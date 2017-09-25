--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
Speed=class()
--起始速度是10
--平移速度区间是10-30（暂定）
--起跳速度区间是5-20（暂定）
Speed.chicken={
    MAX_TRAN = 12;
    MIN_TRAN = 4;
    MAX_JUMP = 40;
    MIN_JUMP = 5 ;
}
Speed.car = {
    LVEVEL1 = 6;
    LVEVEL2 = 10;
    LVEVEL3 = 15;
    LVEVEL4 = 20;
}
Speed.move = {
    GHOST = 4;
    GHOST2 = 6;
    GHOST3 = 8;
}

Speed.ctor = function (self,minTranSpeed,maxTranSpeed,minJumpSpeed,maxJumpSpeed)
    --minTranSpeed
    if minTranSpeed==nil then 
        self.minTranSpeed=Speed.chicken.MIN_TRAN
    else
        self.minTranSpeed=minTranSpeed
    end
    --maxTranSpeed
    if maxTranSpeed==nil then 
        self.maxTranSpeed = Speed.chicken.MAX_TRAN
    else 
        self.maxTranSpeed = maxTranSpeed
    end
    --minJumpSpeed
    if minJumpSpeed==nil then 
        self.minJumpSpeed = Speed.chicken.MIN_JUMP
    else
        self.minJumpSpeed = minJumpSpeed
    end
    --maxJumpSpeed
    if maxJumpSpeed == nil then 
        self.maxJumpSpeed = Speed.chicken.MAX_JUMP
    else
        self.maxJumpSpeed = maxJumpSpeed
    end
end

Speed.dtor = function (self)

end

Speed.getSpeed = function (self,curL,jumpL)
    local temp = {x,y}
    if curL<jumpL then        --平移
        temp.x = self.minTranSpeed+(curL/gameVoice.level.MAX)*(self.maxTranSpeed-self.minTranSpeed)
    else
        temp.x = self.minTranSpeed+(curL/gameVoice.level.MAX)*(self.maxTranSpeed-self.minTranSpeed)
        temp.y = self.minJumpSpeed+(curL-jumpL)/(gameVoice.level.MAX-jumpL)*(self.maxJumpSpeed-self.minJumpSpeed)   
    end
    return temp
end
--endregion