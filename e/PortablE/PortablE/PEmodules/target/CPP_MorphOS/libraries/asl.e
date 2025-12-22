/* $VER: asl.h 45.2 (18.11.2000) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/nodes', 'target/exec/semaphores', 'target/utility/tagitem', 'target/workbench/startup', 'target/graphics/text', 'target/graphics/displayinfo'
{#include <libraries/asl.h>}
NATIVE {LIBRARIES_ASL_H} CONST

NATIVE {AslName} CONST
#define ASLNAME aslname
STATIC aslname = 'asl.library'
NATIVE {ASL_TB}	CONST ASL_TB	= (TAG_USER+$80000)


/*****************************************************************************/


/* Types of requesters known to ASL, used as arguments to AllocAslRequest() */
NATIVE {ASL_FileRequest}	      CONST ASL_FILEREQUEST	      = 0
NATIVE {ASL_FontRequest}	      CONST ASL_FONTREQUEST	      = 1
NATIVE {ASL_ScreenModeRequest} CONST ASL_SCREENMODEREQUEST = 2


/*****************************************************************************
 *
 * ASL File Requester data structures and constants
 *
 * This structure must only be allocated by asl.library amd is READ-ONLY!
 * Control of the various fields is provided via tags when the requester
 * is created with AllocAslRequest() and when it is displayed via
 * AslRequest()
 */
NATIVE {FileRequester} OBJECT filerequester
    {fr_Reserved0}	reserved0[4]	:ARRAY OF UBYTE
    {fr_File}	file	:/*STRPTR*/ ARRAY OF CHAR	      /* Contents of File gadget on exit    */
    {fr_Drawer}	drawer	:/*STRPTR*/ ARRAY OF CHAR	      /* Contents of Drawer gadget on exit  */
    {fr_Reserved1}	reserved1[10]	:ARRAY OF UBYTE
    {fr_LeftEdge}	leftedge	:INT	      /* Coordinates of requester on exit   */
    {fr_TopEdge}	topedge	:INT
    {fr_Width}	width	:INT
    {fr_Height}	height	:INT
    {fr_Reserved2}	reserved2[2]	:ARRAY OF UBYTE
    {fr_NumArgs}	numargs	:VALUE	      /* Number of files selected	    */
    {fr_ArgList}	arglist	:ARRAY OF wbarg	      /* List of files selected	    */
    {fr_UserData}	userdata	:APTR	      /* You can store your own data here   */
    {fr_Reserved3}	reserved3[8]	:ARRAY OF UBYTE
    {fr_Pattern}	pattern	:/*STRPTR*/ ARRAY OF CHAR	      /* Contents of Pattern gadget on exit */
ENDOBJECT

/* File requester tag values, used by AllocAslRequest() and AslRequest() */

/* Window control */
NATIVE {ASLFR_Window}	      CONST ASLFR_WINDOW	      = ASL_TB+2	 /* Parent window		     */
NATIVE {ASLFR_Screen}	      CONST ASLFR_SCREEN	      = ASL_TB+40  /* Screen to open on if no window   */
NATIVE {ASLFR_PubScreenName}   CONST ASLFR_PUBSCREENNAME   = ASL_TB+41  /* Name of public screen	     */
NATIVE {ASLFR_PrivateIDCMP}    CONST ASLFR_PRIVATEIDCMP    = ASL_TB+42  /* Allocate private IDCMP?	     */
NATIVE {ASLFR_IntuiMsgFunc}    CONST ASLFR_INTUIMSGFUNC    = ASL_TB+70  /* Function to handle IntuiMessages */
NATIVE {ASLFR_SleepWindow}     CONST ASLFR_SLEEPWINDOW     = ASL_TB+43  /* Block input in ASLFR_Window?     */
NATIVE {ASLFR_UserData}	      CONST ASLFR_USERDATA	      = ASL_TB+52  /* What to put in fr_UserData	     */
NATIVE {ASLFR_PopToFront}      CONST ASLFR_POPTOFRONT      = ASL_TB+131 /* Make the requester window visible
                                          * when it opens (V44)
                                          */
NATIVE {ASLFR_Activate}        CONST ASLFR_ACTIVATE        = ASL_TB+132 /* Activate the requester window when
                                          * it opens (V45).
                                          */
/* Text display */
NATIVE {ASLFR_TextAttr}	      CONST ASLFR_TEXTATTR	      = ASL_TB+51  /* Text font to use for gadget text */
NATIVE {ASLFR_Locale}	      CONST ASLFR_LOCALE	      = ASL_TB+50  /* Locale ASL should use for text   */
NATIVE {ASLFR_TitleText}       CONST ASLFR_TITLETEXT       = ASL_TB+1	 /* Title of requester		     */
NATIVE {ASLFR_PositiveText}    CONST ASLFR_POSITIVETEXT    = ASL_TB+18  /* Positive gadget text	     */
NATIVE {ASLFR_NegativeText}    CONST ASLFR_NEGATIVETEXT    = ASL_TB+19  /* Negative gadget text	     */

