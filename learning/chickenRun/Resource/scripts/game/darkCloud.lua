-- darkCloud.lua
-- Author: ChaoYuan
-- Date:   2017-03-27
-- Last modification : 2017-03-27
-- Description: 危险的物体
require("game/rectBody")

DarkCloud = class (RectBody,false)
DarkCloud.DEFAULT_SKIN = "cloud.png"

DarkCloud.ctor = function(self)
    super(self,1400,180,500,120,DarkCloud.DEFAULT_SKIN)
end

DarkCloud.dtor = function (self)
    
end

function DarkCloud.isTouch(self, chicken)
    if RectBody.isTouch(self,chicken) then 
        return MapBase.touchValue.DEATH
    else 
        return MapBase.touchValue.NOTHING
    end
end 

