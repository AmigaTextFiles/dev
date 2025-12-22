/* $VER: keymap_protos.h 53.10 (31.1.2010) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/devices/keymap'
MODULE 'target/devices/inputevent', 'target/libraries/keymap', 'target/exec/types', 'target/exec', 'target/exec/interfaces'
MODULE 'target/PEalias/exec', 'target/utility/tagitem'
{
#include <proto/keymap.h>
}
{
struct Library* KeymapBase = NULL;
struct KeymapIFace* IKeymap = NULL;
}
NATIVE {CLIB_KEYMAP_PROTOS_H} CONST
NATIVE {PROTO_KEYMAP_H} CONST
NATIVE {KEYMAP_INTERFACE_DEF_H} CONST
NATIVE {INLINE4_KEYMAP_H} CONST

NATIVE {KeymapBase} DEF keymapbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IKeymap} DEF

PROC new()
	InitLibrary('keymap.library', NATIVE {(struct Interface **) &IKeymap} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {SetKeyMapDefault} PROC
PROC SetKeyMapDefault( keyMap:PTR TO keymap ) IS NATIVE {IKeymap->SetKeyMapDefault(} keyMap {)} ENDNATIVE
->NATIVE {AskKeyMapDefault} PROC
PROC AskKeyMapDefault( ) IS NATIVE {IKeymap->AskKeyMapDefault()} ENDNATIVE !!PTR TO keymap
->NATIVE {MapRawKey} PROC
PROC MapRawKey( event:PTR TO inputevent, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap ) IS NATIVE {IKeymap->MapRawKey(} event {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!INT
->NATIVE {MapANSI} PROC
PROC MapANSI( string:/*CONST_STRPTR*/ ARRAY OF CHAR, count:VALUE, buffer:/*STRPTR*/ ARRAY OF CHAR, length:VALUE, keyMap:PTR TO keymap ) IS NATIVE {IKeymap->MapANSI(} string {,} count {,} buffer {,} length {,} keyMap {)} ENDNATIVE !!VALUE
/*--- functions in V50 or higher (Release 4.0 beta) ---*/
->NATIVE {OpenKeyMapHandleA} PROC
PROC OpenKeyMapHandleA( filename:/*STRPTR*/ ARRAY OF CHAR, taglist:PTR TO tagitem ) IS NATIVE {IKeymap->OpenKeyMapHandleA(} filename {,} taglist {)} ENDNATIVE !!APTR
->NATIVE {OpenKeyMapHandle} PROC
PROC OpenKeyMapHandle( filename:/*STRPTR*/ ARRAY OF CHAR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IKeymap->OpenKeyMapHandle(} filename {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!APTR
->NATIVE {CloseKeyMapHandle} PROC
PROC CloseKeyMapHandle( handle:APTR ) IS NATIVE {IKeymap->CloseKeyMapHandle(} handle {)} ENDNATIVE
->NATIVE {ObtainKeyMapInfoA} PROC
PROC ObtainKeyMapInfoA( handle:APTR, taglist:PTR TO tagitem ) IS NATIVE {IKeymap->ObtainKeyMapInfoA(} handle {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {ObtainKeyMapInfo} PROC
PROC ObtainKeyMapInfo( handle:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IKeymap->ObtainKeyMapInfo(} handle {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {ReleaseKeyMapInfoA} PROC
PROC ReleaseKeyMapInfoA( handle:APTR, taglist:PTR TO tagitem ) IS NATIVE {IKeymap->ReleaseKeyMapInfoA(} handle {,} taglist {)} ENDNATIVE
->NATIVE {ReleaseKeyMapInfo} PROC
PROC ReleaseKeyMapInfo( handle:APTR, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IKeymap->ReleaseKeyMapInfo(} handle {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE
/*--- functions in V51 or higher (Release 4.0 beta2) ---*/
->NATIVE {ObtainRawKeyInfoA} PROC
PROC ObtainRawKeyInfoA( taglist:PTR TO tagitem ) IS NATIVE {IKeymap->ObtainRawKeyInfoA(} taglist {)} ENDNATIVE
->NATIVE {ObtainRawKeyInfo} PROC
PROC ObtainRawKeyInfo( tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IKeymap->ObtainRawKeyInfo(} tag1 {,} tag12 {,} ... {)} ENDNATIVE
