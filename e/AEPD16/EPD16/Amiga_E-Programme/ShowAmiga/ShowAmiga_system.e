PROC getkey(win:PTR TO window)
  DEF msg:PTR TO intuimessage,key=-1
  WHILE (msg:=GetMsg(win.userport))=NIL DO WaitPort(win.userport)
  ScreenToFront(scr)
  IF msg.class=$200000 THEN IF msg.code=" " OR (msg.code=13) THEN key:=0
  IF msg.class=$400 THEN IF msg.code>="L" AND (msg.code<="O") THEN key:=msg.code-"L"+1
  IF msg.class=$200000 THEN IF msg.code=27 THEN key:=5
  ReplyMsg(msg)
ENDPROC key
PROC getlanguages()
  DEF fh,l=0,s[256]:STRING,i
  IF fh:=Open('Text/Sprachen',OLDFILE)
    WHILE Fgets(fh,s,256)>0
      SetStr(s,StrLen(s)-1)
      IF Char(s)<>0 THEN l++
    ENDWHILE
    Seek(fh,0,-1)
    IF lang:=AllocVec(l+1*4,$10001)
      FOR i:=0 TO l-1
        Fgets(fh,s,256)
        SetStr(s,StrLen(s)-1)
        IF Char(s)=0
          i--
        ELSE
          lang[i]:=AllocVec(StrLen(s)+1,$10001)
          IF lang[i] THEN CopyMem(s,lang[i],StrLen(s)+1) ELSE i:=l-1
        ENDIF
      ENDFOR
      langanz:=l
    ELSE
      langanz:=0
    ENDIF
    Close(fh)
  ENDIF
ENDPROC
PROC getarticles(langnr)
  DEF fh,posmem=NIL:PTR TO LONG,type=NIL:PTR TO CHAR,s[256]:STRING,arts=0,i,q
  cls()
  loadtext(stdrast,-640,50,langnr,'loca',2,2,1,0,fontbig)
  IF fh:=opentext(langnr,'allg')
    arts:=0
    WHILE Fgets(fh,s,256)>0
      SetStr(s,StrLen(s)-1)
      IF Char(s)="\\"
        arts++
      ENDIF
    ENDWHILE
    Seek(fh,0,-1)
    IF posmem:=AllocVec(arts+1*4,$10001)
      type:=AllocVec(arts+1,$10001)
      FOR i:=0 TO arts-1
        posmem[i]:=Seek(fh,0,0)
        q:=FALSE
        WHILE q=FALSE
          IF Fgets(fh,s,256)=0
            q:=TRUE
          ELSE
            SetStr(s,StrLen(s)-1)
            IF Char(s)="\\"
              q:=TRUE
              IF InStr(s,'#',1)>-1 THEN type[i]:=1
              IF InStr(s,'+',1)>-1 THEN type[i]:=type[i]+2
            ENDIF
          ENDIF
        ENDWHILE
      ENDFOR
    ENDIF
    Close(fh)
  ENDIF
ENDPROC posmem,type,arts
PROC freearticles(posmem,type)
  IF posmem THEN FreeVec(posmem)
  IF type THEN FreeVec(type)
ENDPROC
PROC opentext(l,file)
  DEF s[256]:STRING
  StringF(s,'Text/\s/\s',lang[l],file)
ENDPROC Open(s,OLDFILE)
PROC loadtext(rp:PTR TO rastport,x,y,lang,file,l1,l2,c1=-1,c2=-1,font=NIL)
  DEF oldfont,s[256]:STRING,i,fh
  oldfont:=rp.font
  IF font THEN SetFont(rp,font)
  IF fh:=opentext(lang,file)
    FOR i:=0 TO l1-1
      Fgets(fh,s,256)
    ENDFOR
    FOR i:=l1 TO l1+l2-1
      writeline(fh,rp,x,i-l1*Int(rp+58)+y,c1,c2)
    ENDFOR
    Close(fh)
  ENDIF
  IF font THEN CloseFont(font)
  SetFont(rp,oldfont)
ENDPROC
PROC writeline(fh,rp,x,y,c1=-1,c2=-1)
  DEF s[256]:STRING
  IF Fgets(fh,s,256)=0 THEN RETURN FALSE
  SetStr(s,StrLen(s)-1)
  writetext(rp,x,y,s,c1,c2)
