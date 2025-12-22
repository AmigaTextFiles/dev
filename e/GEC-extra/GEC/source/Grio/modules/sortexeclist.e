

OPT MODULE 
OPT REG=5


->#define GEC

#ifndef GEC
MODULE 'grio/str/stricmp'
#define StriCmp stricmp
#endif

MODULE 'grio/qsort',
       'exec/nodes','exec/lists'


EXPORT PROC sortExecList(lh:PTR TO lh)
DEF ln:PTR TO ln,size=0
IF lh
   ln:=lh.head
   WHILE ln:=ln.succ DO INC size
   IF (1 < size)
      qsort(lh,0,size-1,{comp},{swap})
   ENDIF
ENDIF
ENDPROC


PROC get(lh:PTR TO lh,z,w)
DEF ln1:PTR TO ln,ln2:PTR TO ln,x,y,s
ln1:=lh.head
IF z<w
   x:=z;y:=w-z;s:=0
ELSE
   x:=w;y:=z-w;s:=1
ENDIF
WHILE x>0
  ln1:=ln1.succ
  DEC x
ENDWHILE
ln2:=ln1
WHILE y>0
  ln2:=ln2.succ
  DEC y
ENDWHILE
IF s
   s:=ln2
   ln2:=ln1
   ln1:=s
ENDIF
ENDPROC ln1,ln2


PROC comp(lh:PTR TO lh,x,y)
DEF l1:PTR TO ln,l2:PTR TO ln
l1,l2:=get(lh,x,y)
StriCmp(l1.name,l2.name,ALL)
MOVE.L D1,D0
ENDPROC D0

PROC swap(lh:PTR TO lh,x,y)
DEF l1:PTR TO ln,l2:PTR TO ln,tmp:PTR TO ln
l1,l2:=get(lh,x,y)
IF tmp:=l1.pred THEN tmp.succ:=l2
l1.pred:=l2.pred   
l2.pred:=tmp
IF tmp:=l1.pred THEN tmp.succ:=l1
IF tmp:=l1.succ THEN tmp.pred:=l2
l1.succ:=l2.succ
l2.succ:=tmp
IF tmp:=l1.succ THEN tmp.pred:=l1
ENDPROC