/* Initial settings */
NATIVE {ASLFR_InitialLeftEdge} CONST ASLFR_INITIALLEFTEDGE = ASL_TB+3	 /* Initial requester coordinates    */
NATIVE {ASLFR_InitialTopEdge}  CONST ASLFR_INITIALTOPEDGE  = ASL_TB+4
NATIVE {ASLFR_InitialWidth}    CONST ASLFR_INITIALWIDTH    = ASL_TB+5	 /* Initial requester dimensions     */
NATIVE {ASLFR_InitialHeight}   CONST ASLFR_INITIALHEIGHT   = ASL_TB+6
NATIVE {ASLFR_InitialFile}     CONST ASLFR_INITIALFILE     = ASL_TB+8	 /* Initial contents of File gadget  */
NATIVE {ASLFR_InitialDrawer}   CONST ASLFR_INITIALDRAWER   = ASL_TB+9	 /* Initial contents of Drawer gadg. */
NATIVE {ASLFR_InitialPattern}  CONST ASLFR_INITIALPATTERN  = ASL_TB+10  /* Initial contents of Pattern gadg.*/
NATIVE {ASLFR_InitialShowVolumes} CONST ASLFR_INITIALSHOWVOLUMES = ASL_TB+130 /* Initially, show the volume list (V44) */

/* Options */
NATIVE {ASLFR_Flags1}	      CONST ASLFR_FLAGS1	      = ASL_TB+20  /* Option flags		     */
NATIVE {ASLFR_Flags2}	      CONST ASLFR_FLAGS2	      = ASL_TB+22  /* Additional option flags	     */
NATIVE {ASLFR_DoSaveMode}      CONST ASLFR_DOSAVEMODE      = ASL_TB+44  /* Being used for saving?	     */
NATIVE {ASLFR_DoMultiSelect}   CONST ASLFR_DOMULTISELECT   = ASL_TB+45  /* Do multi-select?		     */
NATIVE {ASLFR_DoPatterns}      CONST ASLFR_DOPATTERNS      = ASL_TB+46  /* Display a Pattern gadget?	     */

/* Filtering */
NATIVE {ASLFR_DrawersOnly}     CONST ASLFR_DRAWERSONLY     = ASL_TB+47  /* Don't display files?	     */
NATIVE {ASLFR_FilterFunc}      CONST ASLFR_FILTERFUNC      = ASL_TB+49  /* Function to filter files	     */
NATIVE {ASLFR_RejectIcons}     CONST ASLFR_REJECTICONS     = ASL_TB+60  /* Display .info files?	     */
NATIVE {ASLFR_RejectPattern}   CONST ASLFR_REJECTPATTERN   = ASL_TB+61  /* Don't display files matching pat */
NATIVE {ASLFR_AcceptPattern}   CONST ASLFR_ACCEPTPATTERN   = ASL_TB+62  /* Accept only files matching pat   */
NATIVE {ASLFR_FilterDrawers}   CONST ASLFR_FILTERDRAWERS   = ASL_TB+63  /* Also filter drawers with patterns*/
NATIVE {ASLFR_HookFunc}	      CONST ASLFR_HOOKFUNC	      = ASL_TB+7	 /* Combined callback function	     */

/* Sorting */
NATIVE {ASLFR_SetSortBy}       CONST ASLFR_SETSORTBY       = ASL_TB+124 /* Sort criteria (name, date, size) */
NATIVE {ASLFR_GetSortBy}       CONST ASLFR_GETSORTBY       = ASL_TB+125
NATIVE {ASLFR_SetSortDrawers}  CONST ASLFR_SETSORTDRAWERS  = ASL_TB+126 /* Placement of drawers in the list */
NATIVE {ASLFR_GetSortDrawers}  CONST ASLFR_GETSORTDRAWERS  = ASL_TB+127
NATIVE {ASLFR_SetSortOrder}    CONST ASLFR_SETSORTORDER    = ASL_TB+128 /* Order (ascending or descending)  */
NATIVE {ASLFR_GetSortOrder}    CONST ASLFR_GETSORTORDER    = ASL_TB+129

/* Flag bits for the ASLFR_Flags1 tag */
NATIVE {FRB_FILTERFUNC}	   CONST FRB_FILTERFUNC	   = 7
NATIVE {FRB_INTUIFUNC}	   CONST FRB_INTUIFUNC	   = 6
NATIVE {FRB_DOSAVEMODE}	   CONST FRB_DOSAVEMODE	   = 5
NATIVE {FRB_PRIVATEIDCMP}   CONST FRB_PRIVATEIDCMP   = 4
NATIVE {FRB_DOMULTISELECT}  CONST FRB_DOMULTISELECT  = 3
NATIVE {FRB_DOPATTERNS}	   CONST FRB_DOPATTERNS	   = 0

NATIVE {FRF_FILTERFUNC}	   CONST FRF_FILTERFUNC	   = $80
NATIVE {FRF_INTUIFUNC}	   CONST FRF_INTUIFUNC	   = $40
NATIVE {FRF_DOSAVEMODE}	   CONST FRF_DOSAVEMODE	   = $20
NATIVE {FRF_PRIVATEIDCMP}   CONST FRF_PRIVATEIDCMP   = $10
NATIVE {FRF_DOMULTISELECT}  CONST FRF_DOMULTISELECT  = $8
NATIVE {FRF_DOPATTERNS}	   CONST FRF_DOPATTERNS	   = $1

