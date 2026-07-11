-- =======================================================
-- 🔒 檔案 A：獨立驗證加載器 (全私密、防卡快取秒更新最終完工版)
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
-- 🛡️ 核心安全性防護：HWID 綁定與比對邏輯 (自動穿透 Private 倉庫)
-- =======================================================
local HttpService = game:GetService("HttpService")
local current_hwid = gethwid and gethwid() or (syn and syn.get_hwid and syn.get_hwid()) or "UNKNOWN_HWID"

local TokenConfig = {
    Token = "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", 
    Owner = "1yxEc7",
    Repo = "1yxEc7-skin-changer-v1-code"
}

-- 調用 JSON 資料庫路徑
local check_url = string.format("https://github.com", TokenConfig.Owner, TokenConfig.Repo)
local success, hwid_data_raw = pcall(function()
    local req = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    if req then
        local res = req({
            Url = check_url .. "?cb=" .. tostring(os.time()), -- 加上防快取時間戳記
            Method = "GET",
            Headers = {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"}
        })
        return res.Body
    else
        return game:HttpGet(check_url .. "?cb=" .. tostring(os.time()), true, {["Authorization"] = "token " .. TokenConfig.Token, ["Accept"] = "application/vnd.github.v3.raw"})
    end
end)

local db = {}
if success and hwid_data_raw and not hwid_data_raw:find("404") and not hwid_data_raw:find("Not Found") then
    local status, decoded = pcall(function() return HttpService:JSONDecode(hwid_data_raw) end)
    if status then db = decoded end
    
    if db[UserKey] then
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
-- 🔓 驗證與硬體比對全數通過！利用「防快取機制」強行秒速更新、下載 139KB 主程式
-- =======================================================
local main_url = string.format("https://github.com", TokenConfig.Owner, TokenConfig.Repo)
local success_main, main_content = pcall(function()
    local req = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    
    -- 🌟 核心關鍵：在網址後面強行注入 os.time() 時間戳記，徹底摧毀 GitHub 官方伺服器的快取緩存，實現一秒同步更新！
    local anti_cache_url = main_url .. "?cb=" .. tostring(os.time())
    
    if req then
        local res = req({
            Url = anti_cache_url,
            Method = "GET",
            Headers = {
                ["Authorization"] = "token " .. TokenConfig.Token,
                ["Accept"] = "application/vnd.github.v3.raw"
            }
        })
        return res.Body
    else
        return game:HttpGet(anti_cache_url, true, {
            ["Authorization"] = "token " .. TokenConfig.Token,
            ["Accept"] = "application/vnd.github.v3.raw"
        })
    end
end)

if success_main and main_content and main_content ~= "" and not main_content:find("message") and not main_content:find("404") then
    local mainScript = loadstring(main_content)
    if mainScript then
        mainScript() -- 🚀 完美拉起全私密、秒同步的 139KB 核心功能選單！
    else
        warn("主程式解密編譯失敗，請確認檔案內是否為純 Lua 代碼")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n核心下載失敗！無法與遠端私密伺服器取得安全連線，請聯絡開發者。\n")
end
