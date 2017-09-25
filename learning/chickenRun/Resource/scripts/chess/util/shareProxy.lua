ShareProxy = class()
ShareProxy.TYPE_PYQ             = 1;
ShareProxy.TYPE_WEICHAT         = 2;
ShareProxy.TYPE_QQ              = 3;
ShareProxy.TYPE_SMS             = 4;


function ShareProxy.ctor(self)
    self.mShareSwitch = {};
end

function ShareProxy.setShareSwitch(self,params)
    if type(params) == "table" then
        self.mShareSwitch = params;
    end
end

function ShareProxy.getShareSwitch(self)
    return self.mShareSwitch;
end


function ShareProxy.shareToPYQ(self,params)
    if not self:checkParams(params) then return end
end

function ShareProxy.checkParams(self,params)
    if type(params) ~= "table" then
        print("ShareProxy.checkParams : params is error");
        return false;
    end



    return true;
end