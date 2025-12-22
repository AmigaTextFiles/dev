/*-- AutoRev header do NOT edit!
*
*   Program         :   Protos.h
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   04-Nov-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   04-Nov-91     1.00            Program routine protos.
*
*-- REV_END --*/

/*
 * --- About.c
 */
void PrintAbout( WORD l, WORD t );
void About( void );
/*
 * --- Binary.c
 */
long WriteIcon( void );
void WriteNewMenus( BPTR file );
void WriteITexts( BPTR file );
void WriteGadgetXtra( BPTR file, struct ExtNewGadget *eng );
void WriteGadgets( BPTR file );
long WriteBinary( long req );
void ReadNewMenus( BPTR file );
void ReadITexts( BPTR file );
void ReadGadgetXtra( BPTR file, struct ExtNewGadget *eng );
void ReadGadgets( BPTR file );
long ReadBinary( long req);
/*
 * --- Button.c
 */
long MakeButton( void );
void ChangeButton( struct ExtNewGadget *eng );
long EditButton( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- CheckBox.c
 */
long MakeCheckBox( void );
void ChangeCheckBox( struct ExtNewGadget *eng );
long EditCheckBox( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- Coords.c
 */
void SetTitle( UBYTE *title );
void UpdateCoords( long how, WORD l, WORD t, WORD w, WORD h );
/*
 * --- Cycle.c
 */
long MakeCycle( void );
void ChangeCycle( struct ExtNewGadget *eng );
long EditCycle( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- DriPen.c
 */
long EditDriPens( void );
/*
 * --- EAReq.c
 */
long MyRequest( UBYTE *hail, UBYTE *gadgets, UBYTE *body, ... );
/*
 * --- Func.c
 */
long ReadIMsg( struct Window *iwnd );
void ClearMsgPort( struct MsgPort *mport );
struct ListViewNode *MakeNode( UBYTE *name );
struct ListViewNode *FindNode( struct List *list , long entry );
void FreeList( struct List *list );
void GetMouseXY( UWORD *x, UWORD *y );
void Box( UWORD x, UWORD y, UWORD x1, UWORD y1 );
struct TagItem  *MakeTagList( long numtags );
long SetTagData( struct TagItem *tags, Tag tag, Tag data );
long MyTagInArray( Tag tag, struct TagItem *tags );
void FreeTagList( struct TagItem *tags, long numtags );
struct Gadget *WaitForGadget( struct Window *wnd );
long ReOpenScreen( long wnd );
void DoWBench( void );
struct ExtNewGadget *FindExtGad( struct Gadget *gadget );
void Renumber( void );
void CheckSuffix( void );
void SetStringGadget( struct Gadget *g );
void RemoveAllGadgets( void );
long RemakeAllGadgets( void );
void FreeExtGad( struct ExtNewGadget *eng );
long MouseMove( struct Window *wnd, long on );
void FlipFlop( struct Window *wnd, struct Gadget **list, long index, BOOL *val );
void EnableGadget( struct Window *wnd, struct Gadget **list, long index, BOOL val );
long ListToLabels( struct List *list, struct ExtNewGadget *eng );
long LabelsToList( struct List *list, struct ExtNewGadget *eng );
void SizeAGadget( struct ExtNewGadget *eng );
long CopyList( struct ExtNewGadget *src, struct ExtNewGadget *dst );
long CopyLabels( struct ExtNewGadget *src, struct ExtNewGadget *dst, long t );
BPTR MyOpen( long mode );
void DeleteAllGadgets( void );
void CheckDirExtension( void );
void RefreshWindow( void );
void AlertUser( long how );
void Quit( void );
long MyFPrintf( BPTR fh, UBYTE *format, ... );
long CountGadgets( void );
/*
 * --- GenAsm.c
 */
void WriteAsmNewMenu( BPTR file, struct ExtNewMenu *menu, UWORD num, BOOL what );
void WriteAsmMenus( BPTR file );
void WriteAsmID( BPTR file );
void WriteAsmXdef( BPTR file );
void WriteAsmGlob( BPTR file );
void WriteAsmGadgetTags( BPTR file );
void WriteAsmGText( BPTR file );
void WriteAsmLabels( BPTR file );
void WriteAsmNode( BPTR file, struct ExtNewGadget *eng, struct ListViewNode *node, WORD num );
void WriteAsmList( BPTR file );
void WriteAsmTextAttr( BPTR file );
void WriteAsmWTags( BPTR file );
void WriteAsmSTags( BPTR file );
void WriteAsmIText( BPTR file );
void WriteAsmGadgets( BPTR file );
void WriteAsmCleanup( BPTR file );
long WriteAsmSource( void );
/*
 * --- GenC.c
 */
void WritePlaceFlags( FILE *file, long flags, long mode );
void WriteIDFlags( FILE *file, long flags, long mode );
void WriteCDrMd( FILE *file, long drmd, long mode );
void WriteIDCMPFlags( FILE *file, long idcmp, long mode );
void WriteWindowFlags( FILE *file, long flags, long mode );
void WriteCNewMenu( FILE *file, struct ExtNewMenu *menu );
void WriteCMenus( FILE *file );
void WriteCID( FILE *file );
void WriteCGlob( FILE *file );
void WriteCLabels( FILE *file );
void WriteCNode( FILE *file, struct ExtNewGadget *eng, struct ListViewNode *node, WORD num );
void WriteCList( FILE *file );
void WriteCTextAttr( FILE *file );
void WriteCWTags( FILE *file );
void WriteCSTags( FILE *file );
void WriteCIText( FILE *file );
void WriteCHeader( FILE *file );
void WriteCGadgets( FILE *file );
void WriteCCleanup( FILE *file );
long WriteCSource( void );
/*
 * --- GetFont.c
 */
void GetFont( void );
/*
 * --- Idcmp.c
 */
void GetGadgetIDCMP( void );
void SetIDCMPGadgets( void );
void GetUserIDCMP( void );
void SetIDCMP( void );
long EditIDCMP( void );
/*
 * --- ItemEd.c
 */
void MutualExclude( void );
void SetEd( long type, struct ExtNewMenu *item );
void SetTheFlags( struct ExtNewMenu *item );
long ItemEdit( struct ExtNewMenu *parent );
/*
 *  --- ListView.c
 */
void SetLabels( struct ExtNewGadget *eng );
void GetLabels( struct ExtNewGadget *eng );
long MakeListView( void );
void ChangeListView( struct ExtNewGadget *eng );
long EditListView( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- auto.lib
 */
void _waitwbmsg( void );
/*
 * --- main.c
 */
APTR Malloc (ULONG size);
void HandleMenus( void );
void SetupProgram( long dsp );
void QuitProgram( long code );
void ClearWindow( void );
void MoveGadget( void );
void SizeGadget( void );
void CopyGadget( void );
void DeleteGadget( void );
void EditGadget( void );
void DisplayGInfo( long kind, WORD x, WORD y, WORD x1, WORD y1 );
void Join( void );
void Split( void );
long ParseName( void );
#ifdef MYKE_REMOVED_THIS
void _main( void );
#endif
/*
 * --- MenuEd.c
 */
struct ExtNewMenu *MakeDummy( void );
struct ExtNewMenu *GetExtMenu( UBYTE *name, long type );
void FreeMenuList( struct ExtMenuList *list, long all );
void FreeMenu( struct ExtNewMenu *menu );
void FreeNewMenus( void );
void TestMenus( void );
long MenuEdit( void );
/*
 * --- MX.c
 */
long MakeMX( void );
void ChangeMX( struct ExtNewGadget *eng );
long EditMX( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- New.c
 */
void New( void );
long MakePalette( void );
/*
 * --- Palette.c
 */
void ChangePalette( struct ExtNewGadget *eng );
long EditPalette( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- Prefs.c
 */
void SetPreferences( struct Prefs *prf );
void MakePreferences( struct Prefs *prf );
void ReadPreferences( void );
void WritePreferences( void );
long Preferences( void );
/*
 * --- Resources.c
 */
long OpenLibraries( void );
void CloseLibraries( void );
long GetScreenInfo( struct Screen *screen );
void FreeScreenInfo( struct Screen *screen );
/*
 * --- ScreenSelect.c
 */
long GetModes( long monitor );
long CheckModes( struct Screen *scr );
long ScreenSelect( void );
/*
 * --- ScreenSpecial.c
 */
long ScreenSpecial( void );
/*
 * --- Scroller.c
 */
long MakeScroller( void );
void ChangeScroller( struct ExtNewGadget *eng );
long EditScroller( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- SetPalette.c
 */
void SetProp( long reg );
long SetPalette( void );
/*
 * --- Slider.c
 */
long MakeSlider( void );
void ChangeSlider( struct ExtNewGadget *eng );
long EditSlider( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- StrInt.c
 */
long MakeStrInt( void );
void ChangeStrInt( struct ExtNewGadget *eng );
long EditStrInt( WORD x, WORD y, WORD x1, WORD y1, struct Gadget *edit );
/*
 * --- WFlags.c
 */
void SetFlagGadgets( void );
void GetUserFlags( void );
void SetFlags( void );
void SetChanges( void );
void DoExclude( UWORD id );
long EditFlags( void );
/*
 * --- WindowSpecial.c
 */
long WindowSpecial( void );
/*
 * --- WindowText.c
 */
long MakeTextList( void );
struct IntuiText *AddAText( void );
void ChangeText( struct IntuiText *text );
void PlaceText( struct IntuiText *txt );
void DeleteTexts( void );
void RemoveText( struct IntuiText *txt );
struct IntuiText *EditText( struct IntuiText *itxt );
struct IntuiText *SelectText( void );

