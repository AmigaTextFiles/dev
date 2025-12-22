;
; ** $VER: initializers.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Macros for use with the InitStruct() function.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

;#OFFSET(structEntry) \.=
;    (&(((*) 0)\structEntry)).structName
;#INITBYTE(offset.w :value) = $e00WORD) (offset).w :(UWORD) ((value)LSL8).w
;#INITWORD(offset.w :value) = $d00WORD) (offset).w :(UWORD) (value).w
;#INITe) = $c000.l :(UWORD) (offset).l : \.l
;    (((value)LSR16).w : \.w
;    (((value) .w
;#INITSTRUCT(size,offset,value,count) = \
;    (($c000|(sizeLsl12)|(countLsl8)| .w
;    ((((offset)LSR16)).w : \.w
;    (((offset)) .w
