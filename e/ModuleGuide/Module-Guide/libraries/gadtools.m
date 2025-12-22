@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/gadtools.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT lvdrawmsg
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   rastport:PTR TO rastport
@{fg shine}(   8)@{fg text}   drawinfo:PTR TO drawinfo
@{fg shine}(  12)@{fg text}   bounds:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(  20)@{fg text}   state:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

@{fg shine}(----)@{fg text} OBJECT newmenu
@{fg shine}(   0)@{fg text}   type:CHAR
@{fg shine}(   1)@{fg text}   pad:CHAR
@{fg shine}(   2)@{fg text}   label:PTR TO CHAR
@{fg shine}(   6)@{fg text}   commkey:PTR TO CHAR
@{fg shine}(  10)@{fg text}   flags:INT
@{fg shine}(  12)@{fg text}   mutualexclude:LONG
@{fg shine}(  16)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT newgadget
@{fg shine}(   0)@{fg text}   leftedge:INT
@{fg shine}(   2)@{fg text}   topedge:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   gadgettext:PTR TO CHAR
@{fg shine}(  12)@{fg text}   textattr:PTR TO textattr
@{fg shine}(  16)@{fg text}   gadgetid:INT
@{fg shine}(  18)@{fg text}   flags:LONG
@{fg shine}(  22)@{fg text}   visualinfo:LONG
@{fg shine}(  26)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=30 */

