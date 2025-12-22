MODULE 'dos/datetime','dos/dos'

RAISE "OPEN" IF Open() = NIL,
      "MEM"  IF New() = NIL

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
  VfPrintf(stderr.fh,'\nExample: \s | \s | \s\n\n',[dt.strday,dt.strdate,dt.strtime])
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

PROC main() HANDLE

/* Establish where stdout is...*/

WriteF('STDIO port.\n')

/* Create the stderr port to use CONSOLE: */

err_New(NIL)

/* Now write to it.. */

err_WriteF('This is the StdErr port.\n',0)

/* Now open a seperate window and print stuff...*/
stderr.filename:='con:'
err_WriteF('I wonder if this works?\n',0)

/*Print to a file...*/
stderr.filename:='ram:readme.txt'
err_WriteF('This is the \drd time I''ve called err_WriteF()!\n',[3])

/* Now use CONSOLE: again.. */
stderr.filename:=0
err_WriteF('(stderr) Number \d & \d are happy.\n',[234,2])

/* Try writing to stdout instead... */
stderr.filename:=stdout
err_WriteF('Final Test (stdout)\n',0)

/* Enough silliness... let's cleanup and get outta here.*/
err_Dispose()

EXCEPT
 err_Dispose()
 WriteF('Error in main()\n')
 SELECT exception
  CASE "OPEN"
   WriteF('Couldn''t open file.\n')
  CASE "MEM"
   WriteF('Not enough memory.\n')
 ENDSELECT
ENDPROC
