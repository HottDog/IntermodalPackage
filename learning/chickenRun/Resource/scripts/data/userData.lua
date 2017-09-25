-- userData.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: 用户数据
require("data/httpExcutor")
require("libs/json")
require("libs/dkjson")
require("libs/json_wrap")
require("core/system")

UserData = class()

UserData.REQUESR_CMD = "Login.userLogin"

function UserData.ctor(self)
    self.httpExcutor = new (HttpExcutor)
    self:setHttpRequestData()
    self.httpExcutor:setEvent(self,self.httpCallBack)
    self.data = {}
    self.mid = 0
    self.score = 0
    self.bnClicks = 0
    self.firstUse = 0  --表示第一次玩
end 

function UserData.dtor(self)
    if self.httpExcutor then 
        delete(self.httpExcutor)
    end 
    if self.commitHttpExcutor then 
        delete(self.commitHttpExcutor)
    end 
end 

function UserData.requestHttpData(self)
    self.httpExcutor:excute()
end 

UserData.httpCallBack = function (self ,httpRequest)
    repeat 
		-- 判断http请求的错误码,0--成功 ，非0--失败.
		-- 判断http请求的状态 , 200--成功 ，非200--失败.
		if 0 ~= httpRequest:getError() or 200 ~= httpRequest:getResponseCode() then
			--errorCode = HttpErrorType.NETWORKERROR;
			break;
		end
	
		-- http 请求返回值
		local resultStr =  httpRequest:getResponse();
		

		--Log.i("resultStr:"..resultStr);


		-- http 请求返回值的json 格式
		--local json_data = json.decode_node(resultStr);
        local json_data = json.decode(resultStr);
		--返回错误json格式.
	    --if not json_data:get_value() then
	    	--errorCode = HttpErrorType.JSONERROR;
			--break;
	    --end
        self:checkData(json_data)
	until true;
end 

function UserData.setHttpRequestData(self)
    --local post_data={}
    local param = {}
    param.method = UserData.REQUESR_CMD
    param.loginType = 1
    self.httpExcutor:setData(param)
end 

function UserData.checkData(self,data)
    if not data then 
        return 
    end 
    for k,v in pairs(data.data) do 
        self.data[k] = v
    end    
    self.mid = tonumber(self.data.mid) or 0
    local score = tonumber(self.data.score)or 0
    self:setBestScore(score)
    self:commit()
end 

function UserData.checkCommitData(self,data)
    if not data then 
        return 
    end 
    local temp ={}
    for k,v in pairs(data.data) do 
        temp[k] = v
    end
    local mark = tonumber(temp.mark) or 0
    if mark == 1 then 
        --提交成功
        self.bnClicks = 0
        self:saveData(nil , self.bnClicks)
    end 
end 

function UserData.setBestScore(self,score)
    if self.score < score then 
        if self.score ~= 0 then 
            self:commit()
        end 
        self.score = score 

    end 
end 

function UserData.getBestScore(self)
    return self.score
end 
function UserData.commit(self)
    self.commitHttpExcutor = new (HttpExcutor)
    local postData={}
    postData.gid = 3
    postData.uuid = System.getGuid()
    postData.param = {}
    postData.param.mid = self.mid
    postData.param.method = "User.updateGameInfo"
    postData.param.score = self.score
    postData.param.startBtnNum = self.bnClicks
    local str = json.encode(postData)
    self.commitHttpExcutor:setAllData(str)
    self.commitHttpExcutor:setEvent(self,self.commitHttpCallBack)
    self.commitHttpExcutor:excute()
end 

UserData.commitHttpCallBack = function (self ,httpRequest)
    repeat 
		-- 判断http请求的错误码,0--成功 ，非0--失败.
		-- 判断http请求的状态 , 200--成功 ，非200--失败.
		if 0 ~= httpRequest:getError() or 200 ~= httpRequest:getResponseCode() then
			--errorCode = HttpErrorType.NETWORKERROR;
			break;
		end
	
		-- http 请求返回值
		local resultStr =  httpRequest:getResponse();
		

		--Log.i("resultStr:"..resultStr);


		-- http 请求返回值的json 格式
		--local json_data = json.decode_node(resultStr);
        local json_data = json.decode(resultStr);
		--返回错误json格式.
	    --if not json_data:get_value() then
	    	--errorCode = HttpErrorType.JSONERROR;
			--break;
	    --end
        self:checkCommitData(json_data)
	until true;
end 
 
 function UserData.addBnClicks(self,data)
    if data then 
        self.bnClicks = self.bnClicks +data 
    else 
        self.bnClicks = self.bnClicks + 1
    end 
 end 

 function UserData.saveLocalData(self)
    self:saveData(self.score,self.bnClicks)
 end 
 -----本地文件数据保存--------
function UserData.saveData(self,score,bnClicks)
    local dict=new (Dict,"game_data")
    if score then 
        dict:setInt("best",score)
    end 
    if bnClicks then 
        dict:setInt("bnClicks",bnClicks)
    end 
    dict:setInt("firstUse",1)
    dict:save()
end 

function UserData.readData(self)
    local dict=new (Dict,"game_data")
    dict:load()
    local score=dict:getInt("best")
    self:setBestScore(score)
    local bnClicks = dict:getInt("bnClicks")
    self:addBnClicks(bnClicks)
    self.firstUse = dict:getInt("firstUse")
end 