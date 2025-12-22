@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes/animationclass.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT adtstart
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   frame:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT adtframe
@{fg shine}(   0)@{fg text}   methodid:LONG
@{fg shine}(   4)@{fg text}   timestamp:LONG
@{fg shine}(   8)@{fg text}   frame:LONG
@{fg shine}(  12)@{fg text}   duration:LONG
@{fg shine}(  16)@{fg text}   bitmap:PTR TO bitmap
@{fg shine}(  20)@{fg text}   cmap:PTR TO colormap
@{fg shine}(  24)@{fg text}   sample:PTR TO CHAR
@{fg shine}(  28)@{fg text}   samplelength:LONG
@{fg shine}(  32)@{fg text}   period:LONG
@{fg shine}(  36)@{fg text}   userdata:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

@{fg shine}(----)@{fg text} OBJECT animheader
@{fg shine}(   0)@{fg text}   operation:CHAR
@{fg shine}(   1)@{fg text}   mask:CHAR
@{fg shine}(   2)@{fg text}   width:INT
@{fg shine}(   4)@{fg text}   height:INT
@{fg shine}(   6)@{fg text}   left:INT
@{fg shine}(   8)@{fg text}   top:INT
@{fg shine}(  10)@{fg text}   abstime:LONG
@{fg shine}(  14)@{fg text}   reltime:LONG
@{fg shine}(  18)@{fg text}   interleave:CHAR
@{fg shine}(  19)@{fg text}   pad0:CHAR
@{fg shine}(  20)@{fg text}   flags:LONG
@{fg shine}(  24)@{fg text}   pad[16]:ARRAY OF CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=40 */

CONST ADTA_SAMPLELENGTH=$800011F7,
      ADTA_FRAMES=$8000125C,
      ADTA_COLORTABLE2=$800010CF,
      ADTM_DUMMY=$700,
      ADTA_DUMMY=$80001258,
      ID_DLTA=$444C5441,
      ADTM_START=$703,
      ADTA_SCREEN=$800010D4,
      ADTM_PAUSE=$704,
      ADTA_MODEID=$800010C8,
      ADTA_NUMALLOC=$800010D2,
      ADTM_STOP=$705,
      ADTA_GREGS=$800010CD,
      ADTA_CREGS=$800010CC,
      ADTA_SPARSETABLE=$800010DA,
      ADTA_COLORTABLE=$800010CE,
      ADTA_REMAP=$800010D3,
      ADTA_NUMCOLORS=$800010D1,
      ID_ANHD=$414E4844,
      ADTA_VOLUME=$800011F9,
      ADTA_PERIOD=$800011F8,
      ADTA_NUMSPARSE=$800010D9,
      ID_ANIM=$414E494D,
      ADTA_FRAMEINCREMENT=$8000125F,
      ADTM_UNLOADFRAME=$702,
      ADTM_LOADFRAME=$701,
      ADTA_FRAME=$8000125D,
      ADTA_KEYFRAME=$800010CA,
      ADTA_CYCLES=$800011FA,
      ADTA_FRAMESPERSECOND=$8000125E,
      ADTA_SAMPLE=$800011F6,
      ADTA_HEIGHT=$8000125A,
      ADTM_LOCATE=$706,
      ADTA_DEPTH=$8000125B,
      ADTA_ALLOCATED=$800010D0,
      ADTA_WIDTH=$80001259,
      ADTA_COLORREGISTERS=$800010CB

#define ANIMATIONDTCLASS/0
@endnode
