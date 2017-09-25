-- ChatRoomData.lua
-- Author : FordFan
-- Date   : 2015/8/31
-- Update : LeoLi 2016/7/19

require("util/game_cache_data");

ChatRoomData = class(GameCacheData,false);

ChatRoomData.ctor = function(self)
    self.m_dict = new(Dict,"chat_rom_list");
    self.m_dict:load();
end

ChatRoomData.init = function(self)
--    self:getRoomData();
end

ChatRoomData.refresh = function(self)
    
end

ChatRoomData.getInstance = function()
    if not ChatRoomData.instance then
		ChatRoomData.instance = new(ChatRoomData);
	end
	return ChatRoomData.instance; 
end

ChatRoomData.dtor = function(self)
end

ChatRoomData.clear = function(self)
    delete(ChatRoomData.instance);
    ChatRoomData.instance = nil;
end

-- 读取房间最后消息
ChatRoomData.getLastRoomMsg = function(self)
    local tabStr = {};
    local tabjson = self:getString(GameCacheData.ROOM_LAST_MSG_DATA..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "data","");
    tabStr = json.decode(tabjson);
    return tabStr;
end
-- 保存房间最后消息
ChatRoomData.saveRoomData = function(self,roomId,time)
    local jsonMsg = self:getString(GameCacheData.ROOM_LAST_MSG_DATA..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "data", "");
    local jsonHistoryMsg = self:getString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),"");
    local lastMsgTab = json.decode(jsonMsg);
    local historyMsgTab = json.decode(jsonHistoryMsg);

    local lastMsg = {};
    if historyMsgTab then
        lastMsg.roomid = roomId;
        lastMsg.name = historyMsgTab[#historyMsgTab].name;
        lastMsg.last_msg = historyMsgTab[#historyMsgTab].msg;
        lastMsg.last_msg_id = historyMsgTab[#historyMsgTab].msg_id;
        lastMsg.time = historyMsgTab[#historyMsgTab].time;
    else
        lastMsg.roomid = roomId;
        lastMsg.name = nil;
        lastMsg.last_msg = "";
        lastMsg.last_msg_id = 0;
        lastMsg.time = time;
    end;

    if not lastMsgTab then 
        lastMsgTab = {};
        table.insert(lastMsgTab,lastMsg);
    else
        for i = 1,#lastMsgTab do
            if lastMsgTab[i].roomid == roomId then
                lastMsgTab[i] = lastMsg;
                self:saveString(GameCacheData.ROOM_LAST_MSG_DATA..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "data",json.encode(lastMsgTab));
                return;
            end
        end
        table.insert(lastMsgTab,lastMsg); 
    end
    self:saveString(GameCacheData.ROOM_LAST_MSG_DATA..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "data",json.encode(lastMsgTab));
end
--其他玩家信息
ChatRoomData.getChatUserInfo = function(self)
    local infoTab = {};
    local tab = self:getString(GameCacheData.CHAT_USER_INFO..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "user_info" ,"");
    infoTab = json.decode(tab);
    return infoTab;
end

--保存玩家信息
ChatRoomData.saveChatOtherUserInfo = function(self,userInfo)
    local  tab = {};
    local infoJson = self:getString(GameCacheData.CHAT_USER_INFO..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "user_info","");
    local infoTab = json.decode(infoJson);
    if infoTab then
         tab = infoTab;
    end
    for i,v in pairs(userInfo) do 
        table.insert(tab,v);
    end
    self:saveString(GameCacheData.CHAT_USER_INFO..UserInfo.getInstance():getUid()..(kDebug and "_debug_" or "_release_")  .. "user_info",json.encode(tab));
end

-- 第一次进入聊天室使用，拉取最新消息
ChatRoomData.getHistoryMsg = function(self,roomId)
    local jsonStr = self:getString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),"");
    local tab = json.decode(jsonStr);
    local showMsg = {};
    if tab and #tab > 15 then
        for i = #tab, #tab -15+1,-1 do
            table.insert(showMsg,1,tab[i]);
        end;
        return showMsg;
    else 
        return tab;
    end;
end
-- 聊天室内向上拉取历史消息使用，拉取指定时间消息
ChatRoomData.getHistoryMsgByTime = function(self, roomId, time)
    local jsonStr = self:getString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),"");
    local tab = json.decode(jsonStr);
    local showMsg = {};
    if tab and #tab > 0 then
        for i = #tab , 1, -1 do 
            if tab[i] and tab[i].time < time then
                table.insert(showMsg,tab[i]);
            end;
            if #showMsg == 15 then
                return showMsg;
            end;
        end;
    end;
    return nil;
end;

-- 获取聊天室所有的消息
ChatRoomData.getAllHistoryMsg = function(self, roomId)
    local jsonStr = self:getString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),"");
    local tab = json.decode(jsonStr);
    if tab and #tab > 0 then
        return tab;
    end;    
end;

-- 保存拉取到的历史消息，一次保存很多条
ChatRoomData.saveHistoryMsg = function(self,msgUnread,roomId)
    local msgStr = self:getString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),"");
    local msgHistoryTab = {};
    local tab = json.decode(msgStr);
    if tab then
        for i,v in pairs(msgUnread) do
            if #tab >= 2000 then
                table.remove(tab,1);
            end;
            table.insert(tab,v);
        end
        msgHistoryTab = tab;
    else
        for i,v in pairs(msgUnread) do
            table.insert(msgHistoryTab,v);
        end
    end
    self:saveString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),json.encode(msgHistoryTab));
end


-- 保存聊天室正在聊的消息，一次保存一条
ChatRoomData.saveRecvMsg = function(self,msgData,roomId)
    local msgStr = self:getString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),"");
    local msgHistoryTab = {};
    local tab = json.decode(msgStr);
    if tab then
        if #tab >= 2000 then
            table.remove(tab,1);
        end;
        table.insert(tab,msgData);
        msgHistoryTab = tab;
    else
        table.insert(msgHistoryTab,msgData);
    end
   self:saveString(GameCacheData.HISTORY_MSG.."_"..roomId.."_"..UserInfo.getInstance():getUid()..(kDebug and "_debug" or "_release"),json.encode(msgHistoryTab));
end


