/*
   Fill V0.11b  Beta.  Smart Multi-file Mover.
   Copyright ©1993 Barry Wills.  All rights reserved.
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   HISTORY:
   ~~~~~~~
   V0.10b - First release May 1993.
   ~~~~~~
   1.  Locks destination.  Doesn't care if it's a floppy.
   2.  Locks source.  Source is always current directory.
   3.  Examines contents of source directory.  Stores filenames and sizes in
       a list in descending order.
   4.  Checks free space on destination.  Gets from list largest files that
       will fit on destination.  Moves files to destination.  Continues
       until list is emptied or files remaining in list won't fit on an
       empty volume.
   5.  Prompts for disk-change when volume becomes full.
   6.  Displays number of unused bytes on a finished volume.
   7.  Supports options:
       -b##  Copy buffer size (1-100k; default 20)
       -c    Copy only.  Don't move files. (default MOVE FILES)
       -e##  Error Margin for storage estimate (1-20 blocks; default 0)
   8.  Preserves file attributes.
   9.  Recovers from full disk error (untested.)

   V0.11b - Released (I forgot.)
   ~~~~~~
   1.  Corrected erroneous check for file too big to fit on empty volume.
       V0.10b would keep asking for another disk, even though a file would
       not fit on an empty volume.  User had to enter 'Q' or 'q' to quit at
       the prompt.
   2.  Corrected to get the destination infodata before displaying free
       space when exiting the program.  Previously, the free space shown
       upon exiting was the free space on the destination BEFORE the last
       file was copied/moved.  (oops)

   V0.12b - Released 22 May 93.
   ~~~~~~
   1.  Added Ctrl-C abort capability.


*/

MODULE 'dos/Dos'
PMODULE 'PMODULES:commandLineArgs'
PMODULE 'PMODULES:upperChar'



/* Runtime exceptions. */
ENUM ER_NONE,
     ER_USAGE,
     ER_DEST_LOCK,
     ER_SOURCE_LOCK,
     ER_EXAM_SOURCE,
     ER_FIB,
     ER_DEST_INFO,
     ER_FILES_TOO_LARGE,
     ER_MEM,
     ER_INFILE,
     ER_OUTFILE,
     ER_WONT_FIT,
     ER_USER_ABORT


DEF copyBuffer  /* Will be allocated. */


CONST SIZEOF_A_FILE_BLOCK = 35136,
      NUMBLOCKS_USED_ON_BLANK_DISK = 2



/*=== List definitions. ==================================================*/

/* NOTE:  I did this stuff before I tried playing with E lists.  It works */
/* so I won't try changing it until the next release.                     */

OBJECT fl_ElementType
  fileName       : LONG  /*  ptr to string  */
  fileSize       : LONG  /*  long int       */
  fileProtection : LONG  /*  long int       */
ENDOBJECT
    /* fl_ElementType */


OBJECT fl_NodeType
  element  : LONG  /*  ptr to fl_ElementType  */
  nextNode : LONG  /*  ptr to fl_NodeType     */
ENDOBJECT
    /* fl_NodeType */


OBJECT fl_ListType
  head    : LONG  /*  all ptr to fl_NodeType  */
  tail    : LONG
  current : LONG
ENDOBJECT
    /* fl_ListType */



/*=== Command-line argument defs. ========================================*/

CONST MAX_ARG_BUFSIZE = 100,
      MAX_ARG_ERRORMARGIN = 20,
      MAX_DEPTH_OF_COMPARISON = 2



DEF optionIsSet_CopyOnly = FALSE,
    argBufSize = 20,
    argErrorMargin = 0,
    argDestPath = NIL



/*=== Command-line Argument Parser =======================================*/

