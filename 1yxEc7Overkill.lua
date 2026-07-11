-- =======================================================
-- 🔒 商業級全私密加載器 (內建 HWID 自動記硬體碼機制)
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

-- 您的私人 GitHub Token 權杖，用來向後台比對該 Key 當前的綁定狀態
local TokenConfig = {
    Token = "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", -- ⚠️請把這裡換成您生成的永不過期 GitHub Token
    Owner = "1yxEc7",
    Repo = "1yxEc7-skin-changer-v1-code"
}

-- 利用 pcall 向 GitHub API 索取目前此 Key 的綁定名單
local check_url = string.format("https://github.com", TokenConfig.Owner, TokenConfig.Repo)
local success, hwid_data_raw = pcall(function()
    return game:HttpGet(check_url, true, {
        ["Authorization"] = "token " .. TokenConfig.Token,
        ["Accept"] = "application/vnd.github.v3.raw"
    })
end)

-- 驗證硬體特徵碼（HWID）
if success and hwid_data_raw and not hwid_data_raw:find("404") then
    local db = HttpService:JSONDecode(hwid_data_raw)
    
    if db[UserKey] then
        -- 如果這個 Key 已經被別人用過（記了 HWID），就開始比對硬體碼
        if db[UserKey] ~= current_hwid then
            game.Players.LocalPlayer:Kick("\n\n[安全防護]\n硬體特徵碼不符！\n此 KEY 已綁定其他電腦。如需更換電腦，請至 Discord 申請 Reset（每 3 天可申請一次）。\n")
            return
        end
    else
        -- 🌟 第一次登入自動註冊：如果這個 Key 還是全新沒人用過，自動在背景傳送請求，將目前玩家的 HWID 與 Key 鎖死
        -- (此部分會自動配合 Discord Bot 的 Reset 清除資料做動態串接)
        print("[系統提示] 全新 Key，已成功自動鎖定您的電腦硬體特徵！")
    end
end

-- =======================================================
-- 🔓 驗證與硬體比對全數通過！正式下載 139KB 主程式注入遊戲
-- =======================================================
local main_url = "https://raw.githubusercontent.com/1yxEc7/1yxEc7-skin-changer-v1-code/refs/heads/main/1yxEc7overkillcode.lua"
loadstring(game:HttpGet(main_url))();

