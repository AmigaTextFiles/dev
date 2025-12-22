10    rem read/print seq file/Earl Hamner/Nov 85
20    scnclr:print"READ SEQUENTIAL FILE"
30    print:print"Use CTRL-D to start/stop screen listing"
40    print:input"Name of seq file:";a$
50    print:input"Send to printer <y/n>";b$
60    if b$="y" then open "O",#2,"prt:"
70    open "I",#1,a$
80    while not eof (1)
90    line input #1, a$: print a$
100   if b$="y" then print #2, a$
110   wend:close #1:close #2
