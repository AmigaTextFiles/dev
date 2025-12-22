;
; ** $VER: sound.h 38.2 (20.6.91)
; ** Includes Release 40.15
; **
; ** File format for sound preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


#ID_SOND = $534F4E44

Structure SoundPrefs

    sop_Reserved.l[4]       ;  System reserved
    sop_DisplayQueue.w       ;  Flash the display?
    sop_AudioQueue.w       ;  Make some sound?
    sop_AudioType.w       ;  Type of sound, see below
    sop_AudioVolume.w       ;  Volume of sound, 0..64
    sop_AudioPeriod.w       ;  Period of sound, 127..2500
    sop_AudioDuration.w       ;  Length of simple beep
    sop_AudioFileName.b[256]     ;  Filename of 8SVX file
EndStructure


;  constants for SoundPrefs.sop_AudioType
#SPTYPE_BEEP = 0 ;  simple beep sound
#SPTYPE_SAMPLE = 1 ;  sampled sound


; ***************************************************************************


