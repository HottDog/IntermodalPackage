require(MODEL_PATH .. "online/onlineRoom/module/baseModule");
require(DIALOG_PATH.."invite_friends_dialog");

CustomModule = class(BaseModule);

function CustomModule.ctor(self,scene)
    BaseModule.ctor(self,scene);          --房间ID(View)
end

function CustomModule.setStatus(self,status,op_uid)
    if status == STATUS_TABLE_PLAYING then   --走棋状态
        self.mScene.m_private_change_player_btn:setVisible(false);
        self.mScene.m_private_invite_friends_btn:setVisible(false);
	elseif status == STATUS_TABLE_FORESTALL then  -- 抢先状态
        self.mScene.m_private_change_player_btn:setVisible(false);
        self.mScene.m_private_invite_friends_btn:setVisible(false);
	elseif status == STATUS_TABLE_HANDICAP then  -- 让子状态
        self.mScene.m_private_change_player_btn:setVisible(false);
        self.mScene.m_private_invite_friends_btn:setVisible(false);
	elseif status == STATUS_TABLE_SETTIME then -- 设置局时状态
        self.mScene.m_private_change_player_btn:setVisible(false);
        self.mScene.m_private_invite_friends_btn:setVisible(false);
    elseif status == STATUS_TABLE_SETTIMERESPONE then -- 设置局时响应状态
        self.mScene.m_private_change_player_btn:setVisible(false);
        self.mScene.m_private_invite_friends_btn:setVisible(false);
    else
    end
end

function CustomModule.initGame(self)
    if self.mScene.m_customRoomExit then
        self.mScene.m_customRoomExit = false;
        StateMachine.getInstance():popState(StateMachine.STYPE_CUSTOM_WAIT);
        return;
    end
    self.mScene.m_down_user_start_btn:setVisible(true);
    self.mScene.m_private_change_player_btn:setVisible(RoomProxy.getInstance():isSelfRoom() and self.mScene.m_upUser ~= nil);
    self.mScene.m_private_invite_friends_btn:setVisible(RoomProxy.getInstance():isSelfRoom() and self.mScene.m_upUser == nil);
    self.mScene.m_private_change_player_btn:setOnClick(self,self.onPrivateChangePlayerBtnClick);
    self.mScene.m_private_invite_friends_btn:setOnClick(self,self.onPrivateInviteFriendsBtnClick);
	self.mScene.m_roomid:setVisible(true);
    self.mScene:downComeIn(UserInfo.getInstance());
    self:startCustomroom();
end

function CustomModule.resetGame(self)
	self.mScene.m_up_name:setVisible(false);
    self.mScene.m_down_user_start_btn:setVisible(false);
    self.mScene.m_net_state_view:setVisible(false);
	self.mScene.m_net_state_view_bg:setVisible(false);
    self.mScene.m_roomid:setVisible(false);
    self.mScene:showNetSinalIcon(false);
end

function CustomModule.dismissDialog(self)

end

function CustomModule.readyAction(self)
    if UserInfo.getInstance():getStatus() > STATUS_PLAYER_LOGIN then  --网络游戏
        self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.client_msg_start);
	else
	  	self.mScene.m_roomid_text:setText("房间ID "..UserInfo.getInstance():getCustomRoomID());
	end
end

function CustomModule.backAction(self)
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

function CustomModule.onPrivateChangePlayerBtnClick(self)
    if RoomProxy.getInstance():getCurRoomType() == RoomConfig.ROOM_TYPE_PRIVATE_ROOM then
        if self.mScene.m_upUser then
            if tonumber(self.mScene.m_upUser:getClient_version()) and tonumber(self.mScene.m_upUser:getClient_version()) >= 215 then
                self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.server_cmd_kick_player);
            else
                ChessToastManager.getInstance():showSingle("对方版本过低不支持踢人功能");
            end
        end
    end
end

function CustomModule.onPrivateInviteFriendsBtnClick(self)
    local url = UserInfo.getInstance():getInviteFriendsUrl();
    if not url then
       ChessToastManager.getInstance():showSingle("登录信息缺失，请重新登录");
       return ;
    end
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.get_private_room_info);
end

function CustomModule.startCustomroom(self)
	print_string("Room.start_customroom ... ");
  	self.mScene.m_roomid_text:setText("房间ID "..UserInfo.getInstance():getCustomRoomID());
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.start_customroom);
end

function CustomModule.onGetPrivateInfo(self,data)
    Log.i(json.encode(data));
    delete(self.mInviteFriendsDialog);
    self.mInviteFriendsDialog = new(InviteFriendsDialog);
    self.mInviteFriendsDialog:show(data);
end