PROC parseCommandLineArguments () HANDLE
  DEF index = 1,
      char,
      theArg, nextArg

  theArg := String (StrLen (arg))
  IF theArg = NIL THEN Raise (ER_MEM)

  nextArg := String (StrLen (arg))
  IF nextArg = NIL THEN Raise (ER_MEM)

  WHILE getArg (theArg, index)
    INC index
    IF getArg (nextArg, index)
      char := theArg [0]

      IF char = "-"
        char := theArg [1]
        SELECT char
          CASE "c"
            optionIsSet_CopyOnly := TRUE
          CASE "b"
            /* Use nextArg to save storage. */
            MidStr (nextArg, theArg, 2, ALL)
            argBufSize := Val (nextArg, NIL)
            IF argBufSize <=0 THEN Raise (ER_USAGE)
            IF argBufSize > MAX_ARG_BUFSIZE THEN argBufSize := MAX_ARG_BUFSIZE
          CASE "e"
            /* Use nextArg to save storage. */
            MidStr (nextArg, theArg, 2, ALL)
            argErrorMargin := Val (nextArg, NIL)
            IF argErrorMargin <=0 THEN Raise (ER_USAGE)
            IF argErrorMargin > MAX_ARG_ERRORMARGIN THEN argErrorMargin := MAX_ARG_ERRORMARGIN
        ENDSELECT
      ELSE  /* Too many arguments. */
        Raise (ER_USAGE)
      ENDIF
    ELSE  /* Last arg, must be DestPath. */
      argDestPath := String (StrLen (theArg))
      IF argDestPath = NIL THEN Raise (ER_MEM)
      StrCopy (argDestPath, theArg, ALL)
    ENDIF
  ENDWHILE

  Dispose (theArg)
  Dispose (nextArg)

EXCEPT

  IF theArg THEN Dispose (theArg)
  IF nextArg THEN Dispose (nextArg)
  Raise (exception)

ENDPROC
  /* parseCommandLineArguments */



/*=== Begin File List Implementation =====================================*/

/*------------------------------------------------------------------------
   These functions are used to gain easy access to the list substructures.
--------------------------------------------------------------------------*/

PROC fl_FileSizeFrom (theElement)
  DEF el : PTR TO fl_ElementType
  el := theElement
ENDPROC el.fileSize  /* long int */



PROC fl_ElementFrom (theNode)
  DEF node : PTR TO fl_NodeType
  node := theNode
ENDPROC node.element  /* ptr to fl_ElementType */



PROC fl_NextNodeFrom (theNode)
  DEF node : PTR TO fl_NodeType
  node := theNode
ENDPROC node.nextNode  /* ptr to fl_ElementType */



/*------------------------------------------------------------------------
   These functions are used to manipulate the list.
--------------------------------------------------------------------------*/

PROC fl_New ()
  DEF newFileList : PTR TO fl_ListType,
      head : PTR TO fl_NodeType,
      tail : PTR TO fl_NodeType

  newFileList := New (SIZEOF fl_ListType)
  IF newFileList = NIL THEN Raise (ER_MEM)

  newFileList.head := New (SIZEOF fl_NodeType)
  newFileList.tail := New (SIZEOF fl_NodeType)
  IF (newFileList.head = NIL) OR (newFileList.tail = NIL) THEN Raise (ER_MEM)

  head := newFileList.head
  tail := newFileList.tail
  head.nextNode := newFileList.tail
  tail.nextNode := NIL
  head.element := NIL
  tail.element := NIL

  newFileList.current := newFileList.head

ENDPROC newFileList  /* fl_ListType */
  /* fl_New */



PROC fl_Insert (theElement, theList)
  DEF newNode : PTR TO fl_NodeType,
      element : PTR TO fl_ElementType,
      list : PTR TO fl_ListType,
      current : PTR TO fl_NodeType,
      newElement : PTR TO fl_ElementType

  element := theElement
  list := theList

  list.current := list.head
  WHILE (fl_NextNodeFrom (list.current) <> list.tail) AND
        fl_IsLessThan (element, fl_ElementFrom (fl_NextNodeFrom (list.current)))
    list.current := fl_NextNodeFrom (list.current)
  ENDWHILE

  current := list.current  /* shorten name to get at substructure */

  newNode := New (SIZEOF fl_NodeType)
  IF newNode = NIL THEN Raise (ER_MEM)

  newNode.element := New (SIZEOF fl_ElementType)
  IF newNode.element = NIL THEN Raise (ER_MEM)

  newElement := newNode.element
  newElement.fileName := element.fileName
  newElement.fileSize := element.fileSize
  newElement.fileProtection := element.fileProtection
  element.fileName := NIL  /* detach pointer so that list owns it */

  newNode.nextNode := current.nextNode
  current.nextNode := newNode

