

OPT OSVERSION=37
MODULE 'tools/EasyGUI_lite', 'tools/exceptions', 'libraries/gadtools',
       'gadtools','libraries/gadtools','intuition/intuition',
       'graphics/text','workbench/startup','workbench/workbench',
       'tools/constructors','Asl','libraries/Asl','dos/dostags','dos/dos',
       'exec/memory','amigaguide','libraries/amigaguide'


OBJECT makes
s             
ENDOBJECT


DEF     s[50]:STRING,
        mystr,gh,
	nk,altstd,mycon,
	pack,umf[5]:STRING,
        ioi[255]:STRING,y,texte,mywb,fdev[10]:STRING,
        bn[101]:ARRAY OF makes


PROC main() HANDLE
VOID '$VER:EPD_Unpack-GUI © F.Bunk  V1.0beta  (12.03.1997)' 
FOR y:=0 TO 101
  bn[y].s:=String(255) 
ENDFOR  
StrCopy(bn[100].s,'RAM:',ALL)
StrCopy(bn[99].s,bn[100].s,ALL)
StrCopy(fdev,'DF0:',ALL)
StrCopy(s,'Ram:')
StrCopy(umf,'c:',ALL)
reporterr(anlauf())
mystartup()
direntry()
mycon:=Open('CON:10/10/600/73/GUI_Output ',1006)
altstd:=stdout
stdout:=mycon
easyguiA('EPD_GUI 1.0',
    [ROWS,
     [LISTV,{myact},'Click for action',5,4,texte,0,NIL,0],
      [SPACEH],
      [EQROWS ,[CYCLE,{v},'DMS to ',[' DMS  >  RAD: ',' DMS  >  DF0: ',NIL],1],
               [CYCLE,{x}, 'Action ',[' Unpack ',' View Text ',NIL],1]],
       [SPACEH],
      [BEVEL,[COLS,
        mystr:=[STR,{mss},' Unpack Path',s,250,10],
        [BUTTON,{masl},'Path_Requester']]]],[EG_GHVAR,{gh},NIL])
beende()
EXCEPT
report_exception()
ENDPROC


PROC beende()
IF aslbase THEN CloseLibrary(aslbase)
IF amigaguidebase THEN CloseLibrary(amigaguidebase)
stdout:=altstd
Close(mycon)  
ENDPROC


PROC v(x,y)
 IF y=0 
StrCopy(fdev,'RAD:',ALL)
 ELSE 
StrCopy(fdev,'DF0:',ALL)
ENDIF
ENDPROC


PROC x(x,y)
 IF y=0 
pack:=TRUE
 ELSE
 pack:=FALSE
ENDIF
ENDPROC


PROC masl(x)
/*gh:=x*/
aslfilereq()
setstr(gh,mystr,bn[99].s)
ENDPROC


PROC mss(x,y)
StrCopy(bn[99].s,y,ALL)
ENDPROC


PROC myact(x,y)
DEF mpack,moi[255]:STRING,umf[255]:STRING,mrun[255]:STRING
     StrCopy(bn[95].s,bn[97].s,ALL)    
     AddPart(bn[95].s,bn[y+1].s,255) 
     StrCopy(ioi,bn[y+1].s,ALL)
  IF pack=0
   nk:=6
        testas()
       IF nk>=0
       guidm()
       ELSE
         WriteF('Kein Readme File !!\n')
       ENDIF
  ELSE
     StrCopy(ioi,bn[95].s,ALL)
      RightStr(moi,ioi,3)
        LowerStr(moi) 
        mpack:=FALSE
     IF mywb=TRUE
      IF StrCmp(moi,'lzx',ALL)
        mpack:=TRUE
       ENDIF
      ENDIF
      IF StrCmp(moi,'lha',ALL)
        mpack:=TRUE
      ELSEIF StrCmp(moi,'lzh',ALL)
        mpack:=TRUE
        StrCopy(moi,'lha',ALL)
      ENDIF
