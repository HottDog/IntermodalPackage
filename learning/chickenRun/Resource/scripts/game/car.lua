-- car.lua
-- Author: ChaoYuan
-- Date:   2017-04-18
-- Last modification : 2017-04-18
-- Description: 汽车
require("game/wallItem")
require("game/map")
require("game/cityRoad")

Car = class(WallItem,false)

Car.SKINS1 = {"bigBus1.png","bigBus2.png"}
Car.SKINS2 = {"bus1.png","bus2.png","bus3.png"}
Car.SKINS3 = {"car1.png","car2.png"}
Car.SKINS4 = {"bigCar1.png","bigCar2.png"}

Car.DEFAULT_SPEED = 10

function Car.ctor(self,ltX,w,h,skins,speed)
    if skins then 
        self.skins = skins
    else
        self.skins = Car.SKINS1
    end 
    if speed then 
        self.speed = speed 
    else 
        self.speed = Car.DEFAULT_SPEED
    end 
    self.moveLock = true
    super(self,ltX,system.HEIGHT - h - CityRoad.HEIGHT, w, h, self.skins[1],self.skins)
end 

function Car.dtor(self)

end 

function Car.isDead(self, chicken)
    if self:getWorldLeftTopCoordinate().y >= chicken:getWorldRightBottomCoordinate().y then 
        return MapBase.touchValue.NOTHING
    else 
        return MapBase.touchValue.DEATH
    end
end 

Car.intersecteDirection = function (self,chicken)
    print_string("---------------hah -----------------")
    local beginCoordination = chicken:getLastRightBottomCoordinate()
    local endCoordination = chicken.worldPos.rightBottomCoordinate
    --如果小鸡是在上跳的过程中和汽车相撞，则直接死亡
    if beginCoordination.y > endCoordination.y then 
        return MapBase.touchValue.DEATH,0
    end 
    --线段：y=kx+b
    local k = (beginCoordination.y - endCoordination.y)/(beginCoordination.x - endCoordination.x)
    local b = (beginCoordination.x*endCoordination.y - beginCoordination.y * endCoordination.x )/(beginCoordination.x - endCoordination.x) 
   
    local intersecteY = self.worldPos.leftTopCoordinate.x *k +b 
    if intersecteY > self.worldPos.leftTopCoordinate.y and intersecteY <=self.worldPos.rightBottomCoordinate.y then 
        
        return MapBase.touchValue.DEATH, intersecteY
    else
        local intersecteX = (self.worldPos.leftTopCoordinate.y - b)/k 
        return WallItem.s_intersecteDirection.TOP , intersecteX
    end

    print_string("-------------------enenenenend---------------------")
end

function Car.beginMove(self)
    self.moveLock = false
end 

function Car.move(self)
    if not self.moveLock then  
        if self.localPos.leftTopCoordinate.x >=0 then 
            self:resetMoveCoordinate(-self.speed , y)
        end 
    end
end 

function Car.getSkinsLength(self)
    return #(self.skins)
end 

function Car.getSkins(self)
    return self.skins
end 




