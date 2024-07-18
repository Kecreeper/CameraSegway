local CameraSegway = {}
CameraSegway.__index = CameraSegway 

local Internal = require(script.Internal)
local RunService = game:GetService("RunService")

local function checkRunContext()
    assert(RunService:IsClient(), "Module is intended for the client")
end

checkRunContext()

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

local function siffleEffectsFolder(folder: Folder)
    local effects = {}

    for _,v in pairs(folder:GetChildren) do
        if v:IsA("PostEffect") then
            table.insert(effects, v)
        end
    end

    return effects
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

local function ApplyEffectsAndLog(self)
    for _,v in self.effects do
        local e = v:Clone
        e.Parent = self.Camera
        table.insert(self.effectsClone, e)
    end
end

function CameraSegway.new(folder: folder, tweenInfo: TweenInfo)
    checkRunContext()
    local pairingsTable = siffleMainFolder(folder)
    local Segways = {}

    for _,v in pairingsTable do
        table.insert(Segways, Internal.new(v[1], v[2], tweenInfo))
    end

    local self = {}
    self.segways = Segways
    self.running = false
    self.properties = nil
    self.effects = nil
    self.effectsClones = {}
    self.camera = nil

    return self
end

function CameraSegway:Begin()
    getCamera(self)
    if self.properties then
        addPropsToCamera(self.properties, self.camera)
    end
    if self.effects then
        
    end
    while self.running == true do
        local segway = self.segways[math.random(1, #self.segways)]

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
    local effects = siffleEffectsFolder(folder)
    self.effects = effects
end

return CameraSegway 