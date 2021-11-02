#=
This is a multiline comment
with two lines =#

using PyPlot

x = Int[]
for i in -3:3
    push!(x, i)
end

y1 = x.^2 
y2 = x.^1

scatter(x, y1)
plot(x, y2)

filename = tempname()
savefig(filename)

fig2 = figure()
ax = subplot(111)

ax.plot(x, -y1)
ax.scatter(x, 5 .* rand(length(x)))

fig2.savefig(filename)
