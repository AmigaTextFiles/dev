/*

The first draft of a file module. Future methods may include recognition,
convertion, input/output (buffered and not). There may be attributes about
length, protection flags etc.

Gregor Goldbach January 29th 1995

Note:

For file recognition see recognition.e (uses whatis.library).

History
-------

  February 18th 1995
    Added attributes fib and contents. The first contains the fileinfoblock
  which is filled by ExamineFH(), the second contains the file read in by
  method suck().
    Added ExamineFH() to method open(), it fills the fib attribute at the
  file's opening.
    Added method suck(), it reads the whole file into memory.


*/

OPT MODULE
OPT EXPORT

MODULE 'dos/dos', 'dos/dosextens'

EXPORT OBJECT file
  handle
  type
  status    -> "new", "old", "rewr"
  fib:fileinfoblock -> has to be longword aligned!
  contents:PTR TO CHAR
ENDOBJECT

PROC open(name,mode=MODE_OLDFILE) OF file
/*

METHOD

open of file

DESC

Try to open a file in the given mode.

RAISES

The exception "OPEN" with the information "file"is raised, if the opening
failed.

EFFECTS

attribute 'handle' is set to the DOS handle, if the opening succeeded
attribute 'status' is set to MODE_OLDFILE, if an existing file could be opened
                             MODE_NEWFILE, if the file has been created
                             MODE_READWRITE, if access for read/write was gained

SUGGESTIONS

- Automagic recognition of the file (switchable via parameter, default on)
- maybe: if open(old) did fail, try to open(new)
*/

  self.handle := Open(name,mode)

  IF (self.handle = NIL)
    Throw("OPEN", "file")
  ELSE
    self.status := mode
    ExamineFH(self.handle, self.fib)
  ENDIF

ENDPROC

PROC close() OF file
/*

METHOD

  close of file

DESCRIPTION

  Closes a file if it is open.
*/

  IF self.handle THEN Close(self.handle)
ENDPROC

PROC exists(name) OF file
/*

METHOD

  exists of file

DESCRIPTION

  returns NIL if a file does not exists

INTERNAL

  self.open is not used for it raises an exception if open fails.

*/

  self.handle := Open(name, MODE_OLDFILE)

  IF self.handle
    Close(self.handle)
    self.handle := NIL
    RETURN TRUE
  ENDIF

ENDPROC

PROC end() OF file
  self.close()
  Dispose(self.contents)
ENDPROC

PROC suck(name=NIL) OF file HANDLE
/*

METHOD

  suck of file

DESCRIPTION

  Reads a file into memory. If a filename is provided, the actual file will
  be closed and the new file is opened. If no filename is provided a file
  has to be opened or the method returns FALSE.

INPUTS

  filename - the name of the file to load, see the description

RESULTS

  FALSE if the file could not be opened or if no memory could be allocated,
  otherwise the number of bytes read.

*/

  IF name
    IF self.handle THEN self.close() ELSE self.open(name)
  ENDIF

  IF self.handle=NIL THEN Raise(0)

  self.contents := NewR(self.fib.size+1)
  self.contents[self.fib.size]:=0 -> end with a 0byte :)
  RETURN Read(self.handle,self.contents,self.fib.size)

EXCEPT
  RETURN FALSE
ENDPROC


