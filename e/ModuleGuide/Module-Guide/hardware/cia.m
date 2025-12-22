@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "hardware/cia.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT cia
@{fg shine}(   0)@{fg text}   ciapra:CHAR
@{fg shine}(   1)@{fg text}   pad0a:CHAR
@{fg shine}(   2)@{fg text}   pad0b[254]:ARRAY OF CHAR
@{fg shine}( 256)@{fg text}   ciaprb:CHAR
@{fg shine}( 257)@{fg text}   pad1a:CHAR
@{fg shine}( 258)@{fg text}   pad1b[254]:ARRAY OF CHAR
@{fg shine}( 512)@{fg text}   ciaddra:CHAR
@{fg shine}( 513)@{fg text}   pad2a:CHAR
@{fg shine}( 514)@{fg text}   pad2b[254]:ARRAY OF CHAR
@{fg shine}( 768)@{fg text}   ciaddrb:CHAR
@{fg shine}( 769)@{fg text}   pad3a:CHAR
@{fg shine}( 770)@{fg text}   pad3b[254]:ARRAY OF CHAR
@{fg shine}(1024)@{fg text}   ciatalo:CHAR
@{fg shine}(1025)@{fg text}   pad4a:CHAR
@{fg shine}(1026)@{fg text}   pad4b[254]:ARRAY OF CHAR
@{fg shine}(1280)@{fg text}   ciatahi:CHAR
@{fg shine}(1281)@{fg text}   pad5a:CHAR
@{fg shine}(1282)@{fg text}   pad5b[254]:ARRAY OF CHAR
@{fg shine}(1536)@{fg text}   ciatblo:CHAR
@{fg shine}(1537)@{fg text}   pad6a:CHAR
@{fg shine}(1538)@{fg text}   pad6b[254]:ARRAY OF CHAR
@{fg shine}(1792)@{fg text}   ciatbhi:CHAR
@{fg shine}(1793)@{fg text}   pad7a:CHAR
@{fg shine}(1794)@{fg text}   pad7b[254]:ARRAY OF CHAR
@{fg shine}(2048)@{fg text}   ciatodlow:CHAR
@{fg shine}(2049)@{fg text}   pad8a:CHAR
@{fg shine}(2050)@{fg text}   pad8b[254]:ARRAY OF CHAR
@{fg shine}(2304)@{fg text}   ciatodmid:CHAR
@{fg shine}(2305)@{fg text}   pad9a:CHAR
@{fg shine}(2306)@{fg text}   pad9b[254]:ARRAY OF CHAR
@{fg shine}(2560)@{fg text}   ciatodhi:CHAR
@{fg shine}(2561)@{fg text}   pad10a:CHAR
@{fg shine}(2562)@{fg text}   pad10b[254]:ARRAY OF CHAR
@{fg shine}(2816)@{fg text}   unusedreg:CHAR
@{fg shine}(2817)@{fg text}   pad11a:CHAR
@{fg shine}(2818)@{fg text}   pad11b[254]:ARRAY OF CHAR
@{fg shine}(3072)@{fg text}   ciasdr:CHAR
@{fg shine}(3073)@{fg text}   pad12a:CHAR
@{fg shine}(3074)@{fg text}   pad12b[254]:ARRAY OF CHAR
@{fg shine}(3328)@{fg text}   ciaicr:CHAR
@{fg shine}(3329)@{fg text}   pad13a:CHAR
@{fg shine}(3330)@{fg text}   pad13b[254]:ARRAY OF CHAR
@{fg shine}(3584)@{fg text}   ciacra:CHAR
@{fg shine}(3585)@{fg text}   pad14a:CHAR
@{fg shine}(3586)@{fg text}   pad14b[254]:ARRAY OF CHAR
@{fg shine}(3840)@{fg text}   ciacrb:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=3842 */

