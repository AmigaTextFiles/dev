/*
 *  Program:  StC_DeCrunch
 *  Author:   Sebastian (Bluebird) Erbert
 *  Datum:    April '96
 *  Version:  0.1
 *  Compiler: EC V3.2e
 *  Anforderungen:  - 'StC.library' Version 3
 *                  - 2MB Ram und OS2.04 empfohlen
 *
 *  Inhalt:   - das Program entpackt das angegebene File
 *              als Datafile mit den Packroutinen der StC.li-
 *              brary und sichert die entpackten Daten un-
 *              ter dem angegebenen Namen
 *            - das Program soll eigentlich nur die Benutzung
 *              der StC.library veranschaulichen, damit man
 *              die Libraryfunktionen leichter in eigenen
 *              Programmen benutzen kann
*/


MODULE 'stc','libraries/stc','dos/dos','exec/memory'

DEF   filehandle,                         /* Filehandle */
      filesize,                           /* Filegröße */
      dataptr: PTR TO LONG,               /* Adresse der geladenen Filedaten */
      unpackeddataptr,                    /* Adresse der entpackten Daten */
      filename[108]: STRING               /* Filename */


PROC main()

IF stcbase:=OpenLibrary('stc.library',STCVERSION)

 WriteF('Enter Filename: ');
 ReadStr(stdout,filename);                            /* Filename lesen */
 WriteF('Opening File...\n');
 filehandle:=Open(filename,MODE_OLDFILE);             /* Datei öffnen */
 IF filehandle=NIL
  WriteF('Failed to open ''\s''.\n',filename);
  CleanUp(0);
 ENDIF
 filesize:=Seek(filehandle,0,OFFSET_END);               /* Länge auslesen */
 filesize:=Seek(filehandle,filesize,OFFSET_BEGINNING);
 WriteF('filesize: \d\n',filesize);
 WriteF('Alloc Memory...\n');
 dataptr:=New(filesize);                              /* Speicher für Datei holen */
 IF dataptr=NIL
  WriteF('No Mem !\n');                               /* bei Fehler Ende */
  CleanUp(0);
 ENDIF
 WriteF('Read File...\n');
 IF Read(filehandle,dataptr,filesize)<>filesize       /* Datei einlesen */
  WriteF('Error while Reading !\n');
  CleanUp(0);
 ENDIF
 WriteF('Close File...\n');
 IF Close(filehandle)=DOSFALSE
  WriteF('Error while Closing File !\n');
  CleanUp(0);
 ENDIF
 WriteF('Alloc Memory for Decrunching ...\n');        /* Puffer fürs Entpacken anfordern */
 WriteF('orgsize: \d\nsecurity length: \d\n',dataptr[1],dataptr[2]);
 unpackeddataptr:=NewM(dataptr[2]+dataptr[1],MEMF_CLEAR);
 IF unpackeddataptr=NIL
  WriteF('No Mem !\n');
  CleanUp(0);
 ENDIF
 IF StcDeCrunchData(unpackeddataptr,dataptr)          /* Datei entpacken */
  WriteF('Done.\n')
 ELSE
  WriteF('Error while Decrunching !\n');
  CleanUp(0);
 ENDIF
 filehandle:=Open(filename,MODE_NEWFILE);             /* entpackte Datei abspeichern */
 IF Write(filehandle,unpackeddataptr,dataptr[2])<>dataptr[2]
  WriteF('Error while Writing !\n');
  CleanUp(0);
 ENDIF
 IF Close(filehandle)=DOSFALSE
  WriteF('Error while Closing File !\n');
  CleanUp(0);
 ENDIF                                                /* alles nötige wieder freigeben */
 IF dataptr<>NIL THEN Dispose(dataptr);
 IF unpackeddataptr<>NIL THEN Dispose(unpackeddataptr);

 CloseLibrary(stcbase);
ELSE
 WriteF('Could not open stc.library\n');
ENDIF


ENDPROC


