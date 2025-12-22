MODULE '*helloworld'

DEF cat=NIL:PTR TO cat_helloworld

PROC main()
  NEW cat.open()

  WriteF('\s\n', cat.get(MSG_HELLO))
  WriteF('\s\n', cat.get(MSG_BYE))

  END cat
ENDPROC
