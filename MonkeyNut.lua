--Libs/ Innit
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("MonkeyNut For Jailbird", "DarkTheme")

local repStorage = game.ReplicatedStorage
local gameevents = repStorage.GameEvents

local player = game.Players.LocalPlayer

--Functions
local function zonewarnUI()
        -- Instances:

    local Zonewarn = Instance.new("BillboardGui")
    local icon = Instance.new("ImageLabel")

    --Properties:

    Zonewarn.Name = "EspZonewarn"
    Zonewarn.Parent = game.Workspace.Part
    Zonewarn.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Zonewarn.Active = true
    Zonewarn.AlwaysOnTop = true
    Zonewarn.LightInfluence = 1.000
    Zonewarn.Size = UDim2.new(0, 38, 0, 38)

    icon.Name = "icon"
    icon.Parent = Zonewarn
    icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    icon.BackgroundTransparency = 1.000
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.Image = "rbxassetid://36697080"
    icon.ImageColor3 = Color3.fromRGB(255, 0, 0)
    return Zonewarn
end

local function loadMod(code, module)
	loadstring("module = "..module)();
	for i,v in pairs(string.split(code,"\n")) do
		if v ~= nil then
            local func = loadstring("require(module)"..v);
            func()
		end
	end
end	

local weapons = {}
for _,v in pairs(repStorage.Weapons:GetChildren()) do
    table.insert(weapons,1,v.Name)
end

--Module Data
local ammo = false
local ping = false
local pingVal = 0
local codetext = ""
local wepname = ""

--Tabs
local Tab = Window:NewTab("Main")
local Lobby = Window:NewTab("Lobby")
local InGame = Window:NewTab("Game")
local wepEdit = Window:NewTab("Weapon Editor")

--Main tab
local mainSection = Tab:NewSection("MonkeyNut UI By cheekyratmonkey :)")
mainSection:NewLabel("Current features:")
mainSection:NewLabel("-Inf Ammo")
mainSection:NewLabel("-Ping Faker")
mainSection:NewLabel("-Force Join lobby")
mainSection:NewLabel("-Weapon Select")
mainSection:NewLabel("-ESP")

--Lobby tab
local lobysection = Lobby:NewSection("Lobby Hacks (only work in the lobby)")
lobysection:NewTextBox("Force Join Lobby", "Joins anyone's party without an invite.", function(txt)
	gameevents.PartyJoin:FireServer(game.Players:FindFirstChild(txt))
end)

--Game Tab
local gamesection = InGame:NewSection("Game Hacks (only work in a match)")
gamesection:NewToggle("Infinite Ammo", "Enable this to never run out of ammo", function(state)
    ammo = state
end)
gamesection:NewToggle("ESP", "See all your enemies", function(state)
    if state then
        for _,v in pairs(game.Players:GetChildren()) do
            if workspace:FindFirstChild(v.Name) ~= nil then
               local char = workspace:FindFirstChild(v.Name)
                if char.Head:FindFirstChild("TeamIdentity") == nil then
                    local esp = zonewarnUI()
                    esp.Parent = char.HumanoidRootPart
                    esp.Adornee = esp.Parent
                end
            end
        end
    else
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "EspZonewarn" then
                v:Destroy()
            end
        end
    end

end)

gamesection:NewDropdown("Weapon Select", "Set your current weapon to any weapon", weapons, function(currentOption)
    local char = workspace:FindFirstChild(player.Name)
    local currentwep = char:FindFirstChildOfClass("Tool")
    char:FindFirstChild("S"..currentwep.Name):Destroy()
    currentwep:Destroy()
    local wep = repStorage.Weapons:FindFirstChild(currentOption):Clone()
    wep.Parent = char
    local wep2 = repStorage.ClientWeapons:FindFirstChild(currentOption):Clone()
    wep2.Parent = char
    wep2.Name = "S"..currentOption
end)

gamesection:NewTextBox("Ping Faker", "Set your ping to any number", function(txt)
	if txt ~= "" then
        ping = true
        pingVal = tonumber(txt)    
    else
        ping = false
    end
end)

local wepeditSection = wepEdit:NewSection("Create Custom Weapons")
wepeditSection:NewDropdown("Weapon Model", "Choose what model your weapon will use", weapons, function(currentOption)
    wepname = currentOption
end)
wepeditSection:NewTextBox("Weapon Data", "The data for the custom weapon", function(txt)
	codetext = txt
end)
wepeditSection:NewButton("Import Weapon", "Gives the weapon to the player", function()
    if wepname ~= "" then
        local char = workspace:FindFirstChild(player.Name)
        local currentwep = char:FindFirstChildOfClass("Tool")
        char:FindFirstChild("S"..currentwep.Name):Destroy()
        currentwep:Destroy()
        local wep = repStorage.Weapons:FindFirstChild(wepname):Clone()
        wep.Parent = char
        local wep2 = repStorage.ClientWeapons:FindFirstChild(wepname):Clone()
        wep2.Parent = char
        wep2.Name = "S"..wepname
    end
    loadMod(codetext, workspace:FindFirstChild(player.Name):FindFirstChildOfClass("Tool")["ACS_Modulo"].Variaveis.Settings:GetFullName())
end)

--main loop
while wait() do
    if ammo and workspace:FindFirstChild(game.Players.LocalPlayer.Name) ~= nil and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") ~= nil then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").ACS_Modulo.Variaveis.Ammo.Value = 9999999
    end
    if ping then
        gameevents.SendPing:FireServer(pingVal) 
    end
end
