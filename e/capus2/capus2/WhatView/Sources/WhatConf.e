/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '01'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 - Convertit les fichiers prefs de whatview,
   D'Ascii en binaire et vice-vers-ça.

 ===============================*/


MODULE 'dos/dos'
MODULE 'dos/rdargs'
MODULE 'dos/dosextens'
MODULE 'exec/lists','exec/nodes'
MODULE 'wvprefs'


PMODULE 'WhatConfList'

DEF mylist:PTR TO lh
DEF testlist:PTR TO lh
DEF defact=-1
/*"main()"*/
PROC main()
    DEF rdargs=NIL,myargs:PTR TO LONG
    myargs:=[0,0,0]
    VOID {banner}
    IF rdargs:=ReadArgs('Source,Destination,SaveBin/S',myargs,NIL)
        mylist:=p_InitList()
        testlist:=p_InitList()
        IF myargs[2]
            WriteF('Read Ascii file..\n')
            p_ReadAsciiFile(myargs[0])
            WriteF('Save Binary file..\n')
            p_SaveBinFile(mylist,myargs[1])
            JUMP end
        ELSE
            WriteF('Read Binary file..\n')
            p_ReadBinFile(myargs[0])
            WriteF('Save Ascii file..\n')
            p_SaveAsciiFile(mylist,myargs[1])
            JUMP end
        ENDIF
        end:
        IF rdargs THEN FreeArgs(rdargs)
    ELSE
        WriteF('Bad args!\n')
    ENDIF
ENDPROC
/**/

/*"p_SaveBinFile(list:PTR TO lh,fichier)"*/
PROC p_SaveBinFile(list:PTR TO lh,fichier)
    DEF sactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF h
    IF h:=Open(fichier,1006)
        Write(h,[ID_WVPR]:LONG,4)
        sactnode:=list.head
        WHILE sactnode
            node:=sactnode
            IF node.succ<>0
                Write(h,[ID_WVAC]:LONG,4)
                Write(h,[sactnode.exectype]:INT,2)
                Write(h,[sactnode.stack]:LONG,4)
                Write(h,[sactnode.priority]:INT,2)
                Write(h,[sactnode.usesubtype]:INT,2)
                Write(h,node.name,EstrLen(node.name))
                IF Even(EstrLen(node.name))
                    Out(h,0)
                    Out(h,0)
                ELSE
                    Out(h,0)
                ENDIF
                Write(h,sactnode.command,EstrLen(sactnode.command))
                IF Even(EstrLen(sactnode.command))
                    Out(h,0)
                    Out(h,0)
                ELSE
                    Out(h,0)
                ENDIF
                Write(h,sactnode.currentdir,EstrLen(sactnode.currentdir))
                IF Even(EstrLen(sactnode.currentdir))
                    Out(h,0)
                    Out(h,0)
                ELSE
                    Out(h,0)
                ENDIF
            ENDIF
            sactnode:=node.succ
        ENDWHILE
        Write(h,[ID_DEFA]:LONG,4)
        Write(h,[defact]:LONG,4)
        IF h THEN Close(h)
    ENDIF
