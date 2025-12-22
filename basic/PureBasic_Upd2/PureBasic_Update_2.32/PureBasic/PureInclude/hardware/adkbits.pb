;
; ** $VER: adkbits.h 39.1 (18.9.92)
; ** Includes Release 40.15
; **
; ** bit definitions for adkcon register
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

#ADKB_SETCLR = 15 ;  standard set/clear bit
#ADKB_PRECOMP1 = 14 ;  two bits of precompensation
#ADKB_PRECOMP0 = 13
#ADKB_MFMPREC = 12 ;  use mfm style precompensation
#ADKB_UARTBRK = 11 ;  force uart output to zero
#ADKB_WORDSYNC = 10 ;  enable DSKSYNC register matching
#ADKB_MSBSYNC = 9  ;  (Apple GCR Only) sync on MSB for reading
#ADKB_FAST = 8  ;  1 -> 2 us/bit (mfm), 2 -> 4 us/bit (gcr)
#ADKB_USE3PN = 7  ;  use aud chan 3 to modulate period of ??
#ADKB_USE2P3 = 6  ;  use aud chan 2 to modulate period of 3
#ADKB_USE1P2 = 5  ;  use aud chan 1 to modulate period of 2
#ADKB_USE0P1 = 4  ;  use aud chan 0 to modulate period of 1
#ADKB_USE3VN = 3  ;  use aud chan 3 to modulate volume of ??
#ADKB_USE2V3 = 2  ;  use aud chan 2 to modulate volume of 3
#ADKB_USE1V2 = 1  ;  use aud chan 1 to modulate volume of 2
#ADKB_USE0V1 = 0  ;  use aud chan 0 to modulate volume of 1

#ADKF_SETCLR = (1 << 15)
#ADKF_PRECOMP1 = (1 << 14)
#ADKF_PRECOMP0 = (1 << 13)
#ADKF_MFMPREC = (1 << 12)
#ADKF_UARTBRK = (1 << 11)
#ADKF_WORDSYNC= (1 << 10)
#ADKF_MSBSYNC = (1 << 9)
#ADKF_FAST = (1 << 8)
#ADKF_USE3PN = (1 << 7)
#ADKF_USE2P3 = (1 << 6)
#ADKF_USE1P2 = (1 << 5)
#ADKF_USE0P1 = (1 << 4)
#ADKF_USE3VN = (1 << 3)
#ADKF_USE2V3 = (1 << 2)
#ADKF_USE1V2 = (1 << 1)
#ADKF_USE0V1 = (1 << 0)

#ADKF_PRE000NS = 0   ;  000 ns of precomp
#ADKF_PRE140NS = (#ADKF_PRECOMP0) ;  140 ns of precomp
#ADKF_PRE280NS = (#ADKF_PRECOMP1) ;  280 ns of precomp
#ADKF_PRE560NS = (#ADKF_PRECOMP0|#ADKF_PRECOMP1) ;  560 ns of precomp

