TriggerEvent('es:addGroupCommand', 'annonce', 'superadmin', function(source, args, user)
	if not args[1] then
		print("Utilisation: /annonce {annonce}")
		return
	end

	local msg = ""
	for i, v in pairs(args) do
		msg = msg .. " " .. v
	end

	TriggerClientEvent('annonce:sendAnnounceMessage', -1, msg)

end, function(source, args, user)
end, { help = "Faire une annonce", params = {{ name = "name", help = "Annonce à partager" }} })