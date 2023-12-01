input = readlines("01/input.txt")

function calibration(in::String)
    digits = filter(isdigit, in)
    return parse(Int, digits[[1, end]])
end

calibration_sum = sum(map(calibration, input))

println("Calibration: $calibration_sum")

function parsedigits(in::String)
    no_doubles = replace(in, "oneight" => 18, "twone" => 21, "fiveight" => 58, "sevenine" => "79", "eightwo" => 82, "nineight" => 98)
    return replace(no_doubles, "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9)
end

parsed_input = map(parsedigits, input)

calibration_sum = sum(map(calibration, parsed_input))

println("Calibration after parsing: $calibration_sum")
