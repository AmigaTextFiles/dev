/* $VER: xPage 1.1 (5-10-97) © Frédéric Rodrigues - Freeware-Registered
   XPK More
*/

OPT PREPROCESS,OSVERSION=36

#define FREEWARE
->#define REGISTERED

MODULE 'xpkmaster','xpk/xpk','utility/tagitem','dos/dos','dos/dosextens',
       'exec/ports','exec/nodes','intuition/intuition','graphics/rastport',
       'workbench/startup','exec/lists'

ENUM ER_QUIT,ER_LIB,ER_XPK,ER_MEM,ER_DOS,ER_ARG
ENUM TITLE_TOP,TITLE_BOTTOM,TITLE_SEARCH,TITLE_FOUND,TITLE_PRINT,TITLE_LOAD,
     TITLE_CPT,TITLE_VERSION,TITLE_HELP,TITLE_NOTPRINT,TITLE_WRONG
ENUM ARG_FILE,ARG_NBLINES
CONST LEN_STRING=256,DELAY=50

DEF xpkfib:PTR TO xpkfib,xpkerr[XPKERRMSGSIZE]:STRING,xpkbuf,nbytes,
    c[1]:STRING,line,eof,nblines,cptlines,win:PTR TO window,
    stringsearch[LEN_STRING]:STRING,searchagain=FALSE,maxnblines,nbchunk,
    sumnblines,string[LEN_STRING]:STRING,argu

PROC main() HANDLE
  DEF t,title,wb:PTR TO wbstartup,args:PTR TO wbarg
  /* if ran from workbench */
  IF wbmessage
    wb:=wbmessage
#ifdef FREEWARE
    IF wb.numargs>=0
#endif
#ifdef REGISTERED
    IF wb.numargs<2
#endif
      StringF(string,'\s\n\n\s',{version},{help})
      EasyRequestArgs(0,[20,0,{error},string,{seeyou}],0,0)
      RETURN
    ENDIF
    args:=wb.arglist
    argu:=args[1].name
    CurrentDir(args[1].lock)
  ELSE
    IF (arg[]=0) OR (arg[]="?") THEN Raise(ER_ARG)
    argu:=arg        /* DANGER !!! the usage of arg here seems to make the prog crash under 2.1b */
  ENDIF
  cursoff()
  SetMode(stdout,1)           /* set * to RAW mode */
  win:=findwindow()
  title:=win.title        /* save title */
  calculatemaxlines()
  IF (xpkbase:=OpenLibrary('xpkmaster.library',2))=NIL THEN Raise(ER_LIB)
rewind:
  /* ok, do some initialisations */
  nblines:=cptlines:=nbchunk:=sumnblines:=0
  IF (XpkOpen({xpkfib},[XPK_INNAME,argu,XPK_GETERROR,xpkerr,XPK_PASSTHRU,TRUE,TAG_DONE])<>0) THEN Raise(ER_XPK)
  IF (xpkbuf:=New(xpkfib.nlen+1))=NIL THEN Raise(ER_MEM)
  displaytitle(TITLE_LOAD)
  WHILE (nbytes:=XpkRead(xpkfib,xpkbuf,xpkfib.nlen))>0
    sumnblines:=sumnblines+nblines
    INC nbchunk
    xpkbuf[nbytes]:=0       /* set end of xpkbuf */
    nblines:=1
    cptlines:=2
    /* replace 12 by \n */
    FOR t:=0 TO nbytes-1
      IF xpkbuf[t]=12
        xpkbuf[t]:="\n"
        INC nblines
      ENDIF
    ENDFOR
    line:=xpkbuf
    eof:=FALSE
    Write(Output(),xpkbuf,page(xpkbuf))
    IF searchagain=FALSE THEN displaytitle(TITLE_VERSION)
    WHILE eof=FALSE
      IF searchagain
        c[]:="n"
      ELSE
        displaytitle(TITLE_CPT)
        Read(stdout,c,1)
        calculatemaxlines()
      ENDIF
      t:=c[]
      SELECT t
        CASE "t";line:=xpkbuf;pageup()
        CASE "b";line:=xpkbuf+nbytes
                 gotocurrent()
                 pagedown()
        CASE 32;pagedown();
        CASE 8;pageup();
        CASE 13;IF line<>nextline() THEN WriteF('\s\n',line:=nextline()) ELSE displaytitle(TITLE_BOTTOM)
#ifdef REGISTERED
        CASE "p";print()
