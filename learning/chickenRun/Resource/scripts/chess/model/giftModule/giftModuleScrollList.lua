--giftModuleScrollList.lua
--Date 2016.8.6
--礼物滑动列表
--endregion

require(MODEL_PATH .. "giftModule/giftModuleItem")
require(DATA_PATH .. "mallData");

GiftModuleScrollList = class(Node);

GiftModuleScrollList.s_ssize = 1
GiftModuleScrollList.s_lsize = 2

--[Comment]
--创建礼物列表
--w:宽  h:高  label:模式  handler:应用
function GiftModuleScrollList.ctor(self,w,h,label,handler)
    if not w then w = 390 end
    if not h then h = 100 end

    self:setSize(w,h);
    self.mode = label
    self.handler = handler
    self.m_giftScrllView = new(ScrollView,0,0,w,h,true);
    self.m_giftScrllView:setDirection(kHorizontal);
    self.m_giftScrllView:setAlign(kAlignCenter);
    self:addChild(self.m_giftScrllView);
end

function GiftModuleScrollList.dtor(self)
    self.m_giftScrllView:removeAllChildren(true);
    delete(self.m_giftScrllView);
    self.m_giftScrllView = nil;
end

--[Comment]
--初始化滑动列表
--sizeMode: 礼物item大小模式
function GiftModuleScrollList.initScrollView(self,sizeMode)
    local giftList = MallData.getInstance():getGiftList();
    if not giftList or next(giftList) == nil then return end

    for k,v in pairs(giftList) do
        local item = new(GiftModuleItem,v,self.mode,sizeMode,self.handler)
        if item then
            self.m_giftScrllView:addChild(item);
        end
    end
end

--[Comment]
--更新item 
function GiftModuleScrollList.onUpdateItem(self,data)
    if not data then return end
    local tab = self.m_giftScrllView:getChildren()
    for k,v in pairs(tab) do 
        if not data.gift then return end
        for i,j in pairs(data.gift) do
            if j then 
                local id = tonumber(j.gift_id) or 0;
                if v.m_data.cate_id == id then
                    v:onUpdate(tonumber(j.gift_num) or 0)
                end
            end
        end
    end
end



