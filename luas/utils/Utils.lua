local Utils = {}

function Utils.createController(app_name,req,res)
    local ctrl = nil
    local ctrl_name = string.upper(string.sub(app_name,1,1)) .. string.sub(app_name,2,-1) .. 'Controller'
    local ctrl_path = 'controller.' .. ctrl_name
 
    local rs = include(ctrl_path)
    if not rs then
        return false
    else
        ctrl = rs.new(req,res)
        return ctrl
    end
end

function Utils.ucfirst(input)
     return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end



return Utils