/*-- AutoRev header do NOT edit!
*
*   Program		 :   GenC.c
*   Copyright	   :   © Copyright 1991 Jaba Development
*   Author		  :   Jan van den Baard
*   Creation Date   :   20-Oct-91
*   Current version :   1.00
*   Translator	  :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date		  Version		 Comment
*   ---------	 -------		 ------------------------------------------
*   20-Oct-91	 1.00			C Source Generator.
*
*-- REV_END --*/

#include	"defs.h"

extern UBYTE			MainFontName[ 80 ];
extern struct TextAttr		MainFont;
extern struct Screen		*MainScreen;
extern struct Window		*MainWindow;
extern UBYTE			MainFileName[ 512 ];
extern UWORD			MainDriPen[ NUMDRIPENS + 1 ];
extern struct ColorSpec		MainColors[ 33 ];
extern UBYTE			MainScreenTitle[ 80 ];
extern UBYTE			MainWindowTitle[ 80 ];
extern struct TagItem		nwTags[];
extern struct TagItem		MainSTags[];
extern struct ExtGadgetList	Gadgets;
extern UWORD			ActiveKind;
extern struct Prefs		MainPrefs;
extern BOOL			Saved;
extern struct NewMenu		Menus[];
extern struct IntuiText		*WindowTxt;
extern WORD			ws_InnerW, ws_InnerH;
extern BOOL			ws_ZoomF, ws_MQueue;
extern BOOL			ws_RQueue, ws_Adjust, cs_AutoScroll;
extern WORD			ws_IWidth, ws_IHeight, ws_ZLeft, ws_ZTop;
extern WORD			ws_ZWidth, ws_ZHeight, ws_MQue, ws_RQue;
extern UWORD			cs_ScreenType;
extern ULONG			WindowFlags, WindowIDCMP;
extern struct ExtMenuList	ExtMenus;

struct FileRequester		*gc_GenC = 0l;

UBYTE				gc_CPatt[32]  = "#?.c";
UBYTE				gc_CFile[32]  = "unnamed.c";
UBYTE				gc_CPath[256];
UWORD				gc_TagOffset, gc_GadOffset, gc_HeightOffset, gc_ScreenOffset;

struct TagItem	gc_CTags[] = {
	ASL_Hail,	(ULONG)"Save C Source As...",
	ASL_Window,	0l,
	ASL_File,	(ULONG)gc_CFile,
	ASL_Dir,	(ULONG)gc_CPath,
	ASL_Pattern,	(ULONG)gc_CPatt,
	ASL_OKText,	(ULONG)"Save",
	ASL_FuncFlags,	FILF_SAVE | FILF_PATGAD,
	TAG_DONE };

UBYTE	*gc_Kinds[] = {
	"GENERIC_KIND", "BUTTON_KIND", "CHECKBOX_KIND",
	"INTEGER_KIND", "LISTVIEW_KIND", "MX_KIND", "NUMBER_KIND",
	"CYCLE_KIND", "PALETTE_KIND", "SCROLLER_KIND", "RESERVED",
	"SLIDER_KIND", "STRING_KIND", "TEXT_KIND" };

UBYTE	*gc_Types[] = {
	"NM_END", "NM_TITLE", "NM_ITEM", "NM_SUB" };

#define STAT	( MainPrefs.pr_PrefFlags0 & PRF_STATIC ) == PRF_STATIC

/*
 * --- Write placement flags.
 */
void WritePlaceFlags( FILE *file, long flags, long mode )
{
	UBYTE   c;

	if ( mode ) c = '!';
	else		c = '|';

	if ( NOT flags )  {
		fprintf( file, "0,\t\t// NG_Flags\n" );
		return;
	}

	if (( flags & PLACETEXT_LEFT ) == PLACETEXT_LEFT )
		fprintf( file, "PLACETEXT_LEFT%lc", c );
	else if (( flags & PLACETEXT_RIGHT ) == PLACETEXT_RIGHT )
		fprintf( file, "PLACETEXT_RIGHT%lc", c );
	else if (( flags & PLACETEXT_ABOVE ) == PLACETEXT_ABOVE )
		fprintf( file, "PLACETEXT_ABOVE%lc", c );
	else if (( flags & PLACETEXT_BELOW ) == PLACETEXT_BELOW )
		fprintf( file, "PLACETEXT_BELOW%lc", c );
	else if (( flags & PLACETEXT_IN ) == PLACETEXT_IN )
		fprintf( file, "PLACETEXT_IN%lc", c );
	if (( flags & NG_HIGHLABEL ) == NG_HIGHLABEL )
		fprintf( file, "NG_HIGHLABEL%lc", c );

	fseek( file, -1l, SEEK_CUR );
	fprintf( file, ",\t// ng_Flags\n" );
}

/*
 * --- Write DisplayID flags.
 */
void WriteIDFlags( FILE *file, long flags, long mode )
{
	UBYTE   c;

	if ( mode ) c = '!';
	else		c = '|';

	if (( flags & PAL_MONITOR_ID ) == PAL_MONITOR_ID )
		fprintf( file, "PAL_MONITOR_ID%lc", c );
	else if (( flags & NTSC_MONITOR_ID ) == NTSC_MONITOR_ID )
		fprintf( file, "NTSC_MONITOR_ID%lc", c );
	else
		fprintf( file, "DEFAULT_MONITOR_ID%lc", c );

	if (( flags & SUPERLACE_KEY ) == SUPERLACE_KEY )
		fprintf( file, "SUPERLACE_KEY%lc", c );
	else if (( flags & HIRESLACE_KEY ) == HIRESLACE_KEY )
		fprintf( file, "HIRESLACE_KEY%lc", c );
	else if (( flags & LORESLACE_KEY ) == LORESLACE_KEY )
		fprintf( file, "LORESLACE_KEY%lc", c );
	else if (( flags & SUPER_KEY ) == SUPER_KEY )
		fprintf( file, "SUPER_KEY%lc", c );
	else if (( flags & HIRES_KEY ) == HIRES_KEY )
		fprintf( file, "HIRES_KEY%lc", c );
	else
		fprintf( file, "LORES_KEY%lc", c );

	fseek( file, -1l, SEEK_CUR );
	fprintf( file, ",\n" );
}

/*
 * --- Write the IntuiText drawmode flags.
 */
void WriteCDrMd( FILE *file, long drmd, long mode )
{
	if (( drmd & JAM2 ) == JAM2 ) {
		if ( mode ) fprintf( file, "RP_JAM2!" );
		else		fprintf( file, "JAM2|" );
	} else {
		if ( mode ) fprintf( file, "RP_JAM1!" );
		else		fprintf( file, "JAM1|" );
	}

	if (( drmd & COMPLEMENT ) == COMPLEMENT ) {
		if ( mode ) fprintf( file, "RP_COMPLEMENT!" );
		else		fprintf( file, "COMPLEMENT|" );
	}

	if (( drmd & INVERSVID ) == INVERSVID ) {
		if ( mode ) fprintf( file, "RP_INVERSVID!" );
		else		fprintf( file, "INVERSVID|" );
	}

	fseek( file, -1l, SEEK_CUR );
	fprintf( file, "," );
}

/*
 * --- Write IDCMP flags.
 */
void WriteIDCMPFlags( FILE *file, long idcmp, long mode )
{
	UBYTE   c;

	if ( mode ) c = '!';
	else		c = '|';

	if ( NOT idcmp ) {
		fprintf( file, "NULL,\n" );
		return;
	}

	if (( idcmp & IDCMP_SIZEVERIFY ) == IDCMP_SIZEVERIFY )
		fprintf( file, "IDCMP_SIZEVERIFY%lc", c );
	if (( idcmp & IDCMP_NEWSIZE ) == IDCMP_NEWSIZE )
		fprintf( file, "IDCMP_NEWSIZE%lc", c );
	if (( idcmp & IDCMP_REFRESHWINDOW ) == IDCMP_REFRESHWINDOW )
		fprintf( file, "IDCMP_REFRESHWINDOW%lc", c );
	if (( idcmp & IDCMP_MOUSEBUTTONS ) == IDCMP_MOUSEBUTTONS )
		fprintf( file, "IDCMP_MOUSEBUTTONS%lc", c );
	if (( idcmp & IDCMP_MOUSEMOVE ) == IDCMP_MOUSEMOVE )
		fprintf( file, "IDCMP_MOUSEMOVE%lc", c );
	if (( idcmp & IDCMP_GADGETDOWN ) == IDCMP_GADGETDOWN )
		fprintf( file, "IDCMP_GADGETDOWN%lc", c );
	if (( idcmp & IDCMP_GADGETUP ) == IDCMP_GADGETUP )
		fprintf( file, "IDCMP_GADGETUP%lc", c );
	if (( idcmp & IDCMP_REQSET ) == IDCMP_REQSET )
		fprintf( file, "IDCMP_REQSET%lc", c );
	if (( idcmp & IDCMP_MENUPICK ) == IDCMP_MENUPICK )
		fprintf( file, "IDCMP_MENUPICK%lc", c );
	if (( idcmp & IDCMP_CLOSEWINDOW ) == IDCMP_CLOSEWINDOW )
		fprintf( file, "IDCMP_CLOSEWINDOW%lc", c );
	if (( idcmp & IDCMP_RAWKEY ) == IDCMP_RAWKEY )
		fprintf( file, "IDCMP_RAWKEY%lc", c );
	if (( idcmp & IDCMP_REQVERIFY ) == IDCMP_REQVERIFY )
		fprintf( file, "IDCMP_REQVERIFY%lc", c );
	if (( idcmp & IDCMP_REQCLEAR ) == IDCMP_REQCLEAR )
		fprintf( file, "IDCMP_REQCLEAR%lc", c );
	if (( idcmp & IDCMP_MENUVERIFY ) == IDCMP_MENUVERIFY )
		fprintf( file, "IDCMP_MENUVERIFY%lc\n", c );
	if (( idcmp & IDCMP_NEWPREFS ) == IDCMP_NEWPREFS )
		fprintf( file, "IDCMP_NEWPREFS%lc", c );
	if (( idcmp & IDCMP_DISKINSERTED ) == IDCMP_DISKINSERTED )
		fprintf( file, "IDCMP_DISKINSERTED%lc", c );
	if (( idcmp & IDCMP_DISKREMOVED ) == IDCMP_DISKREMOVED )
		fprintf( file, "IDCMP_DISKREMOVED%lc", c );
	if (( idcmp & IDCMP_ACTIVEWINDOW ) == IDCMP_ACTIVEWINDOW )
		fprintf( file, "IDCMP_ACTIVEWINDOW%lc", c );
	if (( idcmp & IDCMP_INACTIVEWINDOW ) == IDCMP_INACTIVEWINDOW )
		fprintf( file, "IDCMP_INACTIVEWINDOW%lc", c );
	if (( idcmp & IDCMP_DELTAMOVE ) == IDCMP_DELTAMOVE )
		fprintf( file, "IDCMP_DELTAMOVE%lc", c );
	if (( idcmp & IDCMP_VANILLAKEY ) == IDCMP_VANILLAKEY )
		fprintf( file, "IDCMP_VANILLAKEY%lc", c );
	if (( idcmp & IDCMP_INTUITICKS ) == IDCMP_INTUITICKS )
		fprintf( file, "IDCMP_INTUITICKS%lc", c );
	if (( idcmp & IDCMP_IDCMPUPDATE ) == IDCMP_IDCMPUPDATE )
		fprintf( file, "IDCMP_IDCMPUPDATE%lc", c );
	if (( idcmp & IDCMP_MENUHELP ) == IDCMP_MENUHELP )
		fprintf( file, "IDCMP_MENUHELP%lc", c );
	if (( idcmp & IDCMP_CHANGEWINDOW ) == IDCMP_CHANGEWINDOW )
		fprintf( file, "IDCMP_CHANGEWINDOW%lc", c );
	fprintf( file, "IDCMP_REFRESHWINDOW%lc", c );
	fseek( file, -1l, SEEK_CUR );
	fprintf( file, ",\n" );
}

