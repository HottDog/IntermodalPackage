--GiftModuleItem.lua
--Date 2016.7.28
--礼物item
--endregion

GiftModuleItem = class(Node);

GiftModuleItem.gridDiff = 40;
GiftModuleItem.s_gridDiff = 14;
GiftModuleItem.bottom_gridDiff = 12;

GiftModuleItem.s_itemImg = {
    [16] = "mall/lips.png",
    [17] = "mall/egg.png",
    [18] = "mall/flower.png",
    [19] = "mall/vip_card.png",
}

GiftModuleItem.s_style = 
{
    {
        w = 100, bg_w = 80,btn_h = 26,item_w = 60,
    },
    {
        w = 160, bg_w = 120,btm_h = 40,item_w = 90,
    }

}

GiftModuleItem.s_mode_user = 1
GiftModuleItem.s_mode_gift = 2
GiftModuleItem.s_mode_other = 3

--[Comment]
--礼物item
--data:礼物数据  mode:礼物模式  sizeMode:礼物item大小模式  handler:引用
function GiftModuleItem.ctor(self,data,mode,sizeMode,handler)
    self.m_data = data;
    self.mode = mode
    self.handler = handler;
    local sizeStyle = GiftModuleItem.s_style[sizeMode]
    if not data then return  end
    self:setSize(sizeStyle.w,sizeStyle.w);

    local gridDiff = GiftModuleItem.gridDiff;
    self.m_bg = new(Image,"common/background/prop_lbg.png",nil,nil,gridDiff,gridDiff,gridDiff,gridDiff);
    self.m_bg:setSize(sizeStyle.bg_w ,sizeStyle.bg_w);
    self.m_bg:setAlign(kAlignCenter);
    self:addChild(self.m_bg);

    local lr_gridDiff = GiftModuleItem.gridDiff;
    local tb_gridDiff = GiftModuleItem.bottom_gridDiff;
    self.m_bottom_bg = new(Image,"common/background/prop_sbg.png",nil,nil,lr_gridDiff,lr_gridDiff,tb_gridDiff,tb_gridDiff);
    self.m_bottom_bg:setSize(sizeStyle.bg_w,sizeStyle.btm_h);
    self.m_bottom_bg:setAlign(kAlignBottom);
    self.m_bg:addChild(self.m_bottom_bg)

    --根据类型选择图片
    local imgSrc = data.imgurl or "mall/flower"
    self.m_item_img = new(Image,imgSrc .. ".png");
    self.m_item_img:setAlign(kAlignTop);
    self.m_item_img:setSize(sizeStyle.item_w,sizeStyle.item_w)
    self.m_item_img:setPos(2,-2);
    self.m_bg:addChild(self.m_item_img)

    --数量
    local numText = "0";
    if self.mode == GiftModuleItem.s_mode_user then
        local price = UserInfo.getInstance():getGiftNum(data.cate_id);
        numText = price or "0";
    elseif self.mode == GiftModuleItem.s_mode_gift then
        self.exchange_price = data.exchange_num or 0
        numText = self.exchange_price .. "金币"
    end
    self.m_num_text = new(Text,numText,nil,nil,kAlignCenter,nil,22,240,200,160);
    self.m_num_text:setAlign(kAlignCenter);
    self.m_bottom_bg:addChild(self.m_num_text)
    
    --透明按钮
    if self.mode == GiftModuleItem.s_mode_gift then
        self.m_button = new(Button,"drawable/blank.png","drawable/transparent_blank.png");
        self.m_button:setSize(sizeStyle.bg_w,sizeStyle.bg_w);
        self.m_button:setAlign(kAlignCenter);
        self:addChild(self.m_button)
        self.m_button:setOnClick(self,self.onSendGift);
        self.m_button:setSrollOnClick()
    end

    local vipImg = new(Image,"vip/vip_item_bg.png")
    vipImg:setSize(sizeStyle.bg_w + 25,sizeStyle.bg_w + 25);
    vipImg:setAlign(kAlignCenter);
    vipImg:setPos(-8,-11)
    if data.cate_id == 19 and self.mode == 2 then
        self:addChild(vipImg);
        if UserInfo.getInstance():getIsVip() == 1 then
            self.can_use_vip = true
        else
            self.can_use_vip = false
        end
    end

end

function GiftModuleItem.dtor(self)
    GiftModuleController.releaseInstance()
end

--[Comment]
--发送礼物
function GiftModuleItem.onSendGift(self)
    local num = 1;
    local times = nil
    if self.handler then
        times = self.handler:getTimes();
    end
    if not times then
        num = 1
    elseif times == 1 then
        num = 10
    elseif times == 2 then
        num = 100
    end

    if self.m_data.cate_id == 19 and not self.can_use_vip then
        ChessToastManager.getInstance():showSingle("成为会员即可使用该礼物！");
        return
    end

    local giftMoney = num * tonumber(self.exchange_price)
    local ret = self:canSendgift(giftMoney)
    if not ret then return end

    local params = {};
    params.gift_type  = self.m_data.cate_id;
    params.gift_count = num;
    GiftModuleController.getInstance():onSendGift(params);
end

--[Comment]
--更新礼物数量
function GiftModuleItem.onUpdate(self,data)
    self.m_num_text:setText(data or 0)
end

--[Comment]
--判断是否可以发送礼物
--giftMoney: 发送礼物消耗的金币
--返回： true可以发送礼物 false不能发送礼物
function GiftModuleItem.canSendgift(self,giftMoney)
    -- 是否可以发送礼物道具
    local miniMoney = 0;
    local roomType = RoomProxy.getInstance():getCurRoomType();

    if roomType and roomType ~= 6 then
        local money = 200 --底注
        local rent = 100 --台费
        local roomConfig = RoomConfig.getInstance():getRoomTypeConfig(roomType);
        local multiple =  RoomProxy.getInstance():getCurRoomMultiple();
        if roomConfig and roomConfig.money then
            money = tonumber(roomConfig.money) --底注
        end
        if roomConfig and roomConfig.rent then
            rent = tonumber(roomConfig.rent) --台费
        end
        miniMoney = multiple * money + rent
    end

    miniMoney = UserInfo.getInstance():getMoney() - miniMoney
    if miniMoney <= 2000 or (miniMoney - giftMoney) <= 0 then
        ChessToastManager.getInstance():showSingle("金币过低，无法发送互动礼物")
        return false
    end
    return true
end
