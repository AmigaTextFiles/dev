Commandline utilities for C64 crossdevelopment
----------------------------------------------

Utilities written by Lasse Öörni (loorni@student.oulu.fi)

CovertBitOps C64 page: http://covertbitops.cjb.net

As these are text-only programs, they should be fairly portable.
Borland's free C compiler has been used by default to compile these
but any C compiler should do.


PRG2BIN.EXE
-----------

Usage: PRG2BIN infile outfile [bytes to strip, default 2]

This program removes a certain amount of bytes from the beginning of the
input file and saves it as the output file. With the default setting
of 2 bytes, it converts PRG files into raw binary files.


PRG2D64.EXE
-----------
Usage: PRG2D64 diskimage c64filename dosfilename

This program reads the PC filesystem file indicated by dos filename, and
writes it to the D64 diskimage given, with the desired c64 filename. Use
the underscore _ to represent blanks in the c64 filename.


D642PRG.EXE
-----------
Usage: D642PRG diskimage c64filename dosfilename

This program does the opposite, it extracts the c64 file from the diskimage
and writes it to a PC filesystem file indicated by dos filename. Like above,
Use the underscore _ to represent blanks in the c64 filename.


D64REN.EXE
----------
Usage: D64REN diskimage oldname newname

This program renames one file on a D64 diskimage. Use the underscore _
represent blanks in the filenames.


MAKEDISK.EXE
------------
Usage: MAKEDISK diskimage commandfile [diskname] [interleave]

This program creates a D64 diskimage from scratch, reading dos filename
c64 filename pairs from the commandfile and writing those files on the image.
A disk name and the sector interleave (10 is the default) can be optionally
given. Fiddling with the interleave is nice when trying to find the optimal
loading speed (minimal sector read waiting time) for an IRQ-loader. Use the
underscore _ to represent blanks in the c64 filenames.

Example of a commandfile: (from the BOFH game)
bofh.pak BOFH_V1.0
instr.pak BOFH_MANUAL
hiscore.bin BOFH_HISCORE

So, bofh.pak is written on the image as BOFH V1.0, instr.pak as BOFH MANUAL
and so on.


C64PACK.EXE
-----------
Usage: C64PACK infile outfile [switches]
Switches:
       /r Raw input and output file (no start address)

Packs a C64 file using my quite ineffective string-pack algorithm. (the only
good side is that the depacker is short). The input and output file can even
be same, because input file is first totally stored in memory.

If the /r switch is given, the input file is assumed to be a raw binary file
without the 2-byte starting address (like in PRG files) and the output file
will be raw binary also. Otherwise, the output file contains the same start
address as the input file.


C64UNP.EXE
----------
Usage: C64UNP infile outfile

This program reverses the compression done by above program. NOTE: this
program can only handle files with startaddress! All in all, I see no good
reason to use this program at all :)


PACKPRG.EXE
-----------
Usage: PACKPRG infile outfile execution address in hexadecimal

This program packs an executable PRG file with the above mentioned
algorithm and adds a depacker, making the file startable with a RUN
command. The depacker will start the executable with a JMP to the
execution address, with the value $37 in memory location $01 (enable
Basic ROM, Kernal ROM and I/O area)

This program needs the file DEPACK.S (depacker source code in DASM
source code format) in the current directory and DASM.EXE in the
path, because it invokes DASM to assemble the depacker and link it
with the packed executable data.


BENTON64.EXE
------------
Usage: BENTON64 infile outfile [switches]
Switches:
       /hXX Clip picture height to XX
       /wXX Clip picture width to XX
       /bXX Set background ($D021) color to XX
        By default it's the most used color.
       /sXX Set picture start address in hex (default a000)
       /r   Raw save (no .PRG start address included)
       /o   Optimal save (do not align bitmap & screen data to page boundary)
       /c   Save color data before bitmap

This is Benton Invertor 64 (heh...don't ask where the name comes
from :)), my C64 multicolor picture conversion program.

The input file has to be in Deluxe Paint IFF/LBM format. Switches
determine what portion of the picture will be converted, and to
what format.

By default a 320x200 picture would be saved like:

2 bytes startaddress
8192 bytes of bitmap data
1024 bytes of screen memory data
1024 bytes of color memory data
As you see, the bitmap/screen/color data lengths are rounded to the next
page (256 bytes) boundary.

By using the /o switch it would be:
2 bytes startaddress
8000 bytes of bitmap data
1000 bytes of screen memory data
1000 bytes of color memory data
(no wasted bytes)

Note that the background color isn't saved with the picture! This is a
downside.


CUTSCENE.EXE
------------
Usage: CUTSCENE infile outfile [switches]
Switches:
       /bXX Set background ($D021) color to XX. Default 0.
       /mXX Set multicolor 1 to XX.
       /nXX Set multicolor 2 to XX.
       /xXX Set Xsize to XX. (default 20)
       /yXX Set Ysize to XX. (default 9)
       /c   Don't save colormap

This is a customized conversion program for Metal Warrior cutscene pictures.
It converts a LBM picture into character (not bitmap) data + screen data.
The output file is always in raw binary format (no startaddress) and it's as
follows:

xsize*ysize chars of screen memory data
xsize*ysize chars of color memory data, if not disabled
as many chars of chardata as needed

Note that screen memory char codes start from 64, because in Metal Warrior
characters 0-63 were always reserved for the textscreen font. Not a really
useful program...


PIC2SPR.EXE
-----------
Usage: PIC2SPR infile outfile [switches]
Switches:
       /hXX Clip picture height to XX sprites
       /wXX Clip picture width to XX sprites
       /bXX Set background color to XX. Default 0.
       /mXX Set sprite multicolor 1 to XX.
       /nXX Set sprite multicolor 2 to XX.
       /sXX Set data start address in hex (default a000)
       /r   Raw save (no .PRG start address included)

This is the customized graphics conversion program for Metal Warrior 2, that
uses sprites in its cutscene graphics. Basically, an IFF/LBM picture will
be converted into sprites, the sprites going left-right and top-bottom in the
like this: (example has 4 sprites horizontally)

  1 2 3 4
  5 6 7 8

The sprites are saved in the .SPR format, which means raw sprite data with
the 64th byte in each sprite defining the sprite color.


SPRRIP.EXE
----------
Usage: SPRRIP ramdumpfile banknumber outfile [spritecolor]

This program takes a 64KB dump file containing the C64 RAM, such as C64.RAM
used by old versions of CCS64, and rips all 256 sprites from a certain
videobank. The bank numbers are the same that are written to the low 2 bits
of $dd00 (3 = $0000-$3fff, 2 = $4000-$7fff etc.). Destination file is simply
the sprite file name (in the same .SPR file format as used by SPREDIT.EXE)
and the optional spritecolor parameter is what to put in the 64th byte of
each sprite.

This is a program I rarely use :)
