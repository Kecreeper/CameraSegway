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

local function changeCompleted(self)
    self.tween.Completed:Connect(function()
        self.CompletedBind:Fire()
    end)
end

function Internal.new(start: BasePart | CFrame | CFrameValue, goal: BasePart | CFrame | CFrameValue, tweenInfo: TweenInfo)
    local self = setmetatable({}, Internal)

    self.start = getCFrame(start)
    self.goal = getCFrame(goal)
    self.tweenInfo = tweenInfo
    self.CompletedBind = Instance.new("BindableEvent")
    self.Completed = self.CompletedBind.Event

    return self
end 

function Internal:Play(cam: Camera)
    if self.tween then
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = self.start
        self.tween:Play()
        changeCompleted(self.tween)
    else
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = self.start
        local tween = TWS:Create(cam, self.tweenInfo, self.goal)
        table.insert(self.tween, tween)
        tween:Play()
        changeCompleted(tween)
    end
end

function Internal:Cancel()
    self.tween:Cancel()
end

return Internal