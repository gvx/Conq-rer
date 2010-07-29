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

function startTurn(n)
	players[n].troops = math.max(math.floor(#players[n].regions / 3), 3)
end

local function lt(a, b)
	return a > b
end
function throwDice(troopsAttacker, troopsDefender)
	local diceAttacker = {}
	for i=1, math.min(troopsAttacker, 3) do
		diceAttacker[i] = math.random(6)
	end
	table.sort(diceAttacker, lt)
	local diceDefender = {}
	for i=1, math.min(troopsDefender, 2) do
		diceDefender[i] = math.random(6)
	end
	table.sort(diceDefender, lt)
	for i=1, math.min(#diceAttacker, #diceDefender) do
		if diceAttacker[i] > diceDefender[i] then
			troopsDefender = troopsDefender - 1
		else
			troopsAttacker = troopsAttacker - 1
		end
	end
	return troopsAttacker, troopsDefender, diceAttacker, diceDefender
end
