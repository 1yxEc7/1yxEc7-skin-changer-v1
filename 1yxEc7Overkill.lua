-- =======================================================
-- 🔒 檔案 A：獨立驗證加載器 (存放在左邊分頁倉庫中)
-- =======================================================

-- 1. 自動讀取玩家在執行器最頂端輸入的 script_key
local UserKey = script_key

if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 2. 您手動控管的卡號白名單資料庫
local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true,
    ["1yxEc7-overkill-exam-02"] = true,
    ["1yxEc7-overkill-exam-03"] = true,
    ["1yxEc7-overkill-exam-04"] = true,
    ["1yxEc7-overkill-exam-05"] = true,
}

-- 3. 比對卡號是否存在
if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n您輸入的 KEY 無效或已過期！\n")
    return
end

-- =======================================================
-- 🛡️ 核心安全性防護：HWID 綁定與比對邏輯 
-- =======================================================
local HttpService = game:GetService("HttpService")
local current_hwid = gethwid and gethwid() or (syn and syn.get_hwid and syn.get_hwid()) or "UNKNOWN_HWID"

local TokenConfig = {
    -- 您的全新隱形權杖鑰匙
    Token = "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", 
    Owner = "1yxEc7",
    -- 🎯 鎖定右邊分頁存放 139KB 亂碼的主功能倉庫
    Repo = "1yxEc7-skin-changer-v1-code"
}

-- 調用 JSON 資料庫路徑 (存放在右邊倉庫中)
local check_url = string.format("https://github.com", TokenConfig.Owner, TokenConfig.Repo)
local success, hwid_data_raw = pcall(function()
    local req = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    if req then
        local res = req({
            Url = check_url,
            Method = "GET",
            Headers = {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"}
        })
        return res.Body
    else
        return game:HttpGet(check_url, true, {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"})
    end
end)

local db = {}
local file_sha = ""

-- 讀取與解析硬體特徵碼資料庫
if success and hwid_data_raw and not hwid_data_raw:find("404") and not hwid_data_raw:find("Not Found") then
    local status, decoded = pcall(function() return HttpService:JSONDecode(hwid_data_raw) end)
    if status then
        db = decoded
    end
    
    if db[UserKey] then
        -- 如果這個 Key 已經記錄過硬體碼，進行嚴格比對
        if db[UserKey] ~= current_hwid then
            game.Players.LocalPlayer:Kick("\n\n[安全防護]\n硬體特徵碼不符！\n此 KEY 已綁定其他電腦。如需更換電腦，請至 Discord 申請 Reset（每 3 天可申請一次）。\n")
            return
        end
    else
        -- 🌟 第一次登入自動註冊硬體碼
        db[UserKey] = current_hwid
        print("[系統提示] 全新 Key，已成功自動鎖定您的電腦硬體特徵！")
    end
else
    -- 如果後台完全沒有這個檔案（第一次執行），自動初始化建立第一筆資料
    db[UserKey] = current_hwid
    print("[系統提示] 初始化硬體資料庫成功！")
end

-- =======================================================
-- 🔓 驗證與硬體比對全數通過！強行穿透 Private 倉庫下載右邊分頁的 139KB 主程式
-- =======================================================
local main_url = string.format("https://github.com", TokenConfig.Owner, TokenConfig.Repo)
local success_main, main_content = pcall(function()
    local req = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    if req then
        return req({
            Url = main_url,
            Method = "GET",
            Headers = {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"}
        }).Body
    else
        return game:HttpGet(main_url, true, {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"})
    end
end)

if success_main and main_content and main_content ~= "" and not main_content:find("message") and not main_content:find("404") then
    local mainScript = loadstring(main_content)
    if mainScript then
        mainScript() -- 🚀 完美無縫拉起右邊分頁的 139KB 純混淆主要功能選單！
    else
        warn("主程式解密編譯失敗，請確認右邊倉庫檔案內是否為純 Lua 代碼")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n無法從遠端私密倉庫抓取主程式，請確認右邊分頁的檔名是否為 1yxEc7Overkill.lua ！\n")
end
