# PyPlot2Igor

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://MLackner.github.io/PyPlot2Igor.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://MLackner.github.io/PyPlot2Igor.jl/dev)
[![Build Status](https://github.com/MLackner/PyPlot2Igor.jl/workflows/CI/badge.svg)](https://github.com/MLackner/PyPlot2Igor.jl/actions)

Export the data from the figures in a Julia script to an IGOR itx file. This works for figures generated with the `PyPlot` package. Only data from figures that are explicitly saved in the script are exported.
## Installation

In the Julia REPL hit `]` to enter the Julia package manager. Then add `PyPlot2Igor`:
```
(@v1.x) pkg> add https://github.com/MLackner/PyPlot2Igor.jl
```

Wait for the package to install and hit backspace to return to the `julia>` prompt.

## Usage

Change the directory to the project folder corresponding to your plotting script (This is the folder containing the `Project.toml` file). Activate this project:

```
(@v1.x) pkg> activate .
```

Activate the `PyPlot2Igor` package:
```
julia> using PyPlot2Igor
```

Convert the figures in the script to an IGOR text file:
```
julia> pyplot2igor("./scripts/my_plot.jl", "./igor-text-file.itx")
```

## Known Issues

* Only the data from figures that are saved in the script via `savefig(filename)` or `<myfig>.savefig(filename)` are exported. Make sure these lines aren't commented out.

* It is only possible to export line data (plotted for example by the `plot` function) and scatter plots (`scatter` function).