CONST GTBB_FRAMETYPE=$8008004D,
      IM_SUB=$83,
      NM_SUB=3,
      PLACETEXT_BELOW=8,
      GTMN_AMIGAKEY=$80080042,
      GTNW_ACTIVE=$8008000F,
      GTCY_ACTIVE=$8008000F,
      GTMX_ACTIVE=$8008000A,
      GTMENU_INVALID=2,
      NM_FLAGMASK_V39=$FFFFFF3D,
      NM_BARLABEL=-1,
      NG_HIGHLABEL=$20,
      GTMN_TEXTATTR=$80080031,
      PLACETEXT_ABOVE=4,
      LVR_NORMAL=0,
      GTMN_NEWLOOKMENUS=$80080043,
      NWAY_KIND=7,
      TEXT_KIND=13,
      STRING_KIND=12,
      SLIDER_KIND=11,
      SCROLLER_KIND=9,
      PALETTE_KIND=8,
      CYCLE_KIND=7,
      NUMBER_KIND=6,
      MX_KIND=5,
      LISTVIEW_KIND=4,
      INTEGER_KIND=3,
      CHECKBOX_KIND=2,
      BUTTON_KIND=1,
      GENERIC_KIND=0,
      NM_IGNORE=$40,
      GTNM_FORMAT=$8008004B,
      GTSL_LEVELFORMAT=$8008002A,
      LVR_SELECTEDDISABLED=8,
      LVR_NORMALDISABLED=2,
      NM_ITEMDISABLED=16,
      NM_MENUDISABLED=1,
      GTMENU_NOMEM=3,
      GTMN_CHECKMARK=$80080041,
      GT_UNDERSCORE=$80080040,
      GTNM_MAXNUMBERLEN=$8008004C,
      IM_ITEM=$82,
      NM_ITEM=2,
      GTSC_ARROWS=$8008003B,
      BBFT_ICONDROPBOX=3,
      GADTOOLMASK=$FFFF7FFF,
      NM_FLAGMASK=$FFFFFF39,
      GTVI_NWTAGS=$80080002,
      GT_TAGBASE=$80080000,
      GTNM_FRONTPEN=$80080048,
      GTTX_FRONTPEN=$80080048,
      GTMN_FRONTPEN=$80080032,
      GTMENU_TRIMMED=1,
      NM_END=0,
      MENU_IMAGE=$80,
      GADTOOLBIT=$8000,
      GTPA_COLORTABLE=$80080052,
      GTSL_JUSTIFICATION=$80080051,
      GTNM_JUSTIFICATION=$8008004A,
      GTTX_JUSTIFICATION=$8008004A,
      GTPA_NUMCOLORS=$80080046,
      PLACETEXT_IN=16,
      GTST_STRING=$8008002D,
      NM_COMMANDSTRING=4,
      GTTX_COPYTEXT=$8008000C,
      GTTX_TEXT=$8008000B,
      GTIN_NUMBER=$8008002F,
      GTNM_NUMBER=$8008000D,
      LV_DRAW=$202,
      GTMN_SECONDARYERROR=$8008003F,
      GTNW_LABELS=$8008000E,
      GTCY_LABELS=$8008000E,
      GTMX_LABELS=$80080009,
      GTLV_LABELS=$80080006,
      NUM_KINDS=14,
      GTBB_RECESSED=$80080033,
      GTSL_MIN=$80080026,
      NM_TITLE=1,
      GTPA_COLOR=$80080011,
      GT_RESERVED0=$80080037,
      LVCB_UNKNOWN=1,
      GT_RESERVED1=$80080038,
      GTMN_FULLMENU=$8008003E,
      GTMN_MENU=$8008003C,
      GTNM_BACKPEN=$80080049,
      GTTX_BACKPEN=$80080049,
      GTNM_CLIPPED=$80080055,
      GTTX_CLIPPED=$80080055,
      GT_VISUALINFO=$80080034,
      GTMX_TITLEPLACE=$80080047,
      GTSL_DISPFUNC=$8008002C,
      GTSL_LEVELPLACE=$8008002B,
      GTSC_TOP=$80080015,
      GTLV_TOP=$80080005,
      GTLV_MAKEVISIBLE=$8008004E,
      GTSC_VISIBLE=$80080017,
      LVR_SELECTED=1,
      GTLV_SELECTED=$80080036,
      GTLV_SHOWSELECTED=$80080035,
      INTERHEIGHT=4,
      BBFT_BUTTON=1,
      GTJ_CENTER=2,
      GTJ_RIGHT=1,
      GTPA_INDICATORHEIGHT=$80080014,
      CHECKBOX_HEIGHT=11,
      MX_HEIGHT=9,
      PLACETEXT_RIGHT=2,
      GTSL_MAXPIXELLEN=$80080050,
      GTSL_MAXLEVELLEN=$80080029,
      GTMX_SCALED=$80080045,
      GTCB_SCALED=$80080044,
      GTJ_LEFT=0,
      GTIN_MAXCHARS=$80080030,
      GTST_MAXCHARS=$8008002E,
      PLACETEXT_LEFT=1,
      GTLV_READONLY=$80080007,
      GTCB_CHECKED=$80080004,
      GT_PRIVATE0=$80080003,
      GTSC_TOTAL=$80080016,
      LVCB_OK=0,
      GTPA_COLOROFFSET=$80080012,
      GTPA_DEPTH=$80080010,
      GTMX_SPACING=$8008003D,
      GTIN_EDITHOOK=$80080037,
      GTST_EDITHOOK=$80080037,
      GTVI_NEWWINDOW=$80080001,
      INTERWIDTH=8,
      BBFT_RIDGE=2,
      GTPA_INDICATORWIDTH=$80080013,
      GTLV_SCROLLWIDTH=$80080008,
      CHECKBOX_WIDTH=26,
      MX_WIDTH=17,
      GTSC_OVERLAP=$80080018,
      NWAYIDCMP=$40,
      GTSL_MAX=$80080027,
      TEXTIDCMP=0,
      STRINGIDCMP=$40,
      SLIDERIDCMP=$70,
      SCROLLERIDCMP=$70,
      PALETTEIDCMP=$40,
      CYCLEIDCMP=$40,
      NUMBERIDCMP=0,
      MXIDCMP=$20,
      LISTVIEWIDCMP=$400078,
      INTEGERIDCMP=$40,
      CHECKBOXIDCMP=$40,
      BUTTONIDCMP=$40,
      ARROWIDCMP=$400068,
      GTNM_BORDER=$8008003A,
      GTTX_BORDER=$80080039,
      GTSL_LEVEL=$80080028

#define MENU_USERDATA/1
#define GTMENUITEM_USERDATA/1
#define GTMENU_USERDATA/1
@endnode
