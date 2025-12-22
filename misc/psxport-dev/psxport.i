		IFND	PSXPORT_I
PSXPORT_I	SET	1

;	$VER: psxport.i 2.1 (05.05.2000)
;
;	pxsport.device definitions
;
;	(C) Copyright 1999-2000 Joseph Fenton. All rights reserved.

	IFND	 DEVICES_INPUTEVENT_I
	INCLUDE  "devices/inputevent.i"
	ENDC

; extension command for psxport.device

GPD_COMMUNICATE	equ	14
GPD_SETPORTRATE	equ	15

PXUB_BUSYWAIT	equ	0
PXUB_ALWAYSOPEN	equ	1

PXUF_BUSYWAIT	equ	1
PXUF_ALWAYSOPEN	equ	2

; all controllers

PSX_CLASS	equ	ie_Class
PSX_SUBCLASS	equ	ie_SubClass
PSX_BUTTONS	equ	ie_Code

; class/subclass

PSX_CLASS_MOUSE		equ	$12
PSX_CLASS_WHEEL		equ	$23
PSX_CLASS_JOYPAD	equ	$41
PSX_CLASS_ANALOG_MODE2	equ	$53
PSX_CLASS_LIGHTGUN	equ	$63
PSX_CLASS_ANALOG	equ	$73
PSX_CLASS_MULTITAP	equ	$80	; will never receive
PSX_CLASS_ANALOG2	equ	$F3	; only Mad Catz Dual Shock returns this

PSX_SUBCLASS_PSX	equ	$5A	; all PSX controllers and cards return this

; note: all buttons are active low

; joypad

PSX_LEFT	equ	15
PSX_DOWN	equ	14
PSX_RIGHT	equ	13
PSX_UP		equ	12
PSX_START	equ	11
PSX_R3		equ	10		; R3 and L3 only if PSX_CLASS_ANALOG
PSX_L3		equ	9		; or PSX_CLASS_ANALOG2
PSX_SELECT	equ	8
PSX_SQUARE	equ	7
PSX_CROSS	equ	6
PSX_CIRCLE	equ	5
PSX_TRIANGLE	equ	4
PSX_R1		equ	3
PSX_L1		equ	2
PSX_R2		equ	1
PSX_L2		equ	0

PSX_RIGHTX	equ	ie_X
PSX_RIGHTY	equ	ie_X+1

PSX_LEFTX	equ	ie_Y
PSX_LEFTY	equ	ie_Y+1

; mouse

PSX_LMB		equ	PSX_R1
PSX_RMB		equ	PSX_L1

PSX_MOUSEDX	equ	ie_X
PSX_MOUSEDY	equ	ie_Y

; wheel

PSX_A		equ	PSX_CIRCLE
PSX_B		equ	PSX_TRIANGLE
PSX_R		equ	PSX_R1

PSX_WHEEL	equ	ie_X
PSX_I		equ	ie_X+1
PSX_II		equ	ie_Y
PSX_L		equ	ie_Y+1

; light gun

PSX_GUN_A	equ	PSX_START
PSX_GUN_B	equ	PSX_CROSS
PSX_GUN_TRIGGER	equ	PSX_CIRCLE

PSX_GUN_X	equ	ie_X
PSX_GUN_Y	equ	ie_Y

; SetPortRate data

psx_SelDelay	equ	0
psx_CmdDelay	equ	2
psx_ClkDelay	equ	4
psx_DatDelay	equ	6

		ENDC
