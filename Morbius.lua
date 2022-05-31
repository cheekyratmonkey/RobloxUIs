--Libs/ Innit
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Morbius For Elemental Awakening", "BloodTheme")

local player = game.Players.LocalPlayer

local repStorage = game.ReplicatedStorage
local events = repStorage.Events
local data = repStorage.Data:FindFirstChild(tostring(player.UserId))
local status = repStorage.Statuses:FindFirstChild(player.Name)

local spelllib = require(repStorage.SpellLibrary)
repStorage.SpellLibrary:Clone().Parent = player
local spellbackup = require(player.SpellLibrary)
--Module Data
local closetPlayer = {nil,10000}
local dash = false
local debuff = false

--Functions
local function getClosest()
    local pos = player.Character.HumanoidRootPart.Position
    closetPlayer = {nil,10000}
    for i,v in ipairs(game.Players:GetChildren()) do
        if v ~= player and v.Character ~= nil and v.Character.Parent == workspace.Entities.Alive then
             local distance = (v.Character.HumanoidRootPart.Position - pos).magnitude
            if distance < closetPlayer[2] then
                closetPlayer = {v,distance}
            end
        end
    end
    if closetPlayer[1] then
        return closetPlayer
    else
        return nil
    end
end

local function aimbotfunc()
    return getClosest()[1].Character.HumanoidRootPart.CFrame
end

--Tabs
local Tab = Window:NewTab("Main")
local Spelltab = Window:NewTab("Spells")
local Playertab = Window:NewTab("Player")

--Main Tab
local mainSection = Tab:NewSection("Morbius UI By cheekyratmonkey :)")
mainSection:NewLabel("Current features:")
mainSection:NewLabel("Instant Spells")
mainSection:NewLabel("Aimbot")
mainSection:NewLabel("Speed and jump")
mainSection:NewLabel("Instant Spin")
mainSection:NewLabel("No Dash Cooldown")
mainSection:NewLabel("No Debuffs")
--Spell Tab
local spellsection = Spelltab:NewSection("Spell Hacks")
spellsection:NewToggle("Instant Spells", "Fire spells instantly", function(state)
    if state then
        for i,v in pairs(spelllib) do
            v.EndLag = 0
            v.CastTime = 0
            v.MaxCharge = 0.5
            v.MaxChargeEndlag = 0
            v.MaxCast = 0.4
        end
    else
        for i,v in pairs(spelllib) do
            v.EndLag = spellbackup[i].EndLag
            v.CastTime = spellbackup[i].CastTime
            v.MaxCharge = spellbackup[i].MaxCharge
            v.MaxChargeEndlag = spellbackup[i].MaxChargeEndlag
            v.MaxCast = spellbawwwwckup[i].MaxCast
        end
    end
end)
spellsection:NewToggle("Aimbot", "Automatically fire a spell at the closest enemy", function(state)
   aimbot = state
    if player.Character then
        player.Character.MouseGrab.OnClientInvoke = aimbotfunc
        player.Character.MouseGrab.MouseRetrieve.Disabled = state
    end
end)

--Player Tab
local playersection = Playertab:NewSection("Player Hacks")
playersection:NewTextBox("WalkSpeed", "Set your walkspeed", function(txt)
    status.WalkSpeedMultiplier.Value = tonumber(txt)/16
end)
playersection:NewTextBox("Jump Power", "Set your jump power", function(txt)
    status.JumpPowerMultiplier.Value = tonumber(txt)/50
end)
playersection:NewToggle("Instant Spin", "Get the instant wheel spin gamepass for free", function(state)
    data.InstantSpin.Value = state
end)
playersection:NewToggle("No Dash Cooldown", "Dash as much as you want", function(state)
    dash = state
end)
playersection:NewToggle("No Debuffs", "Removes debuffs such as no regen or ragdoll", function(state)
    debuff = state
end)

--Events
player.CharacterAdded:Connect(function(c)
    if aimbot then
        c:WaitForChild("MouseGrab").OnClientInvoke = aimbotfunc
        c.MouseGrab.MouseRetrieve.Disabled = true
    end 
end)

status.Cooldowns.ChildAdded:Connect(function(c)
    if c.Name == "DashCD" and dash then
        wait()
        c:Destroy()
    end
end)
status.Removeables.ChildAdded:Connect(function(c)
    if debuff then
        wait()
        c:Destroy()
    end
end)
