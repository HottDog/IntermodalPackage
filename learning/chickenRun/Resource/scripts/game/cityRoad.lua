-- cityRoad.lua
-- Author: ChaoYuan
-- Date:   2017-04-18
-- Last modification : 2017-04-18
-- Description: 城市道路

CityRoad = class(WallItem ,false)

CityRoad.HEIGHT = 120
CityRoad.WIDTH = 1500

CityRoad.DEFAULT_SKIN = "road.png"
function CityRoad.ctor(self,ltX,w)
    local width = w  
    if not width then 
        width = CityRoad.WIDTH
    end     
    super(self,ltX,system.HEIGHT - CityRoad.HEIGHT,width,CityRoad.HEIGHT,CityRoad.DEFAULT_SKIN)
end 

function CityRoad.dtor(self)

end 