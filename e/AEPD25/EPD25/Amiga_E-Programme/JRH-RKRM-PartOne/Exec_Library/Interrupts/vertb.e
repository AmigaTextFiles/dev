
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
          