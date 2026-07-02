# LS25 Giants Editor 10.3 Terrain Generator

## 🎯 Übersicht

Dieses Projekt ist ein **professioneller Terrain-Generator für Farming Simulator 2025 (LS25)** mit **Giants Editor 10.3** Unterstützung. Es generiert realistische Höhenkarten basierend auf Perlin Noise und exportiert sie in das LS25-kompatible RAW-Format.

### ✨ Features

- ✅ **Perlin Noise Engine** - Realistische Landschaftsgenerierung
- ✅ **Flach-Modus** - Für ebenes Gelände mit sanften Wellen
- ✅ **Dynamischer Modus** - Mit Octave-Detail-Boost
- ✅ **LS25 RAW Export** - 16-bit Little-Endian Format
- ✅ **Metadaten-Speicherung** - Reproduzierbare Generierung
- ✅ **Lua-Mod für LS25** - Direkt im Spiel nutzbar
- ✅ **Python GUI** (Optional) - Für erweiterte Nutzung

---

## 📋 Anforderungen

### Für Giants Editor 10.3 Import:
- **Giants Editor 10.3** installiert
- **LS25 SDK** (für .i3d Exporte)
- **Lua 5.1+** (für Mod-Scripts)

### Für Python GUI:
- Python 3.9+
- PyQt6
- numpy
- noise (Perlin Noise Library)
- Pillow

---

## 🚀 Schnellstart

### Option 1: Lua-Mod direkt in LS25

```bash
# 1. Repository klonen
git clone https://github.com/Malle1608/ls25-terrain-generator.git
cd ls25-terrain-generator

# 2. Mod-Ordner in LS25 Mods-Verzeichnis kopieren
# (Windows) C:\Users\[User]\Documents\My Games\FarmingSimulator2025\mods
# (Linux) ~/.local/share/FarmingSimulator2025/mods

# 3. In LS25 Spiel starten und in Konsolenbefehle eingeben:
LS25GenerateTerrain(1024, 1024, 100.0, 0.5, 1.0, false, "my_terrain")
```

### Option 2: Python GUI für Desktop

```bash
# Abhängigkeiten installieren
pip install -r requirements.txt

# GUI starten
python main.py
```

---

## 📚 Projektstruktur

```
ls25-terrain-generator/
├── README.md                 # Diese Datei
├── requirements.txt          # Python Dependencies
├── config.py                 # Konfigurationsparameter
│
├── 🐍 PYTHON-Module:
├── main.py                   # PyQt6 GUI Anwendung
├── terrain_generator.py      # Kernalgorithmus (Perlin Noise)
├── ls25_exporter.py          # LS25 RAW Export-Handler
│
├── 🌙 LUA-Module (LS25 Mod):
├── modDesc.xml               # Mod-Beschreibung für LS25
├── main.lua                  # Einstiegspunkt
├── terrainGenerator.lua      # Lua Kernalgorithmus
├── terrainGeneratorGUI.lua   # GUI-Handler
│
└── 📖 Dokumentation:
    ├── INSTALLATION.md       # Installations-Guide
    ├── USAGE.md              # Nutzungs-Anleitung
    ├── GIANTS_EDITOR.md      # Giants Editor Integration
    └── API_REFERENCE.md      # API Dokumentation
```

---

## 🎮 LS25 Mod-Funktionen

### Verfügbare Lua-Funktionen

```lua
-- Terrain generieren und exportieren
LS25GenerateTerrain(width, height, maxHeight, roughness, contourScale, isFlat, filename)
-- Beispiel:
LS25GenerateTerrain(1024, 1024, 100.0, 0.5, 1.0, false, "farm_map")

-- Debug-Export als Text
LS25ExportTerrainDebug(filename)

-- Terrain-Statistiken abrufen
LS25GetTerrainStats()

-- GUI umschalten
LS25ToggleTerrainGUI()
```

---

## ⚙️ Parameter erklärt

| Parameter | Min | Max | Default | Beschreibung |
|-----------|-----|-----|---------|---------------|
| **Width** | 256 | 2048 | 1024 | Breite des Terrains in Pixeln |
| **Height** | 256 | 2048 | 1024 | Höhe des Terrains in Pixeln |
| **Max Height** | 10 | 500 | 100 | Maximaler Höhenunterschied in Metern |
| **Roughness** | 0.1 | 3.0 | 0.5 | Detail-Dichte (höher = mehr Details) |
| **Contour Scale** | 0.5 | 5.0 | 1.0 | Größe der Landschaftsformen |
| **Flat Mode** | - | - | false | Aktiviert flaches Gelände mit Wellen |

### Parameter-Empfehlungen

**Kleine, flache Farm:**
```
Width: 512, Height: 512, MaxHeight: 50, Roughness: 0.3, ContourScale: 0.5
```

