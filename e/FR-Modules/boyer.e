/*Okay. Here's the slow E port of boyerm.c - It's been stripped of the
non-essential routines and has a few features hard-coded (laziness, I know :)
Basically it searches my Aminet catalogue for Toolmanager2.0 (there's only
one entry) using Boyer-Moore string search. I compiled practically the same
code in C format (of coz) using SAS/C v6.3 and the results were something
like 30secs for SAS/C and 60 secs for E.

Any help much appreciated.

Son Le

PS. Another idea would be to include a set of standard functions with E for
basic functions like atoi, islower, etc. And also about the .o files, how
about mimicking c.o with e.o?*/

/* boyerm - find lines containing given constant string       */
/* A. Kotanski, 1989                                          */
/* For explanation of the method see the following articles : */
/* R.S.Boyer, J.S. Moore, "A fast string search algorithm"    */
/*                        Comm. ACM 20, 762-772 (1977)        */
/* D.E.Knuth, J.H.Morris and V.B.Pratt                        */
/*                        "Fast pattern matching in strings"  */
/*                        SIAM J. Computing, 6, 323-350 (1977)*/

/* InStr() much faster than boyermatch()
   after profiling:

   InStr()=0.353 ms
   boyermatch()=0.637 ms

   Dunno how to optimize boyermatch
*/

OPT MODULE
OPT PREPROCESS

CONST UPPER=255

OBJECT objboyer
  patlen
  delta0
  delta2
  pat
ENDOBJECT

#define MAX(a,b) (IF a>b THEN a ELSE b)
#define MIN(a,b) (IF a>b THEN b ELSE a)

EXPORT PROC boyerfrom(search)
DEF o:PTR TO objboyer,i,t,patlen,delta0,delta2,pat,f
  NEW o
  pat:=NewR(patlen:=StrLen(search)+1)
  AstrCopy(pat,search,ALL)
  delta0:=NewR(128)
  FOR i:=0 TO 127 DO delta0[i]:=patlen
  FOR i:=0 TO patlen-1 DO delta0[pat[i]]:=patlen-i-1
  delta0[pat[patlen-1]]:=UPPER
  delta2:=NewR(patlen)
  FOR i:=0 TO patlen-1 DO delta2[i]:=2*patlen-i-1
  i:=patlen-1
  t:=patlen
  f:=NewR(patlen)
  WHILE i>=0
    f[i]:=t
    WHILE (t<patlen) AND (pat[i]<>pat[t])
      delta2[t]:=MIN(delta2[t],patlen-i-1)
      t:=f[t]
    ENDWHILE
    t--
    i--
  ENDWHILE
  FOR i:=0 TO t DO delta2[i]:=MIN(delta2[i],patlen+t-i)
  o.delta0:=delta0
  o.delta2:=delta2
  o.pat:=pat
  o.patlen:=patlen
  Dispose(f)
ENDPROC o

EXPORT PROC boyermatch(o,string)
DEF obj:PTR TO objboyer,i,j,patlen,delta0,delta2,pat,str
   obj:=o
   str:=string
   patlen:=obj.patlen
   delta0:=obj.delta0
   delta2:=obj.delta2
   pat:=obj.pat
   IF (i:=patlen-1)>=(j:=StrLen(str)) THEN RETURN 0
   LOOP
     WHILE (i:=i+delta0[str[i]])<j DO NOP
     IF i<UPPER THEN RETURN 0
     i:=i-(UPPER+1)
     IF (j:=patlen-2)<0 THEN RETURN i+2
     WHILE str[i]=pat[j]
       i--
       IF j--<0 THEN RETURN i+2
     ENDWHILE
     IF str[i]=pat[patlen-1]
       i:=i+delta2[j]
     ELSE
       i:=i+MAX(delta0[str[i]],delta2[j])
     ENDIF
   ENDLOOP
ENDPROC

EXPORT PROC endboyer(o)
DEF obj:PTR TO objboyer
  obj:=o
  Dispose(obj.pat)
  Dispose(obj.delta0)
  Dispose(obj.delta2)
  END obj
ENDPROC
