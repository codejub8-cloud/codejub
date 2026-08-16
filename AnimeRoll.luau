local function cleanAllExistingNotifications()
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        for _, gui in ipairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "CUPIEUI" and gui.Enabled then
                for _, child in ipairs(gui:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("Frame") then
                        local name = child.Name:lower()
                        local text = child:IsA("TextLabel") and child.Text:lower() or ""
                        
                        local isPopup = (
                            name:find("popup") or 
                            name:find("notif") or 
                            name:find("toast") or 
                            name:find("alert") or 
                            name:find("message") or 
                            name:find("reward") or 
                            name:find("claim") or 
                            text:find("rolled") or 
                            text:find("claimed") or 
                            text:find("reward") or 
                            text:find("success") or 
                            text:find("got") or 
                            text:find("rare") or 
                            text:find("epic") or 
                            text:find("legendary") or 
                            text:find("mythic") or 
                            text:find("secret") or 
                            (child.Parent and child.Parent.Name:lower():find("popup"))
                        )
                        
                        local isProtected = (
                            child.Parent and 
                            (child.Parent.Name:lower():find("shop") or
                             child.Parent.Name:lower():find("pass") or
                             child.Parent.Name:lower():find("upgrade") or
                             child.Parent.Name:lower():find("gold") or
                             child.Parent.Name:lower():find("hud") or
                             child.Parent.Name:lower():find("main") or
                             child.Parent.Name:lower():find("bar"))
                        )
                        
                        if isPopup and not isProtected then
                            if child:IsA("TextLabel") then
                                child.Visible = false
                                child.TextTransparency = 1
                            elseif child:IsA("Frame") then
                                child.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function cleanAllExistingNotifications()
    -- Intentionally non-destructive to preserve all game HUD buttons (Pass, Shop, Upgrades, Gold HUD)
end

-- ══════════════════════════════════════════════════════════
-- HELPER FUNCTIONS (Plot, In-Game Equip & Remote Handlers)
-- ══════════════════════════════════════════════════════════

local function getMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    for _, plot in ipairs(plots:GetChildren()) do
        local ownerAttr = plot:GetAttribute("Owner") or plot:GetAttribute("UserId")
        if ownerAttr and (tostring(ownerAttr) == LocalPlayer.Name or tostring(ownerAttr) == tostring(LocalPlayer.UserId)) then
            return plot
        end
    end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local closest, minDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local cf = plot:GetPivot()
            local dist = (cf.Position - root.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = plot
            end
        end
        if closest and minDist < 250 then return closest end
    end
    
    return plots:FindFirstChild("Plot1") or plots:FindFirstChild("Plot2") or plots:GetChildren()[1]
end

local function firePrompt(prompt)
    if not prompt or not prompt.Enabled then return end
    pcall(function()
        prompt.MaxActivationDistance = 999999
        prompt.RequiresLineOfSight = false
        prompt.HoldDuration = 0
    end)
    if fireproximityprompt then
        pcall(function() fireproximityprompt(prompt) end)
    elseif prompt.InputHoldBegin then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.04)
            prompt:InputHoldEnd()
        end)
    end
end

local function getPlotRollPrompt(plot)
    if not plot then return nil end
    local rollFolder = plot:FindFirstChild("Roll")
    if rollFolder then
        local rollBtn = rollFolder:FindFirstChild("RollButton")
        if rollBtn then
            local btn = rollBtn:FindFirstChild("Button") or rollBtn
            local prompt = btn:FindFirstChild("RollPrompt") or btn:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then return prompt, btn end
        end
        local anyPrompt = rollFolder:FindFirstChildWhichIsA("ProximityPrompt", true)
        if anyPrompt then return anyPrompt, anyPrompt.Parent end
    end
    return nil, nil
end

local function smoothPositionToRollPad()
    local plot = getMyPlot()
    local _, btn = getPlotRollPrompt(plot)
    if not btn then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and btn:IsA("BasePart") then
        local targetPos = btn.Position + Vector3.new(0, 3.2, 0)
        root.CFrame = CFrame.new(targetPos, targetPos + btn.CFrame.LookVector)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- Exact In-Game Equip Best (Verified: Characters.UpdateInventory:FireServer("EquipBest"))
local function triggerEquipBest()
    if CharactersInv then
        pcall(function() CharactersInv:FireServer("EquipBest") end)
    end
    
    local plot = getMyPlot()
    if plot then
        local equipPrompt = plot:FindFirstChild("EquipPrompt", true) or plot:FindFirstChild("AutoEquipPrompt", true)
        if equipPrompt then firePrompt(equipPrompt) end
    end
end

-- ══════════════════════════════════════════════════════════
-- UNIFIED 15-TIER IN-GAME RARITY INDEX & ORDER
-- ══════════════════════════════════════════════════════════

local InGameRarities = {
    [1]  = "Common",
    [2]  = "Rare",
    [3]  = "Epic",
    [4]  = "Legendary",
    [5]  = "Mythic",
    [6]  = "Secret",
    [7]  = "God",
    [8]  = "Limited",
    [9]  = "Godly",
    [10] = "Godlyx",
    [11] = "Divine",
    [12] = "Immortal",
    [13] = "OP",
    [14] = "OG",
    [15] = "INVASION"
}

-- 100% OFFICIAL DECOMPILED IN-GAME CHARACTER RARITY MATRIX
-- (Supports both Internal Names & In-Game Parody Display Names)
-- ══════════════════════════════════════════════════════════

local CharacterRarities = {
    -- 1. Common (Tier 1)
    ["zoro"] = "Common", ["zero"] = "Common",
    ["krillin"] = "Common", ["keririn"] = "Common",
    ["luffy"] = "Common", ["luppi"] = "Common",
    ["ussop"] = "Common", ["usopp"] = "Common", ["usoff"] = "Common",
    ["itadori"] = "Common", ["itadoro"] = "Common",
    ["rock lee"] = "Common", ["rocklee"] = "Common", ["solid lei"] = "Common",

    -- 2. Rare (Tier 2)
    ["maki"] = "Rare", ["mika"] = "Rare",
    ["goku"] = "Rare", ["goke"] = "Rare",
    ["sakura"] = "Rare", ["sukora"] = "Rare",
    ["mob"] = "Rare", ["mobi"] = "Rare", ["reigen"] = "Rare",
    ["junwoo"] = "Rare", ["janwoo"] = "Rare",
    ["choji"] = "Rare", ["soji"] = "Rare",

    -- 3. Epic (Tier 3)
    ["tanjiro"] = "Epic", ["tanjuro"] = "Epic",
    ["shinra"] = "Epic", ["shinrat"] = "Epic",
    ["guts"] = "Epic", ["got"] = "Epic",
    ["manji"] = "Epic",
    ["ban"] = "Epic", ["bon"] = "Epic",
    ["piccolo"] = "Epic", ["picurro"] = "Epic",
    ["renji"] = "Epic", ["rinnju"] = "Epic",
    ["shikamaru"] = "Epic", ["shikamura"] = "Epic",

    -- 4. Legendary (Tier 4)
    ["erwin"] = "Legendary", ["erwon"] = "Legendary",
    ["sukuna"] = "Legendary", ["sakuna"] = "Legendary",
    ["gojo"] = "Legendary", ["goji"] = "Legendary",
    ["naruto"] = "Legendary", ["noruto"] = "Legendary",
    ["narutoclone"] = "Legendary", ["noruto clone"] = "Legendary",
    ["summonertest"] = "Legendary",
    ["saitama"] = "Legendary", ["saitomo"] = "Legendary",
    ["trunks"] = "Legendary", ["truck"] = "Legendary",
    ["grimmjow"] = "Legendary", ["grimmick"] = "Legendary",
    ["zenitsu"] = "Legendary", ["zinichou"] = "Legendary",
    ["nanami"] = "Legendary", ["nonomi"] = "Legendary",

    -- 5. Mythic (Tier 5)
    ["stark"] = "Mythic", ["coyote"] = "Mythic",
    ["kokushibo"] = "Mythic", ["kokushiro"] = "Mythic",
    ["simo hayha"] = "Mythic", ["shimo haya"] = "Mythic",
    ["hoshina"] = "Mythic", ["hoshira"] = "Mythic",
    ["ace"] = "Mythic", ["acer"] = "Mythic",
    ["broly"] = "Mythic", ["brocolli"] = "Mythic",
    ["orihime"] = "Mythic", ["orihemi"] = "Mythic",
    ["rengoku"] = "Mythic", ["rengundam"] = "Mythic",
    ["toji"] = "Mythic", ["joti"] = "Mythic",
    ["kashimo"] = "Mythic", ["kashimi"] = "Mythic",
    ["kakashi"] = "Mythic", ["kebashi"] = "Mythic",
    ["tobi"] = "Mythic", ["tomi"] = "Mythic",
    ["akaza"] = "Mythic", ["akazo"] = "Mythic",
    ["kisuke"] = "Mythic", ["kiwusuke"] = "Mythic",
    ["yoruichi"] = "Mythic", ["yoriki"] = "Mythic",

    -- 6. Secret (Tier 6)
    ["dio"] = "Secret", ["deyo"] = "Secret",
    ["frieren"] = "Secret", ["fryren"] = "Secret",
    ["yhwatch"] = "Secret", ["yhwach"] = "Secret", ["yuwah"] = "Secret",
    ["jiren"] = "Secret", ["jerin"] = "Secret",
    ["byakuya"] = "Secret", ["brakura"] = "Secret",
    ["ulquiorra"] = "Secret", ["ulquiopta"] = "Secret",
    ["kenpachi"] = "Secret", ["kenie"] = "Secret",
    ["gyomei"] = "Secret", ["gyomain"] = "Secret",
    ["megumi"] = "Secret", ["megumo"] = "Secret",
    ["mahoraga"] = "Secret", ["mahorogo"] = "Secret",
    ["yuta"] = "Secret", ["yutta"] = "Secret",
    ["rika"] = "Secret", ["rikka"] = "Secret",
    ["hakari"] = "Secret", ["hakuro"] = "Secret",
    ["mojuro"] = "Secret", ["moru"] = "Secret",
    ["sasuke"] = "Secret", ["susuko"] = "Secret",
    ["naruto (six path)"] = "Secret", ["noruto (six realm)"] = "Secret",
    ["naruto (six path) clone"] = "Secret", ["noruto (six realm) clone"] = "Secret",
    ["douma"] = "Secret", ["duma"] = "Secret",
    ["magellan"] = "Secret", ["magullan"] = "Secret",

    -- 7. God (Tier 7)
    ["beerus"] = "God", ["bills"] = "God",
    ["rimuru"] = "God", ["remura"] = "God",
    ["whis"] = "God", ["wise"] = "God",
    ["yamamoto"] = "God", ["yamumoto"] = "God",
    ["aizen (transcendent)"] = "God", ["aisen (divine)"] = "God",
    ["ichigo"] = "God", ["isogo (true form)"] = "God", ["isogo"] = "God",
    ["dabura"] = "God", ["daburo"] = "God",
    ["madara"] = "God", ["madura"] = "God",
    ["madara (clone)"] = "God", ["madura (clone)"] = "God",
    ["hashirama"] = "God", ["hashyrama"] = "God",
    ["yorichi"] = "God", ["yoichi"] = "God",
    ["shanks"] = "God", ["shancks"] = "God",
    ["ainz"] = "God", ["ais"] = "God",
    ["death knight"] = "God",
    ["gojo (shibuya)"] = "God", ["goji (shinjuku)"] = "God",
    ["yuji (modulo)"] = "God", ["yujo (timeskip)"] = "God",
    ["madara (six path)"] = "God", ["madura (six realms)"] = "God",
    ["madara (limbo)"] = "God", ["madura (six realms) shadow"] = "God",
    ["doflamingo"] = "God", ["flamingo"] = "God",
    ["boros"] = "God", ["boris"] = "God",
    ["boros v2"] = "God", ["boris (white)"] = "God",
    ["goku (black)"] = "God", ["goki (black)"] = "God",
    ["sukuna (heian)"] = "God", ["sakuna (heian)"] = "God",
    ["muzan"] = "God", ["michael"] = "God",
    ["muzan (evolved)"] = "God", ["michael (monster)"] = "God",

    -- 8. Limited
    ["entoma"] = "Limited", ["entomancer"] = "Limited",
    ["spider (entoma)"] = "Limited",
    ["hakari (jackpot)"] = "Limited", ["hakaru (jackpot!)"] = "Limited",
    ["shalltear"] = "Limited", ["bloodtear"] = "Limited",
    ["juuzou"] = "Limited", ["joozou"] = "Limited",
    ["milim"] = "Limited", ["lilim"] = "Limited",
    ["tatsumaki"] = "Limited", ["tazumaki"] = "Limited",
    ["yugi"] = "Limited", ["yuwi"] = "Limited",
    ["darkmagician"] = "Limited", ["purple magician"] = "Limited",
    ["darkmagiciangirl"] = "Limited", ["purple magician girl"] = "Limited"
}

