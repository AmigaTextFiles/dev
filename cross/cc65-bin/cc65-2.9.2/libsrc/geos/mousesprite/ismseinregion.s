
;
; Maciej 'YTM/Elysium' Witkowiak
;
; 21.12.99

; char IsMseInRegion (struct window *mywindow);

	    .import _InitDrawWindow

	    .export _IsMseInRegion
	    
	    .include "../inc/jumptab.inc"

_IsMseInRegion:
	    jsr _InitDrawWindow
	    jmp IsMseInRegion
