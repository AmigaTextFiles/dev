/****** file/--background-- ******************************************

    PURPOSE
        This is the first draft of the file module. The file object
        provides the means to handle any kind of file.

        Future implementations may include automatic file recognition,
        buffered input/output (the stream object needed for this is being
        developed) and convertion between different file formats. Since
        the latter is somewhat more 'high-level' the inheriting objects may

        provided methods for that purpose.
        Note that file recognition is already available through the
        recognize procedure in oomodules/file/.

    CREATION
        January 29 1995 Gregor Goldbach

    HISTORY
        February 18 1995 Gregor Goldbach
          Added attributes fib and contents. The first contains the
          fileinfoblock which is filled by ExamineFH(), the second
          contains the file read in by method suck().

          Added ExamineFH() to method open(), it fills the fib attribute
          at the file's opening.

          Added method suck(), it reads the whole file into memory.


        September 23 1995 Gregor Goldbach
          Made it fit into the oomodules/ hierarchy, i.e. it inherits from
          object.

          Added select with arguments "open" and "suck".

          Added getSize()

        September 25 1995 Gregor Goldbach
          Added isopen(), isClosed() and hasBeenOpenedBefore().

        October 1 1995 Gregor Goldbach
          Looked for autodocs and found it, so now there is at last a
          documentation. Started documenting things for the next E
          distribution.

        October 2 1995 Gregor Goldbach
          Added getProtectionFlags(), getDate(), getDateString() and
          freeContents()

******************************************************************************
*/

OPT MODULE

MODULE  'dos/dos',
   'dos/dosextens',
   'dos/datetime',
   'oomodules/object'

EXPORT OBJECT file OF object
/****** object/file ******************************

    NAME
        file of object -- The basic file object

    ATTRIBUTES
        handle:LONG -- dos.library's file handle.

        type:LONG --  The type of the file. Not used in this module, may be
            used by inheriting objects or future methods. recognize() does
            use it, though.

        status:LONG -- The type of access we want to gain. Usually the modes
            passed to Open(), porting reasons may allow for such constants
            like "read", "write" and "apen".


        fib:fileinfoblock  -- The file info block filled by dos.libary's
            ExamineFH(). By now not used that much but the future will bring
            methods that rely on this one. For now thou may read from this
            attribute if you want to get the time or the like.

        contents:PTR TO CHAR -- Pointer to the memory hunk where the whole
            file lies. suck() sets this.

    SEE ALSO
        object

********/
  handle
  type
  status    -> "new", "old", "rewr"
  fib:fileinfoblock -> has to be longword aligned!
  contents:PTR TO CHAR
ENDOBJECT

EXPORT PROC open(name:PTR TO CHAR,mode=MODE_OLDFILE) OF file
/****** file/open ******************************

    NAME
        open() of file -- Open a file.

    SYNOPSIS
        file.open(PTR TO CAHR, LONG=MODE_OLDFILE)

        file.open(name, mode)

    FUNCTION

    INPUTS
        name:PTR TO CHAR -- Name of the file to open.

        mode:LONG -- The usual dos.library's open modes.

    EXAMPLE
        file.open('S:Startup-sequence', MODE_OLDFILE)

    NOTES
        Throws the exception "file" if the file could not be opened.
        The exceptioninfo is the address of the string 'Unable to open
        file.', it is 0-terminated.

    SEE ALSO
        file

********/

  self.handle := Open(name,mode)

  IF (self.handle = NIL)
    Throw("file", {unableToOpenFile})
  ELSE
    self.status := mode
    ExamineFH(self.handle, self.fib)
  ENDIF

ENDPROC

EXPORT PROC close() OF file
/****** file/close ******************************

    NAME
        close() of file -- Close an open file.

    SYNOPSIS
        file.close()

    FUNCTION
        Closes a file if it is open, otherwise nothing happens.

    EXAMPLE
        file.close()

    SEE ALSO
        file

********/

  IF self.handle
    Close(self.handle)
    self.handle := NIL
  ENDIF

ENDPROC

EXPORT PROC exists(name:PTR TO CHAR) OF file
/****** file/exists ******************************

    NAME
        exists() of file -- Test existence of a file.

    SYNOPSIS
        file.exists(PTR TO CHAR)

        file.exists(name)

    FUNCTION
        Test if a file exists.

    INPUTS
        name:LONG -- The file's name.

    RESULT
        TRUE is the file exists, FALSE otherwise.

    EXAMPLE
        existence := file.exists('RAM:GuruChair')

    SEE ALSO
        file

********/

  self.handle := Open(name, MODE_OLDFILE)

  IF self.handle
    Close(self.handle)
    self.handle := NIL
    RETURN TRUE
  ENDIF

ENDPROC

EXPORT PROC end() OF file
/****** file/end ******************************

    NAME
        end() of file -- Free resources used by the object.

    SYNOPSIS
        file.end()

    FUNCTION
        Frees all allocated resources. As with all end() procedures,
        it is called automatically when using END. If the file is still
        opened it is closed and the memory allocated by suck() will be
        freed.

    SEE ALSO
        file

********/

  self.close()
  self.freeContents()
