require(BASE_PATH.."chessScene");

MallScene = class(ChessScene);
if kPlatform == kPlatformIOS then
    MallScene.s_controls = 
    {
        mall_back_btn = 1;
        mall_type_toggle_view = 2;
        mall_shop_placehold = 3;
        mall_prop_placehold = 4;
        -- ios走元宝
        mall_userinfo_bccoin = 5;
        mall_userinfo_money = 6;
        mall_content_view = 7;
        mall_title_view   = 8;
        mall_userinfo_score_view = 9;
        mall_userinfo_soul = 10;
    }
else
    MallScene.s_controls = 
    {
        mall_back_btn = 1;
        mall_type_toggle_view = 2;
        mall_shop_placehold = 3;
        mall_prop_placehold = 4;
        mall_userinfo_score = 5;
        mall_userinfo_money = 6;
        mall_content_view = 7;
        mall_userinfo_soul = 8;
    }
end;

MallScene.s_cmds = 
{
    updateView     = 1;
    updateShopList = 2;
    updatePropList = 3;
    showTipsDlg    = 4;
}

MallScene.ctor = function(self,viewConfig,controller)
	self.m_ctrls = MallScene.s_controls;
    self:create();
end 
MallScene.resume = function(self)
    ChessScene.resume(self);
    self:updateView();    
    BottomMenu.getInstance():onResume(self.m_bottom_menu);
    BottomMenu.getInstance():setHandler(self,BottomMenu.MALLTYPE);
end;


MallScene.pause = function(self)
	ChessScene.pause(self);
    BottomMenu.getInstance():onPause();
end 


MallScene.dtor = function(self)
    delete(self.m_anim_start);
    delete(self.m_anim_end);
end 

----------------------------------- function ----------------------------
MallScene.create = function(self)  
    self.hasPlayListAnim = false;

    self.m_mall_content_view = self:findViewById(self.m_ctrls.mall_content_view);
    self.m_left_leaf = self.m_root:getChildByName("Image6");
    self.m_right_leaf = self.m_root:getChildByName("Image7");
    self.m_assets_bg = self.m_root:getChildByName("assets_btn_bg");
    self.m_assets_bg:setVisible(false);
    self.m_assets_btn = self.m_root:getChildByName("assets_btn_bg"):getChildByName("assets_btn");
    self.m_assets_btn:setOnClick(self,function()
            StateMachine.getInstance():pushState(States.assetsModel,StateMachine.STYPE_CUSTOM_WAIT);
        end);
    local w,h = self:getSize();
    local cw,ch = self.m_mall_content_view:getSize();
    self.m_mall_content_view:setSize(nil,ch+h-System.getLayoutHeight());

    self.m_mall_shop_placehold = self:findViewById(self.m_ctrls.mall_shop_placehold);
    self.m_mall_prop_placehold = self:findViewById(self.m_ctrls.mall_prop_placehold);
    if kPlatform == kPlatformIOS then
        --ios审核关闭元宝相关
        self.m_mall_userinfo_score_view = self:findViewById(self.m_ctrls.mall_userinfo_score_view);
        if tonumber(UserInfo.getInstance():getIosAuditStatus()) ~= 0 then
            self.m_mall_userinfo_score_view:setVisible(true);
            self.m_assets_bg:setVisible(true);
            PayDialog.ITEMS[1].title = "AppStore";
        else
            self.m_mall_userinfo_score_view:setVisible(false);
            self.m_assets_bg:setVisible(false);
            PayDialog.ITEMS[1].title = "确定";
        end;
        self.m_score_tips = self.m_mall_userinfo_score_view:getChildByName("mall_userinfo_score_tips");
        self.m_score_tips:setText("元宝:");
    	self.m_mall_userinfo_money = self:findViewById(self.m_ctrls.mall_userinfo_money);
    	self.m_mall_userinfo_bccoin = self:findViewById(self.m_ctrls.mall_userinfo_bccoin);
    	self.m_mall_userinfo_soul = self:findViewById(self.m_ctrls.mall_userinfo_soul);
        self.m_mall_userinfo_money:setPos(155,0);
        self.m_mall_userinfo_bccoin:setPos(-285,0);
        self.m_mall_userinfo_soul:setPos(-64,0);
        self.m_mall_userinfo_bccoin:setVisible(true);    
    else
    	self.m_mall_userinfo_money = self:findViewById(self.m_ctrls.mall_userinfo_money);
    	self.m_mall_userinfo_score = self:findViewById(self.m_ctrls.mall_userinfo_score);
    	self.m_mall_userinfo_soul = self:findViewById(self.m_ctrls.mall_userinfo_soul);
        self.m_mall_userinfo_money:setPos(75,0);
        self.m_mall_userinfo_soul:setPos(-194,0);
        
        self.m_mall_userinfo_score:setVisible(false);    
        self.m_assets_bg:setVisible(true);
    end;


    self.m_mall_back_btn = self:findViewById(self.m_ctrls.mall_back_btn);
    self.m_mall_type_toggle_view = self:findViewById(self.m_ctrls.mall_type_toggle_view);

    self.m_shop_select_btn = new(RadioButton,{"mall/money.png","mall/money_chose.png"});
	self.m_prop_select_btn = new(RadioButton,{"mall/prop.png","mall/prop_chose.png"});
    self.m_shop_select_btn:setAlign(kAlignLeft);
    self.m_prop_select_btn:setAlign(kAlignRight);