/*
 * --- Write window flags.
 */
void WriteWindowFlags( FILE *file, long flags, long mode )
{
	UBYTE   c;

	if ( mode ) c = '!';
	else		c = '|';

	if (( flags & WFLG_SIZEGADGET ) == WFLG_SIZEGADGET )
		fprintf( file, "WFLG_SIZEGADGET%lc", c );
	if (( flags & WFLG_DRAGBAR ) == WFLG_DRAGBAR )
		fprintf( file, "WFLG_DRAGBAR%lc", c );
	if (( flags & WFLG_DEPTHGADGET ) == WFLG_DEPTHGADGET )
		fprintf( file, "WFLG_DEPTHGADGET%lc", c );
	if (( flags & WFLG_CLOSEGADGET ) == WFLG_CLOSEGADGET )
		fprintf( file, "WFLG_CLOSEGADGET%lc", c );
	if (( flags & WFLG_SIZEBRIGHT ) == WFLG_SIZEBRIGHT )
		fprintf( file, "WFLG_SIZEBRIGHT%lc", c );
	if (( flags & WFLG_SIZEBBOTTOM ) == WFLG_SIZEBBOTTOM )
		fprintf( file, "WFLG_SIZEBBOTTOM%lc", c );
	if (( flags & WFLG_SMART_REFRESH ) == WFLG_SMART_REFRESH )
		fprintf( file, "WFLG_SMART_REFRESH%lc", c );
	if (( flags & WFLG_SIMPLE_REFRESH ) == WFLG_SIMPLE_REFRESH )
		fprintf( file, "WFLG_SIMPLE_REFRESH%lc", c );
	if (( flags & WFLG_SUPER_BITMAP ) == WFLG_SUPER_BITMAP )
		fprintf( file, "WFLG_SUPER_BITMAP%lc", c );
	if (( flags & WFLG_OTHER_REFRESH ) == WFLG_OTHER_REFRESH )
		fprintf( file, "WFLG_OTHER_REFRESH%lc", c );
	if (( flags & WFLG_BACKDROP ) == WFLG_BACKDROP )
		fprintf( file, "WFLG_BACKDROP%lc", c );
	if (( flags & WFLG_REPORTMOUSE ) == WFLG_REPORTMOUSE )
		fprintf( file, "WFLG_REPORTMOUSE%lc", c );
	if (( flags & WFLG_GIMMEZEROZERO ) == WFLG_GIMMEZEROZERO )
		fprintf( file, "WFLG_GIMMEZEROZERO%lc", c );
	if (( flags & WFLG_BORDERLESS ) == WFLG_BORDERLESS )
		fprintf( file, "WFLG_BORDERLESS%lc", c );
	if (( flags & WFLG_ACTIVATE ) == WFLG_ACTIVATE )
		fprintf( file, "WFLG_ACTIVATE%lc", c );
	if (( flags & WFLG_RMBTRAP ) == WFLG_RMBTRAP )
		fprintf( file, "WFLG_RMBTRAP%lc", c );

	fseek( file, -1l, SEEK_CUR );
	fprintf( file, ",\n" );
}

/*
 * --- Write a single NewMenu structure.
 */
void WriteCNewMenu( FILE *file, struct ExtNewMenu *menu )
{
	ULONG flags;

	fprintf( file, "\t%s, ", gc_Types[ menu->em_NewMenu.nm_Type ] );
	if ( menu->em_NewMenu.nm_Label != NM_BARLABEL )
		fprintf( file, "\"%s\", ", menu->em_NodeName );
	else {
		fprintf( file, "NM_BARLABEL, 0l, 0, 0l, 0l,\n" );
		return;
	}
	if ( menu->em_NewMenu.nm_CommKey )
		fprintf( file, "\"%s\", ", &menu->em_ShortCut[0] );
	else
		fprintf( file, "0l, " );
	if ( flags = menu->em_NewMenu.nm_Flags ) {
		if ( menu->em_NewMenu.nm_Type == NM_TITLE ) {
			if (( flags & NM_MENUDISABLED ) == NM_MENUDISABLED )
				fprintf( file, "NM_MENUDISABLED|" );
		}  else {
			if (( flags & NM_ITEMDISABLED ) == NM_ITEMDISABLED )
				fprintf( file, "NM_ITEMDISABLED|" );
		}
		if (( flags & CHECKIT ) == CHECKIT )
			fprintf( file, "CHECKIT|" );
		if (( flags & CHECKED ) == CHECKED )
			fprintf( file, "CHECKED|" );
		if (( flags & MENUTOGGLE ) == MENUTOGGLE )
			fprintf( file, "MENUTOGGLE|" );

		fseek( file, -1l, SEEK_CUR );
		fprintf( file, ", " );
	} else
		fprintf( file, "0, " );
	fprintf( file, "%ld, 0l,\n", menu->em_NewMenu.nm_MutualExclude );
}

/*
 * --- Write the NewMenu structures.
 */
void WriteCMenus( FILE *file )
{
	struct ExtNewMenu   *menu, *item, *sub;

	if ( NOT ExtMenus.ml_First->em_Next )
		return;

	if ( STAT ) fprintf( file, "static " );

	fprintf( file, "struct NewMenu %sNewMenu[] = {\n", &MainPrefs.pr_ProjectPrefix[0] );

	for ( menu = ExtMenus.ml_First; menu->em_Next; menu = menu->em_Next ) {
		WriteCNewMenu( file, menu );
		if ( menu->em_Items ) {
			for ( item = menu->em_Items->ml_First;  item->em_Next; item = item->em_Next ) {
				WriteCNewMenu( file, item );
				if ( item->em_Items ) {
					for ( sub = item->em_Items->ml_First;  sub->em_Next; sub = sub->em_Next )
						WriteCNewMenu( file, sub );
				}
			}
		}
	}
	fprintf( file, "\tNM_END, 0l, 0l, 0, 0l, 0l };\n\n" );
}

/*
 * --- Write the GadgetID defines.
 */
void WriteCID( FILE *file )
{
	struct ExtNewGadget *eng;

	Renumber();


	fprintf( file, "static enum GD_GADGET_IDS {\n");
	for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next )
		fprintf( file, "\tGD_%s,\t\t// %ld\n", &eng->en_SourceLabel[0], eng->en_NewGadget.ng_GadgetID );
	fprintf( file, "\tMAXGADGET,\n};\n\n");
}

/*
 * --- Write the necessary globals.
 */
void WriteCGlob( FILE *file )
{
	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct Window\t*%sWindow = 0l;\n", &MainPrefs.pr_ProjectPrefix[0] );
	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct Screen\t*%sScreen = 0l;\n", &MainPrefs.pr_ProjectPrefix[0] );
	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "APTR\t\t%sVisualInfo = 0l;\n", &MainPrefs.pr_ProjectPrefix[0] );
	if ( Gadgets.gl_First->en_Next ) {
		if ( STAT ) fprintf( file, "static " );
		fprintf( file, "struct Gadget\t*%sGList = 0l;\n", &MainPrefs.pr_ProjectPrefix[0] );
		if ( STAT ) fprintf( file, "       " );
		fprintf( file, "struct Gadget\t*%sGadgets[MAXGADGET];\n", &MainPrefs.pr_ProjectPrefix[0]);
	}
	if ( ExtMenus.ml_First->em_Next ) {
		if ( STAT ) fprintf( file, "static " );
		fprintf( file, "struct Menu\t*%sMenus = 0l;\n", &MainPrefs.pr_ProjectPrefix[0] );
	}
	if ( ws_ZoomF ) {
		if ( STAT ) fprintf( file, "static " );
		fprintf( file, "UWORD\t%sZoom[4] = { %ld, %ld, %ld, %ld };\n", &MainPrefs.pr_ProjectPrefix[0], ws_ZLeft, ws_ZTop, ws_ZWidth, ws_ZHeight );
	}
	fprintf( file, "\n" );
}

/*
 * --- Write the Cycle and Mx lables.
 */
void WriteCLabels( FILE *file )
{
	struct ExtNewGadget	*eng;
	UWORD			i;

	for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
		if ( eng->en_Kind == CYCLE_KIND || eng->en_Kind == MX_KIND ) {
			if ( STAT ) fprintf( file, "static " );
			fprintf( file, "UBYTE\t\t*%sLabels[] = {\n", &eng->en_SourceLabel[0] );
			for ( i = 0; i < 24; i++ ) {
				if ( eng->en_Labels[ i ] )
					fprintf( file, "\t\"%s\",\n", eng->en_Labels[ i ] );
			}
			fprintf( file, "\tNULL };\n\n" );
		}
	}
}

/*
 * --- Write a single ListView Node.
 */
void WriteCNode( FILE *file, struct ExtNewGadget *eng, struct ListViewNode *node, WORD num )
{
	if ( node->ln_Succ != ( struct ListViewNode * )&eng->en_Entries.lh_Tail )
		fprintf( file, "\t&%sNodes[%ld], ", &eng->en_SourceLabel[0], num + 1 );
	else
		fprintf( file, "\t( struct Node * )&%sList.mlh_Tail, ", &eng->en_SourceLabel[0] );

	if ( node->ln_Pred == ( struct ListViewNode * )&eng->en_Entries )
		fprintf( file, "( struct Node * )&%sList.mlh_Head, ", &eng->en_SourceLabel[0] );
	else
		fprintf( file, "&%sNodes[%ld], ", &eng->en_SourceLabel[0], num - 1 );

	fprintf( file, "0, 0, \"%s\",\n", &node->ln_NameBytes[0] );
}

