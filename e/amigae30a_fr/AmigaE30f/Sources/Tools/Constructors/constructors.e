-> module de contructeurs variés

OPT MODULE
OPT EXPORT

MODULE 'exec/lists', 'exec/nodes'

PROC newlist(lh=NIL:PTR TO lh,type=0)
  IF lh=NIL THEN lh:=NEW lh
  lh.head:=lh+4
  lh.tailpred:=lh
  lh.tail:=0
  lh.type:=0
  lh.pad:=0
ENDPROC lh

PROC newnode(ln=NIL:PTR TO ln,name=NIL,type=0,pri=0)
  IF ln=NIL THEN ln:=NEW ln
  ln.name:=name
  ln.pri:=pri
  ln.type:=type
ENDPROC ln
