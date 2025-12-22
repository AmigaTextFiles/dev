@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/reqtools.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

CONST REQTOOLSVERSION=$26,
      RTPREF_FILEREQ=0,
      RTPREF_FONTREQ=1,
      RTPREF_PALETTEREQ=2,
      RTPREF_SCREENMODEREQ=3,
      RTPREF_VOLUMEREQ=4,
      RTPREF_OTHERREQ=5,
      RTPREF_NR_OF_REQ=6

@{fg shine}(----)@{fg text} OBJECT reqdefaults
@{fg shine}(   0)@{fg text}   size:LONG
@{fg shine}(   4)@{fg text}   reqpos:LONG
@{fg shine}(   8)@{fg text}   leftoffset:INT
@{fg shine}(  10)@{fg text}   topoffset:INT
@{fg shine}(  12)@{fg text}   minentries:INT
@{fg shine}(  14)@{fg text}   maxentries:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT reqtoolsprefs
@{fg shine}(   0)@{fg text}   prefssize:LONG
@{fg shine}(   4)@{fg text}   prefssemaphore:substructure
@{fg shine}(  50)@{fg text}   flags:LONG
@{fg shine}(  54)@{fg text}   reqdefaults:substructure
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=150 */

CONST RTPREFS_SIZE=$64,
      RTPRF_DIRSFIRST=1,
      RTPRF_DIRSMIXED=2,
      RTPRF_IMMSORT=4,
      RTPRF_NOSCRTOFRONT=8,
      RTPRF_NOLED=16

@{fg shine}(----)@{fg text} OBJECT reqtoolsbase
@{fg shine}(   0)@{fg text}   lib:substructure
@{fg shine}(  34)@{fg text}   rtflags:CHAR
@{fg shine}(  35)@{fg text}   pad:substructure
@{fg shine}(  38)@{fg text}   seglist:LONG
@{fg shine}(  42)@{fg text}   intuitionbase:LONG
@{fg shine}(  46)@{fg text}   gfxbase:LONG
@{fg shine}(  50)@{fg text}   dosbase:LONG
@{fg shine}(  54)@{fg text}   gadtoolsbase:LONG
@{fg shine}(  58)@{fg text}   utilitybase:LONG
@{fg shine}(  62)@{fg text}   realopencnt:INT
@{fg shine}(  64)@{fg text}   availfontslock:INT
@{fg shine}(  66)@{fg text}   availfontsheader:LONG
@{fg shine}(  70)@{fg text}   fontsassigntype:LONG
@{fg shine}(  74)@{fg text}   fontsassignlock:LONG
@{fg shine}(  78)@{fg text}   fontsassignlist:LONG
@{fg shine}(  82)@{fg text}   reqtoolsprefs:substructure
@{fg shine}( 232)@{fg text}   prefspad:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=234 */

CONST RT_FILEREQ=0,
      RT_REQINFO=1,
      RT_FONTREQ=2,
      RT_SCREENMODEREQ=3

@{fg shine}(----)@{fg text} OBJECT rtfilerequester
@{fg shine}(   0)@{fg text}   reqpos:LONG
@{fg shine}(   4)@{fg text}   leftoffset:INT
@{fg shine}(   6)@{fg text}   topoffset:INT
@{fg shine}(   8)@{fg text}   flags:LONG
@{fg shine}(  12)@{fg text}   private1:LONG
@{fg shine}(  16)@{fg text}   dir:LONG
@{fg shine}(  20)@{fg text}   matchpat:LONG
@{fg shine}(  24)@{fg text}   defaultfont:LONG
@{fg shine}(  28)@{fg text}   waitpointer:LONG
@{fg shine}(  32)@{fg text}   lockwindow:LONG
@{fg shine}(  36)@{fg text}   shareidcmp:LONG
@{fg shine}(  40)@{fg text}   intuimsgfunc:LONG
@{fg shine}(  44)@{fg text}   reserved1:INT
@{fg shine}(  46)@{fg text}   reserved2:INT
@{fg shine}(  48)@{fg text}   reserved3:INT
@{fg shine}(  50)@{fg text}   reqheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=NONE !!! */

