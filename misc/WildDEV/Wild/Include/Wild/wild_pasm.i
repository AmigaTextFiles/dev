
.ifndef	WILD_I
.set	WILD_I,1		

*		include	"exec/lists.i"
*		include	"exec/libraries.i"
*		include	"exec/ports.i"
*		include	"utility/tagitem.i"

.set	MLH_SIZE,12
.set	MLN_SIZE,8
.set	TAG_USER,0x80000000
.set	LIB_SIZE,0x22
.set	MN_SIZE,0x14
***************************************************************************************
***	My SUPERB library base !! HAhAhhahahaaaah!!				*******
***************************************************************************************
		
		STRUCTURE	WildBASE,LIB_SIZE+4
			LONG	wi_FastPool
			LONG	wi_ChipPool
			APTR	wi_UtilityBase
			APTR	wi_IntuitionBase
			APTR	wi_GraphicsBase
			APTR	wi_DOSBase
			APTR	wi_XpkBase
			APTR	wi_WildPrefsBase
			APTR	wi_PowerPCBase
			APTR	wi_ProfilerBase
			BYTE	wi_WhyFail
			BYTE	wi_Hole000
			STRUCT	wi_Apps,MLH_SIZE
			STRUCT	wi_Modules,MLH_SIZE
			STRUCT	wi_Threads,MLH_SIZE
			STRUCT	wi_Tables,MLH_SIZE
			STRUCT	wi_Extensions,MLH_SIZE		
			STRUCT	wi_MORELISTS,MLH_SIZE*3
			LONG	wi_Ticker
			LABEL	wi_SIZEOF

***************************************************************************************
***	The WildApp and the WildEngine!						*******
***************************************************************************************

		STRUCTURE	WildEngine,0
			APTR	we_Display		
			APTR	we_TDCore		
			APTR	we_Light		
			APTR	we_Draw			
			APTR	we_FX			
			APTR	we_Sound		
			APTR	we_Music		
			APTR	we_Broker		
			APTR	we_Loader		
			APTR	we_Saver		
			STRUCT	we_IsAnyFuture,4*7	
			LABEL	we_SIZEOF

		STRUCTURE	WildTypes,0		
			BYTE	wy_TypeA
			BYTE	wy_TypeB
			BYTE	wy_TypeC
			BYTE	wy_TypeD
			BYTE	wy_TypeE
			BYTE	wy_TypeF
			BYTE	wy_TypeG
			BYTE	wy_TypeH
			LABEL	wy_SIZEOF		

		STRUCTURE	WildApp,MLN_SIZE
			APTR	wap_WildPort		
			APTR	wap_WildBase		
			APTR	wap_Tags		
			LONG	wap_Flags		
			APTR	wap_ChipPool
			APTR	wap_FastPool
			STRUCT	wap_Engine,we_SIZEOF	
			STRUCT	wap_EngineData,we_SIZEOF
			APTR	wap_FrameBuffer		
			APTR	wap_Scene		
			STRUCT	wap_Types,wy_SIZEOF	
			APTR	wap_AppPrefs		
			APTR	wap_ScanLineHeader	
			APTR	wap_Level		
			APTR	wap_UserData		
			LABEL	wap_SIZEOF

* NOTE: wap-Tags now contains ALL TAGS OF EVERYTHING! Modules,App,anything is here!

	BITDEF	WA,RefreshEngine,16			
							
	BITDEF	WA,FreeFastPool,24			
	BITDEF	WA,FreeChipPool,25			

***************************************************************************************
***	Threads definitions.							*******
***************************************************************************************

		STRUCTURE	WildThread,MLN_SIZE	
			APTR	wt_WildBase
			APTR	wt_WildPort		
			APTR	wt_WildApp		
			APTR	wt_FastPool		
			APTR	wt_ChipPool		
			WORD	wt_TimeOut		
			WORD	wt_DieCheck		
			APTR	wt_Entry		
			APTR	wt_Args			
			APTR	wt_Process		
			LABEL	wt_SIZE			

		STRUCTURE	WildMessage,MN_SIZE
			LONG	wm_Type			
			LABEL	wm_Data			

* STD Wild messages types (to his threads)

.set	WIME_Kill,'Kill'				
.set	WIME_Freeze,'Friz'				
.set	WIME_WarmUp,'Warm'				

***************************************************************************************
***	Tags for any use...							*******
***************************************************************************************

.set	WILD_TAGBASE,TAG_USER|('W'<<16)	

.set	WILD_PRIVATESTD,WILD_TAGBASE 		
.set	WILD_SIMPLESTD,WILD_TAGBASE+0x1000000	
.set	WILD_COMPLEXSTD,WILD_TAGBASE+0x2000000	
.set	WILD_OTHERSTD,WILD_TAGBASE+0x4000000	

