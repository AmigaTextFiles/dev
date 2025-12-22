/*------------------------------------------------------------------------*
  cookRawkeyTest.e - test and demonstrate usage of module cookRawkey.m

  See function winDim() for a neato (although somewhat messy) example of
  font- and os-sensitivity.

  Note: if your using custom fonts, you must have all characters defined
  in order to see them.  If any show up blank (except for, like, Space),
  chances are that character isn't defined in your font.
 *------------------------------------------------------------------------*/

MODULE 'devices/inputevent',
       'graphics/gfxbase',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'tools/cookRawkey',
       'tools/ctype'

CONST ESCAPE_KEY=27

CONST TEXT_MAXLENGTH=23,
      TITLE_MAXLENGTH=20

DEF wborleft, wborbottom, fontBelowBase

PROC max(a, b) IS IF a>b THEN a ELSE b

PROC winDim(gfxBase:PTR TO gfxbase, windowTitle)
/* determine the dimensions necessary to display our text. */
  DEF scr:PTR TO screen, xsize=0, ysize=0
  IF KickVersion(36)
    IF scr:=LockPubScreen('Workbench')
      xsize:=max(gfxBase.defaultfont::textfont.xsize*TEXT_MAXLENGTH,
                 IntuiTextLength([0,1,RP_JAM1,0,0, scr.font,
                                  windowTitle,NIL]:intuitext)+1)+
             (wborleft:=scr.wborleft)+scr.wborright
      ysize:=gfxBase.defaultfont::textfont.ysize+
             scr.rastport::rastport.font::textfont.ysize+
             scr.wbortop+1+
             (wborbottom:=scr.wborbottom)
      UnlockPubScreen(NIL, scr)
    ENDIF
  ELSE
    wborleft:=4
    wborbottom:=4
    xsize:=8*TEXT_MAXLENGTH+(wborleft*2)
    ysize:=8*2+(wborbottom*2+1)
  ENDIF
ENDPROC xsize,ysize

PROC format(s, format, n)
/*---------------------------------------------------------*
  format string 's' with number 'n', according to format
  string 'format'.  pads leading spaces in 's' with zeroes.
 *---------------------------------------------------------*/
  DEF i, strLast
  StringF(s, format, n)
  strLast:=StrLen(s)-1
  FOR i:=0 TO strLast DO IF s[i]=" " THEN s[i]:="0"
ENDPROC s

PROC main() HANDLE
  DEF win=NIL:PTR TO window, winTitle, winHeight, winWidth,
      idcmpMessage:PTR TO intuimessage, idcmpCode, idcmpQualifier, iAddress,
      error, errorMessage, asciiChar, hexStr[3]:STRING, decStr[3]:STRING
  /*------------------------------*
    Init rawkey conversion module.
   *------------------------------*/
  IF error:=warmupRawkeyCooker() THEN Raise(error)
  winWidth,winHeight:=winDim(gfxbase, winTitle:='Press Escape to Quit')
  /*-- Convert rawkeys until ESC key is pressed. --*/
  IF win:=OpenW(20, 20, winWidth, winHeight,
                IDCMP_RAWKEY, WFLG_ACTIVATE,
                winTitle, NIL, WBENCHSCREEN, NIL)
    IF FALSE=KickVersion(36) THEN SetTopaz(win)
    fontBelowBase:=win.rport::rastport.txheight-
                   win.rport::rastport.font::textfont.baseline
    REPEAT
      /*-- Wait on rawkey. --*/
      WHILE (idcmpMessage:=GetMsg(win.userport))=NIL DO WaitPort(win.userport)
      /*-- Copy intuimessage info, then reply. --*/
      idcmpCode:=idcmpMessage.code
      idcmpQualifier:=idcmpMessage.qualifier
      iAddress:=idcmpMessage.iaddress
      ReplyMsg(idcmpMessage)
      /*------------------------*
        Convert rawkey to ascii.
       *------------------------*/
      IF asciiChar:=cookRawkey(idcmpCode, idcmpQualifier, iAddress)
        TextF(wborleft, win.height-wborbottom-fontBelowBase,
              'Char=\c Hex=$\s Dec=\s',
              IF isprint(asciiChar) THEN asciiChar ELSE $7f,
              format(hexStr, '\h[3]', asciiChar),
              format(decStr, '\d[3]', asciiChar))
      ENDIF
    UNTIL asciiChar=ESCAPE_KEY
    CloseW(win)
  ELSE
    WriteF('Can''t open window\n')
  ENDIF
  /*---------------------------------*
    Cleanup rawkey conversion module.
   *---------------------------------*/
  shutdownRawkeyCooker()
EXCEPT
  errorMessage:='figger it out'
  /*--------------------------------------*
    Handle exceptions raised by conversion
   *--------------------------------------*/
  SELECT exception
    CASE "MEM";          errorMessage:='get memory'
    CASE ER_CREATEPORT;  errorMessage:='create message port'
    CASE ER_CREATEIO;    errorMessage:='create IO request'
    CASE ER_OPENDEVICE;  errorMessage:='open console.device'
    CASE ER_ASKKEYMAP;   errorMessage:='ask keymap'
  ENDSELECT
  WriteF('Could not \s!\n', errorMessage)
  /*---------------------------------*
    Cleanup rawkey conversion module.
   *---------------------------------*/
  shutdownRawkeyCooker()
ENDPROC
