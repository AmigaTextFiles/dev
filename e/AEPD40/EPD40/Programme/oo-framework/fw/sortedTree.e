 TO execbase
    IF mp=0 THEN status('Load a module first!')
    IF mp AND (pl=0)
        BSET    #1,$BFE001
        SELECT type
            CASE 1  -> ProTracker
                ptbase:=OpenLibrary('protracker.library',1)
                pl:=Mt_StartInt(mp)
                IF pl=0
                    CloseLibrary(ptbase)
                    ptbase:=0
                ENDIF
            CASE 2  -> MED
                medplayerbase:=OpenLibrary('medplayer.library',5)
                pl:=IF GetPlayer(0) THEN FALSE ELSE TRUE
                IF pl
                    SetModnum(song)
                    PlayModule(mp)
                ELSE
                    CloseLibrary(medplayerbase)
                    medplayerbase:=0
                ENDIF
            CASE 3  -> OctaMED
                octaplayerbase:=OpenLibrary('octaplayer.library',5)
                pl:=IF GetPlayer8() THEN FALSE ELSE TRUE
                IF pl
                    SetModnum8(song)
                    PlayModule8(mp)
                ELSE
                    CloseLibrary(octaplayerbase)
                    octaplayerbase:=0
                ENDIF
            CASE 4  -> PlaySID
                playsidbase:=OpenLibrary('playsid.library',1)
                pl:=AllocEmulResource()
                IF pl=0
                    execbase:=Long(4)
                    SetVertFreq(execbase.powersupplyfrequency)
                    SetModule(mp,mp,ml)
                    pl:=StartSong(song)
                    IF pl THEN FreeEmulResource()
                ENDIF
                IF pl
                    CloseLibrary(playsidbase)
                    playsidbase:=0
                ENDIF
                pl:=IF pl THEN FALSE ELSE TRUE
            CASE 5  -> JamCracker
                pl:=jc_StartInt(mp)
        ENDSELECT
        IF pl THEN status('Playing module...') ELSE status('Can''t play module!')
    ENDIF
ENDPROC

PROC eject(i=0)
    IF mp
        stop()
        FreeMem(mp,mfl)
        mp:=0;ml:=0
        type:=0
        mi.setinfo()
        status('Module ejected.')
    ELSE
        status('No module loaded!')
    ENDIF
ENDPROC

PROC stop(i=0)
    IF pl
        SELECT type
            CASE 1  -> ProTracker
                Mt_StopInt()
                CloseLibrary(ptbase)
                ptbase:=0
            CASE 2  -> MED
                StopPlayer()
                FreePlayer()
                CloseLibrary(medplayerbase)
                medplayerbase:=0
            CASE 3  -> OctaMED
                StopPlayer8()
                FreePlayer8()
                CloseLibrary(octaplayerbase)
                octaplayerbase:=0
            CASE 4  -> PlaySID
                StopSong()
                FreeEmulResource()
                CloseLibrary(playsidbase)
                playsidbase:=0
            CASE 5  -> JamCracker
                jc_StopInt()
        ENDSELECT
        pl:=0
        status('Module stopped.')
    ELSE
        status('No module playing!')
    ENDIF
ENDPROC

PROC checkformat(m:PTR TO mmd0)
    DEF v
    song:=0
    minsong:=0
    maxsong:=0
    IF Long(m+1080)="M.K." TH