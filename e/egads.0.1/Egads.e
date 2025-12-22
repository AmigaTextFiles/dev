/*--------------------------------------------------------------------*
  Egads.e - Demo of creating, modifying, reading, and freeing relative
            gadgets WITHOUT GadTools:  vertical propgadget, horizontal
            propgadget, and two buttons.

  Hacked together by Barry Wills.
  This source code is hereby placed in the public domain.  Use it,
  don't abuse it...and certainly don't abuse me. :-)  No guarantees
  except that it runs on my machine. :-) :-)

  Pre-v36 folks!  The following are the only v36+ dependent areas of
  this program (I think).  An resourceful individual could code around
  them.
  - LockPubScreen():  to get current font info.
  - UnlockPubScreen():  ditto.
  - NewModifyProp():  use argument of -1 instead of 1.
  - PROPNEWLOOK:  remove it.

  UPDATE 0.1:
  - object declaration "screenFont:PTR TO textfont" change to
    "screenFont:PTR TO tf".
 *--------------------------------------------------------------------*/
OPT OSVERSION=36

MODULE 'dos/dos',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens'

RAISE "MEM" IF New () = NIL

CONST IDCMP_DEFAULTFLAGS = IDCMP_CLOSEWINDOW + IDCMP_NEWSIZE +
                           IDCMP_GADGETDOWN  + IDCMP_GADGETUP,
      WFLG_DEFAULTFLAGS  = WFLG_ACTIVATE   + WFLG_DRAGBAR     + WFLG_CLOSEGADGET +
                           WFLG_SIZEGADGET + WFLG_DEPTHGADGET + WFLG_NOCAREREFRESH
         /* Note:  you may wish to use another refresh method; the other   */
         /* methods exhibit strange flashing because the gadgets are drawn */
         /* in the window borders and I guess Intuition doesn't like it.   */

CONST VERTSCROLLER_FLAGS     = GFLG_GADGHCOMP   + GFLG_RELHEIGHT + GFLG_RELRIGHT,
      VERTSCROLLER_ACTFLAGS  = GACT_IMMEDIATE   + GACT_RELVERIFY +
                               GACT_FOLLOWMOUSE + GACT_RIGHTBORDER,
      HORIZSCROLLER_FLAGS    = GFLG_GADGHCOMP   + GFLG_RELWIDTH  + GFLG_RELBOTTOM,
      HORIZSCROLLER_ACTFLAGS = GACT_IMMEDIATE   + GACT_RELVERIFY +
                               GACT_FOLLOWMOUSE + GACT_BOTTOMBORDER

CONST MAX_WIDTH = 2000,
      MAX_HEIGHT = 2000

DEF scr = NIL    : PTR TO screen,
    rastport     : PTR TO rastport,
    screenFont   : PTR TO tf,
    win = NIL    : PTR TO window,
    idcmpMessage : PTR TO intuimessage,
    idcmpClass, offy, offx

DEF gads = NIL,
    horizontalScroller : PTR TO gadget,
    verticalScroller   : PTR TO gadget,
    upButton           : PTR TO gadget,
    downButton         : PTR TO gadget,
    currentVert = 0, currentHoriz = 0


/*-----------------------------------------------------------------*/
/*-- Create/Free Gadgets ------------------------------------------*/
/*-----------------------------------------------------------------*/

PROC newVerticalScroller ()
  DEF g   : PTR TO gadget,
      vsi : PTR TO image,
      pi  : PTR TO propinfo
  g := New (SIZEOF gadget)
  vsi := New (SIZEOF image)
  pi := New (SIZEOF propinfo)
  pi.flags := (FREEVERT + AUTOKNOB + PROPNEWLOOK)
  g.leftedge := -15
  g.topedge := offy+12
  g.width := 13
  /*-- Intuition uses title height of 8, so I must --*/
  /*-- adjust for *real* title font height:        --*/
  g.height := -45 - (screenFont.ysize-8)
  g.flags := VERTSCROLLER_FLAGS
  g.activation := VERTSCROLLER_ACTFLAGS
  g.gadgettype := GTYP_PROPGADGET
  g.gadgetrender := vsi
  g.specialinfo := pi
  g.nextgadget := NIL
ENDPROC  g
  /* newVerticalScroller */

PROC newHorizontalScroller ()
  DEF g   : PTR TO gadget,
      hsi : PTR TO image,
      pi  : PTR TO propinfo
  g := New (SIZEOF gadget)
  hsi := New (SIZEOF image)
  pi := New (SIZEOF propinfo)
  pi.flags := (FREEHORIZ + AUTOKNOB + PROPNEWLOOK)
  g.leftedge := offx
  g.topedge := -9
  g.width := -22
  g.height := 8
  g.flags := HORIZSCROLLER_FLAGS
  g.activation := HORIZSCROLLER_ACTFLAGS
  g.gadgettype := GTYP_PROPGADGET
  g.gadgetrender := hsi
  g.specialinfo := pi
  g.nextgadget := NIL
