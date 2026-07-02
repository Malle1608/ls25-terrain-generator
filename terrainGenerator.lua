--- LS25 Terrain Generator - Main Entry Point
--- Author: Malle1608
--- Version: 1.0.0

local TerrainGenerator = {}
TerrainGenerator.__index = TerrainGenerator

-- Constants
TerrainGenerator.VERSION = "1.0.0"
TerrainGenerator.MOD_NAME = "LS25 Terrain Generator"

-- Configuration
local CONFIG = {
    DEFAULT_WIDTH = 1024,
    DEFAULT_HEIGHT = 1024,
    DEFAULT_MAX_HEIGHT = 100.0,
    DEFAULT_FLATNESS = false,
    DEFAULT_ROUGHNESS = 0.5,
    DEFAULT_CONTOUR_SCALE = 1.0,
    
    -- Ranges
    WIDTH_RANGE = {256, 2048},
    HEIGHT_RANGE = {256, 2048},
    MAX_HEIGHT_RANGE = {10.0, 500.0},
    ROUGHNESS_RANGE = {0.1, 3.0},
    CONTOUR_SCALE_RANGE = {0.5, 5.0},
    
    -- Export
    EXPORT_FORMAT = "RAW",
    BIT_DEPTH = 16,
    EXPORT_EXTENSION = ".raw",
    EXPORT_DIR = "terrains/"
}

-- Create new instance
function TerrainGenerator.new()
    local self = setmetatable({}, TerrainGenerator)
    self.heightmap = nil
    self.width = CONFIG.DEFAULT_WIDTH
    self.height = CONFIG.DEFAULT_HEIGHT
    self.maxHeight = CONFIG.DEFAULT_MAX_HEIGHT
    self.roughness = CONFIG.DEFAULT_ROUGHNESS
    self.contourScale = CONFIG.DEFAULT_CONTOUR_SCALE
    self.isFlat = CONFIG.DEFAULT_FLATNESS
    return self
end

--- Initialize the mod
function TerrainGenerator:init()
    print(string.format("[%s] Version %s initialized", self.MOD_NAME, self.VERSION))
    
    -- Create export directory if it doesn't exist
    if not fileExists(CONFIG.EXPORT_DIR) then
        createDirectory(CONFIG.EXPORT_DIR)
    end
end

--- Generate terrain with specified parameters
function TerrainGenerator:generate(width, height, maxHeight, roughness, contourScale, isFlat)
    print(string.format("[%s] Generating terrain: %dx%d, Max Height: %.2f", 
        self.MOD_NAME, width, height, maxHeight))
    
    -- Validate and clamp parameters
    self.width = math.max(CONFIG.WIDTH_RANGE[1], math.min(CONFIG.WIDTH_RANGE[2], width or self.width))
    self.height = math.max(CONFIG.HEIGHT_RANGE[1], math.min(CONFIG.HEIGHT_RANGE[2], height or self.height))
    self.maxHeight = math.max(CONFIG.MAX_HEIGHT_RANGE[1], math.min(CONFIG.MAX_HEIGHT_RANGE[2], maxHeight or self.maxHeight))
    self.roughness = math.max(CONFIG.ROUGHNESS_RANGE[1], math.min(CONFIG.ROUGHNESS_RANGE[2], roughness or self.roughness))
    self.contourScale = math.max(CONFIG.CONTOUR_SCALE_RANGE[1], math.min(CONFIG.CONTOUR_SCALE_RANGE[2], contourScale or self.contourScale))
    self.isFlat = isFlat or self.isFlat
    
    -- Initialize heightmap
    self.heightmap = {}
    for y = 1, self.height do
        self.heightmap[y] = {}
        for x = 1, self.width do
            self.heightmap[y][x] = 0.0
        end
    end
    
    -- Generate terrain
    if self.isFlat then
        self:_generateFlatTerrain()
    else
        self:_generatePerlinTerrain()
    end
    
    -- Normalize heightmap
    self:_normalizeHeightmap()
    
    print(string.format("[%s] Terrain generation completed", self.MOD_NAME))
    return self.heightmap
end

--- Generate flat terrain with minimal variations
function TerrainGenerator:_generateFlatTerrain()
    local w = self.width
    local h = self.height
    local r = self.roughness
    
    for y = 1, h do
        for x = 1, w do
            -- Gentle sine/cosine waves
            local flatValue = math.sin(x * 0.01) * math.cos(y * 0.01)
            -- Limited variation based on roughness
            local variation = math.sin(x * r * 0.05) * math.cos(y * r * 0.05)
            self.heightmap[y][x] = (flatValue + variation * 0.3) * 0.5 + 0.5
        end
    end
end

--- Generate dynamic terrain with Perlin Noise simulation
-- Uses combination of sine/cosine waves for pseudo-Perlin effect
function TerrainGenerator:_generatePerlinTerrain()
    local w = self.width
    local h = self.height
    local r = self.roughness
    local c = self.contourScale
    
    for y = 1, h do
        for x = 1, w do
            -- Coordinate scaling
            local noiseX = (x / c) * r / 100.0
            local noiseY = (y / c) * r / 100.0
            
            -- Base noise using sine/cosine combination
            local rawHeight = math.sin(noiseX) * math.cos(noiseY)
            
            -- Add octaves for detail boost
            for octave = 1, 4 do
                local octaveScale = 2.0 ^ octave
                local octaveNoise = math.sin(noiseX * octaveScale) * math.cos(noiseY * octaveScale)
                rawHeight = rawHeight + octaveNoise / octaveScale
            end
            
            self.heightmap[y][x] = rawHeight
        end
    end
