;
; ** $VER: bootblock.h 36.6 (5.11.90)
; ** Includes Release 40.15
; **
; ** floppy BootBlock definition
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

Structure BootBlock
 bb_id.b[4]   ;  4 character identifier
 bb_chksum.l  ;  boot block checksum (balance)
 bb_dosblock.l  ;  reserved for DOS patch
EndStructure

#BOOTSECTS = 2 ;  1K bootstrap

#BBID_DOS   = $444F5300  ; 'D', 'O', 'S', '\0' }
#BBID_KICK  = $4B49434B  ; 'K', 'I', 'C', 'K' }

#BBNAME_DOS  = $444F5300 ;  'DOS\0'
#BBNAME_KICK = $4B49434B ;  'KICK'

