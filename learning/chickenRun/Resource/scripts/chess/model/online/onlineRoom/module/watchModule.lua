require(MODEL_PATH .. "online/onlineRoom/module/baseModule");

WatchModule = class(BaseModule);

function WatchModule.ctor(self,scene)
    BaseModule.ctor(self,scene);
    --value
    scene.m_watcher_count = 0;  --观战者人数
    local roomType = RoomProxy.getInstance():getCurRoomType();
    if roomType == RoomConfig.ROOM_TYPE_WATCH_ROOM then
        if OnlineRoomSceneNew.IS_NEW then
            -- 隐藏时间
            scene.m_root_view:getChildByName("room_time_bg"):setVisible(false);
            -- 隐藏信号
            scene.m_net_state_view:setVisible(false);
            -- 隐藏聊天按钮和功能按钮
            scene.m_chat_btn:setVisible(false);
            scene.m_menu_btn:setVisible(false);
            -- 隐藏观战人数
            scene.m_room_watcher_btn:setVisible(false);
            -- up_user
            self:showWatchUpUser();
            -- down_user
            self:showWatchDownUser();   
            -- 显示对局
            scene.m_root_view:getChildByName("vs_img"):setVisible(true);
            -- 棋盘上移留出聊天空间
            scene.m_board_view:setPos(0,116);
            -- 显示新版watch_view
            self:showNewWatchView();
            -- 隐藏宝箱
            scene.m_chest_btn:setVisible(false);
       end      
    end
end

function WatchModule.dtor(self)
    delete(self.m_watch_dialog);
end

function WatchModule.initGame(self)
    --	self.m_room_watcher_bg_btn:setVisible(false);
    self.mScene.m_room_watcher_btn:setEnable(true);
	self.mScene.m_down_name:setVisible(true);
	self.mScene.m_up_name:setVisible(true);
    self.mScene.m_roomid:setVisible(false);
    self.mScene.m_room_menu_view:setVisible(false);
    self.mScene.m_chest_btn:setVisible(false);
	self:startWatch();
end

function WatchModule.resetGame(self)
    self.mScene.m_watcher_count = 0;
	self.mScene.m_down_name:setVisible(false);
	self.mScene.m_up_name:setVisible(false);
end

function WatchModule.dismissDialog(self)

end

function WatchModule.readyAction(self)
    self.mScene:stopTimeout();

	self.mScene:clearDialog();
    if self.mScene.m_downUser then
	    if  self.mScene.m_downUser:getUid() == leaveUid then
		    self.mScene.m_down_user_ready_img:setVisible(false);
		    self.mScene.m_down_user_icon:setVisible(false);  ---表现形式将对走离开
	    else
		    self.mScene.m_up_user_ready_img:setVisible(false);
		    self.mScene.m_up_user_icon:setVisible(false);  ---表现形式将对走离开
	    end
    end;
	local message = "棋手离开，所有观战人员离场";
	self.mScene:loginFail(message);
end

function WatchModule.backAction(self)
    print_string("Room.onWatchBack");
	self.mScene:exitRoom();
end

function WatchModule.setStatus(self,status,op_uid)
    if self.mScene.m_t_statuss == STATUS_TABLE_PLAYING then   --走棋状态
	elseif self.mScene.m_t_statuss == STATUS_TABLE_FORESTALL then  -- 抢先状态
        if op_uid then
            if self.mScene.m_downUser and self.mScene.m_downUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText(self.mScene.m_downUser:getName() .. "抢先中...");
            end
            if self.mScene.m_upUser and self.mScene.m_upUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText(self.mScene.m_upUser:getName() .. "抢先中...");
            end
        else
            self.mScene.m_toast_text:setText("抢先中...");
        end
        self.mScene.m_toast_bg:setVisible(true);
        ShowMessageAnim.reset();
	elseif self.mScene.m_t_statuss == STATUS_TABLE_HANDICAP then  -- 让子状态
        if op_uid then
            if self.mScene.m_downUser and self.mScene.m_downUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText(self.mScene.m_downUser:getName() .. "让子中...");
            end
            if self.mScene.m_upUser and self.mScene.m_upUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText(self.mScene.m_upUser:getName() .. "让子中...");
            end
        else
            self.mScene.m_toast_text:setText("双方让子中...");
        end
        self.mScene.m_toast_bg:setVisible(true);
        ShowMessageAnim.reset();
	elseif self.mScene.m_t_statuss == STATUS_TABLE_SETTIME then -- 设置局时状态
        if op_uid then
            if self.mScene.m_downUser and self.mScene.m_downUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText(self.mScene.m_downUser:getName() .. "设置棋局中...");
            end
            if self.mScene.m_upUser and self.mScene.m_upUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText(self.mScene.m_upUser:getName() .. "设置棋局中...");
            end
        else
            self.mScene.m_toast_text:setText("设置棋局中...");
        end
        self.mScene.m_toast_bg:setVisible(true);
        ShowMessageAnim.reset();
    elseif self.mScene.m_t_statuss == STATUS_TABLE_SETTIMERESPONE then
        if op_uid then
            if self.mScene.m_downUser and self.mScene.m_downUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText("等待" ..self.mScene.m_downUser:getName() .. "同意棋局设置...");
            end
            if self.mScene.m_upUser and self.mScene.m_upUser:getUid() == op_uid then
                self.mScene.m_toast_text:setText("等待" ..self.mScene.m_upUser:getName() .. "同意棋局设置...");
            end
        else
            self.mScene.m_toast_text:setText("设置棋局中...");
        end
        self.mScene.m_toast_bg:setVisible(true);
        ShowMessageAnim.reset();
    else
    end
