"""Coarse XY occupancy map per reference part, in BOX coordinates.

Bounding boxes alone were misleading: a thin flange and a solid block report
the same box.  This rasterises each part's triangles into a 2 mm grid so the
actual plan-view shape is visible, and reports the Z span found in each cell
column so flat plates can be told apart from tall bodies.
"""
import glob, os, struct

CELL = 2.0

def read_stl(path):
    with open(path, 'rb') as f:
        head = f.read(84)
        n = struct.unpack('<I', head[80:84])[0]
        data = f.read(n * 50)
    for i in range(n):
        off = i * 50
        v = struct.unpack('<12f', data[off:off + 48])
        yield ((v[3], v[4], v[5]), (v[6], v[7], v[8]), (v[9], v[10], v[11]))

def to_box(p):
    return (p[0], 61.10 - p[2], p[1])

def main():
    d = os.path.join(os.path.dirname(__file__), '..', 'ref')
    X0, X1, Y0, Y1 = -2.0, 100.0, -2.0, 64.0
    nx = int((X1 - X0) / CELL); ny = int((Y1 - Y0) / CELL)
    for path in sorted(glob.glob(os.path.join(d, '*.STL'))):
        cells = {}
        for t in read_stl(path):
            for v in t:
                x, y, z = to_box(v)
                ix = int((x - X0) / CELL); iy = int((y - Y0) / CELL)
                if 0 <= ix < nx and 0 <= iy < ny:
                    lo, hi = cells.get((ix, iy), (1e9, -1e9))
                    cells[(ix, iy)] = (min(lo, z), max(hi, z))
        print('=' * 72)
        print(os.path.basename(path))
        print('  filled cells %d  -> plan area ~%.0f mm2' % (len(cells), len(cells) * CELL * CELL))
        for iy in range(ny - 1, -1, -1):
            row = ''
            for ix in range(nx):
                c = cells.get((ix, iy))
                if c is None:
                    row += '.'
                else:
                    h = c[1] - c[0]
                    row += '#' if h > 8 else ('+' if h > 2 else '-')
            print('  ' + row)
        print('  legend: # tall(>8mm)  + mid(2-8)  - thin(<2mm)   1 char = %gmm' % CELL)

main()
