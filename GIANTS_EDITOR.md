# 🎮 Giants Editor 10.3 Integration Guide

## Vollständige Anleitung zur Integration des LS25 Terrain Generators

---

## 📌 Voraussetzungen

✅ **Giants Editor 10.3** installiert
✅ **LS25 SDK** Modding Tools
✅ **LS25 Terrain Generator** (dieses Repository)
✅ **Mindestens 2 GB freier Festplattenspeicher**

---

## 🔄 Workflow: Von Lua-Generierung zu Giants Editor

### Schritt 1: Terrain mit Lua generieren

```lua
-- In LS25 Konsolenbefehle eingeben:
LS25GenerateTerrain(1024, 1024, 100.0, 1.2, 2.0, false, "my_custom_terrain")
```

**Ausgabe:**
```
[LS25 Terrain Generator] Generating terrain: 1024x1024, Max Height: 100.00
[LS25 Terrain Generator] Terrain generation completed
[LS25 Terrain Generator] Export successful: terrains/my_custom_terrain.raw (2097152 bytes)
Metadata saved: terrains/my_custom_terrain.meta
```

**Generierte Dateien:**
```
terrains/
├── my_custom_terrain.raw   # 16-bit Heightmap (2 MB)
└── my_custom_terrain.meta  # Metadaten (Parameter)
```

### Schritt 2: RAW-Datei in Giants Editor importieren

#### 2.1 Giants Editor starten
- Öffne **Giants Editor 10.3**
- Gehe zu **File → New Scene** oder öffne bestehendes Projekt

#### 2.2 Heightmap importieren
1. **Terrain-Editor öffnen:** Menü → **Terrain → Terrain Editor**
2. **Heightmap importieren:** **File → Import → Import Heightmap**
3. Datei-Browser: Navigiere zu `terrains/my_custom_terrain.raw`

#### 2.3 Import-Einstellungen konfigurieren

```
Heightmap Import Dialog:
┌──────────────────────────────┐
│ File: my_custom_terrain.raw  │
│                              │
│ Width:           1024        │ ← Muss mit RAW-Größe übereinstimmen
│ Height:          1024        │ ← Muss mit RAW-Größe übereinstimmen
│ Bit Depth:       16-bit      │ ← WICHTIG: 16-bit
│ Byte Order:      Little-Endian│← WICHTIG: Little-Endian
│ Scale:           100.0       │ ← Höhenskala (wie in .meta)
│                              │
│ [Preview] [Import] [Cancel]  │
└──────────────────────────────┘
```

**⚠️ WICHTIG:** Die Werte müssen exakt mit der RAW-Datei übereinstimmen!

### Schritt 3: Im Giants Editor Terrain verfeinern

Nach dem Import steht dir die volle Giants Editor Terrain-Bearbeitung zur Verfügung:

#### 3.1 Texture Painting
```
TerrainEditor → Texture Painting
- Wähle Textur-Layer
- Male Texturen auf das Terrain
- Nutze Brush-Optionen für Größe/Härte
```

#### 3.2 Vegetation hinzufügen
```
TerrainEditor → Detail Layers
- Füge Gras, Büsche, Bäume hinzu
- Stelle Dichte und Verteilung ein
```

#### 3.3 Objekte platzieren
```
Scene Inspector → Add Objects
- Häuser, Silos, Scheuen, etc.
- Positionierung mit Gizmo Tools
```

#### 3.4 Höhen manuell anpassen (optional)
```
TerrainEditor → Terrain Sculpting
- Raise/Lower Brush für feine Anpassungen
- Smooth Brush für Übergänge
```

---

## 📤 Export für LS25

### Export als .i3d (Giants Editor Format)

1. **File → Export Scene**
2. Format: **LS25 (*.i3d)**
3. Speicherort: `%MODFOLDER%/map/map.i3d`
4. Einstellungen:
   - ✅ Terrain Data exportieren
   - ✅ Textures einbinden
   - ✅ LOD-Level generieren

### Dateistruktur für LS25 Mod

```
my_ls25_map_mod/
├── modDesc.xml
├── map/
│   ├── map.i3d              # Giants Editor Export
│   ├── map01.png             # Minimap
│   ├── textures/
│   │   ├── ground_01.dds
│   │   ├── ground_02.dds
│   │   └── ...
│   └── objects/
│       ├── buildings/
│       └── ...
└── script/
    └── map.lua
```

---

## 🔧 Lua-Skript für Mod-Integration

### modDesc.xml erweitern

```xml
<?xml version="1.0" encoding="UTF-8"?>
<modDesc descVersion="75">
    <author>Malle1608</author>
    <version>1.0.0</version>
    <title>
        <en>My Custom LS25 Map</en>
        <de>Meine benutzerdefinierte LS25 Map</de>
    </title>
    
    <!-- Map Script einbinden -->
    <scriptFile filename="script/map.lua" />
    
    <!-- Ingame Map laden -->
    <extraSourceFiles>
        <sourceFile filename="map/map.i3d" />
    </extraSourceFiles>
</modDesc>
```

### map.lua - Map-Skript

```lua
--- Map-Skript für LS25
local MapScript = {}

function MapScript:new()
    local self = setmetatable({}, MapScript)
    return self
end

function MapScript:initialize()
    print("[Map] Loading custom terrain map...")
    -- Map-Initialisierung
end

function MapScript:load()
    print("[Map] Map loaded successfully")
end

function MapScript:delete()
    print("[Map] Cleaning up map resources")
end

return MapScript.new()
```

