-> protracker player

MODULE 'tools/file', 'tools/pt'

PROC main() HANDLE
  DEF m,l
  WriteF('Protracker player en E (En ce moment: "\s", Ctrl-C pour arrêter).\n',arg)
  m,l:=readfile(arg,0,2)
  pt_play(m)
  REPEAT
    Delay(10)      -> au lieu de ça, on peut faire quelque chose d'utile
  UNTIL CtrlC()
  pt_stop()
EXCEPT DO
  IF exception THEN WriteF('Exception: "\s", Info: "\s"\n',[exception,0],IF exceptioninfo THEN exceptioninfo ELSE '')
ENDPROC
