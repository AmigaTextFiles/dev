
* $Id: WHDLoadSlave.s 1.2 2003/06/22 18:29:08 wepl Exp $

	INCDIR	Includes:
	INCLUDE UserSymbols.i
	INCLUDE	whdload.i

	dc.l		slave
	dc.b		BYTESYM
	ByteSymbol	<ws_Security>,ws_Security
	ByteSymbol	<ws_ID>,ws_ID
	ByteSymbol	<ws_Version>,ws_Version
	ByteSymbol	<ws_Flags>,ws_Flags
	ByteSymbol	<ws_BaseMemSize>,ws_BaseMemSize
	ByteSymbol	<ws_ExecInstall>,ws_ExecInstall
	ByteSymbol	<ws_GameLoader>,ws_GameLoader
	ByteSymbol	<ws_CurrentDir>,ws_CurrentDir
	ByteSymbol	<ws_DontCache>,ws_DontCache
	ByteSymbol	<ws_keydebug>,ws_keydebug
	ByteSymbol	<ws_keyexit>,ws_keyexit
	ByteSymbol	<ws_ExpMem>,ws_ExpMem
	ByteSymbol	<ws_name>,ws_name
	ByteSymbol	<ws_copy>,ws_copy
	ByteSymbol	<ws_info>,ws_info
	ByteSymbol	<ws_kickname>,ws_kickname
	ByteSymbol	<ws_kicksize>,ws_kicksize
	ByteSymbol	<ws_kickcrc>,ws_kickcrc
	ByteSymbol	<ws_SIZEOF>,ws_SIZEOF
	dc.b		ENDBASE
slave	dc.b		'WHDL Slave Structure',0
