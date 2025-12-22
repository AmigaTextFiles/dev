->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE EJDisk.e
 EDIR    Workbench:AmigaE/Sources/SCSI
 ECOPT   ERRLINE
 EXENAME EJDisk
 MAKE    EBUILD
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
OPT PREPROCESS
OPT OSVERSION=37
->#define DBG
->> MODULES

MODULE 'tools/easygui'
MODULE 'exec/lists','exec/io','exec/ports','exec/nodes','other/plist'
MODULE 'workbench/workbench','workbench/startup','icon'
MODULE 'commodities','libraries/commodities'
MODULE 'dos/rdargs','dos/dosextens','dos/dos'
MODULE 'amigalib/cx','amigalib/io','amigalib/ports','devices/scsidisk'

MODULE '*EJDiskHeader'

-><
->> OBJECTS


OBJECT removal
    node:ln
    devicename:LONG
    unit:LONG
    hkeject:LONG
    aftereject:LONG
    hkload:LONG
    afterload:LONG
ENDOBJECT

-><
->> DEFINITIONS GLOBALES

CONST EVT_HOTKEY=-1

CONST ER_NONE=TRUE
ENUM ER_ONLYWB=1,ER_LIB,ER_BRKR,ER_PORT,ER_CXER,ER_HOTK

RAISE ER_BRKR IF CxBroker()=NIL,
      ER_PORT IF CreateMsgPort()=NIL



DEF removallist:PTR TO lh        -> list exec
DEF cxhotkey[256]:STRING         -> cx hotkey definition
DEF mycxport=NIL:PTR TO mp       -> port OF cx
DEF broker=NIL
DEF scsieject:PTR TO CHAR
DEF scsiload:PTR TO CHAR
-><
->> openLibraries() HANDLE
PROC openLibraries() HANDLE
    IF (cxbase:=OpenLibrary('commodities.library',0))=NIL THEN Raise(ER_LIB)
    IF (iconbase:=OpenLibrary('icon.library',0))=NIL THEN Raise(ER_LIB)
    Raise(ER_NONE)
EXCEPT
    #ifdef DBG
        WriteF('openLibraries() RETURN:$\h\n',exception)
    #endif
    RETURN exception
ENDPROC
-><
->> closeLibraries()
PROC closeLibraries()
    IF iconbase THEN CloseLibrary(iconbase)
    IF cxbase THEN CloseLibrary(cxbase)
    #ifdef DBG
        WriteF('closeLibraries()\n')
    #endif
ENDPROC
-><
->> lookMessage()
PROC lookMessage()
    DEF msg,sigret,quit=FALSE
    DEF msgid,msgtype
    REPEAT
        sigret:=Wait(Shl(1,mycxport.sigbit) OR SIGBREAKF_CTRL_C)
        IF (sigret AND Shl(1,mycxport.sigbit))
            WHILE msg:=GetMsg(mycxport)
                msgid:=CxMsgID(msg)
                msgtype:=CxMsgType(msg)
                ReplyMsg(msg)
                SELECT msgtype
                    CASE CXM_IEVENT
                        SELECT msgid
                            CASE -1
                                showHotKey()
                            DEFAULT
                                performAction(msgid)
                        ENDSELECT
                    CASE CXM_COMMAND
                        SELECT msgid
                            CASE CXCMD_DISABLE
                                ActivateCxObj(broker,FALSE)
                            CASE CXCMD_ENABLE
                                ActivateCxObj(broker,TRUE)
                            CASE CXCMD_KILL
                                quit:=TRUE
                            CASE CXCMD_UNIQUE
                                quit:=TRUE
                        ENDSELECT
                ENDSELECT
            ENDWHILE
        ENDIF
        IF (sigret AND SIGBREAKF_CTRL_C)
                quit:=TRUE
        ENDIF
    UNTIL (quit=TRUE)
