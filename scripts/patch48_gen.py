#!/usr/bin/env python3

import sys

MAX_GAP = 4 # maximum length of equal bytes between two sequence of differences to be counted as part of difference

def print_usage():
    print("Usage: patch48_gen [--seq] [--ignore=ADDR1-ADDR2,ADDR3-ADDR4...] [--force=ADDR,length] <initial.rom> <changed.rom> [diff.bin]")
    print("ADDR is in hex, other integers are decimal")
    sys.exit(1)

filenames = [ x for x in sys.argv[1:] if not x.startswith("-") ]
if len(filenames) < 2:
    print_usage()

diff_filename = filenames[2] if len(filenames) > 2 else None
output_file = open(diff_filename, "wb") if diff_filename else None

def output(addr, value):
    def as_hex(i):
        return hex(i)[2:].zfill(4)

    if isinstance(value, list):
        for a,l in forced_lengths:
            if a == addr:
                if l < len(value):
                    print("Don't know how to make list shorted at", addr)
                    exit(3)
                else:
                    while l > len(value):
                        value.append(rom1[addr + len(value)])

        if output_file:
            output_file.write(bytes([ len(value), addr % 256, addr // 256 ] + value))
        else:
            print(as_hex(addr), len(value))
    elif isinstance(value, int):
        if output_file:
            output_file.write(bytes([ value, addr % 256, addr // 256 ]))
        else:
            print(as_hex(addr), value)
    else:
        raise Exception("Unsupported value type")

is_sequence = False
ignored = []
forced_lengths = []

options = [ x for x in sys.argv if x.startswith("-") ]
for o in options:
    if o == "--seq":
        is_sequence = True
    elif o.startswith("--ignore="):
        val = o.split("=")
        vals = val[1].split(",")
        for v in vals:
            begin, end = v.split("-")
            ignored.append((int(begin, 16), int(end, 16)))
    elif o.startswith("--force="):
        val = o.split("=")
        addr, length = val[1].split(",")
        forced_lengths.append((int(addr, 16), int(length)))
    else:
        print_usage()

rom1 = open(filenames[0], "rb").read()
rom2 = open(filenames[1], "rb").read()

if len(rom1) != len(rom2):
    print("ROM files must be of equal size!")
    exit(2)

seq = []
addr = None
gap = MAX_GAP
for i in range(len(rom1)):
    is_in_ignored = len([ x for x in ignored if x[0] <= i <= x[1] ]) > 0
    if not is_in_ignored and (gap < MAX_GAP or rom1[i] != rom2[i]):
        if is_sequence:
            seq.append(rom2[i])
            if addr == None:
                addr = i
            if rom1[i] != rom2[i]:
                gap = 0
            else:
                gap += 1
        else:
            output(i, rom2[i])
    elif is_sequence and addr is not None and addr >= 0:
        output(addr, seq[:-gap])
        addr = None
        seq.clear()

if addr is not None and addr >= 0:
    output(addr, seq)