#endif
        CASE 155;
        CASE 63;displaytitle(TITLE_HELP)
                cls()
                WriteF('\e[1m\s\e[22m\n\n'+
                       '     HELP - this help\n'+
                       '        t - top of chunk\n'+
                       '        b - bottom of chunk\n'+
                       '    SPACE - next page\n'+
                       'BACKSPACE - previous page\n'+
                       '    ENTER - next line\n'+
                       '        p - print current page\n'+
                       '        / - search for strings (separate them with "|")\n'+
                       '        n - search again\n'+
                       '        j - next chunk\n'+
                       '        r - rewind\n'+
                       '      ESC - quit\n\n',{version})
#ifdef FREEWARE
                WriteF('Some options don''t work with the freeware version:\n'+
                       'workbench, search, print\n'+
                       'So, register for just 2$\n\n')
#endif
                WriteF('\e[3mReach me at :\n\n'+
                       'email : rodrigue@iles.siera.ups-tlse.fr\n'+
                       'mail :  Frédéric RODRIGUES\n'+
                       '        4 allées Antonio Machado app 3009D\n'+
                       '        31100 Toulouse\n'+
                       '        FRANCE\e[23m')
                 t:=cptlines
                 Read(stdout,c,1)
                 Read(stdout,c,1)
                 gotocurrent()
                 line:=previousline()       /* must do this to work */
                 pagedown()
                 cptlines:=t
#ifdef REGISTERED
        CASE "/";SetMode(stdout,0)
                 curson()
                 WriteF('/')
                 ReadStr(stdout,stringsearch)
                 cursoff()
                 SetMode(stdout,1)
                 search()
        CASE "n";searchagain:=FALSE;search()
#endif
        CASE "j";eof:=TRUE
        CASE "r";XpkClose(xpkfib);Dispose(xpkbuf);JUMP rewind
        CASE 27;Raise(ER_QUIT)
        DEFAULT;displaytitle(TITLE_WRONG)
      ENDSELECT
    ENDWHILE
    displaytitle(TITLE_LOAD)
  ENDWHILE
  IF nbytes<0 THEN Raise(ER_XPK)
  Raise(ER_QUIT)
EXCEPT
  t:=IoErr()
  IF win THEN SetWindowTitles(win,title,TRUE)
  curson()
  SetMode(stdout,0)
  IF xpkfib THEN XpkClose(xpkfib)
  IF xpkbase THEN CloseLibrary(xpkbase)
  WriteF('\s\n\n',IF exception THEN {version} ELSE {seeyou})
  SELECT exception
    CASE ER_LIB;WriteF('\s: cannot open xpkmaster.library',{error});RETURN RETURN_ERROR
    CASE ER_XPK;WriteF('\s: \s\n',{error},xpkerr);RETURN RETURN_FAIL
    CASE ER_MEM;PrintFault(ERROR_NO_FREE_STORE,{error});RETURN RETURN_ERROR
    CASE ER_DOS;PrintFault(t,{error});RETURN RETURN_FAIL
    CASE ER_ARG;WriteF('\s\n',{help})
  ENDSELECT
  IF wbmessage
    Delay(DELAY)
    Close(stdout)
  ENDIF
ENDPROC

PROC pagedown()
  DEF i,j
  j:=maxnblines
  IF line<>xpkbuf THEN DEC j
  FOR i:=1 TO maxnblines
    IF line=nextline()  /* trying to find bottom */
      displaytitle(TITLE_BOTTOM)
      JUMP l
    ENDIF
    line:=nextline()
  ENDFOR
l:
  FOR i:=1 TO j DO line:=previousline()  /* return to position */
  cls()
  FOR i:=1 TO maxnblines
    WriteF('\s\n',line)
    IF i<>maxnblines THEN line:=nextline()
  ENDFOR
ENDPROC

PROC pageup()
  DEF i
  FOR i:=1 TO 2*maxnblines
    IF (line:=previousline())=previousline()
      displaytitle(TITLE_TOP)
      JUMP m
    ENDIF
  ENDFOR
m:
  cls()
  pagedown()
ENDPROC

PROC gotocurrent()
  DEF i
  FOR i:=1 TO maxnblines-1 DO line:=previousline()
ENDPROC

PROC print()
  DEF i,fhp,out
  IF fhp:=Open('PRT:',NEWFILE)
    displaytitle(TITLE_PRINT)
    out:=SetStdOut(fhp)
    gotocurrent()
    FOR i:=1 TO maxnblines
      WriteF('\s\n',line)
      IF i<>maxnblines THEN line:=nextline()
    ENDFOR
    SetStdOut(out)
    Close(fhp)
  ELSE
    displaytitle(TITLE_NOTPRINT)
  ENDIF
ENDPROC

/* searches for several strings */
PROC search()
  DEF s,len
  /* display title first because string is shared */
  displaytitle(TITLE_SEARCH)
  len:=StrLen(stringsearch)
  StrCopy(string,stringsearch,ALL)
  s:=string
  /* replace space by 0 */
  WHILE s[]
    IF s[]="|" THEN s[]:=0
    INC s
  ENDWHILE
  WHILE line<>nextline()
    s:=string
