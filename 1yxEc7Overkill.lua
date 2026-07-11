-- =======================================================
-- 🔍 純文字除錯版 Loader (直接測試，不混淆)
-- =======================================================
script_key = "1yxEc7-overkill-exam-01"

local UserKey = script_key
if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true,
    ["1yxEc7-overkill-exam-02"] = true,
}

if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n您輸入的 KEY 無效或已過期！\n")
    return
end

print("[Loader 提示] 第一關：卡號驗證已成功通過！")

-- 🔓 核心下載排查
local main_url = "https://githubusercontent.com"

local success_main, main_content = pcall(function()
    local req = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    if req then
        local res = req({
            Url = main_url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
            }
        })
        return res.Body
    else
        return game:HttpGet(main_url)
    end
end)

-- 輸出詳細日誌到您的 F9 控制台
if success_main and main_content then
    print("[Loader 提示] 第二關：成功連線到伺服器！長度為: " .. tostring(#main_content))
    if main_content:find("404") or main_content:find("Not Found") then
        warn("[Loader 警告] 伺服器回傳了 404 找不到檔案錯誤！")
    end
else
    warn("[Loader 錯誤] 網路請求徹底失敗，原因: " .. tostring(main_content))
end

if success_main and main_content and main_content ~= "" and not main_content:find("404") then
    local mainScript = loadstring(main_content)
    if mainScript then
        print("[Loader 提示] 第三關：主程式編譯成功，正在拉起選單！")
        mainScript() 
    else
        warn("[Loader 錯誤] 主程式 loadstring 編譯失敗！")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n核心加載失敗，安全通道遭到攔截，請重試。\n")
end

