--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("core/object") 
require("ui/node")

ActivityBase=class(Node)

ActivityBase.ctor=function (self)
    self:addToRoot()
    self:create()
end

ActivityBase.dtor=function (self)
  
end

ActivityBase.create=function (self)

end