end

function WatchModule.startWatch(self)
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.start_watch);
end

function WatchModule.showWatchUpUser(self)
    -- 隐藏局时
	self.mScene.m_up_timeframe:setVisible(false);
    -- 显示黑方flag
    self.mScene.m_up_view:getChildByName("up_user_flag"):setVisible(true);
    -- 头像信息背景
    self.mScene.m_up_user_bg = self.mScene.m_up_view:getChildByName("up_user_bg");
    self.mScene.m_up_user_bg:setVisible(true);
    self.mScene.m_up_user_bg:setPos(70,0);
    -- 头像左对齐
    self.mScene.m_up_user_icon_bg:setAlign(kAlignTop);
    self.mScene.m_up_user_icon_bg:setPos(-195,0);
    self.mScene.m_up_user_icon_bg:setSize(74,74);
    -- 头像框
    self.mScene.m_up_user_icon_bg:getChildByName("up_turn1"):setSize(85,85);
    -- 红黑方
    self.mScene.m_up_user_chess_flag = self.mScene.m_up_user_icon_bg:getChildByName("up_user_flag2");
    self.mScene.m_up_user_chess_flag:setVisible(true);
    -- 倒计时
    self.mScene.m_up_turn:setSize(90,90);
    self.mScene.m_up_turn:setAlign(kAlignCenter);
    -- icon_frame_mast
	self.mScene.m_up_user_icon_frame_mask:setFile("userinfo/icon_8484_mask.png");
    self.mScene.m_up_user_icon_frame_mask:setSize(74,74);
    self.mScene.m_up_breath1:setSize(74,74);
    self.mScene.m_up_breath2:setSize(74,74);
    -- icon
    self.mScene.m_up_user_icon:setFile("userinfo/icon_8484_mask.png");
    self.mScene.m_up_user_icon:setSize(74,74);
    -- vip_frame
    self.mScene.m_up_vip_frame:setSize(96,96);
    -- vip_logo
    self.mScene.m_up_vip_logo:setAlign(kAlignTopLeft);
    self.mScene.m_up_vip_logo:setPos(230,35);
    -- user_level
    self.mScene.m_up_user_level_icon:setPos(75,5);
    -- user_name
    delete(self.mScene.m_up_name);
    self.mScene.m_up_name = nil;
    self.mScene.m_up_name = new(Text,"博雅象棋",0,0,kAlignLeft,nil,24,245,235,210);
    self.mScene.m_up_name:setAlign(kAlignTopLeft);
    self.mScene.m_up_name:setPos(155,5);
    self.mScene.m_up_view:addChild(self.mScene.m_up_name);
end


