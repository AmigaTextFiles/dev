
; Listing19j1.s
; Trainer
;
; C <value>             Search for values like energy or lifes in games.
; Cl                    List currently found trainer addresses.

; C is used when you know the value and what it is changing to. 
; For example, C is best for finding lives where it starts at 3 and
; counts down to 0. You always know how many you've got left.
    
																				; Shift+F12	open the Debugger
;-----------------------------------------------------------------------------
; Nicky Boom

>C 5
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
Found 15497 possible addresses with 0x5 (5) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;-----------------------------------------------------------------------------
>g
  D0 FFFFFFFF   D1 00000009   D2 00A2005E   D3 000000A9
  D4 0000002C   D5 006F0040   D6 0000FFFF   D7 00000000
  A0 0000459C   A1 00065D00   A2 0000BA60   A3 0007BB81
  A4 0000604E   A5 00003458   A6 00003488   A7 00080000
USP  00C014B2 ISP  00080000
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0000 (OR) 4a39 (TST) Chip latch 00000000
00000452 4a39 0000 502d           TST.B $0000502d [01]
Next PC: 00000458
;-----------------------------------------------------------------------------
>C 4
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
0000345B 00003473 000034AA 0008345B 00083473 000834AA
0010345B 00103473 001034AA 0018345B 00183473 001834AA
Found 12 possible addresses with 0x4 (4) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;-----------------------------------------------------------------------------
>g
  D0 FFFFFFFF   D1 00000006   D2 00A2005E   D3 000000A6
  D4 0000002C   D5 006F007F   D6 0000FFFF   D7 00000000
  A0 0000459C   A1 00065D00   A2 0000BA60   A3 0007BB7E
  A4 0000604E   A5 00003458   A6 00003488   A7 00080000
USP  00C014B2 ISP  00080000
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0000 (OR) 4a39 (TST) Chip latch 00000000
00000452 4a39 0000 502d           TST.B $0000502d [01]
Next PC: 00000458
;-----------------------------------------------------------------------------
>C 3
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
000034AA 000834AA 001034AA 001834AA Found 4 possible addresses with 0x3 (3) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;-----------------------------------------------------------------------------
>W 34AA 9																		; change to 9 lives

>Cl
000034AA=0009 000834AA=0009 001034AA=0009 001834AA=0009 >

;------------------------------------------------------------------------------
; Giana Sisters

>C 3
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
Found 24688 possible addresses with 0x3 (3) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;------------------------------------------------------------------------------
>g
...
;------------------------------------------------------------------------------
>C 2
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
00008178 00008179 00008198 00088178 00088179 00088198
00108178 00108179 00108198 00188178 00188179 00188198

Found 12 possible addresses with 0x2 (2) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;------------------------------------------------------------------------------
>g
...
;------------------------------------------------------------------------------
>C 1
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
00008178 00008179 00008198 00088178 00088179 00088198
00108178 00108179 00108198 00188178 00188179 00188198
Found 12 possible addresses with 0x1 (1) (1 bytes)

Now continue with 'g' and use 'C' with a different value
;------------------------------------------------------------------------------
>g
...
;------------------------------------------------------------------------------
W 8178 10																		; change to 17 lives

;------------------------------------------------------------------------------
; Flimbos Quest

>C 3
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
Found 46070 possible addresses with 0x3 (3) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;------------------------------------------------------------------------------
>g
  D0 00000003   D1 00000002   D2 0000000F   D3 0000001F
  D4 00006000   D5 0000FFFF   D6 0000FFFF   D7 00000001
  A0 00065040   A1 00000EC1   A2 00066D7C   A3 000009B0
  A4 0000205A   A5 000076D2   A6 00DFF000   A7 0000036E
USP  00C1A7DC ISP  0000036E
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0000 (OR) d1fc (ADDA) Chip latch 00000000
00000FD0 d1fc 0000 08c0           ADDA.L #$000008c0,A0
Next PC: 00000fd6
;------------------------------------------------------------------------------
>C 2
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
00000EC4 0006D645 0006DA91 0006E1A9 0006E85B 0006F1B1 0006F29B
0006F447 0006FB2D 0006FCE5 0006FDC1 000704AD 00070583 00070589
0007081D 00070AB1 00071BDB 000720FD 000729A3 00072B47 00073B9D
00073BA5 00074A4B 00074A59 00076D85 000771D1 000778E9 00077F9B
000788F1 000789DB 00078B87 0007926D 00079425 00079501 00079BED
00079CC3 00079CC9 00079F5D 0007A1F1 0007B31B 0007B835 0007C287
0007D2DD 0007D2EF 0007D2F7 0007E18B 0007E199 00080EC4 000ED645
000EDA91 000EE1A9 000EE85B 000EF1B1 000EF29B 000EF447 000EFB2D
000EFCE5 000EFDC1 000F04AD 000F0583 000F0589 000F081D 000F0AB1
000F1BDB 000F20FD 000F29A3 000F2B47 000F3B9D 000F3BA5 000F4A4B
000F4A59 000F6D85 000F71D1 000F78E9 000F7F9B 000F88F1 000F89DB
000F8B87 000F926D 000F9425 000F9501 000F9BED 000F9CC3 000F9CC9
000F9F5D 000FA1F1 000FB31B 000FB835 000FC287 000FD2DD 000FD2EF
000FD2F7 000FE18B 000FE199 00100EC4 0016D645 0016DA91 0016E1A9
0016E85B 0016F1B1 Found 188 possible addresses with 0x2 (2) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;------------------------------------------------------------------------------
>g
  D0 00000002   D1 00000002   D2 0000000F   D3 0000001F
  D4 00006000   D5 0000FFFF   D6 0000FFFF   D7 00000001
  A0 00065900   A1 00000EC1   A2 00066D56   A3 000009B0
  A4 0000205A   A5 000076D2   A6 00DFF000   A7 0000036E
USP  00C1A7DC ISP  0000036E
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 0050 (OR) 115a (MOVE) Chip latch 00000000
00000FB8 115a 0050                MOVE.B (A2)+ [21],(A0,$0050) == $00065950 [21]
Next PC: 00000fbc
;------------------------------------------------------------------------------
>C 1
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
00000EC4 00080EC4 00100EC4 00180EC4 Found 4 possible addresses with 0x1 (1) (1 bytes)
Now continue with 'g' and use 'C' with a different value
;------------------------------------------------------------------------------
>m 0EC4 4
00000EC4 0100 41F9 0006 43BC 43F8 0EB9 7E05 6100  ..A...C.C...~.a.
00000ED4 00AC 41F9 0006 43CF 43F8 0EBD 7E04 6100  ..A...C.C...~.a.
00000EE4 00AE 41F9 0006 4790 43F8 0EC4 7E01 6100  ..A...G.C...~.a.
00000EF4 008C 41F9 0006 477D 43F8 0EC0 7E01 617C  ..A...G}C...~.a|
;------------------------------------------------------------------------------
>W 0EC4 4																		; change to 4 lives	
Wrote 4 (4) at 00000EC4.B
;------------------------------------------------------------------------------
>m 0EC4 4
00000EC4 0400 41F9 0006 43BC 43F8 0EB9 7E05 6100  ..A...C.C...~.a.
00000ED4 00AC 41F9 0006 43CF 43F8 0EBD 7E04 6100  ..A...C.C...~.a.
00000EE4 00AE 41F9 0006 4790 43F8 0EC4 7E01 6100  ..A...G.C...~.a.
00000EF4 008C 41F9 0006 477D 43F8 0EC0 7E01 617C  ..A...G}C...~.a|