end

--- Normalize heightmap to 0-1 range
function TerrainGenerator:_normalizeHeightmap()
    local minVal = self.heightmap[1][1]
    local maxVal = self.heightmap[1][1]
    
    -- Find min and max
    for y = 1, self.height do
        for x = 1, self.width do
            local val = self.heightmap[y][x]
            if val < minVal then minVal = val end
            if val > maxVal then maxVal = val end
        end
    end
    
    -- Normalize
    local range = maxVal - minVal
    if range > 0 then
        for y = 1, self.height do
            for x = 1, self.width do
                self.heightmap[y][x] = (self.heightmap[y][x] - minVal) / range
            end
        end
    else
        for y = 1, self.height do
            for x = 1, self.width do
                self.heightmap[y][x] = 0.5
            end
        end
    end
end

--- Export heightmap to RAW format (LS25 compatible)
function TerrainGenerator:exportRAW(filename)
    if self.heightmap == nil then
        print(string.format("[%s] ERROR: No heightmap generated yet", self.MOD_NAME))
        return false, "No heightmap generated"
    end
    
    local filepath = CONFIG.EXPORT_DIR .. (filename or "terrain") .. CONFIG.EXPORT_EXTENSION
    
    print(string.format("[%s] Exporting to: %s", self.MOD_NAME, filepath))
    
    -- Create RAW binary data
    local rawData = {}
    for y = 1, self.height do
        for x = 1, self.width do
            -- Scale to 16-bit range (0-65535)
            local scaledValue = math.floor(self.heightmap[y][x] * self.maxHeight)
            scaledValue = math.max(0, math.min(65535, scaledValue))
            table.insert(rawData, scaledValue)
        end
    end
    
    -- Write to file
    local file = io.open(filepath, "wb")
    if not file then
        return false, "Could not open file for writing: " .. filepath
    end
    
    -- Write binary data (16-bit little-endian)
    for _, value in ipairs(rawData) do
        local byte1 = value % 256
        local byte2 = math.floor(value / 256) % 256
        file:write(string.char(byte1, byte2))
    end
    
    file:close()
    
    -- Write metadata
    local metaPath = CONFIG.EXPORT_DIR .. (filename or "terrain") .. ".meta"
    local metaFile = io.open(metaPath, "w")
    if metaFile then
        metaFile:write(string.format("Width=%d\n", self.width))
        metaFile:write(string.format("Height=%d\n", self.height))
        metaFile:write(string.format("MaxHeight=%.2f\n", self.maxHeight))
        metaFile:write(string.format("Roughness=%.2f\n", self.roughness))
        metaFile:write(string.format("ContourScale=%.2f\n", self.contourScale))
        metaFile:write(string.format("IsFlat=%s\n", tostring(self.isFlat)))
        metaFile:close()
    end
    
    local filesize = io.open(filepath, "rb"):seek("end")
    io.close(io.open(filepath, "rb"))
    
    print(string.format("[%s] Export successful: %s (%d bytes)", self.MOD_NAME, filepath, filesize))
    return true, filepath
end

--- Export heightmap as text (for debugging)
function TerrainGenerator:exportTXT(filename)
    if self.heightmap == nil then
        return false, "No heightmap generated"
    end
    
    local filepath = CONFIG.EXPORT_DIR .. (filename or "terrain_debug") .. ".txt"
    local file = io.open(filepath, "w")
    
    if not file then
        return false, "Could not open file for writing"
    end
    
    file:write(string.format("Width: %d\n", self.width))
    file:write(string.format("Height: %d\n", self.height))
    file:write(string.format("Max Height: %.2f\n", self.maxHeight))
    file:write("================================================\n")
    
    for y = 1, self.height do
        local line = ""
        for x = 1, self.width do
            local scaledVal = self.heightmap[y][x] * self.maxHeight
            line = line .. string.format("%.2f ", scaledVal)
        end
        file:write(line .. "\n")
    end
    
    file:close()
    
    print(string.format("[%s] Text export successful: %s", self.MOD_NAME, filepath))
    return true, filepath
end

--- Get heightmap statistics
function TerrainGenerator:getStatistics()
    if self.heightmap == nil then
        return nil
    end
    
    local minVal = self.heightmap[1][1]
    local maxVal = self.heightmap[1][1]
    local sum = 0
    local count = 0
    
    for y = 1, self.height do
        for x = 1, self.width do
            local val = self.heightmap[y][x]
            sum = sum + val
            count = count + 1
            if val < minVal then minVal = val end
            if val > maxVal then maxVal = val end
        end
    end
    
    local avg = sum / count
    
    return {
        min = minVal,
        max = maxVal,
        average = avg,
        width = self.width,
        height = self.height,
        totalPixels = count
    }
end

return TerrainGenerator