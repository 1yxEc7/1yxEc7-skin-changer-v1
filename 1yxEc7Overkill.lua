
-- 使用者在最上方輸入的 Key
local UserKey = script_key

if UserKey == nil or UserKey == "" then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n請在加載代碼最上方加上 script_key = '您的KEY';\n")
    return
end

-- 允許的白名單（如果使用者輸入這裡面的 Key，就各別去嘗試解密）
local ValidKeys = {
    ["1yxEc7-overkill-exam-01"] = true,
    ["1yxEc7-overkill-exam-02"] = true,
    ["1yxEc7-overkill-exam-03"] = true,
    ["1yxEc7-overkill-exam-04"] = true,
    ["1yxEc7-overkill-exam-05"] = true,
}

if not ValidKeys[UserKey] then
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n無效的金鑰 (Key)！\n")
    return
end

-- 1. 從 GitHub 獲取剛才上傳的加密數據 (注意：此時下載下來的是密文)
-- 建議將 GitHub 的原始代碼打包成動態下載的密文檔
local success, cipher_text = pcall(function()
    return game:HttpGet("https://githubusercontent.com")
end)

if not success or not cipher_text then
    game.Players.LocalPlayer:Kick("\n\n[網路錯誤]\n無法連接至驗證伺服器！\n")
    return
end

-- 將下載下來的字串轉回 table（假設您在 GitHub 存的是數值字串如 "11,22,33"）
local encrypted_data = {}
for num in string.gmatch(cipher_text, "[^,]+") do
    table.insert(encrypted_data, tonumber(num))
end

-- 2. 使用 UserKey 進行解密
local decrypted = {}
for i = 1, #encrypted_data do
    local b = encrypted_data[i]
    local k = string.byte(UserKey, ((i - 1) % #UserKey) + 1)
    table.insert(decrypted, string.char(b ~ k))
end
local source_code = table.concat(decrypted)

-- 3. 執行解密後的代碼
local run_script, err = loadstring(source_code)
if run_script then
    run_script()
else
    -- 如果黑客隨便改了一個在 ValidKeys 裡的 Key，但不是當初用來加密的那個 Key，解出來會是亂碼，loadstring 就會失敗
    game.Players.LocalPlayer:Kick("\n\n[驗證失敗]\n代碼損壞或 Key 權限不符！\n")
end
