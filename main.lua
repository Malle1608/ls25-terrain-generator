--- LS25 Terrain Generator - Entry Point for Mod
--- This file initializes the mod in LS25

local g_terrainGenerator = nil
local g_terrainGeneratorGUI = nil

-- Load modules
local TerrainGenerator = require("terrainGenerator")
local TerrainGeneratorGUI = require("terrainGeneratorGUI")

-- Initialize mod
function LS25TerrainGeneratorInit()
    if g_terrainGenerator == nil then
        g_terrainGenerator = TerrainGenerator.new()
        g_terrainGenerator:init()
        
        g_terrainGeneratorGUI = TerrainGeneratorGUI.new(g_terrainGenerator)
        
        print("[LS25 Terrain Generator] Mod loaded successfully")
    end
end

-- Generate and export terrain
function LS25GenerateTerrain(width, height, maxHeight, roughness, contourScale, isFlat, filename)
    if g_terrainGenerator == nil then
        LS25TerrainGeneratorInit()
    end
    
    width = width or 1024
    height = height or 1024
    maxHeight = maxHeight or 100.0
    roughness = roughness or 0.5
    contourScale = contourScale or 1.0
    isFlat = isFlat or false
    filename = filename or "generated_terrain"
    
    -- Generate terrain
    g_terrainGenerator:generate(width, height, maxHeight, roughness, contourScale, isFlat)
    
    -- Export to RAW
    local success, result = g_terrainGenerator:exportRAW(filename)
    
    if success then
        print(string.format("[LS25 Terrain Generator] SUCCESS: %s", result))
        return true, result
    else
        print(string.format("[LS25 Terrain Generator] ERROR: %s", result))
        return false, result
    end
end

-- Export debug version
function LS25ExportTerrainDebug(filename)
    if g_terrainGenerator == nil then
        return false, "No terrain generated"
    end
    
    filename = filename or "terrain_debug"
    local success, result = g_terrainGenerator:exportTXT(filename)
    
    return success, result
end

-- Get statistics
function LS25GetTerrainStats()
    if g_terrainGenerator == nil then
        return nil
    end
    
    return g_terrainGenerator:getStatistics()
end

-- Toggle GUI
function LS25ToggleTerrainGUI()
    if g_terrainGeneratorGUI == nil then
        return
    end
    
    if g_terrainGeneratorGUI.isVisible then
        g_terrainGeneratorGUI:hide()
    else
        g_terrainGeneratorGUI:show()
    end
end

-- Initialize on load
LS25TerrainGeneratorInit()

print("[LS25 Terrain Generator] Mod script loaded")
print("Available functions:")
print("  - LS25GenerateTerrain(width, height, maxHeight, roughness, contourScale, isFlat, filename)")
print("  - LS25ExportTerrainDebug(filename)")
print("  - LS25GetTerrainStats()")
print("  - LS25ToggleTerrainGUI()")