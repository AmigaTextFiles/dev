*	$VER: SimpleLED_1_Source 1.0 (21-Oct-93)

*	*****************************************
*	* SimpleLED_1.s v1.0			*
*	* Copyright © 1993, Richard Karlsson	*
*	*					*
*	* Klövergränd 4				*
*	* SF-22100 Mariehamn			*
*	* Finland				*
*	*					*
*	* Ph. +358-28-22441			*
*	*****************************************

* This little program will do a binary count from 0 to 255 on PORTB.
* You should set up LEDs on this port to see the result. To do this
* you can either use a transistor to drive the LEDs. Base of transistor
* to the port pin. You will need one transistor for each PORTB pin. OR
* you can set up the LEDs straight from the PORTB pins to VSS, through a
* resistor. This method is probably a strain on the MCU and probably
* not within the guaranteed ratings of the MCU. But I've used this
* method many times, and still haven't destroyed any Hc11s that way.

* PORTB Pin0----LED---Resistor---VSS

* The resistor should be about 300 ohms, and the LED should be turned
* the right way. If you don't know which way is the right way then
* try one way and if that doesn't work then turn it the other way.

* You will need to make one of theese for every PORTB pin.

* PORTB is to my knowledge an outport on all HC11 models. If it's not
* on the model you are using then you try using another port. Just
* change the PORTBs in this source to what ever port you are using.
* If the port you are using is a bi-directional port then you will
* have to set it to output mode.

EEPROM		=	$b600	; Change this to where you have space
				; to put the program. NOT in the MCUs
				; internal RAM. The talker file is
				; resident there.
				; If you have the program in EEPROM
				; as you probably will, then remember
				; to set the EEPROM range in HitMon11
				; when transferring this program
				; to the Hc11 MCU. Else programming
				; will fail. The EEPROM range is set
				; with the "EEPROM" command.

RegBase		=	$1000	; This is where the register base is
				; in the MCU you are using. It should
				; be HEX 1000 at all Hc11s. If you
				; havent changed it manually that is.
				; To change the register base is only
				; possable on some MCUs.

	Include	"HcInclude:A8Regs.i"	; Sets all the register to the
					; right addresses. If you are
					; not using the Hc11A0, A1 or A8
					; then you will have to change
					; this.

	org	EEPROM		; Set PC to beginning of EEPROM.

	clra			; Clear Accumulator A (AccA)
Main
	staa	PORTB		; Store AccA at PORTB. If you have LEDs
				; set up at PORTB they should light up
				; according to the bits set in AccA.
	inca			; Binary add 1 to AccA
	bsr	HumaneDelay	; Wait a while so that you can see how
				; the LEDs look.
	bra	Main		; Go back to Main, and start all over
				; again.

HumaneDelay
* This routine counts to 5 times 60000 (=300000) that should be long
* enough for you to see the LEDs pattern.

* It trashes index registers X and Y.

	ldx	#5
HD_Outer
	ldy	#60000
HD_Inner
	dey
	bne	HD_Inner
	dex
	bne	HD_Outer
	rts
