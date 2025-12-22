{
************************** CB_RandomFiles.h *******************

© 1994 - 1996 by FR-SoftWorks.
  Version: 2.00
  Revision 16 Sep 1996

  Support for random files in ACE Basic v2.3.7 May be freely distributed.

*** Declaration of used library functions ***

Make sure you use the new BMAP files supplied with ACE 2.3.7!
}
DECLARE FUNCTION _Open&(n&, m&) LIBRARY "dos.library"
DECLARE FUNCTION _Close&(fh&) LIBRARY "dos.library"
DECLARE FUNCTION _Read&(fh&, buf&, len&) LIBRARY "dos.library"
DECLARE FUNCTION _Write&(fh&, buf&, len&) LIBRARY "dos.library"
DECLARE FUNCTION Seek&(fh&, rpos&, smode&) LIBRARY "dos.library"

LIBRARY "dos.library" {Please close library before exiting the program.}
{
*** Error messages used by the subs ***

If an error occurs, the subs will generate an error message, and the program
will terminate immediately.
}
CBRFERR_OPEN$="Unable to open random file"
CBRFERR_NUMBER$="Random file number out of range"
CBRFERR_NOTOPEN$="Random file not open"
CBRFERR_READ$="Error reading random record"
CBRFERR_READEND$="Attempted to read random record past end of file"
CBRFERR_WRITE$="Error writing random record"
CBRFERR_SEEKNEG$="Negative seek position"
CBRFERR_BUFFER$="Illegal buffer address and / or size"
{
*** Variables used by the subs ***
}

{Highest random file number. Increase it if you need more files}

CONST MAXRANDOMFILES=10

{These arrays contain the data necessary to access a random record. They are
updated when a random file is opened, and are set to 0 (zero) when the file
is to be closed}

DIM RandomHandle&(MAXRANDOMFILES)
DIM RandomBuffer&(MAXRANDOMFILES)
DIM RandomRecLen&(MAXRANDOMFILES)
DIM RandomName$(MAXRANDOMFILES)
{
*** Declaration of the used subs ***
}
DECLARE SUB OpenRandomFile(R_Fnr&, R_Name$, R_Buffer&, R_RecLen&)
DECLARE SUB CloseRandomFile(R_Fnr&)
DECLARE SUB GetRandomRecord(R_Fnr&, R_Rec&)
DECLARE SUB PutRandomRecord(R_Fnr&, R_Rec&)
DECLARE SUB CloseAllRandomFiles
DECLARE SUB RandomSeek(R_Fnr&, R_Pos&)
{
*** The subs ***
}
SUB OpenRandomFile(R_Fnr&, R_Name$, R_Buffer&, R_RecLen&)
  {Opens a random access file. You have to supply the following arguments:

    R_Fnr&:       The file number
    R_Name$:      The file name
    R_Buffer&:    The address of the buffer. It is recommended that you use
                  a fixed length string or a structure for an easy access to
                  the data the buffer contains. (Example: string a$ size 200)
                  I suppose that the buffer *must* be in chip memory because
                  the "dos.library" functions use the co-processors.
    R_RecLen&:    The length of the buffer in bytes. Use the SIZEOF function
                  of ACE to get the length of a variable or structure.

   The file will be opened and the arrays (see above) will be updated.}
  SHARED RandomHandle&, RandomBuffer&, RandomRecLen&, RandomName$
  SHARED CBRFERR_OPEN$, CBRFERR_NUMBER$, CBRFERR_BUFFER$
  IF R_Fnr& <= MAXRANDOMFILES THEN
    IF RandomHandle&(R_Fnr&) <> 0 THEN
      CloseRandomFile(R_Fnr&)
    END IF
    fh&=_Open(SADD(R_Name$), 1004)
    IF fh& <> 0 THEN
      IF (R_Buffer& * R_RecLen&) > 0 THEN
        RandomHandle&(R_Fnr&) = fh&
        RandomBuffer&(R_Fnr&) = R_Buffer&
        RandomRecLen&(R_Fnr&) = R_RecLen&
        RandomName$(R_Fnr&) = R_Name$
      ELSE
        PRINT CBRFERR_BUFFER$
        CloseAllRandomFiles: STOP
      END IF
    ELSE
      PRINT CBRFERR_OPEN$
      CloseAllRandomFiles: STOP
    END IF
  ELSE
    PRINT CBRFERR_NUMBER$
    CloseAllRandomFiles: STOP
  END IF
