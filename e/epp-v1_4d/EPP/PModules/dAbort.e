OPT TURBO

ENUM ER_DEBUG_ABORT=999

PROC dAbort(s)
  WriteF('\n *** Debug abort:  \s\n', s)
  Raise(ER_DEBUG_ABORT)
ENDPROC
  /* dAbort */

