
; Listing19j2.s
; Deep-Trainer
;
; D[idxzs <[max diff]>] Deep trainer. i=new value must be larger, d=smaller,
;                       x = must be same, z = must be different, s = restart.

;---------------------------------------------------------------
- debugger deep trainer improved.
 "D[<s><dix> <[max diff]>]" 
	Di = value must increase, 
	Dd = decrease, abs(new value minus old value) must be smaller than "max diff".
		 s = 1 = byte, 2 = word. long words not supported. (defaults to byte)
	
Signed integers used in comparison. 
NOTE: not really tested, I was not interested 

D is used when you don't know the value. A health bar might not be an obvious
value so you could use D to find it. It works by eliminating addresses that
have or haven't changed. The commands are
Ds (start/reset deep trainer),
D  (find any addresses that have changed since last D command),
Dx (find any addresses that haven't changed since last D command).

D		; Deep trainer
Di		; i=new value must be larger	(value must increase)
Dd		; d=new value must be smaller
Dx		; x=must be same
Dz		; z=must be different
Ds		; s=restart

D  <[max diff]>
Di <[max diff]>	; must be smaller than "max diff"
Dd <[max diff]>
Dx <[max diff]>
Dz <[max diff]>
Ds <[max diff]>


Yo! Joe!

; The game is running (first level - health is lost by contacting with the enemies)
;------------------------------------------------------------------------------
>Ds
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
Deep trainer first pass complete.
;------------------------------------------------------------------------------
>g																				; play a little bit and lost		
	D0 00000000   D1 00000600   D2 00000080   D3 00001100						; some health
	D4 0002DF86   D5 00016E0C   D6 00000003   D7 00010007
	A0 00C0D850   A1 0000F02C   A2 0002CE86   A3 00C49768
	A4 00C4E268   A5 00DFF000   A6 00C030FE   A7 00C7FF64
USP  00C7FBFC ISP  00C7FF64
T=00 S=1 M=0 X=0 N=1 Z=0 V=0 C=0 IMASK=2 STP=0
Prefetch d8bc (ADD) 0000 (OR) Chip latch 00000FF9
00c12952 d8bc 0000 8000           add.l #$00008000,d4
Next PC: 00c12958																; Shift+F12
;------------------------------------------------------------------------------
>Dd																				; any smaller vlaue found?
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
12221 addresses found
;------------------------------------------------------------------------------
Now continue with 'g' and use 'D' again after you have lost another life
>g																				; play a little bit and lost
	D0 00000000   D1 00000080   D2 00000000   D3 00000000						; some health
	D4 0002CE86   D5 00016E0A   D6 00000002   D7 00010007
	A0 00C0D850   A1 0000FA8E   A2 0002CE86   A3 00C497D9
	A4 00C4E2D9   A5 00DFF000   A6 00C030FE   A7 00C7FF58
USP  00C7FBFC ISP  00C7FF58
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=2 STP=0
Prefetch 082d (BTST) 000e (ILLEGAL) Chip latch 0000DB6D
00c1299a 082d 000e 0002           btst.b #$000e,(a5,$0002) == $00dff002
Next PC: 00c129a0																; Shift+F12
;------------------------------------------------------------------------------
>Dd																				; any smaller vlaue found?
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
381 addresses found
Now continue with 'g' and use 'D' again after you have lost another life		
;------------------------------------------------------------------------------
>g																				; play a little bit and lost
	D0 18000000   D1 00000080   D2 00000000   D3 00000000						; some health
	D4 0002CE86   D5 00016E0A   D6 00000002   D7 00010007
	A0 00C0D850   A1 0000FA90   A2 0002CE86   A3 00C497D9
	A4 00C4E2D9   A5 00DFF000   A6 00C030FE   A7 00C7FF60
USP  00C7FBFC ISP  00C7FF60
T=00 S=1 M=0 X=0 N=0 Z=1 V=0 C=0 IMASK=2 STP=0
Prefetch 51ce (DBcc) ff8e (ILLEGAL) Chip latch 0000BAAE
00c129a4 51ce ff8e                dbf .w d6,#$ff8e == $00c12934 (F)
Next PC: 00c129a8																; Shift+F12
;------------------------------------------------------------------------------
>Dd
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
83 addresses found
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)

0000616F=0092 00006195=0092 000061BB=0092 000061E1=0000 00006207=0092, adresses...

	D0 00000080   D1 00001800   D2 00000000   D3 00007300
	D4 00034186   D5 0001FAAC   D6 00000001   D7 00010008
	A0 00C0D8C0   A1 00017CC6   A2 0002CE86   A3 00C49765
	A4 00C4E265   A5 00DFF000   A6 00C030FE   A7 00C7FF64
USP  00C7FBFC ISP  00C7FF64
T=00 S=1 M=0 X=0 N=0 Z=0 V=0 C=0 IMASK=2 STP=0
Prefetch 3b7c (MOVE) 1001 (MOVE) Chip latch 0000FFFE
00c12994 3b7c 1001 0058           move.w #$1001,(a5,$0058) == $00dff058
Next PC: 00c1299a																; Shift+F12
;------------------------------------------------------------------------------
>Dd
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)
3 addresses found
Scanning.. 00000000 - 00200000 (Chip memory)
Scanning.. 00c00000 - 00c80000 (Slow memory)

00C0316B=0005 00C0316C=0005 00C0BCD7=0086 >W C0316B 9							; first adress looks interesting 
Wrote 9 (9) at 00C0316B.B														; because health bar has only 5 segments now
>
;------------------------------------------------------------------------------
>W C0316B F
Wrote F (15) at 00C0316B.B
>g																				; full health bar

;------------------------------------------------------------------------------
																				; when you've found values you can freeze them with the watchpoint command:
																				; w <watchpoint number> <memory start address> <length in bytes> <flags>
																				; To freeze your 1E7E6 address in Crazy Cars 3 you would do:
																				; >w 0 1E7E6 2 frw
																				; This sets freeze watchpoint 0 on the contents of that address and the following one.

																				; or in Yo! Joe!
;------------------------------------------------------------------------------
>w 0 C0316B 1 frw																; yeah! endless energy!