ENDPROC
-><
->> performAction(numid)
PROC performAction(numid)
    DEF pr:PTR TO removal
    DEF scsiio:PTR TO iostd
    DEF scsiport:PTR TO mp
    DEF myscsi:PTR TO scsicmd,ej=TRUE,ret=0
    DEF f
    IF Even(numid)
        pr:=getInfoNode(removallist,numid/2,GETWITH_NUM,RETURN_ADR)
    ELSE
        pr:=getInfoNode(removallist,(numid-1)/2,GETWITH_NUM,RETURN_ADR)
        ej:=FALSE
    ENDIF
    IF pr<>-1
        IF scsiport:=createPort(NIL,NIL)
            IF scsiio:=createStdIO(scsiport)
                f:=OpenDevice(pr.devicename,pr.unit,scsiio,0)
                IF (f)
                    EasyRequestArgs(0,[20,0,0,'Erreur: OpenDevice() \s','Ok'],0,[pr.devicename])
                    deleteStdIO(scsiio)
                    deletePort(scsiport)
                ELSE
                    IF myscsi:=New(SIZEOF scsicmd)
                        myscsi.data:=0
                        myscsi.length:=0
                        myscsi.senseactual:=0
                        myscsi.sensedata:=0
                        myscsi.senselength:=0
                        IF ej
                            myscsi.command:=scsieject
                        ELSE
                            myscsi.command:=scsiload
                        ENDIF
                        myscsi.cmdlength:=6
                        myscsi.flags:=SCSIF_READ OR SCSIF_AUTOSENSE
                        scsiio.length:=SIZEOF scsicmd
                        scsiio.data:=myscsi
                        scsiio.command:=HD_SCSICMD
                        DoIO(scsiio)
                        IF scsiio.error<>0
                            Delay(10)
                            DoIO(scsiio)
                            IF scsiio.error<>0
                                ret:=scsiio.error
                                EasyRequestArgs(0,[20,0,0,'Erreur: DoIO() \d','Ok'],0,[scsiio.error])
                            ENDIF
                        ENDIF
                        CloseDevice(scsiio)
                        deleteStdIO(scsiio)
                        deletePort(scsiport)
                        IF myscsi THEN Dispose(myscsi)
                    ENDIF
                ENDIF
            ELSE
                EasyRequestArgs(0,[20,0,0,'Erreur: createStdIO()','Ok'],0,0)
            ENDIF
        ELSE
            EasyRequestArgs(0,[20,0,0,'Erreur: createPort()','Ok'],0,0)
        ENDIF
    ENDIF
    Delay(20)
    IF ret=0
        IF ej 
            Execute(pr.aftereject,0,stdout)
        ELSE
            Execute(pr.afterload,0,stdout)
        ENDIF
    ENDIF

ENDPROC
-><
->> main() HANDLE
PROC main() HANDLE
    DEF t,msg,hotkey
    VOID PRG_VER
    scsieject:=[$1B,0,0,0,2,0]:CHAR
    scsiload :=[$1B,0,0,0,3,0]:CHAR
    IF wbmessage=NIL THEN Raise(ER_ONLYWB)
    IF (t:=openLibraries())<>ER_NONE THEN Raise(t)
    getEjectDef()
    mycxport:=CreateMsgPort()
    broker:=CxBroker([NB_VERSION,0,'EJDisk','Ejecteur de disque SCSI','© 1996 NasGûl',
                      NBU_UNIQUE OR NBU_NOTIFY,
                      0,0,0,mycxport,0]:newbroker,NIL)
    IF hotkey:=hotKey(cxhotkey,mycxport,EVT_HOTKEY)
        AttachCxObj(broker,hotkey)
        IF CxObjError(hotkey)<>FALSE
            Raise(ER_CXER)
        ELSE
            IF (t:=activeOtherHotKey())<>ER_NONE THEN Raise(t)
            ActivateCxObj(broker,TRUE)
            lookMessage()
        ENDIF
    ELSE
        Raise(ER_HOTK)
    ENDIF
