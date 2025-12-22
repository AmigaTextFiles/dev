@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/gameport.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT gameporttrigger
@{fg shine}(   0)@{fg text}   keys:INT
@{fg shine}(   2)@{fg text}   timeout:INT
@{fg shine}(   4)@{fg text}   xdelta:INT
@{fg shine}(   6)@{fg text}   ydelta:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST GPDERR_SETCTYPE=1,
      GPD_SETCTYPE=11,
      GPD_ASKCTYPE=10,
      GPD_READEVENT=9,
      GPCT_MOUSE=1,
      GPTF_UPKEYS=2,
      GPTB_UPKEYS=1,
      GPTF_DOWNKEYS=1,
      GPTB_DOWNKEYS=0,
      GPD_SETTRIGGER=13,
      GPD_ASKTRIGGER=12,
      GPCT_ABSJOYSTICK=3,
      GPCT_RELJOYSTICK=2,
      GPCT_NOCONTROLLER=0,
      GPCT_ALLOCATED=-1
@endnode
