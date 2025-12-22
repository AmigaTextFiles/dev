Introduction

SX4Amiga is a hard/software package for programming the SX series of microcontrollers 
from Scenix. These controllers have a PIC compatible CPU and are designed to operate at 
very high speeds ranging from 50 to 100MHz. Combined with their real RISC core these 
processors reach speeds of 100Mips, making them the fastest microcontrollers in their 
class. The SX chips are available in 50 and 100mhz version with either 18 or 28 pins. The 
chips are called SX18AC, SX18AC100, SX28AC and SX28AC100.

Until recently, the only programmer available for these chips is the expensive commercial 
SX-Key from Parallax. The software for this programmer is only available for Windows 
and later Linux systems. Then there was Fluffy, a DIY programmer. This system was also 
only available for PC.

And now, there is SX4Amiga. Only available for Amiga systems !


SX4Amiga features:

-ISP programming adapter.
-19K2 RS232 interface
-2.5 mips microcontroller to handle timing sensitive low level protocol
-tested with SX18/SX28 types, fabrication dates 9849/9830

Hardware

The programmer is built around a pic16c/f84 processor so you need access to an pic 
programmer. Unfortunately it isn't possible to do without this processor because of the 
VERY timing sensitive programming algorithm of the SX. Fortunately the rest of the 
schematic is very simple. The processor is clocked by a 9.8304MHz crystal. This 
frequency has been chosen because it can be divided by 512 giving a baud rate for the 
serial interface of exactly 19200 bps.
The programmer needs 2 voltages, a +5V VCC supply and an +12.5V VPP supply. In 
my implementation of SX4Amiga these voltages are derived from an unstabilized 12V 
mains adapter using an 78L12 and an 7805 but you can also derive them from other 
sources. (you can by example, tap +5V from the board you are programming and use a 
switched step-up regulator to create +12.7V, as is done in the real SX-Key) If you take a 
look at the diode in the 78L12 circuit, you can see that it makes sure that +12.6 is 
delivered at the emitter of T1. When T1 is turned on, the saturation voltage of 0.2V makes 
that +12.4V is delivered at he SX OSC1 pin. The 100Ohms resistor in series with T1 is to 
limit the curent flowing into OSC1 in case of a malfunction. I used mosfets for T2 and T3 
because they don't need an extra resistor. If you can't get hold of these mosfet's or find 
them too expensive, you can also use a bc547 with a 22Kohms resistor in the base 
connection. The SX4Amiga programming adapter has 2 status led's. The red led will light 
when the 12.4/12.5V programming voltage is active. The green led acts as a power/busy 
led. This led will light when the porgrammer is on and it will dim or start to flicker when 
there is communication with the Amiga.

Software

Included in the archive is a little shell-utility called (surprisingly) SX4Amiga. SX4Amiga 
uses the serial.device (standard amiga serial port) to connect to the SX4Amiga hardware at 
19k2 baud. Other ports can be used by starting SX4Amiga with the following arguments:

SX4Amiga <device> <number>


The procedure to program an SX chip is the following:
1)      start SX4Amiga in a shell.
2)      Choose 'L' and type in the path of the HEX file you want to program.
3)      Choose 'F' and enter the right Fuse and FuseX values
4)      Choose 'T' and enter the Erase/Write time in ms.
5)      Buffer,Fuse, FuseX and Timing must now show the right settings.
6)      Connect the programming adapter to the Amiga and the SX chip (If you haven't
        already done so)
7)      Choose 'E' to erase the SX chip
8)      Choose 'W' to program the SX chip.

With the 'T' option you can change the programming times in ms. (Refer to the SX 
datasheet for the right values.) At the time of writing there are 2 revisions of the SX 
silicon; the old revision and the new revision (refer to www.scenix.com for an errata on 
silicon revisions). The old revison has a programming time of 100ms, the new revision has 
a programming time of 20ms. Note that these 2 revisons also differ in the Fuse/FuseX 
layout, so take care! The default setting of SX4Amiga is 100ms, which is also the 
maximum value.

The SX won't work if the FuseX bits 11:7 are trashed with the wrong values. To overcome
this situation (if it might happen) option 'O' is added. This option will overwrite FuseX
with the current entered values. (including bits 11:7) Note that this option also erases
the rest of the chip !

Assembler

An assembler is not included in this project. Fortunately there is an excellent pic 
compatible cross compiler available for the Amiga: Apic. If you donwload the SX manual 
you will see that the SX uses other mnemonics than the PIC. They are however opcode 
and function compatible with the PIC lookalikes. Use therefore normal pic mnemonics on 
the Amiga. There are 3 instructions that you will need on the SX but which are not 
available in the PIC:

        mode
        ret
        reti

To get around these problems the include file SX.inc replaces them with the instructions 
bcf PCL,1 2 and 3. This are bit clear instructions on the program counter and must 
therefore not be used in your program. The SX4Amiga programming tool replaces them 
again with the proper opcodes for mode, ret and reti again. Included in the archive is a
example program that flashes led's connected to RA,RB and RC. Study this to get started.

Hints&Tips

The SX chips are still very new and a little beta. If you have bought an SX, write down
the date/type stamp and look it up at www.scenix.com. Some production dates have little
errors. This can save you days of searching for a software bug while the hardware
faulty ! Furthermore, there are quite some websites dedicated to the SX. These are often
very helpfull.

Happy programming with the fastest MCU in the world !


Contact

d.vanweeren@wanadoo.nl


History

V0.90ß  ??-07-1999      First working version and my first program is running on SX

V0.93ß  24-12-1999      -Added Overwrite option to overwrite bits 11:7 of FuseX
                        -Fixed a bug that always setted CF bit of FuseX to 1
                        -Cleaned up the code.

V0.95ß  17-06-2000      -Timing changed to support new revison SX devices. The old
                         timing caused random crashes when running SX at high speeds.
                        -Improved programmimg speed. (optimized firmware routines)


V0.96ß  02-12-2001      -I have a new email adress !
                        -added all sourcecodes.
                        -development stopped.



