-- changeSceneAnimView.lua
-- Author: ChaoYuan
-- Date:   2017-04-18
-- Last modification : 2017-04-18
-- Description: 绘制切换场景的动画
require("ui/image")
require("core/anim")
ChangeSceneAnimView = class(Image,false)

ChangeSceneAnimView.DEFAULT_SKINS = {"anim/anim1.png","anim/anim2.png","anim/anim3.png","anim/anim4.png"}
ChangeSceneAnimView.animValue={ CHANGE_SCENE = 200; }
ChangeSceneAnimView.MAX_TIME = 15
ChangeSceneAnimView.ctor = function(self,skins)
    if skins then 
        self.skins = skins
    else 
        self.skins = ChangeSceneAnimView.DEFAULT_SKINS
    end 
    super(self,self.skins[1])
    self.index = 1
    self.time = 0
    self:initView()
    self:initAnim()
    self.parentAnim = nil 
    self.node = nil
    self.chicken = nil
end 

ChangeSceneAnimView.dtor = function(self)
    if self.changeSceneAnim then 
        delete(self.changeSceneAnim)
    end 
end
 
function ChangeSceneAnimView.initView(self)
    self:setPos(0,0)
    self:setSize(1300,800)
    self:setVisible(false)
end 

function ChangeSceneAnimView.initAnim(self)
    self.changeSceneAnim = new (AnimInt , kAnimLoop , 0, 1 , ChangeSceneAnimView.animValue.CHANGE_SCENE , 1)
    self.changeSceneAnim:setEvent(obj,function()
        self:changeSceneEvent()
    end )
    
    self.changeSceneAnim:setPause(true)
end 

function ChangeSceneAnimView.changeSceneEvent(self)
    if self.time < ChangeSceneAnimView.MAX_TIME then 
        self.time = self.time + 1
        if self.index <= #(self.skins) then        
            self:setFile(self.skins[self.index])
            self.index = self.index + 1
        end 
        if self.index > #(self.skins) then 
            self.index = 1
        end 
    else 
        self.changeSceneAnim:setPause(true)
        self:setVisible(false)
        if self.parentAnim then 
            self.parentAnim:setPause(false)
        end 
        if self.node then 
            self.node:setVisible(true)
        end 
        if self.chicken then 
            self.chicken:setVisible(true)
        end 
    end 
end

function ChangeSceneAnimView.start(self, anim,node ,chicken )
    self.parentAnim = anim 
    self.node = node
    self.chicken =chicken
    self:setVisible(true)
    self.changeSceneAnim:setPause(false)
end  