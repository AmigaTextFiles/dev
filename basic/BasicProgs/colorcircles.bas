10    screen 0,4,0
99    rgb 0,15,15,15
100   rgb 1,0,0,0
101   rgb 2,0,0,1
102   rgb 3,0,0,2
103   rgb 3,0,0,2
104   rgb 4,0,0,3
105   rgb 5,0,0,4
106   rgb 6,0,0,5
107   rgb 7,0,0,6
108   rgb 8,0,0,7
109   rgb 9,0,0,8
110   rgb 10,0,0,9
111   rgb 11,0,0,10
112   rgb 12,0,0,11
113   rgb 13,0,0,12
114   rgb 14,0,0,13
115   rgb 15,0,0,14
1000  scnclr: goto 2000
1001  pena 0
1002  rem drawmode 2
1010  ask mouse h%,v%,b%
1020  if b%= 0 then 1010
1030  ? at (0,0) h%,v%
1040  goto 1010
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
3030  ? red%;spc(5);green%
3040  for timer%=0 to 5000:next timer%
3050  next green%
3060  next red%
4000  cmd 0
4010  close #1
4500  goto 99
5000  getkey A$
