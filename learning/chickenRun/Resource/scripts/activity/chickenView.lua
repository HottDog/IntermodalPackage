-- chickenView.lua
-- Author: ChaoYuan
-- Date:   2017-04-13
-- Last modification : 2017-04-13
-- Description: ªÊ÷∆–°º¶
require("game/chicken")
require("activity/rectImage")
ChickenView = class(RectImage,false)

--chicken∑«ø’
ChickenView.ctor = function (self, chicken)
    super(self,chicken)
end 

function ChickenView.dtor(self)

end 

function ChickenView.changeSkinWithIndex(self, index)
    self:setFile(self.rec:getSkins()[index+1])
end 

function ChickenView.updatePos(self)
    self:setPos(self.rec:getX(),self.rec:getY())
end 