function WatchModule.showWatchDownUser(self)
    self.mScene.m_down_view:setAlign(kAlignTop);
    self.mScene.m_down_view:setPos(0,24);
    -- 隐藏局时
	self.mScene.m_down_timeframe:setVisible(false);
    -- 显示红方flag
    self.mScene.m_down_view:getChildByName("down_user_flag"):setVisible(true);
    -- 头像信息背景
    self.mScene.m_down_user_bg = self.mScene.m_down_view:getChildByName("down_user_bg");
    self.mScene.m_down_user_bg:setVisible(true);
    self.mScene.m_down_user_bg:setAlign(kAlignTopRight);
    -- 头像左对齐
    self.mScene.m_down_user_icon_bg:setAlign(kAlignTop);
    self.mScene.m_down_user_icon_bg:setPos(270,0);
    self.mScene.m_down_user_icon_bg:setSize(74,74);
    -- 头像框
    self.mScene.m_down_user_icon_bg:getChildByName("down_turn1"):setSize(85,85);
    -- 红黑方
    self.mScene.m_down_user_chess_flag = self.mScene.m_down_user_icon_bg:getChildByName("down_user_flag2");
    self.mScene.m_down_user_chess_flag:setVisible(true);
    -- 倒计时
    self.mScene.m_down_turn:setSize(90,90);
    self.mScene.m_down_turn:setAlign(kAlignCenter);
    -- icon_frame_mast
	self.mScene.m_down_user_icon_frame_mask:setFile("userinfo/icon_8484_mask.png");
    self.mScene.m_down_user_icon_frame_mask:setSize(74,74);
    self.mScene.m_down_breath1:setSize(74,74);
    self.mScene.m_down_breath2:setSize(74,74);
    -- icon
    self.mScene.m_down_user_icon:setFile("userinfo/icon_8484_mask.png");
    self.mScene.m_down_user_icon:setSize(74,74);
    -- vip_frame
    self.mScene.m_down_vip_frame:setSize(96,96);
    -- vip_logo
    self.mScene.m_down_vip_logo:setAlign(kAlignTopRight);
    self.mScene.m_down_vip_logo:setPos(157,35);
    -- user_level
    self.mScene.m_down_user_level_icon:setPos(-75,5);
    -- user_name
    delete(self.mScene.m_down_name);
    self.mScene.m_down_name = nil;
    self.mScene.m_down_name = new(Text,"博雅象棋",0,0,kAlignRight,nil,24,245,235,210);
    self.mScene.m_down_name:setAlign(kAlignTopRight);
    self.mScene.m_down_name:setPos(86,5);
    self.mScene.m_down_view:addChild(self.mScene.m_down_name);
end

function WatchModule.showNewWatchView(self)
    if not self.m_watch_dialog then
        self.m_watch_dialog = new(WatchDialog, self.mScene);
    end
    self.m_watch_dialog:show();
end

--更新关注的弹窗
function WatchModule.sendFllowCallback(self,info)
    if self.mScene.m_watchList_dialog and self.mScene.m_watchList_dialog:isShowing() then
        self.mScene.m_watchList_dialog:updataBtnText(info);
    end
end

function WatchModule.onUpdateWatchRoom(self, data, message)
    if not data then
        self.mScene:loginFail(message)
        return;
    end;
    local player1 = data.player1;
    local player2 = data.player2;
    if player1 then
        if player1:getFlag() == 1 then
            self.mScene:downComeIn(player1);
        else
            self.mScene:upComeIn(player1);
        end
    end
    if player2 then
        if player2:getFlag() == 1 then
            self.mScene:downComeIn(player2);
        else
            self.mScene:upComeIn(player2);
        end
    end
    if not player1 and not player2 then
        self:onWatchRoomUserLeave();
        return;
    end
    self.mScene.m_timeout1 = data.round_time;
	self.mScene.m_timeout2 = data.step_time;
	self.mScene.m_timeout3 = data.sec_time;
    if player1 and data.curr_move_flag == player1:getUid() then
        self.mScene.m_move_flag = player1:getFlag();
    elseif player2 and data.curr_move_flag == player2:getUid() then
        self.mScene.m_move_flag = player2:getFlag();
    end
    if self.mScene.m_move_flag == FLAG_RED then
        self.mScene.m_red_turn = true;
    else
        self.mScene.m_red_turn = false;
    end;
    if data.status == 2 then--只有在状态2（playing）才有下面信息
        self.mScene:setStatus(data.status);
        local last_move = {}
	    last_move.moveChess = data.chessMan;
	    last_move.moveFrom = 91 -data.position1;
	    last_move.moveTo = 91 - data.position2;
	    self.mScene:synchroData(data.chess_map,last_move);
    else
        self.mScene:setStatus(data.status);
--        ShowMessageAnim.play(self.m_root_view,"等待开局");
        local message =  "等待开局"; 
        ChessToastManager.getInstance():showSingle(message);   
    end
end

