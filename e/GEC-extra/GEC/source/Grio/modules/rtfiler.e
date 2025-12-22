OPT MODULE
OPT REG=5
OPT PREPROCESS


#define EXTNAME 'rtFiler'

#define GEC


#ifdef GEC
OPT STRMERGE
#define Getrtl(a,b) self.getrtl(a)
#endif

#ifndef GEC
#define Getrtl(a,b) getrtlx(a,b)
#endif


MODULE 'reqtools','libraries/reqtools'
MODULE 'exec/nodes','exec/tasks','exec/ports','exec/memory'
MODULE 'other/geta4'
MODULE 'dos/dosextens','utility/tagitem'
MODULE 'grio/partutils'



EXPORT OBJECT rtfilermsg
mn:mn
result:PTR TO rtfilelist
req:PTR TO rtfilerequester
file:PTR TO CHAR
reqnum:LONG
userdata:LONG
ENDOBJECT

OBJECT rtflist
next:PTR TO rtflist
req:PTR TO rtfilerequester
reqnum:LONG
title:PTR TO CHAR
file:PTR TO CHAR
userdata:LONG
active:LONG
pri:LONG
bdir:PTR TO CHAR
bfile:PTR TO CHAR
segadr:LONG
fakemn:PTR TO fakemsg
ENDOBJECT


EXPORT OBJECT rtfiler
PRIVATE
rtfl:PTR TO rtflist
count:LONG
ident:LONG
task:PTR TO tc
port:PTR TO mp
name:PTR TO CHAR
inuse:LONG
ENDOBJECT


OBJECT fakemsg
mn:mn
rtl:PTR TO rtflist
obj:PTR TO rtfiler
tags:PTR TO tagitem
ENDOBJECT


PROC new(port) OF rtfiler
DEF cli:PTR TO commandlineinterface,ta:PTR TO process
IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))
   ta:=self.task:=FindTask(NIL)
   storea4()
   self.port:=port
   IF (cli:=ta.cli)
      cli:=Shl(cli,2)
      IF cli.commandname
         self.name:=filepart(Shl(cli.commandname,2)+1)
      ENDIF
   ENDIF
   IF self.name=NIL THEN self.name:=ta::ln.name
ENDIF
ENDPROC reqtoolsbase


PROC add(title,file,userdata=0,pri=5) OF rtfiler
DEF rtl:PTR TO rtflist,req=NIL,reqnum=0,bdir=NIL,bfile=NIL
DEF seg=NIL:PTR TO LONG,size,mn=NIL:PTR TO fakemsg
IF (rtl:=getmem(SIZEOF rtflist))
   IF (bdir:=getmem(1024))
      IF (bfile:=getmem(110))
         size:={eprocess}-{process}+8
         IF (seg:=getmem(size))
            IF (mn:=getmem(SIZEOF fakemsg))
               IF (req:=RtAllocRequestA(RT_FILEREQ,NIL))
                  seg[0]:=size
                  CopyMem({process},seg+8,size-8)
                  rtl.segadr:=seg
                  mn::ln.type:=NT_MESSAGE
                  mn.rtl:=rtl
                  mn.obj:=self
                  rtl.fakemn:=mn
                  rtl.bdir:=bdir
                  rtl.bfile:=bfile
                  rtl.req:=req
                  rtl.next:=self.rtfl
                  rtl.title:=title
                  rtl.file:=file
                  rtl.userdata:=userdata
                  rtl.pri:=pri
                  self.rtfl:=rtl
                  reqnum:=self.ident+1
                  rtl.reqnum:=self.ident:=reqnum
                  self.count:=self.count+1
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF
IF req=NIL
   freemem(mn)
   freemem(seg);freemem(bfile)
   freemem(bdir);freemem(rtl)
ENDIF
ENDPROC reqnum



PROC rem(reqnum) OF rtfiler
DEF rtl:PTR TO rtflist,last=0:PTR TO rtflist
IF reqnum
   rtl:=self.rtfl
   WHILE rtl
      EXIT reqnum=rtl.reqnum
      last:=rtl
      rtl:=rtl.next
   ENDWHILE
   IF rtl
      IF rtl.active=0
         RtFreeRequest(rtl.req)
         IF last
            last.next:=rtl.next
         ELSE
            self.rtfl:=rtl.next
         ENDIF
         freemem(rtl.fakemn)
         freemem(rtl.segadr)
         freemem(rtl.bfile)
         freemem(rtl.bdir)
         freemem(rtl)
         self.count:=self.count-1
         RETURN TRUE
      ENDIF
   ENDIF
ENDIF
ENDPROC FALSE




