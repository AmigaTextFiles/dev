/*

Test of miscellenous procs.

*/

MODULE  '*misc'

PROC main()

  testcopyLineAndStripWord('I think I should remove the PRIVATE keyword.','PRIVATE')
  testcopyLineAndStripWord('I think I should remove the 1PRIVATE2 keyword.','PRIVATE')
  testcopyLineAndStripWord('PRIVATE','PRIVATE')
  testcopyLineAndStripWord('blablalbla blurp','PRIVATE')

ENDPROC

PROC testcopyLineAndStripWord(line:PTR TO CHAR, word=NIL:PTR TO CHAR)
DEF linePtr:PTR TO CHAR

  WriteF('\n\nLine to process is \s\n', line)

  linePtr := copyLineAndStripWord(line,word)

  WriteF('results in: \s\n', linePtr)

  DisposeLink(linePtr)

ENDPROC
