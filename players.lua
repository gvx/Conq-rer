players = {
    {
        name = "Stein the Spineless",
        regions = {},
        troops = 40
    },
    {
        name = "Fafnir the Flatulent",
        regions = {},
        troops = 40
    }
}

function divide()
    local randint = math.random
    local t = {}
    for i=1, #countries do
        table.insert(t,i)
    end
    
    local n = 1
    while #t > 0 do
        local i = randint(#t)
        table.insert(players[n].regions, t[i])
        table.remove(t,i)
        if n < #players then
            n = n+1
        else
            n=1
        end
    end
end
