require(MODEL_PATH .. "online/onlineRoom/module/baseModule");
require("dialog/friend_chioce_dialog");

FriendModule = class(BaseModule);

function FriendModule.ctor(self,scene)
    BaseModule.ctor(self,scene);
end

function FriendModule.initGame(self)
    self.mScene.m_roomid:setVisible(false);
    self.mScene.m_multiple_img_bg:setVisible(true);--倍数
    self.mScene:downComeIn(UserInfo.getInstance());
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.client_msg_login); 
    self.mScene.m_down_user_start_btn:setVisible(true);
    if UserInfo.getInstance():getChallenger() == true then
        ChessToastManager.getInstance():show("点击开始按钮向对方发起挑战",2000);
    end
    if UserInfo.getInstance():getChallenger() == false then
        ChessToastManager.getInstance():show("对方正在设置棋局，请稍等");
    end
end

function FriendModule.resetGame(self)
    self.mScene.m_chest_btn:setVisible(false);
	self.mScene.m_multiple_img_bg:setVisible(false);
	self.mScene.m_down_name:setVisible(false);
	self.mScene.m_up_name:setVisible(false);
    self.mScene.m_net_state_view:setVisible(false);
	self.mScene.m_net_state_view_bg:setVisible(false);
    self.mScene:showNetSinalIcon(false);
    self.mScene.m_down_user_start_btn:setVisible(false);
end

function FriendModule.dismissDialog(self)

end

function FriendModule.readyAction(self)
    if self.mScene.m_ready_time and self.mScene.m_ready_time > 0 then
        ChessToastManager.getInstance():show("请等待"..self.m_ready_time.."s再次准备挑战");
        return;
    end
    if UserInfo.getInstance():getChallenger() == false then
        if self.mScene.m_upUser == nil then
            self.mScene:onForceLeave("对方已经离开，请退出房间");
        end
    end
    if UserInfo.getInstance():getChallenger() then
        local post_data = {};
        post_data.uid = tonumber(UserInfo.getInstance():getUid());
        post_data.target_uid = tonumber(UserInfo.getInstance():getTargetUid());
        post_data.tid = RoomProxy.getInstance():getTid();
        UserInfo.getInstance():setChallenger(nil);
        self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.invit_request,post_data);
        self.mScene:showMoneyRent();
    end
end

function FriendModule.backAction(self)
    local message = "亲，中途离开则会输掉棋局哦！"
	if not self.mScene.m_chioce_dialog then
		self.mScene.m_chioce_dialog = new(ChioceDialog);
	end
    if self.mScene.m_downUser and not self.mScene.m_game_start then
        message = "您确定离开吗？"
        self.mScene.m_chioce_dialog:setMode(ChioceDialog.MODE_SURE,"退出","取消");
        self.mScene.m_chioce_dialog:setPositiveListener(self.mScene,self.mScene.exitRoom);
    elseif self.mScene.m_downUser then
        if not self.mScene:checkCanSurrender() then return end
        self.mScene.m_chioce_dialog:setMode(ChioceDialog.MODE_SURE,"认输退出","取消");
        self.mScene.m_chioce_dialog:setPositiveListener(self.mScene,self.mScene.surrender_sure);
    else
        self.mScene.m_chioce_dialog:setPositiveListener(self.mScene,self.mScene.exitRoom);
    end
	self.mScene.m_chioce_dialog:setMessage(message);
	self.mScene.m_chioce_dialog:setNegativeListener(nil,nil);
	self.mScene.m_chioce_dialog:show();
end

--邀请返回【函数内区分失败还是成功】
function FriendModule.onInvitFail(self,data)
    if data and data.ret == 0 then
        if self.mScene.m_invit_time_anim then
            delete(self.mScene.m_invit_time_anim);
            self.mScene.m_invit_time_anim = nil;
        end
        self.mScene.m_invit_time_anim_time = (data.time_out or 20)*1000;
        self.mScene.m_invit_time_anim = new(AnimInt,kAnimRepeat, 0, 1, self.mScene.m_invit_time_anim_time, -1);
        self.mScene.m_invit_time_anim:setDebugName("OnlineRoomSceneNew.m_invit_time_anim");
        self.mScene.m_invit_time_anim:setEvent(self,self.onInvitTimeOut);
    elseif data and data.ret == 1 then
        self.mScene:clearDialog();
        local friendData = FriendsData.getInstance():getUserData(data.target_uid);
        delete(self.mScene.m_friendChoiceDialog);
        self.mScene.m_friendChoiceDialog = new(FriendChoiceDialog);
        if data and data.target_tid ~= 0 and data.target_hallid ~= 0 then   --好友处在下棋中
            self.mScene.m_friendChoiceDialog:setMode(2,friendData);
            self.mScene.m_friendChoiceDialog:setPositiveListener(self.mScene,
                    function()         
                        RoomProxy.getInstance():setTid(data.target_tid);       --转到好友观战
                        if OnlineRoomSceneNew.IS_NEW then
                            self.mScene:changeRoomType(RoomConfig.ROOM_TYPE_WATCH_ROOM); 
                        end
                    end);
            self.mScene.m_friendChoiceDialog:setNegativeListener(self.mScene,
                function()
                    self.mScene:exitRoom();
                    end);
        else
            self.mScene.m_friendChoiceDialog:setMode(4,friendData);
            self.mScene.m_friendChoiceDialog:setPositiveListener(self.mScene,
                function()         
                    self.mScene:exitRoom();
                    end);
            self.mScene.m_friendChoiceDialog:setNegativeListener(self.mScene,
                function()
                    self.mScene:exitRoom();
                    end);
        end
        self.mScene.m_friendChoiceDialog:show();
    elseif data and data.ret == 2 then
        local message = "该好友今天无心对战，请换个对手挑战吧。"
        if not self.mScene.m_chioce_dialog then
		    self.mScene.m_chioce_dialog = new(ChioceDialog);
	    end
        self.mScene.m_chioce_dialog:setMode();
        self.mScene.m_chioce_dialog:setPositiveListener(self.mScene,self.mScene.exitRoom);
	    self.mScene.m_chioce_dialog:setMessage(message);
	    self.mScene.m_chioce_dialog:setNegativeListener(self.mScene,self.mScene.exitRoom);
	    self.mScene.m_chioce_dialog:show();
    end
end

--邀请超时
function FriendModule.onInvitTimeOut(self)
    self:onDeleteInvitAnim();
    local message = "对方无响应，即将离开房间！"
    if not self.mScene.m_chioce_dialog then
		self.mScene.m_chioce_dialog = new(ChioceDialog);
	end
    self.mScene.m_chioce_dialog:setMode();
    self.mScene.m_chioce_dialog:setPositiveListener(self.mScene,self.mScene.exitRoom);
	self.mScene.m_chioce_dialog:setMessage(message);
	self.mScene.m_chioce_dialog:setNegativeListener(self.mScene,self.mScene.exitRoom);
	self.mScene.m_chioce_dialog:show();
end

function FriendModule.onDeleteInvitAnim(self)
    if self.mScene.m_invit_time_anim then
        delete(self.mScene.m_invit_time_anim);
        self.mScene.m_invit_time_anim = nil;
    end
end