IF mpack=TRUE
        StrAdd(umf,moi,ALL)
        StringF(mrun,'\s x \s \s',umf,ioi,bn[99].s)
       SystemTagList(mrun,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])
     ELSEIF StrCmp(moi,'dms',ALL)
        StrAdd(umf,moi,ALL)
        StringF(mrun,'\s WRITE \s to \s',umf,ioi,fdev)
        SystemTagList(mrun,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])
     ELSE
        WriteF('Kein LHA/LZX/DMS File !!\n')
    ENDIF
  ENDIF
ENDPROC


PROC aslfilereq()
 DEF req:PTR TO filerequester
 IF req:=AllocFileRequest()
  IF AslRequest(req,[ASL_DIR,bn[99].s,ASLFR_FLAGS2,1,ASL_HAIL,'Unpack Ziel-Pfad',ASL_HEIGHT,180,NIL])
  StrCopy(bn[99].s,req.drawer,ALL)
  RightStr(ioi,bn[99].s,1)
  IF StrCmp(ioi,':',ALL)
  SetStr(bn[99].s,StrLen(bn[99].s)) 
  ELSE
  StrAdd(bn[99].s,'/',1)
  ENDIF
  ENDIF 
  FreeFileRequest(req)
  ENDIF
ENDPROC



PROC testes()
DEF x
nk:=8
LowerStr(ioi)
x:=InStr(ioi,'.info')
nk:=nk-x
x:=InStr(ioi,'.lha')
nk:=nk+x
x:=InStr(ioi,'.lzx')
nk:=nk+x
x:=InStr(ioi,'.dms')
nk:=nk+x
testas()
ENDPROC


PROC testas()
DEF x
LowerStr(ioi)
x:=InStr(ioi,'.readme')
nk:=nk+x
x:=InStr(ioi,'.txt')
nk:=nk+x
x:=InStr(ioi,'.doc')
nk:=nk+x
x:=InStr(ioi,'.asc')
nk:=nk+x
x:=InStr(ioi,'.e')
nk:=nk+x
x:=InStr(ioi,'.guide')
nk:=nk+x
x:=InStr(ioi,'.dok')
nk:=nk+x
ENDPROC



PROC direntry()
DEF info:fileinfoblock,lock2
texte:=newlist()
y:=1
IF lock2:=Lock(bn[97].s,-2)
 IF Examine(lock2,info)
  WHILE ExNext(lock2,info)
   IF info.direntrytype<1 
   StrCopy(bn[y].s,info.filename,ALL)
   StrCopy(ioi,bn[y].s,ALL)
testes()
IF nk>=0
    Enqueue(texte,newnode(NIL,bn[y].s))
    INC y
ENDIF
    ENDIF
  EXIT y=91 
 ENDWHILE
 ENDIF
 UnLock(lock2)
ENDIF
ENDPROC


/* Start einer Amigaguidedatei b.z.w. alles wofuer es Datatypes im system gibt*/
PROC guidm()   
DEF ja, myg:newamigaguide,mxlock
mxlock:=Lock(bn[97].s,ACCESS_READ)
myg.lock:=mxlock
myg.screen:=0
myg.pubscreen:=0
myg.hostport:=0
myg.clientport:=0
myg.basename:=0
myg.flags:=2
myg.context:=0
myg.extens:=0
myg.client:=0
myg.name:=ioi
myg.node:=0
myg.line:=0
ja:=OpenAmigaGuideA(myg,NIL)
CloseAmigaGuide(ja)
UnLock(mxlock)
ENDPROC


PROC reporterr(er)
IF er=1 
Throw("ASL",er)
ELSEIF er=2
Throw("GUID",er)
ENDIF
ENDPROC


PROC mystartup()
DEF lock1,y,x[15]:STRING
mywb:=TRUE
lock1:=GetProgramDir()
IF lock1
 y:=NameFromLock(lock1,bn[97].s,250)
StrCopy(bn[96].s,bn[97].s,ALL)
ENDIF
ENDPROC

PROC anlauf()
IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN RETURN 1
IF (amigaguidebase:=OpenLibrary('amigaguide.library',37))=NIL THEN RETURN 2  
ENDPROC
