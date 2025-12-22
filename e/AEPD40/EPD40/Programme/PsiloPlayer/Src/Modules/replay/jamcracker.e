
OPT MODULE

MODULE 'replay/jamcracker_replay','replay/replayer'

DEF jc_playing

EXPORT PROC jc_StartInt(mod)
    IF jc_playing THEN jc_StopInt()
    IF dti_AudioAlloc()
        ppinit(mod)
        IF (jc_playing:=dti_StartInt({ppplay})) THEN RETURN TRUE
        dti_AudioFree()
    ENDIF
ENDPROC 0

EXPORT PROC jc_StopInt()
    IF jc_playing
        dti_StopInt()
        ppend()
        dti_AudioFree()
        jc_playing:=0
    ENDIF
ENDPROC

