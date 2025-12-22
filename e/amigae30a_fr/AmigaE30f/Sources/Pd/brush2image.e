/*
        ILBM brush to Image.
*/
MODULE 'dos/dos','intuition/intuition','asl','libraries/asl',
'libraries/iffparse','iffparse','utility/tagitem'
ENUM NOERROR,ER_LIBRARY,ER_NOMEM,ER_NOASLREQUEST,ER_FILENOTFOUND,ER_IFFERROR,
        ER_NOBMHD
CONST ID_ILBM=$494C424D
CONST ID_BMHD=$424D4844
CONST ID_BODY=$424F4459
CONST ID_CMAP=$434D4150

DEF iff:PTR TO iffhandle

PROC main()
        DEF req:PTR TO filerequester,source[256]:STRING,err,xsize,ysize,depth,bmhd,
        body,cmap,camg,cflag,p:PTR TO INT,bp:PTR TO CHAR,sp:PTR TO storedproperty

        IF KickVersion(37)=FALSE
                WriteF('Sorry, Kickstart V37+ Required.\n')
                getout(0)
        ENDIF
        IF (aslbase:=OpenLibrary('asl.library',37))=0
                error(ER_LIBRARY,'asl')
        ENDIF
        IF (iffparsebase:=OpenLibrary('iffparse.library',37))=0
                error(ER_LIBRARY,'iffparse')
        ENDIF
        IF (req:=AllocAslRequest(ASL_FILEREQUEST,[ASL_HAIL,'Choisissez l'ILBM à convertir',0]:tagitem))>0
                IF AslRequest(req,0)=0
                        FreeAslRequest(req)
                        getout(0)
                ELSE
                        StrCopy(source,req.drawer,ALL) ; AddPart(source,req.file,256) ; SetStr(source,StrLen(source))
                ENDIF
        ELSE
                error(ER_NOASLREQUEST,0)
        ENDIF
        IF FileLength(source)>0
                IF (iff:=AllocIFF())>0
                        iff.stream:=Open(source,MODE_OLDFILE)
                        InitIFFasDOS(iff)
                        IF (err:=OpenIFF(iff,IFFF_READ))=0
                                IF (err:=PropChunk(iff,"ILBM","BMHD"))=0
                                        IF (err:=ParseIFF(iff,IFFPARSE_SCAN)=IFFERR_EOF)
                                                IF (sp:=FindProp(iff,"ILBM","BMHD"))>0
                                                        bmhd:=sp.data
                                                        bp:=p:=bmhd ;xsize:=p[2] ; ysize:=p[3]
                                                        depth:=bp[13] ; cflag:=bp[14]
                                                ELSE
                                                        error(ER_NOBMHD,0)
                                                ENDIF
                                                WriteF('Commence:\z\h[8]Taille X:\d Taille Y:\d Compression:\d Profondeur:\d\n',bmhd,xsize,ysize,cflag,depth)
                                                getout(0)
                                        ELSE
                                                error(ER_IFFERROR,err)
                                        ENDIF
                                ELSE
                                        error(ER_IFFERROR,err)
                                ENDIF
                        ELSE
                                error(ER_IFFERROR,err)
                        ENDIF
                ELSE
                        error(ER_IFFERROR,IFFERR_NOMEM)
                ENDIF
        ELSE
                error(ER_FILENOTFOUND,source)
        ENDIF
ENDPROC
CHAR '$VER: ILBM2Image v.01 (C) 1994 Jason Maskell',0

PROC getout(retcode)
        IF iff
                CloseIFF(iff)
                Close(iff.stream)
                FreeIFF(iff)
        ENDIF
        IF aslbase
                CloseLibrary(aslbase)
        ENDIF
        IF iffparsebase
                CloseLibrary(iffparsebase)
        ENDIF
        CleanUp(retcode)
ENDPROC

PROC error(errnum,str)
        DEF work[80]:STRING
        SELECT errnum
                CASE ER_LIBRARY
                        StringF(work,'Ne peut pas ouvrir la \s.library V37+',str)
                CASE ER_NOMEM
                        StringF(work,'Imposible d'allouer la mémoire.')
                CASE ER_NOASLREQUEST
                        StringF(work,'Impossible d'alouer la requête ASL.')
                CASE ER_FILENOTFOUND
                        StringF(work,'Fichier "\s" non trouvé.',str)
                CASE ER_IFFERROR
                        SELECT str
                                CASE IFFERR_EOC
                                        StringF(work,'Erreur Iffparse: End Of Context')
                                CASE IFFERR_NOSCOPE
                                        StringF(work,'Erreur Iffparse: Novalid scope')
                                CASE IFFERR_NOMEM
                                        StringF(work,'Erreur Iffparse: allocation mémoire interne a failli.')
                                CASE IFFERR_READ
                                        StringF(work,'Erreur Iffparse: Erreur de lecture.')
                                CASE IFFERR_WRITE
                                        StringF(work,'Erreur Iffparse: Erreur d'écriture.')
                                CASE IFFERR_SEEK
                                        StringF(work,'Erreur Iffparse: Erreur de Seek.')
                                CASE IFFERR_MANGLED
                                        StringF(work,'Erreur Iffparse: fichier IFF corrompu.')
                                CASE IFFERR_SYNTAX
                                        StringF(work,'Erreur Iffparse: Erreur de syntaxe IFF.')
                                CASE IFFERR_NOTIFF
                                        StringF(work,'Erreur Iffparse: Pas un fichier IFF.')
                                DEFAULT
                                        StringF(work,'Erreur Iffparse: code erreur inconnu: \d',str)
                        ENDSELECT
                CASE ER_NOBMHD
                        StringF(work,'Pas d'entête bitmap trouvé.Pas un FORM utilisable')
                DEFAULT
                        StringF(work,'Code erreur inconnu: \d',errnum)
        ENDSELECT
        request('Erreur ILBM2Image',work,'Ok',0)
        getout(11)
ENDPROC
PROC request(title,body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,title,body,gadgets],0,args)
