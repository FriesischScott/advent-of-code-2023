input = readlines("03/input.txt")

function issymbol(c::Char)
    return !isdigit(c) && c != '.'
end

function hassymbol(s::String)
    return any([issymbol(c) for c in s])
end

function sum_engine_parts(schematic::Vector{String})
    sum = 0
    n, m = length(schematic), length(schematic[1])

    for line in 1:n
        numbers = findall(r"[0-9]+", input[line])
        for n in numbers
            a = n[1]
            b = n[end]
            # left
            if a > 1 && issymbol(schematic[line][a-1])
                sum += parse(Int, schematic[line][n])
                continue
            end
            # right
            if b < m && issymbol(schematic[line][b+1])
                sum += parse(Int, schematic[line][n])
                continue
            end
            candidates = (a > 1 ? a - 1 : a):(b < m ? b + 1 : b)
            # above
            if line > 1 && hassymbol(schematic[line-1][candidates])
                sum += parse(Int, schematic[line][n])
                continue
            end
            # below
            if line < m && hassymbol(schematic[line+1][candidates])
                sum += parse(Int, schematic[line][n])
                continue
            end
        end
    end

    return sum
end

function sum_gear_ratios(schematic::Vector{String})
    sum = 0
    n, m = length(schematic), length(schematic[1])

    for line in 1:n
        gears = findall([c == '*' for c in input[line]])

        for g in gears
            # same line
            adjacent_numbers = String[]
            numbers = findall(r"[0-9]+", input[line])

            for n in numbers
                if n[end] + 1 == g || n[1] - 1 == g
                    push!(adjacent_numbers, schematic[line][n])
                end
            end

            # above and below
            if line != 1
                n_above = findall(r"[0-9]+", input[line-1])
                filter!(n -> any([n[1] - 1, n..., n[end] + 1] .== g), n_above)
                append!(adjacent_numbers, map(n -> schematic[line-1][n], n_above))
            end

            if line != m
                n_below = findall(r"[0-9]+", input[line+1])
                filter!(n -> any([n[1] - 1, n..., n[end] + 1] .== g), n_below)
                append!(adjacent_numbers, map(n -> schematic[line+1][n], n_below))
            end

            if length(adjacent_numbers) == 2
                sum += prod(parse.(Int, adjacent_numbers))
            end
        end
    end

    return sum
end

println("Sum of engine parts: $(sum_engine_parts(input))")
println("Sum of gear ratios: $(sum_gear_ratios(input))")
