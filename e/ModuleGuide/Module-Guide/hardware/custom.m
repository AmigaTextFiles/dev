@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "hardware/custom.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT custom
@{fg shine}(   0)@{fg text}   bltdat:INT
@{fg shine}(   2)@{fg text}   dmaconr:INT
@{fg shine}(   4)@{fg text}   vposr:INT
@{fg shine}(   6)@{fg text}   vhposr:INT
@{fg shine}(   8)@{fg text}   dskdatr:INT
@{fg shine}(  10)@{fg text}   joy0dat:INT
@{fg shine}(  12)@{fg text}   joy1dat:INT
@{fg shine}(  14)@{fg text}   clxdat:INT
@{fg shine}(  16)@{fg text}   adkconr:INT
@{fg shine}(  18)@{fg text}   pot0dat:INT
@{fg shine}(  20)@{fg text}   pot1dat:INT
@{fg shine}(  22)@{fg text}   potinp:INT
@{fg shine}(  24)@{fg text}   serdatr:INT
@{fg shine}(  26)@{fg text}   dskbytr:INT
@{fg shine}(  28)@{fg text}   intenar:INT
@{fg shine}(  30)@{fg text}   intreqr:INT
@{fg shine}(  32)@{fg text}   dskpt:LONG
@{fg shine}(  36)@{fg text}   dsklen:INT
@{fg shine}(  38)@{fg text}   dskdat:INT
@{fg shine}(  40)@{fg text}   refptr:INT
@{fg shine}(  42)@{fg text}   vposw:INT
@{fg shine}(  44)@{fg text}   vhposw:INT
@{fg shine}(  46)@{fg text}   copcon:INT
@{fg shine}(  48)@{fg text}   serdat:INT
@{fg shine}(  50)@{fg text}   serper:INT
@{fg shine}(  52)@{fg text}   potgo:INT
@{fg shine}(  54)@{fg text}   joytest:INT
@{fg shine}(  56)@{fg text}   strequ:INT
@{fg shine}(  58)@{fg text}   strvbl:INT
@{fg shine}(  60)@{fg text}   strhor:INT
@{fg shine}(  62)@{fg text}   strlong:INT
@{fg shine}(  64)@{fg text}   bltcon0:INT
@{fg shine}(  66)@{fg text}   bltcon1:INT
@{fg shine}(  68)@{fg text}   bltafwm:INT
@{fg shine}(  70)@{fg text}   bltalwm:INT
@{fg shine}(  72)@{fg text}   bltcpt:LONG
@{fg shine}(  76)@{fg text}   bltbpt:LONG
@{fg shine}(  80)@{fg text}   bltapt:LONG
@{fg shine}(  84)@{fg text}   bltdpt:LONG
@{fg shine}(  88)@{fg text}   bltsize:INT
@{fg shine}(  90)@{fg text}   pad2d:CHAR
@{fg shine}(  91)@{fg text}   bltcon0l:CHAR
@{fg shine}(  92)@{fg text}   bltsizv:INT
@{fg shine}(  94)@{fg text}   bltsizh:INT
@{fg shine}(  96)@{fg text}   bltcmod:INT
@{fg shine}(  98)@{fg text}   bltbmod:INT
@{fg shine}( 100)@{fg text}   bltamod:INT
@{fg shine}( 102)@{fg text}   bltdmod:INT
@{fg shine}( 104)@{fg text}   pad34[4]:ARRAY OF INT
@{fg shine}( 112)@{fg text}   bltcdat:INT
@{fg shine}( 114)@{fg text}   bltbdat:INT
@{fg shine}( 116)@{fg text}   bltadat:INT
@{fg shine}( 118)@{fg text}   pad3b[3]:ARRAY OF INT
@{fg shine}( 124)@{fg text}   deniseid:INT
@{fg shine}( 126)@{fg text}   dsksync:INT
@{fg shine}( 128)@{fg text}   cop1lc:LONG
@{fg shine}( 132)@{fg text}   cop2lc:LONG
@{fg shine}( 136)@{fg text}   copjmp1:INT
@{fg shine}( 138)@{fg text}   copjmp2:INT
@{fg shine}( 140)@{fg text}   copins:INT
@{fg shine}( 142)@{fg text}   diwstrt:INT
@{fg shine}( 144)@{fg text}   diwstop:INT
@{fg shine}( 146)@{fg text}   ddfstrt:INT
@{fg shine}( 148)@{fg text}   ddfstop:INT
@{fg shine}( 150)@{fg text}   dmacon:INT
@{fg shine}( 152)@{fg text}   clxcon:INT
@{fg shine}( 154)@{fg text}   intena:INT
@{fg shine}( 156)@{fg text}   intreq:INT
@{fg shine}( 158)@{fg text}   adkcon:INT
@{fg shine}( 160)@{fg text}   aud:audchannel @{fg shine}(or ARRAY OF audchannel)@{fg text}
@{fg shine}( 224)@{fg text}   bplpt[8]:ARRAY OF LONG
@{fg shine}( 256)@{fg text}   bplcon0:INT
@{fg shine}( 258)@{fg text}   bplcon1:INT
@{fg shine}( 260)@{fg text}   bplcon2:INT
@{fg shine}( 262)@{fg text}   bplcon3:INT
@{fg shine}( 264)@{fg text}   bpl1mod:INT
@{fg shine}( 266)@{fg text}   bpl2mod:INT
@{fg shine}( 268)@{fg text}   bplcon4:INT
@{fg shine}( 270)@{fg text}   clxcon2:INT
@{fg shine}( 272)@{fg text}   bpldat[8]:ARRAY OF INT
@{fg shine}( 288)@{fg text}   sprpt[8]:ARRAY OF LONG
@{fg shine}( 320)@{fg text}   spr:spritedef @{fg shine}(or ARRAY OF spritedef)@{fg text}
@{fg shine}( 384)@{fg text}   color[32]:ARRAY OF INT
@{fg shine}( 448)@{fg text}   htotal:INT
@{fg shine}( 450)@{fg text}   hsstop:INT
@{fg shine}( 452)@{fg text}   hbstrt:INT
@{fg shine}( 454)@{fg text}   hbstop:INT
@{fg shine}( 456)@{fg text}   vtotal:INT
@{fg shine}( 458)@{fg text}   vsstop:INT
@{fg shine}( 460)@{fg text}   vbstrt:INT
@{fg shine}( 462)@{fg text}   vbstop:INT
@{fg shine}( 464)@{fg text}   sprhstrt:INT
@{fg shine}( 466)@{fg text}   sprhstop:INT
@{fg shine}( 468)@{fg text}   bplhstrt:INT
@{fg shine}( 470)@{fg text}   bplhstop:INT
@{fg shine}( 472)@{fg text}   hhposw:INT
@{fg shine}( 474)@{fg text}   hhposr:INT
@{fg shine}( 476)@{fg text}   beamcon0:INT
@{fg shine}( 478)@{fg text}   hsstrt:INT
@{fg shine}( 480)@{fg text}   vsstrt:INT
@{fg shine}( 482)@{fg text}   hcenter:INT
@{fg shine}( 484)@{fg text}   diwhigh:INT
@{fg shine}( 486)@{fg text}   padf3[11]:ARRAY OF INT
@{fg shine}( 508)@{fg text}   fmode:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=510 */

