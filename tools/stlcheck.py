"""Connected-component + orientation check on a binary STL.

Answers: is this one solid body, or several? And does any component enclose a
void (all normals pointing inward => negative signed volume)?
"""
import struct, sys
from collections import defaultdict

def load(path):
    with open(path, 'rb') as f:
        head = f.read(80)
        if head[:5] == b'solid':
            f.seek(0)
            tris, cur = [], []
            for line in f:
                s = line.split()
                if s and s[0] == b'vertex':
                    cur.append(tuple(float(x) for x in s[1:4]))
                    if len(cur) == 3:
                        tris.append(tuple(cur)); cur = []
            return tris
        n = struct.unpack('<I', f.read(4))[0]
        tris = []
        for _ in range(n):
            d = struct.unpack('<12fH', f.read(50))
            tris.append((d[3:6], d[6:9], d[9:12]))
    return tris

def key(v, q=1e4):
    return (round(v[0]*q), round(v[1]*q), round(v[2]*q))

class UF:
    def __init__(s, n): s.p = list(range(n))
    def find(s, x):
        while s.p[x] != x:
            s.p[x] = s.p[s.p[x]]; x = s.p[x]
        return x
    def union(s, a, b):
        ra, rb = s.find(a), s.find(b)
        if ra != rb: s.p[rb] = ra

def signed_volume(tris):
    """6x the signed volume. Positive = outward normals = solid."""
    t = 0.0
    for a, b, c in tris:
        t += (a[0]*(b[1]*c[2] - b[2]*c[1])
            - a[1]*(b[0]*c[2] - b[2]*c[0])
            + a[2]*(b[0]*c[1] - b[1]*c[0]))
    return t / 6.0

for path in sys.argv[1:]:
    tris = load(path)
    uf = UF(len(tris))
    byvert = defaultdict(list)
    for i, t in enumerate(tris):
        for v in t:
            byvert[key(v)].append(i)
    for ids in byvert.values():
        for j in ids[1:]:
            uf.union(ids[0], j)

    comps = defaultdict(list)
    for i, t in enumerate(tris):
        comps[uf.find(i)].append(t)

    print(f"\n{path}")
    print(f"  triangles: {len(tris)}   components: {len(comps)}")
    for n, (_, ct) in enumerate(sorted(comps.items(),
                                       key=lambda kv: -len(kv[1])), 1):
        vol = signed_volume(ct)
        zs = [v[2] for t in ct for v in t]
        rs = [(v[0], v[1]) for t in ct for v in t]
        xs = [p[0] for p in rs]; ys = [p[1] for p in rs]
        kind = "SOLID" if vol > 0 else "VOID (inward normals)"
        print(f"  #{n}: {len(ct):5d} tris  vol={vol:12.2f} mm3  {kind}")
        print(f"        z {min(zs):7.2f}..{max(zs):7.2f}   "
              f"x {min(xs):7.2f}..{max(xs):7.2f}   "
              f"y {min(ys):7.2f}..{max(ys):7.2f}")
