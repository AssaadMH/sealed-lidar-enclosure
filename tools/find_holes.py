"""Find bolt holes on the flat down-facing faces of a reference part.

Method: keep only triangles whose (box-frame) normal points straight down,
rasterise them at 0.2 mm, then flood-fill the empty cells.  An empty region
fully enclosed by face material is a bore; its centroid is the hole centre
and its area gives the diameter.  This beats eyeballing a render and gives
numbers good to about a tenth of a millimetre.

usage: python find_holes.py <stl> [z_tolerance]
"""
import struct, sys, math
from collections import deque

CELL = 0.2

def read_stl(path):
    with open(path, 'rb') as f:
        head = f.read(84)
        n = struct.unpack('<I', head[80:84])[0]
        data = f.read(n * 50)
    for i in range(n):
        o = i * 50
        v = struct.unpack('<12f', data[o:o + 48])
        yield (v[0], v[1], v[2]), ((v[3], v[4], v[5]), (v[6], v[7], v[8]), (v[9], v[10], v[11]))

def bx(p):   return (p[0], 61.10 - p[2], p[1])
def bn(n):   return (n[0], -n[2], n[1])

def raster(tris, X0, Y0, nx, ny):
    """scanline-fill triangles into a set of cells"""
    filled = set()
    for tri in tris:
        pts = [((p[0] - X0) / CELL, (p[1] - Y0) / CELL) for p in tri]
        ymin = max(0, int(math.floor(min(p[1] for p in pts))))
        ymax = min(ny - 1, int(math.ceil(max(p[1] for p in pts))))
        for iy in range(ymin, ymax + 1):
            yc = iy + 0.5
            xs = []
            for i in range(3):
                x1, y1 = pts[i]; x2, y2 = pts[(i + 1) % 3]
                if (y1 <= yc < y2) or (y2 <= yc < y1):
                    xs.append(x1 + (yc - y1) * (x2 - x1) / (y2 - y1))
            xs.sort()
            for k in range(0, len(xs) - 1, 2):
                for ix in range(max(0, int(math.floor(xs[k]))),
                                min(nx - 1, int(math.ceil(xs[k + 1]))) + 1):
                    filled.add((ix, iy))
    return filled

def main():
    path = sys.argv[1]
    tol = float(sys.argv[2]) if len(sys.argv) > 2 else 0.6

    down = []
    zmin = 1e9
    for n, t in read_stl(path):
        nb = bn(n)
        if nb[2] < -0.99:                       # face looks straight down
            tb = [bx(p) for p in t]
            z = sum(p[2] for p in tb) / 3.0
            down.append((z, tb))
            zmin = min(zmin, z)

    if not down:
        print('no down-facing faces'); return
    print('lowest down-facing plane z = %.2f   (tol %.2f)' % (zmin, tol))
    face = [t for z, t in down if z - zmin < tol]
    print('triangles on that plane: %d' % len(face))

    pts = [p for t in face for p in t]
    X0 = min(p[0] for p in pts) - 2; X1 = max(p[0] for p in pts) + 2
    Y0 = min(p[1] for p in pts) - 2; Y1 = max(p[1] for p in pts) + 2
    nx = int((X1 - X0) / CELL) + 1; ny = int((Y1 - Y0) / CELL) + 1
    print('face bbox  X %.2f..%.2f  Y %.2f..%.2f' % (X0 + 2, X1 - 2, Y0 + 2, Y1 - 2))

    filled = raster(face, X0, Y0, nx, ny)

    # flood the outside, so what stays empty is enclosed = a bore
    outside = set(); q = deque([(0, 0)])
    while q:
        c = q.popleft()
        if c in outside or c in filled: continue
        if not (0 <= c[0] < nx and 0 <= c[1] < ny): continue
        outside.add(c)
        q.extend([(c[0]+1,c[1]), (c[0]-1,c[1]), (c[0],c[1]+1), (c[0],c[1]-1)])

    seen = set(); holes = []
    for iy in range(ny):
        for ix in range(nx):
            c = (ix, iy)
            if c in filled or c in outside or c in seen: continue
            comp = []; q = deque([c])
            while q:
                d = q.popleft()
                if d in seen or d in filled or d in outside: continue
                if not (0 <= d[0] < nx and 0 <= d[1] < ny): continue
                seen.add(d); comp.append(d)
                q.extend([(d[0]+1,d[1]), (d[0]-1,d[1]), (d[0],d[1]+1), (d[0],d[1]-1)])
            area = len(comp) * CELL * CELL
            if area < 1.5: continue
            cx = sum(p[0] for p in comp) / len(comp) * CELL + X0
            cy = sum(p[1] for p in comp) / len(comp) * CELL + Y0
            holes.append((cx, cy, 2 * math.sqrt(area / math.pi), area))

    holes.sort(key=lambda h: (-h[3]))
    print('\nenclosed voids in that face (equivalent circle):')
    for cx, cy, d, a in holes:
        print('   [%7.2f, %7.2f]   d=%5.2f mm   area=%6.1f mm2' % (cx, cy, d, a))

main()
