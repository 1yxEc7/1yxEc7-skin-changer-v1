-- 1. 正確讀取不加 _G 的標準全域變數 script_key
local UserKey = script_key

if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 2. 串接您的 KeyAuth 後台憑證（已幫您完美合併專屬 Application Secret）
local KeyAuthApp = {
    Name = "F6605190606's Application", 
    Secret = "3415524fd01acc9fd62d3bb6a0e11718638fbd43a43d8da594a400836249e199",   
    Version = "1.0"
}

-- 3. 向 KeyAuth 伺服器發送加密驗證請求
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

-- 初始化遠端伺服器連線
local init_data = "type=init&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret .. "&version=" .. KeyAuthApp.Version
local session = HttpService:JSONDecode(req(init_data))

if not session.success then
    game.Players.LocalPlayer:Kick("\n\n[驗證系統錯誤]\n" .. tostring(session.message) .. "\n")
    return
end

-- 開始驗證卡號
local login_data = "type=license&key=" .. UserKey .. "&sessionid=" .. session.sessionid .. "&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret
local login_res = HttpService:JSONDecode(req(login_data))

-- 4. 驗證通過，直接從 KeyAuth 安全抓取 139KB 代碼並執行（HttpGet Spy 抓不到實體網址）
if login_res.success then
    -- 向伺服器索取您存在 Variables 裡名為 MainScript 的 139KB 程式碼
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
        game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n無法從後台安全讀取主代碼！請確認後台變數名稱為 MainScript\n")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n" .. tostring(login_res.message) .. "\n")
end