.set	WILD_USERBASE,WILD_TAGBASE+0x8000000
.set	WILD_PRIVATEUSER,WILD_USERBASE		
.set	WILD_SIMPLEUSER,WILD_USERBASE+0x1000000	
.set	WILD_COMPLEXUSER,WILD_USERBASE+0x2000000	

* Some info:
* Simple tag means it has no pointer in his ti_Data: it's a boolean, or a value.
* Complex tag means it has a pointer to a string.
* That distinction is needed by WildPrefs, to save a normal or pointerto filetag.
* NB: COMPLEX means ONLY A NULL-TERMINATED STRING! POINTERS TO STRUCTS AND MORE
*     AREN'T PREFS HANDLED, so put them in the USER tags with no prefs support.

* Prefs support means WildPrefs can save&load (& edit with the config program)
* them transparently. So, if you want your tag to be editable, put it in the
* SIMPLEUSER if it's a value, or in COMPLEXUSER if it is a string.
* Otherwise, use the WILD_PRIVATEUSER space.

.set	definedcount,0
.macro	GTSTART		
.set	\1_count,0
.set	\1_start,\2
.endm
		
.macro	GTTAG		
.set	\2,WILD_\1STD+\1_start+\1_count
.set	\1_count,\1_count+1
.set	definedcount,definedcount+1
.endm

.macro	GTSTOP		
.set	MIN_\1_\2,WILD_\1STD+\1_start
.set	MAX_\1_\2,WILD_\1STD+\1_start+\1_count-1
.set	NUM_\1_\2,\1_count
.endm	

.macro	OTHERSTART	
	GTSTART	OTHER,\1
.endm

.macro	OTHER		
		GTTAG	OTHER,\1
.endm

.macro	OTHERSTOP	
		GTSTOP	OTHER,\1
.endm

.macro	PRIVATESTART	
		GTSTART	PRIVATE,\1
.endm

.macro	PRIVATE		
		GTTAG	PRIVATE,\1
.endm

.macro	PRIVATESTOP	
		GTSTOP	PRIVATE,\1
.endm

.macro	SIMPLESTART	
		GTSTART	SIMPLE,\1
.endm

.macro	SIMPLE		
		GTTAG	SIMPLE,\1
.endm

.macro	SIMPLESTOP	
		GTSTOP	SIMPLE,\1
.endm

.macro	COMPLEXSTART	
		GTSTART	COMPLEX,\1
.endm

.macro	COMPLEX		
		GTTAG	COMPLEX,\1
.endm

.macro	COMPLEXSTOP	
		GTSTOP	COMPLEX,\1
.endm

.macro	ALLSTRT		
		PRIVATESTART	\1
		SIMPLESTART	\1
		COMPLEXSTART	\1
.endm

.macro	ALLSTOP		
		PRIVATESTOP	\1
		SIMPLESTOP	\1
		COMPLEXSTOP	\1
.endm

*WildApp tags

	ALLSTRT	0
	COMPLEX	WIAP_DisplayModule	
	COMPLEX	WIAP_TDCoreModule
	COMPLEX	WIAP_LightModule	
	COMPLEX	WIAP_DrawModule		
	COMPLEX	WIAP_FXModule		
	COMPLEX	WIAP_SoundModule	
	COMPLEX	WIAP_MusicModule	
	COMPLEX	WIAP_BrokerModule	
	COMPLEX	WIAP_LoaderModule	
	COMPLEX	WIAP_SaverModule	
					
					
					
					
					
	SIMPLE	WIAP_Speed		
					
					
					
	SIMPLE	WIAP_Quality		
	PRIVATE	WIAP_FastPoolPuddles	
	PRIVATE	WIAP_ChipPoolPuddles	
	PRIVATE	WIAP_FastPoolThresh	
	PRIVATE	WIAP_ChipPoolThresh	
	PRIVATE	WIAP_TypeABCD		
	PRIVATE	WIAP_TypeEFGH		
	PRIVATE	WIAP_Name		
	PRIVATE	WIAP_BaseName		
	PRIVATE	WIAP_Description	
	PRIVATE	WIAP_PrefsHandle	
	PRIVATE	WIAP_Level		
	ALLSTOP	WildApp

**1!	Note: DO NOT USE THE '.' IN THE NAME !!! And DO NOT USE MORE THAN 22 CHARS !!
*	      (that is a limitation in WildPrefs.library, used a 32 bytes char for
*	       the name, i say 22 for securty, because also the _ and .prefs is added.
*	       if needed, i can remove this limitation, but think 22 is enough!)

