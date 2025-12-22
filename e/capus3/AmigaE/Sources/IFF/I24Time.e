->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE I24Time.e
 EDIR    Workbench:AmigaE/Sources/IFF
 ECOPT   ERRLINE
 EXENAME I24Time
 MAKE    EC
 AUTHOR  NasGûl
 TYPE    EXEDOS
 =====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !! SEULES LES DISTRIBUTIONS DE FRED FISH ET AMINET CDROM SONT AUTO-  !!
 !! RISES A DISTRIBUER CES PROGRAMMES/SOURCES.                        !!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
->> MODULES

MODULE 'libraries/iffparse','iffparse'
MODULE 'libraries/iff'

-><
->> OBJECTS

OBJECT timetracing
    start:LONG
    end:LONG
ENDOBJECT

-><
->> DEFINITIONS GLOBALES

DEF usereq=FALSE
DEF textreq[4000]:STRING

-><
->> main()
PROC main()
    DEF rdargs=NIL,myargs:PTR TO LONG
    DEF source[80]:STRING
    DEF marg=NIL:PTR TO LONG
    DEF i
    VOID '$VER: I24Time 1.0 (15.11.95) © 1995 NasGûl'
    myargs:=New(400)
    FOR i:=0 TO 99
        myargs[i]:=0
    ENDFOR
    IF iffparsebase:=OpenLibrary('iffparse.library',0)
        IF rdargs:=ReadArgs('Files/M,Req/S',myargs,NIL)
            IF myargs[1] THEN usereq:=TRUE
            IF myargs[0]
                marg:=myargs[0]
                FOR i:=0 TO 97
                    IF (marg[i]<>0)
                        StrCopy(source,marg[i],ALL)
                        readIFFFile(source)
                    ELSE
                        JUMP fin
                    ENDIF
                ENDFOR
                fin:
                IF usereq=TRUE
                    EasyRequestArgs(0,[20,0,'I24Time',textreq,'Ok'],0,0)
                ENDIF
            ENDIF
            FreeArgs(rdargs)
        ENDIF
        CloseLibrary(iffparsebase)
    ENDIF
ENDPROC
-><
->> readIFFFile(s)
PROC readIFFFile(s)
    DEF iff=NIL:PTR TO iffhandle
    DEF error=0
    DEF curchunk:PTR TO contextnode
    DEF buffer
    DEF stopchunk:PTR TO LONG
    DEF numstopchunk=3
    DEF bh:PTR TO bmh
    DEF time:PTR TO timetracing
    DEF t,h,mn,sec
    DEF tempstr[256]:STRING
    DEF piv[256]:STRING
    stopchunk:=["ILBM","BMHD","ILBM","IMRT","ILBM","ANNO"]

    IF (iff:=AllocIFF())>0
        iff.stream:=Open(s,1005)
        InitIFFasDOS(iff)
        IF (error:=OpenIFF(iff,IFFF_READ))=0
            IF (Not(StopChunks(iff,stopchunk,numstopchunk)))
                REPEAT
                    error:=ParseIFF(iff,IFFPARSE_SCAN)
                    IF error=0
                        curchunk:=CurrentChunk(iff)
                            IF curchunk.id="BMHD"
                                IF bh:=New(curchunk.size)
                                    ReadChunkBytes(iff,bh,curchunk.size)
                                    StringF(tempstr,'\s Width  :\d[4] Height :\d[4] NPlanes:\d[2] ',
                                                s,bh.width,bh.height,bh.nplanes)
                                    StrAdd(piv,tempstr,ALL)
                                    Dispose(bh)
                                ENDIF
                            ELSEIF curchunk.id="IMRT"
                                IF time:=New(curchunk.size)
                                    ReadChunkBytes(iff,time,curchunk.size)
                                    t:=time.end-time.start
                                    h:=t/3600
                                    mn:=t/60
                                    sec:=t-(mn*60)
                                    StringF(tempstr,' TotalTime \z\d[2]:\z\d[2]:\z\d[2]',h,mn,sec)
                                    StrAdd(piv,tempstr,ALL)
                                    Dispose(time)
                                ENDIF
                            ELSEIF curchunk.id="ANNO"
                                IF buffer:=New(curchunk.size)
                                    ReadChunkBytes(iff,buffer,curchunk.size)
                                    StringF(tempstr,'Annotation :\s\n',buffer)
                                    StrAdd(piv,tempstr,ALL)
                                    Dispose(buffer)
                                ENDIF
                            ENDIF
                    ENDIF
                UNTIL ((error<>0) AND (error<>-2))
                IF usereq=FALSE 
                    WriteF('\s\n',piv)
                ELSE
                    StrAdd(textreq,piv,ALL)
                    StrAdd(textreq,'\n',ALL)
                ENDIF
            ENDIF
            CloseIFF(iff)
            Close(iff.stream)
        ELSE
            Close(iff.stream)
        ENDIF
        FreeIFF(iff)
    ENDIF
ENDPROC
-><

