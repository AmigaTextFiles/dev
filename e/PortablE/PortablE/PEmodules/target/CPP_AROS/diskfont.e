OPT NATIVE, INLINE
PUBLIC MODULE 'target/diskfont/diskfont', 'target/diskfont/diskfonttag', 'target/diskfont/glyph', 'target/diskfont/oterrors'
MODULE 'target/aros/libcall', 'target/dos/dos', 'target/graphics/text'
MODULE 'target/exec/types', 'target/exec/libraries', 'target/aros/system', 'target/defines/diskfont'
{
#include <proto/diskfont.h>
}
{
struct Library* DiskfontBase = NULL;
}
NATIVE {CLIB_DISKFONT_PROTOS_H} CONST
NATIVE {PROTO_DISKFONT_H} CONST

NATIVE {DiskfontBase} DEF diskfontbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {OpenDiskFont} PROC
PROC OpenDiskFont(textAttr:PTR TO textattr) IS NATIVE {OpenDiskFont(} textAttr {)} ENDNATIVE !!PTR TO textfont
->NATIVE {AvailFonts} PROC
PROC AvailFonts(buffer:/*STRPTR*/ ARRAY OF CHAR, bufBytes:VALUE, flags:VALUE) IS NATIVE {AvailFonts(} buffer {,} bufBytes {,} flags {)} ENDNATIVE !!VALUE
NATIVE {NewFontContents} PROC
PROC NewFontContents(fontsLock:BPTR, fontName:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {NewFontContents(} fontsLock {,} fontName {)} ENDNATIVE !!PTR TO fch
NATIVE {DisposeFontContents} PROC
PROC DisposeFontContents(fontContentsHeader:PTR TO fch) IS NATIVE {DisposeFontContents(} fontContentsHeader {)} ENDNATIVE
NATIVE {NewScaledDiskFont} PROC
->AROS include has wrong declared return type: PROC NewScaledDiskFont(sourceFont:PTR TO textfont, destTextAttr:PTR TO textattr) IS NATIVE {NewScaledDiskFont(} sourceFont {,} destTextAttr {)} ENDNATIVE !!PTR TO diskfontheader