ENDPROC

EXPORT PROC suck(name=NIL:PTR TO CHAR) OF file HANDLE
/****** file/suck ******************************

    NAME
        suck() of file -- Read a file into memory.

    SYNOPSIS
        file.suck(PTR TO CHAR=NIL)

        file.suck(name)

    FUNCTION
        Loads a file of the given name into memory. If this object represents
        an already opened file it is closed first, then the new file is
        opened.

    INPUTS
        name:PTR TO CHAR -- name of the file to read in.

    RESULT
        TRUE if the file could be read in, FALSE otherwise.

    EXCEPTIONS
        Raises an exception if no filename is provided and no file is open.
        The exception has the number 0, this will change in the future when
        the exception handling is improved.

    SEE ALSO
        file

********/

  IF name
    IF self.handle THEN self.close()
    self.open(name)
  ENDIF

  IF self.handle=NIL THEN Raise(0)

  self.contents := New(self.fib.size+1)
  self.contents[self.fib.size]:=0 -> end with a 0byte :)
  Read(self.handle,self.contents,self.fib.size)

  self.close()

  RETURN TRUE

EXCEPT
  RETURN FALSE
ENDPROC

PROC select(opts,i) OF file
/****** file/select ******************************

    NAME
        select() of file -- Selection of action upon initialization.

    SYNOPSIS
        file.select(LONG, LONG)

        file.select(opts, i)

    FUNCTION
        See object/select().

        These items are recognized:
          "open" -- Next item is name of file, that file is opened.

          "suck" -- Next item is name of file, a suck() will be performed
           upon it.

    INPUTS
        opts:LONG -- Optionlist.

        i:LONG -- Index of optionlist.

    SEE ALSO
        file, object, open(), suck()

********/
 DEF item
 item:=ListItem(opts,i)
 SELECT item
  CASE "open"
   INC i
   self.open(ListItem(opts,i))
  CASE "suck"
   INC i
   self.suck(ListItem(opts,i))
 ENDSELECT
ENDPROC i

EXPORT PROC getSize() OF file
/****** file/getSize ******************************

    NAME
        getSize() of file -- Get the size of the file in bytes.

    SYNOPSIS
        file.getSize()

    FUNCTION
        Gets the size of the file in bytes.

    RESULT
        Number of bytes or 0 if the file is not or has not been open.

    SEE ALSO
        file

********/
  IF self.fib THEN RETURN self.fib.size ELSE RETURN 0
ENDPROC

EXPORT PROC appendBytes(string=NIL:PTR TO CHAR,number=0) OF file
/****** file/appendBytes ******************************

    NAME
        appendBytes() of file -- Append bytes to the file.

    SYNOPSIS
        file.appendBytes(PTR TO CHAR=NIL, LONG=0)

        file.appendBytes(string, number)

    FUNCTION
        Append a number of bytes to the file. The status of the file
        has to be at MODE_READWRITE.

    INPUTS
        string:PTR TO CHAR -- Characters to write.

        number:LONG -- Number of characters to write. If NIL, it will be
            found out by calling a StrLen() on the string input.

    SEE ALSO
        file

********/
  IF (string=NIL) OR (number=0) THEN RETURN

  IF self.status=MODE_READWRITE

    Seek(self.handle, 0, OFFSET_END)

    Write(self.handle, string, number)

  ENDIF
ENDPROC

EXPORT PROC isOpen() OF file IS self.handle<>NIL
/****** file/isOpen ******************************

    NAME
        isOpen() of file -- test if the file is open.

    SYNOPSIS
        file.isOpen()

    FUNCTION
        Test if the file represented by this object is open.

    RESULT
        TRUE if the file is open, FALSE otherwise.

    SEE ALSO
        file

********/

EXPORT PROC isClosed() OF file IS self.handle=NIL
/****** file/isClosed ******************************************

    NAME
        isClosed() -- Test if a file is closed.

    SYNOPSIS
        file.isClosed()

    FUNCTION
        Being the counterpart of isOpen() this function test if a file
        is closed.

    RESULT
        TRUE if the file is closed, FALSE otherwise.

******************************************************************************

History


*/

EXPORT PROC hasBeenOpenedBefore() OF file IS self.fib<>NIL
/****** file/hasBeenOpenedBefore ******************************************

    NAME
        hasBeenOpenedBefore() -- test if a file was already open.

    SYNOPSIS
        file.hasBeenOpenedBefore()

    FUNCTION
        Test if the file has been opened before. This function does NOT
        test if the file is open right now or if it is closed.

    RESULT
        TRUE if the file was opened before, FALSE otherwise.

    SEE ALSO
        isOpen(), isClosed()

******************************************************************************

History


*/


