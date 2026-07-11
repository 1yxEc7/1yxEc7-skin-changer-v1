-- =======================================================
-- 🔒 KeyAuth 驗證核心邏輯 (乾淨合併版)
-- =======================================================

-- 1. 自動讀取玩家在執行器最頂端輸入的 script_key
local UserKey = script_key

if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 2. 您的 KeyAuth 後台憑證
local KeyAuthApp = {
    Name = "F6605190606's Application", 
    Secret = "3415524fd01acc9fd62d3bb6a0e11718638fbd43a43d8da594a400836249e199",   
    Version = "1.0"
}

-- 3. 網路請求核心函數
local HttpService = game:GetService("HttpService")
local api_url = "https://keyauth.win"

local function req(data)
    local response = json or (syn and syn.request) or (http and http.request) or http_request or (Fluxus and Fluxus.request)
    if response then
        return response({
            Url = api_url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/x-www-form-urlencoded"},
            Body = data
        }).Body
    else
        return game:HttpGet(api_url .. "?" .. data)
    end
end

-- 4. 初始化遠端伺服器連線
local init_data = "type=init&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret .. "&version=" .. KeyAuthApp.Version
local success_init, init_res_raw = pcall(function() return req(init_data) end)

if not success_init or not init_res_raw or init_res_raw:find("404") then
    game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n無法連線至驗證伺服器，請稍後再試。\n")
    return
end

local session = HttpService:JSONDecode(init_res_raw)
if not session.success then
    game.Players.LocalPlayer:Kick("\n\n[驗證系統錯誤]\n" .. tostring(session.message) .. "\n")
    return
end

-- 5. 開始向伺服器驗證客戶輸入的卡號
local login_data = "type=license&key=" .. UserKey .. "&sessionid=" .. session.sessionid .. "&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret
local login_res = HttpService:JSONDecode(req(login_data))

-- 6. 驗證通過，直接安全抓取 KeyAuth 後台 Variables 裡面的 139KB 主功能
if login_res.success then
    local var_data = "type=var&varid=MainScript&sessionid=" .. session.sessionid .. "&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret
    local var_res = HttpService:JSONDecode(req(var_data))
    
    if var_res.success and var_res.message ~= "" then
        local mainScript = loadstring(var_res.message)
        if mainScript then
            mainScript() -- 🚀 在記憶體中直接拉起您的功能選單
        else
            warn("主程式解密編譯失敗，請確認 Variables 內是否為純 Lua 代碼")
        end
    else
        game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n無法從後台安全讀取主代碼！請確認後台 Variables 變數名稱為 MainScript\n")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n" .. tostring(login_res.message) .. "\n")
end


