OPT OSVERSION=37

MODULE '*rkmmodel',
       'amigalib/boopsi',
       'utility',
       'intuition/classusr',
       'intuition/gadgetclass',
       'intuition/icclass',
       'intuition/imageclass',
       'intuition/intuition'

ENUM ERR_NONE, ERR_DRAW, ERR_LIB, ERR_OBJ, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_OBJ  IF NewObjectA()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST PROPID=1, INTEGERID=2, RIGHTID=3, LEFTID=4, PROPWIDTH=80, PROPHEIGHT=10,
      INTWIDTH=50, INTHEIGHT=14, VISIBLE=10, TOTAL=100, INITIALVAL=25
CONST MINWINDOWWIDTH=80, MINWINDOWHEIGHT=PROPHEIGHT+70, MAXCHARS=4

DEF w=NIL:PTR TO window, mydrawinfo=NIL, rkmmodcl=NIL,
    rkmmodel=NIL, currval2int=NIL, currval2prop=NIL,
    prop=NIL:PTR TO gadget, integer=NIL:PTR TO gadget,
    leftbut=NIL:PTR TO gadget, rightbut=NIL:PTR TO gadget,
    rightimage=NIL, leftimage=NIL

PROC main() HANDLE
  DEF qwe
  utilitybase:=OpenLibrary('utility.library', 37)
  w:=OpenWindowTagList(NIL,
                      [WA_FLAGS, WFLG_DEPTHGADGET OR WFLG_DRAGBAR OR
                                     WFLG_CLOSEGADGET OR WFLG_SIZEGADGET,
                       WA_IDCMP, IDCMP_CLOSEWINDOW,
                       NIL])
  -> E-Note: we could have made initRKMModClass raise an exception
  IF rkmmodcl:=initRKMModClass()
    mydrawinfo:=GetScreenDrawInfo(w.wscreen)
    makeGadgetsAndRKMModel()
    doMethodA(rkmmodel, [OM_ADDMEMBER, currval2prop])
    currval2prop:=NIL  -> E-Note: this is now part of the rkmmodel object
    doMethodA(rkmmodel, [OM_ADDMEMBER, currval2int])
    currval2int:=NIL   -> E-Note: again, now part of the rkmmodel object
    WindowLimits(w,
                 w.borderleft+w.borderright+integer.leftedge+integer.width+10,
                 w.bordertop+w.borderbottom+prop.height+10,
                 w.maxwidth,
                 w.maxheight)
    AddGList(w, prop, -1, -1, NIL)
    RefreshGadgets(prop, w, NIL)

    GetAttr(RKMMOD_CURRVAL, rkmmodel, {qwe})
    WriteF('RKMMOD_CURRVAL = \d\n', qwe)
    Delay(200)

    IF SetAttrsA(rkmmodel, [RKMMOD_CURRVAL, 10, NIL])
      RefreshGadgets(prop, w, NIL)
    ENDIF
    GetAttr(RKMMOD_CURRVAL, rkmmodel, {qwe})
    WriteF('RKMMOD_CURRVAL = \d\n', qwe)
    Delay(200)

    IF SetAttrsA(rkmmodel, [RKMMOD_CURRVAL, 30, NIL])
      RefreshGadgets(prop, w, NIL)
    ENDIF
    GetAttr(RKMMOD_CURRVAL, rkmmodel, {qwe})
    WriteF('RKMMOD_CURRVAL = \d\n', qwe)
    Delay(200)

    IF SetAttrsA(rkmmodel, [RKMMOD_CURRVAL, 50, NIL])
      RefreshGadgets(prop, w, NIL)
    ENDIF
    GetAttr(RKMMOD_CURRVAL, rkmmodel, {qwe})
    WriteF('RKMMOD_CURRVAL = \d\n', qwe)
    Delay(200)

    IF SetAttrsA(rkmmodel, [RKMMOD_UP, 1, NIL])
      RefreshGadgets(prop, w, NIL)
    ENDIF

    -> Wait for the user to click window close gadget
    REPEAT
    UNTIL WaitIMessage(w)=IDCMP_CLOSEWINDOW
    RemoveGList(w, prop, -1)
  ENDIF

