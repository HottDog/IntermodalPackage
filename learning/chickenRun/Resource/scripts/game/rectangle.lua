--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("game/position")
Rectangle = class()

Rectangle.ctor = function (self,ltX,ltY,rbX,rbY)
    --屏幕坐标
    self.localPos = new (Position,ltX,ltY,rbX,rbY)
    --世界坐标
    self.worldPos = new (Position)
    --上一次位置坐标
    self.lastPos = new (Position)

    self.width = 0
    self.height = 0
    self.localPos:calculate()
    self:calculateSize()
end

Rectangle.dtor = function (self)
    
end

--根据移动的距离来计算坐标,单位时间的移动量来计算
--处理的是世界坐标
Rectangle.setMoveWorldPos = function (self,x,y)
    --self:setLastPos()
    if x~=nil then
        self:setLastPosX()
        self.worldPos.leftTopCoordinate.x=self.worldPos.leftTopCoordinate.x+x
        self.worldPos.rightBottomCoordinate.x=self.worldPos.rightBottomCoordinate.x+x 
    end

    if y~=nil then
        self:setLastPosY()
        self.worldPos.leftTopCoordinate.y=self.worldPos.leftTopCoordinate.y+y
        self.worldPos.rightBottomCoordinate.y=self.worldPos.rightBottomCoordinate.y+y 
    end
    self.worldPos:calculate()
end

--移动屏幕坐标
Rectangle.setMoveLocalPos = function (self,x,y)
    if x~=nil then
        self.localPos.leftTopCoordinate.x=self.localPos.leftTopCoordinate.x+x
        self.localPos.rightBottomCoordinate.x=self.localPos.rightBottomCoordinate.x+x 
    end

    if y~=nil then
        self.localPos.leftTopCoordinate.y=self.localPos.leftTopCoordinate.y+y
        self.localPos.rightBottomCoordinate.y=self.localPos.rightBottomCoordinate.y+y 
    end
    self.localPos:calculate()
end
--设置碰撞后的重置位置,这个设置不记录上一次的位置
Rectangle.resetMoveCoordinate = function (self,x,y)
    if x~=nil then 
        self.localPos.leftTopCoordinate.x=self.localPos.leftTopCoordinate.x+x
        self.localPos.rightBottomCoordinate.x=self.localPos.rightBottomCoordinate.x+x 

        self.worldPos.leftTopCoordinate.x=self.worldPos.leftTopCoordinate.x+x
        self.worldPos.rightBottomCoordinate.x=self.worldPos.rightBottomCoordinate.x+x 
    end
    if y~=nil then
        self.localPos.leftTopCoordinate.y=self.localPos.leftTopCoordinate.y+y
        self.localPos.rightBottomCoordinate.y=self.localPos.rightBottomCoordinate.y+y 

        self.worldPos.leftTopCoordinate.y=self.worldPos.leftTopCoordinate.y+y
        self.worldPos.rightBottomCoordinate.y=self.worldPos.rightBottomCoordinate.y+y 
    end
    self.localPos:calculate()
    self.worldPos:calculate()
end
---------------------------private --------------------------------------
--矩形相交检测，true为相交，false为不相交
Rectangle.rectangularIntersecte = function (self,rec)
    if math.abs(self.worldPos.coreCoordinate.x-rec.worldPos.coreCoordinate.x) <= self.width/2+rec.width/2 and
        math.abs(self.worldPos.coreCoordinate.y-rec.worldPos.coreCoordinate.y) <= self.height/2+rec.height/2 then 
        return true
    else
        return false
    end
end
--计算中心点坐标
Rectangle.calculateSize = function (self)
    self.width = self.localPos.rightBottomCoordinate.x-self.localPos.leftTopCoordinate.x
    self.height = self.localPos.rightBottomCoordinate.y-self.localPos.leftTopCoordinate.y
    --print_string("coordination of chicken : ("..self.leftTopCoordinate.x..","..self.leftTopCoordinate.y..")")
    --print_string("coordination of chicken : ("..self.rightBottomCoordinate.x..","..self.rightBottomCoordinate.y..")")
end

--计算世界坐标
function Rectangle.changeToWorldPos(self,distanceX,distanceY)
    if distanceX then 
        self.worldPos.leftTopCoordinate.x = self.localPos.leftTopCoordinate.x + distanceX
        self.worldPos.rightBottomCoordinate.x = self.localPos.rightBottomCoordinate.x + distanceX
    end 
    if distanceY then 
        self.worldPos.leftTopCoordinate.y = self.localPos.leftTopCoordinate.y + distanceY
        self.worldPos.rightBottomCoordinate.y = self.localPos.rightBottomCoordinate.y + distanceY 
    end 
    self.worldPos:calculate()
    self:setLastPos()
end 

Rectangle.setLastPos = function (self)
    self:setLastPosX()
    self:setLastPosY()
end
--设置上一次的位置
Rectangle.setLastPosX = function (self)
    self.lastPos.rightBottomCoordinate.x=self.worldPos.rightBottomCoordinate.x
    self.lastPos.leftTopCoordinate.x=self.worldPos.leftTopCoordinate.x   
end

Rectangle.setLastPosY = function (self)
    self.lastPos.rightBottomCoordinate.y=self.worldPos.rightBottomCoordinate.y
    self.lastPos.leftTopCoordinate.y=self.worldPos.leftTopCoordinate.y
end

--------------get或者set方法--------------------
------------------------------------------------
Rectangle.setCoordinate = function (self,x1,y1,x2,y2)
    if x1 then 
        self.localPos.leftTopCoordinate.x =x1 
    end 
    if y1 then
        self.localPos.leftTopCoordinate.y =y1 
    end 
    if x2 then 
        self.localPos.rightBottomCoordinate.x =x2
    end 
    if y2 then 
        self.localPos.rightBottomCoordinate.y =y2
    end 
    self.localPos:calculate()
end

Rectangle.setLeftTopCoordinate = function (self,x,y)    
    if x then
        self.localPos.leftTopCoordinate.x=x
    end
    if y then
        self.localPos.leftTopCoordinate.y=y
    end
    self.localPos:calculate()
end

Rectangle.setRightBottomCoordinate = function (self,x,y)
    if self.localPos.rightBottomCoordinate.x~=nil then
        self.localPos.rightBottomCoordinate.x=x
    end
    if self.localPos.rightBottomCoordinate.y~=nil then
        self.localPos.rightBottomCoordinate.y=y
    end
    self.localPos:calculate()
end

Rectangle.getLeftTopCoordinate = function (self)
    return self.localPos.leftTopCoordinate
end

Rectangle.getLastLeftTopCoordinate = function (self)
    return self.lastPos.leftTopCoordinate
end

Rectangle.getRightBottomCoordinate = function (self)
    return self.localPos.rightBottomCoordinate
end
Rectangle.getLastRightBottomCoordinate =function (self)
    return self.lastPos.rightBottomCoordinate
end

Rectangle.getCoreCoordinate = function (self)
    return self.localPos.coreCoordinate
end

Rectangle.getWorldRightBottomCoordinate = function (self)
    return self.worldPos.rightBottomCoordinate
end

Rectangle.getWorldLeftTopCoordinate = function (self)
    return self.worldPos.leftTopCoordinate
end

Rectangle.getWidth = function (self)
    return self.width
end

Rectangle.getHeight = function (self)
    return self.height
end

--------------get或者set方法--------------------
------------------end---------------------------
