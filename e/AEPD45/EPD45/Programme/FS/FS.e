/* FS v0.0b */

OPT PREPROCESS                                                  -> Make Macros

#define STR [256]:STRING

PROC main()
  DEF screen,window,file,x,y,n,s[40]:STRING,q,e[256]:STRING     -> Definitions
  DEF s0 STR,s1 STR,s2 STR,s3 STR,s4 STR,s5 STR,s6 STR,s7 STR,s8 STR,s9 STR
  IF screen:=OpenS(320,256,2,0,'FileSelector v0.0b by Martin Kuchinka') -> Opens a Screen
    IF window:=OpenW(0,0,320,256,$40,$11800,NIL,screen,$f,NIL)  -> Opens a Window
      SetColour(screen,0,128,128,128)                           -> Sets Colours
      SetColour(screen,1,255,255,255)
      SetColour(screen,2,0,0,0)
      SetColour(screen,3,0,128,255)
      Box(0,0,320,256,0)                                        -> Clears the Window
      Colour(2,0)
      TextF(88,32,'Select some gadget')                         -> Writes Window Head
      IF file:=Open('S:FS.data',OLDFILE)                        -> Opens File
        FOR n:=0 TO 9
          ReadStr(file,s)                                       -> Reads Button Name
          q:=56+(n*20)
          draw(q,s)                                             -> Draws a Button
        ENDFOR
        ReadStr(file,s0)                                        -> Read File Names
        ReadStr(file,s1)
        ReadStr(file,s2)
        ReadStr(file,s3)
        ReadStr(file,s4)
        ReadStr(file,s5)
        ReadStr(file,s6)
        ReadStr(file,s7)
        ReadStr(file,s8)
        ReadStr(file,s9)
       loop:
        REPEAT
          IF Mouse()=2 THEN BRA exit                            -> A Loop
        UNTIL Mouse()=1
        x:=MouseX(window)                                       -> Gets Mouse Coordinates
        y:=MouseY(window)
        e:=''
        IF And(y>56,y<72) THEN e:=s0                            -> Assigns Selected Strings
        IF And(y>76,y<92) THEN e:=s1
        IF And(y>96,y<112) THEN e:=s2
        IF And(y>116,y<132) THEN e:=s3
        IF And(y>136,y<152) THEN e:=s4
        IF And(y>156,y<172) THEN e:=s5
        IF And(y>176,y<192) THEN e:=s6
        IF And(y>196,y<212) THEN e:=s7
        IF And(y>216,y<232) THEN e:=s8
        IF And(y>236,y<252) THEN e:=s9
        IF StrCmp(e,'',ALL)=TRUE THEN BRA loop                  -> IF string was '' so go back
       exit:
        Close(file)                                             -> Closes file)
      ELSE
        WriteF('Could not open file "S:FS.data" !!!\n')         -> Writes error message
      ENDIF
      CloseW(window)                                            -> Closes Window
    ELSE
      WriteF('Could not open window!!!\n')
    ENDIF
    CloseS(screen)                                              -> Closes Screen
  ELSE
    WriteF('Could not open screen!!!\n')
  ENDIF
  IF e THEN Execute(e,NIL,NIL)
ENDPROC

PROC draw(y,s)                                                  -> Draw Button Procedure
  DEF l
  Colour(1)
  Line(0,y,319,y)
  Line(0,y,0,y+16)
  Line(1,y+16,319,y+16,2)
  Line(319,y+1,319,y+16,2)
  l:=StrLen(s)
  l:=l*8
  l:=(320-l)/2
  TextF(l,y+11,s)
ENDPROC

CHAR '$VER: FS v0.0b by Martin Kuchinka NoTek 19.7.1996'
