
; Listing19h1.s
; Load a demo of your choice

; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

; vh [<ratio> <lines>]  "Heat map"

1a.	vh				= enable
1b.	vh -1			= enable visual mode
2.  vhd				= Heatmap disabled

3.	vh ?			= lists all possible channel modes
4.	vhc				= heatmap data cleared
5.	vh <name of channel> [number of lines]

; vh [<ratio> <lines>]  "Heat map"
6a.	vh 5			; ?
6b.	vh -1 20		; ?

																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
																				; 1a.
																				; without visual mode
																				; Initial enable command "vh"	 (enable) or 
																				;						 "vh -1" (enable visual mode)

>vh																				; no visiual mode is activ 
Memwatch breakpoints enabled
 0: 00DFF000 - 00DFF1FF (512) RWI NONE
 1: 00000000 - 0007FFFF (524288) RWI NONE
 2: 00C00000 - 00C7FFFF (524288) RWI NONE
Heatmap enabled
>x																				
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger
>vhd																			; Heatmap disabled
Heatmap disabled
>x
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger
>vh-1																			; 1b.
 0: 00DFF000 - 00DFF1FF (512) RWI NONE											; visual mode is active
 1: 00000000 - 0007FFFF (524288) RWI NONE
 2: 00C00000 - 00C7FFFF (524288) RWI NONE
Heatmap enabled
>x
;------------------------------------------------------------------------------

>vhd																			; Heatmap disabled
Heatmap disabled
>x
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger

>vh-1																			; 1b.
 0: 00DFF000 - 00DFF1FF (512) RWI NONE											; visual mode is active
 1: 00000000 - 0007FFFF (524288) RWI NONE
 2: 00C00000 - 00C7FFFF (524288) RWI NONE
Heatmap enabled
;------------------------------------------------------------------------------
																				; 3. 
>vh ?																			; vh ? lists all possible channel modes. Same channel mode strings are also
ALL NONE DMA BLT BLTD AUD BPL SPR CPU CPUD CPUI CPUDR CPUDW						; supported by memory watch break points.
COP BLTA BLTB BLTC BLTDN BLTDL BLTDF DSK AUD0 AUD1 AUD2 AUD3					; (Memwatch already supported most of them but some are new)
BPL0 BPL1 BPL2 BPL3 BPL4 BPL5 BPL6 BPL7 SPR0 SPR1 SPR2 SPR3
SPR4 SPR5 SPR6 SPR7 
;------------------------------------------------------------------------------
>vhc																			; 4. heatmap data cleared
heatmap data cleared
>x
;------------------------------------------------------------------------------
																				; Shift+F12 open the Debugger
																				; 4.
vh <name of channel> [number of lines]
			= to list all addresses that channel has accessed

																				; vh cop = list all copper accesses
																				; (includes also copper writes to custom registers)
																				; number of lines = 0: list everything.
>vh bpl0 6
Mask 00008000 Name BPL0
000: 00014d50 - 00014d57 00000007 (7) BPL0
001: 00014d98 - 00014da7 0000000f (15) BPL0
002: 00014de8 - 00014df7 0000000f (15) BPL0
003: 00014e38 - 00014e47 0000000f (15) BPL0
004: 00014e88 - 00014e97 0000000f (15) BPL0
005: 00014ed8 - 00014ee7 0000000f (15) BPL0
;------------------------------------------------------------------------------
>vh spr0 10
Mask 00800000 Name SPR0
000: 00000c80 - 00000cc7 00000047 (71) SPR0
;------------------------------------------------------------------------------
																				; vh cop = list all copper accesses
																				; (includes also copper writes to custom registers)
																				; number of lines = 0: list everything.
