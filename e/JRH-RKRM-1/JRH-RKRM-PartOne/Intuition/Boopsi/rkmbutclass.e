-> RKMButClass.e - Example Boopsi gadget for RKRM:Libraries

OPT PREPROCESS

MODULE 'utility',
       'amigalib/boopsi',
       'tools/installhook',
       'devices/inputevent',
       'graphics/rastport',
       'intuition/cghooks',
       'intuition/classes',
       'intuition/classusr',
       'intuition/gadgetclass',
       'intuition/icclass',
       'intuition/imageclass',
       'intuition/intuition',
       'intuition/screens',
       'utility/tagitem'

ENUM ERR_NONE, ERR_LIB, ERR_WIN

RAISE ERR_LIB IF OpenLibrary()=NIL,
      ERR_WIN IF OpenWindowTagList()=NIL

OBJECT butINST
  midX, midY  -> Coordinates of middle of gadget
ENDOBJECT

CONST RKMBUT_PULSE=TAG_USER+1,
      -> butINST has one flag:
      ERASE_ONLY=1, -> Tells rendering routine to only erase the gadget, not
                    -> rerender a new one.  This lets the gadget erase itself
                    -> before it rescales.
      INTWIDTH=40, INTHEIGHT=20

DEF w=NIL:PTR TO window, rkmbutcl=NIL,
    integer=NIL:PTR TO gadget, but=NIL:PTR TO gadget

-> The main() function connects an rkmButClass object to a Boopsi integer
-> gadget, which displays the rkmButClass gadget's RKMBUT_PULSE value.  The
-> code scales and move the gadget while it is in place.
PROC main() HANDLE
  utilitybase:=OpenLibrary('utility.library', 37)
  w:=OpenWindowTagList(NIL,
                      [WA_FLAGS,  WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR
                                      WFLG_CLOSEGADGET OR WFLG_SIZEGADGET,
                       WA_IDCMP,  IDCMP_CLOSEWINDOW,
                       WA_WIDTH,  640,
                       WA_HEIGHT, 200,
                       NIL])
  WindowLimits(w, 450, 200, 640, 200)
  IF rkmbutcl:=initRKMButGadClass()
    integer:=NewObjectA(NIL, 'strgclass',
                       [GA_ID,            1,
                        GA_TOP,           w.bordertop+5,
                        GA_LEFT,          w.borderleft+5,
                        GA_WIDTH,         INTWIDTH,
                        GA_HEIGHT,        INTHEIGHT,
                        STRINGA_LONGVAL,  0,
                        STRINGA_MAXCHARS, 5,
                        NIL])
    but:=NewObjectA(rkmbutcl, NIL,
                   [GA_ID,            2,
                    GA_TOP,           w.bordertop+5,
                    GA_LEFT,          integer.leftedge+integer.width+5,
                    GA_WIDTH,         INTWIDTH,
                    GA_HEIGHT,        INTHEIGHT,
                    GA_PREVIOUS,      integer,
                    ICA_MAP,         [RKMBUT_PULSE, STRINGA_LONGVAL, NIL],
                    ICA_TARGET,       integer,
                    NIL])

    AddGList(w, integer, -1, -1, NIL)
    RefreshGList(integer, w, NIL, -1)

    SetWindowTitles(w, '<-- Click to resize gadget Height', NIL)
    mainLoop(NIL, 0)

    SetWindowTitles(w, '<-- Click to resize gadget Width', NIL)
    mainLoop(GA_HEIGHT, 100)

    SetWindowTitles(w, '<-- Click to resize gadget Y position', NIL)
    mainLoop(GA_WIDTH, 100)

    SetWindowTitles(w, '<-- Click to resize gadget X position', NIL)
    mainLoop(GA_TOP, but.topedge+20)

    SetWindowTitles(w, '<-- Click to quit', NIL)
    mainLoop(GA_LEFT, but.leftedge+20)

    RemoveGList(w, integer, -1)
  ENDIF
EXCEPT DO
  IF but THEN DisposeObject(but)
  IF integer THEN DisposeObject(integer)
  IF rkmbutcl THEN freeRKMButGadClass(rkmbutcl)
  IF w THEN CloseWindow(w)
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_LIB; WriteF('Error: Could not open utility.library\n')
  CASE ERR_WIN; WriteF('Error: Could not open window\n')
  ENDSELECT
ENDPROC

PROC mainLoop(attr, value)
  SetGadgetAttrsA(but, w, NIL, [attr, value, NIL])
  REPEAT
  UNTIL WaitIMessage(w)=IDCMP_CLOSEWINDOW
ENDPROC

-> Make the class and set up the dispatcher's hook
PROC initRKMButGadClass()
  DEF cl:PTR TO iclass
  IF cl:=MakeClass(NIL, 'gadgetclass', NIL, SIZEOF butINST, 0)
    -> Initialise the dispatcher Hook.
    -> E-Note: use installhook to set up the hook
    installhook(cl.dispatcher, {dispatchRKMButGad})
  ENDIF
ENDPROC cl

