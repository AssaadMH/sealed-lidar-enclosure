"""List every distinct down-facing plane in a part, with its area.

find_holes.py only looked at the lowest plane within a tolerance.  If one
mounting foot is a fraction taller than the others its hole would be missed
entirely, which would be a silent, expensive design error - so enumerate all
of them and show how much face area sits at each level.
"""
import struct, sys
from collections import defaultdict

def read_stl(path):
    with open(path, 'rb') as f:
        head = f.read(84)
        n = struct.unpack('<I', head[80:84])[0]
        data = f.read(n * 50)
    for i in range(n):
        o = i * 50
        v = struct.unpack('<12f', data[o:o + 48])
        yield (v[0], v[1], v[2]), ((v[3], v[4], v[5]), (v[6], v[7], v[8]), (v[9], v[10], v[11]))

def bxf(p): return (p[0], 61.10 - p[2], p[1])
def bnf(n): return (n[0], -n[2], n[1])

def area2d(t):
    (x1, y1, _), (x2, y2, _), (x3, y3, _) = t
    return abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)) / 2.0

levels = defaultdict(lambda: [0.0, 0, 1e9, -1e9, 1e9, -1e9])
for n, t in read_stl(sys.argv[1]):
    nb = bnf(n)
    if nb[2] >= -0.99:
        continue
    tb = [bxf(p) for p in t]
    z = sum(p[2] for p in tb) / 3.0
    key = round(z, 1)
    L = levels[key]
    L[0] += area2d(tb); L[1] += 1
    for p in tb:
        L[2] = min(L[2], p[0]); L[3] = max(L[3], p[0])
        L[4] = min(L[4], p[1]); L[5] = max(L[5], p[1])

print('down-facing planes (box-frame z), largest area first:')
for z, L in sorted(levels.items(), key=lambda kv: -kv[1][0])[:12]:
    print('  z=%7.2f  area=%8.1f mm2  tris=%5d   X %6.2f..%6.2f  Y %6.2f..%6.2f'
          % (z, L[0], L[1], L[2], L[3], L[4], L[5]))
