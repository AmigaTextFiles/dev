
; Listing19k2.s
; DMA Debugger
; cycle-exact is disabled
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

 v <vpos> [<hpos>]     Show DMA data (accurate only in cycle-exact mode).
 
 1.  v <vpos>																	; mousepointer is in the upper-left corner on screen
 2.  v <vpos> [<hpos>]															; mousepointer is not in the upper-left corner on screen

																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
																				; 1.
																				; v <vpos>		mousepointer is in the upper-left corner on screen

>v 43																			; v $2b is also possible

Line: 2B  43 HPOS 00   0:
 [00   0]  [01   1]  [02   2]  [03   3]  [04   4]  [05   5]  [06   6]  [07   7] 
                     COP  08C            COP  180            COP  08C           ; copper on all even cycles
 W                       0180                005A                0182           
                     00014FB4            00014FB6            00014FB8           
 C7D43800  C7D43A00  C7D43C00  C7D43E00  C7D44000  C7D44200  C7D44400  C7D44600 

 [08   8]  [09   9]  [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15] 
 COP  182            COP  08C            COP  184            COP  08C           
     0FFF                0184                0002                0186           
 00014FBA            00014FBC            00014FBE            00014FC0           
 C7D44800  C7D44A00  C7D44C00  C7D44E00  C7D45000  C7D45200  C7D45400  C7D45600 

 [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]	; ok SPR on odd cycles
 COP  186            COP  08C            COP  1A0  SPR  144  COP  08C  SPR  146 
     0F80                01A0                0000      0000      01A2      FC00 
 00014FC2            00014FC4            00014FC6  00000C84  00014FC8  00000C86 
 C7D45800  C7D45A00  C7D45C00  C7D45E00  C7D46000  C7D46200  C7D46400  C7D46600 

