MODULE 'tools/ctype'

PROC main()
  WriteF('\d \d \d\n',islower(tolower("A")),islower(toupper("a")),isalnum("+"))
ENDPROC
