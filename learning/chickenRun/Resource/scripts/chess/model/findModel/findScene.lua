--region NewFile_1.lua
--Author : BearLuo
--Date   : 2015/4/23

require(BASE_PATH.."chessScene");
require("dialog/common_share_dialog");
require(DIALOG_PATH .. "find_view_help_dialog");
require(MODEL_PATH.."online/private/privateScene");
require("dialog/common_share_dialog");
require(MODEL_PATH.."findModel/recommendEndgateItem");
require(MODEL_PATH.."findModel/recentlyPlayerItem");
require(MODEL_PATH .. "findModel/endgateListItem");
require("chess/include/slidingLoadView");

FindScene = class(ChessScene);

FindScene.s_controls = 
{
    bottom_menu             = 1;
    web_view                = 2;
    recommend_scroll_view   = 3;
    ad_scroll_view          = 4;
    recommend_btn           = 5;
    endgate_btn             = 6;
    endgate_scroll_view     = 7;
    refresh_btn             = 8;
    help_btn                = 9
}

FindScene.s_cmds = 
{

    init_ad_scroll_view                 = 1;
    init_recently_player_view           = 2;
    add_friend_response                 = 3;
    wulin_booth_recommend_response      = 4;
    add_endgate                         = 5;
    save_mychess                        = 6;
}


function FindScene.ctor(self,viewConfig,controller)
	self.m_ctrls = FindScene.s_controls;
    self:create();
end 


function FindScene.resume(self)
    ChessScene.resume(self);
--    self:removeAnimProp();
--    self:resumeAnimStart();

    if not self.mInited then
        self.mInited = true;
        self:refreshData();
    end

    BottomMenu.getInstance():onResume(self.mBottomMenu);
    BottomMenu.getInstance():setHandler(self,BottomMenu.FINDTYPE);

--    self:showNativeListWebView();
end

FindScene.isShowBangdinDialog = false;


function FindScene.pause(self)
	ChessScene.pause(self);
    self:removeAnimProp();
--    self:pauseAnimStart();
    BottomMenu.getInstance():onPause();
    call_native(kShareWebViewClose);
    call_native(kNativeWebViewClose);
    call_native(kActivityWebViewClose);
end 


function FindScene.dtor(self)
    delete(self.mAdsAnim);
    self:stopPopAnim();

    delete(self.mHelpDialog);
    delete(self.mChioceDialog);
end 
--占位

function FindScene.setAnimItemEnVisible(self,ret)
end


function FindScene.removeAnimProp(self)
end

