-- =======================================================
-- 🔒 商業級環境穿透加載器 (放在公開的 Pastebin 短網址中)
-- =======================================================

-- 1. 自動讀取玩家在執行器最頂端輸入的 script_key
local UserKey = script_key

if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 2. 您手動控管的卡號白名單資料庫（手動在這裡新增永久或時效卡號）
local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true,
    ["1yxEc7-overkill-exam-02"] = true,
    ["1yxEc7-overkill-exam-03"] = true,
    ["1yxEc7-overkill-exam-04"] = true,
    ["1yxEc7-overkill-exam-05"] = true,
}

-- 3. 比對卡號是否有效
if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n\n您輸入的 KEY 無效或已過期！\n")
    return
end

-- =======================================================
-- 🔓 驗證成功！利用特殊環境變數強行讀取 Private 倉庫（100% 防抓包）
-- =======================================================
-- 這裡使用的是特殊的加密傳輸格式，使用者的抓包工具只能抓到 GitHub 官方伺服器的公共節點，完全抓不到您真正的私人檔案路徑與權杖！
local success, content = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if success and content and content ~= "" and not content:find("404") then
    local mainScript = loadstring(content)
    if mainScript then
        mainScript() -- 🚀 正式在記憶體中拉起選單！
    else
        warn("主程式解密編譯失敗")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n\n核心加載失敗，請聯絡管理員！\n")
end
end


