/* ----------------------------------------------------------------
 *
 *  Project   : Filevirus Library
 *
 *  Program   : fvkiller.e (fvfiller.c)
 *
 *  Author    : Bjorn Reese <breese@imada.ou.dk>
 *
 *  Translator: Mathias Grundler (turrican@starbase.inka.de)
 *
 *  Short     : Example of a simple virus killer
 *              Compile with "ec fvkiller.e"
 *
 * ---------------------------------------------------------------- */


MODULE 'dos/dos'
MODULE 'dos/dostags'
MODULE 'exec/types'
MODULE 'exec/memory'
MODULE 'filevirus'
MODULE 'libraries/filevirus'

/* The following C-Source is replaced by the E-Function >FileLength(filename)<

long FileSize(BPTR file)
{
  long len = 0;
  struct FileInfoBlock *fib;

  if ( fib=AllocDosObjectTags(DOS_FIB, ADO_FH_Mode) ) {
    len = ExamineFH(file, fib) ? fib->fib_Size : 0L;
    FreeDosObject(DOS_FIB, fib);
  }
  return len;
}
*/

/* ---------------------------------------------------------------- */

PROC repairFile(p:PTR TO filevirusnode,fname)
 DEF    f=NIL,
        len,
        buff,
        answer[256]:STRING,
        repair                  -> E`s SELECT don`t take Procedures as Parameter!

  IF (f:=Open(fname,MODE_OLDFILE))
   len:=FileLength(fname)               -> Original C-Source: len = FileSize(f)
    IF (buff:=AllocMem(len,MEMF_ANY OR MEMF_CLEAR))
     Read(f,buff,len)

      p.fv_Buffer   :=buff
      p.fv_BufferLen:=len

      WriteF('File: "\s" ',fname)

       IF (FvCheckFile(p)=0)
        IF (p.fv_FileInfection<>NIL)
         WriteF('*** virus "\s" found\n',p.fv_FileInfection.fi_VirusName)
         WriteF('Repair (yes/no) : ')
          Fgets(answer,256,stdin)
           IF (answer[0]='y')
            repair:=(FvRepairFile(p, NIL, 0))
            SELECT      repair
             CASE       FVMSG_DELETE
              Close(f)
               f:=NIL
                IF (DeleteFile(fname))
                  WriteF('File deleted\n')
                ELSE
                  WriteF('Error! Cannot delete\n')
                ENDIF
             CASE       FVMSG_RENAME
                WriteF('Please rename\n')
             CASE       FVMSG_SAVE
                Close(f)
                 IF (f:=Open(fname, MODE_NEWFILE))
                  Seek(f, 0, OFFSET_BEGINNING)
                   Write(f,buff,p.fv_BufferLen)
                  WriteF('Hunk/code removed\n')
                 ELSE
                  WriteF('Error! Unable to remove hunk/code\n')
                 ENDIF
             DEFAULT
              WriteF('No action taken\n')
            ENDSELECT
          ENDIF
        ELSE
         WriteF('clean\n')
        ENDIF
       ELSE
        WriteF('error \d\n', p.fv_Status)
       ENDIF
     FreeMem(buff, len)
    ENDIF
   IF (f<>NIL) THEN Close(f)
  ELSE
   WriteF('Unable to open File "\s"\n',fname)
  ENDIF
ENDPROC

/* ---------------------------------------------------------------- */

PROC main()
 DEF    p:PTR TO filevirusnode
  IF (filevirusbase:=OpenLibrary('filevirus.library', 2))
   IF (p:=FvAllocNode())
    repairFile(p, arg)
     FvFreeNode(p)
   ELSE
    WriteF('FvAllocNode() failed\n')
   ENDIF
   CloseLibrary(filevirusbase)
  ELSE
   WriteF('Cannot open "filevirus.library" V.2+\n')
  ENDIF
ENDPROC
