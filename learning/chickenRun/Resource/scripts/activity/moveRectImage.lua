-- moveRectImage.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: �����ƶ��ľ�������
require("activity/rectImage")
require("game/moveRectBody")
MoveRectImage = class(RectImage)

function MoveRectImage.ctor(self , moveRect)
    self.index = 1
end 

function MoveRectImage.dtor(self)

end 

function MoveRectImage.update(self)
    --����λ��
    self:updatePos()
    --����Ч��
    if self.index <= self.rec:getSkinsLength() then 
        self:setFile(self.rec:getSkins()[self.index])
        self.index = self.index + 1
    end 
    if self.index > self.rec:getSkinsLength() then 
        self.index = 1
    end 
end 