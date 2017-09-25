-- mapItemView.lua
-- Author: ChaoYuan
-- Date:   2017-04-12
-- Last modification : 2017-04-12
-- Description: 绘制地图片段
require("ui/image")
require("game/wall1")
require("activity/rectImage")
require("activity/groud")
require("activity/moveRectImage")
MapItemView = class(RectImage,false)

MapItemView.ctor = function (self,rec)
    super(self, rec)
    self.moveItems = {}
    self.grouds = {}
    self:drawGrounds()
    self:drawOthers()
    self:drawMoves()
end

MapItemView.dtor = function (self)

end

MapItemView.drawGrounds = function (self)
    for _,v in pairs(self.rec:getBody()) do
        local groud = new (Groud,v)
        self:addChild(groud)
        table.insert(self.grouds, groud)
    end
end

MapItemView.drawOthers = function (self)
    for _,v in pairs(self.rec:getOtherBody()) do
        local rectImg = new (RectImage,v)
        self:addChild(rectImg)
    end
end 

function MapItemView.drawMoves(self)
    for _,v in pairs(self.rec:getMoveBody()) do
        local rectImg = new (MoveRectImage, v)
        self:addChild(rectImg)
        table.insert(self.moveItems, rectImg)
    end 
end 

function MapItemView.update(self)
    self:updateBodys()
    self:updateMoves()
end 

function MapItemView.updateBodys(self)
    for _,v in pairs(self.grouds) do 
        v:update()
    end 
end 

function MapItemView.updateMoves(self)
    for _,v in pairs(self.moveItems) do 
        v:update()
    end 
end 

function MapItemView.restart(self)
    
end 

function MapItemView.clear(self)
    self:removeAllChildren()
end 