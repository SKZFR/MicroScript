local Keys = { ['E'] = 38, ['F5'] = 166, ['F6'] = 167 }

-- Chargement d'un modèle:
function LoadModel(modelHash)
	RequestModel(modelHash)
	
	while not HasModelLoaded(modelHash) do
		Citizen.Wait(1)
		RequestModel(modelHash)
	end
end

-- Barre de saisie de texte:
function KeyboardInput(TextEntry, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(1)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

-- Notifications:
function ShowNotification(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, true)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		-- Faire spawn un véhicule:
		if IsControlJustPressed(0, Keys['F5']) then
			local vehName   = KeyboardInput("Nom du véhicule:", 10)
			local modelName = GetDisplayNameFromVehicleModel(vehName)

			if modelName ~= "CARNOTFOUND" then
				if not HasModelLoaded(GetHashKey(vehName)) then
					LoadModel(GetHashKey(vehName))
				end

				if IsPedSittingInAnyVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false)) then
					DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
				end

				local coords  = GetEntityCoords(PlayerPedId(), true)
				local vehicle = CreateVehicle(GetHashKey(vehName), coords, GetEntityHeading(PlayerPedId()), true, false)

				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

				-- Notification:
				ShowNotification('~g~Spawn du véhicule.')
			else
				-- Notification:
				ShowNotification('~r~Nom du véhicule incorrect.')
			end
		end
	end
end)
