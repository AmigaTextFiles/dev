MODULE  'oomodules/file/textfile/programSource/eSource/eComment'

PROC main()
DEF line


  testLine('just a line')
  testLine('just a->nother line')
  testLine('just a line')
  testLine('jus/*t a line')
  testLine('just */a line')
  testLine('ju/*   ->st a line')
  testLine('jus/*   */   ->  /*t a line')
  testLine('jus*/ /*    t a */li/*ne')

ENDPROC

PROC testLine(line)
DEF l

  WriteF('Line to test: \a\s\a\n', line)

  l := stripCommentFromLine(line)

  WriteF('Result: \a\s\a\n', l)

  Dispose(l)
ENDPROC
