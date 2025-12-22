/* set up a screen with a 90 degrees font
   and have a screen with only 60 colums, but a giant 80 rows! */

CONST LINES=512, INTERLACE=TRUE

/* change these two above to suit your needs! if you want
   NTSC, set LINES=400 (etc.)
   best you keep lines to a minimum of 256   */

MODULE 'DiskFont'

CONST COL=LINES/8-3, H=LINES-11, F=INTERLACE*-4

DEF oldfont,newfont,screen,window,tat[4]:ARRAY OF LONG,cx=0,cy=0,font,
    class,code,mes,input[100]:ARRAY,quit=FALSE

PROC main()
  diskfontbase:=OpenLibrary('diskfont.library',0)
  IF diskfontbase=NIL
    WriteF('Could not open "diskfont.library"!\n')
  ELSE
    screen:=OpenS(640,LINES,1,$8000+F,'90 Degrees! Rotate yo monitor!')
    IF screen=NIL
      WriteF('could not open screen!\n')
    ELSE
      window:=OpenW(0,0,640,LINES,$200000,$1940,'!',screen,$F,0)
      IF window=NIL
        WriteF('could not open window!\n')
      ELSE
        font:=setfont('90.font',8,stdrast)
        IF font=NIL
          WriteF('could not open "90.font"!\n')
        ELSE
          mainloop()
          CloseFont(font)
        ENDIF
        CloseW(window)
      ENDIF
      CloseS(screen)
    ENDIF
    CloseLibrary(diskfontbase)
  ENDIF
ENDPROC

PROC mainloop()
  write90('90 degrees command shell.\ntype "HELP" for infos\n')
  REPEAT
    write90('>')
    read90()
    processcommand()
  UNTIL quit
ENDPROC

PROC processcommand()
  DEF s[50]:STRING,p=0,p2,args[100]:STRING,handle,ok,outstr[200]:STRING
  WHILE Char(p+input)=" " DO INC p
  p2:=InStr(input,' ',p)
  StrCopy(s,input+p,p2-p)
  IF p2<>-1 THEN StrCopy(args,input+p2+1,ALL)
  UpperStr(s)
  IF StrCmp(s,'HELP',ALL)
    write90('Commands supported:\n')
    write90('HELP     this one.\n')
    write90('Q        leave!\n')
    write90('D <dir>  show a dir\n')
    write90('T <file> type a file stripped\n')
    write90('M <adr>  show 77 rows of mem\n')
    write90('CLS      guess...\n')
    write90('<anyother> execute clicommand\n')
    write90('(restricted to output only)\n')
  ELSEIF StrCmp(s,'Q',ALL)
    quit:=TRUE
  ELSEIF StrCmp(s,'D',ALL)
    showdir(args)
  ELSEIF StrCmp(s,'M',ALL)
    showmem(args)
  ELSEIF StrCmp(s,'CLS',ALL)
    cx:=0; cy:=0
    Colour(0,0)
    RectFill(stdrast,0,0,639,H+10)
    Colour(1,0)
  ELSEIF StrCmp(s,'T',ALL)
    handle:=Open(args,1005)
    IF handle=NIL
      write90('Could not open file!\n')
    ELSE
      ok:=ReadStr(handle,outstr)
      WHILE ok<>-1
        writestr90(outstr); write90('\n')
        ok:=ReadStr(handle,outstr)
      ENDWHILE
      Close(handle)
    ENDIF
  ELSEIF StrCmp(s,'',ALL)=FALSE
    handle:=Open('ram:$temp',1006)
    IF handle=NIL
      write90('could not open temp file!\n')
    ELSE
      Execute(input,NIL,handle)
      Close(handle)
      handle:=Open('ram:$temp',1005)
      IF handle=NIL
        write90('could not read temp file!\n')
      ELSE
        ok:=ReadStr(handle,outstr)
        WHILE ok<>-1
          write90(outstr); write90('\n')
          ok:=ReadStr(handle,outstr)
        ENDWHILE
        Close(handle)
      ENDIF
    ENDIF        
  ENDIF
ENDPROC

