--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("core/object")
require("game/map")
require("game/wall1")
require("game/cityWall")
require("game/lightWall")
Map1=class (MapBase)
Map1.SKY =1
Map1.NIGHT =3
Map1.CITY = 2

Map1.ctor=function (self)
    self.sky =nil 
    self.night = nil 
    self.city= nil 
end

Map1.dtor=function (self)

end

Map1.init=function (self)
    self.index =Map1.SKY
    self.curX=0
    self.x=self.curX
    self:initWall()
end

function Map1.changeScene(self)
    self:clearWall()
    self.index = self.index + 1
    if self.index > 3 then 
        self.index =1 
    end 
    if self.index <= 3 then 
        self:initWall() 
    end 
end 

function Map1.clearWall(self)
    self:removeWall()
    if index == Map1.SKY then 
        --delete(self.sky)
    elseif index == Map1.NIGHT then 
        --delete(self.night)
    else
        --delete(self.city)    
    end
end 

function Map1.initWall(self)
    if self.index == Map1.SKY then 
        if not self.sky then 
            self.sky = new (Wall1)           
        else
            self.sky:reSet()
        end 
        self:addWall(self.sky)
    elseif self.index == Map1.NIGHT then 
        if not self.night then 
            self.night = new (LightWall)   
        else    
            self.night:reSet()         
        end 
        self:addWall(self.night)
    else
        if not self.city then 
            self.city = new (CityWall)    
        else 
            self.city:reSet()         
        end 
        self:addWall(self.city) 
    end
end 

function Map1.restart(self)
    MapBase.restart(self)
    self.index = 3
    self:changeScene()
end 
------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------

--endregion