function FindScene.resumeAnimStart(self,lastStateObj,timer)
    BottomMenu.getInstance():hideView(true);
    self:removeAnimProp();
    local duration = timer.waitTime;
    local delay = timer.duration + duration;
    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(lastStateObj.state) then
        if not BottomMenu.getInstance():checkStateSort(States.findModel,lastStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,-w,0,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,w,0,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(0,timer);
    end
end




function FindScene.pauseAnimStart(self,newStateObj,timer)
    self:removeAnimProp();
    local w,h = self:getSize();
    local duration = timer.waitTime;
    local delay = timer.duration + duration;
    if BottomMenu.getInstance():checkState(newStateObj.state) then
        if BottomMenu.getInstance():checkStateSort(States.findModel,newStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,w,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,-w,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(1,timer);
    end
end

---------------------- func --------------------

function FindScene.create(self)




    self.mBottomMenu = self:findViewById(self.m_ctrls.bottom_menu);
    self.mWebView = self:findViewById(self.m_ctrls.web_view);
    local w,h = self:getSize();


    local mw,mh = self.mWebView:getSize();
    self.mWebView:setSize(mw,mh+h-System.getLayoutHeight());
    
    self:initRecommend();
    self:initEndgate();

    self.recommendBtn = self:findViewById(self.m_ctrls.recommend_btn);
    self.endgateBtn = self:findViewById(self.m_ctrls.endgate_btn);
    self:onRecommendBtnClick();

end


function FindScene.refreshData(self)
    self:refreshRecommendData();
    self:refreshEndgateData();
end

function FindScene.refreshRecommendData(self)
    self.popularEndgateReplay:removeAllChildren(true);
    self.popularEndgateReplay:setSize(nil,0);
    self:requestCtrlCmd(FindController.s_cmds.requestData);
    self.recommendScrollView:updateScrollView();
end

function FindScene.refreshEndgateData(self)
    for i=1,3 do
        if self.endgateMenuSort and self.endgateMenuSort[i] then
            self:refreshEndgateScrollView(i);
        end
    end
end


function FindScene.initEndgate(self)
    local w,h = self:getSize();
    self.endgateScrollView = self:findViewById(self.m_ctrls.endgate_scroll_view);
    self.endgateScrollView:setVisible(true);
    self.endgateScrollView:setPos(w,nil);
    local mw,mh = self.endgateScrollView:getSize();
    self.endgateScrollView:setSize(mw,mh+h-System.getLayoutHeight());

    self.endgateListHandler = self.endgateScrollView:getChildByName("endgate_list_handler");
    local mw,mh = self.endgateListHandler:getSize();
    self.endgateListHandler:setSize(mw,mh+h-System.getLayoutHeight());

    self.endgateLists = {};
    --我的创建没有残局提示：大侠，您还没创建过残局，快去试试吧，残局被通关还能获得金币奖励哦
--没有街边残局：暂时没有街边残局，试创建一个给棋友们挑战吧
    self.endgateListsTest = {

        '暂无关注残局，关注的未下架残局都可以在这里快速找到哦。',
        '暂时没有街边残局，试创建一个给棋友们挑战吧',
        '暂时没有街边残局，试创建一个给棋友们挑战吧',
    }

    for i=1,3 do

        local view = new(SlidingLoadView, 0, 0, mw,mh+h-System.getLayoutHeight(), true)
        view:setOnLoad(self,function(self)
            self:requestCtrlCmd(FindController.s_cmds.onLoadEndgate,i,self.endgateMenuSort[i]);
        end)
        view:setNoDataTip(self.endgateListsTest[i]);
        view:setVisible(false);
        self.endgateListHandler:addChild(view);

        self.endgateLists[i] = view;

    end
    self:initEndgateMenu();

    self.createEndgateBtn = self.endgateScrollView:getChildByName("create_endgate_btn");
    self.createEndgateBtn:setOnClick(self,self.gotoCreateEndgate);
    self.ownCreateBtn = self.endgateScrollView:getChildByName("own_create_btn");
    self.ownCreateBtn:setOnClick(self,self.gotoOwnCreateEndgate);
    
end


function FindScene.initEndgateMenu(self)
    self.endgateMenu = self.endgateScrollView:getChildByName("endgate_menu");

    self.ownMarkBtn = self.endgateMenu:getChildByName("own_mark_btn");
    self.timeSortBtn = self.endgateMenu:getChildByName("time_sort_btn");
    self.jackpotSortBtn = self.endgateMenu:getChildByName("jackpot_sort_btn");
    self.endgateMenuBtn = {};

    self.endgateMenuBtn[1] = self.ownMarkBtn;
    self.endgateMenuBtn[2] = self.timeSortBtn;
    self.endgateMenuBtn[3] = self.jackpotSortBtn;
    self.endgateMenuSort = {};
    self.endgateMenuSortText = {};
    self.endgateMenuSortText[1] = '我关注的';
    self.endgateMenuSortText[2] = '时间排序';
    self.endgateMenuSortText[3] = '奖池排序';
    for i=1,3 do
        self:onEndgateMenuBtnClick(i);
        self:updateViewEndgateMenuBtn(i); -- 初始化数据
        self.endgateMenuBtn[i]:setOnClick(self,function(self)
            self:onEndgateMenuBtnClick(i);
        end)
    end
end


function FindScene.updateViewEndgateMenuBtn(self,index)
    if self.endgateMenuBtn[index] then
        if self.endgateMenuSort[index] == 'desc' then
            self.endgateMenuSort[index] = 'asc';
            self.endgateMenuBtn[index]:getChildByName("text"):setText(self.endgateMenuSortText[index] .. "▼");
        else
            self.endgateMenuSort[index] = 'desc';
            self.endgateMenuBtn[index]:getChildByName("text"):setText(self.endgateMenuSortText[index] .. "▲");
        end
    end
end


function FindScene.selectEndgateMenuBtn(self,index)
    local preIndex = self.endgateMenuIndex;
    if self.endgateMenuBtn[preIndex] then
        self.endgateMenuBtn[preIndex]:getChildByName("text"):setColor(125,80,65);
        self.endgateMenuBtn[preIndex]:getChildByName("red_line"):setVisible(false);
        self.endgateLists[preIndex]:setVisible(false);
    end

    if self.endgateMenuBtn[index] then
        self.endgateMenuIndex = index;
        self.endgateMenuBtn[index]:getChildByName("text"):setColor(215,76,45);
        self.endgateMenuBtn[index]:getChildByName("red_line"):setVisible(true);
        self.endgateLists[index]:setVisible(true);
        return true;
    else
        if self.endgateMenuBtn[preIndex] then
            self.endgateMenuBtn[preIndex]:getChildByName("text"):setColor(215,76,45);
            self.endgateMenuBtn[preIndex]:getChildByName("red_line"):setVisible(true);
            self.endgateLists[preIndex]:setVisible(true);
        end
    end
    return false;
end



function FindScene.refreshEndgateScrollView(self,index)
    self:requestCtrlCmd(FindController.s_cmds.onEndgateMenuBtnClick,index);
    local view = self.endgateLists[index];

    view:reset()
    view:loadView();
end




function FindScene.onEndgateMenuBtnClick(self,index)
    if self.endgateMenuIndex and self.endgateMenuIndex == index then
        self:updateViewEndgateMenuBtn(index);
        self:refreshEndgateScrollView(index);
    else
        if self:selectEndgateMenuBtn(index) then
            self.endgateMenuIndex = index;
        end
    end
end

function FindScene.addEndgate(self,index,datas,isNoData)
    if type(datas) ~= "table" or not self.endgateLists[index] then return end;
    local scrollView = self.endgateLists[index];
    for i,data in ipairs(datas) do
        local item = new(EndgateListItem,data);
        scrollView:addChild(item);
    end
    scrollView:loadEnd(isNoData);
end

function FindScene.initRecommend(self)
    local w,h = self:getSize();
    self.recommendScrollView = self:findViewById(self.m_ctrls.recommend_scroll_view);
    self.recommendScrollView:setVisible(true);
    self.recommendScrollView:setPos(0,nil);
    local mw,mh = self.recommendScrollView:getSize();
    self.recommendScrollView:setSize(mw,mh+h-System.getLayoutHeight());

    self:initAdScrollView();
    self:initRecentlyPlayerView();
    self:initWulinBoothRecommendView();
end

function FindScene.initAdScrollView(self,tab)
    self.adScrollView = self:findViewById(self.m_ctrls.ad_scroll_view);
    self.adView = self.adScrollView:getChildByName("ad_view");
    self.ad = self.adView:getChildByName("ad");
    self.adViewBottomTips = self.adView:getChildByName("ad_view_bottom_tips");
    self.adViewBtnL = self.adScrollView:getChildByName("btn_l");
    self.adViewBtnR = self.adScrollView:getChildByName("btn_r");
    self.adViewBtnL:setOnClick(self,self.showPreAd);
    self.adViewBtnR:setOnClick(self,self.showNextAd);

    if not tab or type(tab) ~= "table" or #tab == 0 then 
        self.ad:getChildByName("no_activity"):setVisible(true)
        return ;
    end
    self.ad:getChildByName("tip_text"):setVisible(false);
    
    self:initAds(tab);
end

function FindScene.onBackAction(self)
    self:requestCtrlCmd(FindController.s_cmds.onBack);
end

function FindScene.showNextAd(self)
    if self.showAd and self.showAd > 0 then
        local len = #self.ads;
        local nextAd = self.showAd % len + 1;
        if self.ads[nextAd] then
            self.ads[self.showAd].act:setVisible(false);
            self.ads[self.showAd].tip:setFile("drawable/gray_dot.png");
            self.showAd = nextAd;
            self.ads[self.showAd].act:setVisible(true);
            self.ads[self.showAd].tip:setFile("drawable/red_dot.png");
        end
    end
end

function FindScene.showPreAd(self)
    if self.showAd and self.showAd > 0 then
        local len = #self.ads;
        local nextAd = (self.showAd - 2 + len) % len + 1;
        if self.ads[nextAd] then
            self.ads[self.showAd].act:setVisible(false);
            self.ads[self.showAd].tip:setFile("drawable/gray_dot.png");
            self.showAd = nextAd;
            self.ads[self.showAd].act:setVisible(true);
            self.ads[self.showAd].tip:setFile("drawable/red_dot.png");
        end
    end
end

function FindScene.initAds(self,tab)
    delete(self.mAdsAnim);
    if type(self.ads) == "table" then
        for _,ad in ipairs(self.ads) do
            delete(ad.act);
            delete(ad.tip);
        end
    end
    self.ads = {};
    self.adViewBottomTips:setSize(0,nil);
    self.showAd = 0;
    for _,data in pairs(tab) do
        self:addAd(data);
    end
    if #tab > 0 then
        self.showAd = 1;
        self.ads[self.showAd].act:setVisible(true);
        self.ads[self.showAd].tip:setFile("drawable/red_dot.png");
        if #tab > 1 then
            self.mAdsAnim = new(AnimInt,kAnimLoop, 0, 1, 5000, -1);
            self.mAdsAnim:setEvent(self,self.showNextAd);
        end
    end
end

function FindScene.addAd(self,data)

    local bg = new(Image,"common/background/activity_bg_2.png")
    local act = new(Button,"common/background/activity_bg.png");
    local w,h = self.ad:getSize();
    local str = data.img_url;
    act:setSize(630,300);
    act:setAlign(kAlignCenter)
    act:setUrlImage(str);
    act:setSrollOnClick();
    act:setOnClick(self,function()
        local absoluteX,absoluteY = 0,0;
        local x = absoluteX*System.getLayoutScale();
        local y = absoluteY*System.getLayoutScale();
        local width = System.getScreenWidth();
        local height = System.getScreenHeight();
        NativeEvent.getInstance():showActivityWebView(x,y,width,height,data.info_url);
    end);
    bg:addChild(act)
    bg:setVisible(false);
    
    local w,h = self.adViewBottomTips:getSize();

    local tip = new(Image,"drawable/gray_dot.png");
    tip:setSize(h,h);
    local ad = {};
    ad.act = bg;
    ad.tip = tip;

    table.insert(self.ads,ad);
    tip:setPos(w,0);

    self.adViewBottomTips:addChild(tip);
    self.adViewBottomTips:setSize(w+h+5,nil);
    self.ad:addChild(bg);
end

function FindScene.showNativeListWebView(self)
	local width_content,height_content = self.mWebView:getSize();
    local absoluteX,absoluteY = self.mWebView:getPos();
    local x = absoluteX*System.getLayoutScale();
    local y = absoluteY*System.getLayoutScale();
    local width = width_content*System.getLayoutScale();
    local height = height_content*System.getLayoutScale();
    NativeEvent.getInstance():showNativeWebView(x,y,width,height);
end

function FindScene.onRecommendBtnClick(self)
    self.recommendBtn:setEnable(false);
    self.endgateBtn:setEnable(true);
    self.mRefreshFunc = self.refreshRecommendData;
    if self.recommendScrollView then
        local w,h = self:getSize();
        local x,y = self.recommendScrollView:getPos();
        self:startPopAnim(-x);
    end
end

function FindScene.onEndgateBtnClick(self)
    self.recommendBtn:setEnable(true);
    self.endgateBtn:setEnable(false);
    self.mRefreshFunc = self.refreshEndgateData;
    if self.endgateScrollView then
        local w,h = self:getSize();
        local x,y = self.endgateScrollView:getPos();
        self:startPopAnim(-x);
    end
end

function FindScene.startPopAnim(self,len)
    self:stopPopAnim();
    self.popAnim = new(AnimInt, kAnimLoop, 0, 1, 1000/60, -1);
    self.popAnim:setEvent(self,function()
        if math.abs(len) < 5 then
            if self.endgateScrollView then
                local x,y = self.endgateScrollView:getPos();
                self.endgateScrollView:setPos(x+len,nil);
            end

            if self.recommendScrollView then
                local x,y = self.recommendScrollView:getPos();
                self.recommendScrollView:setPos(x+len,nil);
            end
            self:stopPopAnim();
            return ;
        end
        local move = len * 0.2;
        len = len - move;
        if self.endgateScrollView then
            local x,y = self.endgateScrollView:getPos();
            self.endgateScrollView:setPos(x+move,nil);
        end

        if self.recommendScrollView then
            local x,y = self.recommendScrollView:getPos();
            self.recommendScrollView:setPos(x+move,nil);
        end
    end);
end

function FindScene.stopPopAnim(self)
    delete(self.popAnim);
end

function FindScene.initRecentlyPlayerView(self,tab)
    self.recentlyPlayerGroup = {};
    self.recentlyPlayerView = self.recommendScrollView:getChildByName("recently_player_view");
    self.recentlyPlayerGroupView = self.recentlyPlayerView:getChildByName("recently_player_group_view");
    self.recentlyPlayerGroupView:removeAllChildren();
    self.recentlyPlayerView:getChildByName("recentlyPlayerBtn"):setOnClick(self,self.gotoRecentlyPlayerStatus)

    if type(tab) ~= "table" or #tab == 0 then
        local noDataView = self.recentlyPlayerView:getChildByName("recently_no_data_view");
        noDataView:setVisible(true);
        noDataView:getChildByName("tips"):setPickable(false)
        noDataView:getChildByName("quick_match_btn"):setOnClick(self,self.quickMatch);
        noDataView:getChildByName("challenge_friends_btn"):setOnClick(self,self.challengeFriends);
    else
        local noDataView = self.recentlyPlayerView:getChildByName("recently_no_data_view");
        noDataView:setVisible(false);
        local w,h = self.recentlyPlayerGroupView:getSize();
        local len = w/3;
        for i=1,3 do
            if tab[i] then
                local item = new(RecentlyPlayerItem,tab[i]);
                self.recentlyPlayerGroupView:addChild(item);
                item:setPos((i-1)*len,0);
                item:setFollowBtnClick(self,self.requestFollow);
                self.recentlyPlayerGroup[i] = item;
            end
        end
    end
end

function FindScene.onScrollEvent(self,scroll_status, diffY, totalOffset,isMarginRebounding)
    local frameLength = self.recommendScrollView:getFrameLength();  -- 显示区域
    local viewLength = self.recommendScrollView:getViewLength();    -- 总长度
    if math.abs(totalOffset) >= viewLength - frameLength then
        self:requestCtrlCmd(FindController.s_cmds.requestWulinBoothRecommend);
    end
end

function FindScene.initWulinBoothRecommendView(self,datas,isNoData,isNull)
    self.popularEndgateReplay = self.recommendScrollView:getChildByName("popular_endgate_replay");
    if type(datas) ~= "table" then
        return ;
    end
    if isNoData then
        local w,h = self.popularEndgateReplay:getSize();
        local msg = "没有更多数据了"
        if isNull then
            local item = new(Text,"暂无棋谱推荐", w, 0, kAlignCenter, fontName, 30, 80, 80, 80);
            local addW,addH = item:getSize();
            item:setPos(0,h + 20);
            self.popularEndgateReplay:addChild(item);
            h = h + addH + 20
            msg = "过关热门街边残局的棋谱都有机会被推荐喔"
        end
        local item = new(Text,msg, w, 0, kAlignCenter, fontName, 30, 80, 80, 80);
        local addW,addH = item:getSize();
        item:setPos(0,h + 20);
        self.popularEndgateReplay:setSize(nil,h+addH + 20);
        self.popularEndgateReplay:addChild(item);
        self.recommendScrollView:updateScrollView();
        self.recommendScrollView:setOnScrollEvent(nil,nil);
        return ;
    end
    self.recommendScrollView:setOnScrollEvent(self,self.onScrollEvent)

--    for i=1,3 do
--        table.insert(datas,datas[1]);
--    end


    for _,data in ipairs(datas) do
        local item = new(RecommendEndgateItem,data);
        local w,h = self.popularEndgateReplay:getSize();
        local addW,addH = item:getSize();
        item:setCollectionClick(self,self.savetoLocal)
        item:setShareBtnClick(self,self.shareReplay)
        item:setPos(0,h + 20);
        self.popularEndgateReplay:setSize(nil,h+addH + 20);
        self.popularEndgateReplay:addChild(item);
        self.recommendScrollView:updateScrollView();
    end
end

-- 收藏棋谱
function FindScene.savetoLocal(self, chessItem)
    self.mChessItem = chessItem;
    -- 收藏弹窗
    if not self.mChioceDialog then
        self.mChioceDialog = new(ChioceDialog)
    end;
    self.mChioceDialog:setMode(ChioceDialog.MODE_SHOUCANG);  
    self.mSaveCost = UserInfo.getInstance():getFPcostMoney().collect_manual;  
    self.mChioceDialog:setMessage("是否花费"..(self.mSaveCost or 500) .."金币收藏当前棋谱？");
    self.mChioceDialog:setPositiveListener(self, self.saveChesstoMysave);
    self.mChioceDialog:show();
end;

-- 统计分享复盘
function FindScene.shareReplay(self, manualData)
    if not self.commonShareDialog then
        self.commonShareDialog = new(CommonShareDialog);
    end
    self.commonShareDialog:setShareDate(manualData,"manual_share");
    self.commonShareDialog:show();
end;

-- 收藏到我的收藏
function FindScene.saveChesstoMysave(self,item)
    self:requestCtrlCmd(FindController.s_cmds.save_mychess,self.mChioceDialog:getCheckState(),self.mChessItem:getData());
end;

function FindScene.onSaveMychessCallBack(self,data)
    if not data then return end;
    if data.cost then
        if data.cost > 0 then 
            ChessToastManager.getInstance():showSingle("收藏成功！",2000);
            if self.mChessItem then
                self.mChessItem:setSuggestIsCollect();
            end;
        elseif data.cost == 0 then
            ChessToastManager.getInstance():showSingle("您已经收藏过了！",1000);
        elseif data.cost == -1 then
            -- -1是老版本本地棋谱上传成功
        end
    end
end

function FindScene.requestFollow(self,data)
    self:requestCtrlCmd(FindController.s_cmds.requestFollow,data);
end

function FindScene.onFriendsAddFriendResponse(self,data)
    if type(self.recentlyPlayerGroup) == "table" then
        for i=1,3 do
            local item = self.recentlyPlayerGroup[i];
            if item and item.getTargetMid and item:getTargetMid() == data.target_mid then
                item:updateRelation(data.relation);
            end
        end
    end
end

function FindScene.gotoRecentlyPlayerStatus(self)
    StateMachine.getInstance():pushState(States.RecentlyPlayerState,StateMachine.STYPE_CUSTOM_WAIT);
end

function FindScene.quickMatch(self)
    self:requestCtrlCmd(FindController.s_cmds.quickPlay);
end

function FindScene.challengeFriends(self)
    PrivateScene.challengeFriends = true;
    StateMachine.getInstance():pushState(States.PrivateHall,StateMachine.STYPE_CUSTOM_WAIT);
end

function FindScene.gotoCreateEndgate(self)
    StateMachine.getInstance():pushState(States.createEndgate,StateMachine.STYPE_CUSTOM_WAIT);
end

function FindScene.gotoOwnCreateEndgate(self)
    StateMachine.getInstance():pushState(States.ownCreateEndgate,StateMachine.STYPE_CUSTOM_WAIT);
end

function FindScene.onHelpBtnClick(self)
    if not self.mHelpDialog then
        self.mHelpDialog = new(FindViewHelpDialog);
    end
    self.mHelpDialog:show();
end

function FindScene.onRefreshBtnClick(self)
    if type(self.mRefreshFunc) == 'function' then
        self:mRefreshFunc()
    end
end

---------------------- config ------------------
FindScene.s_controlConfig = {
    [FindScene.s_controls.bottom_menu]                      = {"bottom_menu"};
    [FindScene.s_controls.web_view]                         = {"web_view"};
    [FindScene.s_controls.recommend_scroll_view]            = {"web_view","recommend_scroll_view"};
    [FindScene.s_controls.ad_scroll_view]                   = {"web_view","recommend_scroll_view","ad_scroll_view"};
    [FindScene.s_controls.recommend_btn]                    = {"web_view","recommend_btn"};
    [FindScene.s_controls.endgate_btn]                      = {"web_view","endgate_btn"};
    [FindScene.s_controls.endgate_scroll_view]              = {"web_view","endgate_scroll_view"};
    [FindScene.s_controls.help_btn]                         = {"help_btn"};
    [FindScene.s_controls.refresh_btn]                      = {"refresh_bg","refresh_btn"};

    
}

FindScene.s_controlFuncMap = {
    [FindScene.s_controls.recommend_btn]                    = FindScene.onRecommendBtnClick;
    [FindScene.s_controls.endgate_btn]                      = FindScene.onEndgateBtnClick;
    [FindScene.s_controls.help_btn]                         = FindScene.onHelpBtnClick;
    [FindScene.s_controls.refresh_btn]                      = FindScene.onRefreshBtnClick;
    
};

FindScene.s_cmdConfig =
{
    [FindScene.s_cmds.init_ad_scroll_view]                              = FindScene.initAdScrollView;
    [FindScene.s_cmds.init_recently_player_view]                        = FindScene.initRecentlyPlayerView;
    [FindScene.s_cmds.add_friend_response]                              = FindScene.onFriendsAddFriendResponse;
    [FindScene.s_cmds.wulin_booth_recommend_response]                   = FindScene.initWulinBoothRecommendView;
    [FindScene.s_cmds.add_endgate]                                      = FindScene.addEndgate;
    [FindScene.s_cmds.save_mychess]                                     = FindScene.onSaveMychessCallBack;
    
}