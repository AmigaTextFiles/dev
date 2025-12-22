/*
 *	PLAYERGUI.C
 */

#include "BGUIPlayer.h"

/*
 *	Play button image.
 */
static struct VectorItem Play[] = {
	{	25,	11,	VIF_SCALE				  },
	{	5,	2,	VIF_MOVE | VIF_AREASTART		  },
	{	5,	5,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	5,	5,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	5,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	5,	2,	VIF_DRAW | VIF_LASTITEM                   }
};

/*
 *	Pause button image.
 */
static struct VectorItem Pause[] = {
	{	25,	11,	VIF_SCALE				  },
	{	9,	3,	VIF_MOVE | VIF_AREASTART		  },
	{	11,	3,	VIF_DRAW				  },
	{	11,	3,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	9,	3,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	9,	3,	VIF_DRAW | VIF_AREAEND			  },
	{	9,	3,	VIF_MOVE | VIF_AREASTART | VIF_XRELRIGHT  },
	{	11,	3,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	11,	3,	VIF_DRAW | VIF_YRELBOTTOM | VIF_XRELRIGHT },
	{	9,	3,	VIF_DRAW | VIF_YRELBOTTOM | VIF_XRELRIGHT },
	{	9,	3,	VIF_DRAW | VIF_XRELRIGHT | VIF_LASTITEM   }
};

/*
 *	Stop button image.
 */
static struct VectorItem Stop[] = {
	{	25,	11,	VIF_SCALE				  },
	{	9,	3,	VIF_MOVE | VIF_AREASTART		  },
	{	9,	3,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	9,	3,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	9,	3,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	9,	3,	VIF_DRAW | VIF_LASTITEM                   }
};

/*
 *	Previous button image.
 */
static struct VectorItem Previous[] = {
	{	25,	11,	VIF_SCALE				  },
	{	8,	2,	VIF_MOVE | VIF_AREASTART		  },
	{	9,	2,	VIF_DRAW				  },
	{	9,	5,	VIF_DRAW				  },
	{	10,	5,	VIF_DRAW				  },
	{	9,	2,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	8,	2,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	8,	2,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	9,	2,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	10,	5,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	9,	5,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	9,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	8,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	8,	2,	VIF_DRAW | VIF_LASTITEM                   }
};

/*
 *	Next button image.
 */
static struct VectorItem Next[] = {
	{	25,	11,	VIF_SCALE				  },
	{	8,	2,	VIF_MOVE | VIF_AREASTART | VIF_XRELRIGHT  },
	{	9,	2,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	9,	5,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	10,	5,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	9,	2,	VIF_DRAW				  },
	{	8,	2,	VIF_DRAW				  },
	{	8,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	9,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	10,	5,	VIF_DRAW | VIF_YRELBOTTOM | VIF_XRELRIGHT },
	{	9,	5,	VIF_DRAW | VIF_YRELBOTTOM | VIF_XRELRIGHT },
	{	9,	2,	VIF_DRAW | VIF_YRELBOTTOM | VIF_XRELRIGHT },
	{	8,	2,	VIF_DRAW | VIF_YRELBOTTOM | VIF_XRELRIGHT },
	{	8,	2,	VIF_DRAW | VIF_LASTITEM | VIF_XRELRIGHT   }
};

/*
 *	Backward button image.
 */
static struct VectorItem Backward[] = {
	{	25,	11,	VIF_SCALE				  },
	{	5,	5,	VIF_MOVE | VIF_AREASTART		  },
	{	12,	2,	VIF_DRAW				  },
	{	12,	5,	VIF_DRAW				  },
	{	5,	2,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	5,	2,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	12,	5,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	12,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	5,	5,	VIF_DRAW | VIF_YRELBOTTOM | VIF_LASTITEM  }
};

/*
 *	Forward button image.
 */
static struct VectorItem Forward[] = {
	{	25,	11,	VIF_SCALE				  },
	{	5,	5,	VIF_MOVE | VIF_AREASTART | VIF_XRELRIGHT  },
	{	12,	2,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	12,	5,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	5,	2,	VIF_DRAW				  },
	{	5,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	12,	5,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	12,	2,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	5,	5,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM | VIF_LASTITEM  }
};

/*
 *	Eject button image.
 */
