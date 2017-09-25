
require(BASE_PATH.."chessScene");
require("view/selectButton_nobg");
require("dialog/progress_dialog");
require("dialog/create_room_dialog");
require("dialog/replay_help_dialog");
require("animation/TranslateShakeAnim");
require("ui/gallery");
require(VIEW_PATH .."replay_scene_node");

ReplayScene = class(ChessScene);

ReplayScene.REPLAY  = 1;-- 最近对局
ReplayScene.MYSAVE  = 2;-- 我的收藏
ReplayScene.SUGGEST = 3;-- 棋友动态(推荐)

ReplayScene.s_controls = 
{
    bamboo_left_dec             = 1;
    bamboo_right_dec            = 2;
    tea_dec                     = 3;
    stone_dec                   = 4;
    back_btn                    = 5;
    title_view                  = 6;
    title_bg                    = 7;
    title_subbg                 = 8;
    replay_content_view         = 9;
    replayList_view             = 10;
    dapu_content_view           = 11;
    dapuList_view               = 12;
    bottom_view                 = 13;
    title_mysave                = 14;
    btns_content_view           = 15;
    suggest_content_view        = 16;
    suggestList_view            = 17;
    clear_all_btn               = 18;
    clear_all_btn_bg            = 19;
}

ReplayScene.s_cmds = 
{
    save_mychess                = 1;
    get_mychess                 = 2;
    open_self_chess             = 3;
    del_mysave_chess            = 4;
    get_suggestchess            = 5;
}

ReplayScene.ctor = function(self,viewConfig,controller)
	self.m_ctrls = ReplayScene.s_controls;
    self.m_cur_state = ReplayScene.REPLAY;
    self:initView();
end 

ReplayScene.resume = function(self)
    ChessScene.resume(self);
    self:loadTips();
end;

ReplayScene.pause = function(self)
	ChessScene.pause(self);
    self:removeAnimProp();
end 


ReplayScene.dtor = function(self)
    self.m_title_subbg:removeProp(1);
    delete(self.m_animY_down);
    self.m_animY_down = nil;
    delete(self.m_init_anim);
    delete(self.m_anim_start);
    delete(self.m_anim_end);
    delete(self.m_chioce_dialog);
end 

------------------------------function------------------------------



ReplayScene.initView = function(self)
    --bg
    self.m_bamboo_left_dec = self:findViewById(self.m_ctrls.bamboo_left_dec); 
    self.m_bamboo_right_dec = self:findViewById(self.m_ctrls.bamboo_right_dec); 
    self.m_tea_dec = self:findViewById(self.m_ctrls.tea_dec); 
    self.m_stone_dec = self:findViewById(self.m_ctrls.stone_dec);

    --title
    self.m_title_view = self:findViewById(self.m_ctrls.title_view);
    self.m_back_btn = self:findViewById(self.m_ctrls.back_btn);
    self.m_title_bg = self:findViewById(self.m_ctrls.title_bg);
    self.m_title_subbg = self:findViewById(self.m_ctrls.title_subbg);
    self.m_clear_btn_bg = self:findViewById(self.m_ctrls.clear_all_btn_bg);
    self.m_clear_all_btn = self:findViewById(self.m_ctrls.clear_all_btn);
    self.m_clear_all_btn:setOnClick(self,self.clearAllRecentData);

    -- btns_content
    self.m_btns_content_view = self:findViewById(self.m_ctrls.btns_content_view);
        
       self.m_recent_btn = self.m_btns_content_view:getChildByName("replay_btn"):getChildByName("btn");
       self.m_recent_btn:setOnClick(self, self.showRecentList);
       self.m_recent_btn_txt = self.m_recent_btn:getChildByName("btn_txt");
       self.m_recent_btn_txt:setText("最近对局");
       self.m_recent_btn_txt:setColor(215,75,45);
       self.m_recent_tips = self.m_btns_content_view:getChildByName("replay_btn"):getChildByName("tips");
       self.m_recent_line = self.m_btns_content_view:getChildByName("replay_btn"):getChildByName("select_line");

       self.m_mysave_btn = self.m_btns_content_view:getChildByName("dapu_btn"):getChildByName("btn");
       self.m_mysave_btn:setOnClick(self, self.showMySaveList);
       self.m_mysave_btn_txt = self.m_mysave_btn:getChildByName("btn_txt");
       self.m_mysave_btn_txt:setText("我的收藏");
       self.m_mysave_btn_txt:setColor(120,80,65);
       self.m_mysave_tips = self.m_btns_content_view:getChildByName("dapu_btn"):getChildByName("tips");
       self.m_mysave_line = self.m_btns_content_view:getChildByName("dapu_btn"):getChildByName("select_line");

       self.m_suggest_btn = self.m_btns_content_view:getChildByName("suggest_btn"):getChildByName("btn");
       self.m_suggest_btn:setOnClick(self, self.showSuggestList);
       self.m_suggest_btn_txt = self.m_suggest_btn:getChildByName("btn_txt");
       self.m_suggest_btn_txt:setText("棋友推荐");
       self.m_suggest_btn_txt:setColor(120,80,65);
       self.m_suggest_tips = self.m_btns_content_view:getChildByName("suggest_btn"):getChildByName("tips");
       self.m_suggest_line = self.m_btns_content_view:getChildByName("suggest_btn"):getChildByName("select_line");

    -- content
        self.m_replay_content_view = self:findViewById(self.m_ctrls.replay_content_view);
            -- 最近对战
            self.m_replayList_view = self.m_replay_content_view:getChildByName("replayList_view");
            self.m_replay_empty_tips =  self.m_replay_content_view:getChildByName("enpty_tips");
        self.m_dapu_content_view  = self:findViewById(self.m_ctrls.dapu_content_view);
            -- 我的收藏
            self.m_dapuList_view = self.m_dapu_content_view:getChildByName("dapuList_view");
            self.m_dapu_empty_tips =  self.m_dapu_content_view:getChildByName("enpty_tips");
        self.m_suggest_content_view  = self:findViewById(self.m_ctrls.suggest_content_view);
            -- 棋友动态(推荐)
            self.m_suggestList_view = self.m_suggest_content_view:getChildByName("suggestList_view");
            self.m_suggestList_view:setOnScroll(self, self.onSuggestLVScroll);
            self.m_suggest_empty_tips =  self.m_suggest_content_view:getChildByName("enpty_tips");
    -- bottom_view
    self.m_bottom_view = self:findViewById(self.m_ctrls.bottom_view);

    -- decoration
    self.m_teapot_dec = self.m_root:getChildByName("tea_dec");
    -- help_btn
    self.m_help_btn = self.m_root:getChildByName("help_btn");
    self.m_help_btn:setOnClick(self,self.showHelpInfo);

    -- show_recent    
    delete(self.m_init_anim);
    self.m_init_anim = new(AnimInt,kAnimNormal,0,1,1,1000); 
    if not self.m_init_anim then return end;
    self.m_init_anim:setEvent(self,function() 
        self:showRecentList();
    end);
end;

ReplayScene.showHelpInfo = function(self)
    if not self.m_help_dialog then
        self.m_help_dialog = new(ReplayHelpDialog);
    end;
    self.m_help_dialog:show();
