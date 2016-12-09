local redis = include("luas.core.SRedis")
local RedisController = class()

function RedisController:ctor(req,res)
    self.req = req
    self.res = res
end

function RedisController:actionSetData()
	local res = redis:execute('set','cheng','chengweidong')
	self.res:write(0,res)
end

function RedisController:actionGetData()

	local res = redis:execute('get','cheng')
	self.res:write(0, res)
end
return RedisController