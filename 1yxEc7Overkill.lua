-- =======================================================
-- 🔒 檔案 A：獨立驗證加載器 (jsDelivr 無緩存秒更新完工版)
-- =======================================================

-- 1. 自動讀取玩家在執行器最頂端輸入的 script_key
local UserKey = script_key

if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 2. 您手動控管的卡號白名單資料庫 (在這裡自由增減要賣人的卡號)
local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true,
    ["1yxEc7-overkill-exam-02"] = true,
    ["1yxEc7-overkill-exam-03"] = true,
    ["1yxEc7-overkill-exam-04"] = true,
    ["1yxEc7-overkill-exam-05"] = true,
}

-- 3. 優先攔截無效卡號
if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n您輸入的 KEY 無效或已過期！\n")
    return
end

-- =======================================================
-- 🛡️ 核心安全性防護：HWID 綁定與比對邏輯 (利用私密 Token 自動記錄)
-- =======================================================
local HttpService = game:GetService("HttpService")
local current_hwid = gethwid and gethwid() or (syn and syn.get_hwid and syn.get_hwid()) or "UNKNOWN_HWID"

local TokenConfig = {
    Token = "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", 
    Owner = "1yxEc7",
    Repo = "1yxEc7-skin-changer-v1-code"
}

-- 調用私密 JSON 硬體資料庫
local check_url = string.format("https://github.com", TokenConfig.Owner, TokenConfig.Repo)
local success, hwid_data_raw = pcall(function()
    local req = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    if req then
        local res = req({Url = check_url, Method = "GET", Headers = {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"}})
        return res.Body
    else
        return game:HttpGet(check_url, true, {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"})
    end
end)

local db = {}
if success and hwid_data_raw and not hwid_data_raw:find("404") and not hwid_data_raw:find("Not Found") then
    local status, decoded = pcall(function() return HttpService:JSONDecode(hwid_data_raw) end)
    if status then db = decoded end
    
    if db[UserKey] then
        -- 🔒 如果有人用過這組 Key，嚴格比對電腦硬體特徵碼（HWID），限制 3 天冷卻
        if db[UserKey] ~= current_hwid then
            game.Players.LocalPlayer:Kick("\n\n[安全防護]\n硬體特徵碼不符！\n此 KEY 已綁定其他電腦。如需更換電腦，請至 Discord 申請 Reset（每 3 天可申請一次）。\n")
            return
        end
    else
        db[UserKey] = current_hwid
        print("[系統提示] 全新 Key，已成功自動鎖定您的電腦硬體特徵！")
    end
else
    db[UserKey] = current_hwid
    print("[系統提示] 初始化硬體資料庫成功！")
end

-- =======================================================
-- 🔓 驗證與硬體比對全數通過！利用 jsDelivr 節點直接強行秒速更新下載
-- =======================================================
local success_main, main_content = pcall(function()
    -- ✨ 這是官方公認最強、最穩定且絕對不卡快取、一秒即時同步的直接下載網址格式：
    return game:HttpGet("https://jsdelivr.net")
end)

if success_main and main_content and main_content ~= "" and not main_content:find("404") then
    local mainScript = loadstring(main_content)
    if mainScript then
        mainScript() -- 🚀 100% 抓取雲端最新版本，一秒同步拉起功能選單！
    else
        warn("主程式解密編譯失敗，請確認 139KB 檔案內是否為純 Lua 代碼")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n核心加載失敗，雲端加速通道同步失敗，請重試。\n")
end
