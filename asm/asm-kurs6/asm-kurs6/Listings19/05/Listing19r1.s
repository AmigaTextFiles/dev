
; Listing19r1.s
; Disk logging
; 
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

di <mode> [<track>]   Break on disk access. R=DMA read,W=write,RW=both,P=PIO.
						Also enables level 1 disk logging.   
did <log level>       Enable disk logging.


																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
																				; 1. 																				

>di
Disk breakpoint mode --- track -1												; -1 = failure?
>di 2
Disk breakpoint mode --- track -1
>di 3 12
Disk breakpoint mode --- track 12												; no mode RWP selected
;------------------------------------------------------------------------------
>di R 12																		; correct disk breakpoints
Disk breakpoint mode R-- track 12
>di W 12
Disk breakpoint mode -W- track 12
>di RW 12
Disk breakpoint mode RW- track 12
;------------------------------------------------------------------------------
																				; 2. 
>did																			; no information about different log level
Disk logging level 0
>did 2
Disk logging level 2
>did 4
Disk logging level 4

																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
>di r 0
Disk breakpoint mode R-- track 0	
																				; insert disk in df0: and press start
																				; to stop by access on track 0 		
>g
DSKLEN: drive 0 motor  on cylinder  0 sel yes rw mfmpos 52533/101344
5295 5555 5255 5555|5495 5555 5555 5555 5495 5555 5555 5555 5295 5555 5255 5555 5295
side 0 dma 2 off 1 word 5555 pt 00002064 len 9CBE bytr 80AA adk 1100 sync 0000
  D0 00009CBE   D1 00000400   D2 00009CBE   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00C04800   A1 00DFF000   A2 00002064   A3 00C04730
  A4 00FEA22A   A5 00000000   A6 00C03AA4   A7 00C04A8C
USP  00C04A8C ISP  00C80000
T=00 S=0 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 4e75 (RTS) 43fa (LEA) Chip latch FFFF9CBE
00fea232 4e75                     rts  == $00fea1fc
Next PC: 00fea234

;------------------------------------------------------------------------------
>did 4
Disk logging level 4
>di R 21
Disk breakpoint mode R-- track 21
>g
DSKLEN: drive 0 motor  on cylinder 54 sel yes ro mfmpos 90127/101344
2A28 A92A AAAA 2A29|2929 292A 2928 AA24 A224 A4A5 24A4 A525 292A A8A8 AA92 5554 9492
side 0 dma 2 off 5 word 2A29 pt 00002B8C len 98F0 bytr 8051 adk 1500 sync 4489
SYNC: drive 0 motor  on cylinder 54 sel yes ro mfmpos 92688/101344
5455 2AAA AAAA 4489|4489 5514 A52A 5544 AAA9 2AAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA
side 0 dma 2 off 5 word 4489 pt 00002B8C len 98F0 bytr 8012 adk 1500 sync 4489

DSKLEN: drive 0 motor  on cylinder 55 sel yes ro mfmpos 98972/101344
9555 2A51 4A52 5149|1524 492A AA91 5255 1512 A455 24AA 52A9 1149 5111 514A A949 124A
side 0 dma 2 off 15 word 5149 pt 00005DC6 len 98F0 bytr 80A2 adk 1500 sync 4489
SYNC: drive 0 motor  on cylinder 55 sel yes ro mfmpos 5648/101344
AAAA AAAA AAAA 4489|4489 5515 2AA5 5544 AAA9 2AAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA
side 0 dma 2 off 15 word 4489 pt 00005DC6 len 98F0 bytr 8089 adk 1500 sync 4489

;------------------------------------------------------------------------------

first line:
	DSKLEN: drive 0 motor  on cylinder 54 sel yes ro mfmpos 90127/101344

DSKLEN:		- info label, like SYNC:
			- Floppy drive state (motor, cylinder, selected, side select)
drive 0		- it's df0:	(drive 0,1,2,3) df0:, df1:, df2:, df3:
motor on	- motor state (motor on/off)
cylinder 0	- track 0, side 0 (info)
sel yes rw 	- Drive selected (yes) or not selected (no). (SEL0-SEL3 bits)
mfmpos 90127/101344 - MFMPOS = current bit position of track/total length.
					- Raw bit stream dump (| = current position)
total length: 101344	- Total number of bits in this track.
						- PAL: 3546895 / (7 * 5)
						- NTSC: 3579545 / (7 * 5)
						(7 = clocks per bit, 5 = 5 revs/second)
(It is theoretical max bits that Amiga can write. It is not logical floppy format size.)
(MFM=11*(2*(64Byte+512Byte))*8=101376 Bits logical floppy format size?)

;------------------------------------------------------------------------------
second line:
	 2A28 A92A AAAA 2A29|2929 292A 2928 AA24 A224 A4A5 24A4 A525 292A A8A8 AA92 5554 9492
data - 17 words
| = current position - from the raw bit stream dump (in this case 90127)

;------------------------------------------------------------------------------

third line:
	side 0 dma 2 off 5 word 2A29 pt 00002B8C len 98F0 bytr 8051 adk 1500 sync 4489

side 0		- see cylinder 0
dma 2		- DMA state.
						0 = off.
						1 = first DSKLEN write only done.
						2 = read DMA active.
						3 = write DMA active.
off 5		- 0-15		 Current bit position in current loaded word. (Not very useful)	
word 2A29	- current value
pt 00002B8C - DSK pointer ($dff020,22 DSKPTH, DSKPTL)
len 98F0	- length ($dff024 DSKLEN)
bytr 8051	- DSKBYTR ($dff01A DSKBYTR)
adk 1500	- ADKCON ($dff010 ADKCONR)
sync 4489	- DSKSYNC ($dff07E DSKSYNC)

;------------------------------------------------------------------------------

SYNC: drive 0 motor on cylinder 69 sel yes rw mfmpos 5648/101344
AAAA AAAA AAAA 4489|4489 5545 2AA5 552A AAA9 2AAA AAAA AAAA AAAA AAAA AAAA AAAA AAAA
side 0 dma 2 off 0 word 4489 pt 00070000 len 9F40 bytr 8044 adk 1500 sync 4489

1. What means SYNC?
It means debug log message was caused by DSKSYNC match. Another possibility is DSKLEN write (DMA started).

2. It's this preamble and syncword? AAAA AAAA 4489|4489?
It always shows last 4 words. Nothing to do with sync.

3. what triggers this break?
DMA start when track is zero. (R=read default, W=write, P=DSKBYTR CPU read)

4. are there different log level and for what?
did <log level> Enable disk logging.
Undefined :) The bigger the value the more gets dumped.

5. for what is this breakpoint and logging feature helpful? maybe to understand mfm/gcr-encoding?
or disc data structure?
Debug/crack/hack some loader? Log is usually enough to find out where it is called.

Sorry, I found no example explanation... but I get an advise:

Learn how Amiga MFM encoding works 

WinUAE does not care or need to know. Raw bit stream is DMA'd to memory. MFM decoding is done
by Amiga side software (trackdisk.device or game/demo trackloader).
In theory UAE could decode it but it would return garbage if format is not standard AmigaDOS.