PROC open(reqnum,taskname=0,tags=0) OF rtfiler
DEF name[100]:STRING,rtl:PTR TO rtflist,pr=NIL:PTR TO process
IF reqnum
   IF (rtl:=Getrtl(reqnum,self))
      IF rtl.active=0
         IF taskname
            StringF(name,'\s \s',taskname,EXTNAME)
         ELSE
            StringF(name,'\s \s\d',self.name,EXTNAME,rtl.reqnum)
         ENDIF
         AstrCopy(rtl.bdir,rtl.req.dir,ALL)
         AstrCopy(rtl.bfile,rtl.file,ALL)
         IF (pr:=CreateProc(name,rtl.pri,Shr(rtl.segadr+4,2),8192))
             pr:=pr-SIZEOF tc
             self.inuse:=self.inuse+1
             rtl.active:=1
             rtl.fakemn.tags:=tags
             PutMsg(pr.msgport,rtl.fakemn)
             IF KickVersion(36) THEN CacheClearU()
         ENDIF
      ENDIF
   ENDIF
ENDIF
ENDPROC pr



PROC freemsg(rtfilermsg:PTR TO rtfilermsg) OF rtfiler
IF rtfilermsg
   IF rtfilermsg.result>1 THEN RtFreeFileList(rtfilermsg.result)
   FreeMem(rtfilermsg,SIZEOF rtfilermsg)
ENDIF
ENDPROC D0



PROC isopen(reqnum=0) OF rtfiler
DEF rtl:PTR TO rtflist
IF reqnum
   IF (rtl:=Getrtl(reqnum,self))
      RETURN rtl.active
   ENDIF
ELSE
   RETURN self.inuse
ENDIF
ENDPROC -1




PROC change(reqnum,tags) OF rtfiler
DEF req
IF (req:=self.getreq(reqnum))
   RtChangeReqAttrA(req,tags)
ENDIF
ENDPROC D0



PROC getreq(reqnum) OF rtfiler
DEF rtl:PTR TO rtflist
IF (rtl:=Getrtl(reqnum,self))
   RETURN rtl.req
ENDIF
ENDPROC NIL



PROC end() OF rtfiler
WHILE self.count
      self.rem(self.rtfl.reqnum)
ENDWHILE
IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
ENDPROC D0


#ifndef GEC
PROC getrtlx(reqnum,obj:PTR TO rtfiler)
DEF rtl:PTR TO rtflist
rtl:=obj.rtfl
WHILE rtl
    IF reqnum=rtl.reqnum THEN RETURN rtl
    rtl:=rtl.next
ENDWHILE
ENDPROC NIL
#endif
#ifdef GEC
PROC getrtl(reqnum) OF rtfiler PRIVATE
DEF rtl:PTR TO rtflist
rtl:=self.rtfl
WHILE rtl
    IF reqnum=rtl.reqnum THEN RETURN rtl
    rtl:=rtl.next
ENDWHILE
ENDPROC NIL
#endif



PROC getmem(size) HANDLE
DEF ptr=NIL:PTR TO LONG
ptr:=FastNew(size+4)
ptr[]++:=size
EXCEPT DO
ENDPROC ptr

PROC freemem(ptr:PTR TO LONG)
DEF size:REG
IF ptr
   size:=ptr[]--
   FastDispose(ptr,size+4)
ENDIF
ENDPROC D0



PROC process()
DEF pr:PTR TO process,mnf:PTR TO fakemsg,r=0,mn=0:PTR TO rtfilermsg
DEF ob:PTR TO rtfiler
geta4()
pr:=FindTask(NIL)
WaitPort(pr.msgport)
mnf:=GetMsg(pr.msgport)
ob:=mnf.obj
IF (mn:=AllocMem(SIZEOF rtfilermsg,MEMF_CLEAR))
   IF (r:=RtFileRequestA(mnf.rtl.req,mnf.rtl.file,mnf.rtl.title,mnf.tags))=0
      AstrCopy(mnf.rtl.file,mnf.rtl.bfile,ALL)
      RtChangeReqAttrA(mnf.rtl.req,[RTFI_DIR,mnf.rtl.bdir,TAG_END])
   ENDIF
   mn.mn.ln.type:=NT_MESSAGE
   mn.mn.length:=SIZEOF rtfilermsg
   mn.result:=r
   mn.req:=mnf.rtl.req
   mn.reqnum:=mnf.rtl.reqnum
   mn.file:=mnf.rtl.file
   mn.userdata:=mnf.rtl.userdata
   PutMsg(ob.port,mn)
ENDIF
mnf.rtl.active:=0
ob.inuse:=ob.inuse-1
ENDPROC D0
eprocess:





