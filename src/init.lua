local CameraSegway = {}
CameraSegway.__index = CameraSegway 

local Internal = require(script.Internal)
local RunService = game:GetService("RunService")

local function siffleMainFolder(main: Folder)
    local primary = main["Primary"]
    local secondary = main["Secondary"]

    print(main)
    print(primary)
    print(secondary)

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

    for _,v in pairs(folder:GetChildren()) do
        if v:IsA("PostEffect") then
            table.insert(effects, v)
        end
    end

    return effects
end

local function GetCamera(self)
    if self.camera then
        return self.camera
    else
        self.camera = workspace.CurrentCamera
        return workspace.currentCamera
    end
end

local function ApplyPropsToCamera(properties: table, camera: Camera)
    for i,v in properties do
        camera[i] = v
    end
end

local function DestroyEffects(self)
    for _,v in self.eClones do
        v:Destroy()
    end
end

local function ApplyEffects(self)
    for _,v in self.effects do
        local e = v:Clone()
        e.Parent = self.Camera
        table.insert(self.eClones, e)
    end
end

function CameraSegway.new(folder: Folder, tweenInfo: TweenInfo)
    local pairingsTable = siffleMainFolder(folder)
    local Segways = {}

    for _,v in pairingsTable do
        table.insert(Segways, Internal.new(v[1], v[2], tweenInfo))
    end

    local self = setmetatable({}, CameraSegway)
    self.segways = Segways
    self.running = false
    self.properties = nil
    self.effects = nil
    self.eClones = {}
    self.camera = nil

    return self
end

function CameraSegway:Begin()
    GetCamera(self)
    if self.properties then
        ApplyPropsToCamera(self.properties, self.camera)
    end
    if self.effects then
        ApplyEffects(self)
    end
    self.running = true
    while self.running == true do
        print("keep it loopy")
        local segway = self.segways[math.random(1, #self.segways)]

        segway:Play(GetCamera(self))
        segway.Completed:wait()
    end
end

function CameraSegway:Stop()
    self.running = false
    self.camera = nil
    DestroyEffects(self)
end

function CameraSegway:ChangeProperties(properties: table)
    self.properties = properties
    if self.running == true then
        ApplyPropsToCamera(self.properties, self.camera)
    end
end

function CameraSegway:AddEffects(folder: Folder)
    local effects = siffleEffectsFolder(folder)
    self.effects = effects
    if self.running == true then
        ApplyEffects(self)
    end
end

return CameraSegway 