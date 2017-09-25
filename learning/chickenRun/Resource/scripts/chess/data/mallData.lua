MallData = class();

MallData.s_mallType = {
    shop = 0;
    prop = 1;
}


MallData.getInstance = function()
    if not MallData.instance then
        MallData.instance = new(MallData);
    end
    return MallData.instance;
end

MallData.setMallType = function(self,mallType)
    self.m_mallType = mallType;
end

MallData.getMallType = function(self)
    return self.m_mallType or MallData.s_mallType.shop;
end

MallData.setMallData = function(self,data)
    self.m_mallData = data;
end

MallData.getMallData = function(self)
    return self.m_mallData;
end

MallData.setMallPropData = function(self,data)
    self.m_propData = data;
end

MallData.getMallPropData = function(self)
    return self.m_propData;
end

function MallData.setGiftList(self,data)
    self.m_giftProp = data;
end

function MallData.getGiftList(self)
    return self.m_giftProp;
end
------------------------- shop -------------------------

MallData.getShopData = function(self)
    if not self.m_shopData then
        self:sendGetShopInfo();
    end
    local MallGoods_List = GameCacheData.MALL_GOODS_LIST;
	if PhpConfig.getBid() then
		MallGoods_List = MallGoods_List..PhpConfig.getBid();
	end
    local ret,errMessage = pcall(
        function() -- 捕捉到异常后把数据清理
	        local ret = GameCacheData.getInstance():getString(MallGoods_List,nil);
            shopData = self:safeShopData(json.decode(ret));
            self:setMallData(shopData);
            return shopData;
        end
    );
    if ret then
        self.m_shopData = errMessage;
        return errMessage;
    else
        local MallShop_Version = GameCacheData.Mall_SHOP_VERSION;
        if PhpConfig.getBid() then
	        MallShop_Version = MallShop_Version..PhpConfig.getBid();
        end
        GameCacheData.getInstance():saveInt(MallShop_Version,0);
        self.m_shopData = nil;
        self:sendGetShopInfo();
        return nil;
    end
end

MallData.sendGetShopInfo = function(self,isNeedTips)
    isNeedTips = isNeedTips == nil or isNeedTips;
    local tips = "正在获取商品信息...";
	local post_data = {};

	local MallShop_Version = GameCacheData.Mall_SHOP_VERSION;
	if PhpConfig.getBid() then
		MallShop_Version = MallShop_Version..PhpConfig.getBid();
	end

	local version = GameCacheData.getInstance():getInt(MallShop_Version,0);
	post_data.version = 0--version;
	post_data.mid = UserInfo.getInstance():getUid();
    if isNeedTips then
        HttpModule.getInstance():execute(HttpModule.s_cmds.getShopInfo,post_data,tips);
    else
        HttpModule.getInstance():execute(HttpModule.s_cmds.getShopInfo,post_data);
    end
end

function MallData:getPayRecommend()
    return self.mPayRecommend
end

function MallData:getGoodsById(searchId)
    searchId = tonumber(searchId) or 0
    if self.m_shopData then
        for _,goods in pairs(self.m_shopData) do
            if tonumber(goods.goods_id) == searchId then
                return goods
            end
        end
    end
    return nil
end

