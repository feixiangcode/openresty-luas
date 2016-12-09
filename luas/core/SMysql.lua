local mysql = require("resty.mysql")
local mysql_key = 'smysql'
local SMysql = {}

function SMysql:getConnect()
    if ngx.ctx[mysql_key] then
        return true, ngx.ctx[mysql_key]
    end

    local client, errmsg = mysql:new()
    if not client then
        ngx.log(ngx.ERR, "mysql.socket_failed: " .. errmsg)
        return false
    end

    client:set_timeout(10000)  --10秒

    local result, errmsg, errno, sqlstate = client:connect(ngx.ctx.config.mysql)
    if not result then
        ngx.log(ngx.ERR, "mysql.cant_connect: " .. errmsg .. ", errno:" .. errno .. ", sql_state:" .. sqlstate)
        return false
    end

    local query = "SET NAMES utf8"
    local result, errmsg, errno, sqlstate = client:query(query)
    if not result then
        ngx.log(ngx.ERR, "mysql.cant_query: " .. errmsg .. ", errno:" .. errno .. ", sql_state:" .. sqlstate)
        return false
    end

    ngx.ctx[mysql_key] = client
    return true, ngx.ctx[mysql_key]
end

function SMysql:close()
    if ngx.ctx[mysql_key] then
        ngx.ctx[mysql_key]:set_keepalive(60000, 1000)
    end
end

function SMysql:query(sql)
    local ret, client = self:getConnect()
    if not ret then
        return false, client, nil
    end
    
    local result, errmsg, errno, sqlstate = client:query(sql)

    if not result then
        ngx.log(ngx.ERR, "mysql.cant_query: " .. errmsg .. ", errno:" .. errno .. ", sql_state:" .. sqlstate)
        return false, errmsg, sqlstate
    end

    self:close()
    return true, result, sqlstate
end

function SMysql:executeSql(sql)
    local ok,res = self:query(sql)
    if not ok then
        return false
    end
    return res
end

--get one by id
function SMysql:getInfoById(id, table_name)
    local sql = "select * from " .. table_name .. " where id = " .. id
    local ok,res = self:query(sql)
    if not ok then
        return false
    end
    if #res > 0 then
        return res[1]
    end
    return res
end

--get one
function SMysql:find(condition, table_name)
    local condition_str = ""
    if type(condition) == "table" then
         for k,v in pairs(condition) do
             condition_str = condition_str .. k .. " = " .. ngx.quote_sql_str(v) .. " AND"
         end
         condition_str = string.sub(condition_str,1,-4)
    else
         condition_str = condition
    end
    local sql = "select * from " .. table_name .. " where " ..condition_str
    local ok,res = self:query(sql)
    if not ok then
        return false
    end
    if #res > 0 then
        return res[1]
    end
    return res
end

--get all
function SMysql:findAll(condition, table_name)
    local condition_str = ""
    if type(condition) == "table" then
         for k,v in pairs(condition) do
             condition_str = condition_str .. k .. " = " .. ngx.quote_sql_str(v) .. " AND"
         end
         condition_str = string.sub(condition_str,1,-4)
    else
         condition_str = condition
    end
    local sql = "select * from " .. table_name .. " where " ..condition_str
    local ok,res = self:query(sql)
    if not ok then
        return false
    end
    return res
end

--update
function SMysql:update(data, condition, table_name)
    local condition_str = ""
    if type(condition) == "table" then
         for k,v in pairs(condition) do
             condition_str = condition_str .. k .. " = " .. ngx.quote_sql_str(v) .. " AND"
         end
         condition_str = string.sub(condition_str,1,-4)
    else
         condition_str = condition
    end
    
    local value_str = ""
    for m,n in pairs(data) do
        value_str = value_str .. m .. " = " .. ngx.quote_sql_str(n) .. ","
    end
    value_str = string.sub(value_str,1,-2)
    local sql = "UPDATE " .. table_name .. " set " .. value_str .. " where " .. condition_str
    local ok,res = self:query(sql)
    if not ok then
        return false
    end
    return res['affected_rows']
end

--insert
function SMysql:insertAll(data, table_name)
    if type(data) ~= "table" then
        return false
    end
    local sql = "insert into " .. table_name
    local key_list = {}
    for k,v in pairs(data[1]) do
        table.insert(key_list, k) 
    end
    sql = sql .. " (" .. table.concat(key_list,",") .. ") values "
    value_str = ""
    for i,j in ipairs(data) do
        str = "("
        for k,v in ipairs(key_list) do
            str = str .. ngx.quote_sql_str(j[v]) .. ","
        end
        str = string.sub(str,1,-2)
        str = str .. "),"
        sql = sql .. str
    end
    sql = string.sub(sql,1,-2)
    local ok, res = self:query(sql)
    if not ok then
        return false
    end
    return res['insert_id']
end

function SMysql:insert(data, table_name)
    if type(data) ~= "table" then
        return false
    end
    
    local value_str = ""
    for m,n in pairs(data) do
        value_str = value_str .. m .. " = " .. ngx.quote_sql_str(n) .. ","
    end
    value_str = string.sub(value_str,1,-2)
    local sql = "insert into " .. table_name .. " set " .. value_str
    
    local ok, res = self:query(sql)
    if not ok then
        return false
    end
    return res['insert_id']
end


return SMysql