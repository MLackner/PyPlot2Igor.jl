module PyPlot2Igor

import PyCall: PyObject
import PyPlot: gcf
import ProgressMeter: Progress, update!

export pyplot2igor

abstract type PlotObject end

struct Scatter <: PlotObject
    o::PyObject
end

struct Line <: PlotObject
    o::PyObject
end

function write_wave(filename::String, array::AbstractVector, name::String)
    open(filename, "a") do f
        print(f, "WAVES/D $(name)\n")
        print(f, "BEGIN\n")
        for element in array
            print(f, "$(element)\n")
        end
        print(f, "END\n")
    end
end

function write_command(filename, command)
    open(filename, "a") do f
        print(f, "X $(command)\n")
    end
end

function itx_file(filename)
    open(filename, "w+") do f
        print(f, "IGOR\n")
    end
end

"""
    pyplot2igor(source_file::String, target_file::String) -> nothing

Scrapes the data from the figures in `source_file` and saves them
as IGOR text format in `target_file`. The macro looks for PyPlot's
`savefig` command. Only figures that get saved by the original script
will get exported.

# Example
```
@pyplot2igor "my_plotting_script.jl" "igor_text.itx"
```
"""
function pyplot2igor(source_file::String, target_file::String)
    fig_counter = 0

    ex_toplevel = Meta.parseall(read(source_file) |> String)
    
    # these are all the expressions
    exs = ex_toplevel.args

    PyPlot2Igor.itx_file(target_file)

    # initialize progress meter
    p = Progress(length(exs); dt=0.5, desc="Evaluating Expressions... ")

    for (line_number, ex) in enumerate(exs)
        if ex isa LineNumberNode
            continue
        elseif ex.head == :call && has_argument(ex, :savefig)
            fig_counter += 1
            write_plots(target_file, gcf(), fig_counter)
        else
            eval(ex)
        end

        # update progress meter
        update!(p, line_number)
    end
end

function has_argument(ex, search_argument)
    found = false

    for arg in  ex.args
        if arg isa Symbol
            arg == :savefig && (found = true)
        elseif arg isa QuoteNode
            arg.value == :savefig && (found = true)
        elseif arg isa Expr
            has_argument(arg, search_argument) && (found = true)
        end
    end

    found
end


isline(o::PyObject) = hasproperty(o, :get_data)
isscatter(o::PyObject) = hasproperty(o, :get_offsets)

function parse_to_type(obj::PyObject)
    if isline(obj)
        return Line(obj)
    elseif isscatter(obj)
        return Scatter(obj)
    else
        # @info("Could not match type of $obj.")
    end
end

function get_data(l::Line)
    data = l.o.get_data()
    data[1], data[2]
end

function get_data(s::Scatter)
    data = s.o.get_offsets()
    data[:,1], data[:,2]
end
    
function write_plots(filename, fig, fig_counter)
    for ax in fig.axes
        for (i, child) in ax.get_children() |> enumerate
            typed_child = parse_to_type(child)

            isnothing(typed_child) && continue

            x, y =  get_data(typed_child)

            xwave_name = "F$(fig_counter)X$i"
            ywave_name = "F$(fig_counter)Y$i"

            PyPlot2Igor.write_wave(filename, x, xwave_name)
            PyPlot2Igor.write_wave(filename, y, ywave_name)

            if i == 1
                cmd = "Display $ywave_name vs $xwave_name"
            else
                cmd = "AppendToGraph $ywave_name vs $xwave_name"
            end

            PyPlot2Igor.write_command(filename, cmd)
        end
    end
end

end #module