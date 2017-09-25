-- nightRoad.lua
-- Author: ChaoYuan
-- Date:   2017-04-19
-- Last modification : 2017-04-19
-- Description: Ò¹ÍíµÄÂ½µØ
require("game/wallItem")
require("game/gameConstant")
NightRoad = class(WallItem,false)

function NightRoad.ctor(self,ltX,h,w,skin)
    super(self,ltX,system.HEIGHT - h,w,h,skin)
end 

function NightRoad.dtor(self)

end 