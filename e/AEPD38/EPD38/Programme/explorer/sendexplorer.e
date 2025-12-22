OPT MODULE

MODULE '*sendrexx'

CONST MAXLINE=256

EXPORT PROC sendExplorer(addr, obj, repPort=NIL)
  DEF s[MAXLINE]:STRING
  StringF(s, '"display $\h ''\s''"', addr, obj)
  rx_SendMsg('EXPLORER', s, repPort)
ENDPROC
