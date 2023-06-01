
while not game:IsLoaded() do wait(1) end
wait(4)

settingsconfig = {
	targetmulti = 5,
	breakgiantchest = true,
	breakbigchests = true,
	breakpresents = false,
	breakvaults = false,
	ignorepresents = false,
	autotripledamage = true,
	autoserverdamage = true,
	safetyrange = 500, -- If you are within this much studs as another player it will server hop (set to 0 if you dont want it to do this)
	webhook = "https://discord.com/api/webhooks/1113631434209505290/cyzCogrr__UOA18qnKg6cL1SvW5_2GjfMq9t9SifOfOMbKpJCmQ-pEb4Iyx82ODu7mIu"
}

local SettingsJson = game:GetService("HttpService"):JSONEncode(settingsconfig)
writefile("settings.txt", SettingsJson)

local file = readfile("settings.txt")
local settings = game:GetService("HttpService"):JSONDecode(file)

local targetmulti = tonumber(settings.targetmulti) or 5
local breakgiantchest = settings.breakgiantchest or true
local breakbigchests = settings.breakbigchests or true
local breakpresents = settings.breakpresents or false
local breakvaults = settings.breakvaults or false
local ignorepresents = settings.ignorepresents or false
local WEBHOOK = settings.webhook or "https://discord.com/api/webhooks/1113631434209505290/cyzCogrr__UOA18qnKg6cL1SvW5_2GjfMq9t9SifOfOMbKpJCmQ-pEb4Iyx82ODu7mIu"
local AutoTripleDamage = settings.autotripledamage or true
local AutoServerDamage = settings.autoserverdamage or true

local oldJob = game.JobId

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
    game:GetService("RunService").Heartbeat:Wait();
end;

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke

local old
old = hookfunction(getupvalue(Fire, 1), function(...)
   return true
end)

Lib = require(game:GetService("ReplicatedStorage").Library)

wait(2)

local player = game.Players.LocalPlayer
local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
local detectionRange = settings.safetyrange or 500

local function isPlayerInRange(player)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local playerRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local playerPosition = playerRootPart and playerRootPart.Position
        if playerPosition then
            local playerDistance = (playerPosition - humanoid.RootPart.Position).Magnitude
            return playerDistance <= detectionRange
        end
    end
    return false
end

-- Function to handle checking for nearby players
local function checkNearbyPlayers()
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            if isPlayerInRange(otherPlayer) then
                function sHopper()
				    local endpoint = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/6284583030/servers/Public?sortOrder=Asc&limit=100'))
				    bestserver = {
				        p = 0
				    }
				    function shuffleTable(tbl)
				        local size = #tbl
				        for i = size, 1, -1 do
				            local rand = math.random(size)
				            tbl[i], tbl[rand] = tbl[rand], tbl[i]
				        end
				        return tbl
				    end
				    randomdata = shuffleTable(endpoint.data)
				    for i, v in pairs(randomdata) do
				        if v.playing > bestserver['p'] and v.playing <= 3 then
				            bestserver['id'] = v.id
				            bestserver['p'] = v.playing
				        end
				    end
				    game:GetService("TeleportService"):TeleportToPlaceInstance(6284583030, bestserver.id, game.Players.LocalPlayer)
				end
					while 1 do
					    oldid = game.JobId
					    sHopper()
					    task.wait(1)
					    if oldid ~= game.JobId then
					        break
					    end
					end
            end
        end
    end
end

coi = coroutine.create(function()
	while true do
	    checkNearbyPlayers()
	    wait(1) -- Adjust the interval as needed
	end
end)
coroutine.resume(coi)
local TimeElapsed = 0
local GemsEarned = 0
local TotalGemsEarned = 0
local Library = require(game:GetService("ReplicatedStorage").Library)
local StartingGems = Library.Save.Get().Diamonds

local timer = coroutine.create(function()
    while 1 do
        TimeElapsed = TimeElapsed + 1
        wait(1)
    end
end)
coroutine.resume(timer)

AREATOCHECK = "Mystic Mine"
function add_suffix(inte)
    local gems = inte
    local gems_formatted

    if gems >= 1000000000000 then  -- if gems are greater than or equal to 1 trillion
        gems_formatted = string.format("%.1ft", gems / 1000000000000)  -- display gems in trillions with one decimal point
    elseif gems >= 1000000000 then  -- if gems are greater than or equal to 1 billion
        gems_formatted = string.format("%.1fb", gems / 1000000000)  -- display gems in billions with one decimal point
    elseif gems >= 1000000 then  -- if gems are greater than or equal to 1 million
        gems_formatted = string.format("%.1fm", gems / 1000000)  -- display gems in millions with one decimal point
    elseif gems >= 1000 then  -- if gems are greater than or equal to 1 thousand
        gems_formatted = string.format("%.1fk", gems / 1000)  -- display gems in thousands with one decimal point
    else  -- if gems are less than 1 thousand
        gems_formatted = tostring(gems)  -- display gems as is
    end

    return gems_formatted
end
HttpService = game:GetService("HttpService")
function WH()
	request({
		Url = WEBHOOK,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode{
            ["content"] = "",
            ["embeds"] = {
			    {
			      ["title"] = "Server Hop Stat Update",
			      ["description"] = "Successfully Broke Everything In Server. Hopping To New Server!",
			      ["color"] = 5814783,
			      ["fields"] = {
			        {
			          ["name"] = "Stats",
			          ["value"] = ":clock1: **Time Taken:** ``"..TimeElapsed.."s``\n:gem: **Gems Earned:** ``"..add_suffix(GemsEarned).."``\n:map: **Farming:** ``"..AREATOCHECK.."``"
			        }
			      },
			      ["author"] = {
			        ["name"] = "Mystic Farmer - Stats"
			      }
			    }
			  }
			  }
	})
