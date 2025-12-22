@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "keymap.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY keymapbase          /* informal notation */
  SetKeyMapDefault(A0)      /* -30 (1E) */
  AskKeyMapDefault()        /* -36 (24) */
  MapRawKey(A0,A1,D1,A2)    /* -42 (2A) */
  MapANSI(A0,D0,A1,D1,A2)   /* -48 (30) */
ENDLIBRARY
@endnode
