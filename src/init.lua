local CameraSegway = {}
CameraSegway.__index = CameraSegway 

local Internal = require(script.Internal)
local RunService = game:GetService("RunService")

local function siffleMainFolder(main: folder)
    local primary = main.Primary
    local secondary = main.Secondary

    local pairings = {}

    for _,v in pairs(primary:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("CFrameValue") then
            table.insert(pairings, {v, secondary[v.Name]})
        end
    end

    return pairings
end

function CameraSegway.new(folder: folder, tweenInfo: TweenInfo)
    local pairingsTable = siffleMainFolder(folder)
    local Segways = {}

    for _,v in pairingsTable do
        table.insert(Segways, Internal.new(v[1], v[2], tweenInfo))
    end

    local self = {}
    self.segways = Segways
    self.running = false

    return self
end

function CameraSegway:Begin()
    while self.running == true do
        local segway = self.segways[math.random(1, #self.segways)]
        segway:Play(workspace.CurrentCamera)
        segway.Completed:wait()
    end
end

function CameraSegway:Stop()
    
end

return CameraSegway 