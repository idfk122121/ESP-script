local espEnabled = false
local espObjects = {}

function createESP(player)
    local espBox = Drawing.new("Square")
    espBox.Visible = false
    espBox.Color = Color3.fromRGB(255, 0, 0)
    espBox.Thickness = 2
    espBox.Transparency = 1

    local function update()
        if espEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                espBox.Size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
                espBox.Position = Vector2.new(pos.X - espBox.Size.X / 2, pos.Y - espBox.Size.Y / 2)
                espBox.Visible = true
            else
                espBox.Visible = false
            end
        else
            espBox.Visible = false
        end
    end

    game:GetService("RunService").RenderStepped:Connect(update)
    table.insert(espObjects, espBox)
end

function enableESP()
    espEnabled = true
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
end

function disableESP()
    espEnabled = false
    for _, espObject in pairs(espObjects) do
        espObject.Visible = false
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if espEnabled then
        createESP(player)
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    for i, espObject in ipairs(espObjects) do
        if espObject.Player == player then
            espObject:Remove()
            table.remove(espObjects, i)
        end
    end
end)