--    self.m_shop_select_btn_icon = new(Images,{"mall/coin_toggle_off.png","mall/coin_toggle_on.png",});
--    self.m_prop_select_btn_icon = new(Images,{"mall/prop_toggle_off.png","mall/prop_toggle_on.png",});
--    self.m_shop_select_btn:addChild(self.m_shop_select_btn_icon);
--    self.m_prop_select_btn:addChild(self.m_prop_select_btn_icon);

    self.m_mall_type_toggle_view:addChild(self.m_prop_select_btn);
    self.m_mall_type_toggle_view:addChild(self.m_shop_select_btn);


    self.m_mall_type_toggle_view:setOnChange(self,self.updataSelectState);

    if MallData.getInstance():getMallType() == MallData.s_mallType.prop then
        self.m_prop_select_btn:setChecked(true);
    else
        self.m_shop_select_btn:setChecked(true);
    end
    self:updataSelectState();

    MallScene.tip_bg = new(Image, "common/background/tips_bg_2.png", nil, nil, 80, 48, 30, 60);
    MallScene.tip_bg:setSize(400,200);
    MallScene.tip_bg:setAlign(kAlignTop);
    MallScene.tip_bg:setVisible(false);
    self.m_mall_content_view:addChild(MallScene.tip_bg);

    self.m_bottom_menu = self.m_root:getChildByName("bottom_menu");
end

MallScene.setAnimItemEnVisible = function(self,ret)
    self.m_left_leaf:setVisible(ret);
    self.m_right_leaf:setVisible(ret);
end

MallScene.removeAnimProp = function(self)
    self.m_left_leaf:removeProp(1);
    self.m_right_leaf:removeProp(1);
    self.m_mall_type_toggle_view:removeProp(1);
    self.m_mall_type_toggle_view:removeProp(2); 
end

function MallScene.removeListItemProp(self,list)
    if not list or next(list) == nil then return end
    for k,v in pairs(list) do
        if v then
            if not v:checkAddProp(1) then
                v:removeProp(1);
            end
            if not v:checkAddProp(2) then
                v:removeProp(2);
            end
        end
    end
end

MallScene.resumeAnimStart = function(self,lastStateObj,timer)

    self.m_anim_prop_need_remove = true;
    self:removeAnimProp();
    BottomMenu.getInstance():hideView(true);
    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(lastStateObj.state) then
        if not BottomMenu.getInstance():checkStateSort(States.Mall,lastStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,-w,0,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,w,0,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(0,timer);
    end

    self:setAnimItemEnVisible(false);
    local duration = timer.duration;
    local waitTime = timer.waitTime;
    local delay = waitTime+duration;
    self.waitTime = timer.waitTime
    self.delay = timer.waitTime
--    local w,h = self:getSize();
--    self.m_root:addPropTranslate(1,kAnimNormal,duration,waitTime,w,0,nil,nil);
    delete(self.m_anim_start);
    self.m_anim_start = new(AnimInt,kAnimNormal,0,1,delay,-1);
    if self.m_anim_start then
        self.m_anim_start:setEvent(self,function()
            self:setAnimItemEnVisible(true);
            delete(self.m_anim_start);
        end);
    end

    self.m_mall_type_toggle_view:addPropTransparency(2,kAnimNormal,waitTime,delay,0,1);
    self.m_mall_type_toggle_view:addPropScale(1,kAnimNormal,waitTime,delay,0.8,1,0.6,1,kCenterXY,150,40);
    local lw,lh = self.m_left_leaf:getSize();
    self.m_left_leaf:addPropTranslate(1,kAnimNormal,waitTime,delay,-lw,0,-10,0);
    local rw,rh = self.m_right_leaf:getSize();
    local anim = self.m_right_leaf:addPropTranslate(1,kAnimNormal,waitTime,delay,rw,0,-10,0);
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

MallScene.pauseAnimStart = function(self,newStateObj,timer)
    self.m_anim_prop_need_remove = true;
    self:removeAnimProp();

    local w,h = self:getSize();
    if BottomMenu.getInstance():checkState(newStateObj.state) then
        if BottomMenu.getInstance():checkStateSort(States.Mall,newStateObj.state) then
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,w,nil,nil);
        else
            self.m_root:removeProp(1);
            self.m_root:addPropTranslate(1,kAnimNormal,timer.duration,timer.waitTime,0,-w,nil,nil);
        end
    else
        BottomMenu.getInstance():removeOutWindow(1,timer);
    end

    local duration = timer.duration;
    local waitTime = timer.waitTime
    local delay = waitTime+duration;

