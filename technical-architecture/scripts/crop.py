#!/usr/bin/env python3
"""Audit crops for a rendered figure: four quadrants at full resolution, plus any regions.

    python crop.py figure.png outdir                 # q1..q4 + full downscaled preview
    python crop.py figure.png outdir 0,480,760,760   # extra region in 1x source pixels (x1,y1,x2,y2)

Read every crop with the image viewer before publishing; the downscaled preview hides
short arrow stubs, labels cut by wires, chips on borders and broken icons."""

import sys
from pathlib import Path

from PIL import Image

png, out = Path(sys.argv[1]), Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
im = Image.open(png)
w, h = im.size
for name, box in {
    "q1": (0, 0, w // 2, h // 2),
    "q2": (w // 2, 0, w, h // 2),
    "q3": (0, h // 2, w // 2, h),
    "q4": (w // 2, h // 2, w, h),
}.items():
    im.crop(box).save(out / f"{name}.png")
im.resize((w // 2, h // 2)).save(out / "preview.png")
for i, spec in enumerate(sys.argv[3:], 1):
    x1, y1, x2, y2 = (int(v) * 2 for v in spec.split(","))  # 1x coordinates -> 2x pixels
    im.crop((x1, y1, x2, y2)).save(out / f"region{i}.png")
print(f"{png}: {w}x{h}; crops in {out}")
