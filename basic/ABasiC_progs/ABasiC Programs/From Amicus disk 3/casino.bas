2     pot=100:common pot
3     rem    m=0:n=0
5     scnclr:rgb 0,6,9,15
6     outline 0:pena 2:box(20,20;80,110),1
10    circle(50,50),20
15    pena 1:paint(60,60),1
20    box(30,50;70,100),1
30    dim door%(722)
35    sshape(20,20;80,110),door%
37    scnclr
38    rgb 0,6,9,15
40    x=120:y=40:gosub 400
41    x=60 :y=45 :gosub 400
42    x=180:y=45 :gosub 400
43    x=0  :y=60 :gosub 400
44    x=240:y=60 :gosub 400
50    circle(150,200),150,.5
55    pena 8:paint(150,150),0
60    x=158:y=200:pena 4
61    area(x,y to 10 ,140 to 50,140 to x,y)
62    area(to 70,125 to 110,125 to x,y)
63    area(to 130,121 to 170,121 to x,y)
64    area(to 190,125 to 230,125 to x,y)
65    area(to 250,140 to 290,140 to x,y)
70    paint(30,144),1
75    pena 2:paint(63,137),1
76    paint(10,167),1
77    rem  paint(290,167),1
78    paint(236,137),1
80    pena 2:draw(300,60 to 300,195)
81    paint(290,167),1
100   '
102   graphic 1
104   pena 2:penb 1
105   x=146
110   ?at(146,60);"O"
111   ?at(x,68);"U"
112   ?at(x,76);"T"
120   x=87 :y=65
121   ?at(x,y);"P"
122   y=y+8:?at(x,y);"O"
123   y=y+8:?at(x,y);"K"
124   y=y+8:?at(x,y);"E"
125   y=y+8:?at(x,y);"R"
130   x=206:y=65
131   ?at(x,y);"2"
132   y=y+8:?at(x,y);"1"
140   x=255:y=90
141   ?at(x,y);"OVER"
142   x=x+12:y=y+8:?at(x,y);"7"
143   x=x-17:y=y+8:?at(x,y);"under"
190   rem talking introduction goto 300
200   ask mouse x%,y%,b%
210   if b%=4 and x%<50 then ?at(10,10);"THIS DOOR NOT PROGRAMED YET":sleep 1*10^6:?at(10,10);"                           "
220   if b%=4 and X%>60 and x%<110 then chain "poker",5,all
230   if b%=4 and x%>130 and x%<170 then ?at(10,10);"QUIT  ":stop:gosub 341
240   if B%=4 and x%>190 and x%<230 then chain "bj",0,all
250   if b%=4 and x%>250 then chain "dice",0,all
290   goto 200
300   rem
310   a$=translate$("welcome to bobs cahsienno."):gosub 410
320   A$=translate$("we are going to advance you 1 hundred $."):gosub 410
330   a$=translate$("please click the mouse button in the door-way of the game you would like to play."):gosub 410
340   goto 350
341   a$=translate$("why do you want to quit when you havent even started?"):gosub 410:return
350   '
395   goto 200
399   end
400   gshape(x,y),door%:return
410   x%=narrate (a$):return