function WatchModule.sendWatchChat(self, message)
    self.mScene:requestCtrlCmd(OnlineRoomController.s_cmds.send_watch_chat, message);
end

function WatchModule.onWatchRoomMove(self, data)
    if not data then return end;
    if self.mScene.m_downUser and data.last_move_uid == self.mScene.m_downUser:getUid() then
        if self.mScene.m_downUser:getFlag() == FLAG_RED then
		    self.mScene.m_downUser:setTimeout1((self.mScene.m_timeout1 - data.red_timeout));
            self.mScene.m_upUser:setTimeout1(self.mScene.m_timeout1 - data.black_timeout);
            self.mScene.m_move_flag = FLAG_BLACK;--此函数内接收的是已经走完的棋，所以将要走的棋标志置反。
        else
            self.mScene.m_downUser:setTimeout1((self.mScene.m_timeout1 - data.black_timeout));
            self.mScene.m_upUser:setTimeout1(self.mScene.m_timeout1 - data.red_timeout);
            self.mScene.m_move_flag = FLAG_RED;
        end;
		self.mScene.m_downUser:setTimeout2(self.mScene.m_timeout2);
		self.mScene.m_downUser:setTimeout3(self.mScene.m_timeout3);
    elseif self.mScene.m_upUser and data.last_move_uid == self.mScene.m_upUser:getUid() then
        if self.mScene.m_upUser:getFlag() == FLAG_RED then
		    self.mScene.m_upUser:setTimeout1((self.mScene.m_timeout1 - data.red_timeout));
            self.mScene.m_downUser:setTimeout1(self.mScene.m_timeout1 - data.black_timeout);
            self.mScene.m_move_flag = FLAG_BLACK;
        else
            self.mScene.m_upUser:setTimeout1((self.mScene.m_timeout1 - data.black_timeout));
            self.mScene.m_downUser:setTimeout1(self.mScene.m_timeout1 - data.red_timeout);
            self.mScene.m_move_flag = FLAG_RED;
        end;
		self.mScene.m_upUser:setTimeout2(self.mScene.m_timeout2);
		self.mScene.m_upUser:setTimeout3(self.mScene.m_timeout3);
    end;
    self.mScene:setStatus(data.status);
    if data.ob_num then
     	local str = string.format("%d",data.ob_num);
--	    self.m_room_watcher:setText(str);   
    end;

    local mv = {}
	mv.moveChess = data.chessMan;
	mv.moveFrom = data.position1;
	mv.moveTo = data.position2;
	self.mScene:resPonseMove(mv);
end

function WatchModule.onWatchRoomUserLeave(self, data)
    if not data then
        return 
    end
    local leaveUid = data.leave_uid;
    self.mScene:stopTimeout();

	self.mScene:clearDialog();
    if self.mScene.m_downUser then
	    if self.mScene.m_downUser:getUid() == leaveUid then
		    self.mScene.m_down_user_ready_img:setVisible(false);
		    self.mScene.m_down_user_icon:setVisible(false);  ---表现形式将对走离开
	    else
		    self.mScene.m_up_user_ready_img:setVisible(false);
		    self.mScene.m_up_user_icon:setVisible(false);  ---表现形式将对走离开
	    end
    end;
	local message = "棋手离开，所有观战人员离场";
	self.mScene:loginFail(message);
end


function WatchModule.onWatchRoomStart(self, data)
    if not data then
        return 
    end;
    self.mScene.m_timeout1 = data.round_time;
	self.mScene.m_timeout2 = data.step_time;
	self.mScene.m_timeout3 = data.sec_time;
	
	self.mScene.m_downUser:setTimeout1(data.round_time);
	self.mScene.m_downUser:setTimeout2(data.step_time);
	self.mScene.m_downUser:setTimeout3(data.sec_time);

	self.mScene.m_upUser:setTimeout1(data.round_time);
	self.mScene.m_upUser:setTimeout2(data.step_time);
	self.mScene.m_upUser:setTimeout3(data.sec_time);

	if self.mScene.m_downUser:getUid() == data.red_uid then
		self.mScene.m_downUser:setFlag(FLAG_RED);
		if self.mScene.m_upUser then
			self.mScene.m_upUser:setFlag(FLAG_BLACK);
		end
	else
		self.mScene.m_downUser:setFlag(FLAG_BLACK);
		if self.mScene.m_upUser then
			self.mScene.m_upUser:setFlag(FLAG_RED);
		end
	end

    local player1 = self.mScene.m_downUser;
    local player2 = self.mScene.m_upUser;

    if player1 then
        if player1:getFlag() == 1 then
            self.mScene:downComeIn(player1);
        else
            self.mScene:upComeIn(player1);
        end
    end

    if player2 then
        if player2:getFlag() == 1 then
            self.mScene:downComeIn(player2);
        else
            self.mScene:upComeIn(player2);
        end
    end

    self.mScene.m_move_flag = FLAG_RED;
    self.mScene.m_red_turn = true;
    self.mScene:setStatus(data.status);
	self.mScene:startGame(data.chess_map);
