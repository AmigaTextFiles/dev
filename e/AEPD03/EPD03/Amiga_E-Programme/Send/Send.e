/* <<<ANUBIS ZSort V1.34 (Jul 15 1993 19:34:27) (C)1992/93; Oliver Graf
<<<Route : BLANKER
<<<Absendedatum : 05.09.93 15:11

*/

OPT OSVERSION=37

MODULE 'dos/datetime','dos/dos'
ENUM CPMD_NEW,CPMD_APP

DEF puffer[100]:STRING,
    absender[100]:STRING,
    infile[100]:STRING,
    betreff[100]:STRING,
    empfaenger[100]:STRING,
    isbin,
    mose[12]:ARRAY OF LONG


PROC main()
/*|||*/
  DEF myargs:PTR TO LONG,rdargs
  mose[1]:=0;mose[2]:=2678400;mose[3]:=5097600
  mose[4]:=7776000;mose[5]:=10368000;mose[6]:=13046400
  mose[7]:=15638400;mose[8]:=18316800;mose[9]:=20995200
  mose[10]:=23487200;mose[11]:=26265600;mose[12]:=28857600
  WriteF('Send v1.05 - © TOB 1993\n')
  myargs:=[0,0,0,0,0,0]
  IF rdargs:=ReadArgs('F=FILE/A,E=EMPFÄNGER/A,B=BINÄR/S,T=BETREFF/A,P=PUFFER/A,A=ABSENDER/A',myargs,NIL)
    StringF(infile,'\s',myargs[0])
    StringF(empfaenger,'\s',myargs[1])
    isbin:=myargs[2]
    StringF(betreff,'\s',myargs[3])
    StringF(puffer,'\s',myargs[4])
    StringF(absender,'\s',myargs[5])
    FreeArgs(rdargs)
    IF isbin=TRUE
     add2puff(puffer,infile,empfaenger,betreff,absender,TRUE)
    ELSE
     ed2pu(infile,'T:Send.tmp')
     add2puff(puffer,'T:Send.tmp',empfaenger,betreff,absender,FALSE)
    ENDIF
    DeleteFile('T:Send.tmp')
  ELSE
   WriteF('Gebrauch: Send F=FILE/A,E=EMPFÄNGER/A,B=BINÄR/S,T=BETREFF/A,P=PUFFER/A,A=ABSENDER/A\n')
  ENDIF
ENDPROC
/*|||*/
PROC ed2pu(in,out)
/*|||*/
 DEF h1,h2,rstr,str[100]:STRING,oldstdout,str2[100]:STRING
 IF h1:=Open(in,OLDFILE)
  IF h2:=Open(out,NEWFILE)
   rstr:=New(100)
   REPEAT
    rstr:=Fgets(h1,rstr,100)
    IF rstr<>NIL
     StringF(str,'\s',rstr)
     SetStr(str,(StrLen(str)-1))
     StringF(str2,'\s\b\n',convert(str))
     Fputs(h2,str2)
    ENDIF
   UNTIL (rstr=NIL)
   Dispose(rstr)
   Close(h2)
  ELSE
   fehler('Konnte Tempfile nicht öffnen !')
  ENDIF
  Close(h1)
 ELSE
  fehler('Konnte File nicht öffnen !')
 ENDIF
ENDPROC
/*|||*/
PROC copyfile(in,out,mod)
/*|||*/
 DEF han1,han2,buf,rlen,wlen,wahl,doit=TRUE
 IF han1:=Open(in,OLDFILE)
  SELECT mod
   CASE CPMD_NEW
    han2:=Open(out,NEWFILE)
   CASE CPMD_APP
    IF han2:=Open(out,OLDFILE)
     Seek(han2,0,1)
    ELSE
     han2:=Open(out,NEWFILE)
    ENDIF
  ENDSELECT
  IF doit=TRUE
   IF han2
    IF buf:=New(2048)
     REPEAT
      rlen:=Read(han1,buf,2048)
      IF rlen
       wlen:=Write(han2,buf,rlen)
       IF wlen<>rlen THEN fehler('Fehler beim Kopieren !')
      ENDIF
     UNTIL rlen<=0
     Dispose(buf)
     Close(han1);Close(han2)
    ELSE
     fehler('Speichermangel!')
    ENDIF
   ELSE
    fehler('Kann Zielfile nicht öffnen !')
   ENDIF
  ENDIF
 ELSE
  fehler('Kann Sourcefile nicht öffnen !')
 ENDIF
