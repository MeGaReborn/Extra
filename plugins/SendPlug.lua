--begin
local function run(msg, matches)
  if is_sudo(msg) then
	if matches[1]:lower() == "send" and matches[2] and matches[3] then
		local send_file = "./"..matches[2].."/"..matches[3]
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 1, nil, send_file, '@BanG_TeaM :D')
	end
	if matches[1]:lower() == "send" and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 1, nil, plug, '@BanG_TeaM :D')
    end
  end
end

return {
  patterns = {
  "^[!/#]([Ss][Ee][Nn][Dd]) (.*) (.*)$",
  "^[!/#]([Ss][Ee][Nn][Dd]) (.*)$"
  },
  run = run
}

--end by #@To0fan#