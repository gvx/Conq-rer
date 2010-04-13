require("padding.lua")
function love.load()
    math.randomseed( os.time() )
    love.graphics.setBackgroundColor(188, 213, 232)
    love.graphics.setLine(2, "smooth")
    bg = love.graphics.newImage("gfx/bg.png")
    map = love.graphics.newImage("gfx/map.png")
    compass = love.graphics.newImage("gfx/compass.png")
    arrows = love.graphics.newImage("gfx/arrows.png")
    
    ui = {
        lines = love.graphics.newImage("gfx/UI/lines.png"),
        bubbletop = love.graphics.newImage("gfx/UI/bubbletop.png"),
        bubblebg = love.graphics.newImage("gfx/UI/bubblebg.png"),
        bubblebottom = love.graphics.newImage("gfx/UI/bubblebottom.png"),
    }
    
    fonts = {
        normal = {
            normal = love.graphics.newFont("fonts/AurulentSans-Regular.otf", 14)
        },
        bold = {
            normal = love.graphics.newFont("fonts/AurulentSans-Bold.otf", 14)
        },
        italic = {
            normal = love.graphics.newFont("fonts/AurulentSans-Italic.otf", 12)
        },
        bolditalic = {
            normal = love.graphics.newFont("fonts/AurulentSans-BoldItalic.otf", 12)
        }
    }
    
    
    world = love.physics.newWorld(1024, 640)
    hovering = "nothing"
    selected = 0
    msgview = false
    
    
    msgs = {}
    require("countries.lua")
    require("players.lua")
    require("utils.lua")
    divide(players)
    addMsg("Your troops in Afghanistan have been defeated by Stein the Spineless")
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
    love.graphics.setFont(fonts.normal.normal)
    love.graphics.setColorMode("replace")
    love.graphics.setColor(50,50,50, 200)
    love.graphics.draw(bg, 0,0)
    love.graphics.draw(map, 0,0)
    love.graphics.draw(compass, 651,372)
    love.graphics.draw(arrows, 0,0)
    
    if selected ~= 0 then
        love.graphics.setColorMode("modulate")
        love.graphics.setColor(50,50,50, 100)
        love.graphics.draw(countries[selected].image, countries[selected].draw.x, countries[selected].draw.y)
        love.graphics.setColor(230,230,230, 100)
        for i=1, #countries[selected].neighbours do
            local neighbour = countries[countries[selected].neighbours[i]]
            love.graphics.draw(neighbour.image, neighbour.draw.x, neighbour.draw.y)
        end
    end
    
    for i,v in ipairs(countries) do
        if v.troops > 0 then
            love.graphics.setColorMode("modulate")
            love.graphics.print(v.troops, v.center.x, v.center.y)
            love.graphics.setColorMode("replace")
        end
    end
    if selected ~= 0 then
        drawCountryInfo(selected)
    end
    
    drawMsgs()
    
    love.graphics.setColorMode("modulate")
    love.graphics.setColor(50,50,50)
    love.graphics.print("Mouse X/Y: "..love.mouse.getX().."/"..love.mouse.getY(), 10, 50)
    if hovering ~= "nothing" then
        love.graphics.print("Hovering over "..countries[hovering].name.." ("..hovering..")", 10, 65)
    else
        love.graphics.print("Hovering over nothing", 10, 65)
    end
    if selected == 0 then
        love.graphics.print("Nothing is selected", 10, 80)
    else
        love.graphics.print(countries[selected].name.." is selected", 10, 80)
    end
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 95)
    
    
end

function love.keypressed(key, uni)
    if key == "escape" then
        love.event.push("q")
    elseif key == "f11" then
        local _success = love.graphics.toggleFullscreen()
        if not _success then
            print("Couldn't toggle fullscreen. Sorry!")
        end
    elseif key == "n" then
        addMsg("This is another message. It's quite formidable, really.")
    elseif key == "b" then
        for i=1,#players do
            local regions = ""
            for n=1, #players[i].regions do
                regions = regions..players[i].regions[n].." "
            end
            addMsg(players[i].name.."'s regions: "..regions)
        end
    end
end

function love.mousepressed(x,y, button)
    if button == "l" then
        if x > 988 and x < 1004 and y > 9 and y < 22 then
            msgview = not msgview
        end
        selected = 0
        for i=1, #countries do
            if shapes[i]:testPoint(x, y) then
                selected = i
            end
        end
        
    end
end
