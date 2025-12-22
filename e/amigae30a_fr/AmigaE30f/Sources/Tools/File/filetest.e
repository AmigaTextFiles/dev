-> test des fichiers

MODULE 'tools/file'

PROC main() HANDLE
  DEF m,l,n,list,x,y=1
  m,l:=readfile(arg)
  WriteF('Le fichier a \d lignes:\n\n',n:=countstrings(m,l))
  list:=stringsinfile(m,l,n)
  ForAll({x},list,`WriteF('\d\t\s\n',y++,x))
EXCEPT
  WriteF('exception: "\s", info: "\s"\n',[exception,0],IF exceptioninfo THEN exceptioninfo ELSE '')
ENDPROC