end;

ReplayScene.onSuggestLVScroll = function(self,scroll_status,diff, totalOffset)
    local lvW, lvH = self.m_suggestList_view:getSize();
    local trueOffset = self.m_suggest_list_num * ReplayChessItem.HEIGHT - lvH;
    if totalOffset and trueOffset > 0 then
        if math.abs(tonumber(totalOffset)) >  trueOffset + 50 then
            Log.i("ReplayScene.onSuggestLVScroll---> scroll_status-->");
            self:getSuggestChess(self.m_suggest_list_num,5); 
        end;
    end;
end;




-- 本地数据过多，会有卡顿，加个提示增加体验；加载完成去掉Toast
ReplayScene.loadTips = function(self)
    ChessToastManager.getInstance():showSingle("正在加载数据",1000);
end

ReplayScene.setAnimItemEnVisible = function(self,ret)
    self.m_bamboo_left_dec:setVisible(ret);
    self.m_bamboo_right_dec:setVisible(ret);
end

ReplayScene.resumeAnimStart = function(self,lastStateObj,timer,func)
    self:removeAnimProp(); 
   local duration = timer.duration;
   local waitTime = timer.waitTime
   local delay = waitTime+duration;

    delete(self.m_anim_start);
    self.m_anim_start = new(AnimInt,kAnimNormal,0,1,delay,-1);
    if self.m_anim_start then
        self.m_anim_start:setEvent(self,function()
            self:setAnimItemEnVisible(true);
            delete(self.m_anim_start);
        end);
    end

   local lw,lh = self.m_bamboo_left_dec:getSize();
   self.m_bamboo_left_dec:addPropTranslate(1,kAnimNormal,waitTime,delay,-lw,0,-10,0);
   local rw,rh = self.m_bamboo_right_dec:getSize();
   self.m_bamboo_right_dec:addPropTranslate(1,kAnimNormal,waitTime,delay,rw,0,-10,0);
end


ReplayScene.pauseAnimStart = function(self,newStateObj,timer)
   local duration = timer.duration;
   local waitTime = timer.waitTime
   local delay = waitTime+duration;

   delete(self.m_anim_end);
   self.m_anim_end = new(AnimInt,kAnimNormal,0,1,delay,-1);
   if self.m_anim_end then
        self.m_anim_end:setEvent(self,function()
            self:removeAnimProp();
            if not self.m_root:checkAddProp(1) then 
		        self.m_root:removeProp(1);
	        end
            delete(self.m_anim_end);
        end);
   end

   local lw,lh = self.m_bamboo_left_dec:getSize();
   self.m_bamboo_left_dec:addPropTranslate(1,kAnimNormal,waitTime,-1,0,-lw,0,-10);
   local rw,rh = self.m_bamboo_right_dec:getSize();
   local anim = self.m_bamboo_right_dec:addPropTranslate(1,kAnimNormal,waitTime,-1,0,rw,0,-10);
   if anim then
        anim:setEvent(self,function()
            self:setAnimItemEnVisible(false);
        end);
   end
end


ReplayScene.removeAnimProp = function(self)
    self.m_bamboo_right_dec:removeProp(1);
    self.m_bamboo_left_dec:removeProp(1);
end



ReplayScene.setBtnSelected = function(self, isSelected)
    if self.m_cur_state == ReplayScene.REPLAY then
        -- btn_txt颜色
        self.m_recent_btn_txt:setColor(215,75,45);
        self.m_mysave_btn_txt:setColor(120,80,65);
        self.m_suggest_btn_txt:setColor(120,80,65);
        -- line
        self.m_recent_line:setVisible(true);
        self.m_mysave_line:setVisible(false);
        self.m_suggest_line:setVisible(false);
        -- listView
        self.m_replay_content_view:setVisible(true);
        self.m_dapu_content_view:setVisible(false);
        self.m_suggest_content_view:setVisible(false);
        -- clear_btn_bg
        self.m_clear_btn_bg:setVisible(true);
    elseif self.m_cur_state == ReplayScene.MYSAVE then
        -- btn_txt颜色
        self.m_recent_btn_txt:setColor(120,80,65);
        self.m_mysave_btn_txt:setColor(215,75,45);
        self.m_suggest_btn_txt:setColor(120,80,65);
        -- line
        self.m_recent_line:setVisible(false);
        self.m_mysave_line:setVisible(true);
        self.m_suggest_line:setVisible(false);
        -- listView
        self.m_replay_content_view:setVisible(false);
        self.m_dapu_content_view:setVisible(true);
        self.m_suggest_content_view:setVisible(false);
        -- clear_btn_bg
        self.m_clear_btn_bg:setVisible(false);
    elseif self.m_cur_state == ReplayScene.SUGGEST then
        -- btn_txt颜色
        self.m_recent_btn_txt:setColor(120,80,65);
        self.m_mysave_btn_txt:setColor(120,80,65);
        self.m_suggest_btn_txt:setColor(215,75,45);
        -- line
        self.m_recent_line:setVisible(false);
        self.m_mysave_line:setVisible(false);
        self.m_suggest_line:setVisible(true);
        -- listView
        self.m_replay_content_view:setVisible(false);
        self.m_dapu_content_view:setVisible(false);
        self.m_suggest_content_view:setVisible(true);

        -- clear_btn_bg
        self.m_clear_btn_bg:setVisible(false);
    end;
end;


ReplayScene.resetListViewItemClick = function(self, flag)
    if self.m_cur_state == ReplayScene.REPLAY then
        if flag then
            self.m_replayList_view:setOnItemClick(self, function() end);
        else
            self.m_replayList_view:setOnItemClick(self, self.onRecentItemClick);
        end;
    elseif self.m_cur_state == ReplayScene.MYSAVE then
        if flag then
            self.m_dapuList_view:setOnItemClick(self, function() end);
        else
            self.m_dapuList_view:setOnItemClick(self, self.onMysaveItemClick);
        end;        

    elseif self.m_cur_state == ReplayScene.SUGGEST then
        if flag then
            self.m_suggestList_view:setOnItemClick(self, function() end);
        else
            self.m_suggestList_view:setOnItemClick(self, self.onSuggestItemClick);
        end;    

    end;
end;



-- 显示最近棋局列表加动画
ReplayScene.showRecentList = function(self)
    self.m_cur_state = ReplayScene.REPLAY;
    self:setBtnSelected(true);
    ReplayChessItem.s_room = self;
    ReplayChessItem.s_type = ReplayScene.REPLAY;
    -- 加载数据
    self:showRecentData();
end;



ReplayScene.showMySaveList = function(self)
    self.m_cur_state = ReplayScene.MYSAVE;
    self:setBtnSelected(true);
    ReplayChessItem.s_room = self;
    ReplayChessItem.s_type = ReplayScene.MYSAVE;
    -- 加载数据
    self:showMySaveChess(true);
end;

-- 加载棋友推荐
ReplayScene.showSuggestList = function(self)
    self.m_cur_state = ReplayScene.SUGGEST;
    self.m_suggest_list_num = 0;
    self:setBtnSelected(true);
    ReplayChessItem.s_room = self;
    ReplayChessItem.s_type = ReplayScene.SUGGEST;
    -- 加载数据
    self:showSuggestChess();
