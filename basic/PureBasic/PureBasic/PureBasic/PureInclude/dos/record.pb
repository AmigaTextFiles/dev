;
; **
; ** $VER: record.h 36.5 (12.7.90)
; ** Includes Release 40.15
; **
; ** include file for record locking
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
; **
;

IncludePath   "PureInclude:"
;XIncludeFile "dos/dos.pb"

;  Modes for LockRecord/LockRecords()
#REC_EXCLUSIVE  = 0
#REC_EXCLUSIVE_IMMED = 1
#REC_SHARED  = 2
#REC_SHARED_IMMED = 3

;  struct to be passed to LockRecords()/UnLockRecords()

Structure RecordLock
 rec_FH.l  ;  filehandle
 rec_Offset.l ;  offset in file
 rec_Length.l ;  length of file to be locked
 rec_Mode.l ;  Type of lock
EndStructure

