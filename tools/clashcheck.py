"""Verdict on a clash-check export from ydlidar_x2_box_v2.scad.

The .scad's part="clash_lidar" / "clash_beam" modes intersect the printed
solids with something that must not be touched.  Three outcomes:

  no file / empty   -> nothing intersects at all
  volume ~ 0        -> faces touch but do not overlap (a seating surface)
  volume > 0        -> real interference; the bbox says where

The middle case is expected for the lidar check: the three mounting bosses
are meant to be in flush contact with the lidar's feet.

usage: python tools/clashcheck.py stl_v2/_clash_lidar.stl [...]
"""
import os, struct, sys
from collections import defaultdict

TOL = 0.01   # mm3 - below this it is coincident faces, not overlap

def blobs(tris):
    par = {}
    def find(a):
        while par[a] != a:
            par[a] = par[par[a]]; a = par[a]
        return a
    def uni(a, b):
        ra, rb = find(a), find(b)
        if ra != rb: par[ra] = rb
    k = lambda p: (round(p[0], 3), round(p[1], 3), round(p[2], 3))
    for t in tris:
        for p in t: par.setdefault(k(p), k(p))
    for t in tris:
        a, b, c = [k(p) for p in t]
        uni(a, b); uni(b, c)
    g = defaultdict(list)
    for t in tris: g[find(k(t[0]))].append(t)
    return list(g.values())

def volume(tris):
    v = 0.0
    for a, b, c in tris:
        v += (a[0]*(b[1]*c[2]-c[1]*b[2])
            - a[1]*(b[0]*c[2]-c[0]*b[2])
            + a[2]*(b[0]*c[1]-c[0]*b[1])) / 6.0
    return abs(v)

def read_stl(path):
    """Binary OR ascii.  The original read bytes 80:84 as a facet count
    unconditionally; handed an ascii export it either crashed or - worse -
    parsed junk as a small count and printed a false CLEAR.  Sniff first."""
    with open(path, 'rb') as f:
        raw = f.read()
    if raw[:5] == b'solid' and b'facet' in raw[:2048]:
        tris, cur = [], []
        for line in raw.splitlines():
            w = line.split()
            if w and w[0] == b'vertex':
                cur.append(tuple(float(x) for x in w[1:4]))
                if len(cur) == 3:
                    tris.append(tuple(cur)); cur = []
        return tris
    n = struct.unpack('<I', raw[80:84])[0]
    if len(raw) != 84 + 50 * n:
        raise SystemExit('%s: not a valid binary STL (header claims %d facets, '
                         'file holds %d bytes)' % (path, n, len(raw)))
    tris = []
    for i in range(n):
        o = 84 + i * 50
        v = struct.unpack('<12f', raw[o:o+48])
        tris.append(((v[3],v[4],v[5]), (v[6],v[7],v[8]), (v[9],v[10],v[11])))
    return tris


def main():
    bad = 0
    for path in sys.argv[1:]:
        name = os.path.basename(path)
        if not os.path.exists(path):
            print('%-22s EMPTY export -> CLEAR (nothing intersects)' % name)
            continue
        tris = read_stl(path)
        n = len(tris)
        if n == 0:
            print('%-22s 0 facets -> CLEAR' % name)
            continue
        total = volume(tris)
        verdict = 'CONTACT ONLY' if total < TOL else '*** INTERFERENCE ***'
        if total >= TOL: bad += 1
        print('%-22s %d facets, volume %.5f mm3  -> %s' % (name, n, total, verdict))
        for g in blobs(tris):
            pts = [p for t in g for p in t]
            xs = [p[0] for p in pts]; ys = [p[1] for p in pts]; zs = [p[2] for p in pts]
            print('     X %7.2f..%7.2f  Y %7.2f..%7.2f  Z %7.3f..%7.3f  vol %.5f'
                  % (min(xs), max(xs), min(ys), max(ys), min(zs), max(zs), volume(g)))
    sys.exit(1 if bad else 0)

main()
