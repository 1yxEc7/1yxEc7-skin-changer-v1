
local UserKey = script_key

-- 2. 檢查使用者有沒有在代碼最上方加上 Key
if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true,
    ["1yxEc7-overkill-exam-02"] = true,
    ["1yxEc7-overkill-exam-03"] = true,
    ["1yxEc7-overkill-exam-04"] = true,
    ["1yxEc7-overkill-exam-05"] = true,
}

if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n\n您輸入的 KEY 無效或已過期！\n")
    return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/1yxEc7/1yxEc7-skin-changer-v1-code/refs/heads/main/1yxEc7overkillcode.lua"))();