---

## 📊 Erweiterte Parameter-Kombinationen

### Für verschiedene Landschaftstypen

#### 🏞️ Flache Agrar-Ebene
```lua
-- Ideal für realistische Farmland-Simulation
LS25GenerateTerrain(
    2048,      -- Width: Große Map
    2048,      -- Height: Große Map
    30.0,      -- MaxHeight: Sehr flach
    0.2,       -- Roughness: Minimal Detail
    0.5,       -- ContourScale: Klein
    false,     -- Normal Mode
    "farmland"
)
```

#### ⛰️ Bergige Landschaft
```lua
-- Für abwechslungsreiches Terrain
LS25GenerateTerrain(
    1024,      -- Width
    1024,      -- Height
    250.0,     -- MaxHeight: Sehr hoch
    2.0,       -- Roughness: Viele Details
    3.5,       -- ContourScale: Groß
    false,     -- Normal Mode
    "mountains"
)
```

#### 🌊 Hügeliges Tal
```lua
-- Balance zwischen flach und gebirgig
LS25GenerateTerrain(
    1024,      -- Width
    1024,      -- Height
    120.0,     -- MaxHeight: Mittel
    1.0,       -- Roughness: Ausgewogen
    2.0,       -- ContourScale: Mittel
    false,     -- Normal Mode
    "valley"
)
```

#### 🏜️ Wüsten-Ebene
```lua
-- Flach mit Dünenmuster
LS25GenerateTerrain(
    2048,      -- Width
    2048,      -- Height
    50.0,      -- MaxHeight: Flach
    0.8,       -- Roughness: Sanfte Wellen
    1.5,       -- ContourScale: Mittlere Wellen
    false,     -- Normal Mode
    "desert"
)
```

---

## ✅ Checkliste: Von Generator zu spielbarer Map

```
☐ 1. LS25 Terrain Generator installiert
☐ 2. Lua-Mod in LS25 geladen
☐ 3. LS25GenerateTerrain() ausgeführt
☐ 4. RAW-Datei generiert (in terrains/ Ordner)
☐ 5. Giants Editor 10.3 geöffnet
☐ 6. Heightmap importiert (1024×1024, 16-bit, Little-Endian)
☐ 7. Texturen gemalt
☐ 8. Vegetation platziert
☐ 9. Objekte hinzugefügt
☐ 10. Terrain als .i3d exportiert
☐ 11. modDesc.xml erstellt
☐ 12. Mod-Ordner in LS25 Mods-Verzeichnis kopiert
☐ 13. LS25 starten und Map laden
☐ 14. Spielen und genießen! 🎮
```

---

## 🐛 Häufige Probleme und Lösungen

### Problem 1: "Invalid Heightmap Dimensions"
```
❌ Fehler: Dimensions stimmen nicht überein

✅ Lösung:
- Width und Height müssen exakt 1024×1024 (oder andere Potenz von 2) sein
- Überprüfe config.py: DEFAULT_WIDTH, DEFAULT_HEIGHT
- Regeneriere die Map mit korrekten Parametern
```

### Problem 2: "Terrain appears distorted/wavy"
```
❌ Fehler: Terrain sieht verzerrt aus

✅ Lösung:
- Überprüfe Byte Order: Must be "Little-Endian"
- Überprüfe Bit Depth: Must be "16-bit"
- Regeneriere mit niedrigerem Roughness-Wert
```

### Problem 3: "Giants Editor crashes on import"
```
❌ Fehler: Giants Editor stürzt ab

✅ Lösung:
- Update Giants Editor auf neueste Version
- Überprüfe RAM-Verfügbarkeit (min. 4 GB)
- Reduziere Map-Größe (1024×1024 statt 2048×2048)
- Versuche erneut zu importieren
```

### Problem 4: "Mod doesn't appear in LS25"
```
❌ Fehler: Mod wird nicht in LS25 angezeigt

✅ Lösung:
- Überprüfe Mod-Ordner-Pfad:
  Windows: C:\Users\[User]\Documents\My Games\FarmingSimulator2025\mods
  Linux: ~/.local/share/FarmingSimulator2025/mods
- Überprüfe modDesc.xml Syntax
- LS25 neu starten
```

---

## 🎨 Tipps für realistische Maps

### Terrain-Gestaltung
1. **Höhenvariationen:**
   - Haupttäler: Sanfte Übergänge
   - Nebenflüsse: Dramatischere Hänge
   - Hügel: Markante Spitzen

2. **Texturen-Platzierung:**
   - Wege auf flachen Bereichen
   - Wald an Hängen
   - Felder auf ebenen Flächen

3. **Vegetation-Muster:**
   - Dichte an Wäldern erhöhen
   - Grüne Wiesen in Tälern
   - Sparse Vegetation auf Bergen

### Performance-Optimierung
```lua
-- Optimierte Parameter für bessere Performance
LS25GenerateTerrain(
    1024,      -- Standard-Größe (nicht zu groß)
    1024,
    100.0,     -- Moderate Höhe
    1.0,       -- Mittlere Rauheit
    1.5,       -- Standardisierte Kontur
    false,
    "optimized_map"
)
```

---

## 📚 Weitere Ressourcen

- [Giants Editor Documentation](https://www.giantssoftware.com/)
- [LS25 SDK Modding Guide](https://www.farming-simulator.com/mod/)
- [Lua Scripting Reference](https://www.lua.org/manual/)

---

**Viel Spaß beim Erstellen deiner Custom-Maps! 🎮**