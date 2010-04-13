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

function divide(p)
    local randint = math.random
    local t = {}
    for i=1, #countries do
        table.insert(t,i)
    end
    
    
    local before = ""
    for _,v in ipairs(t) do
        before = before..v.." "
    end
    print("Before: "..before)
    
    local n = 1
    local nump = #p
    for i=1, #countries do
        local c = math.random(1, #t)
        table.insert(players[n].regions, c)
        table.remove(t, c)
        
        local after = ""
        for _,v in ipairs(t) do
            after = after..v.." "
        end
        print("After: "..after)
        
        if n < nump then
            n=n+1
        else
            n=1
        end
    end 
end
