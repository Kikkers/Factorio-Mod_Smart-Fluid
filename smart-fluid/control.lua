require "util"
require "defines"

game.oninit(function()
	glob.allTanks = {}
	glob.allPumps = {}
	glob.lastTickHeld = {}
	glob.expectedSensorUnits = 900
end)

game.onload(function()
	if glob.allTanks == nil then glob.allTanks = {} end
	if glob.allPumps == nil then glob.allPumps = {} end
	if glob.lastTickHeld == nil then glob.lastTickHeld = {} end
	glob.expectedSensorUnits = 900
end)

game.onevent(defines.events.ontick, function(event)
	-- go over all smart tanks
	for k,v in pairs(glob.allTanks) do
		if v.valid then
			local pumpPart = GetEntityAt(v.position, "smart-tank-pipe")
			local inv = v.getinventory(1)
			local storedfluid = pumpPart.getliquid()
			
			if storedfluid ~= nil then
			
				-- check that is good to have, but will likely never occur (inv is cleared when no liquid is present)
				for name,val in pairs(inv.getcontents()) do
					if name ~= "fluid-content" and name ~= "fluid-temperature" then
						game.player.print("Warning: Irrelevant items have been inserted into Smart Tank. They will be removed to ensure proper sensor operation.")
						inv.clear()
						break
					end
				end
			
				--modify fluid representation if changed
				local amountdiff = math.floor((storedfluid.amount * 100) + 0.5) - inv.getitemcount("fluid-content")
				if amountdiff > 0 then 
					inv.insert{name = "fluid-content", count = amountdiff}
				elseif amountdiff < 0 then 
					inv.remove{name = "fluid-content", count = -amountdiff}
				end
				
				local tempdiff = math.floor((storedfluid.temperature * 10) + 0.5) - inv.getitemcount("fluid-temperature")
				if tempdiff > 0 then 
					inv.insert{name = "fluid-temperature", count = tempdiff}
				elseif tempdiff < 0 then 
					inv.remove{name = "fluid-temperature", count = -tempdiff}
				end
				
			else
				inv.clear()
			end
		end
	end
	-- go over all smart pumps
	for k,v in pairs(glob.allPumps) do
		if v.valid then
			local pumpPart = GetEntityAt(v.position, "smart-pump-pipe")
			local chestPart = GetEntityAt(v.position, "smart-pump-chest")
			
			-- rotation changes
			if pumpPart.direction ~= v.direction then
				--replace with rotated pump
				local isactive = pumpPart.active
				pumpPart.destroy()
				pumpPart = game.createentity{name = "smart-pump-pipe", position = v.position, direction = v.direction}
				pumpPart.active = isactive
			end
			
			
			-- test changes
			local currentActive
			if v.heldentity == nil then
				local elapsedSinceHeld = event.tick - glob.lastTickHeld[v]
				if elapsedSinceHeld > 10 then -- slight delay for the time the actuator (inserter) does not hold an item, but is still active
					currentActive = false
				else
					currentActive = true
				end
				
				-- notify if inserters remove chest content
				local storedSensorUnits = chestPart.getinventory(1).getitemcount("smart-pump-sensor-unit")
				if storedSensorUnits ~= glob.expectedSensorUnits then
					game.player.print("Warning: Smart Pump Actuator Units have been removed from Smart Pump. This will clutter your save with invisible objects and should be prevented by YOU.")
					chestPart.insert{name = "smart-pump-sensor-unit", count = (glob.expectedSensorUnits - storedSensorUnits)}
				end
				
			elseif v.energy == 0 then
				currentActive = false
			else
				glob.lastTickHeld[v] = event.tick
				currentActive = true
			end
			
			
			-- modify if changed
			if currentActive ~= pumpPart.active then
				pumpPart.active = currentActive
				--if pumpPart.active then game.player.print("smart pump active") else game.player.print("smart pump inactive") end
			end
			
		end
	end
end)

game.onevent(defines.events.onbuiltentity, function(event)
	if event.createdentity.name == "smart-pump-pipe" then
		
		local pumpPart = event.createdentity
		local actuator = game.createentity{name = "smart-pump-actuator", position = pumpPart.position, direction = pumpPart.direction}
		local chestPart = game.createentity{name = "smart-pump-chest", position = pumpPart.position}
		pumpPart.destroy(); -- recreate to get sorting order good (so you can see the blue arrow)
		pumpPart = game.createentity{name = "smart-pump-pipe", position = actuator.position, direction = actuator.direction}
		
		glob.lastTickHeld[actuator] = -10
		glob.allPumps[actuator] = actuator
	
		chestPart.insert{name = "smart-pump-sensor-unit", count = glob.expectedSensorUnits}
		chestPart.operable = false
		chestPart.destructible = false
		actuator.destructible = false
		pumpPart.active = false
		
	elseif event.createdentity.name == "smart-tank" then
		
		local tank = event.createdentity
		
		glob.allTanks[tank] = tank
		
		local pumpPart = game.createentity{name = "smart-tank-pipe", position = tank.position}
		
		pumpPart.destructible = false
		tank.operable = false
		
	end
end)

game.onevent(defines.events.onpreplayermineditem, function(event)
	if event.entity.name == "smart-tank" then
		CleanupSmartTank(event.entity)
	elseif event.entity.name == "smart-pump-pipe" then
		CleanupSmartPumpActuator(event.entity)
	elseif event.entity.name == "smart-pump-actuator" then
		CleanupSmartPump(event.entity)
	end
end)

game.onevent(defines.events.onentitydied, function(event)
	if event.entity.name == "smart-tank" then
		CleanupSmartTank(event.entity)
	elseif event.entity.name == "smart-pump-pipe" then
		CleanupSmartPumpActuator(event.entity)
	elseif event.entity.name == "smart-pump-actuator" then
		CleanupSmartPump(event.entity)
	end
end)

function CleanupSmartPumpActuator(pumpPart)
	local chestPart = GetEntityAt(pumpPart.position, "smart-pump-chest")
	if chestPart ~= nil then
		local actuator = GetEntityAt(pumpPart.position, "smart-pump-actuator")
		actuator.heldstack = nil
		actuator.destroy()
		chestPart.destroy()
		
		glob.lastTickHeld[actuator] = nil
		glob.allPumps[actuator] = nil
	end
end

function CleanupSmartPump(actuator)
	local chestPart = GetEntityAt(actuator.position, "smart-pump-chest")
	if chestPart ~= nil then
		actuator.heldstack = nil
		local pumpPart = GetEntityAt(actuator.position, "smart-pump-pipe")
		pumpPart.destroy()
		chestPart.destroy()
		
		glob.lastTickHeld[actuator] = nil
		glob.allPumps[actuator] = nil
	end
end

function CleanupSmartTank(entity)
	entity.getinventory(1).clear()
	local pipe = GetEntityAt(entity.position, "smart-tank-pipe")
	pipe.destroy()
	glob.allTanks[entity] = nil
end

function GetEntityAt(pos, entityname)
	local t = game.findentitiesfiltered{area = {{pos.x - 0.1, pos.y - 0.1}, {pos.x + 0.1, pos.y + 0.1}}, name = entityname}
	for k,v in pairs(t) do
		return v
	end
	return nil
end