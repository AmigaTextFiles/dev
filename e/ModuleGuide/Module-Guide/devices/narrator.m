@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/narrator.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT mrb
@{fg shine}(   0)@{fg text}   ndi:ndi @{fg shine}(or ARRAY OF ndi)@{fg text}
@{fg shine}(  88)@{fg text}   width:CHAR
@{fg shine}(  89)@{fg text}   height:CHAR
@{fg shine}(  90)@{fg text}   shape:CHAR
@{fg shine}(  91)@{fg text}   sync:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=92 */

@{fg shine}(----)@{fg text} OBJECT ndi
@{fg shine}(   0)@{fg text}   iostd:iostd @{fg shine}(or ARRAY OF iostd)@{fg text}
@{fg shine}(  48)@{fg text}   rate:INT
@{fg shine}(  50)@{fg text}   pitch:INT
@{fg shine}(  52)@{fg text}   mode:INT
@{fg shine}(  54)@{fg text}   sex:INT
@{fg shine}(  56)@{fg text}   chmasks:PTR TO CHAR
@{fg shine}(  60)@{fg text}   nummasks:INT
@{fg shine}(  62)@{fg text}   volume:INT
@{fg shine}(  64)@{fg text}   sampfreq:INT
@{fg shine}(  66)@{fg text}   mouths:CHAR
@{fg shine}(  67)@{fg text}   chanmask:CHAR
@{fg shine}(  68)@{fg text}   numchan:CHAR
@{fg shine}(  69)@{fg text}   flags:CHAR
@{fg shine}(  70)@{fg text}   f0enthusiasm:CHAR
@{fg shine}(  71)@{fg text}   f0perturb:CHAR
@{fg shine}(  72)@{fg text}   f1adj:CHAR
@{fg shine}(  73)@{fg text}   f2adj:CHAR
@{fg shine}(  74)@{fg text}   f3adj:CHAR
@{fg shine}(  75)@{fg text}   a1adj:CHAR
@{fg shine}(  76)@{fg text}   a2adj:CHAR
@{fg shine}(  77)@{fg text}   a3adj:CHAR
@{fg shine}(  78)@{fg text}   articulate:CHAR
@{fg shine}(  79)@{fg text}   centralize:CHAR
@{fg shine}(  80)@{fg text}   centphon:PTR TO CHAR
@{fg shine}(  84)@{fg text}   avbias:CHAR
@{fg shine}(  85)@{fg text}   afbias:CHAR
@{fg shine}(  86)@{fg text}   priority:CHAR
@{fg shine}(  87)@{fg text}   pad1:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=88 */

CONST MAXPITCH=$140,
      MINPITCH=$41,
      DEFPITCH=$6E,
      MAXCENT=$64,
      MINCENT=0,
      ND_NOWRITE=-8,
      ND_UNIMPL=-7,
      DEFPRIORITY=$64,
      ND_NOMEM=-2,
      NDF_SYLSYNC=4,
      NDF_WORDSYNC=2,
      NDB_SYLSYNC=2,
      NDB_WORDSYNC=1,
      ND_CANTALLOC=-6,
      ND_NOAUDLIB=-3,
      ND_NOTUSED=-1,
      DEFF0PERT=0,
      ND_MODEERR=-24,
      ND_RATEERR=-21,
      MAXRATE=$190,
      MINRATE=$28,
      DEFRATE=$96,
      ND_MAKEBAD=-4,
      DEFCENTRAL=0,
      ND_CENTPHONERR=-28,
      ND_PHONERR=-20,
      FEMALE=1,
      MALE=0,
      ROBOTICF0=1,
      MAXFREQ=$6D60,
      MINFREQ=$1388,
      DEFFREQ=$56B8,
      DEFARTIC=$64,
      ND_SEXERR=-23,
      ND_PITCHERR=-22,
      MINVOL=0,
      ND_VOLERR=-26,
      NDF_NEWIORB=1,
      NDB_NEWIORB=0,
      DEFMODE=0,
      ND_FREQERR=-25,
      MANUALF0=2,
      NATURALF0=0,
      MAXVOL=$40,
      DEFSEX=0,
      DEFF0ENTHUS=$20,
      ND_EXPUNGED=-9,
      DEFVOL=$40,
      ND_DCENTERR=-27,
      ND_UNITERR=-5
@endnode
