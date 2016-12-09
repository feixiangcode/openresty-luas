local cjson = require "cjson"

local Response = class()

function Response:ctor()
    self.headers=ngx.header
    self._output={}
end

function Response:write(code,data,errInfo)
    self._output["code"] = code
    self._output["data"] = data
    self._output["errInfo"] = errInfo
end

function Response:redirect(url, status)
    ngx.redirect(url, status)
end

function Response:finish()
    if self._output["code"] then
        ngx.header.content_type = 'application/json; charset=UTF-8'
        ngx.print(cjson.encode(self._output))
        self._output = nil
    end
end

return Response