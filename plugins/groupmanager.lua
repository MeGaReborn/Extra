local function modadd(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
   if not lang then
        return '_You are not bot admin_'
else
     return 'شما مدیر ربات نمیباشید'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id_)] then
if not lang then
   return '_Group is already added_'
else
return 'گروه در لیست گروه های مدیریتی ربات هم اکنون موجود است'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.chat_id_)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      settings = {
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes'
          },
   mutes = {
                  mute_fwd = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_loc = 'no',
                  mute_doc = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.chat_id_)] = msg.chat_id_
      save_data(_config.moderation.data, data)
    if not lang then
  return '*Group has been added*'
else
  return 'گروه با موفقیت به لیست گروه های مدیریتی ربات افزوده شد'
end
end

local function modrem(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
     if not lang then
        return '_You are not bot admin_'
   else
        return 'شما مدیر ربات نمیباشید'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.chat_id_
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return '_Group is not added_'
else
    return 'گروه به لیست گروه های مدیریتی ربات اضافه نشده است'
   end
  end

  data[tostring(msg.chat_id_)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.chat_id_)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '*Group has been removed*'
 else
  return 'گروه با موفیت از لیست گروه های مدیریتی ربات حذف شد'
end
end
local function modlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "_Group is not added_"
 else
    return "گروه به لیست گروه های مدیریتی ربات اضافه نشده است"
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['mods']) == nil then --fix way
  if not lang then
    return "_No_ *moderator* _in this group_"
else
   return "در حال حاضر هیچ مدیری برای گروه انتخاب نشده است"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
if not lang then
    return "_Group is not added_"
else
return "گروه به لیست گروه های مدیریتی ربات اضافه نشده است"
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['owners']) == nil then --fix way
 if not lang then
    return "_No_ *owner* _in this group_"
else
    return "در حال حاضر هیچ مالکی برای گروه انتخاب نشده است"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
if not arg.username then return false end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ ".. check_markdown(data.type_.user_.username_) .." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
  else
     text = "اطلاعات برای [ ".. check_markdown(data.type_.user_.username_) .." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
    if cmd == "whois" then
if data.username_ then
username = '@'..check_markdown(data.username_)
else
if not lang then
username = 'not found'
 else
username = 'ندارد'
  end
end
     if not lang then
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'Info for [ '..data.id_..' ] :\nUserName : '..username..'\nName : '..data.first_name_, 1)
   else
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'اطلاعات برای [ '..data.id_..' ] :\nیوزرنیم : '..username..'\nنام : '..data.first_name_, 1)
      end
   end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not founded_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
    end
  end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "*Link* _Posting Is Already Locked_"
elseif lang then
 return "ارسال لینک در گروه هم اکنون ممنوع است"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Link* _Posting Has Been Locked_"
else
 return "ارسال لینک در گروه ممنوع شد"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "*Link* _Posting Is Not Locked_" 
elseif lang then
return "ارسال لینک در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Link* _Posting Has Been Unlocked_" 
else
return "ارسال لینک در گروه آزاد شد"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "*Tag* _Posting Is Already Locked_"
elseif lang then
 return "ارسال تگ در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tag* _Posting Has Been Locked_"
else
 return "ارسال تگ در گروه ممنوع شد"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "*Tag* _Posting Is Not Locked_" 
elseif lang then
return "ارسال تگ در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Tag* _Posting Has Been Unlocked_" 
else
return "ارسال تگ در گروه آزاد شد"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "*Mention* _Posting Is Already Locked_"
elseif lang then
 return "ارسال فراخوانی افراد هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mention* _Posting Has Been Locked_"
else 
 return "ارسال فراخوانی افراد در گروه ممنوع شد"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "*Mention* _Posting Is Not Locked_" 
elseif lang then
return "ارسال فراخوانی افراد در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Mention* _Posting Has Been Unlocked_" 
else
return "ارسال فراخوانی افراد در گروه آزاد شد"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "*Editing* _Is Already Locked_"
elseif lang then
 return "ویرایش پیام هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Editing* _Has Been Locked_"
else
 return "ویرایش پیام در گروه ممنوع شد"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "*Editing* _Is Not Locked_" 
elseif lang then
return "ویرایش پیام در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Editing* _Has Been Unlocked_" 
else
return "ویرایش پیام در گروه آزاد شد"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "*Spam* _Is Already Locked_"
elseif lang then
 return "ارسال هرزنامه در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Spam* _Has Been Locked_"
