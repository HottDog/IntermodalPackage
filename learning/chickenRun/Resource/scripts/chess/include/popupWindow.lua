-- popupWindow.lua
-- Author: ChaoYuan
-- Date:   2017-07-13
-- Last modification : 2017-07-13
-- Description: 悬浮窗，区别于弹窗
require("gameBase/gameLayer")
require("ui/image")

PopupWindow = class(GameLayer,false)

PopupWindow.ARROW_TOP_WIDTH =30      --上下弹窗时指示箭头的宽
PopupWindow.ARROW_TOP_HEIGHT = 20
PopupWindow.ARROW_LEFT_WIDTH = 20    --左右弹窗时指示箭头的高
PopupWindow.ARROW_LEFT_HEIGHT = 30 

PopupWindow.SHOWING = 1
PopupWindow.HIDE = 0 

PopupWindow.ARROW_TOP_FILE = "common/icon/tips_arrow_top.png"
PopupWindow.ARROW_BOTTOM_FILE = "common/icon/tips_arrow_bottom.png"

--箭头与依赖的view的间距
PopupWindow.ARROW_SPACING_RELY = 5
function PopupWindow.ctor(self,viewConfig,view)
    super(self,viewConfig)
    if not self.m_root then 
        self.m_root = new (Node)
    end 
    self.m_root:setAlign(kAlignTopLeft)
    self:setAlign(kAlignTopLeft)
    --依赖的view
    self.m_rely_view = view
    --箭头指示
    self.m_arrow = new(Image)
    self.m_arrow:setAlign(kAlignBottomLeft)
    self:addChild(self.m_arrow)
    --初始化悬浮窗的状态为隐藏
    self.m_status = PopupWindow.HIDE
    self:setVisible(true)
    self:initAnim()
    self.mWidth ,self.mHeight = self.m_root:getSize()
    self.m_scaleValue = 0
end 

function PopupWindow.dtor(self)
    delete(self.mAnim)
end 

function PopupWindow.show(self)
    self:startAnim()
end 

function PopupWindow.dismiss(self)
    self:startAnim()
end 

--通过箭头的位置在所依赖的view和弹窗内容root宽度上的比例，来定箭头的具体位置
--参数说明
-- rely_pro  箭头的位置在所依赖的view的宽度比例
-- root_pro  箭头的位置在弹窗内容root的宽度比例
function PopupWindow.setProportion(self,rely_pro,root_pro)
    if rely_pro then 
        self.m_rely_pro = rely_pro
    else
        self.m_rely_pro = 0.5
    end 
    if root_pro then 
        self.m_root_pro = root_pro
    else 
        self.m_root_pro = 0.5
    end 
    self:setArrowImg()
    self:initPos()
end 

--先要设置root的宽高
function PopupWindow.initPos(self)
    local x,y = self.m_rely_view:getAbsolutePos()
    local sw,sh = self.m_rely_view:getSize()
    local width,height = self.m_root:getSize()
    local absolute_arrow_x , absolute_arrow_y
    absolute_arrow_x = x + self.m_rely_pro * sw
    absolute_arrow_y = y - PopupWindow.ARROW_SPACING_RELY - self.m_arrow_height
    --悬浮窗的pos
    self.m_self_x = absolute_arrow_x - width * self.m_root_pro
    self.m_self_y = absolute_arrow_y - height
    --设定好悬浮窗的位置
    self:setPos(self.m_self_x,self.m_self_y)
    --箭头的位置
    self.m_arrow:setPos(width * self.m_root_pro, -self.m_arrow_height)
end 

function PopupWindow.setArrowImg(self,kind)
    self.m_arrow_file = PopupWindow.ARROW_BOTTOM_FILE
    self.m_arrow:setFile(self.m_arrow_file)
    self.m_arrow_width = PopupWindow.ARROW_TOP_WIDTH
    self.m_arrow_height = PopupWindow.ARROW_TOP_HEIGHT
    self.m_arrow:setSize(self.m_arrow_width,self.m_arrow_height)
end 

--出现的动画
function PopupWindow.showAnimation(self)
    self:topPopShowAnim()
end 

--消失的动画
function PopupWindow.dismissAnimation(self)
    
end 
require("core/anim")
function PopupWindow.initAnim(self)
    self.mAnim = new (AnimDouble, kAnimRepeat, 0, 1, 2500, 0)   
    self.mAnim:setPause(true)
    self.mAnim:setEvent(self,self.animEvent) 
end 

function PopupWindow.startAnim(self)
    self.mAnim:setPause(false)
end 
                             
function PopupWindow.stopAnim(self)
    self.mAnim:setPause(true)
end 
                  
function PopupWindow.animEvent(self) 
       
    if self.m_status == PopupWindow.SHOWING then 
        if self.m_scaleValue == 0 then 
            self:hideAnimBegin()
        end 
        --执行的动画效果
        self:topPopDismissAnim()
        if self.m_scaleValue >= 0.9 then 
            self:hideAnimEnd()
        end 
    else 
        if self.m_scaleValue == 0 then 
            self:showAnimBegin()
        end 
        --执行的动画效果
        self:topPopShowAnim()
        if tonumber(self.m_scaleValue) >= 0.9 then 
            self:showAnimEnd()
        end 
    end 
    self.m_scaleValue = self.m_scaleValue + 0.1
    if self.m_scaleValue >= 1 then 
        self.m_scaleValue = 0
    end 
    
end 

function PopupWindow.showAnimBegin(self)
    self:setVisible(true)
    
        
end 

function PopupWindow.hideAnimBegin(self)
    
end 

function PopupWindow.showAnimEnd(self)
    self:stopAnim()   
    self.m_status = PopupWindow.SHOWING
end 

function PopupWindow.hideAnimEnd(self)
    self:stopAnim() 
    self.m_status = PopupWindow.HIDE
    self:setVisible(true)
end 

function PopupWindow.topPopShowAnim(self)
    self:enlarge(self.m_scaleValue)
    self:shiftUp(self.m_scaleValue,self.mWidth * self.m_root_pro,self.mHeight)
end 

function PopupWindow.topPopDismissAnim(self)
    self:narrow(self.m_scaleValue)
    self:down(self.m_scaleValue,self.mWidth * self.m_root_pro,self.mHeight)
end 

--比例缩小动画
function PopupWindow.narrow(self,scaleValue)
    self.m_root:setSize(self.mWidth*(1-scaleValue),self.mHeight*(1-scaleValue))
end 

--比例放大动画
function PopupWindow.enlarge(self,scaleValue)
    self.m_root:setSize(self.mWidth*scaleValue,self.mHeight*scaleValue)
end 

--上方弹窗时，弹出的位移动画
function PopupWindow.shiftUp(self,scaleValue,distanceW,distanceY)
--    self.m_root:setPos(self.m_self_x+distanceW*(1-scaleValue),self.m_self_y+distanceY*(1-scaleValue))
end 

--上方弹窗时，收回的位移动画
function PopupWindow.down(self,scaleValue,distanceW,distanceY)
    self.m_root:setPos(self.m_self_x-distanceW*scaleValue,self.m_self_y-distanceY*scaleValue)
end 
