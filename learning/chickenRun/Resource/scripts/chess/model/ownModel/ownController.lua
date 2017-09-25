--region NewFile_1.lua
--Author : BearLuo
--Date   : 2015/4/23

require(BASE_PATH.."chessController")

OwnController = class(ChessController);

OwnController.s_cmds = 
{
    onBack = 1;
    goToMall = 2;
    goToFeedback = 3;
--    getFriendsRank = 4;
    goToChessFriends = 5;
    saveUserInfo    = 6;
};

OwnController.s_sid = {
    phone = 1;
    email = 2;
    weichat = 3;
    xinlang = 10;
    boyaa = 40;
}


OwnController.ctor = function(self, state, viewClass, viewConfig)
	self.m_state = state;
end

OwnController.dtor = function(self)
end

OwnController.resume = function(self)
	ChessController.resume(self);
	Log.i("OwnController.resume");
end

OwnController.pause = function(self)
	ChessController.pause(self);
	Log.i("OwnController.pause");

end

-------------------- func ----------------------------------

OwnController.onBack = function(self)
    StateMachine.getInstance():popState(StateMachine.STYPE_CUSTOM_WAIT);
end

OwnController.onLoginSuccess = function(self,data)
	Log.i("OwnController.onLoginSuccess");
    UserInfo.getInstance():setLogin(true);
    self:updateView(OwnScene.s_cmds.updateUserInfoView);
    MallData.getInstance():getShopData();
    MallData.getInstance():getPropData();
end

OwnController.onLoginFail = function(self,data)
	Log.i("OwnController.onLoginFail");
    ChessToastManager.getInstance():show("登录失败");
end

OwnController.updateUserInfoView = function(self)
    self:updateView(OwnScene.s_cmds.updateUserInfoView);
end

OwnController.goToMall = function(self)
    StateMachine.getInstance():pushState(States.Mall,StateMachine.STYPE_CUSTOM_WAIT);
end

require(MODEL_PATH.."feedback/feedbackState");
OwnController.goToFeedback = function(self)
    FeedbackScene.s_changeState = false;
    StateMachine.getInstance():pushState(States.Feedback,StateMachine.STYPE_CUSTOM_WAIT);
end

OwnController.goToChessFriends = function(self)
    StateMachine.getInstance():pushState(States.Friends,StateMachine.STYPE_CUSTOM_WAIT);
end


--查询单个用户的好友榜排名
OwnController.attentionFriendsCall = function(self)

    local info = {};
    info.target_uid = UserInfo.getInstance():getUid();
    info.uid = UserInfo.getInstance():getUid();

    if info.target_uid == nil or info.uid == nil then --ZHENGYI
        return;
    end
        
    self:sendSocketMsg(FRIEND_CMD_CHECK_PLAYER_RANK,info);
end

--查询单个用户的好友榜排名 callback
OwnController.onRecvServerMsgFriendsRankSuccess = function(self,info)
    if not info then return end   
    self:updateView(OwnScene.s_cmds.updateFriendsRank,info);

end
-- 用户数据更新
OwnController.onUpdateUserData = function(self,ret)
    for i,v in pairs(ret) do
        if tonumber(v.mid) == UserInfo.getInstance():getUid() then
            self:updateView(OwnScene.s_cmds.updateMasterAndFansRank,v);
            return ;
        end
    end
end

OwnController.getUserMailGetNewMailNumber = function(self,isSuccess,message)
    ChessController.getUserMailGetNewMailNumber(self,isSuccess,message);
    self:updateView(OwnScene.s_cmds.updateUserInfoView);
end

function OwnController:onSaveUserInfo(isSuccess,message)
    if not isSuccess then
        local message = "用户信息修改失败，稍候再试！";
        ChessToastManager.getInstance():show(message);
        self:updateView(OwnController.s_cmds.updateUserInfoView);
  		return;
    end

    if(message.data ~= nil) then
  		self:explainModify(message.data);
  	end
    self:updateView(OwnScene.s_cmds.updateUserInfoView);
end