-- Asynchronous Module Cache for Live In-Game Exact Data
local CachedModuleRarities = {}
task.spawn(function()
    pcall(function()
        local cInfoMod = ReplicatedStorage:WaitForChild("Modules", 3) 
            and ReplicatedStorage.Modules:WaitForChild("Characters", 3) 
            and ReplicatedStorage.Modules.Characters:WaitForChild("CharactersInfo", 3)
        if cInfoMod then
            local info = require(cInfoMod)
            if type(info) == "table" then
                local chars = info.Characters or info
                for _, cData in pairs(chars) do
                    if type(cData) == "table" then
                        local r = cData.Rarity
                        if r then
                            if cData.Name then CachedModuleRarities[cData.Name:lower()] = tostring(r) end
                            if cData.DisplayName then CachedModuleRarities[cData.DisplayName:lower()] = tostring(r) end
                        end
                    end
                end
            end
        end
    end)
end)


-- Fast Number Formatting (e.g. 1,250,000)
local function formatNumberWithCommas(amount)
    local formatted = tostring(amount or "0"):gsub("[^%d]", "")
    if formatted == "" then formatted = "0" end
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Fast Direct Currency Scanner (Instant O(1))

local RarityOrder = {
    ["Common"]    = 1,
    ["Rare"]      = 2,
    ["Epic"]      = 3,
    ["Legendary"] = 4,
    ["Mythic"]    = 5,
    ["Secret"]    = 6,
    ["God"]       = 7,
    ["Limited"]   = 8,
    ["Godly"]     = 9,
    ["Godlyx"]    = 10,
    ["Divine"]    = 11,
    ["Immortal"]  = 12,
    ["OP"]        = 13,
    ["OG"]        = 14,
    ["INVASION"]  = 15
}

local function getMinRankFromRule(ruleString)
    if not ruleString then return 1 end
    if ruleString == "Common & Above (Buy All)" or ruleString == "Common & Above" or ruleString == "All Rarities" or ruleString == "All Units" then return 1
    elseif ruleString == "Rare & Above" then return 2
    elseif ruleString == "Epic & Above" then return 3
    elseif ruleString == "Legendary & Above" then return 4
    elseif ruleString == "Mythic & Above" then return 5
    elseif ruleString == "Secret & Above" then return 6
    elseif ruleString == "God & Above" then return 7
    elseif ruleString == "Limited Only" then return 8
    elseif ruleString == "Godly & Above" then return 9
    elseif ruleString == "Godlyx & Above" then return 10
    elseif ruleString == "Divine & Above" then return 11
    elseif ruleString == "Immortal & Above" then return 12
    elseif ruleString == "OP & Above" then return 13
    elseif ruleString == "OG & Above" then return 14
    elseif ruleString == "INVASION & Above" then return 15
    end
    return 1
end

-- ══════════════════════════════════════════════════════════
-- 100% SAFE & GUARANTEED AUTO SELL ENGINE (MULTI-SOURCE SCAN + UUID & INSTANCE BUYER)
-- ══════════════════════════════════════════════════════════

