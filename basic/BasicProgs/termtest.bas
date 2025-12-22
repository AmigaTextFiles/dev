1     'Demo of Abasic SSHAPE function.
2     'define a box on screen by
3     'clicking upper left and
4     'lower right limits. then
5     'draw with mouse by clicking
6     'left button and moving.
7     'you'll get the hang real quick.
50    sleep 1000000
60    crlf$ = chr$(13)+chr$(10)
100   INI$="ATS0=1"
110   atdt$="ATDT"
120   open "O",1,"SER:"
130   open "I",2,"SER:"
140   get a$
145   if a$="" then 140
147   if a$=chr$(27) then stop
150   print #1,a$;
155   print a$;
157   if a$=chr$(13) then 1000
160   goto 140
1000  stop
2000  input "what file to xfer";fi$
2003  if li$="$" then stop
2010  open "I",3,fi$
2020  while not eof(3)
2030  line input #3,li$
2040  print #1,li$
2045  print #1,chr$(13)
2050  wend
2055  close #3
2060  goto 2000
