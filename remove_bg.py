from PIL import Image
import os
import glob

files = sorted(glob.glob('assets/images/Gemini_*.png'))
names = ['plane.png', 'satellite.png', 'meteoroid.png']

for i, f in enumerate(files):
    if i >= len(names): break
    img = Image.open(f).convert("RGBA")
    datas = img.getdata()
    newData = []
    for item in datas:
        if item[0] > 240 and item[1] > 240 and item[2] > 240:
            newData.append((255, 255, 255, 0))
        else:
            newData.append(item)
    img.putdata(newData)
    img.save(os.path.join('assets/images', names[i]), "PNG")
