local CameraSegway = {}

local CameraSegway = {}
CameraSegway.__index = CameraSegway

function CameraSegway.new(camType: string)
    local self = setmetatable({}, CameraSegway)
    if camType == "Static" then
        self.camType = "Static"
    elseif camType == "Dynamic" then
        self.camType = "Dynamic"
        self.start
        self.goal
    end

    return self
end 

function CameraSegway.setup(start: BasePart | Cframe, goal: BasePart | CFrame)
    if start:IsA("BasePart") then
        self.start = start.CFrame 
    elseif start:IsA("CFrame") then
        self.start = start 
    end

    if goal:IsA("BasePart") then
        self.goal = goal.CFrame
    elseif goal:IsA("CFrame") then 
        self.goal = goal.CFrame
    end 
end 
return CameraSegway