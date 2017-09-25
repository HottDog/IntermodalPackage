-- lightWall.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: Ò¹Íí³¡¾°
require("game/wall")
require("game/nightRoad")
LightWall = class(WallBase,false)

LightWall.DEFAULT_SKIN = "light.png"
LightWall.NIGHT_WALL_SKIN = "night_groud2.png"

function LightWall.ctor(self)
    super(self,7800,LightWall.DEFAULT_SKIN)
    --super(self,1650,LightWall.DEFAULT_SKIN)
    if self.length>0 then 
        self:setFlag(self.body[self.length])
    end
end 

function LightWall.dtor(self)
    
end 

function LightWall.initBody(self)
    local rec1 = new (NightRoad,0,120 ,650,LightWall.NIGHT_WALL_SKIN)   
    local rec2 = new (NightRoad,750,120 ,550,LightWall.NIGHT_WALL_SKIN)
    local rec3 = new (NightRoad,1400,270 ,300,LightWall.NIGHT_WALL_SKIN)
    local rec4 = new (NightRoad,1850,470 ,450,LightWall.NIGHT_WALL_SKIN)
    local rec5 = new (NightRoad,2500,270,500,LightWall.NIGHT_WALL_SKIN)
    local rec6 = new (NightRoad,3250,420,400,LightWall.NIGHT_WALL_SKIN)
    local rec7 = new (NightRoad,3900,100,600,LightWall.NIGHT_WALL_SKIN)
    local rec8 = new (NightRoad,4800,370,500,LightWall.NIGHT_WALL_SKIN)
    local rec9 = new (NightRoad,5600,120,400,LightWall.NIGHT_WALL_SKIN)
    local rec10 = new (NightRoad,6400,420,1400,LightWall.NIGHT_WALL_SKIN)
    self:addBody(rec1)
    self:addBody(rec2)
    self:addBody(rec3)
    self:addBody(rec4)
    self:addBody(rec5)
    self:addBody(rec6)
    self:addBody(rec7)
    self:addBody(rec8)
    self:addBody(rec9)
    self:addBody(rec10)
    self.length=10
end 

function LightWall.initMoveBody(self)
    local ghost1 = new (Ghost1, self.body[2])
    self:addMoveBody(ghost1)

    local ghost2 = new (Ghost1, self.body[4],Ghost1.SKINS2, speed , width, height,nil , marginRight)
    self:addMoveBody(ghost2)

    local ghost3 = new (Ghost1, self.body[5])
    self:addMoveBody(ghost3)

    local ghost4 = new (Ghost1, self.body[8],Ghost1.SKINS3,Speed.move.GHOST2, nil, nil, Ghost1.MARGIN_LEFT.LEVEL2, Ghost1.MARGIN_RIGHT.LEVEL2)
    self:addMoveBody(ghost4)

    local ghost5 = new (Ghost1, self.body[9],Ghost1.SKINS2, Speed.move.GHOST3, nil, nil, Ghost1.MARGIN_LEFT.LEVEL1, Ghost1.MARGIN_RIGHT.LEVEL1)
    self:addMoveBody(ghost5)

end 
