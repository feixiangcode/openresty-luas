local redis = require "resty.redis"
local redis_key = 'sredis'
local SRedis = {}

function SRedis:getConnection()
    if ngx.ctx[redis_key] then
        return true, ngx.ctx[redis_key]
    end
    local red = redis:new()
    red:set_timeout(1000)

    local redis_config = ngx.ctx.config.redis
    local ok, err = red:connect(redis_config.host, redis_config.port)
    if not ok then
        ngx.log(ngx.ERR, 'redis.connect_fail' .. err)
        return false
    end
    ngx.ctx[redis_key] = red
    return true,ngx.ctx[redis_key]
end

function SRedis:close()
    if ngx.ctx[redis_key] then
        ngx.ctx[redis_key]:set_keepalive(60000, 1000)
    end
end

function SRedis:execute(command, ...)
    local ok, redis = self:getConnection()
    if not ok then
        ngx.log(ngx.ERR, 'redis.execute.fail')
    end
    local res, err = redis[command](redis, ...)
    if not res then
        ngx.log(ngx.ERR, 'reids.' .. command .. '.fail' .. err)
        return false
    end
    self:close()
    if res == 'OK' then
        return true
    end
    return res
end

return SRedis