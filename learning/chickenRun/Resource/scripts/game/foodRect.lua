-- foodRect.lua
-- Author: ChaoYuan
-- Date:   2017-03-27
-- Last modification : 2017-03-27
-- Description: 可以吃的食物
require("game/rectBody")
require("game/map")
FoodRect = class(RectBody,false)

FoodRect.ctor = function(self,ltX,ltY,w,h,skin)
    super(self,ltX,ltY,w,h,skin)
end

FoodRect.dtor = function(self)
    
end

function FoodRect.isTouch(self, chicken)
    if RectBody.isTouch(self, chicken) then 
        return BaseMap.touchValue.SCORE
    else 
        return BaseMap.touchValue.NOTHING
    end 
end 
------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------
