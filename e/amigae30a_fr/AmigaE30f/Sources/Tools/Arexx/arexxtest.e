-> Module test arexx, la bonne façon

MODULE 'tools/arexx'

PROC main()
  rx_HandleAll({process},'AREXXTESTPORT')
ENDPROC

PROC process(s)
  WriteF('Message reçu "\s" d'Arexx!\n',s)
ENDPROC StrCmp(s,'quit'),0,'résultat!'
