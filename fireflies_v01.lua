-----------------------------------------------------------------
-- Fireflies model
--Version 0.1
--Authors: Miguel Carrilho & Tigabu Dagne
----------------------------------------------
--PARAMETERS
---------------------------------------------

FIREFLIES = 1
LIGHTED = 2
--OFF = 3
EMPTY = 4

nFIREFLIES=0
nLIGHTED=0
--nOFF=0
nEMPTY=0
SEED=8
rand = Random{seed=SEED}  --

--------------------------------------------------------------
-- MODEL (1. space, 2. behavior, and 3. time)
--------------------------------------------------------------

-------------
--# SPACE #
-------------

world = CellularSpace{
	xdim = 30,
	ydim = 30
}

world:createNeighborhood{
	strategy = "3x3",
	self = false
}

forEachCell(world, function(cell)
	if rand:number() > 0.6 then  --  0.2  0.25  0.3  0.35  0.5
		cell.cover = FIREFLIES
		nFIREFLIES = nFIREFLIES+1
	else
		cell.cover = EMPTY
		nEMPTY = nEMPTY+1
	end
end)

--forEachCell(world, function(cell)
--	if rand1:number() > 0.4 then 
--		cell.prob = true
--	else
--		cell.prob = false
--	end
--end)
----------------
--# BEHAVIOR #
----------------

world:sample().cover = LIGHTED
	--nFIREFLIES=nFIREFLIES-1
	--nLIGHTED=nLIGHTED+1
update = function(cs)
	forEachCell(cs, function(cell)
		if cell.past.cover == FIREFLIES then
			isLIGHTED=false
			forEachNeighbor(cell, function(cell, neighbor)
				if neighbor.past.cover == LIGHTED then
					cell.cover = LIGHTED
					isLIGHTED=true
				end
			end)
			if isLIGHTED==true then
				nFIREFLIES=nFIREFLIES-1
				nLIGHTED=nLIGHTED+1
			end
		elseif cell.past.cover == LIGHTED then
			--cell.cover = BURNING2
			
		--elseif cell.past.cover == BURNING2 then
			cell.cover = FIREFLIES
			nLIGHTED =nLIGHTED-1
			nFIREFLIES=nFIREFLIES+1
		end
	end)
	--print ( nforest, nburning, nburned) --divide it by 4 /4
end

-----------
--# TIME #
-----------

t = Timer{
	Event{action = function(e)
		world:synchronize()
		update(world)
		world:notify()
		print(e:getTime())
	end}
}

--------------------------------------------------------------
-- SIMULATION
--------------------------------------------------------------

legend = Legend {
	grouping = "uniquevalue",
	colorBar = {
		{value = FIREFLIES, text="fireflies", color = "white"},
		{value = LIGHTED, text="lighted", color = "yellow"},
		--{value = BURNING2, color = "yellow"},
		--{value = BURNED, color = "brown"},
		{value = EMPTY, text="empty", color = "black"}
	}
}

Observer{
	subject = world,
	attributes = {"cover"},
	legends = {legend}
}

--world:notify()  -- needed just if you want to see the initial state (before simulation runs)

t:execute(20) --100

print ( nFIREFLIES, nLIGHTED)
