--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("game/wall")
require("game/rectangle")
require("game/gameConstant")
require("game/wallItem")
require("game/darkCloud")
require("game/flagRect")
require("game/ghost1")
require("game/road")
Wall1=class(WallBase,false)

Wall1.ctor=function (self)
    --super(self,2750)
    super(self,4800)
    --super(self,6800)
    if self.length>0 then 
        self:setFlag(self.body[self.length])
    end 
end

Wall1.dtor=function (self)

end

Wall1.initBody=function (self)   
    local rec1 = new (Road,0,120 ,650)   
    local rec2 = new (Road,750,120 ,400)
    local rec3 = new (Road,1250,220 ,300)
    local rec4 = new (Road,1650,120 ,450)
    local rec5 = new (Road,2250,270,500)
    local rec6 = new (Road,2900,420,400)
    local rec7 = new (Road,3400,570,1400)
    --local rec7 = new (Road,3450,220,500)
    --local rec8 = new (Road,4150,420,300)
    --local rec9 = new (Road,4700,270,400)
    --local rec10 = new (Road,5400,570,1400)

    self:addBody(rec1)
    self:addBody(rec2)
    self:addBody(rec3)
    self:addBody(rec4)
    self:addBody(rec5)
    self:addBody(rec6)
    self:addBody(rec7)
    --self:addBody(rec8)
    --self:addBody(rec9)
    --self:addBody(rec10)

    self.length=7
  
end

function Wall1.initOtherBody(self)
    --绘制黑云
    local darkCloud = new (DarkCloud)
    self:addOtherBody(darkCloud)
end 

function Wall1.initMoveBody(self)
    --local ghost = new (Ghost1, self.body[2])
    --self:addMoveBody(ghost)
end 

function Wall1.reSet(self)
    
end 
--endregion