@{fg shine}(----)@{fg text} OBJECT spritedef
@{fg shine}(   0)@{fg text}   pos:INT
@{fg shine}(   2)@{fg text}   ctl:INT
@{fg shine}(   4)@{fg text}   dataa:INT
@{fg shine}(   6)@{fg text}   datab:INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT audchannel
@{fg shine}(   0)@{fg text}   ptr:PTR TO INT
@{fg shine}(   4)@{fg text}   len:INT
@{fg shine}(   6)@{fg text}   per:INT
@{fg shine}(   8)@{fg text}   vol:INT
@{fg shine}(  10)@{fg text}   dat:INT
@{fg shine}(  12)@{fg text}   pad[2]:ARRAY OF INT
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

CONST BLTSIZV=$5C,
      JOYTEST=$36,
      DISPLAYPAL=$20,
      AC_VOL=8,
      BLTCDAT=$70,
      DISPLAYDUAL=$40,
      INTREQR=30,
      BPLCON3_EXTBLKZD=2,
      STREQU=$38,
      HHPOSR=$1DA,
      VHPOSR=6,
      VPOSR=4,
      CLXDAT=14,
      HHPOSW=$1D8,
      VHPOSW=$2C,
      VPOSW=$2A,
      SPR=$140,
      BLTALWM=$46,
      BPLDAT=$110,
      BLTBPT=$4C,
      DSKSYNC=$7E,
      VARCSYNC=16,
      VARHSYNC=$100,
      VARVSYNC=$200,
      BLTADAT=$74,
      POT1DAT=20,
      JOY1DAT=12,
      BPLPT=$E0,
      POTGO=$34,
      AC_PER=6,
      SERDATR=24,
      DSKDATR=8,
      CSBLANK=8,
      VARVBLANK=$1000,
      DSKPT=$20,
      REFPTR=$28,
      POTINP=22,
      BLTAFWM=$44,
      BPLHSTOP=$1D6,
      SPRHSTOP=$1D2,
      VBSTOP=$1CE,
      VSSTOP=$1CA,
      HBSTOP=$1C6,
      HSSTOP=$1C2,
      DDFSTOP=$94,
      DIWSTOP=$90,
      COP1LC=$80,
      BLTCMOD=$60,
      STRHOR=$3C,
      DSKDAT=$26,
      INTENA=$9A,
      BLTCPT=$48,
      AC_PTR=0,
      AC_DAT=10,
      COPJMP1=$88,
      COPJMP2=$8A,
      COPCON=$2E,
      BPLCON3_BRDNTRAN=16,
      CUSTOMADDR=$DFF000,
      BLTDDAT=0,
      BPLCON2_ZDBPEN=$800,
      SERPER=$32,
      BPL1MOD=$108,
      BLTAMOD=$64,
      COP2LC=$84,
      STRVBL=$3A,
      COLOR=$180,
      SD_DATAA=4,
      DSKBYTR=26,
      SD_DATAB=6,
      DIWHIGH=$1E4,
      BEAMCON0=$1DC,
      BPLCON0=$100,
      BLTCON0=$40,
      INTENAR=28,
      SD_CTL=2,
      BPLCON1=$102,
      BLTCON1=$42,
      CLXCON2=$10E,
      BPLCON2=$104,
      BPLCON3=$106,
      BLTDPT=$54,
      USE_BPLCON3=1,
      BPLCON4=$10C,
      AUD=$A0,
      BLTBDAT=$72,
      SERDAT=$30,
      COPINS=$8C,
      BPLCON3_BRDNBLNK=$20,
      FMODE=$1FC,
      HCENTER=$1E2,
      CLXCON=$98,
      INTREQ=$9C,
      BPLCON2_ZDCTEN=$400,
      BLTDMOD=$66,
      ADKCONR=16,
      DMACONR=2,
      VSSTRT=$1E0,
      HSSTRT=$1DE,
      BPLHSTRT=$1D4,
      SPRHSTRT=$1D0,
      VBSTRT=$1CC,
      HBSTRT=$1C4,
      DDFSTRT=$92,
      DIWSTRT=$8E,
      BPLCON3_EXTBLNKEN=1,
      CSCBLANKEN=$400,
      LOLDIS=$800,
      VTOTAL=$1C8,
      HTOTAL=$1C0,
      DENISEID=$7C,
      BLTCON0L=$5B,
      SD_POS=0,
      STRLONG=$3E,
      POT0DAT=18,
      JOY0DAT=10,
      VARBEAM=$80,
      DMACON=$96,
      HSYNCTRUE=1,
      VSYNCTRUE=2,
      CSYNCTRUE=4,
      AUD0=$A0,
      AUD1=$B0,
      BPL2MOD=$10A,
      AUD2=$C0,
      BLTBMOD=$62,
      DSKLEN=$24,
      AUD3=$D0,
      BPLCON2_ZDBPSEL0=$1000,
      SD_SIZEOF=8,
      AC_SIZEOF=16,
      BPLCON3_ZDCLKEN=4,
      BPLCON2_ZDBPSEL1=$2000,
      SPRPT=$120,
      BPLCON2_ZDBPSEL2=$4000,
      BLTSIZE=$58,
      ADKCON=$9E,
      BLTSIZH=$5E,
      BLTAPT=$50,
      AC_LEN=4
@endnode
