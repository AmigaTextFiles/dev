OPT MODULE, REG = 5

MODULE  'workbench/workbench',
        'icon',
        'intuition/intuition'

CONST MAX_GADS = 50,
      MAX_BUFF = 300

OBJECT icongad PRIVATE
  diskobj:PTR TO diskobject -> Icon
  gad:PTR TO gadget         -> Gadget
  displayed                 -> Whether this icon is currently displayed
ENDOBJECT

EXPORT OBJECT icongads PRIVATE
  gads[MAX_GADS]:ARRAY OF icongad
ENDOBJECT

PROC initicongad(iconlist:PTR TO LONG) OF icongads
  DEF myiconstr[MAX_BUFF]:STRING
  DEF a, iconinfolen
  DEF thisdiskobj:PTR TO diskobject

  IF (iconbase := OpenLibrary('icon.library', 0)) = NIL THEN Throw("LIB", 'icon.library')

  FOR a := 0 TO (ListLen(iconlist) - 1)
    -> Strip .info
    StrCopy(myiconstr, iconlist[a])
    iconinfolen := EstrLen(myiconstr) - 5
    IF InStr(myiconstr, '.info') = iconinfolen THEN SetStr(myiconstr, iconinfolen)

    self.gads[a].diskobj := GetDiskObject(myiconstr)
    IF self.gads[a].diskobj = NIL
      self.gads[a].diskobj := GetDefDiskObject(WBTOOL)
    ENDIF

    thisdiskobj := self.gads[a].diskobj

    self.gads[a].gad := NEW [NIL, 0, 0, thisdiskobj.gadget.width,
                                        thisdiskobj.gadget.height,
                                        thisdiskobj.gadget.flags, GACT_RELVERIFY,
                                        thisdiskobj.gadget.gadgettype,
                                        thisdiskobj.gadget.gadgetrender,
                                        thisdiskobj.gadget.selectrender,
                                        NIL, 0, NIL, 0, NIL]:gadget
    self.gads[a].displayed := FALSE
  ENDFOR
ENDPROC

PROC endicongad() OF icongads
  DEF a, thisgad:PTR TO gadget

  FOR a := 0 TO (MAX_GADS - 1)
    EXIT (self.gads[a].diskobj = NIL)
    IF self.gads[a].diskobj THEN FreeDiskObject(self.gads[a].diskobj)
    IF self.gads[a].gad
      thisgad := self.gads[a].gad
      END thisgad
    ENDIF
  ENDFOR

  IF iconbase THEN CloseLibrary(iconbase)
ENDPROC

PROC sizex(gadnum) OF icongads
  IF (gadnum < 0) OR (gadnum >= MAX_GADS) THEN RETURN
  IF self.gads[gadnum].gad THEN RETURN self.gads[gadnum].gad.width
ENDPROC

PROC sizey(gadnum) OF icongads
  IF (gadnum < 0) OR (gadnum >= MAX_GADS) THEN RETURN
  IF self.gads[gadnum].gad THEN RETURN (self.gads[gadnum].gad.height - 1)
ENDPROC

PROC addicongad(gadnum, id, x, y, win:PTR TO window) OF icongads
  DEF thisgad:PTR TO gadget
  IF (win = NIL) OR (gadnum < 0) OR (gadnum >= MAX_GADS) THEN RETURN

  IF self.gads[gadnum].gad
    IF self.gads[gadnum].displayed = FALSE
      thisgad := self.gads[gadnum].gad
      thisgad.leftedge := x
      thisgad.topedge  := y
      thisgad.gadgetid := id
      AddGadget(win, thisgad, NIL)
      RefreshGList(thisgad, win, NIL, 1)

      self.gads[gadnum].displayed := TRUE
    ENDIF
  ENDIF
ENDPROC

PROC removeicongad(gadnum, win:PTR TO window) OF icongads
  IF (win = NIL) OR (gadnum < 0) OR (gadnum >= MAX_GADS) THEN RETURN

  IF self.gads[gadnum].gad
    IF self.gads[gadnum].displayed = TRUE
      RemoveGadget(win, self.gads[gadnum].gad)

      self.gads[gadnum].displayed := FALSE
    ENDIF
  ENDIF
ENDPROC
