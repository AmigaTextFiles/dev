MODULE '*dd_locale_messages'

PROC main()
  DEF msg:PTR TO localemessages
  NEW msg.new()
  PrintF('\s\n',msg.getString(1))
  END msg
ENDPROC
