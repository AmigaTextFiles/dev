/* Automatically generated from '/home/aros/Build/20090307/AROS/rom/keymap/keymap.conf' */
OPT NATIVE
PUBLIC MODULE 'target/devices/keymap'
MODULE 'target/aros/libcall', 'target/devices/keymap', 'target/devices/inputevent', 'target/exec/types', 'target/aros/system'
MODULE 'target/exec/libraries'
{
#include <proto/keymap.h>
}
{
struct Library* KeymapBase = NULL;
}
NATIVE {CLIB_KEYMAP_PROTOS_H} CONST
NATIVE {PROTO_KEYMAP_H} CONST

NATIVE {KeymapBase} DEF keymapbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {SetKeyMapDefault} PROC
PROC SetKeyMapDefault(keyMap:PTR TO keymap) IS NATIVE {SetKeyMapDefault(} keyMap {)} ENDNATIVE
NATIVE {AskKeyMapDefault} PROC
PROC AskKeyMapDefault() IS NATIVE {AskKeyMapDefault()} ENDNATIVE !!PTR TO keymap
NATIVE {MapRawKey} PROC
PROC MapRawKey(event:PTR TO inputevent, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap) IS NATIVE {MapRawKey(} event {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!INT
NATIVE {MapANSI} PROC
PROC MapANSI(string:/*STRPTR*/ ARRAY OF CHAR, count:VALUE, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap) IS NATIVE {MapANSI(} string {,} count {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!VALUE