EXCEPT DO
  IF broker THEN DeleteCxObjAll(broker)
  IF mycxport
    WHILE msg:=GetMsg(mycxport) DO ReplyMsg(msg)
    DeleteMsgPort(mycxport)
  ENDIF
    closeLibraries()
    SELECT exception
        CASE ER_ONLYWB; EasyRequestArgs(0,[20,0,0,'Seulement du Workbench','Ok'],0,0)
        CASE ER_LIB;    EasyRequestArgs(0,[20,0,0,'Erreur: OpenLibrary()','Ok'],0,0)
        CASE ER_BRKR;   EasyRequestArgs(0,[20,0,0,'Erreur: CxBroker()','Ok'],0,0)
        CASE ER_PORT;   EasyRequestArgs(0,[20,0,0,'Erreur: CreateMsgPort()','Ok'],0,0)
        CASE ER_CXER;   EasyRequestArgs(0,[20,0,0,'Erreur: hotKey()','Ok'],0,0)
        CASE ER_HOTK;   EasyRequestArgs(0,[20,0,0,'Erreur: Touche d''appel invalide\n\s','Ok'],0,[cxhotkey])
    ENDSELECT
ENDPROC
-><
->> activeOtherHotKey() HANDLE
PROC activeOtherHotKey() HANDLE
    DEF pr:PTR TO removal
    DEF phk
    DEF i=0
    pr:=removallist.head
    WHILE pr
        IF pr.node.succ<>0
            IF phk:=hotKey(pr.hkeject,mycxport,i)
                AttachCxObj(broker,phk)
                IF CxObjError(phk)<>FALSE
                    EasyRequestArgs(0,[20,0,0,'Touche d''appel invalide\n\s','Ok'],0,[pr.hkeject])
                    Raise(ER_CXER)
                ENDIF
            ELSE
                EasyRequestArgs(0,[20,0,0,'Touche d''appel invalide\n\s','Ok'],0,[pr.hkeject])
                Raise(ER_HOTK)
            ENDIF
            INC i
            IF phk:=hotKey(pr.hkload,mycxport,i)
                AttachCxObj(broker,phk)
                IF CxObjError(phk)<>FALSE
                    EasyRequestArgs(0,[20,0,0,'Touche d''appel invalide\n\s','Ok'],0,[pr.hkload])
                    Raise(ER_CXER)
                ENDIF
            ELSE
                EasyRequestArgs(0,[20,0,0,'Touche d''appel invalide\n\s','Ok'],0,[pr.hkload])
                Raise(ER_HOTK)
            ENDIF
            INC i
        ENDIF
        pr:=pr.node.succ
    ENDWHILE
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
-><
->> getEjectDef()
PROC getEjectDef()
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF prgname[256]:STRING
    DEF ps[256]:STRING
    DEF mydo:PTR TO diskobject,oldlock,test:PTR TO LONG
    DEF m:PTR TO LONG,myremoval:PTR TO removal
    DEF pivstr[256]:STRING
    DEF s_name[256]:STRING
    DEF s_dev[256]:STRING
    DEF s_unit
    DEF s_hke[256]:STRING
    DEF s_hkl[256]:STRING
    DEF s_ae[256]:STRING
    DEF s_al[256]:STRING
    #ifdef DBG
        WriteF('getEjectDef()\n')
    #endif
    wb:=wbmessage
    args:=wb.arglist
    StrCopy(prgname,args[0].name,ALL)
    oldlock:=CurrentDir(args[0].lock)
    IF mydo:=GetDiskObject(prgname)
        IF ps:=FindToolType(mydo.tooltypes,'CX_POPKEY')
            StrCopy(cxhotkey,ps,ALL) 
        ELSE 
            StrCopy(cxhotkey,'alt ctrl esc',ALL)
        ENDIF
        test:=mydo.tooltypes
        removallist:=initList()
        REPEAT
            IF StrCmp(Long(test),'REMOVALNAME',11)
                StrCopy(pivstr,Long(test),ALL)
                m:=[0,0,0,0,0,0,0]
                IF getArg(pivstr,'REM=REMOVALNAME/K,D=DEVICE/K,U=UNIT/K/N,HE=HKE/K,HL=HKL/K,AE=AFTEREJECT/K,AL=AFTERLOAD/K',m)
                    StringF(s_name,'\s',m[0])
                    StringF(s_dev,'\s',m[1])
                    s_unit:=Long(m[2])
                    StringF(s_hke,'\s',m[3])
                    StringF(s_hkl,'\s',m[4])
                    StringF(s_ae,'\s',m[5])
                    StringF(s_al,'\s',m[6])
                    IF myremoval:=New(SIZEOF removal)

                        myremoval.devicename:=String(EstrLen(s_dev))
                        StrCopy(myremoval.devicename,s_dev,ALL)

                        myremoval.unit:=s_unit
                        
                        myremoval.hkeject:=String(EstrLen(s_hke))
                        StrCopy(myremoval.hkeject,s_hke,ALL)

                        myremoval.hkload:=String(EstrLen(s_hkl))
                        StrCopy(myremoval.hkload,s_hkl,ALL)

                        myremoval.aftereject:=String(EstrLen(s_ae))
                        StrCopy(myremoval.aftereject,s_ae,ALL)

                        myremoval.afterload:=String(EstrLen(s_al))
                        StrCopy(myremoval.afterload,s_al,ALL)


                        addNode(removallist,s_name,myremoval,0)
                    
                    ENDIF
                    m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0;m[5]:=0;m[6]:=0
                ELSE
                    EasyRequestArgs(0,[20,0,0,'Définition Invalide\n\s','Ok'],0,[pivstr])
                ENDIF
            ENDIF
            test++
        UNTIL (Long(test)=NIL)
        IF mydo THEN FreeDiskObject(mydo)
    ELSE
        EasyRequestArgs(0,[20,0,0,'Erreur: GetDiskObject()','Ok',0],0,0)
    ENDIF
    CurrentDir(oldlock)
