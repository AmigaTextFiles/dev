/* $VER: console_protos.h 40.1 (17.5.1996) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/devices/inputevent', 'target/devices/keymap'
MODULE 'target/exec/devices'
{
#include <proto/console.h>
}
{
struct Device* ConsoleDevice = NULL;
}
NATIVE {CLIB_CONSOLE_PROTOS_H} CONST
NATIVE {_PROTO_CONSOLE_H} CONST
NATIVE {PRAGMA_CONSOLE_H} CONST
NATIVE {PRAGMAS_CONSOLE_PRAGMAS_H} CONST

NATIVE {ConsoleDevice} DEF consoledevice:PTR TO dd		->AmigaE does not automatically initialise this

NATIVE {CDInputHandler} PROC
PROC CdInputHandler( events:PTR TO inputevent, consoleDevice:PTR TO lib ) IS NATIVE {CDInputHandler(} events {,} consoleDevice {)} ENDNATIVE !!PTR TO inputevent
NATIVE {RawKeyConvert} PROC
PROC RawKeyConvert( events:PTR TO inputevent, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap ) IS NATIVE {RawKeyConvert(} events {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!VALUE
/*--- functions in V36 or higher (Release 2.0) ---*/