END SUB

SUB CloseRandomFile(R_Fnr&)
  {Closes random access file <R_Fnr&> and clears the array contents.}
  SHARED RandomHandle&, RandomBuffer&, RandomRecLen&, RandomName$
  SHARED CBRFERR_NUMBER$
  IF R_Fnr& <= MAXRANDOMFILES THEN
    IF RandomHandle&(R_Fnr&) <> 0 THEN
      _Close(RandomHandle&(R_Fnr&))
    END IF
    RandomHandle&(R_Fnr&) = 0
    RandomBuffer&(R_Fnr&) = 0
    RandomRecLen&(R_Fnr&) = 0
    RandomName$(R_Fnr&) = ""
  ELSE
    PRINT CBRFERR_NUMBER$: STOP
  END IF
END SUB

SUB GetRandomRecord(R_Fnr&, R_Rec&)
  {Tries to read record <R_Rec&> of random acces file <R_Fnr&>.
   Record 0 (zero) is the first one.}
  SHARED RandomHandle&, RandomBuffer&, RandomRecLen&
  SHARED CBRFERR_NUMBER$, CBRFERR_NOTOPEN$, CBRFERR_READ$, CBRFERR_READEND$
  IF R_Fnr& <= MAXRANDOMFILES THEN
    IF RandomHandle&(R_Fnr&) <> 0 THEN
      RandomSeek(R_Fnr&, (R_Rec& * RandomRecLen&(R_Fnr&)))
      dummy&=_Read(RandomHandle&(R_Fnr&), RandomBuffer&(R_Fnr&), RandomRecLen&(R_Fnr&))
      IF dummy& < RandomRecLen&(R_Fnr&) THEN
        IF dummy& = 0 THEN
          PRINT CBRFERR_READEND$
        ELSE
          PRINT CBRFERR_READ$
        END IF
        CloseAllRandomFiles: STOP
      END IF
    ELSE
      PRINT CBRFERR_NOTOPEN$
      CloseAllRandomFiles: STOP
    END IF
  ELSE
    PRINT CBRFERR_NUMBER$
    CloseAllRandomFiles: STOP
  END IF
END SUB

SUB PutRandomRecord(R_Fnr&, R_Rec&)
  {Tries to write record <R_Rec&> of random acces file <R_Fnr&>.
   Record 0 (zero) is the first one.}
  SHARED RandomHandle&, RandomBuffer&, RandomRecLen&
  SHARED CBRFERR_NUMBER$, CBRFERR_NOTOPEN$, CBRFERR_WRITE$
  IF R_Fnr& <= MAXRANDOMFILES THEN
    IF RandomHandle&(R_Fnr&) <> 0 THEN
      RandomSeek(R_Fnr&, (R_Rec& * RandomRecLen&(R_Fnr&)))
      dummy&=_Write(RandomHandle&(R_Fnr&), RandomBuffer&(R_Fnr&), RandomRecLen&(R_Fnr&))
      IF dummy& < RandomRecLen&(R_Fnr&) THEN
        PRINT CBRFERR_WRITE$
        CloseAllRandomFiles: STOP
      END IF
    ELSE
      PRINT CBRFERR_NOTOPEN$
      CloseAllRandomFiles: STOP
    END IF
  ELSE
    PRINT CBRFERR_NUMBER$
    CloseAllRandomFiles: STOP
  END IF
END SUB

SUB CloseAllRandomFiles
  FOR t& = 0 TO MAXRANDOMFILES
    CloseRandomFile(t&)
  NEXT t&
END SUB

SUB RandomSeek(R_Fnr&, R_Pos&)
  {Used to avoid seek errors.

   The file has to be closed before seeking to the desired position, so
   I need the file name to be able to open it again}
  SHARED RandomHandle&, RandomName$
  SHARED CBRFERR_SEEKNEG$
  _Close(RandomHandle&(R_Fnr&))
  RandomHandle&(R_Fnr&) = _Open(SADD(RandomName$(R_Fnr&)), 1004)
  IF R_Pos& <> 0 THEN
    IF R_Pos& < 0 THEN
      PRINT CBRFERR_SEEKNEG$
      CloseAllRandomFiles: STOP
    ELSE
      dummy& = Seek(RandomHandle&(R_Fnr&), R_Pos&, (-1))
    END IF
  END IF
END SUB

{End of CB_RandomFiles.h}