else
 return "ارسال هرزنامه در گروه ممنوع شد"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "*Spam* _Posting Is Not Locked_" 
elseif lang then
 return "ارسال هرزنامه در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data)
if not lang then 
return "*Spam* _Posting Has Been Unlocked_" 
else
 return "ارسال هرزنامه در گروه آزاد شد"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
if not lang then
 return "*Flooding* _Is Already Locked_"
elseif lang then
 return "ارسال پیام مکرر در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Flooding* _Has Been Locked_"
else
 return "ارسال پیام مکرر در گروه ممنوع شد"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
if not lang then
return "*Flooding* _Is Not Locked_" 
elseif lang then
return "ارسال پیام مکرر در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Flooding* _Has Been Unlocked_" 
else
return "ارسال پیام مکرر در گروه آزاد شد"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "*Bots* _Protection Is Already Enabled_"
elseif lang then
 return "محافظت از گروه در برابر ربات ها هم اکنون فعال است"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Bots* _Protection Has Been Enabled_"
else
 return "محافظت از گروه در برابر ربات ها فعال شد"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "*Bots* _Protection Is Not Enabled_" 
elseif lang then
return "محافظت از گروه در برابر ربات ها غیر فعال است"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Bots* _Protection Has Been Disabled_" 
else
return "محافظت از گروه در برابر ربات ها غیر فعال شد"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "*Markdown* _Posting Is Already Locked_"
elseif lang then
 return "ارسال پیام های دارای فونت در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Markdown* _Posting Has Been Locked_"
else
 return "ارسال پیام های دارای فونت در گروه ممنوع شد"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "*Markdown* _Posting Is Not Locked_"
elseif lang then
return "ارسال پیام های دارای فونت در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Markdown* _Posting Has Been Unlocked_"
else
return "ارسال پیام های دارای فونت در گروه آزاد شد"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "*Webpage* _Is Already Locked_"
elseif lang then
 return "ارسال صفحات وب در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Webpage* _Has Been Locked_"
else
 return "ارسال صفحات وب در گروه ممنوع شد"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "*Webpage* _Is Not Locked_" 
elseif lang then
return "ارسال صفحات وب در گروه ممنوع نمیباشد"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Webpage* _Has Been Unlocked_" 
else
return "ارسال صفحات وب در گروه آزاد شد"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "شما مدیر گروه نمیباشید"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

local expiretime = redis:hget('expiretime', msg.chat_id_)
    local expire = ''
  if not expiretime then
  expire = expire..'Not SeT'
  else
   local now = tonumber(os.time())
   expire =  expire..math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1
 end

if not lang then
local settings = data[tostring(target)]["settings"] 
 text = "*Group Settings👇*\n_Lock edit_ 》 *"..settings.lock_edit.."*\n_Lock links_ 》 *"..settings.lock_link.."*\n_Lock tags_ 》 *"..settings.lock_tag.."*\n_Lock flood_ 》 *"..settings.flood.."*\n_Lock spam_ 》 *"..settings.lock_spam.."*\n_Lock mention_ 》 *"..settings.lock_mention.."*\n_Lock webpage_ 》 *"..settings.lock_webpage.."*\n_Lock markdown_ 》 *"..settings.lock_markdown.."*\n_Bots protection_ 》 *"..settings.lock_bots.."*\n_Flood sensitivity_ 》 *"..NUM_MSG_MAX.."*\n*____________________*\n*Group Language* 》 *EN*\n*Group Expire* 》 _"..expire.."_"
else
local settings = data[tostring(target)]["settings"] 
 text = "*تنظیمات گروه👇*\n_قفل ویرایش پیام_ 》 *"..settings.lock_edit.."*\n_قفل لینک_ 》 *"..settings.lock_link.."*\n_قفل تگ_ 》 *"..settings.lock_tag.."*\n_قفل پیام مکرر_ 》 *"..settings.flood.."*\n_قفل هرزنامه_ 》 *"..settings.lock_spam.."*\n_قفل فراخوانی_ 》 *"..settings.lock_mention.."*\n_قفل صفحات وب_ 》 *"..settings.lock_webpage.."*\n_قفل فونت_ 》 *"..settings.lock_markdown.."*\n_محافظت در برابر ربات ها_ 》 *"..settings.lock_bots.."*\n_حداکثر پیام مکرر_ 》 *"..NUM_MSG_MAX.."*\n*____________________*\n_زبان سوپرگروه_ 》 *FA*\n*تاریخ انقضای گروه* 》 _"..expire.."_"
