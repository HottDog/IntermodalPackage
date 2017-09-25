
require(MODEL_PATH.."online/private/privateScene");
require("chess/util/roomProxy");

SchemesProxy = class();
SchemesProxy.SCHEMA = "boyaachess";
SchemesProxy.HOST = SchemesProxy.SCHEMA .. "://v1";
function SchemesProxy.getIntentData()
    call_native("getIntentData");
    return dict_get_string("Schemes","IntentData") or "";
end

function SchemesProxy.clearIntentData()
    call_native("clearIntentData");
end

function SchemesProxy.onSchemesEvent(controler)
    local str = SchemesProxy.getIntentData();
    Log.i("SchemesProxy onSchemesEvent :".. (str or "nil") );
    SchemesProxy.clearIntentData();
    event = SchemesProxy.analyzeSchemesStr(str,true,controler);
    if type(event) == "function" then
        event();
    end
end

function SchemesProxy.analyzeSchemesStr(str,isNotEncode,controler)
    local url = require("libs/url");
    local u = url.parse(str);
    if u.scheme ~= SchemesProxy.SCHEMA then return end
    local dataStr = u.query.data;
    Log.i("SchemesProxy query.data :".. (dataStr or "nil") );
    local data = nil;
    local decode =  function() 
        if not isNotEncode and u.query.isEncode ~= "false" then
            dataStr = SchemesProxy.decodeStr(dataStr);
        end
        data = json.decode(dataStr); 
    end
    if not pcall(decode) then 
        Log.i("SchemesProxy query.data : error");
        return 
    end
    Log.i("SchemesProxy query.data :".. (json.encode(data) or "nil") );
    if type(data) == "table" then
        local method = data.method;
        if method == "gotoCustomEndgateRoom" then
            local params = data.params;
            if type(params) == 'table' then
                return function()
                        kEndgateData:setPlayCreateEndingData(params.data);
                        StateMachine.getInstance():pushState(States.playCreateEndgate,StateMachine.STYPE_CUSTOM_WAIT);
                    end,data;
            end
        elseif method == "gotoPrivateRoom" then
            local params = data.params;
            if type(params) == 'table' then
                return function()
                        if RoomProxy.getInstance():getCurRoomType() ~= RoomConfig.ROOM_TYPE_NULL then
                            ChessToastManager.getInstance():showSingle("游戏房间内不支持跳转!")
                            return 
                        end
                        -- 私人房大厅特殊处理
                        if controler ~= nil and typeof(controler,PrivateController) then
                            Log.i("SchemesProxy loginStartCustomRoom");
                            if controler.m_view and controler.m_view.loginStartCustomRoom then
                                RoomProxy.getInstance():setTid(params.tid);
                                controler.m_view:loginStartCustomRoom(params.pwd);
                            end
                        else
                            StateMachine.getInstance():pushState(States.PrivateHall,StateMachine.STYPE_CUSTOM_WAIT);
                            PrivateScene.setGotoRoom(params.tid,params.pwd);
                        end
                    end,data;
            end
        elseif method == "goto" then
            local params = data.params;
            if type(params) == 'table' then
                return function()
                        if RoomProxy.getInstance():getCurRoomType() ~= RoomConfig.ROOM_TYPE_NULL then
                            ChessToastManager.getInstance():showSingle("游戏房间内不支持跳转!")
                            return 
                        end
                        local jumpScene = params.jumpScene;
                        if jumpScene and jumpScene ~= 0 and StatesMap[jumpScene] then
                            StateMachine.getInstance():pushState(jumpScene,StateMachine.STYPE_CUSTOM_WAIT);
                        end
                    end,data;
            end
        end
    end
end

function SchemesProxy.getMySchemesUrl(str)
    local url = require("libs/url");
    local params = {};
    params.data = json.encode(str);
    params.isEncode = false
    params.uid = UserInfo.getInstance():getUid();
    local u = url.parse(SchemesProxy.HOST);
    u:setQuery(params);
    return u:build();
end

function SchemesProxy.getWebSchemesUrl(str)
    local url = require("libs/url");
    local params = {};
    params.data = json.encode(str);
    params.isEncode = false
    params.uid = UserInfo.getInstance():getUid();
    _,params.down_url = UserInfo.getInstance():getGameShareUrl();
    local u = url.parse(UserInfo.getInstance():getInviteFriendsUrl());
    u:setQuery(params);
    return u:build();
end

SchemesProxy.KEY = "boyaachess";

function SchemesProxy.encodeStr(str)
    if type(str) ~= "string" then return "" end
    local len = #str;
    local charTab = { string.byte(str,1,len) };
    Log.i( table.concat(charTab," "));
    local keyTab = { string.byte(SchemesProxy.KEY,1, string.len(SchemesProxy.KEY)) };
    local ret = {};
    local i = 1;
    local j = 1;
    while next(charTab) do
        local char = table.remove(charTab,1);
        ret[2*i-1] = bit.bxor(char,keyTab[j]);
        ret[2*i] = keyTab[j];
        i = i+1;
        j = j+1;
        if j > #keyTab then
            j = 1;
        end
    end
    Log.i( table.concat(ret," "));
    return string.char(unpack(ret));
end

function SchemesProxy.decodeStr(str)
    if type(str) ~= "string" then return "" end
    local len =  #str;
    local charTab = { string.byte(str,1,len) };
    Log.i( table.concat(charTab," "));
    local keyTab = { string.byte(SchemesProxy.KEY,1, string.len(SchemesProxy.KEY)) };
    local ret = {};
    local i = 1;
    local j = 1;
    while next(charTab) do
        local char = table.remove(charTab,1);
        table.remove(charTab,1)
        ret[i] = bit.bxor(char,keyTab[j]);
        i = i+1;
        j = j+1;
        if j > #keyTab then
            j = 1;
        end
    end
    Log.i( table.concat(ret," "));
    return string.char(unpack(ret));
end