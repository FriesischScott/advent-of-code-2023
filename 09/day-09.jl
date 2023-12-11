input = readlines("09/input.txt")

function extrapolate(series::String)
    numbers = parse.(Int, split(series, " "))
    return numbers[end] + extrapolate(numbers[2:end] .- numbers[1:end-1])
end

function extrapolate_previous(series::String)
    numbers = reverse(parse.(Int, split(series, " ")))
    return numbers[end] + extrapolate(numbers[2:end] .- numbers[1:end-1])
end

function extrapolate(series::Vector{Int})
    if iszero(series)
        return 0
    else
        return series[end] + extrapolate(series[2:end] .- series[1:end-1])
    end
end

extrapolated_sum = mapreduce(extrapolate, +, input)

println("Sum of extrapolated numbers: $extrapolated_sum")

extrapolated_previous_sum = mapreduce(extrapolate_previous, +, input)

println("Sum of extrapolated numbers at the beginning: $extrapolated_previous_sum")
