using LinearAlgebra

input = readlines("11/input.txt")

space = hcat(map(line -> split(line, ""), input)...) |> permutedims

function shortest_paths(space::AbstractMatrix, expansion::Int)
    rows = map(eachrow(space)) do row
        if all(row .== ".")
            return 1
        else
            return 0
        end
    end

    rows = findall(r -> r == 1, rows)

    cols = map(eachcol(space)) do col
        if all(col .== ".")
            return 1
        else
            return 0
        end
    end

    cols = findall(c -> c == 1, cols)

    galaxies = findall(f -> f == "#", space)

    s = 0
    for i in 1:length(galaxies)
        for j in i+1:length(galaxies)
            gi = [Tuple(galaxies[i])...]
            gj = [Tuple(galaxies[j])...]

            x = [gi[1], gj[1]]
            y = [gi[2], gj[2]]

            sort!(x)
            sort!(y)

            distance = (x[2] - x[1]) + (y[2] - y[1])

            r = sum([r in x[1]:x[2] for r in rows])
            c = sum([c in y[1]:y[2] for c in cols])

            distance += r * expansion - r
            distance += c * expansion - c

            s += distance
        end
    end

    return s
end

paths = shortest_paths(space, 2)

println("Shortest paths (Expansion * 2): $paths")

paths = shortest_paths(space, 1_000_000)

println("Shortest paths (Expansion * 1000000): $paths")
