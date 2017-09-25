-- moveRectImage.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: 绘制移动的矩形物体
require("activity/rectImage")
require("game/moveRectBody")
MoveRectImage = class(RectImage)

function MoveRectImage.ctor(self , moveRect)
    self.index = 1
end 

function MoveRectImage.dtor(self)

end 

function MoveRectImage.update(self)
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