ENDPROC TRUE
  /* fl_Insert */



PROC fl_RetrieveFirst (theList)
  DEF list : PTR TO fl_ListType
  IF fl_IsEmpty (theList) THEN RETURN NIL
  list := theList
  list.current := fl_NextNodeFrom (list.head)
  RETURN fl_ElementFrom (list.current)
ENDPROC
  /* fl_RetrieveFirst */



PROC fl_RetrieveNext (theList)
  DEF list : PTR TO fl_ListType
  IF fl_IsEmpty (theList) THEN RETURN NIL
  list := theList
  IF fl_NextNodeFrom (list.current) = list.tail THEN RETURN NIL
  list.current := fl_NextNodeFrom (list.current)
  RETURN fl_ElementFrom (list.current)
ENDPROC
  /* fl_RetrieveNext */



PROC fl_RemoveCurrent (theList)
  DEF list : PTR TO fl_ListType,
      current : PTR TO fl_NodeType,
      node : PTR TO fl_NodeType,
      element : PTR TO fl_ElementType

  IF fl_IsEmpty (theList) THEN RETURN NIL

  list := theList

  /* find node */
  IF list.current = list.head THEN RETURN NIL
     /* current undefined; must call one   */
     /* of the functions that set current. */
  IF list.current = list.tail THEN RETURN NIL
     /* At end of list. */
  current := list.head
  WHILE (current.nextNode <> list.current)
    current := current.nextNode
  ENDWHILE

  /* detach node */
  node := list.current
  current.nextNode := node.nextNode
  list.current := current
     /* this sets up for a possible subsequent call to fl_RetrieveNext. */

  /* remove element and deallocate node */
  element := node.element
  Dispose (node)

  RETURN element

ENDPROC
  /* fl_RemoveCurrent */



PROC fl_IsLessThan (thisElement, thatElement)
  RETURN fl_FileSizeFrom (thisElement) < fl_FileSizeFrom (thatElement)
ENDPROC



PROC fl_IsEmpty (theList)
  DEF list : PTR TO fl_ListType
  list := theList
  RETURN fl_NextNodeFrom (list.head) = list.tail
ENDPROC


/*=== End File List Implementation =======================================*/



PROC enoughRoomOnDest (theDestInfo, theElement)
  DEF destInfo : PTR TO infodata,
      element : PTR TO fl_ElementType,
      numBytesFree,
      numBytesRequired,
      numFileExtensionBlocks,
      numBytesForFileExtensionBlocks

  IF theElement = NIL THEN RETURN FALSE

  destInfo := theDestInfo
  element := theElement

  /* Compute what DOS says is free. */
  numBytesFree := Mul ((destInfo.numblocks - destInfo.numblocksused),
                       destInfo.bytesperblock)

  /*------------------------------------------------*/
  /* Storage required by DOS filesystem =           */
  /*   file_size_in_bytes +                         */
  /*   one_block_for_file_header +                  */
  /*   number_file_extension_blocks_required *      */
  /*    bytes_per_block                             */
  /*------------------------------------------------*/
  numFileExtensionBlocks := Div (element.fileSize, SIZEOF_A_FILE_BLOCK)

  numBytesForFileExtensionBlocks := Mul (numFileExtensionBlocks,
                                         destInfo.bytesperblock)
  numBytesRequired := element.fileSize +               /* file size        */
                      destInfo.bytesperblock +         /* file header      */
                      numBytesForFileExtensionBlocks + /* extension blocks */
                      (argErrorMargin *
                       destInfo.bytesperblock)

/*** LEAVE THESE IN JUST IN CASE SOMEONE REPORTS ERRORS ********************
WriteF ('\n\nfilename                      \s', element.fileName)
WriteF ('\n filesize                       \d', element.fileSize)
WriteF ('\n numblocks                      \d', destInfo.numblocks)
WriteF ('\n numblocksused                  \d', destInfo.numblocksused)
WriteF ('\n bytesperblock                  \d', destInfo.bytesperblock)
WriteF ('\n numbytesfree                   \d', numBytesFree)
WriteF ('\n numFileExtensionBlocks         \d', numFileExtensionBlocks)
WriteF ('\n numBytesForFileExtensionBlocks \d', numBytesForFileExtensionBlocks)
WriteF ('\n numBytesRequired               \d', numBytesRequired)
***************************************************************************/

