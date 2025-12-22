10    scnclr
20    rem SpeechCraft V.1.0, by Kelly Kauffman, 3170 Sprout Way, Sparks, NV  89431
30    rem CIS [70206,640]
40    restore 100
50    for i=0 to 8:read config%(i):next i
60    read x$
70    speek$=translate$(x$)
80    x%=narrate (speek$,config%())
90    print    "            Version 1.0"
100   data 110,0,150,0,22000,64,10,0,0
110   data speech-eazy.
120   goto 1770:rem menu
130   speek$=translate$(x$)
140   x%=narrate(speek$,config%())
150   return
160   x$="Change Pitch.":gosub 130
170   scnclr
180   print "Please enter a number between 65 and"
190   print 
200   print "320.  It is currently set to ";config%(0);"."
210   print
220   print
230   print "What do you want it to be now ";:input change
240   config%(0)=change
250   print
260   x$=phrase$
270   gosub 130
280   goto 1770
290   rem end of changing pitch
300   x$="Change Inflection.":gosub 130
310   scnclr
320   print "          Change Inflection"
330   print
340   print "It is currently set to:";config%(1);"."
350   if config%(1)=0 then print "Inflection Enabled." Else print "Monotone.  No Inflection."
360   print
370   print "0 = Inflection Enabled":print :print "1 = Inflection Disabled"
380   print
390   print "Enter Choice ";:input change
400   if change>1 or change<0 then 300 else config%(1)=change
410   goto 1770
420   rem end of inflection
430   x$="Speeking Rate.":gosub 130
440   scnclr
450   print
460   print "            Change Rate"
470   print
480   print
490   print"Speeking Rate is currently set to:"
500   print config%(2);"."
510   print
520   print
530   print "You can enter a number between 40 &"
540   print "400, the default is 150."
550   print
560   print "Enter Speech Rate ";:input change
570   if change >400 or change<40 then 440
580   config%(2)=change
590   x$=phrase$:gosub 130
600   goto 1770
610   x$="Change Voice.":gosub 130
620   scnclr
630   print
640   print "         Change Speaking Voice"
650   print
660   print "Currently set to ";
670   if config%(3)=0 then print "Male Voice." else print "Female Voice."
680   print
690   print "0=Male"
700   print "1=Female"
710   print
720   print "Enter Choice";
730   input choice
740   if choice>1 or choice <0 then 620
750   config%(3)=choice
760   goto 1770
770   x$="Change Freequency.":gosub 130
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
950   goto 1770
960   x$="Volume.":gosub 130
970   scnclr
980   print"              Volume."
990   print
1000  print "Specify a value between 0 (no sound)"
1010  print "and 64 (loudest).  It is currently "
1020  print "set at ";config%(5);"."
1030  print
1040  print "Enter Volume ";
1050  input vol
1060  if vol>64 or vol<0 then 970
1070  print
1080  config%(5)=vol
1090  goto 1770
1100  x$="Chanel Selection.":gosub 130
1110  scnclr
1120  print"      Channel Selection"
1130  print "Channels 0 and 3 go to the left audio"
1140  print "output, and channels 1 and 2 go to "
1150  print "the right audio output.  Specify a "
1160  print "number from the following chart:"
1170  print
1180  print "Value     Channel"
1190  print "0         0"
1200  print "1         1"
1210  print "2         2"
1220  print "3         3"
1230  print "4         0 and 1"
1240  print "5         0 and 2"
1250  print "6         3 and 1"
1260  print "7         3 and 2"
1270  print "8         either avail. left channel."
1280  print "9         either aval. right channel."
1290  print "10        either avail. right/left"
1300  print "          pair of channels (default)"
1310  print "11        any avail. single channel."
1320  print
1330  print "Enter Choice";
1340  input choice
1350  if choice>11 or choice<0 then 1110
1360  config%(6)=choice
1370  goto 1770
1380  end
1390  x$="sinkronihzation mode.":gosub 130
1400  scnclr
1410  print "     Synchronization Mode."
1420  print
1430  print "0 (default) means the Amiga waits"
1440  print "  to finish what it is saying, before"
1450  print "  it goes on in the program."
1460  print
1470  print "1 means the Amiga doesn't wait to"
1480  print "  finish what it's saying, instead"
1490  print "  it speaks and continues with the"
1500  print "  program."
1510  print
1520  print "It is currently set to ";config%(7)
1530  print
1540  print "Enter new Value ";
1550  input choice
1560  if choice>1 or choice<0 then 1400
1570  config%(7)=choice
1580  goto 1770
1590  x$="Narator device control.":gosub 130
1600  scnclr
1610  print "0=Wait to finish first statement,then"
1620  print "speak the next one."
1630  print 
1640  print "1=If another speech command is found"
1650  print "encountered, stop speaking the"
1660  print "one and say neither."
1670  print
1680  print "2=Identical to 1 except it speaks"
1690  print "the second command."
1700  print
1710  print "Currently set to ";config%(8)
1720  print
1730  print "Change to ";:input choice
1740  if choice>2 or choice<0 then 1600
1750  config%(8)=choice
1760  goto 1770
1770  rem menu
1780  scnclr
1790  print "      SpeechEazy! Version 1.0"
1800  print 
1810  print "            Main Menu"
1820  print
1830  print "1) Change Pitch "
1840  print "2) Change Inflection"
1850  print "3) Change Rate"
1860  print "4) Change Speaking Voice"
1870  print "5) Change Frequency in hertz"
1880  print "6) Change Volume"
1890  print "7) Change Channel Selection"
1900  print "8) Change Synchronization mode."
1910  print "9) Change Narrator device control"
1920  print "0) Change Phrase"
1930  print "S) Save current phrase w/paramaters."
1940  print "L) Load phrase w/parameters."
1950  ?
1960  x$="choose.":gosub 130
1970  print "Please enter Choice ";
1980  getkey a$
1990  print a$
2000  if asc(a$)=13 then 1770
2010  if a$<>"L" or a$<>"l" or a$<>"S" or a$<>"s" then choice=val(a$)
2020  if a$="L" or a$="l" then 2300
2030  if a$="S" or a$="s" then 2530
2040  if choice=0 then 2070
2050  on choice goto 160,300,430,610,770,960,1100,1390,1590,2070
2060  goto 1770
2070  scnclr
2080  x$="Change Phrase.":gosub 130
2090  print "          Change Phrase"
2100  print
2110  print "1) Listen to Current Phrase"
2120  print 
2130  print "2) Make a new phrase"
2140  print
2150  print "Enter Choice.";
2160  input choice
2170  if choice>2 or choice<1 then 2070
2180  if choice=1 then x$=phrase$:gosub 130
2190  if choice=1 then 1770
2200  scnclr
2210  print "          Enter New Phrase"
2220  print 
2230  print "Then follow it by a [RETURN]"
2240  print
2250  line input phrase$
2260  print
2270  print "Do you want to hear it now? (y/n)";:input yn$
2280  if yn$="Y" or yn$="y" then x$=phrase$:gosub 130
2290  goto 1770
2300  x$="Load.":gosub 130
2310  scnclr
2320  print
2330  print "            Load Phrase"
2340  print
2350  print "This will load in a previously "
2360  print
2370  print "      ";
2380  print inverse(1);"S";inverse(0);"aved phrase."
2390  print
2400  print"Enter filename for phrase:"
2410  print
2420  print "FORMAT:  Volume name:subdir./file"
2430  print
2440  on error gosub 2780
2450  line input file$
2460  open "i",#1,file$
2470  for i=0 to 8
2480  input #1,config%(i)
2490  next i
2500  line input #1,phrase$
2510  close #1
2520  goto 1770
2530  x$="Save.":gosub 130
2540  scnclr
2550  print
2560  print"              Save"
2570  print 
2580  print"This command will save your current"
2590  print 
2600  print "phrase to disk to a file you specify"
2610  print
2620  print "along with all of your parameters."
2630  print
2640  print "Press RETURN to exit.":?
2650  print "Filename:";
2660  line input file$
2670  if file$="" then 1770
2680  open "o",#1,file$
2690  for i=0 to 8
2700  print #1,config%(i)
2710  next i
2720  print #1,phrase$
2730  close #1
2740  print
2750  print "Save is complete."
2760  for i=1 to 2000:next i
2770  goto 1770
2780  scnclr 
2790  x$="you messed up."
2800  gosub 130
2810  ?:?:?
2820  ?"I encountered an error ";err;"."
2830  print
2840  print
2850  print"Press RETURN to continue."
2860  input a$
2870  on error gosub 2780
2880  resume 1770