local throttledAutoSell = createThrottle(function()
    Log("Info", "Executing Auto Sell scan...")
    if not CharactersSell and not CharactersInv then
        pcall(function()
            CharactersSell = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("Sell")
            CharactersInv = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("UpdateInventory")
        end)
    end

    local function getUnitRarity(unitName, explicitRarity)
        if explicitRarity and InGameRarities then
            for _, rName in pairs(InGameRarities) do
                if explicitRarity:lower() == rName:lower() then return rName end
            end
        end
        local raw = tostring(unitName or ""):lower():gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " ")
        local nTrim = raw:match("^%s*(.-)%s*$") or ""
        if nTrim == "" then return nil end

        if CachedModuleRarities and CachedModuleRarities[nTrim] then return CachedModuleRarities[nTrim] end
        if CharacterRarities and CharacterRarities[nTrim] then return CharacterRarities[nTrim] end
        
        if CharacterRarities then
            for charKey, rVal in pairs(CharacterRarities) do
                if nTrim == charKey or nTrim:find("^" .. charKey .. "$") or nTrim:find(charKey, 1, true) then
                    return rVal
                end
            end
        end
        return nil
    end

    local function shouldSellItem(uName, explicitRarity, isLocked, mutation, trait, level)
        if isLocked == true then return false end
        if mutation and tostring(mutation):lower() ~= "none" and tostring(mutation) ~= "" and tostring(mutation):lower() ~= "nil" then return false end
        if trait and tostring(trait):lower() ~= "none" and tostring(trait) ~= "" and tostring(trait):lower() ~= "nil" then return false end
        if type(level) == "number" and level > 1 then return false end

        local finalRarity = getUnitRarity(uName, explicitRarity)
        if finalRarity and Config.SelectedSellRarities and Config.SelectedSellRarities[finalRarity] == true then
            return true, finalRarity
        end
        return false, nil
    end

    local uuidsToSell = {}
    local instancesToSell = {}
    local namesToSell = {}
    local seenUIDs = {}

    -- 1. Scan DataService Profile Memory (Primary)
    pcall(function()
        local dataServMod = ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("DataService")
        if dataServMod then
            local ds = require(dataServMod)
            local client = (type(ds) == "table" and (ds.client or ds.Client or ds)) or ds
            
            for _, key in ipairs({"Inventory", "Characters", "Units", "Bag"}) do
                local rawList = nil
                pcall(function() rawList = client:get(LocalPlayer, {key}) end)
                if not rawList then pcall(function() rawList = client:get({key}) end) end
                if not rawList then pcall(function() rawList = ds:get(LocalPlayer, {key}) end) end
                if not rawList and client.Data then rawList = client.Data[key] end
                if not rawList and client.Profile then rawList = client.Profile[key] end
                if not rawList and client._data then rawList = (client._data._data and client._data._data[key]) or client._data[key] end
                if not rawList and ds._data then rawList = (ds._data._data and ds._data._data[key]) or ds._data[key] end

                if type(rawList) == "table" then
                    for _, item in pairs(rawList) do
                        if type(item) == "table" then
                            local uid = item.UUID or item.Uuid or item.Id or item.uid
                            local uName = item.Name or item.CharacterName or item.UnitName or ""
                            local isLocked = item.isLocked == true or item.Locked == true or item.IsLocked == true
                            local mut = item.Mutation or item.Variant
                            local trait = item.Trait or item.Traits
                            local lvl = item.Level or item.Lvl
                            local rStr = item.Rarity or item.Tier

                            local sellOk, _ = shouldSellItem(uName, rStr, isLocked, mut, trait, lvl)
                            if sellOk and uid and not seenUIDs[uid] then
                                seenUIDs[uid] = true
                                table.insert(uuidsToSell, uid)
                                table.insert(namesToSell, uName)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- 2. Scan LocalPlayer Data / PlayerData Folders
    pcall(function()
        for _, fName in ipairs({"Data", "PlayerData", "Inventory", "Characters"}) do
            local df = LocalPlayer:FindFirstChild(fName)
            if df then
                local invFolder = df:FindFirstChild("Inventory") or df:FindFirstChild("Characters") or df
                for _, item in ipairs(invFolder:GetChildren()) do
                    if item:IsA("Instance") and item.Name ~= "Terrain" then
                        local uid = item:GetAttribute("UUID") or item:GetAttribute("Uuid") or item:GetAttribute("Id") or item.Name
                        local uName = item:GetAttribute("CharacterName") or item:GetAttribute("Name") or item.Name
                        local isLocked = item:GetAttribute("Locked") == true or item:GetAttribute("isLocked") == true
                        local mut = item:GetAttribute("Mutation") or item:GetAttribute("Variant")
                        local trait = item:GetAttribute("Trait")
                        local lvl = item:GetAttribute("Level") or item:GetAttribute("Lvl")
                        local rStr = item:GetAttribute("Rarity") or item:GetAttribute("Tier")

                        local sellOk, _ = shouldSellItem(uName, rStr, isLocked, mut, trait, lvl)
                        if sellOk then
                            if uid and not seenUIDs[uid] then
                                seenUIDs[uid] = true
                                table.insert(uuidsToSell, uid)
                            end
                            table.insert(instancesToSell, item)
                            table.insert(namesToSell, uName)
                        end
                    end
                end
            end
        end
    end)

    -- 3. Execute Multi-Format Selling
    if #uuidsToSell > 0 then
        if CharactersSell then
            pcall(function() CharactersSell:FireServer(uuidsToSell) end)
            pcall(function() CharactersSell:FireServer({ UUIDs = uuidsToSell }) end)
            pcall(function() CharactersSell:FireServer("Sell", uuidsToSell) end)
            for _, uid in ipairs(uuidsToSell) do
                pcall(function() CharactersSell:FireServer(uid) end)
                pcall(function() CharactersSell:FireServer({ UUID = uid }) end)
            end
        end
        if CharactersInv then
            pcall(function() CharactersInv:FireServer("Sell", uuidsToSell) end)
            pcall(function() CharactersInv:FireServer("SellUnits", uuidsToSell) end)
        end
    end

    if #instancesToSell > 0 and CharactersSell then
        for _, inst in ipairs(instancesToSell) do
            pcall(function() CharactersSell:FireServer(inst) end)
            pcall(function() CharactersSell:FireServer(inst.Name) end)
        end
    end
    if #uuidsToSell > 0 then
        Log("Success", "Sold %d units for Gold!", #uuidsToSell)
    end
end, 2.5)

local function executeAutoSell()
    throttledAutoSell()
end

-- ══════════════════════════════════════════════════════════
-- OFFICIAL CHARACTER PRICES & MUTATION MULTIPLIERS
-- ══════════════════════════════════════════════════════════

local CharacterPrices = {
    ["zero"] = 200, ["zoro"] = 200, ["krillin"] = 200, ["keririn"] = 200,
    ["luffy"] = 275, ["luppi"] = 275, ["ussop"] = 300, ["usopp"] = 300, ["usoff"] = 300,
    ["itadori"] = 500, ["itadoro"] = 500, ["rock lee"] = 750, ["rocklee"] = 750, ["solid lei"] = 750,
    ["maki"] = 1000, ["mika"] = 1000, ["goku"] = 1000, ["goke"] = 1000,
    ["mob"] = 1200, ["mobi"] = 1200, ["reigen"] = 1200,
    ["junwoo"] = 1800, ["janwoo"] = 1800, ["sakura"] = 1800, ["sukora"] = 1800,
    ["choji"] = 3500, ["soji"] = 3500,
    ["shinra"] = 4200, ["shinrat"] = 4200, ["ban"] = 4500, ["bon"] = 4500,
    ["tanjiro"] = 4800, ["tanjuro"] = 4800, ["manji"] = 5200,
    ["guts"] = 6000, ["got"] = 6000, ["renji"] = 7000, ["rinnju"] = 7000,
    ["piccolo"] = 7800, ["picurro"] = 7800, ["shikamaru"] = 10000, ["shikamura"] = 10000,
    ["saitama"] = 16000, ["saitomo"] = 16000, ["sukuna"] = 17500, ["sakuna"] = 17500,
    ["gojo"] = 18000, ["goji"] = 18000, ["erwin"] = 20000, ["erwon"] = 20000,
    ["naruto"] = 24000, ["noruto"] = 24000, ["summonertest"] = 24000,
    ["trunks"] = 36000, ["truck"] = 36000,
    ["akaza"] = 50500, ["akazo"] = 50500, ["entoma"] = 50000, ["entomancer"] = 50000,
    ["stark"] = 60000, ["coyote"] = 60000, ["kokushibo"] = 70000, ["kokushiro"] = 70000,
    ["simo hayha"] = 75000, ["shimo haya"] = 75000, ["hoshina"] = 80000, ["hoshira"] = 80000,
    ["ace"] = 85000, ["acer"] = 85000, ["grimmjow"] = 85000, ["grimmick"] = 85000,
    ["zenitsu"] = 120000, ["zinichou"] = 120000, ["broly"] = 127500, ["brocolli"] = 127500,
    ["nanami"] = 200000, ["nonomi"] = 200000, ["orihime"] = 200000, ["orihemi"] = 200000,
    ["dio"] = 200000, ["deyo"] = 200000, ["rengoku"] = 250000, ["rengundam"] = 250000,
    ["frieren"] = 275000, ["fryren"] = 275000, ["yhwatch"] = 310000, ["yuwah"] = 310000,
    ["toji"] = 350000, ["joti"] = 350000, ["kisuke"] = 350000, ["kiwusuke"] = 350000,
    ["yoruichi"] = 375000, ["yoriki"] = 375000, ["kashimo"] = 450000, ["kashimi"] = 450000,
    ["jiren"] = 450000, ["jerin"] = 450000,
    ["kakashi"] = 650000, ["kebashi"] = 650000, ["tobi"] = 650000, ["tomi"] = 650000,
    ["beerus"] = 650000, ["bills"] = 650000, ["byakuya"] = 700000, ["brakura"] = 700000,
    ["ulquiorra"] = 750000, ["ulquiopta"] = 750000, ["rimuru"] = 750000, ["remura"] = 750000,
    ["whis"] = 1125000, ["wise"] = 1125000, ["kenpachi"] = 1125000, ["kenie"] = 1125000,
    ["gyomei"] = 1500000, ["gyomain"] = 1500000, ["yamamoto"] = 1750000, ["yamumoto"] = 1750000,
    ["megumi"] = 2500000, ["megumo"] = 2500000, ["yuta"] = 3100000, ["yutta"] = 3100000,
    ["aizen (transcendent)"] = 3500000, ["aisen (divine)"] = 3500000,
    ["hakari"] = 3900000, ["hakuro"] = 3900000, ["ichigo"] = 4000000, ["isogo (true form)"] = 4000000,
    ["mojuro"] = 4500000, ["moru"] = 4500000, ["sasuke"] = 5000000, ["susuko"] = 5000000,
    ["dabura"] = 6000000, ["daburo"] = 6000000, ["madara"] = 7500000, ["madura"] = 7500000,
    ["hashirama"] = 7500000, ["hashyrama"] = 7500000
}

local MutationPriceMultipliers = {
    ["gold"]       = 2,
    ["diamond"]    = 5,
    ["demon"]      = 10,
    ["destroyer"]  = 15,
    ["hollow"]     = 20,
    ["slayer"]     = 25,
    ["cursed"]     = 30,
    ["astronaut"]  = 1
}

local function getCharacterCost(cleanName, mutStr)
    local base = CharacterPrices[cleanName] or 200
    local mult = 1
    if mutStr and mutStr ~= "" then
        for mKey, mVal in pairs(MutationPriceMultipliers) do
            if mutStr:find(mKey) then
                mult = mVal
                break
            end
        end
    end
    return base * mult
end


local function parseFormattedNumber(val)
    if type(val) == "number" then return val end
    if not val then return 0 end
    local str = tostring(val):gsub(",", ""):match("^%s*(.-)%s*$") or "0"
    local num, suffix = str:match("([%d%.]+)%s*([KkMmBbTtQq]?)")
    local n = tonumber(num) or 0
    if suffix then
        local s = suffix:upper()
        if s == "K" then n = n * 1e3
        elseif s == "M" then n = n * 1e6
        elseif s == "B" then n = n * 1e9
        elseif s == "T" then n = n * 1e12
        elseif s == "Q" then n = n * 1e15
        end
    end
    return n
end



local function getCurrentPlayerGold()
    -- 1. Direct DataServiceClient Live Memory Access
    local dsGold = nil
    pcall(function()
        local dsClientMod = ReplicatedStorage:FindFirstChild("Data") 
            and ReplicatedStorage.Data:FindFirstChild("DataService") 
            and (ReplicatedStorage.Data.DataService:FindFirstChild("DataServiceClient") or ReplicatedStorage.Data.DataService:FindFirstChild("Data"))
        if dsClientMod then
            local ds = require(dsClientMod)
            if type(ds) == "table" then
                if ds._data and type(ds._data) == "table" then
                    if ds._data._data and type(ds._data._data.Gold) == "number" then
                        dsGold = ds._data._data.Gold
                    elseif type(ds._data.Gold) == "number" then
                        dsGold = ds._data.Gold
                    end
                elseif ds.client and ds.client._data and type(ds.client._data._data) == "table" and type(ds.client._data._data.Gold) == "number" then
                    dsGold = ds.client._data._data.Gold
                elseif type(ds.Gold) == "number" then
                    dsGold = ds.Gold
                end
            end
        end
    end)
    if dsGold and type(dsGold) == "number" and dsGold >= 0 then
        return dsGold
    end

    -- 2. Direct ReplicatedStorage DataService Client get()
    pcall(function()
        local dsMod = ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("DataService")
        if dsMod then
            local ds = require(dsMod)
            local client = (type(ds) == "table" and (ds.client or ds.Client or ds)) or ds
            if client and client.get then
                local res = client:get(LocalPlayer, {"Gold"}) or client:get({"Gold"})
                if type(res) == "number" then dsGold = res end
            end
        end
    end)
    if dsGold and type(dsGold) == "number" and dsGold >= 0 then
        return dsGold
    end

    -- 3. LocalPlayer Data / leaderstats ValueBase
    for _, fName in ipairs({"Data", "leaderstats", "PlayerData", "Stats"}) do
        local dFolder = LocalPlayer:FindFirstChild(fName)
        if dFolder then
            for _, gName in ipairs({"Gold", "Coins", "Money", "Cash"}) do
                local gVal = dFolder:FindFirstChild(gName)
                if gVal and gVal:IsA("ValueBase") and tonumber(gVal.Value) ~= nil then
                    return tonumber(gVal.Value)
                end
            end
        end
    end

    -- 4. Strictly Scoped TopBar HUD TextLabel (Excludes Shop, Products, Gamepasses, Upgrades)
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in ipairs(pGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "CUPIEUI" and gui.Enabled then
                local gName = gui.Name:lower()
                if not gName:find("shop") and not gName:find("pass") and not gName:find("product") and not gName:find("upgr") and not gName:find("trade") then
                    for _, lbl in ipairs(gui:GetDescendants()) do
                        if lbl:IsA("TextLabel") and lbl.Visible then
                            local lName = lbl.Name:lower()
                            local pName = (lbl.Parent and lbl.Parent.Name:lower()) or ""
                            if not pName:find("shop") and not pName:find("product") and not pName:find("cost") and not pName:find("price") then
                                if (lName == "gold" or lName == "coins" or lName == "money" or pName == "gold" or pName == "coins") and lbl.Text:match("%d") then
                                    local parsed = parseFormattedNumber(lbl.Text)
                                    if parsed >= 0 then return parsed end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return 0
end


local function getStandTargetInfo(model)
    if not model or not model:IsA("Model") then return nil end
    local uName = model.Name
    local cleanName = uName:lower():gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " "):match("^%s*(.-)%s*$")
    
    local foundRarity = nil
    local foundMutation = nil
    local foundPrice = nil
    local foundCharName = nil

    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("TextLabel") and desc.Visible then
            local txt = desc.Text:lower():match("^%s*(.-)%s*$") or ""
            
            -- Read Price from Billboard (e.g. "$400", "$1,200", "$350K")
            local priceMatch = desc.Text:match("%$%s*([%d%,%.%a]+)") or desc.Text:match("([%d%,%.%a]+)%s*[Gg]old")
            if priceMatch then
                foundPrice = parseFormattedNumber(priceMatch)
            end

            -- Read Mutation from Billboard
            if txt:find("gold") then foundMutation = "Gold"
            elseif txt:find("diamond") then foundMutation = "Diamond"
            elseif txt:find("astronaut") or txt:find("cosmic") then foundMutation = "Astronaut"
            elseif txt:find("demon") then foundMutation = "Demon"
            elseif txt:find("destroyer") then foundMutation = "Destroyer"
            elseif txt:find("hollow") then foundMutation = "Hollow"
            elseif txt:find("slayer") then foundMutation = "Slayer"
            elseif txt:find("cursed") then foundMutation = "Cursed"
            end
            
            -- Read Rarity from Billboard
            if InGameRarities then
                for _, rName in pairs(InGameRarities) do
                    if txt == rName:lower() or txt:find("^" .. rName:lower() .. "$") or txt:find(rName:lower()) then
                        foundRarity = rName
                        break
                    end
                end
            end
            
            if CharacterRarities and (CharacterRarities[txt] or CharacterRarities[txt:gsub("[%[%]%(%)%_%-%.%#]", "")]) then
                foundCharName = txt
            end
        end
    end

    local attrR = model:GetAttribute("Rarity") or model:GetAttribute("Tier")
    local finalRarity = foundRarity or attrR or (foundCharName and CharacterRarities and CharacterRarities[foundCharName]) or (CharacterRarities and CharacterRarities[cleanName]) or (CachedModuleRarities and CachedModuleRarities[cleanName]) or "Common"
    
    local attrM = model:GetAttribute("Mutation") or model:GetAttribute("Mutations") or model:GetAttribute("Variant")
    local mutChild = model:FindFirstChild("Mutation") or model:FindFirstChild("Gold") or model:FindFirstChild("Diamond") or model:FindFirstChild("Astronaut")
    local finalMutation = foundMutation or (attrM and tostring(attrM)) or (mutChild and mutChild.Name) or (model.Name:lower():find("gold") and "Gold") or (model.Name:lower():find("astronaut") and "Astronaut") or nil

    local cost = foundPrice or getCharacterCost(cleanName, finalMutation)
    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)

    return {
        Model = model,
        Name = uName,
        CleanName = cleanName,
        Rarity = finalRarity,
        Mutation = finalMutation,
        Cost = cost,
        Prompt = prompt
    }