-> Free the class
PROC freeRKMButGadClass(cl) IS FreeClass(cl)

-> The RKMBut class dispatcher
PROC dispatchRKMButGad(cl:PTR TO iclass, o, msg:PTR TO msg)
  DEF inst:PTR TO butINST, retval=FALSE, g:PTR TO gadget, gpi:PTR TO gpinput,
      ie:PTR TO inputevent, rp, x, y, w, h, tmp, gpmsg:gprender
  -> E-Note: installhook makes sure A4 is set-up properly
  tmp:=msg.methodid
  SELECT tmp
  CASE OM_NEW  -> First, pass up to superclass
    IF g:=doSuperMethodA(cl, o, msg)
      -> Initialise local instance data
      inst:=INST_DATA(cl, g)
      inst.midX:=g.leftedge+(g.width/2)
      inst.midY:=g.topedge+(g.height/2)
      retval:=g
    ENDIF
  CASE GM_HITTEST  -> Since this is a rectangular gadget this
                   -> method always returns GMR_GADGETHIT.
    retval:=GMR_GADGETHIT
  CASE GM_GOACTIVE
    inst:=INST_DATA(cl, o)

    -> Only become active if the GM_GOACTIVE was triggered by direct user input.
    IF msg::gpinput.ievent
      -> This gadget is now active, change visual state to selected and render.
      g:=o
      g.flags:=g.flags OR GFLG_SELECTED
      renderRKMBut(cl, o, msg)
      retval:=GMR_MEACTIVE
    ELSE
      -> The GM_GOACTIVE was not triggered by direct user input.
      retval:=GMR_NOREUSE
    ENDIF
  CASE GM_RENDER
    retval:=renderRKMBut(cl, o, msg)
  CASE GM_HANDLEINPUT
    -> While it is active, this gadget sends its superclass an OM_NOTIFY pulse
    -> for every IECLASS_TIMER event that goes by (about one every 10th of a
    -> second).  Any object that is connected to this gadget will get A LOT of
    -> OM_UPDATE messages.
    g:=o
    gpi:=msg
    ie:=gpi.ievent

    inst:=INST_DATA(cl, o)

    retval:=GMR_MEACTIVE

    IF ie.class=IECLASS_RAWMOUSE
      tmp:=ie.code
      SELECT tmp
      CASE SELECTUP
        -> The user let go of the gadget so return GMR_NOREUSE to deactivate
        -> and to tell Intuition not to reuse this Input Event as we have
        -> already processed it. If the user let go of the gadget while the
        -> mouse was over it, mask GMR_VERIFY into the return value so Intuition
        -> will send a Release Verify (GADGETUP).
        IF (gpi.mousex < g.leftedge) OR
           (gpi.mousex > (g.leftedge+g.width)) OR
           (gpi.mousey < g.topedge) OR
           (gpi.mousey > (g.topedge+g.height))
          retval:=GMR_NOREUSE OR GMR_VERIFY
        ELSE
          retval:=GMR_NOREUSE
        ENDIF

        -> Since the gadget is going inactive, send a final notification to
        -> the ICA_TARGET.
        notifyPulse(cl, o, 0, inst.midX, msg)
      CASE MENUDOWN
        -> The user hit the menu button. Go inactive and let Intuition reuse
        -> the menu button event so Intuition can pop up the menu bar.
        retval:=GMR_REUSE

        -> Since the gadget is going inactive, send a final notification to
        -> the ICA_TARGET.
        notifyPulse(cl, o, 0, inst.midX, msg)
      DEFAULT
        retval:=GMR_MEACTIVE
      ENDSELECT
    ELSEIF ie.class=IECLASS_TIMER
      -> If the gadget gets a timer event, it sends an interim OM_NOTIFY to
      -> its superclass.
      notifyPulse(cl, o, OPUF_INTERIM, inst.midX, gpi)
    ENDIF
  CASE GM_GOINACTIVE
    -> Intuition said to go inactive.  Clear the GFLG_SELECTED bit and render
    -> using unselected imagery.
    g:=o
    g.flags:=g.flags AND Not(GFLG_SELECTED)
    renderRKMBut(cl, o, msg)
  CASE OM_SET
    -> Although this class doesn't have settable attributes, this gadget class
    -> does have scaleable imagery, so it needs to find out when its size and/or
    -> position has changed so it can erase itself, THEN scale, and rerender.
    IF FindTagItem(GA_WIDTH,  msg::opset.attrlist) OR
       FindTagItem(GA_HEIGHT, msg::opset.attrlist) OR
       FindTagItem(GA_TOP,    msg::opset.attrlist) OR
       FindTagItem(GA_LEFT,   msg::opset.attrlist)
      g:=o

      x:=g.leftedge
      y:=g.topedge
      w:=g.width
      h:=g.height

      inst:=INST_DATA(cl, o)

      retval:=doSuperMethodA(cl, o, msg)

      -> Get pointer to RastPort for gadget.
      IF rp:=ObtainGIRPort(msg::opset.ginfo)
        SetAPen(rp, msg::opset.ginfo.drinfo.pens[BACKGROUNDPEN])
        SetDrMd(rp, RP_JAM1)  -> Erase the old gadget.
        RectFill(rp, x, y, x+w, y+h)
        inst.midX:=g.leftedge+(g.width/2)  -> Recalculate where the
        inst.midY:=g.topedge+(g.height/2)  -> center of the gadget is.

        -> Rerender the gadget.
        -> E-Note: Intuition may alter the message, so don't use a static list
        gpmsg.methodid:=GM_RENDER
        gpmsg.ginfo:=msg::opset.ginfo
        gpmsg.rport:=rp
        gpmsg.redraw:=GREDRAW_REDRAW
        doMethodA(o, gpmsg)
        ReleaseGIRPort(rp)
      ENDIF
    ELSE
      retval:=doSuperMethodA(cl, o, msg)
    ENDIF
  DEFAULT
    -> rkmmodelclass does not recognise the methodID, let the superclass's
    -> dispatcher take a look at it.
    retval:=doSuperMethodA(cl, o, msg)
  ENDSELECT
