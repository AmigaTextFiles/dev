-> hashing module

OPT MODULE

EXPORT CONST HASH_NORMAL   = 211,
             HASH_MEDIUM   = 941,
             HASH_HEAVY    = 3911,
             HASH_HEAVIER  = 16267

EXPORT OBJECT hashtable PRIVATE
  size,entries:PTR TO LONG
ENDOBJECT

EXPORT OBJECT hashlink PRIVATE
  next, data, len
ENDOBJECT

PROC hashtable(tablesize) OF hashtable          -> constructeur
  DEF table:PTR TO LONG
  self.entries:=NEW table[tablesize]
  self.size:=tablesize
ENDPROC

PROC end() OF hashtable                         -> destructeur
  DEF p:PTR TO LONG
  p:=self.entries
  END p[self.size]
ENDPROC

/* coupe les données, puis les essaie de trouver leur entrée.
   retourne les hashlink, hashvalue */

PROC find(data,len) OF hashtable
  DEF e,s
  e:=self.entries
  s:=self.size
  MOVEM.L D3-D7,-(A7)
  MOVE.L data,D6        -> D6=data
  MOVE.L e,A1           -> A1=table
  MOVE.L s,D3           -> D3=tablesize
  MOVEQ  #0,D1          -> D1=hashvalue
  MOVEQ  #0,D0          -> D0=hashlink
  MOVE.L len,D4         -> D4=len
  BEQ.S  done
  MOVE.L D4,D5
  MOVE.L D6,A2
  SUBQ.L #1,D5
loop:
  LSL.W  #4,D1
  ADD.B  (A2)+,D1
  DBRA   D5,loop
  DIVU   D3,D1
  SWAP   D1
  EXT.L  D1
  MOVE.L A1,A2          -> maintenant cherche les entrées
  MOVE.L D1,D5
  LSL.L  #2,D5
  ADD.L  D5,A2          -> A2 pointe sur le spot dans la table
findd:
  MOVE.L (A2),D5        -> pointe sur le prochain
  BEQ.S  done
  MOVE.L D5,A2
  CMP.L  8(A2),D4       -> si la longueur est inégale, pas de problême
  BNE.S  findd
  MOVE.L 4(A2),A0       -> prend les pointeurs dans les 2 zones
  MOVE.L D6,A3
  MOVE.L D4,D5
  SUBQ.L #1,D5
compare:                -> compare bytes à bytes
  CMPM.B (A0)+,(A3)+
  BNE.S  findd
  DBRA   D5,compare
  MOVE.L A2,D0          -> cherche l'entrée
done:
  MOVEM.L (A7)+,D3-D7
ENDPROC D0

-> ajoute un nouveau hashlink

PROC add(link:PTR TO hashlink,hashvalue,data,len) OF hashtable
  link.next:=self.entries[hashvalue]
  link.data:=data
  link.len:=len
  self.entries[hashvalue]:=link
ENDPROC

PROC iterate(do_proc) OF hashtable
  DEF a,n,p:PTR TO hashlink, depth, r=0, num=0, table:PTR TO LONG
  n:=self.size
  table:=self.entries
  FOR a:=1 TO n
    p:=table[]++
    depth:=1
    WHILE p
      r:=r+do_proc(p, depth++)
      num++
      p:=p.next
    ENDWHILE
  ENDFOR
ENDPROC r,num

PROC calc_hash_spread() OF hashtable
  DEF idepth,num
  idepth,num:=self.iterate({calcspread})
ENDPROC IF num THEN !idepth/num ELSE 0.0

PROC calcspread(h,depth) IS depth
