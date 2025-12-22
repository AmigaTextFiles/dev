
; Listing19c1.s
; debugging an assembler program with a programm breakpoint
; start and run from asmone	
; (WinUAE 4.9.0 A500 configuration)
; GUI-Debugger

;  f <address>           Add/remove breakpoint.
;  fl                    List breakpoints.
;  fd                    Remove all breakpoints.
;  d <address> [<lines>] Disassembly starting at <address>.
;  t [instructions]      Step one or more instructions.
;  fi                    Step forward until PC points to RTS, RTD or RTE.
;------------------------------------------------------------------------------

start:

waitmouse:  
	btst	#6,$bfe001	; left mousebutton?
	bne.s	waitmouse	

	lea	dog,a0
	move.L	#dog,a1
	move.L	dog,a2
	move.l	#$AA,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	move.l	#$BB,cat1
	move.l	a1,cat2
	move.l	a2,cat3
	rts

dog:
	dc.l	$12345678
cat1:
	dc.l	0
cat2:
	dc.l	0
cat3:
	dc.l	0

	end

;------------------------------------------------------------------------------
>r
Filename:Listing19c1.s
>a
Pass1
Pass2
No Errors
>j
																				; start the programm
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
																				; the disassembled programlines are visible in the middle
																				; but it is not possible to copy a textsegment, therefore

>d PC																			; for copy and paste the adress
																				; the same is now standing in the bottom field
																				; 1. First we make a program breakpoint in this line 
																				
...
00C15682 41f9 00c1 56c2           LEA.L $00c156c2,A0							; lea	dog,a0

>f C15682																		; step 2 - set breakpoint
Breakpoint added.
																				; now there is a blue point on this line !

>x																				; step 2 - leave the debugger
;------------------------------------------------------------------------------
																				; the program is waiting for the left mouse button
																				; now click left mousebutton and the debugger reopens
																				; and wait on this line
>t																				; step 3 - trace (one step) 
00C15688 227c 00c1 56c2           MOVEA.L #$00c156c2,A1

>t 3																			; step 4 - trace (3 steps)
00C1569E 23c9 00c1 56ca           MOVE.L A1,$00c156ca [00000000]
;------------------------------------------------------------------------------
>fi																				; step 5 - Step forward until PC points to RTS, RTD or RTE.
Cycles: 84 Chip, 168 CPU. (V=210 H=34 -> V=210 H=118)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000 
  D4 00000000   D5 00000000   D6 00000000   D7 00000000 
  A0 00025876   A1 00025876   A2 12345678   A3 00000000 
  A4 00000000   A5 00000000   A6 00000000   A7 00C60D80 
USP  00C60D80 ISP  00C61D80 
T=00 S=0 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=0 STP=0
Prefetch 1234 (MOVE) 4e75 (RTS) Chip latch 00000000
00025874 4e75                     RTS											; programs run to the next rts
Next PC: 00025876
;------------------------------------------------------------------------------
>fl																				; List all breakpoints
0: PC == 00c15682 [00000000 00000000]											; ok
>fd																				; step 6 - remove all breakpoints												
All breakpoints removed.

>x																				; step 7 - leave the debugger
	
		end																		; finish

;------------------------------------------------------------------------------
; from EAB
Have been working with the UAE debugger and I'm getting used to it. Here are my
steps trying to solve serious problems (code which took over the system)

1. put a loop waiting for the left mousebutton right after the start of the code
2. put a string (dc.b. "[whatever]") near the location where I presume the faulty code
3. start the program, program stays in wait-loop
4. enter Shift-F12 starting the uae debugger
5. search for the string > s "[whatever] < in memory, at least one address should be found
6. disassembling the memory at given address, > d $xxxxxx <
7. searching for the spot where I want to have the breakpoint, setting the bp with > f $xxxxxx <
8. quit the uae debugger and continuing the emulation
9. hit the left mousebutton
10. when the program stops at the breakpoint I follow the program with > t < or > z < 
   (tip, within a dbxx loop >z< completely handles the loop)
11. anything after this is more or less related to the error, usually I seach for
    wrong pointers or condition codes (a wrong test or branch maybe?)
;------------------------------------------------------------------------------
; also from EAB
Crash:
Often it works, but very often WinUAE crashes immediately after entering g.

 g [<address>]         Start execution at the current address or <address>.

 This is not correct. It is possible to stay in the debugger. 
 With >g  you need not to make a >x.
 But bring the program in focus and make the mouseclick.
 Then Shift+F12 to open the debugger again and >x for close the debugger.

;------------------------------------------------------------------------------
 >fl																			; "unlimited" breakpoints...
0: PC == 00000100 [00000000 00000000]
1: PC == 00000101 [00000000 00000000]
2: PC == 00000200 [00000000 00000000]
3: PC == 00000300 [00000000 00000000]
4: PC == 00000400 [00000000 00000000]
5: PC == 00000500 [00000000 00000000]
6: PC == 00000600 [00000000 00000000]
7: PC == 00000700 [00000000 00000000]
8: PC == 00000800 [00000000 00000000]
9: PC == 00000900 [00000000 00000000]
10: PC == 00001000 [00000000 00000000]

>f 200
Breakpoint removed.																; breakpoint 2 is removed		
>fl
0: PC == 00000100 [00000000 00000000]
1: PC == 00000101 [00000000 00000000]
3: PC == 00000300 [00000000 00000000]
4: PC == 00000400 [00000000 00000000]
5: PC == 00000500 [00000000 00000000]
6: PC == 00000600 [00000000 00000000]
7: PC == 00000700 [00000000 00000000]
8: PC == 00000800 [00000000 00000000]
9: PC == 00000900 [00000000 00000000]
10: PC == 00001000 [00000000 00000000]
>fd
All breakpoints removed.