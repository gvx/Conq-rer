players = {
    {
        name = "Stein the Spineless",
        regions = {},
        troops = 40,
        color = {r=236, g=87,b=99}
    },
    {
        name = "Fafnir the Flatulent",
        regions = {},
        troops = 40,
        color = {r=87,g=198,b=236}
    }
}

function divide()
    local randint = math.random
    local t = {}
    for i=1, #countries do
        table.insert(t,i)
        countries[i].troops = randint(1,10)
    end
    
    local n = 1
    while #t > 0 do
        local i = randint(#t)
        table.insert(players[n].regions, t[i])
        table.remove(t,i)
        n = n % #players + 1
    end
end
