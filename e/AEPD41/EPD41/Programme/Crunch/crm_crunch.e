/*
 *  Program:  CrM_Crunch
 *  Author:   Sebastian (Bluebird) Erbert
 *  Datum:    April '96
 *  Version:  0.1
 *  Compiler: EC V3.2e
 *  Anforderungen:  - 'CrM.library' Version 4
 *                  - 2MB Ram und OS2.04 empfohlen
 *
 *  Inhalt:   - das Program packt das angegebene File als
 *              Datafile mit den Packroutinen der CrM.li-
 *              brary und sichert die gepackten Daten un-
 *              ter dem angegebenen Namen (plus der Exten-
 *              sion 'crm' wieder ab)
 *            - das Program soll eigentlich nur die Benutzung
 *              der CrM.library veranschaulichen, damit man
 *              die Libraryfunktionen leichter in eigenen
 *              Programmen benutzen kann
*/


MODULE   'crm','libraries/crm','dos/dos'

CONST ERR_TEMPLATE= 20,         /* Error - Codes */
      ERR_NOLIB   = 19,
      ERR_STRUCT  = 18,
      ERR_LOCK   = 17,
      ERR_NOFIBMEM= 16,
      ERR_NOFMEM  = 15,
      ERR_READ   = 14,
      ERR_CRUNCHFAIL=13,
      ERR_WRITE    = 12,
      ERR_FILE   = 11


DEF   filehandle,                         /* Filehandle */
      filesize,                           /* Filegröße */
      dataptr: PTR TO LONG,               /* Adresse der Filedaten */
      crunchinfos: PTR TO crunchstruct,   /* nötig zum Packen */
      datenkopf=NIL: PTR TO dataheader,   /* Dataheader der vor die gepackten Daten kommt */
      crunlen,                            /* gepackte Größe */
      altpos,                             /* Hilfsvariable für Filegrößenermittlung */
      filename[108]: STRING               /* Filename */


      


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
 WriteF('Alloc Memory...\n');                         /* Speicher für File holen */
 dataptr:=New(filesize);
 IF dataptr=NIL
   WriteF('No Mem !\n');
   CleanUp(0);                                        /* bei Fehler Ende */
 ENDIF
 WriteF('Read File...\n');
 IF Read(filehandle,dataptr,filesize)<>filesize       /* File lesen */
   WriteF('Error while Reading !\n');
   CleanUp(0);
 ENDIF
 WriteF('Close File...\n');
 Close(filehandle);
 crunchinfos:=CmProcessCrunchStructA(NIL,CM_ALLOCSTRUCT,  /* Argumente definieren */
           [CMCS_ALGO,CM_LZH OR CMF_LEDFLASH,
            CMCS_OFFSET,$7FFE,
            CMCS_HUFFSIZE,16,
            0]);

 IF crunchinfos=NIL                                   /* bei Fehler Ende */
   WriteF('Error while allocing CrunchStruct !\n');
   CleanUp(0);
 ENDIF
 datenkopf:=New(SIZEOF dataheader);                   /* Speicher für Dataheader */
 crunchinfos.src:=dataptr;
 crunchinfos.srclen:=filesize;                        /* Werte in Struktur eintragen */
 crunchinfos.dest:=dataptr;
 crunchinfos.destlen:=filesize;
 crunchinfos.datahdr:=datenkopf;
 WriteF('Crunching...\n');
 crunlen:=CmCrunchData(crunchinfos);                  /* das Packen starten */
 SELECT crunlen                                       /* Fehlerauswertung */
  CASE ERR_TEMPLATE;   WriteF('Wrong Arguments !\n');
  CASE ERR_NOLIB;      WriteF('Could not open Library !\n');
  CASE ERR_STRUCT;     WriteF('Could no allocate Struct !\n');
  CASE ERR_LOCK;       WriteF('File not found !\n');
  CASE ERR_NOFIBMEM;   WriteF('No Mem !\n');
  CASE ERR_NOFMEM;     WriteF('No Mem !\n');
  CASE ERR_READ;       WriteF('Error while Reading !\n');
  CASE ERR_CRUNCHFAIL; WriteF('Crunching Failed !\n');
  CASE ERR_WRITE;      WriteF('Error while Writing !\n');
  CASE ERR_FILE;       WriteF('Dest File open Failed !\n');
  DEFAULT;             WriteF('Crunched Length: \d\n',crunlen);
 ENDSELECT
 WriteF('Org.Size: \d\n',datenkopf.originallen);      /* Ergebnisse */
 WriteF('Dst.Size: \d\n',datenkopf.crunchedlen);
 StrAdd(filename,'.crm');
 WriteF('Writing packed File: ''\s'' ...\n',filename);
 filehandle:=Open(filename,MODE_NEWFILE);             /* Dataheader speichern */
 IF Write(filehandle,datenkopf,SIZEOF dataheader)<>(SIZEOF dataheader)
   WriteF('Error while Writing !\n');
   CleanUp(0);                                        /* bei Fehler Ende */
 ENDIF
 IF Write(filehandle,dataptr,crunlen)<>crunlen        /* gepackte Daten speichern */
   WriteF('Error while Writing !\n');
   CleanUp(0);                                        /* bei Fehler Ende */
 ENDIF
 Close(filehandle); 
 IF dataptr<>NIL THEN Dispose(dataptr);               /* nötiges weider freigeben */
 crunchinfos:=CmProcessCrunchStructA(crunchinfos,CM_FREESTRUCT,NIL);
 CloseLibrary(crmbase);
 WriteF('Done.\n');
ELSE
 WriteF('Could not open CrM.library.\n');
ENDIF

ENDPROC