>vh cop 20
Mask 00000200 Name COP
000: 00000420 - 00000477 00000057 (87) COP
001: 0001ed50 - 0001edef 0000009f (159) COP
002: 00dff088 - 00dff097 0000000f (15) COP
003: 00dff0e0 - 00dff0e7 00000007 (7) COP
004: 00dff100 - 00dff10f 0000000f (15) COP
005: 00dff120 - 00dff13f 0000001f (31) COP
006: 00dff180 - 00dff187 00000007 (7) COP
007: 00dff1a0 - 00dff1bf 0000001f (31) COP
;------------------------------------------------------------------------------
>vh
001: 00c001e8 - 00c001ff 00000017 (23) 12.28331%
002: 00c00240 - 00c00257 00000017 (23) 9.80684%
003: 00c023a8 - 00c023bf 00000017 (23) 8.76672%
004: 00c000f0 - 00c00107 00000017 (23) 7.92472%
005: 00c001f0 - 00c00207 00000017 (23) 6.14165%
006: 00c001d8 - 00c001ef 00000017 (23) 5.64636%
013: 00c00120 - 00c0013f 0000001f (31) 5.57207%
007: 00c00030 - 00c00047 00000017 (23) 5.05201%
008: 00c00248 - 00c0025f 00000017 (23) 4.86627%
009: 00c02db8 - 00c02dcf 00000017 (23) 4.12333%
010: 00c00230 - 00c00247 00000017 (23) 3.60327%
011: 00c001e0 - 00c001f7 00000017 (23) 3.08321%
012: 00c00238 - 00c0024f 00000017 (23) 3.04606%
014: 00c00028 - 00c0003f 00000017 (23) 2.52600%
015: 00c000e8 - 00c000ff 00000017 (23) 1.56018%
018: 00c066e0 - 00c066ff 0000001f (31) 1.48588%
016: 00c00088 - 00c0009f 00000017 (23) 1.21347%
017: 00c066f0 - 00c06707 00000017 (23) 0.92868%
019: 00c00090 - 00c000a7 00000017 (23) 0.60674%
020: 00c00140 - 00c00157 00000017 (23) 0.59435%
021: 00c000f8 - 00c0010f 00000017 (23) 0.55721%
022: 00c00178 - 00c0018f 00000017 (23) 0.39624%
023: 00c00098 - 00c000af 00000017 (23) 0.38385%
028: 00c02dc8 - 00c02de7 0000001f (31) 0.37147%
024: 00c066a8 - 00c066bf 00000017 (23) 0.30956%
025: 00c000a0 - 00c000b7 00000017 (23) 0.29718%
026: 00c000a8 - 00c000bf 00000017 (23) 0.24765%
027: 00c00180 - 00c00197 00000017 (23) 0.19812%
029: 00c00130 - 00c00147 00000017 (23) 0.14859%
030: 00c00040 - 00c00057 00000017 (23) 0.12382%
;------------------------------------------------------------------------------
>vh cpu 10
Mask 00000007 Name CPU
000: 00000000 - 00000007 00000007 (7) CPU
001: 00000020 - 00000027 00000007 (7) CPU
002: 00000060 - 0000006f 0000000f (15) CPU
003: 00000400 - 0000040f 0000000f (15) CPU
004: 00000418 - 0000041f 00000007 (7) CPU
005: 00011f10 - 00011f17 00000007 (7) CPU
006: 00011f30 - 00011f37 00000007 (7) CPU
007: 00012150 - 0001219f 0000004f (79) CPU
008: 000121a8 - 000121bf 00000017 (23) CPU
009: 000121e0 - 000121e7 00000007 (7) CPU
>																				; vh bltd = blitter D channel accesses only 
																				; (bltdn = normal D channel mode only, bltdf = fill, bltdl = line)

																				; CPU accesses: cpu = all, cpui = opcode fetch, cpud = data access,
																				;			    cpudr = data reads only, cpudw = data writes only.				
;------------------------------------------------------------------------------
>vhc																			; vhc = clear collected data.
heatmap data cleared
>vh cop 20
Mask 00000200 Name COP
>vh spr0 10
Mask 00800000 Name SPR0
>vh bpl0 6
Mask 00008000 Name BPL0
>

;------------------------------------------------------------------------------
vh [ratio] [number of lines]													; what means ratio?
			 = list CPU instruction access info
			(like previously, but does not clear collected data anymore)
>vh 5																			; shows always the complet list (30)
>vh -1 10																		; ratio is only -1

;------------------------------------------------------------------------------
Note: from EAB
- Colors are same as in DMA debugger except CPU color was changed to brown from dark grey.
- Separate color for CPU instruction (pink) and data accesses (brown).

- Enable: "vh" in debugger. (cycle-exact mode must be enabled)

- Automatically adds "null" memwatch break point from 0 to 512k,
  used to capture all memory accesses.
- First 512k of chip ram only.
- all chip ram and slow ram is now supported.

- visual part is now optional

- 256x256 pixel matrix, 1 pixel = 8 bytes. (top/left = addresses 0 - 7,
  top/right = addresses 255*8 - 255*8+7 and so on..)
- Each pixel has 32 shades, pixel gets darker each frame if it has not been "accessed".
- Colors are same as in DMA debugger except CPU color was changed to brown from dark grey.
- Separate color for CPU instruction (pink) and data accesses (brown).

- CPU = all CPU accesses, no separation between opcode and data accesses.
- Any DMA channel (and more) accesses can be listed.

- "Heatmap" shows audio sample playing nicely (red lines).
- Also game/demo double/triple buffer usage is easy to see (flashing blue = bitplane DMA regions)
  Not much CPU code activity, I guess most common routines are short loops
  except if program has or generates big unrolled loops.

- Statistics update: "vh" command after enabling it now lists 40 first addresses
  with most CPU instruction word fetch activity. (Data is cleared after command)
  It first finds highest CPU usage in stat data. Then finds all other nearby addresses
  with same or slightly less (5% less) CPU usage and outputs single line to console
  with start, end and percentage of total used. Then repeat same 40 lines.

EDIT: Note that list is not fully sorted, the longer the detected address space the worse the list is..
EDIT2: now also accepts two parameters, first parameter: percentage value of how big range is
accepted (default 95 = 95% of highest accepted, set to zero to list all address),
second parameter is number of lines to output.

I quickly checked some simple intros and demos and most CPU time was nearly always
used "loop: btst #6,$bfe001; bne.s loop" main loop, everything else was done in interrupts.
How boring.
