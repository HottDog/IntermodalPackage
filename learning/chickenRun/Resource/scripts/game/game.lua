--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("game/map")
require("game/wall")
require("game/tourist")
require("game/voice")
require("game/wallItem")
Game=class()
--------------------------Constant-------------------------------
Game.screen={MAP_MOVE_BEGIN,MAP_MOVE_END}
Game.screen.MAP_MOVE_BEGIN = 640
Game.screen.MAP_MOVE_END = 12560 
-----------------------------------------------------------------

Game.ctor=function (self,map,user,chicken,voice,speed)
    --map
    if map==nil then
        self.map=new (MapBase)
    else
        self.map=map
    end
    --user
    if user==nil then
        self.user=new (User)
    else
        self.user=user
    end
    --chicken
    if chicken==nil then
        self.chicken=new (Chicken)
    else
        self.chicken=chicken
    end
    --voice
    if voice==nil then 
        self.voie = new (Voice)
    else
        self.voice=voice
    end
    --speed
    if speed == nil then 
        self.speed = new (Speed)
    else
        self.speed = speed
    end 
    --score
    self.score=0
    self.time=0
    
end

Game.dtor=function (self)

end

Game.init = function (self)
    --self.score=self.user.getBestScore()
end
--游戏控制，对外提供的游戏控制接口
Game.control = function (self,voice)
    print_string("-----------------------------voice value : "..voice.."---------------------------------")
    self.time=self.time+1
    self.score = math.ceil(self.time/10)
    self.voice:setCurValue(voice)
    --如果之前小鸡是出于平移阶段，则小鸡要考虑是否起跳
    if self.chicken:getState() == chickenState.TRANSLATION then
        --print_string("--------------------------translation------------------------------")       
        self:isJump()
    end
    --设置小鸡和map的平移速度
    self.map:setSpeedX(self.speed:getSpeed(self.voice:getCurLevel(),self.voice:getJumpLevel()).x)
    self.chicken:setSpeedX(self.speed:getSpeed(self.voice:getCurLevel(),self.voice:getJumpLevel()).x)
    print_string("------map:speedX : "..self.map:getSpeedX().."--------")
    --唯一的死亡判断
    if self.chicken:getRightBottomCoordinate().y>=system.HEIGHT then 
        self:gameover()
        return gameResult.GAMEOVER
    end
    --唯一的过关判断
    if self.map:isWin(self.chicken) then 
        return gameResult.WIN
    end 
    --和黑云相撞就死亡
    local otherResult = self.map:isTouchOther(self.chicken)
    if otherResult == MapBase.touchValue.DEATH then 
        self:gameover()
        return gameResult.GAMEOVER
    end 
    --和移动的怪物相撞就死亡
    local moveResult = self.map:isTouchMove(self.chicken)
    if moveResult == MapBase.touchValue.DEATH then 
        self:gameover()
        return gameResult.GAMEOVER
    end 
    --判断游戏当前进行都了哪个阶段
    if self.chicken:getX()<Game.screen.MAP_MOVE_BEGIN then
        print_string("--------------------GAME BEGIN--------------------------------")
        self:begin()
    elseif self.chicken.worldPos.coreCoordinate.x<= Game.screen.MAP_MOVE_END then 
        print_string("--------------------GAMING--------------------------------")
        self:gaming()
    else
        print_string("--------------------GAME OVER--------------------------------")
        self:over()
    end
    print_string("speedX of chicken :"..self.chicken:getSpeedX())
    self.map:updateMoveBody(self.chicken)
    --print_string("x of the chicken :"..self.chicken:getX())
    --print_string("y of the chicken :"..self.chicken:getY())

    --print_string("x of the map :"..self.map:getX())
    --print_string("y of the map ;"..self.map:getY())
    --死亡判断,分两步，
    --第一步是矩形相交，
    --第二步是小鸡的中心离绿地的最上边的距离是否大于（小鸡1/2的高度-10）
    local chickenIntersectResult = gameResult.CONTINUE
    if self.chicken:getState()~=chickenState.FALL then
        chickenIntersectResult = self:checkChickenState()      
    end
    --小鸡碰撞检测后的游戏状态,主要是为了应对第三种模式
    if chickenIntersectResult == gameResult.GAMEOVER then 
        self:gameover()
        return gameResult.GAMEOVER
    end 
    
    self.map:updateCurIndex(self.chicken)
    return chickenIntersectResult
    --return self:isDeath()
end
--游戏开始阶段
Game.begin=function (self)
    --小鸡移动，背景不动
    self.chicken:moveBegin()
end
--游戏进行阶段
Game.gaming = function (self)
    --小鸡原地踏步，背景移动
    self.chicken:moving()
    self.map:translation()
    --设置小鸡位置的变化
    self.chicken:setMoveWorldPos(self.map:getSpeedX(),y)
    --先判断是否要起跳还是平移
    --[[if self.voice:isJump() then 
    --起跳
        self.chicken:setJumpSpeed(self.speed:getSpeed(self.voice:getCurLevel(),self.voice:getJumpLevel()))
        self.chicken:jumpBegin()
    end
    ]]--
end
--游戏临近结束阶段
Game.over = function (self)
    --背景不动，小鸡动
    self.chicken:moveEnd()
    
end

