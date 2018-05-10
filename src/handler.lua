local BasePlugin = require "kong.plugins.base_plugin"
local HelloworldHandler = BasePlugin:extend()

function HelloworldHandler:new()
    HelloworldHandler.super.new(self, "helloworld")
end

function HelloworldHandler:access(config)
    HelloworldHandler.super.access(self)
    ngx.log(ngx.ERR, "hello world")
end

HelloworldHandler.PRIORITY = 3000
HelloworldHandler.VERSION = "0.0.1"

return HelloworldHandler