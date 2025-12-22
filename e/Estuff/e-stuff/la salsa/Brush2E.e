MODULE  'intuition/intuition', 'intuition/screens',
'libraries/iff', 'iff',
'tools/ctype'

PROC main()
  DEF sn:PTR TO screen, wn:PTR TO window
  DEF iff, bmhd:PTR TO bmh
  DEF ct[256]:ARRAY OF INT
  DEF rdargs, myargs[4]:LIST
  DEF currentplane, x, y, xx, i, number, pixel, pass=NIL
  DEF str[100]:STRING, temp[100]:STRING
  DEF fh, name[100]:STRING
  IF (iffbase:=OpenLibrary('iff.library', 22))
    myargs[0]:=NIL
    myargs[1]:=NIL
    myargs[2]:=NIL
    IF (rdargs:=ReadArgs('PICTURE/A,FILE/A,COLOURS/S',myargs,0))
      StrCopy(name,myargs[0])
      StringF(name,'\s', FilePart(myargs[0]))
      LowerStr(name)
      IF (iff:=IfFL_OpenIFF(myargs[0],IFFL_MODE_READ))
        bmhd:=IfFL_GetBMHD(iff)
        PrintF('\s\t=\t\d x \d x \e[1m\d\e[0m\n', FilePart(myargs[0]), bmhd.width, bmhd.height, twotothepower(bmhd.nplanes))
        IF (fh:=Open(myargs[1],NEWFILE))
          IF (sn:=OpenScreenTagList(NIL,[SA_WIDTH,bmhd.pagewidth,SA_HEIGHT,bmhd.pageheight,SA_DEPTH,bmhd.nplanes,
            SA_TITLE,FilePart(myargs[0]),SA_DISPLAYID,($8ce4 AND IfFL_GetViewModes(iff)),NIL]))
            IF (wn:=OpenWindowTagList(NIL,[WA_CUSTOMSCREEN,sn,WA_BORDERLESS,TRUE,NIL]))
              LoadRGB4(sn.viewport,ct,IfFL_GetColorTab(iff,ct))
              IfFL_DecodePic(iff,sn.bitmap)
              Write(fh,'-> Brush2E was written by Steven Goodgrove\n\n', 44)
              IF myargs[2]=-1
                StringF(temp,'\scolours:\n', name)
                Write(fh,temp,StrLen(temp))
                pass:=0
                FOR i:=0 TO twotothepower(bmhd.nplanes)-1
                  IF pass=0 THEN Write(fh,'\nINT\t', 5)
                  IF pass=3 THEN pass:=0 ELSE pass:=pass+1
                  StringF(temp,'$\z\h[4]', ct[i])
                  Write(fh,temp,StrLen(temp))
                  IF pass<>0 THEN Write(fh,', ',2)
                ENDFOR
              ENDIF
              StringF(temp,'\n\n\sbody:', name)
              Write(fh,temp,StrLen(temp))
              FOR currentplane:=1 TO bmhd.nplanes
                StringF(temp,'\n\n-> Plane \d', currentplane)
                Write(fh,temp,StrLen(temp))
                pass:=NIL
                FOR y:=0 TO bmhd.height-1
                  FOR x:=0 TO bmhd.width-1 STEP 16
                    IF pass<>0 THEN Write(fh,', ',2)
                    IF pass=0 THEN Write(fh,'\nINT\t',5)
                    IF pass=8 THEN pass:=0 ELSE pass:=pass+1
                    StringF(str,'$')
                    FOR xx:=0 TO 3
                      number:=NIL
                      FOR i:=0 TO 3
                        pixel:=ReadPixel(sn.rastport,x+(xx*4)+i,y)
                        IF pixel AND twotothepower(currentplane-1) = twotothepower(currentplane-1) THEN number:=number+twotothepower(3-i)
                      ENDFOR
                      StringF(str,'\s\z\h[1]', str, number)
                    ENDFOR
                    Write(fh,str,StrLen(str))
                  ENDFOR
                ENDFOR
              ENDFOR
              StringF(temp,'\n\n\sdata:=[0,0,\d,\d,\d,{\sbody},\d,0,0]:image\n', name, bmhd.width, bmhd.height,
              bmhd.nplanes, name, twotothepower(bmhd.nplanes)-1)
              Write(fh,temp,StrLen(temp))
              CloseW(wn)
            ENDIF
            CloseS(sn)
          ELSE
            PrintF('Could\ant open screen\n')
          ENDIF
          Close(fh)
        ELSE
          PrintF('Couldn\at open output file\n')
        ENDIF
        IfFL_CloseIFF(iff)
      ELSE
        PrintF('Couldn\at open iff brush\n')
      ENDIF
      FreeArgs(rdargs)
    ELSE
      PrintF('Bad args!\n')
    ENDIF
    CloseLibrary(iffbase)
  ELSE
    PrintF('Couldn\at open iff.library version 22 or better.\n')
  ENDIF
ENDPROC

PROC twotothepower(no)
  DEF i, res=1
  FOR i:=1 TO no
    res:=res*2
  ENDFOR
ENDPROC res

version:
CHAR  0, '$VER: Brush2E 3.2 (03/07/97)', 0
