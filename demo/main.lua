ngx.ctx.config = include("config.config")
local Route = include("luas.core.Route")
local Utils = include("luas.utils.Utils")
local route = Route.new()
route:runRoute()
if not route.controller then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
if not route.action then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
local app = route.controller
local act = 'action' .. Utils.ucfirst(route.action)

local Request = require "luas.core.Request"
local Response = require "luas.core.Response"

local req = Request.new()
local res = Response.new()

local controller_name = string.lower(app)
local controller = Utils.createController(controller_name,req,res)

if controller then
    if controller[act] then
        controller[act](controller)
        res:finish()
        ngx.exit(ngx.HTTP_OK)
    else

    end
else

end