CONST CIAF_COMCD=$20,
      CIAB_COMCD=5,
      CIAICRF_TA=1,
      CIAPRA=0,
      CIAF_DSKRDY=$20,
      CIAB_DSKRDY=5,
      CIAICRF_TB=2,
      CIAPRB=$100,
      CIAF_COMRTS=$40,
      CIAB_COMRTS=6,
      CIAF_COMDTR=$80,
      CIAB_COMDTR=7,
      CIACRBF_LOAD=16,
      CIACRAF_LOAD=16,
      CIACRBB_LOAD=4,
      CIACRAB_LOAD=4,
      CIAF_PRTRSEL=4,
      CIAB_PRTRSEL=2,
      CIACRBF_IN_PHI2=0,
      CIACRBF_START=1,
      CIACRAF_START=1,
      CIACRBB_START=0,
      CIACRAB_START=0,
      CIACRBF_IN_CNT_TA=$60,
      CIACRBF_PBON=2,
      CIACRAF_PBON=2,
      CIACRBB_PBON=1,
      CIACRAB_PBON=1,
      CIACRA=$E00,
      CIACRB=$F00,
      CIAICRF_IR=$80,
      CIAF_PRTRPOUT=2,
      CIAB_PRTRPOUT=1,
      CIAF_DSKSIDE=4,
      CIAB_DSKSIDE=2,
      CIATAHI=$500,
      CIAF_DSKCHANGE=4,
      CIAB_DSKCHANGE=2,
      CIAICRB_SP=3,
      CIAICRB_TA=0,
      CIAICRB_TB=1,
      CIAICRF_FLG=16,
      CIAICRB_FLG=4,
      CIATALO=$400,
      CIAICR=$D00,
      CIAB_ADDR=$BFD000,
      CIAA_ADDR=$BFE001,
      CIATODMID=$900,
      CIATBHI=$700,
      CIACRBF_INMODE0=$20,
      CIACRBB_INMODE0=5,
      CIACRBF_INMODE1=$40,
      CIACRBB_INMODE1=6,
      CIAICRB_IR=7,
      CIAF_DSKTRACK0=16,
      CIAB_DSKTRACK0=4,
      CIATODLOW=$800,
      CIATBLO=$600,
      CIASDR=$C00,
      CIAF_DSKPROT=8,
      CIAB_DSKPROT=3,
      CIAF_DSKMOTOR=$80,
      CIAF_PRTRBUSY=1,
      CIAB_DSKMOTOR=7,
      CIAB_PRTRBUSY=0,
      CIAF_GAMEPORT0=$40,
      CIAB_GAMEPORT0=6,
      CIAF_GAMEPORT1=$80,
      CIAB_GAMEPORT1=7,
      CIADDRA=$200,
      CIACRBF_RUNMODE=8,
      CIACRBF_OUTMODE=4,
      CIACRAF_SPMODE=$40,
      CIACRAF_INMODE=$20,
      CIACRAF_RUNMODE=8,
      CIACRAF_OUTMODE=4,
      CIACRBB_RUNMODE=3,
      CIACRBB_OUTMODE=2,
      CIACRAB_SPMODE=6,
      CIACRAB_INMODE=5,
      CIACRAB_RUNMODE=3,
      CIACRAB_OUTMODE=2,
      CIADDRB=$300,
      CIACRBF_IN_TA=$40,
      CIAF_DSKDIREC=2,
      CIAB_DSKDIREC=1,
      CIAF_DSKSTEP=1,
      CIAB_DSKSTEP=0,
      CIAICRF_ALRM=4,
      CIAICRB_ALRM=2,
      CIACRBF_ALARM=$80,
      CIACRBB_ALARM=7,
      CIAF_COMCTS=16,
      CIAB_COMCTS=4,
      CIAICRF_SETCLR=$80,
      CIAICRB_SETCLR=7,
      CIATODHI=$A00,
      CIAF_LED=2,
      CIAB_LED=1,
      CIAF_DSKSEL0=8,
      CIAB_DSKSEL0=3,
      CIAF_DSKSEL1=16,
      CIAF_COMDSR=8,
      CIAB_DSKSEL1=4,
      CIAB_COMDSR=3,
      CIAF_DSKSEL2=$20,
      CIAB_DSKSEL2=5,
      CIAF_DSKSEL3=$40,
      CIAB_DSKSEL3=6,
      CIAF_OVERLAY=1,
      CIAB_OVERLAY=0,
      CIACRBF_IN_CNT=$20,
      CIACRAF_TODIN=$80,
      CIAICRF_SP=8,
      CIACRAB_TODIN=7
@endnode
