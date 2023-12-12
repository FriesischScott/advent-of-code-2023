using DelimitedFiles

input = readlines("10/input.txt")

pipes = hcat(map(line -> split(line, ""), input)...) |> permutedims

function identify_start(pipes::AbstractMatrix, i::Int, j::Int)
    n, m = size(pipes)
    if j > 1 && j < m && pipes[i, j-1] in ["-", "L", "F"] && pipes[i, j+1] in ["-", "J", "7"]
        return "-"
    elseif i > 1 && i < 1 && pipes[i-1, j] in ["|", "7", "F"] && pipes[i+1, j] in ["|", "L", "J"]
        return "|"
    elseif i > 1 && j < m && pipes[i-1, j] in ["F", "7", "|"] && pipes[i, j+1] in ["-", "J", "7"]
        return "L"
    elseif i > 1 && j > 1 && pipes[i-1, j] in ["F", "7", "|"] && pipes[i, j-1] in ["-", "L", "F"]
        return "J"
    elseif i < n && j < m && pipes[i+1, j] in ["L", "J", "|"] && pipes[i, j+1] in ["-", "J", "7"]
        return "F"
    elseif i < n && j > 1 && pipes[i+1, j] in ["L", "J", "|"] && pipes[i, j-1] in ["-", "F", "L"]
        return "7"
    end
end

function find_loop(pipes::AbstractMatrix)
    i, j = [Tuple(findfirst(f -> f == "S", pipes))...]

    last_i = 0
    last_j = 0

    loop = Matrix{Int}(undef, 2, 0)
    loop = hcat(loop, [i, j])

    current = identify_start(pipes, i, j)

    while true
        if current == "-"
            if last_j != j + 1 && pipes[i, j+1] in ["-", "7", "J", "S"]
                last_i, last_j = i, j
                j += 1
            elseif last_j != j - 1 && pipes[i, j-1] in ["-", "L", "F", "S"]
                last_i, last_j = i, j
                j -= 1
            end
        elseif current == "|"
            if last_i != i - 1 && pipes[i-1, j] in ["|", "7", "F", "S"]
                last_i, last_j = i, j
                i -= 1
            elseif last_i != i + 1 && pipes[i+1, j] in ["|", "L", "J", "S"]
                last_i, last_j = i, j
                i += 1
            end
        elseif current == "L"
            if last_i != i - 1 && pipes[i-1, j] in ["|", "7", "F", "S"]
                last_i, last_j = i, j
                i -= 1
            elseif last_j != j + 1 && pipes[i, j+1] in ["-", "7", "J", "S"]
                last_i, last_j = i, j
                j += 1
            end
        elseif current == "J"
            if last_i != i - 1 && pipes[i-1, j] in ["|", "7", "F", "S"]
                last_i, last_j = i, j
                i -= 1
            elseif last_j != j - 1 && pipes[i, j-1] in ["-", "L", "F", "S"]
                last_i, last_j = i, j
                j -= 1
            end
        elseif current == "F"
            if last_j != j + 1 && pipes[i, j+1] in ["-", "7", "J", "S"]
                last_i, last_j = i, j
                j += 1
            elseif last_i != i + 1 && pipes[i+1, j] in ["|", "L", "J", "S"]
                last_i, last_j = i, j
                i += 1
            end
        elseif current == "7"
            if last_j != j - 1 && pipes[i, j-1] in ["-", "F", "L", "S"]
                last_i, last_j = i, j
                j -= 1
            elseif last_i != i + 1 && pipes[i+1, j] in ["|", "L", "J", "S"]
                last_i, last_j = i, j
                i += 1
            end
        end
        loop = hcat(loop, [i, j])
        current = pipes[i, j]
        if current == "S"
            break
        end
    end
    return loop
end

loop = find_loop(pipes)

println("Furthest distance: $(Int(ceil((size(loop, 2)-1)/2)))")

"""
    Shoelace formula
    https://en.wikipedia.org/wiki/Shoelace_formula
"""
function area(loop::Matrix{Int})
    A = 0.0
    for i = 1:size(loop, 2)-1
        A += loop[2, i] * loop[1, i+1] - loop[2, i+1] * loop[1, i]
    end
    A *= 0.5
    return A
end

# Picks theorem
enclosed_tiles = (2 * area(loop) + 2 - (size(loop, 2) - 1)) / 2 |> Int

println("Enclosed tiles: $enclosed_tiles")
