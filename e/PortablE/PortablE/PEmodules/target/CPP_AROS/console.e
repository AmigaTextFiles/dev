OPT NATIVE
MODULE 'target/aros/libcall', 'target/exec/io', 'target/devices/keymap'
MODULE 'target/exec/devices', 'target/devices/inputevent', 'target/exec/types'
{
#include <proto/console.h>
}
{
struct Device* ConsoleDevice = NULL;
}
NATIVE {CLIB_CONSOLE_PROTOS_H} CONST
NATIVE {PROTO_CONSOLE_H} CONST

NATIVE {ConsoleDevice} DEF consoledevice:PTR TO dd		->AmigaE does not automatically initialise this

NATIVE {CDInputHandler} PROC
PROC CdInputHandler(events:PTR TO inputevent, _cdihdata:APTR) IS NATIVE {CDInputHandler(} events {,} _cdihdata {)} ENDNATIVE !!PTR TO inputevent
NATIVE {RawKeyConvert} PROC
PROC RawKeyConvert(events:PTR TO inputevent, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap) IS NATIVE {RawKeyConvert(} events {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!VALUE
