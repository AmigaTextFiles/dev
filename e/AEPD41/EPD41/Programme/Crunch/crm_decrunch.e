/*
 *  Program:  CrM_DeCrunch
 *  Author:   Sebastian (Bluebird) Erbert
 *  Datum:    April '96
 *  Version:  0.1
 *  Compiler: EC V3.2e
 *  Anforderungen:  - 'CrM.library' Version 4
 *                  - 2MB Ram und OS2.04 empfohlen
 *
 *  Inhalt:   - das Program entpackt das angegebene File als
 *              Datafile mit den Packroutinen der CrM.li-
 *              brary und sichert die ungepackten Daten un-
 *              ter dem angegebenen Namen
 *            - das Program soll eigentlich nur die Benutzung
 *              der CrM.library veranschaulichen, damit man
 *              die Libraryfunktionen leichter in eigenen
 *              Programmen benutzen kann
*/


MODULE   'crm','libraries/crm','dos/dos'

DEF   filehandle,                                     /* Filehandle */
      filesize,                                       /* Filegröße */
      packeddataptr  : PTR TO LONG,                   /* Adresse der gepackten Filedaten */
      unpackeddataptr: PTR TO LONG,                   /* Adresse der entpackten Daten + MinSecDist */
      newunpdataptr  : PTR TO LONG,                   /* Adresse der entpackten Daten (diesen Zeiger zum Saven benutzen) */
      newdatalen,                                     /* Größe des original (ungepackten) Files (vom Dataheader) */
      datenkopf      : PTR TO dataheader,             /* Zeiger auf den Dataheader des gepackten Files */
      decrunlen,                                      /* Größe des entpackten Files */
      altpos,                                         /* Hilsvariable für Filegröße */
      filename[108]: STRING                           /* Filename */
      


PROC main()

IF crmbase:=OpenLibrary('CrM.library',CRMVERSION)     /* Library öffnen */

 WriteF('Enter Filename: ');
 ReadStr(stdout,filename);                            /* Filename lesen */
 WriteF('Open File...\n');           
 filehandle:=Open(filename,MODE_OLDFILE);             /* File öffnen */
 IF filehandle=NIL                                    /* Fehler dann: */
  WriteF('Couldn''t open file: ''\s''.\n',filename);
  CleanUp(0);                                         /* Ende */
 ENDIF
 altpos:=Seek(filehandle,0,OFFSET_END);               /* sonst Größenermittlung */
 filesize:=Seek(filehandle,altpos,OFFSET_BEGINNING);
 WriteF('Filesize: \d\n',filesize);
 WriteF('Alloc Memory...\n');
 packeddataptr:=New(filesize);                        /* Speicher für File holen */
 IF packeddataptr=NIL
   WriteF('No Mem !\n');
   CleanUp(0);                                        /* bei Fehler Ende */
 ENDIF
 WriteF('Reading File...\n');
 IF Read(filehandle,packeddataptr,filesize)<>filesize /* File einlesen */
   WriteF('Error while Reading !\n');
   CleanUp(0);                                        /* bei Fehler Ende */
 ENDIF
 WriteF('Closing File...\n');
 IF Close(filehandle)=DOSFALSE
   WriteF('Error while Closing File !\n');
   CleanUp(0);
 ENDIF
 datenkopf:=packeddataptr;                            /* Dataheader ist immer am Fileanfang */
 WriteF('CrunchedSize: \d\n',datenkopf.crunchedlen);  /* Infos ausgeben */
 WriteF('OriginalSize: \d\n',datenkopf.originallen);
 WriteF('MinSecDist: \d\n',datenkopf.minsecdist);
 newdatalen:=datenkopf.originallen+datenkopf.minsecdist; /* originale Dateigröße merken */
 unpackeddataptr:=New(newdatalen);                    /* dafür Speicher holen */
 IF unpackeddataptr=NIL
   WriteF('No Mem !\n');
   CleanUp(0);                                        /* kein Mem, dann Ende */
 ENDIF
 WriteF('DeCrunching...\n');                          /* File entpacken */
 newunpdataptr:=CmDecrunch((packeddataptr+14),unpackeddataptr,datenkopf);

 /***  Achtung:  Der Zeiger auf die gepackte Quelldatei darf _NICHT_ auf den
                 DataHeader zeigen (sonst Fehler oder sogar Crash).
                 Er muß auf das erste Byte nach dem Dataheader zeigen.
  ***/



 IF newunpdataptr=NIL                                 /* hier gibts das fertig entpackte File */
   WriteF('Error while Decrunching !\n');
   CleanUp(0);                                        /* bei fehler Ende */
 ENDIF               
 WriteF('Done.\n');
 decrunlen:=datenkopf.originallen;
 WriteF('Org.Size: \d\n',decrunlen);
 filehandle:=Open(filename,MODE_NEWFILE);
 IF Write(filehandle,newunpdataptr,decrunlen)<>decrunlen /* entpackte Daten abspeichern */
   WriteF('Error While Writing !\n');
   CleanUp(0);
 ENDIF
 IF Close(filehandle)=DOSFALSE
   WriteF('Error while Closing File !\n');
   CleanUp(0);
 ENDIF
 IF packeddataptr<>NIL THEN Dispose(packeddataptr);   /* Speicher für gepackte Datei freigeben */
 IF unpackeddataptr<>NIL THEN Dispose(unpackeddataptr);  /* Speicher für entpackten Datei freigeben */
ELSE
 WriteF('Could not open CrM.library.\n');             /* Library wieder schließen */
ENDIF

ENDPROC