/* Flag bits for the ASLFR_Flags2 tag */
NATIVE {FRB_DRAWERSONLY}    CONST FRB_DRAWERSONLY    = 0
NATIVE {FRB_FILTERDRAWERS}  CONST FRB_FILTERDRAWERS  = 1
NATIVE {FRB_REJECTICONS}    CONST FRB_REJECTICONS    = 2

NATIVE {FRF_DRAWERSONLY}    CONST FRF_DRAWERSONLY    = $1
NATIVE {FRF_FILTERDRAWERS}  CONST FRF_FILTERDRAWERS  = $2
NATIVE {FRF_REJECTICONS}    CONST FRF_REJECTICONS    = $4

/* Sort criteria for the ASLFR_SetSortBy/ASLFR_GetSortBy tags */
NATIVE {ASLFRSORTBY_Name}   CONST ASLFRSORTBY_NAME   = 0
NATIVE {ASLFRSORTBY_Date}   CONST ASLFRSORTBY_DATE   = 1
NATIVE {ASLFRSORTBY_Size}   CONST ASLFRSORTBY_SIZE   = 2

/* Drawer placement for the ASLFR_SetSortDrawers/ASLFR_GetSortDrawers tags */
NATIVE {ASLFRSORTDRAWERS_First}  CONST ASLFRSORTDRAWERS_FIRST  = 0
NATIVE {ASLFRSORTDRAWERS_Mix}    CONST ASLFRSORTDRAWERS_MIX    = 1
NATIVE {ASLFRSORTDRAWERS_Last}   CONST ASLFRSORTDRAWERS_LAST   = 2

/* Sort order for the ASLFR_SetSortOrder/ASLFR_GetSortOrder tags */
NATIVE {ASLFRSORTORDER_Ascend}   CONST ASLFRSORTORDER_ASCEND   = 0
NATIVE {ASLFRSORTORDER_Descend}  CONST ASLFRSORTORDER_DESCEND  = 1

/*****************************************************************************
 *
 * ASL Font Requester data structures and constants
 *
 * This structure must only be allocated by asl.library amd is READ-ONLY!
 * Control of the various fields is provided via tags when the requester
 * is created with AllocAslRequest() and when it is displayed via
 * AslRequest()
 */
NATIVE {FontRequester} OBJECT fontrequester
    {fo_Reserved0}	reserved0[8]	:ARRAY OF UBYTE
    {fo_Attr}	attr	:textattr		/* Returned TextAttr		    */
    {fo_FrontPen}	frontpen	:UBYTE	/* Returned front pen		    */
    {fo_BackPen}	backpen	:UBYTE	/* Returned back pen		    */
    {fo_DrawMode}	drawmode	:UBYTE	/* Returned drawing mode	    */
    {fo_Reserved1}	reserved1	:UBYTE
    {fo_UserData}	userdata	:APTR	/* You can store your own data here */
    {fo_LeftEdge}	leftedge	:INT	/* Coordinates of requester on exit */
    {fo_TopEdge}	topedge	:INT
    {fo_Width}	width	:INT
    {fo_Height}	height	:INT
    {fo_TAttr}	tattr	:ttextattr		/* Returned TTextAttr		    */
ENDOBJECT

/* Font requester tag values, used by AllocAslRequest() and AslRequest() */

/* Window control */
NATIVE {ASLFO_Window}	      CONST ASLFO_WINDOW	      = ASL_TB+2	 /* Parent window		     */
NATIVE {ASLFO_Screen}	      CONST ASLFO_SCREEN	      = ASL_TB+40  /* Screen to open on if no window   */
NATIVE {ASLFO_PubScreenName}   CONST ASLFO_PUBSCREENNAME   = ASL_TB+41  /* Name of public screen	     */
NATIVE {ASLFO_PrivateIDCMP}    CONST ASLFO_PRIVATEIDCMP    = ASL_TB+42  /* Allocate private IDCMP?	     */
NATIVE {ASLFO_IntuiMsgFunc}    CONST ASLFO_INTUIMSGFUNC    = ASL_TB+70  /* Function to handle IntuiMessages */
NATIVE {ASLFO_SleepWindow}     CONST ASLFO_SLEEPWINDOW     = ASL_TB+43  /* Block input in ASLFO_Window?     */
NATIVE {ASLFO_UserData}	      CONST ASLFO_USERDATA	      = ASL_TB+52  /* What to put in fo_UserData	     */
NATIVE {ASLFO_PopToFront}      CONST ASLFO_POPTOFRONT      = ASL_TB+131 /* Make the requester window visible
                                          * when it opens (V44)
                                          */
NATIVE {ASLFO_Activate}        CONST ASLFO_ACTIVATE        = ASL_TB+132 /* Activate the requester window when
                                          * it opens (V45).
                                          */

/* Text display */
NATIVE {ASLFO_TextAttr}	      CONST ASLFO_TEXTATTR	      = ASL_TB+51  /* Text font to use for gadget text */
NATIVE {ASLFO_Locale}	      CONST ASLFO_LOCALE	      = ASL_TB+50  /* Locale ASL should use for text   */
NATIVE {ASLFO_TitleText}       CONST ASLFO_TITLETEXT       = ASL_TB+1	 /* Title of requester		     */
NATIVE {ASLFO_PositiveText}    CONST ASLFO_POSITIVETEXT    = ASL_TB+18  /* Positive gadget text	     */
NATIVE {ASLFO_NegativeText}    CONST ASLFO_NEGATIVETEXT    = ASL_TB+19  /* Negative gadget text	     */

