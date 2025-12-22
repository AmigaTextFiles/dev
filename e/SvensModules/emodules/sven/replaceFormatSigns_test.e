MODULE '*replaceFormatSigns'

PROC main() HANDLE
DEF estri[256]:STRING

  StrCopy(estri,'It\\as our \\qtest\\q-string\\nthe \\q\\\\\\q IS necessary because E does the same job.')
  WriteF('Original: "\s"\n',estri)
  
  replaceFormatSigns(estri)
  WriteF('Modified: "\s"\n',estri)

EXCEPT DO


  IF exception
    WriteF('\n\nError\n')
  ENDIF

ENDPROC

