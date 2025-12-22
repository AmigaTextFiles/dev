
; Listing19f1.s
; as a good example you can load Listing7f.s
; it shows the 8 sprites and his prioritys

 M<a/b/s> <val>        Enable or disable audio channels, bitplanes or sprites.
	
	Sprite-Mask
Ms 00	0000	- all disabled
Ms 01	0001	- Sprite 0			enabled
Ms 02	0010	- Sprite 1			enabled
Ms 03	0011	- Sprite 0+1					; attached sprite combination
Ms 04	0100	- Sprite 2
Ms 05	0101	- Sprite 0+2
Ms 06	0110	- Sprite 1+2
Ms 07	0111	- Sprite 0+1+2		enabled
Ms 08	1000	- Sprite 3			enabled	
Ms 09   1001	- Sprite 0+3		enabled
Ms 0A   1010	- Sprite 1+3
Ms 0B   1011	- Sprite 0+1+3
Ms 0C	1100	- Sprite 2+3					; attached sprite combination
Ms 0D	1101	- Sprite 0+2+3
Ms 0E	1110	- Sprite 1+2+3
Ms 0F   1111	- Sprite 0+1+2+3	enabled
;---
...
Ms 30	0011	- Sprite 4+5					; attached sprite combination
Ms C0	0011	- Sprite 6+7					; attached sprite combination
...
Ms FF			- Sprite 0+1+2+...+7 all enabled		

(same procedure for audio Ma and bitplane Mb ...)

;------------------------------------------------------------------------------
																				; Shift+F12	open the Debugger


>Ms 0																			; all sprites disabled (switch off)
Sprite mask: 00																	; Ms0 (without spaces is also possible)	
>x

>Ms 01																			; only sprite 0 is visible
Sprite mask: 01
>x

>Ms 02																			; only sprite 1 is visible
Sprite mask: 02
>x

>Ms 03																			; only sprite 0 and sprite 1 are visible
Sprite mask: 03
>x

>Ms 04																			; only sprite 2 is visible
Sprite mask: 04
>x

>Ms 05																			; only sprite 0 and sprite 2 are visible
Sprite mask: 05
>x

>Ms 06																			; only sprite 1 and sprite 2 are visible
Sprite mask: 06
>x

>Ms 7																			; sprite 0, sprite 1 and  sprite 2 are visible
Sprite mask: 07
>x

>Ms 8																			; only sprite 3 is visible
Sprite mask: 08
>x

>Ms 9																			; only sprite 0 and sprite 3 are visible
Sprite mask: 09
>x

>Ms A																			; only sprite 1 and sprite 3 are visible
Sprite mask: 0A
>x

>Ms B																			; sprite 0, sprite 1 and sprite 3 are visible
Sprite mask: 0B
>x

>Ms C																			; only sprite 2 and sprite 3 are visible
Sprite mask: 0C
>x

>Ms D																			; sprite 0, sprite 2 and sprite 3 are visible
Sprite mask: 0D
>x

>Ms E																			; sprite 1, sprite 2 and sprite 3 are visible
Sprite mask: 0E
>x

>Ms F																			; sprite 1, sprite 2, sprite 3 and sprite 4 are visible
Sprite mask: 0F 
>x

>Ms 10																			; only sprite 4 is visible
Sprite mask: 10
>

Numbers:
are usually hexadecimal by default (a few exceptions default to decimal)
prepend a number with $ or 0x force hexadecimal
prepend a number with ! to force decimal
prepend a number with % to force binary

>Ms 11
>Ms $11 or 0x11
Sprite mask: 11
>

>Ms 12																			; only sprite 1 and sprite 4 are visible
>Ms !18
Sprite mask: 12
>

>Ms 13																			; sprite 0, sprite 1 and sprite 4 are visible
>Ms %10011 
Sprite mask: 13
>

....

>MsFF																			; all sprites enabled
Sprite mask: FF
>


