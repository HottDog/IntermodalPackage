--region NewFile_1.lua
--Author : FordFan
--Date   : 2015/11/7
--endregion

require(BASE_PATH.."chessScene");
require("dialog/chioce_dialog");
require("dialog/http_loading_dialog");
require("dialog/add_friend_dialog");
--require("dialog/share_invite_dialog");
require("dialog/union_dialog");
require("dialog/common_share_dialog");

require(MODEL_PATH.."friendsInfo/friendsInfoController");

FriendsScene = class(ChessScene);

FriendsScene.itemType = 0;

FriendsScene.DEFAULT_TIPS = 
{
    "大侠，您还没有好友，互相关注可成为好友",
    "大侠，您还没有关注棋友，关注棋友可与棋友互动哦",
    "大侠，您还没有粉丝",
}

FriendsScene.default_icon = "userinfo/women_head02.png";

FriendsScene.s_controls = 
{
	back_btn     = 1;
    leaf_right   = 2;
    leaf_left    = 3;
    teapot_dec   = 4;

    content_view = 5;
    icon_mask    = 6;
    game_id      = 7;

    friends_btn  = 8;
    guanzhu_btn  = 9;
    fans_btn     = 10;

    friend_view  = 11;
    fans_view    = 12;
    guanzhu_view = 13;

    add_btn      = 14;--添加好友按钮
    add_btn_tip  = 15;--通讯录有好友提示
--    invite_btn   = 16;--邀请好友按钮
    union_btn    = 17;--同城按钮
    bottom_menu     = 18;

} 

FriendsScene.s_cmds = 
{
    changeFriendsList   = 1;
    changeFollowList    = 2;
    changeFansList      = 3;
    
    changeFriendsData   = 4;
    changeFriendstatus  = 5;
    change_userIcon     = 6; -- 更新用户头像
    newfriendsNum       = 7;
    friends_num         = 8;
    follow_num          = 9;
    fans_num            = 10;
    change_myHead       = 12;
    closeShareDialog    = 13;
    updata_union_dialog = 14;
    updata_union_member = 15;
}

FriendsScene.ctor = function(self,viewConfig,controller)
	self.m_ctrls = FriendsScene.s_controls;

    --好友
    self.friends_list_check = true;
    self.attention_list_check = false;
    self.fans_list_check = false;

    self:init();

end 

FriendsScene.resume = function(self)
    ChessScene.resume(self);
--    self:removeAnimProp();
--    self:resumeAnimStart();
    BottomMenu.getInstance():onResume(self.m_bottom_menu);
    BottomMenu.getInstance():setHandler(self,BottomMenu.FRIENDSTYPE);
end

FriendsScene.pause = function(self)
	ChessScene.pause(self);
    self:removeAnimProp();
    BottomMenu.getInstance():onPause();
--    self:pauseAnimStart();
end 

FriendsScene.dtor = function(self)
    delete(self.m_add_friends_dialog);
    delete(self.m_union_dialog);
    delete(self.anim_start);
    delete(self.anim_end);
    delete(self.commonShareDialog);
end

FriendsScene.init = function(self)
    Log.i("FriendsScene.init");
    FriendsScene.itemType = 1;
    --界面动画控件
    self.m_back_btn = self:findViewById(self.m_ctrls.back_btn);
    self.m_contentView = self:findViewById(self.m_ctrls.content_view);
    self.m_leaf_left = self:findViewById(self.m_ctrls.leaf_left);
    self.m_leaf_right = self:findViewById(self.m_ctrls.leaf_right);
    self.m_teapot_dec = self:findViewById(self.m_ctrls.teapot_dec);
    self.m_union_btn = self:findViewById(self.m_ctrls.union_btn);
    self.m_bottom_menu = self:findViewById(self.m_ctrls.bottom_menu);
    
    -- 我的游戏id 和头像
    self.m_game_id = self:findViewById(self.m_ctrls.game_id);
    self.m_icon_mask = self:findViewById(self.m_ctrls.icon_mask);
    self.m_vip_frame = self.m_contentView:getChildByName("icon_frame"):getChildByName("vip_frame");
    self.m_game_id:setText(UserInfo.getInstance():getUid() .. "");
    self.m_icon = new(Mask,UserInfo.DEFAULT_ICON[1],"common/background/head_mask_bg_110.png");
    self.m_icon:setSize(self.m_icon_mask:getSize());
    self.m_icon:setAlign(kAlignCenter);
    self.m_icon_mask:addChild(self.m_icon);

    --切换按钮
    self.m_friends_btn = self:findViewById(self.m_ctrls.friends_btn);
    self.m_fans_btn = self:findViewById(self.m_ctrls.fans_btn);
    self.m_guanzhu_btn = self:findViewById(self.m_ctrls.guanzhu_btn);
    self.m_friends_btn_text = self.m_friends_btn:getChildByName("Text");
    self.m_fans_btn_text = self.m_fans_btn:getChildByName("Text");
    self.m_guanzhu_btn_text = self.m_guanzhu_btn:getChildByName("Text");

    --text
    self.m_friends_text = self.m_friends_btn:getChildByName("Text");
    self.m_fans_text = self.m_fans_btn:getChildByName("Text");
    self.m_guanzhu_text = self.m_guanzhu_btn:getChildByName("Text");
    self.m_friends_text:setColor(215,75,45);
    self.m_fans_text:setColor(135,100,95);
    self.m_guanzhu_text:setColor(135,100,95);

    self.friendsNum = self.m_friends_btn:getChildByName("num");
    self.firendNewBg = self.m_friends_btn:getChildByName("new_bg");
    self.addFriendNum = self.firendNewBg:getChildByName("new_add_num"); -- 新增好友数量
    self.m_firend_btn_line = self.m_friends_btn:getChildByName("selet_line");

    self.guanzhuNum = self.m_guanzhu_btn:getChildByName("num");
    self.guanzhuNewBg = self.m_guanzhu_btn:getChildByName("new_bg");
    self.addGuanzhuNum = self.guanzhuNewBg:getChildByName("new_add_num"); -- 新增关注数量
    self.m_guanzhu_btn_line = self.m_guanzhu_btn:getChildByName("selet_line");

    self.fansNum = self.m_fans_btn:getChildByName("num");
    self.fansNewBg = self.m_fans_btn:getChildByName("new_bg");
    self.addFansNum = self.fansNewBg:getChildByName("new_add_num");  -- 新增粉丝数量
    self.m_fans_btn_line = self.m_fans_btn:getChildByName("selet_line");

    self.fansNewBg:setVisible(false);
    self.guanzhuNewBg:setVisible(false);
    self.firendNewBg:setVisible(false);

    self.m_no_friend_tip = self.m_contentView:getChildByName("tips");

    --好友，粉丝，关注列表
    self.m_FriendsView = self:findViewById(self.m_ctrls.friend_view);
    self.m_FansView = self:findViewById(self.m_ctrls.fans_view);
    self.m_AttentionView = self:findViewById(self.m_ctrls.guanzhu_view);
    self.m_FansView.m_autoPositionChildren = true;
    self.m_FriendsView.m_autoPositionChildren = true;
    self.m_AttentionView.m_autoPositionChildren = true;

    local frameRes = UserSetInfo.getInstance():getFrameRes();
    self.m_vip_frame:setVisible(frameRes.visible);
    local fw,fh = self.m_vip_frame:getSize();
    if frameRes.frame_res then
        self.m_vip_frame:setFile(string.format(frameRes.frame_res,fw));
    end
    -- 通讯录有好友提示
    self.m_add_btn_tip = self:findViewById(self.m_ctrls.add_btn_tip);

