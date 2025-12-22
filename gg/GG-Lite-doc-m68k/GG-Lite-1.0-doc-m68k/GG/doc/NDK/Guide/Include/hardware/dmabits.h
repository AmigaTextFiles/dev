@DATABASE "gg:doc/NDK/Guide/Include/hardware/dmabits.h"
@MASTER   "gg:os-include/hardware/dmabits.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:18
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "hardware/dmabits.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"hardware/dmabits.h" LINK File}


@{b}#defines@{ub}

@{"DMAB_AUD0" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 35}     @{"DMAB_AUD1" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 36}     @{"DMAB_AUD2" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 37}     @{"DMAB_AUD3" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 38}
@{"DMAB_BLITHOG" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 45}  @{"DMAB_BLITTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 41}  @{"DMAB_BLTDONE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 46}  @{"DMAB_BLTNZERO" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 47}
@{"DMAB_COPPER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 42}   @{"DMAB_DISK" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 39}     @{"DMAB_MASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 44}   @{"DMAB_RASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 43}
@{"DMAB_SETCLR" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 34}   @{"DMAB_SPRITE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 40}   @{"DMAF_ALL" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 27}      @{"DMAF_AUD0" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 16}
@{"DMAF_AUD1" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 17}     @{"DMAF_AUD2" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 18}     @{"DMAF_AUD3" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 19}     @{"DMAF_AUDIO" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 15}
@{"DMAF_BLITHOG" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 26}  @{"DMAF_BLITTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 22}  @{"DMAF_BLTDONE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 31}  @{"DMAF_BLTNZERO" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 32}
@{"DMAF_COPPER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 23}   @{"DMAF_DISK" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 20}     @{"DMAF_MASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 25}   @{"DMAF_RASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 24}
@{"DMAF_SETCLR" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 14}   @{"DMAF_SPRITE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 21}   

@ENDNODE
@NODE File "hardware/dmabits.h"
#ifndef HARDWARE_DMABITS_H
#define HARDWARE_DMABITS_H
/*
**      $VER: dmabits.h 39.1 (18.9.1992)
**      Includes Release 45.1
**
**      include file for defining dma control stuff
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

/* write definitions for dmaconw */
#define DMAF_SETCLR  0x8000
#define DMAF_AUDIO   0x000F   /* 4 bit mask */
#define DMAF_AUD0    0x0001
#define DMAF_AUD1    0x0002
#define DMAF_AUD2    0x0004
#define DMAF_AUD3    0x0008
#define DMAF_DISK    0x0010
#define DMAF_SPRITE  0x0020
#define DMAF_BLITTER 0x0040
#define DMAF_COPPER  0x0080
#define DMAF_RASTER  0x0100
#define DMAF_MASTER  0x0200
#define DMAF_BLITHOG 0x0400
#define DMAF_ALL     0x01FF   /* all dma channels */

/* read definitions for dmaconr */
/* bits 0-8 correspnd to dmaconw definitions */
#define DMAF_BLTDONE 0x4000
#define DMAF_BLTNZERO   0x2000

#define DMAB_SETCLR  15
#define DMAB_AUD0    0
#define DMAB_AUD1    1
#define DMAB_AUD2    2
#define DMAB_AUD3    3
#define DMAB_DISK    4
#define DMAB_SPRITE  5
#define DMAB_BLITTER 6
#define DMAB_COPPER  7
#define DMAB_RASTER  8
#define DMAB_MASTER  9
#define DMAB_BLITHOG 10
#define DMAB_BLTDONE 14
#define DMAB_BLTNZERO   13

#endif  /* HARDWARE_DMABITS_H */
@ENDNODE