;------------------------------------------------------------------------------
>m 0c80 5																		; memory view from mousepointer
00000C80 2B3F 3B01 0000 FC00 7C00 FE00 7C00 8600  +?;.....|...|...				; 0000 FC00 data
00000C90 7800 8C00 7C00 8600 6E00 9300 0700 6980  x...|...n.....i.
00000CA0 0380 04C0 01C0 0260 0080 0140 0000 0080  .......`...@....
00000CB0 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000CC0 0000 0000 0000 0000 0000 0000 0000 0000  ................
>x
;------------------------------------------------------------------------------
																				from EAB:
																				SPR = access type
																				144	= custom register accessed	; $dff144 SPR0DATA Sprite 0 low bitplane data
																				146	= custom register accessed	; $dff146 SPR0DATB Sprite 0 high bitplane data
																				Number below is value written/read (144,146)
																				Larger number below is address of access (in this $dff144 SPR0DATA 00000C84)
																				Final number is UAE internal cycle counter (C7D46200)


																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
																				; 2.
																				; v <vpos> [<hpos>]  mousepointer is not in the upper-left corner on screen

>v 43 10																		; both decimal 43 and 10, $2b and 0A
Line: 2B  43 HPOS 0A  10:
 [0A  10]  [0B  11]  [0C  12]  [0D  13]  [0E  14]  [0F  15]  [10  16]  [11  17]	; now the mousepointer
 COP  08C            COP  184            COP  08C            COP  186			; is on another y position
     0184                0002                0186                0F80           
 00014FBC            00014FBE            00014FC0            00014FC2           
 C2E75800  C2E75A00  C2E75C00  C2E75E00  C2E76000  C2E76200  C2E76400  C2E76600 

 ;-----------------------------------------------------------------------------

																				; mousepointer is in the upper-left corner on screen
 >v 43 16
  [10  16]  [11  17]  [12  18]  [13  19]  [14  20]  [15  21]  [16  22]  [17  23]	; ok SPR on odd cycles
 COP  186            COP  08C            COP  1A0  SPR  144  COP  08C  SPR  146 
     0F80                01A0                0000      0000      01A2      FC00 
 00014FC2            00014FC4            00014FC6  00000C84  00014FC8  00000C86 
 C7D45800  C7D45A00  C7D45C00  C7D45E00  C7D46000  C7D46200  C7D46400  C7D46600 

>x																				; leave debugger
;------------------------------------------------------------------------------
																				; or from EAB
>v 97
Line: 61  97 HPOS 00   0:
[00   0] [01   1] [02   2] [03   3] [04   4] [05   5] [06   6] [07   7]
                  COP  08C          COP  180          COP  08C        
W                     0180              0414              0182        
                  0002DE74          0002DE76          0002DE78        
D60BB400 D60BB600 D60BB800 D60BBA00 D60BBC00 D60BBE00 D60BC000 D60BC200

																				First "slot":		; first DMA-slot	

																				line 97 ($61)
																				COP = access type.					
																				08C = custom register accessed	; $dff08c COPINS Coprocessor inst fetch identify
																				Number below is value written/read (0180)
																				Larger number below is address of access (in this case copper list pointer, 0002DE74)
																				Final number is UAE internal cycle counter (D60BB800)

>o 2de74 1																		; Copperlist
0002de74: 0180 0414		;  COLOR00 := 0x0414

																				Copper move cycle: (0180 0414)
																				Load first word to $08c. (0002DE74: 0180)
																				Load second word to custom register loaded in first word.
																				(0002DE76: Write $414 to $dff180)

;------------------------------------------------------------------------------
																				; or from EAB:

Code:
[80 128]  [81 129]  [82 130]  [83 131]  [84 132]  [85 133]  [86 134]  [87 135]
           BLT  072  BLT  070  BLT  000            BLT  072  BLT  070  BLT  000
 B             0000      03FF      0000  B             0000      F800      03FF
           0002B27E  0001B4AE  0001B4AC            0002B2B8  0001B4E8  0001B4AE

																				So 81 to 83
																				072 (0000 from Address 0002B27E) -> BLTBDAT Blitter source B data reg
																				070 (03FF from Address 0001B4AE) -> BLTCDAT Blitter source C data reg
																				000 (0000 from Blitter to Address 0001B4AC ??? -> BLTDDAT Blitter destination data register

																				Ok. He probably reads a word (0000) from 0002B27E (Source?), then reads 03ff
																				from the target? 0001B4AE, combines both values and then stores the result 0000
																				to the target. Am I right? But why differ the two target addresses by two?

																				[Edit] Ah, this two bytes offset above seem to be the effect of the pipelining.

																				You can use -blitterdebug 1 to enable blitter log messages which should help to
																				find out when blitter was started and used parameters.

																				Current (and previous frame) output to text file debugger command sounds useful.


;------------------------------------------------------------------------------
; from EAB

note:
2.7.0 Beta 4
- Added CPU interrupt level information to visual DMA debugger. Each scanline
has extra pixel on left side of DMA usage image that shows scanline's highest
CPU interrupt level	

2.0.0 Beta 2
- "DMA cycle debugger", v <vpos> [<hpos>] lists selected scanline's DMA
activity, hpos, custom register, data, address. This made compatibility
testing much easier. (just compare this data to logic analyzer data)
Second row can contain extra characters:
N = blitter cycle given for CPU,
b = blitter interrupt,
B = blitter finished. (not necessarily exactly same thing)

B = blitter idle cycle. Cycle that blitter needs to be free but blitter does
not use it and it is available for the CPU (Blitter start has always 2 idle
cycles, purpose unknown)
So the blitter takes all slots he can get. Even Sprite or Bitplane-Slots, if
they are not used. I was confused because I have a book here that explicitely
states "The blitter only uses the even bus cycles."

Note that currently mode can't be changed after it has been enabled.
After it has been enabled (visual or not),
v <vpos> <hpos> shows detailed scanline DMA/CPU usage.

v <vpos> [<hpos>] = show detailed cycle usage of line <vpos>. hpos is optional.
(also don't use invalid vpos or hpos, it probably will crash too..)

4.5
- Added DMA debugger non-nasty blitter extra information: 
's' (CPU will get next blitter cycle) and 'S' (CPU stole this cycle from blitter)

There is also hardcore bus debugging mode, type vd to enable it,
v <scanline> [<start cycle>] shows what happened in selected scanline in previous
 frame, cycle by cycle.

 DMA debugger blitter slots are now marked as BLT-x (normal), BLF-x (fill) or
 BLL-x (line). x = channel. RFS, DSK, AUD, SPR and BPL slots include channel numbers.
  (Easier to remember than xxxDAT register address numbers)

DMA debugger now includes DDFSTRT (0), DDFSTOP (1) and hardwired DDFSTOP (2)
positions if match caused bitplane DMA to start (DDFSTRT) or stop
(DDFSTRT/hardwired DDFSTOP).

DMA debugger uses first refresh slot to show if line is vertical blanking (B),
vertical sync (S) or vertical diw is open (=), second refresh slot is used for
long field (F) and long line (L). These special slots are marked with '*' to not
(too easily) confuse them with same symbols in other slots. Horizontal diw 
('(' and ')'), programmed horizontal blanking ('[' and ']') and programmed
 horizontal sync ('{' and '}') are also marked.

"Copper wake up" (W) and "Copper wanted this cycle but couldn't get it" (c)
 markers in DMA debugger had disappeared. Skip also shows 'W' if SKIP skipped.

;------------------------------------------------------------------------------
; from EAB
DMA map - show only DMA slot usage (DMA data transfers).
Extra letters are used to show some special conditions.

Extra letters:

v 100 100
Line: 64 100 HPOS 64 100:
 [64 100]  [65 101]  [66 102]  [67 103]  [68 104]  [69 105]  [6A 106]  [6B 107]
 BLT  000      114    CPU-WW        110   CPU-WW	BLT  074  BLT  000      112		; dB-B-ddB
    FFFF      0007    N  0000      0000  B  0000      0104      FFFF      FFFF
 00058B54  000439B8  00040966  0004398C  00040968  00058B50  00058B52  0007BCDE
 07635400  07635600  07635800  07635A00  07635C00  07635E00  07636000  07636200

 [6C 108]  [6D 109]  [6E 110]  [6F 111]  [70 112]  [71 113]  [72 114]  [73 115]
  CPU-WW       114	 BLT  074      110   BLT  000    CPU-WW                112		
 B  0000      FFFF      0000      0000       FF03  N  0000   B             FFFF
 0004096A  000439BA  00058B4E  0004398E  00058B50  0004096C            0007BCE0
 07636400  07636600  07636800  07636A00  07636C00  07636E00  07637000  07637200


B = blitter needed this cycle but it is also available for CPU if CPU needs it.
  (=blitter idle cycle which means blitter did some internal operation but it
   didn't need bus hardware = CPU can still access chip bus)

N = bus cycle given to CPU due to blitter nasty not enabled. Note that logic of
   blitter nasty is not what you probably think it is: If CPU waits more than 3 cycles,
   it gets next blitter cycle. ANY DMA cycle counts, it does not need to be blitter
   cycle, only requirement is that blitter is also active. In this case result was
   1 lost cycle, CPU got cycle that was originally going to be blitter idle cycle
   which CPU would have gotten automatically. But because priority was given to CPU,
   blitter couldn't use it..

CPU-WW = CPU Write Word.

Cycles without extra text: DMA transfer, for example $65 = $0007 written to $0114 (BPL3DAT)

Cycle is unused because CPU memory access takes 4 cycles (=2 DMA slots). It can't
do back to back memory accesses, there is always one DMA cycle between accesses.

68000 memory access is basically in two parts, first half sends address, second
half transfers data. CPU can always do first part of access, even if bus is currently
in use. When second part is about to start, if bus is not available, Agnus/Gary
won't complete the cycle and CPU simply thinks it is accessing memory with (possibly
lots of) wait states.

"black field" =  like $72
It is considered free because cycle is not "used" and it is available for CPU if it wants
(No data is transferred when blitter does internal stuff. Many normal block move
blitter operations and line mode also includes idle cycles that most likely do some
hidden internal operations too and they are also not included.)

[C3 195]  [C4 196]  [C5 197]  [C6 198]  [C7 199]  [C8 200]  [C9 201]  [CA 202]
 BPL1 110    CPU-RW  BPL2 112  BLT-D 00  BPL1 110  BLT-D 00  BPL2 112    CPU-RW
     0000  B   00DF  b   0000      0000      0000  D   0000      0000      F002
 0001A378  0002642C  0001F37A  00014FD0  0001A37A  00014FD2  0001F37C  0002642E
 BB7C0400  BB7C0600  BB7C0800  BB7C0A00  BB7C0C00  BB7C0E00  BB7C1000  BB7C1200

All blitter cycles needs free cycle (even idle cycles which are also available for
the CPU). Blitter is stopped when any higher priority channel needs the bus.

b = blitter wanted this cycle but higher priority channel took it.
D = blitter's final D write. (marked because it is special cycle, blitter finished 
    bit was set 2 cycles ago)

;-----------------------------------------------------------------------------
; from EAB:

Note that currently mode can't be changed after it has been enabled.
After it has been enabled (visual or not),
v <vpos> <hpos> shows detailed scanline DMA/CPU usage.

Don't change mode after it has been started once. 
It will crash, it is a "feature"..

