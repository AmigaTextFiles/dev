@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "gadtoolsbox/forms.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST ID_GXMN=$47584D4E,
      ID_GXTX=$47585458,
      ID_GXBX=$47584258,
      ID_GXGA=$47584741,
      ID_GXWD=$47585744,
      ID_GXUI=$47585549,
      ID_MEDA=$4D454441,
      ID_ITXT=$49545854,
      ID_BBOX=$42424F58,
      ID_GADA=$47414441,
      ID_WDDA=$57444441,
      ID_GGUI=$47475549,
      ID_VERS=$56455253

@{fg shine}(----)@{fg text} OBJECT version
@{fg shine}(   0)@{fg text}   version:INT
@{fg shine}(   2)@{fg text}   flags:INT
@{fg shine}(   4)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

CONST MAXMENUTITLE=$50,
      MAXMENULABEL=$22,
      MAXSHORTCUT=2,
      MENUVERSION=0

@{fg shine}(----)@{fg text} OBJECT menudata
@{fg shine}(   0)@{fg text}   newmenu:substructure
@{fg shine}(  20)@{fg text}   title:substructure
@{fg shine}( 100)@{fg text}   label:substructure
@{fg shine}( 134)@{fg text}   shortcut:substructure
@{fg shine}( 136)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=138 */

CONST MAXTEXTLENGTH=$50,
      ITXTVERSION=0

@{fg shine}(----)@{fg text} OBJECT itextdata
@{fg shine}(   0)@{fg text}   itext:substructure
@{fg shine}(  20)@{fg text}   text:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=100 */

CONST BBOXVERSION=0

@{fg shine}(----)@{fg text} OBJECT bboxdata
@{fg shine}(   0)@{fg text}   left:INT
@{fg shine}(   2)@{fg text}   top:INT
@{fg shine}(   4)@{fg text}   width:INT
@{fg shine}(   6)@{fg text}   height:INT
@{fg shine}(   8)@{fg text}   flags:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=10 */

CONST BBF_RECESSED=1,
      BBF_DROPBOX=2,
      MAXGADGETTEXT=$50,
      MAXGADGETLABEL=$22,
      GADGETVERSION=0

@{fg shine}(----)@{fg text} OBJECT gadgetdata
@{fg shine}(   0)@{fg text}   newgadget:substructure
@{fg shine}(  30)@{fg text}   gadgettext:substructure
@{fg shine}( 110)@{fg text}   gadgetlabel:substructure
@{fg shine}( 144)@{fg text}   flags:LONG
@{fg shine}( 148)@{fg text}   kind:INT
@{fg shine}( 150)@{fg text}   numtags:INT
@{fg shine}( 152)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=168 */

CONST GDF_ISLOCKED=$20,
      GDF_NEEDLOCK=$40,
      MAXWINDOWNAME=$22,
      MAXWINDOWTITLE=$50,
      MAXWDSCREENTITLE=$50,
      WINDOWVERSION=0

@{fg shine}(----)@{fg text} OBJECT windowdata
@{fg shine}(   0)@{fg text}   name:substructure
@{fg shine}(  34)@{fg text}   title:substructure
@{fg shine}( 114)@{fg text}   screentitle:substructure
@{fg shine}( 194)@{fg text}   numtags:INT
@{fg shine}( 196)@{fg text}   idcountfrom:INT
@{fg shine}( 198)@{fg text}   idcmp:LONG
@{fg shine}( 202)@{fg text}   windowflags:LONG
@{fg shine}( 206)@{fg text}   tagflags:LONG
@{fg shine}( 210)@{fg text}   innerwidth:INT
@{fg shine}( 212)@{fg text}   innerheight:INT
@{fg shine}( 214)@{fg text}   showtitle:INT
@{fg shine}( 216)@{fg text}   mousequeue:INT
@{fg shine}( 218)@{fg text}   rptqueue:INT
@{fg shine}( 220)@{fg text}   flags:INT
@{fg shine}( 222)@{fg text}   leftborder:INT
@{fg shine}( 224)@{fg text}   topborder:INT
@{fg shine}( 226)@{fg text}   reserved:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=236 */

CONST WDF_INNERWIDTH=1,
      WDF_INNERHEIGHT=2,
      WDF_ZOOM=4,
      WDF_MOUSEQUEUE=8,
      WDF_RPTQUEUE=16,
      WDF_AUTOADJUST=$20,
      WDF_DEFAULTZOOM=$40,
      WDF_FALLBACK=$80,
      MAXSCREENTITLE=$50,
      FONTNAMELENGTH=$80,
      MAXCOLORSPEC=$21,
      MAXDRIPENS=10,
      MAXMOREDRIPENS=10,
      GUIVERSION=0

@{fg shine}(----)@{fg text} OBJECT guidata
@{fg shine}(   0)@{fg text}   flags0:LONG
@{fg shine}(   4)@{fg text}   screentitle:substructure
@{fg shine}(  84)@{fg text}   left:INT
@{fg shine}(  86)@{fg text}   top:INT
@{fg shine}(  88)@{fg text}   width:INT
@{fg shine}(  90)@{fg text}   height:INT
@{fg shine}(  92)@{fg text}   depth:INT
@{fg shine}(  94)@{fg text}   displayid:LONG
@{fg shine}(  98)@{fg text}   overscan:INT
@{fg shine}( 100)@{fg text}   dripens:substructure
@{fg shine}( 120)@{fg text}   colors:substructure
@{fg shine}( 384)@{fg text}   fontname:substructure
@{fg shine}( 512)@{fg text}   font:substructure
@{fg shine}( 520)@{fg text}   moredripens:substructure
@{fg shine}( 540)@{fg text}   reserved:substructure
@{fg shine}( 560)@{fg text}   flags1:LONG
@{fg shine}( 564)@{fg text}   stdscreenwidth:INT
@{fg shine}( 566)@{fg text}   stdscreenheight:INT
@{fg shine}( 568)@{fg text}   activekind:INT
@{fg shine}( 570)@{fg text}   lastproject:INT
@{fg shine}( 572)@{fg text}   gridx:INT
@{fg shine}( 574)@{fg text}   gridy:INT
@{fg shine}( 576)@{fg text}   offx:INT
@{fg shine}( 578)@{fg text}   offy:INT
@{fg shine}( 580)@{fg text}   reserved1:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=594 */

CONST GU0F_AUTOSCROLL=1,
      GU0F_WORKBENCH=2,
      GU0F_PUBLIC=4,
      GU0F_CUSTOM=8
@endnode
