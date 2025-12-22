import sys
import os

input_file = "SYS:PYIN/unswapped.rom"
output_file = "SYS:PYOUT/swapped.bin"

# Open file Read only
f = open(input_file, "rb")
data = f.read()
f.close()

# Byteswap: exchange two bytes at a time
swapped_data = []
data_length = len(data)

print "swapping started...get a cup of coffe "
for i in range(0, data_length, 2):
    if i + 1 < data_length:  # check if there is any 
        swapped_data.append(data[i+1])
        swapped_data.append(data[i])
    else:
        swapped_data.append(data[i])  # pad if not divdeable by 2

    # Progressbar update every 10000 bytes
    if i % 10000 == 0 or i == data_length - 1:
        progress = (i + 1) * 100 / data_length
        sys.stdout.write("\rprgress: %d%%" % progress)
        sys.stdout.flush()

# close progress bar
sys.stdout.write("\rProgress: 100%%\n")

swapped_data = ''.join(swapped_data)  # convert list to string

# check if swapped file is = 256 KB
if len(swapped_data) == 256 * 1024:  # 256 KB = 256 * 1024 Bytes
    print "256KB 1.X ROM detected. ROM will be Padded to become 512KB."
    swapped_data = swapped_data + swapped_data
else:
    print "Fancy 2.0 or higher rom detected. No padding required."

# Open File in write mode
f = open(output_file, "wb")
f.write(swapped_data)
f.close()

print "Saved as %s" % output_file
