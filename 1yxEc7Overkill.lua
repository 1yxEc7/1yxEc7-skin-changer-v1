
script_key = "3415524fd01acc9fd62d3bb6a0e11718638fbd43a43d8da594a400836249e199"

-- =======================================================
-- 🔒 KeyAuth 伺服器驗證核心邏輯 (直接在本地執行，免除 GitHub 404 風險)
-- =======================================================
local UserKey = script_key
if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

local KeyAuthApp = {
    Name = "F6605190606's Application", 
    Secret = "3415524fd01acc9fd62d3bb6a0e11718638fbd43a43d8da594a400836249e199",   
    Version = "1.0"
}

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

local login_data = "type=license&key=" .. UserKey .. "&sessionid=" .. session.sessionid .. "&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret
local login_res = HttpService:JSONDecode(req(login_data))

if login_res.success then

    local var_data = "type=var&varid=MainScript&sessionid=" .. session.sessionid .. "&name=" .. KeyAuthApp.Name .. "&secret=" .. KeyAuthApp.Secret
    local var_res = HttpService:JSONDecode(req(var_data))
    
    if var_res.success and var_res.message ~= "" then
        local mainScript = loadstring(var_res.message)
        if mainScript then
            mainScript() 
        else
            warn("主程式解密編譯失敗，請確認 Variables 內是否為純 Lua 代碼")
        end
    else
        game.Players.LocalPlayer:Kick("\n\n[系統錯誤]\n無法從後台安全讀取主代碼！請確認後台 Variables 變數名稱為 MainScript\n")
    end
else
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n" .. tostring(login_res.message) .. "\n")
end




