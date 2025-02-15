import sys

DIFF_TO_PRINT = 5

if len(sys.argv) < 3:
    print("Usage: diff <file1> <file2>")
    exit(1)

data1 = open(sys.argv[1], "rb").read()
data2 = open(sys.argv[2], "rb").read()

if len(data1) != len(data2):
    print("Lengths are not equal!")

l = min(len(data1), len(data2))

diff_count = 0

for i in range(l):
    if data1[i] != data2[i]:
        if diff_count < DIFF_TO_PRINT:
            print(f"{i:04X}: {data1[i]:02X} {data2[i]:02X}")
        diff_count += 1

if diff_count > 0:
    print(f"...total {diff_count} differences")
    exit(2)
else:
    print("Files are equal!")
    exit(0)