local AnnounceTime = 10

RegisterNetEvent('annonce:sendAnnounceMessage')
AddEventHandler('annonce:sendAnnounceMessage', function(msg)
	PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)

	local time = 0

    local function setcountdown(x) time = GetGameTimer() + x*1000 end
    local function getcountdown() return math.floor((time-GetGameTimer())/1000) end
    
    setcountdown(AnnounceTime)

    while getcountdown() > 0 do
        Citizen.Wait(1)
		local scaleform = Initialize("mp_big_message_freemode", msg)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end
end)

-- Scaleform:
function Initialize(scaleform, msg)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~c~~r~ANNONCE") -- Titre de l'annonce
    PushScaleformMovieFunctionParameterString(msg) -- Message de l'annonce
	PopScaleformMovieFunctionVoid()
    return scaleform
end