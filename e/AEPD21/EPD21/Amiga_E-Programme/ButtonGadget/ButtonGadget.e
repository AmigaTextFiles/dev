/*============================================*
  Okay, Arvid et al.  Here it is.
  Sample source for creating your own button
  gadgets.  I tried to make the code somewhat
  reusable.  Hope you enjoy it!
  -- Barry
 *============================================*/
MODULE 'graphics/rastport',
       'intuition/intuition',
       'intuition/screens'

PROC newUpButton (left, top, width, height, id)
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
  /*-- Line coordinates for borders. --*/
  upXY3 := [ 3,6,  8, 4, 12, 6] : INT  -> Little arrow.
  upXY2 := [16,0, 16,10,  0,10] : INT  -> Right and bottom edge.
  upXY1 := [15,0,  -1, 0,  -1,10] : INT  -> Left and top edge.
  /*-- Create and link border structures. --*/
  upGadgetRender3 := [0,0,1,0,RP_JAM1,3, upXY3, NIL] : border
  upGadgetRender2 := [0,0,1,0,RP_JAM1,3, upXY2, upGadgetRender3] : border
  upGadgetRender1 := [0,0,2,0,RP_JAM1,3, upXY1, upGadgetRender2] : border
  upSelectRender3 := [0,0,1,0,RP_JAM1,3, upXY3, NIL] : border
  upSelectRender2 := [0,0,2,0,RP_JAM1,3, upXY2, upSelectRender3] : border
  upSelectRender1 := [0,0,1,0,RP_JAM1,3, upXY1, upSelectRender2] : border
  /*-- Create and initialize gadget. --*/
  IF (g := New (SIZEOF gadget)) = NIL THEN Raise ("MEM")
  g.nextgadget := NIL
  g.leftedge := left
  g.topedge := top
  g.width := width
  g.height := height
  g.flags := GFLG_GADGHIMAGE
  g.activation := GACT_RELVERIFY + GACT_IMMEDIATE
  g.gadgettype := GTYP_BOOLGADGET
  g.gadgetrender := upGadgetRender1
  g.selectrender := upSelectRender1
  g.userdata := id
ENDPROC  g
  /* newUpButton */

PROC newDownButton (left, top, width, height, id)
/*----------------------------------------------------*
  Create an Up-Arrow Button gadget.  Supply the gadget
  ID which will be placed in the userdata field.
 *----------------------------------------------------*/
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
  /*-- Line coordinates for borders. --*/
  downXY3 := [ 3,4,  8, 6, 12, 4] : INT  -> Little arrow.
  downXY2 := [16,0, 16,10,  0,10] : INT  -> Right and bottom edge.
  downXY1 := [15,0,  -1, 0,  -1,10] : INT  -> Left and top edge.
  /*-- Create and link border structures. --*/
  downGadgetRender3 := [0,0,1,0,RP_JAM1,3, downXY3, NIL] : border
  downGadgetRender2 := [0,0,1,0,RP_JAM1,3, downXY2, downGadgetRender3] : border
  downGadgetRender1 := [0,0,2,0,RP_JAM1,3, downXY1, downGadgetRender2] : border
  downSelectRender3 := [0,0,1,0,RP_JAM1,3, downXY3, NIL] : border
  downSelectRender2 := [0,0,2,0,RP_JAM1,3, downXY2, downSelectRender3] : border
  downSelectRender1 := [0,0,1,0,RP_JAM1,3, downXY1, downSelectRender2] : border
  /*-- Create and initialize gadget. --*/
  IF (g := New (SIZEOF gadget)) = NIL THEN Raise ("MEM")
  g.nextgadget := NIL
  g.leftedge := left
  g.topedge := top
  g.width := width
  g.height := height
  g.flags := GFLG_GADGHIMAGE
  g.activation := GACT_RELVERIFY + GACT_IMMEDIATE
  g.gadgettype := GTYP_BOOLGADGET
  g.gadgetrender := downGadgetRender1
  g.selectrender := downSelectRender1
  g.userdata := id
ENDPROC  g
  /* newDownButton */

PROC createGList ()
/*--------------------------------------*
  Create and link Scroll Button Gadgets.
 *--------------------------------------*/
  DEF g : PTR TO gadget
  g := newUpButton (154, 148, 15, 11, "UP")
  g.nextgadget := newDownButton (154, 159, 15, 11, "DOWN")
/*-------------------------*
  To add more to the list:
  g := g.nextgadget
  g.nextgadget := newGad () ...
 *-------------------------*/
ENDPROC  g
  /* createGList */

PROC main() HANDLE
  DEF w = NIL: PTR TO window,
      gadget : PTR TO gadget, gadgetId,
      idcmpClass, reqMessage
  IF (w := OpenW (0, 0, 300, 200,
                  IDCMP_CLOSEWINDOW+IDCMP_GADGETDOWN,
                  WFLG_CLOSEGADGET+WFLG_ACTIVATE+WFLG_SMART_REFRESH,
                  'Create Gadget Demo', NIL, WBENCHSCREEN,
                  createGList())) = NIL THEN Raise ("WIN")
  REPEAT
    idcmpClass := WaitIMessage (w)
    IF idcmpClass = IDCMP_GADGETDOWN
      gadget := MsgIaddr ()
      gadgetId := gadget.userdata
      SELECT gadgetId
        CASE "UP";   reqMessage := 'Up'
        CASE "DOWN"; reqMessage := 'Down'
        DEFAULT;     reqMessage := 'PANIC!'  /*-- Should never happen. --*/
      ENDSELECT
      EasyRequestArgs (0, [20,0,0,
                           'You pressed the \s Button???',
                           'Right!'], 0, [reqMessage])
    ENDIF
  UNTIL idcmpClass = IDCMP_CLOSEWINDOW
  CloseW (w)
  CleanUp (0)
EXCEPT
  IF w THEN Close (w)
  CleanUp (10)
ENDPROC