end

function WatchModule.onWatchRoomClose(self, data)
	self:setWatchUsersInfo(data);
    self.mScene:setStatus(data.status);
	self.mScene:gameClose(data.win_flag,data.end_type);    
end

function WatchModule.setWatchUsersInfo(self, data)
    if not self.mScene.m_upUser or not self.mScene.m_downUser then return end;
    if  self.mScene.m_downUser:getFlag() == 1 then
		self.mScene.m_downUser:setScore(data.red_total_score or 0);
        self.mScene.m_downUser:setPoint(data.red_turn_score);
        self.mScene.m_downUser:setCoin(data.red_turn_money);
		self.mScene.m_downUser:setMoney(data.red_total_money or 0);

		self.mScene.m_upUser:setScore(data.black_total_score or 0);
		self.mScene.m_upUser:setPoint(data.black_turn_score);
		self.mScene.m_upUser:setCoin(data.black_turn_money);
		self.mScene.m_upUser:setMoney(data.black_total_money or 0);
	else
		self.mScene.m_upUser:setScore(data.red_total_score or 0);
        self.mScene.m_upUser:setPoint(data.red_turn_score);
        self.mScene.m_upUser:setCoin(data.red_turn_money);
		self.mScene.m_upUser:setMoney(data.red_total_money or 0);

		self.mScene.m_downUser:setScore(data.black_total_score or 0);
		self.mScene.m_downUser:setPoint(data.black_turn_score);
		self.mScene.m_downUser:setCoin(data.black_turn_money);
		self.mScene.m_downUser:setMoney(data.black_total_money or 0);
	end
end

function WatchModule.onWatchRoomAllReady(self, data)
    if not data then
        return;
    end
    if data.tid then
        local message =  "双方已准备(等待开局)"; 
        ChessToastManager.getInstance():showSingle(message); 
    end
end

function WatchModule.onWatchRoomError(self, data)
    local message =  "观战房间出现问题,请重新进入"; 
    ChessToastManager.getInstance():showSingle(message); 
    self.mScene:exitRoom();
end

function WatchModule.onWatchRoomUpdateTable(self,data)
	if data and data.status then
        self.mScene:setStatus(data.status,data.curr_op_uid);
    end
end

function WatchModule.onWatcherChatMsg(self, data)
    if data.uid ~= UserInfo.getInstance():getUid() then
        local name      = data.name;
        local msgType   = data.msgType;
        local message   = data.message;
        local uid       = data.uid;
        if not message or message == "" then
		    return;
	    end
	    local msg = string.format("%s:%s",name,message);
        if OnlineRoomSceneNew.IS_NEW and self.m_watch_dialog then -- 是自己发的观战消息显示在
            self.m_watch_dialog:addChatLog(name,message,uid);
        else
	        self.mScene.m_chat_dialog:addChatLog(name,message,uid);
            if self.mScene.m_chat_btn and not self.mScene.m_chat_dialog:isShowing() then 
               if self.mScene.m_chat_btn:getChildByName("notice") then
                    self.mScene.m_chat_btn:getChildByName("notice"):setVisible(true);
               end 
            end
        end
    end
end

function WatchModule.onWatchRoomDraw(self, data)
	if  self.mScene.m_downUser and self.mScene.m_downUser:getUid() == data.uid then
        ChatMessageAnim.play(self.mScene.m_root_view,3,self.mScene.m_downUser:getName().." 和棋申请成功");
	elseif self.mScene.m_upUser and self.mScene.m_upUser:getUid() == data.uid then
        ChatMessageAnim.play(self.mScene.m_root_view,3,self.mScene.m_upUser:getName().." 和棋申请成功");
	end
end


