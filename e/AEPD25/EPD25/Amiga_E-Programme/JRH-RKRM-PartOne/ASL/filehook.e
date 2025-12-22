-> filehook.e

OPT PREPROCESS

-> E-Note: eCodeASLHook() sets up an E PROC for use as an ASL hook function
->         (i.e., you can use globals and not worry about trashing registers).
MODULE 'asl',
       'other/ecode',
       'dos/dos',
       'dos/dosasl',
       'intuition/intuition',
       'libraries/asl',
       'utility/hooks'

ENUM ERR_NONE, ERR_AFILE, ERR_ECODE, ERR_KICK, ERR_LIB, ERR_WIN

RAISE ERR_AFILE IF AllocFileRequest()=NIL,
      ERR_KICK  IF KickVersion()=FALSE,
      ERR_LIB   IF OpenLibrary()=NIL,
      ERR_WIN   IF OpenWindowTagList()=NIL

CONST DESTPATLENGTH=20

DEF window=NIL, sourcepattern, pat[DESTPATLENGTH]:ARRAY

PROC main() HANDLE
  DEF fr=NIL:PTR TO filerequester, myFunc

  -> This is the pattern matching string that the hook function uses
  sourcepattern:='(#?.info)'

  KickVersion(37)  -> E-Note: requires V37

  aslbase:=OpenLibrary('asl.library', 37)

  -> This is a V37 dos.library function that turns a pattern matching string
  -> into something the DOS pattern matching functions can understand.
  ParsePattern(sourcepattern, pat, DESTPATLENGTH)

  -> Open a window that gets ACTIVEWINDOW events
  window:=OpenWindowTagList(NIL, [WA_TITLE, 'ASL Hook Function Example',
                                  WA_IDCMP, IDCMP_ACTIVEWINDOW,
                                  WA_FLAGS, WFLG_DEPTHGADGET,
                                  NIL])

  fr:=AllocFileRequest()
  -> E-Note: eCodeASLHook() sets up an E PROC for use as an ASL hook function
  IF NIL=(myFunc:=eCodeASLHook({hookFunc})) THEN Raise(ERR_ECODE)
  IF AslRequest(fr, [ASL_DIR,       'SYS:Utilities',
                     ASL_WINDOW,    window,
                     ASL_TOPEDGE,   0,
                     ASL_HEIGHT,    200,
                     ASL_HAIL,      'Pick an icon, select save',
                     -> E-Note: use the value returned from aslhook()
                     ASL_HOOKFUNC,  myFunc,
                     ASL_FUNCFLAGS, FILF_DOWILDFUNC OR FILF_DOMSGFUNC OR
                                    FILF_SAVE,
                     ASL_OKTEXT, 'Save',
                     NIL])
    WriteF('PATH=\s FILE=\s\n', fr.drawer, fr.file)
    WriteF('To combine the path and filename, copy the path\n')
    WriteF('to a buffer, add the filename with Dos AddPart().\n')
  ENDIF
EXCEPT DO
  IF fr THEN FreeFileRequest(fr)
  IF window THEN CloseWindow(window)
  IF aslbase THEN CloseLibrary(aslbase)
  SELECT exception
  CASE ERR_AFILE;  WriteF('Error: Could not allocate file request\n')
  CASE ERR_ECODE;  WriteF('Error: Ran out of memory in eCodeASLHook()\n')
  CASE ERR_KICK;   WriteF('Error: Requires V37\n')
  CASE ERR_LIB;    WriteF('Error: Could not open ASL library\n')
  CASE ERR_WIN;    WriteF('Error: Could not open window\n')
  ENDSELECT
ENDPROC

PROC hookFunc(type, obj:PTR TO anchorpath, fr)
  DEF returnvalue
  SELECT type
  CASE FILF_DOMSGFUNC
    -> We got a message meant for the window
    WriteF('You activated the window\n')
    RETURN obj
  CASE FILF_DOWILDFUNC
    -> We got an AnchorPath structure, should the requester display this file?

    -> MatchPattern() is a dos.library function that compares a matching
    -> pattern (parsed by the ParsePattern() DOS function) to a string and
    -> returns TRUE if they match.
    returnvalue:=MatchPattern(pat, obj.info.filename)

    -> We have to negate MatchPattern()'s return value because the file
    -> requester expects a zero for a match not a TRUE value
    RETURN returnvalue=FALSE
  ENDSELECT
ENDPROC

vers: CHAR 0, '$VER: filehook 37.0', 0
