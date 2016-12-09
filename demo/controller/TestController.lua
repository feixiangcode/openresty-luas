local mysql = include("luas.core.SMysql")
local debug = include("luas.core.Debug")
local TestController = class()

function TestController:ctor(req,res)
    self.req = req
    self.res = res
end

function TestController:actionTest()
	self.res:write(0, '1111')
end

function TestController:actionGetInfo()
	local id = self.req:get_uri_arg('id', nil)
	if not id then
		self.res:write(22,nil,'id not empty')
		return
	end
	local res = mysql:getInfoById(id, 'tbl_user')
	if not res then
		self.res:write(22,nil,'no data')
		return
	end
	self.res:write(0, res)
end

function TestController:actionFind()
	local name = self.req:get_uri_arg('name', nil)
	local condition = { username = name}
	local res = mysql:find(condition, 'tbl_user')
	self.res:write(0, res)
end

function TestController:actionFindAll()
	local name = self.req:get_uri_arg('name', nil)
	local condition = { username = name}
	local res = mysql:findAll(condition, 'tbl_user')
	self.res:write(0, res)
end

function TestController:actionUpdate()
	local id = self.req:get_uri_arg('id', nil)
	local name = self.req:get_uri_arg('name', nil)
	local update_data = { username = name}
	local res = mysql:update(update_data, "id = " .. id, "tbl_user")
	self.res:write(0, res)
end

function TestController:actionInsertAll()
	local insert_data = {
		{
			username = 'cwd',
			password = '111',
			email = 'cwd@163.com',
			test = 10,
			test1 = 100
		}
	}
	local res = mysql:insert(insert_data, 'tbl_user')
	self.res:write(0,res)
end

function TestController:actionInsert()
	local insert_data = {
			username = 'ccc',
			password = '111',
			email = 'ccc@163.com',
			test = 10,
			test1 = 100
		}
	local res = mysql:insert(insert_data, 'tbl_user')
	self.res:write(0,res)

end

function TestController:actionJoin()
	local sql = "select * from tbl_user u left join tbl_post p on u.id = p.author_id";
	local res = mysql:executeSql(sql)
	
	self.res:write(0,res)
end

return TestController