function WatchModule.onWatchRoomSurrender(self, data)
	if  self.mScene.m_downUser and self.mScene.m_downUser:getUid() == data.uid then
        ChatMessageAnim.play(self.mScene.m_root_view,3,self.mScene.m_downUser:getName().." 认输");
	elseif self.mScene.m_upUser and self.mScene.m_upUser:getUid() == data.uid then
        ChatMessageAnim.play(self.mScene.m_root_view,3,self.mScene.m_upUser:getName().." 认输");
	end

end;

function WatchModule.onWatchRoomUndo(self, data)
	self.mScene:setStatus(data.status);
	if  self.mScene.m_downUser and self.mScene.m_downUser:getUid() == data.undo_uid then
        ChatMessageAnim.play(self.mScene.m_root_view,3,self.mScene.m_downUser:getName().." 悔棋一步");
	elseif self.mScene.m_upUser and self.mScene.m_upUser:getUid() == data.undo_uid then
        ChatMessageAnim.play(self.mScene.m_root_view,3,self.mScene.m_upUser:getName().." 悔棋一步");
	end
	if  data.chessID1 ~= 0 then
		local mv = {}
		mv.moveChess = data.chessID1;
		mv.moveFrom = data.position1_1;
		mv.moveTo = data.position1_2;
		mv.dieChess = data.eatChessID1;
		self.mScene:resPonseUndoMove(mv);
	end


	if  data.chessID2 ~= 0 then
		local mv = {}
		mv.moveChess = data.chessID2;
		mv.moveFrom = data.position2_1;
		mv.moveTo = data.position2_2;
		mv.dieChess = data.eatChessID2;
		self.mScene:resPonseUndoMove(mv);
	end
end

function WatchModule.onWatchRoomUserEnter(self,packetInfo)
    if self.mScene.m_downUser then
        self.mScene:upComeIn(packetInfo.player);
    else
        self.mScene:downComeIn(packetInfo.player);
    end
end

function WatchModule.onWatchRoomMsg(self,packetInfo)
    if not packetInfo or not packetInfo.chat_msg or packetInfo.chat_msg == ""  or not packetInfo.name or packetInfo.name == "" then
		return;
	end
    if packetInfo and packetInfo.uid == UserInfo.getInstance():getUid() then
        if packetInfo.forbid_time == -1 then 
            ChessToastManager.getInstance():showSingle("亲，消息不能为空或频繁发送哦",1500);
            return;
        end;
    end;

	local msg = string.format("%s:%s",packetInfo.name,packetInfo.chat_msg);
    if OnlineRoomSceneNew.IS_NEW and self.m_watch_dialog then
        self.m_watch_dialog:addChatLog(packetInfo.name,packetInfo.chat_msg,packetInfo.uid);
    else
	    self.mScene.m_chat_dialog:addChatLog(packetInfo.name,packetInfo.chat_msg,packetInfo.uid);
        if self.mScene.m_chat_btn and not self.mScene.m_chat_dialog:isShowing() then 
           if self.mScene.m_chat_btn:getChildByName("notice") then
            self.mScene.m_chat_btn:getChildByName("notice"):setVisible(true);
           end 
        end
    end
end

function WatchModule.showFullScreen(self)
    if self.m_watch_dialog and self.m_watch_dialog:isShowing() then
        self.m_watch_dialog:fullScreen();
    end
end

function WatchModule.updataWatchNum(self,info)
    if self.m_watch_dialog and self.m_watch_dialog:isShowing() then
        self.m_watch_dialog:updataWatchNum(info);
    end
end

--更新观战dialog列表
function WatchModule.onUpdateWatchDialogView(self, data)
    if self.m_watch_dialog then
        self.m_watch_dialog:setListView(data);
    end
end

function WatchModule.resumeAnimStart(self,lastStateObj,timer)
    local w,h = self.mScene:getSize();
--    if self.m_watch_dialog then
--        self.m_watch_dialog:removeProp(1);
--        local anim = self.m_watch_dialog:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,-w,0,nil,nil);
--        if anim then
--            anim:setEvent(nil,function()
--                     self.m_watch_dialog:removeProp(1);
--                end);
--        end
--    end
end

function WatchModule.pauseAnimStart(self,newStateObj,timer)
    local w,h = self.mScene:getSize();
    if self.m_watch_dialog then
        self.m_watch_dialog:removeProp(1);
        local anim = self.m_watch_dialog:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,w,nil,nil);
        if anim then
            anim:setEvent(nil,function()
                     self.m_watch_dialog:removeProp(1);
                end);
        end
    end
end
       