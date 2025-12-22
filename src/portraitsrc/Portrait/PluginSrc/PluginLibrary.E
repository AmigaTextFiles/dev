LIBRARY 'example.plugin',1,0,'plugin example 1.0 (07.07.98)' IS initplugin, cleanupplugin

PROC main()
  /* Initialise library here */
ENDPROC

PROC close()
  /* Cleanup library here */
ENDPROC

PROC initplugin()
  /* Initialise plugin here */
ENDPROC 0 -> This plugin does nothing, so return 0

PROC cleanupplugin()
  /* Cleanup plugin here */
  -> NOTE: This procedure will still be called, even if you return 0 in
  -> initplugin()
ENDPROC
