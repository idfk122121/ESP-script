local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createBox()
    local Outline = Drawing.new("Square")
    Outline.Visible = true
    Outline.Color = Color3.fromRGB(0, 0, 0)
    Outline.Thickness = 2
    Outline.Transparency = 1
    Outline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = true
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    return Box, Outline
end

local function updateBox(Box, Outline, target)
    local targetPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(target.Position)
    if onScreen then
        local headPos = workspace.CurrentCamera:WorldToViewportPoint(target.Position + Vector3.new(0, 2, 0))
        local legPos = workspace.CurrentCamera:WorldToViewportPoint(target.Position - Vector3.new(0, 3, 0))
        local size = Vector2.new(1200 / targetPos.Z, headPos.Y - legPos.Y)
        Box.Size = size
        Box.Position = Vector2.new(targetPos.X - size.X / 2, targetPos.Y - size.Y / 2)
        Outline.Size = size
        Outline.Position = Box.Position
        Box.Visible = true
        Outline.Visible = true
    else
        Box.Visible = false
        Outline.Visible = false
    end
end

local function addESP(player)
    if player ~= LocalPlayer then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local Box, Outline = createBox()
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if character and humanoidRootPart and player.Parent then
                updateBox(Box, Outline, humanoidRootPart)
            else
                Box.Visible = false
                Outline.Visible = false
                if not player.Parent then
                    connection:Disconnect()
                    Box:Remove()
                    Outline:Remove()
                }
            end
        end)
    end
end

local function onPlayerAdded(player)
    addESP(player)
    player.CharacterAdded:Connect(function()
        addESP(player)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerRemoving:Connect(function(player)
    local espObjects = player:GetAttribute("ESPObjects")
    if espObjects then
        for _, object in pairs(espObjects) do
            object:Remove()
        end
    end
end)
