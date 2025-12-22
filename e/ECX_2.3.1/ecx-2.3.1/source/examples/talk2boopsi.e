
OPT OSVERSION=37

MODULE 'intuition/gadgetclass',
       'intuition/icclass',
       'intuition/intuition'

ENUM ERR_NONE, ERR_OBJ, ERR_WIN

RAISE ERR_OBJ IF NewObjectA()=NIL,
      ERR_WIN IF OpenWindowTagList()=NIL

CONST PROPGADGET_ID=1, INTGADGET_ID=2,
      PROPGADGETWIDTH=10, PROPGADGETHEIGHT=80, INTGADGETHEIGHT=18,
      VISIBLE=10, TOTAL=100, INITIALVAL=25, MINWINDOWWIDTH=80
CONST MINWINDOWHEIGHT=PROPGADGETHEIGHT+70, MAXCHARS=3

PROC main() HANDLE
  DEF w=NIL:PTR TO window, prop=NIL, integer=NIL

  -> Open the window--notice that the window's IDCMP port
  -> does not listen for GADGETUP messages.
  w:=OpenWindowTagList(NIL,
                      [WA_FLAGS,     WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR
                                         WFLG_CLOSEGADGET OR WFLG_SIZEGADGET,
                       WA_IDCMP,     IDCMP_CLOSEWINDOW,
                       WA_MINWIDTH,  MINWINDOWWIDTH,
                       WA_MINHEIGHT, MINWINDOWHEIGHT,
                       NIL
                       ])


  -> Create a new propgclass object
  prop:=NewObjectA(NIL, 'propgclass',
          [GA_ID,     PROPGADGET_ID,  -> These are defined by gadgetclass and
           GA_TOP,    w.bordertop+5,  -> correspond to similarly named fields
           GA_LEFT,   w.borderleft+5, -> in the Gadget structure.
           GA_WIDTH,  PROPGADGETWIDTH,
           GA_HEIGHT, PROPGADGETHEIGHT,
           -> This tells the prop gadget to map its PGA_Top attribute to
           -> STRINGA_LONGVAL when it issues an update about the change to
           -> its PGA_Top value.
           ICA_MAP,   [PGA_TOP, STRINGA_LONGVAL, NIL],
           -> The rest of this gadget's attributes are defined by propgclass.
           PGA_TOTAL,   TOTAL,      -> The integer range of the prop gadget.
           PGA_TOP,     INITIALVAL, -> The initial value of the prop gadget.
           PGA_VISIBLE, VISIBLE, -> This determines how much of the prop gadget
                                 -> area is covered by the prop gadget's knob,
                                 -> or how much of the gadget's TOTAL range is
                                 -> taken up by the prop gadget's knob.
           PGA_NEWLOOK, TRUE,    -> Use new-look prop gadget imagery
           NIL])

  -> Create the integer string gadget
  integer:=NewObjectA(NIL, 'strgclass',
             [GA_ID,      INTGADGET_ID,  -> Parameters for the Gadget structure
              GA_TOP,     w.bordertop+5,
              GA_LEFT,    w.borderleft+PROPGADGETWIDTH+10,
              GA_WIDTH,   (MINWINDOWWIDTH-
                            (w.borderleft+w.borderright+PROPGADGETWIDTH+15)),
              GA_HEIGHT,  INTGADGETHEIGHT,
              -> This tells the string gadget to map its STRINGA_LONGVAL
              -> attribute to PGA_TOP when it issues an update.
              ICA_MAP,    [STRINGA_LONGVAL, PGA_TOP, NIL],
              ICA_TARGET, prop,
              -> The GA_PREVIOUS attribute is defined by gadgetclass and is used
              -> to wedge a new gadget into a list of gadget's linked by their
              -> gadget.nextgadget field.  When NewObject() creates this gadget,
              -> it inserts the new gadget into this list behind the GA_PREVIOUS
              -> gadget.  This attribute is a pointer to the previous gadget.
              -> This attribute cannot be used to link new gadgets into the
              -> gadget list of an open window or requester, use
              -> AddGList() instead.
              GA_PREVIOUS, prop,
              -> These attributes are defined by strgclass.  The first contains
              -> the value of the integer string gadget.  The second is the
              -> maximum number of characters the user is allowed to type into
              -> the gadget.
              STRINGA_LONGVAL,  INITIALVAL,
              STRINGA_MAXCHARS, MAXCHARS,
              NIL])


  -> Because the integer string gadget did not exist when this example created
  -> the prop gadget, it had to wait to set the ICA_Target of the prop gadget.
  SetGadgetAttrsA(prop, w, NIL, [ICA_TARGET, integer, NIL])

  AddGList(w,prop,-1,-1,NIL) -> Add the gadgets to the window and display them.
  RefreshGList(prop, w, NIL, -1)

  REPEAT  -> Wait for the user to click the window close gadget.
  UNTIL WaitIMessage(w)=IDCMP_CLOSEWINDOW

  RemoveGList(w, prop, -1)

EXCEPT DO
  IF integer THEN DisposeObject(integer)
  IF prop THEN DisposeObject(prop)
  IF w THEN CloseWindow(w)
  SELECT exception
  CASE ERR_OBJ; WriteF('Error: Failed to create new Object\n')
  CASE ERR_WIN; WriteF('Error: Failed to open window\n')
  ENDSELECT

ENDPROC

vers: CHAR  0, '$VER: Talk2boopsi 37.1', 0