/* Initial settings */
NATIVE {ASLFO_InitialLeftEdge} CONST ASLFO_INITIALLEFTEDGE = ASL_TB+3	 /* Initial requester coordinates    */
NATIVE {ASLFO_InitialTopEdge}  CONST ASLFO_INITIALTOPEDGE  = ASL_TB+4
NATIVE {ASLFO_InitialWidth}    CONST ASLFO_INITIALWIDTH    = ASL_TB+5	 /* Initial requester dimensions     */
NATIVE {ASLFO_InitialHeight}   CONST ASLFO_INITIALHEIGHT   = ASL_TB+6
NATIVE {ASLFO_InitialName}     CONST ASLFO_INITIALNAME     = ASL_TB+10  /* Initial contents of Name gadget  */
NATIVE {ASLFO_InitialSize}     CONST ASLFO_INITIALSIZE     = ASL_TB+11  /* Initial contents of Size gadget  */
NATIVE {ASLFO_InitialStyle}    CONST ASLFO_INITIALSTYLE    = ASL_TB+12  /* Initial font style		     */
NATIVE {ASLFO_InitialFlags}    CONST ASLFO_INITIALFLAGS    = ASL_TB+13  /* Initial font flags for TextAttr  */
NATIVE {ASLFO_InitialFrontPen} CONST ASLFO_INITIALFRONTPEN = ASL_TB+14  /* Initial front pen		     */
NATIVE {ASLFO_InitialBackPen}  CONST ASLFO_INITIALBACKPEN  = ASL_TB+15  /* Initial back pen		     */
NATIVE {ASLFO_InitialDrawMode} CONST ASLFO_INITIALDRAWMODE = ASL_TB+59  /* Initial draw mode		     */

/* Options */
NATIVE {ASLFO_Flags}	      CONST ASLFO_FLAGS	      = ASL_TB+20  /* Option flags		     */
NATIVE {ASLFO_DoFrontPen}      CONST ASLFO_DOFRONTPEN      = ASL_TB+44  /* Display Front color selector?    */
NATIVE {ASLFO_DoBackPen}       CONST ASLFO_DOBACKPEN       = ASL_TB+45  /* Display Back color selector?     */
NATIVE {ASLFO_DoStyle}	      CONST ASLFO_DOSTYLE	      = ASL_TB+46  /* Display Style checkboxes?	     */
NATIVE {ASLFO_DoDrawMode}      CONST ASLFO_DODRAWMODE      = ASL_TB+47  /* Display DrawMode cycle gadget?   */
NATIVE {ASLFO_SampleText}      CONST ASLFO_SAMPLETEXT      = ASL_TB+133 /* Text to display in font sample area (V45) */

/* Filtering */
NATIVE {ASLFO_FixedWidthOnly}  CONST ASLFO_FIXEDWIDTHONLY  = ASL_TB+48  /* Only allow fixed-width fonts?    */
NATIVE {ASLFO_MinHeight}       CONST ASLFO_MINHEIGHT       = ASL_TB+16  /* Minimum font height to display   */
NATIVE {ASLFO_MaxHeight}       CONST ASLFO_MAXHEIGHT       = ASL_TB+17  /* Maximum font height to display   */
NATIVE {ASLFO_FilterFunc}      CONST ASLFO_FILTERFUNC      = ASL_TB+49  /* Function to filter fonts	     */
NATIVE {ASLFO_HookFunc}	      CONST ASLFO_HOOKFUNC	      = ASL_TB+7	 /* Combined callback function	     */
NATIVE {ASLFO_MaxFrontPen}     CONST ASLFO_MAXFRONTPEN     = ASL_TB+66  /* Max # of colors in front palette */
NATIVE {ASLFO_MaxBackPen}      CONST ASLFO_MAXBACKPEN      = ASL_TB+67  /* Max # of colors in back palette  */

/* Custom additions */
NATIVE {ASLFO_ModeList}	      CONST ASLFO_MODELIST	      = ASL_TB+21	 /* Substitute list for drawmodes    */
NATIVE {ASLFO_FrontPens}       CONST ASLFO_FRONTPENS       = ASL_TB+64  /* Color table for front pen palette*/
NATIVE {ASLFO_BackPens}	      CONST ASLFO_BACKPENS	      = ASL_TB+65  /* Color table for back pen palette */

/* Flag bits for ASLFO_Flags tag */
NATIVE {FOB_DOFRONTPEN}	   CONST FOB_DOFRONTPEN	   = 0
NATIVE {FOB_DOBACKPEN}	   CONST FOB_DOBACKPEN	   = 1
NATIVE {FOB_DOSTYLE}	   CONST FOB_DOSTYLE	   = 2
NATIVE {FOB_DODRAWMODE}	   CONST FOB_DODRAWMODE	   = 3
NATIVE {FOB_FIXEDWIDTHONLY} CONST FOB_FIXEDWIDTHONLY = 4
NATIVE {FOB_PRIVATEIDCMP}   CONST FOB_PRIVATEIDCMP   = 5
NATIVE {FOB_INTUIFUNC}	   CONST FOB_INTUIFUNC	   = 6
NATIVE {FOB_FILTERFUNC}	   CONST FOB_FILTERFUNC	   = 7

