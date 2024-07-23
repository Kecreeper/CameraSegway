local CameraSegway = {}
CameraSegway.__index = CameraSegway 

local Internal = require(script.Internal)

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

local function ApplyPropsToCamera(self)
    if self.properties ~= nil then
        for i,v in self.properties do
            self.camera[i] = v
        end
    end
end

local function DestroyEffects(self)
    if self.eClones ~= nil then
        for _,v in self.eClones do
            v:Destroy()
        end
    end
end

local function ApplyEffects(self)
    if self.effects ~= nil then
        for _,v in self.effects do
            local e = v:Clone()
            e.Parent = self.camera
            table.insert(self.eClones, e)
        end
    end
end

local function siffleTweenInfo(tweenInfo: TweenInfo): TweenInfo
    local newtweeninfo = TweenInfo.new(tweenInfo.Time, tweenInfo.EasingStyle, tweenInfo.EasingDirection)
    return newtweeninfo
end

function CameraSegway.new(folder: Folder, tweenInfo: TweenInfo)
    local pairingsTable = siffleMainFolder(folder)
    local Segways = {}
    tweenInfo = siffleTweenInfo(tweenInfo)

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
    self.index = 0

    return self
end

function CameraSegway:Begin()
    GetCamera(self)
    ApplyPropsToCamera(self)
    ApplyEffects(self)
    
    self.running = true

    coroutine.wrap(function()
        local outer
        repeat
            print("keep it loopy")
            local randomIndex = math.random(1, #self.segways)
            outer = randomIndex
            local segway = self.segways[randomIndex]
    
            segway:Play(GetCamera(self))
            segway.Completed:Wait()
            segway:Cancel(false)
        until self.running == false
        self.segways[outer]:Cancel(true)
    end)()
end

function CameraSegway:Stop()
    print("asdfasdf")
    self.running = false
    self.camera = nil
    DestroyEffects(self)
end

function CameraSegway:ChangeProperties(properties: table)
    self.properties = properties
    if self.running == true then
        ApplyPropsToCamera(self)
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