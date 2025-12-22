PROC title(auto)
  DEF fh,i=-1,k,r,p
  SetRast(stdrast,2)
  loadiff(stdrast,NIL,-640,25,'IFF/Titel.64',1)
  loadiff(stdrast,NIL,40,395,'IFF/C=LogoKlein.64',1)
  Colour(0,2)
  r:=49
  k:=-1
  p:=0
  WHILE k<0
    k:=getkey(win)
    r++
    IF r>=50
      r:=0
      delline(stdrast,0,640,170)
      delline(stdrast,0,640,200)      
      delline(stdrast,120,640,400)      
      delline(stdrast,120,640,420)      
      delline(stdrast,0,640,470)      
      i++
      IF lang[i]=0
        i:=0
        IF auto THEN k:=0
        IF p=0
          loadiff(NIL,scr+44,0,0,'IFF/Palette2.64',2)
          p:=1
        ELSE
          loadiff(NIL,scr+44,0,0,'IFF/Palette.64',2)
          p:=0
        ENDIF
      ENDIF
      IF fh:=opentext(i,'Title')
        writeline(fh,stdrast,-640,170)
        writeline(fh,stdrast,-640,200)
        writeline(fh,stdrast,120,400)
        writeline(fh,stdrast,120,420)
        writeline(fh,stdrast,-640,470)
        Close(fh)
      ENDIF
    ENDIF
  ENDWHILE
  IF p=1 THEN loadiff(NIL,scr+44,0,0,'IFF/Palette.64',2)
ENDPROC k
PROC chooselang()
  DEF s[256]:STRING,fh,y,i,x,key=-1,yy,r
  cls()
  IF fh:=Open('Text/Sprachenwahl',OLDFILE)
    y:=10
    WHILE writeline(fh,stdrast,-640,y,1,0)=TRUE
      y:=y+Int(stdrast+58)
    ENDWHILE
    Close(fh)
  ENDIF
  x:=66
  y:=y+50
  yy:=y
  FOR i:=0 TO langanz-1
    StringF(s,'IFF/Flagge\s.64',lang[i])
    Box(x,y,x+187,y+63,2)
    loadiff(stdrast,NIL,x+4,y+2,s,1)
    writetext(stdrast,188-TextLength(stdrast,lang[i],StrLen(lang[i]))/2+x,y+70,lang[i],2,0)
    IF x=66
      x:=386
    ELSE
      x:=66
      y:=y+100
    ENDIF
  ENDFOR
  x:=0
  y:=0
  WHILE key<>0
    drawbbox(x*320+66,y*100+yy,188,64,1,0)
    writetext(stdrast,188-TextLength(stdrast,lang[y*2+x],StrLen(lang[y*2+x]))/2+(x*320)+66,
        y*100+yy+70,lang[y*2+x],1,0)
    r:=0
    key:=-1
    WHILE key<0
      key:=getkey(win)
      r++
      IF r>=200 THEN key:=0
    ENDWHILE
    drawbbox(x*320+66,y*100+yy,188,64,2,2)
    writetext(stdrast,188-TextLength(stdrast,lang[y*2+x],StrLen(lang[y*2+x]))/2+(x*320)+66,
        y*100+yy+70,lang[y*2+x],2,0)
    IF key=1 AND (y>0) THEN y:=y-1
    IF key=2 AND (y<(langanz/2-1)) THEN y:=y+1
    IF key=3 AND (x<1) THEN x:=x+1
    IF key=4 AND (x>0) THEN x:=x-1
    IF y*2+x>=langanz THEN x:=0
  ENDWHILE
