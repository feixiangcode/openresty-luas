local Route = class()

function Route:ctor()
   self.controller = nil
   self.action = nil
end

function Route:runRoute()
    local params = ngx.req.get_uri_args()
    local uri = params['r']
    if not uri then
        return
    end
    local matches,err = ngx.re.match(uri, "([A-Za-z0-9_]+)/([A-Za-z0-9_]+)")
    if type(matches) == 'table' then
         self.controller = matches[1]
         self.action = matches[2]
    end
end

return Route