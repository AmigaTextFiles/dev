MODULE '*dd_window_instance'

PROC main()
  DEF x:PTR TO mainwindow
  DEF y:PTR TO mainwindow
  NEW x.new()
  NEW y.new()
  PrintF('window opened.\n')
  Delay(100)
  x.disable()
  PrintF('window busied.\n')
  Delay(100)
  x.enable()
  PrintF('window unbusied.\n')
  Delay(100)
  END x
  PrintF('window closed.\n')
ENDPROC