NATIVE {FOF_DOFRONTPEN}	   CONST FOF_DOFRONTPEN	   = $1
NATIVE {FOF_DOBACKPEN}	   CONST FOF_DOBACKPEN	   = $2
NATIVE {FOF_DOSTYLE}	   CONST FOF_DOSTYLE	   = $4
NATIVE {FOF_DODRAWMODE}	   CONST FOF_DODRAWMODE	   = $8
NATIVE {FOF_FIXEDWIDTHONLY} CONST FOF_FIXEDWIDTHONLY = $10
NATIVE {FOF_PRIVATEIDCMP}   CONST FOF_PRIVATEIDCMP   = $20
NATIVE {FOF_INTUIFUNC}	   CONST FOF_INTUIFUNC	   = $40
NATIVE {FOF_FILTERFUNC}	   CONST FOF_FILTERFUNC	   = $80


/*****************************************************************************
 *
 * ASL Screen Mode Requester data structures and constants
 *
 * This structure must only be allocated by asl.library and is READ-ONLY!
 * Control of the various fields is provided via tags when the requester
 * is created with AllocAslRequest() and when it is displayed via
 * AslRequest()
 */
NATIVE {ScreenModeRequester} OBJECT screenmoderequester
    {sm_DisplayID}	displayid	:ULONG	   /* Display mode ID		       */
    {sm_DisplayWidth}	displaywidth	:ULONG	   /* Width of display in pixels       */
    {sm_DisplayHeight}	displayheight	:ULONG	   /* Height of display in pixels      */
    {sm_DisplayDepth}	displaydepth	:UINT	   /* Number of bit-planes of display  */
    {sm_OverscanType}	overscantype	:UINT	   /* Type of overscan of display      */
    {sm_AutoScroll}	autoscroll	:INT	   /* Display should auto-scroll?      */

    {sm_BitMapWidth}	bitmapwidth	:ULONG	   /* Used to create your own BitMap   */
    {sm_BitMapHeight}	bitmapheight	:ULONG

    {sm_LeftEdge}	leftedge	:INT		   /* Coordinates of requester on exit */
    {sm_TopEdge}	topedge	:INT
    {sm_Width}	width	:INT
    {sm_Height}	height	:INT

    {sm_InfoOpened}	infoopened	:INT	   /* Info window opened on exit?      */
    {sm_InfoLeftEdge}	infoleftedge	:INT	   /* Last coordinates of Info window  */
    {sm_InfoTopEdge}	infotopedge	:INT
    {sm_InfoWidth}	infowidth	:INT
    {sm_InfoHeight}	infoheight	:INT

    {sm_UserData}	userdata	:APTR		   /* You can store your own data here */
ENDOBJECT

/* An Exec list of custom modes can be added to the list of available modes.
 * The DimensionInfo structure must be completely initialized, including the
 * Header. See <graphics/displayinfo.h>. Custom mode ID's must be in the range
 * 0xFFFF0000..0xFFFFFFFF. Regular properties which apply to your custom modes
 * can be added in the dn_PropertyFlags field. Custom properties are not
 * allowed.
 */
NATIVE {DisplayMode} OBJECT displaymode
    {dm_Node}	ln	:ln	      /* see ln_Name	       */
    {dm_DimensionInfo}	dimensioninfo	:dimensioninfo    /* mode description      */
    {dm_PropertyFlags}	propertyflags	:ULONG    /* applicable properties */
ENDOBJECT

/* ScreenMode requester tag values, used by AllocAslRequest() and AslRequest() */

/* Window control */
NATIVE {ASLSM_Window}	      CONST ASLSM_WINDOW	      = ASL_TB+2	 /* Parent window		     */
NATIVE {ASLSM_Screen}	      CONST ASLSM_SCREEN	      = ASL_TB+40  /* Screen to open on if no window   */
NATIVE {ASLSM_PubScreenName}   CONST ASLSM_PUBSCREENNAME   = ASL_TB+41  /* Name of public screen	     */
NATIVE {ASLSM_PrivateIDCMP}    CONST ASLSM_PRIVATEIDCMP    = ASL_TB+42  /* Allocate private IDCMP?	     */
NATIVE {ASLSM_IntuiMsgFunc}    CONST ASLSM_INTUIMSGFUNC    = ASL_TB+70  /* Function to handle IntuiMessages */
NATIVE {ASLSM_SleepWindow}     CONST ASLSM_SLEEPWINDOW     = ASL_TB+43  /* Block input in ASLSM_Window?     */
NATIVE {ASLSM_UserData}	      CONST ASLSM_USERDATA	      = ASL_TB+52  /* What to put in sm_UserData	     */
NATIVE {ASLSM_PopToFront}      CONST ASLSM_POPTOFRONT      = ASL_TB+131 /* Make the requester window visible
                                          * when it opens (V44)
                                          */
NATIVE {ASLSM_Activate}        CONST ASLSM_ACTIVATE        = ASL_TB+132 /* Activate the requester window when
                                          * it opens (V45).
                                          */