static struct VectorItem Eject[] = {
	{	25,	11,	VIF_SCALE				  },
	{	12,	2,	VIF_MOVE | VIF_AREASTART		  },
	{	11,	2,	VIF_DRAW | VIF_XRELRIGHT		  },
	{	6,	5,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	6,	5,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	12,	2,	VIF_DRAW | VIF_AREAEND			  },
	{	6,	3,	VIF_MOVE | VIF_AREASTART | VIF_YRELBOTTOM },
	{	6,	3,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	6,	2,	VIF_DRAW | VIF_XRELRIGHT | VIF_YRELBOTTOM },
	{	6,	2,	VIF_DRAW | VIF_YRELBOTTOM		  },
	{	6,	3,	VIF_DRAW | VIF_YRELBOTTOM | VIF_LASTITEM  }
};

/*
 *	Simple macros to create a
 *	vector image button/Toggle.
 */
#define VectorButton( v, i )\
	ButtonObject,\
		ButtonFrame,\
		VIT_VectorArray,	v,\
		GA_ID,			i,\
	EndObject

#define VectorToggle( v, i )\
	ButtonObject,\
		ButtonFrame,\
		VIT_VectorArray,	v,\
		GA_ID,			i,\
		GA_ToggleSelect,	TRUE,\
	EndObject

/*
 *	Create the control panel.
 */
Prototype Object *GO_Pause;

Object *GO_Pause;

static Object *CreateControlPanel( void )
{
	Object			*master;

	/*
	 *	Create the control panel which
	 *	contains, from left to right:
	 *
	 *	Play, Pause, Stop, Previous, Next, Backward, Forward, Eject.
	 */
	master = HGroupObject,
		StartMember, VectorButton( Play,     ID_PLAY	 ), EndMember,
		StartMember, GO_Pause = VectorToggle( Pause,	ID_PAUSE    ), EndMember,
		StartMember, VectorButton( Stop,     ID_STOP	 ), EndMember,
		StartMember, VectorButton( Previous, ID_PREV	 ), EndMember,
		StartMember, VectorButton( Next,     ID_NEXT	 ), EndMember,
		StartMember, VectorButton( Backward, ID_BACKWARD ), EndMember,
		StartMember, VectorButton( Forward,  ID_FORWARD  ), EndMember,
		StartMember, VectorButton( Eject,    ID_EJECT	 ), EndMember,
	EndObject;

	return( master );
}

/*
 *	Create the track selection group.
 */
#define TrackButton( l, i, d )\
	ButtonObject,\
		LAB_Label,	l,\
		GA_ID,		i,\
		ButtonFrame,\
		GA_Disabled,	d,\
	EndObject

Prototype Object *TrackButtons[ 20 ];

static UBYTE *Tracks[] = { "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20" };
Object *TrackButtons[ 20 ];

static Object *CreateTrackPanel( void )
{
	Object		*master, *row[ 4 ];
	UWORD		 i, a, j;
	BOOL		 fail = FALSE;

	/*
	 *	First we create a horizontal master group.
	 */
	if ( master = BGUI_NewObject( BGUI_GROUP_GADGET, GROUP_Style, GRSTYLE_VERTICAL, TAG_END )) {
		/*
		 *	Then four rows of 5 buttons each.
		 */
		for ( a = 0, i = 0; a < 4; a++ ) {
			if ( row[ a ] = BGUI_NewObject( BGUI_GROUP_GADGET, GROUP_Style, GRSTYLE_HORIZONTAL, GROUP_EqualWidth, TRUE, TAG_END )) {
				/*
				 *	Then the buttons.
				 */
				for ( j = 0; j < 5; j++, i++ ) {
					if ( ! DoMethod( row[ a ], GRM_ADDMEMBER, TrackButtons[ i ] = TrackButton( Tracks[ i ], i + 1, i < TOCNumTracks ? FALSE : TRUE ), TAG_END )) {
						fail = TRUE;
						break;
					}
				}
				if ( ! DoMethod( master, GRM_ADDMEMBER, row[ a ], TAG_END )) {
					fail = TRUE;
					break;
				}
				if ( fail ) break;
			} else {
				fail = TRUE;
				break;
			}
		}
		if ( fail ) {
			DisposeObject( master );
			master = NULL;
		}
	}
	return( master );
}

/*
 *	Simple macros for display objects.
 */
#define TwoDigit\
	IndicatorObject,\
		INDIC_Min,		0,\
		INDIC_Max,		99,\
		INDIC_FormatString,	"%02ld",\
		INDIC_Justification,	IDJ_CENTER,\
	EndObject

