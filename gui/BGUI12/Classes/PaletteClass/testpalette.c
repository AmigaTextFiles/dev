;/* Execute me to compile with DICE V3.0
dcc testpalette.c -3.0 -mi -ms -proto -lpaletteclass.o -lbgui
quit
*/
/*
 *	TESTPALETTE.C
 *
 *	(C) Copyright 1995 Jaba Development.
 *	(C) Copyright 1995 Jan van den Baard.
 *	    All Rights Reserved.
 */

#include <exec/types.h>
#include <libraries/bgui.h>
#include <libraries/bgui_macros.h>

#include <clib/alib_protos.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/bgui.h>

#include "paletteclass.h"

/*
 *	Object ID.
 */
#define ID_QUIT                 1

/*
 *	Map-lists.
 */
ULONG p2f[]  = { PALETTE_CurrentColor, FRM_BackPen,	    TAG_END };
ULONG p2fs[] = { PALETTE_CurrentColor, FRM_SelectedBackPen, TAG_END };
ULONG p2l[]  = { PALETTE_CurrentColor, LAB_Pen,             TAG_END };
ULONG p2ls[] = { PALETTE_CurrentColor, LAB_SelectedPen,     TAG_END };

/*
 *	Library base and class base.
 */
struct Library *BGUIBase;
Class	       *PaletteClass;

int main( int argc, char **argv )
{
	struct Window		*window;
	Object			*WO_Window, *GO_Quit, *GO_B, *GO_Pal[ 4 ];
	ULONG			 signal, rc, tmp = 0, a;
	UWORD			 defpens[ 4 ] = { 0, 3, 1, 1 };
	BOOL			 running = TRUE;

	/*
	 *	Open BGUI.
	 */
	if ( BGUIBase = OpenLibrary( BGUINAME, BGUIVERSION )) {
		/*
		 *	Initialize the paletteclass.
		 */
		if ( PaletteClass = InitPaletteClass()) {
			/*
			 *	I assume a depth of three
			 *	(8 colors) here for simplicity.
			 */
			for ( a = 0; a < 4; a++ )
				GO_Pal[ a ] = NewObject( PaletteClass, NULL, FRM_Type,				FRTYPE_BUTTON,
									     FRM_Recessed,			TRUE,
									     PALETTE_Depth,			3,
									     PALETTE_CurrentColor,		defpens[ a ],
									     TAG_END );
			/*
			 *	Create the window object.
			 */
			WO_Window = WindowObject,
				WINDOW_Title,		"PaletteClass Demo",
				WINDOW_AutoAspect,	TRUE,
				WINDOW_SmartRefresh,	TRUE,
				WINDOW_RMBTrap,         TRUE,
				WINDOW_IDCMP,		IDCMP_MOUSEMOVE,
				WINDOW_MasterGroup,
					VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
						GROUP_BackFill,         SHINE_RASTER,
						StartMember,
							InfoFixed( NULL, ISEQ_C
									 "As you can see the colors of the below button\n"
									 "are normal but when you change the colors with\n"
									 "the palette objects the colors of the button change.",
									 NULL, 3 ),
						EndMember,
						StartMember,
							HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
								FRM_Type,		FRTYPE_BUTTON,
								FRM_Recessed,		TRUE,
								StartMember, GO_B = Button( "Palette Demo", 0 ), EndMember,
							EndObject, FixMinHeight,
						EndMember,
						StartMember,
							HGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ),
								FRM_Type,		FRTYPE_BUTTON,
								FRM_Recessed,		TRUE,
								StartMember,
									VGroupObject, Spacing( 4 ),
										LAB_Label,	"Background:",
										LAB_Place,	PLACE_ABOVE,
										StartMember, GO_Pal[ 0 ], EndMember,
										StartMember, GO_Pal[ 1 ], EndMember,
									EndObject,
								EndMember,
								StartMember,
									VGroupObject, Spacing( 4 ),
										LAB_Label,	"Label:",
										LAB_Place,	PLACE_ABOVE,
										StartMember, GO_Pal[ 2 ], EndMember,
										StartMember, GO_Pal[ 3 ], EndMember,
									EndObject,
								EndMember,
							EndObject,
						EndMember,
						StartMember,
							HGroupObject,
								VarSpace( DEFAULT_WEIGHT ),
								StartMember, GO_Quit = KeyButton( "_Quit", ID_QUIT ), EndMember,
								VarSpace( DEFAULT_WEIGHT ),
							EndObject, FixMinHeight,
						EndMember,
					EndObject,
			EndObject;

			/*
			**	Object created OK?
			**/
			if ( WO_Window ) {
				tmp += GadgetKey( WO_Window, GO_Quit,  "q" );
				tmp += AddMap( GO_Pal[ 0 ], GO_B, p2f  );
				tmp += AddMap( GO_Pal[ 1 ], GO_B, p2fs );
				tmp += AddMap( GO_Pal[ 2 ], GO_B, p2l  );
				tmp += AddMap( GO_Pal[ 3 ], GO_B, p2ls );
				if ( tmp == 5 ) {
					if ( window = WindowOpen( WO_Window )) {
						GetAttr( WINDOW_SigMask, WO_Window, &signal );
						do {
							Wait( signal );
							while (( rc = HandleEvent( WO_Window )) != WMHI_NOMORE ) {
								switch ( rc ) {

									case	WMHI_CLOSEWINDOW:
									case	ID_QUIT:
										running = FALSE;
										break;
								}
							}
						} while ( running );
					}
				}
				DisposeObject( WO_Window );
			}
			FreePaletteClass( PaletteClass );
		}
		CloseLibrary( BGUIBase );
	}
}

#ifdef _DCC
int wbmain( struct WBStartup *wbs )
{
	return( main( 0, wbs ));
}
#endif

