-- 1. 正確讀取不加 _G 的標準全域變數 script_key
local UserKey = script_key or script_key

-- 2. 檢查使用者有沒有在代碼最上方加上 Key
if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 3. 您的卡號白名單資料庫
local ValidKeys = {
    ["1yxEc7-overkill-01"] = true,
    ["1yxEc7-overkill-02"] = true,
    ["1yxEc7-overkill-03"] = true,
    ["1yxEc7-overkill-04"] = true,
    ["1yxEc7-overkill-05"] = true,
    ["1yxEc7-overkill-06"] = true,
    ["1yxEc7-overkill-07"] = true,
    ["1yxEc7-overkill-08"] = true,
    ["1yxEc7-overkill-09"] = true,
    ["1yxEc7-overkill-10"] = true,
}

-- 4. 使用剛才抓取到的 UserKey 去白名單資料庫比對 (修正原本錯誤的 _G.script_key)
if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n您輸入的 KEY 無效或已過期！\n")
    return
end

-- =======================================================
-- 🔓 驗證成功！正式執行您原本的純混淆主要程式碼 (已移除開頭註解與結尾錯誤的 else)
-- =======================================================
loadstring(game:HttpGet("https://raw.githubusercontent.com/1yxEc7/1yxEc7-skin-changer-v1-code/refs/heads/main/1yxEc7-overkill-code.lua"))();



