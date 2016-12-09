--class method
_G.class = function(super)
    local superType = type(super)
    local cls = nil

    if superType ~= "table" then
        superType = nil
        super = nil
    end

    if super then
        cls = {}
        setmetatable(cls, {__index = super})
        cls.super = super
    else
        cls = {ctor = function() end}
    end

    cls.__index = cls

    function cls.new(...)
        local instance = setmetatable({}, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end

    return cls
end

--requre file
local _include_files = {}
_G.include = function(_name)
	local file = _include_files[_name]
	if file then
		return _include_files[_name]
	end

    local dir_file = ngx.var.APP_NAME .. "." .. _name
    local file = _include_files[dir_file]

    if file then
        return file
    end

    --self
    local ok, file = pcall(require, dir_file)
    if ok then
        _include_files[dir_file] = file
        return file
    end

    --sys
    local ok, file = pcall(require, _name)
    if ok then
        _include_files[_name] = file
        return file
    end
    return false
end