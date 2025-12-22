/* Simple example on how to use FileID.library in Amiga E */
/* Usage:  Identify filename */


MODULE  'dos/dos', 'fileid', 'libraries/fileid'


DEF myargs:PTR TO LONG, rdargs
DEF fib:PTR TO fileinfo


PROC main()
DEF filename[200]:STRING

/* Get the supplied filename */

   myargs:=[0]

   IF rdargs:=ReadArgs('File/A',myargs,NIL)
      StrCopy(filename,myargs[0],ALL)
   ELSE
      WriteF('Usage: Identify FILENAME.\n')
      FreeArgs(rdargs)
      CleanUp(10)
   ENDIF
   FreeArgs(rdargs)


/* Open FileID.library V2 or higher */

   IF (fileidbase := OpenLibrary('FileID.library',2)) <> NIL

/* Allocate the FileInfo structure */

      IF (fib := FiAllocFileInfo()) <> NIL

/* Identify the supplied filename */

         IF FiIdentifyFromName(fib,filename) = NIL
            WriteF('\e[1mFilename:\e[22m \s\n',filename)
            WriteF('\e[1mFileType:\e[22m #\d \e[1m-\e[22m \s\n',fib.id,fib.description)
         ELSE
            WriteF('Error while examining file!\n')
         ENDIF

/* Free the FileInfo structure */
         FiFreeFileInfo(fib)

      ELSE
         WriteF('Couln''t allocate Info structure!\n')
      ENDIF

/* Close the library */

      CloseLibrary(fileidbase)
   ENDIF
ENDPROC

