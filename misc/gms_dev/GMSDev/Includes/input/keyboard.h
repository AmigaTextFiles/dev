#ifndef INPUT_KEYBOARD_H
#define INPUT_KEYBOARD_H TRUE

/*
**  $VER: keyboard.h V1.0
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** The Keyboard object.
*/

#define VER_KEYBOARD  1
#define TAGS_KEYBOARD ((ID_SPCTAGS<<16)|ID_KEYBOARD)

struct Keyboard {
  struct Head Head;         /* [00] Standard header */
  LONG   Size;              /* [12] Amount of key entries buffer can hold */
  struct KeyEntry *Buffer;  /* [16] Pointer to key buffer array */
  WORD   AmtRead;           /* [20] Amount of keys read from last query */
  WORD   Flags;             /* [22] Special flags */

  /*** Private fields below ***/

  LONG   prvID;             /* Private ID */
};

struct KeyEntry {
  WORD  Qualifier;   /* Shift/Control/CapsLock... */
  UBYTE Value;       /* A/B/C/D... */
  BYTE  Reserved;    /* Reserved for the future */
};

/****************************************************************************
** Key Tags
*/

#define KEYA_Size  (TLONG|12)
#define KEYA_Flags (TWORD|22)

/****************************************************************************
** Key->Flags
*/

#define KF_AUTOSHIFT 0x0001  /* Auto-Shift handling */
#define KF_GLOBAL    0x0002  /* Receive all keyboard input */

/****************************************************************************
** KeyEntry Qualifiers.
*/

#define KQ_LSHIFT   0x0001  /* Left Shift  */
#define KQ_RSHIFT   0x0002  /* Right Shift */
#define KQ_CAPSLOCK 0x0004  /* Caps-Lock   */
#define KQ_CONTROL  0x0008  /* Control Key */
#define KQ_LALT     0x0010  /* Left Alt    */
#define KQ_RALT     0x0020  /* Right Alt   */
#define KQ_LCOMMAND 0x0040  /* Left Amiga  [Command] */
#define KQ_RCOMMAND 0x0080  /* Right Amiga [Command] */
#define KQ_KEYPAD   0x0100  /* This is a keypad key */
#define KQ_REPEAT   0x0200  /* This is a repeated key */
#define KQ_RELEASED 0x0400  /* Key is now being released */
#define KQ_HELD     0x0800  /* Key is being held/pressed */
#define KQ_SHIFT    (KQ_LSHIFT | KQ_RSHIFT)

/****************************************************************************
** Non-ASCII key codes.
*/

#define K_SCS    0x80   /* Private */
#define K_SLEFT  0x81   /* "Special" key on left */
#define K_HELP   0x82   /* Help */

#define K_LSHIFT 0x83   /* Left Shift  */
#define K_RSHIFT 0x84   /* Right Shift */
#define K_CAPS   0x85   /* Caps Lock   */
#define K_CTRL   0x86   /* Control     */
#define K_LALT   0x87   /* Left Alt    */
#define K_RALT   0x88   /* Right Alt   */
#define K_LAMIGA 0x89   /* Left Amiga  */
#define K_RAMIGA 0x8a   /* Right Amiga */

#define K_F1     0x8b   /* Function Key 1  */
#define K_F2     0x8c   /* Function Key 2  */
#define K_F3     0x8d   /* Function Key 3  */
#define K_F4     0x8e   /* Function Key 4  */
#define K_F5     0x8f   /* Function Key 5  */
#define K_F6     0x90   /* Function Key 6  */
#define K_F7     0x91   /* Function Key 7  */
#define K_F8     0x92   /* Function Key 8  */
#define K_F9     0x93   /* Function Key 9  */
#define K_F10    0x94   /* Function Key 10 */
#define K_F11    0x95   /* Function Key 11 */
#define K_F12    0x96   /* Function Key 12 */
#define K_F13    0x97   /* Function Key 13 */
#define K_F14    0x98   /* Function Key 14 */
#define K_F15    0x99   /* Function Key 15 */
#define K_F16    0x9a   /* Function Key 16 */
#define K_F17    0x9b   /* Function Key 17 */
#define K_F18    0x9c   /* Function Key 18 */
#define K_F19    0x9d   /* Function Key 19 */
#define K_F20    0x9e   /* Function Key 20 */

#define K_UP     0x9f   /* Cursor Up       */
#define K_DOWN   0xa0   /* Cursor Down     */
#define K_RIGHT  0xa1   /* Cursor Right    */
#define K_LEFT   0xa2   /* Cursor Left     */
#define K_SRIGHT 0xa3   /* "Special" key on right */

/****************************************************************************
** Special keys that are recognised under ASCII (here for convenience)
*/

#define K_BAKSPC 08
#define K_TAB    09
#define K_ENTER  10
#define K_RETURN 10
#define K_ESC    0x1b
#define K_DEL    0x7f

#endif /* INPUT_KEYBOARD_H */
