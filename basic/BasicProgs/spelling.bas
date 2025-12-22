10    ' title
20    screen 0,4,0:scnclr:print " "
30    rgb 0,0,0,0:rgb 1,0,0,0:rgb 2,15,0,0:rgb 3,15,10,0:rgb 4,0,0,0:rgb 15,0,0,0
40    peno 4:box(68,6;240,166),0:print at (11,9);"Created exclusively";at (19,11);"for";at (12,13);"Slipped Disk Inc."
50    pena 0:box(14,14;153,40),1:print at (4,4);"S P E L L I N G"
60    box(166,136;288,158),1:print at (23,19);"Robert Sawdey"
70    pena 2:paint(95,50),1:rgb 4,15,15,2:pena 3:paint(16,16),1:paint(170,140),1:sleep(1000000)*5
80    for j%=0 to 15:for i%=2 to 4:ask rgb i%,r%,g%,b%
90    if r%>0 then r%=r%-1
100   if g%>0 then g%=g%-1
110   if b%>0 then b%=b%-1
120   rgb i%,r%,g%,b%:sleep(12000):next i%:next j%
130   '
140   '     setup screen & stripes
150   '
160   rgb 0,10,0,12:' screen color
170   rgb 1,15,15,10:'  text color
180   rgb 2,15,10,15:' border color
190   rgb 3,15,0,15
200   rgb 4,15,0,10
210   rgb 5,15,0,5
220   rgb 6,15,0,0
230   rgb 7,10,0,5
240   rgb 8,5,0,10
250   rgb 9,0,0,15
260   rgb 10,0,5,10
270   rgb 11,0,10,5
280   rgb 12,5,15,5
290   rgb 13,10,15,5
300   rgb 14,15,15,5
310   rgb 15,15,15,10
320   scnclr
330   for i%=2 to 15
340   pena i%
350   box(9,(i%*12)-15;319,(i%*12)-3),1
360   next i%
370   peno 2 :'  outline pen color
380   pena 0 :'   foreground pen
390   penb 1 :'   background pen
400   box(45,82;187,116),1
410   '
420   '    setup voice parameters
430   '
440   a%(0)=200   :' pitch(65-320)
450   a%(1)=0     :' inflect(0-1)
460   a%(2)=120   :' rate(40-400)
470   a%(3)=1     :' 0=male 1=fem
480   a%(4)=25000 :'tuning 5k-28k
490   a%(5)=64    :' volume(0-64)
500   a%(6)=10    :'channel(0-11)
510   a%(7)=1     :' mode(0-1)
520   a%(8)=0     :' control(0-2)
530   '
540   ' student name & word list
550   '
560   b$(0%)="student"
570   b$(1%)="run"
580   b$(2%)="us"
590   b$(3%)="bus"
600   b$(4%)="rub"
610   b$(5%)="sun"
620   b$(6%)="tug"
630   b$(7%)="cut"
640   b$(8%)="bug"
650   b$(9%)="cup"
660   b$(10%)="rug"
670   '
680   '    intro
690   '
700   print" Spelling Quiz: Type <return> to quit"
710   a$="Please type your name.":gosub 880
720   print at (8,13);"";:input;b$(0)
730   if b$(0)="" then goto 1110
740   a$="Hello "+b$(0)+". Lets spell.":l%=0:gosub 880
750   '
760   '     main test loop
770   '
780   l%=l%+1
790   if l%>10 then goto 960
800   a$="Please type. "+b$(l%)+"."
810   gosub 880
820   print at (8,13); "               "
830   print at (8,13); "";:input; a$
840   if a$="" then goto 1150
850   if a$=b$(l%) then a$="you got it right.":gosub 880:gosub 1010:goto 780
860   if a$<>b$(l%) then a$="try again.":gosub 880:goto 790
870   '
880   '  speakit
890   '
900   b$=translate$(a$)
910   i%=narrate(b$,a%())
920   return
930   '
940   '  congrats
950   '
960   gosub 1010:a$="now you are done.":gosub 900
970   a$="you have spelled all ten words right.":gosub 900:goto 1150
980   '
990   ' roll colors
1000  '
1010  for j%=1 to 16
1020  ask rgb 15,rr%,rg%,rb%
1030  for i%=14 to 0 step -1
1040  ask rgb i%,r%,g%,b%
1050  rgb i%+1,r%,g%,b%
1060  next i%
1070  rgb 0,rr%,rg%,rb%
1080  sleep(10000)
1090  next j%
1100  return
1110  '
1120  ' Clean up & go home
1130  '
1140  ' reset rgb
1150  rgb 0,6,9,15:rgb 1,0,0,0:rgb 2,15,15,15:rgb 3,15,9,10:rgb 4,14,3,0:rgb 5,15,11,0:rgb 6,15,15,2:rgb 7,11,15,0
1160  rgb 8,5,13,0:rgb 9,0,14,13:rgb 10,7,13,15:rgb 11,12,0,14:rgb 12,15,2,14:rgb 13,15,13,11:rgb 14,12,9,8:rgb 15,11,11,11
1170  scnclr:print " "