end

function GetMulti(B)
		if not B then return 0 end
		local totalMultiplier = 0	
		if B.l then
			for _, v in pairs(B.l) do
				pcall(function() 
					if v.m and tonumber(v.m) then
						totalMultiplier = totalMultiplier + v.m
					end
				end)
			end
			
		end
		return totalMultiplier
	end
	
	
AllC = Invoke("Get Coins")
AllNeededCoins = {}
for i, v in pairs(AllC) do
	if v.a == "Mystic Mine" then
		M = GetMulti(v.b)
		if breakgiantchest then
			if string.find(v.n, "Giant") then
				AllNeededCoins[i] = v
			end
		end
		if breakbigchests then
			if string.find(tostring(v.mh), "320") then
				AllNeededCoins[i] = v
			end
		end
		if breakpresents then
			if string.find(v.n, "Present") then
				AllNeededCoins[i] = v
			end
		end
		if breakvaults then
			if string.find(v.n, "Vault") or string.find(v.n, "Safe") then
				AllNeededCoins[i] = v
			end
		end
		if ignorepresents then
			if M >= targetmulti and not string.find(v.n, "Present") then
				AllNeededCoins[i] = v
			end
		else
			if M >= targetmulti then
				AllNeededCoins[i] = v
			end
		end
	end
end
if game.Workspace:FindFirstChild("plat") then game.Workspace.plat:Destroy() end
local p = Instance.new("Part") 
p.Anchored = true
p.Name = "plat"
p.Position = Vector3.new(9043.19140625, -38.66098690032959, 2424.636474609375)
p.Size = Vector3.new(100, 1, 100)
p.Parent = game.Workspace
local gui = Instance.new("SurfaceGui")
gui.Parent = p
gui.Face = Enum.NormalId.Top
local textLabel = Instance.new("TextLabel")
textLabel.Text = "Gem Farmer Made By henrymistert#3888 (.gg/henrymistert)"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
textLabel.TextColor3 = Color3.new(0, 0, 0)
textLabel.FontSize = Enum.FontSize.Size14
textLabel.Parent = gui
textLabel.TextScaled = true
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9043.19141, -34.3321552, 2424.63647, -0.938255966, 7.68024719e-08, 0.345941782, 8.24376656e-08, 1, 1.57588176e-09, -0.345941782, 2.99972136e-08, -0.938255966)

Fire("Performed Teleport")
wait(0.2)
PETS = Lib.Save.Get().PetsEquipped
newP = {}
for i,v in pairs(PETS) do table.insert(newP, i) end
game.Workspace['__THINGS'].Orbs.ChildAdded:Connect(function(v)
	Fire("Claim Orbs", {v.Name})
end)
game.Workspace['__THINGS'].Lootbags.ChildAdded:Connect(function(v)
	Fire("Collect Lootbag", v.Name, v.Position)
end)
boostco = coroutine.create(function()
    while 1 do
        wait(2)
	  if AutoTripleDamage then
        boostName = "Triple Damage"
        local Library = require(game.ReplicatedStorage.Framework.Library)
        local save = Library.Save.Get()
        found = false
        for i, v in pairs(save.Boosts) do
            if i == boostName then
                found = true
            end
        end
        if not found then
            Fire("Activate Boost", boostName)
        end
	  end
	  if AutoServerDamage then
            boostName = "Triple Damage"
            local Library = require(game.ReplicatedStorage.Library)
            Library.Load()
            found = false
            for i, v in pairs(Library.ServerBoosts.GetActiveBoosts()) do
                if i == boostName then
                    found = true
                end
            end
            if not found then
                Fire("Activate Server Boost", boostName)
            end
        end
    end
end)
coroutine.resume(boostco)
for i, v in pairs(AllNeededCoins) do
	local v86 = Invoke("Join Coin", i, newP)
	for v88, v89 in pairs(v86) do
    	Fire("Farm Coin", i, v88);
	end
	while 1 do
		wait(0.01)
		AllC = debug.getupvalue(getsenv(game.Players.LocalPlayer.PlayerScripts.Scripts.Game:WaitForChild("Coins", 10)).DestroyAllCoins, 1)
		f = false
		for i2,v2 in pairs(AllC) do
			if i2 == i then f = true end
		end
		if not f then break end
	end
end
wait(5)
local EndingGems = Library.Save.Get().Diamonds
GemsEarned = EndingGems - StartingGems
pcall(WH)
wait(1)

-- Replace Everything After This With Your Own Server Hopper If You Want To Use Your Own (Or Use The Hopper In #script) :)

function sHopper()
    local endpoint = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/6284583030/servers/Public?sortOrder=Asc&limit=100'))
    bestserver = {
        p = 0
    }
    function shuffleTable(tbl)
        local size = #tbl
        for i = size, 1, -1 do
            local rand = math.random(size)
            tbl[i], tbl[rand] = tbl[rand], tbl[i]
        end
        return tbl
    end
    randomdata = shuffleTable(endpoint.data)
    for i, v in pairs(randomdata) do
        if v.playing > bestserver['p'] and v.playing <= 2 then
            bestserver['id'] = v.id
            bestserver['p'] = v.playing
        end
    end
    game:GetService("TeleportService"):TeleportToPlaceInstance(6284583030, bestserver.id, game.Players.LocalPlayer)
end
while 1 do
    oldid = game.JobId
    sHopper()
    task.wait(1)
    if oldid ~= game.JobId then
        break
    end
end