ENDPROC  numBytesRequired <= numBytesFree
  /* enoughRoomOnDest */



PROC moveFile (theElement) HANDLE
  DEF element : PTR TO fl_ElementType,
      sourceFileHandle = NIL,
      destFileHandle = NIL,
      destPathAndFilename [108] : STRING,
      bytesRead,
      bytesWritten = 1

  element := theElement
  StrCopy (destPathAndFilename, argDestPath, ALL)
  StrAdd (destPathAndFilename, element.fileName, ALL)

  WriteF ('\n   \s ...', element.fileName)

  sourceFileHandle := Open (element.fileName, OLDFILE)
  IF sourceFileHandle = NIL THEN Raise (ER_INFILE)

  destFileHandle := Open (destPathAndFilename, NEWFILE)
  IF destFileHandle = NIL THEN Raise (ER_OUTFILE)

  REPEAT
    IF CtrlC () THEN Raise (ER_USER_ABORT)
    bytesRead := Read (sourceFileHandle, copyBuffer, argBufSize)
    IF bytesRead > 0
      bytesWritten := Write (destFileHandle, copyBuffer, bytesRead)
      IF bytesWritten <> bytesRead THEN Raise (ER_OUTFILE)
    ENDIF
  UNTIL (bytesRead < 1) OR (bytesWritten < 1)

  Close (destFileHandle)
  Close (sourceFileHandle)

  IF bytesRead < 0 THEN Raise (ER_INFILE)
  IF bytesWritten < 0 THEN Raise (ER_OUTFILE)

  IF optionIsSet_CopyOnly
    WriteF (' copied.')
  ELSE
    DeleteFile (element.fileName)
    WriteF (' moved.')
  ENDIF

  IF SetProtection (destPathAndFilename, element.fileProtection) = FALSE
    WriteF ('\nFailed to set protection bits for \s.', element.fileName)
  ENDIF

EXCEPT

  IF sourceFileHandle THEN Close (sourceFileHandle)
  IF destFileHandle THEN Close (destFileHandle)

  SELECT exception
    CASE ER_OUTFILE
      WriteF ('\n didn\at fit.  Trying a smaller one.')
      DeleteFile (destPathAndFilename)
      RETURN FALSE
    CASE ER_USER_ABORT
      DeleteFile (destPathAndFilename)
  ENDSELECT

  Raise (exception)

ENDPROC TRUE
  /* moveFile */