*Display tags

	ALLSTRT	50
	SIMPLE	WIDI_Width		
	SIMPLE	WIDI_Height		
	SIMPLE	WIDI_PixelRes		
	PRIVATE	WIDI_Screen		
					
					
					
					
					
	SIMPLE	WIDI_Depth		
					
					
					
	PRIVATE	WIDI_Palette		
	SIMPLE	WIDI_DisplayID		
					
					
	ALLSTOP	Display

* values for PixelRes
.set	PXRS_Full,1		
.set	PXRS_High,2		
.set	PXRS_Med,3		
.set	PXRS_Low,4		
.set	PXRS_Worst,5		

*TDCore tags
	ALLSTRT	100
	PRIVATE	WITD_Scene	
				
				
	SIMPLE	WITD_CutDistance	
					
	ALLSTOP	TDCore
	
.set	WILD_DEFINED,definedcount

*wildthreads tags
     OTHERSTART	1
	OTHER	WITH_Priority		
	OTHER	WITH_TimeOut		
	OTHER	WITH_Entry		
	OTHER	WITH_Args		
	OTHER	WITH_Name		
	OTHER	WITH_Stack		
     OTHERSTOP	WildThreads

*wildbuilder tags
     OTHERSTART 50
     	OTHER	WIBU_ObjectType		
     	OTHER	WIBU_BuildObject	
     	OTHER	WIBU_WildApp		
     	OTHER	WIBU_ModifyObject	
     OTHERSTOP	WildBuilder

*more generic wild tags...
     OTHERSTART	1000
     	OTHER	WILD_ModuleGroup	
     	OTHER	WILD_ModuleName
     OTHERSTOP	WildGeneric

.set	GROUP_Display,1
.set	GROUP_TDCore,2
.set	GROUP_Light,3
.set	GROUP_Draw,4
.set	GROUP_FX,5
.set	GROUP_Sound,6
.set	GROUP_Music,7
.set	GROUP_Broker,8
.set	GROUP_Loader,9
.set	GROUP_Saver,10

***************************************************************************************
***	Modules struts and types.						*******
***************************************************************************************

		STRUCTURE	WildModuleBASE,LIB_SIZE+4
			STRUCT	wm_Node,MLN_SIZE	
			APTR	wm_WildBase		
			WORD	wm_CNT			
			STRUCT	wm_Types,wy_SIZEOF
			LABEL	wm_SIZEOF

.set	TYPEA_FULLCOMPATIBLE	,	0		
.set	TYPEA_TD_STD		,	1		

.set	TYPEB_FULLCOMPATIBLE	,	0
.set	TYPEB_DI_FRIENDLYPLANAR	,	1		
.set	TYPEB_DI_CHUNKY8	,	2		
.set	TYPEB_DI_OSWINDOW	,	3		

.set	TYPEC_FULLCOMPATIBLE	,	0		
.set	TYPEC_DW_ONLYX		,	1		
.set	TYPEC_DW_SHADING	,	2		
.set	TYPEC_DW_RGBSHADING	,	3		
.set	TYPEC_DW_TEX		,	4		
.set	TYPEC_DW_SHADINGTEX	,	5		
.set	TYPEC_DW_RGBSHADINGTEX	,	6		
.set	TYPEC_DW_SCANSHADINGTEX	,	7		
.set	TYPEC_DW_SCANRGBSHADINGTEX	,	8	
* NB: Not all methods are available with the scanline: only the ones really need it, so fast and good-looking (a scanline for only X ? NEVER!)

.set	TYPED_FULLCOMPATIBLE	,	0
.set	TYPED_LI_FLATINTENSITY	,	1		
.set	TYPED_LI_FLATCOLOR	,	2		
.set	TYPED_LI_SOFTINTENSITY	,	3		

.set	TYPEE_FULLCOMPATIBLE	,	0
.set	TYPEF_FULLCOMPATIBLE	,	0
.set	TYPEG_FULLCOMPATIBLE	,	0
.set	TYPEH_FULLCOMPATIBLE	,	0

.set	TYPEH_CPU_68k		,	0
.set	TYPEH_CPU_WARPUP	,	1

* Note about the FULLCOMPATIBLE type.
* This means there are no compatibility problems for this module.
* For example, the PyperGrey32 module if TYPEC_FULLCOMPATIBLE,
* because you can use any broker, it will work, because it uses
* no broker structs, so you can (you SHOULD) obmit to use the broker.
* The FULLCOMPATIBLE type should be used by modules that use his own 
* structs, and bypasses any of the pipeline parts, so don't need
* any precalc or anything made by anyother module.
* USE WITH EXTREME CARE !
			
