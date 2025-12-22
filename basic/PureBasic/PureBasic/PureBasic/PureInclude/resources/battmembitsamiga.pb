;/*
;**  $VER: battmembitsamiga.h 39.3 (14.9.92)
;**  Includes Release 40.15
;**
;**  BattMem AMIGA specific bit definitions.
;**
;**  (C) Copyright 1989-1993 Commodore-AMIGA Inc.
;**    All Rights Reserved
;*/


;/*
; * AMIGA specific bits in the battery-backedup ram.
; *
; *  Bits 0 To 31, inclusive
; */

;/*
; * AMIGA_AMNESIA
; *
; *    The battery-backedup memory has had a memory loss.
; *    This bit is Used as a flag that the user should be
; *    notified that all battery-backed bit have been
; *    RESET AND that some attention is required. Zero
; *    indicates that a memory loss has occured.
; */

#BATTMEM_AMIGA_AMNESIA_ADDR = 0
#BATTMEM_AMIGA_AMNESIA_LEN  = 1


;/*
; * SCSI_TIMEOUT
; *
; *    adjusts the timeout value For SCSI device selection.  A
; *    value of 0 will produce short timeouts (128 ms) While a
; *    value of 1 produces long timeouts (2 sec).  This is Used
; *    For SeaCrate drives (AND some Maxtors apparently) that
; *    don`t respond To selection Until they are fully spun up
; *    AND intialised.
; */

#BATTMEM_SCSI_TIMEOUT_ADDR =1
#BATTMEM_SCSI_TIMEOUT_LEN  =1


;/*
; * SCSI_LUNS
; *
; *    Determines If the controller attempts To access logical
; *    units above 0 at any given SCSI address.  This prevents
; *    problems with drives that respond To ALL LUN addresses
; *    (instead of only 0 like they should).  Default value is
; *    0 meaning don't support LUNs.
; */

#BATTMEM_SCSI_LUNS_ADDR  = 2
#BATTMEM_SCSI_LUNS_LEN   = 1
