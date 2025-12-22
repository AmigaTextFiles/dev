OPT MODULE

MODULE  'oomodules/library',

        'asl',
        'libraries/asl',

        'other/ecode',
        'dos/dos',
        'dos/dosasl',
        'utility/hooks'

CONST MAXPATTERNLENGTH=80,
      MAXFILELENGTH=30,
      MAXDIRLENGTH=255

DEF patbuffer,

/*
 * The patbuffer variable is used in hookFunc and getFileWithPattern. It holds
 * the pattern the files should match.
 */

    temporaryBuffer:PTR TO CHAR -> contains temporary data

/*
 * the temporary buffer contains the absolute file name of the file name
 * that was chosen in the last requester.
 */

EXPORT OBJECT asl OF library
/****** asl/asl ******************************

    NAME
      asl of library

    PURPOSE
      Object for handling the asl.library.

    ATTRIBUTES
      patbuffer[MAXPATTERNLENGTH]:ARRAY OF CHAR -- buffer to store the file
          pattern in.

      lastFileChosen[MAXFILELENGTH]:ARRAY OF CHAR -- buffer to store the name
          of the file that was chosen in the last requester.

      lastDirChosen[MAXDIRLENGTH]:ARRAY OF CHAR -- buffer to store the name
          of the directory that was chosen in the last requester.

    NOTES
      Not all functions of the asl.library are implemented.

    SEE ALSO
        library

********/
  patbuffer[MAXPATTERNLENGTH]:ARRAY OF CHAR,
  lastFileChosen[MAXFILELENGTH]:ARRAY OF CHAR
  lastDirChosen[MAXDIRLENGTH]:ARRAY OF CHAR
ENDOBJECT

PROC init() OF asl
/****** reqtools/init ******************************************

    NAME 
        init() -- Initialization of the object.

    SYNOPSIS
        asl.init()

    FUNCTION
        Copies 'SYS:' to the lastDirChosen attribute.
        Sets the library's name and the version to 0. After that the library
        is opened.

    SEE ALSO
        open()
******************************************************************************

History


*/
  temporaryBuffer := String(255)

  AstrCopy(self.lastDirChosen, 'SYS:')

  self.identifier:='asl.library'
  self.version:=0
  self.open()
ENDPROC

EXPORT PROC open() OF asl
/****** asl/open ******************************

    NAME
        open() of asl -- Open the asl.library.

    SYNOPSIS
        asl.open()

    FUNCTION
        Open the asl.library. The version to open can be specified in the
        option list you pass to new().

    EXCEPTION
        As with all libraries, the exception "lib" is raised when the opening
        failed. The exceptioninfo contains a string that tells this.

    NOTES
        The string may be localized in the future.

    SEE ALSO
        asl

********/

 IF (aslbase:=OpenLibrary(self.identifier,self.version)) = NIL THEN Throw("lib",{aslOpen})

ENDPROC

EXPORT PROC close() OF asl
/****** asl/close ******************************

    NAME
        close() of asl -- Close the library.

    SYNOPSIS
        asl.close()

    FUNCTION
        Closes the library if it is open.

    SEE ALSO
        asl

********/

  IF aslbase THEN CloseLibrary(aslbase)

ENDPROC

PROC end() OF asl
/****** asl/end ******************************

    NAME
        end() of asl -- Global destructor.

    SYNOPSIS
        asl.end()

    FUNCTION
        Frees allocated resources and closes the library.

    SEE ALSO
        asl

********/

  DisposeLink(temporaryBuffer)
  self.close()

ENDPROC

PROC hookFunc(type, obj:PTR TO anchorpath, fr)
/****** /hookFunc ******************************

    NAME
        hookFunc() -- Hook function for requesters.

    SYNOPSIS
        hookFunc(LONG, PTR TO anchorpath, LONG)

        hookFunc(type, obj, fr)

    FUNCTION
        Used when displaying the file requesters.

    NOTES
        Stolen from JRH's rkrm examples. Dunno how it works, so this autodoc
        lacks the input description :-(

    SEE ALSO
        getFileWithPattern(), rkrm examples
********/
  DEF returnvalue
  SELECT type
  CASE FILF_DOMSGFUNC
    -> We got a message meant for the window
    RETURN obj
  CASE FILF_DOWILDFUNC
    -> We got an AnchorPath structure, should the requester display this file?

    -> MatchPattern() is a dos.library function that compares a matching
    -> pattern (parsed by the ParsePattern() DOS function) to a string and
    -> returns TRUE if they match.
    returnvalue:=MatchPattern(patbuffer, obj.info.filename)

    -> We have to negate MatchPattern()'s return value because the file
    -> requester expects a zero for a match not a TRUE value
    RETURN returnvalue=FALSE
  ENDSELECT
