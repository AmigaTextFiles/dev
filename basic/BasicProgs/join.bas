100   input a: ? a
110   a$ = mks$(a)
120   for i = 1 to 4
130   b$ = mid$(a$,i,1)
131   ? hex$(asc(b$))
140   next i
200   goto 100
