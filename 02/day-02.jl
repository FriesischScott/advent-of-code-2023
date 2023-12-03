input = readlines("02/input.txt")

input = map(i -> split(i, ": ")[2], input)

red = 12
green = 13
blue = 14

limits = Dict("red" => 12, "green" => 13, "blue" => 14)

function impossible_draw(draw)
    cubes = split(draw, ", ")
    for c in cubes
        number, color = split(c, " ")
        if parse(Int, number) > limits[color]
            return true
        end
    end
    return false
end

function possible_game(game)
    draws = strip.(split(game, ";"))
    return !any(impossible_draw.(draws))
end

ids = [1:length(input);]

possible_games = possible_game.(input)

sum_of_ids = sum(ids[possible_games])

println("Sum of possible games: $sum_of_ids")

function power(game)
    min_cubes = Dict("red" => 0, "green" => 0, "blue" => 0)

    draws = strip.(split(game, ";"))
    for d in draws
        cubes = split(d, ", ")
        for c in cubes
            number, color = split(c, " ")
            number = parse(Int, number)
            if number > min_cubes[color]
                min_cubes[color] = number
            end
        end
    end
    return min_cubes["red"] * min_cubes["blue"] * min_cubes["green"]
end

println("Sum of powers: $(sum(power.(input)))")
