MODULE 'dos/dos'
MODULE 'grio/qsort','grio/link','grio/str/stricmp'

ENUM ERR_NOMEM=1,ERR_BREAK

RAISE ERR_NOMEM IF String()=NIL
RAISE ERR_BREAK IF CtrlC()<>0

DEF oldd,oldf,lend,lenf,based,basef

PROC main() HANDLE
DEF lock,fib:fileinfoblock
oldd:=oldf:=0
lend:=lenf:=-1
lock:=Lock(arg,SHARED_LOCK)
IF lock=NIL THEN RETURN
Examine(lock,fib)
WHILE ExNext(lock,fib)
   CtrlC()
   str(fib.filename,fib.size,fib.direntrytype>0)
ENDWHILE
UnLock(lock)
qsort({based},0,lend,{comp},{swap})
qsort({basef},0,lenf,{comp},{swap})
show(based)
show(basef)
EXCEPT
SELECT exception
  CASE ERR_NOMEM
     WriteF('no memory\n')
  CASE ERR_BREAK
     WriteF('***break\n')
ENDSELECT
DisposeLink(based)
DisposeLink(basef)
ENDPROC

PROC show(base)
REPEAT
  CtrlC()
  WriteF('\s\n',base)
UNTIL (base:=Next(base))=0
ENDPROC


PROC str(name,size,dir)
DEF s
s:=String(100)
StringF(s,IF dir THEN '\l\s[30] (dir)' ELSE '\l\s[30] \d[8]',name,size)
IF dir
   Link(oldd,s)
   oldd:=s
   IF -1=lend THEN based:=s
   INC lend
ELSE
   Link(oldf,s)
   oldf:=s
   IF -1=lenf THEN basef:=s
   INC lenf
ENDIF
ENDPROC

PROC swap(baseptr,p1,p2) IS gSwapItems(baseptr,p1,p2)

PROC comp(baseptr,p1,p2) IS stricmp(Forward(^baseptr,p1),Forward(^baseptr,p2))

