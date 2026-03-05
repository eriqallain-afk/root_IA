import re
from pathlib import Path

schema_re = re.compile(
    r'^(\s*schema_version\s*:\s*)([0-9]+(?:\.[0-9]+)?)((?:\s*#.*)?)\s*$',
    re.IGNORECASE
)

changed = 0
files = 0

for p in Path("root_IA").rglob("*"):
    if p.is_file() and p.suffix.lower() in [".yaml", ".yml"]:
        txt = p.read_text(encoding="utf-8", errors="replace").splitlines(True)
        out = []
        dirty = False
        for line in txt:
            m = schema_re.match(line)
            if m:
                new_line = f'{m.group(1)}"{m.group(2)}"{m.group(3)}\n'
                if new_line != line:
                    dirty = True
                    changed += 1
                line = new_line
            out.append(line)
        if dirty:
            p.write_text("".join(out), encoding="utf-8")
            files += 1

print(f"Done. Files modified: {files}, lines updated: {changed}")
