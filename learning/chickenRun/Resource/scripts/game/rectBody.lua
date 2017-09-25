-- rectBody.lua
-- Author: ChaoYuan
-- Date:   2017-04-13
-- Last modification : 2017-04-13
-- Description: 矩形物体
require("game/rectangle")
require("core/object")
RectBody = class(Rectangle,false)

RectBody.DEFAULT_SKIN = "flag.png"

function RectBody.ctor(self,ltX,ltY,w,h,skin)
    super(self,ltX,ltY,ltX+w,ltY+h)
    if skin==nil then
        self.skin = RectBody.DEFAULT_SKIN
    else
        self.skin = skin
    end
end 

function RectBody.dtor(self)

end  

--有没有碰撞，true为碰到，false为没碰到
RectBody.isTouch = function(self,chicken)
    return self:rectangularIntersecte(chicken)
end

------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------
RectBody.setSkin = function (self,skin)
    self.skin = skin
end

RectBody.getSkin = function (self)
    return self.skin
end
------------------------------------------------
--------------get或者set方法--------------------
------------------end--------------------------