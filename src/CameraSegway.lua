local CameraSegway = {}

local TWS = game:GetService("TweenService")

CameraSegway.__index = CameraSegway

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

function CameraSegway.new(start: BasePart | CFrame | CFrameValue, goal: BasePart | CFrame | CFrameValue, tweenInfo: TweenInfo)
    local self = setmetatable({}, CameraSegway)

    self.start = getCFrame(start)
    self.goal = getCFrame(goal)
    self.tweenInfo = tweenInfo

    return self
end 

function CameraSegway:Play(cam: Camera)
    if self.tween then
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = self.start
        self.tween:Play()
    else
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = self.start
        local tween = TWS:Create(cam, self.tweenInfo, self.goal)
        table.insert(self.tween, tween)
    end
end

function CameraSegway:Cancel(cam: Camera)
    self.tween:Cancel()
end

return CameraSegway