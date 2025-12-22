-> showprefs.e - Parse and show some info from an IFF Preferences file
-> E-Note: ignore the rubbish (in the C version) about startup code

MODULE 'iffparse',
       'devices/timer',
       'dos/dos',
       'graphics/text',
       'libraries/iffparse',
       'prefs/font',
       'prefs/icontrol',
       'prefs/input',
       'prefs/overscan',
       'prefs/printergfx',
       'prefs/printertxt',
       'prefs/prefhdr',
       'prefs/screenmode',
       'prefs/serial'

ENUM ERR_NONE, ERR_IFF, ERR_LIB, ERR_OPEN, ERR_RDARGS, TOTAL_ERRS

-> E-Note: the use of exceptions is carefully balanced
RAISE ERR_IFF    IF AllocIFF()=NIL,
      ERR_LIB    IF OpenLibrary()=NIL,
      ERR_OPEN   IF Open()=NIL,
      ERR_RDARGS IF ReadArgs()=NIL

PROC main() HANDLE
  DEF readargs=NIL, rargs[2]:ARRAY OF LONG, iffhandle=NIL:PTR TO iffhandle,
      filename=NIL, error, rc=RETURN_OK, iffErrTxt:PTR TO LONG

  iffparsebase:=OpenLibrary('iffparse.library', 37)

  readargs:=ReadArgs('FILE/A', rargs, NIL)
  IF filename:=rargs[0]
    -> Allocate an IFF handle
    iffhandle:=AllocIFF()
    -> Open the file for reading
    iffhandle.stream:=Open(filename, OLDFILE)
    -> Initialise the iff handle
    InitIFFasDOS(iffhandle)
    IF (error:=OpenIFF(iffhandle, IFFF_READ))=0
      PropChunk(iffhandle, ID_PREF, ID_PRHD)

      PropChunk(iffhandle, ID_PREF, ID_FONT)
      PropChunk(iffhandle, ID_PREF, ID_ICTL)
      PropChunk(iffhandle, ID_PREF, ID_INPT)
      PropChunk(iffhandle, ID_PREF, ID_OSCN)
      PropChunk(iffhandle, ID_PREF, ID_PGFX)
      PropChunk(iffhandle, ID_PREF, ID_PTXT)
      PropChunk(iffhandle, ID_PREF, ID_SCRM)
      PropChunk(iffhandle, ID_PREF, ID_SERL)

      -> E-Note: handle the funny loop more cleanly using a separate procedure
      REPEAT
      UNTIL error:=parse(iffhandle)
    ENDIF
    CloseIFF(iffhandle)
    IF error<>IFFERR_EOF
      iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
                  'stream read error','stream write error','stream seek error',
                  'file corrupt', 'IFF syntax error', 'not an IFF file',
                  'required call-back hook missing', NIL]
      WriteF('\s: \s\n', rargs[], iffErrTxt[-error-1])
      rc:=RETURN_FAIL
    ENDIF
  ENDIF
EXCEPT DO
  SELECT TOTAL_ERRS OF exception
  CASE ERR_OPEN, ERR_RDARGS
    error:=IoErr()
    SetIoErr(error)
    IF error
      rc:=RETURN_FAIL
      PrintFault(error, IF filename THEN filename ELSE '')
    ENDIF
  CASE ERR_IFF; WriteF('Can''t allocate IFF handle\n')
  CASE ERR_LIB; WriteF('Can''t open iffparse.library\n')
  ENDSELECT
  IF iffhandle THEN FreeIFF(iffhandle)
  IF readargs THEN FreeArgs(readargs)
  IF iffparsebase THEN CloseLibrary(iffparsebase)
ENDPROC rc

-> E-Note: handle the funny loop more cleanly using a separate procedure
PROC parse(iffhandle)
  DEF ifferror, sp:PTR TO storedproperty, hdrsp, cnode:PTR TO contextnode
  IF ifferror:=ParseIFF(iffhandle, IFFPARSE_STEP)
    RETURN IF ifferror=IFFERR_EOC THEN 0 ELSE ifferror
  ENDIF

  -> Do nothing if this is a PrefHeader chunk; we'll pop it later when there
  -> is a pref chunk.
  IF cnode:=CurrentChunk(iffhandle)
    IF (cnode.id=ID_PRHD) OR (cnode.id=ID_FORM) THEN RETURN 0
  ENDIF

  -> Get the preferences header, stored previously
  hdrsp:=FindProp(iffhandle, ID_PREF, ID_PRHD)

  IF sp:=FindProp(iffhandle, ID_PREF, ID_FONT)
    WriteF('FrontPen:  \d\n', sp.data::fontprefs.frontpen)
    WriteF('BackPen:   \d\n', sp.data::fontprefs.backpen)
    WriteF('Font:      \s\n', sp.data::fontprefs.name)
    WriteF('YSize:     \d\n', sp.data::fontprefs.textattr.ysize)
    WriteF('Style:     \d\n', sp.data::fontprefs.textattr.style)
    WriteF('Flags:     \d\n', sp.data::fontprefs.textattr.flags)
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_ICTL)
    WriteF('TimeOut:   \d\n', sp.data::icontrolprefs.timeout)
    WriteF('MetaDrag:  \d\n', sp.data::icontrolprefs.metadrag)
    WriteF('WBtoFront: \d\n', sp.data::icontrolprefs.wbtofront)
    WriteF('FrontToBack: \d\n', sp.data::icontrolprefs.fronttoback)
    WriteF('ReqTrue:   \d\n', sp.data::icontrolprefs.reqtrue)
    WriteF('ReqFalse:  \d\n', sp.data::icontrolprefs.reqfalse)
    -> Etc.
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_INPT)
    WriteF('PointerTicks:      \d\n', sp.data::inputprefs.pointerticks)
    WriteF('DoubleClick/Secs:  \d\n', sp.data::inputprefs.doubleclick.secs)
    WriteF('DoubleClick/Micro: \d\n', sp.data::inputprefs.doubleclick.micro)
    -> Etc.
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_OSCN)
    WriteF('DisplayID: $\h\n', sp.data::overscanprefs.displayid)
    -> Etc.
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_PGFX)
    WriteF('Aspect:    \d\n', sp.data::printergfxprefs.aspect)
    -> Etc.
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_PTXT)
    WriteF('Driver:    \s\n', sp.data::printertxtprefs.driver)
    -> Etc.
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_SCRM)
    WriteF('DisplayID: $\h\n', sp.data::screenmodeprefs.displayid)
    -> Etc.
  ELSEIF sp:=FindProp(iffhandle, ID_PREF, ID_SERL)
    WriteF('BaudRate:  \d\n', sp.data::serialprefs.baudrate)
    -> Etc.
  ENDIF
  RETURN 0
ENDPROC
