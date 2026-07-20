-- ============================================================
--  输入法自动切换
--  规则：列表内的 App → 微信输入法；其余 App → 英文 ABC
-- ============================================================

-- 【第一步】确认输入法 ID
-- 切换到对应输入法后，在 Hammerspoon Console 执行以下命令查询：
--   hs.keycodes.currentSourceID()

local IM_CHINESE = "com.tencent.inputmethod.wetype.pinyin"  -- 微信输入法
-- local IM_CHINESE = "com.bytedance.inputmethod.doubaoime.pinyin"  -- 豆包输入法
local IM_ENGLISH = "com.apple.keylayout.ABC"            -- 系统英文 ABC

-- 【第二步】填写需要中文输入法的 App
-- 查询 Bundle ID：切换到目标 App，在 Console 执行：
--   hs.application.frontmostApplication():bundleID()
local chineseApps = {
    "com.tencent.xinWeChat",    -- 微信
    "com.kingsoft.gobang",      -- gobang
    "ru.keepcoder.Telegram",    -- telegram
    "com.openai.chat",          -- chatgpt
    "com.tencent.qq",           -- QQ
    "com.apple.Notes",          -- 备忘录
    "com.apple.mail",           -- 邮件
    "md.obsidian",              -- Obsidian
    "com.notion.id",            -- Notion
    -- 继续添加 ↑
}

-- ============================================================
--  以下无需修改
-- ============================================================

local chineseAppSet = {}
for _, id in ipairs(chineseApps) do
    chineseAppSet[id] = true
end

-- 切换提示样式：小号、半透明、屏幕底部，短暂显示，不打断操作
local hintStyle = {
    textSize = 13,
    strokeWidth = 0,
    strokeColor = { white = 0, alpha = 0 },
    fillColor = { white = 0, alpha = 0.55 },
    textColor = { white = 1, alpha = 0.85 },
    radius = 8,
    padding = 8,
    atScreenEdge = 2, -- 屏幕底部
    fadeInDuration = 0.1,
    fadeOutDuration = 0.2,
}

local function switchInput(bundleID)
    local target = chineseAppSet[bundleID] and IM_CHINESE or IM_ENGLISH
    if hs.keycodes.currentSourceID() ~= target then
        hs.keycodes.currentSourceID(target)
        local hint = (target == IM_CHINESE) and "中" or "EN"
        hs.alert.closeAll(0)
        hs.alert.show(hint, hintStyle, 0.5)
    end
end

local windowFilter = hs.window.filter.new(nil, "inputSwitcher")
windowFilter:subscribe(hs.window.filter.windowFocused, function(win)
    if not win then return end
    local app = win:application()
    if not app then return end
    local bid = app:bundleID()
    if not bid then return end
    hs.timer.doAfter(0.1, function() switchInput(bid) end)
end)

local front = hs.application.frontmostApplication()
if front then switchInput(front:bundleID()) end

hs.alert.show("⌨️ 输入法自动切换已启动")
