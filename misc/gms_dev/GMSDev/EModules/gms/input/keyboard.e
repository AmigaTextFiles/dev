/*
**  $VER: keyboard.e V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/****************************************************************************
** The Keyboard object.
*/

CONST VER_KEYBOARD  = 1
CONST TAGS_KEYBOARD = $FFFB0000 OR ID_KEYBOARD

OBJECT keyentry
  qualifier :INT
  value     :CHAR
  reserved  :CHAR
ENDOBJECT

OBJECT keyboard
  head[1] :ARRAY OF head   /* Standard header */
  size    :LONG            /* Size of key buffer */
  buffer  :PTR TO keyentry /* Pointer to key buffer */
  amtread :INT             /* Amount of keys read from last query */
  flags   :INT             /* Special flags */
ENDOBJECT

/****************************************************************************
** Key Tags
*/

CONST KEYA_Size  = TLONG OR 12,
      KEYA_Flags = TWORD OR 22

/****************************************************************************
** Key->Flags
*/

CONST KF_AUTOSHIFT = $0001,
      KF_GLOBAL    = $0002

/****************************************************************************
** KeyEntry Qualifiers.
*/

CONST KQ_LSHIFT   = $0001,  /* Left Shift  */
      KQ_RSHIFT   = $0002,  /* Right Shift */
      KQ_CAPSLOCK = $0004,  /* Caps-Lock   */
      KQ_CONTROL  = $0008,  /* Control Key */
      KQ_LALT     = $0010,  /* Left Alt    */
      KQ_RALT     = $0020,  /* Right Alt   */
      KQ_LCOMMAND = $0040,  /* Left Amiga  [Command] */
      KQ_RCOMMAND = $0080,  /* Right Amiga [Command] */
      KQ_KEYPAD   = $0100,  /* This is a keypad key */
      KQ_REPEAT   = $0200,  /* This is a repeated key */
      KQ_RELEASED = $0400,  /* Key is now being released */
      KQ_HELD     = $0800   /* Key is being held/pressed */

#define KQ_SHIFT (KQ_LSHIFT OR KQ_RSHIFT)

/****************************************************************************
** Non-ASCII key codes.
*/

CONST K_SCS     = $80,      -> Screen switch (LEFTAMIGA + M) 
      K_SLEFT   = $81,
      K_HELP    = $82,
      K_LSHIFT  = $83,
      K_RSHIFT  = $84,
      K_CAPS    = $85,
      K_CTRL    = $86,
      K_LALT    = $87,
      K_RALT    = $88,
      K_LAMIGA  = $89,
      K_RAMIGA  = $8a,

      K_F1  = $8b, K_F2  = $8c, K_F3  = $8d, K_F4  = $8e,
      K_F5  = $8f, K_F6  = $90, K_F7  = $91, K_F8  = $92,
      K_F9  = $93, K_F10 = $94, K_F11 = $95, K_F12 = $96,
      K_F13 = $97, K_F14 = $98, K_F15 = $99, K_F16 = $9a,
      K_F17 = $9b, K_F18 = $9c, K_F19 = $9d, K_F20 = $9e,

      K_UP = $9f, K_DOWN = $a0, K_RIGHT = $a1, K_LEFT = $a2,

      K_SRIGHT  = $a3      -> Special key on right 

/****************************************************************************
** Some keys that are recognised under ASCII (here for convenience)
*/

CONST K_BAKSPC = 8,
      K_TAB    = 9,
      K_ENTER  = 10,
      K_RETURN = 10,
      K_ESC    = $1b,
      K_DEL    = $7f

