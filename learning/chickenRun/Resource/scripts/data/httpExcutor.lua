-- httpExcutor.lua
-- Author: ChaoYuan
-- Date:   2017-04-17
-- Last modification : 2017-04-17
-- Description: http«Î«Û
require("core/system")
require("core/http")
require("core/httpRequest")
require("libs/json")
require("libs/dkjson")
require("libs/json_wrap")

HttpExcutor = class()
HttpExcutor.URL = "http://jdcomb.by.com/"

HttpExcutor.ctor = function (self)
    self.timeout = 30000
    self.uuid = System.getGuid()
    self.gameid = 3
    self.http = new (Http,requestType, responseType, HttpExcutor.URL )
    self.http:setTimeout(self.timeout,self.timeout)
    self:initData()
end 

HttpExcutor.dtor = function (self)
    if self.http then 
        delete(self.http)
    end 
end 

function HttpExcutor.setData(self,param)
    if param then 
        for key,v in pairs(param) do 
            self.postData.param[key] = v
        end 
        local str = json.encode(self.postData)
        self.http:setData("api="..str)
    end 
end 

function HttpExcutor.setAllData(self,str)
    self.http:setData("api="..str)
end 

function HttpExcutor.setEvent(self,obj,func)
    self.http:setEvent( obj, func)
end 

function HttpExcutor.excute(self)
    self.http:execute()
end 

function HttpExcutor.initData(self)
    self.postData = {}
    self.postData.gid = self.gameid
    self.postData.uuid = self.uuid
    self.postData.param = {}
end 