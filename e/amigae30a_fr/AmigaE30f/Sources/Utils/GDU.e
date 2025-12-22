/* Graphical Disk Usage (GDU), basé sur D.e

   affiche toutes les partitions du disque dur et du même style sur l'écran
   et est capable de zoomer dedans, d'afficher les infos etc. [voir requester]

*/

OPT OSVERSION=37

MODULE 'class/stack', 'tools/clonescreen',
       'dos/dosasl', 'dos/dos', 'utility', 'intuition/intuition'

CONST MAXPATH=250

ENUM ER_NONE,ER_BADARGS,ER_MEM,ER_UTIL,ER_COML
ENUM ARG_DIR,NUMARGS

RAISE ER_MEM IF New()=NIL, ERROR_BREAK IF CtrlC()=TRUE, ER_MEM IF String()=NIL

OBJECT dir
  name,size,sub,x,y,xs,ys
ENDOBJECT

DEF dir,dirw[100]:STRING,rdargs=NIL,dirno=0,s[200]:STRING,b:PTR TO dir,
    screen=NIL,font=NIL,win=NIL,xsize,ysize,depth,st:PTR TO stack

PROC consdir(name,size,sub) IS NEW [StrCopy(String(StrLen(name)),name),size,sub]:dir

PROC main() HANDLE
  DEF args[NUMARGS]:LIST,templ,x,lock,fib:fileinfoblock,do=TRUE,code,qual,mx,my
  IF EasyRequestArgs(win,[20,0,'Welcome to GraphicDiskUsage',
      'cli usage = GDU <volume>\nbouton gauche = affiche info\nbouton droit = quit\nshift + bouton gauche = zoom interieur\nshift + bouton droit = zoom dehors\nctrl c = quitte [pendant la lecture du disque]\n',
      'On y va|Cancel'],0,NIL)=1
    NEW st.stack()
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTIL)
    FOR x:=0 TO NUMARGS-1 DO args[x]:=0
    templ:='DIR'
    rdargs:=ReadArgs(templ,args,NIL)
    IF rdargs=NIL THEN Raise(ER_BADARGS)
    dir:=args[ARG_DIR]
    IF dir THEN StrCopy(dirw,dir,ALL)
    lock:=Lock(dirw,-2)
    IF lock                  /* Si oui, le rép prob. dir, sinon car. génériques */
      IF Examine(lock,fib) AND (fib.direntrytype>0)
        AddPart(dirw,'#?',100)
      ENDIF
      UnLock(lock)
    ENDIF
    screen,font:=openclonescreen('Workbench','Graphic Disk Usage ($%#!)')
    win:=backdropwindow(screen,$8,$10000)
    depth,xsize,ysize:=getcloneinfo(screen)
    WriteF('Scanning...\n')
    b:=recdir(dirw)
    SetTopaz(8)
    refresh()
    WHILE do
      WaitIMessage(win)
      code:=MsgCode()
      qual:=MsgQualifier()
      mx:=MouseX(win); my:=MouseY(win)
      IF code=MENUDOWN
        IF qual AND 1
          zoomout()
        ELSE
          IF EasyRequestArgs(win,[20,0,'Quitter?','T'es sûr, mec?','Voui|Meuh nooon!'],0,NIL)=1 THEN do:=FALSE
        ENDIF
      ELSEIF code=SELECTDOWN
        IF qual AND 1
          zoomin(mx,my)
        ELSE
          findxy(b,mx,my)
        ENDIF
      ENDIF
    ENDWHILE
  ENDIF
EXCEPT DO
  closeclonescreen(screen,font,win)
  IF rdargs THEN FreeArgs(rdargs)
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
    CASE "SCR";                 WriteF('Pas d'écran!\n')
    CASE "WIN";                 WriteF('Pas de fenêtre!\n')
    CASE ER_BADARGS;            WriteF('Mauvais arguments pour GDU!\n')
    CASE ER_MEM;                WriteF('Pas de mémoire!\n')
    CASE ER_COML;               WriteF('Pas de ligne de commande spécifié\n')
    CASE ER_UTIL;               WriteF('Nepeut pas ouvrir l''"utility.library" v37\n')
    CASE ERROR_BREAK;           WriteF('Arrêt de GDU par l''utilisateur\n')
    CASE ERROR_BUFFER_OVERFLOW; WriteF('Erreur interne\n')
    DEFAULT;                    PrintFault(exception,'Dos Error')
  ENDSELECT
ENDPROC

PROC refresh()
  SetRast(stdrast,0)
  dogfx(b,5,20,xsize-10,ysize-30,TRUE)
ENDPROC

PROC recdir(dirr) HANDLE
  DEF er,i:PTR TO fileinfoblock,size=0,anchor=NIL:PTR TO anchorpath,
      fullpath,x,num=0,l=NIL,rl:PTR TO dir
  CtrlC()
  anchor:=New(SIZEOF anchorpath+MAXPATH)
  anchor.breakbits:=4096
  anchor.strlen:=MAXPATH-1
  er:=MatchFirst(dirr,anchor)               /* collecte toutes les chaines */
  WHILE er=0
    fullpath:=anchor+SIZEOF anchorpath
    i:=anchor.info
    IF i.direntrytype<0
      size:=size+Shr(i.size+1023,9)
      num++
    ELSE
      x:=StrLen(fullpath)
      IF x+5<MAXPATH THEN CopyMem('/#?',fullpath+x,4)
      rl:=recdir(fullpath)
      size:=size+rl.size
      fullpath[x]:=0
      ->l:=NEW [l,rl]
      l:=addsorted(l,rl)
    ENDIF
    er:=MatchNext(anchor)
  ENDWHILE
  IF er<>ERROR_NO_MORE_ENTRIES THEN Raise(er)
  MatchEnd(anchor)
  Dispose(anchor)
  anchor:=NIL
  INC dirno
EXCEPT
  IF anchor THEN MatchEnd(anchor)
  Raise(exception)
ENDPROC consdir(dirr,IF size THEN size ELSE 1,l)

PROC addsorted(l:PTR TO LONG,d:PTR TO dir)
  DEF d2:PTR TO dir,p:PTR TO LONG,c:PTR TO LONG
  IF l=NIL
    RETURN NEW [NIL,d]
  ELSE
    d2:=l[1]
    IF d.size>d2.size
      RETURN NEW [l,d]
    ELSE
      c:=l
      REPEAT
        p:=c; c:=c[]
      UNTIL IF c THEN (d2:=c[1]) BUT d.size>d2.size ELSE TRUE
      p[]:=NEW [c,d]
    ENDIF
  ENDIF
ENDPROC l

PROC dogfx(b:PTR TO dir,x,y,xs,ys,isx)
  DEF l:PTR TO LONG,cs=0,sb:PTR TO dir,mc,last
  b.x:=x; b.y:=y; b.xs:=xs; b.ys:=ys
  IF (xs>2) AND (ys>2)
    Line(x,y,x+xs,y)
    Line(x,y,x,y+ys)
    Line(x+xs,y,x+xs,y+ys)
    Line(x,y+ys,x+xs,y+ys)
    l:=b.sub
    WHILE l
      l <=> [l,sb]
      dogfx(sb,IF isx THEN Div(Mul(cs,xs),b.size)+x ELSE x,
               IF isx THEN y ELSE Div(Mul(cs,ys),b.size)+y,
               IF isx THEN Div(Mul(sb.size,xs),b.size) ELSE xs,
               IF isx THEN ys ELSE Div(Mul(sb.size,ys),b.size),
               Not(isx))
      cs:=cs+sb.size
    ENDWHILE
    IF isx
      x:=x+xs; xs:=xs-Div(Mul(cs,xs),b.size); x:=x-xs
    ELSE
      y:=y+ys; ys:=ys-Div(Mul(cs,ys),b.size); y:=y-ys
    ENDIF
    IF ys>10
      IF xs>20
        mc:=xs-4/8
        last:=b.name+EstrLen(b.name)
        WHILE (last>b.name) AND (last[]<>"/") AND (last[]<>":") DO last--
        mc:=last-mc
        IF mc<b.name THEN mc:=b.name
        IF mc=last THEN StrCopy(s,'#?') ELSE StrCopy(s,mc,last-mc)
        TextF(xs/2+x-(EstrLen(s)*4),ys/2+y+3,s)
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC zoomin(x,y)
  DEF l:PTR TO LONG,b2:PTR TO dir
  l:=b.sub
  WHILE l
    b2:=l[1]
    IF x>=b2.x
      IF y>=b2.y
        IF x<(b2.x+b2.xs)
          IF y<(b2.y+b2.ys) THEN st.push(b) BUT (b:=b2) BUT refresh()
        ENDIF
      ENDIF
    ENDIF
    l:=l[]
  ENDWHILE
ENDPROC

PROC zoomout()
  IF st.is_empty()
    DisplayBeep(screen)
  ELSE
    b:=st.pop()
    refresh()
  ENDIF
ENDPROC

PROC findxy(b:PTR TO dir,x,y)
  DEF f=FALSE,l:PTR TO LONG,numsub=0
  IF x>=b.x
    IF y>=b.y
      IF x<(b.x+b.xs)
        IF y<(b.y+b.ys)
          l:=b.sub
          WHILE l
            f:=f OR findxy(l[1],x,y)
            l:=l[]
            numsub++
          ENDWHILE
          IF f=FALSE
            f:=TRUE
            StringF(s,IF numsub THEN '\s, \d octets [incluant \d sous répertoire(s)].' ELSE '\s, \d octets.',b.name,Shl(b.size,9),numsub)
            SetWindowTitles(win,s,s)
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC f
