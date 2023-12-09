input = readlines("07/input.txt")

struct Hand
    cards::String
    bid::Int

    function Hand(in::String)
        cards, bid = split(in, " ")
        new(cards, parse(Int, bid))
    end
end

hands = Hand.(input)

faces = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

card_values = Dict(faces .=> 1:length(faces))

function type(hand::Hand)
    counts = count.(faces, hand.cards)

    if 5 in counts
        return 7
    elseif 4 in counts
        return 6
    elseif 3 in counts
        if 2 in counts
            return 5
        else
            return 4
        end
    elseif 2 in counts
        if count(i -> i == 2, counts) == 2
            return 3
        else
            return 2
        end
    end
    return 1
end

function lt(a::Hand, b::Hand)
    type_a = type(a)
    type_b = type(b)

    if type_a != type_b
        return type_a < type_b
    else
        for (card_a, card_b) in zip(split(a.cards, ""), split(b.cards, ""))
            if card_a == card_b
                continue
            else
                return card_values[card_a] < card_values[card_b]
            end
        end
    end
end

hands = sort!(hands; lt=lt)

winnings = getproperty.(hands, :bid) .* [1:length(hands);] |> sum

println("Total winnings: $winnings")

faces = ["J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"]

card_values = Dict(faces .=> 1:length(faces))

function type_joker(hand::Hand)
    counts = count.(faces, hand.cards)

    if 5 in counts
        return 7
    elseif 4 in counts
        if counts[1] == 1 || counts[1] == 4 # one joker and four of a kind or four jokers
            return 7
        else
            return 6
        end
    elseif 3 in counts
        if counts[1] == 2 # two jokers and three of a kind
            return 7
        end
        if counts[1] == 1 # one joker and three of a kind
            return 6
        end
        if counts[1] == 3 && 2 in counts
            return 7
        end
        if counts[1] == 3
            return 6
        end
        if 2 in counts
            return 5
        else
            return 4
        end
    elseif 2 in counts
        if count(i -> i == 2, counts) == 2
            if counts[1] == 1 # two pairs and one joker
                return 5
            end
            if counts[1] == 2 # one pair and two jokers
                return 6
            end
            return 3
        else
            if counts[1] == 1 || counts[1] == 2 # two jokers or one pair and one joker
                return 4
            end
            return 2
        end
    end
    if counts[1] == 1 # one joker
        return 2
    else
        return 1
    end
end

function lt_joker(a::Hand, b::Hand)
    type_a = type_joker(a)
    type_b = type_joker(b)

    if type_a != type_b
        return type_a < type_b
    else
        for (card_a, card_b) in zip(split(a.cards, ""), split(b.cards, ""))
            if card_a == card_b
                continue
            else
                return card_values[card_a] < card_values[card_b]
            end
        end
    end
end

hands = sort!(hands; lt=lt_joker)

winnings = getproperty.(hands, :bid) .* [1:length(hands);] |> sum

println("Total winnings with jokers: $winnings")
