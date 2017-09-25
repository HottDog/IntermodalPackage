require("config/boardres");

UserSetInfo = class();

UserSetInfo.getInstance = function()
    if not UserSetInfo.instance then
        UserSetInfo.instance = new(UserSetInfo);
    end
    return UserSetInfo.instance;
end

UserSetInfo.ctor = function(self)
    
end

UserSetInfo.getMySetType = function(self)
    local tab = {};
    local tempType = GameCacheData.getInstance():getString(GameCacheData.HEADFRAME,"sys");
    tab.picture_frame = tempType; --UserSetInfoHeadFrameMapConfig[tempNum].my_set;
    tempType = GameCacheData.getInstance():getString(GameCacheData.CHESSPIECE,"sys");
    tab.piece = tempType; --UserSetInfoChessMapConfig[tempNum].my_set;
    tempType = GameCacheData.getInstance():getString(GameCacheData.BOARDTYPE,"sys");
    tab.board = tempType; --UserSetInfoBoardMapConfig[tempNum].my_set;
    return tab
end

--[Comment]
-- 设置棋子类型
-- chessPieceType: 棋盘類型 string
UserSetInfo.setBoardType = function(self,boardType)
--    self.m_boardType = boardType;
    local _boardType = "sys";
    if boardType and boardType ~= "" then
        _boardType = boardType
    end
    GameCacheData.getInstance():saveString(GameCacheData.BOARDTYPE,_boardType);
end

--[Comment]
-- 获得棋盘类型
UserSetInfo.getBoardType = function(self)
    local _boardType = GameCacheData.getInstance():getString(GameCacheData.BOARDTYPE,"sys");
	return _boardType;
end

--[Comment]
-- 设置棋子类型
-- chessPieceType: 棋子類型 string
UserSetInfo.setChessPieceType = function(self,chessPieceType)
    local _chessPieceType = "sys";
    if chessPieceType and chessPieceType ~= "" then
        _chessPieceType = chessPieceType
    end
    GameCacheData.getInstance():saveString(GameCacheData.CHESSPIECE,_chessPieceType);
end

--[Comment]
-- 获得棋子类型
UserSetInfo.getChessPieceType = function(self)
    local _chessPieceType = GameCacheData.getInstance():getString(GameCacheData.CHESSPIECE,"sys");
	return _chessPieceType;
end

--[Comment]
-- 设置头像框类型
-- headFrameType: 頭像類型 string
UserSetInfo.setHeadFrameType = function(self,headFrameType)
    local _headFrameType = "sys";
    if headFrameType and headFrameType ~= "" then
        _headFrameType = headFrameType
    end
	GameCacheData.getInstance():saveString(GameCacheData.HEADFRAME,_headFrameType);
end

--[Comment]
-- 获得头像框类型
UserSetInfo.getHeadFrameType = function(self)
    local _headFrameType = GameCacheData.getInstance():getString(GameCacheData.HEADFRAME,"sys");
	return _headFrameType;
end

--[Comment]
--获得棋盘类型资源
UserSetInfo.getBoardRes = function(self)
    local boardType = GameCacheData.getInstance():getString(GameCacheData.BOARDTYPE,"sys");
    for k,v in pairs(UserSetInfoBoardMapConfig) do
        if v.my_set == boardType then
            return v.board;
        end
    end
    return "common/background/room_bg.png"
end

--[Comment]
--棋子类型资源
UserSetInfo.getChessRes = function(self)
    local pieceType = GameCacheData.getInstance():getString(GameCacheData.CHESSPIECE,"sys");
    for k,v in pairs(UserSetInfoChessMapConfig) do
        if v.my_set == pieceType then
            return v.piece_res;
        end
    end
    return boardres_map
end

--[Comment]
--头像框类型资源
UserSetInfo.getFrameRes = function(self,frameType)
    local headFrameType = nil
    if frameType then
        headFrameType = frameType
    else
        headFrameType = GameCacheData.getInstance():getString(GameCacheData.HEADFRAME,"sys");
    end
    for k,v in pairs(UserSetInfoHeadFrameMapConfig) do
        if v.my_set == headFrameType then
            return v;
        end
    end
    return UserSetInfoHeadFrameMapConfig[0]
end

--[Comment]
--更新设置
--data: 用户设置数据
UserSetInfo.updataSelectData = function(self,data)
    self:setHeadFrameType(data.picture_frame);
    self:setChessPieceType(data.piece);  
    self:setBoardType(data.board);
end

