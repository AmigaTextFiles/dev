;
; **  $VER: icclass.h 38.1 (11.11.91)
; **  Includes Release 40.15
; **
; **  Gadget/object interconnection classes
; **
; **  (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;


IncludePath   "PureInclude:"
XIncludeFile "utility/tagitem.pb"

#ICM_Dummy = ($0401) ;  used for nothing
#ICM_SETLOOP = ($0402) ;  set/increment loop counter
#ICM_CLEARLOOP = ($0403) ;  clear/decrement loop counter
#ICM_CHECKLOOP = ($0404) ;  set/increment loop

;  no parameters for ICM_SETLOOP, ICM_CLEARLOOP, ICM_CHECKLOOP

;  interconnection attributes used by icclass, modelclass, and gadgetclass
#ICA_Dummy = (#TAG_USER+$40000)
#ICA_TARGET = (#ICA_Dummy + 1)
 ;  interconnection target
#ICA_MAP  = (#ICA_Dummy + 2)
 ;  interconnection map tagitem list
#ICSPECIAL_CODE = (#ICA_Dummy + 3)
 ;  a "pseudo-attribute", see below.

;  Normally, the value for ICA_TARGET is some object pointer,
;  * but if you specify the special value ICTARGET_IDCMP, notification
;  * will be send as an IDCMP_IDCMPUPDATE message to the appropriate window's
;  * IDCMP port. See the definition of IDCMP_IDCMPUPDATE.
;  *
;  * When you specify ICTARGET_IDCMP for ICA_TARGET, the map you
;  * specify will be applied to derive the attribute list that is
;  * sent with the IDCMP_IDCMPUPDATE message.  If you specify a map list
;  * which results in the attribute tag id ICSPECIAL_CODE, the
;  * lower sixteen bits of the corresponding ti_Data value will
;  * be copied into the Code field of the IDCMP_IDCMPUPDATE IntuiMessage.
;
#ICTARGET_IDCMP = 0 ; was (~0)