ENDPROC
-><
->> getArg(argu,temp,a:PTR TO LONG)
PROC getArg(argu,temp,a:PTR TO LONG)
    DEF myc:PTR TO csource
    DEF ma:PTR TO rdargs
    DEF rdarg=NIL
    DEF argstr[256]:STRING
    DEF ret=NIL
    #ifdef DBG
        WriteF('getArg(\s,\s,$\h)\n',argu,temp,a)
    #endif
    StrCopy(argstr,argu,ALL)
    StrAdd(argstr,'\n',1)
    IF ma:=AllocDosObject(DOS_RDARGS,NIL)
        myc:=New(SIZEOF csource)
        myc.buffer:=argstr
        myc.length:=EstrLen(argstr)
        ma.flags:=4
        CopyMem(myc,ma.source,SIZEOF csource)
        IF rdarg:=ReadArgs(temp,a,ma)
            ret:=a
            IF rdarg THEN FreeArgs(rdarg)
        ELSE
        ENDIF
        FreeDosObject(DOS_RDARGS,ma)
    ELSE
        EasyRequestArgs(0,[20,0,0,'Erreur: AllocDosObject()','Ok'],0,0)
    ENDIF
    RETURN ret
ENDPROC
-><
->> showHotKey()
PROC showHotKey()
    DEF pr:PTR TO removal
    DEF buffer[1000]:STRING
    DEF pivbuf[256]:STRING
    pr:=removallist.head
    WHILE pr
        IF pr.node.succ<>0
            StringF(pivbuf,'\s \s \d\nEject:"\s" Load :"\s"\n',pr.node.name,pr.devicename,pr.unit,pr.hkeject,pr.hkload)
            StrAdd(buffer,pivbuf,ALL)
        ENDIF
        pr:=pr.node.succ
    ENDWHILE
    EasyRequestArgs(0,[20,0,0,'\s','Ok'],0,[buffer])
ENDPROC
-><

