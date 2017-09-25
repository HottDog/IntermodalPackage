-- cityWall.lua
-- Author: ChaoYuan
-- Date:   2017-04-18
-- Last modification : 2017-04-18
-- Description: 城市场景
require("game/wall")
require("game/wallItem")
require("game/cityRoad")
require("game/car")
require("game/speed")

CityWall = class(WallBase,false)

CityWall.DEFAULT_SKIN = "city.png"

CityWall.ROAD_HEIGHT = 120

CityWall.CAR_HEIGHT = 130
CityWall.CAR_WIDTH = 270

CityWall.BUS_HEIGHT = 200
CityWall.BUS_WIDTH = 420

function CityWall.ctor(self)
    super(self,6900, CityWall.DEFAULT_SKIN)
    if self.carLength>0 then 
        self:setFlag(self.body[self.carLength])
    end 
end 

function CityWall.dtor(self)

end 

function CityWall.initBody(self)
    --道路
    local rec1 = new (CityRoad,0)
    local rec2 = new (CityRoad,1500)
    local rec3 = new (CityRoad,3000)
    local rec4 = new (CityRoad,4500,1200)
    local rec5 = new (CityRoad,5700,1200)
    self:addBody(rec1)
    self:addBody(rec2)
    self:addBody(rec3)
    self:addBody(rec4)
    self:addBody(rec5)
    --self:addBody(rec6)
    --self:addBody(rec7)
    --self:addBody(rec8)
    self.length = 5
    self.carLength = 5
    self.carIndex = self.length + 1
    self:initCar()
end 

function CityWall.initCar(self)
    --汽车
    --小 0
    local car1 = new (Car, 1500, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS1,Speed.car.LVEVEL1)
    self:addBody(car1)
    
    --小小
    local car2 = new (Car, 2100, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS1,Speed.car.LVEVEL1)
    self:addBody(car2)
    local car3 = new (Car, 2700, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS2,Speed.car.LVEVEL1)
    self:addBody(car3)
    --大小  
    local car4 = new (Car, 3400, CityWall.BUS_WIDTH, CityWall.BUS_HEIGHT ,Car.SKINS3,Speed.car.LVEVEL2)
    self:addBody(car4)
    local car5 = new (Car, 4000, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS2,Speed.car.LVEVEL2)
    self:addBody(car5)
    --小小大
    local car6 = new (Car, 4800, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS1,Speed.car.LVEVEL2)
    self:addBody(car6)
    local car7 = new (Car, 5200, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS2,Speed.car.LVEVEL2)
    self:addBody(car7)
    local car8 = new (Car, 5800, CityWall.BUS_WIDTH, CityWall.BUS_HEIGHT ,Car.SKINS4,Speed.car.LVEVEL2)
    self:addBody(car8)
    --大小大
    local car9 = new (Car, 6800, CityWall.BUS_WIDTH, CityWall.BUS_HEIGHT ,Car.SKINS3,Speed.car.LVEVEL3)
    self:addBody(car9)
    local car10 = new (Car, 7600, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS2,Speed.car.LVEVEL3)
    self:addBody(car10)
    local car11 = new (Car, 8200, CityWall.BUS_WIDTH, CityWall.BUS_HEIGHT ,Car.SKINS4,Speed.car.LVEVEL3)
    self:addBody(car11)
    --大小
    local car12 = new (Car, 9200, CityWall.BUS_WIDTH, CityWall.BUS_HEIGHT ,Car.SKINS4,Speed.car.LVEVEL4)
    self:addBody(car12)
    local car13 = new (Car, 10000, CityWall.CAR_WIDTH, CityWall.CAR_HEIGHT ,Car.SKINS2,Speed.car.LVEVEL4)
    self:addBody(car13)
end 

function CityWall.updateOther(self,chicken)
    local index = self.carIndex
    if chicken:getWorldLeftTopCoordinate().x < 2100 then 
        self.body[index]:beginMove()
        self.body[index+1]:beginMove()
        self.body[index+2]:beginMove()       
    elseif chicken:getWorldLeftTopCoordinate().x < 3800 then 
        self.body[index+3]:beginMove()
        self.body[index+4]:beginMove()
        self.body[index+5]:beginMove()
        self.body[index+6]:beginMove()
        self.body[index+7]:beginMove()
    elseif chicken:getWorldLeftTopCoordinate().x < 4600 then 
        self.body[index+8]:beginMove()
        self.body[index+9]:beginMove()
        self.body[index+10]:beginMove()
    else
        self.body[index+11]:beginMove()
        self.body[index+12]:beginMove()
    end 
end 

function CityWall.clear(self) 
    local n = self.length 
    for i = self.carIndex ,n,1  do 
        delete(table.remove(self.body, i))
    end 
end 

function CityWall.reSet(self)
    self:clear()
    self:initCar()
end 
