/* $VER: diskfont_protos.h 36.1 (1.5.1990) */
OPT NATIVE, INLINE
PUBLIC MODULE 'target/diskfont/diskfont', 'target/diskfont/diskfonttag', 'target/diskfont/glyph', 'target/diskfont/oterrors'
MODULE 'target/dos/dos', 'target/exec/libraries', /*'target/libraries/diskfont',*/ 'target/utility/tagitem'
MODULE 'target/graphics/text', 'target/exec/types'
{MODULE 'diskfont'}

NATIVE {diskfontbase} DEF diskfontbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {OpenDiskFont} PROC
PROC OpenDiskFont( textAttr:PTR TO textattr ) IS NATIVE {OpenDiskFont(} textAttr {)} ENDNATIVE !!PTR TO textfont
->NATIVE {AvailFonts} PROC
PROC AvailFonts( buffer:ARRAY OF CHAR /*STRPTR*/, bufBytes:VALUE, flags:VALUE ) IS NATIVE {AvailFonts(} buffer {,} bufBytes {,} flags {)} ENDNATIVE !!VALUE
/*--- functions in V34 or higher (Release 1.3) ---*/
NATIVE {NewFontContents} PROC
PROC NewFontContents( fontsLock:BPTR, fontName:ARRAY OF CHAR /*STRPTR*/ ) IS NATIVE {NewFontContents(} fontsLock {,} fontName {)} ENDNATIVE !!PTR TO fch
NATIVE {DisposeFontContents} PROC
PROC DisposeFontContents( fontContentsHeader:PTR TO fch ) IS NATIVE {DisposeFontContents(} fontContentsHeader {)} ENDNATIVE
/*--- functions in V36 or higher (Release 2.0) ---*/
NATIVE {NewScaledDiskFont} PROC
->OS3 include has wrong declared return type: PROC NewScaledDiskFont( sourceFont:PTR TO textfont, destTextAttr:PTR TO textattr ) IS NATIVE {NewScaledDiskFont(} sourceFont {,} destTextAttr {)} ENDNATIVE !!PTR TO diskfontheader
/*--- functions in V45 or higher (Release 3.9) ---*/
->NATIVE {GetDiskFontCtrl} PROC
->PROC GetDiskFontCtrl( tagid:VALUE ) IS NATIVE {GetDiskFontCtrl(} tagid {)} ENDNATIVE !!VALUE
->NATIVE {SetDiskFontCtrlA} PROC
->PROC SetDiskFontCtrlA( taglist:ARRAY OF tagitem ) IS NATIVE {SetDiskFontCtrlA(} taglist {)} ENDNATIVE
->NATIVE {SetDiskFontCtrl} PROC
->PROC SetDiskFontCtrl( tag1:TAG, tag12=0:ULONG, tag13=0:ULONG, tag14=0:ULONG, tag15=0:ULONG, tag16=0:ULONG, tag17=0:ULONG, tag18=0:ULONG ) IS NATIVE {SetDiskFontCtrl(} tag1 {,} tag12 {,} tag13 {,} tag14 {,} tag15 {,} tag16 {,} tag17 {,} tag18 {)} ENDNATIVE
