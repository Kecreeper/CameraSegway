# CameraSegway
Module to create idle camera paths


https://github.com/user-attachments/assets/a4e1a965-653a-4534-aaba-f3dd00da34f3


```lua
  - CameraSegway.new(folder: Folder, tweenInfo: TweenInfo)

  - CameraSegway:Begin()
  - CameraSegway:Stop()
  - CameraSegway:ChangeProperties(properties: Table)
  - CameraSegway:AddEffects(folder: Folder)
```

## Example Code and Setup
```lua
-- local script
task.wait(3)

local CameraSegway = require(game:GetService("ReplicatedStorage").CameraSegway)
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

local Segway = CameraSegway.new(workspace.Main, tweenInfo)

Segway:ChangeProperties({FieldOfView = 30})
Segway:Begin()

task.wait(3)
Segway:AddEffects(workspace.Effects)
Segway:ChangeProperties({FieldOfView = 40})

task.wait(20)

Segway:Stop() -- waits for camera to stop tweening
```
> Will only take the time, easing style, and easing direction of any TweenInfo inputted

### Main Folder Structure
```
└── Main             # folder with any name
    ├── Primary      # folder with the name "Primary" 
    └── Secondary    # folder with the name "Secondary"
```
> Insert BaseParts or CFrameValues with the same name into both the Primary and Secondary folder. 
![image](https://github.com/user-attachments/assets/51fc7932-e5b5-484d-acf7-50eb26612214)
> Camera tweens from Primary to Secondary

### Effects Folder Structure
```
  └── Effects        # folder with any name
```
> Insert PostEffects into the Effects folder

![RobloxStudioBeta_AM1QcDABYb](https://github.com/user-attachments/assets/07fb0893-c8f6-452d-836f-789a33bba78b)
