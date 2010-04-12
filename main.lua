function love.load()
    love.graphics.setBackgroundColor(188, 213, 232)
    love.graphics.setLine(2, "smooth")
    map = love.graphics.newImage("gfx/map.png")
    world = love.physics.newWorld(1024, 640)
    hovering = "nothing"
    
    countries = {
        {
            name = "Alaska",
            center = {x=141 , y=80 },
            neighbours = {2,3,32}
        },
        {
            name = "Northwest Territory",
            center = {x=203 , y=80 },
            neighbours = {1,3,4,6}
        },
        {
            name = "Alberta",
            center = {x=205 , y=124 },
            neighbours = {1,2,4,7}
        },
        {
            name = "Ontario",
            center = {x=252 , y=130 },
            neighbours = {2,3,7,8,5,6}
        },
        {
            name = "Quebec",
            center = {x= 300, y=132 },
            neighbours = {4,8,6}
        },
        {
            name = "Greenland",
            center = {x=350 , y=60 },
            neighbours = {2,4,5,15}
        },
        {
            name = "Western United States",
            center = {x=205 , y=180 },
            neighbours = {3,4,8,9}
        },
        {
            name = "Eastern United States",
            center = {x=255 , y=195 },
            neighbours = {9,7,4,5}
        },
        {
            name = "Central America",
            center = {x=207 , y=225 },
            neighbours = {7,8,10}
        },
        {
            name = "Venezuela",
            center = {x=267 , y=286 },
            neighbours = {9,11,12}
        },
        {
            name = "Peru",
            center = {x=242 , y=323 },
            neighbours = {10,12,13}
        },
        {
            name = "Brazil",
            center = {x=322 , y=336 },
            neighbours = {10,11,13,14,23}
        },
        {
            name = "Bolivia",
            center = {x=285 , y=355 },
            neighbours = {11,12,14}
        },
        {
            name = "Argentina",
            center = {x=280 , y=415 },
            neighbours = {13,12}
        },
        {
            name = "Iceland",
            center = {x=460 , y=107 },
            neighbours = {6,16,17}
        },
        {
            name = "Scandinavia",
            center = {x=512 , y=108 },
            neighbours = {15,17,18,19}
        },
        {
            name = "Great Britain",
            center = {x=453 , y=173 },
            neighbours = {15,16,18,20}
        },
        {
            name = "Northern Europe",
            center = {x=510 , y=175 },
            neighbours = {16,17,19,20,21}
        },
        {
            name = "Ukraine",
            center = {x=580 , y=140 },
            neighbours = {29,34,38,16,18,21}
        },
        {
            name = "France",
            center = {x=470 , y=210 },
            neighbours = {17,18,21,22}
        },
        {
            name = "Southern Europe",
            center = {x=520 , y=215 },
            neighbours = {18,19,20,38,23}
        },
        {
            name = "Spain",
            center = {x=455 , y=245 },
            neighbours = {20,23}
        },
        {
            name = "North Africa",
            center = {x=477 , y=320 },
            neighbours = {12,21,22,24,25,26}
        },
        {
            name = "Egypt",
            center = {x=540 , y=292 },
            neighbours = {23,25,38}
        },
        {
            name = "East Africa",
            center = {x=575 , y=340 },
            neighbours = {23,24,26,27,28}
        },
        {
            name = "Congo",
            center = {x=545 , y=380 },
            neighbours = {23,25,27}
        },
        {
            name = "South Africa",
            center = {x= 545, y=445 },
            neighbours = {25,26,28}
        },
        {
            name = "Madagascar",
            center = {x=613 , y=451 },
            neighbours = {25,27}
        },
        {
            name = "Ural",
            center = {x=650 , y=127 },
            neighbours = {19,34,35,30}
        },
        {
            name = "Siberia",
            center = {x=688 , y=66 },
            neighbours = {29,31,33,35,36}
        },
        {
            name = "Yakutsk",
            center = {x=745 , y=75 },
            neighbours = {30,32,33}
        },
        {
            name = "Kamchatka",
            center = {x=800 , y=83 },
            neighbours = {31,33,36,1, 37}
        },
        {
            name = "Irkutsk",
            center = {x=735 , y=144 },
            neighbours = {30,31,32,36}
        },
        {
            name = "Afghanistan",
            center = {x=640 , y=200 },
            neighbours = {19,29,35,38,39}
        },
        {
            name = "China",
            center = {x=727 , y=233 },
            neighbours = {29,30,33,34,36,39,40}
        },
        {
            name = "Mongolia",
            center = {x=745 , y=185 },
            neighbours = {37,30,32,33,35}
        },
        {
            name = "Japan",
            center = {x=822 , y=190 },
            neighbours = {32,36}
        },
        {
            name = "Middle East",
            center = {x=594 , y=262 },
            neighbours = {19,21,24,25,34,39}
        },
        {
            name = "India",
            center = {x=684 , y=270 },
            neighbours = {34,35,38,40}
        },
        {
            name = "Siam",
            center = {x=744 , y=291 },
            neighbours = {35,39,41}
        },
        {
            name = "Indonesia",
            center = {x=769 , y=371 },
            neighbours = {40,42,43}
        },
        {
            name = "New Guinea",
            center = {x=831 , y=353 },
            neighbours = {40,43,44}
        },
        {
            name = "Western Australia",
            center = {x=790 , y= 445 },
            neighbours = {41,42,44}
        },
        {
            name = "Eastern Australia",
            center = {x=840 , y=422 },
            neighbours = {42,43}
        }
    }
    
    polygons = {
        {174, 51, 171, 90, 185, 127, 153,100, 114, 111, 122, 50},
        {175, 57, 280, 39, 294,64, 261,95, 172,89},
        {180,91, 188,140, 239,141, 242,93},
        {243,95, 240,141, 262,141, 285,161, 287,121, 260,97},
        {287,154, 299,85, 348,123, 322,162},
        {345,109, 303,43, 388,7, 395,66},
        {182,142, 187,198, 225,209, 251,175, 252,142},
        {225,209, 279,226, 315,163, 281,164, 254,143, 254,176},
        {188,200, 204,238, 242,277, 252,234, 234,214},
        {250, 250, 330, 283, 267, 305, 245, 294},
        {242,294, 236,318, 251,337, 265,326, 257,319, 265,307},
        {257,319, 267,307, 331,284, 381,312, 331,403, 306,339},
        {264,325, 247,345, 320,378, 305,339},
        {320,380, 327,403, 293,463, 312,487, 265,474, 272, 358},
        {445,85, 485,85, 485, 114, 445, 117},
        {490, 100, 515,140, 555,111, 555,55},
        {450,120, 480,175, 420,185},
        {507,140, 548,146, 547,180, 498,195, 485,179},
        {557,65, 555,111, 548,146, 556,206, 614,221, 607, 156, 640, 143, 637,61}, --19
        {485,179, 498,195, 495,221, 463, 216, 455,195},
        {498,195, 495,221, 503,247, 540,250, 555,208, 549,181},
        {484,220, 473,258, 441,249, 440,217},
        {464,260, 520,252, 513,293, 550,310, 550,336, 520,362, 472,354, 447,325},
        {521,265, 579,272, 585,303, 557,302, 550,310, 513,293},
        {557,302, 552,339, 582,361, 571,395, 580,420, 597,404, 628,336, 585,303},
        {552,339, 509,377, 565,407, 582,361},
        {526,388, 565,407, 571,395, 580,420, 605,404, 572,474, 538,484, 521,425},
        {642,404, 620,465, 602,463, 611,425},
        {639,42, 643,143, 687,175, 699,151, 680,131, 687,118}, 
        {650,51, 687,118, 680,131, 718,173, 712,125, 732,124, 734,38, 698,19},
        {734,38, 734,100, 785,76, 793,36},
        {785,76, 761,90, 803,168, 797,97, 830,130, 864,64, 794,40},
        {761,90, 734,100, 732,124, 712,125, 716,152, 760,152, 767,135, 789,148},
        {607, 156, 641,144, 687,175, 680,214, 651,228, 632,221, 611,184},--
        {680,214, 696,149, 735,196, 786,204, 795,235, 775,268, 696,235, 694,218},
        {735,196, 803,203, 799,168, 767,135, 760,152, 716,152, 718,173},
        {823,132, 823,174, 806,206, 847,184, 845,136, 822,133 },
        {651,228, 552,220, 549,247, 580,250, 580,272, 624,331, 661,290},
        {651,228, 658,266, 698,334, 732,253, 696,236, 693,219, 680,215},
        {734,253, 774,269, 778,307, 755,325, 724,275},
        {730,342, 765,394, 801,396, 809,354, 782,329, 760,355 },
        {798,322, 844,325, 869,367, 823,364},
        {823,384, 824,430, 854,430, 854,483, 828,456, 779,473, 774,418},
        {823,384, 824,430, 854,430, 854,483, 878,447, 895,433, 863,376}
    }
    shapes = {}
    bodies = {}
    
    for i=1, #polygons do
        bodies[i] = love.physics.newBody(world, 0,0,0,0)
        shapes[i] = love.physics.newPolygonShape(bodies[i], unpack(polygons[i]))
    end
end

function love.update(dt)
    world:update(dt)
    
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
    end
end
