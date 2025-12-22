5     rem this is the dice drawing routine only -- lines 0 toi 62
10    scnclr
11    common pot
12    rgb 0,15,15,15
13    rem:borderoff rgb 1,15,15,15
14    pena 4
16    dim blank%(500)
18    sshape(42,42;99,94),blank%
20    box(50,50;90,85),1
22    draw(70,68)
24    dim d1%(300)
26    sshape(50,50;91,86),d1%
28    pena 2
30    draw(70,68)
32    draw(70,66 to 72,68 to 70,70 to 68,68 to 70,66)
34    draw(70,67 to 71,68 to 70,69 to 69,68)
36    dim spot%(100)
38    sshape(68,66;73,71),spot%
40    rem draw(70,40 to 70,95)
42    rem draw(40,68 to 100,68)
44    scnclr
46    pena 4
48    draw(70,42 to 42,68)
50    draw(70,42 to 98,68)
52    draw(to 70,93 to 42,68)
54    paint(80,60),1
56    dim d2%(500)
58    sshape(42,42;99,94),d2%
60    scnclr
61    rem THIS IS THE END OF THE           DICE DRAWING ROUTINE
62    chain "casino",0,all
