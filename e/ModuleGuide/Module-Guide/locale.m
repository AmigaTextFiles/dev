@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "locale.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY localebase              /* informal notation */
  CloseCatalog(A0)              /* -36 (24) */
  CloseLocale(A0)               /* -42 (2A) */
  ConvToLower(A0,D0)            /* -48 (30) */
  ConvToUpper(A0,D0)            /* -54 (36) */
  FormatDate(A0,A1,A2,A3)       /* -60 (3C) */
  FormatString(A0,A1,A2,A3)     /* -66 (42) */
  GetCatalogStr(A0,D0,A1)       /* -72 (48) */
  GetLocaleStr(A0,D0)           /* -78 (4E) */
  IsAlNum(A0,D0)                /* -84 (54) */
  IsAlpha(A0,D0)                /* -90 (5A) */
  IsCntrl(A0,D0)                /* -96 (60) */
  IsDigit(A0,D0)                /* -102 (66) */
  IsGraph(A0,D0)                /* -108 (6C) */
  IsLower(A0,D0)                /* -114 (72) */
  IsPrint(A0,D0)                /* -120 (78) */
  IsPunct(A0,D0)                /* -126 (7E) */
  IsSpace(A0,D0)                /* -132 (84) */
  IsUpper(A0,D0)                /* -138 (8A) */
  IsXDigit(A0,D0)               /* -144 (90) */
  OpenCatalogA(A0,A1,A2)        /* -150 (96) */
  OpenLocale(A0)                /* -156 (9C) */
  ParseDate(A0,A1,A2,A3)        /* -162 (A2) */
  StrConvert(A0,A1,A2,D0,D1)    /* -174 (AE) */
  StrnCmp(A0,A1,A2,D0,D1)       /* -180 (B4) */
ENDLIBRARY
@endnode
