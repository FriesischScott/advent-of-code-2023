times = [59, 70, 78, 78]
records = [430, 1218, 1213, 1276]

function beat_race(time::Int, record::Int)
    return sum([acc * (time - acc) for acc in 1:time] .> record)
end

ways_to_win = map((t, r) -> beat_race(t, r), times, records)

println("Product of ways to win: $(prod(ways_to_win))")

println("Ways to win long race: $(beat_race(59707878, 430121812131276))")