#define TwoDigitRight\
	IndicatorObject,\
		INDIC_Min,		0,\
		INDIC_Max,		99,\
		INDIC_FormatString,	"%02ld",\
		INDIC_Justification,	IDJ_RIGHT,\
	EndObject

#define TwoDigitColon\
	IndicatorObject,\
		INDIC_Min,		0,\
		INDIC_Max,		99,\
		INDIC_FormatString,	":%02ld",\
	EndObject

#define InfoTitle( t )\
	InfoObject,\
		INFO_TextFormat,	t,\
		INFO_HorizOffset,	0,\
		INFO_VertOffset,	0,\
		INFO_FixTextWidth,	TRUE,\
	EndObject

/*
 *	Create the Display panel. The display panel
 *	consists of several indicator and info
 *	objects.
 */
Prototype Object	*GO_Track, *GO_Index, *GO_TimeA, *GO_TimeB, *GO_TogoA, *GO_TogoB, *GO_TotalA, *GO_TotalB, *GO_Title, *GO_TrackTitle;
Prototype ULONG         TrackID, IndexID, TimeIDA, TimeIDB, TogoIDA, TogoIDB, TotalIDA, TotalIDB;

Object *GO_Track,		/* Track indicator.			*/
       *GO_Index,		/* Index indicator.			*/
       *GO_TimeA,		/* Minutes passed digits.		*/
       *GO_TimeB,		/* Seconds passed digits.		*/
       *GO_TogoA,		/* Minutes to go digits.		*/
       *GO_TogoB,		/* Seconds to go digits.		*/
       *GO_TotalA,		/* Total disk minute digits.		*/
       *GO_TotalB,		/* Total disk second digits.		*/
       *GO_Title,		/* Disk title.				*/
       *GO_TrackTitle;		/* Artist/Track playing.		*/

ULONG  TrackID, IndexID, TimeIDA, TimeIDB, TogoIDA, TogoIDB, TotalIDA, TotalIDB;

static Object *CreateDisplayPanel( void )
{
	Object			*master;

	master = VGroupObject, Spacing( 2 ), HOffset( 4 ), VOffset( 2 ),
		FRM_Type,	FRTYPE_BUTTON,
		FRM_Recessed,	TRUE,
		StartMember,
			VGroupObject, Spacing( 2 ),
				StartMember,
					HGroupObject, Spacing( 2 ),
						StartMember,
							VGroupObject, GROUP_EqualWidth, TRUE,
								StartMember, InfoTitle( ISEQ_C "Track" ), EndMember,
								StartMember, GO_Track = TwoDigit, EndMember,
							EndObject,
						EndMember,
						StartMember,
							VGroupObject, GROUP_EqualWidth, TRUE,
								StartMember, InfoTitle( ISEQ_C "Index" ), EndMember,
								StartMember, GO_Index = TwoDigit, EndMember,
							EndObject,
						EndMember,
						StartMember,
							VGroupObject, GROUP_EqualWidth, TRUE,
								StartMember, InfoTitle( ISEQ_C "Time" ), EndMember,
								StartMember,
									HGroupObject,
										StartMember, GO_TimeA = TwoDigitRight, EndMember,
										StartMember, GO_TimeB = TwoDigitColon, EndMember,
									EndObject,
								EndMember,
							EndObject,
						EndMember,
						StartMember,
							VGroupObject, GROUP_EqualWidth, TRUE,
								StartMember, InfoTitle( ISEQ_C "To go" ), EndMember,
								StartMember,
									HGroupObject,
										StartMember, GO_TogoA = TwoDigitRight, EndMember,
										StartMember, GO_TogoB = TwoDigitColon, EndMember,
									EndObject,
								EndMember,
							EndObject,
						EndMember,
						StartMember,
							VGroupObject, GROUP_EqualWidth, TRUE,
								StartMember, InfoTitle( ISEQ_C "Total" ), EndMember,
								StartMember,
									HGroupObject,
										StartMember, GO_TotalA = TwoDigitRight, EndMember,
										StartMember, GO_TotalB = TwoDigitColon, EndMember,
									EndObject,
								EndMember,
							EndObject,
						EndMember,
					EndObject,
				EndMember,
				StartMember, HorizSeperator, EndMember,
				StartMember,
					GO_Title = InfoObject,
						INFO_HorizOffset,	0,
						INFO_VertOffset,	0,
						INFO_TextFormat,	Status == SCSI_STAT_NO_DISK ? "<NO DISK>" : DiskName,
					EndObject,
				EndMember,
				StartMember,
					GO_TrackTitle = InfoObject,
						INFO_HorizOffset,	0,
						INFO_VertOffset,	0,
						INFO_TextFormat,	Status == SCSI_STAT_NO_DISK ? "" : ( Status == SCSI_STAT_STOPPED ? Artist : &DiskTracks[ Track - 1 ][ 0 ] ),
					EndObject,
				EndMember,
			EndObject,
		EndMember,
	EndObject;

	return( master );
}