@{fg shine}(----)@{fg text} OBJECT rtfilelist
@{fg shine}(   0)@{fg text}   next:LONG
@{fg shine}(   4)@{fg text}   strlen:LONG
@{fg shine}(   8)@{fg text}   name:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT rtvolumeentry
@{fg shine}(   0)@{fg text}   type:LONG
@{fg shine}(   4)@{fg text}   name:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT rtfontrequester
@{fg shine}(   0)@{fg text}   reqpos:LONG
@{fg shine}(   4)@{fg text}   leftoffset:INT
@{fg shine}(   6)@{fg text}   topoffset:INT
@{fg shine}(   8)@{fg text}   flags:LONG
@{fg shine}(  12)@{fg text}   private1:LONG
@{fg shine}(  16)@{fg text}   attr:substructure
@{fg shine}(  24)@{fg text}   defaultfont:LONG
@{fg shine}(  28)@{fg text}   waitpointer:LONG
@{fg shine}(  32)@{fg text}   lockwindow:LONG
@{fg shine}(  36)@{fg text}   shareidcmp:LONG
@{fg shine}(  40)@{fg text}   intuimsgfunc:LONG
@{fg shine}(  44)@{fg text}   reserved1:INT
@{fg shine}(  46)@{fg text}   reserved2:INT
@{fg shine}(  48)@{fg text}   reserved3:INT
@{fg shine}(  50)@{fg text}   reqheight:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=NONE !!! */

@{fg shine}(----)@{fg text} OBJECT rtscreenmoderequester
@{fg shine}(   0)@{fg text}   reqpos:LONG
@{fg shine}(   4)@{fg text}   leftoffset:INT
@{fg shine}(   6)@{fg text}   topoffset:INT
@{fg shine}(   8)@{fg text}   flags:LONG
@{fg shine}(  12)@{fg text}   private1:LONG
@{fg shine}(  16)@{fg text}   displayid:LONG
@{fg shine}(  20)@{fg text}   displaywidth:INT
@{fg shine}(  22)@{fg text}   displayheight:INT
@{fg shine}(  24)@{fg text}   defaultfont:LONG
@{fg shine}(  28)@{fg text}   waitpointer:LONG
@{fg shine}(  32)@{fg text}   lockwindow:LONG
@{fg shine}(  36)@{fg text}   shareidcmp:LONG
@{fg shine}(  40)@{fg text}   intuimsgfunc:LONG
@{fg shine}(  44)@{fg text}   reserved1:INT
@{fg shine}(  46)@{fg text}   reserved2:INT
@{fg shine}(  48)@{fg text}   reserved3:INT
@{fg shine}(  50)@{fg text}   reqheight:INT
@{fg shine}(  52)@{fg text}   displaydepth:INT
@{fg shine}(  54)@{fg text}   overscantype:INT
@{fg shine}(  56)@{fg text}   autoscroll:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=NONE !!! */

@{fg shine}(----)@{fg text} OBJECT rtreqinfo
@{fg shine}(   0)@{fg text}   reqpos:LONG
@{fg shine}(   4)@{fg text}   leftoffset:INT
@{fg shine}(   6)@{fg text}   topoffset:INT
@{fg shine}(   8)@{fg text}   width:LONG
@{fg shine}(  12)@{fg text}   reqtitle:LONG
@{fg shine}(  16)@{fg text}   flags:LONG
@{fg shine}(  20)@{fg text}   defaultfont:LONG
@{fg shine}(  24)@{fg text}   waitpointer:LONG
@{fg shine}(  28)@{fg text}   lockwindow:LONG
@{fg shine}(  32)@{fg text}   shareidcmp:LONG
@{fg shine}(  36)@{fg text}   intuimsgfunc:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=NONE !!! */

@{fg shine}(----)@{fg text} OBJECT rthandlerinfo
@{fg shine}(   4)@{fg text}   waitmask:LONG
@{fg shine}(   8)@{fg text}   donotwait:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=NONE !!! */

