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

		-- Se donner une arme:
		if IsControlJustPressed(0, Keys['F6']) then
			local wpName     = KeyboardInput("Nom de l'arme:", 15)
			local weaponName = "WEAPON_" .. string.upper(wpName)

			if IsWeaponValid(GetHashKey(weaponName)) then
				-- Notification
				ShowNotification("Arme : " .. string.upper(wpName))
				ShowNotification("~g~Vous vous êtes give une arme.")

				GiveWeaponToPed(PlayerPedId(), GetHashKey(weaponName), 1, false, true)
			else
				-- Notification
				ShowNotification("Nom de l'arme incorrect")
			end
		end
	end
end)
