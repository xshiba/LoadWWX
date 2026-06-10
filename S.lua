local plr = game.Players.LocalPlayer
local CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_

local NPCLocations = {
    [1] = CFrame.new(-1077.91, 7.075, 1375.7),
    [2] = CFrame.new(-15906.6, 483.392, 945.215),
    [3] = CFrame.new(5661.9, 1210.88, 863.176),
}

local function IsLife()
    local Humanoid = plr.Character:FindFirstChild("Humanoid")
    return Humanoid and Humanoid.Health > 0
end

local function GetDistance(Endpoint)
    if typeof(Endpoint) == "CFrame" then
        Endpoint = Endpoint.Position
    end
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

local function StartBodyClip()
    if getgenv().noclip_loop then
        getgenv().noclip_loop:Disconnect()
    end
    getgenv().noclip_loop = game:GetService("RunService").Stepped:Connect(function()
        if not plr.Character then return end
        local UpperTorso = plr.Character:FindFirstChild("UpperTorso")
        if not UpperTorso then return end
        if not UpperTorso:FindFirstChild("BodyClip") then
            local BV = Instance.new("BodyVelocity", UpperTorso)
            BV.Name = "BodyClip"
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.MaxForce = Vector3.new(10000, 10000, 10000)
            BV.P = 1000
        end
        if not UpperTorso:FindFirstChild("BodyClip2") then
            local BG = Instance.new("BodyAngularVelocity", UpperTorso)
            BG.Name = "BodyClip2"
            BG.AngularVelocity = Vector3.new(0, 0, 0)
            BG.MaxTorque = Vector3.new(10000, 10000, 10000)
            BG.P = 1000
        end
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end

local function StopBodyClip()
    if getgenv().noclip_loop then
        getgenv().noclip_loop:Disconnect()
    end
    if not plr.Character then return end
    local UpperTorso = plr.Character:FindFirstChild("UpperTorso")
    if not UpperTorso then return end
    if UpperTorso:FindFirstChild("BodyClip") then UpperTorso.BodyClip:Destroy() end
    if UpperTorso:FindFirstChild("BodyClip2") then UpperTorso.BodyClip2:Destroy() end
end

local function BuyDragonTalon()
    local currentSea = workspace:GetAttribute("Map") or 1
    StartBodyClip()
    TpTo(NPCLocations[currentSea] or NPCLocations[1])
    task.wait(0.5)

    local npc = FindNPC()
    if npc then
        TpTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
        task.wait(0.5)
    end

    local check = CommF_:InvokeServer("BuyDragonTalon", true)

    if check == false or typeof(check) == "string" or check == 3 then
        StopBodyClip()
        return
    end

    if check ~= 1 then
        local result = CommF_:InvokeServer("BuyDragonTalon")
        if result == 0 or result == 3 then
            StopBodyClip()
            return
        end
    end

    task.wait(1)

    local tool = plr.Backpack:FindFirstChild("Dragon Talon")
    if tool then
        plr.Character.Humanoid:EquipTool(tool)
    end

    StopBodyClip()
end

BuyDragonTalon()
