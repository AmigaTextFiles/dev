
OPT STRMERGE
OPT REG=5
OPT RUNBG


MODULE 'libraries/playsidbase'
MODULE 'tools/EasyGui_os12'
MODULE 'libraries/gadtools'

DEF fh,st[120]:STRING,status[256]:STRING,argst[512]:STRING
DEF gui=FALSE,txtg,gh=0:PTR TO guihandle,strg
DEF sour[200]:STRING,des[200]:STRING

PROC main()
IF arg[]="?"
   writef('USAGE: <sidplay name>\n')
ELSEIF arg[]=NIL
   makeGUI()
ELSE
   StrCopy(argst,arg,ALL)
   conv()
ENDIF
ENDPROC


PROC writef(fmt,args=NIL)
DEF fh,buf[258]:ARRAY,fhout,len
 fhout:=stdout
 IF args
    RawDoFmt(fmt,buf,{putch},args)
 ELSE
    AstrCopy(buf,fmt)
 ENDIF
 IF (fh:=Open('*',NEWFILE)) THEN fhout:=fh
 len:=StrLen(buf)
 Write(fhout,buf,len)
 IF fh THEN Close(fh)
ENDPROC len
putch:
MOVE.B D0,(A3)+
RTS

CHAR '$VER: SidConvert 1.2 (14.08.2001) by Grio!',0