/* Text display */
NATIVE {ASLSM_TextAttr}	      CONST ASLSM_TEXTATTR	      = ASL_TB+51  /* Text font to use for gadget text */
NATIVE {ASLSM_Locale}	      CONST ASLSM_LOCALE	      = ASL_TB+50  /* Locale ASL should use for text   */
NATIVE {ASLSM_TitleText}       CONST ASLSM_TITLETEXT       = ASL_TB+1	 /* Title of requester		     */
NATIVE {ASLSM_PositiveText}    CONST ASLSM_POSITIVETEXT    = ASL_TB+18  /* Positive gadget text	     */
NATIVE {ASLSM_NegativeText}    CONST ASLSM_NEGATIVETEXT    = ASL_TB+19  /* Negative gadget text	     */

/* Initial settings */
NATIVE {ASLSM_InitialLeftEdge} CONST ASLSM_INITIALLEFTEDGE = ASL_TB+3	 /* Initial requester coordinates    */
NATIVE {ASLSM_InitialTopEdge}  CONST ASLSM_INITIALTOPEDGE  = ASL_TB+4
NATIVE {ASLSM_InitialWidth}    CONST ASLSM_INITIALWIDTH    = ASL_TB+5	 /* Initial requester dimensions     */
NATIVE {ASLSM_InitialHeight}   CONST ASLSM_INITIALHEIGHT   = ASL_TB+6
NATIVE {ASLSM_InitialDisplayID}	   CONST ASLSM_INITIALDISPLAYID	   = ASL_TB+100 /* Initial display mode id     */
NATIVE {ASLSM_InitialDisplayWidth}  CONST ASLSM_INITIALDISPLAYWIDTH  = ASL_TB+101 /* Initial display width	     */
NATIVE {ASLSM_InitialDisplayHeight} CONST ASLSM_INITIALDISPLAYHEIGHT = ASL_TB+102 /* Initial display height      */
NATIVE {ASLSM_InitialDisplayDepth}  CONST ASLSM_INITIALDISPLAYDEPTH  = ASL_TB+103 /* Initial display depth	     */
NATIVE {ASLSM_InitialOverscanType}  CONST ASLSM_INITIALOVERSCANTYPE  = ASL_TB+104 /* Initial type of overscan    */
NATIVE {ASLSM_InitialAutoScroll}    CONST ASLSM_INITIALAUTOSCROLL    = ASL_TB+105 /* Initial autoscroll setting  */
NATIVE {ASLSM_InitialInfoOpened}    CONST ASLSM_INITIALINFOOPENED    = ASL_TB+106 /* Info wndw initially opened? */
NATIVE {ASLSM_InitialInfoLeftEdge}  CONST ASLSM_INITIALINFOLEFTEDGE  = ASL_TB+107 /* Initial Info window coords. */
NATIVE {ASLSM_InitialInfoTopEdge}   CONST ASLSM_INITIALINFOTOPEDGE   = ASL_TB+108

/* Options */
NATIVE {ASLSM_DoWidth}	      CONST ASLSM_DOWIDTH	      = ASL_TB+109  /* Display Width gadget?	     */
NATIVE {ASLSM_DoHeight}	      CONST ASLSM_DOHEIGHT	      = ASL_TB+110  /* Display Height gadget?	     */
NATIVE {ASLSM_DoDepth}	      CONST ASLSM_DODEPTH	      = ASL_TB+111  /* Display Depth gadget?	     */
NATIVE {ASLSM_DoOverscanType}  CONST ASLSM_DOOVERSCANTYPE  = ASL_TB+112  /* Display Overscan Type gadget?   */
NATIVE {ASLSM_DoAutoScroll}    CONST ASLSM_DOAUTOSCROLL    = ASL_TB+113  /* Display AutoScroll gadget?      */

/* Filtering */
NATIVE {ASLSM_PropertyFlags}   CONST ASLSM_PROPERTYFLAGS   = ASL_TB+114  /* Must have these Property flags  */
NATIVE {ASLSM_PropertyMask}    CONST ASLSM_PROPERTYMASK    = ASL_TB+115  /* Only these should be looked at  */
NATIVE {ASLSM_MinWidth}	      CONST ASLSM_MINWIDTH	      = ASL_TB+116  /* Minimum display width to allow  */
NATIVE {ASLSM_MaxWidth}	      CONST ASLSM_MAXWIDTH	      = ASL_TB+117  /* Maximum display width to allow  */
NATIVE {ASLSM_MinHeight}       CONST ASLSM_MINHEIGHT       = ASL_TB+118  /* Minimum display height to allow */
NATIVE {ASLSM_MaxHeight}       CONST ASLSM_MAXHEIGHT       = ASL_TB+119  /* Maximum display height to allow */
NATIVE {ASLSM_MinDepth}	      CONST ASLSM_MINDEPTH	      = ASL_TB+120  /* Minimum display depth	     */
NATIVE {ASLSM_MaxDepth}	      CONST ASLSM_MAXDEPTH	      = ASL_TB+121  /* Maximum display depth	     */
NATIVE {ASLSM_FilterFunc}      CONST ASLSM_FILTERFUNC      = ASL_TB+122  /* Function to filter mode id's    */

/* Custom additions */
NATIVE {ASLSM_CustomSMList}    CONST ASLSM_CUSTOMSMLIST    = ASL_TB+123  /* Exec list of struct DisplayMode */


/*****************************************************************************/

NATIVE {ASL_LAST_TAG} CONST ASL_LAST_TAG = ASL_TB+133

