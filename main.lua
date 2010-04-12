function love.load()
    love.graphics.setBackgroundColor(188, 213, 232)
    love.graphics.setLine(2, "smooth")
    map = love.graphics.newImage("gfx/map.png")
    world = love.physics.newWorld(1024, 640)
    hovering = "nothing"
    require("countries.lua")
end

function love.update(dt)
    
    local mousex, mousey = love.mouse.getPosition()
    hovering = "nothing"
    if mousey < 490 and mousey > 5 then
        if mousex < 410 and mousex > 110 then
            for i=1, 14 do
                if shapes[i]:testPoint(mousex, mousey) then
                    hovering = i
                end
            end
        elseif mousex < 897 then
            for i=15, #polygons do
                if shapes[i]:testPoint(mousex, mousey) then
                    hovering = i
                end
            end
        end
    end
end

function love.draw()
    love.graphics.setColorMode("replace")
    love.graphics.setColor(50,50,50, 200)
    love.graphics.draw(map, 117,0)
    
    for i=1, #countries do
        local x1,y1 = countries[i].center.x, countries[i].center.y
        for n,v in ipairs(countries[i].neighbours) do
            local x2, y2 = countries[v].center.x, countries[v].center.y
            if i == hovering then
                love.graphics.setColor(50,50,50,225)
            else
                love.graphics.setColor(50,50,50,10)
            end
            love.graphics.line(x1,y1,x2,y2)
        end
    end
    
    love.graphics.setColor(50,50,50)
    love.graphics.setColorMode("modulate")
    love.graphics.print("Mouse X/Y: "..love.mouse.getX().."/"..love.mouse.getY(), 10, 15)
    if hovering ~= "nothing" then
        love.graphics.print("Hovering over "..countries[hovering].name.." ("..hovering..")", 10, 30)
    else
        love.graphics.print("Hovering over nothing", 10, 30)
    end
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 45)
    
    
end

function love.keypressed(key, uni)
    if key == "escape" then
        love.event.push("q")
    elseif key == "f11" then
        local _success = love.graphics.toggleFullscreen()
        if not _success then
            print("Couldn't toggle fullscreen. Sorry!")
        end
    end
end
