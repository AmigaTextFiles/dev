#ifndef IEDIT_EXPANDERS_PROTOS_H
#define IEDIT_EXPANDERS_PROTOS_H

/* tag.a                */

extern ALibExpunge(), ALibClose(), ALibOpen(), ALibReserved();

/* lib.c                */

extern __geta4 struct Library *LibInit   ( __A0 BPTR );
extern __geta4 struct Library *LibOpen   ( __D0 long,  __A0 struct Library * );
extern __geta4 long            LibClose  ( __A0 struct Library * );
extern __geta4 long            LibExpunge( __A0 struct Library * );

/* funcs.c              */

extern __geta4 ULONG        IEX_Mount( __A0 struct IE_Data * );
extern __geta4 BOOL         IEX_Add( __D0 UWORD, __A0 struct IE_Data *, __D1 WORD, __D2 WORD, __D3 UWORD, __D4 UWORD );
extern __geta4 void         IEX_Remove( __D0 UWORD, __A0 struct IE_Data * );
extern __geta4 BOOL         IEX_Edit( __D0 UWORD, __A0 struct IE_Data * );
extern __geta4 BOOL         IEX_Copy( __D0 UWORD, __A0 struct IE_Data *, __D1 WORD, __D2 WORD );
extern __geta4 struct Gadget *IEX_Make( __D0 UWORD, __A0 struct IE_Data *, __A1 struct Gadget * );
extern __geta4 void         IEX_Free( __D0 UWORD, __A0 struct IE_Data * );
extern __geta4 void         IEX_Refresh( __D0 UWORD, __A0 struct IE_Data * );

extern __geta4 void         IEX_Save( __D0 UWORD, __A0 struct IE_Data *, __D1 BPTR );
extern __geta4 BOOL         IEX_Load( __D0 UWORD, __A0 struct IE_Data *, __D1 BPTR, __D2 UWORD );

extern __geta4 STRPTR       IEX_StartSrcGen( __D0 UWORD, __A0 struct IE_Data * );
extern __geta4 void         IEX_WriteGlobals( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteSetup( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteCloseDown( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteHeaders( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteRender( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 ULONG        IEX_GetIDCMP( __D0 UWORD, __D1 ULONG, __A0 struct IE_Data * );
extern __geta4 void         IEX_WriteData( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteChipData( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteOpenWnd( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
extern __geta4 void         IEX_WriteCloseWnd( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );

extern __geta4 void         IEX_WriteGadgetTags( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data *, __A2 struct GadgetInfo * );
extern __geta4 void         IEX_WriteWindowTags( __D0 UWORD, __A0 struct GenFiles *, __A1 struct IE_Data * );
#endif
