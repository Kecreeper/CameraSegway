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

local function getCamera(self)
    if self.camera then
        return self.camera
    else
        self.camera = workspace.CurrentCamera
        return workspace.currentCamera
    end
end

local function ApplyPropsToCamera(properties: Table, camera: Camera)
    for i,v in properties do
        camera[i] = v
    end
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
    self.camera = nil

    return self
end

function CameraSegway:Begin()
    

    while self.running == true do
        local segway = self.segways[math.random(1, #self.segways)]

        if self.properties then
            for i,v in self.properties do
                
            end
        end

        segway:Play(getCamera(self))
        segway.Completed:wait()
    end
end

function CameraSegway:Stop()
    self.running = false
    self.camera = nil
end

function CameraSegway:ChangeProperties(properties: Table)
    self.properties = properties
    if self.running == true then
        applyPropsToCamera(self.properties, self.camera)
    end
end

function CameraSegway:AddEffects(folder: Folder)

end

return CameraSegway 