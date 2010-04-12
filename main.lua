require("padding.lua")
function love.load()
    love.graphics.setBackgroundColor(188, 213, 232)
    love.graphics.setLine(2, "smooth")
    bg = love.graphics.newImage("gfx/bg.png")
    map = love.graphics.newImage("gfx/map.png")
    compass = love.graphics.newImage("gfx/compass.png")
    arrows = love.graphics.newImage("gfx/arrows.png")
    world = love.physics.newWorld(1024, 640)
    hovering = "nothing"
    selected = 0
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
    love.graphics.draw(bg, 0,0)
    love.graphics.draw(map, 0,0)
    love.graphics.draw(compass, 651,372)
    love.graphics.draw(arrows, 0,0)
    
    --[[for i=1, #countries do
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
    end]]--
    
    love.graphics.setColorMode("modulate")
    love.graphics.setColor(50,50,50, 100)
    if selected ~= 0 then
        love.graphics.draw(countries[selected].image, countries[selected].draw.x, countries[selected].draw.y)
        love.graphics.setColor(230,230,230, 100)
        for i=1, #countries[selected].neighbours do
            local neighbour = countries[countries[selected].neighbours[i]]
            love.graphics.draw(neighbour.image, neighbour.draw.x, neighbour.draw.y)
        end
    end
    
    love.graphics.setColor(50,50,50)
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

function love.mousepressed(x,y, button)
    if button == "l" then
        selected = 0
        for i=1, #countries do
            if shapes[i]:testPoint(x, y) then
                selected = i
            end
        end
    end
end
