--This script is for those games that won't let you use a GUI
--Once executing, the ESP is instant.
 
 
-- Function to update player ESP distance
local function updatePlayerESP()
    local localCharacter = game.Players.LocalPlayer.Character
    if not localCharacter then
        return
    end
 
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (localCharacter.Head.Position - player.Character.Head.Position).Magnitude
            local billboardGui = player.Character.Head:FindFirstChild("TadachiisESPTags") -- Check if the BillboardGui exists
            if not billboardGui then -- Only create a new one if it doesn't exist
                billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "TadachiisESPTags" -- Use the correct name for the BillboardGui
                billboardGui.Adornee = player.Character.Head
                billboardGui.Size = UDim2.new(0, 100, 0, 50) -- fixed size for the BillboardGui
                billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- adjust the vertical offset as needed
                billboardGui.AlwaysOnTop = true
                billboardGui.LightInfluence = 1
                billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                billboardGui.Parent = player.Character.Head
 
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "NameLabel" -- Use the correct name for the label
                textLabel.Text = player.Name .. "\nDistance: " .. math.floor(distance)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1 -- transparent background
                textLabel.TextColor3 = Color3.new(1, 0, 0) -- red text for the player's name
                textLabel.TextScaled = true
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- black text stroke
                textLabel.TextStrokeTransparency = 0 -- fully opaque text stroke (visible through walls)
                textLabel.Visible = true -- ESP is always visible without a GUI
                textLabel.Parent = billboardGui
            else
                billboardGui.NameLabel.Text = player.Name .. "\nDistance: " .. math.floor(distance) -- Update the distance text
            end
        end
    end
end
 
-- Call updatePlayerESP() initially and then schedule it to be called every 0.01 seconds
updatePlayerESP()
game:GetService("RunService").Heartbeat:Connect(function()
    updatePlayerESP()
end)
 