--棋盘、棋子、头像框 列表
--[Comment]
--获得所有棋盘，棋子，头像框的数据
UserSetInfo.getAllSelectRes = function(self)
    local list = {};
    list[1] = UserSetInfoHeadFrameMapConfig;
    list[2] = UserSetInfoChessMapConfig;
    list[3] = UserSetInfoBoardMapConfig;
    local new_prop_info,_ = UserInfo.getInstance():getNewPropInfo();
    --更新棋盘解锁状态
    for k,v in pairs(new_prop_info) do
        if v and tonumber(v.is_enabled) == 1 then
            local boardItem = list[3][tonumber(v.prop_id)];
            if boardItem then
                boardItem['is_enabled']  = 1;
            end
            local frameItem = list[1][tonumber(v.prop_id)];
            if frameItem then
                frameItem['is_enabled']  = 1;
            end
        end
    end

    --如果是vip则改变 is_enabled 属性状态
    local ret = UserInfo.getInstance():getIsVip()
    if ret and ret == 1 then
        for i = 1,3 do
            list[i][1]['is_enabled'] = ret;
        end
    end

    return list;
end

function UserSetInfo.getBgImgRes(self)
    local boardType = GameCacheData.getInstance():getString(GameCacheData.BOARDTYPE,"sys");
    for k,v in pairs(UserSetInfoBoardMapConfig) do
        if v.my_set == boardType then
            return v.bg_img;
        end
    end
end

--[Comment]
--更新个性装扮选择状态
function UserSetInfo.updateSelectItem(self)
    local tab,_ = UserInfo.getInstance():getNewPropInfo();
    local boardType = self:getBoardType();
    if boardType == "sys" or boardType == "vip" then

    else
        if not tab or next(tab) == nil then
            self:setBoardType();
            return
        end
        for k,v in pairs(tab) do
            if tonumber(v.is_enabled) == 0  then
                if v.my_set == boardType then
                    self:setBoardType();
                end
            end
        end
    end
end


-- 棋盘
UserSetInfoBoardMapConfig = 
{
    [0] = {
        ['board'] = boardres_map['chess_board.png'];
        ['board_img'] = "settingicon/normal_board.png",
        ['board_res'] = boardres_map,
        ['bg_img'] = "common/background/room_bg.png",
        ['name'] = "默认",
        ['settype']   = 3,
        ['property']  = 0,
        ['is_enabled']  = 1,
        ['my_set'] = "sys",
    },
    [1] = {
        ['board'] = boardres_map1['chess_board.png'];
        ['board_img'] = "settingicon/vip_board.png",
        ['board_res'] = boardres_map1,
        ['bg_img'] = "common/background/room_bg.png",
        ['name'] = "会员棋盘",
        ['settype']   = 3,
        ['property']  = 1,
        ['is_enabled']  = -1,
        ['my_set'] = "vip",
    },
    [14] = {
        ['board'] = board_res_map['zhulin_board.png'];
        ['board_img'] = "settingicon/zhu_lin.png",
        ['board_res'] = boardres_map1,
        ['bg_img'] = "common/background/zhulin_bg.png",
        ['name'] = "竹林棋盘",
        ['settype']   = 3,
        ['property']  = 1,
        ['is_enabled']  = 0,
        ['my_set'] = "zhu_lin",
    },
    [15] = {
        ['board'] = board_res_map['hupan_board.png'];
        ['board_img'] = "settingicon/hu_pan.png",
        ['board_res'] = boardres_map1,
        ['bg_img'] = "common/background/hupan_bg.png",
        ['name'] = "湖畔棋盘",
        ['settype']   = 3,
        ['property']  = 1,
        ['is_enabled']  = 0,
        ['my_set'] = "hu_pan",
    },
}

-- 头像框
UserSetInfoHeadFrameMapConfig = 
{
    [0] = {
        ['frame_res'] = nil,
        ['name'] = "默认",
        ['visible']   = false,
        ['settype']   = 1,
        ['property']  = 0,
        ['is_enabled']  = 1,
        ['my_set'] = "sys",
    },
    [1] = {
        ['frame_res'] = "vip/vip_%d.png",
        ['name'] = "会员头像",
        ['visible']   = true,
        ['settype']   = 1,
        ['property']  = 1,
        ['is_enabled']  = -1,
        ['my_set'] = "vip",
    },
    [21] = {
        ['frame_res'] = "vip/sliver_%d.png",
        ['name'] = "白银头像",
        ['visible']   = true,
        ['settype']   = 1,
        ['property']  = 1,
        ['is_enabled']  = 0,
        ['my_set'] = "sliver",
    },
}
-- 棋子
UserSetInfoChessMapConfig = 
{
    [0] = {
        ['piece_res']  = boardres_map,
        ['name'] = "默认",
        ['piece_bg']   = boardres_map["piece.png"],
        ['piece_img']  = boardres_map["rking.png"],
        ['settype']   = 2,
        ['property']  = 0,
        ['is_enabled']  = 1,
        ['my_set'] = "sys",
    },
    [1] = {
        ['piece_res'] = boardres_map1,
        ['name'] = "会员棋子",
        ['piece_bg']   = boardres_map1["piece.png"],
        ['piece_img']  = boardres_map1["rking.png"],
        ['settype']   = 2,
        ['property']  = 1,
        ['is_enabled']  = -1,
        ['my_set'] = "vip",
    },
}

UserSetInfo.getInstance();