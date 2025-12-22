OPT OSVERSION=37
OPT STRMERGE
OPT RUNBG
OPT REG=5



MODULE 'tools/EasyGui','libraries/gadtools'
MODULE 'dos/dos','dos/dosextens','dos/dostags'
MODULE 'intuition/intuition','exec/semaphores'
MODULE 'utility/tagitem'

ENUM MODE_RENAME,MODE_COPY
CONST COPYSIZE=50000


DEF dest[110]:STRING,sour[110]:STRING,table[512]:ARRAY,gui=FALSE
DEF gh=0:PTR TO guihandle,txti,txto,mode=MODE_RENAME,abort=FALSE
DEF list:PTR TO LONG,dirname[512]:STRING,copybuf,todir[512]:STRING
DEF cvsem:ss,convg,rev=0,abortg,dirg,revg,modeg,formg

PROC makeconv(revi)
DEF tab1,len,x,e,y,dpath[512]:STRING,tab2
len:=EstrLen(sour)-1
tab1:=table+256
IF revi
   tab2:=tab1
   tab1:=table
ELSE
   tab2:=table
ENDIF
FOR x:=0 TO len
   e:=sour[x]
   FOR y:=0 TO 255
      EXIT e=tab1[y]
   ENDFOR
   IF y=256
      dest[x]:=sour[x]
   ELSE
      dest[x]:=tab2[y]
   ENDIF
ENDFOR
SetStr(dest,len+1)
IF (e:=StrCmp(sour,dest))
   StrCopy(dest,'Skipped',STRLEN)
ENDIF
showSour()
showDest()
IF e=FALSE
   IF mode=MODE_RENAME
      Rename(sour,dest)
   ELSE
      StrCopy(dpath,todir,ALL)
      AddPart(dpath,dest,512)
      SetStr(dpath,StrLen(dpath))
      copy(sour,dpath)
   ENDIF
ENDIF
Delay(2)
ENDPROC



PROC convproc()
DEF lock,fib:PTR TO fileinfoblock,str=-1,last=0,size=0,first=0,x,crev
GetA4()
ObtainSemaphore(cvsem)
setdisabledabort(FALSE)
setdisabledall(TRUE)
crev:=rev
IF (fib:=AllocDosObject(DOS_FIB,[TAG_DONE]))
   IF (lock:=Lock(dirname,SHARED_LOCK))
      Examine(lock,fib)
      WHILE ExNext(lock,fib)
         EXIT abort=TRUE
         IF (str:=String(StrLen(fib.filename)+2))
            StrCopy(str,fib.filename,ALL)
            IF last
               Link(last,str)
            ELSE
               first:=str
            ENDIF
            last:=str
            INC size
         ENDIF
         EXIT str=0
      ENDWHILE
      lock:=CurrentDir(lock)
      str:=first
      FOR x:=0 TO size
         EXIT abort=TRUE
         StrCopy(sour,str)
         makeconv(crev)
         str:=Next(str)
         EXIT str=0
      ENDFOR
      UnLock(CurrentDir(lock))
   ENDIF
   FreeDosObject(DOS_FIB,fib)
ENDIF
IF first THEN DisposeLink(first)
idle()
abort:=FALSE
setdisabledabort(TRUE)
setdisabledall(FALSE)
ReleaseSemaphore(cvsem)
ENDPROC


PROC conv()
CreateNewProc([NP_ENTRY,{convproc},NP_NAME,'Ami2PCName Conv',NP_STACKSIZE,8192,TAG_END])
ENDPROC


MODULE 'grio/reqtools','libraries/reqtools'

PROC dir() HANDLE
DEF req:PTR TO reqtools
NEW req.new(RT_FILEREQ)
IF req.file('Select Dir',dirname,200,TRUE,[RTFI_FLAGS,FREQF_NOFILES,TAG_END])
   StrCopy(dirname,req.dirbuf,ALL)
   setdisabled(gh,convg,FALSE)
ENDIF
EXCEPT DO
  END req
ENDPROC



PROC format(num)
DEF name[120]:STRING,fh=0
StrCopy(name,'L:FileSystem_trans/',STRLEN)
StrAdd(name,ListItem(list,num),ALL)
IF (fh:=Open(name,OLDFILE))
   Read(fh,table,512)
   Close(fh)
ENDIF
ENDPROC fh<>0


PROC idle()
StrCopy(sour,'Idle',ALL)
StrCopy(dest,'Idle',ALL)
IF gh
   showSour()
   showDest()
ENDIF
ENDPROC


PROC makeGUI() HANDLE
  DEF res=-1
  IF format(0)=0 THEN Raise()
  idle()
  gh:=guiinitA('Ami2PCName',
    [ROWS,
      [EQCOLS,
        convg:=[SBUTTON,{conv}, 'Convert',NIL,NIL,NIL,TRUE],
        dirg:=[SBUTTON,{dir},'Work Dir',NIL,NIL,NIL,FALSE],
        revg:=[CHECK ,{gadrev},'Reverse',rev,TRUE,NIL,NIL,FALSE],
        abortg:=[SBUTTON,{setabort},'Abort',NIL,NIL,NIL,TRUE]
      ],
      [EQCOLS,
        formg:=[CYCLE,{format},'Format',list,0,NIL,NIL,FALSE],
        modeg:=[CYCLE,{setmodeg},'Mode',['Rename','Copy',NIL],mode,NIL,NIL,FALSE]
      ],
      [EQROWS,
        txti:=[TEXT,sour,  'Sour :',TRUE,0],
        txto:=[TEXT,dest,  'Dest :',TRUE,0]
      ]
    ])
    addmenu()
    gui:=TRUE
    WHILE res<0
         Wait(gh.sig)
         res:=guimessage(gh)
         EXIT gui=FALSE
    ENDWHILE
