local spawnedFarms = 0
local farmPlants = {}
local isPickingUp = false

CreateThread(function()
	while true do
		Wait(700)
		local coords = GetEntityCoords(PlayerPedId())

		if #(coords - Config.CircleZones.FarmField.coords) < 80 then
			SpawnFarmPlants()
		end
	end
end)

CreateThread(function()
	while true do
		local Sleep = 500

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #farmPlants, 1 do
			if #(coords - GetEntityCoords(farmPlants[i])) < 1.5 then
				nearbyObject, nearbyID = farmPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
			Sleep = 0
			if IsControlPressed(0, 38) then -- E
                if CurrentAction == 'farm_pickupprompt' then
                    OpenWashedMenu(CurrentActionData.zone)
                end

                CurrentAction = nil
            end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				if Config.RequiredPolice <= 0 or ((GlobalState.jobnumbers and GlobalState.jobnumbers['police']) or 0) >= Config.RequiredPolice then 
					isPickingUp = true
					if Config.RandomItems then

						FreezeEntityPosition(playerPed, true)
						if not HasAnimDictLoaded("creatures@rottweiler@tricks@") then
						RequestAnimDict("creatures@rottweiler@tricks@") 
						end
						while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do 
						Wait(0)
						end
						TaskPlayAnim(playerPed, 'creatures@rottweiler@tricks@', 'petting_franklin', 1.0, -1.0,-1,1,0,0, 0,0)
						Wait(4000)
						ClearPedTasks(playerPed)

		
						ESX.Game.DeleteObject(nearbyObject)

						table.remove(farmPlants, nearbyID)
						spawnedFarms = spawnedFarms - 1

						TriggerServerEvent(Config.Eventname..':pickedUpItem')
						FreezeEntityPosition(PlayerPedId(), false)
						
						isPickingUp = false
					else
						ESX.TriggerServerCallback(Config.Eventname..':canPickUp', function(canPickUp)
							if canPickUp then

								FreezeEntityPosition(playerPed, true)
								if not HasAnimDictLoaded("creatures@rottweiler@tricks@") then
								RequestAnimDict("creatures@rottweiler@tricks@") 
								end
								while not HasAnimDictLoaded("creatures@rottweiler@tricks@") do 
								Wait(0)
								end
								TaskPlayAnim(playerPed, 'creatures@rottweiler@tricks@', 'petting_franklin', 1.0, -1.0,-1,1,0,0, 0,0)
								Wait(4000)
								ClearPedTasks(playerPed)
				
								ESX.Game.DeleteObject(nearbyObject)

								table.remove(farmPlants, nearbyID)
								spawnedFarms = spawnedFarms - 1

								TriggerServerEvent(Config.Eventname..':pickedUpItem')
								FreezeEntityPosition(PlayerPedId(), false)
							else
								--ESX.ShowNotification(_U('farm_inventoryfull'))
							end

							isPickingUp = false
						end, Config.Item)
					end
				else
					ESX.ShowNotification('There are not enough police officers on duty!')
				end
			end
		end
	Wait(Sleep)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(farmPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnFarmPlants()
	while spawnedFarms < 25 do
		Wait(0)
		local farmCoords = GenerateFarmCoords()

		ESX.Game.SpawnLocalObject(Config.Prop, farmCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			SetEntityCollision(obj, false, false)
			table.insert(farmPlants, obj)
			spawnedFarms = spawnedFarms + 1
		end)
	end
end

function ValidateFarmCoord(plantCoord)
	if spawnedFarms > 0 then
		local validate = true

		for k, v in pairs(farmPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		if #(plantCoord - Config.CircleZones.FarmField.coords) > 80 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateFarmCoords()
	while true do
		Wait(0)

		local farmCoordX, farmCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-40, 40)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-40, 40)

		farmCoordX = Config.CircleZones.FarmField.coords.x + modX
		farmCoordY = Config.CircleZones.FarmField.coords.y + modY

		local coordZ = GetCoordZ(farmCoordX, farmCoordY)
		local coord = vector3(farmCoordX, farmCoordY, coordZ)

		if ValidateFarmCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = Config.Heights

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return Config.Returner
end

function CreateBlipCircle(coords, text, radius, color, sprite)
	
	if Config.Blipumrandung then
		local blip = AddBlipForRadius(coords, radius)
		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, 1)
		SetBlipAlpha (blip, 128)
	end

	blip = AddBlipForCoord(coords)
	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

CreateThread(function()
	if Config.Blip then
		for k,zone in pairs(Config.CircleZones) do
			CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
		end
	end
end)
