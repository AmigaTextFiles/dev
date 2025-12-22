/* fonction test de 'hashing'

les identificateurs sont généré par 10, 100, 1000, qui sont coupé en
table de taille 1, 211, 941, 3911 et 16267. Affiché sont les nombres moyens
de StrCmp nécéssaire pour trouver n'importe lequel de ces identificateurs.

*/

MODULE 'class/hash'

RAISE "MEM" IF String()=NIL

PROC main()
  DEF heavy:PTR TO LONG,a,b,l,num:PTR TO LONG,t=NIL:PTR TO hashtable,
      c,ll,n,h,link:PTR TO hashlink,rs[10]:STRING
  heavy:=[1,HASH_NORMAL,HASH_MEDIUM,HASH_HEAVY,HASH_HEAVIER]
  num:=[10,100,1000]
  l:=genidents(1000)
  WriteF('numidents:')
  FOR b:=0 TO 2 DO WriteF('\t\d\t',num[b])
  WriteF('\ntablesize:\n')
  FOR a:=0 TO 4
    WriteF('[\d]\t\t',heavy[a])
    FOR b:=0 TO 2
      NEW t.hashtable(heavy[a])
      ll:=l
      FOR c:=1 TO num[b]
        n,h:=t.find(ll,EstrLen(ll))
        t.add(NEW link,h,ll,EstrLen(ll))
        ll:=Next(ll)
      ENDFOR
      WriteF('\s[8]\t',RealF(rs,t.calc_hash_spread(),4))
      END t
    ENDFOR
    WriteF('\n')
  ENDFOR
ENDPROC

-> génère des identificateurs au hasard

PROC genidents(n)
  DEF l=NIL,a,s[100]:STRING,x:PTR TO LONG,len,prt,b,y
  x:=['bla','burp','e_','pom','ti','dom','aap','noot','mies']
  len:=ListLen(x)
  FOR a:=1 TO n
    StrCopy(s,'')
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"a") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    prt:=Rnd(3)+1
    FOR b:=1 TO prt DO StrAdd(s,x[Rnd(len)])
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"a") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    l:=Link(StrCopy(String(EstrLen(s)),s),l)
  ENDFOR
ENDPROC l
