->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE IFFComment.e
 EDIR    Workbench:AmigaE/Sources/IFF
 ECOPT   ERRLINE
 EXENAME IFFComment
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

-><
->> DEFINITIONS GLOBALES

ENUM READ_ANNO,CHECK_ANNO

DEF objsource[256]:STRING
DEF comment[256]:STRING
DEF chunkname[5]:STRING

-><
->> main()
PROC main()
    DEF myargs:PTR TO LONG,rdargs=NIL
    myargs:=[0,0,0,0]
    VOID '$VER: IFFComment 1.0 (16.11.95) © NasGûl'
    IF iffparsebase:=OpenLibrary('iffparse.library',0)
        IF rdargs:=ReadArgs('Fichier/A,ID=ChunkID/k,R=ReadComment/S,Comment/F',myargs,NIL)
            IF myargs[0] THEN StrCopy(objsource,myargs[0],ALL)
            IF myargs[1]
                StrCopy(chunkname,myargs[1],4)
            ELSE
                JUMP fin
            ENDIF
            IF myargs[2] THEN readComment(READ_ANNO)
            IF myargs[3]
                StrCopy(comment,myargs[3],ALL)
                IF Even(EstrLen(comment)) THEN NOP ELSE StrAdd(comment,' ',1)
                IF Not(myargs[2]) THEN writeComment()
            ENDIF
            fin:
            IF rdargs THEN FreeArgs(rdargs)
        ELSE
            WriteF('Bad Args\n')
        ENDIF
        CloseLibrary(iffparsebase)
    ELSE
        WriteF('iffparse.library ?.\n')
    ENDIF
ENDPROC
-><
->> writeComment()
PROC writeComment()
    DEF fh,buffer,read,len,fs,adr,lencom,test
    lencom:=EstrLen(comment)
    len:=FileLength(objsource)
    test:=readComment(CHECK_ANNO)
    IF test=FALSE
        IF len<>-1
            IF buffer:=New(len)
                IF fh:=Open(objsource,OLDFILE)
                    read:=Read(fh,buffer,len)
                    IF fh THEN Close(fh)
                    IF read=len
                        IF fs:=Open(objsource,1006)
                            adr:=buffer
                            read:=adr+4
                            ^read:=(len-8)+lencom+8
                            read:=Write(fs,buffer,len)
                            IF read=len
                                read:=Write(fs,[Long(chunkname)]:LONG,4)
                                IF read=4
                                    Write(fs,[lencom]:LONG,4)
                                    Write(fs,comment,lencom)
                                ELSE
                                    WriteF('probl\n')
                                ENDIF
                            ENDIF
                            IF fs THEN Close(fs)
                        ENDIF
                    ELSE
                        WriteF('probl\n')
                    ENDIF
                ENDIF
                IF buffer THEN Dispose(buffer)
            ENDIF
        ENDIF
    ELSE
        WriteF('\s a déjà un commentaire.\n',objsource)
    ENDIF
ENDPROC
-><
->> readComment(act)
PROC readComment(act)
    DEF iff=NIL:PTR TO iffhandle
    DEF error
    DEF h,i
    DEF curchunk:PTR TO contextnode
    DEF anno,ret=FALSE,rlen,buffer
    IF iff:=AllocIFF()
        IF h:=Open(objsource,1005)
            iff.stream:=h
            InitIFFasDOS(iff)
            error:=OpenIFF(iff,IFFF_READ)
            IF checkIFFError(error)
                WHILE 1
                    error:=ParseIFF(iff,IFFPARSE_RAWSTEP)
                    IF checkIFFError(error)
                        curchunk:=CurrentChunk(iff)
                        IF (error=0) OR  (error=IFFERR_EOC)
                            anno:=curchunk.id
                            IF (anno=Long(chunkname))
                                IF act=READ_ANNO
                                    IF error=0
                                        ->WriteF('ID :$\h Depth:\d\n',curchunk.id,iff.depth)
                                        ->WriteF('Type:\h Size:\d\n',curchunk.type,curchunk.size)
                                        ->WriteF('Scan: \h\n',curchunk.scan)
                                        IF buffer:=New(curchunk.size)
                                            rlen:=ReadChunkBytes(iff,buffer,curchunk.size)
                                            WriteF('<<\s>> \s\n',objsource,buffer)
                                            Dispose(buffer)
                                        ENDIF
                                    ENDIF
                                ELSEIF act=CHECK_ANNO
                                    ret:=TRUE
                                ENDIF
                            ENDIF
                        ENDIF
                    ELSE
                        ->WriteF('error :\d\n',error)
                        JUMP ex
                    ENDIF
                ENDWHILE
                ex:
                CloseIFF(iff)
            ENDIF
            CloseIFF(iff)
            IF iff.stream THEN Close(iff.stream)
        ENDIF
        FreeIFF(iff)
    ELSE
        WriteF('AllocIFF() Failed.\n')
    ENDIF
    RETURN ret
ENDPROC
-><
->> checkIFFError(er)
PROC checkIFFError(er)
    SELECT er
        CASE 0;          RETURN TRUE
        CASE IFFERR_EOF; RETURN FALSE
        CASE IFFERR_EOC; RETURN TRUE
        CASE IFFERR_NOMEM
            WriteF('IFFERR_NOMEM\n')
            RETURN FALSE
        CASE IFFERR_MANGLED
            WriteF('IFFERR_MANGLED\n')
            RETURN FALSE
        CASE IFFERR_SYNTAX
            WriteF('IFFERR_SYNTAX\n')
            RETURN FALSE
        CASE IFFERR_NOTIFF
            WriteF('IFFERR_NOTIFF\n')
            RETURN FALSE
        CASE IFFERR_SEEK
            WriteF('IFFERR_SEEK\n')
            RETURN FALSE
    ENDSELECT
ENDPROC
-><


