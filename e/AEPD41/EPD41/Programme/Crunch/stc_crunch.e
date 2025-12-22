/*
 *  Program:  StC_Crunch
 *  Author:   Sebastian (Bluebird) Erbert
 *  Datum:    April '96
 *  Version:  0.1
 *  Compiler: EC V3.2e
 *  Anforderungen:  - 'StC.library' Version 3
 *                  - 2MB Ram und OS2.04 empfohlen
 *
 *  Inhalt:   - das Program packt das angegebene File als
 *              Datafile mit den Packroutinen der StC.li-
 *              brary und sichert die gepackten Daten un-
 *              ter dem angegebenen Namen (plus der Exten-
 *              sion 'stc' wieder ab)
 *            - das Program soll eigentlich nur die Benutzung
 *              der StC.library veranschaulichen, damit man
 *              die Libraryfunktionen leichter in eigenen
 *              Programmen benutzen kann
*/


MODULE  'stc','libraries/stc','dos/dos'

DEF   filehandle,                         /* Filehandle */
      filesize,                           /* Filegröße */
      crunbuffer,                         /* Puffer zum Packen nötig */
      filebuffer,                         /* Adresse der Filedaten */
      crunlen,                            /* gepackte Dateilänge */
      filename[108]: STRING               /* Filename */

PROC main()

IF stcbase:=OpenLibrary('stc.library',STCVERSION)



 WriteF('Enter Filename: ');
 ReadStr(stdout,filename);                            /* Filename lesen */

 filebuffer:=StcNewAllocFileBuffer(64,filename);      /* Dateipuffer anfordern */
 IF filebuffer=NIL
  WriteF('Error allocating FileBuffer !\n');
  CleanUp(0);
 ENDIF

 filesize:=StcLoadFileBuffer(filebuffer);             /* Datei laden */
 IF filesize=0
  WriteF('Error while Loading File !\n');
  CleanUp(0);
 ENDIF
 crunbuffer:=StcAllocBuffer(S404);                    /* Puffer zum Packen anfordern */
 IF crunbuffer=NIL
  WriteF('No Mem !\n');
  CleanUp(0);
 ENDIF
 WriteF('Crunching...\n');                            /* Packvorgang starten */
 crunlen:=StcCrunchDataTags([CDDESTINATION,filebuffer,   /* Zeiger auf Datei */
                             CDLENGTH,filesize,          /* deren Länge */
                             CDABORTFLAGS,CDABORTNIL,    /* kein Abbruch */
                             CDOUTPUTFLAGS,CDOUTPUTNIL,  /* kein Ausgabe */
                             CDDISTBITS,CDDIST16K,       /* Distanz 16K */
                             CDBUFFER,crunbuffer,        /* Zeiger auf zusätzlichen Puffer */
                             0]);
 IF crunlen=0                                         /* wenn crunlen=0 dann ist Fehler aufgetreten */
  WriteF('Error while Crunching !\n');
  CleanUp(0);
 ENDIF
 WriteF('Src_Size: \d\n',filesize);                   /* ursprüngliche Größe */
 WriteF('Dst_Size: \d\n',crunlen);                    /* neue Größe */
 StrAdd(filename,'.stc');
 filehandle:=Open(filename,MODE_NEWFILE);
 WriteF('Saving...\n');
 IF Write(filehandle,filebuffer,crunlen)<>crunlen     /* gepackte Datei speichern */
  WriteF('Error while Writing !\n');
  CleanUp(0);                                         /* bei Fehler Ende */
 ENDIF
 IF Close(filehandle)=DOSFALSE
  WriteF('Error while Closing File !\n');
  CleanUp(0);
 ENDIF
 IF crunbuffer<>NIL THEN StcFreeBuffer(crunbuffer);   /* alle Puffer wieder freigeben */
 IF filebuffer<>NIL THEN StcFreeFileBuffer(filebuffer);
 WriteF('Done.\n');
 CloseLibrary(stcbase);                               /* Lib schließen */
ELSE
 WriteF('Could not open stc.library\n');
ENDIF

ENDPROC

