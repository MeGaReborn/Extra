do

local function run(msg, matches)
if matches[1]=="me" and is_sudo(msg) then 
return  "*Your ID* 》 _"..user.."_\n *Your Rank* 》 _Sudo_"
elseif matches[1]=="me" and is_admin(msg) then 
return  "*Your ID* 》 _"..user.."_\n *Your Rank* 》 _Bot Admin_"
elseif matches[1]=="me" and is_owner(msg) then 
return  "*Your ID* 》 _"..user.."_\n *Your Rank* 》 _Owner_"
elseif matches[1]=="me" and is_mod(msg) then 
return  "*Your ID* 》 _"..user.."_\n *Your Rank* 》 _GP Admin_"
else
return  "*Your ID* 》 _"..user.."_\n *Your Rank* 》 _Member_"
end

end

return {
  patterns = {
    "^[!#/](me)$",
    },
  run = run
}
end


--By @Bibak_BG
-- @BanG_TeaM