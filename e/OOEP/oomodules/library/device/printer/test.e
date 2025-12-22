MODULE 'oomodules/library/device/printer/printer'

PROC main()
DEF drucker:PTR TO printer

  NEW drucker.new()
  drucker.write('Hallo',5)

  END drucker

ENDPROC
