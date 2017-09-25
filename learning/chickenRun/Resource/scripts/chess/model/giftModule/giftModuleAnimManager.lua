--GiftModuleAnimManager.lua
--Date 2016.8.7
--礼物动画管理
--endregion
require("animation/eggAnim");
require("animation/flowerAnim");
require("animation/cardAnim");
require("animation/kissAnim");

GiftModuleAnimManager = {}

GiftModuleAnimManager.animTable = {};

GiftModuleAnimManager.ANIM_KISS = 16;
GiftModuleAnimManager.ANIM_EGG = 17;
GiftModuleAnimManager.ANIM_FLOWER = 18;
GiftModuleAnimManager.ANIM_CARD = 19;

--[Comment]
--播放礼物动画
--id: 礼物类型(礼物cate_id)  startView:开始节点  endView:结束节点  angle:角度
function GiftModuleAnimManager.playAnim(content,id,startView,endView,angle,halfMode)
    if not startView or not endView then
        return
    end
    if not id then return end
    if id == GiftModuleAnimManager.ANIM_KISS then
        GiftModuleAnimManager.playKissAnim(content,startView,endView)
    elseif id == GiftModuleAnimManager.ANIM_EGG and angle then
        GiftModuleAnimManager.playEggAnim(content,startView,endView,angle,halfMode)
    elseif id == GiftModuleAnimManager.ANIM_FLOWER and angle then
        GiftModuleAnimManager.playFlowerAnim(content,startView,endView,angle,halfMode)
    elseif id == GiftModuleAnimManager.ANIM_CARD then
        GiftModuleAnimManager.playCardAnim(content,startView,endView,halfMode)
    end
end

--[Comment]
--播放飞吻动画
function GiftModuleAnimManager.playKissAnim(content, startView,endView)
    local anim = new(KissAnim,startView,endView);
    table.insert(GiftModuleAnimManager.animTable,anim);
    anim:setCallBack(GiftModuleAnimManager,function()
        delete(anim)
        anim = nil;
        GiftModuleAnimManager.clearAnimTab()
    end)
--    if mode then
--        anim:playHalfAnim();
--        return
--    end
    anim:play();
end

--[Comment]
--播放鸡蛋动画
function GiftModuleAnimManager.playEggAnim(content, startView,endView,angle,mode)
    local anim = new(EggAnim,startView,endView,angle);
    table.insert(GiftModuleAnimManager.animTable,anim);
    anim:setCallBack(GiftModuleAnimManager,function()
        delete(anim)
        anim = nil;
        GiftModuleAnimManager.clearAnimTab()
    end)
    if mode then
        anim:playHalfAnim();
        return
    end
    anim:play();
end

--[Comment]
--播放鲜花动画
function GiftModuleAnimManager.playFlowerAnim(content, startView,endView,angle,mode)
    local anim = new(FlowerAnim,startView,endView,angle);
    table.insert(GiftModuleAnimManager.animTable,anim);
    anim:setCallBack(GiftModuleAnimManager,function()
        delete(anim)
        anim = nil;
        GiftModuleAnimManager.clearAnimTab()
    end)
    if mode then
        anim:playHalfAnim();
        return
    end
    anim:play();
end

--[Comment]
--播放金卡动画
function GiftModuleAnimManager.playCardAnim(content, startView,endView,mode)
    local anim = new(CardAnim,startView,endView);
    table.insert(GiftModuleAnimManager.animTable,anim);
    anim:setCallBack(GiftModuleAnimManager,function()
        delete(anim)
        anim = nil;
        GiftModuleAnimManager.clearAnimTab()
    end )
    if mode then
        anim:playHalfAnim();
        return
    end
    anim:play();
end

--[Comment]
--停止播放所有礼物动画
function GiftModuleAnimManager.stopAllPropAnim()
    for k, v in pairs(GiftModuleAnimManager.animTable) do
        if v then
            v:stop();
        end
    end
    GiftModuleAnimManager.clearAnimTab()
end

--[Comment]
--获得礼物动画列表长度
function GiftModuleAnimManager.getAnimList()
    local temp = 0;
    for k, v in pairs(GiftModuleAnimManager.animTable) do
        if v then
            temp = temp + 1
        end
    end
    return temp
end

--[Comment]
--清理动画列表
function GiftModuleAnimManager.clearAnimTab()
    for k, v in pairs(GiftModuleAnimManager.animTable) do
        if v then
            delete(v)
            v = nil
        end
    end
    GiftModuleAnimManager.animTable = {}
end

