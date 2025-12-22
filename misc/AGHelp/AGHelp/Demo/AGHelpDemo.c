/* Demo for the aghelp.class.
 *
 * This demo currently needs ClassAct, though this is not a requirement
 * of the aghelp.class as such (which is ClassAct-compatible though ;).
 */

#include <classact.h>
#include <clib/alib_protos.h>
#include <proto/aghelp.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include "/source/macros.h"


struct ClassLibrary	*AGHelpBase;


const STRPTR	Context[] =
{
	"Main",
	"Node_1",
	"Node_2",
	"Node_3",
	"Node_4"
};


/* A very simple error hook... */
SAVEDS ASM VOID
ErrorFunc( A0 struct Hook *hook, A2 Object *help, A1 struct aghError *err )
{
	Printf(	"AGHelp error    : %ld\n"
		"AmigaGuide error: '%s' (%ld)\n",
		err->agh_Error,
		err->agh_HTErrorString,
		err->agh_HTError );
}


struct Hook ErrHook =
{
	NULL, NULL,
	( HOOKFUNC ) ErrorFunc,
	NULL, NULL
};


#define WINDOW_FLAGS	( WFLG_DRAGBAR | WFLG_CLOSEGADGET | WFLG_DEPTHGADGET | WFLG_ACTIVATE | WFLG_SIMPLE_REFRESH )

__stdargs VOID
__main( STRPTR argStr )
{
	if( ButtonBase && ( AGHelpBase = ( struct ClassLibrary * ) OpenLibrary( "aghelp.class", 0 ) ) )
	{
		Object	*help;
		ULONG	helpMask;

		if( help = NewObject( AGH_GetClass(), NULL,
			AGHA_Context,		Context,
			AGHA_SigMask,		&helpMask,
			AGHA_GuideName,		"AGHelpDemo.guide",
			AGHA_ErrorHook,		&ErrHook,
		TAG_DONE ) )
		{
			Object	*win;

			if( win = WindowObject,
				WA_Flags,		WINDOW_FLAGS,
				WA_Title,		"AGHelp demo",
				WINDOW_Position,	WPOS_TOPLEFT,
				WINDOW_Layout,	VGroupObject,
					LAYOUT_SpaceOuter,	TRUE,
					StartVGroup,
						LAYOUT_BevelStyle,	BVS_BUTTON,
						LAYOUT_BevelState,	IDS_SELECTED,
						LAYOUT_SpaceOuter,	TRUE,
						StartImage,	LabelObject,
							LABEL_Text,	"Click on some of the gadgets below\n"
									"to see some (simple) help messages.",
						EndImage,
					EndGroup,
					StartImage, BevelObject,
						BEVEL_Style,	VBarFrame,
					EndImage,
					CHILD_WeightedHeight,	0,
					StartHGroup,
						StartMember, Button( "Gadget 1", 1 ),
						StartMember, Button( "Gadget 2", 2 ),
					EndGroup,
					StartHGroup,
						StartMember, Button( "Gadget 3", 3 ),
						StartMember, Button( "Gadget 4", 4 ),
					EndGroup,
				EndGroup,
			EndWindow )
			{
				if( CA_OpenWindow( win ) )
				{
					ULONG	winMask, rec;
					BOOL	run = TRUE;

					GetAttr( WINDOW_SigMask, win, &winMask );

					while( run )
					{
						rec = Wait( winMask | helpMask | SIGBREAKF_CTRL_C );

						if( rec & winMask )
						{
							ULONG	result, code;

							while( WMHI_LASTMSG != ( result = DoMethod( win, WM_HANDLEINPUT, &code ) ) )
							{
								switch( result & WMHI_CLASSMASK )
								{
									case WMHI_CLOSEWINDOW:
										run = FALSE;
										break;

									case WMHI_GADGETUP:
										DoMethod( help, AGHM_HELP, result & WMHI_GADGETMASK );
										break;

									case WMHI_RAWKEY:
										if( ( result & WMHI_GADGETMASK ) == 0x5f )
										{
											DoMethod( help, AGHM_HELP, 0 );
										}

										break;
								}
							}
						}

						if( rec & helpMask )
						{
							DoMethod( help, AGHM_HANDLEINPUT );
						}

						if( rec & SIGBREAKF_CTRL_C )
						{
							run = FALSE;
						}
					}
				}

				DisposeObject( win );
			}

			DisposeObject( help );
		}

		CloseLibrary( ( struct Library * ) AGHelpBase );
	}
}
