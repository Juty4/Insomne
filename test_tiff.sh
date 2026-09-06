#!/bin/bash
sips -s format png IconoClaro.png --out tmp_light.png
sips -s format png IconoOscuro.png --out tmp_dark.png
tiffutil -cathidpicheck tmp_light.png tmp_dark.png -out AppIcon.tiff