EXCEPT DO
   ObtainSemaphore(cvsem)
   cleangui(gh)
   ReleaseSemaphore(cvsem)
   ReThrow()
ENDPROC



PROC setdisabledall(dis)
DEF x,t,l
l:=ListLen(t:=[convg,dirg,revg,formg,modeg])-1
FOR x:=0 TO l DO setdisabled(gh,ListItem(t,x),dis)
addmenu(dis)
ENDPROC


PROC setdisabledabort(dis)
setdisabled(gh,abortg,dis)
ENDPROC


PROC addmenu(disable=FALSE)
DEF nflag,aflag,copyf,renaf,revf,checkf
aflag:=IF disable THEN NIL ELSE NM_ITEMDISABLED
nflag:=IF disable THEN NM_ITEMDISABLED ELSE NIL
checkf:=nflag OR CHECKIT
renaf:=checkf OR (IF mode=MODE_RENAME THEN CHECKED ELSE NIL)
copyf:=checkf OR (IF mode=MODE_COPY THEN CHECKED ELSE NIL)
revf:=checkf OR (IF rev THEN CHECKED ELSE NIL)
changemenus(gh,[NM_TITLE,0,'Project',0,0,0,0,
                  NM_ITEM,0,'Work Dir','d',nflag,0,{dir},
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Convert','c',nflag,0,{conv},
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Reverse','r',revf,0,{menurev},
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Mode',0,nflag,0,0,
                    NM_SUB,0,'Rename','0',renaf,2,{setrename},
                    NM_SUB,0,'Copy','1',copyf,1,{setcopy},
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Abort','a',aflag,0,{setabort},
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Quit','q',0,0,{quit},
                NM_END,0,NIL,0,0,0,0]:newmenu)
ENDPROC



PROC quit()
 gui:=FALSE
 abort:=TRUE
ENDPROC



PROC reverse(num) IS rev:=num


PROC setabort()
 setdisabledabort(abort:=TRUE)
ENDPROC

PROC gadrev(num)
 reverse(num)
 addmenu()
ENDPROC


PROC menurev()
 reverse(IF rev=0 THEN 1 ELSE 0)
 setcheck(gh,revg,rev)
ENDPROC


PROC setmode(num) HANDLE
DEF req=NIL:PTR TO reqtools,res=NIL
mode:=num
IF mode=MODE_COPY
   NEW req.new(RT_FILEREQ)
   IF (res:=req.file('Where copy files',todir,200,TRUE,[RTFI_FLAGS,FREQF_NOFILES,TAG_END]))
      StrCopy(todir,req.dirbuf,ALL)
   ENDIF
   Raise()
ENDIF
EXCEPT
  END req
ENDPROC res


PROC setmodeg(num)
IF setmode(num)
   addmenu()
ELSE
   setrename()
ENDIF
ENDPROC


PROC setcopy()
setcycle(gh,modeg,1)
IF setmode(1)=NIL
   setrename()
   addmenu()
ENDIF
ENDPROC

PROC setrename()
setcycle(gh,modeg,0)
setmode(0)
ENDPROC



PROC main() HANDLE
DEF lock=0,fib:fileinfoblock,str,size=0,last=0,first,x
copybuf:=NewR(COPYSIZE)
IF (lock:=Lock('L:FileSystem_trans',SHARED_LOCK))
   Examine(lock,fib)
   WHILE ExNext(lock,fib)
      IF (str:=String(StrLen(fib.filename)+2))
         StrCopy(str,fib.filename,ALL)
      ELSE
         Raise()
      ENDIF
      IF last
         Link(last,str)
      ELSE
         first:=str
      ENDIF
      last:=str
      INC size
   ENDWHILE
   UnLock(lock)
   lock:=0
   IF (list:=List(size+1))
      str:=first
      FOR x:=0 TO size-1
         ListAdd(list,[str])
         str:=Next(str)
      ENDFOR
      ListAdd(list,[NIL])
      StrCopy(dirname,'RAM:',ALL)
      StrCopy(todir,'RAM:',ALL)
      InitSemaphore(cvsem)
      makeGUI()
   ELSE
      Raise()
   ENDIF
ENDIF
EXCEPT
IF lock THEN UnLock(lock)
ENDPROC



PROC showSour() IS  settext(gh,txti,sour)

PROC showDest() IS  settext(gh,txto,dest)





PROC copy(s,d)
DEF fhi,fho
IF (fhi:=Open(s,OLDFILE))
   IF (fho:=Open(d,NEWFILE))
      REPEAT
      UNTIL Write(fho,copybuf,Read(fhi,copybuf,COPYSIZE))<COPYSIZE
      Close(fho)
   ENDIF
   Close(fhi)
ENDIF
ENDPROC