end



-- ══════════════════════════════════════════════════════════
-- DEDICATED STAND TARGET DISCOVERY & BUY ENGINE
-- ══════════════════════════════════════════════════════════

local function checkUnitMatchesFilter(unitName, unitRarity, unitMutation)
    local rPass = false
    local mPass = false

    -- 1. Check Multi-Selected Rarities
    if Config.SelectedBuyRarities and type(Config.SelectedBuyRarities) == "table" then
        for rName, enabled in pairs(Config.SelectedBuyRarities) do
            if enabled and unitRarity and (unitRarity:lower() == rName:lower() or unitRarity:lower():find(rName:lower())) then
                rPass = true
                break
            end
        end
    end

    -- 2. Check Multi-Selected Mutations
    local mutStr = tostring(unitMutation or ""):lower()
    if mutStr ~= "" and mutStr ~= "nil" and mutStr ~= "none" then
        if Config.SelectedBuyMutations and type(Config.SelectedBuyMutations) == "table" then
            for mName, enabled in pairs(Config.SelectedBuyMutations) do
                if enabled and (mutStr:find(mName:lower()) or (mName:lower() == "astronaut" and mutStr:find("cosmic"))) then
                    mPass = true
                    break
                end
            end
        end
    end

    local anyRaritySelected = false
    if Config.SelectedBuyRarities then
        for _, v in pairs(Config.SelectedBuyRarities) do if v then anyRaritySelected = true break end end
    end
    local anyMutationSelected = false
    if Config.SelectedBuyMutations then
        for _, v in pairs(Config.SelectedBuyMutations) do if v then anyMutationSelected = true break end end
    end

    if anyRaritySelected and anyMutationSelected then
        return rPass or mPass
    elseif anyRaritySelected then
        return rPass
    elseif anyMutationSelected then
        return mPass
    else
        return true
    end
end

local function getMatchingStandTargets()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local myPlot = getMyPlot()

    local candidateModels = {}
    if myPlot then
        local charFolder = myPlot:FindFirstChild("Characters") or myPlot:FindFirstChild("Stands") or myPlot:FindFirstChild("Roll")
        if charFolder then
            for _, m in ipairs(charFolder:GetChildren()) do
                if m:IsA("Model") and m ~= char then
                    table.insert(candidateModels, m)
                end
            end
        end
    end
    
    if #candidateModels == 0 and root then
        for _, m in ipairs(Workspace:GetChildren()) do
            if m:IsA("Model") and m ~= char and m.Name ~= "Terrain" then
                local mRoot = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
                if mRoot and (mRoot.Position - root.Position).Magnitude < 45 then
                    table.insert(candidateModels, m)
                end
            end
        end
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, p in ipairs(plots:GetChildren()) do
                local cFolder = p:FindFirstChild("Characters") or p:FindFirstChild("Stands")
                if cFolder then
                    for _, m in ipairs(cFolder:GetChildren()) do
                        if m:IsA("Model") and m ~= char then
                            local mRoot = m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart
                            if mRoot and (mRoot.Position - root.Position).Magnitude < 45 then
                                table.insert(candidateModels, m)
                            end
                        end
                    end
                end
            end
        end
    end

    table.sort(candidateModels, function(a, b)
        local pA = a:GetPivot().Position
        local pB = b:GetPivot().Position
        return (pA.X + pA.Z) < (pB.X + pB.Z)
    end)

    local matching = {}
    for slotIdx, model in ipairs(candidateModels) do
        local info = getStandTargetInfo(model)
        if info and checkUnitMatchesFilter(info.Name, info.Rarity, info.Mutation) then
            info.SlotIdx = slotIdx
            table.insert(matching, info)
        end
    end
    return matching
end

local function buyStandTarget(target)
    if not target or not target.Model or not target.Model.Parent then return end
    
    local curGold = getCurrentPlayerGold()
    local cost = target.Cost or 200
    if curGold < cost then
        return false
    end
    
    if not CharactersBuy then
        pcall(function()
            CharactersBuy = ReplicatedStorage:FindFirstChild("Remotes") 
                and ReplicatedStorage.Remotes:FindFirstChild("Characters") 
                and ReplicatedStorage.Remotes.Characters:FindFirstChild("Buy")
        end)
    end

    -- Use exact verified pattern from Spy Log: Characters.Buy:FireServer(tier, slot)
    if CharactersBuy then
        local tier = 1
        if target.Rarity then
            local r = target.Rarity:lower()
            if r == "common" or r == "rare" then tier = 1
            elseif r == "epic" then tier = 2
            elseif r == "legendary" or r == "mythic" then tier = 3
            elseif r == "secret" or r == "god" or r == "limited" then tier = 4
            end
        end
        local slot = target.SlotIdx or 1
        pcall(function() CharactersBuy:FireServer(tier, slot) end)
    end
    
    return true
end

local function executeSmartAutoBuy()
    local targets = getMatchingStandTargets()
    for _, target in ipairs(targets) do
        local curGold = getCurrentPlayerGold()
        local cost = target.Cost or 200
        if curGold >= cost then
            buyStandTarget(target)
            task.wait(0.08)
        end
    end
    return #targets
end


-- Auto Upgrade Stats Loop (Verified from foranimell.lua: Upgrade:FireServer("Gold", "Luck" / "Inventory" / "Gold" / "Slots"))
local function executeStatUpgrades()
    if not GeneralUpgrade then return end
    if Config.AutoUpgradeLuck then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Luck") end)
    end
    if Config.AutoUpgradeInventory then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Inventory") end)
    end
    if Config.AutoUpgradeGold then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Gold") end)
    end
    if Config.AutoUpgradeSlots then
        pcall(function() GeneralUpgrade:FireServer("Gold", "Slots") end)
    end
end

-- Anti-AFK Handler
pcall(function()
    if getconnections and LocalPlayer then
        for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
            if conn.Disable then conn:Disable()
            elseif conn.Disconnect then conn:Disconnect() end
        end
    end
    if LocalPlayer then
        LocalPlayer.Idled:Connect(function()
            if Config.AntiAFK and VirtualUser then
                pcall(function()
                    local cam = workspace.CurrentCamera
                    local cf = cam and cam.CFrame or CFrame.new()
                    VirtualUser:Button2Down(Vector2.new(0, 0), cf)
                    task.wait(0.2)
                    VirtualUser:Button2Up(Vector2.new(0, 0), cf)
                end)
            end
        end)
    end
end)

