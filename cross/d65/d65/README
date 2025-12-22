d65 v0.2.1 -- symbolic 65xx disassembler
Release date: 18th June, 1994 (opcode table patched 6th January, 2000)
Copyright (C) 1993, 1994, 2000 Marko Mäkelä

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


This document describes the second public release of my d65 utility, a
symbolic disassembler for the 8-bit 65xx processors (currently only
the NMOS 6502 and the Rockwell R65C02 instruction sets are supported).
Unlike the umpteen conventional 6502 disassemblers on the scene, this
program detects data blocks extremely reliably and has very many scanning
options.

I started planning the program in the spring 1993, and wrote a fairly
complete pseudo-code version of the most important routines.  Due to
the complexity of the project, I deferred the project until early 1994.
As I become isolated from the Internet and from my 65xx equipment, I
had to hassle with something that kept my mind working in the middle
of beemers and Multiple Sklerosis programs.

As you can see from the version number, the program is not complete
yet.  The output is very ugly and does not even use all information
that is available, and the layout of this document sucks, but the
scanning routines work flawlessly, just like I planned, or even
better.

I have compiled and tested the program on a minimal Linux system,
whose heart is an i386SUX running at 16 MHz and who has 2 MB of
memory.  (-: Should I mention the i387SUX, which won't be
significantly employed by my program? :-) The utility also compiles
under SunOS, HP-UX and Ultrix, although the long command line options
are not available on these systems, unless the GNU C compiler is
properly installed.  For some pervert reason, the program fails to
create some labels when compiled on HP-UX with the native CC.  So, if
you want to compile the program for that ill operating system, you
have to use gcc.  If the GNU getopt library is not installed, like here,
you have to modify the main.c file or to undefine __GNUC__ while compiling.
I would appreciate a patch that makes the program to work with the native
HP-UX CC.

As I hate Multiple Sklerose Disk Operating System (MS-DOS), I did not
bother trying to write any #ifdefs for it.  Anyway, there should be no
reason why the program would not run on any beemer with at least 256 or
384 kilobytes of memory.  You only have to use the large memory model
and to replace the getopt library with your own routine.  If you make an
MS-DOS port of the software, please send your modifications to me.
Also, if you make any patches to the program, like modify the output
routine to produce an output that is compatible with some particular
assembler, I would be very grateful for the diffs.

OK, enough hype.  The rest of this document will concentrate on the use
of the program.

The only input the d65 needs is a binary file containing 6502 code, in
Commodore (partially R.I.P.) format.  That is, the first two bytes (in
low-endian order) specify the address from which on the following
bytes (0 to 65536) will be copied to.  There is no execution address
information in the file, but you can specify one or more execution
addresses if you want to.  You can also specify which memory areas
contain data, so that the program wouldn't scan them in vain, and you
can choose some option flags, if you do not like the default
behaviour.

Command line usage:

    d65 [options] [filename]

Note that you may specify the options in any order, and you can specify
the same options multiple times. If any options exclude each other, the
last option will take effect.

If you do not specify any filename, the program will read the file from
the standard input.

