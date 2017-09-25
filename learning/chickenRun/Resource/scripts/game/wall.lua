-- wall.lua
-- Author: ChaoYuan
-- Date:   2017-04-13
-- Last modification : 2017-04-13
-- Description: 场景
require("game/rectangle")
require("game/gameConstant")
require("game/rectBody")

WallBase=class(RectBody,false)

WallBase.DEFAULT_SKIN = "sky.png"


WallBase.ctor=function (self,w,skin)
    local tempSkin = skin
    if not tempSkin then 
        tempSkin = WallBase.DEFAULT_SKIN
    end 
    super(self,0,0,w,system.HEIGHT,tempSkin)
    --墙体数据
    self.body={}
    self.otherBody = {}
    self.moveBody = {}
    self.flag =nil
    self.length=0
    self:initBody()
    self:initOtherBody()  
    self:initMoveBody()
end

WallBase.dtor=function (self)

end


--判断小鸡是否与绿地碰撞
--true为相交，false为不相交
WallBase.isCollisionWall=function (self,chicken)
    for _,v in pairs(self.body) do
        if v:rectangularIntersecte(chicken) then
            print_string("------------chicken collision the wall-------------")
            return v
        end
    end
    print_string("------------chicken don't collision the wall-------------")
    return nil  
end

--判断小鸡有没有和其他元素碰撞
WallBase.isTouchOther = function (self,chicken)
    for _,v in pairs(self.otherBody) do 
        local temp = v:isTouch(chicken)
        if temp ~= MapBase.touchValue.NOTHING then 
            return temp
        end 
    end 
    return MapBase.touchValue.NOTHING
end 

WallBase.isTouchMove = function (self,chicken)
    for _,v in pairs(self.moveBody) do 
        local temp = v:isTouch(chicken)
        if temp ~= MapBase.touchValue.NOTHING then 
            return temp
        end 
    end 
    return MapBase.touchValue.NOTHING
end 
----------protect--------------
WallBase.initBody=function (self)
    
end

WallBase.initOtherBody = function (self)
    
end 

WallBase.initMoveBody = function (self)
    
end 

function WallBase.update(self, chicken)
    self:updateBody()
    self:updateMoveBody()
    self:updateOther(chicken)
end 

function WallBase.updateBody(self)
    for _,v in pairs(self.body) do 
        v:move()
    end
end 

WallBase.updateMoveBody = function (self)
    for _,v in pairs(self.moveBody) do 
        v:move()
    end 
end 

function WallBase.updateOther(self,chicken)

end 

function WallBase.reSet(self)
    for _,v in pairs(self.moveBody) do 
        v:reSet()
    end
end 

------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------
function WallBase.addBody(self,wallItem)
    if wallItem then 
        wallItem:changeToWorldPos(self.worldPos.leftTopCoordinate.x,0)
        table.insert(self.body, wallItem)
        
    end 
end 

function WallBase.addOtherBody(self, other)
    if other then 
        other:changeToWorldPos(self.worldPos.leftTopCoordinate.x,0)
        table.insert(self.otherBody, other)
    end 
end 

function WallBase.addMoveBody(self,move)
    if move then 
        move:changeToWorldPos(self.worldPos.leftTopCoordinate.x,0)
        table.insert(self.moveBody, move)
    end 
end 

WallBase.getBody = function (self)
    return self.body
end

WallBase.getOtherBody = function (self)
    return self.otherBody
end

WallBase.getMoveBody = function (self)
    return self.moveBody
end 

function WallBase.setFlag(self ,rec)
    self.flag = new (FlagRect, rec)
    self.flag:changeToWorldPos(self.worldPos.leftTopCoordinate.x,0)
end 

function WallBase.getFlag(self)
    return self.flag
end
--endregion
