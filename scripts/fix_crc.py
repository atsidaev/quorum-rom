import sys

if len(sys.argv) != 4:
    print("Usage: fix_crc <file.rom> <file.sym> <LABEL_NAME>")
    exit(1)

# Find address of the label
addr = -1
for l in open(sys.argv[2]).readlines():
    if l.startswith(sys.argv[3] + ":"):
        addr = int(l.split(" EQU ")[-1], 16)

if addr < 0:
    print("Cannot find patch position")
    exit(2)

data = open(sys.argv[1], "rb").read()
data = list(data)

existing_crc = data[addr]
data[addr] = 0

# Calc
sum = 0
for d in data:
    sum += d

crc = (256 - (sum % 256)) % 256
print(f"CRC error for file is {crc}")

if crc == existing_crc:
    print("CRC already correct")
    exit(0)

print(f"Patching at 0x{addr:X}")
data[addr] = crc
open(sys.argv[1], "wb").write(bytes(data))
exit(0)