PROC showdir(args)
  DEF lock,ok,d,dir,s[50]:STRING,info[300]:ARRAY
  ADDQ.L #4,info
  BCLR #1,info.B        /* buffer must be LONG aligned */
  lock:=Lock(args,-2)
  IF lock<>0
    ok:=Examine(lock,info)
    IF ok<>0
      dir:=Long(info+4)
      IF dir>0
        StringF(s,'Directory of: \s\n',info+8); write90(s)
        WHILE ok<>0
          ok:=ExNext(lock,info)
          IF ok<>0
            d:=Long(info+124); dir:=Long(info+4)
            IF dir>0
              StringF(s,'\l\s[29]\n',info+8)
            ELSE
              StringF(s,'\l\s[21] \r\d[7]\n',info+8,d)
            ENDIF
            write90(s)
          ENDIF
        ENDWHILE
      ELSE
        write90('No Dir!\n')
      ENDIF
    ENDIF
    UnLock(lock)
  ELSE
    write90('What ?!?\n')
  ENDIF
ENDPROC

PROC showmem(args)
  DEF adr,a,b,radr:PTR TO LONG,c,s[100]:STRING
  adr:=Val(args,{a})
  IF a=0
    write90('Illegal address.\nUsage: M <adr>\n')
  ELSE
    BCLR #0,adr.B                    /* we don't like uneven addresses */
    FOR a:=0 TO 77
      radr:=a*16+adr
      StringF(s,'$\r\z\h[6] ',radr); write90(s)
      FOR b:=0 TO 3
        StringF(s,'\r\z\h[8] ',radr[b]); write90(s)
      ENDFOR
      FOR b:=0 TO 15
        c:=Char(b+radr)
        IF (c<32) OR (c>126) THEN c:=46
        put90(c)
      ENDFOR
      write90('\n')
    ENDFOR
  ENDIF
ENDPROC

PROC write90(string)
  DEF a,s[200]:STRING,l
  StrCopy(s,string,ALL)
  l:=EstrLen(s)-1
  IF l>=0 THEN FOR a:=0 TO l DO put90(Char(a+s))
ENDPROC

PROC writestr90(string)
  DEF a,s[200]:STRING,l,r
  StrCopy(s,string,ALL)
  l:=EstrLen(s)-1
  IF l>=0
    FOR a:=0 TO l
      r:=put90(Char(a+s))
      IF r
        a:=l
        DEC cy
      ENDIF
    ENDFOR
  ENDIF
ENDPROC

PROC read90()
  DEF n=0
  put90("_")
  wait4message()
  put90(8)
  PutChar(input,0)
  WHILE code<>13
    IF (code>=32) AND (COL-1>cx)
      PutChar(input+n,code)
      INC n
      put90(code)
    ELSEIF (code=8) AND (n>0)
      DEC n
      put90(8)
    ENDIF
    PutChar(input+n,0)
    put90("_")
    wait4message()
    put90(8)
  ENDWHILE
  put90(10)
ENDPROC

PROC put90(c)
  DEF b,r=FALSE
  IF c>=32                                    /* character */
    TextF(cy*8,-cx*8+H+10,'\c',c)
    INC cx
    IF COL+1=cx THEN r:=lf()
  ELSEIF c=10                                 /* lf+cr */
    r:=lf()
  ELSEIF (c=8) AND (cx>0)                     /* backspace */
    DEC cx
    put90(" ")
    DEC cx
  ELSEIF c=9                                  /* tab */
    b:=cx AND 7
    IF b=0 THEN cx:=cx+8 ELSE cx:=cx-b+8
    IF cx>COL THEN r:=lf()
  ELSEIF c=13
    cx:=0                                     /* cr */
  ENDIF
ENDPROC r

PROC lf()
  cx:=0
  IF cy=79
    ClipBlit(stdrast,8,11,stdrast,0,11,632,H,$C0)
    Colour(0,0)
    RectFill(stdrast,632,11,639,H+10)
    Colour(1,0)
  ELSE
    INC cy
  ENDIF
ENDPROC TRUE

PROC setfont(name,h,rast)
  oldfont:=Long(rast+52)
  tat[0]:=name
  tat[1]:=Mul(h,$10000)+96
  newfont:=OpenDiskFont(tat)
  IF newfont<>NIL
    SetFont(rast,newfont)
  ENDIF
ENDPROC newfont

PROC wait4message()
  start:
  mes:=GetMsg(Long(window+86))
  IF mes<>0
    class:=Long(mes+20)
    code:=Int(mes+24)
    ReplyMsg(mes)
    IF class<>$200000 THEN JUMP start
  ELSE
    Wait(-1)
    JUMP start
  ENDIF  
ENDPROC
