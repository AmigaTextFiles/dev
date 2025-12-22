-> constructortest.e

MODULE 'tools/constructors'

PROC main() HANDLE
  DEF list,a
  list:=newlist()
  FOR a:=1 TO 10 DO Enqueue(list,newnode(NIL,'test bête de nodes'+a,0,Rnd(100)))
EXCEPT
  WriteF('no mem!\n')
ENDPROC
