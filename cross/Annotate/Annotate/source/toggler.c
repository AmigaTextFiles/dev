#ifdef AMIGA
    #include <exec/types.h>
    #include <exec/execbase.h>
    #include <dos/dos.h>
#endif
#ifdef WIN32
    #include <windows.h>

    typedef unsigned char       UBYTE;
    typedef unsigned char       TEXT;
    typedef unsigned short      UWORD;
    typedef unsigned long       ULONG;
    typedef unsigned char*      STRPTR;
    #define IMPORT              extern
    #define __inline
#endif

#include <stdio.h>
#include <stdlib.h>

typedef signed char    FLAG;   /* 8-bit signed quantity (replaces BOOL) */
typedef signed char    SBYTE;  /* 8-bit signed quantity (replaces Amiga BYTE) */
typedef signed short   SWORD;  /* 16-bit signed quantity (replaces Amiga WORD) */
typedef signed long    SLONG;  /* 32-bit signed quantity (same as LONG) */
#define elif           else if
#define AGLOBAL        ;       /* global (project-scope) */
#define MODULE         static  /* external static (file-scope) */
#define PERSIST        static  /* internal static (function-scope) */
#define AUTO           auto    /* automatic (function-scope) */
#define DISCARD        (void)

MODULE void rq(STRPTR message);

IMPORT struct ExecBase* SysBase;

MODULE TEXT             filename[512 + 1];
MODULE UBYTE*           IOBuffer /* = NULL */ ;

void main(int argc, char** argv)
{   ULONG                 thesize;
    FILE*                 FHandle /* = NULL */ ;

#ifdef AMIGA
    BPTR                  BHandle /* = NULL */ ;
    SLONG                 args[1 + 1]  = {0, 0};
    struct FileInfoBlock* FIBPtr    /* = NULL */ ;
    struct RDArgs*        ArgsPtr   = NULL;
#endif
#ifdef WIN32
    HANDLE                hFile     /* = NULL */ ;
    int                   i;
#endif

    /* Start of program.

    version embedding into executable */
    if (0) /* that is, never */
    {   printf("$VER: Toggler 1.42a (15.10.2007)");
    }

#ifdef AMIGA
    if (SysBase->LibNode.lib_Version < 36L)
    {   rq("Toggler: Need AmigaOS 2.0+!");
    }

    if (argc) /* started from CLI */
    {   if (!(ArgsPtr = ReadArgs
        (   "FILE/A", // all compulsory (/A) arguments must be first
            (LONG *) args,
            NULL
        )))
        {   printf
            (   "Usage: %s [FILE=]<filename>\n",
                argv[0]
            );
            exit(EXIT_FAILURE);
        }
        // assert(args[0]);
        if (strlen(args[0]) > 512)
        {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
            FreeArgs(ArgsPtr);
            // ArgsPtr = NULL;
            exit(EXIT_FAILURE);
        }
        strcpy(filename, args[0]);
    } else // started from WB
    {   printf
        (   "Usage: %s [FILE=]<filename>\n",
            argv[0]
        );
        FreeArgs(ArgsPtr);
        // ArgsPtr = NULL;
        exit(EXIT_FAILURE);
    }
    if (ArgsPtr)
    {   FreeArgs(ArgsPtr);
        // ArgsPtr = NULL;
    }
#endif
#ifdef WIN32
    if (argc >= 2)
    {   for (i = 1; i < argc; i++)
        {   if (!strcmp(argv[i], "?"))
            {   printf
                (   "Usage: %s [FILE=]<filename>\n",
                    argv[0]
                );
                exit(EXIT_SUCCESS);
            } elif (!strnicmp(argv[i], "FILE", 4))
            {   if (argv[i][4] != '=')
                {   printf
                    (   "Usage: %s [FILE=]<filename>\n",
                        argv[0]
                    );
                    exit(EXIT_FAILURE);
                }
                if (strlen(&argv[i][5]) > 512)
                {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
                    exit(EXIT_FAILURE);
                }
                strcpy(filename, (STRPTR) &argv[i][5]);
            } else
            {   if (strlen(argv[i]) > 512)
                {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
                    exit(EXIT_FAILURE);
                }
                strcpy(filename, argv[i]);
    }   }   }
    else
    {   printf
        (   "Usage: %s [FILE=]<filename>\n",
            argv[0]
        );
        exit(EXIT_FAILURE);
    }
#endif

#ifdef AMIGA
    if (!(BHandle = (BPTR) Lock(filename, ACCESS_READ)))
    {   rq("Lock() failed!");
    }
    if (!(FIBPtr = AllocDosObject(DOS_FIB, NULL)))
    {   UnLock(BHandle);
        // BHandle = NULL;
        rq("AllocDosObject() failed!");
    }
    if (!(Examine(BHandle, FIBPtr)))
    {   FreeDosObject(DOS_FIB, FIBPtr);
        // FIBPtr = NULL;
        UnLock(BHandle);
        // BHandle = NULL;
        rq("Examine() failed!");
    }
    thesize = (ULONG) FIBPtr->fib_Size;
    if (FIBPtr->fib_DirEntryType != -3)
    {   FreeDosObject(DOS_FIB, FIBPtr);
        // FIBPtr = NULL;
        rq("Not a file!");
    }
    FreeDosObject(DOS_FIB, FIBPtr);
    // FIBPtr = NULL;
    UnLock(BHandle);
    // BHandle = NULL;
#endif
#ifdef WIN32
    hFile = CreateFile(filename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {   thesize = 0;
    } else
    {   thesize = GetFileSize(hFile, NULL);
        CloseHandle(hFile);
        // hFile = NULL;
        if (thesize == (ULONG) -1)
        {   thesize = 0;
    }   }
#endif

    if (!(IOBuffer = malloc(thesize)))
    {   rq("Out of memory!");
    }
    if (!(FHandle = fopen((char *) filename, "rb"))) // just cast for lint
    {   rq("Can't open file for reading!");
    }
    if (fread(IOBuffer, (size_t) thesize, 1, FHandle) != 1)
    {   fclose(FHandle);
        FHandle = NULL;
        free(IOBuffer);
        IOBuffer = NULL;
        rq("Can't read from file!");
    }
    fclose(FHandle);
    // FHandle = NULL;

    /* IOBuffer is now allocated and filled. */

    if (IOBuffer[0] == 0x00)
    {   IOBuffer[0] = 0x1F;
    } elif (IOBuffer[0] == 0x1F)
    {   IOBuffer[0] = 0x00;
    } else
    {   free(IOBuffer);
        IOBuffer = NULL;
        rq("Unrecognized file!");
    }

    if (!(FHandle = fopen((char *) filename, "wb"))) // just cast for lint
    {   rq("Can't open file for writing!");
    }
    DISCARD fwrite(IOBuffer, (size_t) thesize, 1, FHandle);
    DISCARD fclose(FHandle);
}

MODULE void rq(STRPTR message)
{   printf("%s\n", message);
    exit(EXIT_FAILURE);
}
