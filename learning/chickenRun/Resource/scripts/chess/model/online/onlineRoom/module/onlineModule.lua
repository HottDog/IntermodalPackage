require(MODEL_PATH .. "online/onlineRoom/module/baseModule");

OnlineModule = class(BaseModule);

function OnlineModule.ctor(self,scene)
    BaseModule.ctor(self,scene);
end

function OnlineModule.dtor(self)
    delete(self.mScene.m_match_dialog);
end

function OnlineModule.initGame(self)
    self.mScene.m_roomid:setVisible(false);
    self.mScene.m_multiple_img_bg:setVisible(true);--倍数
    self.mScene:downComeIn(UserInfo.getInstance());
    if UserInfo.getInstance():getRelogin() then
        self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.client_msg_login); 
	end
    --初始化时弹出选择玩家弹窗
    if not UserInfo.getInstance():getRelogin() then
        self:matchRoom();
    end
end

function OnlineModule.resetGame(self)
    self.mScene.m_chest_btn:setVisible(false);
	self.mScene.m_multiple_img_bg:setVisible(false);
	self.mScene.m_down_name:setVisible(false);
	self.mScene.m_up_name:setVisible(false);
    self.mScene.m_net_state_view:setVisible(false);
	self.mScene.m_net_state_view_bg:setVisible(false);
    self.mScene:showNetSinalIcon(false);
end

function OnlineModule.dismissDialog(self)
    if self.mScene.m_match_dialog and self.mScene.m_match_dialog:isShowing() then
		self.mScene.m_match_dialog:dismiss();
	end
end

function OnlineModule.readyAction(self)
    if self.mScene.m_match_dialog then
        self.mScene.m_match_dialog:dismiss();
    end
    self.mScene.m_upuser_leave = false;
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.send_ready_msg);
end

function OnlineModule.backAction(self)
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

-- 对方退出房间后弹出确认重新匹配对话框
function OnlineModule.showRematchComfirmDialog(self)
    if self.mScene.m_match_dialog and self.mScene.m_match_dialog:isShowing() then
        self.mScene.m_match_dialog:setVisible(false);
    end
    if self.mScene.m_account_dialog and self.mScene.m_account_dialog:isShowing() then
        return;
    end
    local message = "对方退出房间，请重新匹配对手！"
    if not self.mScene.m_rematch_dialog then
		self.mScene.m_rematch_dialog = new(ChioceDialog);
	end
    self.mScene.m_rematch_dialog:setMode(ChioceDialog.MODE_SURE,"确定","退出房间");
    self.mScene.m_rematch_dialog:setPositiveListener(self,self.changeChessRoom);
    self.mScene.m_rematch_dialog:setMessage(message);
	self.mScene.m_rematch_dialog:setNegativeListener(self.mScene,self.mScene.exitRoom);
	self.mScene.m_rematch_dialog:show();
end

function OnlineModule.changeChessRoom(self)
    self.mScene.changeRoom = true;
    UserInfo.getInstance():setChallenger(nil);
	OnlineConfig.deleteTimer(self.mScene); 
    self.mScene.m_board_menu_dialog:dismiss();
    self.mScene.m_connectCount = 0;
	UserInfo.getInstance():setRelogin(false) 

    if self.mScene.m_login_succ then
        self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.client_msg_logout);
    else
        self:matchRoom();
    end
end

--匹配对手
function OnlineModule.matchRoom(self,isRematch)
    if not isRematch then
        self.mScene.m_matchIng = true;
	    if not self.mScene.m_match_dialog then
		    self.mScene.m_match_dialog = new(MatchDialog);
	    end
	    self.mScene:showMoneyRent();

	    self.mScene.m_match_dialog:show(self.mScene,UserInfo.getInstance():getMatchTime());
    end
    local data = {};
    local roomType = RoomProxy.getInstance():getCurRoomType();
    if RoomConfig.ROOM_TYPE_NOVICE_ROOM == roomType and RoomConfig.getInstance():getRoomTypeConfig(RoomConfig.ROOM_TYPE_NOVICE_ROOM) then
        data.roomType = RoomConfig.getInstance():getRoomTypeConfig(RoomConfig.ROOM_TYPE_NOVICE_ROOM).level;
    elseif RoomConfig.ROOM_TYPE_INTERMEDIATE_ROOM == roomType then
        data.roomType = RoomConfig.getInstance():getRoomTypeConfig(RoomConfig.ROOM_TYPE_INTERMEDIATE_ROOM).level;
    elseif RoomConfig.ROOM_TYPE_MASTER_ROOM == roomType then
        data.roomType = RoomConfig.getInstance():getRoomTypeConfig(RoomConfig.ROOM_TYPE_MASTER_ROOM).level;
    else
        return ;
    end;
    data.playerLevel = self.mScene.m_upPlayer_level;
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.hall_game_info, data); 
end

function OnlineModule.cancelMatch(self)
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.hall_cancel_match); 
end

function OnlineModule.onMatchSuccess(self,data)
    if self.mScene.m_match_dialog then
        self.mScene.m_matchIng = false;
	    self.mScene.m_match_dialog:onMatchSuc(data);
	end
end

function OnlineModule.onMatchRoomFail(self)
	print_string("匹配失败");
--	self.m_down_user_start_btn:setVisible(true);

	local message = "大侠，对手已闻风而逃，请重新匹配。"
	if self.mScene.m_match_dialog then
		self.mScene.m_match_dialog:dismiss();
	end

	if not self.mScene.m_chioce_dialog then
		self.mScene.m_chioce_dialog = new(ChioceDialog);
	end

	self.mScene.m_chioce_dialog:setMode(ChioceDialog.MODE_OK);
	self.mScene.m_chioce_dialog:setMessage(message);
	self.mScene.m_chioce_dialog:setPositiveListener(self,self.changeChessRoom);
	self.mScene.m_chioce_dialog:show();
end

--更换等级
function OnlineModule.changeRoomType(self)
	self.mScene.m_account_dialog:dismiss();
	self.mScene:stopTimeout();
end

--更新匹配动画里的弹窗
function OnlineModule.sendFllowCallback(self,info)
    if self.mScene.m_match_dialog and self.mScene.m_match_dialog:isShowing() then
        self.mScene.m_match_dialog:update(info);
    end    
    if self.mScene.m_watchList_dialog and self.mScene.m_watchList_dialog:isShowing() then
        self.mScene.m_watchList_dialog:updataBtnText(info);
    end
end