--检查小鸡是否需要跳跃,这个判断只有在小鸡处于平移阶段才有效，跳跃阶段是无效的
--确定接下来小鸡得到移动状态，然后确定小鸡和地图的移动速度
Game.isJump = function (self)
    if self.voice:isJump() then --true为起跳，false为平移
        self.chicken:setState(chickenState.JUMP)
        
        self.chicken:setJumpSpeed(self.speed:getSpeed(self.voice:getCurLevel(),self.voice:getJumpLevel()).y)
              
    else
        self.chicken:setState(chickenState.TRANSLATION)
        
        
    end
end

--检查小鸡是否死亡，true为死亡，false为存活
Game.checkChickenState = function (self)
    --print_string("-------------------------colision begin--------------")
    local v=self.map:isTouchWall(self.chicken)
    --print_string("-------------------------colision end--------------")
    if self.chicken:getState() == chickenState.TRANSLATION then
        print_string("---------------------TRANSLATION---------------------------------")
        if  v~=nil then           --碰撞 
            if v:isDead(self.chicken) == MapBase.touchValue.NOTHING then  
                return gameResult.CONTINUE
            else 
                return gameResult.GAMEOVER
               --return gameResult.CONTINUE
            end 
        else                        
            --print_string("----------------------dead in translation-----------------------")   
            self.chicken:setState(chickenState.JUMP) 
            self.chicken:setJumpSpeed(0)
            return gameResult.CONTINUE
        end
    elseif self.chicken:getState() == chickenState.JUMP then
        print_string("---------------------JUMP hahhah ---------------------------------")
        if v then             --碰撞
            --[[if (v:getLeftTopCoordinate().y-self.chicken:getCoreCoordinate().y)>(0.5*self.chicken:getHeight()-death.ERROR) then
                print_string("-----------------take off---------------------")

                self.chicken:jumpEnd()
                return false
            else
                print_string("--------------------------dead in jump----------------------------")
                self:gameover()
                return true
            end
            --]]
            --print_string("---------------0 -------------")
            local direc =WallItem.s_intersecteDirection.TOP
            local co = 0
            --print_string("---------------1 -------------")
            direc,co  = v:intersecteDirection(self.chicken)
            --print_string("---------------2 -------------")
            if direc == MapBase.touchValue.DEATH then 
                return gameResult.GAMEOVER
                --return gameResult.CONTINUE
            end 
            if direc == WallItem.s_intersecteDirection.LEFT then 
                print_string("------------------interesect in left---------------------------")
                self.chicken:setState(chickenState.FALL)
                self.chicken:moveX(v:getWorldLeftTopCoordinate().x - self.chicken:getWorldRightBottomCoordinate().x)
                self.chicken:moveY(co - self.chicken:getWorldRightBottomCoordinate().y)
                self.map:stop()
            else
                print_string("------------------interesect in top---------------------------")
                
                self.chicken:moveX(co-self.chicken:getWorldRightBottomCoordinate().x)
                self.chicken:moveY(v:getWorldLeftTopCoordinate().y - self.chicken:getWorldRightBottomCoordinate().y)
                self.chicken:jumpEnd()
            end
            return gameResult.CONTINUE
        else 
           -- print_string("-----------------------------3---------------------")
            return gameResult.CONTINUE
        end
    end
end

--死亡
Game.gameover = function (self)
    self.user:setBestScore(self.score)
    self.user:saveLocalData()
    self.chicken:jumpEnd()
end
--每一个时间单位移动完后要判断小鸡是否踩在墙上
Game.isOnWall = function (self)
    
end

--重新开始
function Game.restart(self)
    self.chicken:restart()
    self.map:restart()
    self.time=0
    self.score = 0
end 

Game.clean = function (self)
    self.chicken:restart()
    self.map:clear()
end


------------------------------------------------
--------------get或者set方法--------------------
------------------------------------------------
Game.setUser=function (self,user)
    if user~=nil then 
        self.user=user
    end
end

Game.setMap=function (self,map)
    if map~=nil then 
        self.map=map
    end
end

Game.setChicken=function (self,chicken)
    if chicken~=nil then 
        self.chicken=chicken
    end
end

Game.setVoice = function (self,voice)
    if voice~=nil then 
        self.voice = voice
    end
end

Game.setSpeed = function (self,speed)
    if speed ~= nil then 
        self.speed = speed
    end
end

Game.setCurVoice = function (self,curV)
    self.voice:setCurValue(curV)
end

Game.getChickenX = function (self)
    return self.chicken:getX()
end

Game.getChickenY = function (self)
    return self.chicken:getY()
end

Game.getMapX = function (self)
    return self.map:getX()
end

Game.getMapY = function (self)
    return self.map:getY()
end

Game.getMapPic = function (self)
    return self.map:getPic()
end

Game.getMapSizeX = function (self)
    return self.map:getSize().x
end

Game.getMapSizeY = function (self)
    return self.map:getSize().y
end
Game.getChickenWidth = function (self)
    return self.chicken:getWidth()
end

Game.getChickenHeight = function (self)
    return self.chicken:getHeight()
end

Game.getChickenSkin = function (self)
    return self.chicken:getSkin()
end

Game.getChickenFootSpeed  = function (self)
    return self.chicken:getFootSpeed()
end

Game.getScore = function (self)
    return self.score
end

Game.getBestScore = function (self)
    return self.user:getBestScore()
end

--endregion
