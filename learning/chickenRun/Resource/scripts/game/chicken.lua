--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("game/gameConstant")
require("game/rectBody")
Chicken=class(RectBody,false)

Chicken.WIDTH = 60
Chicken.HEIGHT = 60
--游戏帧数
Chicken.FRAMES = 1000/25
--小鸡的运动状态
chickenState={TRANSLATION,JUMP,FALL}
chickenState.TRANSLATION=1
chickenState.JUMP=2
chickenState.FALL = 3

--小黄鸡是一个矩形，但是由于最终起影响的只有右下角，
--所以只需要保存右下角这个点就可以了
Chicken.ctor=function (self,width,height,initX,initY,speedX,footSpeed)
    --小鸡的皮肤
    self.skins={"1.png","2.png","3.png","4.png","5.png"}
    self.skin = self.skins[1]  --小鸡当前的皮肤
    --width
    super(self,0,540,60,60,self.skin)
    self:changeToWorldPos(0,0)
    if width==nil then 
        self.width=Chicken.WIDTH
    else
        self.width=width
    end
    --height
    if height==nil then
        self.height = Chicken.HEIGHT
    else
        self.height = height
    end 
    --小鸡初始的坐标
    if initX==nil then 
        self.initX=0
    else
        self.initX=initX
    end
    if initY==nil then 
        self.initY=540
    else
        self.initY=initY
    end
    --小鸡当前的X，Y坐标
    self.x=self.initX
    self.y=self.initY

    --小鸡上一次的Y坐标
    self.lastY=self.y
    --小鸡移动的速度
    if speedX==nil then 
        self.speedX=0
    else
        self.speedX = speedX
    end
    --小鸡脚步的频率
    if footSpeed==nil then
        self.footSpeed=Chicken.FRAMES
    else
        self.footSpeed=footSpeed
    end
    --小鸡向上起跳的速度
    self.jumpSpeed=0
    --小鸡跳跃的时间
    self.jumpTotalTime=0
    self.jumpTime=0
    --小鸡跳跃的次数
    self.jumpCount=0
    --目前小鸡跑了多长时间
    self.runTotalTime=0
    --小鸡的运动状态，默认是平移
    self.state=chickenState.TRANSLATION
    ----------数据模型坐标系---------------
end


Chicken.dtor=function (self)

end

--重置小鸡的数据
Chicken.restart = function (self)
    self:setCoordinate(0,540,60,600)
    self:changeToWorldPos(0,0)
    self.jumpTime=0
    self.jumpSpeed=0
    self.jumpTotalTime=0
    self.jumpCount=0
    self.state=chickenState.TRANSLATION
    self.speedX=0
    self.initY=540
    self.x=0
    self.y=540
end
--提供给外部的封装好的小鸡移动的接口
--开始阶段
Chicken.moveBegin = function (self)
    if self.state == chickenState.TRANSLATION then 
        self:translation()
    elseif self.state == chickenState.JUMP then
        --print_string("chicken jump time :"..self.jumpTime)
        if self.jumpTime == 0 then
            print_string("jump begin!!!!!!!!!!!")
            self:jumpBegin()
            self:jumping()
            
            self:translation()
            print_string("jump begin ---translastion!!!!!!!!!!!")
        else
            --print_string("jumping!!!!!!!!!!!")
            self:jumping() 
            self:translation()
            --print_string("jumping---translastion!!!!!!!!!!!")
            if self.jumpTime >= self.jumpTotalTime then
                --self:jumpEnd()
            end
         end
    else
        self:fall()
    end
end

--进行阶段
Chicken.moving = function (self)
    if self.state == chickenState.TRANSLATION then 
        --self:translation()
    elseif self.state == chickenState.JUMP then
        if self.jumpTime == 0 then
            self:jumpBegin()
            self:jumping()
        else
            self:jumping() 
            if self.jumpTime >= self.jumpTotalTime then
               --self:jumpEnd()
            end
         end
    else
        self:fall()
    end