--    local w,h = self:getSize();
--    local anim_end = self.m_root:addPropTranslate(1,kAnimNormal,duration,waitTime,0,w,nil,nil);
    delete(self.m_anim_end);
    self.m_anim_end = new(AnimInt,kAnimNormal,0,1,delay,-1);
    if self.m_anim_end then
        self.m_anim_end:setEvent(self,function()
            self.m_anim_prop_need_remove = true;
            self:removeAnimProp();
            if not self.m_root:checkAddProp(1) then 
		        self.m_root:removeProp(1);
	        end
            delete(self.m_anim_end);
        end);
    end

    local lw,lh = self.m_left_leaf:getSize();
    self.m_left_leaf:addPropTranslate(1,kAnimNormal,waitTime,-1,0,-lw,0,-10);
    local rw,rh = self.m_right_leaf:getSize();
    local anim = self.m_right_leaf:addPropTranslate(1,kAnimNormal,waitTime,-1,0,rw,0,-10);
    if anim then
        anim:setEvent(self,function()
            self:setAnimItemEnVisible(false);
        end);
    end
end

MallScene.onBack = function(self)
    self:requestCtrlCmd(MallController.s_cmds.onBack);
end


MallScene.updataSelectState = function(self)
    if self.m_shop_select_btn:isChecked() then
        self.m_mall_shop_placehold:setVisible(true);
        if not self.m_shop_mall_adapter then
            self:requestCtrlCmd(MallController.s_cmds.getShopInfo);
        end
    else
        self.m_mall_shop_placehold:setVisible(false);
    end
    
    if self.m_prop_select_btn:isChecked() then
        self.m_mall_prop_placehold:setVisible(true);
        if not self.m_prop_Mall_adapter then
            self:requestCtrlCmd(MallController.s_cmds.getPropList);
            return
        end
        if not self.hasPlayListAnim then
            self.hasPlayListAnim = true
            self:onPlayListAnim(self.m_prop_mall_list);
        end
    else
        self.m_mall_prop_placehold:setVisible(false);
    end
end

MallScene.updateView = function(self)
	self.m_mall_userinfo_money:getChildByName("num"):setText(UserInfo.getInstance():getMoneyStr());
	if kPlatform == kPlatformIOS then
	    self.m_mall_userinfo_bccoin:getChildByName("num"):setText(UserInfo.getInstance():getBccoin());
	else
	    self.m_mall_userinfo_score:getChildByName("num"):setText(UserInfo.getInstance():getScore());
	end
    self.m_mall_userinfo_soul:getChildByName("num"):setText(UserInfo.getInstance():getSoulCount());
end

