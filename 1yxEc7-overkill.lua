local UserKey = script_key or script_key


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

if not ValidKeys[_G.script_key] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n您輸入的 KEY 無效或已過期！\n")
    return
end

-- =======================================================
 loadstring(game:HttpGet("https://raw.githubusercontent.com/1yxEc7/1yxEc7-skin-changer-v1-code/refs/heads/main/1yxEc7-overkill-code.lua"))();else
-- =======================================================



