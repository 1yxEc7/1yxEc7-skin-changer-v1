-- 使用者輸入的 Key（必須在最上方設定）
local UserKey = script_key
local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true, ["1yxEc7-overkill-exam-02"] = true,
    ["1yxEc7-overkill-exam-03"] = true, ["1yxEc7-overkill-exam-04"] = true,
    ["1yxEc7-overkill-exam-05"] = true
}

-- 驗證 Key 是否合法
if not UserKey or not ValidKeys[UserKey] then 
    return game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n無效或未設定金鑰 (Key)！\n") 
end

-- 1. 下載密文
local success, cipher_text = pcall(game.HttpGet, game, "https://githubusercontent.com")
if not success or not cipher_text then 
    return game.Players.LocalPlayer:Kick("\n\n[網路錯誤]\n無法連接至驗證伺服器！\n") 
end

-- 2. 解密 (XOR)
local decrypted, key_len, idx = {}, #UserKey, 1
for num in string.gmatch(cipher_text, "[^,]+") do
    local b = tonumber(num)
    local k = string.byte(UserKey, ((idx - 1) % key_len) + 1)
    decrypted[idx] = string.char(b ~ k)
    idx = idx + 1
end

-- 3. 執行代碼
local run_script, err = loadstring(table.concat(decrypted))
if run_script then 
    run_script() 
else 
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n代碼損壞或 Key 權限不符！\n") 
end
