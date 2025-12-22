@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "wb.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY workbenchbase                   /* informal notation */
  AddAppWindowA(D0,D1,A0,A1,A2)         /* -48 (30) */
  RemoveAppWindow(A0)                   /* -54 (36) */
  AddAppIconA(D0,D1,A0,A1,A2,A3,A4)     /* -60 (3C) */
  RemoveAppIcon(A0)                     /* -66 (42) */
  AddAppMenuItemA(D0,D1,A0,A1,A2)       /* -72 (48) */
  RemoveAppMenuItem(A0)                 /* -78 (4E) */
  WbInfo(A0,A1,A2)                      /* -90 (5A) */
ENDLIBRARY
@endnode