* Note about the wm_TypeABCD: IT'S NOT TO IDENTIFY THE Display,TDCore,Light,Sound
* or more module type: THIS IS DONE BY SEPARING THEM INTO DIFFERENT DIRS.
* IT'S TO DETERMINE THE TYPE OF MODULE, so the data structs it uses, the
* things it calcs, the maths is uses, and so.
* For example: tdcore modules of Type 1 have a certain TMPData for Points,
* for faces, for edges and more.
* This value is used to verify the correct working of an engine.
* Actually, a well working engine must have these equal types:

* TypeA: TYPEA_TD)TDCore=Light=Broker=Draw=PostFX=WApp=Extensions
* TypeB: TYPEB_DI)Draw=Display=PostFX=WApp=Extensions 
* TypeC: TYPEC_DW)Broker=Draw=PostFX=Extensions
* TypeD: TYPED_SN)Music=Sound=WApp=Extensions TYPED_LI) Light=Broker=Draw

* 1:Obviolsly,3D structs have to be the same! (also for broker,draw&more: the offsets are set by TDCore!)
* 2:More to define...
* 3:Obviously,the frame buffer type requided must be the same! (planar,chunky,..)
* 4:Broker have to interpret the light's structs: they may be different, and use color OR intensity.
* 5:Draw have to interpret Broker's struct, and PostFX may also use them, and surely have to life with Draw.
* NB: Unused TYPES MUST BE SET TO 0 !!!!!!!
*** There will also be a special type: the $ff, wich means a module full compatible.
*** Obviously, it would not be, so the user is responsible of what happens, and the
*** coder must specify what modules will be compatible to its. Useful if someone wants
*** to re-write all the pipeline, or a big part, and doesn't like all my types.
* NB2: Also WApp has his types. So, you have to use types you are sure to be possible.
* Or you have to write new modules for your types.
* NB3: wm_TypeEFGH have the same use, but now are not necessary. So, set them to fullcompatible.

***************************************************************************************
***	Extensions def								*******
***************************************************************************************

* First of all, info about extensions: they are COMPLETELY STANDALONE Libraries, the
* only thing they have to match with WILD is the TYPE checking, for compatibility
* with the engine. The LoadExtension function of wild JUST OPENS THE LIB AND CHECKS
* THE TYPE MATCHING, NO MORE !!!!!!!! And the KillExtension just CLOSES THE LIB.
* NB: The wi_Extensions WILL BE USED IN THE FUTURE, JUST TO HAVE AUTOMATIC
* CLOSE OF ALL Exts when Expugning Wild, like modules now. But not now.

		STRUCTURE	WildExtensionBASE,wm_SIZEOF
			LABEL	wx_SIZEOF

* Library base exactly the same of the modules one.

***************************************************************************************
***	Table struct and used IDS.						*******
***************************************************************************************

		STRUCTURE	WildTable,MLN_SIZE
			LONG	wt_ID			
			WORD	wt_CNT			
			LABEL	wt_Data

* NB: When using LoadTable, the returned d0 points to wt_Data direclty: you don't
* have to add wt_Data to d0 to reach the data. And when KillTable, you don't have
* to sub wt_Data to the precedent result: Wild does for you.

* Here are defined all the ids for the currently used tables.
* I define them here just to avoid the risk of double-used IDs. (32Bit! should be difficult!)

.set	WITA_COSQTOSEN		,	1	
.set	WITA_PYTREE		,	2	
.set	WITA_SINCOS1616		,	3	
		
***************************************************************************************
***	Wild possible errors 							*******
***************************************************************************************

.set	WILDERR_NOMEM,1		
.set	WILDERR_BADARGS,2	

* Read them in wi_WhyFail (in WildBase struct) after the failed call. May help to
* comprend.

***************************************************************************************
***	_LVO definitions and std macros.					*******
***************************************************************************************

.set	_LVOAddWildApp		,	-30		
.set	_LVORemWildApp		,	-36		
.set	_LVOLoadModule		,	-42		
.set	_LVOKillModule		,	-48		
.set	_LVOSetWildAppTags	,	-54		
.set	_LVOGetWildAppTags	,	-60		
.set	_LVOAddWildThread	,	-66		
.set	_LVORemWildThread	,	-72		
.set	_LVOAllocVecPooled	,	-78		
.set	_LVOFreeVecPooled	,	-84		
.set	_LVORealyzeFrame	,	-90		
.set	_LVOInitFrame		,	-96		
.set	_LVODisplayFrame	,	-102		
.set	_LVOLoadTable		,	-108		
.set	_LVOKillTable		,	-114		
.set	_LVOLoadFile		,	-120		
.set	_LVOLoadExtension	,	-126		
.set	_LVOKillExtension	,	-132		
.set	_LVOFindWildApp		,	-138		
.set	_LVOBuildWildObject	,	-144		
.set	_LVOFreeWildObject	,	-150		
		
.endif