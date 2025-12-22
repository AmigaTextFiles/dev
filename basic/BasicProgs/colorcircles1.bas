11    Print"       I wrote this program to explore the different shades of colors";
12    Print" possible. If you see a shade that you want to use in a program";
13    Print" you can determine the RGB values. The red & green are";
14    Print" listed in window 1. The circle in the upper left corner has a blue";
15    Print" value of 1 increasing to 15 in the lower right circle. You can use";
16    Print" the right mouse button to pause the program."
17    Print"
18    Print"  Rick Parker, Sysop, Amiga BBS of Colorado, (303) 752-0247
19    Print"
20    for x=1 to 3000: next
25    scnclr:rgb 1,5,5,5
26    input "Timing delay";delay%
98    screen 0,5:scnclr
99    rgb 0,15,15,15
100   rgb 1,0,0,1
101   rgb 2,0,0,2
102   rgb 3,0,0,3
103   rgb 4,0,0,4
104   rgb 5,0,0,5
105   rgb 6,0,0,6
106   rgb 7,0,0,7
107   rgb 8,0,0,8
108   rgb 9,0,0,9
109   rgb 10,0,0,10
110   rgb 11,0,0,11
111   rgb 12,0,0,12
112   rgb 13,0,0,13
113   rgb 14,0,0,14
114   rgb 15,0,0,15
2000  pena 1:circle (25,25),24:paint (25,25)
2001  pena 2:circle (75,25),24:paint (75,25)
2002  pena 3:circle (125,25),24:paint (125,25)
2003  pena 4:circle (175,25),24:paint (175,25)
2004  pena 5:circle (225,25),24:paint (225,25)
2005  pena 6:circle (25,75),24:paint(25,75)
2006  pena 7:circle (75,75),24:paint(75,75)
2007  pena 8:circle (125,75),24:paint(125,75)
2008  pena 9:circle (175,75),24:paint(175,75)
2009  pena 10:circle (225,75),24:paint(225,75)
2010  pena 11:circle(25,125),24:paint(25,125)
2011  pena 12:circle(75,125),24:paint(75,125)
2012  pena 13:circle(125,125),24:paint(125,125)
2013  pena 14:circle(175,125),24:paint(175,125)
2014  pena 15:circle(225,125),24:paint(225,125)
2500  window 1,0,170,320,30,"Red and Green levels"
2510  cmd 1
3000  for red%=0 to 15
3010  for green%=0 to 15
3011  rgb 1,red%,green%,1
3012  rgb 2,red%,green%,2
3013  rgb 3,red%,green%,3
3014  rgb 4,red%,green%,4
3015  rgb 5,red%,green%,5
3016  rgb 6,red%,green%,6
3017  rgb 7,red%,green%,7
3018  rgb 8,red%,green%,8
3019  rgb 9,red%,green%,9
3020  rgb 10,red%,green%,10
3021  rgb 11,red%,green%,11
3022  rgb 12,red%,green%,12
3023  rgb 13,red%,green%,13
3024  rgb 14,red%,green%,14
3025  rgb 15,red%,green%,15
3030  print red%, spc(5);green%
3040  for timer%=0 to delay%:next timer%
3050  next green%
3060  next red%
4000  cmd 0
4010  close #1
4500  goto 25