Command line options:
Note: the long options (the ones with two dashes in the beginning) are
only available if the program was compiled with GNU C.

  --datablock xxxx-yyyy
  -b xxxx-yyyy
    Defines the memory range xxxx to yyyy (hexadecimal, inclusive)
    to be a data block.

  --datablock !xxxx-yyyy
  -b !xxxx-yyyy
    Defines the memory range xxxx to yyyy to be a data block that does
    not contain any vectors.

  --datablock ?xxxx-yyyy
  -b ?xxxx-yyyy
    Defines the memory block from the address xxxx to yyyy to be unused;
    no valid routine may contain instructions whose parameter lie in this
    range.  Useful for providing enhanced protection against misinterpreting
    data to be program code, but be careful, or some code may be listed as
    data.  For instance, the Commodore 64 firmware uses the base address CFFF
    when initializing the video chip, and the BASIC interpreter uses the
    addresses 9FEA and 9FEB while loading the instruction pointers.
    In addition to this, there are a number of BIT instructions used for
    skipping the next instruction.  Thus, you must allow addresses like 1A9,
    2A9 and so on.

  --datablocks filename
  -B filename
    Causes data block addresses to be read from a file.  The file must
    consist of lines like

      xxxx-yyyy

    or

      !xxxx-yyyy

    or

      ?xxxx-yyyy.

    See the -b or --datablock option for their function.
    You should have received an example datablock specifier file,
    "datablocks", with this distribution.  I used it while debugging
    the program and producing dumps of the Commodore 64 firmware
    (BASIC ROM, character generator ROM and the KERNAL ROM catenated
    to a single file).

  --labels filename
  -L filename
    Causes label names to be read from a file.  The file format is
    as follows:

      xxxx:label

    where xxxx is an address (hexadecimal), and label is the
    symbolic label which should substitute the address.

  --routine xxxx
  -r xxxx
    Specifies a start address of a routine in the program file.

  --routines filename
  -R filename
    Causes routine addresses to be read from a file that has one
    hexadecimal address on its each line.  An example file for
    the C64 KERNAL is in the file "routines".

  --addresses option
  -a option
    Determines if and what kind of address information should be dumped
    with the source code.  The following options are supported:

       disabled
         Dump only the source code.
       enabled
         Write the current address to the beginning of each line.
       dump
         Write the current address and produce a hexadecimal dump of
         the bytes for which the statement was generated.
         This is the default.

  --datablock-detection option
  -d option
    The datablock detection option must be one of the following:

       poor
         As many bytes as possible will be listed as program code, even
         tough the routines contain illegal instructions.
       extended
         Oops, this option is not actually being checked in the source files!
         Anyway, when it is used, other routines than you specify may not
         lead to invalid code.
       skip-scanning
         The program addresses that are not called by any routine specified
         will not be scanned for routines.
       strict
         If any of the routines whose addresses you specified ever calls
         any routine that leads to illegal code, the disassembling process
         will be exited immediately. This is the default option.

  --processor machine
  -p machine
    Currently the following instruction sets are supported:

       all-nmos6502
         All 256 NMOS 6502 opcodes will be allowed.
       rational-nmos6502
         The NMOS 6502 opcodes that have some rational use will be allowed.
       useful-nmos6502
         The opcodes that might really be useful will be allowed.
       traditional-nmos6502
         Only the widely known undocumented instructions that are combinations
         of ALU and RMW instructions, like SREO (LSR+EOR) will be allowed.
       standard-nmos6502
         Only the official opcodes will be allowed.  This is the default.

  --no-external-labels
  -e
  --external-labels
  -E
     These options specify whether labels should be created for addresses
     that lie outside of the program's address range.  The default is -E.

  -address-tables option
  -t option
    The following address table detection options are available:

       ignore
         No address tables will be detected.
       detect-all
         Address tables with any labels will be detected.
       detect-internal
         Address tables with labels whose addresses lie inside the
         program's address range will be detected.  This is the default.

  --no-address-statements
  -s
  --address-statements
  -S
    These options specify whether the program should scan for statements
    like LDA #<label.  They won't be detected in the current version.
    Anyway, -S is the default.

  --no-suspect-jsr
  -j
  --suspect-jsr
  -J
    These options specify whether the JSR instruction should be suspected
    not to return to the following address.  For instance, the C128 KERNAL
    has the PRIMM routine (PRint IMMediate) that prints a null-terminated
    string starting right after the JSR instruction, and returns to the
    instruction following the terminating null byte.  The default is -j.

  --no-one-byte-routines
  -o
  --one-byte-routines
  -O
    These options are for permitting or inhibiting routines that consist
    of a single BRK, RTS, RTI or STP instruction, or a conditional branch.
    The default is -o.

  --no-stupid-jumps
  -m
  --stupid-jumps
  -M
    With these options, you can rank routines with jumps or branches to
    the current address as invalid.  The BVC * instruction will be accepted
    in any case, as the V flag can be set by a hardware signal on some
    processors.  The default option is -m.

  --no-allow-brk
  -w
  --allow-brk
  -W
    These options control if the BRK (and STP) instructions should be treated
    just like RTI and RTS.  The default is -w, flagging all routines with a
    BRK or STP to be invalid.

  --no-suspect-branches
  -c
  --suspect-branches
  -C
    Normally, the d65 does not except routines to continue after a relative
    branch, but it assumes that the branch destination addresses are valid.
    However, someone might use something like LDA#2 : BEQ *-1 to confuse
    d65.  If you chose the -C option, such routines would be treated as valid.

  --no-cross-reference
  -x
  --cross-reference
  -X
    Another unimplemented option.  Default is -x.

  --verbose
  -v
    If you define this flag, d65 will keep outputting more or less informative
    messages, letting you know that it has not jammed.

  --help
  -?
    When this option is defined, the d65 will print a short copyright message
    and an even shorter explanation on using the program.


Well, that was all, folks!  Except a newer version to be published in late
1994.  Hopefully it will be version 1.0, with all bells and whistles I would
like to have.  In addition to the miserably ugly output and to the
unimplemented options, I would like detection of address tables like the
following:

     .BYTE <label1
     .BYTE <label2
     .BYTE <label3
     [...]
     .BYTE >label1
     .BYTE >label2
     .BYTE >label3

The major version number 2 could be reserved for the following enhancements:

The options should not be global, but adjustable for several memory
ranges.  For instance, if support for the 65C816 instruction set will
be added, it would be useful if you could specify the memory ranges
where the native 65C816 instruction set is applicaple and where the
6502 emulation mode is in use.  Well, it would be even better if the
program could determine the mode itself, but it wouldn't be reliable
enough, I'm afraid.  Anyway, if you have any 65C816 code, send it to
me, if you would like such features.  I have worked only with the NMOS
6500 series of microprocessors, so I really do not need any other
instruction sets.

Also some sort of interactivity would be nice.  Maybe a
machine-language monitor like interface where the user could mark
blocks as data and have routines scanned to the end, and where the
program could ask for confirmation when scanning the remaining memory
for routines.



[6th January 2000: Addendum]
I had big plans about this program, but I never got around to implement
the planned features.  The first version was functional enough to satisfy
my needs, and I didn't get much feedback from users.  Maybe I will continue
the development when I have retired in about 40 years, maybe not.

Marko Mäkelä <Marko.Makela@NIC.FUNET.FI>
