@DATABASE "gg:doc/NDK/Guide/Include/hardware/intbits.h"
@MASTER   "gg:os-include/hardware/intbits.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:18
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "hardware/intbits.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"hardware/intbits.h" LINK File}


@{b}#defines@{ub}

@{"INTB_AUD0" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 23}   @{"INTB_AUD1" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 22}    @{"INTB_AUD2" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 21}     @{"INTB_AUD3" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 20}     @{"INTB_BLIT" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 24}
@{"INTB_COPER" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 26}  @{"INTB_DSKBLK" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 29}  @{"INTB_DSKSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 18}  @{"INTB_EXTER" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 17}    @{"INTB_INTEN" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 16}
@{"INTB_PORTS" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 27}  @{"INTB_RBF" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 19}     @{"INTB_SETCLR" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 13}   @{"INTB_SOFTINT" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 28}  @{"INTB_TBE" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 30}
@{"INTB_VERTB" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 25}  @{"INTF_AUD0" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 42}    @{"INTF_AUD1" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 41}     @{"INTF_AUD2" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 40}     @{"INTF_AUD3" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 39}
@{"INTF_BLIT" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 43}   @{"INTF_COPER" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 45}   @{"INTF_DSKBLK" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 48}   @{"INTF_DSKSYNC" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 37}  @{"INTF_EXTER" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 36}
@{"INTF_INTEN" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 35}  @{"INTF_PORTS" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 46}   @{"INTF_RBF" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 38}      @{"INTF_SETCLR" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 34}   @{"INTF_SOFTINT" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 47}
@{"INTF_TBE" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 49}    @{"INTF_VERTB" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 44}   

@ENDNODE
@NODE File "hardware/intbits.h"
#ifndef HARDWARE_INTBITS_H
#define HARDWARE_INTBITS_H
/*
**      $VER: intbits.h 39.1 (18.9.1992)
**      Includes Release 45.1
**
**      bits in the interrupt enable (and interrupt request) register
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#define  INTB_SETCLR    (15)  /* Set/Clear control bit. Determines if bits */
            /* written with a 1 get set or cleared. Bits */
            /* written with a zero are allways unchanged */
#define  INTB_INTEN     (14)  /* Master interrupt (enable only ) */
#define  INTB_EXTER     (13)  /* External interrupt */
#define  INTB_DSKSYNC   (12)  /* Disk re-SYNChronized */
#define  INTB_RBF       (11)  /* serial port Receive Buffer Full */
#define  INTB_AUD3      (10)  /* Audio channel 3 block finished */
#define  INTB_AUD2      (9)   /* Audio channel 2 block finished */
#define  INTB_AUD1      (8)   /* Audio channel 1 block finished */
#define  INTB_AUD0      (7)   /* Audio channel 0 block finished */
#define  INTB_BLIT      (6)   /* Blitter finished */
#define  INTB_VERTB     (5)   /* start of Vertical Blank */
#define  INTB_COPER     (4)   /* Coprocessor */
#define  INTB_PORTS     (3)   /* I/O Ports and timers */
#define  INTB_SOFTINT   (2)   /* software interrupt request */
#define  INTB_DSKBLK    (1)   /* Disk Block done */
#define  INTB_TBE       (0)   /* serial port Transmit Buffer Empty */



#define  INTF_SETCLR    (1L<<15)
#define  INTF_INTEN     (1L<<14)
#define  INTF_EXTER     (1L<<13)
#define  INTF_DSKSYNC   (1L<<12)
#define  INTF_RBF       (1L<<11)
#define  INTF_AUD3      (1L<<10)
#define  INTF_AUD2      (1L<<9)
#define  INTF_AUD1      (1L<<8)
#define  INTF_AUD0      (1L<<7)
#define  INTF_BLIT      (1L<<6)
#define  INTF_VERTB     (1L<<5)
#define  INTF_COPER     (1L<<4)
#define  INTF_PORTS     (1L<<3)
#define  INTF_SOFTINT   (1L<<2)
#define  INTF_DSKBLK    (1L<<1)
#define  INTF_TBE       (1L<<0)

#endif  /* HARDWARE_INTBITS_H */
@ENDNODE
