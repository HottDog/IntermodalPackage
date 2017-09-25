--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("core/object") 
require("activity/activityBase")
require("game/gameConstant")
require("activity/groud")
require("core/gameString")
require("game/map1")
require("ui/slider")
require("activity/mapView")
require("activity/chickenView")
require("data/userData")
require("activity/changeSceneAnimView")
--积分字体颜色：255 241 0

function getVoiceValue()
    voice = dict_get_int("voice", "voiceValue", 0)
end

GameActivity=class(ActivityBase,false)

GameActivity.animValue = 
{  
    SENSITIVITY = 1;
    SENS_VECTOR = 5 ; 
}

GameActivity.ctor=function (self,controler,user)
    self.controler=controler
    if user then 
        self.tourist = user 
    else 
        self.tourist = new (Tourist)
        self.tourist:login()
    end
    super(self) 
end

GameActivity.dtor=function (self)
    if self.anim then 
        delete(self.anim)
    end
    if self.sensAnim then 
        delete(self.sensAnim)
    end 
end 

GameActivity.create = function (self)
    --暂停的锁，true的话暂停键就失效，false才生效    
    self.pause_lock=true
    self.set_lock=true
    --初始化数据
    self:initData()
    self:initHttpData()
--    local chickenRes1=new(ResImage)
    --[[local text=new(Text)
    text:setText("开始游戏", 100, 50, 255 ,0 ,0)
    local textBn=new(Button)
    textBn:setSize(200,100)
    textBn:setPos(100,100)
    textBn:addChild(text)
    self:addChild(textBn)
    print_string("end  ")
    --]]
    -----
    
    --local chickenRes1=new(ResImage,"1.png")
    --local chickenRes2=new(ResImage,"2.png")
--背景
    self.mapImage = new (MapView , self.map )
    self:addChild(self.mapImage)
    self:drawMap()
    --目前小鸡跑了多长时间
    --self.chickenRunTotalTime=0
    self.chickenImage=new(ChickenView,self.chicken)
    --self.chickenImage:addImage( chickenRes1,1)
    self:addChild(self.chickenImage)
--积分画面
    --[[self.bestScoreLabel = new (Text,GameString.convert2UTF8("历史纪录："), 60, 30, align, fontName, 30, 0, 0, 0)
    self.bestScoreLabel:setPos(10,10)
    self:addChild(self.bestScoreLabel)

    self.bestScoreText = new (Text,"0", 40, 35, align, fontName, 35, 0, 0, 0) 
    self.bestScoreText:setPos(160,8)
    self.bestScoreText:setText(self.game:getBestScore())
    self:addChild(self.bestScoreText)
    --]]
    --[[
    self.scoreLable = new (Text,GameString.convert2UTF8("分数："),40, 40, align, fontName, 30, 118 ,238, 0)
    self.scoreLable:setPos(590,50)
    self:addChild(self.scoreLable)

    self.scoreText = new (Text,"0", 40, 35, align, fontName,40, 118, 238 ,0)
    self.scoreText:setPos(670,46)
    self:addChild(self.scoreText) 
    ]]--
--积分画面
    --积分
    self.scoreImage = new (Image , "score.png")
    self:addChild(self.scoreImage)
    self.scoreImage:setPos(40,25)
    self.scoreImage:setSize(180,60)

    self.scoreText = new (Text,"0", 25, 35, align, fontName,25, 255 ,241, 0)
    self.scoreImage:addChild(self.scoreText)
    self.scoreText:setPos(120,15)

    --砖石
    self.diamonImage = new (Image , "diamon.png")
    --self:addChild(self.diamonImage)
    self.diamonImage:setPos(250,25)
    self.diamonImage:setSize(150,40)

    self.diamonText = new (Text,"0", 25, 35, align, fontName,23, 255 ,241, 0)
    self.diamonImage:addChild(self.diamonText)
    self.diamonText:setPos(100,2)

    --设置灵敏度
    self.sensPosX = 10
    self.sensPosY = 0
    self.setBnLock = false 
    
    self.setNode = new (Node)
    self:addChild(self.setNode)
    self.setNode:setPos(0,100)
    self.setNode:setSize(60,180)
    self.setNode:setClip(0,180,60,300)
       
    self.sensitivitySlide = new (Slider , 40, 180,"set_nor_bg.png","set_bg.png","set_point.png")
    self.setNode:addChild(self.sensitivitySlide)
    self.sensitivitySlide:setImages("set_nor_bg.png","set_bg.png","set_point.png")
    self.sensitivitySlide:setPos(self.sensPosX , self.sensPosY )
    self.sensitivitySlide:setSize(40,180)

    self.sensitivitySlide:setProgress2(self.voice.jumpLevel/100)
    self.sensitivitySlide:setOnChange(self , function (self,progress)
        local temp = progress  
        if temp == 0 then 
            temp = 0.01
        elseif temp == 1 then 
            temp = 0.99
        end 
        self.voice:setJumpLevel(100*temp)
    end)
    self:initSensAnim()

    self.setBn = new (Button , "set.png")
    self:addChild(self.setBn)
    self.setBn:setPos(0,130)
    self.setBn:setSize(60,150)
    self.setBn:setOnClick(obj , function ()
        self:showSet()
       end )
