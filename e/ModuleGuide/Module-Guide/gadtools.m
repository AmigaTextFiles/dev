@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "gadtools.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY gadtoolsbase                    /* informal notation */
  CreateGadgetA(D0,A0,A1,A2)            /* -30 (1E) */
  FreeGadgets(A0)                       /* -36 (24) */
  Gt_SetGadgetAttrsA(A0,A1,A2,A3)       /* -42 (2A) */
  CreateMenusA(A0,A1)                   /* -48 (30) */
  FreeMenus(A0)                         /* -54 (36) */
  LayoutMenuItemsA(A0,A1,A2)            /* -60 (3C) */
  LayoutMenusA(A0,A1,A2)                /* -66 (42) */
  Gt_GetIMsg(A0)                        /* -72 (48) */
  Gt_ReplyIMsg(A1)                      /* -78 (4E) */
  Gt_RefreshWindow(A0,A1)               /* -84 (54) */
  Gt_BeginRefresh(A0)                   /* -90 (5A) */
  Gt_EndRefresh(A0,D0)                  /* -96 (60) */
  Gt_FilterIMsg(A1)                     /* -102 (66) */
  Gt_PostFilterIMsg(A1)                 /* -108 (6C) */
  CreateContext(A0)                     /* -114 (72) */
  DrawBevelBoxA(A0,D0,D1,D2,D3,A1)      /* -120 (78) */
  GetVisualInfoA(A0,A1)                 /* -126 (7E) */
  FreeVisualInfo(A0)                    /* -132 (84) */
  Gt_GetGadgetAttrsA(A0,A1,A2,A3)       /* -174 (AE) */
ENDLIBRARY
@endnode
