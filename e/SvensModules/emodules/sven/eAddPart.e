/*
** AddPart() that works correctly on EStrings
*/

OPT MODULE
OPT PREPROCESS

MODULE 'dos/dos'

RAISE "addp" IF AddPart()=DOSFALSE

/*
** Adds an file or directory name to a pathname.
**   pathname - pointer to EString to which the file name should be added
**   filename - the filename to be added.
** Returns 'pathname'.
** Raise "addp"-exception if 'pathname' is not large enough.
*/
EXPORT PROC eAddPart(pathname, filename:PTR TO CHAR)

  AddPart(pathname,filename,StrMax(pathname))
  SetStr(pathname,StrLen(pathname))

ENDPROC pathname

/*
** Like eAddPart, but first copies pathname into the EString
*/
EXPORT PROC eAddPartC(estri, pathname:PTR TO CHAR, filename:PTR TO CHAR) IS
  eAddPart(StrCopy(estri, pathname), filename)

