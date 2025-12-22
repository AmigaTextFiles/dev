/*
**             File: epdprog.e
**      Description: EPD-Gesamtverzeichnis nach String durchsuchen
**        Copyright: None
**           Status: Public Domain
**
**          $Author: Daniel van Gerpen
**             $VER: epdprog 0.1 (09 Apr 1995)
**            $Date: 1995/04/09 13:59:31
**/         

MODULE 'dos/dosextens'

CONST MXLEN   =1000,
      PATHLEN =128

DEF   full[MXLEN]         :STRING, /* Für Ausgabe */
      last=NIL,
      s,
      first=NIL,
      pos                          /* Position */

PROC main()
  DEF fh,                          /* FileHandle */
      lock : PTR TO filelock,      /* Programm - Verzeichnis */
      progdir[PATHLEN]  : STRING,
      fullpath[PATHLEN] : STRING,
      buf[MXLEN]          :ARRAY,  /* Zeilenbuffer */
      casebuf[MXLEN]      :STRING, /* Für Vergleich */
      n=0,                         /* Zeilencounter */
      f=0,                         /* Fundstellen */
      lowarg                       /* Lowercase Arg */

  lock:=GetProgramDir()                   /* Programmverzeichnis ermitteln */
  NameFromLock(lock,progdir,PATHLEN)
  StrCopy(fullpath,progdir)
  StrAdd(fullpath,'/allEPD.txt')

  IF fh:=Open(fullpath,OLDFILE)

    WHILE Fgets(fh,buf,MXLEN)

      IF (s:=String(StrLen(buf)))=NIL THEN Raise("MEM")
      StrCopy(s,buf,ALL)
      IF last THEN Link(last,s) ELSE first:=s
      last:=s
      INC n

    ENDWHILE

    Close(fh)
    s:=first

    lowarg:=arg
    LowerStr(lowarg)

    WriteF('\nName                      Datum      EPD\n')
    WriteF('----------------------------------------\n')

    WHILE s                                           /* Eigentliche Suche */
      StrCopy(casebuf,s)                              /* groß/klein mißachten */
      LowerStr(casebuf)
      pos := InStr(casebuf,lowarg)
      IF pos<>-1                                      /* arg vorhanden ? */
        write_line()
        INC f                                         /* Zähler erhöhen */
      ENDIF
      s := Next(s)
    ENDWHILE

    WriteF('\nDatei enthält \d Programme. Davon ausgegeben : \d.\n',n,f)
    DisposeLink(first)
  ELSE
    WriteF('Keine Quelldatei verfügbar.\n')
  ENDIF
ENDPROC

PROC write_line()                         /* Gibt eine gefundene Zeile aus */
  DEF tmp1[MXLEN]         :STRING,
      tmp2[MXLEN]         :STRING

  StrCopy(full,'')                              /* full löschen */
  StrCopy(full,s,pos)                           /* Zeichen bis "arg" */
  StrAdd(full,'[1;32m')                        /* Farbe 2 */
  MidStr(tmp1,s,pos,StrLen(arg))                /* arg */
  StrAdd(full,tmp1)                             /* anfügen */
  StrAdd(full,'[0;31m')                        /* Farbe 1 */
  RightStr(tmp2,s,(StrLen(s)-StrLen(arg)-pos))  /* und den Rest */
  StrAdd(full,tmp2)                             /* anfügen */
  WriteF('\s',full)                             /* schreiben */
ENDPROC



