(****** ioSet/--AMOK-Header-- ***********************************************

:Program.    ioSet.mod
:Contents.   redirection of in- and output-channels for io.mod
:Author.     Oliver Knorr
:Copyright.  Public Domain
:Language.   Oberon-2
:Translator. Amiga Oberon v3.11
:History.    v1.1 [olk] 24-Mar-94
:Support.    idea taken from M2Amiga's InOut.mod
:Version.    $VER: ioSet.mod 1.1 (24.3.94)

*****************************************************************************
*
*)

MODULE ioSet;

(****** ioSet/--background-- ************************************************
*
*       Two of the most important standard modules for text in- and
*       output coming with the Amiga Oberon Compiler are io.mod and
*       FileSystem.mod. While FileSystem.mod gives you the ability to
*       work with files, it does not feature the many options for
*       formatted in- and output of io.mod. While io.mod normally
*       operates only on standard input and standard output, you can
*       redirect it to any file with its global variables out and in.
*       This Module, ioSet, gives you easy access to this redirection
*       feature of io.mod.
*
*****************************************************************************
*
*)

IMPORT io, SecureDos, Dos;

VAR

  in, out, oldOut, oldIn : Dos.FileHandlePtr;


(****** ioSet/CloseInput ****************************************************
*
*   NAME
*       CloseInput -- remove redirection of the io.mod input channel
*
*   SYNOPSIS
*       CloseInput
*
*   FUNCTION
*       Removes the redirection of the input channel of io.mod
*       started with SetInput() and closes the redirection file.
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       SetInput(), CloseOutput()
*
*****************************************************************************
*
*)

PROCEDURE CloseInput *;
BEGIN
  IF in # NIL THEN
    io.in := oldIn;
    SecureDos.Close(in);
    in := NIL
  END;
END CloseInput;


(****** ioSet/CloseOutput ***************************************************
*
*   NAME
*       CloseOutput -- remove redirection of the io.mod output channel
*
*   SYNOPSIS
*       CloseOutput
*
*   FUNCTION
*       Removes the redirection of the output channel of io.mod
*       started with SetOutput() and closes the redirection file.
*
*   INPUTS
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       SetOutput(), CloseInput()
*
*****************************************************************************
*
*)

PROCEDURE CloseOutput *;
BEGIN
  IF out # NIL THEN
    io.out := oldOut;
    SecureDos.Close(out);
    out := NIL
  END
END CloseOutput;


(****** ioSet/SetInput ******************************************************
*
*   NAME
*       SetInput -- redirect input channel of io.mod
*
*   SYNOPSIS
*       SetInput (name: ARRAY OF CHAR): BOOLEAN
*
*   FUNCTION
*       Redirects the input channel of io.mod to the given file.
*       Any subsequent calls to the Read... procedures of io.mod
*       will operare on this file instead of the standard input
*       until CloseInput() is called.
*
*   INPUTS
*       name - name of the file the input channel of io.mod shall be
*              redirected to
*
*   RESULT
*       TRUE: redirection enabled
*       FALSE: file could not be opened
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       CloseInput(), SetOutput()
*
*****************************************************************************
*
*)

PROCEDURE SetInput * (name: ARRAY OF CHAR): BOOLEAN;
BEGIN
  IF in # NIL THEN CloseInput END;
  in := SecureDos.Open(name, Dos.oldFile);
  IF in # NIL THEN io.in := in END;
  RETURN in # NIL
END SetInput;


(****** ioSet/SetOutput *****************************************************
*
*   NAME
*       SetOutput -- redirect output channel of io.mod
*
*   SYNOPSIS
*       SetOutput (name: ARRAY OF CHAR): BOOLEAN
*
*   FUNCTION
*       Redirects the output channel of io.mod to the given file.
*       Any subsequent calls to the Write... procedures of io.mod
*       will operare on this file instead of the standard output
*       until CloseOutput() is called.
*
*   INPUTS
*       name - name of the file the output channel of io.mod shall be
*              redirected to
*
*   RESULT
*       TRUE: redirection enabled
*       FALSE: file could not be opened
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       CloseOutput(), SetInput()
*
*****************************************************************************
*
*)

PROCEDURE SetOutput * (name: ARRAY OF CHAR): BOOLEAN;
BEGIN
  IF out # NIL THEN CloseOutput END;
  out := SecureDos.Open(name, Dos.newFile);
  IF out # NIL THEN io.out := out END;
  RETURN out # NIL
END SetOutput;


BEGIN

  oldOut := io.out;
  oldIn := io.in;
  out := NIL;
  in := NIL;


CLOSE

  io.out := oldOut;
  io.in := oldIn;


END ioSet.