function OwnController:explainModify(data)
	local aUser = data.aUser;
	if not aUser then 
		return
	end
    
	local mnick = aUser.mnick:get_value();
	local sex = aUser.sex:get_value();
    local iconType = aUser.iconType:get_value();
    local icon_url = aUser.icon_url:get_value();
    if iconType then
        if iconType > 0 then --1,2,3,4界面自带的头像
            UserInfo.getInstance():setIconFile(UserInfo.DEFAULT .. iconType,UserInfo.DEFAULT_ICON[iconType] or UserInfo.DEFAULT_ICON[1]);
            UserInfo.getInstance():setIconType(iconType);
            UserInfo.getInstance():setIcon();
        elseif iconType == -1 then--本地上传的头像
            if self.m_uploadIcon then -- 自定义头像
                local iconName = nil;

                if UserInfo.getInstance():getLoginType() == LOGIN_TYPE_BOYAA then
           
                    iconName = UserInfo.ICON..PhpConfig.TYPE_BOYAA;

                elseif UserInfo.getInstance():getLoginType() == LOGIN_TYPE_YOUKE then
            
                    iconName = UserInfo.ICON..PhpConfig.TYPE_YOUKE;

                elseif UserInfo.getInstance():getLoginType() == LOGIN_TYPE_weibo then
 
                    iconName = UserInfo.ICON..PhpConfig.TYPE_WEIBO;

                end;


                UserInfo.getInstance():setIconFile(self.m_uploadIcon,iconName..".png");
                UserInfo.getInstance():setIconType(iconType);
                UserInfo.getInstance():setIcon(self.m_uploadIcon);
                self.m_uploadIcon = nil;
            elseif icon_url then -- 系统默认头像
                 local iconName = nil;

                if UserInfo.getInstance():getLoginType() == LOGIN_TYPE_BOYAA then
           
                    iconName = UserInfo.ICON..PhpConfig.TYPE_BOYAA;

                elseif UserInfo.getInstance():getLoginType() == LOGIN_TYPE_YOUKE then
            
                    iconName = UserInfo.ICON..PhpConfig.TYPE_YOUKE;

                elseif UserInfo.getInstance():getLoginType() == LOGIN_TYPE_weibo then
 
                    iconName = UserInfo.ICON..PhpConfig.TYPE_WEIBO;

                end;


                UserInfo.getInstance():setIconFile(icon_url,iconName..".png");
                UserInfo.getInstance():setIconType(iconType);
                UserInfo.getInstance():setIcon(icon_url);               
            end;
        end;
    end;
    if mnick then
        UserInfo:getInstance():setName(mnick);
    end;
    if sex then
	    UserInfo:getInstance():setSex(sex);
    end;
end

function OwnController:upLoadImage(json_data)
--    local a = '{"time":"2015-05-12 17:55:04","flag":"10000","data":{"big":"http:\/\/chesscnmobile.17c.cn\/chess_android\/userIcon\/icon\/6996\/5726996_big.png?v=1431424504","middle":"http:\/\/chesscnmobile.17c.cn\/chess_android\/userIcon\/icon\/6996\/5726996_middle.png?v=1431424504","icon":"http:\/\/chesscnmobile.17c.cn\/chess_android\/userIcon\/icon\/6996\/5726996_icon.png?v=1431424504"}}';
--    json_data = json.decode_node(a);
    
	if not json_data then  --   上传失败           
		 print_string(" UserDisplay.upLoadImage not json_data " );
  		local message = "上传头像失败，稍候再试！";
        ChessToastManager.getInstance():show(message);
    else   -- 上传成功


    	local flag = HttpModule.explainPHPFlag(json_data);
	  	if not flag then
	  		local message = "上传头像失败，稍候再试！";
            ChessToastManager.getInstance():show(message);
	  		return;
	  	end

    	local data = json_data.data;
    	local icon = data.middle:get_value();


	  	local message = "上传头像失败...";
    	if  icon then
            message = "上传头像成功!";
            print_string("UserDisplay.upLoadImage icon = " .. icon);
			self.m_uploadIcon = icon;
            self:updateView(OwnScene.s_cmds.upLoadImage,-1);
            return;
    	end
        
        ChessToastManager.getInstance():show(message);
	end
end

function OwnController:onDownLoadImageRequest(status,json_data)
    if not status or not json_data then 
        return ;
    end
    local imageName = json_data.ImageName:get_value();
    self:updateView(OwnScene.s_cmds.updateUserHead);
end

function OwnController:onUpLoadImageRequest(status,json_data)
    if not status or not json_data then 
        return ;
    end
    self:upLoadImage(json_data)
end

function OwnController:onBindWeibo(flag,json_data)
    if not flag then
        Toast.getInstance():show("登录失败");
        return;
    end
    local bind_uuid = json_data.sitemid:get_value();
    local mid = UserInfo.getInstance():getUid();
    Log.i("kLoginWithWeibo sitemid:"..bind_uuid);
    local post_data = {};
    post_data.bind_uuid = bind_uuid;
    post_data.mid = mid;
    post_data.sid = OwnController.s_sid.xinlang;

    HttpModule.getInstance():execute(HttpModule.s_cmds.bindUid,post_data,"绑定中...");
