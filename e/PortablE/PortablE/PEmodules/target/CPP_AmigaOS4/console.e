/* $Id: console_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/devices/inputevent', 'target/devices/keymap'
MODULE 'target/exec/devices', 'target/exec/types', 'target/exec/io', 'target/timer'
{
#include <proto/console.h>
}
{
struct Device* ConsoleDevice = NULL;
struct ConsoleIFace* IConsole = NULL;
}
PRIVATE
CONST ICONSOLE_SIZE = 20
DEF iconsole_ioRequest[ICONSOLE_SIZE]:ARRAY OF PTR TO io
DEF iconsole_count = 0
PUBLIC

NATIVE {CLIB_CONSOLE_PROTOS_H} CONST
NATIVE {PROTO_CONSOLE_H} CONST
NATIVE {PRAGMA_CONSOLE_H} CONST
NATIVE {INLINE4_CONSOLE_H} CONST
NATIVE {CONSOLE_INTERFACE_DEF_H} CONST

NATIVE {ConsoleDevice} DEF consoledevice:PTR TO dd		->AmigaE does not automatically initialise this
NATIVE {IConsole}      DEF

NATIVE {IConsole_size}      DEF
NATIVE {IConsole_ioRequest} DEF
NATIVE {IConsole_count}     DEF

PROC OpenDevice(devName:ARRAY OF CHAR, unit:ULONG, ioRequest:PTR TO io, flags:ULONG) REPLACEMENT
	DEF ret:BYTE
	ret := SUPER OpenDevice(devName, unit, ioRequest, flags)
	IF (ret = 0) AND StrCmpNoCase(devName, 'console.device')
		->get global interface for "console.device"
		NATIVE {
		if (IConsole == NULL) \{
			IConsole = (struct ConsoleIFace *) IExec->GetInterface((struct Library *)} ioRequest{->io_Device, "main", 1, NULL);
		\}
		} ENDNATIVE
		
		->add ioRequest to list
		IF iconsole_count >= ICONSOLE_SIZE THEN Throw("BUG", 'OpenDevice("console.device") called too many times for OS4 wrapper to handle')
		iconsole_ioRequest[iconsole_count++] := ioRequest;
	ENDIF
ENDPROC ret

PROC CloseDevice(ioRequest:PTR TO io) REPLACEMENT
	DEF i, found:BOOL
	
	->see if this ioRequest matches any used to open "console.device"
	found := FALSE
	FOR i := 0 TO iconsole_count-1
		IF iconsole_ioRequest[i] = ioRequest THEN found := TRUE
	ENDFOR IF found
	
	IF found
		->remove ioRequest from list
		iconsole_count--
		iconsole_ioRequest[i] := iconsole_ioRequest[iconsole_count]
		
		->drop interface for "console.device"
		IF iconsole_count = 0
			NATIVE {
				IExec->DropInterface((struct Interface *) IConsole);
				IConsole = NULL;
			} ENDNATIVE
		ENDIF
	ENDIF
	SUPER CloseDevice(ioRequest)
ENDPROC

->NATIVE {CDInputHandler} PROC
PROC CdInputHandler( events:PTR TO inputevent, consoleDevice:PTR TO lib ) IS NATIVE {IConsole->CDInputHandler(} events {,} consoleDevice {)} ENDNATIVE !!PTR TO inputevent
->NATIVE {RawKeyConvert} PROC
PROC RawKeyConvert( events:PTR TO inputevent, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap ) IS NATIVE {IConsole->RawKeyConvert(} events {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!VALUE
/*--- functions in V36 or higher (Release 2.0) ---*/
