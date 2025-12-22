@DATABASE "gg:doc/NDK/Guide/Include/hardware/custom.h"
@MASTER   "gg:os-include/hardware/custom.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:17
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "hardware/custom.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"hardware/custom.h" LINK File}


@{b}Structures@{ub}

@{"Custom" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 25}


@{b}#defines@{ub}

@{"BPLCON2_ZDBPEN" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 166}     @{"BPLCON2_ZDBPSEL0" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 167}  @{"BPLCON2_ZDBPSEL1" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 168}  @{"BPLCON2_ZDBPSEL2" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 169}
@{"BPLCON2_ZDCTEN" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 165}     @{"BPLCON3_BRDNBLNK" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 176}  @{"BPLCON3_BRDNTRAN" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 175}  @{"BPLCON3_EXTBLKZD" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 173}
@{"BPLCON3_EXTBLNKEN" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 172}  @{"BPLCON3_ZDCLKEN" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 174}   @{"CSBLANK" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 156}           @{"CSCBLANKEN" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 149}
@{"CSYNCTRUE" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 157}          @{"DISPLAYDUAL" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 153}       @{"DISPLAYPAL" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 154}        @{"HSYNCTRUE" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 159}
@{"LOLDIS" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 148}             @{"USE_BPLCON3" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 162}       @{"VARBEAM" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 152}           @{"VARCSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 155}
@{"VARHSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 151}           @{"VARVBLANK" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 147}         @{"VARVSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 150}          @{"VSYNCTRUE" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 158}

@ENDNODE
@NODE File "hardware/custom.h"
#ifndef HARDWARE_CUSTOM_H
#define HARDWARE_CUSTOM_H
/*
**      $VER: custom.h 39.1 (18.9.1992)
**      Includes Release 45.1
**
**      Offsets of Amiga custom chip registers
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif /* EXEC_TYPES_H */



/*
 * do this to get base of custom registers:
 * extern @{"struct Custom" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File" 25} custom;
 */


struct Custom {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltddat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dmaconr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   vposr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   vhposr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dskdatr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   joy0dat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   joy1dat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   clxdat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   adkconr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pot0dat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pot1dat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   potinp;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   serdatr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dskbytr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   intenar;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   intreqr;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    dskpt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dsklen;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dskdat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   refptr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   vposw;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   vhposw;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   copcon;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   serdat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   serper;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   potgo;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   joytest;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   strequ;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   strvbl;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   strhor;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   strlong;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltcon0;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltcon1;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltafwm;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltalwm;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    bltcpt;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    bltbpt;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    bltapt;
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    bltdpt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltsize;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   pad2d;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   bltcon0l;   /* low 8 bits of bltcon0, write only */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltsizv;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltsizh;    /* 5e */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltcmod;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltbmod;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltamod;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltdmod;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pad34[4];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltcdat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltbdat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bltadat;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pad3b[3];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   deniseid;   /* 7c */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dsksync;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cop1lc;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cop2lc;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   copjmp1;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   copjmp2;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   copins;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   diwstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   diwstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ddfstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   ddfstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   dmacon;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   clxcon;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   intena;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   intreq;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   adkcon;
    struct  AudChannel {
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *ac_ptr; /* ptr to start of waveform data */
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ac_len;     /* length of waveform in words */
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ac_per;     /* sample period */
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ac_vol;     /* volume */
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ac_dat;     /* sample pair */
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ac_pad[2];  /* unused */
    } aud[4];
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    bplpt[8];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bplcon0;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bplcon1;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bplcon2;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bplcon3;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bpl1mod;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bpl2mod;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bplcon4;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   clxcon2;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   bpldat[8];
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}    sprpt[8];
    struct  SpriteDef {
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} pos;
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ctl;
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} dataa;
      @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} datab;
    } spr[8];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   color[32];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} htotal;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hsstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hbstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hbstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vtotal;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vsstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vbstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vbstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sprhstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sprhstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} bplhstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} bplhstop;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hhposw;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hhposr;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} beamcon0;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hsstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vsstrt;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} hcenter;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} diwhigh;      /* 1e4 */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} padf3[11];
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} fmode;
};

#ifdef ECS_SPECIFIC

/* defines for beamcon register */
#define VARVBLANK       0x1000  /* Variable vertical blank enable */
#define LOLDIS          0x0800  /* long line disable */
#define CSCBLANKEN      0x0400  /* redirect composite sync */
#define VARVSYNC        0x0200  /* Variable vertical sync enable */
#define VARHSYNC        0x0100  /* Variable horizontal sync enable */
#define VARBEAM 0x0080  /* variable beam counter enable */
#define DISPLAYDUAL     0x0040  /* use UHRES pointer and standard pointers */
#define DISPLAYPAL      0x0020  /* set decodes to generate @{"PAL" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File" 140} display */
#define VARCSYNC        0x0010  /* Variable composite sync enable */
#define CSBLANK 0x0008  /* Composite blank out to CSY* pin */
#define CSYNCTRUE       0x0004  /* composite sync true signal */
#define VSYNCTRUE       0x0002  /* vertical sync true */
#define HSYNCTRUE       0x0001  /* horizontal sync true */

/* new defines for bplcon0 */
#define USE_BPLCON3     1

/* new defines for bplcon2 */
#define BPLCON2_ZDCTEN          (1<<10) /* colormapped genlock bit */
#define BPLCON2_ZDBPEN          (1<<11) /* use bitplane as genlock bits */
#define BPLCON2_ZDBPSEL0        (1<<12) /* three bits to select one */
#define BPLCON2_ZDBPSEL1        (1<<13) /* of 8 bitplanes in */
#define BPLCON2_ZDBPSEL2        (1<<14) /* ZDBPEN genlock mode */

/* defines for bplcon3 register */
#define BPLCON3_EXTBLNKEN       (1<<0)  /* external blank enable */
#define BPLCON3_EXTBLKZD        (1<<1)  /* external blank ored into trnsprncy */
#define BPLCON3_ZDCLKEN (1<<2)  /* zd pin outputs a 14mhz clock*/
#define BPLCON3_BRDNTRAN        (1<<4)  /* border is opaque */
#define BPLCON3_BRDNBLNK        (1<<5)  /* border is opaque */

#endif  /* ECS_SPECIFIC */

#endif  /* HARDWARE_CUSTOM_H */
@ENDNODE
