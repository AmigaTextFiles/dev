-> dd_debugtest.e - © 1994-1995 by Digital Disturbance. Freeware.
-> Programmed by Leon Woestenberg (Email: leon@stack.urc.tue.nl)

OPT PREPROCESS

MODULE 'tools/debug'

-> MODULE '*dd_debugon'
MODULE '*dd_debugoff'

PROC main()
  -> only compiled if you use dd_debugon
  KPUTSTR('serial debugging information\n')
ENDPROC


