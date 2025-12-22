	IFND INPUT_KEYBOARD_I
INPUT_KEYBOARD_I  SET  1

**
**  $VER: keyboard.i V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* Keyboard object.

VER_KEYBOARD  = 1
TAGS_KEYBOARD = ((ID_SPCTAGS<<16)|ID_KEYBOARD)

    STRUCTURE	KEY,HEAD_SIZEOF
	LONG	KEY_Size
	APTR	KEY_Buffer
	WORD	KEY_AmtRead
	WORD	KEY_Flags

KEYA_Size  =	(TLONG|KEY_Size)
KEYA_Flags =	(TWORD|KEY_Flags)

******************************************************************************
* Key Flags

KF_AUTOSHIFT = $0001  ;Auto-Shift handling.
KF_GLOBAL    = $0002  ;Receive all keyboard input.

******************************************************************************
* KeyEntry structure.

    STRUCTURE	KE,0
	WORD	KE_Qualifier
	BYTE	KE_Value
	BYTE	KE_Reserved
	LABEL	KE_SIZEOF

******************************************************************************
* KeyEntry Qualifiers.

KQ_LSHIFT   = $0001      ;Left Shift.
KQ_RSHIFT   = $0002      ;Right Shift.
KQ_CAPSLOCK = $0004      ;Caps-Lock.
KQ_CONTROL  = $0008      ;Control Key.
KQ_LALT     = $0010      ;Left Alt.
KQ_RALT     = $0020      ;Right Alt.
KQ_LCOMMAND = $0040      ;Left Amiga  [Command]
KQ_RCOMMAND = $0080      ;Right Amiga [Command]
KQ_KEYPAD   = $0100      ;This is a keypad key.
KQ_REPEAT   = $0200      ;This is a repeated key.
KQ_RELEASED = $0400      ;Key is now being released.
KQ_HELD     = $0800      ;Key is being held/pressed.
KQ_SHIFT    = (KQ_LSHIFT|KQ_RSHIFT)

******************************************************************************
* Special Keypresses.  All other keys can be considered to be in ASCII format. 

K_SCS   =	$80            ;ScreenSwitch (LEFTAMIGA + M)
K_SLEFT =	$81
K_HELP  =	$82

K_LSHIFT =	$83
K_RSHIFT =	$84
K_CAPS   =	$85
K_CTRL   =	$86
K_LALT   =	$87
K_RALT   =	$88
K_LAMIGA =	$89
K_RAMIGA =	$8a

K_F1	=	$8b
K_F2	=	$8c
K_F3	=	$8d
K_F4	=	$8e
K_F5	=	$8f
K_F6	=	$90
K_F7	=	$91
K_F8	=	$92
K_F9	=	$93
K_F10	=	$94
K_F11	=	$95
K_F12	=	$96
K_F13	=	$97
K_F14	=	$98
K_F15	=	$99
K_F16	=	$9a
K_F17	=	$9b
K_F18	=	$9c
K_F19	=	$9d
K_F20	=	$9e

C_UP	=	$9f
C_DOWN	=	$a0
C_RIGHT	=	$a1
C_LEFT	=	$a2

K_SRIGHT =	$a3            ;Special key on right.

******************************************************************************
* Special keys that are recognised under ASCII (here for convenience).

K_BAKSPC =	08
K_TAB    =	09
K_ENTER  =	10
K_RETURN =	10
K_ESC    =	$1b
K_DEL    =	$7f

	ENDC	;INPUT_KEYBOARD_I