ENDPROC
/*|||*/
PROC add2puff(puff,file,empf,betreff,abs,bin)
/*|||*/
 DEF fl,hp,hf,oldst
 UpperStr(empf)
 IF (fl:=FileLength(file))>=0
  IF hf:=Open(file,OLDFILE)
   IF hp:=Open(puff,OLDFILE)
    Seek(hp,0,1)
   ELSE
    hp:=Open(puff,NEWFILE)
   ENDIF
   IF hp
    oldst:=stdout;stdout:=hp
    WriteF('\s\b\n',empf)
    WriteF('\s\b\n',convert(betreff))
    WriteF('\s\b\n',abs)
    WriteF('\s\b\n',pdate(datesecs()))
    WriteF('\b\n',NIL)
    WriteF('\b\n',NIL)
    WriteF('\s\b\n',IF bin=TRUE THEN 'B' ELSE 'T')
    WriteF('\d\b\n',fl)
    stdout:=oldst
    Close(hp);Close(hf)
    copyfile(file,puff,CPMD_APP)
   ENDIF
  ENDIF
 ENDIF
ENDPROC
/*|||*/
PROC datesecs()
/*|||*/
 DEF s,dt:datetime,ds:PTR TO datestamp
 ds:=DateStamp(dt.stamp)
 s:=Mul(31622400,2)+Mul(31536000,6)+Mul(ds.days,86400)+Mul(ds.minute,60)+Div(ds.tick,50)
ENDPROC s
/*|||*/
PROC pdate(s)
/*|||*/
 DEF y,year,f,g,str,date,month,std,min,sec,datum
 datum:=String(19)
 y:=70;f:=1
 WHILE f=1
  IF (Mod(y,4)=0)
   IF (s>=31622400)
    y++;s:=(s-31622400)
   ELSE
    f:=86400
   ENDIF
  ELSE
   IF s>=31536000
    y++;s:=(s-31536000)
   ELSE
    f:=0
   ENDIF
  ENDIF
 ENDWHILE
 year:=y;g:=12;y:=0
 WHILE y<>-1
  IF g<3 THEN f:=0
  IF (s>=(mose[g]+f)) THEN y:=-1 ELSE g--
 ENDWHILE
 month:=g;s:=s-(mose[g]+f)
 date:=(Div(s,86400)+1);s:=(s-Mul((date-1),86400))
 std:=Div(s,3600);s:=(s-Mul(std,3600))
 min:=Div(s,60);s:=(s-Mul(min,60))
 sec:=s
 SetStr(datum,0)
 IF year<10 THEN StringF(datum,'0\d',year) ELSE StringF(datum,'\d[2]',year)
 IF month<10 THEN StringF(datum,'\s0\d',datum,month) ELSE StringF(datum,'\s\d[2]',datum,month)
 IF date<10 THEN StringF(datum,'\s0\d',datum,date) ELSE StringF(datum,'\s\d[2]',datum,date)
 IF std<10 THEN StringF(datum,'\s0\d',datum,std) ELSE StringF(datum,'\s\d[2]',datum,std)
 IF min<10 THEN StringF(datum,'\s0\d',datum,min) ELSE StringF(datum,'\s\d[2]',datum,min)
ENDPROC datum
/*|||*/
PROC convert(in)
/*|||*/
 DEF out,i,z=0,len
 len:=StrLen(in)
 out:=String(len)
 FOR i:=0 TO (len-1)
  z:=in[i]
  SELECT z
   CASE 246 /*ö*/
    StringF(out,'\s\c',out,148)
   CASE 214 /*Ö*/
    StringF(out,'\s\c',out,153)
   CASE 252 /*ü*/
    StringF(out,'\s\c',out,129)
   CASE 196 /*Ä*/
    StringF(out,'\s\c',out,142)
   CASE 220 /*Ü*/
    StringF(out,'\s\c',out,154)
   CASE 228 /*ä*/
    StringF(out,'\s\c',out,132)
   CASE 223 /*ß*/
    StringF(out,'\s\c',out,225)
   DEFAULT
    StringF(out,'\s\c',out,z)
  ENDSELECT
 ENDFOR
ENDPROC out
/*|||*/
PROC fehler(text)
/*|||*/
 WriteF('Fehler: \s',text)
ENDPROC
/*|||*/


/*
        mfG,
            TOB


The artistic temperament is a disease that affects amateurs. - G. K Chesterton, Heretics, 1905
- AnurEad v0.98 - (c) 1993 TOB -

*/

