/* Justify.rexx - justify selected-block or current line in EE at column 80,
   or column supplied on command line.
*/

ADDRESS 'EE.0'
OPTIONS RESULTS

PARSE ARG rightMargin .
IF rightMargin<=0 THEN rightMargin=80

LockWindow

/* Get block-dimensions; if no block selected, use current line only. */
?BlockDimensions; blockDimensions=RESULT
PARSE VALUE blockDimensions WITH line dummy lastLine dummy .
IF line=0 THEN DO
  ?line; line=RESULT; lastLine=RESULT
END
CancelBlock

beginLine=line
endLine=lastLine
GotoLine beginLine

/* Save settings for restoral, then turn on Insert and turn off Justify. */
?InsertMode;  insertState =RESULT;  IF insertState =0 THEN InsertMode
?Justify;     justifyState=RESULT;  IF justifyState=1 THEN Justify

DO endLine-beginLine+1
  /* While line is longer than right margin... */
  ?Length; length=RESULT
  DO WHILE length>rightMargin
    /* Look for a space to break line... */
    GotoColumn rightMargin+1
    column=rightMargin+1
    DO WHILE column>1
      GetChar; char=RESULT
      IF char=' ' THEN DO
        /* Eat spaces, split line, then continue. */
        DO WHILE char=' ' & column<=length
          DeleteChar
          GetChar; char=RESULT
          ?Length; length=RESULT
        END
        IF column<length THEN SplitLine
        ?Length; length=RESULT
        LEAVE
       END
      ELSE DO
        CursorLeft
        column=column-1
      END
    END
    /* If no spaces found, split line at right margin. */
    IF column=1 THEN DO
      GotoColumn rightMargin+1
      SplitLine
      ?Length; length=RESULT
    END
  END
  CursorDown
END


/* Restore window settings and exit. */
IF insertState =0 THEN InsertMode
IF justifyState=0 THEN Justify
UnlockWindow
EXIT 0