ENDPROC
/**/
/*"p_ReadBinFile(source)"*/
PROC p_ReadBinFile(source)
    DEF len,a,adr,buf,handle,flen=TRUE,pos:PTR TO CHAR
    DEF chunk
    DEF pv[256]:STRING
    DEF node:PTR TO ln
    DEF addact:PTR TO actionnode
    DEF nn=NIL
    IF (flen:=FileLength(source))=-1 THEN RETURN FALSE
    IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
    IF (handle:=Open(source,1005))=NIL THEN RETURN FALSE
    len:=Read(handle,buf,flen)
    Close(handle)
    IF len<1 THEN RETURN FALSE
    adr:=buf
    chunk:=Long(adr)
    IF chunk<>ID_WVPR
        Dispose(buf)
        RETURN FALSE
    ENDIF
    FOR a:=0 TO len-1
        pos:=adr++
        IF Even(pos)
            chunk:=Long(pos)
            SELECT chunk
                CASE ID_WVAC
                    pos:=pos+4
                    node:=New(SIZEOF ln)
                    addact:=New(SIZEOF actionnode)
                    addact.exectype:=Int(pos)
                    addact.stack:=Long(pos+2)
                    addact.priority:=Int(pos+6)
                    addact.usesubtype:=Int(pos+8)
                    StringF(pv,'\s',pos+10)
                    node.name:=String(EstrLen(pv))
                    node.succ:=0
                    StrCopy(node.name,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+10+EstrLen(pv)+2
                    ELSE
                        pos:=pos+10+EstrLen(pv)+1
                    ENDIF
                    StringF(pv,'\s',pos)
                    addact.command:=String(EstrLen(pv))
                    StrCopy(addact.command,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+EstrLen(pv)+2
                    ELSE
                        pos:=pos+EstrLen(pv)+1
                    ENDIF
                    StringF(pv,'\s',pos)
                    addact.currentdir:=String(EstrLen(pv))
                    StrCopy(addact.currentdir,pv,ALL)
                    IF Even(EstrLen(pv))
                        pos:=pos+EstrLen(pv)+2
                    ELSE
                        pos:=pos+EstrLen(pv)+1
                    ENDIF
                    nn:=p_AjouteNode(mylist,node.name,addact)
                    IF node THEN Dispose(node)
                CASE ID_DEFA
                    pos:=pos+4
                    defact:=Long(pos)
            ENDSELECT
        ENDIF
    ENDFOR
    Dispose(buf)
    RETURN TRUE
ENDPROC
/**/


/*"p_SaveAsciiFile(list:PTR TO lh,fichier)"*/
PROC p_SaveAsciiFile(list:PTR TO lh,fichier)
    DEF sactnode:PTR TO actionnode
    DEF node:PTR TO ln
    DEF h,us
    DEF outstr[256]:STRING
    IF h:=Open(fichier,1006)
        sactnode:=list.head
        WHILE sactnode
            node:=sactnode
            IF node.succ<>0
                us:=sactnode.usesubtype
                StringF(outstr,'Type "\s" Com "\s" Dir "\s" Mode "\d" Pri "\d" Stack "\d" \s\n',
                                node.name,sactnode.command,sactnode.currentdir,
                                sactnode.exectype,sactnode.priority,sactnode.stack,
                                IF us<>FALSE THEN 'UseParent' ELSE '')
                Write(h,outstr,EstrLen(outstr))
            ENDIF
            sactnode:=node.succ
        ENDWHILE
        IF h THEN Close(h)
    ENDIF
ENDPROC
/**/
/*"p_ReadAsciiFile(str)"*/
PROC p_ReadAsciiFile(str)
    DEF fh,buf[1000]:ARRAY,numline=1
    DEF nom[256]:STRING,rn[256]:STRING
    DEF m:PTR TO LONG
    DEF test
    DEF addact:PTR TO actionnode,nn
    DEF str_name[80]:STRING,str_com[80]:STRING,str_dir[256]:STRING
    DEF mode,pri,st,usep
    IF fh:=Open(str,OLDFILE)
        WHILE test:=Fgets(fh,buf,1000)
                StringF(nom,'\s',test)
                StrCopy(rn,test,(EstrLen(test)-1))
                m:=[0,0,0,0,0,0,0]
                IF getArg(rn,'Type/K,Com/K,Dir/K,Mode/K/N,Pri/K/N,Stack/K/N,UseParent/S',m)
                    /*
                    WriteF('Type :\s Com:\s Dir:\s Mode:\d Pri:\d Stack:\d UseParent:\d\n',
                            m[0],m[1],m[2],Long(m[3]),Long(m[4]),Long(m[5]),Long(m[6]))
                    */
                    StringF(str_name,'\s',m[0])
                    StringF(str_com,'\s',m[1])
                    StringF(str_dir,'\s',m[2])
                    mode:=Long(m[3])
                    pri:=Long(m[4])
                    st:=Long(m[5])
                    usep:=m[6]
                    /*===========================*/
                    /*===========================*/
                    addact:=New(SIZEOF actionnode)
                    addact.exectype:=mode
                    addact.stack:=st
                    addact.priority:=pri
                    IF usep THEN addact.usesubtype:=TRUE ELSE addact.usesubtype:=FALSE
                    addact.command:=String(EstrLen(str_com))
                    StrCopy(addact.command,str_com,ALL)
                    addact.currentdir:=String(EstrLen(str_dir))
                    StrCopy(addact.currentdir,str_dir,ALL)
                    /*===============================*/
                    /*===============================*/
                    p_AjouteNode(testlist,str_name,0)
                    nn:=p_AjouteNode(mylist,str_name,addact)
                ELSE
                    WriteF('Error in line \d\n',numline)
                    JUMP fin
                ENDIF
                m[0]:=0;m[1]:=0;m[2]:=0;m[3]:=0;m[4]:=0;m[5]:=0;m[6]:=0
                numline:=numline+1
        ENDWHILE
        fin:
        Close(fh)
    ENDIF
ENDPROC
/**/

/*"getArg(argu,temp,a:PTR TO LONG)"*/
PROC getArg(argu,temp,a:PTR TO LONG)
    DEF myc:PTR TO csource
    DEF ma:PTR TO rdargs
    DEF rdarg=NIL
    DEF argstr[256]:STRING
    DEF ret=NIL
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
        WriteF('AllocDosObject failed !!\n')
    ENDIF
    RETURN ret
ENDPROC
/**/