end
return text
end
--------Mutes---------
--------Mute all--------------------------
local function mute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "شما مدیر گروه نمیباشید"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "*Mute All* _Is Already Enabled_" 
elseif lang then
return "بیصدا کردن همه فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Enabled_" 
else
return "بیصدا کردن همه فعال شد"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "شما مدیر گروه نمیباشید"
end
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "*Mute All* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن همه غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Disabled_" 
else
return "بیصدا کردن همه غیر فعال شد"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "*Mute Gif* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن تصاویر متحرک فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "*Mute Gif* _Has Been Enabled_"
else
 return "بیصدا کردن تصاویر متحرک فعال شد"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "*Mute Gif* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن تصاویر متحرک غیر فعال بود"
end
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Gif* _Has Been Disabled_" 
else
return "بیصدا کردن تصاویر متحرک غیر فعال شد"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then
if not lang then
 return "*Mute Game* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن بازی های تحت وب فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Game* _Has Been Enabled_"
else
 return "بیصدا کردن بازی های تحت وب فعال شد"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then
if not lang then
return "*Mute Game* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن بازی های تحت وب غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Game* _Has Been Disabled_" 
else
return "بیصدا کردن بازی های تحت وب غیر فعال شد"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then
if not lang then
 return "*Mute Inline* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن کیبورد شیشه ای فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Inline* _Has Been Enabled_"
else
 return "بیصدا کردن کیبورد شیشه ای فعال شد"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then
if not lang then
return "*Mute Inline* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن کیبورد شیشه ای غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Inline* _Has Been Disabled_" 
else
return "بیصدا کردن کیبورد شیشه ای غیر فعال شد"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "*Mute Text* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن متن فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Text* _Has Been Enabled_"
else
 return "بیصدا کردن متن فعال شد"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
if not lang then
return "*Mute Text* _Is Already Disabled_"
elseif lang then
return "بیصدا کردن متن غیر فعال است" 
end
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Text* _Has Been Disabled_" 
else
return "بیصدا کردن متن غیر فعال شد"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
 return "*Mute Photo* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن عکس فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Photo* _Has Been Enabled_"
else
 return "بیصدا کردن عکس فعال شد"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
return "*Mute Photo* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن عکس غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Photo* _Has Been Disabled_" 
else
return "بیصدا کردن عکس غیر فعال شد"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "*Mute Video* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن فیلم فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mute Video* _Has Been Enabled_"
else
 return "بیصدا کردن فیلم فعال شد"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "*Mute Video* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن فیلم غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Video* _Has Been Disabled_" 
else
return "بیصدا کردن فیلم غیر فعال شد"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "*Mute Audio* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن آهنگ فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Audio* _Has Been Enabled_"
else 
return "بیصدا کردن آهنگ فعال شد"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "*Mute Audio* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن آهنک غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Audio* _Has Been Disabled_"
else
return "بیصدا کردن آهنگ غیر فعال شد" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "*Mute Voice* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن صدا فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Voice* _Has Been Enabled_"
else
 return "بیصدا کردن صدا فعال شد"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "*Mute Voice* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن صدا غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Voice* _Has Been Disabled_" 
else
return "بیصدا کردن صدا غیر فعال شد"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "*Mute Sticker* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن برچسب فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Sticker* _Has Been Enabled_"
else
 return "بیصدا کردن برچسب فعال شد"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "*Mute Sticker* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن برچسب غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Sticker* _Has Been Disabled_"
else
return "بیصدا کردن برچسب غیر فعال شد"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "*Mute Contact* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن مخاطب فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Contact* _Has Been Enabled_"
else
 return "بیصدا کردن مخاطب فعال شد"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "*Mute Contact* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن مخاطب غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Contact* _Has Been Disabled_" 
else
return "بیصدا کردن مخاطب غیر فعال شد"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "*Mute Forward* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن نقل قول فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Forward* _Has Been Enabled_"
else
 return "بیصدا کردن نقل قول فعال شد"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "*Mute Forward* _Is Already Disabled_"
elseif lang then
return "بیصدا کردن نقل قول غیر فعال است"
end 
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Forward* _Has Been Disabled_" 
else
return "بیصدا کردن نقل قول غیر فعال شد"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "*Mute Location* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن موقعیت فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "*Mute Location* _Has Been Enabled_"
else
 return "بیصدا کردن موقعیت فعال شد"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "*Mute Location* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن موقعیت غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Location* _Has Been Disabled_" 
