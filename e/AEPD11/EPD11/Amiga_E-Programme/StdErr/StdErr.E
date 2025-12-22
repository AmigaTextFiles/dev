MODULE 'dos/datetime','dos/dos'

OBJECT err_port
 filename,
 private,
 fh
ENDOBJECT

DEF stderr=0:PTR TO err_port

PROC err_New(filename) HANDLE
 IF stderr THEN err_Dispose()
 stderr:=New(SIZEOF err_port)
 stderr.filename:=filename
 stderr.private:=0
 stderr.fh:=0
EXCEPT
 Raise(exception)
ENDPROC

PROC err_Close()
 IF stderr.fh AND (stderr.fh <> stdout) AND stderr<>0 THEN Close(stderr.fh)
 stderr.fh:=0
ENDPROC

PROC err_Dispose()
 IF stderr=0 THEN RETURN
 err_Close()
 Dispose(stderr)
 stderr:=0
ENDPROC

PROC err_Open() HANDLE
/* NOTE: you may wish to change the format string printed in the print
 * statement.
 */
 DEF dt:datetime,tmp
 IF stderr=0
  stderr:=New(SIZEOF err_port)
  stderr.fh:=0
  stderr.private:=0
  stderr.filename:=0
 ENDIF
 IF stderr.filename <> stderr.private
  err_Close()
  IF stderr.filename=stdout
   stderr.fh:=stdout
  ENDIF
  stderr.private:=stderr.filename
 ENDIF
 IF stderr.private AND (stderr.private <> stdout)
  DateStamp(dt.stamp)
  dt.format:=FORMAT_DOS /* set datetime options */
  dt.flags:=0
  dt.strday:=String(11)
  dt.strdate:=String(11)
  dt.strtime:=String(11)
  DateToStr(dt)         /* make into string */
  IF tmp := Open(stderr.private,MODE_READWRITE)
    stderr.fh := tmp
    Seek(stderr.fh,0,OFFSET_END)
  ENDIF
  VfPrintf(stderr.fh,'\nERROR: \s | \s | \s\n\n',[dt.strday,dt.strdate,dt.strtime])
  Flush(stderr.fh)
 ELSEIF wbmessage                 /* if called from icon */
  WriteF('')
  stderr.fh:=stdout
 ELSEIF stderr.private <> stdout
  stderr.fh:=Open('CONSOLE:',NEWFILE) /* for stderr activity on CLI call */
 ENDIF
 IF stderr.fh=0
  stderr.fh:=stdout
 ENDIF

EXCEPT
 err_Close()
 WriteF('*** Error in err_Open()\n')
 Raise(exception)
ENDPROC

PROC err_WriteF(format,items) HANDLE
/* Here's a way to write errors without having to open a window until we
 * absolutely HAVE to.
 */
 err_Open()
 IF items
  VfPrintf(stderr.fh,format,items)
  Flush(stderr.fh)
 ELSE
  Fputs(stderr.fh,format)
  Flush(stderr.fh)
 ENDIF
EXCEPT
 WriteF('Error in err_WriteF()\n')
 Raise(exception)
ENDPROC
