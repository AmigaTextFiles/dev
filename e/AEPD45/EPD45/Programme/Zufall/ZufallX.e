/*
   Generierung von Zufallszahlen

   Programm ZufallX - ©1995 bei Andreas Rehm
*/

PROC main()
 DEF buf[8]:STRING,args:PTR TO LONG,zahl:LONG,anzahl[80]:STRING,anz:LONG,count
 WriteF('\e[1;32mZufallszahlen © Andreas Rehm 1995\e[0m\nCtrl-C für Ende.\n\n')
 WriteF('\e[33mGeben Sie das Maximum ein [1 bis 99999]:\e[0m ')
 ReadStr(stdout,buf)
 WriteF('\e[33mGeben Sie die Anzahl an Zufallszahlen an [0 für Ende]:\e[0m ')
 ReadStr(stdout,anzahl)
 StrToLong(buf,{args})
 StrToLong(anzahl,{anz})
 count:=1
 WHILE count<=anz
  IF CtrlC() THEN CleanUp(0)
  zahl:=Rnd(args+1)
  WriteF('\e[33mZufallszahl [Nr.: \d]:\e[0m \e[32m\d\e[0m\n',count,zahl)
  count:=count+1
 ENDWHILE
 WriteF('\nZufallX beendet.\n')
ENDPROC

CHAR '\0$VER: ZufallX 1.00 (07.03.95) (©1995 Andreas Rehm)\0'