ENDPROC TRUE
PROC writetext(rp,x,y,s,c1=-1,c2=-1)
  IF x<0 THEN x:=-x-TextLength(rp,s,StrLen(s))/2
  SetDrMd(rp,0)
  IF c2>-1
    SetAPen(rp,c2)
    Move(rp,x+1,y+Int(rp+62)+1)
    Text(rp,s,StrLen(s))
  ENDIF
  IF c1>-1 THEN SetAPen(rp,c1)
  Move(rp,x,y+Int(rp+62))
  Text(rp,s,StrLen(s))
ENDPROC
PROC delline(rp,l,w,y)
  SetDrMd(rp,5)
  RectFill(rp,l,y,w-1,y+Int(rp+58)-1)
  SetDrMd(rp,1)
ENDPROC
PROC drawbbox(l,t,w,h,c1,c2)
  Line(l,t,l+w-2,t,c1)
  Line(l,t,l,t+h-1,c1)
  Line(l+1,t,l+1,t+h-2,c1)
  Line(l+1,t+h-1,l+w-1,t+h-1,c2)
  Line(l+w-1,t,l+w-1,t+h-1,c2)
  Line(l+w-2,t+1,l+w-2,t+h-1,c2)
ENDPROC
PROC drawimg(x,y,img)
  IF img THEN DrawImage(stdrast,img,x,y)
ENDPROC
PROC cls(flags=0)
  IF cimage
    SetAPen(stdrast,2)
    RectFill(stdrast,0,0,win.width-cimage.width/2-1,win.height-1)
    RectFill(stdrast,win.width-cimage.width/2+cimage.width,0,win.width-1,win.height-1)
    RectFill(stdrast,0,0,win.width-1,win.height-cimage.height/2-1)
    RectFill(stdrast,0,win.height-cimage.height/2+cimage.height,win.width-1,win.height-1)
    drawimg(win.width-cimage.width/2,win.height-cimage.height/2,cimage)
    IF flags AND 1
      IF p1img
        drawimg(20,505-p1img.height,p1img)
      ELSE
        loadiff(stdrast,NIL,20,490,'IFF/PfeilLinks.64',1)
      ENDIF
    ENDIF
    IF flags AND 2
      IF p2img
        drawimg(620-p2img.width,505-p2img.height,p2img)
      ELSE
        loadiff(stdrast,NIL,20,490,'IFF/PfeilRechts.64',1)
      ENDIF
    ENDIF
  ELSE
    SetRast(stdrast,2)
    loadiff(stdrast,NIL,-win.width,-win.height,'IFF/C=Logo.8',1)
  ENDIF
ENDPROC

