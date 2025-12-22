OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO OpenDiskFont(textAttr) IS (A0:=textAttr) BUT (A6:=diskfontbase) BUT ASM ' jsr -30(a6)'
MACRO AvailFonts(buffer,bufBytes,flags) IS Stores(diskfontbase,buffer,bufBytes,flags) BUT Loads(A6,A0,D0,D1) BUT ASM ' jsr -36(a6)'
-> --- functions in V34 or higher (Release 1.3) ---
MACRO NewFontContents(fontsLock,fontName) IS Stores(diskfontbase,fontsLock,fontName) BUT Loads(A6,A0,A1) BUT ASM ' jsr -42(a6)'
MACRO DisposeFontContents(fontContentsHeader) IS (A1:=fontContentsHeader) BUT (A6:=diskfontbase) BUT ASM ' jsr -48(a6)'
-> --- functions in V36 or higher (Release 2.0) ---
MACRO NewScaledDiskFont(sourceFont,destTextAttr) IS Stores(diskfontbase,sourceFont,destTextAttr) BUT Loads(A6,A0,A1) BUT ASM ' jsr -54(a6)'
