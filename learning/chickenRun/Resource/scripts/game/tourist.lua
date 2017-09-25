--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-------游客--------
require("game/user")
require("data/userData")
Tourist=class(User)

Tourist.ctor=function (self)
    self.userData = new (UserData)
end

Tourist.dtor=function (self)
    if self.userData then 
        delete(self.userData)
    end 
end

Tourist.login=function (self)
    self.userData:readData()
    self.userData:requestHttpData()
end

function Tourist.commit(self)
    self.userData:commit()
end 

function Tourist.addClicks(self)
    self.userData:addBnClicks()
end 

function Tourist.setBestScore(self,score)
    self.userData:setBestScore(score)
end 
function Tourist.getBestScore(self)
    return self.userData:getBestScore()
end 

function Tourist.saveLocalData(self)
    self.userData:saveLocalData()
end 
----------------private-----------------
Tourist.readLocalData=function (self)
    self.userData:readData()
end


--endregion