--游戏暂停画面
    self.pauseNode = new(Node)
    self:addChild(self.pauseNode)
    self.pauseNode:setPos(470,150)
    self.pauseNode:setVisible(false)

    self.pauseImage = new (Image , "pausepic.png")
    self.pauseImage:setSize(180,80)
    self.pauseImage:setPos(80,0)
    self.pauseNode:addChild(self.pauseImage)

    self.pauseHomeBn = new (Button , "back.png")
    self.pauseHomeBn:setSize(80,80)
    self.pauseHomeBn:setPos(0,130)
    self.pauseNode:addChild(self.pauseHomeBn)
    self.pauseHomeBn:setOnClick(obj,function ()
            self:back()
        end)

    self.pauseRestartBn = new (Button , "restart.png")
    self.pauseRestartBn:setSize(80,80)
    self.pauseRestartBn:setPos(130,130)
    self.pauseNode:addChild(self.pauseRestartBn)
    self.pauseRestartBn:setOnClick(obj,function ()
            self:restart()
        end)

    self.pauseContinueBn = new (Button,"continue.png")
    self.pauseContinueBn:setSize(80,80)
    self.pauseContinueBn:setPos(260,130)
    self.pauseNode:addChild(self.pauseContinueBn)
    self.pauseContinueBn:setOnClick(obj,function ()
            self:continue()
        end)
    
    self.pauseHomeLabel = new(Text,GameString.convert2UTF8("home"), 40, 30, align, fontName, 27, 255, 0, 0)
    self.pauseHomeLabel:setPos(15,230)
    self.pauseNode:addChild(self.pauseHomeLabel)

    self.pauseRestartLabel = new(Text,GameString.convert2UTF8("retry"), 40, 30, align, fontName, 27, 50,205 ,50)
    self.pauseRestartLabel:setPos(137,230)
    self.pauseNode:addChild(self.pauseRestartLabel)

    self.pauseContinueLable = new (Text,GameString.convert2UTF8("continue"), 40, 30, align, fontName, 27, 255, 255 ,0)
    self.pauseContinueLable:setPos(250,230)
    self.pauseNode:addChild(self.pauseContinueLable)
--游戏结束画面
    self.gameoverNode = new(Node)
    self:addChild(self.gameoverNode)
    self.gameoverNode:setPos(500,150)
    self.gameoverNode:setVisible(false)

    self.gameoverImage = new(Image,"gameover.png")
    self.gameoverImage:setSize(300,240)
    self.gameoverImage:setPos(0,0)
    
    self.gameoverNode:addChild(self.gameoverImage)

    self.resultScoreText=new (Text,"0", 40, 35, align, fontName, 35, 0, 0, 0)
    self.resultScoreText:setPos(175,105)
    self.gameoverImage:addChild(self.resultScoreText)

    self.backLable = new(Text,GameString.convert2UTF8("home"), 40, 30, align, fontName, 27, 255, 0, 0)
    self.backLable:setPos(55,330)
    self.gameoverNode:addChild(self.backLable)

    self.restartLabel = new(Text,GameString.convert2UTF8("retry") ,40, 30, align, fontName, 27, 50,205 ,50)
    self.restartLabel:setPos(185,330)
    self.gameoverNode:addChild(self.restartLabel)

    self.backBn = new (Button , "back.png")
    self.backBn:setSize(70,70)
    self.backBn:setPos(50,250)
    self.gameoverNode:addChild(self.backBn)
    self.backBn:setOnClick(obj,function ()
            self:back()
        end)

    self.restartBn = new (Button , "restart.png")
    self.restartBn:setSize(70,70)
    self.restartBn:setPos(180,250)
    self.gameoverNode:addChild(self.restartBn)
    self.restartBn:setOnClick(obj,function ()
            self:restart()
        end)
