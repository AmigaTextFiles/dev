5     clr:screen 0,5
6     drawmode 0
10    dim picture%(12000),regsave%(500),mandelinfo(500)
12    dim aa(10)
52    filename$="titlefractal":gosub 17060
55    flag=1:count = 50:speed%=1:gosub 25070
60    flag = 0
70    talk$=translate$("USE QUESTION MARK,FOR LIST OF COMMANDS!")
80    q%=narrate(talk$)
100   rem **** MAIN LOOP ****
110   get a$
120   if a$="D" or a$="d" then gosub 12000
140   if a$="L" or a$="l" then gosub 17000
150   if a$="S" or a$="s" then gosub 15000
160   if a$="C" or a$="c" then gosub 25000
170   if a$="Q" or a$="q" then goto 16000
180   if a$="?" or a$="/" then gosub 11000
200   if a$="M" or a$="m" then gosub 30000
500   goto 110
9999  rem **** DEFINE AREA TO MAGNIFY ****
10000 talk$ = translate$("PLACE POINTER AT THE REAL, AND, IMAGINARY CENTER!"):q% = narrate(talk$)
10002 talk$ = translate$("THEN, HOLD DOWN MOUSE BUTTUN, AND OUT LINE SECTION, TO MAGNIFY!")
10003 q%=narrate(talk$)
10005 gosub 10040
10010 ask mouse x%,y%,b%
10016 if a$<>"" then return
10020 if b% = 0 goto 10010
10030 goto 10005
10040 drawmode 2
10050 ask mouse x%,y%,b%
10055 x1%=x%:y1%=y%
10060 if b% = 0 goto 10050
10070 x2% = x1% : y2% = y1%
10080 ask mouse xx%,yy%,b%
10090 if xx% = x2% goto 10080
10092 if x%-abs(xx%-x%) < 0 or xx% > 302 then 10080
10093 if y%-(abs(xx%-x%)*.62) < 0 or y%+(abs(xx%-x%)*.62) > 186 then 10080
10095 x3%=xx%
10100 if b%=0 then 10150
10110 box (x1%,y1%;x2%,y2%)
10120 x1%=x%-abs(xx%-x%):x2%=xx%
10122 y1%=y%-(abs(xx%-x%)*.62):y2%=y%+(abs(xx%-x%)*.62)
10130 box(x1%,y1%;x2%,y2%)
10140 if b% <> 0 goto 10080
10150 drawmode 0
10155 peno 1:box(x1%,y1%;x2%,y2%)
10156 erase aa:dim aa(500)
10160 aa(1)=mandelinfo(5)+(x%*mandelinfo(7))
10170 aa(2)=(x2%-x1%)*mandelinfo(7)
10180 aa(3)=mandelinfo(6)+((186-y%)*mandelinfo(8))
10190 aa(4)=aa(2)*.77
10200 aa(5)=aa(1)-(aa(2)/2)
10210 aa(6)=aa(3)-(aa(4)/2)
10220 aa(7)=aa(2)/302
10230 aa(8)=aa(4)/186
10250 return
11000 rem **** MENU ****
11010 window #1,0,0,180,160,"   MENU    "
11020 cmd #1
11030 ? " "
11040 ? " C... Cycle Colors"
11050 ? " D... Define area"
11060 ? "      to magnify."
11070 ? " L... Load a Picture"
11080 ? " M... Draw magnified"
11085 ? "      area."
11090 ? " Q... Quit"
11100 ? " S... Save a Picture"
11110 ? " ?... This Menu"
11115 ?:? "Click mouse twice":? "in window to":? "continue!"
11120 ask mouse x%,y%,b%
11130 if b%=0 then 11120
11140 cmd #0:close #1:return
12000 rem **** DEFINE MANUALLY OR WITH MOUSE ****
12010 window #1,70,100,180,200,"  DEFINE  "
12020 cmd #1
12030 ?:? "**  DEFINE AREA  **"
12040 ?:? "  1... MANUALLY"
12050 ?:? "  2... WITH MOUSE"
12060 ?:?:input "  Enter Choice: ";choice$
12070 if choice$ = "2" then cmd #0:close #1:goto 10000
12080 cmd #0:close #1:window #1,0,0,320,200,"     MANUAL  DEFINE     "
12085 CMD #1
12090 ?:?:input "Real number center: ";aa(1)
12100 ?:input "Real number range: ";aa(2)
12102 aa(5)=aa(1)-aa(2)/2
12104 xe=aa(5)+aa(2)
12106 aa(7)=(xe-aa(5))/302
12110 ?:input "Imaginary number center: ";aa(3)
12120 ?:input "Autoscale Imaginary Axis (Y/N) ";char$
12130 if char$="Y" or char$="y" then 12170
12140 ?:input "Imaginary number range: ";aa(4)
12150 aa(6)=aa(3)-aa(4)/2
12160 ye=aa(6)+aa(4):goto 12190
12170 aa(6)=aa(3)-(aa(2)*.77)/2
12180 ye=aa(6)+aa(2)*.77
12190 aa(8)=(ye-aa(6))/186
12200 cmd #0:close #1:return
15000 rem **** SAVE A FRACTAL PICTURE ****
15020 x1%=0:y1%=0
15050 x2%=305:y2%=188
15070 erase picture%
15080 size% = int(((x2%-x1%)/16)+2)
15090 size% = size%*(y2%-y1%)
15100 size% = ((((size%*5)+4)/2)+10)
15110 dim picture%(size%)
15120 sshape (x1%,y1%;x2%,y2%),picture%()
15130 window #1,10,50,300,35,"   SAVE    "
15140 cmd #1
15150 print "SIZE= ";size%:input "Enter a Filename: ";filename$
15160 close #1:cmd #0
15165 if filename$="" then 15400
15170 bsave filename$,varptr(picture%(0)),4*size%
15180 colorfile$=filename$+"_dat"
15190 ct=0
15200 for i%=0 to 31
15210 ask rgb i%,red%,green%,blue%
15220 regsave%(ct)=red%:regsave%(ct+1)=green%:regsave%(ct+2)=blue%
15230 ct=ct+3
15240 next i%
15250 bsave colorfile$,varptr(regsave%(0)),400
15260 infofile$=filename$+"_info"
15270 bsave infofile$,varptr(mandelinfo(0)),100
15400 return
15999 rem **** I QUIT ****
16000 talk$=translate$("I QUIT!"):q% = narrate(talk$)
16010 SCREEN 0,4:RGB 15,0,0,0:END
16999 rem **** LOAD A FRACTAL PICTURE ****
17000 window #1,0,0,320,200,"    LOAD    "
17001 cmd #1
17002 input "Which drive are pictures on: ";a$
17004 if a$ < "0" or a$ > "1" then ?:? "Drive must be ( 0 or 1 ) !":goto 17002
17006 if a$ = "0" then shell "list pat #?(_info) quick"
17010 cmd #1
17011 if a$ = "1" then shell "list df1: pat #?(_info) quick"
17015 ?:? "DO NOT include <_info> in filename!":?
17020 input "Enter a filename: ";filename$
17030 cmd #0:close #1
17035 if filename$ = "" then return
17060 x%=0:y%=0
17080 erase picture%:dim picture%(11000)
17082 on error goto 58000
17084 colorfile$=filename$+"_dat":infofile$=filename$+"_info"
17085 name$=colorfile$
17086 bload colorfile$,varptr(regsave%(0))
17087 name$=infofile$
17088 bload infofile$,varptr(mandelinfo(0))
17089 name$=filename$
17090 bload filename$,varptr(picture%(0))
17095 scnclr
17100 gshape (x%,y%),picture%()
17125 ON ERROR GOTO 0
17130 ct=0
17140 for i%=0 to 31
17150 rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
17160 ct=ct+3
17170 next i%
17400 return
25000 rem **** CYCLE COLORS ****
25010 window #1,0,20,300,50,"  CYCLE COLORS   "
25020 cmd #1
25055 input "Speed of rotation: ";speed%
25060 cmd #0:close #1
25070 ask rgb 1,r%,g%,b%
25080 for i%=14 to 1 step -1
25090 ask rgb i%,r1%,g1%,b1%
25100 rgb i%,r%,g%,b%
25110 r%=r1%:g%=g1%:b%=b1%
25120 ask mouse x%,y%,button%:if button%=4 then goto 25200
25121 get a$:if a$<>"" then 25200
25125 sleep(speed%)
25130 next i%
25135 if flag = 0 then 25140
25136 count=count - 1:if count = 0 then 25200
25140 goto 25070
25200 ct=0
25210 for i% = 0 to 31
25220 rgb i%,regsave%(ct),regsave%(ct+1),regsave%(ct+2)
25230 ct=ct+3
25240 next i%
25250 return
30000 rem **** compute fractal variables ****
30005 for i%=0 to 10:swap mandelinfo(i%),aa(i%):next i%
30010 xs=mandelinfo(1)
30020 rrange = mandelinfo(2)
30030 xs=xs-rrange/2
30040 xe=xs+rrange
30050 xstep=(xe-xs)/302
30060 ys=mandelinfo(3)
30070 ys=ys-(rrange*.77)/2
30080 ye=ys+rrange*.77
30090 ystep=(ye-ys)/186
30095 scnclr
30100 ?:?:? "  Low iteration values allow the map":? "to be drawn faster,but lose accuracy."
30110 ? "  A value of 100 takes several hours.
30120 ?:input "Enter Iteration limit: ";climit
30122 if climit=0 then for i%=0 to 10:swap mandelinfo(i%),aa(i%):next i%
30130 cdivfac=climit/15
30140 gosub 60000:gosub 15000:return
58000 window #1,0,50,300,100,"    ERROR    "
58010 cmd #1
58020 if err=53 then print "SORRY, but I can't find":? "         ";name$:goto 58040
58030 print "DISK ERROR #";err
58035 ?:? "             ";name$
58040 ?:? "PRESS any key to continue."
58050 getkey char$
58060 cmd #0:close #1
58070 resume 100
60000 scnclr:x=xs
60010 for xp%=0 to 302
60020 y=ys
60030 for yp%=186 to 0 step -1
60040 az=0:bz=0:ac=x:bc=y
60050 count%=0:size=0
60060 while count%<climit and size<2
60070 atq=az*az-bz*bz
60080 btq=az*bz*2
60090 az=atq+ac:bz=btq+bc
60100 tsiz=az*az+bz*bz
60110 sqin=tsiz
60120 sqout=sqr(sqin)
60130 size=sqout
60140 count%=count%+1
60150 wend
60160 pcolor%=count%/cdivfac
60170 if pcolor%>15 then pcolor%=15
60180 pena pcolor%
60190 draw (xp%,yp%)
60200 get char$
60210 if char$<>"" then xp%=320:yp%=-1
60220 y=y+ystep
60230 next yp%
60240 x=x+xstep
60250 next xp%
60260 pena 15
60270 return
