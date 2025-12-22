/* $Id: diskfont_protos.h,v 1.11 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/diskfont/diskfont', 'target/diskfont/diskfonttag', 'target/diskfont/glyph', 'target/diskfont/oterrors'
MODULE 'target/dos/dos', 'target/libraries/diskfont', 'target/utility/tagitem'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/graphics/text', 'target/exec/lists', 'target/exec/types'
{
#include <proto/diskfont.h>
}
{
struct Library* DiskfontBase = NULL;
struct DiskfontIFace* IDiskfont = NULL;
}
NATIVE {CLIB_DISKFONT_PROTOS_H} CONST
NATIVE {PROTO_DISKFONT_H} CONST
NATIVE {PRAGMA_DISKFONT_H} CONST
NATIVE {INLINE4_DISKFONT_H} CONST
NATIVE {DISKFONT_INTERFACE_DEF_H} CONST

NATIVE {DiskfontBase} DEF diskfontbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IDiskfont}    DEF

PROC new()
	InitLibrary('diskfont.library', NATIVE {(struct Interface **) &IDiskfont} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

->NATIVE {OpenDiskFont} PROC
PROC OpenDiskFont( textAttr:PTR TO textattr ) IS NATIVE {IDiskfont->OpenDiskFont(} textAttr {)} ENDNATIVE !!PTR TO textfont
->NATIVE {AvailFonts} PROC
PROC AvailFonts( buffer:ARRAY OF CHAR /*STRPTR*/, bufBytes:VALUE, flags:ULONG ) IS NATIVE {IDiskfont->AvailFonts(} buffer {,} bufBytes {,} flags {)} ENDNATIVE !!VALUE
/*--- functions in V34 or higher (Release 1.3) ---*/
->NATIVE {NewFontContents} PROC
PROC NewFontContents( fontsLock:BPTR, fontName:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {IDiskfont->NewFontContents(} fontsLock {,} fontName {)} ENDNATIVE !!PTR TO fch
->NATIVE {DisposeFontContents} PROC
PROC DisposeFontContents( fontContentsHeader:PTR TO fch ) IS NATIVE {IDiskfont->DisposeFontContents(} fontContentsHeader {)} ENDNATIVE
/*--- functions in V36 or higher (Release 2.0) ---*/
->NATIVE {NewScaledDiskFont} PROC
PROC NewScaledDiskFont( sourceFont:PTR TO textfont, destTextAttr:PTR TO textattr ) IS NATIVE {IDiskfont->NewScaledDiskFont(} sourceFont {,} destTextAttr {)} ENDNATIVE !!PTR TO diskfontheader
/*--- functions in V45 or higher (Beta release for developers only) ---*/
->NATIVE {GetDiskFontCtrl} PROC
PROC GetDiskFontCtrl( tagid:VALUE ) IS NATIVE {IDiskfont->GetDiskFontCtrl(} tagid {)} ENDNATIVE !!VALUE
->NATIVE {SetDiskFontCtrlA} PROC
PROC SetDiskFontCtrlA( taglist:ARRAY OF tagitem ) IS NATIVE {IDiskfont->SetDiskFontCtrlA(} taglist {)} ENDNATIVE
->NATIVE {SetDiskFontCtrl} PROC
PROC SetDiskFontCtrl( tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDiskfont->SetDiskFontCtrl(} tag1 {,} tag12 {,} ... {)} ENDNATIVE
/*--- functions in V46 or higher (Beta release for developers only) ---*/
->NATIVE {EOpenEngine} PROC
PROC EopenEngine( eEngine:PTR TO eglyphengine ) IS NATIVE {IDiskfont->EOpenEngine(} eEngine {)} ENDNATIVE !!VALUE
->NATIVE {ECloseEngine} PROC
PROC EcloseEngine( eEngine:PTR TO eglyphengine ) IS NATIVE {IDiskfont->ECloseEngine(} eEngine {)} ENDNATIVE
->NATIVE {ESetInfoA} PROC
PROC EsetInfoA( eEngine:PTR TO eglyphengine, taglist:ARRAY OF tagitem ) IS NATIVE {IDiskfont->ESetInfoA(} eEngine {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {ESetInfo} PROC
PROC EsetInfo( eEngine:PTR TO eglyphengine, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDiskfont->ESetInfo(} eEngine {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {EObtainInfoA} PROC
PROC EobtainInfoA( eEngine:PTR TO eglyphengine, taglist:ARRAY OF tagitem ) IS NATIVE {IDiskfont->EObtainInfoA(} eEngine {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {EObtainInfo} PROC
PROC EobtainInfo( eEngine:PTR TO eglyphengine, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDiskfont->EObtainInfo(} eEngine {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {EReleaseInfoA} PROC
PROC EreleaseInfoA( eEngine:PTR TO eglyphengine, taglist:ARRAY OF tagitem ) IS NATIVE {IDiskfont->EReleaseInfoA(} eEngine {,} taglist {)} ENDNATIVE !!ULONG
->NATIVE {EReleaseInfo} PROC
PROC EreleaseInfo( eEngine:PTR TO eglyphengine, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDiskfont->EReleaseInfo(} eEngine {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {OpenOutlineFont} PROC
PROC OpenOutlineFont( name:ARRAY OF CHAR /*STRPTR*/, list:PTR TO lh, flags:ULONG ) IS NATIVE {IDiskfont->OpenOutlineFont(} name {,} list {,} flags {)} ENDNATIVE !!PTR TO outlinefont
->NATIVE {CloseOutlineFont} PROC
PROC CloseOutlineFont( outlineFont:PTR TO outlinefont, list:PTR TO lh ) IS NATIVE {IDiskfont->CloseOutlineFont(} outlineFont {,} list {)} ENDNATIVE
->NATIVE {WriteFontContents} PROC
PROC WriteFontContents( fontsLock:BPTR, fontName:ARRAY OF CHAR /*STRPTR*/, fontContentsHeader:PTR TO fch ) IS NATIVE {IDiskfont->WriteFontContents(} fontsLock {,} fontName {,} fontContentsHeader {)} ENDNATIVE !!VALUE
->NATIVE {WriteDiskFontHeaderA} PROC
PROC WriteDiskFontHeaderA( font:PTR TO textfont, fileName:ARRAY OF CHAR /*STRPTR*/, taglist:ARRAY OF tagitem ) IS NATIVE {IDiskfont->WriteDiskFontHeaderA(} font {,} fileName {,} taglist {)} ENDNATIVE !!VALUE
->NATIVE {WriteDiskFontHeader} PROC
PROC WriteDiskFontHeader( font:PTR TO textfont, fileName:ARRAY OF CHAR /*STRPTR*/, tag1:TAG, tag12=0:ULONG, ... ) IS NATIVE {IDiskfont->WriteDiskFontHeader(} font {,} fileName {,} tag1 {,} tag12 {,} ... {)} ENDNATIVE !!VALUE
->NATIVE {ObtainCharsetInfo} PROC
PROC ObtainCharsetInfo( knownTag:ULONG, knownValue:ULONG, wantedTag:ULONG ) IS NATIVE {IDiskfont->ObtainCharsetInfo(} knownTag {,} knownValue {,} wantedTag {)} ENDNATIVE !!ULONG
/*--- functions in V49 or higher (Beta release for developers only) ---*/
->NATIVE {ObtainTTextAttr} PROC
PROC ObtainTTextAttr( textFont:PTR TO textfont ) IS NATIVE {IDiskfont->ObtainTTextAttr(} textFont {)} ENDNATIVE !!PTR TO ttextattr
->NATIVE {FreeTTextAttr} PROC
PROC FreeTTextAttr( tta:PTR TO ttextattr ) IS NATIVE {IDiskfont->FreeTTextAttr(} tta {)} ENDNATIVE
