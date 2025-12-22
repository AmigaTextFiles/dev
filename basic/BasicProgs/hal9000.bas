5     rem *** HAL 9000 version 1.0
10    a%(0)=110 : a%(1)=0 : a%(2)=150
11    a%(3)=0 : a%(4)=22200 : a%(5)=64
12    a%(6)=10 : a%(7)=0 : a%(8)=0
20    input "Male or female (m/f)";a$
30    if a$="m" then 80
40    if a$="f" then 50
42    if a$<>"v" then 20
44    print"value 0 (";a%(0%);") =";: input"";a%(0%)
46    print"value 3 (";a%(3%);") =";: input"";a%(3%)
48    print"value 4 (";a%(4%);") =";: input"";a%(4%)
49    goto 80
50    a%(0%)=200
60    a%(3%)=1%
70    a%(4%)=25000
80    a$ = translate$("hello")
90    ? narrate(a$,a%())
100   for i= 1 to 100
110   next i
120   read a$,a%(4),a%(2)
130   if a$="" then 10
140   b$=translate$(a$)
150   i%=narrate(b$,a%())
160   goto 120
200   data good afternoon my friends., 20000, 140
210   data I am an HAL 9 thousand computer., 17000,120
220   data let me sing you a song., 15000,100
230   data it is called Daisy., 13000,80
240   data Daisy; Daisy: Tell me your answer true., 10000,60
250   data I am crazy all for the love of you., 7000,50
260   data I can feel it; dave. i can feel it., 5000,50
