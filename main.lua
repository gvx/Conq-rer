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
    
    
    world = love.physics.newWorld(0, 0, 1024, 640)
    hovering = "nothing"
    selected = 0
    msgview = false
    msgtimer = 0
    current_player = 1
    state = 'place' -- 'place', 'attack' or 'move'
	using_troops = 0
    
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
                    break
                end
            end
        elseif mousex < 897 then
            for i=15, #polygons do
                if shapes[i]:testPoint(mousex, mousey) then
                    hovering = i
                    break
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
            local x = v.troops
            if x > 0 then
                love.graphics.setColor(players[n].color.r,players[n].color.g,players[n].color.b, 200)
                local force = troops[x >= 10 and 3 or x >= 5 and 2 or 1]
                love.graphics.setColorMode("replace")
                love.graphics.draw(force, v.center.x+8, v.center.y-8, 0, 1, 1, 13,13)
                love.graphics.setColorMode("modulate")
                love.graphics.draw(force, v.center.x+8, v.center.y-8, 0, 1, 1, 13,13)
            end
        end
    end
    if --[[love.mouse.isDown("r") and]] hovering ~= "nothing" then
        drawCountryInfo(hovering)
    end
    
    drawMsgs()
    
    if debugging then
        drawDebugInformation()
    end
    
	love.graphics.setColor(30,30,30)
	love.graphics.setFont(fonts.bold.normal)
    love.graphics.print("It's "..players[current_player].name.."'s turn", 10, 590)
	local text
	if state == 'place' then
		text = players[current_player].troops..' units left to place.'
	elseif state == 'attack' then
		text = 'Attack the enemy.'
	elseif state == 'move' then
		text = 'Move your troops.'
	end
    love.graphics.print(text, 10, 610)
    love.graphics.print(using_troops > 0 and using_troops or 1, 500, 610)
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
	elseif key >= '0' and key <= '9' then
		using_troops = using_troops * 10 + tonumber(key)
	elseif key == 'backspace' then
		using_troops = math.floor(using_troops / 10)
    end
end

function areNeighbours(index1, index2)
    local c = countries[index1].neighbours
    for i=1,#c do
        if c[i] == index2 then
            return true
        end
    end
end

function love.mousepressed(x,y, button)
    if button == "l" then
        if x > 988 and x < 1004 and y > 9 and y < 22 then
            msgview = not msgview
        end
        local sel_new = getSelectedRegion(x,y)
        if sel_new > 0 and selected > 0 and countries[selected].owner == current_player and areNeighbours(selected, sel_new) then
            if state == 'attack' then
                if countries[sel_new].owner ~= current_player and countries[selected].troops > 1 then
					local using = using_troops > 0 and using_troops or 1
					if using >= countries[selected].troops then
						using = countries[selected].troops - 1
					end
                    --attack!
                    local att, def = throwDice(using, countries[sel_new].troops) -- change this to letting the players choose
					if def == 0 then
						for i,country in ipairs(players[countries[sel_new].owner].regions) do
							if country == sel_new then
								table.remove(players[countries[sel_new].owner].regions, i)
								break
							end
						end
						table.insert(players[current_player].regions, sel_new)
						countries[sel_new].owner = current_player
						countries[sel_new].troops = att
						countries[selected].troops = countries[selected].troops - using
						using_troops = 0
					else
						countries[selected].troops = countries[selected].troops - using + att
						using_troops = att > 1 and att or 0
						countries[sel_new].troops = def
					end
                end
            elseif state == 'move' then
                if countries[sel_new].owner == current_player then
                    -- move some troops
                    if countries[selected].troops > 1 then
                        countries[selected].troops = countries[selected].troops - 1
                        countries[sel_new].troops = countries[sel_new].troops + 1
                        -- let the player choose
                    end
                end
            end
        else
            selected = sel_new
        end
		if state == 'place' then
			local c = countries[selected]
			if c and c.owner == current_player then
				local p = players[current_player]
				local using = using_troops > 0 and using_troops or 1
				using_troops = 0
				if using > p.troops then
					using = p.troops
				end
				p.troops = p.troops - using
				c.troops = c.troops + using
				local prev_player = current_player
				current_player = current_player % #players + 1
				while players[current_player].troops < 1 do
					current_player = current_player % #players + 1
					if current_player == prev_player then
						state = 'attack'
						break
					end
				end
			end
		end
    end
end
