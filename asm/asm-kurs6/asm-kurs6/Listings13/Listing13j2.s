
; Listing13j2.s	; Wait States	; Optimierungen auf 68020+
; Zeile 1957

start:
	move.w #$4000,$dff09a		; Interrupts disable
waitmouse:  
	btst	#6,$bfe001			; left mousebutton?
	bne.s	Waitmouse	
;-------------------------------;

	move.l	d0,(a0)				; 12 cy
	move.l	d1,(a1)				; 12 cy
	move.l	d2,(a2)				; 12 cy
	sub.l	d2,d0				; 8 cy
	eor.l	d0,d1				; 8 cy
	add.l	d1,d2				; 8 cy

; Es sollte "umformuliert" werden in:

	move.l	d0,(a0)				; 12 cy
	sub.l	d2,d0				; 8 cy
	move.l	d1,(a1)				; 12 cy
	eor.l	d0,d1				; 8 cy
	move.l	d2,(a2)				; 12 cy
	add.l	d1,d2				; 8 cy
	
;-------------------------------;	
	nop							; an dieser Stelle ist die Aufgabe erledigt
	move.w #$C000,$dff09a		; Interrupts enable
	end


Eine andere Sache, die Sie beachten sollten, ist, dass Sie es vermeiden
sollten, wenn es möglich ist nacheinander auf den Speicher zuzugreifen.
Beispielsweise:

	move.l	d0,(a0)
	move.l	d1,(a1)
	move.l	d2,(a2)
	sub.l	d2,d0
	eor.l	d0,d1
	add.l	d1,d2

Es sollte "umformuliert" werden in:

	move.l	d0,(a0)
	sub.l	d2,d0
	move.l	d1,(a1)
	eor.l	d0,d1
	move.l	d2,(a2)
	add.l	d1,d2


;------------------------------------------------------------------------------
r
Filename: Listing13i5.s
>a
Pass1
Pass2
No Errors
>j																				; start the programm																				
																				; the program is waiting for the left mouse button
;------------------------------------------------------------------------------
																				; open the Debugger with Shift+F12
																				; task 1 - set breakpoint
>d pc
00020fb8 66f6                     bne.b #$f6 == $00020fb0 (T)
00020fba 2080                     move.l d0,(a0) [00000000]
00020fbc 2281                     move.l d1,(a1) [00000000]
00020fbe 2482                     move.l d2,(a2) [00000000]
00020fc0 9082                     sub.l d2,d0
00020fc2 b181                     eor.l d0,d1
00020fc4 d481                     add.l d1,d2
00020fc6 2080                     move.l d0,(a0) [00000000]
00020fc8 9082                     sub.l d2,d0
00020fca 2281                     move.l d1,(a1) [00000000]
>f 20fba
Breakpoint added.
>
;------------------------------------------------------------------------------

>g
Breakpoint 0 triggered.
Cycles: 8312991 Chip, 16625982 CPU. (V=105 H=0 -> V=105 H=24)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2080 (MOVE) 2281 (MOVE) Chip latch 00002281
00020fba 2080                     move.l d0,(a0) [00000000]
Next PC: 00020fbc
>t
Cycles: 6 Chip, 12 CPU. (V=105 H=24 -> V=105 H=30)
  D0 00000000   D1 00000000   D2 00000000   D3 00000000
  D4 00000000   D5 00000000   D6 00000000   D7 00000000
  A0 00000000   A1 00000000   A2 00000000   A3 00000000
  A4 00000000   A5 00000000   A6 00000000   A7 00C5FDF8
USP  00C5FDF8 ISP  00C60DF8
T=00 S=0 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=0 STP=0
Prefetch 2281 (MOVE) 2482 (MOVE) Chip latch 00002482
00020fbc 2281                     move.l d1,(a1) [00000000]
Next PC: 00020fbe


;------------------------------------------------------------------------------
from Toni Wilen, EAB:

It won't affect 68000 or 68010. It can affect 68020+ because of caches. It can
increase performance greatly if 68040+ because they have "write buffer" where
writes are stored and write happens in background. If write goes to slower
memory (like chip ram), CPU can execute instructions between memory write
instructions if they are already in cache. If write is immediately followed by
another write, following write stalls the CPU until previous write has completed.