/*****************************************************************************/

/* This defines the rendezvous data for setting and querying asl.library's
 * defaults for the window size and the file requester sort order. The name
 * of the semaphore is given below; it exists only with asl.library V45 and
 * IPrefs V45 and beyond.
 */
NATIVE {ASL_SEMAPHORE_NAME} CONST
#define ASL_SEMAPHORE_NAME asl_semaphore_name
STATIC asl_semaphore_name = 'asl.library'

NATIVE {AslSemaphore} OBJECT aslsemaphore
	{as_Semaphore}	semaphore	:ss

	{as_Version}	version	:UINT	/* Must be >= 45 */
	{as_Size}	size	:ULONG	/* Size of this data structure. */

	{as_SortBy}	sortby	:UBYTE	/* File requester defaults; name, date or size */
	{as_SortDrawers}	sortdrawers	:UBYTE	/* File requester defaults; first, mix or last */
	{as_SortOrder}	sortorder	:UBYTE	/* File requester defaults; ascending or descending */

	{as_SizePosition}	sizeposition	:UBYTE /* See below */

	{as_RelativeLeft}	relativeleft	:INT /* Window position offset */
	{as_RelativeTop}	relativetop	:INT

	{as_RelativeWidth}	relativewidth	:UBYTE/* Window size factor; this is
						  * a percentage of the parent
						  * window/screen width.
						  */
	{as_RelativeHeight}	relativeheight	:UBYTE
ENDOBJECT

/* Default position of the ASL window. */
NATIVE {ASLPOS_DefaultPosition}	CONST ASLPOS_DEFAULTPOSITION	= 0	/* Position is calculated according to the builtin rules. */
NATIVE {ASLPOS_CenterWindow}	CONST ASLPOS_CENTERWINDOW	= 1	/* Centred within the bounds of the parent window. */
NATIVE {ASLPOS_CenterScreen}	CONST ASLPOS_CENTERSCREEN	= 2	/* Centred within the bounds of the parent screen. */
NATIVE {ASLPOS_WindowPosition}	CONST ASLPOS_WINDOWPOSITION	= 3	/* Relative to the top left corner of the parent window,
					 * using the offset values provided in the
					 * as_RelativeLeft/as_RelativeTop members.
					 */
NATIVE {ASLPOS_ScreenPosition}	CONST ASLPOS_SCREENPOSITION	= 4	/* Relative to the top left corner of the parent screen,
					 * using the offset values provided in the
					 * as_RelativeLeft/as_RelativeTop members.
					 */
NATIVE {ASLPOS_CenterMouse}	CONST ASLPOS_CENTERMOUSE	= 5	/* Directly below the mouse pointer. */
NATIVE {ASLPOS_MASK}		CONST ASLPOS_MASK		= $0F

/* Default size of the ASL window. */
NATIVE {ASLSIZE_DefaultSize}	CONST ASLSIZE_DEFAULTSIZE	= $0 /*(0<<4)*/	/* Size is calculated according to the builtin rules. */
NATIVE {ASLSIZE_RelativeSize}	CONST ASLSIZE_RELATIVESIZE	= $10	/* Size is relative to the size of the parent
					 * window or screen, using the values provided in
					 * the as_RelativeWidth/as_RelativeHeight members.
					 * The as_RelativeWidth/as_RelativeHeight values are
					 * taken as percentage, i.e. a value of "50" stands for
					 * 50% of the width/height of the parent window/screen.
					 */
NATIVE {ASLSIZE_MASK}		CONST ASLSIZE_MASK		= $30

/* Other options. */
NATIVE {ASLOPTION_ASLOverrides}	CONST ASLOPTION_ASLOVERRIDES	= $40	/* ASL determines placement and size of requester
					 * windows; application's choice is ignored.
					 */

/*****************************************************************************/

/*****************************************************************************
 *
 * Obsolete ASL definitions, here for source code compatibility only.
 * Please do NOT use in new code.
 *
 * #define ASL_V38_NAMES_ONLY to remove these older names
 */
