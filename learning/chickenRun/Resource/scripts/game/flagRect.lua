-- flagRec.lua
-- Author: ChaoYuan
-- Date:   2017-04-13
-- Last modification : 2017-04-13
-- Description: �ﵽ�յ��С����
require("game/rectBody")
FlagRect = class(RectBody,false)

FlagRect.DEFAULT_SKIN = "flag.png"

--standRect�ǿ� ΪС������ڵ��Ǹ�ƽ��
function FlagRect.ctor(self, standRect)
    local tempSkin = skin
    if not tempSkin then 
        tempSkin = FlagRect.DEFAULT_SKIN
    end 
    local ltX = standRect:getLeftTopCoordinate().x + 0.5 * standRect:getWidth() - 0.5 * gamePic.flag.WIDTH
    local ltY = standRect:getLeftTopCoordinate().y - gamePic.flag.HEIGHT
    super(self,ltX,ltY,gamePic.flag.WIDTH,gamePic.flag.HEIGHT,tempSkin)
end 

function FlagRect.dtor(self)

end  


------------------------------------------------
--------------get����set����--------------------
------------------------------------------------

------------------------------------------------
--------------get����set����--------------------
------------------end--------------------------