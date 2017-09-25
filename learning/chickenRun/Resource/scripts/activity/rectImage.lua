-- rectImage.lua
-- Author: ChaoYuan
-- Date:   2017-04-12
-- Last modification : 2017-04-12
-- Description: 通过矩形绘制Image
require("ui/image")
require("game/rectBody")
RectImage = class (Image)

RectImage.ctor = function (self , rec)
    if rec ~=nil then
        self.rec = rec 
    else
        self.rec = new(RectBody)
    end
    self:draw()
end 

RectImage.dtor = function (self)
    
end

RectImage.draw = function (self)
    self:setSize(self.rec:getWidth(),self.rec:getHeight())
    self:setPos(self.rec:getLeftTopCoordinate().x,self.rec:getLeftTopCoordinate().y)
    if self.rec:getSkin() then 
        self:setFile(self.rec:getSkin())
    end
end

function RectImage.updatePos(self)
    self:setPos(self.rec:getLeftTopCoordinate().x,self.rec:getLeftTopCoordinate().y)
end 

RectImage.setRec = function (self, rec)
    if rec then 
        self.rec = rec
        self:draw()
    end 
end 

RectImage.getRec = function (self)
    return self.rec
end 
