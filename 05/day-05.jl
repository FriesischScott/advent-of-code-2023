input = readlines("05/input.txt")

seeds = parse.(Int, split(split(input[1], "seeds: ")[2], " "))

function build_map(lines::Vector{String})
    m = map(lines) do line
        numbers = parse.(Int, split(line, " "))
        return [numbers[2], numbers[1], numbers[3] - 1]
    end
    return m
end

function build_map(input::Vector{String}, start::String)
    first_line = findfirst(s -> s == start, input) + 1
    last_line = findfirst(isempty, input[first_line:end])
    if isnothing(last_line)
        last_line = length(input)
    else
        last_line = last_line + first_line - 2
    end

    return build_map(input[first_line:last_line])
end

function lookup(d::Vector{Vector{Int64}}, key::Int)
    for m in d
        source = m[1]
        target = m[2]
        len = m[3]

        if key in source:source+len
            s = key - source
            return target + s
        end
    end
    return key
end

seed_to_soil = build_map(input, "seed-to-soil map:")
soil_to_fertilizer = build_map(input, "soil-to-fertilizer map:")
fertilizer_to_water = build_map(input, "fertilizer-to-water map:")
water_to_light = build_map(input, "water-to-light map:")
light_to_temperature = build_map(input, "light-to-temperature map:")
temperature_to_humidity = build_map(input, "temperature-to-humidity map:")
humidity_to_location = build_map(input, "humidity-to-location map:")

locations = map(seeds) do seed
    soil = lookup(seed_to_soil, seed)
    fertilizer = lookup(soil_to_fertilizer, soil)
    water = lookup(fertilizer_to_water, fertilizer)
    light = lookup(water_to_light, water)
    temperature = lookup(light_to_temperature, light)
    humidity = lookup(temperature_to_humidity, temperature)
    location = lookup(humidity_to_location, humidity)
end

println("Minimal location: $(minimum(locations))")

seeds = [seeds[i]:seeds[i]+seeds[i+1]-1 for i in 1:2:length(seeds)]

minimal_location = Inf
for seed_range in seeds
    for seed in seed_range

        soil = lookup(seed_to_soil, seed)
        fertilizer = lookup(soil_to_fertilizer, soil)
        water = lookup(fertilizer_to_water, fertilizer)
        light = lookup(water_to_light, water)
        temperature = lookup(light_to_temperature, light)
        humidity = lookup(temperature_to_humidity, temperature)
        location = lookup(humidity_to_location, humidity)
        if location < minimal_location
            global minimal_location = location
        end
    end
end

println("Minimal location for seed ranges: $minimal_location")
