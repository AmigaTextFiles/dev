5 'maybe this terminal prog works. off of Delphi 11/10/85.

10 open "O",#1,"ser:": print #1, " " : close #1

20 get a$: if a$="" then 60

40 ?a$;: if a$=chr$(13) then ?

50 gosub 70

60 gosub 90:goto 20

70 td=asc(a$): poke_w &hdff030,td+256: return

90 a=peek_w (&hdff018) and 127: if a=b then return

100 ?chr$(a);: if a=13 then ?

110 b=a: return