end

--结束阶段
Chicken.moveEnd = function (self)
    if self.state == chickenState.TRANSLATION then 
        self:translation()
    elseif self.state == chickenState.JUMP then
        if self.jumpTime == 0 then
            self:jumpBegin()
            self:jumping()
            self:translation()
        else
            self:jumping() 
            self:translation()
         end
    else 
        self:fall()
    end
end

-------------------private------------------------
--小鸡每个时间单位(由self.footSpeed决定)的运动情况

---------------------平移-----------------------

Chicken.translation=function (self)
    self.x=self.x+self.speedX
    self:setMoveLocalPos(self.speedX,y)
    self:setMoveWorldPos(self.speedX,y)
end

---------------------跳跃-------------------------

--跳跃开始，然后返回一个跳跃的时间
Chicken.jumpBegin=function (self)
    --print_string("---------------------jumpSpeed------------------"..self.jumpSpeed)
    self.jumpTotalTime=(self.jumpSpeed/game.G)*2
    --print_string("chicken jump total time :"..self.jumpTotalTime)
    self.jumpTime=0
    self.state=chickenState.JUMP
    return self.jumpTotalTime
end

--跳跃过程,每个时间单位的运动情况
Chicken.jumping=function (self)
    self.jumpTime=self.jumpTime+1
    --self.x=self.initX+self.speedX
    self.lastY=self.y
    self.y=self.initY-(self.jumpSpeed*self.jumpTime-0.5*game.G*self.jumpTime*self.jumpTime)
    --[[if math.abs(self.y-self.lastY) >30 then 
        if self.y-self.lastY>0 then 
            self.y=self.lastY+29
        end
        if self.y-self.lastY<0  then 
            self.y = self.lastY-29
        end 
    end--]]
    self:setMoveLocalPos(x,self.y-self.lastY)
    self:setMoveWorldPos(x,self.y-self.lastY)
end

--跳跃结束
Chicken.jumpEnd=function (self)
    self.jumpTime=0
    self.jumpSpeed=0
    self.jumpTotalTime=0
    self.jumpCount=self.jumpCount+1
    self.initY=self.y
    self.state=chickenState.TRANSLATION
    --print_string("----------------TRANSLATION-----------------")
end

-------------------坠落------------------------
--其实就是X坐标不动的跳跃
Chicken.fall = function (self)
    self:jumping()
end

Chicken.moveX = function (self,x)
    self.x = self.x + x
    self:resetMoveCoordinate(x,y)
end

Chicken.moveY = function (self,y)
    self.y = self.y + y
    self:resetMoveCoordinate(x,y)
end

--------------get或者set方法--------------------
------------------------------------------------
Chicken.getX=function (self)
    return self.x
end

Chicken.getY=function (self)
    return self.y
end

Chicken.getState = function (self)
    return self.state
end

Chicken.getWidth = function (self)
    return self.width
end

Chicken.getHeight = function (self)
    return self.height
end

Chicken.getSkin = function (self)
    return self.skin
end

Chicken.getFootSpeed = function (self)
    return self.footSpeed
end

Chicken.getSpeedX = function (self)
    return self.speedX
end

Chicken.setSpeedX = function (self,x)
    self.speedX = x
end

Chicken.setJumpSpeed = function (self,y)
    self.jumpSpeed = y
end

Chicken.setWidth = function (self ,width)
    self.width = width
end

Chicken.setHeight = function (self , height)
    self.height=height
end

Chicken.setSkins = function (self , skins)
    for i=#(self.skins),1,-1 do
        table.remove(self.skins,i)
    end
    for _,v in ipairs(skins) do
        table.insert(self.skins,v)
    end  
end
function Chicken.getSkins(self)
    return self.skins
end 
Chicken.setState = function (self,state)
    self.state=state
end
--------------get或者set方法--------------------
-------------------end--------------------------
