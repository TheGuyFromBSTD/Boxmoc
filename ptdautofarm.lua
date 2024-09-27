wait(6)
local plr = game.Players.LocalPlayer
plr.OnTeleport:Connect(function(State)
	if queue_on_teleport then
		queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/TheGuyFromBSTD/Boxmoc/refs/heads/main/ptdautofarm.lua"))()]])
	end
end)
local hotbarui = plr.PlayerGui.MainUI.Hotbar.Main.Units
local loadout = {}
local placespot = Vector3.new(-14663.25390625, 605.6867065429688, -2268.96533203125)
local nextplace = 1
local currentplacing = {["Tower"] = nil,["Level"] = 1}
local maxes = {
    ["Fire Guardian"] = 2;
    ["Enderguy"] = 2;
    ["Odin"] = 3;
    ["Rosy Apollo"] = 3;
    ["Apollo"] = 3;
}
local maxlevels = {
    ["Fire Guardian"] = 7;
    ["Enderguy"] = 6;
    ["Odin"] = 5;
    ["Rosy Apollo"] = 7;
    ["Apollo"] = 7;
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
}
local currentmaxes = {}
for i,v in pairs(hotbarui:GetDescendants()) do
    if v:IsA("Model") then
        if v.Parent.Parent:FindFirstChild("Label") then
            local slot = v.Parent.Parent.Parent.Name
            local pricestring = v.Parent.Parent.Label.Text
            local price = string.gsub(pricestring, "%D", "")
            loadout[slot] = {["Tower"] = v.Name, ["Price"] = tonumber(price)}
            currentmaxes[v.Name] = 0
        end
    end
end

local function upgradeloop(tower)
    if plr.leaderstats.Money.Value >= levelcosts[currentplacing["Tower"].Name][currentplacing["Level"]] then
        if currentplacing["Level"] == maxlevels[currentplacing["Tower"].Name] then currentplacing["Tower"] = nil nextplace += 1 return end
        local args = {
            [1] = currentplacing["Tower"]
        }
        game:GetService("ReplicatedStorage").Packages.Knit.Services.UnitService.RF.UpgradeUnit:InvokeServer(unpack(args))
        currentplacing["Level"] += 1
    end
    task.wait(1)
    upgradeloop(tower)
end

local function place(tower)
    local args = {
        [1] = tower,
        [2] = CFrame.new(-14659.3477, 608.209778, -2274.07202, 1, 0, 0, 0, 1, 0, 0, 0, 1)
    }
    game:GetService("ReplicatedStorage").Packages.Knit.Services.UnitService.RF.PlaceUnit:InvokeServer(unpack(args))
    currentmaxes[tower] += 1
end

if game.PlaceId == 15939808257 then
    task.wait(5)
    for i=1,9 do
        game:GetService("ReplicatedStorage").Packages.Knit.Services.GiftsService.RF.Claim:InvokeServer(i)
    end
    task.wait(1)
    plr.Character:PivotTo(CFrame.new(-34.9111, 508.059, 193.926))
    task.wait(0.5)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.ElevatorService.RF.Start:InvokeServer("Underworld-1")
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
                game:GetService("ReplicatedStorage").Packages.Knit.Services.WaveService.RE.UnitAbilityRequest:FireServer(unpack(args))
            end 
        end
        if plr.leaderstats.Money.Value >= loadout[tostring(nextplace)].Price and currentplacing["Tower"] == nil then
            place(loadout[tostring(nextplace)].Tower)
        end
        if plr.PlayerGui.MainUI.Frames.Results.Visible == true then
            game:GetService("ReplicatedStorage").Packages.Knit.Services.ElevatorService.RF.Leave:InvokeServer()
            task.wait(0.1)
            local A_1 = "Lobby-1"
            local A_2 = "Lobby"
            local A_3 = "Lobby"
            game:GetService("ReplicatedStorage").Packages.Knit.Services.ElevatorService.RF.Join:InvokeServer(A_1, A_2, A_3)
            task.wait(0.2)
            local A_1 = "Lobby-1"
            game:GetService("ReplicatedStorage").Packages.Knit.Services.ElevatorService.RF.Start:InvokeServer(A_1)
        end
    end
end)
game.workspace.Game.Map.PlacedUnits.ChildAdded:Connect(function(child)
    currentplacing = {["Tower"] = child, ["Level"] = 0}
    coroutine.wrap(upgradeloop)(child)
end)
game:GetService("ReplicatedStorage").Packages.Knit.Services.WaveService.RF.AutoSkip:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.WaveService.RF.SpeedUp:InvokeServer()
game:GetService("ReplicatedStorage").Packages.Knit.Services.VotingService.RF.Vote:InvokeServer("Hard")
game:GetService("ReplicatedStorage").Packages.Knit.Services.VotingService.RF.Start:InvokeServer()