/*
 *	Export data.
 */
Prototype Object	*WO_Player, *GO_Volume;
Prototype struct Window *Player;
Prototype ULONG          PlayerSig;

Object			*WO_Player, *GO_Volume, *GO_Hide, *GO_Quit;
struct Window		*Player;
ULONG			 PlayerSig;

/*
 *	Main window menus.
 */
static struct NewMenu MainMenus[] = {
	Title( "Project" ),
		Item( "Inquire...",     "I",    ID_INQUIRE ),
		Item( "About...",       "?",    ID_ABOUT   ),
		ItemBar,
		Item( "Edit CD...",     "E",    ID_EDIT    ),
		ItemBar,
		Item( "Hide",           "H",    ID_HIDE    ),
		Item( "Quit",           "Q",    ID_QUIT    ),
	End
};

/*
 *	Open up the player window.
 */
Prototype BOOL OpenPlayerWindow( BOOL );

BOOL OpenPlayerWindow( BOOL open )
{
	/*
	 *	Object created yet?
	 */
	if ( ! WO_Player ) {
		/*
		 *	No. Create it.
		 */
		WO_Player = WindowObject,
			WINDOW_Title,			VERS " (" DATE ")",
			WINDOW_AutoAspect,		TRUE,
			WINDOW_SmartRefresh,		TRUE,
			WINDOW_LockHeight,		TRUE,
			WINDOW_MenuStrip,		MainMenus,
			WINDOW_PubScreenName,		PubScreen,
			WINDOW_SharedPort,		SharedPort,
			WINDOW_MasterGroup,
				VGroupObject, HOffset( 4 ), VOffset( 4 ), Spacing( 4 ), GROUP_BackFill, SHINE_RASTER,
					StartMember,
						HGroupObject, Spacing( 4 ), HOffset( 4 ), VOffset( 4 ),
							FRM_Type,	FRTYPE_BUTTON,
							FRM_Recessed,	TRUE,
							StartMember,
								VGroupObject, Spacing( 2 ),
									StartMember,
										CreateDisplayPanel(),
									EndMember,
									StartMember,
										CreateControlPanel(), FixMinHeight,
									EndMember,
									StartMember,
										VGroupObject, HOffset( 4 ), VOffset( 4 ),
											FRM_Type,	FRTYPE_BUTTON,
											FRM_Recessed,	TRUE,
											VarSpace( DEFAULT_WEIGHT ),
											StartMember, GO_Volume = KeyHorizSlider( "_Volume:", 1, 255, 255, ID_VOLUME ), FixMinHeight, EndMember,
											VarSpace( DEFAULT_WEIGHT ),
										EndObject,
									EndMember,
								EndObject,
							EndMember,
							StartMember, CreateTrackPanel(), EndMember,
						EndObject,
					EndMember,
					StartMember,
						HGroupObject, Spacing( 2 ),
							StartMember, GO_Hide = KeyButton( "_Hide", ID_HIDE ), EndMember,
							VarSpace( DEFAULT_WEIGHT ),
							StartMember, GO_Quit = KeyButton( "_Quit", ID_QUIT ), EndMember,
						EndObject,
					EndMember,
				EndObject,
		EndObject;

		if ( WO_Player ) {
			GadgetKey( WO_Player, GO_Hide,	 "h" );
			GadgetKey( WO_Player, GO_Quit,	 "q" );
			GadgetKey( WO_Player, GO_Volume, "v" );
			DisableMenu( WO_Player, ID_EDIT, Status == SCSI_STAT_NO_DISK ? TRUE : FALSE );
		}
	}

	if ( WO_Player && open ) {
		/*
		 *	Open the window.
		 */
		if ( Player = WindowOpen( WO_Player )) {
			GetAttr( WINDOW_SigMask, WO_Player, &PlayerSig );
			return( TRUE );
		}
	}
	return( FALSE );
}

/*
 *	Close the player window.
 */
Prototype VOID ClosePlayerWindow( void );

VOID ClosePlayerWindow( void )
{
	WindowClose( WO_Player );
	Player = NULL;
	PlayerSig = 0L;
}
