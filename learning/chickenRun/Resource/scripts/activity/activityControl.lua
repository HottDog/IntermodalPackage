--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("core/object") 
require("activity/gameActivity")
require("activity/homeActivity")
require("game/tourist")

ActivityControler=class()

ActivityControler.ctor=function (self)
    --print_string("000000")
    self.tourist = new (Tourist)
    self.tourist:login()
    self.homeActivity = new (HomeActivity,self,self.tourist)
    self.gameActivity = new (GameActivity,self,self.tourist)
    self.gameActivity:setVisible(false)
end

ActivityControler.dtor=function (self)

end

ActivityControler.goTo = function (self)
    self.homeActivity:setVisible(false)
    
    self.homeActivity.gameMusic:pauseMusic()

    self.gameActivity:setVisible(true)
    self.gameActivity:begin()
end

ActivityControler.backToHome = function (self)
    self.gameActivity:setVisible(false)
    self.homeActivity:setVisible(true)
    if self.homeActivity.hasSound then
        self.homeActivity.gameMusic:resumeMusic()
    end
end
--endregion
