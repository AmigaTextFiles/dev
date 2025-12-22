-> filepat.e

MODULE 'asl',
       'intuition/intuition',
       'intuition/screens',
       'graphics/modeid',
       'libraries/asl',
       'workbench/startup'

ENUM ERR_NONE, ERR_ASL, ERR_KICK, ERR_LIB, ERR_SCRN, ERR_WIN

RAISE ERR_ASL  IF AllocAslRequest()=NIL,
      ERR_KICK IF KickVersion()=FALSE,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_SCRN IF OpenScreenTagList()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

DEF screen=NIL, window=NIL

PROC main() HANDLE
  DEF fr=NIL:PTR TO filerequester, frargs:PTR TO wbarg, x
  KickVersion(37)  -> E-Note: requires V37
  aslbase:=OpenLibrary('asl.library',37)
  screen:=OpenScreenTagList(NIL, [SA_DISPLAYID, HIRESLACE_KEY,
                                  SA_TITLE, 'ASL Test Screen',
                                  NIL])
  window:=OpenWindowTagList(NIL,
                   [WA_CUSTOMSCREEN, screen,
                    WA_TITLE, 'Demo Customscreen, File Pattern, Multi-select',
                    -> E-Note: C version uses obsolete tags
                    WA_FLAGS, WFLG_DEPTHGADGET OR WFLG_DRAGBAR,
                    NIL])
  fr:=AllocAslRequest(ASL_FILEREQUEST,
                     [ASL_HAIL, 'FilePat/MultiSelect Demo',
                      ASL_DIR,  'libs:',
                      ASL_FILE, 'asl.library',

                      -> Initial pattern string for pattern matching
                      ASL_PATTERN, '~(rexx#?|math#?)',

                      -> Enable multiselection and pattern match gadget
                      ASL_FUNCFLAGS, FILF_MULTISELECT OR FILF_PATGAD,

                      -> This requester comes up on the screen of this window
                      -> (and uses window's message port, if any).
                      ASL_WINDOW, window,
                      NIL])

  -> Put up file requester
  IF AslRequest(fr, 0)
    -> If the file requester's numargs field is not zero, the user
    -> multiselected.  The number of files is stored in numargs.
    IF fr.numargs
      -> arglist is an array of wbarg objects (see 'workbench/startup.m').
      -> Each entry in this array corresponds to one of the files the user
      -> selected (in alphabetical order).
      frargs:=fr.arglist

      -> The user multiselected, step through the list of selected files.
      FOR x:=0 TO fr.numargs-1
        WriteF('Argument \d: PATH=\s FILE=\s\n', x, fr.drawer, frargs[x].name)
      ENDFOR
    ELSE
      -> The user didn't multiselect, use the normal way to get the file name.
      WriteF('PATH=\s FILE=\s\n', fr.drawer, fr.file)
    ENDIF
  ENDIF
EXCEPT DO
  IF fr THEN FreeAslRequest(fr)
  IF window THEN CloseWindow(window)
  IF screen THEN CloseScreen(screen)
  IF aslbase THEN CloseLibrary(aslbase)
  SELECT exception
  CASE ERR_ASL;  WriteF('Error: Could not allocate ASL request\n')
  CASE ERR_KICK; WriteF('Error: Requires V37\n')
  CASE ERR_LIB;  WriteF('Error: Could not open ASL library\n')
  CASE ERR_SCRN; WriteF('Error: Could not open screen\n')
  CASE ERR_WIN;  WriteF('Error: Could not open window\n')
  ENDSELECT
ENDPROC

vers: CHAR 0, '$VER: filepat 37.0', 0
