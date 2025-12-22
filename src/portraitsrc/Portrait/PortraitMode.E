MODULE 'asl', 'libraries/asl', 'iffparse', 'libraries/iffparse', 'dos/dos',
       'prefs/prefhdr', 'graphics/modeid'
CONST ID_PORT="PORT"
ENUM ERR_LIB=1, ERR_IFF, ERR_OPEN
OBJECT prefs
  displayid:LONG
  displaydepth:INT
  grayscale:CHAR
ENDOBJECT
DEF prefs=NIL:PTR TO prefs, length=0
PROC main()
  DEF smr:PTR TO screenmoderequester
  IF KickVersion(37)=FALSE
    WriteF('PortraitMode requires Kickstart V37+\n')
    CleanUp(20)
  ENDIF
  IF KickVersion(39)=FALSE
    request('Portrait requires Kickstart V39+','Exit', NIL)
    CleanUp(20)
  ENDIF
  IF getprefs()=FALSE
    IF prefs=NIL
      prefs:=New(SIZEOF prefs)
      prefs.displayid:=PAL_MONITOR_ID OR HIRES_KEY
      prefs.displaydepth:=8
      prefs.grayscale:=0
      length:=SIZEOF prefs
    ENDIF
    IF aslbase:=OpenLibrary('asl.library', 39)
      IF smr:=AllocAslRequest(ASL_SCREENMODEREQUEST,[ASLSM_INITIALDISPLAYID, prefs.displayid,
                                                     ASLSM_INITIALDISPLAYDEPTH, prefs.displaydepth,
                                                     ASLSM_DODEPTH,TRUE,
                                                     ASLSM_MINDEPTH,8,
                                                     ASLSM_MINWIDTH,640,
                                                     ASLSM_MINHEIGHT,256,
                                                     ASLSM_MAXDEPTH,8,
                                                     NIL])
        IF AslRequest(smr,NIL)
          prefs.displayid:=smr.displayid
          prefs.displaydepth:=smr.displaydepth
        ENDIF
        FreeAslRequest(smr)
      ELSE
        request('Couldn''t allocate ASL screenmode requester','Exit',NIL)
      ENDIF
      CloseLibrary(aslbase)
    ELSE
      request('Couldn''t open asl.library','Exit',NIL)
    ENDIF
    IF prefs.displayid<8 THEN prefs.grayscale:=1
    writeprefs()
  ENDIF
ENDPROC
PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,0,body,gadgets],0,args)
PROC getprefs() HANDLE
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror=NIL,
      iffErrTxt:PTR TO LONG, error=FALSE,cn:PTR TO contextnode
  IF (iffparsebase:=OpenLibrary('iffparse.library', 39))=NIL THEN Raise(ERR_LIB)
  iffhandle:=AllocIFF()
  IF iffhandle=NIL THEN Raise(ERR_IFF)
  iffhandle.stream:=Open('PROGDIR:Portrait.prefs', MODE_OLDFILE)
  IF iffhandle.stream=NIL THEN Raise(ERR_OPEN)
  InitIFFasDOS(iffhandle)
  IF (ifferror:=OpenIFF(iffhandle, IFFF_READ))=NIL
    WHILE (ifferror=NIL)
      IF ifferror:=ParseIFF(iffhandle, IFFPARSE_STEP)
        IF ifferror=IFFERR_EOC THEN ifferror:=NIL
      ELSE
        IF cn:=CurrentChunk(iffhandle)
          IF (cn.type=ID_PREF) AND (cn.id=ID_PORT)
            IF prefs:=New(cn.size)
              ReadChunkBytes(iffhandle, prefs, cn.size)
              length:=cn.size
            ELSE
              request('Out of memory','Error',NIL)
              error:=TRUE
            ENDIF
          ENDIF
        ENDIF
      ENDIF
    ENDWHILE
    CloseIFF(iffhandle)
  ENDIF
  IF ifferror<>IFFERR_EOF
    iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
                'stream read error','stream write error','stream seek error',
                'file corrupt', 'IFF syntax error', 'not an IFF file',
                'required call-back hook missing', NIL]
     request('IFF error:\n\s','Exit',[iffErrTxt[-ifferror-1]])
    error:=TRUE
  ENDIF
EXCEPT DO
  SELECT exception
  CASE ERR_IFF
    request('Couldn''t allocate IFF handle','Exit',NIL)
    error:=TRUE
  CASE ERR_LIB
    request('Couldn''t open iffparse.library','Exit',NIL)
    error:=TRUE
  ENDSELECT
  IF iffhandle
    IF iffhandle.stream THEN Close(iffhandle.stream)
    FreeIFF(iffhandle)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
ENDPROC error
PROC writeprefs() HANDLE
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror,
      iffErrTxt:PTR TO LONG,error=FALSE
  IF (iffparsebase:=OpenLibrary('iffparse.library', 39))=NIL THEN Raise(ERR_LIB)
  iffhandle:=AllocIFF()
  IF iffhandle=NIL THEN Raise(ERR_IFF)
  iffhandle.stream:=Open('PROGDIR:Portrait.prefs', MODE_NEWFILE)
  IF iffhandle.stream=NIL THEN Raise(ERR_OPEN)
  InitIFFasDOS(iffhandle)
  IF (ifferror:=OpenIFF(iffhandle, IFFF_WRITE))=NIL
    IF (ifferror:=PushChunk(iffhandle, ID_PREF, ID_FORM, IFFSIZE_UNKNOWN))=NIL
      IF (ifferror:=PushChunk(iffhandle, NIL, ID_PORT, IFFSIZE_UNKNOWN))=NIL
        IF WriteChunkBytes(iffhandle, prefs, length)<>length
          ifferror:=IFFERR_WRITE
        ENDIF
        PopChunk(iffhandle)
      ENDIF
      PopChunk(iffhandle)
    ENDIF
    IF ifferror
      iffErrTxt:=['EOF', 'EOC', 'no lexical scope', 'insufficient memory',
               'stream read error','stream write error','stream seek error',
               'file corrupt', 'IFF syntax error', 'not an IFF file',
               'required call-back hook missing', NIL]
       request('IFF error:\n\s','Exit',[iffErrTxt[-ifferror-1]])
       error:=TRUE
    ENDIF
    CloseIFF(iffhandle)
  ENDIF
EXCEPT DO
  SELECT exception
  CASE ERR_OPEN
    request('Couldn''t open file PROGDIR:Portrait.prefs','Exit',NIL)
    error:=TRUE
  CASE ERR_IFF
    request('Couldn''t allocate IFF handle','Exit',NIL)
    error:=TRUE
  CASE ERR_LIB
    request('Couldn''t open iffparse.library','Exit',NIL)
    error:=TRUE
  ENDSELECT
  IF iffhandle
    IF iffhandle.stream THEN Close(iffhandle.stream)
    FreeIFF(iffhandle)
  ENDIF
  IF iffparsebase THEN CloseLibrary(iffparsebase)
ENDPROC error