n:
    IF InStr(line,s,0)<>-1
      line:=previousline()
      pagedown()
      cptlines:=cptlines-2                /* must do this to get right */
      displaytitle(TITLE_FOUND)
      RETURN
    ELSE
      WHILE s[]++ DO NOP
      IF (s-string)>=len THEN JUMP o
      JUMP n
    ENDIF
o:
    line:=nextline()
  ENDWHILE
  eof:=TRUE
  searchagain:=TRUE
ENDPROC

PROC nextline()
  DEF pos
  pos:=line
  WHILE pos[]++<>0 DO NOP
  IF pos=(xpkbuf+nbytes)
    cptlines:=nblines-(maxnblines/2)*2-1  /* must do this to get right */
    RETURN line
  ELSE
    INC cptlines
    RETURN pos
  ENDIF
ENDPROC

PROC previousline()
  DEF pos
  IF line=xpkbuf THEN RETURN xpkbuf   /* needed */
  pos:=line-1
  WHILE pos[]--<>0
    IF pos<=xpkbuf
      cptlines:=2
      RETURN xpkbuf
    ENDIF
  ENDWHILE
  DEC cptlines
  RETURN pos+1
ENDPROC

/* apparently unique way to get PTR to * window */
/* I got this from TheSourceAsm */
PROC findwindow()
  DEF proc:PTR TO process,cli:PTR TO commandlineinterface,
      id:infodata,pkt:standardpacket,fhandl:PTR TO filehandle,
      msg:PTR TO mn,node:PTR TO ln,dospkt:PTR TO dospacket
  proc:=FindTask(NIL)
  cli:=Shl(proc.cli,2)
  msg:=pkt.msg
  node:=msg.ln
  node.name:=pkt.pkt
  dospkt:=pkt.pkt
  dospkt.link:=msg
  dospkt.port:=proc.msgport
  dospkt.type:=ACTION_DISK_INFO
  dospkt.arg1:=Shr(id,2)
  fhandl:=Shl(stdout,2)
  PutMsg(fhandl.type,pkt)
  WaitPort(proc.msgport)
  GetMsg(proc.msgport)
  RETURN id.volumenode
ENDPROC

/* ok, just a function */
PROC cls()
  WriteF('\e[0;0H\e[J')
ENDPROC

PROC curson()
  WriteF('\e[1 p')
ENDPROC

PROC cursoff()
  WriteF('\e[0 p')
ENDPROC

/* it's better programming if u get this */
PROC displaytitle(tit)
  DEF t,u
  SELECT tit
    CASE TITLE_CPT
      u:=(cptlines+maxnblines)/2
      t:=u+sumnblines
      StringF(string,'\s · \d% of chunk \d · line \d · page \d',argu,u*100/nblines,nbchunk,t,t/maxnblines)
    CASE TITLE_SEARCH
      StringF(string,'searching for \s...',stringsearch)
    CASE TITLE_FOUND
      StringF(string,'found \s',stringsearch)
  ENDSELECT
  SetWindowTitles(win,ListItem(['top of chunk','bottom of chunk',string,string,'printing...','loading...',string,{version},'help','cannot print','press HELP for help'],tit),TRUE)
  IF tit<>TITLE_CPT THEN IF tit<>TITLE_HELP THEN IF tit<>TITLE_LOAD THEN IF tit<>TITLE_SEARCH THEN Delay(DELAY)
ENDPROC

/* calculate the size of display based on the screen font */
PROC calculatemaxlines()
  DEF rastport:PTR TO rastport
  rastport:=win.rport
  maxnblines:=(win.height-win.bordertop)/rastport.txheight-1
  /* necessary to get right values */
  IF Even(maxnblines) THEN DEC maxnblines
ENDPROC

PROC sizewin(win) IS (win.height-win.bordertop-win.borderbottom)/win.rport.txheight,(win.width-win.borderleft-win.borderright)/win.rport.txwidth

PROC page(buf)
DEF x,y
  x,y:=sizewin(win)
  WHILE buf[]

  ENDWHILE
ENDPROC

CHAR '$VER: '
#ifdef FREEWARE
version: CHAR 'xPage 1.1 (5.10.97) © Frédéric Rodrigues\nXPK More',0
#endif
#ifdef REGISTERED
version: CHAR 'xPage 1.1 (5.10.97) © Frédéric RODRIGUES - Registered\nXPK More',0
#endif
error: CHAR 'xPage',0
help: CHAR 'CLI usage:  xPage filename\nWB  usage:  Click xPage, Shift/Doubleclick text file\nWhile viewing file, press HELP for help screen',0
seeyou: CHAR 'See you later !',0
