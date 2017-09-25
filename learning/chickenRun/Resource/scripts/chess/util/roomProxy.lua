require("config/roomConfig");
RoomProxy = class();

function RoomProxy.getInstance()
    if not RoomProxy.instance then
        RoomProxy.instance = new(RoomProxy);
    end
    return RoomProxy.instance;
end

function RoomProxy.ctor(self)
    self.mCurRoomType = RoomConfig.ROOM_TYPE_NULL;
end

function RoomProxy.setCurRoomType(self,ctype)
    self.mCurRoomType = ctype;
end

function RoomProxy.getCurRoomType(self)
    return self.mCurRoomType or RoomConfig.ROOM_TYPE_NULL;
end

function RoomProxy.changeRoomType(self,ctype)
    self:setCurRoomType(ctype);
end

function RoomProxy.gotoTypeRoom(self,ctype)
    self:setCurRoomType(ctype);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.gotoPrivateRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_PRIVATE_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.gotoFriendRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_FRIEND_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.gotoNoviceRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_NOVICE_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.gotoIntermediateRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_INTERMEDIATE_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.gotoMasterRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_MASTER_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.gotoWatchRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_WATCH_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.goteEndgateRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_ENDGATE_ROOM);
    StateMachine.getInstance():pushState(States.EndingRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.goteConsoleRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_CONSOLE_ROOM);
    StateMachine.getInstance():pushState(States.ConsoleRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.goteReplayRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_REPLAY_ROOM);
    StateMachine.getInstance():pushState(States.ReplayRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.goteDapuRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_DAPU_ROOM);
    StateMachine.getInstance():pushState(States.CustomBoard,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.goteArenaRoom(self)
    self:setCurRoomType(RoomConfig.ROOM_TYPE_ARENA_ROOM);
    StateMachine.getInstance():pushState(States.OnlineRoom,StateMachine.STYPE_CUSTOM_WAIT);
end

function RoomProxy.getMatchRoomByMoney(self,money)
    local roomConfig = RoomConfig.getInstance();
    local compareMoney = tonumber(money) or 0;
    local retRoom = nil;
    local data = {};
    data[1] = roomConfig:getRoomTypeConfig(RoomConfig.ROOM_TYPE_NOVICE_ROOM);
    data[2] = roomConfig:getRoomTypeConfig(RoomConfig.ROOM_TYPE_INTERMEDIATE_ROOM);
    data[3] = roomConfig:getRoomTypeConfig(RoomConfig.ROOM_TYPE_MASTER_ROOM);
    for i,room in ipairs(data) do
        if room and compareMoney >= room.minmoney then
            retRoom = room;
        end
    end
    return retRoom;
end

--能进入场
function RoomProxy.canAccessRoom(self,ctype,money)
    local roomConfig = RoomConfig.getInstance();
    local room = roomConfig:getRoomTypeConfig(ctype);
	if not room or not room.minmoney or not money then
		return false;
	end
	return money >= room.minmoney;
end 

function RoomProxy.canCollapseReward(self,money)
    local roomConfig = RoomConfig.getInstance();
	local room = roomConfig:getRoomTypeConfig(RoomConfig.ROOM_TYPE_NOVICE_ROOM);

	if not room or not room.minmoney or not money then
        return	false;
	end
	--是否有满足最低场的最低金额
	return  money < room.minmoney;
end

function RoomProxy.checkCanJoinRoom(self,ctype,money)
    local roomConfig = RoomConfig.getInstance();
    local room = roomConfig:getRoomTypeConfig(ctype);

	if not room or not room.minmoney or not money then
        return	false;
	end
    return money >= room.minmoney
end
-- 私人房特有参数 以后进行重构
function RoomProxy.setSelfRoom(self,flag)
    self.mSelfRoom = flag;
end

function RoomProxy.isSelfRoom(self)
    return self.mSelfRoom or false;
end

-- 房间tid  以后重构到对于房间类里面去
function RoomProxy.setTid(self,tid)
	self.mTid = tid;
end
function RoomProxy.getTid(self)
	return self.mTid or 0;
end

function RoomProxy.getLevel(self)
    local mType = self:getCurRoomType();
    local roomConfig = RoomConfig.getInstance():getRoomTypeConfig(mType)
	return roomConfig.level or 0;
end

--观战SVID
function RoomProxy.setOBSvid(self,obsvid)
	self.m_obsvid = obsvid;
end
function RoomProxy.getOBSvid(self)
	return self.m_obsvid or 0;
end

--[Comment]
--设置当前房间倍数
function RoomProxy.setCurRoomMultiple(self,num)
	self.m_currRoomMutiple = num
end

function RoomProxy.getCurRoomMultiple(self)
	return self.m_currRoomMutiple or 1
end