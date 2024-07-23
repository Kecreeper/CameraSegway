--# selene: allow(empty_if)

local Internal = {}
Internal.__index = Internal

local TWS = game:GetService("TweenService")

local function getCFrame(toGet: BasePart | CFrameValue | CFrame)
    if toGet:IsA("BasePart") then
        return toGet.CFrame
    elseif toGet:IsA("CFrameValue") then
        return toGet.Value
    elseif typeof(toGet) == "CFrame" then
        return toGet
    else
        error("No BasePart/CFrameValue/CFrame provided")
    end
end

local function returnCamera(self)
    self.camera.CameraType = Enum.CameraType.Custom
end

local function setCamera(self)
    self.camera.CameraType = Enum.CameraType.Scriptable
    self.camera.CFrame = self.start
end

function Internal.new(start: BasePart | CFrame | CFrameValue, goal: BasePart | CFrame | CFrameValue, tweenInfo: TweenInfo)
    local self = setmetatable({}, Internal)

    self.start = getCFrame(start)
    self.goal = {CFrame = getCFrame(goal)}
    self.tweenInfo = tweenInfo
    self.CompletedBind = Instance.new("BindableEvent")
    self.Completed = self.CompletedBind.Event
    self.camera = nil

    return self
end 

function Internal:Play(cam: Camera)
    if (cam and not self.camera) or (cam and self.camera) then
        self.camera = cam
    elseif not cam and self.camera then
    else
        error("No camera provided")
    end

    if self.tween then
        setCamera(self)
        self.tween:Play()
    else
        setCamera(self)
        local tween = TWS:Create(self.camera, self.tweenInfo, self.goal)
        self.tween = tween
        tween:Play()
        tween.Completed:Connect(function()
            self.CompletedBind:Fire()
        end)
    end
end

function Internal:Cancel(returnCam: boolean)
    self.tween:Cancel()
    if returnCam == true then
        returnCamera(self)
    end
end

function Internal:Pause(returnCam: boolean)
    self.tween:Pause()
    if returnCam == true then
        returnCamera(self)
    end
end

return Internal