-- road.lua
-- Author: ChaoYuan
-- Date:   2017-04-18
-- Last modification : 2017-04-18
-- Description: Â½µØ
require("game/wallItem")
require("game/gameConstant")

Road = class(WallItem,false)

function Road.ctor(self,ltX,h,w,skin)
    super(self,ltX,system.HEIGHT - h,w,gameMap.MAXHEIGHT-(system.HEIGHT - h),skin)
end 

function Road.dtor(self)

end 