ENDPROC  g
  /* newHorizontalScroller */

PROC newUpButton ()
  DEF g : PTR TO gadget,
      upGadgetRender1 : PTR TO border,
      upGadgetRender2 : PTR TO border,
      upGadgetRender3 : PTR TO border,
      upSelectRender1 : PTR TO border,
      upSelectRender2 : PTR TO border,
      upSelectRender3 : PTR TO border,
      upXY1 : PTR TO INT,
      upXY2 : PTR TO INT,
      upXY3 : PTR TO INT
  upXY3 := [ 3,6,  8, 4, 12, 6] : INT    /* Little arrow.          */
  upXY2 := [16,0, 16,10,  0,10] : INT    /* Right and bottom edge. */
  upXY1 := [15,0,  -1, 0,  -1,10] : INT  /* Left and top edge.     */
  upGadgetRender3 := [0,0,1,0,RP_JAM1,3, upXY3, NIL] : border
  upGadgetRender2 := [0,0,1,0,RP_JAM1,3, upXY2, upGadgetRender3] : border
  upGadgetRender1 := [0,0,2,0,RP_JAM1,3, upXY1, upGadgetRender2] : border
  upSelectRender3 := [0,0,1,0,RP_JAM1,3, upXY3, NIL] : border
  upSelectRender2 := [0,0,2,0,RP_JAM1,3, upXY2, upSelectRender3] : border
  upSelectRender1 := [0,0,1,0,RP_JAM1,3, upXY1, upSelectRender2] : border
  g := New (SIZEOF gadget)
  g.leftedge := -16
  g.topedge := -31
  g.width := 15
  g.height := 11
  g.flags := (GFLG_RELBOTTOM + GFLG_RELRIGHT + GFLG_GADGHIMAGE)
  g.activation := (GACT_RELVERIFY + GACT_IMMEDIATE)
  g.gadgettype := GTYP_BOOLGADGET
  g.gadgetrender := upGadgetRender1
  g.selectrender := upSelectRender1
  g.nextgadget := NIL
ENDPROC  g
  /* newUpButton */

PROC newDownButton ()
  DEF g : PTR TO gadget,
      downGadgetRender1 : PTR TO border,
      downGadgetRender2 : PTR TO border,
      downGadgetRender3 : PTR TO border,
      downSelectRender1 : PTR TO border,
      downSelectRender2 : PTR TO border,
      downSelectRender3 : PTR TO border,
      downXY1 : PTR TO INT,
      downXY2 : PTR TO INT,
      downXY3 : PTR TO INT
  downXY3 := [ 3,4,  8, 6, 12, 4] : INT    /* Little arrow.          */
  downXY2 := [16,0, 16,10,  0,10] : INT    /* Right and bottom edge. */
  downXY1 := [15,0,  -1, 0,  -1,10] : INT  /* Left and top edge.     */
  downGadgetRender3 := [0,0,1,0,RP_JAM1,3, downXY3, NIL] : border
  downGadgetRender2 := [0,0,1,0,RP_JAM1,3, downXY2, downGadgetRender3] : border
  downGadgetRender1 := [0,0,2,0,RP_JAM1,3, downXY1, downGadgetRender2] : border
  downSelectRender3 := [0,0,1,0,RP_JAM1,3, downXY3, NIL] : border
  downSelectRender2 := [0,0,2,0,RP_JAM1,3, downXY2, downSelectRender3] : border
  downSelectRender1 := [0,0,1,0,RP_JAM1,3, downXY1, downSelectRender2] : border
  g := New (SIZEOF gadget)
  g.leftedge := -16
  g.topedge := -20
  g.width := 15
  g.height := 11
  g.flags := (GFLG_RELBOTTOM + GFLG_RELRIGHT + GFLG_GADGHIMAGE)
  g.activation := (GACT_RELVERIFY + GACT_IMMEDIATE)
  g.gadgettype := GTYP_BOOLGADGET
  g.gadgetrender := downGadgetRender1
  g.selectrender := downSelectRender1
  g.nextgadget := NIL
ENDPROC  g
  /* newDownButton */

PROC newGadgets ()
  DEF glist, g : PTR TO gadget
  /*-- Scroller Gadgets. --*/
  g := glist := verticalScroller := newVerticalScroller ()
  g.nextgadget := horizontalScroller := newHorizontalScroller ()
  g := g.nextgadget
  /*-- Scroll Button Gadgets. --*/
  g.nextgadget := upButton := newUpButton ()
  g := g.nextgadget
  g.nextgadget := downButton := newDownButton ()
  g := downButton