EXCEPT DO
  IF currval2int  THEN DisposeObject(currval2int)
  IF currval2prop THEN DisposeObject(currval2prop)
  IF rightbut     THEN DisposeObject(rightbut)
  IF leftbut      THEN DisposeObject(leftbut)
  IF integer      THEN DisposeObject(integer)
  IF prop         THEN DisposeObject(prop)
  IF rkmmodel     THEN DisposeObject(rkmmodel)
  IF leftimage    THEN DisposeObject(leftimage)
  IF rightimage   THEN DisposeObject(rightimage)

  IF mydrawinfo THEN FreeScreenDrawInfo(w.wscreen, mydrawinfo)
  IF rkmmodcl THEN freeRKMModClass(rkmmodcl)
  IF w THEN CloseWindow(w)
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_DRAW; WriteF('Error: Failed to get screen DrawInfo\n')
  CASE ERR_LIB;  WriteF('Error: Failed to open utility library\n')
  CASE ERR_OBJ;  WriteF('Error: Failed to make new Object\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  ENDSELECT
ENDPROC

PROC makeGadgetsAndRKMModel() HANDLE
  rightimage:=NewObjectA(NIL, 'sysiclass',
                        [SYSIA_WHICH, RIGHTIMAGE,
                         SYSIA_DRAWINFO, mydrawinfo, NIL])
  leftimage:=NewObjectA(NIL, 'sysiclass',
                       [SYSIA_WHICH, LEFTIMAGE,
                        SYSIA_DRAWINFO, mydrawinfo, NIL])
  rkmmodel:=NewObjectA(rkmmodcl, NIL,
                      [RKMMOD_CURRVAL, INITIALVAL,
                       RKMMOD_LIMIT, TOTAL-VISIBLE, NIL])
  prop:=NewObjectA(NIL, 'propgclass',
                  [GA_ID,       PROPID,
                   GA_TOP,      w.bordertop+5,
                   GA_LEFT,     w.borderleft+5,
                   GA_WIDTH,    PROPWIDTH,
                   GA_HEIGHT,   PROPHEIGHT,
                   ICA_MAP,    [PGA_TOP, RKMMOD_CURRVAL,
                                STRINGA_LONGVAL, RKMMOD_CURRVAL,
                                NIL],
                   ICA_TARGET,  rkmmodel,
                   PGA_FREEDOM, FREEHORIZ,
                   PGA_TOTAL,   TOTAL,
                   PGA_TOP,     INITIALVAL,
                   PGA_VISIBLE, VISIBLE,
                   PGA_NEWLOOK, TRUE,
                   NIL])
  integer:=NewObjectA(NIL, 'strgclass',
                     [GA_ID,       INTEGERID,
                      GA_TOP,      w.bordertop+5,
                      GA_LEFT,     prop.leftedge+prop.width+48,
                      GA_WIDTH,    INTWIDTH,
                      GA_HEIGHT,   INTHEIGHT,
                      ICA_MAP,    [PGA_TOP, RKMMOD_CURRVAL,
                                   STRINGA_LONGVAL, RKMMOD_CURRVAL,
                                   NIL],
                      ICA_TARGET,  rkmmodel,
                      GA_PREVIOUS, prop,
                      STRINGA_LONGVAL,  INITIALVAL,
                      STRINGA_MAXCHARS, MAXCHARS,
                      NIL])
  leftbut:=NewObjectA(NIL, 'buttongclass',
                     [GA_ID,       LEFTID,
                      GA_IMAGE,    leftimage,
                      GA_TOP,      w.bordertop+5,
                      GA_LEFT,     prop.leftedge+prop.width,
                      ICA_MAP,    [GA_ID, RKMMOD_DOWN, NIL],
                      ICA_TARGET,  rkmmodel,
                      GA_PREVIOUS, integer,
                      NIL])
  rightbut:=NewObjectA(NIL, 'buttongclass',
                      [GA_ID,       RIGHTID,
                       GA_IMAGE,    rightimage,
                       GA_TOP,      w.bordertop+5,
                       GA_LEFT,     prop.leftedge+prop.width+leftbut.width,
                       ICA_MAP,    [GA_ID, RKMMOD_UP, NIL],
                       ICA_TARGET,  rkmmodel,
                       GA_PREVIOUS, leftbut,
                       NIL])
  currval2prop:=NewObjectA(NIL, 'icclass',
                          [ICA_MAP,    [RKMMOD_CURRVAL, PGA_TOP, NIL],
                           ICA_TARGET,  prop,
                           NIL])
  currval2int:=NewObjectA(NIL, 'icclass',
                         [ICA_MAP,    [RKMMOD_CURRVAL, STRINGA_LONGVAL, NIL],
                          ICA_TARGET,  integer,
                          NIL])
  RETURN TRUE
EXCEPT
  ReThrow()  -> E-Note: pass on exception if it is an error
ENDPROC

vers: CHAR 0, '$VER: UseRKMModel 37.1', 0
