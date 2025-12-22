30    a$(0)="Four score and seven years ago"
40    a$(1)="our fathers brought forth, upon this continent"
50    a$(2)="a new nation, conceived in liberty"
60    a$(3)="and dedicated to the proposition"
70    a$(4)="that all people should buy amigas."
80    for i%=0% to 4%
90    b$=translate$(a$(i%))
100   x%=narrate(b$,a%())
110   next i%
120   for i= 1 to 10000
130   next i
140   goto 80