CONST CALL_HANDLER=$80000000,
      RT_TAGBASE=$80000000,
      RT_WINDOW=$80000001,
      RT_IDCMPFLAGS=$80000002,
      RT_REQPOS=$80000003,
      RT_LEFTOFFSET=$80000004,
      RT_TOPOFFSET=$80000005,
      RT_PUBSCRNAME=$80000006,
      RT_SCREEN=$80000007,
      RT_REQHANDLER=$80000008,
      RT_DEFAULTFONT=$80000009,
      RT_WAITPOINTER=$8000000A,
      RT_UNDERSCORE=$8000000B,
      RT_SHAREIDCMP=$8000000C,
      RT_LOCKWINDOW=$8000000D,
      RT_SCREENTOFRONT=$8000000E,
      RT_TEXTATTR=$8000000F,
      RT_INTUIMSGFUNC=$80000010,
      RT_LOCALE=$80000011,
      RTEZ_REQTITLE=$80000014,
      RTEZ_FLAGS=$80000016,
      RTEZ_DEFAULTRESPONSE=$80000017,
      RTGL_MIN=$8000001E,
      RTGL_MAX=$8000001F,
      RTGL_WIDTH=$80000020,
      RTGL_SHOWDEFAULT=$80000021,
      RTGL_GADFMT=$80000022,
      RTGL_GADFMTARGS=$80000023,
      RTGL_INVISIBLE=$80000024,
      RTGL_BACKFILL=$80000025,
      RTGL_TEXTFMT=$80000026,
      RTGL_TEXTFMTARGS=$80000027,
      RTGL_CENTERTEXT=$80000064,
      RTGL_FLAGS=$80000016,
      RTGS_WIDTH=$80000020,
      RTGS_ALLOWEMPTY=$80000050,
      RTGS_GADFMT=$80000022,
      RTGS_GADFMTARGS=$80000023,
      RTGS_INVISIBLE=$80000024,
      RTGS_BACKFILL=$80000025,
      RTGS_TEXTFMT=$80000026,
      RTGS_TEXTFMTARGS=$80000027,
      RTGS_CENTERTEXT=$80000064,
      RTGS_FLAGS=$80000016,
      RTFI_FLAGS=$80000028,
      RTFI_HEIGHT=$80000029,
      RTFI_OKTEXT=$8000002A,
      RTFI_VOLUMEREQUEST=$8000002B,
      RTFI_FILTERFUNC=$8000002C,
      RTFI_ALLOWEMPTY=$8000002D,
      RTFO_FLAGS=$80000028,
      RTFO_HEIGHT=$80000029,
      RTFO_OKTEXT=$8000002A,
      RTFO_SAMPLEHEIGHT=$8000003C,
      RTFO_MINHEIGHT=$8000003D,
      RTFO_MAXHEIGHT=$8000003E,
      RTFO_FILTERFUNC=$8000002C,
      RTSC_FLAGS=$80000028,
      RTSC_HEIGHT=$80000029,
      RTSC_OKTEXT=$8000002A,
      RTSC_PROPERTYFLAGS=$8000005A,
      RTSC_PROPERTYMASK=$8000005B,
      RTSC_MINWIDTH=$8000005C,
      RTSC_MAXWIDTH=$8000005D,
      RTSC_MINHEIGHT=$8000005E,
      RTSC_MAXHEIGHT=$8000005F,
      RTSC_MINDEPTH=$80000060,
      RTSC_MAXDEPTH=$80000061,
      RTSC_FILTERFUNC=$8000002C,
      RTFI_DIR=$80000032,
      RTFI_MATCHPAT=$80000033,
      RTFI_ADDENTRY=$80000034,
      RTFI_REMOVEENTRY=$80000035,
      RTFO_FONTNAME=$8000003F,
      RTFO_FONTHEIGHT=$80000040,
      RTFO_FONTSTYLE=$80000041,
      RTFO_FONTFLAGS=$80000042,
      RTSC_MODEFROMSCREEN=$80000050,
      RTSC_DISPLAYID=$80000051,
      RTSC_DISPLAYWIDTH=$80000052,
      RTSC_DISPLAYHEIGHT=$80000053,
      RTSC_DISPLAYDEPTH=$80000054,
      RTSC_OVERSCANTYPE=$80000055,
      RTSC_AUTOSCROLL=$80000056,
      RTPA_COLOR=$80000046,
      RTRH_ENDREQUEST=$8000003C,
      REQPOS_POINTER=0,
      REQPOS_CENTERWIN=1,
      REQPOS_CENTERSCR=2,
      REQPOS_TOPLEFTWIN=3,
      REQPOS_TOPLEFTSCR=4,
      REQ_CANCEL=0,
      REQ_OK=1,
      FREQF_NOBUFFER=4,
      FREQF_MULTISELECT=1,
      FREQF_SAVE=2,
      FREQF_NOFILES=8,
      FREQF_PATGAD=16,
      FREQF_SELECTDIRS=$1000,
      FREQF_FIXEDWIDTH=$20,
      FREQF_COLORFONTS=$40,
      FREQF_CHANGEPALETTE=$80,
      FREQF_LEAVEPALETTE=$100,
      FREQF_SCALE=$200,
      FREQF_STYLE=$400,
      SCREQF_SIZEGADS=$2000,
      SCREQF_DEPTHGAD=$4000,
      SCREQF_NONSTDMODES=$8000,
      SCREQF_GUIMODES=$10000,
      SCREQF_AUTOSCROLLGAD=$40000,
      SCREQF_OVERSCANGAD=$80000,
      EZREQF_NORETURNKEY=1,
      EZREQF_LAMIGAQUAL=2,
      EZREQF_CENTERTEXT=4,
      GLREQF_CENTERTEXT=4,
      GLREQF_HIGHLIGHTTEXT=8,
      GSREQF_CENTERTEXT=4,
      GSREQF_HIGHLIGHTTEXT=8,
      VREQF_NOASSIGNS=1,
      VREQF_NODISKS=2,
      VREQF_ALLDISKS=4,
      RTFI_HOOK=12,
      RTFO_HOOK=12,
      REQHOOK_WILDFILE=0,
      REQHOOK_WILDFONT=1,
      FREQF_DOWILDFUNC=$800
@endnode
