10    a%(0)=110 : a%(1)=0 : a%(2)=150
11    a%(3)=0 : a%(4)=22200 : a%(5)=64
12    a%(6)=10 : a%(7)=0 : a%(8)=0
20    input "Male or female (m/f)";a$
30    if a$="m" then 80
40    if a$<>"f" then 20
50    a%(0%)=200
60    a%(3%)=1%
70    a%(4%)=28000
80    a$ = translate$("hello")
90    ? narrate(a$,a%())
100   for i= 1 to 100
110   next i
120   input "Enter speech";a$
130   if a$="" then 10
140   b$=translate$(a$)
150   i%=narrate(b$,a%())
160   goto 120