ENDPROC  glist
  /* newGadgets */

PROC freeGadgets (g : PTR TO gadget)
  DEF ng : PTR TO gadget
  /*-- Dispose of two propgads... --*/
  ng := g.nextgadget
  Dispose (g.specialinfo); Dispose (g.gadgetrender); Dispose (g)
  g := ng; ng := ng.nextgadget
  Dispose (g.specialinfo); Dispose (g.gadgetrender); Dispose (g)
  /*-- ...and two button gads. --*/
  Dispose (ng.nextgadget); Dispose (ng)
ENDPROC
  /* freeGadgets */


/*-----------------------------------------------------------------*/
/*-- Propgad Calculation Routines ---------------------------------*/
/*-----------------------------------------------------------------*/

PROC unsigned (x) RETURN x AND $FFFF

PROC signed (x)
  MOVE.L  x,D0
  EXT.L   D0
  MOVE.L  D0,x
ENDPROC  x
  /* signed */

PROC setLocation (maxValue, viewSize, value)
/*-- horizPot := value / maxValue * MAXPOT --*/
  IF (maxValue <= viewSize) OR (maxValue-viewSize < value)
    RETURN signed ($FFFF)
  ELSE
    RETURN signed (SpFix(SpMul(SpFlt(MAXPOT),
                               SpDiv(SpFlt(maxValue-viewSize), SpFlt(value)))))
  ENDIF
ENDPROC
  /* setLocation */

PROC setSize (maxValue, viewSize)
/*-- horizBody := viewSize / maxValue * MAXBODY --*/
  RETURN signed (SpFix(SpMul(SpFlt(MAXBODY),
                             SpDiv(SpFlt(IF maxValue<viewSize THEN viewSize ELSE maxValue),
                                   SpFlt(viewSize)))))
ENDPROC
  /* setSize */

PROC readLocation (maxValue, viewSize, potValue)
/*-- newLineNumber := vertPot / MAXPOT * maxValue --*/
  IF maxValue <= viewSize
    RETURN 0
  ELSE
    RETURN SpFix (SpMul(SpFlt(maxValue-viewSize),
                        SpDiv(SpFlt(MAXPOT),
                              SpFlt(unsigned(potValue)))))
  ENDIF
ENDPROC
  /* readLocation */

PROC recalculateHorizontalPropGadget ()
  DEF propInfo : PTR TO propinfo
  propInfo := horizontalScroller.specialinfo
  NewModifyProp (horizontalScroller, win, NIL, propInfo.flags,
                 setLocation (MAX_WIDTH, win.width, currentHoriz), 0,
                 setSize (MAX_WIDTH, win.width), 0, 1)
ENDPROC
  /* recalculateHorizontalPropGadget */

PROC recalculateVerticalPropGadget ()
  DEF propInfo : PTR TO propinfo
  propInfo := verticalScroller.specialinfo
  NewModifyProp (verticalScroller, win, NIL, propInfo.flags,
                 0, setLocation (MAX_HEIGHT, win.height, currentVert),
                 0, setSize (MAX_HEIGHT, win.height), 1)
ENDPROC
  /* recalculateVerticalPropGadget */

/*-----------------------------------------------------------------*/
/*-- Event Handlers -----------------------------------------------*/
/*-----------------------------------------------------------------*/

PROC writeValues ()
  TextF (offx+10, rastport.txheight*2+10+offy, 'currentVert  = \d[4]', currentVert)
  TextF (offx+10, rastport.cp_y+rastport.txheight, 'currentHoriz = \d[4]', currentHoriz)
ENDPROC
  /* writeValues */

PROC doVerticalScroller ()
  DEF propInfo : PTR TO propinfo
  ModifyIDCMP (win, (IDCMP_DEFAULTFLAGS OR IDCMP_MOUSEMOVE))
  propInfo := verticalScroller.specialinfo
  REPEAT
    IF idcmpMessage := GetMsg (win.userport)
      idcmpClass := idcmpMessage.class
      ReplyMsg (idcmpMessage)
      IF (idcmpClass = IDCMP_MOUSEMOVE) OR (idcmpClass = IDCMP_GADGETUP)
        currentVert := readLocation (MAX_HEIGHT, win.height, propInfo.vertpot)
        SELECT idcmpClass
          CASE IDCMP_MOUSEMOVE; writeValues ()
          CASE IDCMP_GADGETUP;  writeValues ()
        ENDSELECT
      ENDIF
    ELSE
      WaitPort (win.userport)
    ENDIF
  UNTIL idcmpClass = IDCMP_GADGETUP
  recalculateVerticalPropGadget ()
  ModifyIDCMP (win, IDCMP_DEFAULTFLAGS)
