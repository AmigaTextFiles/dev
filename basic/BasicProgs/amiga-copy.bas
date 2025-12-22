1     goto 110
2     rem
3     rgb 1,15,0,0
4     print at (33,0);"Amiga Copy"
5     print at (19,3);"Courtesy of Phase 4 Distributors Inc."
10    print at (30,5);"By: ";inverse(1)"Graeme Earle"
11    print at (34,6);"Nov 25/85"
12    sp$="amiga copy by Grayem Earle   Courtessy of Phase Four Distributors Inc.!" : gosub 181
15    print at (10,8);"This is a simple utilities program for the Amiga"
16    print at (10,9);"If you are going to be using the one drive file"
17    print at (10,10);"copier I would recommend installing workbench"
18    print at (10,11);"into Ram, so you don't have to keep putting in the"
19    print at (10,12);"workbench disk all the time. Also you need to know"
20    print at (10,13);"the name of the source and destination disks.
21    print at (14,14);"You can find these out through Workbench."
22    print at (10,16);"This program has speech built into it, if you do not"
23    print at(10,17);"want the speech, hit the ";inverse(1)"S";inverse(0)" key, or hit any other key to continue"
25    rem    
30    get tk$ : if tk$ = "" then 30
33    if tk$ = "s" or tk$ = "S" then tk = 1 else tk = 0
35    rem
37    rem
39    rem
89    sleep 1000000
99    goto 150
100   rem setup error routine
110   screen 1,3,4
120   rgb 0,0,0,0
130   rgb 1,0,0,0 
140   rgb 2,15,15,14
145   goto 2
150   on error goto 190
160   d$ = "df0:"
165   ch$ = "cd " + d$
167   shell ch$
170   dim a$(100),cop$(100),del$(100)
180   goto 790
181   if tk = 1 then return
182   tt$ = translate$(sp$)
183   ttt% = narrate(tt$)
184   return
190   rem error comes here
200   if err = 53 and erl = 230 then close #1
210   if err = 53 and erl = 230 then shell "dir >ddirfile" : resume 220
215   scnclr : print "System Error" : sleep 1000000: resume 790
220   rem open directory as a file
230   open "I", #1, "ddirfile"
240   i = 1
250   while not eof(1)
260   input #1,n$
270   gosub 350
280   i = i + 1
290   if mid$(n$,34) = "" then 320
300   a$(i) = mid$(n$,34)
310   i = i + 1
320   wend : close #1
330   ct = i - 1
340   return
350   rem check for blanks
360   sp = 0
370   for q = 1 to len(n$)
380   k = q
390   if mid$(n$,q,1) = " " then sp = sp + 1 else sp = 0
400   if sp = 3 then 420
410   next q
420   kk = q - sp : a$(i) = left$(n$,kk)
430   return
440   rem main copy part
445   rem gosub 1220
450   scnclr
459   sp$ = "file copier!" : gosub 181
460   print at (34,0);inverse(1) "File Copier"
470   print at (29,2);inverse(1)"C)";inverse(0)"opy,"
471   print at (36,2);inverse(1)"N)";inverse(0)"ext, or "
472   print at (46,2);inverse(1)"D)";inverse(0)"one"
479   if val(m$) = 2 then 613
480   chdir "df0:"
485   gosub 220
490   m = 0
500   i = 0 : p = 0
510   i = i + 1: if i > ct then 760
520   p = p + 1
530   print at (5,8); "                                              "
540   print at (5,8); a$(i); at (33,8); inverse(1); "c/n/d"
550   get do$ : if do$ = "" then 550
560   if i = ct then 610
570   if do$ = "n" then 510
580   if do$ = "d" then 610
590   if do$ = "c" then cop$(m+1) = a$(i) : m = m + 1 : goto 510
600   i = i - 1 : p = p - 1 : goto 550
610   if m = 0 then 760
611   if val(m$) = 3 then 639
612   if val(m$) = 2 then 620
613   shell "makedir ram:z" : sp$ = "one drive file copier!" : gosub 181
614   print at (29,0) ; inverse(1) "One drive file copier" : sp$ = "type in
615   print at (5,5); "Type in the name of your source disk"
616   print at (21,6);"                             "
617   print at (5,6); "Use the format ";inverse(1) "name: ";
618   input ds$ : l = len(ds$) : if mid$(ds$,l) <> ":" then 616
619   shell "cd " + ds$ : goto 480
620   print at (5,10); "Type in the name of the destination disk"
621   print at (21,11);"                         " : sp$ = "type in the name
622   print at (5,11); "Use the format ";inverse(1) "name: ";
623   input dd$ : l = len(dd$) : if mid$(dd$,l) <> ":" then 620
624   for z = 1 to m
625   g1$ = "copy " + ds$ +cop$(z) + " ram:z"
626   g2$ = "copy ram:z/" + cop$(z) + " to " + dd$
627   shell g1$
628   shell g2$
629   g3$ = "delete ram:z/" + cop$(z)
630   shell g3$
637   next z
638   shell "delete " + ds$ + "ddirfile" : shell "delete ram:z" : goto 770
639   sp$ = "copying files." : gosub 181
640   scnclr : print at (30,0);inverse(1) "Copying Files"
641   sp$ = "insert destination disk." : gosub 181
642   print at (25,2); "Insert destination disk in drive #";v
644   sp$ = "hit the left mouse butten when ready." : gosub 181
650   print at (25,4); "Hit the left mouse button when ready"
660   ask mouse j%,k%,l%
670   if l% = 4 then 690 else 660
680   ? l%
690   for z = 1 to m
700   go$ = "copy df0:" + cop$(z) + " to df1:" + cop$(z)
710   shell go$
720   print at (5,8); "                                              "
725   sp$ = "copied okay." : gosub 181
730   print at (5,8); cop$(z); at (5,20); "copied ok"
740   sleep 100000
750   next z
760   scnclr : sp$ = "copy completed." : gosub 181
770   print at (30,20);inverse(1) "Copy Completed"
780   shell "df0:ddirfile"
790   rem main menu
795   rgb 1,15,15,0
800   scnclr
805   sp$ = "amiga utillities!" : gosub 181
810   print at (35,0);inverse(1) "Amiga Utilities"
820   print at (5,4);inverse(1) "1)";inverse(0)" Install Workbench into RAM"
830   print at (5,6);inverse(1) "2)";inverse(0)" Copy Files using one drive"
840   print at (5,8);inverse(1) "3)";inverse(0)" Copy Files using two drives"
870   print at (5,10);inverse(1) "4)";inverse(0)" Delete Files"
880   print at (5,12);inverse(1) "5)";inverse(0)" Send a file to printer"
890   print at (5,14);inverse(1) "6)";inverse(0)" Directory"
900   print at (5,16);inverse(1) "7)";inverse(0)" Exit to basic"
910   print at (35,22); inverse(1) "Type in your choice";
915   sp$ = "type in your choice please!" : gosub 181
920   get m$ : if m$ = "" then 920
925   on val(m$) goto 1030,440,440,1670,2070,1930,2240
926   if val(m$) < 1 or val(m$) > 7 then 915
1030  rem workbench into ram
1040  scnclr
1045  sp$ = "installing workbench into ram!" : gosub 181
1050  print at (25,0);inverse(1) "Installing Workbench into RAM"
1060  print at (5,5); " I would not recommend this unless you have the extra memory"
1065  sp$ = "do you want to continue on ?" : gosub 181
1070  print at (5,7); "Do you want to continue on (y/n) ";
1080  get y$ : if y$ = "" then 1080
1090  if y$ = "n" or y$ = "N" then 790
1100  if y$ = "y" or y$ = "Y" then 1120
1110  goto 1065
1120  rem do it here
1130  scnclr
1140  rem ram it
1141  shell "makedir ram:c"
1142  shell "copy c/assign ram:c"
1143  shell "copy c/cd ram:c"
1144  shell "copy c/delete ram:c"
1145  shell "copy c/makedir ram:c"
1146  shell "copy c/break ram:c"
1147  shell "copy c/copy ram:c"
1148  shell "copy c/dir ram:c"
1149  shell "copy c/failat ram:c"
1150  shell "copy c/stack ram:"
1151  shell "copy c/fault ram:c"
1152  shell "copy c/break ram:c"
1153  shell "copy c/run ram:c"
1154  shell "assign c: ram:c"
1180  scnclr
1185  sp$ = "ram disk installed!" : gosub 181
1190  print at (30,0); inverse(1) "RAM disk installed"
1200  sleep 1000000
1210  goto 790
1220  rem set current directory
1230  scnclr
1235  sp$ = "current directory is set at " + d$ : gosub 181
1240  print at (5,0); "Current directory set at ";d$
1245  sp$ = "do you wish to change the directory?" : gosub 181
1250  print at (5,5); "Do you wish to change the directory (y/n) ";
1260  get y$: if y$ = "" then 1260
1270  if y$ = "n" or y$ = "N" then sleep 1000000: return
1280  if y$ = "y" or y$ = "Y" then goto 1300
1290  goto 1250
1295  print at (5,8) ; "                                                "
1296  sp$ = "type in the new directory name" : gosub 181
1300  print at (5,8); "Type in the new directory name ";
1310  input d$
1315  if d$ = "df0:" or d$ = "DF0:" or d$ = "df1:" or d$ = "DF1:" then 1320 else 1295
1320  ch$ = "cd " + d$
1322  shell ch$
1325  sp$ = "directory changed to " + d$ : gosub 181
1330  print at (5,15); "Directory changed to ";d$
1340  sleep 1000000 : return
1670  rem delete files.......
1675  gosub 1220
1680  scnclr : sp$ = "delete files." : gosub 181
1690  print at (35,0) ;inverse(1) "Delete Files"
1700  gosub 220
1702  sp$ = "d to delete     n for next   or e to exit " : gosub 181
1705  print at (30,2);inverse(1)"D)";inverse(0)"elete,"
1707  print at (38,2);inverse(1)"N)";inverse(0)"ext, or "
1709  print at (49,2);inverse(1)"E)";inverse(0)"xit"
1720  for del = 1 to ct
1730  print at (5,8); "                                                 "
1740  print at (5,8); a$(del); at (33,8); inverse (1); "d/n/e"
1750  get y$ : if y$ = "" then goto 1750
1760  if y$ = "n" or y$ = "N" then 1890
1770  if y$ = "e" or y$ = "E" then 790
1780  if y$ = "d" or y$ = "D" then 1800
1790  goto 1750
1800  print at (5,12) ; "                                                           "
1805  sp$ = "are you sure you want to delete this file?" : gosub 181
1810  print at (5,12); "Are you sure you want to delete this file (y/n) "
1820  get y1$ : if y1$ = "" then 1820
1830  if y1$ = "n" or y$ = "N" then 1890
1840  if y1$ = "y" or y1$ = "Y" then 1860
1850  goto 1810
1860  rem do it here
1870  ff$ = "delete " + d$ + a$(del)
1880  shell ff$
1890  print at (5,12) ;"                                                       " : next del
1910  shell "delete ddirfile"
1920  goto 790
1930  rem directory
1940  scnclr
1945  sp$ = "disk directory." : gosub 181
1950  print at (35,0);inverse(1) "Disk Directory"
1955  sp$ = "type in the drive number!" : gosub 181
1960  print at (5,2) ; "Type in the drive number ie (df0: or df1:) or (e) to exit";
1970  input d1$
1980  if d1$ = "e" or d1$ = "E" then 790
1990  if d1$ = "df0:" or d1$ = "DF0:" or d1$ = "df1:" or d1$ = "DF1:" then 2010
2000  goto 1960
2005  sp$ = "directory of " + d1$ + " is " : goto 181
2010  print at (20,8) ;"Directory of ";d1$
2020  df$ = "dir " + d1$
2030  shell df$
2035  sp$ = "type any key to return to menu!" : gosub 181
2040  ? : ? "Type any key to return to menu ";
2050  get y$ : if y$ = "" then 2050
2060  goto 790
2070  rem print a file out
2080  scnclr
2085  sp$ = "send a file to the printer!" : gosub 181
2090  print at (35,0);inverse(1) "Send a file to the printer"
2100  print at (5,8); "                                                    "
2110  print at (5,5) ; "                                                          "
2120  print at (5,5) ; "Type in name of the file (e) to exit ";
2125  sp$ = "type in the name of the file or e to exit!" : gosub 181
2130  input pr$
2140  if pr$ = "e" or pr$ = "E" then 790
2145  sp$ = "are you sure you want to print this file." : gosub 181
2150  print at (5,8); "Are you sure you want to print this file (y/n)
2160  get y$ : if y$ = "" then 2160
2170  if y$ = "n" or y$ = "N" then 2100
2180  if y$ = "y" or y$ = "Y" then 2200
2190  goto 2160
2200  x$ = "copy " + pr$ + " par:" 
2210  shell x$
2220  sleep 1000000
2230  goto 790
2240  scnclr : sp$ = "we will see you later." : gosub 181
2245  end
