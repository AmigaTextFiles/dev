/*
** do not bother the WARNINGs
*/

MODULE 'exec/libraries','exec'

OBJECT SimpleBase
  library   :Library
  flags     :BYTE
  pad       :BYTE
  segment   :LONG
ENDOBJECT

DEF SimpleBase:PTR TO SimpleBase

#define LibClassName    'simple.library' ->this MUST be the same name as that of this file
#define LibVersion 2
#define LibRevision 1
#define LibCopyright(ver,rev) ' V.'+LibVersion+'.'+LibRevision+' (\xd-\xm-\xY) (C) Marco Antoniazzi'

OPT	LIBRARY	LibClassName,LibVersion,LibRevision,'$VER: '+LibClassName+LibCopyright(LibVersion,LibRevision),SimpleBase IS MyAdd,
MySub

PROC customInitLib(base:PTR TO SimpleBase)
/*
** here you can open libraries or allocate mem, RETURN TRUE if all went well
*/
    RETURN TRUE
ENDPROC FALSE
PROC customOpenLib(base:PTR TO SimpleBase)
/*
** here you can allocate mem or do other initialisation done every time a
** program calls OpenLibrary(). RETURN TRUE if all went well
*/
ENDPROC TRUE
PROC customCloseLib(base:PTR TO SimpleBase)
-> free memory allocated in customOpenLib
ENDPROC
PROC customExpungeLib(base:PTR TO SimpleBase)
-> free memory allocated in customInitLib and close libraries opened there
ENDPROC

PROC MyAdd(a REG d0,b REG d1)
ENDPROC a+b

PROC MySub(a REG d0,b REG d1)
ENDPROC a-b
