-- wallItem.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: 可以踩的陆地
require("game/rectangle")
require("game/chicken")
require("game/rectBody")
require("game/map")

WallItem = class(RectBody,false)

--常量
WallItem.DEFAULTSKIN = "grassland3.png"           --默认皮肤

WallItem.s_intersecteDirection = {
    TOP = 1,
    LEFT = 2
}
--------------------构造函数--------------------
-------参数解释
--startX 开始的X轴坐标
--endX 结束的X轴坐标
--h 高度
--skin 皮肤
WallItem.ctor = function (self,ltX,ltY,w,h,skin,skins)
    local tempSkin = skin
    if not tempSkin then 
        tempSkin = WallItem.DEFAULTSKIN
    end 
    if skins then 
        self.skins=skins
    else
        self.skins={}
    end 
    --table.insert(self.skins, tempSkin)
    super(self,ltX,ltY,w,h,tempSkin)
end

WallItem.dtor = function (self)
    
end

function WallItem.isDead(self,chicken)
    return MapBase.touchValue.NOTHING
end 
--陆地是以那边和小鸡向撞得，目前只有两边，上面或左边（基于陆地）
-----返回参数说明
-----第一参数 返回相撞的方向
-----第二个参数  返回相撞点的坐标，已知的没给，只给了需要计算的
WallItem.intersecteDirection = function (self,chicken)
    print_string("---------------hah -----------------")
    local beginCoordination = chicken:getLastRightBottomCoordinate()
    local endCoordination = chicken.worldPos.rightBottomCoordinate
    --线段：y=kx+b
    local k = (beginCoordination.y - endCoordination.y)/(beginCoordination.x - endCoordination.x)
    local b = (beginCoordination.x*endCoordination.y - beginCoordination.y * endCoordination.x )/(beginCoordination.x - endCoordination.x) 
   
    local intersecteY = self.worldPos.leftTopCoordinate.x *k +b 
    if intersecteY > self.worldPos.leftTopCoordinate.y and intersecteY <=self.worldPos.rightBottomCoordinate.y then 
        
        return WallItem.s_intersecteDirection.LEFT , intersecteY
    else
        local intersecteX = (self.worldPos.leftTopCoordinate.y - b)/k 
        return WallItem.s_intersecteDirection.TOP , intersecteX
    end

    print_string("-------------------enenenenend---------------------")
end

function WallItem.beginMove(self)
    
end 

function WallItem.move(self)

end 

function WallItem.getSkinsLength(self)
    return #(self.skins)
end 
function WallItem.getSkins(self)
    return self.skins
end 
------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------

--endregion
