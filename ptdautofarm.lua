wait(4)
print("Digger trigger skibidi nigger")
local VirtualUser = game:service('VirtualUser')
game:service('Players').LocalPlayer.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
local plr = game.Players.LocalPlayer

plr.OnTeleport:Connect(function(State)
    queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/TheGuyFromBSTD/Boxmoc/refs/heads/main/ptdautofarm.lua"))()]])
end)
local hotbarui = plr.PlayerGui.MainUI.Hotbar.Main.Units
local placeevent
local upgradeevent
local attackevent
local elevatorleave
local elevatorjoin
local elevatorstart
local autoskipevent
local speedupevent
local modevote
local modestart
local Giftclaimevent
for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
    if v.Name == "UnitAbilityRequest" then
        attackevent = v
    end
    if v.Name == "Start" and v.Parent.Parent.Name == "ElevatorService" then
        elevatorstart = v
    end
    if v.Name == "Join" and v.Parent.Parent.Name == "ElevatorService" then
        elevatorjoin = v
    end
    if v.Name == "Leave" and v.Parent.Parent.Name == "ElevatorService" then
        elevatorleave = v
    end
    if v.Name == "Start" and v.Parent.Parent.Name == "VotingService" then
        modestart = v
    end
    if v.Name == "Vote" and v.Parent.Parent.Name == "VotingService" then
        modevote = v
    end
    if v.Name == "Claim" and v.Parent.Parent.Name == "GiftsService" then
        Giftclaimevent = v
    end
    if v.Name == "UpgradeUnit" then
        upgradeevent = v
    end
    if v.Name == "PlaceUnit" then
        placeevent = v
    end
    if v.Name == "AutoSkip" then
        autoskipevent = v
    end
    if v.Name == "SpeedUp" then
        speedupevent = v
    end
end
local loadout = {}
local nextplace = 1
local enchantmod = require(game.ReplicatedStorage.Modules.Data.Enchants)
local currentplacing = {["Tower"] = nil,["Level"] = 1}
local maxes = {
    ["Fire Guardian"] = 2;
    ["Enderguy"] = 2;
    ["Odin"] = 3;
    ["Rosy Apollo"] = 3;
    ["Apollo"] = 3;
    ["Necromancer"] = 2;
}
local maxlevels = {
    ["Fire Guardian"] = 7;
    ["Enderguy"] = 6;
    ["Odin"] = 5;
    ["Rosy Apollo"] = 7;
    ["Apollo"] = 7;
    ["Necromancer"] = 6;
}
local levelcosts = {
    ["Fire Guardian"] = {
        [1] = 475;
        [2] = 850;
        [3] = 1200;
        [4] = 1600;
        [5] = 1950;
        [6] = 2300;
        [7] = 2650;
    },
    ["Enderguy"] = {
        [1] = 600;
        [2] = 1050;
        [3] = 1500;
        [4] = 1950;
        [5] = 2400;
        [6] = 2850;
    },
    ["Odin"] = {
        [1] = 500;
        [2] = 875;
        [3] = 1250;
        [4] = 1650;
        [5] = 2000;
    },
    ["Rosy Apollo"] = {
        [1] = 525;
        [2] = 900;
        [3] = 1300;
        [4] = 1650;
        [5] = 2050;
        [6] = 2450;
        [7] = 2850;
    },
    ["Necromancer"] = {
        [1] = 425;
        [2] = 750;
        [3] = 1050;
        [4] = 1400;
        [5] = 1700;
        [6] = 2000;
    },
}
local enchantnames = {}
for i,v in pairs(enchantmod.Enchants) do
    enchantnames[v.Icon] = i
end

local currentmaxes = {}
for i,v in pairs(hotbarui:GetDescendants()) do
    if v:IsA("Model") then
        if v.Parent.Parent:FindFirstChild("Label") then
            local slot = v.Parent.Parent.Parent.Name
            local pricestring = v.Parent.Parent.Label.Text
            local enchant = v.Parent.Parent.Enchant.Enchant.Icon.Image
            local price = string.gsub(pricestring, "%D", "")
            if enchant ~= "" then
                loadout[slot] = {["Tower"] = v.Name.."/"..enchantnames[enchant], ["Price"] = tonumber(price)}
            else
                loadout[slot] = {["Tower"] = v.Name, ["Price"] = tonumber(price)}
            end
            currentmaxes[v.Name] = 0
        end
    end
end

local function upgradeloop(tower)
    if levelcosts[tower][currentplacing["Level"] + 1] == nil then currentplacing["Tower"] = nil currentmaxes[tower] += 1 if currentmaxes[tower] == maxes[tower] then nextplace += 1 end return end
    if plr.leaderstats.Money.Value >= levelcosts[tower][currentplacing["Level"] + 1] then
        local args = {
            [1] = currentplacing["Tower"]
        }
        upgradeevent:InvokeServer(unpack(args))
        currentplacing["Level"] += 1
    end
    task.wait(1)
    upgradeloop(tower)
end

local function place(tower)
    local args = {
        [1] = tower,
        --[2] = CFrame.new(-14666.0352, 605.687012, -2270.27271, 1, 0, 0, 0, 1, 0, 0, 0, 1) --underworld
        --[2] = CFrame.new(-13060.9092, 550.715759, 738.3125, 1, 0, 0, 0, 1, 0, 0, 0, 1) --kingdom
        [2] = CFrame.new(-13172.6426, 588.382812, 2923.04956, 1, 0, 0, 0, 1, 0, 0, 0, 1) -- halloween
    }
    placeevent:InvokeServer(unpack(args))
end

if game.PlaceId == 15939808257 then
    task.wait(5)
    for i=1,9 do
        Giftclaimevent:InvokeServer(i)
    end
    task.wait(1)
    local Elevators = game.workspace.Lobby.JoinPads.Elevators
    local function joinelevator(name, number)
        plr.Character:PivotTo(Elevators:FindFirstChild(name):FindFirstChild(number).CFrame)
        task.wait(0.7)
        elevatorstart:InvokeServer(name.."-"..number)
    end
    joinelevator('Haunted Graveyard', "1")
end
task.spawn(function()
    while task.wait(0.1) do
        if #workspace.Game.Map.Enemies:GetChildren() > 0 then
            for i,t in pairs(workspace.Game.Map.PlacedUnits:GetChildren()) do
                local args = {
                    [1] = t,
                    [2] = os.time(),
                    [3] = workspace.Game.Map.Enemies:GetChildren()[1].Name
                }
                attackevent:FireServer(unpack(args))
            end 
        end
        if plr.leaderstats.Money.Value >= loadout[tostring(nextplace)].Price and currentplacing["Tower"] == nil then
            place(loadout[tostring(nextplace)].Tower)
        end
        if plr.PlayerGui.MainUI.Frames.Results.Visible == true then
            elevatorleave:InvokeServer()
            task.wait(0.1)
            local A_1 = "Lobby-1"
            local A_2 = "Lobby"
            local A_3 = "Lobby"
            elevatorjoin:InvokeServer(A_1, A_2, A_3)
            task.wait(0.2)
            local A_1 = "Lobby-1"
            elevatorstart:InvokeServer(A_1)
        end
    end
end)
game.workspace.Game.Map.PlacedUnits.ChildAdded:Connect(function(child)
    currentplacing = {["Tower"] = child, ["Level"] = 1}
    coroutine.wrap(upgradeloop)(child.Name)
end)
autoskipevent:InvokeServer()
speedupevent:InvokeServer()
modevote:InvokeServer("Nightmare")
modestart:InvokeServer()
