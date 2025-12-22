/*

example script for ee
load an autodoc according to the word under the cursor from a filelist which
looks like this:

funcname autodocfile [linenumber]

OpenWindow autodocs:intuition/intuition.h 42

idea and first draft by Gregor Goldbach

*/

ADDRESS 'EE.0'
OPTIONS RESULTS

ARG datname

IF datname="" THEN datname="EE:rexx/autodoc/autodoclist.ee"

IF Open(autodoclist, datname, 'R') THEN
  DO
    LockWindow
    GetWord
    funcname=RESULT
    posi=Index(funcname, '(')
    IF posi>0 THEN funcname=Left(the_word, posi-1)
    DO UNTIL (Word(the_line,1)=funcname)=1 | Eof(autodoclist)
      the_line=Readln(autodoclist)
      SAY the_line
    END
    the_file=Word(the_line,2)
    OpenNew the_file
    GotoLine Word(the_line, 3)
    UnlockWindow
  END
ELSE
  SAY 'Could not open file.'
