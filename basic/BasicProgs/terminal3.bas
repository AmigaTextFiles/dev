100   rem Term3.bas by K.L. Colclasure
110   rem Written 14 Nov 85
115   rem Set baud rate in Preferences
120   rem 110 or 300 baud only!
200   open "o",#1,"ser:": print #1, " ": close #1
300   get key$: if key$ = "" then 320
310   gosub 400
320   gosub 450: goto 300
400   key% = asc(key$): poke_w &hdff030,key%+256: return
450   char% = peek_w(&hdff018)
460   if (char% and 16384) = 0 then return
470   char$ = chr$(char% and 127): poke &hdff09c,8
480   print char$;: return
