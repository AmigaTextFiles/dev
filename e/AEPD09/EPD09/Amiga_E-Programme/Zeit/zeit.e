/*  FB  1994 */


MODULE  'dos/datetime','utility/date','dos/dos','utility'

PROC main()

/* utilitybase wird für mydate2 benötigt ( Amiga2Date )*/
utilitybase:=OpenLibrary('utility.library',36)

/* Zeit als String verfügbar*/
WriteF('\n\n')  
WriteF(' Zeit als String \n')  
mydate1()

WriteF('\n\n')  

/* Zeit als Zahl verfügbar*/
WriteF(' Zeit als Zahl \n')  
mydate2()
WriteF('\n\n')  

ENDPROC




PROC mydate1()
DEF bdate[12]:ARRAY OF datestamp,stri=NIL:PTR TO datetime

DateStamp(bdate)

stri:=[bdate.days,bdate.minute,bdate.tick,NIL]
stri.format:=3  /* 3=  FORMAT_CDN ( dd-mm-yy ) */
stri.flags:=0   /* 0= ignoriert  */

DateToStr(stri)

WriteF('  \s\n',stri.strdate)
WriteF('  \s\n',stri.strday)
WriteF('  \s\n',stri.strtime)

ENDPROC



PROC mydate2()
DEF mydat[14]:ARRAY OF clockdata,wtag=NIL:PTR TO LONG,bdate[12]:ARRAY OF datestamp,
    alsec	

wtag:=['Sonntag','Montag','Dienstag','Mittwoch',  'Donnerstag','Freitag',
       'Samstag']

DateStamp(bdate)

alsec:=((bdate.minute*60)+(bdate.tick/50)+(Mul(bdate.days,86400)))

Amiga2Date(alsec,mydat)
 
  WriteF('      Jahr     \d\n',mydat.year)
  WriteF('     Monat       \d[2]\n',mydat.month)
  WriteF('       Tag       \d[2]\n',mydat.mday)
  WriteF('      Zeit \d[2]:\d[2]:\d[2]\n',mydat.hour,mydat.min,mydat.sec)
  WriteF(' Wochentag \s\n',wtag[mydat.wday])

ENDPROC