/*
 * --- Write the ListView entries.
 */
void WriteCList( FILE *file )
{
	struct ExtNewGadget *eng;
	struct ListViewNode *node, *action;
	WORD				 nodenum;

	for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
		if ( eng->en_Kind == LISTVIEW_KIND ) {

			action = ( struct ListViewNode * )RemHead( &eng->en_Entries );

			if ( eng->en_Entries.lh_Head->ln_Succ ) {
				fprintf( file, "extern struct MinList %sList;\n\n", &eng->en_SourceLabel[0] );
				if ( STAT ) fprintf( file, "static " );
				fprintf( file, "struct Node	%sNodes[] = {\n", &eng->en_SourceLabel[0] );
				for ( node = eng->en_Entries.lh_Head, nodenum = 0; node->ln_Succ; node = node->ln_Succ, nodenum++ )
					WriteCNode( file, eng, node, nodenum );
				fseek( file, -2, SEEK_CUR );
				fprintf( file, " };\n\n" );
				fprintf( file, "struct MinList %sList = {\n", &eng->en_SourceLabel[0] );
				fprintf( file, "\t&%sNodes[0], ( struct Node * )0l, &%sNodes[%ld] };\n\n", &eng->en_SourceLabel[0], &eng->en_SourceLabel[0], nodenum -1 );
			}
			AddHead( &eng->en_Entries, ( struct Node * )action );
		}
	}
}

/*
 * --- Write the TextAttr structure
 */
