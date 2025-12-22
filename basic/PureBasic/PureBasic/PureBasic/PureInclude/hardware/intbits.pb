;
; ** $VER: intbits.h 39.1 (18.9.92)
; ** Includes Release 40.15
; **
; ** bits in the interrupt enable (and interrupt request) register
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

#INTB_SETCLR = (15)  ;  Set/Clear control bit. Determines if bits
     ;  written with a 1 get set or cleared. Bits
     ;  written with a zero are allways unchanged
#INTB_INTEN = (14)  ;  Master interrupt (enable only )
#INTB_EXTER = (13)  ;  External interrupt
#INTB_DSKSYNC = (12)  ;  Disk re-SYNChronized
#INTB_RBF = (11)  ;  serial port Receive Buffer Full
#INTB_AUD3 = (10)  ;  Audio channel 3 block finished
#INTB_AUD2 = (9)   ;  Audio channel 2 block finished
#INTB_AUD1 = (8)   ;  Audio channel 1 block finished
#INTB_AUD0 = (7)   ;  Audio channel 0 block finished
#INTB_BLIT = (6)   ;  Blitter finished
#INTB_VERTB = (5)   ;  start of Vertical Blank
#INTB_COPER = (4)   ;  Coprocessor
#INTB_PORTS = (3)   ;  I/O Ports and timers
#INTB_SOFTINT = (2)   ;  software interrupt request
#INTB_DSKBLK = (1)   ;  Disk Block done
#INTB_TBE = (0)   ;  serial port Transmit Buffer Empty



#INTF_SETCLR = (1 << 15)
#INTF_INTEN = (1 << 14)
#INTF_EXTER = (1 << 13)
#INTF_DSKSYNC = (1 << 12)
#INTF_RBF = (1 << 11)
#INTF_AUD3 = (1 << 10)
#INTF_AUD2 = (1 << 9)
#INTF_AUD1 = (1 << 8)
#INTF_AUD0 = (1 << 7)
#INTF_BLIT = (1 << 6)
#INTF_VERTB = (1 << 5)
#INTF_COPER = (1 << 4)
#INTF_PORTS = (1 << 3)
#INTF_SOFTINT = (1 << 2)
#INTF_DSKBLK = (1 << 1)
#INTF_TBE = (1 << 0)

