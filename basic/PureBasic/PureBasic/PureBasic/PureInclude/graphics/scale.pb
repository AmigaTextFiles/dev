;
; ** $VER: scale.h 39.0 (21.8.91)
; ** Includes Release 40.15
; **
; ** structure argument to BitMapScale()
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

Structure BitScaleArgs
  bsa_SrcX.w
  bsa_SrcY.w   ;  source origin
  bsa_SrcWidth.w
  bsa_SrcHeight.w ;  source size
  bsa_XSrcFactor.w
  bsa_YSrcFactor.w ;  scale factor denominators
  bsa_DestX.w
  bsa_DestY.w  ;  destination origin
  bsa_DestWidth.w
  bsa_DestHeight.w ;  destination size result
  bsa_XDestFactor.w
  bsa_YDestFactor.w ;  scale factor numerators
  *bsa_SrcBitMap.BitMap  ;  source BitMap
  *bsa_DestBitMap.BitMap  ;  destination BitMap
  bsa_Flags.l    ;  reserved.  Must be zero!
  bsa_XDDA.w
  bsa_YDDA.w   ;  reserved
  bsa_Reserved1.l
  bsa_Reserved2.l
EndStructure
