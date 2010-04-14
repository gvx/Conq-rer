function addMsg(str)
    local msg = {when=os.date("%H:%M"), text=str}
    table.insert(msgs, msg)
end

function drawMsgs()
    if #msgs > 0 then
        if not msgview then
            love.graphics.setColor(0,0,0, 175)
            love.graphics.rectangle("fill", 0,0, 1024,30 )
            local h = fonts.normal.normal:getHeight(msgs[#msgs].text)/2
            love.graphics.setColor(230,230,230, 255)
            love.graphics.print(msgs[#msgs].when, 20, 13+h)
            love.graphics.printf(msgs[#msgs].text, 200, 13+h, 624, "center")
            love.graphics.draw(ui.lines, 988, 7)
            --love.graphics.draw(ui.speech, 966, 7)
        else
            love.graphics.setColor(0,0,0, 175)
            love.graphics.rectangle("fill", 0,0, 1024,640 )
            love.graphics.setColor(230,230,230, 255)
            for i=0, #msgs-1 do
                local num = #msgs
                local h = fonts.normal.normal:getHeight(msgs[num-i].text)/2
                
                love.graphics.print(msgs[num-i].when, 20, 35+(20+h)*i)
                love.graphics.printf(msgs[num-i].text, 200, 35+(20+h)*i, 624, "center")
                --love.graphics.line(20,40+(20+h)*i, 1004, 40+(20+h)*i)
            end
            love.graphics.draw(ui.lines, 988, 7)
        end
    end
end

function drawCountryInfo(id)
    local name  = countries[id].name
    local owner = ""
    for n=1, #players do
        local r = indexOfValue(players[n].regions, id)
        if r ~= 0 then
            owner = players[n].name
        end
    end
    
    local namelength = fonts.bold.normal:getWidth(name)
    local x = countries[id].center.x
    local y = countries[id].center.y
    local nameheight = fonts.bold.normal:getHeight(name)
    local bottom = 0
    local ownerheight = fonts.normal.normal:getHeight(owner)
    local ownerlength = fonts.normal.normal:getWidth(owner)
    local roof = math.ceil
    local lines = roof(namelength/224)+roof(ownerlength/196)+2
    
    love.graphics.setColorMode("replace")
    love.graphics.draw(ui.bubbletop, x-122, y+15)
    for i=1, lines do
        love.graphics.draw(ui.bubblebg, x-122, y+31+13*(i-1))
        bottom = y+31+13*(i)
    end
    love.graphics.draw(ui.bubblebottom, x-122, bottom)
    
    
    love.graphics.setFont(fonts.bold.normal)
    love.graphics.printf(name, x-114, y+31+nameheight/2, 224, "center")
    
    love.graphics.setFont(fonts.normal.normal)
    love.graphics.printf(owner, x-90, y+36+nameheight/2+ownerheight, 190, "left")
    love.graphics.printf(countries[id].troops, x-90,y+41+nameheight/2+ownerheight*2, 190, "left")
    love.graphics.draw(ui.crown,x-106, y+42+nameheight/2)
    love.graphics.draw(ui.troop, x-106, y+41+nameheight+ownerheight*0.85)
    
    
    love.graphics.setColorMode("modulate")
end

function drawSelected(id)
    if id == 0 then return end
    love.graphics.setColorMode("modulate")
    love.graphics.setColor(50,50,50, 100)
    love.graphics.draw(countries[id].image, countries[id].draw.x, countries[id].draw.y)
    love.graphics.setColor(230,230,230, 100)
end

function drawNeighbours(id)
    if id == 0 then return end
    for i=1, #countries[id].neighbours do
        local neighbour = countries[countries[id].neighbours[i]]
        love.graphics.draw(neighbour.image, neighbour.draw.x, neighbour.draw.y)
    end
end

function getSelectedRegion(x,y)
    for i=1, #countries do
        if shapes[i]:testPoint(x, y) then
            return i
        end
    end
    return 0
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function indexOfValue(t, v)
    local index = 0
    for i=1, #t do
        if t[i] == v then
            index = t[i]
            return index
        end
    end
    return index
end
