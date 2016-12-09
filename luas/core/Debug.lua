local Debug = {}
local json = include("cjson")

function Debug.writeLog(value)
	local bug_info = debug.traceback("trace")
	local value_type = type(value)
	if value_type == "number" then

	elseif value_type == "string" then

	elseif value_type == "boolean" then

	elseif value_type == "function" then
		value = ""
	elseif value_type == "table" then
		value = json.encode(value)
	elseif value_type == "userdata" then
		value = ""
	elseif value_type == "thread" then
		value = ""
	else
		value = ""
	end
	ngx.log(ngx.ERR,  bug_info)
	ngx.log(ngx.ERR, value_type .. '|' .. value)
end

return Debug