-> load a file into memory like readfile() in tools/file.m
-> but with XPK and PowerPacker support

OPT MODULE
OPT EXPORT

MODULE 'xpkmaster', 'powerpacker', 'xpk/xpk',
       'libraries/ppbase', 'utility/tagitem'

PROC loadfile(filename, memtype=0)
  DEF err, file, memptr=NIL, length, readlen

  -> first try to load with the XPK system, if no XPK is available then
  -> try PowerPacker (XPK itself will already have tried PowerPacker)

  IF xpkbase := OpenLibrary('xpkmaster.library', 3)
    err := XpkUnpack([
      XPK_INNAME,       filename,
      XPK_GETOUTBUF,    {memptr},
      XPK_GETOUTBUFLEN, {length},
      XPK_OUTMEMTYPE,   memtype,
      TAG_DONE
    ])
    CloseLibrary(xpkbase)
  ELSE
    IF ppbase := OpenLibrary('powerpacker.library', 35)
      err := PpLoadData(
        filename, DECR_NONE, memtype, {memptr}, {length}, NIL
      )
      CloseLibrary(ppbase)
    ENDIF
  ENDIF

  -> both ppLoadData() and xpkUnpack() return 0 on success, < 0 for
  -> error code. If we've succeeded, return now.
  IF err = 0 THEN RETURN memptr, length

  -> Otherwise, free any possibly allocated memory, and try to
  -> load raw from disk.
  IF memptr THEN FreeMem(memptr, length)

  IF (length := FileLength(filename)) > 0
    IF memptr := AllocMem(length, memtype)
      IF file := Open(filename, OLDFILE)
        readlen := Read(file, memptr, length)
        Close(file)
        IF readlen <> -1 THEN RETURN memptr, length
        FreeMem(memptr, length)
      ENDIF
    ENDIF
  ENDIF
ENDPROC NIL, 0

PROC savefile(filename, data, length)
  DEF file, written
  IF file := Open(filename, NEWFILE)
    written := Write(file, data, length)
    IF Close(file) AND (written <> -1) THEN RETURN TRUE
  ENDIF
ENDPROC FALSE
