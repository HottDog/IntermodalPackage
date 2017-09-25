--region *.lua
--Date
--平地
require("game/rectangle")
require("ui/image")
require("game/wallItem")
require("activity/rectImage")
Groud = class (RectImage,false)

Groud.ctor = function (self,rec)    
    super(self,rec)
    self.index = 1
end

Groud.dtor = function (self)
    
end

function Groud.update(self)
    --更新位置
    self:updatePos()
    --动画效果
    if self.index <= self.rec:getSkinsLength() then 
        self:setFile(self.rec:getSkins()[self.index])
        self.index = self.index + 1
    end 
    if self.index > self.rec:getSkinsLength() then 
        self.index = 1
    end 
end 


--endregion