end;


-- 加载最近对局数据
ReplayScene.showRecentData = function(self)
    local data = self:getRecentChess();
    if not next(data) or not data  then 
--        ChessToastManager.getInstance():showSingle("暂无最近对局",1500);
        self.m_recent_tips:setText("0/"..UserInfo.getInstance():getSaveChessManualLimit());
        self.m_replay_empty_tips:setVisible(true);
        return 
    else
        ChessToastManager.getInstance():clearAllToast();
        self.m_recent_tips:setText(#data .."/"..UserInfo.getInstance():getSaveChessManualLimit());
        self.m_replay_empty_tips:setVisible(false);
    end;    
    -- 本地棋谱一次性加载完毕，所以不用每次加载
    if not self.m_recent_adapter then
        self.m_recent_adapter = new(CacheAdapter,ReplayChessItem,data);
        self.m_replayList_view:setAdapter(self.m_recent_adapter);
    end;
end;

-- 获取本地保存的最近对局
ReplayScene.getRecentChess = function(self)
    local uid = UserInfo.getInstance():getUid();
	local keys = GameCacheData.getInstance():getString(GameCacheData.RECENT_DAPU_KEY .. uid,"");
    local data = {};
	if keys == "" or keys == GameCacheData.NULL then
		return data;
	end
	local keys_table = lua_string_split(keys, GameCacheData.chess_data_key_split);
	local index = 1;
	for key , value in pairs(keys_table) do
		local mvData_str = GameCacheData.getInstance():getString(value .. uid,"");
		if value ~= "" and value ~= GameCacheData.NULL 
				and mvData_str ~= "" and mvData_str ~= GameCacheData.NULL then

--			local mvData_json = json.decode(mvData_str);
            local mvData_json = mvData_str;
			index = index + 1;
			table.insert(data,mvData_json);
		end
	end
    return data;
end;

-- 更新最近对战
ReplayScene.updateRecentChess = function(self)
    
    
end;




ReplayScene.deleteListViewItem = function(self,item)
    if self.m_cur_state == ReplayScene.REPLAY then
        self:deleteRecentChessData(item);
        self:resetReplayListView();
    elseif self.m_cur_state == ReplayScene.MYSAVE then
        self:deleteMysaveChess(item);
    elseif self.m_cur_state == ReplayScene.SUGGEST then
    end;
end;

-- 重置replayListView
ReplayScene.resetReplayListView = function(self)
    if self.m_recent_adapter then
        local data = self:getRecentChess();
        if not next(data) or not data  then 
            self.m_recent_tips:setText("0/"..UserInfo.getInstance():getSaveChessManualLimit());
            self.m_replay_empty_tips:setVisible(true);
            delete(self.m_recent_adapter);
            self.m_recent_adapter = nil;
            return 
        else
            ChessToastManager.getInstance():clearAllToast();
            self.m_recent_tips:setText(#data .."/"..UserInfo.getInstance():getSaveChessManualLimit());
            self.m_replay_empty_tips:setVisible(false);
        end;  
        self.m_recent_adapter:changeData(data);
    end;
end;



ReplayScene.clearAllRecentData = function(self)
    if not self.m_clear_chioce_dialog then
        self.m_clear_chioce_dialog = new(ChioceDialog);
    end;
    self.m_clear_chioce_dialog:setMode(ChioceDialog.MODE_SURE);
    self.m_clear_chioce_dialog:setMessage("是否清空最近对局中所有棋谱？");
    self.m_clear_chioce_dialog:setPositiveListener(self, function() 
        self:deleteAllRecentChessData();
        self:resetReplayListView();   
    end);
    self.m_clear_chioce_dialog:show();    
end;



ReplayScene.deleteAllRecentChessData = function(self)
    local uid = UserInfo.getInstance():getUid();
	local keys = GameCacheData.getInstance():getString(GameCacheData.RECENT_DAPU_KEY .. uid,"");
	if keys == "" or keys == GameCacheData.NULL then
		return ;
	end
	local keys_table = lua_string_split(keys, GameCacheData.chess_data_key_split);
    for key , value in pairs(keys_table) do
        table.remove(keys_table,key);
        local mvData_str = GameCacheData.getInstance():getString(value .. uid,"");
		if value ~= "" and value ~= GameCacheData.NULL and mvData_str ~= "" and mvData_str ~= GameCacheData.NULL then
            GameCacheData.getInstance():saveString(value .. uid,"");
		end
	end       
    GameCacheData.getInstance():saveString(GameCacheData.RECENT_DAPU_KEY .. uid,""); 
end;



-- 删除最近对战item数据
ReplayScene.deleteRecentChessData = function(self,chessItem)
    local uid = UserInfo.getInstance():getUid();
	local keys = GameCacheData.getInstance():getString(GameCacheData.RECENT_DAPU_KEY .. uid,"");
	if keys == "" or keys == GameCacheData.NULL then
		return ;
	end
	local keys_table = lua_string_split(keys, GameCacheData.chess_data_key_split);
	local index = 1;
	local data = {};
    local deleteId = nil;
    if not chessItem:getData().id then
        return;
    else
        deleteId = "myRecentChessDataId_"..chessItem:getData().id;
    end;
    for key , value in pairs(keys_table) do
        if deleteId == value then
            table.remove(keys_table,key);
            GameCacheData.getInstance():saveString(GameCacheData.RECENT_DAPU_KEY .. uid,table.concat(keys_table,GameCacheData.chess_data_key_split));
        		local mvData_str = GameCacheData.getInstance():getString(value .. uid,"");
		    if value ~= "" and value ~= GameCacheData.NULL and mvData_str ~= "" and mvData_str ~= GameCacheData.NULL then
                GameCacheData.getInstance():saveString(deleteId .. uid,"");
		    end
            return true;
        end;
	end    
end;


ReplayScene.updateRecentChessData = function(self,chessItem)
    local uid = UserInfo.getInstance():getUid();
	local keys = GameCacheData.getInstance():getString(GameCacheData.RECENT_DAPU_KEY .. uid,"");
	if keys == "" or keys == GameCacheData.NULL then
		return ;
	end
	local keys_table = lua_string_split(keys, GameCacheData.chess_data_key_split);
	local data = {};
    local updateId = nil;
    if not chessItem:getData().id then 
        return;
    else
        updateId = "myRecentChessDataId_"..chessItem:getData().id;
    end;
    for key , value in pairs(keys_table) do
        if updateId == value then
		    local mvData_str = GameCacheData.getInstance():getString(value .. uid,"");
		    if value ~= "" and value ~= GameCacheData.NULL and mvData_str ~= "" and mvData_str ~= GameCacheData.NULL then
                GameCacheData.getInstance():saveString(value .. uid,json.encode(chessItem:getData()));
		    end
            return true;
        end;
	end       
end;

-- 最近对局itemClick
ReplayScene.onRecentItemClick = function(self,adapter,view,index,viewX,viewY)
    Log.i("ReplayScene.onRecentItemClick");
    self:entryReplayRoom(view:getData());
end;


-- 最近对局itemClick
ReplayScene.onMysaveItemClick = function(self,adapter,view,index,viewX,viewY)
    Log.i("ReplayScene.onMysaveItemClick");
    self:entryReplayRoom(view:getData());
end;

-- 最近对局itemClick
ReplayScene.onSuggestItemClick = function(self,adapter,view,index,viewX,viewY)
    Log.i("ReplayScene.onSuggestItemClick");
    self:entryReplayRoom(view:getData());
end;





-- 删除我的收藏item
ReplayScene.deleteMysaveChess = function(self,chessItem)
    self:requestCtrlCmd(ReplayController.s_cmds.delete_mysave_chess,chessItem:getManualId());
end;


ReplayScene.showMySaveChess = function(self,showTips)
    if showTips then
        self:loadTips(); 
    end;
    self:getMysaveChess(0,50); 
end;


ReplayScene.showSuggestChess = function(self)
    self:loadTips();
    self:getSuggestChess(0,50); 
end;




-- 收藏棋谱
ReplayScene.savetoLocal = function(self, chessItem)
    self.m_chess_item = chessItem;
    -- 收藏弹窗
    if not self.m_chioce_dialog then
        self.m_chioce_dialog = new(ChioceDialog)
    end;
    self.m_chioce_dialog:setMode(ChioceDialog.MODE_SHOUCANG);  
    self.m_save_cost = UserInfo.getInstance():getFPcostMoney().save_manual;  
    self.m_chioce_dialog:setMessage("是否花费"..(self.m_save_cost or 500) .."金币永久收藏当前棋谱？");
    self.m_chioce_dialog:setPositiveListener(self, self.saveChesstoMysave);
    self.m_chioce_dialog:show();
end;




-- 收藏到我的收藏
ReplayScene.saveChesstoMysave = function(self,item)
    self.m_chess_item = item;
    self:requestCtrlCmd(ReplayController.s_cmds.save_mychess,item:getChioceDlgCheckState(),item:getData());
end;

-- 获取我的收藏
ReplayScene.getMysaveChess = function(self,start,num)
    self:requestCtrlCmd(ReplayController.s_cmds.get_mysavechess,start, num);
end;

-- 弹窗，是否删除该棋谱
ReplayScene.deleteDapuItem = function(self,chessItem)
    if not self.m_chioce_dialog then
        self.m_chioce_dialog = new(ChioceDialog);
    end;
    self.m_chioce_dialog:setMode(ChioceDialog.MODE_SURE);
    self.m_chioce_dialog:setMessage("是否确定删除该棋谱？");
    self.m_chioce_dialog:setPositiveListener(self, self.deleteGalleryItem,chessItem);
    self.m_chioce_dialog:show();
end;

-- 删除棋谱
ReplayScene.deleteGalleryItem = function(self,chessItem)
    self.m_chess_item = chessItem;
    if self.m_cur_state == ReplayScene.REPLAY then
        self.m_recent_view:deleteItem(self.m_chess_item:getIndex());
        if self:deleteRecentChess(self.m_chess_item) then
            ChessToastManager.getInstance():showSingle("删除成功！",2000);
        end;
    elseif self.m_cur_state == ReplayScene.MYSAVE then
        self:deleteMysaveChess(self.m_chess_item);
    end;
end;



-- 获取棋友动态
ReplayScene.getSuggestChess = function(self,start,num)
    self:requestCtrlCmd(ReplayController.s_cmds.get_suggestchess,start, num);
end;





-- 公开棋谱
ReplayScene.openOrSelfDapu = function(self,chessItem,collectType)
    self.m_chess_item = chessItem;
    self:requestCtrlCmd(ReplayController.s_cmds.open_self_chess,self.m_chess_item:getManualId(),collectType);
end;


-- 进入房间
ReplayScene.entryReplayRoom = function(self,data)
      UserInfo.getInstance():setDapuSelData(data);
      RoomProxy.getInstance():goteReplayRoom();
end;


ReplayScene.onBackActionBtnClick = function(self)
    self:requestCtrlCmd(ReplayController.s_cmds.back_action);
end;



ReplayScene.galleryCallback = function(self)
    self:getMysaveChess(self.m_dapu_view:getCurrentIndex(),10);
end

-------------------------------- http --------------------------------
ReplayScene.onSaveMychessCallBack = function(self,data)
    if not data then return end;
    if data.cost then
        if data.cost > 0 then 
            ChessToastManager.getInstance():showSingle("收藏成功！",2000);
            if self.m_chess_item then
                if self.m_chess_item.m_type == ReplayScene.REPLAY then
                    self.m_chess_item:setReplayIsCollect();
                elseif self.m_chess_item.m_type == ReplayScene.MYSAVE then
                    -- 已经收藏了
                elseif self.m_chess_item.m_type == ReplayScene.SUGGEST then
                    self.m_chess_item:setSuggestIsCollect();
                end;
            end;
        elseif data.cost == 0 then
            ChessToastManager.getInstance():showSingle("您已经收藏过了！",1000);
        elseif data.cost == -1 then
            -- -1是老版本本地棋谱上传成功
        end;
    end;
end;


-- 获取我的收藏成功回调
ReplayScene.onGetMychessCallBack = function(self,data)
    Log.i("ReplayScene.onGetMychessCallBack");
    if not data or not next(data) then 
        self.m_mysave_tips:setText("...");
        self.m_dapu_empty_tips:setVisible(true);
        return 
    end;
    -- 每次需重新加载收藏，有可能新增加收藏
    delete(self.m_masave_adapter);
    self.m_masave_adapter = nil;
    local masaveData = {};
    for i = 1 ,#data.list do
        table.insert(masaveData,json.encode(data.list[i]));
    end;
    if not masaveData or not next(masaveData) then 
        self.m_mysave_tips:setText("...");
        self.m_dapu_empty_tips:setVisible(true);
        delete(self.m_masave_adapter);
        self.m_masave_adapter = nil;
        return 
    else
        ChessToastManager.getInstance():clearAllToast();
        self.m_mysave_tips:setText(data.total);
        self.m_dapu_empty_tips:setVisible(false);
    end; 
    self.m_masave_adapter = new(CacheAdapter,ReplayChessItem,masaveData);
    self.m_dapuList_view:setAdapter(self.m_masave_adapter);
end;

-- 获取棋友动态成功回调
ReplayScene.onGetSuggestCallBack = function(self,data)
    Log.i("ReplayScene.onGetSuggestCallBack");
    if not data or not next(data) then 
        self.m_suggest_tips:setText("...");
        self.m_suggest_empty_tips:setVisible(true);
        return 
    else
        ChessToastManager.getInstance():clearAllToast();
        self.m_suggest_total_num = data.total;
--        self.m_suggest_tips:setText(self.m_suggest_total_num);
        self.m_suggest_empty_tips:setVisible(false);
    end; 

    local suggestData = {};
    if not self.m_suggest_list_num then self.m_suggest_list_num = 0 end
    if data.list then
        self.m_suggest_list_num = self.m_suggest_list_num + #data.list;
    else
        return;
    end;
    for i = 1 ,#data.list do
        table.insert(suggestData,json.encode(data.list[i]));
    end;
    if self.m_suggest_list_num > #data.list then
        if self.m_suggest_adapter then
            self.m_suggest_adapter:appendData(suggestData);
        end;
    else
        -- 每次需重新加载收藏，有可能新增加收藏
        delete(self.m_suggest_adapter);
        self.m_suggest_adapter = nil;
        self.m_suggest_adapter = new(CacheAdapter,ReplayChessItem,suggestData);
        self.m_suggestList_view:setAdapter(self.m_suggest_adapter);
    end;
end;


-- 公开或私密棋谱回调
ReplayScene.onOpenOrSelfMychessCallBack = function(self, data)
    self.m_chess_item:setOpenOrSelfType();
end;


-- 删除我的收藏回调
ReplayScene.onDelMychessCallBack = function(self)
    ChessToastManager.getInstance():showSingle("删除成功！",2000);
--    if self.m_chess_item then-- 当删除我的收藏item，收藏状态同步到最近对局
--        self.m_chess_item:getData().is_collect = 0;
--        self:updateRecentChessData(self.m_chess_item);
--    end;
    self:showMySaveChess(false);
end;

require("dialog/common_share_dialog");
--[Comment]
--分享棋谱
--data: 复盘数据
function ReplayScene.shareChess(self,data)
    if not data then return end
    if not self.commonShareDialog then
        self.commonShareDialog = new(CommonShareDialog);
    end
    self.commonShareDialog:setShareDate(data,"manual_share");
    self.commonShareDialog:show();

end
---------------------------------config-------------------------------
ReplayScene.s_controlConfig = 
{
    [ReplayScene.s_controls.bamboo_left_dec]            = {"bamboo_left_dec"};
    [ReplayScene.s_controls.bamboo_right_dec]           = {"bamboo_right_dec"};
    [ReplayScene.s_controls.tea_dec]                    = {"tea_dec"};
    [ReplayScene.s_controls.stone_dec]                  = {"stone_dec"};
	[ReplayScene.s_controls.back_btn]                   = {"back_btn"};
    [ReplayScene.s_controls.title_view]                 = {"title_content"};
    [ReplayScene.s_controls.title_bg]                   = {"title_content","title_bg"};
    [ReplayScene.s_controls.title_subbg]                = {"title_content","title_subbg"};
    [ReplayScene.s_controls.title_mysave]               = {"title_content","title_mysave"};
    [ReplayScene.s_controls.clear_all_btn_bg]           = {"title_content","clear_all_bg"};
    [ReplayScene.s_controls.clear_all_btn]              = {"title_content","clear_all_bg","clear_all_btn"};
    [ReplayScene.s_controls.btns_content_view]          = {"btns_content"};

    [ReplayScene.s_controls.replay_content_view]        = {"replay_content"};
    [ReplayScene.s_controls.replayList_view]            = {"replay_content","replayList_view"};
    [ReplayScene.s_controls.dapu_content_view]          = {"dapu_content"};
    [ReplayScene.s_controls.dapuList_view]              = {"dapu_content","dapuList_view"};
    [ReplayScene.s_controls.suggest_content_view]       = {"suggest_content"};
    [ReplayScene.s_controls.suggestList_view]           = {"suggest_content","suggestList_view"};
    [ReplayScene.s_controls.bottom_view]                = {"bottom_view"};
   
};

--定义控件的触摸响应函数
ReplayScene.s_controlFuncMap =
{
	[ReplayScene.s_controls.back_btn]                   = ReplayScene.onBackActionBtnClick;
};

ReplayScene.s_cmdConfig = 
{
    [ReplayScene.s_cmds.save_mychess]                   = ReplayScene.onSaveMychessCallBack;
    [ReplayScene.s_cmds.get_mychess]                    = ReplayScene.onGetMychessCallBack;
    [ReplayScene.s_cmds.get_suggestchess]               = ReplayScene.onGetSuggestCallBack;
    [ReplayScene.s_cmds.open_self_chess]                = ReplayScene.onOpenOrSelfMychessCallBack;
    [ReplayScene.s_cmds.del_mysave_chess]               = ReplayScene.onDelMychessCallBack;
}










-- 最近对局/我的收藏/棋友推荐item
ReplayChessItem = class(Node);

ReplayChessItem.WIDTH = 630;
ReplayChessItem.HEIGHT = 410;


ReplayChessItem.ctor = function(self, data)
    if not data or data == "" then return end;
    self.m_data = json.decode(data);
    self.m_room = ReplayChessItem.s_room;
    self.m_type = ReplayChessItem.s_type;
    self.m_data.chess_type = self.m_type;
    self:setSize(ReplayChessItem.WIDTH,ReplayChessItem.HEIGHT);
    self:loadView();
    self:initView();
    self:initData();
end;

ReplayChessItem.dtor = function(self)

end;



----------------------------------------- function -----------------------------------------------

ReplayChessItem.loadView = function(self)

    self.m_root_view = SceneLoader.load(replay_scene_node);
    self:addChild(self.m_root_view);

    self.m_bg = self.m_root_view:getChildByName("bg");
    -- title
    self.m_title_view = self.m_root_view:getChildByName("title");
      --- native_title ---
      self.m_native_title = self.m_title_view:getChildByName("native_title");
        -- left_title
        self.m_native_left_title = self.m_native_title:getChildByName("left_title");
          self.m_native_left_icon = self.m_native_left_title:getChildByName("icon");
          self.m_native_left_chess_type = self.m_native_left_title:getChildByName("chess_type");
          self.m_native_left_chess_time = self.m_native_left_title:getChildByName("chess_time");
        
        -- right_title
        self.m_native_right_title = self.m_native_title:getChildByName("right_title");
          -- only_self
          self.m_native_right_only_self = self.m_native_right_title:getChildByName("only_self");
            self.m_native_right_only_self_img = self.m_native_right_only_self:getChildByName("img");
          -- open_chess
          self.m_native_right_open_chess = self.m_native_right_title:getChildByName("open_chess");
            self.m_native_right_open_chess_save_txt = self.m_native_right_open_chess:getChildByName("save_txt");
            self.m_native_right_open_chess_comment_txt = self.m_native_right_open_chess:getChildByName("comment_txt");
      
      --- online_title ---
      self.m_online_title = self.m_title_view:getChildByName("online_title");
       -- left_title
       self.m_online_left_title = self.m_online_title:getChildByName("left_title");
         self.m_online_left_title_icon_frame = self.m_online_left_title:getChildByName("icon_mask");
         self.m_online_left_title_owner_name = self.m_online_left_title:getChildByName("owner_name");
       -- right_title
       self.m_online_right_title = self.m_online_title:getChildByName("right_title");
         self.m_online_left_title_share_time = self.m_online_right_title:getChildByName("share_time");

    -- content
    self.m_content_view = self.m_root_view:getChildByName("content");
      -- red_user
      self.m_red_user = self.m_content_view:getChildByName("red_user");
        -- icon_frame
        self.m_red_user_icon_frame = self.m_red_user:getChildByName("icon_frame");
        -- vip_frame
        self.m_red_user_vip_frame = self.m_red_user_icon_frame:getChildByName("vip_frame");
        -- name
        self.m_red_user_name = self.m_red_user:getChildByName("name");
        -- score
        self.m_red_user_score = self.m_red_user:getChildByName("score");
        -- level
        self.m_red_user_level = self.m_red_user:getChildByName("level");
      -- middle
      self.m_middle_view = self.m_content_view:getChildByName("middle");
        self.m_chess_board = self.m_middle_view:getChildByName("board");
        -- win_txt
        self.m_middle_win_txt = self.m_middle_view:getChildByName("win_bg"):getChildByName("win");
        self.m_middle_entry_btn = self.m_middle_view:getChildByName("entry_btn");
--        self.m_middle_entry_btn:setOnClick(self, self.entryReplayRoom);
      -- black_user
      self.m_black_user = self.m_content_view:getChildByName("black_user");
        -- icon_frame
        self.m_black_user_icon_frame = self.m_black_user:getChildByName("icon_frame");
        -- vip_frame
        self.m_black_user_vip_frame = self.m_black_user_icon_frame:getChildByName("vip_frame");
        -- name
        self.m_black_user_name = self.m_black_user:getChildByName("name");
        -- score
        self.m_black_user_score = self.m_black_user:getChildByName("score");
        -- level
        self.m_black_user_level = self.m_black_user:getChildByName("level");
    
    -- bottom(btns)
    self.m_bottom_view = self.m_root_view:getChildByName("bottom");
      self.m_bottom_top_line = self.m_bottom_view:getChildByName("top_line");
      self.m_bottom_bottom_line = self.m_bottom_view:getChildByName("bottom_line");
      
      -- del_btn
      self.m_delete_btn = self.m_bottom_view:getChildByName("delete_btn");
      self.m_delete_btn:setLevel(10);
      self.m_delete_btn:setOnClick(self, self.deleteSelf);
      -- share_btn
      self.m_share_btn = self.m_bottom_view:getChildByName("share_btn");
      self.m_share_btn:setOnClick(self, self.shareSelf);
      -- save_btn
      self.m_save_btn = self.m_bottom_view:getChildByName("save_btn");
      self.m_save_btn:setOnClick(self, self.saveSelf);
      -- open_btn
      self.m_open_btn = self.m_bottom_view:getChildByName("open_btn");
      self.m_open_btn:setOnClick(self, self.openSelf);
      -- comment_btn
      self.m_comment_btn = self.m_bottom_view:getChildByName("comment_btn");
      self.m_comment_btn:setOnClick(self, self.commentSelf);   

      self.m_bottom_line1 = self.m_bottom_view:getChildByName("line1");
      self.m_bottom_line2 = self.m_bottom_view:getChildByName("line2");
      -- front_bg
      self.m_front_bg = self.m_root_view:getChildByName("front_bg");
      self.m_front_bg:setEventTouch(self, function() 
        if self.m_room then 
            self.m_room:resetListViewItemClick(false);
        end;
      end);
end;


ReplayChessItem.initView = function(self)

    if self.m_type == ReplayScene.REPLAY then
        self.m_bg:setPos(0,0);
        self.m_bg:setSize(nil,390);
        -- title
        self.m_native_title:setVisible(true);
        self.m_online_title:setVisible(false);
        -- btns
        self.m_delete_btn:setVisible(true);
        self.m_delete_btn:setPos(80);
        self.m_share_btn:setVisible(false);
        self.m_save_btn:setVisible(true);
        self.m_save_btn:setPos(80);
        self.m_open_btn:setVisible(false);
        self.m_comment_btn:setVisible(false);

        self.m_bottom_top_line:setVisible(true);  
        self.m_bottom_bottom_line:setVisible(false);
        self.m_bottom_line1:setPos(0,0);
        self.m_bottom_line2:setPos(0,0);
    elseif self.m_type == ReplayScene.MYSAVE then
        self.m_bg:setPos(0,0);
        self.m_bg:setSize(nil,390);
        -- title
        self.m_native_title:setVisible(true);
        self.m_online_title:setVisible(false);
        -- btns
        self.m_delete_btn:setVisible(true);
        self.m_delete_btn:setPos(40);
        if kPlatform == kPlatformIOS then
            if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
                self.m_share_btn:setVisible(true);
                self.m_open_btn:setVisible(true);
            else
                self.m_share_btn:setVisible(false);
                self.m_open_btn:setVisible(false);
            end;            
        else
            self.m_share_btn:setVisible(true);
            self.m_open_btn:setVisible(true);
        end;
        self.m_save_btn:setVisible(false);
        self.m_comment_btn:setVisible(false);   
        
        self.m_bottom_top_line:setVisible(true);    
        self.m_bottom_bottom_line:setVisible(false);
        self.m_bottom_line1:setPos(-105,0);
        self.m_bottom_line2:setPos(105,0);
    elseif self.m_type == ReplayScene.SUGGEST then
        self.m_bg:setPos(nil,10);
        self.m_bg:setSize(nil,250);
        -- title
        self.m_native_title:setVisible(false);
        self.m_online_title:setVisible(true);
        -- btns
        self.m_save_btn:setVisible(true);
        self.m_save_btn:setAlign(kAlignLeft);
        self.m_save_btn:setPos(40);
        if kPlatform == kPlatformIOS then
            if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
                self.m_share_btn:setVisible(true);
                self.m_comment_btn:setVisible(true);  
            else
                self.m_share_btn:setVisible(false);
                self.m_comment_btn:setVisible(false);  
            end;            
        else
            self.m_share_btn:setVisible(true);
            self.m_comment_btn:setVisible(true);  
        end;
        self.m_delete_btn:setVisible(false);
        self.m_open_btn:setVisible(false);
        self.m_bottom_top_line:setVisible(false);
        self.m_bottom_bottom_line:setVisible(true);
        self.m_bottom_line1:setPos(-105,0);
        self.m_bottom_line2:setPos(105,0);
    end;

end;


ReplayChessItem.initData = function(self)
    if self.m_type == ReplayScene.REPLAY then
        self:initReplayChessState();
    elseif self.m_type == ReplayScene.MYSAVE then
        self:initMysaveChessState();
    elseif self.m_type == ReplayScene.SUGGEST then
        self:initSuggestChessState();
    end;   
    self:initLeftTitle(); 
    self:initUserData();
    self:initChessData();

end;



ReplayChessItem.initLeftTitle = function(self)
    -- manual_type
    if self.m_data.manual_type then
        if tonumber(self.m_data.manual_type) == 1 then
            self.m_native_left_chess_type:setText("联网对战");
        elseif tonumber(self.m_data.manual_type) == 2 then
            self.m_native_left_chess_type:setText("残局挑战");
        elseif tonumber(self.m_data.manual_type) == 3 then
            self.m_native_left_chess_type:setText("单机挑战");
        elseif tonumber(self.m_data.manual_type) == 4 then
            self.m_native_left_chess_type:setText("单机打谱");        
        elseif tonumber(self.m_data.manual_type) == 5 then
            self.m_native_left_chess_type:setText("街边残局");
        elseif tonumber(self.m_data.manual_type) == 6 then
            self.m_native_left_chess_type:setText("联网观战");
        end;
    end;
    -- time
    if self.m_type == ReplayScene.REPLAY then
        if self.m_data.time then
            self.m_native_left_chess_time:setText(self.m_data.time);
        else
            self.m_native_left_chess_time:setText();
        end; 
    elseif self.m_type == ReplayScene.MYSAVE then
        if self.m_data.add_time then
            self.m_native_left_chess_time:setText(os.date("%Y/%m/%d",self.m_data.add_time));
        else
            self.m_native_left_chess_time:setText();
        end;        
    elseif self.m_type == ReplayScene.SUGGEST then
        self.m_owner_user_icon = new(Mask,UserInfo.DEFAULT_ICON[1],"userinfo/icon_7070_frame2.png");
        self.m_owner_user_icon:setSize(68,68);
        self.m_owner_user_icon:setAlign(kAlignCenter);
        self.m_online_left_title_icon_frame:addChild(self.m_owner_user_icon);

        if self.m_data.icon_url then
            self.m_owner_user_icon:setUrlImage(self.m_data.icon_url,UserInfo.DEFAULT_ICON[1]);
        else
            self.m_owner_user_icon:setFile(UserInfo.DEFAULT_ICON[1]);
        end;     
        if self.m_data.mnick then
            self.m_online_left_title_owner_name:setText(self.m_data.mnick);
        else
            self.m_online_left_title_owner_name:setText("博雅象棋");
        end;      
        if self.m_data.add_time then
            if ToolKit.isSecondDay(self.m_data.add_time) then
                self.m_online_left_title_share_time:setText(os.date("%Y/%m/%d %H:%M",self.m_data.add_time));
            else
                self.m_online_left_title_share_time:setText(os.date("%H:%M",self.m_data.add_time));
            end;
        else
            self.m_online_left_title_share_time:setText();
        end;   
    end;  
end;


ReplayChessItem.initReplayChessState = function(self)
    if self.m_data.is_collect then
        -- 1已收藏，0未收藏
        if tonumber(self.m_data.is_collect) == 1 then 
            self.m_save_btn:setFile("replay/has_save.png");     
            self.m_save_btn:setPickable(false);            
        elseif tonumber(self.m_data.is_collect) == 0 then
            self.m_save_btn:setFile("replay/save.png");
            self.m_save_btn:setPickable(true);
        end;
    else
       self.m_data.is_collect = 0;
    end;
    self.m_room:updateRecentChessData(self);
end;


ReplayChessItem.setReplayIsCollect = function(self)
--   if self.m_data.is_collect then
--       if tonumber(self.m_data.is_collect) == 0 then
--            self.m_data.is_collect = 1;
--       else
--            self.m_data.is_collect = 0;
--       end
--   end;
--   self:initReplayChessState();
end;


ReplayChessItem.initSuggestChessState = function(self)
    if self.m_data.is_collect then
        -- 1已收藏，0未收藏
        if tonumber(self.m_data.is_collect) == 1 then 
            self.m_save_btn:setFile("replay/has_save.png");     
            self.m_save_btn:setPickable(false);            
        elseif tonumber(self.m_data.is_collect) == 0 then
            self.m_save_btn:setFile("replay/save.png");
            self.m_save_btn:setPickable(true);
        end;
    end;
end;

ReplayChessItem.setSuggestIsCollect = function(self)
   if tonumber(self.m_data.is_collect) == 0 then
        self.m_data.is_collect = 1;
   else
        self.m_data.is_collect = 0;
   end    
   self:initSuggestChessState();
end;

ReplayChessItem.initMysaveChessState = function(self)
    if self.m_data.collect_type then
        -- 收藏类型，1公开，2个人
        if tonumber(self.m_data.collect_type) == 1 then
            self.m_native_right_only_self:setVisible(false);
            self.m_native_right_open_chess:setVisible(true);     
            self.m_native_right_open_chess_save_txt:setText(self.m_data.collect_num or 0);
            self.m_native_right_open_chess_comment_txt:setText(self.m_data.comment_num or 0);  
            self.m_open_btn:setFile("replay/self.png");                 
        elseif tonumber(self.m_data.collect_type) == 2 then
            self.m_native_right_only_self:setVisible(true);
            self.m_native_right_open_chess:setVisible(false);
            self.m_open_btn:setFile("replay/open.png"); 
        end;
        if kPlatform == kPlatformIOS then
            if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
            else
                self.m_native_right_only_self:setVisible(false);
                self.m_native_right_open_chess:setVisible(false);  
            end;            
        end;
    end;
end;

ReplayChessItem.setOpenOrSelfType = function(self)
   if tonumber(self.m_data.collect_type) == 1 then
        self.m_data.collect_type = 2;
        ChessToastManager.getInstance():showSingle("仅自己可见");
   else
        self.m_data.collect_type = 1;
        ChessToastManager.getInstance():showSingle("公开可见");
   end    
   self:initMysaveChessState();
end;


ReplayChessItem.initUserData = function(self)
    -- red_icon
    self.m_red_user_icon = new(Mask,UserInfo.DEFAULT_ICON[1],"userinfo/icon_7070_frame2.png");
    self.m_red_user_icon:setSize(68,68);
    self.m_red_user_icon:setAlign(kAlignCenter);
    self.m_red_user_icon_frame:addChild(self.m_red_user_icon);
    if self.m_data.red_icon_url and self.m_data.red_icon_url ~= "" then
        self.m_red_user_icon:setUrlImage(self.m_data.red_icon_url,UserInfo.DEFAULT_ICON[1]);
    else
        self.m_red_user_icon:setFile(UserInfo.DEFAULT_ICON[1]);
    end;
    -- red_name
    if self.m_data.red_mnick then
        local len = string.lenutf8(GameString.convert2UTF8(self.m_data.red_mnick) or "");
        if len > 4 then
            local name = string.subutf8(self.m_data.red_mnick,1,4);
            self.m_red_user_name:setText(name.."...");
        else
            self.m_red_user_name:setText(self.m_data.red_mnick);
        end;
    else
        self.m_red_user_name:setText("博雅象棋");
    end;
    -- red_score
    if self.m_data.red_score then
        self.m_red_user_score:setText("积分:"..self.m_data.red_score);
    else
        self.m_red_user_score:setText("积分:...");
    end;
    -- red_level
    if self.m_data.red_level then
        if type(self.m_data.red_level)=="number" then
            self.m_red_user_level:setFile("common/icon/big_level_"..self.m_data.red_level..".png");
        else
            self.m_red_user_level:setFile("common/icon/big_level_9.png");
        end;
    else
        self.m_red_user_level:setFile("common/icon/big_level_9.png");
    end;


    -- black_icon
    self.m_black_user_icon = new(Mask,UserInfo.DEFAULT_ICON[1],"userinfo/icon_7070_frame2.png");
    self.m_black_user_icon:setSize(68,68);
    self.m_black_user_icon:setAlign(kAlignCenter);
    self.m_black_user_icon_frame:addChild(self.m_black_user_icon);
    if self.m_data.black_icon_url and self.m_data.black_icon_url ~= "" then
        self.m_black_user_icon:setUrlImage(self.m_data.black_icon_url,UserInfo.DEFAULT_ICON[1]);
    else
        self.m_black_user_icon:setFile(UserInfo.DEFAULT_ICON[1]);
    end;
    -- black_name
    if self.m_data.black_mnick then
        local len = string.lenutf8(GameString.convert2UTF8(self.m_data.black_mnick) or "");
        if len > 4 then
            local name = string.subutf8(self.m_data.black_mnick,1,4);
            self.m_black_user_name:setText(name.."...");
        else
            self.m_black_user_name:setText(self.m_data.black_mnick);
        end;
    else
        self.m_black_user_name:setText("博雅象棋");
    end;
    -- black_score
    if self.m_data.black_score then
        self.m_black_user_score:setText("积分:"..self.m_data.black_score);
    else
        self.m_black_user_score:setText("积分:...");
    end;
    -- black_level
    if self.m_data.black_level then
        if type(self.m_data.black_level)=="number" then
            self.m_black_user_level:setFile("common/icon/big_level_"..self.m_data.black_level..".png");
        else
            self.m_black_user_level:setFile("common/icon/big_level_9.png");
        end;
    else
        self.m_black_user_level:setFile("common/icon/big_level_9.png");
    end;

end;


ReplayChessItem.initChessData = function(self)
    -- chess_board
    self.m_board = new(Board,200,230,self);
    Board.resetFenPiece();
    local chess_map = self.m_board:fen2chessMap(self.m_data.end_fen or "3ak4/4a4/9/7N1/9/9/9/9/9/5K3 r");
    if tonumber(self.m_data.down_user) == tonumber(self.m_data.red_mid) then
        self.m_board.m_flipped = false;
    else
        self.m_board.m_flipped = true;
    end;
    self.m_board:copyChess90(chess_map);
    self.m_chess_board:addChild(self.m_board);

    -- win_flag
    if self.m_data.win_flag then
        local flag = tonumber(self.m_data.win_flag);
        if flag == 0 then
            self.m_middle_win_txt:setText("和棋");
        elseif flag == 1 then
            self.m_middle_win_txt:setText("红胜");
        elseif flag == 2 then
            self.m_middle_win_txt:setText("黑胜");
        end;
    end;
    
end;

------------------------------- function -----------------------------------

ReplayChessItem.getManualId = function(self)
    return self.m_data.manual_id;
end;


ReplayChessItem.getChioceDlgCheckState = function(self)
    if self.m_replayItem_chioce_dialog then
        return self.m_replayItem_chioce_dialog:getCheckState() or false;
    end;
    return false;
end;

ReplayChessItem.getData = function(self)
    return self.m_data or nil;
end;


ReplayChessItem.entryReplayRoom = function(self,finger_action,x,y,drawing_id_first,drawing_id_current)
    Log.i("ReplayChessItem.entryReplayRoom");
--    if self.m_room then
--        self.m_room:entryReplayRoom(self.m_data);
--    end;
end;




ReplayChessItem.deleteSelf = function(self)
    Log.i("ReplayChessItem.deleteSelf");
    if self.m_room then
        self.m_room:resetListViewItemClick(true);
    end;
    if not self.m_replayItem_chioce_dialog then
        self.m_replayItem_chioce_dialog = new(ChioceDialog);
    end;
    self.m_replayItem_chioce_dialog:setMode(ChioceDialog.MODE_SURE);
    self.m_replayItem_chioce_dialog:setMessage("确定删除此棋谱吗？");
    self.m_replayItem_chioce_dialog:setPositiveListener(self,function() 
        if self.m_room then
            self.m_room:deleteListViewItem(self);
        end;   
    end);
    self.m_replayItem_chioce_dialog:show();
end;

ReplayChessItem.shareSelf = function(self)
    Log.i("ReplayChessItem.shareSelf");
    if self.m_room then
        self.m_room:resetListViewItemClick(true);
    end;
    self:shareChess();
end;


ReplayChessItem.shareChess = function(self)
--    require(BASE_PATH.."chessShareManager");
    local manualData = {};
    manualData.red_mid = self.m_data.red_mid or "0";       --红方uid
    manualData.black_mid = self.m_data.black_mid or "0";    --黑方uid
    manualData.win_flag = self.m_data.win_flag or "1";        --胜利方（1红胜，2黑胜，3平局）
    manualData.manual_type = self.m_data.manual_type or "1";     --棋谱类型，1联网游戏，2残局，3单机游戏，4用户打谱
    manualData.end_type = self.m_data.m_game_end_type or self.m_data.end_type or "1";    --棋盘开局
    manualData.start_fen = self.m_data.fenStr or self.m_data.start_fen;    -- 棋盘开局
    manualData.move_list = self.m_data.mvStr or self.m_data.move_list;     -- 走法，json字符串
    manualData.manual_id = self.m_data.manual_id;       -- 保存的棋谱id
    manualData.mid = self.m_data.mid;                   -- mid     
    manualData.h5_developUrl = PhpConfig.h5_developUrl;     
    manualData.title = self.m_data.title or "复盘演练（博雅中国象棋）";
    manualData.description = self.m_data.description or "复盘让您回顾精彩对局"; 
    manualData.url = manualData.h5_developUrl.."view/replay/replay.php?manual_id="..manualData.manual_id;
    if self.m_room then
        self.m_room:shareChess(manualData);
    end;
--    dict_set_string(kShareWebViewShare , kShareWebViewShare .. kparmPostfix,json.encode(postData));      
--    ChessShareManager.getInstance():onShare(manualData);
end


ReplayChessItem.saveSelf = function(self)
    Log.i("ReplayChessItem.saveSelf");
    if self.m_room then
        self.m_room:resetListViewItemClick(true);
    end;
    if not self.m_replayItem_chioce_dialog then
        self.m_replayItem_chioce_dialog = new(ChioceDialog);
    end;
    local save_cost;  
    self.m_replayItem_chioce_dialog:setMode(ChioceDialog.MODE_SHOUCANG);  
    if self.m_type == ReplayScene.REPLAY then
        save_cost = UserInfo.getInstance():getFPcostMoney().save_manual;  
    elseif self.m_type == ReplayScene.SUGGEST then
        save_cost = UserInfo.getInstance():getFPcostMoney().collect_manual; 
    end;
    self.m_replayItem_chioce_dialog:setMessage("是否花费"..(save_cost or 500) .."金币永久收藏当前棋谱？");
    self.m_replayItem_chioce_dialog:setPositiveListener(self,function() 
        if self.m_room then
            self.m_room:saveChesstoMysave(self);
        end;   
    end);
    self.m_replayItem_chioce_dialog:show();
end;

-- 公开棋谱或私密棋谱
ReplayChessItem.openSelf = function(self)
    Log.i("ReplayChessItem.openSelf");
    if self.m_room then
        self.m_room:resetListViewItemClick(true);
    else
        return;
    end;
    if tonumber(self.m_data.collect_type) == 1 then
        self.m_room:openOrSelfDapu(self,2);
    else
        self.m_room:openOrSelfDapu(self,1);
    end
end;

ReplayChessItem.commentSelf = function(self)
    Log.i("ReplayChessItem.commentSelf");
    if self.m_room then
        self.m_room:resetListViewItemClick(true);
    end;
    UserInfo.getInstance():setDapuSelData(self.m_data);
    StateMachine.getInstance():pushState(States.Comment,StateMachine.STYPE_LEFT_IN);
end;