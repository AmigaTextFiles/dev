*	$VER: SimpleLED_2_Source 1.0 (21-Oct-93)

*	*****************************************
*	* SimpleLED_2.s v1.0			*
*	* Copyright © 1993, Richard Karlsson	*
*	*					*
*	* Klövergränd 4				*
*	* SF-22100 Mariehamn			*
*	* Finland				*
*	*					*
*	* Ph. +358-28-22441			*
*	*****************************************

* This program will make a nice moving pattern of two lit LEDs
* traveling the oposite directions on PORTB. See theSimpleLED_1.s
* source for more info on how to set up the LEDs.

* Read the comments for SimpleLED_1.s before trying this example.

RAM		=	0
EEPROM		=	$b600
RegBase		=	$1000

	Include	"HcInclude:A8Regs.i"

	org	RAM

Left		rmb	1	; Leave one byte room for "Left" and
Right		rmb	1	; "Right". Here the two LEDs positions
				; are stored.

	org	EEPROM

	ldaa	#1		; Set start position for the LED
	staa	Left		; travelling left.
	ldaa	#1<<7		; And the start position for the other
	staa	Right		; one.
Main
	ldaa	Left		; Logic OR the Left and Right LEDs
	oraa	Right		; together to make a single pattern
	staa	PORTB		; at PORTB

	ldaa	Left		; Move the LED travelling left one
	rola			; position to the left. If it comes
	ldaa	Left		; to the end of the port it will start
	rola			; over from the beginning.
	staa	Left

	ldaa	Right		; And move the other LED.
	rora
	ldaa	Right
	rora
	staa	Right

	bsr	HumaneDelay	; Wait a while so that you can see the
				; pattern.
	bra	Main		; And start over.

HumaneDelay
* Wait while the processor is couting to 300000.

* Trashes Index register X and Y.

	ldx	#5
HD_Outer
	ldy	#60000
HD_Inner
	dey
	bne	HD_Inner
	dex
	bne	HD_Outer
	rts
