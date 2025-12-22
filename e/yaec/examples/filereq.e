-> filereq.e

MODULE 'asl'
MODULE 'libraries/asl'

ENUM ERR_NONE, ERR_ASL, ERR_KICK, ERR_LIB

RAISE ERR_ASL  IF AllocAslRequest()=NIL
RAISE ERR_KICK IF KickVersion()=FALSE
RAISE ERR_LIB  IF OpenLibrary()=NIL

CONST MYLEFTEDGE=0, MYTOPEDGE=0, MYWIDTH=320, MYHEIGHT=400

PROC main() HANDLE
  DEF fr:PTR TO filerequester, aslbase
  KickVersion(37)  -> E-Note: requires V37
  aslbase:=OpenLibrary('asl.library',37)
  fr:=AllocAslRequest(ASL_FILEREQUEST,
                     [ASL_HAIL,       'The RKM file requester',
                      ASL_HEIGHT,     MYHEIGHT,
                      ASL_WIDTH,      MYWIDTH,
                      ASL_LEFTEDGE,   MYLEFTEDGE,
                      ASL_TOPEDGE,    MYTOPEDGE,
                      ASL_OKTEXT,     'O KAY',
                      ASL_CANCELTEXT, 'not OK',
                      ASL_FILE,       'asl.library',
                      ASL_DIR,        'libs:',
                      NIL])
  IF AslRequest(fr, NIL)
    WriteF('PATH=\s  FILE=\s\n', fr.drawer, fr.file)
    WriteF('To combine the path and filename, copy the path\n')
    WriteF('to a buffer, add the filename with Dos AddPart().\n')
  ELSE
    -> E-Note: C version gets this wrong!
    WriteF('User Cancelled\n')
  ENDIF
EXCEPT DO
  IF fr THEN FreeAslRequest(fr)
  IF aslbase THEN CloseLibrary(aslbase)
  SELECT exception
  CASE ERR_ASL;  WriteF('Error: Could not allocate ASL request\n')
  CASE ERR_KICK; WriteF('Error: Requires V37\n')
  CASE ERR_LIB;  WriteF('Error: Could not open ASL library\n')
  ENDSELECT
ENDPROC

->CHAR '$VER: filereq 37.0',0
STATIC VERSTRING = '$VER: filereq 37.0'