ENDPROC

EXPORT PROC getFileWithPattern(pattern:PTR TO CHAR, taglist=NIL) OF asl
/****** asl/getFileWithPattern ******************************

    NAME
        getFileWithPattern() of asl -- Get a file that matches the pattern.

    SYNOPSIS
        asl.getFileWithPattern(PTR TO CHAR, LONG=NIL)

        asl.getFileWithPattern(pattern, taglist)

    FUNCTION
        Opens a file requester that displays the files that match the pattern
        provided.

    INPUTS
        pattern:PTR TO CHAR -- The pattern of the files that should appear in
            the file list. The usual dos.library wildcards are allowed.

        taglist:LONG -- asl tags. See CBM's asl.doc for those.

    RESULT
        PTR TO CHAR -- The chosen file or NIL if the user aborted.

    NOTES
        The attributes lastFileChosen and lastDirChosen are set by this proc.

        Stolen from JRH's rkrm examples.

    KNOWN BUGS
        Tries to add a file name even if no file was chosen. Fixed this bug
        (May 26 1996 Gregor Goldbach).

    SEE ALSO
        asl/asl, CBM's asl.doc, JRH's rkrm examples

********/
DEF fr:PTR TO filerequester,
    myFunc,
    nulist

  ParsePattern(pattern, self.patbuffer, MAXPATTERNLENGTH)

  patbuffer := self.patbuffer

  fr:=AllocFileRequest()
  -> E-Note: eCodeASLHook() sets up an E PROC for use as an ASL hook function
  myFunc:=eCodeASLHook({hookFunc})

  IF myFunc

 /*
  * now we have myFunc. we're able to set up the tag list
  */

    nulist := List(255)
    ListCopy(nulist, taglist)
    ListAdd(nulist, [ASL_HOOKFUNC, myFunc, ASL_FUNCFLAGS, FILF_DOWILDFUNC OR FILF_DOMSGFUNC OR FILF_SAVE])


/*
    IF AslRequest(fr, [ASL_DIR,       'SYS:Utilities',
->                       ASL_WINDOW,    window,
                       ASL_TOPEDGE,   0,
                       ASL_HEIGHT,    200,
                       ASL_HAIL,      'Pick an icon, select save',
                       -> E-Note: use the value returned from aslhook()
                       ASL_HOOKFUNC,  myFunc,
                       ASL_FUNCFLAGS, FILF_DOWILDFUNC OR FILF_DOMSGFUNC
                       ASL_OKTEXT, 'Save',
                       NIL])
*/

    IF AslRequest(fr, nulist)

      AstrCopy(self.lastDirChosen,fr.drawer, IF StrLen(fr.drawer)<MAXDIRLENGTH THEN StrLen(fr.drawer)+1 ELSE MAXDIRLENGTH)
      AstrCopy(self.lastFileChosen,fr.file, IF StrLen(fr.file)<MAXFILELENGTH THEN StrLen(fr.file)+1 ELSE MAXFILELENGTH)

/*
      WriteF('PATH=\s FILE=\s\n', fr.drawer, fr.file)
      WriteF('To combine the path and filename, copy the path\n')
      WriteF('to a buffer, add the filename with Dos AddPart().\n')
*/
    ENDIF

  ENDIF

  DisposeLink(nulist)

  IF fr THEN FreeFileRequest(fr)

  StrCopy(temporaryBuffer, self.lastDirChosen)
  IF self.lastFileChosen[0] THEN AddPart(temporaryBuffer, self.lastFileChosen, 255)

  RETURN temporaryBuffer

ENDPROC



aslOpen: CHAR 'Unable to open asl.library',0
/*EE folds
-1
31 29 33 28 36 26 39 18 42 19 45 37 
EE folds*/
