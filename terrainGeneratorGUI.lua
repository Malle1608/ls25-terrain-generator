--- LS25 Terrain Generator - GUI Handler
--- Interactive interface for terrain generation

local TerrainGeneratorGUI = {}
TerrainGeneratorGUI.__index = TerrainGeneratorGUI

function TerrainGeneratorGUI.new(terrainGenerator)
    local self = setmetatable({}, TerrainGeneratorGUI)
    self.generator = terrainGenerator
    self.isVisible = false
    self.selectedTab = "generate"
    return self
end

--- Show GUI overlay
function TerrainGeneratorGUI:show()
    self.isVisible = true
    print("[LS25 Terrain Generator] GUI opened")
end

--- Hide GUI overlay
function TerrainGeneratorGUI:hide()
    self.isVisible = false
end

--- Handle input events
function TerrainGeneratorGUI:handleInput(input, isDown)
    if not self.isVisible then
        return
    end
    
    -- Handle input logic here
end

--- Render GUI
function TerrainGeneratorGUI:render()
    if not self.isVisible then
        return
    end
    
    -- GUI rendering logic would go here
    -- In a real LS25 mod, this would use LS25's rendering API
end

return TerrainGeneratorGUI