--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("game/gameConstant")
Voice=class()
--jumpV是起跳声音，起跳声音越低，声音敏感度越高
--将所有声音一共分为100个等级

Voice.ctor=function (self,maxV,minV,jumpL)
    self.curValue=0
    --maxValue
    if maxV~=nil then 
        self.maxValue=maxV
    else
        self.maxValue=3200
    end
    --minValue
    if minV==nil then
        self.minValue=2600
    else
        self.minValue=minV
    end
    self.maxLevel = gameVoice.level.MAX
    self.minLevel = gameVoice.level.MIN
    --起跳等级
    if jumpL==nil then 
    --起跳等级默认是20
        self.jumpLevel=30
    else
        self.jumpLevel=jumpL
    end
    --当前的声音等级
    self.curLevel=0
end

Voice.dtor = function (self)

end

Voice.setMaxValue = function (self,maxV)
    if maxV ~= nil then 
        self.maxValue = maxV
    end
end

Voice.setMinValue = function (self,minV)
    if minV ~= nil then 
        self.minValue = minV
    end
end

Voice.setJumpLevel = function (self,jumpL)
    if jumpL ~= nil then 
        self.jumpLevel = jumpL
    end
end

Voice.setCurValue = function (self,curV)
    if curV ~= nil then 
        self.curValue = curV
    end
    self:curV2curL()
end

--判断是起跳还是平移
--true为起跳，false为平移
Voice.isJump = function (self)
    if self.curLevel>=self.jumpLevel then 
        print_string("-----------------voice : jump ---------------------")
        return true
    else
        print_string("-----------------voice : translation ---------------------")
        return false
    end
end

Voice.getCurLevel = function (self)
    return self.curLevel
end

Voice.getJumpLevel = function (self)
    return self.jumpLevel
end

--------------private --------------
Voice.curV2curL = function (self)
    if self.curValue>=self.maxValue then
        self.curLevel = self.maxLevel
    elseif self.curValue <=self.minValue then
        self.curLevel = self.minLevel
    else 
        self.curLevel = (self.curValue-self.minValue)/(self.maxValue-self.minValue)*(self.maxLevel-self.minLevel)+self.minLevel
    end
end
--endregion
