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
--flashCicle=10

nFIREFLIES=0
nLIGHTED=0
--nOFF=0
nEMPTY=0
SEED=8
rand = Random{seed=SEED} 
flashCicle = random:integer(10) -- from 0 to 10 -----------------------  do we need to assign this to each cell???????????

--------------------------------------------------------------
-- MODEL (1. space, 2. behavior, and 3. time)
--------------------------------------------------------------

-------------
--# SPACE #
-------------

world = CellularSpace{
	xdim = 50,--150
	ydim = 50  --100
}

world:createNeighborhood{
	strategy = "moore",
	self = false
}

forEachCell(world, function(cell)
	if rand:number() > 0.6 then  --  0.2  0.25  0.3  0.35  0.5 
		cell.cover = FIREFLIES
		nFIREFLIES = nFIREFLIES+1
	elseif rand:number() > 0.7 then  --this will give us 0.3 of the space with empty cells
		cell.cover = EMPTY
		nEMPTY = nEMPTY+1
	else
		cell.cover = LIGHTED  --this will give us the remainder between 0.6 and 0.7 = 0.1 of lighted fireflies making it random
		nLIGHTED = nLIGHTED+1
	end
end)

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
				flashCicle=flashCicle-1 ---i think that here it will reduce one to the random variable flashCicle
				if flashCicle==0 then  --- and when it is equal to 0 they should flash 
					cell.cover = LIGHTED
					isLIGHTED=true
				else
					cell.cover = FIREFLIES----else they should stay as fireflies
				end
--			forEachNeighbor(cell, function(cell, neighbor)
--				if neighbor.past.cover == LIGHTED then
--					cell.cover = LIGHTED
--					isLIGHTED=true
--				end
--			end)
			if isLIGHTED==true then
				nFIREFLIES=nFIREFLIES-1
				nLIGHTED=nLIGHTED+1
			end
		elseif cell.past.cover == LIGHTED then
			cell.cover = FIREFLIES
			nLIGHTED =nLIGHTED-1
			nFIREFLIES=nFIREFLIES+1
		end
	end)
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
		{value = EMPTY, text="empty", color = "black"}
	}
}

Observer{
	subject = world,
	attributes = {"cover"},
	legends = {legend}
}

world:notify()  -- needed just if you want to see the initial state (before simulation runs)

t:execute(20) --100

print ( nFIREFLIES, nLIGHTED)