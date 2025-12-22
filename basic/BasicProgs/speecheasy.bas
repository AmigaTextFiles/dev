10    scnclr
20    screen 0,4,0
30    rem SpeechCraft V.1.0, by Kelly Kauffman, 3170 Sprout Way, Sparks, NV  89431
40    rem CIS [70206,640]
50    restore 110
60    for i=0 to 8:read config%(i):next i
70    read x$
80    speek$=translate$(x$)
90    x%=narrate (speek$,config%())
100   print    "            Version 1.0"
110   data 110,0,150,0,22000,64,10,0,0
120   data speech-eazy.
130   goto 1820:rem menu
140   speek$=translate$(x$)
150   x%=narrate(speek$,config%())
160   return
170   x$="Change Pitch.":gosub 140
180   scnclr
190   print "Please enter a number between 65 and"
200   print 
210   print "320.  It is currently set to ";config%(0);"."
220   print
230   print
240   print "What do you want it to be now ";:input change
250   config%(0)=change
260   print
270   x$=phrase$:gosub 140
280   goto 1820
290   x$="Change Inflection.":gosub 140
300   scnclr
310   print "          Change Inflection"
320   print
330   print "It is currently set to:";config%(1);"."
340   if config%(1)=0 then print "Inflection Enabled." Else print "Monotone.  No Inflection."
350   print
360   print "0 = Inflection Enabled":print :print "1 = Inflection Disabled"
370   print
380   print "Enter Choice ";:input change
390   if change>1 or change<0 then 290 else config%(1)=change
400   x$=phrase$:gosub 140
410   goto 1820
420   x$="Speeking Rate.":gosub 140
430   scnclr
440   print
450   print "            Change Rate"
460   print
470   print
480   print"Speeking Rate is currently set to:"
490   print config%(2);"."
500   print
510   print
520   print "You can enter a number between 40 &"
530   print "400, the default is 150."
540   print
550   print "Enter Speech Rate ";:input change
560   if change >400 or change<40 then 430
570   config%(2)=change
580   x$=phrase$:gosub 140
590   goto 1820
600   x$="Change Voice.":gosub 140
610   scnclr
620   print
630   print "         Change Speaking Voice"
640   print
650   print "Currently set to ";
660   if config%(3)=0 then print "Male Voice." else print "Female Voice."
670   print
680   print "0=Male"
690   print "1=Female"
700   print
710   print "Enter Choice";
720   input choice
730   if choice>1 or choice <0 then 610
740   config%(3)=choice
750   x$=phrase$:gosub 140
760   goto 1820
770   x$="Change Freequency.":gosub 140
780   scnclr
790   print
800   print"           Change Frequency"
810   print
820   print
830   print "This paramater controls the changes"
840   print "in vocal quality. Specify a value"
850   print "in the range of 5,000 (low and"
860   print "rumbly), to 28000 (high and squeaky."
870   print "The default value is 22200."
880   print
890   print "It is currently set to ";config%(4)
900   print
910   print "Please enter Frequency now";
920   input choice
930   if choice >28000 or choice <5000 then 780
940   config%(4)=choice
950   x$=phrase$:gosub 140
960   goto 1820
970   x$="Volume.":gosub 140
980   scnclr
990   print"              Volume."
1000  print
1010  print "Specify a value between 0 (no sound)"
1020  print "and 64 (loudest).  It is currently "
1030  print "set at ";config%(5);"."
1040  print
1050  print "Enter Volume ";
1060  input vol
1070  if vol>64 or vol<0 then 980
1080  print
1090  config%(5)=vol
1100  x$=phrase$:gosub 140
1110  goto 1820
1120  x$="Chanel Selection.":gosub 140
1130  scnclr
1140  print"      Channel Selection"
1150  print "Channels 0 and 3 go to the left audio"
1160  print "output, and channels 1 and 2 go to "
1170  print "the right audio output.  Specify a "
1180  print "number from the following chart:"
1190  print
1200  print "Value     Channel"
1210  print "0         0"
1220  print "1         1"
1230  print "2         2"
1240  print "3         3"
1250  print "4         0 and 1"
1260  print "5         0 and 2"
1270  print "6         3 and 1"
1280  print "7         3 and 2"
1290  print "8         either avail. left channel."
1300  print "9         either aval. right channel."
1310  print "10        either avail. right/left"
1320  print "          pair of channels (default)"
1330  print "11        any avail. single channel."
1340  print
1350  print "Enter Choice";
1360  input choice
1370  if choice>11 or choice<0 then 1130
1380  config%(6)=choice
1390  x$=phrase$:gosub 140
1400  goto 1820
1410  end
1420  x$="sinkronihzation mode.":gosub 140
1430  scnclr
1440  print "     Synchronization Mode."
1450  print
1460  print "0 (default) means the Amiga waits"
1470  print "  to finish what it is saying, before"
1480  print "  it goes on in the program."
1490  print
1500  print "1 means the Amiga doesn't wait to"
1510  print "  finish what it's saying, instead"
1520  print "  it speaks and continues with the"
1530  print "  program."
1540  print
1550  print "It is currently set to ";config%(7)
1560  print
1570  print "Enter new Value ";
1580  input choice
1590  if choice>1 or choice<0 then 1430
1600  config%(7)=choice
1610  x$=phrase$:gosub 140
1620  goto 1820
1630  x$="Narator device control.":gosub 140
1640  scnclr
1650  print "0=Wait to finish first statement,then"
1660  print "speak the next one."
1670  print 
1680  print "1=If another speech command is found"
1690  print "encountered, stop speaking the"
1700  print "one and say neither."
1710  print
1720  print "2=Identical to 1 except it speaks"
1730  print "the second command."
1740  print
1750  print "Currently set to ";config%(8)
1760  print
1770  print "Change to ";:input choice
1780  if choice>2 or choice<0 then 1640
1790  config%(8)=choice
1800  x$=phrase$:gosub 140
1810  goto 1820
1820  rem menu
1830  scnclr
1840  print "      SpeechEazy! Version 1.0"
1850  print 
1860  print "            Main Menu"
1870  print
1880  print "1) Change Pitch "
1890  print "2) Change Inflection"
1900  print "3) Change Rate"
1910  print "4) Change Speaking Voice"
1920  print "5) Change Frequency in hertz"
1930  print "6) Change Volume"
1940  print "7) Change Channel Selection"
1950  print "8) Change Synchronization mode."
1960  print "9) Change Narrator device control"
1970  print "0) Change Phrase"
1980  print "S) Save current phrase w/paramaters."
1990  print "L) Load phrase w/parameters."
2000  ?
2010  x$="choose.":gosub 140
2020  print "Please enter Choice ";
2030  getkey a$
2040  print a$
2050  if asc(a$)=13 then 1820
2060  if a$<>"L" or a$<>"l" or a$<>"S" or a$<>"s" then choice=val(a$)
2070  if a$="L" or a$="l" then 2350
2080  if a$="S" or a$="s" then 2580
2090  if choice=0 then 2120
2100  on choice goto 170,290,420,600,770,970,1120,1420,1630,2120
2110  goto 1820
2120  scnclr
2130  x$="Change Frase.":gosub 140
2140  print "          Change Phrase"
2150  print
2160  print "1) Listen to Current Phrase"
2170  print 
2180  print "2) Make a new phrase"
2190  print
2200  print "Enter Choice.";
2210  input choice
2220  if choice>2 or choice<1 then 2120
2230  if choice=1 then x$=phrase$:gosub 140
2240  if choice=1 then 1820
2250  scnclr
2260  print "          Enter New Phrase"
2270  print 
2280  print "Then follow it by a [RETURN]"
2290  print
2300  line input phrase$
2310  print
2320  print "Do you want to hear it now? (y/n)";:input yn$
2330  if yn$="Y" or yn$="y" then x$=phrase$:gosub 140
2340  goto 1820
2350  x$="Load.":gosub 140
2360  scnclr
2370  print
2380  print "            Load Phrase"
2390  print
2400  print "This will load in a previously "
2410  print
2420  print "      ";
2430  print inverse(1);"S";inverse(0);"aved phrase."
2440  print
2450  print"Enter filename for phrase:"
2460  print
2470  print "FORMAT:  Volume name:subdir./file"
2480  print
2490  on error gosub 2830
2500  line input file$
2510  open "i",#1,file$
2520  for i=0 to 8
2530  input #1,config%(i)
2540  next i
2550  line input #1,phrase$
2560  close #1
2570  goto 1820
2580  x$="Save.":gosub 140
2590  scnclr
2600  print
2610  print"              Save"
2620  print 
2630  print"This command will save your current"
2640  print 
2650  print "phrase to disk to a file you specify"
2660  print
2670  print "along with all of your parameters."
2680  print
2690  print "Press RETURN to exit.":?
2700  print "Filename:";
2710  line input file$
2720  if file$="" then 1820
2730  open "o",#1,file$
2740  for i=0 to 8
2750  print #1,config%(i)
2760  next i
2770  print #1,phrase$
2780  close #1
2790  print
2800  print "Save is complete."
2810  for i=1 to 2000:next i
2820  goto 1820
2830  scnclr 
2840  x$="you messed up."
2850  gosub 140
2860  ?:?:?
2870  ?"I encountered an error ";err;"."
2880  print
2890  print
2900  print"Press RETURN to continue."
2910  input a$
2920  on error gosub 2830
2930  resume 1820