ENDPROC y*2+x
PROC displayoverview()
  DEF image:PTR TO image,image2:PTR TO image,i,fh,q,p,
      title[256]:STRING,r
  image:=loadiff(NIL,NIL,0,0,'IFF/Punkt.64',4)
  image2:=loadiff(NIL,NIL,0,0,'IFF/Angekreuzt.64',4)
  cls(2)
  loadtext(stdrast,20,10,langnr,'loca',1,1,1,0,fontbig)
  q:=0
  IF fh:=opentext(langnr,'allg')
    FOR i:=0 TO artanz-1
      IF atyp[i] AND 1
        Seek(fh,art[i],-1)
        Fgets(fh,title,256)
        SetStr(title,StrLen(title)-1)
        drawimg(20,q*22+90,image)
        writetext(stdrast,50,q*22+91,title,1,0)
        q++
      ENDIF
    ENDFOR
    Close(fh)
    drawimg(20,q*22+90,image)
    loadtext(stdrast,50,q*22+91,langnr,'loca',4,1,13,0)
  ENDIF
  i:=-1 ; p:=0
  WHILE i<>0
    drawimg(20,p*22+90,image2)
    r:=0
    i:=-1
    WHILE i<0
      i:=getkey(win)
      r++
      IF r>=400 THEN i:=0
    ENDWHILE
    drawimg(20,p*22+90,image)
    IF i=1 THEN p--
    IF i=2 THEN p++
    IF p<0 THEN p:=q
    IF p>q THEN p:=0
    IF i=3
      p:=-1
      i:=0
    ENDIF
  ENDWHILE
  IF image THEN FreeVec(image)
  IF image2 THEN FreeVec(image2)
  IF p<0
    p:=0
  ELSEIF p=q
    p:=-1
  ELSE
    q:=-1
    FOR i:=0 TO artanz-1
      IF atyp[i] AND 1 THEN q++
      IF q=p
        p:=i
        i:=artanz-1
      ENDIF
    ENDFOR
  ENDIF
ENDPROC p
PROC textautomatic()
  DEF q=FALSE,k,p,r
  p:=0
  displaytext(p)
  WHILE q=FALSE
    r:=0
    WHILE (k:=getkey(win))<0 AND (r<100)
      r++
    ENDWHILE
    IF r>=100
      p++
      IF p>(artanz-1) THEN p:=0
      WHILE (atyp[p] AND 2)=0 AND (p<(artanz-1)) DO p++
      displaytext(p)
    ENDIF
    SELECT k
      CASE 0
        p:=displayoverview()
        IF p<0
          q:=TRUE
        ELSE
          displaytext(p)
        ENDIF
      CASE 3
        IF p<(artanz-1)
          p++
          displaytext(p)
        ENDIF
      CASE 4
        IF p>0
          p--
          displaytext(p)
        ENDIF
    ENDSELECT    
  ENDWHILE
ENDPROC
PROC textsteuerung()
  DEF q=FALSE,k,p,r
  p:=displayoverview()
  IF p<0
    q:=TRUE
  ELSE
    displaytext(p)
  ENDIF
  WHILE q=FALSE
    r:=0
    WHILE (k:=getkey(win))<0 AND (r<400)
      r++
      IF r>=400 THEN q:=TRUE
    ENDWHILE
    SELECT k
      CASE 0
        p:=displayoverview()
        IF p<0
          q:=TRUE
        ELSE
          displaytext(p)
        ENDIF
      CASE 3
        IF p<(artanz-1)
          p++
          displaytext(p)
        ENDIF
      CASE 4
        IF p>0
          p--
          displaytext(p)
        ENDIF
    ENDSELECT    
  ENDWHILE
ENDPROC
PROC displaytext(p)
  DEF fh,s[256]:STRING,y,q=FALSE
  IF fh:=opentext(langnr,'allg')
    IF p>=(artanz-1) THEN cls(1) ELSE IF p<=0 THEN cls(2) ELSE cls(3)
    Seek(fh,art[p],-1)
    y:=0
    WHILE q=FALSE
      Fgets(fh,s,256)
      SetStr(s,StrLen(s)-1)
      IF Char(s)="\\"
        q:=TRUE
      ELSE
        writetext(stdrast,20,y*Int(stdrast+58)+10,s,1,0)
        y++
      ENDIF
    ENDWHILE
    Close(fh)
    loadtext(stdrast,-640,500-Int(stdrast+58),langnr,'loca',0,1,0,-1)
  ENDIF
ENDPROC