--    self.m_invite_btn = self:findViewById(self.m_ctrls.invite_btn);
--    if kPlatform == kPlatformIOS then
--        --ios审核跳发现模块跳商城
--        if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
--            self.m_invite_btn:setVisible(true);
--        else
--            self.m_invite_btn:setVisible(false);  
--        end;
--    else
--        self.m_invite_btn:setVisible(true);
--    end;

    self:setTextColor(); 
end

--------------进入和退出界面动画相关---------------
FriendsScene.removeAnimProp = function(self)
    self.m_contentView:removeProp(1);
    self.m_back_btn:removeProp(1);
    self.m_leaf_left:removeProp(1);
    self.m_leaf_right:removeProp(1);
    self.m_union_btn:removeProp(1);
end

FriendsScene.setAnimItemEnVisible = function(self,ret)
    self.m_leaf_left:setVisible(ret);
    self.m_leaf_right:setVisible(ret);
end

FriendsScene.resumeAnimStart = function(self,lastStateObj,timer)
    self.m_anim_prop_need_remove = true;
    self:setAnimItemEnVisible(false);
    self:removeAnimProp();
    local duration = timer.duration;
    local waitTime = timer.waitTime
    local delay = waitTime+duration;

    BottomMenu.getInstance():hideView(true);
    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(lastStateObj.state) then
        if not BottomMenu.getInstance():checkStateSort(States.Friends,lastStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,-w,0,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,w,0,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(0,timer);
    end
--    local w,h = self:getSize();
--    if not typeof(lastStateObj,OwnState) then
--        self.m_root:removeProp(1);
--        self.m_root:addPropTranslate(1,kAnimNormal,duration,waitTime,-w,0,nil,nil);
--    end
    delete(self.anim_start);
    self.anim_start = new(AnimInt,kAnimNormal,0,1,delay,-1);
    if self.anim_start then
        self.anim_start:setEvent(self,function()
            self:setAnimItemEnVisible(true);
            delete(self.anim_start);
        end);
    end

    self.m_union_btn:addPropTransparency(1,kAnimNormal,waitTime,delay,0,1);
    self.m_contentView:addPropTransparency(1,kAnimNormal,waitTime,delay,0,1);
    local lw,lh = self.m_leaf_left:getSize();
    self.m_leaf_left:addPropTranslate(1, kAnimNormal, waitTime, delay, -lw, 0, -10, 0);
    local tw,th = self.m_leaf_right:getSize();
    local anim = self.m_leaf_right:addPropTranslate(1, kAnimNormal, waitTime, delay, tw, 0, -10, 0);
    if anim then
        anim:setEvent(self,function()
            self.m_anim_prop_need_remove = true;
            self:removeAnimProp();
            if not self.m_root:checkAddProp(1) then 
		        self.m_root:removeProp(1);
	        end  
        end);   
    end
end

FriendsScene.pauseAnimStart = function(self,newStateObj,timer)
    self.m_anim_prop_need_remove = true;
    self:removeAnimProp();
    local duration = timer.duration;
    local waitTime = timer.waitTime
    local delay = waitTime+duration;

    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(newStateObj.state) then
        if BottomMenu.getInstance():checkStateSort(States.Friends,newStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,w,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,-w,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(1,timer);
    end
--    local w,h = self:getSize();
--    if not typeof(newStateObj,OwnState) then
--        self.m_root:removeProp(1);
--        self.m_root:addPropTranslate(1,kAnimNormal,duration,waitTime,0,-w,nil,nil);
--    end
    delete(self.anim_end);
    self.anim_end = new(AnimInt,kAnimNormal,0,1,delay,-1);
    if self.anim_end then
        self.anim_end:setEvent(self,function()
            self.m_anim_prop_need_remove = true;
            self:removeAnimProp();
            if not self.m_root:checkAddProp(1) then 
		        self.m_root:removeProp(1);
	        end  
            delete(self.anim_end);
        end);
    end
    self.m_union_btn:addPropTransparency(1,kAnimNormal,waitTime,-1,1,0);
    self.m_contentView:addPropTransparency(1,kAnimNormal,waitTime,-1,1,0);
    local lw,lh = self.m_leaf_left:getSize();
    self.m_leaf_left:addPropTranslate(1, kAnimNormal, waitTime, -1, 0, -lw, 0, -10);
    local w,h = self.m_leaf_right:getSize();
    local anim = self.m_leaf_right:addPropTranslate(1, kAnimNormal, waitTime, -1, 0, w, 0, -10);
    if anim then
        anim:setEvent(self,function()
            self:setAnimItemEnVisible(false);
        end);
    end
end

FriendsScene.changeMyHead = function(self,data)
    if data.iconType == -1 then
        self.m_icon:setUrlImage(data.iconUrl);
    else
        self.m_icon:setFile(UserInfo.DEFAULT_ICON[data.iconType] or UserInfo.DEFAULT_ICON[1]);
    end
end


function FriendsScene:closeShareDialog()
    if self.m_share_invite_dialog and not self.m_share_invite_dialog.is_dismissing and self.m_share_invite_dialog:isShowing() then
        self.m_share_invite_dialog:dismiss();
        return true;
    end
    return false;
end

function FriendsScene:showNoLisTip(listType)
    if not listType or listType < 1 or listType > 3 then 
        self.m_no_friend_tip:setVisible(false);
        return 
    end
    local msg = FriendsScene.DEFAULT_TIPS[listType];
    self.m_no_friend_tip:setText(msg);
    self.m_no_friend_tip:setVisible(true);
end
------------更新头像相关----------------------------------
FriendsScene.changeUserIconCall = function(self,data)
    Log.i("changeUserIconCall");
      --好友
      self:changeListUserIconCall(data,self.m_friend_items,self.m_friendListData);
      -- 关注
      self:changeListUserIconCall(data,self.m_adapter_attention,self.m_attentionListData);
      -- 粉丝
      self:changeListUserIconCall(data,self.m_adapter_fans,self.m_fansListData);
end

--------用户头像更新实现方法
FriendsScene.changeListUserIconCall = function(self,data,items,datas)
--   Log.i("changeListUserIconCall");
--   if not datas then
--       return;
--   end
--   if data and items then
--       for i,v in pairs(items) do
--           if v.dataid == tonumber(data.what) and items:isHasView(i) then
--               local view = m_adapte:getTmpView(i);
--               view:updateUserIcon(data.ImageName);
--           end
--       end
--   end
end

------------------------Click 事件--------------------------------
FriendsScene.onBack = function(self)
    self:requestCtrlCmd(FriendsController.s_cmds.back_action);
end

FriendsScene.onFriendsBtnClick = function(self) -- 切换好友列表
    Log.d("FriendsScene.onFriendsBtnClick");
    if self.friends_list_check == false then
        self.friends_list_check = true;
        self.attention_list_check = false;
        self.fans_list_check = false;

        --文字颜色
        self.m_friends_text:setColor(215,75,45);
        self.m_fans_text:setColor(135,100,95);
        self.m_guanzhu_text:setColor(135,100,95);
        --按钮下红线
        self.m_firend_btn_line:setVisible(true);
        self.m_guanzhu_btn_line:setVisible(false);
        self.m_fans_btn_line:setVisible(false);

        self:setTextColor();
        --好友,关注,粉丝列表
        FriendsScene.itemType = 1;
        self.m_no_friend_tip:setVisible(false);
        local datas = self:requestCtrlCmd(FriendsController.s_cmds.ongetfriendslist);
        if not datas or #datas < 1 then 
            self:showNoLisTip(FriendsScene.itemType);
--            ChessToastManager.getInstance():show("暂无好友！",500);
        end
        self:updateFriends_list();

        self:exitNewTile2();
        self:updateNewNum();
    end
end


FriendsScene.onFriendsattBtnClick = function(self) --切换关注列表
    Log.d("FriendsScene.onFriendsattBtnClick");
    if self.attention_list_check == false then
        self.friends_list_check = false;
        self.attention_list_check = true;
        self.fans_list_check = false;
        --文字颜色
        self.m_friends_text:setColor(135,100,95);
        self.m_fans_text:setColor(135,100,95);
        self.m_guanzhu_text:setColor(215,75,45);
        --按钮下红线
        self.m_firend_btn_line:setVisible(false);
        self.m_guanzhu_btn_line:setVisible(true);
        self.m_fans_btn_line:setVisible(false);

        self:setTextColor();
        --好友,关注,粉丝列表
        FriendsScene.itemType = 2;
        self.m_no_friend_tip:setVisible(false);
        local datas = self:requestCtrlCmd(FriendsController.s_cmds.ongetfollowlist);
        if not datas or #datas < 1 then
            self:showNoLisTip(FriendsScene.itemType);
--            ChessToastManager.getInstance():show("暂无关注！",500);
        end
        self:updateAttention_list();

        self:exitNewTile1();
        self:exitNewTile2();
        self:updateNewNum();
    end
end


FriendsScene.onFriendsfansBtnClick = function(self)  --切换粉丝列表
    Log.d("FriendsScene.onFriendsfansBtnClick");
    if self.fans_list_check == false then
        self.friends_list_check = false;
        self.attention_list_check = false;
        self.fans_list_check = true;
        --文字颜色
        self.m_friends_text:setColor(135,100,95);
        self.m_fans_text:setColor(215,75,45);
        self.m_guanzhu_text:setColor(135,100,95);
        --按钮下红线
        self.m_firend_btn_line:setVisible(false);
        self.m_guanzhu_btn_line:setVisible(false);
        self.m_fans_btn_line:setVisible(true);

        self:setTextColor();
        --好友,关注,粉丝列表
        FriendsScene.itemType = 3;
        self.m_no_friend_tip:setVisible(false);
        local datas = self:requestCtrlCmd(FriendsController.s_cmds.ongetfanslist);
        if not datas or #datas < 1 then 
            self:showNoLisTip(FriendsScene.itemType);   
--            ChessToastManager.getInstance():show("暂无粉丝！",500);
        end
        self:updateFans_list();

        self:exitNewTile1();
        self:updateNewNum();
    end
end

FriendsScene.onAddFriendBtnClick = function(self)
    if not self.m_add_friends_dialog  then
        self.m_add_friends_dialog = new(AddFriendDialog,false);
    end
    self.m_add_friends_dialog:show()--self.newFriendsDatas)
    self.m_add_btn_tip:setVisible(false);
end

--function FriendsScene:onInviteFriendBtnClick()
----    if not self.m_share_invite_dialog then
----        self.m_share_invite_dialog = new(ShareInviteDialog);
----    end 
----    self.m_share_invite_dialog:show();
--    m_qr_code_url,m_qr_download_url = UserInfo.getInstance():getGameShareUrl();
--    local tab = {};
--    if not m_qr_download_url then return end
--    tab.url = m_qr_download_url;
--    tab.title = "博雅中国象棋";
--    tab.description = CommonShareDialog.DEFAULT_TEXT;
--    if not self.commonShareDialog then
--        self.commonShareDialog = new(CommonShareDialog);
--    end
--    self.commonShareDialog:setShareDate(tab,"game_share");
--    self.commonShareDialog:show();
--end

FriendsScene.exitNewTile1 = function(self)

    local datas1 = FriendsData.getInstance():getFrendsListData();

    if datas1 then
        for i,v_uid in pairs(datas1) do
            if FriendsData.getInstance():isNewFriends(v_uid) == 1 then
                FriendsData.getInstance():setIsNewFriends(v_uid,0);
            end
        end
    end

end

FriendsScene.exitNewTile2 = function(self)

    local datas2 = FriendsData.getInstance():getFansListData();
    if datas2 then
        for i,v_uid in pairs(datas2) do
            if FriendsData.getInstance():isNewFans(v_uid) == 1 then
                FriendsData.getInstance():setIsNewFans(v_uid,0);
            end
        end
    end

end

FriendsScene.updateNewNum = function(self)

    local friendsNum = 0;
    local fansNum = 0;

    local friendsList = self:requestCtrlCmd(FriendsController.s_cmds.ongetfriendslist); 
    local fansList = self:requestCtrlCmd(FriendsController.s_cmds.ongetfanslist); 

    if friendsList~= nil then
        for i,uid in pairs(friendsList) do
                if FriendsData.getInstance():isNewFriends(uid) == 1 then
                    friendsNum = friendsNum + 1;
                end
        end
    end

    if fansList~= nil then
        for i,uid in pairs(fansList) do
                if FriendsData.getInstance():isNewFans(uid) == 1 then
                    fansNum = fansNum + 1;
                end
        end
    end

    --好友和粉丝后面要显示新增加的好友和粉丝的数量
    if friendsNum <= 0 then
        self.firendNewBg:setVisible(false);
    else
        self.firendNewBg:setVisible(true);
        self.addFriendNum:setText("+"..friendsNum);--新增好友数量
    end

    if fansNum <= 0 then
        self.fansNewBg:setVisible(false);
    else
        self.fansNewBg:setVisible(true);
        self.addFansNum:setText("+"..fansNum);--新增粉丝数量
    end
   

end

--新增通讯录好友数量
FriendsScene.changeNewfriendsNumCall = function(self,datas)
    Log.d("ZY changeNewfriendsNumCall");
    --a and b -- 如果a 为false，则返回a，否则返回b
    --a or b -- 如果a 为true，则返回a，否则返回b

    if datas == nil then 
        return; 
    end

--    self.newFriendsDatas = datas.list;
    if self.newFriendsDatas == nil then
        self.m_add_btn_tip:setVisible(false);
    else
        if datas.total == 0 then
            self.m_add_btn_tip:setVisible(false);
        else
            self.m_add_btn_tip:setVisible(true);
        end
    end

end

-----callback--------------
FriendsScene.changeFriendsListCall = function(self)

    ChessToastManager.getInstance():clearAllToast();
    if self.friends_list_check then --更新好友列表
        self:updateFriends_list();
    end

    --更新好友，粉丝新增数量
    self:updateNewNum();

end
FriendsScene.changeFollowListCall = function(self)

    
    if self.attention_list_check then --更新关注列表
        self:updateAttention_list();
    end


end
FriendsScene.changeFansListCall = function(self)

    if self.fans_list_check then --更新粉丝列表
        self:updateFans_list();
    end

    --更新好友，粉丝新增数量
    self:updateNewNum();

end

function FriendsScene:setTextColor()
    if self.friends_list_check then
        self.m_friends_btn_text:setColor(215,75,45);
        self.m_guanzhu_btn_text:setColor(135,100,95)
        self.m_fans_btn_text:setColor(135,100,95);
    elseif self.attention_list_check then
        self.m_friends_btn_text:setColor(135,100,95);
        self.m_guanzhu_btn_text:setColor(215,75,45)
        self.m_fans_btn_text:setColor(135,100,95);
    elseif self.fans_list_check then
        self.m_friends_btn_text:setColor(135,100,95);
        self.m_guanzhu_btn_text:setColor(135,100,95)
        self.m_fans_btn_text:setColor(215,75,45);
    end
end


FriendsScene.changeFriendsNumCall = function(self,info) --好友数目
    if info == nil then return; end 

    local number = info.num.."";
    self.friendsNum:setText(number);
       
end

FriendsScene.changeFollowNumCall = function(self,info) --关注数目
    if info == nil then return; end 
    local number = info.num..""; 
    Log.i("aaaaaaaaaaa"..number);
    self.guanzhuNum:setText(number); 

end

FriendsScene.changeFansNumCall = function(self,info) --粉丝数目
    if info == nil then return; end

    local number = info.num.."";
    self.fansNum:setText(number);
    
end

----好友列表
FriendsScene.updateFriends_list = function(self)
    local datas = self:requestCtrlCmd(FriendsController.s_cmds.ongetfriendslist);
    self:createFriendsListView(datas);
end

FriendsScene.createFriendsListView = function(self,datas)
    self.m_FriendsView:removeAllChildren(true);

    if not datas or #datas < 1 then 
        self:showNoLisTip(FriendsScene.itemType);
        self.m_AttentionView:removeProp(1);
        self.m_FansView:removeProp(1);
        self.m_FansView:setVisible(false);
        self.m_AttentionView:setVisible(false);
        return ; 
    end

    self.m_friendListData = datas;
    local friendOnline = {};
    local friendOffline = {};
    self.m_friend_items = {};

    for i,v in pairs(self.m_friendListData) do
        local temp = {};
        temp = new(FriendsItem,v,FriendsItem.s_friend_type);
        if not temp.status or temp.status.hallid <= 0 then
            table.insert(friendOffline,temp);
        else
            table.insert(friendOnline,temp);
        end
        temp:setOnClickCallBack(self,self.goToRoom);
        self.m_friend_items[i] = temp;
    end

    self:refreshFriendsStatus();

    if #friendOnline > 0 then
        local node = new(LabelItem,1); --type 1：在线 2：离线
        self.m_FriendsView:addChild(node);
        for i,v in pairs(friendOnline) do 
            if i == #friendOnline then
                v.setBottomLine(v,false);
            end
            self.m_FriendsView:addChild(v);
        end
    end

    if #friendOffline > 0 then
        local node = new(LabelItem,2); --type 1：在线 2：离线
        self.m_FriendsView:addChild(node);
        for i,v in pairs(friendOffline) do 
            if i == #friendOnline then
                v.setBottomLine(v,false);
            end
            self.m_FriendsView:addChild(v);
        end
    end
    
    self:showNoLisTip();
    self.m_AttentionView:removeProp(1);
    self.m_FansView:removeProp(1);
    self.m_FansView:setVisible(false);
    self.m_AttentionView:setVisible(false);
    self.m_FriendsView:addPropTransparency(1,kAnimNormal,300,150,0,1);
    self.m_FriendsView:setVisible(true);
end

---- 关注列表
FriendsScene.updateAttention_list = function(self)
    local datas = self:requestCtrlCmd(FriendsController.s_cmds.ongetfollowlist);
    self:createAttentionListView(datas);
end

FriendsScene.createAttentionListView = function(self,datas)
    self.m_AttentionView:removeAllChildren(true);
    if not datas or #datas < 1 then
        self.m_FriendsView:removeProp(1);
        self.m_FansView:removeProp(1);
        self.m_FansView:setVisible(false);
        self.m_FriendsView:setVisible(false);
        return ; 
    end
    
    self.m_attentionListData = datas;
    local fellowOnline = {};
    local fellowOffline = {};
    self.m_attention_items = {};

    for i,v in pairs(self.m_attentionListData) do
        local temp = {};
        temp = new(FriendsItem,v,FriendsItem.s_follow_type);
        if not temp.status or temp.status.hallid <= 0 then
            table.insert(fellowOffline,temp);
        else
            table.insert(fellowOnline,temp);
        end
        self.m_attention_items[i] = temp;
    end

    if #fellowOnline > 0 then
        local node = new(LabelItem,1); --type 1：在线 2：离线
        self.m_AttentionView:addChild(node);
        for i,v in pairs(fellowOnline) do 
            if i == #fellowOnline then
                v.setBottomLine(v,false);
            end
            self.m_AttentionView:addChild(v);
        end
    end

    if #fellowOffline > 0 then
        local node = new(LabelItem,2); --type 1：在线 2：离线
        self.m_AttentionView:addChild(node);
        for i,v in pairs(fellowOffline) do 
            if i == #fellowOffline then
                v.setBottomLine(v,false);
            end
            self.m_AttentionView:addChild(v);
        end
    end

    self:showNoLisTip();
    self.m_FriendsView:removeProp(1);
    self.m_FansView:removeProp(1);
    self.m_FansView:setVisible(false);
    self.m_FriendsView:setVisible(false);
    self.m_AttentionView:addPropTransparency(1,kAnimNormal,300,150,0,1);
    self.m_AttentionView:setVisible(true);
end

---- 粉丝列表
FriendsScene.updateFans_list = function(self)
    local datas = self:requestCtrlCmd(FriendsController.s_cmds.ongetfanslist);
    self:createFansListView(datas);
end

FriendsScene.createFansListView = function(self,datas)
    self.m_FansView:removeAllChildren(true);
    if not datas or #datas < 1 then
        self.m_FriendsView:removeProp(1);
        self.m_AttentionView:removeProp(1);
        self.m_AttentionView:setVisible(false);
        self.m_FriendsView:setVisible(false);
        return ; 
    end
    
    self.m_fansListData = datas;
    local fansOnline = {};
    local fansOffline = {};
    self.m_fans_items = {};

    for i,v in pairs(self.m_fansListData) do 
        local temp = {};
        temp = new(FriendsItem,v,FriendsItem.s_fans_type);
        if not temp.status or temp.status.hallid <= 0 then
            table.insert(fansOffline,temp);
        else
            table.insert(fansOnline,temp);
        end
        self.m_fans_items[i] = temp;
    end
    
    if #fansOnline > 0 then
        local node = new(LabelItem,1); --type 1：在线 2：离线
        self.m_FansView:addChild(node);
        for i,v in pairs(fansOnline) do
            if i == #fansOnline then
                v.setBottomLine(v,false);
            end 
            self.m_FansView:addChild(v);
        end
    end

    if #fansOffline > 0 then
        local node = new(LabelItem,2); --type 1：在线 2：离线
        self.m_FansView:addChild(node);
        for i,v in pairs(fansOffline) do
            if i == #fansOffline then
                v.setBottomLine(v,false);
            end 
            self.m_FansView:addChild(v);
        end
    end

    self:showNoLisTip();
    self.m_FriendsView:removeProp(1);
    self.m_AttentionView:removeProp(1);
    self.m_AttentionView:setVisible(false);
    self.m_FriendsView:setVisible(false);
    self.m_FansView:addPropTransparency(1,kAnimNormal,300,150,0,1);
    self.m_FansView:setVisible(true);
end

---更新状态
FriendsScene.changeStatusCall = function(self,status)
    self:filterFriendsRelation();
    self:changeFriendsStatusCall(status,self.m_friend_items);--好友
    self:changeFriendsStatusCall(status,self.m_attention_items);--关注
    self:changeFriendsStatusCall(status,self.m_fans_items);--粉丝   
end

--------好友状态更新实现方法
FriendsScene.changeFriendsStatusCall = function(self,status,items)
   
   if status and items then
        for i,item in pairs(items) do
            local uid = item:getUid();
            for _,sdata in pairs(status) do
                if uid == sdata.uid then
                    self:changeFriendsView(item,sdata);
                end
            end
        end
   end
end


FriendsScene.changeFriendsView = function(self,view,status)

    if view ~= nil and status ~= nil then
        view.status = status;
        view.setOnlineStatus(view,status);
        view.m_title.setText(view.m_title,view.m_title.m_str);
        view.m_contentText.setText(view.m_contentText,view.m_contentText.m_str);
    end     
end

--数据更新
FriendsScene.changeDataCall = function(self,state) 
    self:filterFriendsRelation();
    self:changeFriendsDataCall(state,self.m_friend_items);--好友
    self:changeFriendsDataCall(state,self.m_attention_items);--关注
    self:changeFriendsDataCall(state,self.m_fans_items);--粉丝
end

FriendsScene.filterFriendsRelation = function(self)
    if self.m_friend_items then
        for i,item in pairs(self.m_friend_items) do
            local uid = item:getUid();
            if FriendsData.getInstance():isYourFriend(uid) == -1 then
                table.remove(self.m_friend_items,i);
            end;
        end;
    end;
    if self.m_attention_items then
        for i,item in pairs(self.m_attention_items) do
            local uid = item:getUid();
            if FriendsData.getInstance():isYourFollow(uid) == -1 then
                table.remove(self.m_attention_items,i);
            end;
        end;
    end;
    if self.m_fans_items then
        for i,item in pairs(self.m_fans_items) do
            local uid = item:getUid();
            if FriendsData.getInstance():isYourFans(uid) == -1 then
                table.remove(self.m_fans_items,i);
            end;
        end;
    end;   
end;

---------数据更新实现方法
FriendsScene.changeFriendsDataCall = function(self,friendsdata,items)
    if items and friendsdata then
        for i,item in pairs(items) do
            local uid = item:getUid();
            for _,sdata in pairs(friendsdata) do
                if uid == tonumber(sdata.mid) then
                    self:updateFriendsView(i,sdata,items);
                    break;
                end
            end
        end
    end
end

FriendsScene.updateFriendsView = function(self,index,data,items)
    if items then
        items[index].updataItem(items[index],data);
    end
end


FriendsScene.onGetScreenings = function(level)
    local room_list = RoomConfig.getInstance():getRoomConfig();

    for i,list in pairs(room_list) do
       if level == list.level then
           return list.name;
       end
    end

    return nil;
end

-- 联盟界面
function FriendsScene.onUnionBtnClick(self)
   Log.d("FriendsScene.onUnionBtnClick");
--   if not self:requestCtrlCmd(HallController.s_cmds.isLogined) then return end
   if not self.m_union_dialog then
       self.m_union_dialog = new(UnionDialog, self);
   end;
   self:setHallUnionBtnVisible(false);
end;

-- 联盟按钮
function FriendsScene.setHallUnionBtnVisible(self,visible)
    if not visible then
        -- 收起动画
        local anim = self.m_union_btn:addPropTranslateWithEasing(1, kAnimNormal, 300, -1, "easeInBack", function (...) return 0 end, 0, -25, 0, 0)
        anim:setEvent(nil, function ()
            self.m_union_btn:removeProp(1);
            self.m_union_btn:setVisible(visible);
            self.m_union_dialog:show();
        end)
    else
        self.m_union_btn:setVisible(visible);
        -- 伸展动画
        local anim = self.m_union_btn:addPropTranslateWithEasing(2, kAnimNormal, 300, -1, "easeOutBack", function (...) return 0 end, -25, 25, 0, 0)
        anim:setEvent(nil, function ()
            self.m_union_btn:removeProp(2);
        end)   
    end; 
end

function FriendsScene.getUnionRecommend(self)
	self:requestCtrlCmd(FriendsController.s_cmds.getUnionRecommend);   
end

function FriendsScene.updataUnionDialog(self,data,errorMsg)
    if not self.m_union_dialog then
        self.m_union_dialog = new(UnionDialog,self);
    end
    if not self.m_union_dialog:isShowing() then
        self.m_union_dialog:show();
    end
    if errorMsg then
        --显示错误提示弹窗
    end

    self.m_union_dialog:updataRecommend(data);
end

function FriendsScene.getAllUnionMember(self)
	self:requestCtrlCmd(FriendsController.s_cmds.getUnionMember);   
end

function FriendsScene.updataUnionMember(self,data,errorMsg)
	if not self.m_union_dialog then
        self.m_union_dialog = new(UnionDialog,self);
    end
    if not self.m_union_dialog:isShowing() then
        self.m_union_dialog:show();
    end
    if errorMsg then
        --显示错误提示弹窗
    end

    self.m_union_dialog:updataMember(data);
end

function FriendsScene.getUnionDialog(self)
    return self.m_union_dialog;
end

function FriendsScene.getAddFriendDialog(self)
    return self.m_add_friends_dialog;
end;
--[Comment]
--跳转房间，roomType: 房间类型  data: 好友数据
function FriendsScene.goToRoom(self,roomType,data)
    if not roomType or not data then return end
    if UserInfo.getInstance():getUserStatus() == 1 then
        local freeze_time = UserInfo.getInstance():getUserFreezEndTime();
        local tip_msg;
        if freeze_time ~= 0 then
            tip_msg = "很抱歉，您的账号被多次举报，经核实已被冻结，将于"..os.date("%Y-%m-%d %H:%M",freeze_time) .."解封，期间仅能进入单机和残局版块。"
        else        
            tip_msg = "很抱歉，您的账号被多次举报，经核实已被冻结，仅能进入单机和残局版块。"
        end;
        if not self.m_chioce_dialog then
            self.m_chioce_dialog = new(ChioceDialog);
        end;
        self.m_chioce_dialog:setMode(ChioceDialog.MODE_SURE);
        self.m_chioce_dialog:setMessage(tip_msg);
        self.m_chioce_dialog:show();
        return;
    end;


    if roomType == FriendsItem.s_challenge_room then
        UserInfo.getInstance():setTargetUid(data.mid);
        local post_data = {};
        post_data.uid = tonumber(UserInfo.getInstance():getUid());
        post_data.level = 320;
        self:requestCtrlCmd(FriendsController.s_cmds.challenge,post_data); 
    elseif roomType == FriendsItem.s_watch_room then
        --观战
        RoomProxy.getInstance():setTid(data.tid);   
        RoomProxy.getInstance():gotoWatchRoom();
    end
 
end;

--[Comment]
--更新好友状态信息
function FriendsScene.refreshFriendsStatus(self)
    if not self.m_friend_items or not self.m_friendListData then return end
    FriendsData.getInstance():sendCheckUserStatus(self.m_friendListData);
end
--------------------------config--------------------------------------
FriendsScene.s_controlConfig = 
{
    [FriendsScene.s_controls.back_btn]             = {"back_btn"};
    [FriendsScene.s_controls.leaf_left]            = {"leaf_left"};
    [FriendsScene.s_controls.leaf_right]           = {"leaf_right"};
    [FriendsScene.s_controls.teapot_dec]           = {"teapot_dec"};
    [FriendsScene.s_controls.content_view]         = {"content_view"};
    [FriendsScene.s_controls.icon_mask]            = {"content_view","icon_frame","icon_mask"};
    [FriendsScene.s_controls.game_id]              = {"content_view","game_id"};
    [FriendsScene.s_controls.friends_btn]          = {"content_view","friend_btn"};
    [FriendsScene.s_controls.guanzhu_btn]          = {"content_view","guanzhu_btn"};
    [FriendsScene.s_controls.fans_btn]             = {"content_view","fans_btn"};
    [FriendsScene.s_controls.friend_view]          = {"content_view","friend_view"};
    [FriendsScene.s_controls.fans_view]            = {"content_view","fans_view"};
    [FriendsScene.s_controls.guanzhu_view]         = {"content_view","guanzhu_view"};
    [FriendsScene.s_controls.add_btn]              = {"content_view","add_btn"};
--    [FriendsScene.s_controls.invite_btn]           = {"content_view","invite_btn"};
    [FriendsScene.s_controls.add_btn_tip]          = {"content_view","add_btn","add_btn_txt","add_btn_tip"};
    [FriendsScene.s_controls.union_btn]            = {"union_btn"};
    [FriendsScene.s_controls.bottom_menu]          = {"bottom_menu"};
    
}

FriendsScene.s_controlFuncMap = 
{
    [FriendsScene.s_controls.back_btn]              = FriendsScene.onBack;
    [FriendsScene.s_controls.friends_btn]           = FriendsScene.onFriendsBtnClick;
    [FriendsScene.s_controls.guanzhu_btn]           = FriendsScene.onFriendsattBtnClick;
    [FriendsScene.s_controls.fans_btn]              = FriendsScene.onFriendsfansBtnClick;
    [FriendsScene.s_controls.add_btn]               = FriendsScene.onAddFriendBtnClick;
--    [FriendsScene.s_controls.invite_btn]            = FriendsScene.onInviteFriendBtnClick;
    [FriendsScene.s_controls.union_btn]             = FriendsScene.onUnionBtnClick;
}

FriendsScene.s_cmdConfig =
{
    [FriendsScene.s_cmds.change_userIcon]           = FriendsScene.changeUserIconCall;
    [FriendsScene.s_cmds.changeFriendsList]         = FriendsScene.changeFriendsListCall;
    [FriendsScene.s_cmds.changeFollowList]          = FriendsScene.changeFollowListCall;
    [FriendsScene.s_cmds.changeFansList]            = FriendsScene.changeFansListCall;
    [FriendsScene.s_cmds.changeFriendsData]         = FriendsScene.changeDataCall;
    [FriendsScene.s_cmds.changeFriendstatus]        = FriendsScene.changeStatusCall;  
    [FriendsScene.s_cmds.newfriendsNum]             = FriendsScene.changeNewfriendsNumCall;
    [FriendsScene.s_cmds.friends_num]               = FriendsScene.changeFriendsNumCall;
    [FriendsScene.s_cmds.follow_num]                = FriendsScene.changeFollowNumCall;
    [FriendsScene.s_cmds.fans_num]                  = FriendsScene.changeFansNumCall;
    [FriendsScene.s_cmds.change_myHead]             = FriendsScene.changeMyHead;
    [FriendsScene.s_cmds.closeShareDialog]          = FriendsScene.closeShareDialog;
    [FriendsScene.s_cmds.updata_union_dialog]       = FriendsScene.updataUnionDialog;
    [FriendsScene.s_cmds.updata_union_member]       = FriendsScene.updataUnionMember;
}

--------------------label node---------------------------
LabelItem = class(Node);
LabelItem.s_w = 600;
LabelItem.s_h = 36;

LabelItem.ctor = function(self,typelabel)
    self:setSize(LabelItem.s_w, LabelItem.s_h);
    self.m_bg = new(Image,"common/decoration/line_4.png");
    self.m_bg:setSize(527, 19);
    self.m_bg:setAlign(kAlignCenter);
    if typelabel == 1 then
        self.m_text = new(Text,"在线",nil,nil,kAlignCenter,nil,36,100,100,100);
    else
        self.m_text = new(Text,"离线",nil,nil,kAlignCenter,nil,36,100,100,100);
    end
    self.m_text:setAlign(kAlignCenter);
    self.m_bg:addChild(self.m_text);
    self:addChild(self.m_bg);
end


-----------------------private node-----------------------

require(VIEW_PATH .. "friends_view_node");
FriendsItem = class(Node)
FriendsItem.s_w = 600;
FriendsItem.s_h = 98;
FriendsItem.s_friend_type = 1;
FriendsItem.s_follow_type = 2;
FriendsItem.s_fans_type = 3;
FriendsItem.s_watch_room = 10;
FriendsItem.s_challenge_room = 11;

FriendsItem.ctor = function(self,dataid,itemType)
    self.m_data = dataid;
    if not dataid then return  end
        
    self.datas = FriendsData.getInstance():getUserData(dataid);
    self.status = FriendsData.getInstance():getUserStatus(dataid);

    self.m_root_view = SceneLoader.load(friends_view_node);
    self.m_root_view:setAlign(kAlignCenter);
    self.m_node_view = self.m_root_view:getChildByName("node_view");
    self:addChild(self.m_root_view);
    self:setSize(self.m_root_view:getSize());
    self.itemType = itemType;
   
    --头像
    self.m_vip_frame = self.m_node_view:getChildByName("icon_bg"):getChildByName("vip_frame");
    local iconFile = UserInfo.DEFAULT_ICON[1]; --FriendsItem.idToIcon[0]; 
    self.m_icon_mask = self.m_node_view:getChildByName("icon_bg"):getChildByName("icon_mask");
    self.m_icon = new(Mask, iconFile, "common/background/head_mask_bg_86.png");
    self.m_icon:setAlign(kAlignCenter);
    self.m_icon:setSize(self.m_icon_mask:getSize());
    self.m_icon_mask:addChild(self.m_icon);
    if self.datas then
        if self.datas.iconType == -1 then
            self.m_icon:setUrlImage(self.datas.icon_url);
        else
            self.m_icon:setFile(UserInfo.DEFAULT_ICON[self.datas.iconType] or iconFile);
        end
    end
    --段位
    self.m_level = self.m_node_view:getChildByName("level");
    self.m_level:setFile("common/icon/level_9.png");
    --名字
    self.m_title = self.m_node_view:getChildByName("name");
    self.m_vip_logo = self.m_node_view:getChildByName("vip_logo");
    --积分
    self.m_contentText = self.m_node_view:getChildByName("score");
    --状态
--    self.m_onlineRoomType = self.m_node_view:getChildByName("room_type");
--    self.m_onlineStatus = self.m_node_view:getChildByName("online_status");
    self.m_offline = self.m_node_view:getChildByName("offline");
    self.m_statusButton = self.m_node_view:getChildByName("button");
    self.m_buttonText = self.m_statusButton:getChildByName("text");

    --详细信息按钮
    self.m_infoBtn = self.m_node_view:getChildByName("check_info");
    self.m_infoBtn:setOnClick(self,self.onBtnClick);
    self.m_infoBtn:setSrollOnClick();

    --底部装饰线
    self.m_bottomLine = self.m_node_view:getChildByName("item_line");
    self.m_bottomLine:setVisible(true);

    self:setOnlineStatus(self.status);
    self:setItemUserInfo();
    self:setVipIconStatus();
end

FriendsItem.dtor = function(self)
    if self.m_statusButton then
        delete(self.m_statusButton);
        self.m_statusButton = nil;
    end;
end;


FriendsItem.setOnBtnClick = function(self,obj,func)
    self.m_btn_obj = obj;
    self.m_btn_func = func;
end

FriendsItem.onBtnClick = function(self)
    Log.d("FriendsItem.onBtnClick");
    StateMachine.getInstance():pushState(States.FriendsInfo,StateMachine.STYPE_CUSTOM_WAIT,nil,tonumber(self.m_data));
end

FriendsItem.updateUserIcon = function(self,imageName)
    Log.i("FriendsItem.updateUserIcon: "..(imageName or "null"));
    if imageName then
        self.m_icon:setFile(imageName);
    end
end

FriendsItem.getUid = function(self)
    return self.m_data or 0;
end

FriendsItem.updataItem = function(self,data)
    self.datas = data;
    if self.datas then
        if self.datas.iconType == -1 then
            self.m_icon:setUrlImage(self.datas.icon_url);
        else
            self.m_icon:setFile(UserInfo.DEFAULT_ICON[self.datas.iconType] or UserInfo.DEFAULT_ICON[1]);
        end
    end

    self.m_level:setFile("common/icon/level_"..10 - UserInfo.getInstance():getDanGradingLevelByScore(tonumber(self.datas.score))..".png");
    self.m_title:setText(self.datas.mnick);
    self.m_contentText:setText("积分:"..self.datas.score);
end

FriendsItem.setBottomLine = function(self,ret)
    if not ret then
        self.m_bottomLine:setVisible(ret);
    end
end

--[Comment]
--设置item中联网状态，status: 好友状态数据
function FriendsItem.setOnlineStatus(self,status)
    self.status = status;
    --离线状态
    if not status or status.hallid <=0 then
        self.m_offline:setText("离线",nil,nil,125,80,65);
        self.m_offline:setPos(400,46);
        self.m_statusButton:setVisible(false);
        self.m_icon:setGray(true);
        return
    end

    --item类型
    if not self.itemType or self.itemType > 1 then
        self.m_offline:setPos(400,46);
        self.m_statusButton:setVisible(false);
    else
        self.m_offline:setPos(299,46);
        self.m_statusButton:setVisible(true);
    end

    --在线状态
    self.m_icon:setGray(false);
    if status.tid and status.tid >0 then
        local strname = FriendsScene.onGetScreenings(status.level);
        self.m_offline:setText(strname or "游戏中",nil,nil,125,80,65); 
        self.m_buttonText:setText("观战");
        self.m_statusButton:setFile({"common/button/dialog_btn_7_normal.png","common/button/dialog_btn_7_press.png"});
        self.m_statusButton:setOnClick(self,function()
            self:gotoRoom(FriendsItem.s_watch_room,status.tid);
        end);
    else
        self.m_offline:setText("闲逛中",nil,nil,25,115,40);
        self.m_buttonText:setText("挑战");
        self.m_statusButton:setFile({"common/button/dialog_btn_3_normal.png","common/button/dialog_btn_3_press.png"});
        self.m_statusButton:setOnClick(self,function()
            self:gotoRoom(FriendsItem.s_challenge_room);
        end);
    end
end

--[Comment]
--设置item中，名字和积分 
function FriendsItem.setItemUserInfo(self)
    --存在好友数据
    if self.datas then
        if self.datas.mnick then
            local lenth = string.lenutf8(GameString.convert2UTF8(self.datas.mnick));
            if lenth > 10 then    
                local str  = string.subutf8(self.datas.mnick,1,7).."...";
                self.m_title.setText(self.m_title,str);
            else
                self.m_title.setText(self.m_title,self.datas.mnick);    
            end
        else
            self.m_title.setText(self.m_title,self.m_data or "博雅象棋");
        end
        local  str = "积分:"..self.datas.score;
        self.m_contentText.setText(self.m_contentText,str);  
        self.m_level:setFile("common/icon/level_"..10 - UserInfo.getInstance():getDanGradingLevelByScore(tonumber(self.datas.score))..".png");  
        return
    end
    --好友数据为空
    local  str = "积分:0";
    self.m_title.setText(self.m_title,self.m_data or "博雅象棋");
    self.m_contentText.setText(self.m_contentText,str);  

end

--[Comment]
--设置item中，vip头像
function FriendsItem.setVipIconStatus(self)
    if self.datas and self.datas.my_set then
        local frameRes = UserSetInfo.getInstance():getFrameRes(self.datas.my_set.picture_frame or "sys");
        local fw,fh = self.m_vip_frame:getSize();
        if frameRes.frame_res then
            self.m_vip_frame:setFile(string.format(frameRes.frame_res,fw));
        end
        self.m_vip_frame:setVisible(frameRes.visible);
    end
    local vw,vh = self.m_vip_logo:getSize();
    if self.datas and self.datas.is_vip == 1 then
        self.m_title:setPos(130+vw,25);
--        self.m_vip_frame:setVisible(true);
        self.m_vip_logo:setVisible(true);
    else
        self.m_title:setPos(130,25);
--        self.m_vip_frame:setVisible(false);
        self.m_vip_logo:setVisible(false);
    end
end

function FriendsItem.setOnClickCallBack(self,obj,func)
    self.callBackObj = obj;
    self.callBackFunc = func;
end

--[Comment]
--跳转房间，roomType: 好友游戏房间类型，tid: 房间桌子号
function FriendsItem.gotoRoom(self,roomType,tid) 
    if self.callBackObj and self.callBackFunc then
        if not roomType then return end
        local data = self.datas;
        data.tid = tid;
        self.callBackFunc(self.callBackObj,roomType,data);
    end
end

--function FriendsItem.refreshStatus(self)
--    local status = FriendsData.getInstance():getUserStatus(self.m_data);
--    self:setOnlineStatus(status);
--end