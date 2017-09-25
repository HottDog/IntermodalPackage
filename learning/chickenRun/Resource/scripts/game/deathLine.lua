--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
DeathLine=class()

DeathLine.ctor=function (self)
    self.y=710
end

DeathLine.dtor=function (self)

end

DeathLine.setDeathY=function (self,y)
    self.y=y
end

DeathLine.isDeath=function (self,x,y)
    if y>=self.y then 
        return true
    else
        return false
    end
end
--endregion
