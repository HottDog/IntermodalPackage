
function event_load(width,height)
    
	require("core/object");
	require("coreex/coreex");
	require("core/object");
	require("core/system");
	require("core/gameString");
	require("core/stateMachine");
    require("core/eventDispatcher");
	require("core/res");
	require("core/systemEvent");
    require("core/dict")
    require("ui/uiConfig");
    require("core/sound")   
    require("activity/activityControl")  
    require("game/chicken")
    require("game/deathLine")
    require("game/gameConstant") 
    require("game/speed")
    require("game/tourist")
    require("game/voice")
    require("game/wall1")
    require("game/map1")
    require("game/game")
    require("game/rectangle")
    require("game/wallItem")
    System.setLayoutWidth(1280);
    System.setLayoutHeight(720);
    init()
	--[[init();
    PhpConfig.setPlatform(kAppid,kAppkey,kBid,kSid,kTypePar);
    PhpConfig.initURL();
    StateMachine.getInstance():changeState(States.Hall);
    for _,status in pairs(StatesMap) do
        require(status[1]);
    end
	]]--
end

-----初始化游戏
function init()
    --print_string("000000")
    control=new(ActivityControler)
end