PROC main ()  HANDLE
  DEF sourceLock = NIL,
      sourceFib : fileinfoblock,
      destLock = NIL,
      destInfo : infodata,
      fileList : PTR TO fl_ListType,
      element : PTR TO fl_ElementType,
      destInfoSuccess,
      fileName,
      checkingForFile,
      char,
      newDisk = TRUE

  WriteF ('\n   Fill V0.12b - Beta.  Smart Multi-file Mover.' +
          '\n   Copyright ©1993 Barry Wills.  All rights reserved.')

  IF arg [] = 0 THEN Raise (ER_USAGE)

  parseCommandLineArguments ()
  IF argDestPath = NIL THEN Raise (ER_USAGE)

  destLock := Lock (argDestPath, SHARED_LOCK)
  IF destLock = NIL THEN Raise (ER_DEST_LOCK)

  sourceLock := Lock ('', SHARED_LOCK)  /* Current directory. */
  IF sourceLock = NIL THEN Raise (ER_SOURCE_LOCK)

  IF Examine (sourceLock, sourceFib) = FALSE THEN Raise (ER_EXAM_SOURCE)
  IF sourceFib.direntrytype <= 0 THEN Raise (ER_FIB)

  copyBuffer := New ((argBufSize * 1024))
  IF copyBuffer = NIL THEN Raise (ER_MEM)

  fileList := fl_New ()
  IF fileList = NIL THEN Raise (ER_MEM)

  WriteF ('\n\nSource directory: \s\n', sourceFib.filename)

  /* Put filenames and sizes in a list. */
  WHILE ExNext (sourceLock, sourceFib)
    IF sourceFib.direntrytype < 0
      fileName := String (108)
      StrCopy (fileName, sourceFib.filename, ALL)
      fl_Insert ([fileName, sourceFib.size, sourceFib.protection], fileList)
    ENDIF
  ENDWHILE

  /* Move files. */
  WHILE fl_IsEmpty (fileList) = FALSE
    IF newDisk OR (element = NIL)
      element := fl_RetrieveFirst (fileList)
      newDisk := FALSE
    ELSE
        element := fl_RetrieveNext (fileList)
    ENDIF

    destInfoSuccess := Info (destLock, destInfo)
    IF destInfoSuccess = FALSE THEN Raise (ER_DEST_INFO)

    checkingForFile := TRUE
    WHILE checkingForFile
      IF element = NIL
        checkingForFile := FALSE
      ELSEIF enoughRoomOnDest (destInfo, element)
        checkingForFile := FALSE
      ELSE
        element := fl_RetrieveNext (fileList)
      ENDIF
    ENDWHILE

    IF element <> NIL
      element := fl_RemoveCurrent (fileList)
      moveFile (element)
      Dispose (element)
    ELSEIF destInfo.numblocksused = NUMBLOCKS_USED_ON_BLANK_DISK
      Raise (ER_FILES_TOO_LARGE)
    ELSE
      WriteF ('\n\nUnused bytes = \d.',
              Mul ((destInfo.numblocks - destInfo.numblocksused),
                   destInfo.bytesperblock))

      WriteF ('\nInsert next volume.  Press RETURN to proceed, \aQ\a or \aq\a to discontinue...')
      char := Inp (stdout)
      WHILE Inp (stdout) <> 10 DO NOP  /* Flush input buffer. */
      IF upperChar (char) = "Q" THEN Raise (ER_USER_ABORT)

      UnLock (destLock)
      destLock := Lock (argDestPath, SHARED_LOCK)
      IF destLock = NIL THEN Raise (ER_DEST_LOCK)
      newDisk := TRUE
    ENDIF
  ENDWHILE

  /* Display unused bytes on destination before leaving program. */
  destInfoSuccess := Info (destLock, destInfo)
  IF destInfoSuccess = FALSE THEN Raise (ER_DEST_INFO)
  WriteF ('\n\nUnused bytes = \d.',
          Mul ((destInfo.numblocks - destInfo.numblocksused),
               destInfo.bytesperblock))

  Dispose (copyBuffer)

  UnLock (sourceLock)
  UnLock (destLock)

  WriteF ('\n\n')

  CleanUp (0);

EXCEPT

  WriteF ('\n   ')

  SELECT exception
    CASE ER_USAGE
      WriteF ('\n   Usage:  Fill [<options>] <destination>')
      WriteF ('\n   Options:')
      WriteF ('\n     -b##  Buffer size in kbytes (1-\d; default 20)', MAX_ARG_BUFSIZE)
      WriteF ('\n     -c    Copy files only, don\at delete source (default MOVE FILES)')
      WriteF ('\n     -e##  Error margin, add blocks to storage estimate (1-\d; default 0)',
              MAX_ARG_ERRORMARGIN)
    CASE ER_DEST_LOCK;    WriteF ('Unable to use \s as destination.', argDestPath)
    CASE ER_SOURCE_LOCK;  WriteF ('Unable to lock the current directory.')
    CASE ER_EXAM_SOURCE;  WriteF ('Unknown error examining current directory.')
    CASE ER_FIB;          WriteF ('Error encountered in source directory file info block.')
    CASE ER_MEM;          WriteF ('Insufficient memory.')
    CASE ER_DEST_INFO;    WriteF ('Error occurred while getting destination Info.')
    CASE ER_FILES_TOO_LARGE
                          WriteF ('Remaining file(s) too large to fit on destination.')
    CASE ER_INFILE;       WriteF ('Input file error.')
    CASE ER_OUTFILE;      WriteF ('Output file error.')
    CASE ER_USER_ABORT;   WriteF ('Program aborted by request.')
  ENDSELECT

  WriteF ('\n\n')

  IF copyBuffer THEN Dispose (copyBuffer)

  IF sourceLock THEN UnLock (sourceLock)
  IF destLock THEN UnLock (destLock)

  CleanUp (exception);

ENDPROC