PROC makeGUI() HANDLE
  DEF res=-1
  StrCopy(sour,'RAM:',ALL)
  StrCopy(des,'RAM:',ALL)
  StrCopy(status,'Idle',ALL)
  gh:=guiinitA('Sid Convert 1.2',
    [ROWS,
      [EQCOLS,
        [SBUTTON,{open}, 'Source'],
        [SBUTTON,{conv}, 'Convert']
       ],
       [EQCOLS,
        [BUTTON,{dest}, 'Dest path'],
        strg:=[STR,   {dest},NIL,  des,   120,15]
      ],
      [EQROWS,
        txtg:=[TEXT,status,  'Status :',TRUE,0]
      ]
    ],
      [EG_MENU,
       [NM_TITLE,0,'Project',0,0,0,0,
        NM_ITEM,0,'Source',  's',0,0,{open},
        NM_ITEM,0,'Dest path','d',0,0,{dest},
        NM_ITEM,0,NM_BARLABEL,0,0,0,0,
        NM_ITEM,0,'Convert','c',0,0,{conv},
        NM_ITEM,0,NM_BARLABEL,0,0,0,0,
        NM_ITEM,0,'About','c',0,0,{about},
        NM_ITEM,0,NM_BARLABEL,0,0,0,0,
        NM_ITEM,0,'Quit','q',0,0,`gui:=FALSE,
        0,0, 0,0,0,0,0
       ]:newmenu
      ]
    )
    SetWindowTitles(gh.wnd,-1,'Sid Convert 1.2')
    gui:=TRUE
    WHILE res<0
         Wait(gh.sig)
         res:=guimessage(gh)
         EXIT gui=FALSE
    ENDWHILE
EXCEPT DO
   cleangui(gh)
  ->ReThrow()
ENDPROC

MODULE 'grio/reqtools','libraries/reqtools',
       'utility/tagitem','dos/dos'


PROC open() HANDLE
  DEF req:PTR TO reqtools
  NEW req.new(RT_FILEREQ)
  IF req.file('Select PC SID',sour)
     StrCopy(argst,req.dirbuf,ALL)
     AddPart(argst,req.filebuf,-1)
     SetStr(argst,StrLen(argst))
     StringF(status,'sid: \s',req.filebuf)
     showMess()
     StrCopy(sour,req.dirbuf,ALL)
  ENDIF
EXCEPT DO
  END req
ENDPROC


PROC dest() HANDLE
  DEF req:PTR TO reqtools
  NEW req.new(RT_FILEREQ)
  IF req.file('Select Dest Path',des,200,TRUE,
              [RTFI_FLAGS,FREQF_NOFILES,TAG_DONE])
     StrCopy(des,req.dirbuf,ALL)
     setstr(gh,strg,des)
  ENDIF
EXCEPT DO
  END req
ENDPROC

PROC conv() HANDLE
DEF sh:PTR TO sidheader,s2[120]:STRING,pr,x,lock=-1,buf=0
RightStr(s2,argst,4)
LowerStr(s2)
IF (StrCmp(s2,'.sid',ALL)=TRUE) OR (StrCmp(s2,'.dat',ALL)=TRUE)
   SetStr(argst,EstrLen(argst)-4)
ENDIF
StringF(s2,'\s.sid',argst)
IF (fh:=Open(s2,OLDFILE))
   parsefirst()
   IF (sh:=New(SIZEOF sidheader))
      sh.id:="PSID"
      sh.version:=2
      sh.length:=SIZEOF sidheader
      pcReadStr(st)
      IF InStr(st,'ADDRESS=')=0
         pr:=`StringF(s2,'$\s',st+x) BUT Val(s2)
         x:=8
         sh.start:=Eval(pr)
         IF (x:=InStr(st,','))<=0 THEN badinfo()
         INC x
         sh.init:=Eval(pr)
         IF (x:=InStr(st,',',x))<=0 THEN badinfo()
         INC x
         sh.main:=Eval(pr)
      ELSE
         badinfo()
      ENDIF
      parse('SONGS=')
      sh.number:=Val(st+STRLEN)
      IF (x:=InStr(st,','))>0
         sh.defsong:=Val(st+x+1)
      ELSE
         sh.defsong:=1
      ENDIF
      parse('SPEED=')
      sh.speed:=Val(st+STRLEN)
      parse('NAME=')
      AstrCopy(sh.name,st+STRLEN,32)
      parse('AUTHOR=')
      AstrCopy(sh.author,st+STRLEN,32)
      parse('COPYRIGHT=')
      AstrCopy(sh.copyright,st+STRLEN,32)
      closefh()
      StringF(st,'\s.dat',argst)
      IF (x:=FileLength(st))>0
         IF (buf:=New(x))=NIL
            Raise('no mem')
         ENDIF
         IF (fh:=Open(st,OLDFILE))
            Read(fh,buf,x)
            closefh()
         ELSE
            nodat()
         ENDIF
      ELSE
         nodat()
      ENDIF
      IF lock:=Lock(des,SHARED_LOCK)
         CurrentDir(lock)
      ELSE
         lock:=-1
      ENDIF
      StringF(s2,'SiD.\s',sh.name)
      IF (fh:=Open(s2,NEWFILE))
         Write(fh,sh,SIZEOF sidheader)
         Write(fh,buf,x)
         Throw('file "\s" saved',s2)
      ELSE
         Raise('error open output file')
      ENDIF
  ELSE
      Raise('no mem')
   ENDIF
   Close(fh)
ELSE
   Throw('no \s file',s2)
ENDIF
EXCEPT DO
IF exception
   StringF(status,exception,exceptioninfo)
   showMess()
ENDIF
IF lock<>-1
   UnLock(CurrentDir(lock))
ENDIF
closefh()
Dispose(buf)
ENDPROC


PROC badinfo() IS Raise('bad sidinfo')

PROC nodat() IS Throw('no "\s" file',st)


PROC parse(stri)
    pcReadStr(st)
    IF StrCmp(stri,st,StrLen(stri))=FALSE
       badinfo()
    ENDIF
ENDPROC


PROC parsefirst()
    pcReadStr(st)
    IF StrCmp('PSID',st,STRLEN)
       Raise('this file is PSID')
    ELSE
       IF StrCmp('SIDPLAY INFOFILE',st,STRLEN)=FALSE THEN badinfo()
    ENDIF
ENDPROC


PROC pcReadStr(str)
    DEF x,y
    y:=ReadStr(fh,str)
    IF (x:=InStr(str,{dd}))>0
       str[x]:=0
    ENDIF
ENDPROC y


dd:
   CHAR $d,$0




PROC closefh()
 IF fh THEN Close(fh)
 fh:=0
ENDPROC


PROC showMess()
  IF gui=FALSE
     writef('\s\n',[status])
  ELSE
     settext(gh,txtg,status)
  ENDIF
ENDPROC



PROC about() HANDLE
 DEF req:PTR TO reqtools
 NEW req.new(RT_REQINFO)
 req.ez('Sid Convert About','Sid Convert 1.2 -> 99-01\nCopyright by Grio\n'+
         'This proggy is small converter\nfor PC headers SID files\n'+
         'to Amiga PSID files...',NIL,NIL,
         [RTEZ_FLAGS,EZREQF_CENTERTEXT,TAG_END])
EXCEPT DO
 END req
ENDPROC