else
return "بیصدا کردن موقعیت غیر فعال شد"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "*Mute Document* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن اسناد فعال لست"
end
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Document* _Has Been Enabled_"
else
 return "بیصدا کردن اسناد فعال شد"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "*Mute Document* _Is Already Disabled_" 
elseif lang then
return "بیصدا کردن اسناد غیر فعال است"
end
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Document* _Has Been Disabled_" 
else
return "بیصدا کردن اسناد غیر فعال شد"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "*Mute TgService* _Is Already Enabled_"
elseif lang then
 return "بیصدا کردن خدمات تلگرام فعال است"
end
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute TgService* _Has Been Enabled_"
else
return "بیصدا کردن خدمات تلگرام فعال شد"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نیستید"
end 
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "*Mute TgService* _Is Already Disabled_"
elseif lang then
return "بیصدا کردن خدمات تلگرام غیر فعال است"
end 
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute TgService* _Has Been Disabled_"
else
return "بیصدا کردن خدمات تلگرام غیر فعال شد"
end 
end
end
----------MuteList---------
local function mutes(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"	
else
 return "شما مدیر گروه نیستید"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_all"] then			
data[tostring(target)]["mutes"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_gif"] then			
data[tostring(target)]["mutes"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_text"] then			
data[tostring(target)]["mutes"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_photo"] then			
data[tostring(target)]["mutes"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_video"] then			
data[tostring(target)]["mutes"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_audio"] then			
data[tostring(target)]["mutes"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_voice"] then			
data[tostring(target)]["mutes"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_sticker"] then			
data[tostring(target)]["mutes"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_contact"] then			
data[tostring(target)]["mutes"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_forward"] then			
data[tostring(target)]["mutes"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_location"] then			
data[tostring(target)]["mutes"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_document"] then			
data[tostring(target)]["mutes"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_tgservice"] then			
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_inline"] then			
data[tostring(target)]["mutes"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["mutes"] then		
if not data[tostring(target)]["mutes"]["mute_game"] then			
data[tostring(target)]["mutes"]["mute_game"] = "no"		
end
end

if not lang then
local mutes = data[tostring(target)]["mutes"] 
 text = " *Group Mute List* : \n_Mute all : _ *"..mutes.mute_all.."*\n_Mute gif :_ *"..mutes.mute_gif.."*\n_Mute text :_ *"..mutes.mute_text.."*\n_Mute inline :_ *"..mutes.mute_inline.."*\n_Mute game :_ *"..mutes.mute_game.."*\n_Mute photo :_ *"..mutes.mute_photo.."*\n_Mute video :_ *"..mutes.mute_video.."*\n_Mute audio :_ *"..mutes.mute_audio.."*\n_Mute voice :_ *"..mutes.mute_voice.."*\n_Mute sticker :_ *"..mutes.mute_sticker.."*\n_Mute contact :_ *"..mutes.mute_contact.."*\n_Mute forward :_ *"..mutes.mute_forward.."*\n_Mute location :_ *"..mutes.mute_location.."*\n_Mute document :_ *"..mutes.mute_document.."*\n_Mute TgService :_ *"..mutes.mute_tgservice.."*\n*____________________*\n*Group Language* : *EN*"
else
local mutes = data[tostring(target)]["mutes"] 
 text = " *لیست بیصدا ها* : \n_بیصدا همه : _ *"..mutes.mute_all.."*\n_بیصدا تصاویر متحرک :_ *"..mutes.mute_gif.."*\n_بیصدا متن :_ *"..mutes.mute_text.."*\n_بیصدا کیبورد شیشه ای :_ *"..mutes.mute_inline.."*\n_بیصدا بازی های تحت وب :_ *"..mutes.mute_game.."*\n_بیصدا عکس :_ *"..mutes.mute_photo.."*\n_بیصدا فیلم :_ *"..mutes.mute_video.."*\n_بیصدا آهنگ :_ *"..mutes.mute_audio.."*\n_بیصدا صدا :_ *"..mutes.mute_voice.."*\n_بیصدا برچسب :_ *"..mutes.mute_sticker.."*\n_بیصدا مخاطب :_ *"..mutes.mute_contact.."*\n_بیصدا نقل قول :_ *"..mutes.mute_forward.."*\n_بیصدا موقعیت :_ *"..mutes.mute_location.."*\n_بیصدا اسناد :_ *"..mutes.mute_document.."*\n_بیصدا خدمات تلگرام :_ *"..mutes.mute_tgservice.."*\n*____________________*\n_زبان سوپرگروه_ : *FA*"
end
return text
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
if matches[1] == "id" then
if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   if not lang then
return "*Group ID* 》 _"..chat.."_\n*Your ID* 》 _"..user.."_"
   else
return "*شناسه گروه* 》 _"..chat.."_\n*شناسه شما* 》 _"..user.."_"
   end
end
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="id"})
  end
if matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="id"})
      end
   end
if matches[1] == "pin" and is_owner(msg) then
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
if not lang then
return "*Message Has Been Pinned*"
else
return "پیام سجاق شد"
end
end
if matches[1] == 'unpin' and is_mod(msg) then
tdcli.unpinChannelMessage(msg.chat_id_)
if not lang then
return "*Pin message has been unpinned*"
else
return "پیام سنجاق شده پاک شد"
end
end
if matches[1] == "add" then
return modadd(msg)
end
if matches[1] == "rem" then
return modrem(msg)
end
if matches[1] == "setowner" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "remowner" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "promote" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "demote" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="demote"})
      end
   end

if matches[1] == "lock" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "link" then
return lock_link(msg, data, target)
end
if matches[2] == "tag" then
return lock_tag(msg, data, target)
end
if matches[2] == "mention" then
return lock_mention(msg, data, target)
end
if matches[2] == "edit" then
return lock_edit(msg, data, target)
end
if matches[2] == "spam" then
return lock_spam(msg, data, target)
end
if matches[2] == "flood" then
return lock_flood(msg, data, target)
end
if matches[2] == "bots" then
return lock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return lock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return lock_webpage(msg, data, target)
end
end

if matches[1] == "unlock" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "link" then
return unlock_link(msg, data, target)
end
if matches[2] == "tag" then
return unlock_tag(msg, data, target)
end
if matches[2] == "mention" then
return unlock_mention(msg, data, target)
end
if matches[2] == "edit" then
return unlock_edit(msg, data, target)
end
if matches[2] == "spam" then
return unlock_spam(msg, data, target)
end
if matches[2] == "flood" then
return unlock_flood(msg, data, target)
end
if matches[2] == "bots" then
return unlock_bots(msg, data, target)
end
if matches[2] == "markdown" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "webpage" then
return unlock_webpage(msg, data, target)
end
end
if matches[1] == "mute" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
return mute_all(msg, data, target)
end
if matches[2] == "gif" then
return mute_gif(msg, data, target)
end
if matches[2] == "text" then
return mute_text(msg ,data, target)
end
if matches[2] == "photo" then
return mute_photo(msg ,data, target)
end
if matches[2] == "video" then
return mute_video(msg ,data, target)
end
if matches[2] == "audio" then
return mute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return mute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return mute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return mute_forward(msg ,data, target)
end
if matches[2] == "location" then
return mute_location(msg ,data, target)
end
if matches[2] == "document" then
return mute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return mute_inline(msg ,data, target)
end
if matches[2] == "game" then
return mute_game(msg ,data, target)
end
end

if matches[1] == "unmute" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "all" then
return unmute_all(msg, data, target)
end
if matches[2] == "gif" then
return unmute_gif(msg, data, target)
end
if matches[2] == "text" then
return unmute_text(msg, data, target)
end
if matches[2] == "photo" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "video" then
return unmute_video(msg ,data, target)
end
if matches[2] == "audio" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "voice" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "sticker" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "contact" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "forward" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "location" then
return unmute_location(msg ,data, target)
end
if matches[2] == "document" then
return unmute_document(msg ,data, target)
end
if matches[2] == "tgservice" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "inline" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "game" then
return unmute_game(msg ,data, target)
end
end
if matches[1] == "gpinfo" and is_mod(msg) and gp_type(msg.chat_id_) == "channel" then
local function group_info(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not lang then
ginfo = "*Group Info :*\n_Admin Count :_ *"..data.administrator_count_.."*\n_Member Count :_ *"..data.member_count_.."*\n_Kicked Count :_ *"..data.kicked_count_.."*\n_Group ID :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
elseif lang then
ginfo = "*اطلاعات گروه :*\n_تعداد مدیران :_ *"..data.administrator_count_.."*\n_تعداد اعضا :_ *"..data.member_count_.."*\n_تعداد اعضای حذف شده :_ *"..data.kicked_count_.."*\n_شناسه گروه :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.chat_id_, group_info, {chat_id=msg.chat_id_,msg_id=msg.id_})
end
		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
      if not lang then
			return '_Please send the new group_ *link* _now_'
    else 
         return 'لطفا لینک گروه خود را ارسال کنید'
       end
		end

		if msg.content_.text_ then
   local is_link = msg.content_.text_:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.content_.text_:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.content_.text_
				save_data(_config.moderation.data, data)
            if not lang then
				return "*Newlink* _has been set_"
           else
           return "لینک جدید ذخیره شد"
		 	end
       end
		end
    if matches[1] == 'link' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First set a link for group with using_ /setlink"
     else
        return "اول لینک گروه خود را ذخیره کنید با /setlink"
      end
      end
     if not lang then
       text = "<b>Group Link :</b>\n"..linkgp
     else
      text = "<b>لینک گروه :</b>\n"..linkgp
         end
        return tdcli.sendMessage(chat, msg.id_, 1, text, 1, 'html')
     end
  if matches[1] == "setrules" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "*Group rules* _has been set_"
   else 
  return "قوانین گروه ثبت شد"
   end
  end
  if matches[1] == "rules" then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@BanG_TeaM"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n@Bang_TeaM"
 end
        else
     rules = "*Group Rules :*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "res" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="res"})
  end
if matches[1] == "whois" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'setflood' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "_Wrong number, range is_ *[1-50]*"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'clean' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(chat)]['mods']) == nil then
            if not lang then
					return "_No_ *moderators* _in this group_"
             else
                return "هیچ مدیری برای گروه انتخاب نشده است"
				end
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *moderators* _has been demoted_"
          else
            return "تمام مدیران گروه تنزیل مقام شدند"
			end
         end
			if matches[2] == 'rules' then
				if not data[tostring(chat)]['rules'] then
            if not lang then
					return "_No_ *rules* _available_"
             else
               return "قوانین برای گروه ثبت نشده است"
             end
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Group rules* _has been cleaned_"
          else
            return "قوانین گروه پاک شد"
			end
       end
			if matches[2] == 'about' then
        if gp_type(chat) == "chat" then
				if not data[tostring(chat)]['about'] then
            if not lang then
					return "_No_ *description* _available_"
            else
              return "پیامی مبنی بر درباره گروه ثبت نشده است"
          end
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
             if not lang then
				return "*Group description* _has been cleaned_"
           else
              return "پیام مبنی بر درباره گروه پاک شد"
             end
		   	end
        end
		if matches[1]:lower() == 'clean' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(chat)]['owners']) == nil then
             if not lang then
					return "_No_ *owners* _in this group_"
            else
                return "مالکی برای گروه انتخاب نشده است"
            end
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *owners* _has been demoted_"
           else
            return "تمامی مالکان گروه تنزیل مقام شدند"
          end
			end
     end
if matches[1] == "setname" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "setabout" and matches[2] and is_mod(msg) then
     if gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif gp_type(chat) == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "*Group description* _has been set_"
    else
     return "پیام مبنی بر درباره گروه ثبت شد"
      end
  end
  if matches[1] == "about" and gp_type(chat) == "chat" then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "پیامی مبنی بر درباره گروه ثبت نشده است"
       end
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "settings" then
return group_settings(msg, target)
end
if matches[1] == "mutelist" then
return mutes(msg, target)
end
if matches[1] == "modlist" then
return modlist(msg)
end
if matches[1] == "ownerlist" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "setlang" and is_owner(msg) then
   if matches[2] == "en" then
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 redis:del(hash)
return "_Group Language Set To:_ EN"
  elseif matches[2] == "fa" then
redis:set(hash, true)
return "*زبان گروه تنظیم شد به : فارسی*"
end
end

if matches[1] == "help" and is_mod(msg) then
if not lang then
text = [[
*Bot Commands:*

*!setowner* `[username|id|reply]` 
_Set Group Owner(Multi Owner)_

*!remowner* `[username|id|reply]` 
 _Remove User From Owner List_

*!promote* `[username|id|reply]` 
_Promote User To Group Admin_

*!demote* `[username|id|reply]` 
_Demote User From Group Admins List_

*!setflood* `[1-50]`
_Set Flooding Number_

*!silent* `[username|id|reply]` 
_Silent User From Group_

*!unsilent* `[username|id|reply]` 
_Unsilent User From Group_

*!kick* `[username|id|reply]` 
_Kick User From Group_

*!ban* `[username|id|reply]` 
_Ban User From Group_

*!unban* `[username|id|reply]` 
_UnBan User From Group_

*!res* `[username]`
_Show User ID_

*!id* `[reply]`
_Show User ID_

*!whois* `[id]`
_Show User's Username And Name_

*!lock* `[link | tag | edit | webpage | bots | spam | flood | markdown | mention]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unlock* `[link | tag | edit | webpage | bots | spam | flood | markdown | mention]`
_If This Actions Unlock, Bot Not Delete Them_

*!mute* `[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

*!unmute* `[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

*!set*`[rules | name | photo | link | about]`
_Bot Set Them_

*!clean* `[bans | mods | bots | rules | about | silentlist]`   
_Bot Clean Them_

*!pin* `[reply]`
_Pin Your Message_

*!unpin* 
_Unpin Pinned Message_

*!settings*
_Show Group Settings_

*!mutelist*
_Show Mutes List_

*!silentlist*
_Show Silented Users List_

*!banlist*
_Show Banned Users List_

*!ownerlist*
_Show Group Owners List_ 

*!modlist* 
_Show Group Moderators List_

*!rules*
_Show Group Rules_

*!about*
_Show Group Description_

*!id*
_Show Your And Chat ID_

*!gpinfo*
_Show Group Information_

*!link*
_Show Group Link_

*!setwelcome [text]*
_set Welcome Message_

_You Can Use_ *[!/#]* _To Run The Commands_
_This Help List Only For_ *Moderators/Owners!*
_Its Means, Only Group_ *Moderators/Owners* _Can Use It!_

*Good luck ;)*]]

elseif lang then

text = [[
*دستورات ربات بیوند:*

*!setowner* `[username|id|reply]` 
_انتخاب مالک گروه(قابل انتخاب چند مالک)_

*!remowner* `[username|id|reply]` 
 _حذف کردن فرد از فهرست مالکان گروه_

*!promote* `[username|id|reply]` 
_ارتقا مقام کاربر به مدیر گروه_

*!demote* `[username|id|reply]` 
_تنزیل مقام مدیر به کاربر_

*!setflood* `[1-50]`
_تنظیم حداکثر تعداد پیام مکرر_

*!silent* `[username|id|reply]` 
_بیصدا کردن کاربر در گروه_

*!unsilent* `[username|id|reply]` 
_در آوردن کاربر از حالت بیصدا در گروه_

*!kick* `[username|id|reply]` 
_حذف کاربر از گروه_

*!ban* `[username|id|reply]` 
_مسدود کردن کاربر از گروه_

*!unban* `[username|id|reply]` 
_در آوردن از حالت مسدودیت کاربر از گروه_

*!res* `[username]`
_نمایش شناسه کاربر_

*!id* `[reply]`
_نمایش شناسه کاربر_

*!whois* `[id]`
_نمایش نام کاربر, نام کاربری و اطلاعات حساب_

*!lock* `[link | tag | edit | webpage | bots | spam | flood | markdown | mention]`
_در صورت قفل بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

*!unlock* `[link | tag | edit | webpage | bots | spam | flood | markdown | mention]`
_در صورت قفل نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

*!mute* `[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدد بودن فعالیت ها, ربات آنهارا حذف خواهد کرد_

*!unmute* `[gifs | photo | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_در صورت بیصدا نبودن فعالیت ها, ربات آنهارا حذف نخواهد کرد_

*!set*`[rules | name | photo | link | about]`
_ربات آنهارا ثبت خواهد کرد_

*!clean* `[bans | mods | bots | rules | about | silentlist]`   
_ربات آنهارا پاک خواهد کرد_

*!pin* `[reply]`
_ربات پیام شمارا در گروه سنجاق خواهد کرد_

*!unpin* 
_ربات پیام سنجاق شده در گروه را حذف خواهد کرد_

*!settings*
_نمایش تنظیمات گروه_

*!mutelist*
_نمایش فهرست بیصدا های گروه_

*!silentlist*
_نمایش فهرست افراد بیصدا_

*!banlist*
_نمایش افراد مسدود شده از گروه_

*!ownerlist*
_نمایش فهرست مالکان گروه_ 

*!modlist* 
_نمایش فهرست مدیران گروه_

*!rules*
_نمایش قوانین گروه_

*!about*
_نمایش درباره گروه_

*!id*
_نمایش شناسه شما و گروه_

*!gpinfo*
_نمایش اطلاعات گروه_

*!link*
_نمایش لینک گروه_

*!setwelcome [text]*
_ثبت پیام خوش آمد گویی_

_شما میتوانید از [!/#] در اول دستورات برای اجرای آنها بهره بگیرید

این راهنما فقط برای مدیران/مالکان گروه میباشد!

این به این معناست که فقط مدیران/مالکان گروه میتوانند از دستورات بالا استفاده کنند!_

*موفق باشید ;)*]]
end
return text
end
--------------------- Welcome -----------------------
if matches[1] == 'setwelcome' and matches[2] then
	if not lang then
		welcome = check_markdown(matches[2])
		redis:hset('beyond_welcome',msg.chat_id_,tostring(welcome))
		tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'Welcome Message Seted :\n\n'..matches[2], 1, 'md')
	else
		welcome = check_markdown(matches[2])
		redis:hset('beyond_welcome',msg.chat_id_,tostring(welcome))
		tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'پیام خوش آمد ثبت شد:\n\n'..matches[2], 1, 'md')
	end
end
-----------------------------------------
if matches[1] == 'delwelcome' then
	if not lang then
		if not redis:hget('beyond_welcome',msg.chat_id_) then
			tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'Already No welcome message available!', 1, 'md')
		else
			redis:hdel('beyond_welcome',msg.chat_id_)
			tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'Weclome Message Deleted!', 1, 'md')
		end
	else
		if not redis:hget('beyond_welcome',msg.chat_id_) then
			tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'در حال حاضر هیچ پیام خوش آمد گویی وجود ندارد !', 1, 'md')
		else
			welcome = check_markdown(matches[2])
			redis:hdel('beyond_welcome',msg.chat_id_)
			tdcli.sendMessage(msg.chat_id_, msg.id_, 1, 'پیام خوش آمد گویی حذف شد', 1, 'md')
		end
	end
end
end
-----------------------------------------
local function pre_process(msg)
	if msg.content_.members_ then
		if redis:hget('beyond_welcome',msg.chat_id_) then
			if msg.content_.members_[0] then
				name = msg.content_.members_[0].first_name_
				if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
					return nil
				else
					data = redis:hget('beyond_welcome',msg.chat_id_)
					if data:match('{name}') then
						out = data:gsub('{name}',name)
					else
						out = data
					end
						tdcli.sendMessage(msg.chat_id_, msg.id_, 1, tostring(out:gsub('\\_','_')), 1, 'md')
				end
			end
		end
    end
	if msg.content_.ID == 'MessageChatJoinByLink' then 
		if redis:hget('beyond_welcome',msg.chat_id_) then
		--	name = data.first_name_ 	# Not Fixed Yet!
			Data = redis:hget('beyond_welcome',msg.chat_id_)
			if Data:match('{name}') then
				out = Data:gsub('{name}',' ')
			else
				out = Data
			end
				tdcli.sendMessage(msg.chat_id_, msg.id_, 1, tostring(out:gsub('\\_','_')), 1, 'md')
		end
	end
 end
return {
patterns ={
"^[!/#](id)$",
"^[!/#](id) (.*)$",
"^[!/#](pin)$",
"^[!/#](unpin)$",
"^[!/#](gpinfo)$",
"^[!/#](test)$",
"^[!/#](add)$",
"^[!/#](rem)$",
"^[!/#](setowner)$",
"^[!/#](setowner) (.*)$",
"^[!/#](remowner)$",
"^[!/#](remowner) (.*)$",
"^[!/#](promote)$",
"^[!/#](promote) (.*)$",
"^[!/#](demote)$",
"^[!/#](demote) (.*)$",
"^[!/#](modlist)$",
"^[!/#](ownerlist)$",
"^[!/#](lock) (.*)$",
"^[!/#](unlock) (.*)$",
"^[!/#](settings)$",
"^[!/#](mutelist)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](link)$",
"^[!/#](setlink)$",
"^[!/#](rules)$",
"^[!/#](setrules) (.*)$",
"^[!/#](about)$",
"^[!/#](setabout) (.*)$",
"^[!/#](setname) (.*)$",
"^[!/#](clean) (.*)$",
"^[!/#](setflood) (%d+)$",
"^[!/#](res) (.*)$",
"^[!/#](whois) (%d+)$",
"^[!/#](help)$",
"^[!/#](setlang) (.*)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^[!/#](setwelcome) (.*)",
"^[!/#](delwelcome)$"

},
run=run,
pre_process = pre_process
}