MallData.explainShopData = function(self,message)
    local data = message.data;
	local version = message.version:get_value();
    local status = message.status:get_value();
    local enable_goods = message.enable_goods;

    if not message.enable_goods:get_value() then
        enable_goods = {}
    end

    local showList = {};
    for _,value in pairs(enable_goods) do 
        local enableGoods = {};
        enableGoods.id = tonumber(value:get_value()) or 0;
        table.insert(showList,enableGoods);
    end

    if message.pay_recommend:get_value() then
        local payRecommend = json.analyzeJsonNode(message.pay_recommend)
        self.mPayRecommend = {}
        self.mPayRecommend.enterRoom = {}
        if type(payRecommend.enter_room) == "table" then
            for key,val in pairs(payRecommend.enter_room) do
                if kPlatform == kPlatformIOS then
                    self.mPayRecommend.enterRoom[tonumber(key)] = val.ios or 0
                else
                    self.mPayRecommend.enterRoom[tonumber(key)] = val.android or 0
                end
            end
        end
        self.mPayRecommend.buyProp = 0
        if type(payRecommend.buy_prop) == "table" then
            if kPlatform == kPlatformIOS then
                self.mPayRecommend.buyProp = payRecommend.buy_prop.ios or 0
            else
                self.mPayRecommend.buyProp = payRecommend.buy_prop.android or 0
            end
        end
    end

    if tonumber(status) == 0 then
        local MallGoods_List = GameCacheData.MALL_GOODS_LIST;
		if PhpConfig.getBid() then
			MallGoods_List = MallGoods_List..PhpConfig.getBid();
		end
		local ret = GameCacheData.getInstance():getString(MallGoods_List,nil);
        self.m_shopData = self:safeShopData(json.decode(ret));
        local tempData = {};
        for _,v in pairs(self.m_shopData) do
            for _,m in pairs(showList) do
                if m.id == v.goods_id then
                     table.insert(tempData,v);
                end
            end
        end
        self:setMallData(tempData);
        return tempData;
    end

	local MallShop_Version = GameCacheData.Mall_SHOP_VERSION;
	if PhpConfig.getBid() then
		MallShop_Version = MallShop_Version..PhpConfig.getBid();
	end

	GameCacheData.getInstance():saveInt(MallShop_Version,version);

	if not data then
		print_string("not data");
		return;
	end

	if #data <= 0 then
		print_string("not datas");
		return;
	end

    data = json.analyzeJsonNode(data)

	if data then
		local MallGoods_List = GameCacheData.MALL_GOODS_LIST;
		if PhpConfig.getBid() then
			MallGoods_List = MallGoods_List..PhpConfig.getBid();
		end
		GameCacheData.getInstance():saveString(MallGoods_List,json.encode(data));
	end

    local list = self:safeShopData(data)
    local tempData = {}; 
	for _,value in pairs(list) do 
        if value.isShow == 1 then
            for _,v in pairs(showList) do
                if value.goods_id == v.id then
		            table.insert(tempData,value);
                end
            end
		end
	end
    self.m_shopData = list
    self:setMallData(tempData);
    return tempData;
end

function MallData:safeShopData(datas)
    if type(datas) ~= "table" then return nil end

    local list  = {}
	for _,value in pairs(datas) do 
		local goods = {};
		goods.id       		= tonumber(value.id) or 0;
		goods.name     		= value.name;
		goods.money    		= tonumber(value.money) or 0;
		goods.paysid   		= tonumber(value.paysid) or 0;
		goods.appid    		= tonumber(value.appid) or 0;
		goods.pmode         = tonumber(value.pmode) or 0;
		goods.type     		= tonumber(value.type) or 0;
		goods.label    		= tonumber(value.label) or 0;
		goods.originmoney   = tonumber(value.originmoney) or 0;
		goods.imgurl        = value.imgurl or "";
		goods.desc          = value.desc or "";
		goods.price         = tonumber(value.price) or 0;
		goods.modelist 		= value.modelist or "";
		if kPlatform == kPlatformIOS then
		    goods.identifier    = value.ios_goods_id or "";
		else
		    goods.identifier    = value.identifier or "";
		end;
        goods.payType       = tonumber(value.paytype) or 1;-- 1 rwb 购买 (2 元宝兑换) 2 vip购买
        goods.isShow        = tonumber(value.is_show) or 0;
        goods.goods_id      = tonumber(value.goods_id) or 0;
        goods.cate_id       = tonumber(value.cate_id) or 0;
        goods.short_desc    = value.short_desc or ""
        table.insert(list,goods);
	end
    return list
end
----------------------------- prop --------------------

