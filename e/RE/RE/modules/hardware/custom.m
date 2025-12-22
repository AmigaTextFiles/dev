#ifndef  HARDWARE_CUSTOM_H
#define  HARDWARE_CUSTOM_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 

OBJECT AudChannel

      ptr:PTR TO UWORD 
      len:UWORD   
      per:UWORD   
      vol:UWORD   
      dat:UWORD   
      pad[2]:UWORD   
ENDOBJECT

OBJECT SpriteDef

      pos:UWORD
      ctl:UWORD
      dataa:UWORD
      datab:UWORD
ENDOBJECT

OBJECT Custom
 
    bltddat:UWORD
    dmaconr:UWORD
    vposr:UWORD
    vhposr:UWORD
    dskdatr:UWORD
    joy0dat:UWORD
    joy1dat:UWORD
    clxdat:UWORD
    adkconr:UWORD
    pot0dat:UWORD
    pot1dat:UWORD
    potinp:UWORD
    serdatr:UWORD
    dskbytr:UWORD
    intenar:UWORD
    intreqr:UWORD
    dskpt:LONG
    dsklen:UWORD
    dskdat:UWORD
    refptr:UWORD
    vposw:UWORD
    vhposw:UWORD
    copcon:UWORD
    serdat:UWORD
    serper:UWORD
    potgo:UWORD
    joytest:UWORD
    strequ:UWORD
    strvbl:UWORD
    strhor:UWORD
    strlong:UWORD
    bltcon0:UWORD
    bltcon1:UWORD
    bltafwm:UWORD
    bltalwm:UWORD
    bltcpt:LONG
    bltbpt:LONG
    bltapt:LONG
    bltdpt:LONG
    bltsize:UWORD
    pad2d:UBYTE
    bltcon0l:UBYTE   
    bltsizv:UWORD
    bltsizh:UWORD 
    bltcmod:UWORD
    bltbmod:UWORD
    bltamod:UWORD
    bltdmod:UWORD
    pad34[4]:UWORD
    bltcdat:UWORD
    bltbdat:UWORD
    bltadat:UWORD
    pad3b[3]:UWORD
    deniseid:UWORD   
    dsksync:UWORD
    cop1lc:LONG
    cop2lc:LONG
    copjmp1:UWORD
    copjmp2:UWORD
    copins:UWORD
    diwstrt:UWORD
    diwstop:UWORD
    ddfstrt:UWORD
    ddfstop:UWORD
    dmacon:UWORD
    clxcon:UWORD
    intena:UWORD
    intreq:UWORD
    adkcon:UWORD
      aud[4]:AudChannel

    bplpt[8]:LONG
    bplcon0:UWORD
    bplcon1:UWORD
    bplcon2:UWORD
    bplcon3:UWORD
    bpl1mod:UWORD
    bpl2mod:UWORD
    bplcon4:UWORD
    clxcon2:UWORD
    bpldat[8]:UWORD
    sprpt[8]:LONG
      spr[8]:SpriteDef
    color[32]:UWORD
    htotal:UWORD
    hsstop:UWORD
    hbstrt:UWORD
    hbstop:UWORD
    vtotal:UWORD
    vsstop:UWORD
    vbstrt:UWORD
    vbstop:UWORD
    sprhstrt:UWORD
    sprhstop:UWORD
    bplhstrt:UWORD
    bplhstop:UWORD
    hhposw:UWORD
    hhposr:UWORD
    beamcon0:UWORD
    hsstrt:UWORD
    vsstrt:UWORD
    hcenter:UWORD
    diwhigh:UWORD 
    padf3[11]:UWORD
    fmode:UWORD
ENDOBJECT

#ifdef ECS_SPECIFIC

#define VARVBLANK $1000 
#define LOLDIS    $0800 
#define CSCBLANKEN   $0400 
#define VARVSYNC  $0200 
#define VARHSYNC  $0100 
#define VARBEAM   $0080 
#define DISPLAYDUAL  $0040 
#define DISPLAYPAL   $0020 
#define VARCSYNC  $0010 
#define CSBLANK   $0008 
#define CSYNCTRUE $0004 
#define VSYNCTRUE $0002 
#define HSYNCTRUE $0001 

#define USE_BPLCON3  1

#define BPLCON2_ZDCTEN     (1<<10) 
#define BPLCON2_ZDBPEN     (1<<11) 
#define BPLCON2_ZDBPSEL0   (1<<12) 
#define BPLCON2_ZDBPSEL1   (1<<13) 
#define BPLCON2_ZDBPSEL2   (1<<14) 

#define BPLCON3_EXTBLNKEN  (1<<0)   
#define BPLCON3_EXTBLKZD   (1<<1)   
#define BPLCON3_ZDCLKEN (1<<2)   
#define BPLCON3_BRDNTRAN   (1<<4)   
#define BPLCON3_BRDNBLNK   (1<<5)   
#endif   
#endif   