->#ifndef ASL_V38_NAMES_ONLY
NATIVE {rf_File}		 DEF
NATIVE {rf_Dir}		 DEF
NATIVE {rf_LeftEdge}	 DEF
NATIVE {rf_TopEdge}	 DEF
NATIVE {rf_Width}	 DEF
NATIVE {rf_Height}	 DEF
NATIVE {rf_NumArgs}	 DEF
NATIVE {rf_ArgList}	 DEF
NATIVE {rf_UserData}	 DEF
NATIVE {rf_Pat}		 DEF
NATIVE {ASL_Dummy}	 CONST ASL_DUMMY	 = (TAG_USER + $80000)
NATIVE {ASL_Hail}	 CONST ASL_HAIL	 = ASL_DUMMY+1
NATIVE {ASL_Window}	 CONST ASL_WINDOW	 = ASL_DUMMY+2
NATIVE {ASL_LeftEdge}	 CONST ASL_LEFTEDGE	 = ASL_DUMMY+3
NATIVE {ASL_TopEdge}	 CONST ASL_TOPEDGE	 = ASL_DUMMY+4
NATIVE {ASL_Width}	 CONST ASL_WIDTH	 = ASL_DUMMY+5
NATIVE {ASL_Height}	 CONST ASL_HEIGHT	 = ASL_DUMMY+6
NATIVE {ASL_HookFunc}	 CONST ASL_HOOKFUNC	 = ASL_DUMMY+7
NATIVE {ASL_File}	 CONST ASL_FILE	 = ASL_DUMMY+8
NATIVE {ASL_Dir}		 CONST ASL_DIR		 = ASL_DUMMY+9
NATIVE {ASL_FontName}	 CONST ASL_FONTNAME	 = ASL_DUMMY+10
NATIVE {ASL_FontHeight}	 CONST ASL_FONTHEIGHT	 = ASL_DUMMY+11
NATIVE {ASL_FontStyles}	 CONST ASL_FONTSTYLES	 = ASL_DUMMY+12
NATIVE {ASL_FontFlags}	 CONST ASL_FONTFLAGS	 = ASL_DUMMY+13
NATIVE {ASL_FrontPen}	 CONST ASL_FRONTPEN	 = ASL_DUMMY+14
NATIVE {ASL_BackPen}	 CONST ASL_BACKPEN	 = ASL_DUMMY+15
NATIVE {ASL_MinHeight}	 CONST ASL_MINHEIGHT	 = ASL_DUMMY+16
NATIVE {ASL_MaxHeight}	 CONST ASL_MAXHEIGHT	 = ASL_DUMMY+17
NATIVE {ASL_OKText}	 CONST ASL_OKTEXT	 = ASL_DUMMY+18
NATIVE {ASL_CancelText}	 CONST ASL_CANCELTEXT	 = ASL_DUMMY+19
NATIVE {ASL_FuncFlags}	 CONST ASL_FUNCFLAGS	 = ASL_DUMMY+20
NATIVE {ASL_ModeList}	 CONST ASL_MODELIST	 = ASL_DUMMY+21
NATIVE {ASL_ExtFlags1}	 CONST ASL_EXTFLAGS1	 = ASL_DUMMY+22
NATIVE {ASL_Pattern}	 CONST ASL_PATTERN	 = ASL_FONTNAME
/* remember what I said up there? Do not use these anymore! */
NATIVE {FILB_DOWILDFUNC}	 CONST FILB_DOWILDFUNC	 = 7
NATIVE {FILB_DOMSGFUNC}	 CONST FILB_DOMSGFUNC	 = 6
NATIVE {FILB_SAVE}	 CONST FILB_SAVE	 = 5
NATIVE {FILB_NEWIDCMP}	 CONST FILB_NEWIDCMP	 = 4
NATIVE {FILB_MULTISELECT} CONST FILB_MULTISELECT = 3
NATIVE {FILB_PATGAD}	 CONST FILB_PATGAD	 = 0
NATIVE {FILF_DOWILDFUNC}	 CONST FILF_DOWILDFUNC	 = $80
NATIVE {FILF_DOMSGFUNC}	 CONST FILF_DOMSGFUNC	 = $40
NATIVE {FILF_SAVE}	 CONST FILF_SAVE	 = $20
NATIVE {FILF_NEWIDCMP}	 CONST FILF_NEWIDCMP	 = $10
NATIVE {FILF_MULTISELECT} CONST FILF_MULTISELECT = $8
NATIVE {FILF_PATGAD}	 CONST FILF_PATGAD	 = $
NATIVE {FIL1B_NOFILES}	 CONST FIL1B_NOFILES	 = 0
NATIVE {FIL1B_MATCHDIRS}	 CONST FIL1B_MATCHDIRS	 = 1
NATIVE {FIL1F_NOFILES}	 CONST FIL1F_NOFILES	 = $1
NATIVE {FIL1F_MATCHDIRS}	 CONST FIL1F_MATCHDIRS	 = $2
NATIVE {FONB_FRONTCOLOR}	CONST FONB_FRONTCOLOR	= 0
NATIVE {FONB_BACKCOLOR}	CONST FONB_BACKCOLOR	= 1
NATIVE {FONB_STYLES}	CONST FONB_STYLES	= 2
NATIVE {FONB_DRAWMODE}	CONST FONB_DRAWMODE	= 3
NATIVE {FONB_FIXEDWIDTH}	CONST FONB_FIXEDWIDTH	= 4
NATIVE {FONB_NEWIDCMP}	CONST FONB_NEWIDCMP	= 5
NATIVE {FONB_DOMSGFUNC}	CONST FONB_DOMSGFUNC	= 6
NATIVE {FONB_DOWILDFUNC}	CONST FONB_DOWILDFUNC	= 7
NATIVE {FONF_FRONTCOLOR}	CONST FONF_FRONTCOLOR	= $1
NATIVE {FONF_BACKCOLOR}	CONST FONF_BACKCOLOR	= $2
NATIVE {FONF_STYLES}	CONST FONF_STYLES	= $4
NATIVE {FONF_DRAWMODE}	CONST FONF_DRAWMODE	= $8
NATIVE {FONF_FIXEDWIDTH}	CONST FONF_FIXEDWIDTH	= $10
NATIVE {FONF_NEWIDCMP}	CONST FONF_NEWIDCMP	= $20
NATIVE {FONF_DOMSGFUNC}	CONST FONF_DOMSGFUNC	= $40
NATIVE {FONF_DOWILDFUNC}	CONST FONF_DOWILDFUNC	= $80
->#endif
