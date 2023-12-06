input = readlines("04/input.txt")

input = map(i -> split(i, ": ")[2], input)

function parse_numbers(in::AbstractString)
    return parse.(Int, split(in, " "; keepempty=false))
end

function scratchcard_points(card::AbstractString)
    numbers = winning_numbers(card)
    if numbers == 0
        return 0
    end
    return 2^(numbers - 1)
end

function winning_numbers(card::AbstractString)
    numbers, winners = split(card, " | ")

    numbers = parse_numbers(numbers)
    winners = parse_numbers(winners)

    return sum([n ∈ winners for n in numbers])
end

function more_scratch_cards(cards::Vector{<:AbstractString})
    copies = ones(length(cards))

    for (i, card) in enumerate(cards)
        winners = winning_numbers(card)
        if winners == 0
            continue
        end
        next_cards = i+1:(i + winners < length(cards) ? i + winners : length(cards))
        copies[next_cards] .+= copies[i]
    end
    return Int(sum(copies))
end

total_points = sum(scratchcard_points.(input))

println("Total points: $total_points")

println("Total scratch cards: $(more_scratch_cards(input))")
