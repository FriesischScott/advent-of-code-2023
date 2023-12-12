using Combinatorics

input = readlines("12/input.txt")

function arrangements(line::String)
    springs, groups = split(line, " ")

    springs = split(springs, "")
    groups = parse.(Int, split(groups, ","))

    unknowns = findall(s -> s == "?", springs)

    total_springs = sum(groups)
    certain_springs = count("#", join(springs))

    combs = 0
    for c in combinations(unknowns)
        if certain_springs + length(c) != total_springs
            continue
        end

        test = copy(springs)
        test[c] .= "#"
        replace!(test, "?" => ".")

        matches = eachmatch(r"(#)+", join(test))
        pattern = map(m -> length(m.match), matches)

        if pattern == groups
            combs += 1
        end
    end

    test = copy(springs)
    replace!(test, "?" => ".")

    matches = eachmatch(r"(#)+", join(test))
    pattern = map(m -> length(m.match), matches)

    if pattern == groups
        combs += 1
    end

    return combs
end

arr = sum(map(arrangements, input))

println("Arrangements: $arr")