--过关画面
    self.winNode = new(Node)
    self:addChild(self.winNode)
    self.winNode:setPos(500,150)
    self.winNode:setVisible(false)

    self.winImage = new(Image,"win.png")
    self.winImage:setSize(300,240)
    self.winImage:setPos(0,0)
    
    self.winNode:addChild(self.winImage)

    self.winScoreText=new (Text,"0", 40, 35, align, fontName, 35, 0, 0, 0)
    self.winScoreText:setPos(175,97)
    self.winImage:addChild(self.winScoreText)

    self.winBackLable = new(Text,GameString.convert2UTF8("主页"), 40, 30, align, fontName, 30, 255, 0, 0)
    self.winBackLable:setPos(55,330)
    self.winNode:addChild(self.winBackLable)

    self.winRestartLabel = new(Text,GameString.convert2UTF8("再来") ,40, 30, align, fontName, 30, 50,205 ,50)
    self.winRestartLabel:setPos(185,330)
    self.winNode:addChild(self.winRestartLabel)

    self.winBackBn = new (Button , "back.png")
    self.winBackBn:setSize(70,70)
    self.winBackBn:setPos(50,250)
    self.winNode:addChild(self.winBackBn)
    self.winBackBn:setOnClick(obj,function ()
            self:back()
        end)

    self.winRestartBn = new (Button , "restart.png")
    self.winRestartBn:setSize(70,70)
    self.winRestartBn:setPos(180,250)
    self.winNode:addChild(self.winRestartBn)
    self.winRestartBn:setOnClick (obj,function ()

            self:restart()
        
        end)


--暂停按钮
    self.pauseBn = new (Button,"pause.png")
    self.pauseBn:setSize(60,60)
    self.pauseBn:setPos(1170,25)
    self:addChild(self.pauseBn)
    self.pauseBn:setOnClick(obj,function ()
            if self.pause_lock then
                 
            else
                 self:pause()
            end
        end)
--设置按钮
    --[[self.setBn = new (Button , "set.png")
    self.setBn:setSize(100,50)
    self.setBn:setPos(1130,50)
    --self:addChild(self.setBn)
    self.setBn:setOnClick(obj , function ()
            if self.set_lock then 
            else
                self:set()
            end
        end)
    ]]--
    --音量
    self.voiceText = new (Text,"0",40, 35, align, fontName,40, 118, 238 ,0);
    self.voiceText:setSize(50,50)
    self.voiceText:setPos(300,300)
    --self:addChild(self.voiceText)
    --屏幕遮罩
    self.changeImage = new(ChangeSceneAnimView)
    self:addChild(self.changeImage)
--定义计时器
    self.anim=new(AnimInt,kAnimLoop, 0, 4,self.game:getChickenFootSpeed(), 1)
    self:time()
    --[[rec1=new(Rectangle,0,0,100,100)
    rec2=new(Rectangle,100,99,567,890)
    if rec1:rectangularIntersecte(rec2) then
        print_string("-----------yes----------")
    else
        print_string("-----------no-----------")
    end]]--
end

--初始化数据
GameActivity.initData = function (self)
--测试
    self.time1=0
    --数据
    
    self.map = new (Map1)
    self.voice = new (Voice)
    self.speed = new (Speed)      
    self.chicken = new (Chicken)
    self.game = new (Game,self.map,self.tourist,self.chicken,self.voice,self.speed)
end

function GameActivity.initHttpData(self)
    
    
end 
--计时器,定义好协程
GameActivity.time=function (self)
    local co=coroutine.create(function ()
        while true do
            --direction = coroutine.yield("hallo")
            --通过resume传入参数
            --direction = coroutine.yield()
            --获取音量大小
            --local voice=math.random(gameVoice.level.MAX)
            --self.voiceText:setText(voice)


            local temp = self.game:control(voice)
            --local temp = self.game:control(math.random(2600,3200))
            if  temp == gameResult.GAMEOVER then
                self:gameover()
            elseif temp == gameResult.WIN then 
                self:win()
            else
                print_string("---------------------DRAWING ANIM------------------------")
                self:chickenRun()
                self:mapMove()
                self:updateMoveBody()
                print_string("--------------score:"..self.game:getScore().."------------------------")
                self.scoreText:setText(self.game:getScore())
            end
            coroutine.yield()
        end
    end)
    
    self.anim:setEvent(obj,function ()
        --print_string(self.snake:getDirection())
--        gameContorll(snake:getDirection())
        coroutine.resume(co)
        
        --获得yield返回的参数
        --[[local ret = {coroutine.resume(co,snake:getDirection())}
        for i,v in pairs(ret) do
            if tostring(v) and type(v) ~= "boolean" then
                print_string( string.format("key:%s val:%s",i,v) )
            end
        end--]]
    end)
    self.anim:setPause(true)
