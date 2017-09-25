-- moveRectBody.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: 可以移动的矩形物体
require("game/rectBody")

MoveRectBody = class(RectBody,false)

MoveRectBody.moveState = 
{
    FORWARD = 1;
    BACKOFF = 2;
}
MoveRectBody.DEFAULT_SPEED = 4
MoveRectBody.DEFAULT_MARGIN_LEFT = 100
MoveRectBody.DEFAULT_MARGIN_RIGHT = 100
function MoveRectBody.ctor(self, w, h, rec, speed, skins,marginLeft,marginRight)
    if speed then 
        self.speed = speed 
    else 
        self.speed = MoveRectBody.DEFAULT_SPEED
    end 
    self.skins = skins
    self.rec = rec 
    self.moveState = MoveRectBody.moveState.FORWARD
    --距离守护的陆地的边界距离
    if marginLeft then 
        self.marginLeft = marginLeft
    else 
        self.marginLeft = MoveRectBody.DEFAULT_MARGIN_LEFT
    end 
    if marginRight then 
        self.marginRight = marginRight
    else 
        self.marginRight = MoveRectBody.DEFAULT_MARGIN_RIGHT
    end 

    local ltX = rec:getLeftTopCoordinate().x + 0.5*rec:getWidth() - 0.5 * w
    local ltY = rec:getLeftTopCoordinate().y - h
    super(self,ltX,ltY,w,h,skins[1])

end 

function MoveRectBody.dtor(self)

end 

function MoveRectBody.move(self)
    if self.moveState == MoveRectBody.moveState.FORWARD and 
    self.localPos.leftTopCoordinate.x >= self.rec:getLeftTopCoordinate().x + self.rec:getWidth() - self.marginRight - self:getWidth() then 
        self.moveState = MoveRectBody.moveState.BACKOFF 
    end 
    if self.moveState == MoveRectBody.moveState.BACKOFF and 
    self.localPos.leftTopCoordinate.x <= self.rec:getLeftTopCoordinate().x + self.marginLeft then 
        self.moveState = MoveRectBody.moveState.FORWARD
    end 
    self:moving() 
end 

--移动
function MoveRectBody.moving(self)
    if self.moveState == MoveRectBody.moveState.FORWARD then 
        self:resetMoveCoordinate(self.speed , y)
    else 
        self:resetMoveCoordinate(-self.speed , y)
    end 
end 

function MoveRectBody.reSet(self)
    local ltX = self.rec:getLeftTopCoordinate().x + 0.5*self.rec:getWidth() - 0.5 * w
    local ltY = self.rec:getLeftTopCoordinate().y - h
    self.moveState = MoveRectBody.moveState.FORWARD
    self:setCoordinate(ltX,ltY,ltX+self:getWidth(),ltY+self.getHeight())
    self.localPos:calculate()
    self:changeToWorldPos(0,0)
end 

function MoveRectBody.setSkins(self,skins)
    if skins then 
        self.skins = skins 
    end 
end 

function MoveRectBody.getSkins(self)
    return self.skins
end 

function MoveRectBody.getSkinsLength(self)
    return #(self.skins)
end 

function MoveRectBody.setSpeed(self, speed)
    self.speed = speed 
end 