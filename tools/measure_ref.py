"""Measure the vendor YDLIDAR X2 STLs in BOX coordinates.

The .scad places the reference with  translate([0,61.10,0]) rotate([90,0,0]),
so a model point (mx,my,mz) lands at box  X = mx, Y = 61.10 - mz, Z = my.
Everything printed here is therefore directly comparable to the numbers in
the MEASURED LIDAR GEOMETRY block.
"""
import glob, os, struct, sys, math

def read_stl(path):
    with open(path, 'rb') as f:
        head = f.read(84)
        n = struct.unpack('<I', head[80:84])[0]
        data = f.read(n * 50)
    tris = []
    for i in range(n):
        off = i * 50
        v = struct.unpack('<12f', data[off:off + 48])
        tris.append(((v[3], v[4], v[5]), (v[6], v[7], v[8]), (v[9], v[10], v[11])))
    return tris

def to_box(p):
    return (p[0], 61.10 - p[2], p[1])

def bbox(pts):
    xs = [p[0] for p in pts]; ys = [p[1] for p in pts]; zs = [p[2] for p in pts]
    return (min(xs), max(xs)), (min(ys), max(ys)), (min(zs), max(zs))

def main():
    d = os.path.join(os.path.dirname(__file__), '..', 'ref')
    for path in sorted(glob.glob(os.path.join(d, '*.STL'))):
        tris = read_stl(path)
        pts = [to_box(v) for t in tris for v in t]
        bx, by, bz = bbox(pts)
        name = os.path.basename(path)
        print('%-46s tris=%6d' % (name[:46], len(tris)))
        print('    X %8.2f .. %8.2f  (%6.2f)' % (bx[0], bx[1], bx[1] - bx[0]))
        print('    Y %8.2f .. %8.2f  (%6.2f)' % (by[0], by[1], by[1] - by[0]))
        print('    Z %8.2f .. %8.2f  (%6.2f)' % (bz[0], bz[1], bz[1] - bz[0]))

main()
