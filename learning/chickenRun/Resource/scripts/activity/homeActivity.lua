--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("core/object") 
require("core/sound")
require("activity/activityBase")
require("activity/activityConstant")
require("core/systemEvent")
require("core/system")
require("core/eventDispatcher")
HomeActivity = class(ActivityBase,false)

HomeActivity.ctor = function (self,activityControler,user)
    if activityControler ~=nil then
        self.activityControler=activityControler
    else
        self.activityControler = new (ActivityControler)
    end 
    if user then 
        self.user = user 
    end 
    super(self)
end

HomeActivity.dtor = function (self)
    EventDispatcher:getInstance():unregister(Event.Back,self,self.onBackPress)
end

HomeActivity.create = function (self)
    --初始化声音资源
    self.gameMusic=new (Sound)
    self.gameMusic.playMusic("chicken.mp3",true)
    self.gameMusic:resumeMusic()
    --首页的背景图片
    self.backgroundImage = new(Image,homeActivity.BGPIC)
    self.backgroundImage:setPos(0,0)
    self.backgroundImage:setSize(1280,720)
    self:addChild(self.backgroundImage)
    --开始游戏的按钮
    self.beginBn = new (Button,homeActivity.BNPIC_NOPRESS)
    self.beginBn:setPos(450,325)
    self.beginBn:setSize(400,150)
    self:addChild(self.beginBn)
    self.beginBn:setOnClick(obj,function ()
        if self.user then 
            self.user:addClicks()
        end 
        self.activityControler:goTo()
    end)

    --声音控制按钮
    self.hasSound = true
    self.soundBn = new(Button,"sound_yes.png")
    self.soundBn:setSize(85,90)
    self.soundBn:setPos(1160,40)
    self.soundBn:setOnClick(obj,function ()
             if self.hasSound then
                 self.hasSound=false
                 self.soundBn:setFile("sound_no.png")
                 self.gameMusic:pauseMusic()
             else
                 self.hasSound=true
                 self.soundBn:setFile("sound_yes.png")
                 self.gameMusic:resumeMusic()
             end
         end)
     self:addChild(self.soundBn)
     --帮助弹窗
     self.helpLock = false
     self.helpImage = new(Image, "help_content.png")
     self:addChild(self.helpImage)
     self.helpImage:setSize(700,450)
     self.helpImage:setPos(300,110)
     self.helpImage:setVisible(false)
     self.chaBn = new(Button,"cha.png")
     self.chaBn:setSize(40,40)
     self.chaBn:setPos(620,30)
     self.chaBn:setOnClick(obj,function ()
            self.helpImage:setVisible(false)
            self.helpLock = false
        end )
     self.helpImage:addChild(self.chaBn)
     --帮助按钮
     
     self.helpBn = new(Button , "help.png")
     self.helpBn:setSize(85,90)
     self.helpBn:setPos(1160,150)
     self.helpBn:setOnClick(obj ,function ()
         if self.helpLock then 
             self.helpLock = false 
             self.helpImage:setVisible(false)
         else 
             self.helpLock = true 
             self.helpImage:setVisible(true)
         end 
     end )
     self:addChild(self.helpBn)

     --游戏结束的弹窗
     self.endGameImage = new (Image , "endgame.png")
     self.endGameImage:setSize(600,400)
     self.endGameImage:setPos(350,130)
     self:addChild(self.endGameImage)
     self.endGameImage:setVisible(false)
     self.yesBn = new (Button , "yes.png")
     self.yesBn:setSize(180,60)
     self.yesBn:setPos(80,300)
     self.yesBn:setOnClick(obj,function ()
            sys_exit();
        end )
     self.endGameImage:addChild(self.yesBn)
     
     self.noBn = new(Button , "no.png")
     self.noBn:setSize(180,60)
     self.noBn:setPos(350,300)
     self.noBn:setOnClick(obj,function ()
            self.endGameImage:setVisible(false)
            self.beginBn:setVisible(true)
        end )
     self.endGameImage:addChild(self.noBn)
     EventDispatcher:getInstance():register(Event.Back,self,self.onBackPress)    
end
--处理退出游戏返回键的点击事件
function HomeActivity.onBackPress(self)
    self.endGameImage:setVisible(true)
    self.beginBn:setVisible(false)
end 

HomeActivity.setControler = function (self,controler)
    if controler~=nil then 
        self.activityControler=controler
    end
end
--endregion