**Mittlere, bergige Map:**
```
Width: 1024, Height: 1024, MaxHeight: 150, Roughness: 1.0, ContourScale: 2.0
```

**Große, zerklüftete Landschaft:**
```
Width: 2048, Height: 2048, MaxHeight: 300, Roughness: 2.5, ContourScale: 3.5
```

---

## 🔧 Giants Editor 10.3 Integration

### Schritt-für-Schritt Integration

1. **Terrain mit Lua-Mod generieren**
   ```lua
   LS25GenerateTerrain(1024, 1024, 100.0, 1.0, 2.0, false, "editor_terrain")
   ```
   - Exportiert `terrains/editor_terrain.raw` und `editor_terrain.meta`

2. **RAW-Datei in Giants Editor importieren**
   - Giants Editor öffnen
   - **File → Import Heightmap**
   - `editor_terrain.raw` auswählen
   - Dimensionen: 1024×1024, Format: 16-bit

3. **Höhenskala anpassen**
   - Height Scale: 100.0 (oder wie exportiert)

4. **Texturieren und verfeinern**
   - Im Editor Texturen, Objekte und Umgebung hinzufügen

5. **Exportieren für LS25**
   - **File → Export → .i3d**

---

## 📊 LS25 RAW Format Spezifikation

```
Format: 16-bit RAW Binary
Byte Order: Little-Endian
Datentyp: unsigned short (uint16)
Wertbereich: 0-65535

Layout (Example: 2×2 Map):
Pixel[0,0] (2 bytes) | Pixel[1,0] (2 bytes)
Pixel[0,1] (2 bytes) | Pixel[1,1] (2 bytes)
```

**Größenberechnung:**
```
Dateigröße = Width × Height × 2 bytes
Beispiel: 1024 × 1024 × 2 = 2.097.152 bytes ≈ 2 MB
```

---

## 🐍 Python GUI Nutzung

### Screenshot der Bedienung

```
┌─────────────────────────────────────┐
│  LS25 Terrain Generator             │
├─────────────────────────────────────┤
│                                     │
│  Width:          [1024] ◄───►       │
│  Height:         [1024] ◄───►       │
│  Max Height:     [100.0] ◄───►      │
│  Roughness:      [0.5] ◄───►        │
│  Contour Scale:  [1.0] ◄───►        │
│  Flat Mode:      [☐] Toggle         │
│                                     │
│  ┌──────────────────────────────┐   │
│  │  Preview (512×512)           │   │
│  │  [Grayscale Heightmap]       │   │
│  └──────────────────────────────┘   │
│                                     │
│  [Generate] [Export RAW] [Export TXT]│
│  Status: Ready                      │
└─────────────────────────────────────┘
```

---

## 🔒 Sicherheit & Performance

### Performance-Tipps

- **Größe optimieren**: 1024×1024 für Standard-Maps (schnell)
- **Octaves deaktivieren**: `USE_OCTAVES = False` in config.py für Speed
- **RAM-Verbrauch**: ~10 MB für 1024×1024 Map

### Speicheroptimierung

```python
# config.py
USE_OCTAVES = True        # Set False für schnellere Generierung
OCTAVE_COUNT = 4          # Reduze auf 2 für weniger Details
```

---

## 🐛 Troubleshooting

### Problem: "Repository not found" in LS25
**Lösung:** Mod-Ordner in korrektes Verzeichnis kopieren

### Problem: Terrain sieht unnatürlich aus
**Lösung:** Parameter anpassen:
- Erhöhe `Roughness` für mehr Details
- Erhöhe `Contour Scale` für größere Landschaftsformen

### Problem: Export-Fehler
**Lösung:** 
- Überprüfe Schreibberechtigung im `terrains/` Verzeichnis
- Stelle sicher, dass Dateipfad keine Sonderzeichen enthält

---

## 📖 Weitere Dokumentation

- [Installations-Guide](INSTALLATION.md)
- [Nutzungs-Anleitung](USAGE.md)
- [Giants Editor Integration](GIANTS_EDITOR.md)
- [API Reference](API_REFERENCE.md)

---

## 🤝 Beitragen

Contributions sind willkommen! Bitte:
1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Commit deine Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push zum Branch (`git push origin feature/AmazingFeature`)
5. Öffne einen Pull Request

---

## 📄 Lizenz

MIT License - Siehe [LICENSE](LICENSE) für Details

---

## 👨‍💻 Autor

**Malle1608**
- GitHub: [@Malle1608](https://github.com/Malle1608)
- LS25 Community Contributer

---

## 🙏 Credits

- **Perlin Noise Algorithm**: Ken Perlin
- **LS25 SDK**: GIANTS Software
- **Inspiration**: LS25 Modding Community

---

**Letzte Aktualisierung:** 2. Juli 2026
**Version:** 1.0.0