MallData.getPropData = function(self)
    if not self.m_propData then
        self:sendGetPropList();
    end
    local Prop_List = GameCacheData.PROP_LIST;
	if PhpConfig.getBid() then
		Prop_List = Prop_List..PhpConfig.getBid();
	end
    local ret,errMessage = pcall(
        function() -- 捕捉到异常后把数据清理
	        local ret = GameCacheData.getInstance():getString(Prop_List,nil)
            propData = self:safePropData(json.decode(ret))
            self:setMallPropData(propData);
            return propData;
        end
    );
    if ret then
        self.m_propData = errMessage;
        return errMessage;
    else
        local Prop_Version = GameCacheData.PROP_LIST_VERSION;
	    if PhpConfig.getBid() then
		    Prop_Version = Prop_Version..PhpConfig.getBid();
	    end
	    GameCacheData.getInstance():saveInt(Prop_Version,0);
        self.m_propData = nil;
        self:sendGetPropList();
        return nil;
    end
end

MallData.sendGetPropList = function(self,isNeedTips)
    isNeedTips = isNeedTips == nil or isNeedTips;
    local tips = "正在获取道具...";

	local post_data = {};

	local Prop_Version = GameCacheData.PROP_LIST_VERSION;
	if PhpConfig.getBid() then
		Prop_Version = Prop_Version..PhpConfig.getBid();
	end

	local version = GameCacheData.getInstance():getInt(Prop_Version,0);
	post_data.version = version;
    if isNeedTips then
        HttpModule.getInstance():execute(HttpModule.s_cmds.getPropList,post_data,tips);
    else
        HttpModule.getInstance():execute(HttpModule.s_cmds.getPropList,post_data);
    end
end


MallData.explainPropData = function(self,message)
    local data = message.data;
	local version =message.version:get_value();
    
    local status = message.status:get_value();

    if status == 0 then
        local Prop_List = GameCacheData.PROP_LIST;
		if PhpConfig.getBid() then
			Prop_List = Prop_List..PhpConfig.getBid();
		end
		local ret = GameCacheData.getInstance():getString(Prop_List,nil);
        self.m_propData = self:safePropData(json.decode(ret))
        self:setMallPropData(self.m_propData);
        return self.m_propData;
    end

	local Prop_Version = GameCacheData.PROP_LIST_VERSION;
	if PhpConfig.getBid() then
		Prop_Version = Prop_Version..PhpConfig.getBid();
	end

	
	if not data then
		print_string("not data");
		return
	end

    
	if #data <= 0 then
		print_string("not data");
		return
	end
    
    data = json.analyzeJsonNode(data)

	GameCacheData.getInstance():saveInt(Prop_Version,version);
	local Prop_List = GameCacheData.PROP_LIST;
	if PhpConfig.getBid() then
		Prop_List = Prop_List..PhpConfig.getBid();
	end

	GameCacheData.getInstance():saveString(Prop_List,json.encode(data));

    self.m_propData = self:safePropData(data)
    self:setMallPropData(self.m_propData);
    return self.m_propData;
end

function MallData:safePropData(datas)
    if type(datas) ~= "table" then return nil end

    local list  = {}
    local giftList = {}
	for _,value in pairs(datas) do 
		local goods = {};
		goods.id       		= tonumber(value.id) or 0;
		goods.goods_type    = tonumber(value.goods_type) or 0;  --道具类型
        goods.goods_num     = tonumber(value.goods_num) or 0;
		goods.name     		= value.name or "";
        goods.exchange_type = tonumber(value.exchange_type) or 0;
        goods.exchange_num  = tonumber(value.exchange_num) or 0;
		goods.imgurl        = value.imgurl or "";
		goods.desc          = value.desc or "";
        goods.show          = tonumber(value.show) or 0;
        goods.cate_id       = tonumber(value.cate_id) or 0;
        goods.daylimit      = tonumber(value.daylimit) or 0;
        goods.short_desc    = value.short_desc or ""
        goods.stock_num     = tonumber(value.stock_num) or 0;
		goods.is_promote    = tonumber(value.is_promote) or 0;
		goods.is_hot    	= tonumber(value.is_hot) or 0;
        goods.pid           = tonumber(value.pid) or 0;
        if goods.goods_type ~= 1 and goods.goods_type ~= 5 then 
            table.insert(list,goods);
        end
        if goods.pid == 105 then
            table.insert(giftList,goods);
        end
	end

    self:setGiftList(giftList);

    return list
end
