/*
**  Protoypes for IE sources
**  ©1994-1996 Simone Tellini Software
*/

#ifndef IE_PROTOS_H
#define IE_PROTOS_H

/// main.c
extern int IERequest( STRPTR, STRPTR, ULONG, ULONG );
extern BOOL ThisIsADemo( void );
extern void Stat( __A0 STRPTR, __D0 BOOL, __D1 ULONG );
extern void SistemaPrefsMenu( void );
extern void EliminaFont( __A0 struct TxtAttrNode * );
extern struct TxtAttrNode *AggiungiFont( __A0 struct TextAttr * );
extern void LiberaFntLst( void );
extern void Coord( void );
extern void CheckMenuToActive( void );
extern void Rect( int, int, int, int );
extern void ToolsGadgetsOn( void );
extern void ToolsGadgetsOff( void );
extern BOOL ApriListaFin( STRPTR, ULONG, struct MinList * );
extern void ChiudiListaFin( void );
extern WORD GestisciListaFin( UWORD, UWORD );
extern BOOL GetFile2( BOOL, STRPTR, STRPTR, ULONG, STRPTR );
extern void DrawRect( UWORD, UWORD );
extern BOOL GetGenerators( void );
extern void FreeGenerators( void );
extern BOOL opentoolswnd( void );
extern void ClearGUI( void );
extern ULONG ReqHandle( struct Window *, ULONG ( *Handler )( void ));
extern void HandleEdit( void );
extern void SistemaGadgetsItem( void );
extern void SistemaGadgetsFlags( struct MinList * );
///
/// screen.c
extern void GadgetsUp( void );
extern void GadgetsDown( void );
extern void RifaiGadgets( void );
extern void UpdateScr( void );
extern void LoadScr( void );
extern void WriteScr( void );
extern void LayoutWindow( struct TagItem * );
extern void PostOpenWindow( struct TagItem * );
extern void CheckForVisitors( void );
extern void CloseReqs( void );
extern struct Gadget *CreateGadgets( struct MinList *, struct Gadget * );
///
/// gadgets.c
extern struct GadgetInfo *GetGad( void );
extern void CheckSize( struct GadgetInfo * );
extern struct TxtAttrNode *FontRequest( struct TextAttr *, STRPTR, ULONG );
extern BOOL ResizeGadgets( void );
extern void ContornoGadgets( BOOL );
extern void PosizioneGadgets( WORD, WORD );
extern BOOL TestAttivi( void );
extern void RinfrescaFinestra( void );
extern void AttivaGadgets( void );
extern void MenuGadgetDisattiva( void );
extern void MenuGadgetAttiva( void );
extern void DisattivaTuttiGad( void );
extern void AttaccaGadgets( void );
extern void StaccaGadgets( void );
extern void SetUnder( ULONG *, ULONG );
extern void ListEditor( struct MinList *, BOOL, UWORD *, STRPTR, ULONG );
///
/// gadgets2.c
extern void AccodaBooleani( void );
extern void SistemaNextBool( void );
extern ULONG GetNodeNum( APTR, APTR );
extern void AggiungiBooleano( void );
extern void ParametriBooleano( struct BooleanInfo * );
extern void RemGBank( struct GadgetBank * );
extern void AddGBank( struct GadgetBank * );
extern void DetacheGBanks( void );
extern void ReAttachGBanks( void );
extern void EliminaGBanks( struct WindowInfo * );
extern BOOL CheckActivationKey( struct WindowInfo *, struct GadgetInfo * );
///
/// windows.c
extern struct Window *OpenWindowShdIDCMP( ULONG *, ULONG );
extern void CloseWindowSafely( struct Window * );
extern void LockAllWindows( void );
extern void UnlockAllWindows( void );
extern void EliminaGadgets( struct WindowInfo * );
extern void EliminaMenus( struct WindowInfo * );
extern void EliminaBoxes( struct WindowInfo * );
extern void EliminaTexts( struct WindowInfo * );
extern void EliminaImages( struct WindowInfo * );
extern void EliminaAllWorkWnd( void );
extern struct ITextNode *GetText( void );
extern struct WndImages *GetImg( void );
extern struct WindowInfo *GetWnd( void );
extern struct BevelBoxNode *CheckBox( void );
extern struct BevelBoxNode *GetBox( void );
extern void DisegnaContorno( WORD, WORD, UWORD, UWORD );
extern BOOL WaitButton( void );
extern BOOL TraceRect( void );
extern void DisattivaNoOpen( void );
extern void SettaWFlags( struct WindowInfo * );
///
/// IO.c
extern void PutString( STRPTR );
extern void FGetString( UBYTE * );
extern BOOL AskFile( STRPTR );
extern ULONG CountNodes( struct MinList * );
///
/// prefs.c
extern void EliminaMainProcData( void );
extern void LiberaARexxCmds( void );
extern BOOL GetFile3( BOOL, STRPTR, STRPTR, ULONG, STRPTR, STRPTR, STRPTR );
extern void RemoveItem( struct Menu *, struct MenuItem * );
extern void AddItem( struct Menu *, struct MenuItem * );
extern void FreeMacroItems( void );
extern void AttaccaMenus( void );
extern void StaccaMenus( void );
extern void AddMacroItem( STRPTR );
extern void SistemaMacroMenu( void );
extern void CloseGenReq( void );
extern void GetF( void );
extern void CloseRexxEdReq( void );
///
/// menus.c
extern void NodeUp( APTR );
extern void NodeDown( APTR );
extern void EliminaMenus( struct WindowInfo * );
extern void DrawImg( struct Window *, struct ImageNode *, WORD, WORD );
extern void FreeImgList( void );
extern BOOL GetImgFile( BOOL, STRPTR, ULONG, STRPTR );
///
/// IEX.c
extern void GetExpanders( void );
extern void FreeExpanders( void );
extern void SplitLines( __A0 UBYTE * );
extern STRPTR GetFirstLine( __A0 UBYTE *, __A1 STRPTR );
extern void WriteFormatted( __D0 BPTR, __A0 STRPTR, __A1 struct Descriptor * );
extern void AddObject( UWORD );
extern APTR AllocObject( __D0 UWORD );
extern void FreeObject( __A0 APTR, __D0 UWORD );
extern BOOL AddGadgetKind( __A0 struct Expander *, __A1 struct Node * );
extern BOOL AddARexxCmd( __A0 struct ExCmdNode * );
extern void FreeARexxCmds( void );
///
/// BOOPSI.c
extern BOOL BoopsiEditor( struct BOOPSIInfo * );
///
/// locale.c
extern void FreeLocaleData( void );
extern BOOL GetStrings( void );
extern void PutStrings( void );
extern void WriteCatalogs( STRPTR );
extern struct LocaleStr *FindString( __A0 struct MinList *, __A1 STRPTR );
extern struct ArrayNode *FindArray( __A0 struct MinList *, __A1 struct MinList * );
///

/// Loader
extern ULONG LoadGUI( struct IE_Data *, UBYTE * );
extern ULONG LoadWindows( struct IE_Data *, UBYTE * );
extern ULONG LoadGadgets( struct IE_Data *, UBYTE * );
extern ULONG LoadScreen( struct IE_Data *, UBYTE * );
///

#endif
