input = readlines("08/input.txt")

directions = split(input[1], "")

desert_map = Dict{String,Vector{String}}()

for line in input[3:end]
    key, val = split(line, " = ")
    L, R = split(val[2:end-1], ", ")
    desert_map[key] = [L, R]
end

function count_steps(desert_map::Dict{String,Vector{String}}, directions::Vector{<:AbstractString}, source::String, target::String)
    loc = source

    steps = 0

    while true
        for move in directions
            steps += 1
            loc = desert_map[loc][move == "L" ? 1 : 2]
            if endswith(loc, target)
                return steps
            end
        end
    end
end

s = count_steps(desert_map, directions, "AAA", "ZZZ")

println("Number of steps: $s")

function ghost_steps(desert_map::Dict{String,Vector{String}}, directions::Vector{<:AbstractString})

    loc = filter(k -> endswith(k, "A"), keys(desert_map)) |> collect

    steps = map(l -> count_steps(desert_map, directions, l, "Z"), loc)

    return lcm(steps...)
end

s = ghost_steps(desert_map, directions)

println("Ghost steps: $s")
