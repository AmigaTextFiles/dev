@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "post.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY psbase                  /* informal notation */
  Pscreateact(A1)               /* -30 (1E) */
  Psdeleteact(A0)               /* -36 (24) */
  Psintstring(A0,A1,D0,D1)      /* -42 (2A) */
  Pssignalint(A0,D0)            /* -48 (30) */
  Pssignalfpe(A0)               /* -54 (36) */
  Pserror(A0,D0)                /* -60 (3C) */
  Pssetdevice(A0,A1)            /* -78 (4E) */
  Pserrstr(A0,D0)               /* -84 (54) */
ENDLIBRARY
@endnode
