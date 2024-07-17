local init = {}
init.__index = init 

local function siffleMainFolder(main: folder)
    local primary = main.Primary
    local secondary = main.Secondary

    local pairings = {}

    for _,v in pairs(primary:GetChildren()) do
        table.insert(pairings, {v, secondary[v.Name]})
    end

    return pairings
end

function init.new(folder: folder)
    local pairings = siffleMainFolder(folder)
    local self = {}
    self.pairings = pairings
end 

return init 