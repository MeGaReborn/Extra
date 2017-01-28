local datebase = {
   "_Pong_",
  }
local function run(msg, matches) 
return datebase[math.random(#datebase)]
end
return {
  patterns = {
    "^[/#+×!$]([Pp][Ii][Nn][Gg])",
	"^([Pp][Ii][Nn][Gg])",
  },
  run = run
}