ENDPROC retval

-> Build an OM_NOTIFY message for RKMBUT_PULSE and send it to the superclass.
PROC notifyPulse(cl, o:PTR TO gadget, flags, mid, gpi:PTR TO gpinput)
  DEF msg:PTR TO opnotify  -> E-Note: "opnotify" is really "opupdate"
  -> If this is an OM_UPDATE method, make sure the part the OM_UPDATE message
  -> adds to the OM_SET message gets added.  That lets the dispatcher handle
  -> OM_UPDATE and OM_SET in the same case.
  msg:=[OM_NOTIFY, [RKMBUT_PULSE, mid-(gpi.mousex+o.leftedge),
                    GA_ID, o.gadgetid, NIL],
        gpi.ginfo, flags]:opnotify

  -> E-Note: A bug (?) in Intuition means that the methodid of an OM_NOTIFY
  ->         message may be altered, so you can't get away with just using a
  ->         constant value in the above static list...
  msg.methodid:=OM_NOTIFY

  doSuperMethodA(cl, o, msg)
ENDPROC

-> Erase and rerender the gadget.
PROC renderRKMBut(cl:PTR TO iclass, g:PTR TO gadget, msg:PTR TO gprender)
  DEF inst:PTR TO butINST, rp, retval=TRUE, pens:PTR TO INT,
      back, shine, shadow, w, h, x, y
  inst:=INST_DATA(cl, g)
  pens:=msg.ginfo.drinfo.pens

  IF msg.methodid=GM_RENDER
    -> If msg is truly a GM_RENDER message (not a gpinput that looks like a
    -> gprender), use the rastport within it...
    rp:=msg.rport
  ELSE  -> ...Otherwise, get a rastport using ObtainGIRPort().
    rp:=ObtainGIRPort(msg.ginfo)
  ENDIF

  IF rp
    IF g.flags AND GFLG_SELECTED
      -> If the gadget is selected, reverse the meanings of the pens.
      back:=pens[FILLPEN]
      shine:=pens[SHADOWPEN]
      shadow:=pens[SHINEPEN]
    ELSE
      back:=pens[BACKGROUNDPEN]
      shine:=pens[SHINEPEN]
      shadow:=pens[SHADOWPEN]
    ENDIF
    SetDrMd(rp, RP_JAM1)

    SetAPen(rp, back)  -> Erase the old gadget.
    RectFill(rp, g.leftedge,         g.topedge,
                 g.leftedge+g.width, g.topedge+g.height)

    SetAPen(rp, shadow)  -> Draw shadow edge.
    Move(rp, g.leftedge+1, g.topedge+g.height)
    Draw(rp, g.leftedge+g.width, g.topedge+g.height)
    Draw(rp, g.leftedge+g.width, g.topedge+1)

    w:=g.width/4   -> Draw Arrows - Sorry, no frills imagery
    h:=g.height/2
    x:=g.leftedge+(w/2)
    y:=g.topedge+(h/2)

    Move(rp, x, inst.midY)
    Draw(rp, x+w, y)
    Draw(rp, x+w, y+g.height-h)
    Draw(rp, x, inst.midY)

    x:=g.leftedge+(w/2)+(g.width/2)

    Move(rp, x+w, inst.midY)
    Draw(rp, x, y)
    Draw(rp, x, y+g.height-h)
    Draw(rp, x+w, inst.midY)

    SetAPen(rp, shine)  -> Draw shine edge.
    Move(rp, g.leftedge, g.topedge+g.height-1)
    Draw(rp, g.leftedge, g.topedge)
    Draw(rp, g.leftedge+g.width-1, g.topedge)

    IF msg.methodid<>GM_RENDER  -> If we allocated a rastport, give it back.
      ReleaseGIRPort(rp)
    ENDIF
  ELSE
    retval:=FALSE
  ENDIF
ENDPROC retval

vers: CHAR 0, '$VER: TestBut 37.1', 0