end

function OwnController:onBindWeChat(flag,json_data)
    if not flag then
        Toast.getInstance():show("登录失败");
        return;
    end
    local bind_uuid = json_data.openid:get_value();
    local mid = UserInfo.getInstance():getUid();
    Log.i("kLoginWeChat openid:"..bind_uuid);
    local post_data = {};
    post_data.bind_uuid = bind_uuid;
    post_data.mid = mid;
    post_data.sid = OwnController.s_sid.weichat;

    HttpModule.getInstance():execute(HttpModule.s_cmds.bindUid,post_data,"绑定中...");
end

function OwnController:onBindUidResponse(isSuccess,data,message)
    if not isSuccess then
        ChessToastManager.getInstance():showSingle( message or "请求失败!");
        return ;
    end
    ChessToastManager.getInstance():showSingle("绑定成功!",2000);
    local bind_uuid = data.data.bind_uuid:get_value();
    local sid = data.data.sid:get_value();
    local bindData = nil
    if bind_uuid and sid then
        local temp = {}
        UserInfo.getInstance():updateBindAccountBySid(sid,bind_uuid);
        temp.sid = sid
        temp.bind_uuid = bind_uuid
        bindData = temp
    end
    self:updateView(OwnScene.s_cmds.updateUserInfoView,bindData);
end

function OwnController:saveUserInfo(data)
--    self.m_fileName = data.fileName;
    local post_data = {};
    post_data.iconType = data.iconType or UserInfo.getInstance():getIconType();
	post_data.mnick = data.name;
	post_data.sex = UserInfo.getInstance():getSex();
    post_data.icon_url = data.icon_url;
    local flag = false;
    if UserInfo.getInstance():getIconType() == data.iconType then
        if data.iconType == -1 then
            if data.icon_url then
                if string.find(UserInfo.getInstance():getIcon(),data.icon_url) then
                    flag = true;
                end
            else
                flag = false;
            end;
        else
            flag = true;
        end
    end
    if post_data.mnick == UserInfo.getInstance():getName() and post_data.sex == UserInfo.getInstance():getSex() and flag then
        return;
    end
    HttpModule.getInstance():execute(HttpModule.s_cmds.saveUserInfo,post_data,"正在修改用户信息...");

end
-------------------- config --------------------------------------------------
OwnController.s_httpRequestsCallBackFuncMap  = {
    [HttpModule.s_cmds.UserMailGetNewMailNumber]    = OwnController.getUserMailGetNewMailNumber;
    [HttpModule.s_cmds.saveUserInfo]                = OwnController.onSaveUserInfo;
    [HttpModule.s_cmds.bindUid]                     = OwnController.onBindUidResponse;
};


OwnController.s_nativeEventFuncMap = {
    [kFriend_UpdateUserData]         = OwnController.onUpdateUserData;
    [kDownLoadImage]                 = OwnController.onDownLoadImageRequest;
    [kUpLoadImage]                   = OwnController.onUpLoadImageRequest;
    -- 绑定
    [kLoginWithWeibo]                = OwnController.onBindWeibo;
    [kLoginWeChat]                   = OwnController.onBindWeChat;
};
OwnController.s_nativeEventFuncMap = CombineTables(ChessController.s_nativeEventFuncMap,
	OwnController.s_nativeEventFuncMap or {});

OwnController.s_socketCmdFuncMap = {
--    [FRIEND_CMD_CHECK_PLAYER_RANK]                  = OwnController.onRecvServerMsgFriendsRankSuccess;
};
-- 合并父类 方法
OwnController.s_httpRequestsCallBackFuncMap = CombineTables(ChessController.s_httpRequestsCallBackFuncMap,
	OwnController.s_httpRequestsCallBackFuncMap or {});

OwnController.s_socketCmdFuncMap = CombineTables(ChessController.s_socketCmdFuncMap,
	OwnController.s_socketCmdFuncMap or {});

------------------------------------- 命令响应函数配置 ------------------------
OwnController.s_cmdConfig = 
{
    [OwnController.s_cmds.onBack]                   = OwnController.onBack;
    [OwnController.s_cmds.goToMall]                 = OwnController.goToMall;
    [OwnController.s_cmds.goToFeedback]             = OwnController.goToFeedback;
--    [OwnController.s_cmds.getFriendsRank]           = OwnController.attentionFriendsCall;
    [OwnController.s_cmds.goToChessFriends]         = OwnController.goToChessFriends;
    [OwnController.s_cmds.saveUserInfo]             = OwnController.saveUserInfo;

}