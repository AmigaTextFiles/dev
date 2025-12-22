OPT PREPROCESS
OPT OSVERSION=40
OPT REG=5
OPT STRMERGE

MODULE 'icon'
MODULE 'exec/ports'
MODULE 'exec/memory'
MODULE 'exec/nodes'


OBJECT mymsg
 mn:mn
 new:LONG
 old:LONG
 oldn:LONG
ENDOBJECT

#define NAME 'UseGetIcon'


CONST GETICON = -180,GETDISKOBJ = -78,GETDISKOBJNEW = -132

DEF info

PROC main()
DEF buf,size,port:PTR TO mp,mn:PTR TO mymsg,old,oldn,args[1]:LONG,rdargs
args[0]:=NIL
IF (rdargs:=ReadArgs('QUIET/S',args,NIL))
   info:='can\at open icon.library v44+'
   IF (iconbase:=OpenLibrary('icon.library',44))
      Forbid()
      IF (port:=FindPort(NAME))
         size:=TRUE
         IF (mn:=GetMsg(port))
            old:=SetFunction(iconbase,GETDISKOBJ,mn.old)
            oldn:=SetFunction(iconbase,GETDISKOBJNEW,mn.oldn)
            size:=(old=mn.new) AND (oldn=mn.new)
            IF size
               FreeVec(mn)
            ELSE
               SetFunction(iconbase,GETDISKOBJ,mn.new)
               SetFunction(iconbase,GETDISKOBJNEW,mn.new)
            ENDIF
         ENDIF
         IF size
            RemPort(port)
            DeleteMsgPort(port)
            info:='removed'
         ELSE
            info:='remove failed'
         ENDIF
      ELSE
         info:='install failed'
         size:={newn}-{newf}
         IF (buf:=AllocVec(size,MEMF_ANY))
            IF (port:=CreateMsgPort())
               port::ln.name:=buf+({newe}-{newf})
               port.sigtask:=NIL
               port::ln.pri:=-40
               IF (mn:=AllocVec(SIZEOF mymsg,MEMF_CLEAR))
                  mn.new:=buf
                  old:=SetFunction(iconbase,GETICON,old)
                  SetFunction(iconbase,GETICON,old)
                  PutLong({geticon},old)
                  CopyMem({newf},buf,size)
                  mn.old:=SetFunction(iconbase,GETDISKOBJ,buf)
                  mn.oldn:=SetFunction(iconbase,GETDISKOBJNEW,buf)
                  AddPort(port)
                  PutMsg(port,mn)
                  info:='installed'
               ELSE
                  DeleteMsgPort(port)
                  JUMP freebuf
               ENDIF
            ELSE
               freebuf:
               FreeVec(buf)
            ENDIF
         ENDIF
      ENDIF
      CacheClearU()
      Permit()
      CloseLibrary(iconbase)
   ENDIF
   IF args[0]=FALSE THEN textMsg()
   FreeArgs(rdargs)
ELSE
   info:='bad args'
   textMsg()
ENDIF
ENDPROC


PROC textMsg() IS
   PrintF(NAME+': \s\n',info)


CHAR '$VER:',NAME,' 0.2 (19.12.2001) by Grio',0


newf:
   MOVE.L geticon(PC),-(A7)
   SUBA.L A1,A1
   RTS
geticon:
   LONG 0
newe:
   CHAR NAME,0
newn:



