/* compression de huffman en E

   Tout ce qu'il fait est de vous dire quel gain si vous compressiez avec
   huffman, il ne le fait pas pourle moment.

   Désolé pour les implémentations vaseuses ici et là
*/

MODULE 'tools/file'

PROC countfreq(adr,num,freq:PTR TO LONG)
  DEF a,ch,list=NIL
  FOR a:=0 TO 255 DO freq[a]:=0
  FOR a:=1 TO num
    ch:=adr[]++
    freq[ch]:=freq[ch]+1
  ENDFOR
  FOR a:=0 TO 255 DO list:=Link(c([freq[a],a]),list)
ENDPROC Link(c([]),list)

PROC c(l)
  DEF m
  IF (m:=List(ListLen(l)))=NIL THEN Raise("MEM")
  ListCopy(m,l)
ENDPROC m

PROC takelowest(list:PTR TO LONG)
  DEF l:PTR TO LONG,lf=1000000000,lp
  WHILE l:=Next(list)
    IF l[]<lf
      lf:=l[]
      lp:=list
    ENDIF
    list:=l
  ENDWHILE
  l:=Next(lp)
  Link(lp,Next(l))
ENDPROC l

PROC optimize(trees)
  DEF numtrees=256,lowest:PTR TO LONG,low:PTR TO LONG
  WHILE numtrees>1
    lowest:=takelowest(trees)
    low:=takelowest(trees)
    Link(trees,Link(c([lowest[]+low[],lowest,low]),Next(trees)))
    DEC numtrees
  ENDWHILE
ENDPROC Next(trees)

PROC writetree(tree:PTR TO LONG,off=0)
  DEF a
  IF ListLen(tree)=2
    IF off THEN FOR a:=1 TO off DO WriteF('  ')
    WriteF('[char=\d,freq=\d]\n',tree[1],tree[])
  ELSE
    writetree(tree[1],off+1)
    writetree(tree[2],off+1)
  ENDIF
ENDPROC

PROC computetree(tree:PTR TO LONG,res:PTR TO LONG,bit,depth=0)
  DEF a,b,r:PTR TO LONG,t,ar
  IF ListLen(tree)=2
    r:=36*tree[1]+res
    r[0]:=depth
    ar:=bit
    FOR a:=1 TO 8
      t:=0
      FOR b:=0 TO 31 DO t:=t+IF ar[]++ THEN Shl(1,b) ELSE 0
      r[a]:=t
    ENDFOR
  ELSE
    bit[depth]:=1
    computetree(tree[1],res,bit,depth+1)
    bit[depth]:=0
    computetree(tree[2],res,bit,depth+1)
  ENDIF
ENDPROC

PROC writebits(b:PTR TO LONG)
  DEF a,d,e
  d:=b
  FOR a:=0 TO 255
    WriteF('b=\d\td=\d\t',b-d/36,b[]++)
    FOR e:=0 TO 7 DO WriteF('\h[8]',b[]++)
    WriteF('\n')
  ENDFOR
ENDPROC

PROC crunch(adr,num)
  DEF trees, huffbits, bitarray[256]:ARRAY OF CHAR, a,freq[256]:ARRAY OF LONG,t=0
  trees:=countfreq(adr,num,freq)
  trees:=optimize(trees)
  ->writetree(trees)
  FOR a:=0 TO 255 DO bitarray[a]:=0
  computetree(trees,huffbits:=NewR(36*256),bitarray)
  ->writebits(huffbits)
  FOR a:=0 TO 255 DO t:=t+Mul(freq[a],Long(a*36+huffbits))
  WriteF('% de compressé (gain)=\d%\n',100-Div(Mul(Div(t,8),100),num))
ENDPROC

PROC main() HANDLE
  DEF m,l
  m,l:=readfile(arg)
  WriteF('Fichier compressé \s de longueur \d\n',arg,l)
  crunch(m,l)
EXCEPT
  SELECT exception
    CASE "MEM"; WriteF('Pas de Mémoire!\n')
    CASE "OPEN";  WriteF('Pas de Fichier!\n')
  ENDSELECT
ENDPROC
