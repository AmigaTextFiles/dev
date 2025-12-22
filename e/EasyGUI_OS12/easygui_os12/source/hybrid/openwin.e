/* RST: hybrid "any kick" replacement for intuition library "OpenWindowTagList"

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition',
       'intuition/screens',
       'hybrid/version'

PROC openWindowTagList(newwin,taglist:PTR TO LONG) -> RST: new, hybrid "any kick" replacement
  DEF win,nw:PTR TO nw,tag,data
  IF intuiVersion(36)
    win:=OpenWindowTagList(newwin,taglist)
  ELSE
    NEW nw
    WHILE tag:=taglist[]++
      data:=taglist[]++
      SELECT tag
        CASE WA_LEFT;         nw.leftedge:=data
        CASE WA_TOP;          nw.topedge:=data
        CASE WA_WIDTH;        nw.width:=data
        CASE WA_HEIGHT;       nw.height:=data
        CASE WA_IDCMP;        nw.idcmpflags:=data
        CASE WA_FLAGS;        nw.flags:=data
        CASE WA_TITLE;        nw.title:=data
        CASE WA_CUSTOMSCREEN; nw.screen:=data
        CASE WA_MINWIDTH;     nw.minwidth:=data
        CASE WA_MINHEIGHT;    nw.minheight:=data
        CASE WA_MAXWIDTH;     nw.maxwidth:=data
        CASE WA_MAXHEIGHT;    nw.maxheight:=data
      ENDSELECT
    ENDWHILE
    nw.type:=IF nw.screen THEN CUSTOMSCREEN ELSE WBENCHSCREEN
    nw.detailpen:=IF nw.screen THEN nw.screen.detailpen ELSE 0
    nw.blockpen:=IF nw.screen THEN nw.screen.blockpen ELSE 1
    win:=OpenWindow(nw)
    END nw
  ENDIF
ENDPROC win