ENDPROC
  /* doVerticalScroller */

PROC doHorizontalScroller ()
  DEF propInfo : PTR TO propinfo
  ModifyIDCMP (win, (IDCMP_DEFAULTFLAGS OR IDCMP_MOUSEMOVE))
  propInfo := horizontalScroller.specialinfo
  REPEAT
    IF idcmpMessage := GetMsg (win.userport)
      idcmpClass := idcmpMessage.class
      ReplyMsg (idcmpMessage)
      IF (idcmpClass = IDCMP_MOUSEMOVE) OR (idcmpClass = IDCMP_GADGETUP)
        currentHoriz := readLocation (MAX_WIDTH, win.width, propInfo.horizpot)
        writeValues ()
      ENDIF
    ELSE
      WaitPort (win.userport)
    ENDIF
  UNTIL idcmpClass = IDCMP_GADGETUP
  recalculateHorizontalPropGadget ()
  ModifyIDCMP (win, IDCMP_DEFAULTFLAGS)
ENDPROC
  /* doHorizontalScroller */

PROC doUpButton ()
  REPEAT
    IF idcmpMessage := GetMsg (win.userport)
      idcmpClass := idcmpMessage.class
      ReplyMsg (idcmpMessage)
    ELSEIF currentVert > 0
      DEC currentVert
      recalculateVerticalPropGadget ()
      writeValues ()
    ENDIF
  UNTIL idcmpClass = IDCMP_GADGETUP
ENDPROC
  /* doUpButton */

PROC doDownButton ()
  REPEAT
    IF idcmpMessage := GetMsg (win.userport)
      idcmpClass := idcmpMessage.class
      ReplyMsg (idcmpMessage)
    ELSEIF currentVert < (MAX_HEIGHT-win.height)
      INC currentVert
      recalculateVerticalPropGadget ()
      writeValues ()
    ENDIF
  UNTIL idcmpClass = IDCMP_GADGETUP
ENDPROC
  /* doDownButton */



/*-----------------------------------------------------------------*/
/*-- Shutdown -----------------------------------------------------*/
/*-----------------------------------------------------------------*/

PROC openWindow ()
  IF (scr := LockPubScreen ('Workbench')) = NIL THEN Raise ("SCR")
  rastport := scr.rastport
  screenFont := rastport.font
  offy := scr.wbortop + Int (rastport+58) - 10
  offx := scr.wborleft
  IF (win := OpenW (0, 0, 300, 150,
                    IDCMP_DEFAULTFLAGS,
                    WFLG_DEFAULTFLAGS,
                    'E-gads!',
                    scr, CUSTOMSCREEN,
                    gads:=newGadgets())) = NIL THEN Raise ("WIN")
  rastport := stdrast
  Colour (1, 0)
  recalculateVerticalPropGadget ()
  recalculateHorizontalPropGadget ()
  writeValues ()
ENDPROC
  /* openWindow */

PROC closeWindow ()
  DEF g
  RemoveGList (win, g:=win.firstgadget, -1)
  freeGadgets (g)
  CloseW (win)
ENDPROC
  /* closeWindow */


/*-----------------------------------------------------------------*/
/*-- Main ---------------------------------------------------------*/
/*-----------------------------------------------------------------*/

PROC main () HANDLE
  DEF whichGadget
  openWindow ()
  REPEAT
    IF idcmpMessage := GetMsg (win.userport)
      idcmpClass := idcmpMessage.class
      whichGadget := idcmpMessage.iaddress
      ReplyMsg (idcmpMessage); idcmpMessage := NIL
      SELECT idcmpClass
        CASE IDCMP_GADGETDOWN;
          SELECT whichGadget
            CASE horizontalScroller; doHorizontalScroller ()
            CASE verticalScroller;   doVerticalScroller ()
            CASE upButton;           doUpButton ()
            CASE downButton;         doDownButton ()
          ENDSELECT
        CASE IDCMP_NEWSIZE;
          recalculateVerticalPropGadget ()
          recalculateHorizontalPropGadget ()
      ENDSELECT
    ELSE
      WaitPort (win.userport)
    ENDIF
  UNTIL idcmpClass = IDCMP_CLOSEWINDOW
  Raise (0)
EXCEPT
  IF win THEN closeWindow () ELSE IF gads THEN freeGadgets (gads)
  IF scr THEN UnlockPubScreen (NIL, scr)
  IF exception THEN WriteF ('\s\n', [exception,0])
  RETURN IF exception THEN RETURN_WARN ELSE RETURN_OK
ENDPROC
