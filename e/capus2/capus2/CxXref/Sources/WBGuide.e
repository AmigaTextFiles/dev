/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '3'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 0.1 - Display DataTypes on the WB screen.
       (Amigaguide,Gif,Bmp,etc...)
 0.2 - Multi Arg (the last document quit all documents).
 0.3 - Add Xref Arguments.
 ===============================*/


MODULE 'amigaguide','libraries/amigaguide'
MODULE 'exec/lists','exec/nodes'
MODULE 'intuition/intuitionbase'

CONST DEBUG=FALSE
ENUM ASYNC,NOASYNC

OBJECT filenode
    node:ln
    newag:LONG
    handle:LONG
ENDOBJECT

PMODULE 'Pmodules:PlistNoSort'
PMODULE 'PModules:DWriteF'

DEF mylist:PTR TO lh
DEF req=FALSE
DEF screen=NIL
DEF xr=FALSE
/*"main()"*/
PROC main()
    DEF test,rdargs=NIL,myargs:PTR TO LONG
    DEF source[80]:STRING
    DEF marg:PTR TO LONG,b,fln:PTR TO filenode
    DEF intui:PTR TO intuitionbase
    myargs:=[0,0,0,0]
    VOID {banner}
    IF amigaguidebase:=OpenLibrary('amigaguide.library',39)
        IF rdargs:=ReadArgs('Amigaguide/M,Req/S,ActiveScreen/S,XRef/S',myargs,NIL)
            mylist:=p_InitList()
            IF myargs[1] THEN req:=TRUE
            IF myargs[2]
                intui:=intuitionbase
                screen:=intui.activescreen
            ENDIF
            IF myargs[3] THEN xr:=TRUE
            IF myargs[0]
                marg:=myargs[0]
                FOR b:=0 TO 9
                    IF marg[b]<>0
                        IF b=0 THEN StrCopy(source,Long(myargs[0]),ALL) ELSE StrCopy(source,marg[b],ALL)
                        IF (EstrLen(source)<>0)
                            fln:=New(SIZEOF filenode)
                            fln.handle:=0
                            fln.newag:=0
                            p_AjouteNode(mylist,source,fln)
                        ENDIF
                    ENDIF
                ENDFOR
                IF xr=FALSE
                    p_ShowFileNode(mylist)
                ELSE
                    p_ShowXrefNode(mylist)
                ENDIF
                p_FreeFileNode(mylist)
            ENDIF
            IF rdargs THEN FreeArgs(rdargs)
        ELSE
        ENDIF
        IF amigaguidebase THEN CloseLibrary(amigaguidebase)
    ENDIF
    CleanUp(0)
ENDPROC
/**/
/*"p_ShowFileNode(list:PTR TO lh)"*/
PROC p_ShowFileNode(list:PTR TO lh)
    DEF count=0,b,nn:PTR TO ln
    DEF key
    IF key:=LockAmigaGuideBase(NIL)
        count:=p_CountNodes(list)
        nn:=p_GetAdrNode(list,count-1)
        IF req=TRUE THEN EasyRequestArgs(0,[20,0,0,'le fichier "\s" quitte tous les documents.','Ok'],0,[nn.name])
        FOR b:=0 TO count-2
            p_NewShowAmigaGuideFile(p_GetAdrNode(mylist,b),ASYNC,'main',0)
        ENDFOR
        p_NewShowAmigaGuideFile(p_GetAdrNode(mylist,count-1),NOASYNC,'main',0)
        IF key THEN UnlockAmigaGuideBase(key)
    ENDIF
ENDPROC
/**/
/*"p_ShowXrefNode(list:PTR TO lh)"*/
PROC p_ShowXrefNode(list:PTR TO lh)
    DEF n:PTR TO ln
    DEF pn:PTR TO ln
    DEF nx:PTR TO xref
    DEF o:PTR TO filenode
    DEF key,t,xreflist:PTR TO lh,lastnum,count=0,pv[80]:STRING
    IF key:=LockAmigaGuideBase(NIL)
        IF t:=GetAmigaGuideAttr(AGA_XREFLIST,NIL,xreflist)
            n:=list.head
            WHILE n
                IF n.succ<>0
                    t:=FindName(xreflist,n.name)
                    IF t<>0 THEN lastnum:=count
                    count:=count+1
                ENDIF
                n:=n.succ
            ENDWHILE
            count:=0
            n:=list.head
            WHILE n
                IF n.succ<>0
                    pn:=o:=n
                    t:=FindName(xreflist,n.name)
                    StringF(pv,'\s',n.name)
                    IF t<>0
                        nx:=t
                        IF (count<>lastnum)
                            pn.name:=nx.file
                            p_NewShowAmigaGuideFile(p_GetAdrNode(mylist,count),ASYNC,pv,nx.line)
                        ELSE
                            pn.name:=nx.file
                            p_NewShowAmigaGuideFile(p_GetAdrNode(mylist,count),NOASYNC,pv,nx.line)
                        ENDIF
                    ENDIF
                    count:=count+1
                ENDIF
                n:=n.succ
            ENDWHILE
        ENDIF
        IF key THEN UnlockAmigaGuideBase(key)
    ENDIF
ENDPROC
/**/
/*"p_NewShowAmigaGuideFile(of:PTR TO filenode,mode,nod)"*/
PROC p_NewShowAmigaGuideFile(of:PTR TO filenode,mode,nod,lin)
    DEF myag:PTR TO newamigaguide
    DEF n:PTR TO ln
    DEF h=0,r=NIL
    DEF cmd[256]:STRING,pv[256]:STRING
    IF myag:=New(SIZEOF newamigaguide)
        n:=of
        myag.name:=n.name
        myag.node:=nod
        myag.screen:=screen
        myag.line:=lin
        myag.flags:=HTF_CACHE_NODE+HTF_UNIQUE
        myag.client:=NIL
        IF mode=ASYNC
            h:=OpenAmigaGuideAsync(myag,NIL)
        ELSEIF mode=NOASYNC
            h:=OpenAmigaGuide(myag,NIL)
            CloseAmigaGuide(h)
            h:=0
        ENDIF
        IF h<>0
            StringF(pv,'Link "\s/\s"',n.name,nod)
            StrCopy(cmd,pv,ALL)
            Delay(10)
            SendAmigaGuideCmd(h,cmd,NIL)
            r:=IoErr()
            IF r=0
                of.handle:=h
                of.newag:=myag
                dWriteF(['Handle \h',' Myag \h\n'],[h,myag])
            ENDIF
        ENDIF
    ENDIF
    RETURN r
ENDPROC
/**/
/*"p_FreeFileNode(list:PTR TO lh)"*/
PROC p_FreeFileNode(list:PTR TO lh)
    DEF n:PTR TO ln
    DEF f:PTR TO filenode
    n:=list.head
    WHILE n
        IF n.succ<>0
            f:=n
            dWriteF(['FreeHandle \h\n'],[f.handle])
            IF f.handle<>0 THEN CloseAmigaGuide(f.handle)
            IF f.newag<>0 THEN Dispose(f.newag)
        ENDIF
        n:=n.succ
    ENDWHILE
ENDPROC
/**/








