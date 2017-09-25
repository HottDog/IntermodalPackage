-- position.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: 坐标
Position = class()

function Position.ctor(self,ltX,ltY,rbX,rbY)
    self.leftTopCoordinate = {x,y}
    self.rightBottomCoordinate = {x,y}
    self.coreCoordinate = {x,y}

    if ltX==nil then 
        self.leftTopCoordinate.x = 0
    else
        self.leftTopCoordinate.x = ltX
    end

    if ltY==nil then 
        self.leftTopCoordinate.y = 0
    else
        self.leftTopCoordinate.y = ltY
    end

    if rbX==nil then
        self.rightBottomCoordinate.x = 0
    else
        self.rightBottomCoordinate.x = rbX
    end

    if rbY==nil then 
        self.rightBottomCoordinate.y = 0     
    else
        self.rightBottomCoordinate.y = rbY
    end
end 

function Position.dtor(self)
    
end  

--计算中心点坐标
Position.calculate = function (self)
    self.coreCoordinate.x=(self.rightBottomCoordinate.x+self.leftTopCoordinate.x)/2
    self.coreCoordinate.y=(self.rightBottomCoordinate.y+self.leftTopCoordinate.y)/2
    --print_string("coordination of chicken : ("..self.leftTopCoordinate.x..","..self.leftTopCoordinate.y..")")
    --print_string("coordination of chicken : ("..self.rightBottomCoordinate.x..","..self.rightBottomCoordinate.y..")")
end
