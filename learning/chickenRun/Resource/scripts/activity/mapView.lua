-- mapView.lua
-- Author: ChaoYuan
-- Date:   2017-04-12
-- Last modification : 2017-04-12
-- Description: 绘制总地图
require("ui/node")
require("game/map")
require("activity/mapItemView")
MapView = class(Node)

MapView.ctor = function (self, map)
    if map then 
        self.map = map
    else 
        self.map = new (MapBase)
    end 
    self.mapItems = {}
    self:draw()
    self:drawBody()
end

MapView.dtor = function (self)
    
end

function MapView.draw (self)
    self:setPos(self.map:getX(),self.map:getY())
    self:setSize(self.map:getWidth(), self.map:getHeight())
end 

function MapView.drawBody (self)
    for _,v in ipairs(self.map:getWalls()) do 
        local mapItemView = new (MapItemView , v)
        self:addChild(mapItemView)
        table.insert(self.mapItems, mapItemView)
    end 
end 

function MapView.updatePos(self)
    self:setPos(self.map:getX(),self.map:getY())
end

function MapView.update(self)
    self.mapItems[self.map:getCurIndex()]:update()
end 

function MapView.changeScene(self)
    table.remove(self.mapItems,1)
    self:removeAllChildren()
    self:draw()
    self:drawBody()
end 

