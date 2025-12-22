
;
; ** $VER: datetime.h 36.7 (12.7.90)
; ** Includes Release 40.15
; **
; ** Date and time C header for AmigaDOS
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
; **
;

;IncludePath   "PureInclude:"
;XIncludeFile "dos/dos.pb"

;
;  * Data structures and equates used by the V1.4 DOS functions
;  * StrtoDate() and DatetoStr()
;

; --------- String/Date structures etc
Structure DateTime
 dat_Stamp.DateStamp ;  DOS DateStamp
 dat_Format.b  ;  controls appearance of dat_StrDate
 dat_Flags.b  ;  see BITDEF's below
 *dat_StrDay.b  ;  day of the week string
 *dat_StrDate.b  ;  date string
 *dat_StrTime.b  ;  time string
EndStructure

;  You need this much room for each of the DateTime strings:
#LEN_DATSTRING = 16

;  flags for dat_Flags

#DTB_SUBST = 0  ;  substitute Today, Tomorrow, etc.
#DTF_SUBST = 1
#DTB_FUTURE = 1  ;  day of the week is in future
#DTF_FUTURE = 2

;
;  * date format values
;

#FORMAT_DOS = 0  ;  dd-mmm-yy
#FORMAT_INT = 1  ;  yy-mm-dd
#FORMAT_USA = 2  ;  mm-dd-yy
#FORMAT_CDN = 3  ;  dd-mm-yy
#FORMAT_MAX = #FORMAT_CDN

