/* $VER: keymap_protos.h 40.1 (17.5.1996) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/devices/keymap'
MODULE 'target/devices/inputevent', 'target/devices/keymap'
MODULE 'target/exec/libraries'
{MODULE 'keymap'}

NATIVE {keymapbase} DEF keymapbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V36 or higher (Release 2.0) ---*/
NATIVE {SetKeyMapDefault} PROC
PROC SetKeyMapDefault( keyMap:PTR TO keymap ) IS NATIVE {SetKeyMapDefault(} keyMap {)} ENDNATIVE
NATIVE {AskKeyMapDefault} PROC
PROC AskKeyMapDefault( ) IS NATIVE {AskKeyMapDefault()} ENDNATIVE !!PTR TO keymap
NATIVE {MapRawKey} PROC
PROC MapRawKey( event:PTR TO inputevent, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap ) IS NATIVE {MapRawKey(} event {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!INT
NATIVE {MapANSI} PROC
PROC MapANSI( string:/*CONST_STRPTR*/ ARRAY OF CHAR, count:VALUE, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap ) IS NATIVE {MapANSI(} string {,} count {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!VALUE
