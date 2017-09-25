-- map.lua
-- Author: ChaoYuan
-- Date:   2017-04-13
-- Last modification : 2017-04-13
-- Description: 地图
require("game/wall")
require("core/object");

MapBase=class()

MapBase.DEFAULT_BACKGROUND = "sky.png"

MapBase.touchValue = 
{
    NOTHING = 21;
    DEATH = 22;
    SCORE = 23;
    DIAMOND = 24;
}

MapBase.ctor=function (self, pic)
    self.curX=0
    self.curY=0
    self.x=0
    self.y=0
    self.width = 0
    self.height = 0
    self.index = 0
    if pic == nil then 
        self.pic = MapBase.DEFAULT_BACKGROUND
    else
        self.pic = pic
    end
    self.walls = {}
    self.length = 0   --场景个数
    self.winX = 0     --赢得终点X坐标
    self.speedX = 0    
    --小鸡当前在那个场景
    self.curIndex = 1      
    --移动锁，true为不能移动，false为可以移动
    self.move_lock = false
    self:init()
end

MapBase.dtor=function (self)

end

--地图单位时间内平移的距离
MapBase.translation=function (self)
    if not self.move_lock then
        print_string("-------------------MAP MOVE---------------------")
        self.x=self.x-self.speedX
    end
end
--重置地图数据
MapBase.restart = function (self)
    self.x=0
    self.y=0
    self.speedX=0
    self.move_lock=false
end
--切换场景
function MapBase.clear(self)
    self.x=0
    self.y=0
    self.move_lock=false
    self.speedX=0
end 

MapBase.stop = function (self)
    self.move_lock=true
end

MapBase.move = function (self)
    self.move_lock= false
end

--判断小鸡有没有到达终点
--ture 为到了，false 为没有
function MapBase.isWin(self, chicken)
    if chicken:getWorldLeftTopCoordinate().x >= self.winX then 
        return true 
    end 
    return false 
end

function MapBase.updateCurIndex(self,chicken)
    local temp =nil
    if self.curIndex + 1 <= self.length then 
        temp = self.walls[self.curIndex + 1]:isCollisionWall(chicken)
        if temp then 
            self.curIndex = self.curIndex + 1            
        end 
    end 
end 

function MapBase.updateMoveBody(self ,chicken)
    self.walls[self.curIndex]:update(chicken)
end 

function MapBase.isTouchOther(self,chicken)
    return self.walls[self.curIndex]:isTouchOther(chicken)
end 

function MapBase.isTouchMove(self, chicken)
    return self.walls[self.curIndex]:isTouchMove(chicken)
end 

function MapBase.isTouchWall(self, chicken)
    return self.walls[self.curIndex]:isCollisionWall(chicken)
end 

function MapBase.changeScene(self)

end 

function MapBase.removeWall(self)
    table.remove(self.walls,1)
    self.width = 0
    self.hegiht = 0
    self.length = 0
    self.curIndex = 1
end 
----------private ----------
MapBase.init=function (self)
    
end

------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------
MapBase.setPic = function (self , pic)
    if pic ~= nil then
        self.pic = pic
    end
end

MapBase.setSize = function (self,x,y)
    self.width = x
    self.hegiht = y
end

MapBase.addWall=function (self,wall)
    if wall then 
        wall:setCoordinate(self.width ,nil , self.width + wall:getWidth(),nil)
        wall:changeToWorldPos(0,0)
        table.insert(self.walls, wall)
        self.width = self.width + wall:getWidth()
        self.height = system.HEIGHT
        self.length = self.length + 1
        if wall:getFlag() then 
            self.winX = wall:getLeftTopCoordinate().x + wall:getFlag():getLeftTopCoordinate().x
        end 
    end
end

MapBase.setSpeedX = function (self,speedX)
    self.speedX = speedX
end

MapBase.getX=function (self)
    return self.x
end

MapBase.getY=function (self)
    return self.y
end

MapBase.getWidth = function (self)
    return self.width
end

MapBase.getHeight = function (self)
    return self.height
end 

MapBase.getPic = function (self)
    return self.pic
end

MapBase.getSpeedX = function (self)
    return self.speedX
end

MapBase.getWalls = function (self)
    return self.walls
end

MapBase.getCurIndex = function (self)
    return self.curIndex
end 
--endregion
