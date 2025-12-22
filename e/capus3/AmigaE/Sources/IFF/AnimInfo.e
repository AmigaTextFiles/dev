->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE AnimInfo.e
 EDIR    Workbench:AmigaE/Sources/IFF
 ECOPT   ERRLINE
 EXENAME AnimInfo
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

MODULE 'libraries/iffparse'
MODULE 'iffparse'
MODULE 'exec/nodes','exec/lists'
MODULE 'other/plist','libraries/iff'
MODULE 'tools/easygui','tools/exceptions'

-><
->> DEFINITIONS GLOBALES

DEF objsource[256]:STRING
DEF mylist:PTR TO lh
DEF force=FALSE
DEF stopchunk:PTR TO LONG
DEF numstopchunk=4
DEF nbrsframes=0,maxdelta=0,totaldelta=0

-><
->> main() HANDLE
PROC main() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF title[256]:STRING,test
    myargs:=[0,0]
    stopchunk:=["ANIM","FORM","ILBM","BMHD","ILBM","BODY","ILBM","DLTA"]
    VOID '$VER: AnimInfo 1.0 (15.11.95) © 1995 NasGûl'
    IF iffparsebase:=OpenLibrary('iffparse.library',0)
        IF rdargs:=ReadArgs('FICHIER/A,FORCE/S',myargs,NIL)
            IF myargs[0] THEN StrCopy(objsource,myargs[0],ALL)
            IF myargs[1] THEN force:=TRUE
            IF mylist:=initList()
                test:=readIFFFile()
                IF ((force=TRUE) OR (test=-1))

                    StringF(title,'AnimInfo :\s',objsource)
                    easygui(title,
                                [BEVEL,
                                    [EQROWS,
                                        [LISTV,{rien},NIL,50,5,mylist,0,NIL,NIL],
                                        [SBUTTON,0,'Ok']
                                    ]
                                ],NIL,NIL,NIL)

                    IF mylist THEN removeList(mylist)
                ENDIF
            ENDIF
            IF rdargs THEN FreeArgs(rdargs)
        ELSE
            WriteF('Bad Args\n')
        ENDIF
        CloseLibrary(iffparsebase)
    ELSE
        WriteF('iffparse.library ?.\n')
    ENDIF
EXCEPT DO
    IF mylist THEN removeList(mylist)
    IF rdargs THEN FreeArgs(rdargs)
    IF iffparsebase THEN CloseLibrary(iffparsebase)
    report_exception()
ENDPROC
-><
->> rien()
PROC rien()
ENDPROC
-><
->> readIFFFile()
PROC readIFFFile()
    DEF iff=NIL:PTR TO iffhandle
    DEF error=0
    DEF curchunk:PTR TO contextnode
    DEF buffer[256]:STRING
    DEF strtype[5]:STRING,strid[5]:STRING,moydelta=NIL
    DEF bm:PTR TO bmh
    IF (iff:=AllocIFF())>0
        iff.stream:=Open(objsource,1005)
        InitIFFasDOS(iff)
        IF (error:=OpenIFF(iff,IFFF_READ))=0
            IF (Not(StopChunks(iff,stopchunk,numstopchunk)))
                REPEAT
                    error:=ParseIFF(iff,IFFPARSE_SCAN)
                    IF error=0
                        curchunk:=CurrentChunk(iff)
                        VOID IdtoStr(curchunk.id,strid)
                        VOID IdtoStr(curchunk.type,strtype)
                        IF (curchunk.type="ANIM")
                            StringF(buffer,'\s (\s)',objsource,strtype)
                            addNode(mylist,buffer,0,0)
                        ELSEIF (curchunk.type="ILBM")
                            IF curchunk.id="BMHD"
                                IF bm:=New(curchunk.size)
                                    ReadChunkBytes(iff,bm,curchunk.size)
                                    StringF(buffer,'Width:\l\d[4] Height:\l\d[4] Planes:\l\d[2]',
                                                    bm.width,bm.height,bm.nplanes)
                                    addNode(mylist,buffer,0,0)
                                    Dispose(bm)
                                ENDIF
                            ELSEIF curchunk.id="BODY"
                                nbrsframes:=nbrsframes+1
                            ELSEIF curchunk.id="DLTA"
                                nbrsframes:=nbrsframes+1
                                maxdelta:=Max(curchunk.size,maxdelta)
                                totaldelta:=totaldelta+curchunk.size
                            ENDIF
                        ENDIF
                    ENDIF
                UNTIL ((error<>0) AND (error<>-2))
            ENDIF
            checkIFFError(error)
            CloseIFF(iff)
            Close(iff.stream)
        ENDIF
        FreeIFF(iff)
    ENDIF
    moydelta:=Div(totaldelta,nbrsframes)
    StringF(buffer,'NbrsFrames:\l\d MaxDelta:\l\d MoyDelta:\l\d',nbrsframes,maxdelta,moydelta)
    addNode(mylist,buffer,0,0)
    RETURN error
ENDPROC
-><
->> checkIFFError(er)
PROC checkIFFError(er)
    DEF text[256]:STRING
    SELECT er
        CASE 0;              RETURN TRUE
        CASE IFFERR_EOF;     RETURN FALSE
        CASE IFFERR_EOC;     RETURN TRUE
        CASE IFFERR_NOSCOPE; StrCopy(text,'IFFERR_NOSCOPE.',ALL)
        CASE IFFERR_NOMEM;   StrCopy(text,'IFFERR_NOMEM.',ALL)
        CASE IFFERR_READ;    StrCopy(text,'IFFERR_READ.',ALL)
        CASE IFFERR_WRITE;   StrCopy(text,'IFFERR_WRITE.',ALL)
        CASE IFFERR_SEEK;    StrCopy(text,'IFFERR_SEEK.',ALL)
        CASE IFFERR_MANGLED; StrCopy(text,'IFFERR_MANGLED.',ALL)
        CASE IFFERR_SYNTAX;  StrCopy(text,'IFFERR_SYNTAX.',ALL)
        CASE IFFERR_NOTIFF;  StrCopy(text,'IFFERR_NOTIFF.',ALL)
        CASE IFFERR_NOHOOK;  StrCopy(text,'IFFERR_NOHOOK.',ALL)
    ENDSELECT
    EasyRequestArgs(0,[20,0,'IFF Error',text,'Ok'],0,0)
    RETURN FALSE
ENDPROC
-><


