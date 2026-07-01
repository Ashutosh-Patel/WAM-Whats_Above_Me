import os
import glob

files = sorted([f for f in glob.glob('assets/images/Gemini_*.png') if not f.endswith('.out.png')])
names = ['plane.png', 'satellite.png', 'meteoroid.png']

for i, f in enumerate(files):
    if i < len(names):
        out_f = f + '.out.png'
        print(f"Processing {f} to {out_f}")
        os.system(f'rembg i "{f}" "{out_f}"')
        os.rename(out_f, f'assets/images/{names[i]}')
        print(f"Saved to {names[i]}")
