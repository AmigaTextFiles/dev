OPT MODULE, EXPORT, REG = 5

PROC insertinlist(listvar:PTR TO LONG, liststring)
  DEF breakpos, count, tempstr[32]:STRING

  count := ListLen(listvar)
  breakpos := InStr(liststring, '/')            -> Find end of first value
  WHILE (count-- >= 0)                          -> While we are not at the end of the list
    IF StrLen(liststring) > 0                   -> If we have a string
      StrCopy(tempstr, liststring, breakpos)    -> Copy the variable to the temp string
      listvar[] := Val(tempstr)                 -> Make the list item equal to our variable
      liststring := liststring + breakpos + 1   -> Move to the next variable in the string
      breakpos := InStr(liststring, '/')        -> Find the end of the next variable
    ENDIF
    listvar[]++
  ENDWHILE
ENDPROC

PROC mergelist2str(deststr:PTR TO CHAR, listvar:PTR TO LONG, hex = FALSE)
  DEF tempstr[20]:STRING, count

  count := ListLen(listvar)
  StringF(deststr, IF hex THEN '$\h' ELSE '\d', listvar[]++)

  WHILE count-- >= 1
    /* add current number and increase list position */
    StrAdd(deststr, StringF(tempstr, IF hex THEN '/$\h' ELSE '/\d', listvar[]++))
  ENDWHILE
ENDPROC deststr
