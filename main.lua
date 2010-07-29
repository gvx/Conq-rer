require("padding.lua")
function love.load()
    math.randomseed( os.time() )
    love.graphics.setBackgroundColor(188, 213, 232)
    love.graphics.setLine(2, "smooth")
    bg = love.graphics.newImage("gfx/bg.png")
    map = love.graphics.newImage("gfx/map.png")
    compass = love.graphics.newImage("gfx/compass.png")
    arrows = love.graphics.newImage("gfx/arrows.png")
    troops = {
        love.graphics.newImage("gfx/hat.png"),
        love.graphics.newImage("gfx/cavalry.png"),
        love.graphics.newImage("gfx/cannon.png"),
    }
    
    ui = {
        lines = love.graphics.newImage("gfx/UI/lines.png"),
        bubbletop = love.graphics.newImage("gfx/UI/bubbletop.png"),
        bubblebg = love.graphics.newImage("gfx/UI/bubblebg.png"),
        bubblebottom = love.graphics.newImage("gfx/UI/bubblebottom.png"),
        speech = love.graphics.newImage("gfx/UI/speechbubble.png"),
        crown = love.graphics.newImage("gfx/UI/crown.png"),
        troop = love.graphics.newImage("gfx/UI/troop.png")
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
    msgtimer = 0
    
    
    msgs = {}
    require("countries.lua")
    require("players.lua")
    require("utils.lua")
    divide()
    addMsg("Press the left button to select a region. Right button to see region information.")
end

function love.update(dt)

    if msgtimer > 0 then
        msgtimer = msgtimer -dt
    end
    
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
    
    drawSelected(selected)
    drawNeighbours(selected)
    
    love.graphics.setColor(30,30,30)
    love.graphics.setColorMode("modulate")
    for n=1,#players do
        for k,m in ipairs(players[n].regions) do
            local v = countries[m]
            if v.troops > 0 then
                love.graphics.setColor(players[n].color.r,players[n].color.g,players[n].color.b, 200)
                local force = troops[x >= 10 and 3 or x >= 5 and 2 or 1]
                love.graphics.setColorMode("replace")
                love.graphics.draw(force, v.center.x+8, v.center.y-8, 0, 1, 1, 13,13)
                love.graphics.setColorMode("modulate")
                love.graphics.draw(force, v.center.x+8, v.center.y-8, 0, 1, 1, 13,13)
            end
        end
    end
    if love.mouse.isDown("r") and hovering ~= "nothing" then
        drawCountryInfo(hovering)
    end
    
    drawMsgs()
    
    if debugging then
        drawDebugInformation()
    end
    
    
end

function love.keypressed(key, uni)
    if key == "escape" then
        love.event.push("q")
    elseif key == "f11" then
        local _success = love.graphics.toggleFullscreen()
        if not _success then
            addMsg("Couldn't toggle fullscreen. Sorry!")
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
    elseif key == "tab" then
        debugging = not debugging
    end
end

function love.mousepressed(x,y, button)
    if button == "l" then
        if x > 988 and x < 1004 and y > 9 and y < 22 then
            msgview = not msgview
        end
        selected = getSelectedRegion(x,y)
    end
end