EXPORT PROC getProtectionFlags(name=NIL:PTR TO CHAR) OF file HANDLE
/****** file/getProtectionFlags ******************************************

    NAME
        getProtectionFlags() -- Get the protection flags of a file

    SYNOPSIS
        file.getProtectionFlags(PTR TO CHAR)

        file.getProtectionFlags(name=NIL)

    FUNCTION
        Get the protection flags of a file. If a name is provided the current
        file is closed if open. If no name is provided you get the flags of
        the current file.

    INPUTS
        name:PTR TO CHAR -- name of file to get the flags of. If NIL the
            flags of the current file are returned.

    RESULT
        Protection flag entry of the file info block structure from dos.

    SEE ALSO
        open(), close()
******************************************************************************

History


*/

  IF name

    IF self.isOpen() THEN self.close()


    IF self.open(name)

    self.close()
    RETURN self.fib.protection

    ENDIF

  ELSE

    IF self.fib THEN RETURN self.fib.protection

  ENDIF

EXCEPT

  RETURN NIL

ENDPROC

EXPORT PROC getDate(convert=TRUE,name=NIL:PTR TO CHAR) OF file HANDLE
/****** file HANDLE/getDate ******************************

    NAME
        getDate() of file -- Get last modification date of a file.

    SYNOPSIS
        file.getDate(LONG=TRUE, PTR TO CHAR=NIL:PTR TO CHAR)

        file.getDate(convert, name)

    FUNCTION
        Get the date of the last modification of a file. If a name is
        provided the current file is closed if open. If no name is
        provided you get the date stamp of the current file.

        The date stamp structure can be automatically converted to a
        human readable string by providing TRUE for the convert parameter.

    INPUTS
        convert:LONG -- Convert date stamp to string.


        name:PTR TO CHAR -- name of file to get the stamp of. If NIL the
            date stamp of the current file is returned.


    RESULT
        Date stamp entry of the file info block structure from dos or
        a string which contains that date in localized form.

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        file, open(), close()

********/
  IF name

    IF self.isOpen() THEN self.close()


    IF self.open(name)

    self.close()


    IF convert

   RETURN self.getDateString(self.fib.datestamp)

    ELSE

   RETURN self.fib.datestamp

    ENDIF

    ENDIF

  ELSE

    IF convert

    RETURN self.getDateString(self.fib.datestamp)

    ELSE

    RETURN self.fib.datestamp

    ENDIF

  ENDIF

EXCEPT

  RETURN NIL

ENDPROC

EXPORT PROC getDateString(datestamp=NIL:PTR TO datestamp) OF file
/****** file/getDateString ******************************

    NAME
        getDateString() of file -- Get date string in readable form.

    SYNOPSIS
        file.getDateString(PTR TO datestamp=NIL:PTR TO datestamp)

        file.getDateString(datestamp)

    FUNCTION
        Returns a string which contains the datestamp provided in a human
        readable form. The string is localized.

    INPUTS
        datestamp:PTR TO datestamp --  The stamp to get the date from.
            If NIL the current time is returned.

    RESULT
        The date in humand readable form or NIL if an error occurred.

    NOTES
        Only usable in this module. Will be moved to another module,
        maybe Date or something like that.

    SEE ALSO
        file

********/
DEF dt:datetime,
    day[50]:STRING,date[50]:STRING,time[50]:STRING,
    str

  IF datestamp

    dt.stamp.days := datestamp.days
    dt.stamp.minute := datestamp.minute
    dt.stamp.tick := datestamp.tick

  ELSE

    DateStamp(dt.stamp)

  ENDIF

  /* fill datetime structure */
  dt.format:=FORMAT_DOS
  dt.flags:=DTF_SUBST
  dt.strday:=day
  dt.strdate:=date
  dt.strtime:=time

  IF DateToStr(dt)

    str := String(StrLen(day) + StrLen(date) + StrLen(time)+2)


    IF str

    StrAdd(str, day)
    StrAdd(str,' ')
    StrAdd(str, date)
    StrAdd(str,' ')
    StrAdd(str, time)


    RETURN str

    ENDIF

  ENDIF

ENDPROC

EXPORT PROC freeContents() OF file
/****** file/freeContents ******************************

    NAME
        freeContents() of file -- Free memory allocated by suck().

    SYNOPSIS
        file.freeContents()

    FUNCTION
        Frees the memory allocated for the file's contents. May be safely
        called more than once.

    NOTES
        It is not necessary to call this function since it's called
        automatically when ENDing the object. You may call it, however, if
        you are using the same object for several files.

    SEE ALSO
        file

********/

  IF self.contents

    Dispose(self.contents)
    self.contents := NIL

  ENDIF

ENDPROC

EXPORT PROC name() OF file IS 'File'

unableToOpenFile: CHAR 'Unable to open file.',0
/*EE folds
-1
62 35 64 39 67 24 70 35 73 21 76 48 79 38 82 19 85 33 158 53 161 82 164 72 167 29 
EE folds*/
