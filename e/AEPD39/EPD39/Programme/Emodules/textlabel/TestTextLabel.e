OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Test program for textlabel.image
*   File            :   testtextlabel.e
*   Copyright       :   © 1993,1994 by hartmut Goebel
*   Author          :   Piotr Gapinski
*   Creation Date   :   04.01.96
*   Current version :   2.2
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date         Version         Comment
*   --------     -------         ------------------------------------------
*   18.07.95     2.1             AOberon version by hartmut Goebel [hG]
*   04.01.96     2.2             AmigaE version
*
*-- REV_END --*
*/

MODULE  'intuition/intuition','intuition/icclass',
        'intuition/screens','intuition/imageclass',
        'intuition/classusr','intuition/gadgetclass',
        'utility/tagitem',
        'libraries/textlabel',
        'tools/exceptions'

#define PROGRAMVERSION '$VER: TestTextLabel 2.2 (04.01.96)'

ENUM  ERR_OK,ERR_KICK,ERR_NOLIB,ERR_STRUCT,ERR_NOMEM
CONST NUMIMAGES     = 5,
      LEFTOFFSET    = 20,
      RIGHTOFFSET   = 20,
      LABELHEIGHT   = 20,
      IMAGEDISTANCE = 4

DEF   textlabelbase=NIL:PTR TO classlibrary,    -> must be defined!
      drawinfo=NIL:PTR TO drawinfo

PROC main() HANDLE
  DEF scr=NIL:PTR TO screen,
      frame=NIL:PTR TO image,
      gad=NIL:PTR TO gadget,
      win=NIL:PTR TO window,
      images[NUMIMAGES]:ARRAY OF LONG,
      im:PTR TO image,
      width,i

  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)
  IF (textlabelbase:=OpenLibrary(TEXTLABELIMAGE,
      TEXTLABELVERSION))=NIL THEN Raise(ERR_NOLIB)
  scr:=LockPubScreen(NIL);
  IF (drawinfo:=GetScreenDrawInfo(scr))=NIL THEN Raise(ERR_STRUCT);
  width := 0
  FOR i:=0 TO NUMIMAGES-1
    IF (im:=makeimage(i))=NIL THEN Raise(ERR_NOMEM)
    images[i]:=im
    IF width<im.width THEN width:=im.width
  ENDFOR

  frame:=NewObjectA(NIL,FRAMEICLASS,
                    [IA_FRAMETYPE,FRAME_BUTTON,TAG_DONE]:tagitem)

  gad:=NewObjectA(NIL,FRBUTTONCLASS,
                    [GA_TOP,30,
                     GA_LEFT,LEFTOFFSET,
                     GA_WIDTH,40,
                     GA_HEIGHT,80,
                     GA_IMAGE,frame,
                     GA_LABELIMAGE,images[],
                     TAG_DONE]:tagitem)

  IF width<gad.width THEN width:=gad.width
  win:=OpenWindowTagList(NIL,
            [WA_PUBSCREEN,scr,
             WA_TOP,48,
             WA_LEFT,140,
             WA_INNERWIDTH,width+LEFTOFFSET-scr.wborleft+RIGHTOFFSET-scr.wborright,
             WA_INNERHEIGHT,180,
             WA_TITLE,'TestTextLabel',
             WA_FLAGS,WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR WFLG_CLOSEGADGET,
             WA_IDCMP,IDCMP_CLOSEWINDOW,
             WA_GADGETS,gad,
             TAG_DONE])
  UnlockPubScreen(NIL,scr);
  IF win<>NIL
    FOR i:=0 TO NUMIMAGES-1
      DrawImageState(win.rport,images[i],0,0,IDS_NORMAL,drawinfo);
    ENDFOR
    waitclose(win)
    FreeScreenDrawInfo(win.wscreen,drawinfo);
  ENDIF
EXCEPT DO
  FOR i:=0 TO NUMIMAGES-1
    EXIT images[i]=NIL
    DisposeObject(images[i])
  ENDFOR
  IF gad THEN DisposeObject(gad)
  IF frame THEN DisposeObject(frame)
  IF win THEN CloseWindow(win)
  IF textlabelbase THEN CloseLibrary(textlabelbase)
  IF exception
    SELECT exception
    CASE ERR_KICK
      WriteF('Wrong kickstart version, require v37+!\n')
    CASE ERR_NOLIB
      WriteF('Couldn\at open \s!\n',TEXTLABELIMAGE)
    CASE ERR_STRUCT
      WriteF('memory error!\n')
    CASE ERR_NOMEM
      WriteF('memory error!\n')
    DEFAULT
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

PROC makeimage(num)
  DEF im:PTR TO image,
      tags[NUMIMAGES]:LIST,
      texts[NUMIMAGES]:LIST
  texts:=[                                 -> shortcut
          ' _yellow submarine ',           ->   "_"
          ' M_MMassivholz ',               ->   "_"
          ' Really??  ',                   ->   "?"
          ' Logik und Berechenbar-keit ',  ->   "-"
          ' kolo8@@sparc10.ely.pg.gda.pl ' ->   "@"
         ]
  tags:=[
         [TLA_ADJUSTMENT,TLADJUST_HLEFT,TAG_DONE],
         [TLA_FGPEN,TEXTPEN,TAG_DONE],
         [TLA_UNDERSCORE,"?",TAG_DONE],
         [TLA_UNDERSCORE,"-",TAG_DONE],
         [TLA_UNDERSCORE,"@",TAG_DONE]
        ]

  im:=NewObjectA(textlabelbase.class,NIL,
        [
         TLA_TEXT,texts[num],
         TLA_LEFT,LEFTOFFSET,
         TLA_TOP,Mul(LABELHEIGHT,num)+50,
         TLA_DRAWINFO,drawinfo,
         TLA_ADJUSTMENT,TLADJUST_HLEFT,
         TAG_MORE,tags[num]
        ]:tagitem)
ENDPROC im

PROC waitclose(win:PTR TO window)
  DEF msg:PTR TO intuimessage,class

  LOOP
    WaitPort(win.userport)
    msg:=GetMsg(win.userport)
    WHILE msg<>NIL
      class:=msg.class
      ReplyMsg(msg);
      IF class=IDCMP_CLOSEWINDOW THEN RETURN;
      msg:=GetMsg(win.userport);
    ENDWHILE
  ENDLOOP
ENDPROC

CHAR PROGRAMVERSION,0
/*EE folds
-1
123 27 126 12 
EE folds*/
