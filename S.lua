local plr = game.Players.LocalPlayer
local CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_

local NPCLocations = {
    ["Sea1"] = CFrame.new(-1077.91, 7.075, 1375.7, 0.947886, 0, -0.31861, 0, 1, 0, 0.31861, 0, 0.947886),
    ["Sea2"] = CFrame.new(-15906.6, 483.392, 945.215, -0.0958583, 0, 0.995395, 0, 1, 0, -0.995395, 0, -0.0958583),
    ["Sea3"] = CFrame.new(5661.9, 1210.88, 863.176, -0.823952, 0, 0.56666, 0, 1, 0, -0.56666, 0, -0.823952),
}

local function IsLife()
    local Humanoid = plr.Character:FindFirstChild("Humanoid")
    return Humanoid and Humanoid.Health > 0
end

local function GetDistance(Endpoint)
    if typeof(Endpoint) == "CFrame" then Endpoint = Endpoint.Position end
    return (Endpoint - plr.Character.HumanoidRootPart.Position).Magnitude
end

local function TpTo(Endpoint)
    if not IsLife() then return end
    local Distance = GetDistance(Endpoint)
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.CFrame.X, Endpoint.Y, plr.Character.HumanoidRootPart.CFrame.Z)
    local Tween = game:GetService("TweenService"):Create(plr.Character.HumanoidRootPart, TweenInfo.new(Distance / 250, Enum.EasingStyle.Linear), {CFrame = Endpoint})
    Tween:Play()
    Tween.Completed:Wait()
end

local function FindNPC()
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == "Uzoth" or npc.Name == "Dragon Talon Sage" then
            return npc
        end
    end
    return nil
end

local function BuyDragonTalon()
    local currentSea = workspace:GetAttribute("MAP") or "Sea1"
    TpTo(NPCLocations[currentSea] or NPCLocations["Sea1"])
    task.wait(0.5)

    local npc = FindNPC()
    if npc then
        TpTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
        task.wait(0.5)
    end

    local check = CommF_:InvokeServer("BuyDragonTalon", true)

    if check == false or typeof(check) == "string" or check == 3 then
        return
    end

    if check ~= 1 then
        local result = CommF_:InvokeServer("BuyDragonTalon")
        if result == 0 or result == 3 then return end
    end

    task.wait(1)

    local tool = plr.Backpack:FindFirstChild("Dragon Talon")
    if tool then
        plr.Character.Humanoid:EquipTool(tool)
    end
end

BuyDragonTalon()
