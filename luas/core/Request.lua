local Request = class()

local string_len = string.len

function Request:ctor()
    local ngx_var = ngx.var
    local ngx_req = ngx.req

    self.method          = ngx_var.request_method
    self.schema          = ngx_var.schema
    self.host            = ngx_var.host
    self.hostname        = ngx_var.hostname
    self.uri             = ngx_var.request_uri
    self.path            = ngx_var.uri
    self.filename        = ngx_var.request_filename
    self.query_string    = ngx_var.query_string
    self.headers         = ngx_req.get_headers()
    self.user_agent      = ngx_var.http_user_agent
    self.remote_addr     = ngx_var.remote_addr
    self.remote_port     = ngx_var.remote_port
    self.remote_user     = ngx_var.remote_user
    self.remote_passwd   = ngx_var.remote_passwd
    self.content_type    = ngx_var.content_type
    self.content_length  = ngx_var.content_length
    self.uri_args        = ngx_req.get_uri_args()
    self.socket          = ngx_req.socket
end

function Request:get_uri_arg(name, default)
    if name==nil then return nil end

    local arg = self.uri_args[name]
    if arg~=nil then
        if type(arg)=='table' then
            for _, v in ipairs(arg) do
                if v and string_len(v)>0 then
                    return v
                end
            end

            return ""
        end

        return arg
    end

    return default
end

function Request:get_post_arg(name, default)
    if name==nil then return nil end
    if self.post_args==nil then return nil end

    local arg = self.post_args[name]
    if arg~=nil then
        if type(arg)=='table' then
            for _, v in ipairs(arg) do
                if v and string_len(v)>0 then
                    return v
                end
            end

            return ""
        end

        return arg
    end

    return default
end

function Request:get_arg(name, default)
    return self:get_post_arg(name) or self:get_uri_arg(name, default)
end

function Request:read_body()
    local ngx_req = ngx.req
    ngx_req.read_body()
    self.post_args = ngx_req.get_post_args()
end

function Request:get_cookie(key, decrypt)
    local value = ngx.var['cookie_'..key]

    if value and value~="" and decrypt==true then
        value = ndk.set_var.set_decode_base64(value)
        value = ndk.set_var.set_decrypt_session(value)
    end

    return value
end

function Request:rewrite(uri, jump)
    return ngx.req.set_uri(uri, jump)
end

function Request:set_uri_args(args)
    return ngx.req.set_uri_args(args)
end

return Request