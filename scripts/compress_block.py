import sys

if len(sys.argv) != 3:
    print("Usage: compress_block <input file> <output file>")
    exit(1)

data = open(sys.argv[1], "rb").read()

pos = 0

result = bytearray()
countPos = -1

while pos < len(data):
    d = data[pos]
    
    # Should RLE?
    repeated_bytes = 0
    for j in (range(pos + 1, len(data))):
        if d == data[j]:
            repeated_bytes += 1
        else:
            break
    
    if repeated_bytes >= 2:
        if repeated_bytes < 0x80:
            # Regular RLE
            result.append(0x80 | (repeated_bytes))
            result.append(d)
        else:
            # long block RLE
            result.append(0xFF)
            result.append(d)
            result.append((repeated_bytes) % 256)
            result.append((repeated_bytes) // 256)
        pos += repeated_bytes + 1
        countPos = -1
    else:
        if countPos == -1:
            countPos = len(result)
            result.append(0)
        else:
            result[countPos] += 1
        result.append(d)
        pos += 1

        if result[countPos] == 0x7F:
            countPos = -1

open(sys.argv[2], "wb").write(result)