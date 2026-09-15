from pathlib import Path
from PIL import Image,ImageOps,ImageDraw
import json
ROOT=Path(__file__).resolve().parent
records=json.loads((ROOT/'qa/pdf_checks.json').read_text(encoding='utf-8'))
out=[]
for lang,r in records.items():
    pages=sorted((ROOT/r['render_directory']).glob('page-*.png'))
    dest=ROOT/'qa/contact_sheets'/lang/r['sha256'][:12];dest.mkdir(parents=True,exist_ok=True)
    for start in range(0,len(pages),6):
        canvas=Image.new('RGB',(1560,1530),'#e3e7eb')
        draw=ImageDraw.Draw(canvas)
        for j,p in enumerate(pages[start:start+6]):
            img=Image.open(p).convert('RGB');img.thumbnail((500,708),Image.Resampling.LANCZOS)
            x=(j%3)*520+10;y=(j//3)*765+35
            canvas.paste(img,(x,y))
            draw.text((x,y-23),f'{lang.upper()} | PAGE {start+j+1:02d}',fill='black')
        name=dest/f'pages_{start+1:02d}_{min(start+6,len(pages)):02d}.png'
        canvas.save(name)
        out.append({'language':lang,'first_page':start+1,'last_page':min(start+6,len(pages)),'file':name.relative_to(ROOT).as_posix(),'pdf_sha256':r['sha256']})
(ROOT/'qa/contact_sheet_index.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print(json.dumps(out,indent=2))
