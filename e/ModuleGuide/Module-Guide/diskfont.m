@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "diskfont.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY diskfontbase         /* informal notation */
  OpenDiskFont(A0)           /* -30 (1E) */
  AvailFonts(A0,D0,D1)       /* -36 (24) */
  NewFontContents(A0,A1)     /* -42 (2A) */
  DisposeFontContents(A1)    /* -48 (30) */
  NewScaledDiskFont(A0,A1)   /* -54 (36) */
ENDLIBRARY
@endnode
