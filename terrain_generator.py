"""
Kernalgorithmus für Terrain-Generierung
Implementiert Perlin Noise basierte Höhenkarten-Generierung
"""

import numpy as np
import noise
from config import USE_OCTAVES, OCTAVE_COUNT


class TerrainGenerator:
    """Generiert realistisches Terrain basierend auf Perlin Noise"""

    def __init__(self):
        self.heightmap = None
        self.width = None
        self.height = None

    def generate(self, width, height, max_height, roughness, contour_scale, is_flat):
        """
        Generiert eine Höhenkarte
        
        Args:
            width (int): Breite des Terrains in Pixeln
            height (int): Höhe des Terrains in Pixeln
            max_height (float): Maximaler Höhenunterschied
            roughness (float): Kontrolliert die Detaildichte (0.1-3.0)
            contour_scale (float): Kontrolliert die grobe Form (0.5-5.0)
            is_flat (bool): Wenn True, flaches Gelände mit minimalen Variationen
            
        Returns:
            np.ndarray: 2D-Array der Höhenwerte (normalized 0-1)
        """
        self.width = width
        self.height = height
        self.heightmap = np.zeros((height, width), dtype=np.float32)

        if is_flat:
            return self._generate_flat_terrain(width, height, roughness)
        else:
            return self._generate_perlin_terrain(width, height, max_height, 
                                               roughness, contour_scale)

    def _generate_flat_terrain(self, width, height, roughness):
        """
        Generiert flaches Gelände mit minimalen Variationen
        Nutzt Sinus/Kosinus für sanfte Wellen
        """
        for y in range(height):
            for x in range(width):
                # Sanfte sinusförmige Wellen
                flat_value = np.sin(x * 0.01) * np.cos(y * 0.01)
                # Begrenzte Variation basierend auf Rauheit
                variation = np.sin(x * roughness * 0.05) * np.cos(y * roughness * 0.05)
                self.heightmap[y, x] = (flat_value + variation * 0.3) * 0.5 + 0.5

        return self._normalize_heightmap()

    def _generate_perlin_terrain(self, width, height, max_height, 
                                 roughness, contour_scale):
        """
        Generiert dynamisches Terrain mit Perlin Noise
        Optional mit Octaves für mehr Details
        """
        for y in range(height):
            for x in range(width):
                # Koordinaten skalieren
                noise_x = (x / contour_scale) * roughness / 100.0
                noise_y = (y / contour_scale) * roughness / 100.0

                # Basis Perlin Noise
                raw_height = noise.pnoise2(noise_x, noise_y, octaves=1)

                # Optional: Detail Boost mit mehreren Octaves
                if USE_OCTAVES and OCTAVE_COUNT > 1:
                    for octave in range(1, OCTAVE_COUNT):
                        octave_scale = 2.0 ** octave
                        octave_noise = noise.pnoise2(
                            noise_x * octave_scale,
                            noise_y * octave_scale,
                            octaves=1
                        )
                        # Amplitude abnehmen bei höheren Octaves
                        raw_height += octave_noise / octave_scale

                self.heightmap[y, x] = raw_height

        return self._normalize_heightmap()

    def _normalize_heightmap(self):
        """
        Normalisiert die Höhenkarte auf den Bereich 0-1
        
        Returns:
            np.ndarray: Normalisierte Höhenkarte
        """
        min_val = np.min(self.heightmap)
        max_val = np.max(self.heightmap)

        if max_val - min_val > 0:
            self.heightmap = (self.heightmap - min_val) / (max_val - min_val)
        else:
            self.heightmap = np.ones_like(self.heightmap) * 0.5

        return self.heightmap

    def get_heightmap(self):
        """Gibt die aktuelle Höhenkarte zurück"""
        return self.heightmap

    def get_heightmap_scaled(self, max_height):
        """
        Gibt die Höhenkarte skaliert auf den gewünschten Höhenunterschied zurück
        
        Args:
            max_height (float): Maximaler Höhenwert
            
        Returns:
            np.ndarray: Skalierte Höhenkarte
        """
        if self.heightmap is None:
            return None
        return self.heightmap * max_height

    def get_preview_image(self):
        """
        Generiert ein Preview-Bild der Höhenkarte
        
        Returns:
            PIL.Image: Graustufen-Vorschaubild
        """
        from PIL import Image
        
        if self.heightmap is None:
            return None

        # Konvertiere zu 8-bit Graustufen (0-255)
        preview_data = (self.heightmap * 255).astype(np.uint8)
        
        # Erstelle Bild
        img = Image.fromarray(preview_data, mode='L')
        return img