MallScene.updateShopList = function(self,data)    
    if not data or (type(data) == "table" and #data == 0) then 
        return ;
    end

	self.m_shop_mall_adapter = new(CacheAdapter,MallShopItem,data);
	local w,h = self.m_mall_shop_placehold:getSize();
    delete(self.m_shop_mall_list);
	self.m_shop_mall_list = new(ListView,0,0,w,h);
    self.m_shop_mall_list:setAdapter(self.m_shop_mall_adapter);
	self.m_mall_shop_placehold:addChild(self.m_shop_mall_list);
	self.m_shop_mall_list:setOnItemClick(self,self.mallOnShopListItemClick);

    if self.m_shop_select_btn:isChecked() then
        self:onPlayListAnim(self.m_shop_mall_list);
    end
end

MallScene.mallOnShopListItemClick = function(self,adapter,view,index)
	print_string("Online.setMallOnListItemClick index = " .. index);
 	local data  = view:getData();

 	if data==nil or ( view.isPay and not view:isPay() )then
 		return;
 	end

 	if data then
        if data.payType and data.payType == 2 then 
            MallScene.m_PayInterface = PayUtil.getPayInstance(PayUtil.s_payType.Exchange);
		    data.position = MALL_COINS_GOODS;
		    MallScene.m_pay_dialog = MallScene.m_PayInterface:buy(data,MALL_COINS_GOODS);
        else
            MallScene.m_PayInterface = PayUtil.getPayInstance(PayUtil.s_defaultType);
		    data.position = MALL_COINS_GOODS;
		    MallScene.m_pay_dialog = MallScene.m_PayInterface:buy(data,MALL_COINS_GOODS);
        end
	end
end


MallScene.updatePropList = function(self,data)
    if not data then 
        return ;
    end

    local pdata = {};
    for i,v in pairs(data) do
        if v.show == 1 then
            pdata[#pdata+1] = v;
        end
    end

    if #pdata == 0 then return end ;

	self.m_prop_Mall_adapter = new(CacheAdapter,MallPropItem,pdata);
	local w,h = self.m_mall_prop_placehold:getSize();
    delete(self.m_prop_mall_list);
	self.m_prop_mall_list = new(ListView,0,0,w,h);
    self.m_prop_mall_list:setAdapter(self.m_prop_Mall_adapter);
	self.m_mall_prop_placehold:addChild(self.m_prop_mall_list);
	self.m_prop_mall_list:setOnItemClick(self,self.mallOnPropListItemClick);

end

MallScene.mallOnPropListItemClick = function(self,adapter,view,index)
    local data  = view:getData();
    
 	if data==nil or ( view.isPay and not view:isPay() )then
 		return;
 	end

 	if data then
        if data.goods_type == 12 then
            local soulcount = tonumber(UserInfo.getInstance():getSoulCount());
            if data.exchange_num and tonumber(data.exchange_num) > soulcount then --data.exchangeNum > soulcount
                local msg = "很抱歉，您的棋魂不足以兑换该奖品，玩游戏有几率获得棋魂，赶紧去赚取吧！";
                local title = "兑换失败";	
                EventDispatcher.getInstance():dispatch(Event.Call, SOUL_NOT_ENOUGH_FOR_COST,title,msg);
                return;
            end
        end
        MallScene.m_PayInterface = PayUtil.getPayInstance(PayUtil.s_payType.Exchange);
		data.position = data.id;
		MallScene.m_pay_dialog = MallScene.m_PayInterface:buy(data,data.position);
	end
end

require("dialog/exchange_tips_dialog");
MallScene.showTipsDlg = function(self,title,tips)
	if not self.m_exchange_tips_dialog then
		self.m_exchange_tips_dialog = new(ExchangeTipsDialog,title,tips);
	end
	self.m_exchange_tips_dialog:show(title,tips);
end

function MallScene.onPlayListAnim(self,list)
    if not list then return end
    local listTab = list:getChildren();
    local itemDelay = 0;
    if next(listTab) ~= nil then
        for k,v in pairs(listTab) do
            v:addPropTransparency(2,kAnimNormal,self.waitTime-100,itemDelay,0,1);
            v:addPropScale(1,kAnimNormal,self.waitTime-100,itemDelay,0.8,1,0.8,1,kCenterXY,360,110)
            itemDelay = itemDelay + 100;
        end
    end

    if itemDelay == 0 then return end
    local anim = new(AnimInt, kAnimNormal,0,1, itemDelay, -1);
    if anim then
        anim:setEvent(self,function()
            self:removeListItemProp(listTab);
        end);
    end
end
----------------------------------- onClick ---------------------------------





----------------------------------- config ------------------------------
if kPlatform == kPlatformIOS then
    MallScene.s_controlConfig = 
    {
    	[MallScene.s_controls.mall_back_btn] = {"mall_back_btn"};
        [MallScene.s_controls.mall_title_view] = {"mall_title_view"};
        [MallScene.s_controls.mall_type_toggle_view] = {"mall_title_view","mall_type_toggle_view"};
        [MallScene.s_controls.mall_content_view] = {"mall_content_view"};
        [MallScene.s_controls.mall_shop_placehold] = {"mall_content_view","mall_shop_placehold"};
        [MallScene.s_controls.mall_prop_placehold] = {"mall_content_view","mall_prop_placehold"};
        [MallScene.s_controls.mall_userinfo_score_view] = {"mall_userinfo_view","mall_score_info_view"};
        [MallScene.s_controls.mall_userinfo_bccoin] = {"mall_userinfo_view","mall_score_info_view"};
        [MallScene.s_controls.mall_userinfo_money] = {"mall_userinfo_view","mall_money_info_view"};
        [MallScene.s_controls.mall_userinfo_soul] = {"mall_userinfo_view","mall_soul_info_view"};
    };
else
    MallScene.s_controlConfig = 
    {
    	[MallScene.s_controls.mall_back_btn] = {"mall_back_btn"};
        [MallScene.s_controls.mall_type_toggle_view] = {"mall_title_view","mall_type_toggle_view"};
        [MallScene.s_controls.mall_content_view] = {"mall_content_view"};
        [MallScene.s_controls.mall_shop_placehold] = {"mall_content_view","mall_shop_placehold"};
        [MallScene.s_controls.mall_prop_placehold] = {"mall_content_view","mall_prop_placehold"};
        [MallScene.s_controls.mall_userinfo_score] = {"mall_userinfo_view","mall_score_info_view"};
        [MallScene.s_controls.mall_userinfo_money] = {"mall_userinfo_view","mall_money_info_view"};
        [MallScene.s_controls.mall_userinfo_soul] = {"mall_userinfo_view","mall_soul_info_view"};
    };
end;

MallScene.s_controlFuncMap =
{
    [MallScene.s_controls.mall_back_btn] = MallScene.onBack;

};


MallScene.s_cmdConfig =
{
    [MallScene.s_cmds.updateView]     = MallScene.updateView;
    [MallScene.s_cmds.updateShopList] = MallScene.updateShopList;
    [MallScene.s_cmds.updatePropList] = MallScene.updatePropList;
    [MallScene.s_cmds.showTipsDlg]    = MallScene.showTipsDlg;
}




------------------------------------ private node -----------------------------

--商品信息的Item
MallShopItem = class(Node);
MallShopItem.ICON_PRE = "mall/";
require(VIEW_PATH.."mall_shop_item")
MallShopItem.ctor = function(self,goods)
    
	print_string("MallShopItem.ctor" .. goods.id);
	self.m_data = {};
	for key ,value  in pairs(goods) do
		self.m_data[key] = value;
	end

	self.mScene = SceneLoader.load(mall_shop_item)
    self.mScene:setAlign(kAlignTop)
    self:addChild(self.mScene)
    self:setPos(0,0)
    self:setSize(720,220)
    self.mScene:getChildByName("btn"):setOnTuchProcess(self,self.onTuchProcess)
    self.mPromotionIcon = self.mScene:getChildByName("promotion_icon")
    self.mHotIcon = self.mScene:getChildByName("hot_icon")
    self.mNameView = self.mScene:getChildByName("name_view")
    self.mPriceView = self.mScene:getChildByName("price_view")
    self.mIconView = self.mScene:getChildByName("icon_view")
    self.mDecsView = self.mScene:getChildByName("desc_view")
    self.m_isPay = true
    
    
	self.mNameText = new(Text, goods.name, 0, 0, nil,nil,36,80, 80, 80)
    self.mNameText:setAlign(kAlignLeft)
    self.mNameView:addChild(self.mNameText)

    
    --商品图片
	self.mGoodsIcon = new(Image,MallShopItem.ICON_PRE .. goods.imgurl .. ".png")
    self.mGoodsIcon:setAlign(kAlignCenter)
    self.mIconView:addChild(self.mGoodsIcon)

    
    self.mGoodsPriceIcon = new(Image,"common/icon/sale_icon.png");
	self.mGoodsPrice = new(Text, string.format("%d元",goods.price), 0, 0, kAlignLeft,nil,40,125, 80, 65)
    self.mGoodsPriceIcon:setAlign(kAlignRight)
    self.mGoodsPrice:setAlign(kAlignRight)

    local padingRigth = self.mGoodsPrice:getSize()
    self.mGoodsPriceIcon:setPos(padingRigth+5)
    

    self.mPriceView:addChild(self.mGoodsPriceIcon)
    self.mPriceView:addChild(self.mGoodsPrice)

    local w,h = self.mDecsView:getSize()
    self.mDecsText = new(TextView, goods.short_desc, w, 0, nil,nil,30,160,110,90)
    self.mDecsText:setPickable(false)
    self.mDecsView:addChild(self.mDecsText)
    
    self.mPromotionIcon:setVisible(false)
    self.mHotIcon:setVisible(false)
    if goods.label then
		if goods.label == 1 then --打折
            self.mPromotionIcon:setVisible(true)
		elseif goods.label == 2 then
            self.mHotIcon:setVisible(true)
		end
	end
end

MallShopItem.buyGoods = function(self)
	print_string("MallShopItem.buyGoods goods = " .. self.m_data.money);

	if self.m_data then
        if self.m_data.payType and self.m_data.payType == 2 then 
            Mall.m_PayInterface = PayUtil.getPayTypeObj(PayInterface.PROP_GOODS,Mall.obj);
		    self.m_data.position = MALL_COINS_GOODS
		    Mall.m_pay_dialog = Mall.m_PayInterface:buy(self.m_data,MALL_COINS_GOODS);
        else
            Mall.m_PayInterface = PayUtil.getPayTypeObj(PayInterface.COINS_GOODS,Mall.obj,true);
		    self.m_data.position = MALL_COINS_GOODS
		    Mall.m_pay_dialog = Mall.m_PayInterface:buy(self.m_data,MALL_COINS_GOODS);
        end
	end
end

MallShopItem.isPay = function(self)
    return self.m_isPay;
end

MallShopItem.onTuchProcess = function(self,enable)
    if self.m_data and self.m_data.desc and self.m_data.desc ~= "" then
        if not enable then
            local x,y = self:getAbsolutePos();
            MallScene.tip_bg:setPos(0,y-400); -- 220 的 自身高  220 的父类节点高
            MallScene.tip_bg:setVisible(true);
            Log.i("1111111111111");
            local anim = MallScene.tip_bg:addPropTransparency(1, kAnimNormal, 0, 1000, 0, 1);
            if anim then
                self.m_isPay = true;
                anim:setEvent(self,function(self)
                        Log.i("22222222222222");
                        self.m_isPay = false;
                        MallScene.tip_bg:removeAllChildren(true);
                        local w,h = MallScene.tip_bg:getSize();
                        node = new(Node);
                        node:setSize(w-40,h-50);
                        node:setPos(20,20);
                        node:setClip(20,20,w-40,h-50);
                        text = new(RichText, self.m_data.desc, w-40, h-50, kAlignTopLeft, nil, 32, 80, 80, 80, true,10);
                        node:addChild(text);
                        MallScene.tip_bg:addChild(node);
                        local tw,th = text:getSize();
                        if th > h then
                            local diff = th - h;
                            local anim = text:addPropTranslate(1, kAnimNormal, diff*30+1500, 1500, 0, 0, 0, -diff-h/2);
            --                anim:setEvent(text,function(self)
            --                    text:addPropTranslate(1, kAnimNormal, diff*1000/32, 4000, 0, 0, 0, -diff);
            --                end);
                        end
                    end);
            end
        else
            Log.i("333333333333");
            MallScene.tip_bg:removeAllChildren(true);
            MallScene.tip_bg:setVisible(false);
            MallScene.tip_bg:removeProp(1);
        end
    end
end

MallShopItem.getData = function(self)
	return self.m_data;
end

MallShopItem.dtor = function(self)
	
end	

------道具商品Item
require(VIEW_PATH .. "mall_prop_item")
MallPropItem = class(Node);
MallPropItem.ICON_PRE = "mall/";
MallPropItem.ctor = function(self,prop)
	self.data = prop;
    self:setPos(0,0);     --位置
    self:setSize(720,220);    --大
    self.m_isPay = true;

    self.mScene = SceneLoader.load(mall_prop_item)
    self.mScene:setAlign(kAlignTop)
    self:addChild(self.mScene)
    self:setPos(0,0)
    self:setSize(720,220)
    self.mScene:getChildByName("btn"):setOnTuchProcess(self,self.onTuchProcess)
    self.mPromotionIcon = self.mScene:getChildByName("promotion_icon")
    self.mHotIcon = self.mScene:getChildByName("hot_icon")
    self.mNameView = self.mScene:getChildByName("name_view")
    self.mPriceView = self.mScene:getChildByName("price_view")
    self.mIconView = self.mScene:getChildByName("icon_view")
    self.mDecsView = self.mScene:getChildByName("desc_view")
    self.m_isPay = true
    
    
	self.mNameText = new(Text, prop.name, 0, 0, nil,nil,36,80, 80, 80)
    self.mNameText:setAlign(kAlignLeft)
    self.mNameView:addChild(self.mNameText)

    
    --商品图片
	self.mGoodsIcon = new(Image,MallShopItem.ICON_PRE .. prop.imgurl .. ".png")
    self.mGoodsIcon:setAlign(kAlignCenter)
    self.mIconView:addChild(self.mGoodsIcon)

    
    self.mGoodsPriceIcon = new(Image,"mall/rechange.png");
    local priceStr = ""
    if prop.exchange_num then
        if prop.exchange_num >= 10000 then
            if prop.exchange_num % 10000 > 1000 then
                priceStr = string.format("%.1f万",prop.exchange_num/10000);
            else
                priceStr = string.format("%.0f万",prop.exchange_num/10000);
            end
        else
			priceStr = prop.exchange_num;
        end
	end
    if prop.exchange_type == 1 then
        priceStr = priceStr.."元宝";
    elseif prop.exchange_type == 4 then
        priceStr = priceStr.."棋魂";
    else
        priceStr = priceStr.."金币";
    end

	self.mGoodsPrice = new(Text, priceStr, 0, 0, kAlignLeft,nil,40,125, 80, 65)
    self.mGoodsPriceIcon:setAlign(kAlignRight)
    self.mGoodsPrice:setAlign(kAlignRight)

    local padingRigth = self.mGoodsPrice:getSize()
    self.mGoodsPriceIcon:setPos(padingRigth+5)
    
    self.mPriceView:addChild(self.mGoodsPriceIcon)
    self.mPriceView:addChild(self.mGoodsPrice)

    local w,h = self.mDecsView:getSize()
    self.mDecsText = new(TextView, prop.short_desc, w, 0, nil,nil,30,160,110,90)
    self.mDecsText:setPickable(false)
    self.mDecsView:addChild(self.mDecsText)
    
    self.mPromotionIcon:setVisible(false)
    self.mHotIcon:setVisible(false)
    
    if prop.is_promote and prop.is_promote == 1 then
        self.mPromotionIcon:setVisible(true)
	end
    if prop.is_hot and prop.is_hot == 1 then
        self.mHotIcon:setVisible(true)
	end
end

MallPropItem.onTuchProcess = function(self,enable)
    if self.data and self.data.desc and self.data.desc ~= "" then
        if not enable then
            local x,y = self:getAbsolutePos();
            MallScene.tip_bg:setPos(0,y-400); -- 220 的 自身高  220 的父类节点高
            MallScene.tip_bg:setVisible(true);
            Log.i("1111111111111");
            local anim = MallScene.tip_bg:addPropTransparency(1, kAnimNormal, 0, 1000, 0, 1);
            if anim then
                self.m_isPay = true;
                anim:setEvent(self,function(self)
                        Log.i("22222222222222");
                        self.m_isPay = false;
                        MallScene.tip_bg:removeAllChildren(true);
                        local w,h = MallScene.tip_bg:getSize();
                        node = new(Node);
                        node:setSize(w-40,h-50);
                        node:setPos(20,20);
                        node:setClip(20,20,w-40,h-50);
                        text = new(RichText, self.data.desc, w-40, h-50, kAlignTopLeft, nil, 32, 80, 80, 80, true,10);
                        node:addChild(text);
                        MallScene.tip_bg:addChild(node);
                        local tw,th = text:getSize();
                        if th > h then
                            local diff = th - h;
                            local anim = text:addPropTranslate(1, kAnimNormal, diff*30+1500, 1500, 0, 0, 0, -diff-h/2);
            --                anim:setEvent(text,function(self)
            --                    text:addPropTranslate(1, kAnimNormal, diff*1000/32, 4000, 0, 0, 0, -diff);
            --                end);
                        end
                    end);
            end
        else
            Log.i("333333333333");
            MallScene.tip_bg:removeAllChildren(true);
            MallScene.tip_bg:setVisible(false);
            MallScene.tip_bg:removeProp(1);
        end
    end
end

MallPropItem.addCoinGoodsItem = function(self,bgImg,data)
	self.data  = data;

	local leftImgStr = "mall/mall_list_gold3.png";
	local leftImg = new(Image,leftImgStr);
	leftImg:setPos(25,25); 								
	leftImg:setVisible(true);	
	bgImg:addChild(leftImg);

    local money = "66,000金币"
	local money_x,money_y = 180,40;
	local money_fontsize = 30;

	local moneyText = new(Text, money, 0, 0, nil,nil,money_fontsize,255, 255, 206);
	moneyText:setPos(money_x,money_y);
	bgImg:addChild(moneyText);

    local oldmoney = "60,000金币"
	local oldmoney_x,oldmoney_y = 180,70;
	local oldmoney_fontsize = 20;

	oldmoneyText = new(Text, oldmoney, 0, 0, nil,nil,oldmoney_fontsize,69,157,79);
	oldmoneyText:setPos(oldmoney_x,oldmoney_y);
	bgImg:addChild(oldmoneyText);
end


MallPropItem.addNomalMallPropItem = function(self,bgImg,data)

		local leftImgStr=nil;
		local propdescStr = nil;
        if data.imgurl and data.imgurl ~= "" then
            leftImgStr = "mall/"..data.imgurl..".png";
        else
    		local startNum = data.goods_type;
            if startNum == 1 then--生命回复
--			    leftImgStr = "drawable/ending_buy_life_full_texture.png";
			    self.data.position = MALL_LIFERECOVER;
			    propdescStr = "使用加满生命值（仅限残局挑战、单机游戏使用）。";
		    elseif startNum == 2 then --悔棋
			    leftImgStr = "mall/undo_icon.png";
			    self.data.position = MALL_UNDO;
			    propdescStr = "返回上一步（仅限残局挑战、单机游戏使用）。";
		    elseif startNum == 3 then --提示
			    leftImgStr = "mall/tips_icon.png";
			    self.data.position = MALL_TIPS;
			    propdescStr = "当前最准确走棋方式（仅限残局挑战使用）。";
		    elseif startNum == 4 then --起死回生
			    leftImgStr = "mall/relive_icon.png";
			    self.data.position = MALL_SAVELIFE;
			    propdescStr = "返回至出错的前一步，不消耗生命。（仅限残局挑战使用）。";
		    elseif startNum == 5 then --增加生命上限
--			    leftImgStr = "drawable/maximum_life_level_add3_icon.png";
			    self.data.position = MALL_LIFELEVEL;
			    propdescStr = "可以帮你增加生命值上限（仅限残局挑战、单机游戏使用）。";
            end
        end 

--        if data.desc then
--            propdescStr = data.desc;
--        end
	
		if leftImgStr then
			local leftImg = new(Image,leftImgStr);
			leftImg:setPos(40,-15); 								
			leftImg:setVisible(true);	
            leftImg:setAlign(kAlignLeft);
			bgImg:addChild(leftImg);
		end
        local propdesc_x,propdesc_y = 195,85;
        if data.goods_type == 14 or data.goods_type == 15 then
            propdescStr = string.format("有效期:%d天",data.daylimit)
        end

		if propdescStr then
			local propdesc_fontsize = 24;
			local propdescText = new(TextView, propdescStr, 400, 0, nil,nil,propdesc_fontsize,160, 110, 95);
            propdescText:setPickable(false);
			propdescText:setPos(propdesc_x,propdesc_y);
			bgImg:addChild(propdescText);
		end

        

	    local propNameStr = data.name
		local propName_x,propName_y = 195,35;
		local propName_fontsize = 36;

		local propNameText = new(Text, propNameStr, 0, 0, nil,nil,propName_fontsize,80, 80, 80);
		propNameText:setPos(propName_x,propName_y);
		bgImg:addChild(propNameText);

        local leftText = new(Text,"剩余：",nil,nil,nil,nil,30,80,80,80);
        local leftNum = new(Text,"",nil,nil,nil,nil,30,25,115,40);
        leftText:setPos(propdesc_x,propdesc_y+20);
        leftNum:setPos(propdesc_x + 80,propdesc_y+20);
        if data.goods_type == 12 then
            propNameText:setPos(nil,propName_y+18);
            leftNum:setText("" .. data.stock_num);
            leftNum:setVisible(true);
            leftText:setVisible(true);     
        else            
            leftNum:setVisible(false);
            leftText:setVisible(false);
        end
        bgImg:addChild(leftText);
        bgImg:addChild(leftNum);

   		local priceStr = ""
		if data.exchange_num then
            if data.exchange_num >= 10000 then
                if data.exchange_num % 10000 > 1000 then
                    priceStr = string.format("%.1f万",data.exchange_num/10000);
                else
                    priceStr = string.format("%.0f万",data.exchange_num/10000);
                end
            else
			    priceStr = data.exchange_num;
            end
		end

        local price_x,price_y = 90,30;
        if data.exchange_type == 1 then
            priceStr = priceStr.."元宝";
        elseif data.exchange_type == 4 then
            priceStr = priceStr.."棋魂";
            price_x = 80;
            price_y = 70;
        else
            priceStr = priceStr.."金币";
        end
        data.msg = string.format("是否用%s兑换%s?",priceStr,data.name);--兑换dialog要用的参数

		
		local price_fontsize = 40;

		local priceText = new(Text, priceStr, 0, 0, kAlignLeft,nil,price_fontsize,125, 80, 65);
		priceText:setPos(price_x + 350,price_y);
        priceText:setAlign(kAlignTopLeft);
		bgImg:addChild(priceText);

        local w,h = priceText:getSize();

        local icon = new(Image,"mall/rechange.png");
		icon:setPos(price_x+300,price_y+3);
        icon:setAlign(kAlignTopLeft);
		bgImg:addChild(icon);
end

MallPropItem.getData = function(self)
    return self.data;
end

MallPropItem.isPay = function(self)
    return self.m_isPay;
end

MallPropItem.dtor = function(self)
	
end