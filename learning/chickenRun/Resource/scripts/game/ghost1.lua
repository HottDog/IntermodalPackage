-- ghost1.lua
-- Author: ChaoYuan
-- Date:   2017-04-18
-- Last modification : 2017-04-18
-- Description: ”ƒ¡È1
require("game/moveRectBody")
require("game/map")
require("game/speed")

Ghost1 = class(MoveRectBody,false)

Ghost1.SKINS = {"ghost1.png","ghost2.png"}
Ghost1.SKINS2 = {"m1.png","m2.png","m3.png"}
Ghost1.SKINS3 = {"k1.png","k2.png","k3.png"}
Ghost1.WIDTH = 60
Ghost1.HEIGHT = 90
Ghost1.MARGIN_LEFT = {
    LEVEL1 = 30;
    LEVEL2 = 60;
    LEVEL3 = 100;
}
Ghost1.MARGIN_RIGHT  = {
    LEVEL1 = 30;
    LEVEL2 = 60;
    LEVEL3 = 100;
}
function Ghost1.ctor(self,rec,skins,speed , width, height, marginLeft , marginRight)
    if skins then 
        self.skins = skins
    else 
        self.skins = Ghost1.SKINS
    end 
    local s = speed 
    if not s then 
        s = Speed.move.GHOST
    end 
    local w = width
    if not w then 
        w = Ghost1.WIDTH
    end 
    local h = height
    if not h then 
        h = Ghost1.HEIGHT
    end 
    super(self, w, h, rec, s, self.skins , marginLeft , marginRight)
end 

function Ghost1.dtor(self)
    
end 

function Ghost1.isTouch(self, chicken)
    if RectBody.isTouch(self, chicken) then 
        return MapBase.touchValue.DEATH
    else 
        return MapBase.touchValue.NOTHING
    end 
end 