void WriteCTextAttr( FILE *file )
{
	UBYTE				fname[32], *ptr;

	strcpy( fname, MainFontName );

	ptr = strchr( fname, '.' );
	*ptr = 0;

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct TextAttr %s%ld = {", fname, MainFont.ta_YSize );
	fprintf( file, "\t( STRPTR )\"%s\", %ld, 0x%02lx, 0x%02lx };\n\n", MainFontName, MainFont.ta_YSize, MainFont.ta_Style, MainFont.ta_Flags );
}

/*
 * --- Write the Window Tags.
 */
void WriteCWTags( FILE *file )
{
	gc_TagOffset = 0;

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct TagItem	%sWindowTags[] = {\n", &MainPrefs.pr_ProjectPrefix[0] );

	if ( MyTagInArray( WA_Left, nwTags ))
	{   fprintf( file, "\tWA_Left,\t%ld,\n", GetTagData( WA_Left, 0l, nwTags )); gc_TagOffset++; }
	if ( MyTagInArray( WA_Top, nwTags ))
	{   fprintf( file, "\tWA_Top,\t\t%ld,\n", GetTagData( WA_Top, 0l, nwTags )); gc_TagOffset++; }
	if ( ws_InnerW )
	{   fprintf( file, "\tWA_InnerWidth,\t%ld,\n", ws_IWidth ); gc_TagOffset++;}
	else
	{   fprintf( file, "\tWA_Width,\t%ld,\n", MainWindow->Width); gc_TagOffset++; }
	if ( ws_InnerH )
	{   fprintf( file, "\tWA_InnerHeight,\t%ld,\n", ws_IHeight ); gc_TagOffset++; }
	else
	{   fprintf( file, "\tWA_Height,\t%ld,\n", MainWindow->Height-MainScreen->BarHeight); gc_HeightOffset = gc_TagOffset; gc_TagOffset++; }
	if ( MyTagInArray( WA_DetailPen, nwTags ))
	{   fprintf( file, "\tWA_DetailPen,\t%ld,\n", GetTagData( WA_DetailPen, 0l, nwTags )); gc_TagOffset++; }
	if ( MyTagInArray( WA_BlockPen, nwTags ))
	{   fprintf( file, "\tWA_BlockPen,\t%ld,\n", GetTagData( WA_BlockPen, 0l, nwTags )); gc_TagOffset++; }
	GetGadgetIDCMP();
	fprintf( file, "\tWA_IDCMP,\tIDCMP_RAWKEY|IDCMP_VANILLAKEY|" );
	WriteIDCMPFlags( file, WindowIDCMP, 0l);
	gc_TagOffset++;
	if ( MyTagInArray( WA_Flags, nwTags ))
	{   fprintf( file, "\tWA_Flags,\t" );
		WriteWindowFlags( file, GetTagData( WA_Flags, 0l, nwTags ), 0l);
		gc_TagOffset++;
	}
	if ( Gadgets.gl_First->en_Next ) {
		fprintf( file, "\tWA_Gadgets,\tNULL,\n" );
		gc_GadOffset = gc_TagOffset;
		gc_TagOffset++;
	}
	if ( strlen( MainWindowTitle ))
	{   fprintf( file, "\tWA_Title,\t(ULONG)\"%s\",\n", MainWindowTitle ); gc_TagOffset++; }
	if ( strlen( MainScreenTitle ))
	{   fprintf( file, "\tWA_ScreenTitle,\t(ULONG)\"%s\",\n", MainScreenTitle ); gc_TagOffset++; }
	if ( cs_ScreenType ) {
		if ( cs_ScreenType == 2 )
			fprintf( file, "\tWA_CustomScreen,\tNULL,\n" );
		if ( cs_ScreenType == 1 )
			fprintf( file, "\tWA_PubScreen,\tNULL,\n" );
		gc_ScreenOffset = gc_TagOffset;
	}
	if ( MyTagInArray( WA_MinWidth, nwTags ))
		fprintf( file, "\tWA_MinWidth,\t%ld,\n", GetTagData( WA_MinWidth, 0l, nwTags ));
	if ( MyTagInArray( WA_MinHeight, nwTags ))
		fprintf( file, "\tWA_MinHeight,\t%ld,\n", GetTagData( WA_MinHeight, 0l, nwTags ));
	if ( MyTagInArray( WA_MaxWidth, nwTags ))
		fprintf( file, "\tWA_MaxWidth,\t%ld,\n", GetTagData( WA_MaxWidth, 0l, nwTags ));
	if ( MyTagInArray( WA_MaxHeight, nwTags ))
		fprintf( file, "\tWA_MaxHeight,\t%ld,\n", GetTagData( WA_MaxHeight, 0l, nwTags ));
	if ( ws_ZoomF )
		fprintf( file, "\tWA_Zoom,\t(Tag)%sZoom,\n", &MainPrefs.pr_ProjectPrefix[0] );
	if ( ws_MQueue )
		fprintf( file, "\tWA_MouseQueue,\t%ld,\n", ws_MQue);
	if ( ws_RQueue )
		fprintf( file, "\tWA_RptQueue,\t%ld,\n", ws_RQue );
	if ( ws_Adjust )
		fprintf( file, "\tWA_AutoAdjust,\t1l,\n" );

	fprintf( file, "\tTAG_DONE };\n\n" );
}

/*
 * --- Write the Screen Tags and screen specific data.
 */
void WriteCSTags( FILE *file )
{
	UWORD		   cnt;
	UBYTE		   fname[32], *ptr;

	strcpy( fname, MainFontName );

	ptr = strchr( fname, '.' );
	*ptr = 0;

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct ColorSpec  %sScreenColors[] = {\n", &MainPrefs.pr_ProjectPrefix[0] );

	for ( cnt = 0; cnt < 33; cnt++ ) {
		if ( MainColors[ cnt ].ColorIndex != ~0 )
			fprintf( file, "\t%2ld, 0x%02lx, 0x%02lx, 0x%02lx,\n", MainColors[ cnt ].ColorIndex, MainColors[ cnt ].Red, MainColors[ cnt ].Green, MainColors[ cnt ].Blue );
		else {
			fprintf( file, "\t~0, 0x00, 0x00, 0x00 };\n\n" );
			break;
		}
	}

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "UWORD			 %sDriPens[] = {\n	", &MainPrefs.pr_ProjectPrefix[0] );

	for ( cnt = 0; cnt < NUMDRIPENS + 1; cnt++ ) {
		if ( MainDriPen[ cnt ] != ~0 )
			fprintf( file, "%ld,", MainDriPen[ cnt ] );
		else {
			fprintf( file, "~0 };\n\n" );
			break;
		}
	}

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct TagItem	%sScreenTags[] = {\n", &MainPrefs.pr_ProjectPrefix[0] );

	if ( MyTagInArray( SA_Left, MainSTags ))
		fprintf( file, "\tSA_Left,		  %ld,\n", GetTagData( SA_Left, 0l, MainSTags ));
	if ( MyTagInArray( SA_Top, MainSTags ))
		fprintf( file, "\tSA_Top,		   %ld,\n", GetTagData( SA_Top, 0l, MainSTags ));
	if ( MyTagInArray( SA_Width, MainSTags ))
		fprintf( file, "\tSA_Width,		 %ld,\n", GetTagData( SA_Width, 0l, MainSTags ));
	if ( MyTagInArray( SA_Height, MainSTags ))
		fprintf( file, "\tSA_Height,		%ld,\n", GetTagData( SA_Height, 0l, MainSTags ));
	if ( MyTagInArray( SA_Depth, MainSTags ))
		fprintf( file, "\tSA_Depth,		 %ld,\n", GetTagData( SA_Depth, 0l, MainSTags ));
	if ( MyTagInArray( SA_DetailPen, MainSTags ))
		fprintf( file, "\tSA_DetailPen,	 %ld,\n", GetTagData( SA_DetailPen, 0l, MainSTags ));
	if ( MyTagInArray( SA_BlockPen, MainSTags ))
		fprintf( file, "\tSA_BlockPen,	  %ld,\n", GetTagData( SA_BlockPen, 0l, MainSTags ));
	if ( MyTagInArray( SA_Colors, MainSTags ))
		fprintf( file, "\tSA_Colors,		(ULONG)%sScreenColors,\n", &MainPrefs.pr_ProjectPrefix[0] );
	if ( MyTagInArray( SA_Font, MainSTags ))
		fprintf( file, "\tSA_Font,		  &%s%ld,\n", fname, MainFont.ta_YSize );
	fprintf( file, "\tSA_Type,		  CUSTOMSCREEN,\n" );
	if ( MyTagInArray( SA_DisplayID, MainSTags )) {
		fprintf( file, "\tSA_DisplayID,	 " );
		WriteIDFlags( file, GetTagData( SA_DisplayID, 0l, MainSTags ), 0l);
	}
	if ( cs_AutoScroll )
		fprintf( file, "\tSA_AutoScroll,	1l,\n" );
	if ( MyTagInArray( SA_Pens, MainSTags ))
		fprintf( file, "\tSA_Pens,		  %sDriPens,\n", &MainPrefs.pr_ProjectPrefix[0] );

	fprintf( file, "\tTAG_DONE };\n\n" );
}

/*
 * --- Write the C IntuiText structures.
 */
void WriteCIText( FILE *file )
{
	struct IntuiText   *t;
	UWORD			   i = 1;
	UBYTE			   fname[32], *ptr;

	strcpy( fname, MainFontName );

	ptr = strchr( fname, '.' );
	*ptr = 0;

	if ( NOT( t = WindowTxt )) return;

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct IntuiText  %sIText[] = {\n", &MainPrefs.pr_ProjectPrefix[0] );

	while ( t ) {
		fprintf( file, "\t%ld, %ld, ", t->FrontPen, t->BackPen );
		WriteCDrMd( file, t->DrawMode, 0l );
		fprintf( file, "%ld, %ld, &%s%ld, ", t->LeftEdge, t->TopEdge, fname, MainFont.ta_YSize );
		fprintf( file, "(UBYTE *)\"%s\", ", t->IText );

		if ( t->NextText )
			fprintf( file, "&%sIText[%ld],\n", &MainPrefs.pr_ProjectPrefix[0], i++ );
		else
			fprintf( file, "NULL };\n\n" );
		t = t->NextText;
	}
}

/*
 * --- Write the routine header.
 */
void WriteCHeader( FILE *file )
{
	if ( STAT ) fprintf( file, "static " );

	fprintf( file, "long %sInitStuff( void )\n{\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "\tstruct Gadget\t*g;\n\n" );
}

/*
 * --- Write the C Gadgets initialization.
 */
void WriteCGadgets( FILE *file )
{
	struct ExtNewGadget 	*g, *pred;
	struct NewGadget	*ng, *ngp;
	UBYTE			fname[32], *ptr;
	UWORD			num;

	strcpy( fname, MainFontName );

	ptr  = strchr( fname, '.' );
	*ptr = 0;

	if ( STAT ) fprintf( file, "static " );
	fprintf( file, "struct NewGadget\t%sGadgetArray[MAXGADGET] = {\n", &MainPrefs.pr_ProjectPrefix[0] );

	for ( g = Gadgets.gl_First, num = 0l; g->en_Next; g = g->en_Next, num++ ) {
		fprintf( file, "\t{\n");
		if (( pred = g->en_Prev ) == ( struct ExtNewGadget * )&Gadgets ) {
			pred = 0l;
			ngp  = 0l;
		} else
			ngp = &pred->en_NewGadget;

		ng = &g->en_NewGadget;

#ifdef MYKE_REMOVED_THIS
		if ( ngp ) {
			if ( g->en_Kind != STRING_KIND ) {
				if ( ng->ng_LeftEdge != ngp->ng_LeftEdge )
					fprintf( file, "\t\t%ld,\t\t// ng_LeftEdge1\n", ng->ng_LeftEdge );
				else
					fprintf( file, "\t\t0,\t\t// ng_LeftEdge2\n");
				if ( ng->ng_TopEdge  != ngp->ng_TopEdge )
					fprintf( file, "\t\t%ld,\t\t// ng_TopEdge3\n", ng->ng_TopEdge-MainScreen->BarHeight );
				else
					fprintf( file, "\t\t%ld,\t\t// ng_TopEdge3x\n", ngp->ng_TopEdge-MainScreen->BarHeight );
			} else {
				if (( g->en_SpecialFlags & EGF_ISLOCKED ) != EGF_ISLOCKED ) {
					if ( ng->ng_LeftEdge != ngp->ng_LeftEdge )
						fprintf( file, "\t\t%ld,\t\t// ng_LeftEdge5\n", ng->ng_LeftEdge );
					else
						fprintf( file, "\t\t0,\t\t// ng_LeftEdge6\n");
					if ( ng->ng_TopEdge  != ngp->ng_TopEdge )
						fprintf( file, "\t\t%ld,\t\t// ng_TopEdge7\n", ng->ng_TopEdge-MainScreen->BarHeight );
					else
						fprintf( file, "\t\t%ld,\t\t// ng_TopEdge7x\n", ngp->ng_TopEdge-MainScreen->BarHeight );
				}
				else {
					fprintf( file, "\t\t0,\t\t// ng_LeftEdge9\n");
					fprintf( file, "\t\t0,\t\t// ng_TopEdge10\n");
				}
			}

			if ( g->en_Kind != MX_KIND && g->en_Kind != CHECKBOX_KIND ) {
				if ( ng->ng_Width != ngp->ng_Width )
					fprintf( file, "\t\t%ld,\t\t// ng_Width1\n", ng->ng_Width );
				else
					fprintf( file, "\t\t0,\t\t// ng_Width2\n");
#ifdef MYKE_REMOVED_THIS
				if ( ng->ng_Height != ngp->ng_Height )
#endif
					fprintf( file, "\t\t%ld,\t\t// ng_Height1\n", ng->ng_Height );
			}
			else {
				fprintf( file, "\t\t0,\t\t// ng_Width3\n");
				fprintf( file, "\t\t0,\t\t// ng_Height3\n");
			}
			if ( ng->ng_GadgetText ) {
				if ( strcmp( ng->ng_GadgetText, ngp->ng_GadgetText ) && g->en_Kind != MX_KIND )
					fprintf( file, "\t\t\"%s\",\t// ng_GadgetText\n", ng->ng_GadgetText );
				else
					fprintf( file, "\t\tNULL,\t\t// ng_GadgetText\n");
			} else {
					fprintf( file, "\t\tNULL,\t\t// ng_GadgetText\n" );
			}
			fprintf( file, "\t\t&%s%ld,\t// ng_TextAttr\n", &fname[0], MainFont.ta_YSize );
			fprintf( file, "\t\tGD_%s,\t// ng_GadgetID\n", &g->en_SourceLabel[0] );
#ifdef MYKE_REMOVED_THIS
			if ( ng->ng_Flags != ngp->ng_Flags ) {
#endif
				fprintf( file, "\t\t" );
				WritePlaceFlags( file, (long)ng->ng_Flags, 0l );
#ifdef MYKE_REMOVED_THIS
			}
			else {
				fprintf( file, "\t\t0l,\t\t// ng_Flags\n");
			}
#endif
			fprintf( file, "\t\tNULL,\t\t// ng.ng_VisualInfo=%sVisualInfo\n", &MainPrefs.pr_ProjectPrefix[0] );
		} else {
#endif
			fprintf( file, "\t\t%ld,\t\t// ng_LeftEdge11\n", ng->ng_LeftEdge );
			fprintf( file, "\t\t%ld,\t\t// ng_TopEdge12\n", ng->ng_TopEdge-MainScreen->BarHeight );
			fprintf( file, "\t\t%ld,\t\t// ng_Width4\n", ng->ng_Width );
			fprintf( file, "\t\t%ld,\t\t// ng_Height4\n", ng->ng_Height );
			if ( ng->ng_GadgetText )
				fprintf( file, "\t\t\"%s\",\t// ng_GadgetText\n", ng->ng_GadgetText );
			else
				fprintf( file, "\t\tNULL,\t\t// ng_GadgetText\n" );
			fprintf( file, "\t\t&%s%ld,\t// ng_TextAttr\n", &fname[0], MainFont.ta_YSize );
			fprintf( file, "\t\tGD_%s,\t// ng_GadgetID\n", &g->en_SourceLabel[0] );
			fprintf( file, "\t\t" );
			WritePlaceFlags( file, ng->ng_Flags, 0l );
			fprintf( file, "\t\tNULL,\t\t// ng.ng_VisualInfo=%sVisualInfo\n", &MainPrefs.pr_ProjectPrefix[0] );
#ifdef MYKE_REMOVED_THIS
		}
#endif
		fprintf( file, "\t\tNULL,\t\t// ng_UserData\n");
		fprintf( file, "\t},\n");
	}

	fprintf( file, "};\n\n");

}

void	WriteCGadgetInits( FILE *file ) {
	struct ExtNewGadget 	*g, *pred;
	struct NewGadget	*ng, *ngp;
	UBYTE			fname[32], *ptr;
	UWORD			num;

	strcpy( fname, MainFontName );

	ptr  = strchr( fname, '.' );
	*ptr = 0;

	for ( g = Gadgets.gl_First, num = 0l; g->en_Next; g = g->en_Next, num++ ) {
		if (( pred = g->en_Prev ) == ( struct ExtNewGadget * )&Gadgets ) {
			pred = 0l;
			ngp  = 0l;
		} else
			ngp = &pred->en_NewGadget;

		ng = &g->en_NewGadget;

		fprintf( file, "\t%sGadgetArray[%ld].ng_VisualInfo = %sVisualInfo;\t// set ng.ng_VisualInfo\n", &MainPrefs.pr_ProjectPrefix[0], num, &MainPrefs.pr_ProjectPrefix[0] );
		if ( ws_InnerW ) {
			fprintf( file, "\t%sGadgetArray[%ld].ng_LeftEdge += %sScreen->WBorLeft;\t// adjust ng_LeftEdge13\n", &MainPrefs.pr_ProjectPrefix[0], num, &MainPrefs.pr_ProjectPrefix[0] );
			fprintf( file, "\t%sGadgetArray[%ld].ng_TopEdge += %sScreen->BarHeight;\t// adjust ng_TopEdge14\n", &MainPrefs.pr_ProjectPrefix[0], num, &MainPrefs.pr_ProjectPrefix[0] );
		}
		fprintf( file, "\tg = CreateGadget( %s, g, &%sGadgetArray[%ld],\n", gc_Kinds[ g->en_Kind ], &MainPrefs.pr_ProjectPrefix[0], num );

		switch ( g->en_Kind ) {

			case	BUTTON_KIND:
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	CHECKBOX_KIND:
				if (( g->en_SpecialFlags & EGF_CHECKED ) == EGF_CHECKED )
					fprintf( file, "\t\tGTCB_Checked, TRUE,\n" );
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	CYCLE_KIND:
				fprintf( file, "\t\tGTCY_Labels, %sLabels,\n", &g->en_SourceLabel[0] );
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	INTEGER_KIND:
				fprintf( file, "\t\tGTIN_Number, %ld,\n", g->en_DefInt );
				fprintf( file, "\t\tGTIN_MaxChars, %ld,\n", GetTagData( GTIN_MaxChars, 5l, g->en_Tags ));
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	LISTVIEW_KIND:
				if ( g->en_Entries.lh_Head->ln_Succ->ln_Succ )
					fprintf( file, "\t\tGTLV_Labels, &%sList,\n", &g->en_SourceLabel[0] );
				else
					fprintf( file, "\t\tGTLV_Labels, ~0,\n" );
				if (( g->en_SpecialFlags & EGF_NEEDLOCK ) == EGF_NEEDLOCK )
					fprintf( file, "\t\tGTLV_ShowSelected, %sGadgets[%ld],\n", &MainPrefs.pr_ProjectPrefix[0], num - 1 );
				else if (MyTagInArray( GTLV_ShowSelected, g->en_Tags ))
					fprintf( file, "\t\tGTLV_ShowSelected, 0l,\n" );
				if ( MyTagInArray( GTLV_ScrollWidth, g->en_Tags ))
					fprintf( file, "\t\tGTLV_ScrollWidth, %ld,\n", g->en_ScrollWidth );
				if (( g->en_SpecialFlags & EGF_READONLY ) == EGF_READONLY )
					fprintf( file, "\t\tGTLV_ReadOnly, TRUE,\n" );
				if ( MyTagInArray( LAYOUTA_Spacing, g->en_Tags ))
					fprintf( file, "\t\tLAYOUTA_Spacing, %ld,\n", g->en_Spacing );
				break;

			case	MX_KIND:
				fprintf( file, "\t\tGTMX_Labels, %sLabels,\n", &g->en_SourceLabel[0] );
				if ( MyTagInArray( GTMX_Spacing, g->en_Tags ))
					fprintf( file, "\t\tGTMX_Spacing, %ld,\n", g->en_Spacing );
				break;

			case	PALETTE_KIND:
				fprintf( file, "\t\tGTPA_Depth, %ld,\n", MainScreen->BitMap.Depth );
				if ( MyTagInArray( GTPA_IndicatorWidth, g->en_Tags ))
					fprintf( file, "\t\tGTPA_IndicatorWidth, %ld,\n", GetTagData( GTPA_IndicatorWidth, 0l, g->en_Tags ));
				if ( MyTagInArray( GTPA_IndicatorHeight, g->en_Tags ))
					fprintf( file, "\t\tGTPA_IndicatorHeight, %ld,", GetTagData( GTPA_IndicatorHeight, 0l, g->en_Tags ));
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	SCROLLER_KIND:
				if ( MyTagInArray( GTSC_Top, g->en_Tags ))
					fprintf( file, "\t\tGTSC_Top, %ld,\n", GetTagData( GTSC_Top, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSC_Total, g->en_Tags ))
					fprintf( file, "\t\tGTSC_Total, %ld,\n", GetTagData( GTSC_Total, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSC_Visible, g->en_Tags ))
					fprintf( file, "\t\tGTSC_Visible, %ld,\n", GetTagData( GTSC_Visible, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSC_Arrows, g->en_Tags ))
					fprintf( file, "\t\tGTSC_Arrows, %ld,\n", g->en_ArrowSize );
				if ( MyTagInArray( PGA_Freedom, g->en_Tags ))
					fprintf( file, "\t\tPGA_Freedom, LORIENT_VERT,\n" );
				else
					fprintf( file, "\t\tPGA_Freedom, LORIENT_HORIZ,\n" );
				if ( MyTagInArray( GA_Immediate, g->en_Tags ))
					fprintf( file, "\t\tGA_Immediate, TRUE,\n" );
				if ( MyTagInArray( GA_RelVerify, g->en_Tags ))
					fprintf( file, "\t\tGA_RelVerify, TRUE,\n" );
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	SLIDER_KIND:
				if ( MyTagInArray( GTSL_Min, g->en_Tags ))
					fprintf( file, "\t\tGTSL_Min, %ld,\n", GetTagData( GTSL_Min, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSL_Max, g->en_Tags ))
					fprintf( file, "\t\tGTSL_Max, %ld,\n", GetTagData( GTSL_Max, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSL_Level, g->en_Tags ))
					fprintf( file, "\t\tGTSL_Level, %ld,\n", GetTagData( GTSL_Level, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSL_MaxLevelLen, g->en_Tags ))
					fprintf( file, "\t\tGTSL_MaxLevelLen, %ld,\n", GetTagData( GTSL_MaxLevelLen, 0l, g->en_Tags ));
				if ( MyTagInArray( GTSL_LevelFormat, g->en_Tags ))
					fprintf( file, "\t\tGTSL_LevelFormat, \"%s\",\n", g->en_LevelFormat );
				if ( MyTagInArray( GTSL_LevelPlace, g->en_Tags )) {
					fprintf( file, "\t\tGTSL_LevelPlace, " );
					WritePlaceFlags( file, (long)GetTagData( GTSL_LevelPlace, 0l, g->en_Tags ), 0l );
					fseek( file, -2, SEEK_CUR );
					fprintf( file,"\n" );
				}
				if ( MyTagInArray( PGA_Freedom, g->en_Tags ))
					fprintf( file, "\t\tPGA_Freedom, LORIENT_VERT,\n" );
				else
					fprintf( file, "\t\tPGA_Freedom, LORIENT_HORIZ,\n" );
				if ( MyTagInArray( GA_Immediate, g->en_Tags ))
					fprintf( file, "\t\tGA_Immediate, TRUE,\n" );
				if ( MyTagInArray( GA_RelVerify, g->en_Tags ))
					fprintf( file, "\t\tGA_RelVerify, TRUE,\n" );
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;

			case	STRING_KIND:
				if ( g->en_DefString )
					fprintf( file, "\t\tGTST_String, \"%s\",\n", g->en_DefString );
				fprintf( file, "\t\tGTST_MaxChars, %ld,\n", GetTagData( GTST_MaxChars, 5l, g->en_Tags ));
				if (( g->en_SpecialFlags & EGF_DISABLED ) == EGF_DISABLED )
					fprintf( file, "\t\tGA_Disabled, TRUE,\n" );
				break;
		}
		if ( MyTagInArray( GT_Underscore,  g->en_Tags ))
			fprintf( file, "\t\tGT_Underscore, '_',\n" );

		fprintf( file, "\t\tTAG_DONE\n\t);\n" );
		fprintf( file, "\t%sGadgets[ %ld ] = g;\n", &MainPrefs.pr_ProjectPrefix[0], num );
		fprintf( file, "\tif ( NOT g ) return( 4l );\n\n" );
	}

	if ( Gadgets.gl_First->en_Next ) {
		fprintf( file, "\t%sWindowTags[ %ld ].ti_Data = (ULONG)%sGList;\n", &MainPrefs.pr_ProjectPrefix[0], gc_GadOffset, &MainPrefs.pr_ProjectPrefix[0] );
		fprintf( file, "\t%sWindowTags[ %ld ].ti_Data += (ULONG)%sScreen->BarHeight;\n\n", &MainPrefs.pr_ProjectPrefix[0], gc_HeightOffset, &MainPrefs.pr_ProjectPrefix[0] );
	}
}


/*
 * --- Write the C cleanup routine.
 */
void WriteCCleanup( FILE *file )
{
	fprintf( file, "void %sCleanStuff( void )\n{\n", &MainPrefs.pr_ProjectPrefix[0] );
	if ( ExtMenus.ml_First->em_Next )
		fprintf( file, "\tif ( %sMenus ) { ClearMenuStrip( %sWindow ); FreeMenus( %sMenus );	}\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "\tif ( %sWindow ) CloseWindow( %sWindow );\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	if ( Gadgets.gl_First->en_Next )
		fprintf( file, "\tif ( %sGList ) FreeGadgets( %sGList );\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "\tif ( %sVisualInfo ) FreeVisualInfo( %sVisualInfo );\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	if ( cs_ScreenType == 2 )
		fprintf( file, "\tif ( %sScreen ) CloseScreen( %sScreen );\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	else
		fprintf( file, "\tif ( %sScreen )UnlockPubScreen( 0l, %sScreen );\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "}\n\n" );

}

void	WriteCMain( FILE *file ) {
	fprintf( file, "void\t%s(void) {\n", &MainPrefs.pr_ProjectPrefix[0]);
	fprintf( file, "\tlong\tret = %sInitStuff();\n\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "\tif (ret) {\n");
	fprintf( file, "\t\tprintf(\"%sInitStuff() failed (%%d)\\n\", ret);\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "\t\tAbort();\n");
	fprintf( file, "\t}\n\n");
	fprintf( file, "%s\n", "\twhile (1) {");
	fprintf( file, "\t\tWaitPort(%sWindow->UserPort);\n", &MainPrefs.pr_ProjectPrefix[0]);
	fprintf( file, "\t\tEventHandler(%sWindow, %sGadgetHandler, NULL, NULL);\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "%s\n", "\t}");
	fprintf( file, "%s\n", "}");
}

void	WriteStartupStuff(FILE *file) {
	fprintf( file, "/*\n *  Source generated with GadToolsBox V2.0\n" );
	fprintf( file, " *  which is (c) Copyright 1991 Jaba Development\n" );
	fprintf( file, " *  and is heavily modified by Mike Schwartz\n");
	fprintf( file, " */\n\n" );
}

static char	*defsh[] = {
	"#include <exec/types.h>",
	"#include <intuition/intuition.h>",
	"#include <intuition/intuitionbase.h>",
	"#include <intuition/gadgetclass.h>",
	"#include <libraries/gadtools.h>",
	"#include <graphics/displayinfo.h>",
	"#include <dos/dos.h>",
	"#include <dos/dosextens.h>",
	"#include <clib/exec_protos.h>",
	"#include <clib/intuition_protos.h>",
	"#include <clib/gadtools_protos.h>",
	"#include <stdio.h>",
	"#include <fcntl.h>",
	"",
	"#define	O_READ	(O_RDONLY)",
	"#define	O_WRITE	(O_WRONLY|O_CREAT|O_TRUNC)",
	"",
	"typedef struct Library		LIBRARY;",
	"typedef struct TagItem		TAGS;",
	"typedef struct List		LIST;",
	"typedef struct Node		NODE;",
	"typedef struct VisualInfo	VINFO;",
	"typedef struct Gadget		GADGET;",
	"typedef struct NewGadget	NEWGAD;",
	"typedef struct Screen		SCREEN;",
	"typedef struct Window		WINDOW;",
	"typedef struct ViewPort		VPORT;",
	"typedef struct RastPort		RPORT;",
	"typedef struct IntuiMessage	IMSG;",
	"typedef struct TextAttr		TATTR;",
	"typedef struct StringInfo	STRINGINFO;",
	"typedef struct Rectangle	RECT;",
	"typedef struct TextFont		FONT;",
	"typedef struct FileInfoBlock	FIB;",
	"#define LOCK			BPTR",
	"typedef struct Process		PROCESS;",
	"typedef struct FontRequester	FONTREQ;",
	"typedef struct FileRequester	FILEREQ;",
	"typedef struct MsgPort		MPORT;",
	"typedef struct IntuitionBase	IBASE;",
	"",
	"#define	LE_OK		0",
	"#define	LE_NO_MEMORY	1",
	"#define	LE_END_OF_LIST	2",
	"#define	LE_EMPTY_LIST	3",
	"",
	"#define	NODE_STATIC	(1<<0)",
	"#define	NODE_ALLOCATED	(1<<1)",
	"",
	"BOOL	EmptyList(LIST *list);",
	"void	FreeListNodes(LIST *list);",
	"NODE	*ListNodeNumber(LIST *list, ULONG n);",
	"",
	"// func is a comparison function.  It returns >0 if NODE2 > NODE1.",
	"// if flag == TRUE, then sort ascending, else decending",
	"void	SortList(LIST *list, int (*func)(), BOOL flag);",
	"",
	"// flag = TRUE to allocate string, FALSE to set ln_Name to static string (char *s)",
	"BOOL	AddStringToListTail(char *s, LIST *list, BOOL flag);",
	"",
	"//",
	"// Expands tabs in a buffer into spaces.",
	"//",
	"void	TabsToSpaces(char *buf);",
	"",
	"ULONG	AppendListToList(LIST *dst, LIST *src);",
	"LIST	*CloneList(LIST *src);",
	"",
	"//",
	"// Appends a file to a LIST structure.  Returns # of lines read in.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to TabsToSpaces().",
	"//",
	"ULONG	AppendFileToList(FILE *fp, struct List *list, void (*LineEnhancer)());",
	"",
	"//",
	"// Reads a file into a LIST structure.  Returns # of lines read in.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to TabsToSpaces().",
	"//",
	"ULONG	ReadListFromFile(LIST *list, char *filename, void (*LineEnhancer)());",
	"",
	"//",
	"// Appends to a file from a LIST structure.  Returns # of lines written.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to SpacesToTabs().",
	"//",
	"ULONG	AppendListToFile(LIST *list, FILE *fp, void (*LineEnhancer)());",
	"",
	"//",
	"// Reads a file into a LIST structure.  Returns # of lines read in.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to TabsToSpaces().",
	"//",
	"ULONG	WriteListToFile(LIST *list, char *filename, APTR LineEnhancer);",
	"",
	"// this routine should take a pattern as input.  It should use MatchFirst/MatchNext.",
	"ULONG	ReadListFromDirectory(LIST *list, char *dirname, short type, void (*EnhanceFIB)());",
	NULL,
};

void	WriteDefsH() {
	long	i;
	FILE	*fp;
	BPTR	lock;

	lock = Lock("defs.h", SHARED_LOCK);
	if (lock) { UnLock(lock); return; }
	fp = fopen("defs.h", "w");
	if (!fp) return;
	WriteStartupStuff(fp);
	for (i=0; defsh[i]; i++) fprintf(fp, "%s\n", defsh[i]);
	fclose(fp);
}

void	WriteMakefile(void) {
	long	i;
	FILE	*fp;
	BPTR	lock;

	lock = Lock("makefile", SHARED_LOCK);
	if (lock) { UnLock(lock); return; }
	fp = fopen("makefile", "w");
	if (!fp) return;

	fprintf(fp, "OBJ=	main.o lists.o %sStubs.o\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf(fp, "\n");
	fprintf(fp, ".c.o:\n");
	fprintf(fp, "	lc $*.c\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf(fp, "\n");
	fprintf(fp, "all:	%s\n", &MainPrefs.pr_ProjectPrefix[0] , &MainPrefs.pr_ProjectPrefix[0] );
	fprintf(fp, "\n");
	fprintf(fp, "%s:	$(OBJ)\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf(fp, "	blink FROM lib:c.o+$(OBJ) TO %s LIBRARY lib:lc.lib+lib:amiga.lib\n", &MainPrefs.pr_ProjectPrefix[0] );
	fprintf(fp, "\n");
	fclose(fp);
}

void	WriteDMakefile(void) {
	long	i;
	FILE	*fp;
	BPTR	lock;

	lock = Lock("DMakefile", SHARED_LOCK);
	if (lock) { UnLock(lock); return; }
	fp = fopen("DMakefile", "w");
	if (!fp) return;
	fprintf(fp, "%s\n", "all:");
	fprintf(fp, "	dcc -s -O \"\" -new main.c lists.c %sStubs.c -o %s\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0]);
	fclose(fp);
}

static char	*mainc[] = {
	"#include	\"defs.h\"",
	"",
	"long\tabortCode = 0;",
	"void\tAbort(void);",
	"typedef struct {",
	"	char	*name;",
	"	APTR	*base;",
	"} LIBDEFS;",
	"",
	"/*",
	" * List of libraries used",
	" */",
	"IBASE	*IntuitionBase = 0;",
	"LIBRARY	*GfxBase = 0;",
	"LIBRARY	*DiskfontBase = 0;",
	"LIBRARY	*AslBase = 0;",
	"LIBRARY	*GadToolsBase = 0;",
	"LIBRARY	*WorkbenchBase = 0;",
	"LIBRARY	*IconBase = 0;",
	"LIBRARY	*CxBase = 0;",
	"",
	"/*",
	" * Array of library names/base pointers.  To open an additional library, define",
	" * the base above and add a line here.",
	" */",
	"LIBDEFS	libDefs[] = {",
	"	\"intuition.library\",(APTR *)&IntuitionBase,",
	"	\"graphics.library\",(APTR *)&GfxBase,",
	"	\"diskfont.library\",(APTR *)&DiskfontBase,",
	"	\"asl.library\",(APTR *)&AslBase,",
	"	\"gadtools.library\",(APTR *)&GadToolsBase,",
	"	\"workbench.library\", (APTR *)&WorkbenchBase,",
	"	\"icon.library\", (APTR *)&IconBase,",
	"	\"commodities.library\", (APTR *)&CxBase,",
	"	0,0",
	"};",
	"",
	"/************************************************************************/",
	"",
	"/*",
	" * These might be the shortest open/close library routines ever :)",
	" */",
	"void	CloseLibs( void ) {",
	"	short	i;",
	"",
	"	for (i=0; libDefs[i+1].name; i++);",
	"	while (i >= 0) {",
	"		if (*libDefs[i].base) CloseLibrary((LIBRARY *)*libDefs[i].base);",
	"		*libDefs[i--].base = 0;",
	"	}",
	"}",
	"",
	"BOOL	OpenLibs( void ) {",
	"	short	i;",
	"",
	"	for (i=0; libDefs[i].name; i++) {",
	"		*libDefs[i].base = (APTR)OpenLibrary(libDefs[i].name, 0);",
	"		if (!(*libDefs[i].base)) return FALSE;",
	"	}",
	"	return TRUE;",
	"}",
	"",
	"",
	"/************************************************************************/",
	"",
	"void			DefaultIDCMPFunc(window, m)",
	"struct Window		*window;",
	"struct IntuiMessage	*m;",
	"{",
	"	switch (m->Class) {",
	"		case IDCMP_RAWKEY:",
	"			if (m->Code & 0x80) break;",
	"			printf(\"RAWKEY Class = %x Code = %x\\n\", m->Class, m->Code);",
	"			break;",
	"",
	"		case IDCMP_VANILLAKEY:",
	"			if (m->Code == 0x1b) Abort();	// Escape Key",
	"			printf(\"VANILLAKEY Class = %x Code = %x\\n\", m->Class, m->Code);",
	"			break;",
	"",
	"		case IDCMP_MOUSEBUTTONS:",
	"			if (m->Code == MENUUP || m->Code == SELECTUP) break;",
	"			printf(\"MouseButtons Code = %x, x,y = %d,%d\\n\", m->Code, m->MouseX, m->MouseY);",
	"			break;",
	"		case IDCMP_CLOSEWINDOW:",
	"			Abort();",
	"			break;",
	"",
	"		default:",
	"			printf(\"Class = %x Code = %x\\n\", m->Class, m->Code);",
	"			break;",
	"	}",
	"}",
	"",
	"/*",
	" * void	GadgetUp(m);",
	" * struct IntuiMessage	*m;		ptr to IntuiMessage received",
	" *",
	" * Synopsis:",
	" *	Handles Gadtools/Intuition GADGETUP events.  For 2.0 and GadTools, the TAB and HELP",
	" *	keys are special.  This routine handles these events, also.",
	" *",
	" * NOTES:",
	" *	STRINGA_ExitHelp is not defined in any of the headers I got with SAS 5.10a, so the",
	" *	HELP feature doesn't work.",
	" */",
	"static void	GadgetUp(void (*func)(), struct IntuiMessage *m) {",
	"	struct Gadget	*gad = (struct Gadget *)m->IAddress;",
	"",
	"	(*func)(gad->GadgetID, m->Code);",
	"}",
	"",
	"/*",
	" * void	GadgetDown(m);",
	" * struct IntuiMessage	*m;		ptr to IntuiMessage received",
	" *",
	" * Synopsis:",
	" *	Handles Gadtools/Intuition GADGETDOWN events.",
	" */",
	"static void	GadgetDown(void (*func)(), struct IntuiMessage *m) {",
	"	struct Gadget	*gad = (struct Gadget *)m->IAddress;",
	"",
	"	(*func)(gad->GadgetID, m->Code);",
	"}",
	"",
	"/*",
	" * void	MouseMove(m);",
	" * struct IntuiMessage	*m;		ptr to IntuiMessage received",
	" *",
	" * Synopsis:",
	" *	Handles Gadtools/Intuition MOUSEMOVE events.",
	" */",
	"static void	MouseMove(void (*func)(), struct IntuiMessage *m) {",
	"	struct Gadget	*gad = (struct Gadget *)m->IAddress;",
	"",
	"	(*func)(gad->GadgetID, m->Code);",
	"}",
	"",
	"static void	DefaultHandleFunc(UWORD id, UWORD code) {",
	"	printf(\"GadgetID:%d (code=%d)\\n\", id, code);",
	"}",
	"",
	"void		EventHandler(window, handleFunc, idcmpFunc, refreshFunc) ",
	"struct Window	*window;",
	"void		(*handleFunc)();",
	"void		(*idcmpFunc)();",
	"void		(*refreshFunc)();",
	"{",
	"	struct IntuiMessage 	*m, msg;",
	"",
	"	while (m = GT_GetIMsg(window->UserPort)) {",
	"		msg = *m;",
	"		GT_ReplyIMsg(m);",
	"",
	"		switch (msg.Class) {",
	"			case IDCMP_INTUITICKS:",
	"				break;",
	"",
	"			case IDCMP_MOUSEMOVE:",
	"				if (handleFunc)",
	"					MouseMove(handleFunc, &msg);",
	"				else",
	"					MouseMove(DefaultHandleFunc, &msg);",
	"				break;",
	"",
	"			case IDCMP_GADGETUP:",
	"				if (handleFunc)",
	"					GadgetUp(handleFunc, &msg);",
	"				else",
	"					GadgetUp(DefaultHandleFunc, &msg);",
	"				break;",
	"",
	"			case IDCMP_GADGETDOWN:",
	"				if (handleFunc)",
	"					GadgetDown(handleFunc, &msg);",
	"				else",
	"					GadgetDown(DefaultHandleFunc, &msg);",
	"				break;",
	"",
	"			case IDCMP_REFRESHWINDOW:",
	"				GT_BeginRefresh(window);",
	"				if (refreshFunc)(*refreshFunc)();",
	"				GT_EndRefresh(window, TRUE);",
	"				break;",
	"			default:",
	"				if (idcmpFunc) ",
	"					(*idcmpFunc)(&msg);",
	"				else",
	"					DefaultIDCMPFunc(window, &msg);",
	"				break;",
	"		}",
	"	}",
	"}",
	"",
	"/************************************************************************/",
	"",
	NULL,
};

void	WriteMainC(void) {
	long	i;
	FILE	*fp;
	BPTR	lock;

	lock = Lock("main.c", SHARED_LOCK);
	if (lock) { UnLock(lock); return; }
	fp = fopen("main.c", "w");
	if (!fp) return;
	WriteStartupStuff(fp);
	for (i=0; mainc[i]; i++) fprintf(fp, "%s\n", mainc[i]);

	fprintf( fp, "void\tAbort(void) {\n");
	fprintf( fp, "\t%sCleanStuff();\n", &MainPrefs.pr_ProjectPrefix[0]);
	fprintf( fp, "\tCloseLibs();\n");
	fprintf( fp, "\texit(abortCode);\n");
	fprintf( fp, "}\n");

	fprintf( fp, "void	main(int ac, char *av[]) {\n");
	fprintf( fp, "	if (!OpenLibs()) exit(999);\n");
	fprintf( fp, "	%s();\n", &MainPrefs.pr_ProjectPrefix[0]);
	fprintf( fp, "}\n");
	fprintf( fp, "\n");

	fclose(fp);
}

char	*listsc[] = {
	"#include	\"defs.h\"",
	"",
	"ULONG	gtxErrorCode = 0;",
	"",
	"#define	Error(x) gtxErrorCode=(x)",
	"",
	"/************************************************************************/",
	"",
	"BOOL	EmptyList(list)",
	"LIST	*list;",
	"{",
	"	if (list->lh_TailPred == (NODE *)list) return !0;",
	"	return 0;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"void	FreeListNodes(LIST *list) {",
	"	NODE	*np;",
	"",
	"	while (!EmptyList(list)) {",
	"		np = RemHead(list);",
	"		if (np->ln_Type == NODE_ALLOCATED) free(np->ln_Name);",
	"		free(np);",
	"	}",
	"}",
	"",
	"/************************************************************************/",
	"",
	"NODE	*ListNodeNumber(LIST *list, ULONG n) {",
	"	NODE	*np;",
	"",
	"	for (np = list->lh_Head; np->ln_Succ; np=np->ln_Succ) {",
	"		if (!n) return np;",
	"		n--;",
	"	}",
	"	Error(LE_END_OF_LIST);",
	"	return NULL;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"// func is a comparison function.  It returns >0 if NODE2 > NODE1.",
	"// if flag == TRUE, then sort ascending, else decending",
	"void	SortList(LIST *list, int (*func)(), BOOL flag) {",
	"	LIST	tmp;",
	"	NODE	*np, *np2;",
	"",
	"	if (EmptyList(list)) return;",
	"	NewList(&tmp);",
	"	while (!EmptyList(list)) {",
	"		np = RemHead(list);",
	"		if (EmptyList(&tmp)) {",
	"			AddHead(&tmp, np);",
	"		}",
	"		else if (flag) {",
	"			if (func) {",
	"				if ((*func)(np, tmp.lh_Head) < 0)",
	"					AddHead(&tmp, np);",
	"				else if ((*func)(np, tmp.lh_TailPred) > 0)",
	"					AddTail(&tmp, np);",
	"				else {",
	"					for (np2=tmp.lh_Head; np2->ln_Succ; np2=np2->ln_Succ) {",
	"						if (strcmp(&np->ln_Name[0], &np2->ln_Name[0]) < 0) {",
	"							Insert(&tmp, np, np2->ln_Pred);",
	"							break;",
	"						}",
	"					}",
	"				}",
	"			}",
	"			else {",
	"				if (strcmp(&np->ln_Name[0], &tmp.lh_Head->ln_Name[0]) < 0) {",
	"					AddHead(&tmp, np);",
	"				}",
	"				else if (strcmp(&np->ln_Name[0], &tmp.lh_TailPred->ln_Name[0]) > 0) {",
	"					AddTail(&tmp, np);",
	"				}",
	"				else {",
	"					for (np2=tmp.lh_Head; np2->ln_Succ; np2=np2->ln_Succ) {",
	"						if (strcmp(&np->ln_Name[0], &np2->ln_Name[0]) < 0) {",
	"							Insert(&tmp, np, np2->ln_Pred);",
	"							break;",
	"						}",
	"					}",
	"				}",
	"			}",
	"		}",
	"		else { // descending",
	"			if (func) {",
	"				if ((*func)(np, tmp.lh_Head) > 0)",
	"					AddHead(&tmp, np);",
	"				else if ((*func)(np, tmp.lh_TailPred) < 0)",
	"					AddTail(&tmp, np);",
	"				else {",
	"					for (np2=tmp.lh_Head; np2->ln_Succ; np2=np2->ln_Succ) {",
	"						if (strcmp(&np->ln_Name[0], &np2->ln_Name[0]) > 0) {",
	"							Insert(&tmp, np, np2->ln_Pred);",
	"							break;",
	"						}",
	"					}",
	"				}",
	"			}",
	"			else {",
	"				if (strcmp(&np->ln_Name[0], &tmp.lh_Head->ln_Name[0]) > 0) {",
	"					AddHead(&tmp, np);",
	"				}",
	"				else if (strcmp(&np->ln_Name[0], &tmp.lh_TailPred->ln_Name[0]) < 0) {",
	"					AddTail(&tmp, np);",
	"				}",
	"				else {",
	"					for (np2=tmp.lh_Head; np2->ln_Succ; np2=np2->ln_Succ) {",
	"						if (strcmp(&np->ln_Name[0], &np2->ln_Name[0]) > 0) {",
	"							Insert(&tmp, np, np2->ln_Pred);",
	"							break;",
	"						}",
	"					}",
	"				}",
	"			}",
	"		}",
	"		",
	"	}",
	"	NewList(list);",
	"	while (!EmptyList(&tmp)) {",
	"		np = RemHead(&tmp);",
	"		AddTail(list, np);",
	"	}",
	"}",
	"",
	"/************************************************************************/",
	"",
	"// flag = TRUE to allocate string, FALSE to set ln_Name to static string (char *s)",
	"BOOL	AddStringToListTail(char *s, LIST *list, BOOL flag) {",
	"	NODE	*np = (NODE *)malloc(sizeof(NODE));",
	"",
	"	if (!np) { Error(LE_NO_MEMORY); return FALSE; }",
	"	if (flag) {",
	"		np->ln_Name = (char *)malloc(strlen(s)+1);",
	"		if (!np->ln_Name) { Error(LE_NO_MEMORY); free(np); return FALSE; }",
	"		strcpy(np->ln_Name, s);",
	"		np->ln_Type = NODE_ALLOCATED;",
	"	}",
	"	else {",
	"		np->ln_Name = s;",
	"		np->ln_Type = NODE_STATIC;",
	"	}",
	"	return !0;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"//",
	"// Expands tabs in a buffer into spaces.",
	"//",
	"void	TabsToSpaces(char *buf) {",
	"	short	col = 0;",
	"	char	work[512], *pd = &work[0], *ps = buf;",
	"",
	"	while (1) {",
	"		switch (*ps) {",
	"			case '\\t':	do {",
	"						*pd++ = ' '; col++;",
	"					} while ((col%8) && col < 510);",
	"					ps++;",
	"					if (col >= 510) {",
	"						*pd++ = '\\0';",
	"						strcpy(buf, work);",
	"						return;",
	"					}",
	"					break;",
	"			case '\\0':	*pd++ = '\\0';",
	"					strcpy(buf, work);",
	"					return;",
	"			default:	*pd++ = *ps++; col++; break;",
	"		}",
	"	}",
	"}",
	"",
	"/************************************************************************/",
	"",
	"ULONG	AppendListToList(LIST *dst, LIST *src) {",
	"	NODE	*srcNode;",
	"	ULONG	count = 0;",
	"",
	"	for (srcNode = src->lh_Head; srcNode->ln_Succ; srcNode = srcNode->ln_Succ) {",
	"		if (!AddStringToListTail(srcNode->ln_Name, dst, TRUE)) {",
	"			FreeListNodes(dst);",
	"			return 0;",
	"		}",
	"		count++;",
	"	}",
	"	return count;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"LIST	*CloneList(LIST *src) {",
	"	LIST	*list;",
	"",
	"	list = (LIST *)malloc(sizeof(LIST));",
	"	if (!list) {",
	"		Error(LE_EMPTY_LIST);",
	"		return NULL;",
	"	}",
	"	NewList(list);",
	"	if (!AppendListToList(list, src)) {",
	"		free(list);",
	"		return NULL;",
	"	}",
	"	return list;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"//",
	"// Appends a file to a LIST structure.  Returns # of lines read in.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to TabsToSpaces().",
	"//",
	"ULONG	AppendFileToList(FILE *fp, struct List *list, void (*LineEnhancer)()) {",
	"	char	buf[512];",
	"	ULONG	lines = 0L;",
	"",
	"	while (fgets(buf, 512, fp)) {",
	"		buf[strlen(buf)-1] = '\\0';",
	"		if (LineEnhancer)",
	"			(*LineEnhancer)(buf);",
	"		else",
	"			TabsToSpaces(buf);",
	"		if (!AddStringToListTail(buf, list, TRUE)) {",
	"			fclose(fp);",
	"			FreeListNodes(list);",
	"			return 0;",
	"		}",
	"		lines++;",
	"	}",
	"	Error(LE_OK);",
	"	return lines;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"//",
	"// Reads a file into a LIST structure.  Returns # of lines read in.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to TabsToSpaces().",
	"//",
	"ULONG	ReadListFromFile(LIST *list, char *filename, void (*LineEnhancer)()) {",
	"	FILE	*fp;",
	"	ULONG	lines;",
	"",
	"	NewList(list);",
	"	fp = fopen(filename, \"r\");",
	"	lines = AppendFileToList(fp, list, LineEnhancer);",
	"	fclose(fp);",
	"	return lines;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"//",
	"// Appends to a file from a LIST structure.  Returns # of lines written.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to SpacesToTabs().",
	"//",
	"ULONG	AppendListToFile(LIST *list, FILE *fp, void (*LineEnhancer)()) {",
	"	char	buf[512];",
	"	ULONG	lines = 0L;",
	"	NODE	*np;",
	"",
	"	for (np = list->lh_Head; list->lh_TailPred != np; np = np->ln_Succ) {",
	"		if (LineEnhancer)",
	"			(*LineEnhancer)(buf);",
	"#ifdef MYKE_REMOVED_THIS",
	"		else",
	"			SpacesToTabs(buf);",
	"#endif",
	"		fprintf(fp, \"%%s\\n\", buf);",
	"		lines++;",
	"	}",
	"	Error(LE_OK);",
	"	return lines;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"//",
	"// Reads a file into a LIST structure.  Returns # of lines read in.",
	"// LineEnhancer is either a function that takes a buffer and massages as",
	"// it desires or a NULL pointer, in which case it defaults to TabsToSpaces().",
	"//",
	"ULONG	WriteListToFile(LIST *list, char *filename, APTR LineEnhancer) {",
	"	FILE	*fp;",
	"	ULONG	lines;",
	"",
	"	fp = fopen(filename, \"w\");",
	"	lines = AppendListToFile(list, fp, LineEnhancer);",
	"	fclose(fp);",
	"	return lines;",
	"}",
	"",
	"/************************************************************************/",
	"",
	"// this routine should take a pattern as input.  It should use MatchFirst/MatchNext.",
	"",
	"ULONG	ReadListFromDirectory(LIST *list, char *dirname, short type, void (*EnhanceFIB)()) {",
	"	LOCK	lock;",
	"	ULONG	count = 0;",
	"	char	buf[512];",
	"	FIB	*fib;",
	"",
	"	NewList(list);",
	"	lock = Lock(dirname, SHARED_LOCK);",
	"	if (!lock) return 0;",
	"	fib = (FIB *)AllocDosObject(DOS_FIB, TAG_DONE);",
	"	if (!fib) return 0;",
	"	Examine(lock, fib);",
	"	while (ExNext(lock, fib)) {",
	"		if (type < 0 && fib->fib_DirEntryType > 0) continue;",
	"		else if (type > 0 && fib->fib_DirEntryType < 0) continue;",
	"		if (EnhanceFIB) {",
	"			(*EnhanceFIB)(buf, dirname, fib);",
	"		}",
	"		else {",
	"			strcpy(buf, fib->fib_FileName);",
	"		}",
	"		if (!AddStringToListTail(buf, list, TRUE)) { ",
	"			UnLock(lock); ",
	"			FreeDosObject(DOS_FIB, (void *)fib);",
	"			return count;",
	"		}",
	"		count++;",
	"	}",
	"	UnLock(lock); lock = 0;",
	"	FreeDosObject(DOS_FIB, (void *)fib);",
	"	return count;",
	"}",
	"",
	"/************************************************************************/",
	"",
	NULL,
};

void	WriteListsC(void) {
	long	i;
	FILE	*fp;
	BPTR	lock;

	lock = Lock("lists.c", SHARED_LOCK);
	if (lock) { UnLock(lock); return; }
	fp = fopen("lists.c", "w");
	if (!fp) return;
	WriteStartupStuff(fp);
	for (i=0; listsc[i]; i++) fprintf(fp, "%s\n", listsc[i]);
	fclose(fp);
}

void	WriteStubs() {
	char			name[128];
	FILE			*file;
	BPTR			lock;
	struct ExtNewGadget 	*eng;

	sprintf( name, "%sStubs.c", &MainPrefs.pr_ProjectPrefix[0] );
	lock = Lock(name, SHARED_LOCK);
	if (lock) { UnLock(lock); return; }
	file = fopen(name, "w");
	if (!file) return;
	WriteStartupStuff(file);
	fprintf(file, "#include	\"%s.c\"\n\n", &MainPrefs.pr_ProjectPrefix[0] );

	fprintf( file, "// Stubs\n");
	fprintf( file, "// Fill in the code for your application here!\n");
	for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
		fprintf( file, "void	%s(UWORD gadgetID, UWORD code) {\n", &eng->en_SourceLabel[0]);
		fprintf( file, "	printf(\"Gadget %s\\n\");\n", &eng->en_SourceLabel[0]);
		fprintf( file, "}\n\n");
	}

	fprintf( file, "// As you use GTB to edit your gadgets, etc., you will need to\n");
	fprintf( file, "// edit this function accordingly.\n");

	fprintf( file, "void	%sGadgetHandler(UWORD gadgetID, UWORD code) {\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
	fprintf( file, "	switch(gadgetID) {\n");

	for ( eng = Gadgets.gl_First; eng->en_Next; eng = eng->en_Next ) {
		fprintf( file, "		case GD_%s:\n", &eng->en_SourceLabel[0]);
		fprintf( file, "			%s(gadgetID, code);\n", &eng->en_SourceLabel[0]);
		fprintf( file, "			break;\n");
	}
	fprintf( file, "		default:\n");
	fprintf( file, "			printf(\"GadgetID: %%d (code=%%d)\\n\", gadgetID, code);\n");
	fprintf( file, "			break;\n");
	fprintf( file, "	}\n");
	fprintf( file, "}\n\n");

	WriteCMain(file);
	fclose(file);
}

/*
 * --- Write the C Source file.
 */
long WriteCSource( void )
{
	FILE	*file = 0l;
	UBYTE	fname[32], *ptr;

	strcpy( fname, MainFontName );

	ptr  = strchr( fname, '.' );
	*ptr = 0;

	if ( gc_GenC = AllocAslRequest( ASL_FileRequest, TAG_DONE )) {
		gc_CTags[1].ti_Data = (ULONG)MainWindow;
		if ( AslRequest( gc_GenC, gc_CTags )) {

			strcpy( MainFileName, gc_GenC->rf_Dir );
			CheckDirExtension();
			strcat( MainFileName, gc_GenC->rf_File );

			strcpy( gc_CPath, gc_GenC->rf_Dir );
			strcpy( gc_CFile, gc_GenC->rf_File );
			strcpy( gc_CPatt, gc_GenC->rf_Pat );

			if ( file = fopen( MainFileName, "w" )) {

				SetTitle( "Saving C Source..." );

				SetIoErr( 0l );

WriteDefsH();
WriteMakefile();
WriteDMakefile();
WriteMainC();
WriteStubs();
WriteListsC();
				WriteStartupStuff( file );
				fprintf( file, "#include \"defs.h\"\n\n");
				WriteCID( file );
				WriteCGlob( file );
				WriteCLabels( file );
				WriteCList( file );
				WriteCTextAttr( file );
				WriteCGadgets( file );
				WriteCWTags( file );
				WriteCIText( file );
				WriteCMenus( file );

				if ( cs_ScreenType == 2 )
					WriteCSTags( file );

				WriteCHeader( file );

				if ( NOT cs_ScreenType )
					fprintf( file, "\tif ( NOT( %sScreen = LockPubScreen( \"Workbench\" )))\n		return( 1l );\n\n", &MainPrefs.pr_ProjectPrefix[0] );
				else if ( cs_ScreenType == 1 )
					fprintf( file, "\tif ( NOT( %sScreen = LockPubScreen( 0l )))\n		return( 1l );\n\n", &MainPrefs.pr_ProjectPrefix[0] );
				else
					fprintf( file, "\tif ( NOT( %sScreen = OpenScreenTagList( 0l, %sScreenTags )))\n		return( 1l );\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

				if ( cs_ScreenType )
					fprintf( file, "\t%sWindowTags[ %ld ].ti_Data = (ULONG)%sScreen;\n\n", &MainPrefs.pr_ProjectPrefix[0], gc_ScreenOffset, &MainPrefs.pr_ProjectPrefix[0] );

				fprintf( file, "\tif ( NOT( %sVisualInfo = GetVisualInfo( %sScreen, TAG_DONE )))\n		return( 2l );\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

				if ( Gadgets.gl_First->en_Next )
					fprintf( file, "\tif ( NOT( g = CreateContext( &%sGList )))\n		return( 3l );\n\n", &MainPrefs.pr_ProjectPrefix[0] );

				WriteCGadgetInits( file );

				if ( ExtMenus.ml_First->em_Next ) {
					fprintf( file, "\tif ( NOT( %sMenus = CreateMenus( %sNewMenu, GTMN_FrontPen, 0l, TAG_DONE )))\n		return( 6l );\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );
					fprintf( file, "\tLayoutMenus( %sMenus, %sVisualInfo, GTMN_TextAttr, &%s%ld, TAG_DONE );\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0], fname, MainFont.ta_YSize );
				}

				fprintf( file, "\tif ( NOT( %sWindow = OpenWindowTagList( 0l, %sWindowTags )))\n		return( 5l );\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

				if ( ExtMenus.ml_First->em_Next )
					fprintf( file, "\tSetMenuStrip( %sWindow, %sMenus );\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

				fprintf( file, "\tGT_RefreshWindow( %sWindow, 0l );\n\n", &MainPrefs.pr_ProjectPrefix[0] );

				if ( ws_ZoomF ) {
					fprintf( file, "\t%sZoom[0] = %ld;\n", &MainPrefs.pr_ProjectPrefix[0], MainWindow->LeftEdge );
					fprintf( file, "\t%sZoom[1] = %ld;\n", &MainPrefs.pr_ProjectPrefix[0], MainWindow->TopEdge );
					fprintf( file, "\t%sZoom[2] = %ld;\n", &MainPrefs.pr_ProjectPrefix[0], MainWindow->Width );
					fprintf( file, "\t%sZoom[3] = %ld;\n\n", &MainPrefs.pr_ProjectPrefix[0], MainWindow->Height );
				}

				if ( WindowTxt )
					fprintf( file, "\tPrintIText( %sWindow->RPort, %sIText, 0l, 0l );\n\n", &MainPrefs.pr_ProjectPrefix[0], &MainPrefs.pr_ProjectPrefix[0] );

				fprintf( file, "\treturn( 0l );\n}\n\n" );

				WriteCCleanup( file );


				fclose( file );

				file = 0l;

				if ( IoErr())
					MyRequest( "Oh oh...", "CONTINUE", "Write Error !" );
			}
		}
	}

	SetWindowTitles( MainWindow, MainWindowTitle, MainScreenTitle );
	RefreshWindow();

	if ( file ) fclose( file );
	if ( gc_GenC ) FreeAslRequest( gc_GenC );

	gc_GenC = 0l;

	ClearMsgPort( MainWindow->UserPort );
}
