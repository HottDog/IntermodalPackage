--region *.lua
--Date 2016/5/27
--此文件由[BabeLua]插件自动生成
-- FordFan
--endregion

StatisticsManager = class();

StatisticsManager.s_gameType = 
{
    [2] = "console_room";
    [5] = "online_room";
    [8] = "endgame_room";
}

StatisticsManager.s_levelType = 
{
    [0] = nil;
    [201] = "primary";
    [202] = "middle";
    [203] = "master";

}

--StatisticsManager.s_invitePLayChess = 
--{
--    [1] = "qq";
--    [2] = "wechat";
--    [3] = "chat";
--}


--PHP统计的参数与友盟统计的参数不一样
StatisticsManager.SHARE_WAY_QQ = "qq";
StatisticsManager.SHARE_WAY_WECHAT = "wexin";
StatisticsManager.SHARE_WAY_PYQ = "wexin";
StatisticsManager.SHARE_WAY_SMS = "sms";
StatisticsManager.SHARE_WAY_WEIBO = "weibo";
StatisticsManager.SHARE_WAY_CHAT = "chat";

function StatisticsManager.getInstance()
    if not StatisticsManager.s_instance then
		StatisticsManager.s_instance = new(StatisticsManager);
	end
	return StatisticsManager.s_instance;
end

function StatisticsManager.releaseInstance()
	delete(StatisticsManager.s_instance);
	StatisticsManager.s_instance = nil;
end

function StatisticsManager:ctor()
    
    EventDispatcher.getInstance():register(Event.Call,self,self.onNativeCallDone);
end

function StatisticsManager:dtor()
    

end

--[[
    统计到友盟
    参数: event_id 事件id 
          param 自定义后缀（子参数）
--]]
function StatisticsManager:onCountToUM(event_id, param)
    if not event_id then return end
    if not param then return end
    local event_info = event_id .. "," .. param;

    sys_set_int("win32_console_color",10);
    print_string("on_event_stat = " .. event_info);
    sys_set_int("win32_console_color",9);

    dict_set_string(ON_EVENT_STAT , ON_EVENT_STAT .. kparmPostfix , event_info);
    call_native(ON_EVENT_STAT);
end

--[[
    统计到PHP
    参数: event_id 事件id 
          param 自定义后缀（子参数）
--]] 
function StatisticsManager:onCountToPHP(event,info)
    if not event or not info then return end

    sys_set_int("win32_console_color",10);
    print_string("on_event_stat = " .. event);
    sys_set_int("win32_console_color",9);

    local post_data = {}
    post_data.param = {}
    post_data.param.mid = UserInfo.getInstance():getUid();
    post_data.param.event = event;
    post_data.param.sub_event = info;
    HttpModule.getInstance():execute(HttpModule.s_cmds.countToPHP,post_data);
end

--[Comment]
--统计跳过新手引导
function StatisticsManager:onCountNewUserSkip(gameType)
    local event = "user_guide";
    local param = StatisticsManager.s_gameType[gameType];
    self:onCountToPHP(event,gameType);
end

--[Comment]
--统计快速开始 
function StatisticsManager:onCountQuickPlay(gotoRoom)
    local event = "quick_start";
    local roomLevel = tonumber(gotoRoom.level); 
    self:onCountToPHP(event,roomLevel);
end

--[Comment]
--统计邀请好友对战
function StatisticsManager:onCountInvitePlayChess(way)
    local event = "flight_invite";
    self:onCountToPHP(event,way);
end

--[Comment]
--统计分享好友邀请
function StatisticsManager:onCountInviteFriends(way)
    local event = "game_share";
    self:onCountToPHP(event,way);
end

--[Comment]
-- event : php 定义的类型
-- way   : 分享类型
function StatisticsManager:onCountShare(event,way)
    if not event or not way then return end
    self:onCountToPHP(event,way);
end

--[Comment]
--统计同屏模式
function StatisticsManager:onCountCustomBoard(way)
    local event = "put_chess";
    self:onCountToPHP(event,way);
end

