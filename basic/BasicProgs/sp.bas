0     for x=1 to 5 step 2
1     if x=1 or x=2 then x$="right"
2     if x=3 or x=4 then x$="left"
3     if x=5 then x$="CENTER"
10    a%(0)=200:rem express 65-320
11    a%(1)=0:rem hum/mon 0/1U
12    a%(2)=165:rem speed 1-400
13    a%(3)=0:rem saprano/falceto
14    a%(4)=23400:rem freq 15000-28000
15    a%(5)=64:rem vol. 1-64
16    a%(6)=x
17    a%(7)=0
18    a%(8)=0
20    goto 80
80    a$=translate$(x$)
90    i%=narrate(a$,a%())
95    ?x
100   next x
110   goto 0