-- Noclip Stepped Handler
Cupie:AddConnection(RunService.Stepped:Connect(function()
    if Config.Noclip then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- ══════════════════════════════════════════════════════════
-- CREATE WINDOW
-- ══════════════════════════════════════════════════════════
local Window = Cupie:CreateWindow({
    Title    = "CUPIE HUB",
    Subtitle = "Roll Anime To Fight - v1.0",
    Keybind  = Enum.KeyCode.RightControl
})

-- ══════════════════════════════════════════════════════════
-- TAB 1: DASHBOARD & STATS (GOLD HIGHLIGHT & RARITY INVENTORY ONLY)
-- ══════════════════════════════════════════════════════════
local DashTab = Window:CreateTab("Stats", 1)

DashTab:CreateHeader("GOLD & TREASURY", 1)

-- Highlighted Gold Balance Card
local goldPara = DashTab:CreateParagraph({
    Title = "GOLD BALANCE",
    Content = "Scanning Gold balance...",
    LayoutOrder = 2
})

DashTab:CreateHeader("OTHER CURRENCIES & SESSION", 3)

local curPara = DashTab:CreateParagraph({
    Title = "Account Currencies",
    Content = "Scanning currencies...",
    LayoutOrder = 4
})

DashTab:CreateHeader("CHARACTER INVENTORY BY RARITY", 5)

local invRarityPara = DashTab:CreateParagraph({
    Title = "Owned Characters Breakdown",
    Content = "Scanning character inventory...",
    LayoutOrder = 6
})

DashTab:CreateHeader("CHARACTER MUTATIONS (SPECIAL VARIANTS)", 7)

local mutPara = DashTab:CreateParagraph({
    Title = "Owned Mutations (0 Total)",
    Content = "Scanning mutations...",
    LayoutOrder = 8
})

-- ══════════════════════════════════════════════════════════
-- INSTANT REAL-TIME STATS & INVENTORY ENGINE (ZERO-LAG)
-- ══════════════════════════════════════════════════════════

-- Known Character Rarity Dictionary (Instant O(1) Lookup, No require hang)
-- ══════════════════════════════════════════════════════════
-- ══════════════════════════════════════════════════════════
local function getPlayerCurrencies()
    local gold = nil
    local gems = nil
    local wins = nil
    
    -- 1. Direct Leaderstats check
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, child in ipairs(ls:GetChildren()) do
            local n = child.Name:lower()
            local val = tostring(child.Value or (child:IsA("ValueBase") and child.Value) or "")
            if val ~= "" and val ~= "nil" then
                if n:find("gold") or n:find("coin") or n:find("money") or n:find("cash") then
                    gold = val
                elseif n:find("gem") or n:find("diamond") then
                    gems = val
                elseif n:find("win") or n:find("level") or n:find("stage") or n:find("wave") then
                    wins = val
                end
            end
        end
    end
    
    -- 2. Direct Player Attributes check
    if not gold or not gems or not wins then
        local attrs = LocalPlayer:GetAttributes()
        for k, v in pairs(attrs) do
            local n = tostring(k):lower()
            local val = tostring(v)
            if val ~= "" and val ~= "nil" then
                if not gold and (n:find("gold") or n:find("coin") or n:find("money") or n:find("cash")) then
                    gold = val
                elseif not gems and (n:find("gem") or n:find("diamond")) then
                    gems = val
                elseif not wins and (n:find("win") or n:find("level") or n:find("stage") or n:find("wave")) then
                    wins = val
                end
            end
        end
    end
    
    -- 3. Direct Data / PlayerData folder check
    if not gold or not gems or not wins then
        local df = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:FindFirstChild("Stats")
        if df then
            for _, child in ipairs(df:GetChildren()) do
                local n = child.Name:lower()
                local val = tostring(child.Value or (child:IsA("ValueBase") and child.Value) or "")
                if val ~= "" and val ~= "nil" then
                    if not gold and (n:find("gold") or n:find("coin") or n:find("money") or n:find("cash")) then
                        gold = val
                    elseif not gems and (n:find("gem") or n:find("diamond")) then
                        gems = val
                    elseif not wins and (n:find("win") or n:find("level") or n:find("stage") or n:find("wave")) then
                        wins = val
                    end
                end
            end
            for k, v in pairs(df:GetAttributes()) do
                local n = tostring(k):lower()
                local val = tostring(v)
                if not gold and (n:find("gold") or n:find("coin") or n:find("money")) then gold = val
                elseif not gems and (n:find("gem") or n:find("diamond")) then gems = val
                elseif not wins and (n:find("win") or n:find("level") or n:find("stage")) then wins = val
                end
            end
        end
    end

    -- 4. Direct Fast UI Checks
    if not gold or gold == "0" then
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            local mainGui = pGui:FindFirstChild("MainGui") or pGui:FindFirstChild("ScreenGui") or pGui:FindFirstChild("HUD") or pGui:FindFirstChild("Main")
            if mainGui then
                for _, ch in ipairs(mainGui:GetChildren()) do
                    if ch:IsA("Frame") or ch:IsA("TextLabel") then
                        local n = ch.Name:lower()
                        if ch:IsA("TextLabel") and ch.Text:match("%d") then
                            if n:find("gold") or n:find("coin") then gold = ch.Text end
                            if n:find("gem") or n:find("diamond") then gems = ch.Text end
                            if n:find("win") or n:find("level") then wins = ch.Text end
                        end
                    end
                end
            end
        end
    end
    
    return tostring(gold or "0"), tostring(gems or "0"), tostring(wins or "0")
end


-- PURE DATA-DRIVEN INVENTORY SCANNER (ZERO FALSE POSITIVES)
-- ══════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════
-- PURE DATA-DRIVEN INVENTORY & MUTATION SCANNER (ZERO FALSE POSITIVES)
-- ══════════════════════════════════════════════════════════

local function scanPlayerCharacterInventory()
    local rarityCounts = {
        ["Limited"]   = 0,
        ["INVASION"]  = 0,
        ["OG"]        = 0,
        ["OP"]        = 0,
        ["Immortal"]  = 0,
        ["Divine"]    = 0,
        ["Secret"]    = 0,
        ["Godlyx"]    = 0,
        ["Godly"]     = 0,
        ["God"]       = 0,
        ["Mythic"]    = 0,
        ["Legendary"] = 0,
        ["Epic"]      = 0,
        ["Rare"]      = 0,
        ["Common"]    = 0
    }
    
    local mutationCounts = {
        ["Gold"]       = 0,
        ["Diamond"]    = 0,
        ["Demon"]      = 0,
        ["Destroyer"]  = 0,
        ["Hollow"]     = 0,
        ["Slayer"]     = 0,
        ["Cursed"]     = 0,
        ["Astronaut"]  = 0
    }
    
    local totalChars = 0
    local totalMutations = 0
    local seenUIDs = {}

    local function resolveRarity(rawName, explicitRarity)
        if explicitRarity and rarityCounts[explicitRarity] then
            return explicitRarity
        end
        if explicitRarity and type(explicitRarity) == "string" then
            for rName in pairs(rarityCounts) do
                if explicitRarity:lower() == rName:lower() then
                    return rName
                end
            end
        end

        local nClean = tostring(rawName or ""):lower():gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " ")
        local nTrim = nClean:match("^%s*(.-)%s*$") or ""
        if nTrim == "" then return nil end

        -- 1. Check live game module cache from CharactersInfo
        if CachedModuleRarities and CachedModuleRarities[nTrim] and rarityCounts[CachedModuleRarities[nTrim]] then
            return CachedModuleRarities[nTrim]
        end

        -- 2. Check exact character dictionary
        if CharacterRarities and CharacterRarities[nTrim] and rarityCounts[CharacterRarities[nTrim]] then
            return CharacterRarities[nTrim]
        end

        -- 3. Check clean substring in dictionary
        if CharacterRarities then
            for charKey, rVal in pairs(CharacterRarities) do
                if (nTrim == charKey or nTrim:find("^" .. charKey .. "$") or nTrim:find(charKey, 1, true)) and rarityCounts[rVal] then
                    return rVal
                end
            end
        end

        return "Common"
    end

    local function resolveMutation(rawMut)
        if not rawMut then return nil end
        local mStr = tostring(rawMut):lower()
        if mStr:find("gold") then return "Gold"
        elseif mStr:find("diamond") then return "Diamond"
        elseif mStr:find("demon") then return "Demon"
        elseif mStr:find("destroyer") then return "Destroyer"
        elseif mStr:find("hollow") then return "Hollow"
        elseif mStr:find("slayer") then return "Slayer"
        elseif mStr:find("cursed") then return "Cursed"
        elseif mStr:find("astronaut") or mStr:find("cosmic") then return "Astronaut"
        end
        return nil
    end

    local function addChar(name, explicitRarity, uid, explicitMutation)
        if not name or name == "" then return end
        if uid then
            if seenUIDs[uid] then return end
            seenUIDs[uid] = true
        end

        local raw = tostring(name):lower()
        local nClean = raw:gsub("lv%s*%.?%s*%d+", ""):gsub("%d+", ""):gsub("[%[%]%(%)%_%-%.%#]", " ")
        local nTrim = nClean:match("^%s*(.-)%s*$") or ""
        
        -- Filter out non-character words
        if nTrim == "" or nTrim == "gold" or nTrim == "level" or nTrim == "slot" or nTrim == "button" or nTrim == "image" or nTrim == "frame" or nTrim == "pass" or nTrim == "shop" or nTrim == "index" or nTrim == "trade" or nTrim == "items" or nTrim == "animes" or nTrim == "profile" or nTrim == "upgr" or nTrim == "upgrades" or nTrim == "boost" then
            return
        end
        
        local finalRarity = resolveRarity(nTrim, explicitRarity)
        if finalRarity and rarityCounts[finalRarity] then
            totalChars = totalChars + 1
            rarityCounts[finalRarity] = rarityCounts[finalRarity] + 1
        end

        local finalMut = resolveMutation(explicitMutation) or resolveMutation(raw)
        if finalMut and mutationCounts[finalMut] then
            totalMutations = totalMutations + 1
            mutationCounts[finalMut] = mutationCounts[finalMut] + 1
        end
    end

    local foundFromData = false

    -- 1. Direct DataService Profile Access (Bag + Hotbar Profile)
    pcall(function()
        local dataServMod = ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("DataService")
        if dataServMod then
            local ds = require(dataServMod)
            local client = (type(ds) == "table" and (ds.client or ds.Client or ds)) or ds
            
            for _, key in ipairs({"Inventory", "Characters", "Hotbar", "Units", "Equipped"}) do
                local invList = nil
                pcall(function() invList = client:get(LocalPlayer, {key}) end)
                if not invList then pcall(function() invList = client:get({key}) end) end
                if not invList then pcall(function() invList = ds:get(LocalPlayer, {key}) end) end
                if not invList and client.Data then invList = client.Data[key] end
                if not invList and client.Profile then invList = client.Profile[key] end
                
                if type(invList) == "table" and next(invList) ~= nil then
                    foundFromData = true
                    for k, v in pairs(invList) do
                        if type(v) == "table" then
                            local cName = v.Name or v.CharacterName or v.Id or tostring(k)
                            local cRarity = v.Rarity or v.Tier
                            local cMut = v.Mutation or v.Mutations or v.Variant or v.Shiny
                            local cUID = v.UUID or v.UID or (key .. "_" .. tostring(k))
                            addChar(cName, cRarity, cUID, cMut)
                        elseif type(v) == "string" then
                            addChar(v, nil, key .. "_" .. tostring(k), nil)
                        end
                    end
                end
            end
        end
    end)

    -- 2. LocalPlayer Data / PlayerData Folders
    pcall(function()
        local dataFolder = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData")
        if dataFolder then
            for _, folderName in ipairs({"Inventory", "Characters", "Hotbar", "Units", "Equipped"}) do
                local sub = dataFolder:FindFirstChild(folderName)
                if sub and #sub:GetChildren() > 0 then
                    foundFromData = true
                    for _, item in ipairs(sub:GetChildren()) do
                        local attrR = item:GetAttribute("Rarity") or item:GetAttribute("Tier")
                        local attrM = item:GetAttribute("Mutation") or item:GetAttribute("Mutations") or item:GetAttribute("Variant") or item:GetAttribute("Shiny")
                        local rChild = item:FindFirstChild("Rarity") or item:FindFirstChild("Tier")
                        local mChild = item:FindFirstChild("Mutation") or item:FindFirstChild("Mutations")
                        local rVal = (attrR and type(attrR) == "string" and attrR) or (rChild and rChild:IsA("ValueBase") and tostring(rChild.Value)) or nil
                        local mVal = (attrM and type(attrM) == "string" and attrM) or (mChild and mChild:IsA("ValueBase") and tostring(mChild.Value)) or nil
                        local itemUID = item:GetAttribute("UUID") or ("df_" .. item:GetFullName())
                        addChar(item.Name, rVal, itemUID, mVal)
                    end
                end
            end
        end
    end)

    -- 3. LocalPlayer Direct Storage Folders
    pcall(function()
        for _, folderName in ipairs({"Inventory", "Characters", "Hotbar", "Units", "Equipped"}) do
            local sub = LocalPlayer:FindFirstChild(folderName)
            if sub and #sub:GetChildren() > 0 then
                foundFromData = true
                for _, item in ipairs(sub:GetChildren()) do
                    local attrR = item:GetAttribute("Rarity") or item:GetAttribute("Tier")
                    local attrM = item:GetAttribute("Mutation") or item:GetAttribute("Mutations") or item:GetAttribute("Variant")
                    local rChild = item:FindFirstChild("Rarity") or item:FindFirstChild("Tier")
                    local mChild = item:FindFirstChild("Mutation") or item:FindFirstChild("Mutations")
                    local rVal = (attrR and type(attrR) == "string" and attrR) or (rChild and rChild:IsA("ValueBase") and tostring(rChild.Value)) or nil
                    local mVal = (attrM and type(attrM) == "string" and attrM) or (mChild and mChild:IsA("ValueBase") and tostring(mChild.Value)) or nil
                    local itemUID = item:GetAttribute("UUID") or ("lp_" .. item:GetFullName())
                    addChar(item.Name, rVal, itemUID, mVal)
                end
            end
        end
    end)

    -- 4. Bottom Hotbar Slots in PlayerGui
    pcall(function()
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, g in ipairs(pGui:GetChildren()) do
                if g:IsA("ScreenGui") and g.Name ~= "CUPIEUI" and g.Enabled then
                    for _, desc in ipairs(g:GetDescendants()) do
                        if (desc:IsA("Frame") or desc:IsA("ImageLabel")) and (desc.Name:lower():find("slot") or desc.Name:match("^%d+$")) then
                            local lvLabel = nil
                            local nameLabel = nil
                            local mutLabel = nil
                            for _, ch in ipairs(desc:GetChildren()) do
                                if ch:IsA("TextLabel") and ch.Visible then
                                    local txt = ch.Text:lower()
                                    if txt:find("lv") or txt:match("^%d+$") then
                                        lvLabel = ch
                                    elseif CharacterRarities and (CharacterRarities[txt] or CharacterRarities[txt:match("^%s*(.-)%s*$")]) then
                                        nameLabel = ch
                                    elseif txt:find("gold") or txt:find("diamond") or txt:find("demon") or txt:find("destroyer") or txt:find("hollow") or txt:find("slayer") or txt:find("cursed") or txt:find("astronaut") then
                                        mutLabel = ch.Text
                                    end
                                end
                            end
                            if lvLabel and nameLabel then
                                local slotUID = "hotbar_slot_" .. desc:GetFullName()
                                local slotMut = desc:GetAttribute("Mutation") or mutLabel or (desc.Name:lower():find("gold") and "Gold")
                                addChar(nameLabel.Text, desc:GetAttribute("Rarity"), slotUID, slotMut)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return rarityCounts, totalChars, mutationCounts, totalMutations
end


-- Live Stats Updater Loop
local function updateDashboardStats(startTime)
    local goldStr, gemsStr, winsStr = getPlayerCurrencies()
    local elapsed = os.time() - (startTime or os.time())
    local hrs = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    local timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
    
    local formattedGold = formatNumberWithCommas(goldStr or "0")
    
    -- 1. Prominent Gold Display Card
    if goldPara then
        goldPara:SetTitle("GOLD: " .. formattedGold)
        goldPara:SetContent("Current Available Balance: " .. formattedGold .. " Gold Coins")
    end
    
    -- 2. Other Currencies Card
    if curPara then
        local dName = (LocalPlayer and LocalPlayer.DisplayName) or "Player"
        local uName = (LocalPlayer and LocalPlayer.Name) or "User"
        curPara:SetTitle(dName .. " (@" .. uName .. ")")
        curPara:SetContent(string.format(
            "• Gems (Diamonds) : %s\n" ..
            "• Wins / Level    : %s\n" ..
            "• Farm Duration   : %s",
            formatNumberWithCommas(gemsStr or "0"),
            tostring(winsStr or "0"),
            tostring(timeStr)
        ))
    end
    
    -- 3. Characters Count by Rarity & Mutations
    local rCounts, totalCount, mCounts, totalMutations = scanPlayerCharacterInventory()
    rCounts = rCounts or {}
    totalCount = totalCount or 0
    mCounts = mCounts or {}
    totalMutations = totalMutations or 0
    
    if invRarityPara then
        invRarityPara:SetTitle(string.format("Owned Characters (%d Total)", totalCount))
        invRarityPara:SetContent(string.format(
            "• Limited   : %d  |  INVASION : %d  |  OG       : %d\n" ..
            "• OP        : %d  |  Immortal : %d  |  Divine   : %d\n" ..
            "• Secret    : %d  |  Godlyx   : %d  |  Godly    : %d\n" ..
            "• God       : %d  |  Mythic   : %d  |  Legendary: %d\n" ..
            "• Epic      : %d  |  Rare     : %d  |  Common   : %d",
            rCounts["Limited"] or 0, rCounts["INVASION"] or 0, rCounts["OG"] or 0,
            rCounts["OP"] or 0, rCounts["Immortal"] or 0, rCounts["Divine"] or 0,
            rCounts["Secret"] or 0, rCounts["Godlyx"] or 0, rCounts["Godly"] or 0,
            rCounts["God"] or 0, rCounts["Mythic"] or 0, rCounts["Legendary"] or 0,
            rCounts["Epic"] or 0, rCounts["Rare"] or 0, rCounts["Common"] or 0
        ))
    end
    
    -- 4. Mutations Count Card
    if mutPara then
        mutPara:SetTitle(string.format("Owned Mutations (%d Total)", totalMutations))
        mutPara:SetContent(string.format(
            "• Gold       : %d  |  Diamond   : %d  |  Demon     : %d\n" ..
            "• Destroyer  : %d  |  Hollow    : %d  |  Slayer    : %d\n" ..
            "• Cursed     : %d  |  Astronaut : %d",
            mCounts["Gold"] or 0, mCounts["Diamond"] or 0, mCounts["Demon"] or 0,
            mCounts["Destroyer"] or 0, mCounts["Hollow"] or 0, mCounts["Slayer"] or 0,
            mCounts["Cursed"] or 0, mCounts["Astronaut"] or 0
        ))
    end
end

-- Run immediate first update + continuous 1-second refresh
task.spawn(function()
    local startTime = os.time()
    updateDashboardStats(startTime)
    while true do
        task.wait(2.0)
        pcall(function()
            updateDashboardStats(startTime)
        end)
    end
end)

-- Load saved user preferences if available
loadConfig()

Log("Success", "CUPIE HUB v2.0 Loaded Successfully!")
Log("Info", "AutoRoll: %s, AutoBuy: %s, AutoSell: %s", 
    tostring(Config.AutoRoll), 
    tostring(Config.AutoBuyByRarity),
    tostring(Config.AutoSellLowTier))



-- ══════════════════════════════════════════════════════════
-- UNIFIED MASTER AUTO ROLL & FUND-LOCK STEP FUNCTION
-- ══════════════════════════════════════════════════════════

local function performAutoRollStep()
    if not Config.AutoRoll then return end

    -- STEP 1: Smart Auto Buy with Random Wait
    if Config.AutoBuyByRarity then
        local targets = getMatchingStandTargets()
        
        if #targets > 0 then
            for _, target in ipairs(targets) do
                local requiredCost = target.Cost or 200
                local curGold = getCurrentPlayerGold()
                
                local waitCount = 0
                while Config.AutoRoll and Config.AutoBuyByRarity and target.Model and target.Model.Parent and getCurrentPlayerGold() < requiredCost do
                    task.wait(randomDelay(0.4, 0.2))
                    waitCount = waitCount + 1
                    if waitCount >= 15 then
                        Log("Warning", "Waiting for Gold (%d / %d) to buy %s...", getCurrentPlayerGold(), requiredCost, target.Name or "Unit")
                        waitCount = 0
                    end
                end
                
                if target.Model and target.Model.Parent and getCurrentPlayerGold() >= requiredCost then
                    buyStandTarget(target)
                    task.wait(randomDelay(0.15, 0.1))
                end
            end
        end
        
        local remaining = getMatchingStandTargets()
        for _, t in ipairs(remaining) do
            if getCurrentPlayerGold() < (t.Cost or 200) then
                return
            end
        end
    end

    if not Config.AutoRoll then return end

    -- STEP 2: Trigger Roll
    local plot = getMyPlot()
    local prompt, btn = getPlotRollPrompt(plot)
    if prompt then
        firePrompt(prompt)
    elseif CharactersRoll then
        pcall(function() CharactersRoll:FireServer() end)
    end

    -- STEP 3: Wait for new roll animation
    task.wait(randomDelay(0.3, 0.1))

    -- STEP 4: Inspect new roll and buy immediately
    if Config.AutoBuyByRarity then
        local newTargets = getMatchingStandTargets()
        for _, target in ipairs(newTargets) do
            local cost = target.Cost or 200
            if getCurrentPlayerGold() >= cost then
                buyStandTarget(target)
                task.wait(randomDelay(0.08, 0.05))
            end
        end
    end

    -- STEP 5: Auto Pickup All (ถ้าเปิด)
    if Config.AutoPickupAll then
        autoPickupAll()
    end

    -- STEP 6: Wait user configured Roll Delay + Random Variance
    task.wait(randomDelay(math.max(1.5, Config.RollDelay), 0.3))
end

-- TAB 2: GACHA & SUMMON ENGINE (ระบบสุ่ม & ซื้อ/ขาย/ล็อคตามระดับ)
-- ══════════════════════════════════════════════════════════
local GachaTab = Window:CreateTab("Gacha", 2)
GachaTab:CreateToggle({
    Name = "Auto Roll (Fast Summon)",
    Description = "Automatically triggers roll proximity prompt and remote without stuttering",
    Badge = "HOT",
    Default = false,
    Callback = function(state)
        Config.AutoRoll = state
        if state then
            smoothPositionToRollPad()
            Cupie:StartLoop("AutoRollLoop", 0.3, function()
                performAutoRollStep()
            end)
        else
            Cupie:StopLoop("AutoRollLoop")
        end
    end
})

GachaTab:CreateSlider({
    Name = "Roll Speed / Delay",
    Description = "Interval between each roll attempt (seconds, min 2.0s)",
    Min = 2.0,
    Max = 8.0,
    Default = 2.5,
    Step = 0.1,
    Decimals = 1,
    Suffix = "s",
    Callback = function(val)
        Config.RollDelay = math.max(2.0, val)
    end
})

GachaTab:CreateHeader("AUTO BUY & FILTER CRITERIA", 3)

GachaTab:CreateMultiDropdown({
    Name = "Auto Buy - Rarity Filter (Multi-Select)",
    Description = "Select multiple specific Rarities to automatically buy",
    Options = {
        "Common",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Secret",
        "God",
        "Limited",
        "Godly",
        "Godlyx",
        "Divine",
        "Immortal",
        "OP",
        "OG",
        "INVASION"
    },
    Default = {
        ["Common"]    = true,
        ["Rare"]      = true,
        ["Epic"]      = true,
        ["Legendary"] = true,
        ["Mythic"]    = true,
        ["Secret"]    = true,
        ["God"]       = true,
        ["Limited"]   = true
    },
    Callback = function(selectedMap)
        Config.SelectedBuyRarities = selectedMap
    end
})

GachaTab:CreateMultiDropdown({
    Name = "Auto Buy - Mutation Filter (Multi-Select)",
    Description = "Select multiple specific Mutations to automatically buy",
    Options = {
        "Gold",
        "Astronaut",
        "Diamond",
        "Demon",
        "Destroyer",
        "Hollow",
        "Slayer",
        "Cursed"
    },
    Default = {
        ["Gold"]      = true,
        ["Astronaut"] = true
    },
    Callback = function(selectedMap)
        Config.SelectedBuyMutations = selectedMap
    end
})

GachaTab:CreateToggle({
    Name = "Enable Smart Auto Buy",
    Description = "Continuously buys characters matching your Rarity & Mutation criteria",
    Badge = "BUY",
    Default = false,
    Callback = function(state)
        Config.AutoBuyByRarity = state
        if state then
            Cupie:StartLoop("AutoBuyRarityLoop", 0.5, function()
                if not Config.AutoRoll then
                    executeSmartAutoBuy()
                end
            end)
        else
            Cupie:StopLoop("AutoBuyRarityLoop")
        end
    end
})

GachaTab:CreateMultiDropdown({
    Name = "Auto Sell - Rarity Filter (Multi-Select)",
    Description = "Select specific Rarities to automatically sell for Gold",
    Options = {
        "Common",
        "Rare",
        "Epic",
        "Legendary",
        "Mythic",
        "Secret",
        "God",
        "Limited"
    },
    Default = Config.SelectedSellRarities,
    Callback = function(selMap)
        Config.SelectedSellRarities = selMap
    end
})

GachaTab:CreateToggle({
    Name = "Auto Delete / Sell Low Tier",
    Description = "Scans inventory and sells units below selected rarity for Gold",
    Badge = "SELL",
    Default = false,
    Callback = function(state)
        Config.AutoSellLowTier = state
        if state then
            Cupie:StartLoop("AutoSellLoop", 2.0, function()
                executeAutoSell()
            end)
        else
            Cupie:StopLoop("AutoSellLoop")
        end
    end
})

GachaTab:CreateToggle({
    Name = "Auto Spin Wheel (Silent)",
    Description = "Spins wheel continuously without popup notifications",
    Badge = "FREE",
    Default = false,
    Callback = function(state)
        Config.AutoSpinWheel = state
        if state then
            cleanAllExistingNotifications()
            Cupie:StartLoop("AutoSpinLoop", 3.5, function()
                if SpinRemote then
                    SpinRemote:FireServer("Spin")
                    task.wait(1.2)
                    SpinRemote:FireServer("Complete", {})
                    cleanAllExistingNotifications()
                end
            end)
        else
            Cupie:StopLoop("AutoSpinLoop")
        end
    end
})

GachaTab:CreateToggle({
    Name = "Hide All Screen Popups (ป้ายชื่อ)",
    Description = "Blocks and destroys all center screen notification labels",
    Default = true,
    Callback = function(state)
        Config.HideNotifications = state
        if state then cleanAllExistingNotifications() end
    end
})

GachaTab:CreateButton({
    Name = "Clear Screen Text Now",
    Description = "Instantly clears all stuck labels/popups on your screen",
    Callback = function()
        cleanAllExistingNotifications()
        Cupie:Notify("Screen Cleaned", "Purged all notification popups!", 2.0)
    end
})

-- ══════════════════════════════════════════════════════════
-- TAB 3: 👥 TEAM & STAT UPGRADES (พัฒนาสเตตัส & สุ่ม Trait)
-- ══════════════════════════════════════════════════════════
local UpgradeTab = Window:CreateTab("Upgrades", 3)
UpgradeTab:CreateHeader("Team & Character Progression (Auto Controls)", 1)

UpgradeTab:CreateToggle({
    Name = "Auto Pickup All Units",
    Description = "Automatically picks up all units from plot",
    Badge = "PICKUP",
    Default = false,
    Callback = function(state)
        Config.AutoPickupAll = state
        saveConfig()
        if state then
            Cupie:StartLoop("AutoPickupLoop", 1.5, function()
                autoPickupAll()
            end)
        else
            Cupie:StopLoop("AutoPickupLoop")
        end
    end
})


UpgradeTab:CreateToggle({
    Name = "Auto Equip Best Units",
    Description = "Automatically and continuously keeps your strongest team equipped",
    Badge = "BEST",
    Default = false,
    Callback = function(state)
        Config.AutoEquipBest = state
        if state then
            triggerEquipBest()
            Cupie:StartLoop("AutoEquipBestLoop", 1.5, function() triggerEquipBest() end)
        else
            Cupie:StopLoop("AutoEquipBestLoop")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Level Up Team",
    Description = "Continuously upgrades character levels as Gold is earned",
    Badge = "UPGRADE",
    Default = false,
    Callback = function(state)
        Config.AutoLevelUp = state
        if state then
            Cupie:StartLoop("AutoLevelUpLoop", 1.0, function()
                if CharactersLevelUp then CharactersLevelUp:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoLevelUpLoop")
        end
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Evolve Characters",
    Description = "Automatically evolves characters as soon as requirements are met",
    Badge = "EVOLVE",
    Default = false,
    Callback = function(state)
        Config.AutoEvolve = state
        if state then
            Cupie:StartLoop("AutoEvolveLoop", 3.0, function()
                if EvolutionRemote then EvolutionRemote:FireServer({}) end
            end)
        else
            Cupie:StopLoop("AutoEvolveLoop")
        end
    end
})

UpgradeTab:CreateHeader("Account Stat Upgrades (Verified Remotes)", 5)

UpgradeTab:CreateToggle({
    Name = "Auto Upgrade All Stats (Luck/Bag/Gold/Slots)",
    Description = "Continuously spends Gold to upgrade Luck, Inventory size, Gold multiplier, and Slots",
    Badge = "STATS",
    Default = false,
    Callback = function(state)
        Config.AutoUpgradeStats = state
        if state then
            Cupie:StartLoop("AutoStatsLoop", 1.0, function()
                executeStatUpgrades()
            end)
        else
            Cupie:StopLoop("AutoStatsLoop")
        end
    end
})

UpgradeTab:CreateButton({
    Name = "Upgrade All Stats Once Now",
    Description = "Spends available Gold on all 4 stat upgrades immediately",
    Callback = function()
        executeStatUpgrades()
        Cupie:Notify("Upgrades", "Sent All Stat Upgrade Requests!", 2.0)
    end
})

UpgradeTab:CreateHeader("Character Traits & Progression", 4)

UpgradeTab:CreateToggle({
    Name = "Auto Trait Reroll Loop",
    Description = "Continuously rerolls traits for active unit",
    Default = false,
    Callback = function(state)
        Config.AutoTraitReroll = state
        if state then
            Cupie:StartLoop("AutoTraitLoop", 0.5, function()
                if TraitRemote then TraitRemote:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoTraitLoop")
        end
    end
})

UpgradeTab:CreateButton({
    Name = "Clone Unit Request",
    Description = "Requests character shadow clone",
    Callback = function()
        if CloneRemote then
            CloneRemote:FireServer()
            Cupie:Notify("Clone", "Clone request sent!", 2.0)
        end
    end
})

UpgradeTab:CreateHeader("Manual Shop Purchasing", 7)

UpgradeTab:CreateDropdown({
    Name = "Target Tier",
    Description = "Select which Tier shop to purchase from",
    Options = {"Tier 1 (Starter)", "Tier 2 (Rare)", "Tier 3 (Epic/Legend)", "Tier 4 (Mythic/God)", "All Tiers (1-4)"},
    Default = "Tier 1 (Starter)",
    Callback = function(selected)
        if selected:find("Tier 1") then Config.SelectedTier = 1
        elseif selected:find("Tier 2") then Config.SelectedTier = 2
        elseif selected:find("Tier 3") then Config.SelectedTier = 3
        elseif selected:find("Tier 4") then Config.SelectedTier = 4
        elseif selected:find("All Tiers") then Config.SelectedTier = "All"
        end
    end
})

UpgradeTab:CreateDropdown({
    Name = "Target Slot",
    Description = "Select slot position in shop",
    Options = {"All Slots", "Slot 1", "Slot 2", "Slot 3"},
    Default = "All Slots",
    Callback = function(selected)
        Config.SelectedSlot = selected
    end
})

UpgradeTab:CreateToggle({
    Name = "Continuous Shop Auto Buy",
    Description = "Spams buy for selected tier & slot directly",
    Default = false,
    Callback = function(state)
        Config.AutoBuyTier = state
        if state then
            Cupie:StartLoop("AutoBuyLoop", 0.4, function()
                if not CharactersBuy then return end
                local tiers = (Config.SelectedTier == "All") and {1, 2, 3, 4} or {Config.SelectedTier}
                for _, tier in ipairs(tiers) do
                    if Config.SelectedSlot == "All Slots" then
                        CharactersBuy:FireServer(tier, 1)
                        task.wait(0.08)
                        CharactersBuy:FireServer(tier, 2)
                        task.wait(0.08)
                        CharactersBuy:FireServer(tier, 3)
                    elseif Config.SelectedSlot == "Slot 1" then
                        CharactersBuy:FireServer(tier, 1)
                    elseif Config.SelectedSlot == "Slot 2" then
                        CharactersBuy:FireServer(tier, 2)
                    elseif Config.SelectedSlot == "Slot 3" then
                        CharactersBuy:FireServer(tier, 3)
                    end
                end
            end)
        else
            Cupie:StopLoop("AutoBuyLoop")
        end
    end
})

-- ══════════════════════════════════════════════════════════
-- TAB 4: COMBAT & DUNGEONS
-- ══════════════════════════════════════════════════════════
local CombatTab = Window:CreateTab("Combat", 4)
CombatTab:CreateHeader("Combat Automation & Battle Loop", 1)

CombatTab:CreateToggle({
    Name = "Auto Fight (Infinite Battles)",
    Description = "Automatically starts battles and advances waves continuously",
    Badge = "FARM",
    Default = false,
    Callback = function(state)
        Config.AutoFight = state
        if state then
            Cupie:StartLoop("AutoFightLoop", 1.5, function()
                if FightStart then FightStart:FireServer("AutoPlay") end
                if Config.AutoWaveSkip and FightArrived then FightArrived:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoFightLoop")
            if FightStart then FightStart:FireServer("Stop") end
        end
    end
})

CombatTab:CreateToggle({
    Name = "Fast Attack Aura (Max DPS)",
    Description = "Rapidly executes attack hits for all deployed characters",
    Badge = "DPS",
    Default = false,
    Callback = function(state)
        Config.FastAttackAura = state
        if state then
            Cupie:StartLoop("AutoAttackLoop", Config.AttackSpeed, function()
                if FlexAttack then FlexAttack:FireServer() end
            end)
        else
            Cupie:StopLoop("AutoAttackLoop")
        end
    end
})

CombatTab:CreateSlider({
    Name = "Attack Hit Rate",
    Description = "Interval between attack strikes (seconds)",
    Min = 0.04,
    Max = 0.50,
    Default = 0.08,
    Decimals = 2,
    Suffix = "s",
    Callback = function(val)
        Config.AttackSpeed = val
        if Config.FastAttackAura then
            Cupie:StopLoop("AutoAttackLoop")
            Cupie:StartLoop("AutoAttackLoop", Config.AttackSpeed, function()
                if FlexAttack then FlexAttack:FireServer() end
            end)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Instant Wave Advance (Fight.Arrived)",
    Description = "Skips walk transition time between waves and stages",
    Default = true,
    Callback = function(state)
        Config.AutoWaveSkip = state
    end
})

CombatTab:CreateHeader("Dungeon Modes & Quick Actions", 6)

CombatTab:CreateButton({
    Name = "Join Tower Dungeon",
    Description = "Instantly queues into Tower Dungeon Mode",
    Callback = function()
        if JoinTowerRemote then
            JoinTowerRemote:FireServer()
            Cupie:Notify("Tower", "Joined Tower Dungeon!", 2.5)
        end
    end
})

CombatTab:CreateButton({
    Name = "Teleport to AFK World",
    Description = "Teleports to AFK Rewards World",
    Callback = function()
        if AFKTeleportRemote then
            AFKTeleportRemote:FireServer()
            Cupie:Notify("AFK World", "Teleporting to AFK Area...", 2.5)
        end
    end
})

CombatTab:CreateButton({
    Name = "Emergency Stop Combat",
    Description = "Immediately halts and exits current battle",
    Callback = function()
        if FightStart then
            FightStart:FireServer("Stop")
            Cupie:Notify("Combat", "Combat Stopped!", 2.0)
        end
    end
})

-- ══════════════════════════════════════════════════════════
-- TAB 5: 🎁 QUESTS & FACTIONS
-- ══════════════════════════════════════════════════════════
local MiscTab = Window:CreateTab("Misc", 5)
MiscTab:CreateHeader("Quests, Factions & Free Rewards", 1)

MiscTab:CreateToggle({
    Name = "Auto Claim Battlepass Quests",
    Description = "Continuously claims all completed daily/season quests and levels",
    Default = false,
    Callback = function(state)
        Config.AutoClaimBP = state
        if state then
            Cupie:StartLoop("AutoBPLoop", 2.5, function()
                if BPGetQuestData then BPGetQuestData:InvokeServer() end
                if BPClaimQuest then BPClaimQuest:FireServer() end
                if BPClaimLevel then BPClaimLevel:FireServer() end
                if BPPremiumStatus then BPPremiumStatus:InvokeServer() end
            end)
        else
            Cupie:StopLoop("AutoBPLoop")
        end
    end
})

MiscTab:CreateToggle({
    Name = "Auto Claim Free Group & VIP Rewards",
    Description = "Claims Group Rewards and VIP status continuously",
    Default = false,
    Callback = function(state)
        Config.AutoFreeRewards = state
        if state then
            Cupie:StartLoop("FreeRewardsLoop", 8.0, function()
                if FreeGroupRemote then FreeGroupRemote:FireServer() end
                if ClaimVIPRemote then ClaimVIPRemote:FireServer() end
            end)
        else
            Cupie:StopLoop("FreeRewardsLoop")
        end
    end
})

MiscTab:CreateButton({
    Name = "Claim Tutorial Rewards",
    Description = "Instantly claims tutorial rewards from Modules.Tutorial",
    Callback = function()
        if TutorialDone then TutorialDone:FireServer("8b415605-0fd4-48c8-82f5-fe629dadb5b3") end
        if TutorialReward then TutorialReward:InvokeServer("8b415605-0fd4-48c8-82f5-fe629dadb5b3") end
        Cupie:Notify("Tutorial", "Claimed Tutorial Rewards!", 2.0)
    end
})

MiscTab:CreateButton({
    Name = "Auto Buy NPC Ticket (TalkTickets)",
    Description = "Buys ticket from NPC via TalkTickets remote",
    Callback = function()
        if TalkTicketsRemote then
            TalkTicketsRemote:FireServer("BuyOne")
            Cupie:Notify("NPC Event", "Sent Buy Ticket Request!", 2.0)
        end
    end
})

MiscTab:CreateButton({
    Name = "Claim All Free Rewards Now",
    Description = "Instant one-click claim for all rewards & VIP",
    Callback = function()
        if FreeGroupRemote then FreeGroupRemote:FireServer() end
        if ClaimVIPRemote then ClaimVIPRemote:FireServer() end
        if BPClaimQuest then BPClaimQuest:FireServer() end
        if BPClaimLevel then BPClaimLevel:FireServer() end
        Cupie:Notify("Rewards", "Claimed All Free Gifts & VIP!", 2.5)
    end
})

MiscTab:CreateHeader("LocalPlayer Modifications", 7)

MiscTab:CreateSlider({
    Name = "WalkSpeed",
    Description = "Modify player movement speed",
    Min = 16,
    Max = 250,
    Default = 16,
    Decimals = 0,
    Callback = function(val)
        Config.WalkSpeed = val
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
})

MiscTab:CreateSlider({
    Name = "JumpPower",
    Description = "Modify player jump height",
    Min = 50,
    Max = 300,
    Default = 50,
    Decimals = 0,
    Callback = function(val)
        Config.JumpPower = val
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = val end
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Jump",
    Description = "Allows unlimited jumping in mid-air",
    Default = false,
    Callback = function(state)
        Config.InfJump = state
    end
})

MiscTab:CreateToggle({
    Name = "Noclip (Walk Through Walls)",
    Description = "Disables character collision with obstacles",
    Default = false,
    Callback = function(state)
        Config.Noclip = state
    end
})

MiscTab:CreateToggle({
    Name = "Anti-AFK (20m Disconnect Shield)",
    Description = "Prevents Roblox from kicking you for being idle",
    Default = true,
    Callback = function(state)
        Config.AntiAFK = state
    end
})

MiscTab:CreateHeader("Configuration & Profile Management", 8)

MiscTab:CreateButton({
    Name = "Save Current Settings",
    Description = "Save all toggle/slider values to file and shared memory",
    Callback = function()
        saveConfig()
        Cupie:Notify("Settings Saved", "Configuration saved successfully!", 2.5)
    end
})

MiscTab:CreateButton({
    Name = "Reset Settings to Default",
    Description = "Reset all settings to default values",
    Callback = function()
        Config.AutoRoll = false
        Config.AutoBuyByRarity = false
        Config.AutoSellLowTier = false
        Config.AutoEquipBest = false
        Config.AutoFight = false
        Config.FastAttackAura = false
        Config.AutoUpgradeStats = false
        Cupie:Notify("Settings Reset", "All settings restored to default!", 2.5)
    end
})

-- Infinite Jump Listener
Cupie:AddConnection(UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

-- Keep Walkspeed persistent on respawn
Cupie:AddConnection(LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        task.wait(0.2)
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end
end))

MiscTab:CreateHeader("Theme & UI Control", 12)

MiscTab:CreateDropdown({
    Name = "UI Theme",
    Description = "Change the visual color theme of Cupie Hub",
    Options = {"Midnight (AMOLED)", "Dark (Default)", "Purple Cyber", "Emerald Green", "Crimson Ruby", "Ocean Blue"},
    Default = "Midnight (AMOLED)",
    Callback = function(theme)
        Cupie:SetTheme(theme)
    end
})

MiscTab:CreateKeybind({
    Name = "Toggle Menu Keybind",
    Description = "Change keyboard shortcut to open/minimize",
    Default = Window.Keybind,
    Callback = function(newKey)
        Window.Keybind = newKey
        Cupie:Notify("Keybind Updated", "New Key: " .. newKey.Name, 2.5)
    end
})

MiscTab:CreateButton({
    Name = "Unload Script Hub",
    Description = "Safely cleans up all loops, events, and UI",
    Callback = function()
        Cupie:Unload()
    end
})

-- Switch to Stats Tab by Default
Window:SwitchTab("Stats")

Cupie:Notify("CUPIE HUB", "Loaded Anime Roll Hub v1.0 Successfully!", 3.5)