end 

--定义控制灵敏度动画的anim
GameActivity.initSensAnim = function (self)
    self.sensAnim = new (AnimInt , kAnimLoop , 0, 1 , GameActivity.animValue.SENSITIVITY , 1)
    self.hideSensOrNot = false
    self.sensAnim:setEvent(obj , function ()
        self:sensAnimEvent()
    end)
    self.sensAnim:setPause(true)
end

--定义灵敏度的拉出和隐藏动画
GameActivity.sensAnimEvent = function (self)
    self.sensitivitySlide:setPos(self.sensPosX , self.sensPosY)
    if self.hideSensOrNot then 
        self.sensPosY = self.sensPosY - GameActivity.animValue.SENS_VECTOR
        
    else 
        self.sensPosY = self.sensPosY + GameActivity.animValue.SENS_VECTOR
    end 
    self:sensAnimation()
end

GameActivity.sensAnimation = function (self)
    if self.sensPosY < - 16 then 
        self.sensPosY = self.sensPosY + GameActivity.animValue.SENS_VECTOR
        self.sensAnim:setPause(true)
        self.hideSensOrNot = false
        self.setBnLock = false 
    elseif self.sensPosY > 178 then 
        self.sensPosY = self.sensPosY - GameActivity.animValue.SENS_VECTOR
        self.sensAnim:setPause(true)
        self.hideSensOrNot = true 
        self.setBnLock = false 
    end
end 

--游戏控制
GameActivity.begin = function (self)
    self.anim:setPause(false)
    self.pause_lock=false
    self.set_lock=false
    self:restart()
end

GameActivity.pause = function (self)
    self.anim:setPause(true)
    self.pauseNode:setVisible(true)
    self.set_lock=true
end

GameActivity.continue = function (self)
    self.anim:setPause(false)
    self.pauseNode:setVisible(false)
    --self.setNode:setVisible(false)
    self.pause_lock=false
    self.set_lock=false
    
end

GameActivity.restart = function (self)
    self.game:restart()
    self.anim:setPause(false)
    self.gameoverNode:setVisible(false)
    self.pauseNode:setVisible(false)
    self.winNode:setVisible(false)
    self.pause_lock=false
    self.set_lock=false
    self.mapImage:changeScene()
end

GameActivity.back = function (self)
    self.game:restart()
    self.anim:setPause(true)
    self.gameoverNode:setVisible(false)
    self.pauseNode:setVisible(false)
    self.winNode:setVisible(false)
    self.controler:backToHome()

end

GameActivity.pauseBack = function (self)
    self.anim:setPause(true)
    self.gameoverNode:setVisible(false)
    self.pauseNode:setVisible(true)
    self.winNode:setVisible(false)
    self.controler:backToHome()
end

GameActivity.gameover = function (self)
    self.anim:setPause(true)
    self.gameoverNode:setVisible(true)
    self.scoreText:setText(self.game:getScore())
    self.resultScoreText:setText(self.game:getScore())
    self.pause_lock=true
    self.set_lock=true
end

GameActivity.win = function (self)
    self.anim:setPause(true)
    self.mapImage:setVisible(false)
    self.chickenImage:setVisible(false)
    --self.winNode:setVisible(true)
    --self.winScoreText:setText(self.game.time)
    self.pause_lock=true
    self.set_lock=true
    --播放切换动画
    self.changeImage:start(self.anim,self.mapImage,self.chickenImage)
    self.game:clean()
    self.map:changeScene()
    self.mapImage:changeScene()
end

GameActivity.set=function (self)
    self.anim:setPause(true)
    self.setNode:setVisible(true)
    self.pause_lock=true
end

--灵敏度的弹窗动画
GameActivity.showSet = function (self)
    if self.setBnLock then 
    else 
        self.setBnLock = true 
        self.sensAnim:setPause(false)
        
    end
end

--绘制背景地图
GameActivity.drawMap = function (self)
    
end
--奔跑吧小鸡
GameActivity.chickenRun=function (self)
    --print_string("the value of anim:"..self.anim:getCurValue())
    self.chickenImage:updatePos()
    self.chickenImage:changeSkinWithIndex(self.anim:getCurValue())
end

GameActivity.mapMove = function (self)
    --self.time1=self.time1+1
    --self.mapImage:setPos(-self.time1*10,self.map:getY())
    --print_string("map move begin!!!!!!!!")
    self.mapImage:updatePos()
    --print_string("map move over!!!!!!!!")
end

function GameActivity.updateMoveBody(self)
    self.mapImage:update()
end 


--endregion