PROC loadiff(rastport,vp,xoff,yoff,name,flags)
  /*   rastport: Bild in diesen Rastport zeichnen, nur wenn (flags AND 1)
             vp: ViewPort für Palette, nur wenn (flags AND 2)
     xoff, yoff: Offset von der linken, oberen Ecke
           name: Gültiger Dateiname
          flags: 1 -> BitMap lesen
                 2 -> Farben lesen
                 4 -> Als Image lesen (result={image})
  */        
  DEF filehandle,eof,chunktype,chunklength,
      bmhd=FALSE,xpic=NIL,ypic=NIL,depth=NIL,compressed=NIL,
      body=FALSE,linebytes,mem,image,x,y,count=NIL,byte=NIL,rep,bigimage=NIL,lb,
         buffer[MAXBUFFER]:ARRAY OF CHAR,bufferpointer=MAXBUFFER,
      cmap=FALSE,nr,r=NIL,g=NIL,b=NIL,mask=NIL
  IF ((flags AND 1)=1) AND (rastport=0) THEN RETURN FALSE
  IF ((flags AND 2)=2) AND (vp=0) THEN RETURN FALSE
  IF (filehandle:=Open(name,OLDFILE))=NIL THEN RETURN FALSE
  Read(filehandle,{chunktype},4)
  Read(filehandle,{chunklength},4)
  IF chunktype<>"FORM"
    Close(filehandle)
    RETURN FALSE
  ENDIF
  Read(filehandle,{chunktype},4)
  IF chunktype<>"ILBM"
    Close(filehandle)
    RETURN FALSE
  ENDIF
  REPEAT
    eof:=Read(filehandle,{chunktype},4)
    eof:=Read(filehandle,{chunklength},4)
    SELECT chunktype
      CASE "BMHD"
        Read(filehandle,{xpic}+2,2)
        Read(filehandle,{ypic}+2,2)
        Seek(filehandle,4,0)
        Read(filehandle,{depth}+3,1)
        Read(filehandle,{mask}+3,1)
        Read(filehandle,{compressed}+3,1)
        Seek(filehandle,9,0)
        bmhd:=TRUE
        IF xoff<0 THEN xoff:=(Abs(xoff)-xpic)/2
        IF yoff<0 THEN yoff:=(Abs(yoff)-ypic)/2
        IF mask<>1 THEN mask:=0
      CASE "BODY"
        IF (bmhd=TRUE) AND ((flags AND 5)>0)
          lb:=(xpic+15)/16*2
          linebytes:=lb*(depth+mask)
          IF (mem:=AllocVec(linebytes,3))
            IF flags AND 4
              IF (bigimage:=AllocVec(linebytes*ypic+20,3))
                CopyMem([0,0,xpic,ypic,depth,bigimage+20,0,0,0]:image,bigimage,20)
                PutChar(bigimage+14,Shl(2,(depth-1))-1)
              ELSE
                flags:=flags-4
              ENDIF
            ENDIF
            image:=[0,0,xpic,1,depth,mem,0,0,0]:image
            PutChar(image+14,Shl(2,(depth-1))-1)
            FOR y:=0 TO (ypic-1)
              IF compressed=0
                readbuffer(filehandle,mem,linebytes,buffer,{bufferpointer})
              ELSEIF compressed=1
                x:=0
                WHILE (x<linebytes) AND (eof<>0)
                  eof:=readbuffer(filehandle,({count}+3),1,buffer,{bufferpointer})
                  IF count<128
                    readbuffer(filehandle,mem+x,count+1,buffer,{bufferpointer})
                    x:=x+count+1
                  ENDIF
                  IF count>128
                    count:=256-count
                    readbuffer(filehandle,({byte}+3),1,buffer,{bufferpointer})
                    FOR rep:=0 TO count
                      PutChar(mem+x+rep,byte)
                    ENDFOR
                    x:=x+count+1
                  ENDIF
                ENDWHILE
              ENDIF
              IF flags AND 1 THEN DrawImage(rastport,image,xoff,yoff+y)
              IF flags AND 4
                FOR x:=0 TO (depth-1)
                  CopyMem(lb*x+mem,lb*ypic*x+(y*lb)+bigimage+20,lb)
                ENDFOR
              ENDIF
            ENDFOR
            FreeVec(mem)
          ENDIF
        ELSE
          Seek(filehandle,(chunklength-Odd(chunklength)),0)
        ENDIF
        body:=TRUE
      CASE "CMAP"
        IF (flags AND 2)
          FOR nr:=1 TO (chunklength/3)
            Read(filehandle,{r}+3,1)
            Read(filehandle,{g}+3,1)
            Read(filehandle,{b}+3,1)
            fullcolour(vp,(nr-1),r,g,b)
          ENDFOR
          Seek(filehandle,-Odd(chunklength),0)
        ELSE
          Seek(filehandle,(chunklength-Odd(chunklength)),0)
        ENDIF
        cmap:=TRUE
      DEFAULT
        Seek(filehandle,(chunklength-Odd(chunklength)),0)
    ENDSELECT
    IF CtrlC() THEN eof:=0
  UNTIL (eof=0) OR (body=TRUE)
  Close(filehandle)
  IF flags AND 4 THEN RETURN bigimage
ENDPROC TRUE
PROC readbuffer(filehandle,to,length,buffer,bufferpointer)
  DEF p=0,eof
  eof:=length
  WHILE length>(MAXBUFFER-^bufferpointer)
    CopyMem(buffer+^bufferpointer,to+p,MAXBUFFER-^bufferpointer)
    p:=p+MAXBUFFER-^bufferpointer
    length:=length-MAXBUFFER+^bufferpointer
    eof:=Read(filehandle,buffer,MAXBUFFER)
    ^bufferpointer:=0
  ENDWHILE
  IF length=0 THEN RETURN eof
  CopyMem(buffer+^bufferpointer,to+p,length)
  ^bufferpointer:=^bufferpointer+length
ENDPROC eof
PROC fullcolour(vp,nr,r,g,b)	/* a replacement for SetRGB32()   */
  MOVE.L vp,A0		/* as the modules for 3.0 weren't */
  MOVE.L nr,D0		/* available yet. */
  MOVE.L r,D1
  SWAP   D1
  LSL.L  #8,D1			/* shift RGB to 32bit */
  MOVE.L g,D2
  SWAP   D2
  LSL.L  #8,D2
  MOVE.L b,D3
  SWAP   D3
  LSL.L  #8,D3
  MOVE.L gfxbase,A6
  JSR    -$354(A6)		/* SetRGB32(vp,nr,r32,g32,b32) */
ENDPROC


