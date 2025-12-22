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

// #define TESTING
// enable this if you don't want arguments

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
#define acase          break; case
#define adefault       break; default

// ASCII characters
#define TAB             9
#define LF             10
#define CR             13

// machines
// variants of the same machine must be contiguously consecutive
#define INTERTON_A      0
#define INTERTON_B      1
#define INTERTON_C      2
#define INTERTON_D      3
#define ELEKTOR_E       4
#define ELEKTOR_F       5
#define ARCADIA_G       6
#define ARCADIA_H       7
#define ARCADIA_I       8
#define PIPBUG_J        9
#define PIPBUG_K       10
#define PIPBUG_L       11
#define PIPBUG_M       12
#define PIPBUG_P       13
#define INSTRUCTOR_N   14
#define INSTRUCTOR_O   15
#define CD2650_U       16
#define GENERIC        17

#define PSU_S           0x80
#define PSU_F           0x40
#define PSU_II          0x20

#define PSL_IDC         0x20
#define PSL_RS          0x10
#define PSL_WC          0x08
#define PSL_OVF         0x04
#define PSL_COM         0x02
#define PSL_C           0x01

#ifdef AMIGA
    #define EXTRAARG " [AMIGA] "
#endif
#ifdef WIN32
    #define EXTRAARG " "
#endif

#define USAGE "Usage: %s [FILE|ASMFILE=]<filename> [LEVEL=<number>]" \
EXTRAARG \
"[MACHINE=<machine>] [BINFILE|PGMFILE=<filename>]\n"

#include "annotate.h"

MODULE void rq(STRPTR message);
MODULE void absolute(void);
MODULE void getea(void);
MODULE void immediate(FLAG bin, TEXT special);
MODULE void skip(void);
MODULE void zero(TEXT special);
MODULE FLAG getcondition(FLAG istrue);
MODULE void binarize(FLAG invert);
MODULE void printlabel(void);
MODULE void dolf(void);
MODULE void prepare(ULONG value);
MODULE void tellwhere(void);
MODULE UBYTE grabvalue(void);
MODULE void psu(FLAG invert);
MODULE void psl(FLAG invert);
MODULE void printusage(STRPTR name);
MODULE int getsize(STRPTR passedfilename);
MODULE FLAG replace(FLAG whether);
MODULE void printrange(void);

IMPORT struct ExecBase*      SysBase;

MODULE UBYTE                *Buffer1     = NULL,
                            *Buffer2     = NULL,
                            *Buffer3     = NULL;
MODULE UBYTE                 memory[32768];
MODULE ULONG                 ic, oc,
                             level       = 7,
                             machine     = ARCADIA_G,
                             rangeaddress,
                             x;
MODULE TEXT                  binfilename[512 + 1] = "",
                             errorstring[512 + 80 + 1],
                             asmfilename[512 + 1],
                             op[7 + 1],
                             r,
                             where[4];
MODULE int                   penalty;

#ifdef AMIGA
    MODULE FLAG              ibm         = TRUE;
#endif
#ifdef WIN32
    MODULE FLAG              ibm         = FALSE; // done automatically
#endif

void main(int argc, char** argv)
{   ULONG                 ac, hc, asmsize, binsize, tc, y, yc;
    int                   address    = 0,
                          i,
                          iar        = 0,
                          tempaddress,
                          xx;
    FILE*                 FHandle /* = NULL */ ;
    FLAG                  addr3,
                          done;
    TEXT                  bytes, cycles;
#ifdef AMIGA
    SLONG                 args[6]    = {0, 0, 0, 0, 0, 0};
    struct RDArgs*        ArgsPtr    = NULL;
#endif

    /* Start of program.

    version embedding into executable */
    if (0) /* that is, never */
    {   printf("$VER: Annotate 2.33 (16.4.2010)");
    }

#ifdef AMIGA
    if (SysBase->LibNode.lib_Version < 36L)
    {   rq("Annotate: Need AmigaOS 2.0+!");
    }

    if (argc) /* started from CLI */
    {   if (!(ArgsPtr = ReadArgs
        (   "FILE=ASMFILE/A,LEVEL/N,AMIGA/S,MACHINE/K,BINFILE=PGMFILE/K", // all compulsory (/A) arguments must be first
            (LONG *) args,
            NULL
        )))
        {   printusage(argv[0]);
            exit(EXIT_FAILURE);
        }
        // assert(args[0]);
        if (strlen(args[0]) > 512)
        {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
            FreeArgs(ArgsPtr);
            ArgsPtr = NULL;
            exit(EXIT_FAILURE);
        }
        strcpy(asmfilename, args[0]);
        if (args[1])
        {   level = (ULONG) (*((SLONG *) args[1]));
            if (level < 1 && level > 8)
            {   printf("%s: <number> must be 1-8!\n", argv[0]);
                FreeArgs(ArgsPtr);
                ArgsPtr = NULL;
                exit(EXIT_FAILURE);
        }   }
        if (args[2])
        {   ibm = FALSE;
        }
        if (args[3])
        {   if     (!stricmp(args[3], "INTERTON_A"  ))
            {   machine = INTERTON_A;
            } elif (!stricmp(args[3], "INTERTON_B"  ))
            {   machine = INTERTON_B;
            } elif (!stricmp(args[3], "INTERTON_C"  ))
            {   machine = INTERTON_C;
            } elif (!stricmp(args[3], "INTERTON_D"  ))
            {   machine = INTERTON_D;
            } elif (!stricmp(args[3], "ELEKTOR_E"   ))
            {   machine = ELEKTOR_E;
            } elif (!stricmp(args[3], "ELEKTOR_F"   ))
            {   machine = ELEKTOR_F;
            } elif (!stricmp(args[3], "ARCADIA_G"   ))
            {   machine = ARCADIA_G;
            } elif (!stricmp(args[3], "ARCADIA_H"   ))
            {   machine = ARCADIA_H;
            } elif (!stricmp(args[3], "ARCADIA_I"   ))
            {   machine = ARCADIA_I;
            } elif (!stricmp(args[3], "PIPBUG_J"    ))
            {   machine = PIPBUG_J;
            } elif (!stricmp(args[3], "PIPBUG_K"    ))
            {   machine = PIPBUG_K;
            } elif (!stricmp(args[3], "PIPBUG_L"    ))
            {   machine = PIPBUG_L;
            } elif (!stricmp(args[3], "PIPBUG_M"    ))
            {   machine = PIPBUG_M;
            } elif (!stricmp(args[3], "PIPBUG_P"    ))
            {   machine = PIPBUG_P;
            } elif (!stricmp(args[3], "INSTRUCTOR_N"))
            {   machine = INSTRUCTOR_N;
            } elif (!stricmp(args[3], "INSTRUCTOR_O"))
            {   machine = INSTRUCTOR_O;
            } elif (!stricmp(args[3], "CD2650_U"    ))
            {   machine = CD2650_U;
            } elif (!stricmp(args[3], "GENERIC"     ))
            {   machine = GENERIC;
            } else
            {   printusage(argv[0]);
                FreeArgs(ArgsPtr);
                ArgsPtr = NULL;
                exit(EXIT_FAILURE);
        }   }
        if (args[4])
        {   strcpy(binfilename, args[4]);
    }   }
    else // started from WB
    {   printusage("Annotate: ");
        FreeArgs(ArgsPtr);
        ArgsPtr = NULL;
        exit(EXIT_FAILURE);
    }
    if (ArgsPtr)
    {   FreeArgs(ArgsPtr);
        // ArgsPtr = NULL;
    }
#endif

#ifdef WIN32
#ifdef TESTING
    strcpy(asmfilename, "..\\ROBOTKI1.ASM");
    strcpy(binfilename, "..\\ROBOTKIL.BIN");
    level = 8;
    machine = ARCADIA_G;
#else
    if (argc >= 2)
    {   for (i = 1; i < argc; i++)
        {   if (!strcmp(argv[i], "?"))
            {   printusage(argv[0]);
                exit(EXIT_SUCCESS);
            } elif (!strnicmp(argv[i], "LEVEL", 5))
            {   if     (!strcmp(&argv[i][5], "=1"))
                {   level = 1;
                } elif (!strcmp(&argv[i][5], "=2"))
                {   level = 2;
                } elif (!strcmp(&argv[i][5], "=3"))
                {   level = 3;
                } elif (!strcmp(&argv[i][5], "=4"))
                {   level = 4;
                } elif (!strcmp(&argv[i][5], "=5"))
                {   level = 5;
                } elif (!strcmp(&argv[i][5], "=6"))
                {   level = 6;
                } elif (!strcmp(&argv[i][5], "=7"))
                {   level = 7;
                } elif (!strcmp(&argv[i][5], "=8"))
                {   level = 8;
                } else
                {   printf("%s: <number> must be 1-8!\n", argv[0]);
                    exit(EXIT_FAILURE);
            }   }
            elif (!strnicmp(argv[i], "MACHINE", 7))
            {   if     (!stricmp(&argv[i][7], "=INTERTON_A"  ))
                {   machine = INTERTON_A;
                } elif (!stricmp(&argv[i][7], "=INTERTON_B"  ))
                {   machine = INTERTON_B;
                } elif (!stricmp(&argv[i][7], "=INTERTON_C"  ))
                {   machine = INTERTON_C;
                } elif (!stricmp(&argv[i][7], "=INTERTON_D"  ))
                {   machine = INTERTON_D;
                } elif (!stricmp(&argv[i][7], "=ELEKTOR_E"   ))
                {   machine = ELEKTOR_E;
                } elif (!stricmp(&argv[i][7], "=ELEKTOR_F"   ))
                {   machine = ELEKTOR_F;
                } elif (!stricmp(&argv[i][7], "=ARCADIA_G"   ))
                {   machine = ARCADIA_G;
                } elif (!stricmp(&argv[i][7], "=ARCADIA_H"   ))
                {   machine = ARCADIA_H;
                } elif (!stricmp(&argv[i][7], "=ARCADIA_I"   ))
                {   machine = ARCADIA_I;
                } elif (!stricmp(&argv[i][7], "=PIPBUG_J"    ))
                {   machine = PIPBUG_J;
                } elif (!stricmp(&argv[i][7], "=PIPBUG_K"    ))
                {   machine = PIPBUG_K;
                } elif (!stricmp(&argv[i][7], "=PIPBUG_L"    ))
                {   machine = PIPBUG_L;
                } elif (!stricmp(&argv[i][7], "=PIPBUG_M"    ))
                {   machine = PIPBUG_M;
                } elif (!stricmp(&argv[i][7], "=PIPBUG_P"    ))
                {   machine = PIPBUG_P;
                } elif (!stricmp(&argv[i][7], "=INSTRUCTOR_N"))
                {   machine = INSTRUCTOR_N;
                } elif (!stricmp(&argv[i][7], "=INSTRUCTOR_O"))
                {   machine = INSTRUCTOR_O;
                } elif (!stricmp(&argv[i][7], "=CD2650_U"    ))
                {   machine = CD2650_U;
                } elif (!stricmp(&argv[i][7], "=GENERIC"     ))
                {   machine = GENERIC;
                } else
                {   printusage(argv[0]);
                    exit(EXIT_FAILURE);
            }   }
            elif (!strnicmp(argv[i], "FILE", 4))
            {   if (argv[i][4] != '=')
                {   printusage(argv[0]);
                    exit(EXIT_FAILURE);
                }
                if (strlen(&argv[i][5]) > 512)
                {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
                    exit(EXIT_FAILURE);
                }
                strcpy(asmfilename, (STRPTR) &argv[i][5]);
            } elif (!strnicmp(argv[i], "ASMFILE", 7))
            {   if (argv[i][7] != '=')
                {   printusage(argv[0]);
                    exit(EXIT_FAILURE);
                }
                if (strlen(&argv[i][8]) > 512)
                {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
                    exit(EXIT_FAILURE);
                }
                strcpy(asmfilename, (STRPTR) &argv[i][8]);
            } elif
            (   !strnicmp(argv[i], "BINFILE", 7)
             || !strnicmp(argv[i], "PGMFILE", 7)
            )
            {   strcpy(binfilename, (STRPTR) &argv[i][8]);
            } else
            {   if (strlen(argv[i]) > 512)
                {   printf("%s: <filename> must be <= 512 characters!\n", argv[0]);
                    exit(EXIT_FAILURE);
                }
                strcpy(asmfilename, argv[i]);
    }   }   }
    else
    {   printusage(argv[0]);
        exit(EXIT_FAILURE);
    }
#endif
#endif

    if (binfilename[0])
    {   binsize = getsize(binfilename);
        if (binsize > 32768)
        {   rq("Binary file must be <= 32K!");
        }
        if (!(FHandle = fopen((char *) binfilename, "rb"))) // just cast for lint
        {   sprintf
            (   errorstring,
                "fopen(\"%s\") failed!",
                binfilename
            );
            rq(errorstring);
        }
        if (fread(memory, (size_t) binsize, 1, FHandle) != 1)
        {   fclose(FHandle);
            FHandle = NULL;
            sprintf
            (   errorstring,
                "fread(\"%s\") failed!",
                binfilename
            );
            rq(errorstring);
        }
        fclose(FHandle);
        // FHandle = NULL;

        if (level < 8)
        {   level = 8;
    }   }

    // better if these array indices weren't hard-coded
    switch (machine)
    {
    case INTERTON_A:
    case INTERTON_B:
    case INTERTON_C:
    case INTERTON_D:
        pvi_ranges[21].description = "unmapped";
        pvi_ranges[30].description = "unmapped";
        pvi_ranges[31].description = "mirror of $0000..$1FFF"; // thrice
    acase ELEKTOR_E:
        pvi_ranges[0].description  = "unknown";
    acase ELEKTOR_F:
        pvi_ranges[21].description = "1st German randomizer";
        pvi_ranges[30].description = "1st English randomizer";
        pvi_ranges[31].description = "normally unused";
    acase ARCADIA_G:
        a_memmap[ 1].description = "mirror of $1800..$18FF";
        a_memmap[ 2].description = "mirror of $1900..$19FF";
        a_memmap[ 3].description = "mirror of $1A00..$1AFF";
        a_memmap[ 4].description = "mirror of $1B00..$1BFF";
        a_memmap[ 5].description = "mirror of $1000..$13FF";
        a_memmap[25].description = "mirror of $1800..$1BFF";
        a_memmap[27].description =
        a_memmap[29].description =
        a_memmap[31].description = "mirror of $1000..$1FFF";
        a_memmap[28].description =
        a_memmap[30].description = "mirror of $0000..$0FFF?";

        a_header[1] =
";                   $1000..$10FF: (*/*)  mirror of $1800..$18FF";
        a_header[2] =
";                   $1100..$11FF: (*/*)  mirror of $1900..$19FF";
        a_header[3] =
";                   $1200..$12FF: (*/*)  mirror of $1A00..$1AFF";
        a_header[4] =
";                   $1300..$13FF: (*/*)  mirror of $1B00..$1BFF";
        a_header[5] =
";                   $1400..$17FF: (*/*)  mirror of $1000..$13FF";
        a_header[147] =
";                   $1C00..$1FFF: (*/*)  mirror of $1800..$1BFF";
        a_header[149] =
";                   $3000..$3FFF: (*/*)  mirror of $1000..$1FFF";
        a_header[150] =
";                   $4000..$4FFF: (*/*)  mirror of $0000..$0FFF?";
        a_header[151] =
";                   $5000..$5FFF: (*/*)  mirror of $1000..$1FFF";
        a_header[152] =
";                   $6000..$6FFF: (*/*)  mirror of $0000..$0FFF?";
        a_header[153] =
";                   $7000..$7FFF: (*/*)  mirror of $1000..$1FFF";
    acase ARCADIA_H:
        a_memmap[ 1].description = "CPU RAM";
        a_memmap[ 2].description = "mirror of $1900..$19FF";
        a_memmap[ 3].description = "CPU RAM";
        a_memmap[ 4].description = "mirror of $1B00..$1BFF";
        a_memmap[ 5].description = "mirror of $1000..$13FF";
        a_memmap[25].description = "mirror of $1800..$1BFF";
        a_memmap[27].description =
        a_memmap[29].description =
        a_memmap[31].description = "mirror of $1000..$1FFF";
        a_memmap[28].description =
        a_memmap[30].description = "mirror of $0000..$0FFF?";

        a_header[1] =
";                   $1000..$10FF: (R/W)  256 bytes of CPU RAM";
        a_header[2] =
";                   $1100..$11FF: (*/*)  mirror of $1900..$19FF";
        a_header[3] =
";                   $1200..$12FF: (R/W)  256 bytes of CPU RAM";
        a_header[4] =
";                   $1300..$13FF: (*/*)  mirror of $1B00..$1BFF";
        a_header[5] =
";                   $1400..$17FF: (*/*)  mirror of $1000..$13FF";
        a_header[147] =
";                   $1C00..$1FFF: (*/*)  mirror of $1800..$1BFF";
        a_header[149] =
";                   $3000..$3FFF: (*/*)  mirror of $1000..$1FFF";
        a_header[150] =
";                   $4000..$4FFF: (*/*)  mirror of $0000..$0FFF?";
        a_header[151] =
";                   $5000..$5FFF: (*/*)  mirror of $1000..$1FFF";
        a_header[152] =
";                   $6000..$6FFF: (*/*)  mirror of $0000..$0FFF?";
        a_header[153] =
";                   $7000..$7FFF: (*/*)  mirror of $1000..$1FFF";
    acase ARCADIA_I:
        a_memmap[ 1].description =
        a_memmap[ 2].description =
        a_memmap[ 3].description =
        a_memmap[ 4].description =
        a_memmap[ 5].description =
        a_memmap[25].description =
        a_memmap[27].description =
        a_memmap[28].description =
        a_memmap[29].description =
        a_memmap[30].description =
        a_memmap[31].description = "ROM";

        a_header[1] =
";                   $1000..$10FF: (R/-)  ROM";
        a_header[2] =
";                   $1100..$11FF: (R/-)  ROM";
        a_header[3] =
";                   $1200..$12FF: (R/-)  ROM";
        a_header[4] =
";                   $1300..$13FF: (R/-)  ROM";
        a_header[5] =
";                   $1400..$17FF: (R/-)  ROM";
        a_header[147] =
";                   $1C00..$1FFF: (R/-)  ROM";
        a_header[149] =
";                   $3000..$3FFF: (R/-)  ROM";
        a_header[150] =
";                   $4000..$4FFF: (R/-)  ROM";
        a_header[151] =
";                   $5000..$5FFF: (R/-)  ROM";
        a_header[152] =
";                   $6000..$6FFF: (R/-)  ROM";
        a_header[153] =
";                   $7000..$7FFF: (R/-)  ROM";
    acase PIPBUG_J:
        p_ranges[3].description = "mirror of $400..$4FF";
    acase PIPBUG_K:
        p_ranges[3].description = "game RAM";
    acase PIPBUG_L:
        p_ranges[3].description =
        p_ranges[4].description = "game RAM";
        p_ranges[5].description =
        p_ranges[6].description = "unused?";
    acase PIPBUG_M:
        p_ranges[3].description =
        p_ranges[4].description =
        p_ranges[5].description =
        p_ranges[6].description = "game RAM";
    acase PIPBUG_P:
        p_ranges[3].description =
        p_ranges[4].description =
        p_ranges[5].description =
        p_ranges[6].description =
        p_ranges[7].description = "game+utility RAM";
        p_ranges[9].description = "utility EPROM";
        p_ranges[11].description = "RAM?";
    acase INSTRUCTOR_N:
        s_ranges[1].description =
        s_ranges[7].description = "unused?";
    }

    // first pass --------------------------------------------------------

    asmsize = getsize(asmfilename);

    if (!(Buffer1 = malloc(asmsize + 1)))
    {   rq("Out of memory!");
    }

    if (!(FHandle = fopen((char *) asmfilename, "rb"))) // just cast for lint
    {   rq("fopen() failed!");
    }
    if (fread(Buffer1, (size_t) asmsize, 1, FHandle) != 1)
    {   fclose(FHandle);
        FHandle = NULL;
        free(Buffer1);
        Buffer1 = NULL;
        rq("fread() failed!");
    }
    fclose(FHandle);
    // FHandle = NULL;
    Buffer1[asmsize] = 0;

    /* Buffer1 is now allocated and filled. */

    if (!(Buffer2 = malloc(16384 + (asmsize * 4))))
    {   rq("Out of memory!");
    }

    ic = oc = x = y = 0;
    addr3 = FALSE;

    // There are some other substitutions which we really shouldn't make
    // in the header comments (eg. "bsna,r"), although they are unlikely
    // to be present there anyway.

    while (ic < asmsize)
    {   if (!strncmp(&Buffer1[ic], "\t\t\t\t\t\t;INFO: indirect jump", 26))
        {   ic += 26;
        } elif (Buffer1[ic] == TAB)
        {   xx = 8 - (x % 8);
            x += xx;
            for (i = 1; i <= xx; i++)
            {   Buffer2[oc++] = ' ';
            }
            ic++;
        } elif
        (   y >= 15
         && (   (Buffer1[ic] == 'X' && Buffer1[ic + 5] != ':')
             || (   Buffer1[ic] == 'L'
// was           && (   (Buffer1[ic + 1] >= '2' && Buffer1[ic + 1] <= '9') // "L2xxx" -> "$2xxx", "L4xxx" -> "$4xxx", etc.
                 && (   (Buffer1[ic + 1] >= '0' && Buffer1[ic + 1] <= '9') // "L2xxx" -> "$2xxx", "L4xxx" -> "$4xxx", etc.
                     || (Buffer1[ic + 1] >= 'A' && Buffer1[ic + 1] <= 'F')
        )   )   )   )
        {   if (x == 0)
            {   Buffer2[oc++] = ';';
                x++;
            }
            Buffer2[oc    ] = '$';             // "$1234"
            Buffer2[oc + 1] = Buffer1[ic + 1]; // "$1234"
            Buffer2[oc + 2] = Buffer1[ic + 2]; // "$1234"
            Buffer2[oc + 3] = Buffer1[ic + 3]; // "$1234"
            Buffer2[oc + 4] = Buffer1[ic + 4]; // "$1234"
            ic += 5;
            oc += 5;
            x += 5;
        } elif // "01234H" -> "$1234"
        (   y >= 15
         &&   Buffer1[ic    ] == '0'
         && ((Buffer1[ic + 1] >= '0' && Buffer1[ic + 1] <= '9') || (Buffer1[ic + 1] >= 'A' && Buffer1[ic + 1] <= 'F'))
         && ((Buffer1[ic + 2] >= '0' && Buffer1[ic + 2] <= '9') || (Buffer1[ic + 2] >= 'A' && Buffer1[ic + 2] <= 'F'))
         && ((Buffer1[ic + 3] >= '0' && Buffer1[ic + 3] <= '9') || (Buffer1[ic + 3] >= 'A' && Buffer1[ic + 3] <= 'F'))
         && ((Buffer1[ic + 4] >= '0' && Buffer1[ic + 4] <= '9') || (Buffer1[ic + 4] >= 'A' && Buffer1[ic + 4] <= 'F'))
         &&   Buffer1[ic + 5] == 'H'
        )
        {   Buffer2[oc    ] = '$';             // "$1234"
            Buffer2[oc + 1] = Buffer1[ic + 1]; // "$1234"
            Buffer2[oc + 2] = Buffer1[ic + 2]; // "$1234"
            Buffer2[oc + 3] = Buffer1[ic + 3]; // "$1234"
            Buffer2[oc + 4] = Buffer1[ic + 4]; // "$1234"
            ic += 6;
            oc += 5;
            x += 5;
        } elif
        (   y >= 15
         && Buffer1[ic    ] == '0'
         && Buffer1[ic + 3] == 'H'
        )
        {   // change "012H" to "$12"
            Buffer2[oc] = '$';
            Buffer2[oc + 1] = Buffer1[ic + 1];
            Buffer2[oc + 2] = Buffer1[ic + 2];
            ic += 4;
            oc += 3;
            x += 3;
        } elif
        (   Buffer1[ic] == ','
         && (   Buffer1[ic + 1] == '+'
             || Buffer1[ic + 1] == '-'
        )   )
        {   ic++;
            Buffer2[oc++] = Buffer1[ic++];
            x++;
        } elif (Buffer1[ic] == CR)
        {   ic++;
        } elif
        (   !strncmp(&Buffer1[ic], "bsna,r", 6)
         || !strncmp(&Buffer1[ic], "bsnr,r", 6)
        )
        {   Buffer2[oc] = 0;
            strncat(&Buffer2[oc], &Buffer1[ic], 5); // copy "bsna," or "bsnr,"
            ic += 6;
            oc += 5;
            if (Buffer1[ic] == '0')
            {   Buffer2[oc++] = 'e';
                Buffer2[oc++] = 'q';
            } elif (Buffer1[ic] == '1')
            {   Buffer2[oc++] = 'g';
                Buffer2[oc++] = 't';
            } elif (Buffer1[ic] == '2')
            {   Buffer2[oc++] = 'l';
                Buffer2[oc++] = 't';
            } else
            {   // assert(Buffer1[ic] == '3');
                Buffer2[oc++] = 'u';
                Buffer2[oc++] = 'n';
            }
            Buffer2[oc++] = ' ';
            Buffer2[oc] = 0;
            ic += 2;
        } elif (Buffer1[ic] == LF)
        {   if (addr3)
            {   Buffer2[oc++] = ',';
                Buffer2[oc++] = 'r';
                Buffer2[oc++] = '3';
                addr3 = FALSE;
            }
            Buffer2[oc++] = Buffer1[ic++];
            x = 0;
            y++;
            if (y == 5)
            {   Buffer2[oc] = 0;

                strcat(Buffer2,
";       Commented by:\n"
";               Annotate 2.33 (16 Apr 2010) by Amigan Software\n"
                );

                oc = strlen(Buffer2);
            } elif (y == 15)
            {   Buffer2[oc] = 0;

                strcat(Buffer2,
";       Platform:       "
                );
                if (machine == ARCADIA_G)
                {   strcat(Buffer2, "Emerson Arcadia 2001 family, type \"G\"\n");
                } elif (machine == ARCADIA_H)
                {   strcat(Buffer2, "Emerson Arcadia 2001 family, type \"H\"\n");
                } elif (machine == ARCADIA_I)
                {   strcat(Buffer2, "Emerson Arcadia 2001 family, type \"I\"\n");
                } elif (machine == ELEKTOR_E)
                {   strcat(Buffer2, "Elektor TV Games Computer, type \"E\" (base)\n");
                } elif (machine == ELEKTOR_F)
                {   strcat(Buffer2, "Elektor TV Games Computer, type \"F\" (expanded)\n");
                } elif (machine == PIPBUG_J)
                {   strcat(Buffer2, "Electronics Australia 77up2\n");
                } elif (machine == PIPBUG_K)
                {   strcat(Buffer2, "Signetics Adaptable Board Computer\n");
                } elif (machine == PIPBUG_L)
                {   strcat(Buffer2, "Electronics Australia 77up5, type \"L\" (1K)\n");
                } elif (machine == PIPBUG_M)
                {   strcat(Buffer2, "Electronics Australia 77up5, type \"M\" (8K)\n");
                } elif (machine == PIPBUG_P)
                {   strcat(Buffer2, "Electronics Australia 77up5, type \"P\" (11K+EPROM)\n");
                } elif (machine == INSTRUCTOR_N)
                {   strcat(Buffer2, "Signetics Instructor 50, type \"N\" (basic)\n");
                } elif (machine == INSTRUCTOR_O)
                {   strcat(Buffer2, "Signetics Instructor 50, type \"O\" (expanded)\n");
                } elif (machine == CD2650_U)
                {   strcat(Buffer2, "Central Data 2650\n");
                } elif (machine == GENERIC)
                {   strcat(Buffer2, "Generic 2650-based machine\n");
                } else
                {   strcat(Buffer2, "Interton VC 4000 family, type \"");
                    if (machine == INTERTON_A)
                    {   strcat(Buffer2, "A\" (2K ROM + 0");
                    } elif (machine == INTERTON_B)
                    {   strcat(Buffer2, "B\" (4K ROM + 0");
                    } elif (machine == INTERTON_C)
                    {   strcat(Buffer2, "C\" (4K ROM + 1");
                    } else
                    {   // assert(machine == INTERTON_D);
                        strcat(Buffer2, "D\" (6K ROM + 1");
                    }
                    strcat(Buffer2, "K RAM)\n");
                }

                oc = strlen(Buffer2);
            } elif (y == 16)
            {   ic += 6;
                Buffer2[oc] = 0;

                if (level >= 3 && machine != GENERIC)
                {   strcat(Buffer2, ";Hardware Equates/Memory Map----------------------------------------------\n");
                    if (machine >= INTERTON_A && machine <= INTERTON_D)
                    {   for (i = 0; i < i_headerlines[machine - INTERTON_A]; i++)
                        {   strcat(Buffer2, i_header[machine - INTERTON_A][i]);
                            oc += strlen(i_header[machine - INTERTON_A][i]);
                            dolf();
                        }
                        for (i = 0; i < I_ANYHEADERLINES; i++)
                        {   if (level >= 5 || i_anyheader[i][0] != ';')
                            {   strcat(Buffer2, i_anyheader[i]);
                                oc += strlen(i_anyheader[i]);
                                dolf();
                    }   }   }
                    elif (machine == ELEKTOR_E)
                    {   for (i = 0; i < E_E_HEADERLINES; i++)
                        {   if (level >= 5 || e_e_header[i][0] != ';')
                            {   strcat(Buffer2, e_e_header[i]);
                                oc += strlen(e_e_header[i]);
                                dolf();
                    }   }   }
                    elif (machine == ELEKTOR_F)
                    {   for (i = 0; i < E_F_HEADERLINES; i++)
                        {   if (level >= 5 || e_f_header[i][0] != ';')
                            {   strcat(Buffer2, e_f_header[i]);
                                oc += strlen(e_f_header[i]);
                                dolf();
                    }   }   }
                    elif (machine >= ARCADIA_G && machine <= ARCADIA_I)
                    {   for (i = 0; i < A_HEADERLINES; i++)
                        {   if (level >= 5 || a_header[i][0] != ';')
                            {   strcat(Buffer2, a_header[i]);
                                oc += strlen(a_header[i]);
                                dolf();
                    }   }   }

                    if (machine == ELEKTOR_E || machine == ELEKTOR_F)
                    {   for (i = 0; i < M_HEADERLINES; i++)
                        {   strcat(Buffer2, m_header[i]);
                            oc += strlen(m_header[i]);
                            dolf();
                    }   }
                    elif (machine >= PIPBUG_J && machine <= PIPBUG_P)
                    {   for (i = 0; i < P_HEADERLINES; i++)
                        {   strcat(Buffer2, p_header[i]);
                            oc += strlen(p_header[i]);
                            dolf();
                        }
                        if (machine == PIPBUG_P)
                        {   for (i = 0; i < P_P_HEADERLINES; i++)
                            {   strcat(Buffer2, p_p_header[i]);
                                oc += strlen(p_p_header[i]);
                                dolf();
                    }   }   }
                    elif (machine == INSTRUCTOR_N || machine == INSTRUCTOR_O)
                    {   for (i = 0; i < S_HEADERLINES; i++)
                        {   strcat(Buffer2, s_header[i]);
                            oc += strlen(s_header[i]);
                            dolf();
                    }   }
                    elif (machine == CD2650_U)
                    {   for (i = 0; i < C_HEADERLINES; i++)
                        {   strcat(Buffer2, c_header[i]);
                            oc += strlen(c_header[i]);
                            dolf();
                }   }   }

                strcat(Buffer2,
";2650 Equates-------------------------------------------------------------\n"
"z               equ 0\n"
"eq              equ z\n"
"p               equ 1\n"
"gt              equ p\n"
"n               equ 2\n"
"lt              equ n\n"
"un              equ 3\n"
";-------------------------------------------------------------------------\n"
                );

                oc = strlen(Buffer2);
        }   }
        else
        {   if
            (   !strncmp(&Buffer1[ic], "bxa",  3)
             || !strncmp(&Buffer1[ic], "bsxa", 4)
            )
            {   addr3 = TRUE;
            }
            Buffer2[oc++] = Buffer1[ic++];
            x++;
    }   }

    Buffer2[oc] = 0;
    dolf();
    for (i = 0; i <= 7; i++)
    {   Buffer2[oc++] = ' ';
    }
    Buffer2[oc++] = 'e';
    Buffer2[oc++] = 'n';
    Buffer2[oc++] = 'd';
    Buffer2[oc] = 0;
    dolf();
    free(Buffer1);
    Buffer1 = NULL;

    // second pass -------------------------------------------------------

    asmsize = oc;
    if (!(Buffer3 = malloc(asmsize * 16)))
    {   rq("Out of memory!");
    }

    ic = oc = 0;

    if (level <= 1)
    {   while (ic < asmsize)
        {   if (Buffer2[ic] == LF && ibm)
            {   Buffer3[oc++] = CR;
            }
            Buffer3[oc++] = Buffer2[ic++];
        }
        goto FINISH;
    }

    while (ic < asmsize)
    {   tc = ic;
        x = 0;
        ac = oc;

        done = FALSE;
        do
        {   if (Buffer2[ic] == LF)
            {   done = TRUE;
                ic++;
            } else
            {   Buffer3[oc++] = Buffer2[ic++];
                x++;
        }   }
        while (!done);
        hc = ic;
        ic = tc;

        skip();

        bytes = cycles = '0';
        if (level >= 6)
        {   penalty = 0;
            if
            (   !strncmp(&Buffer2[ic], "adda", 4)
             || !strncmp(&Buffer2[ic], "anda", 4)
             || !strncmp(&Buffer2[ic], "bcfa", 4)
             || !strncmp(&Buffer2[ic], "bcta", 4)
             || !strncmp(&Buffer2[ic], "bdra", 4)
             || !strncmp(&Buffer2[ic], "bira", 4)
             || !strncmp(&Buffer2[ic], "brna", 4)
             || !strncmp(&Buffer2[ic], "bsfa", 4)
             || !strncmp(&Buffer2[ic], "bsna", 4)
             || !strncmp(&Buffer2[ic], "bsta", 4)
             || !strncmp(&Buffer2[ic], "bsxa", 4)
             || !strncmp(&Buffer2[ic], "bxa" , 3)
             || !strncmp(&Buffer2[ic], "coma", 4)
             || !strncmp(&Buffer2[ic], "eora", 4)
             || !strncmp(&Buffer2[ic], "iora", 4)
             || !strncmp(&Buffer2[ic], "loda", 4)
             || !strncmp(&Buffer2[ic], "stra", 4)
             || !strncmp(&Buffer2[ic], "suba", 4)
            )
            {   bytes = '3';
            } elif
            (   !strncmp(&Buffer2[ic], "addi", 4)
             || !strncmp(&Buffer2[ic], "addr", 4)
             || !strncmp(&Buffer2[ic], "andi", 4)
             || !strncmp(&Buffer2[ic], "andr", 4)
             || !strncmp(&Buffer2[ic], "bcfr", 4)
             || !strncmp(&Buffer2[ic], "bctr", 4)
             || !strncmp(&Buffer2[ic], "bdrr", 4)
             || !strncmp(&Buffer2[ic], "birr", 4)
             || !strncmp(&Buffer2[ic], "brnr", 4)
             || !strncmp(&Buffer2[ic], "bsfr", 4)
             || !strncmp(&Buffer2[ic], "bsnr", 4)
             || !strncmp(&Buffer2[ic], "bstr", 4)
             || !strncmp(&Buffer2[ic], "comi", 4)
             || !strncmp(&Buffer2[ic], "comr", 4)
             || !strncmp(&Buffer2[ic], "cpsl", 4)
             || !strncmp(&Buffer2[ic], "cpsu", 4)
             || !strncmp(&Buffer2[ic], "eori", 4)
             || !strncmp(&Buffer2[ic], "eorr", 4)
             || !strncmp(&Buffer2[ic], "iori", 4)
             || !strncmp(&Buffer2[ic], "iorr", 4)
             || !strncmp(&Buffer2[ic], "lodi", 4)
             || !strncmp(&Buffer2[ic], "lodr", 4)
             || !strncmp(&Buffer2[ic], "ppsl", 4)
             || !strncmp(&Buffer2[ic], "ppsu", 4)
             || !strncmp(&Buffer2[ic], "rede", 4)
             || !strncmp(&Buffer2[ic], "strr", 4)
             || !strncmp(&Buffer2[ic], "subi", 4)
             || !strncmp(&Buffer2[ic], "subr", 4)
             || !strncmp(&Buffer2[ic], "tmi" , 3)
             || !strncmp(&Buffer2[ic], "tpsl", 4)
             || !strncmp(&Buffer2[ic], "tpsu", 4)
             || !strncmp(&Buffer2[ic], "zbrr", 4)
             || !strncmp(&Buffer2[ic], "zbsr", 4)
             || !strncmp(&Buffer2[ic], "wrte", 4)
            )
            {   bytes = '2';
            } elif
            (   !strncmp(&Buffer2[ic], "addz", 4)
             || !strncmp(&Buffer2[ic], "andz", 4)
             || !strncmp(&Buffer2[ic], "comz", 4)
             || !strncmp(&Buffer2[ic], "dar" , 3)
             || !strncmp(&Buffer2[ic], "eorz", 4)
             || !strncmp(&Buffer2[ic], "halt", 4)
             || !strncmp(&Buffer2[ic], "iorz", 4)
             || !strncmp(&Buffer2[ic], "lodz", 4)
             || !strncmp(&Buffer2[ic], "lpsl", 4)
             || !strncmp(&Buffer2[ic], "lpsu", 4)
             || !strncmp(&Buffer2[ic], "nop" , 3)
             || !strncmp(&Buffer2[ic], "redc", 4)
             || !strncmp(&Buffer2[ic], "redd", 4)
             || !strncmp(&Buffer2[ic], "retc", 4)
             || !strncmp(&Buffer2[ic], "rete", 4)
             || !strncmp(&Buffer2[ic], "rrl" , 3)
             || !strncmp(&Buffer2[ic], "rrr" , 3)
             || !strncmp(&Buffer2[ic], "spsl", 4)
             || !strncmp(&Buffer2[ic], "spsu", 4)
             || !strncmp(&Buffer2[ic], "strz", 4)
             || !strncmp(&Buffer2[ic], "subz", 4)
             || !strncmp(&Buffer2[ic], "wrtc", 4)
             || !strncmp(&Buffer2[ic], "wrtd", 4)
            )
            {   bytes = '1';
            }

            if
            (   !strncmp(&Buffer2[ic], "addi", 4)
             || !strncmp(&Buffer2[ic], "addz", 4)
             || !strncmp(&Buffer2[ic], "andi", 4)
             || !strncmp(&Buffer2[ic], "andz", 4)
             || !strncmp(&Buffer2[ic], "comi", 4)
             || !strncmp(&Buffer2[ic], "comz", 4)
             || !strncmp(&Buffer2[ic], "eori", 4)
             || !strncmp(&Buffer2[ic], "eorz", 4)
             || !strncmp(&Buffer2[ic], "iori", 4)
             || !strncmp(&Buffer2[ic], "iorz", 4)
             || !strncmp(&Buffer2[ic], "halt", 4)
             || !strncmp(&Buffer2[ic], "lodi", 4)
             || !strncmp(&Buffer2[ic], "lodz", 4)
             || !strncmp(&Buffer2[ic], "lpsl", 4)
             || !strncmp(&Buffer2[ic], "lpsu", 4)
             || !strncmp(&Buffer2[ic], "nop",  3)
             || !strncmp(&Buffer2[ic], "rrl",  3)
             || !strncmp(&Buffer2[ic], "rrr",  3)
             || !strncmp(&Buffer2[ic], "spsl", 4)
             || !strncmp(&Buffer2[ic], "spsu", 4)
             || !strncmp(&Buffer2[ic], "strz", 4)
             || !strncmp(&Buffer2[ic], "subi", 4)
             || !strncmp(&Buffer2[ic], "subz", 4)
             || !strncmp(&Buffer2[ic], "redc", 4)
             || !strncmp(&Buffer2[ic], "redd", 4)
             || !strncmp(&Buffer2[ic], "wrtc", 4)
             || !strncmp(&Buffer2[ic], "wrtd", 4)
            )
            {   cycles = '2';
            } elif
            (   !strncmp(&Buffer2[ic], "addr", 4)
             || !strncmp(&Buffer2[ic], "andr", 4)
             || !strncmp(&Buffer2[ic], "bcfa", 4)
             || !strncmp(&Buffer2[ic], "bcfr", 4)
             || !strncmp(&Buffer2[ic], "bcta", 4)
             || !strncmp(&Buffer2[ic], "bctr", 4)
             || !strncmp(&Buffer2[ic], "bdra", 4)
             || !strncmp(&Buffer2[ic], "bdrr", 4)
             || !strncmp(&Buffer2[ic], "bira", 4)
             || !strncmp(&Buffer2[ic], "birr", 4)
             || !strncmp(&Buffer2[ic], "brna", 4)
             || !strncmp(&Buffer2[ic], "brnr", 4)
             || !strncmp(&Buffer2[ic], "bsta", 4)
             || !strncmp(&Buffer2[ic], "bstr", 4)
             || !strncmp(&Buffer2[ic], "bsfa", 4)
             || !strncmp(&Buffer2[ic], "bsfr", 4)
             || !strncmp(&Buffer2[ic], "bsna", 4)
             || !strncmp(&Buffer2[ic], "bsnr", 4)
             || !strncmp(&Buffer2[ic], "bsxa", 4)
             || !strncmp(&Buffer2[ic], "bxa",  3)
             || !strncmp(&Buffer2[ic], "comr", 4)
             || !strncmp(&Buffer2[ic], "cpsl", 4)
             || !strncmp(&Buffer2[ic], "cpsu", 4)
             || !strncmp(&Buffer2[ic], "dar",  3)
             || !strncmp(&Buffer2[ic], "eorr", 4)
             || !strncmp(&Buffer2[ic], "iorr", 4)
             || !strncmp(&Buffer2[ic], "lodr", 4)
             || !strncmp(&Buffer2[ic], "ppsl", 4)
             || !strncmp(&Buffer2[ic], "ppsu", 4)
             || !strncmp(&Buffer2[ic], "rede", 4)
             || !strncmp(&Buffer2[ic], "retc", 4)
             || !strncmp(&Buffer2[ic], "rete", 4)
             || !strncmp(&Buffer2[ic], "strr", 4)
             || !strncmp(&Buffer2[ic], "subr", 4)
             || !strncmp(&Buffer2[ic], "tmi",  3)
             || !strncmp(&Buffer2[ic], "tpsl", 4)
             || !strncmp(&Buffer2[ic], "tpsu", 4)
             || !strncmp(&Buffer2[ic], "wrte", 4)
             || !strncmp(&Buffer2[ic], "zbrr", 4)
             || !strncmp(&Buffer2[ic], "zbsr", 4)
            )
            {   cycles = '3';
            } elif
            (   !strncmp(&Buffer2[ic], "adda", 4)
             || !strncmp(&Buffer2[ic], "anda", 4)
             || !strncmp(&Buffer2[ic], "coma", 4)
             || !strncmp(&Buffer2[ic], "eora", 4)
             || !strncmp(&Buffer2[ic], "iora", 4)
             || !strncmp(&Buffer2[ic], "loda", 4)
             || !strncmp(&Buffer2[ic], "stra", 4)
             || !strncmp(&Buffer2[ic], "suba", 4)
            )
            {   cycles = '4';
        }   }

        if
        (   !strncmp(&Buffer2[ic], "anda", 4)
         || !strncmp(&Buffer2[ic], "andr", 4)
        )
        {   prepare(4);
            strcpy(op, "&=");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "andi", 4))
        {   prepare(4);
            strcpy(op, "&=");
            immediate(TRUE, 'A');
        } elif (!strncmp(&Buffer2[ic], "andz", 4))
        {   prepare(4);
            strcpy(op, "&=");
            zero('A');
        } elif
        (   !strncmp(&Buffer2[ic], "adda", 4)
         || !strncmp(&Buffer2[ic], "addr", 4)
        )
        {   prepare(4);
            strcpy(op, "+=");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "addi", 4))
        {   prepare(4);
            strcpy(op, "+=");
            immediate(FALSE, 'D');
        } elif (!strncmp(&Buffer2[ic], "addz", 4))
        {   prepare(4);
            strcpy(op, "+=");
            zero('D');
        } elif
        (   !strncmp(&Buffer2[ic], "bcfa", 4)
         || !strncmp(&Buffer2[ic], "bcfr", 4)
        )
        {   prepare(4);
            getcondition(FALSE);
            strcat(Buffer3, "if ");
            strcat(Buffer3, op);
            strcat(Buffer3, " goto ");
            printlabel();
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "bcta", 4)
         || !strncmp(&Buffer2[ic], "bctr", 4)
        )
        {   prepare(4);
            if (getcondition(TRUE))
            {   strcat(Buffer3, "if ");
                strcat(Buffer3, op);
                strcat(Buffer3, " ");
                strcat(Buffer3, "goto ");
                printlabel();
            } else
            {   strcat(Buffer3, "goto ");
                printlabel();
                if (penalty == 1)
                {   penalty = 2;
            }   }
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "bdra", 4)
         || !strncmp(&Buffer2[ic], "bdrr", 4)
        )
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "if (--r");
            oc += 7;
            Buffer3[oc++] = r;
            Buffer3[oc] = 0;
            strcat(Buffer3, " != 0) goto ");
            printlabel();
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "bira", 4)
         || !strncmp(&Buffer2[ic], "birr", 4)
        )
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "if (++r");
            oc += 7;
            Buffer3[oc++] = r;
            Buffer3[oc] = 0;
            strcat(Buffer3, " != 0) goto ");
            printlabel();
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "brna", 4)
         || !strncmp(&Buffer2[ic], "brnr", 4)
        )
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "if (r");
            oc += 5;
            Buffer3[oc++] = r;
            Buffer3[oc] = 0;
            strcat(Buffer3, " != 0) goto ");
            printlabel();
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "bsna", 4)
         || !strncmp(&Buffer2[ic], "bsnr", 4)
        )
        {   prepare(4);
            skip();
            r = Buffer2[ic++];
            ic++;
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "if (r");
            oc += 5;
            if (r == 'e')
            {   Buffer3[oc++] = '0';
            } elif (r == 'g')
            {   Buffer3[oc++] = '1';
            } elif (r == 'l')
            {   Buffer3[oc++] = '2';
            } elif (r == 'u')
            {   Buffer3[oc++] = '3';
            } /* else panic! */
            Buffer3[oc] = 0;
            strcat(Buffer3, " != 0) gosub ");
            printlabel();
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "bsfa", 4)
         || !strncmp(&Buffer2[ic], "bsfr", 4)
        )
        {   prepare(4);
            getcondition(FALSE);
            strcat(Buffer3, "if ");
            strcat(Buffer3, op);
            strcat(Buffer3, " gosub ");
            printlabel();
            Buffer3[oc++] = ';';
            printrange();
        } elif
        (   !strncmp(&Buffer2[ic], "bsta", 4)
         || !strncmp(&Buffer2[ic], "bstr", 4)
        )
        {   prepare(4);
            if (getcondition(TRUE))
            {   strcat(Buffer3, "if ");
                strcat(Buffer3, op);
                strcat(Buffer3, " ");
                strcat(Buffer3, "gosub ");
                printlabel();
            } else
            {   strcat(Buffer3, "gosub ");
                printlabel();
                if (penalty == 1)
                {   penalty = 2;
            }   }
            Buffer3[oc++] = ';';
            printrange();
        } elif (!strncmp(&Buffer2[ic], "bsxa", 4))
        {   prepare(4);
            skip();
            strcat(Buffer3, "gosub ");
            printlabel();
            if (penalty == 1)
            {   penalty = 2;
            }
            strcat(Buffer3, " + r3;");
            oc += 6;
            // we don't want to printrange() because it's a calculated jump
        } elif (!strncmp(&Buffer2[ic], "bxa",  3))
        {   prepare(3);
            skip();
            strcat(Buffer3, "goto ");
            printlabel();
            if (penalty == 1)
            {   penalty = 2;
            }
            strcat(Buffer3, " + r3;");
            oc += 6;
            // we don't want to printrange() because it's a calculated jump
        } elif
        (   !strncmp(&Buffer2[ic], "coma", 4)
         || !strncmp(&Buffer2[ic], "comr", 4) // problem with comr
        )
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "compare ");
            oc += 8;
            strcpy(op, "against");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "comi", 4))
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "compare ");
            oc += 8;
            strcpy(op, "against");
            immediate(FALSE, 'C');
        } elif (!strncmp(&Buffer2[ic], "comz", 4))
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "compare ");
            oc += 8;
            strcpy(op, "against");
            zero('C');
        } elif (!strncmp(&Buffer2[ic], "cpsl", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "PSL &= ");
            oc += 7;
            psl(TRUE);
            Buffer3[oc++] = ';';
        } elif (!strncmp(&Buffer2[ic], "cpsu", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "PSU &= (");
            oc += 8;
            psu(TRUE);
            Buffer3[oc] = 0;
            strcat(Buffer3, " & %01100111);");
            oc += 14;
        } elif (!strncmp(&Buffer2[ic], "dar", 3))
        {   prepare(3);
            skip();
            ic++;
            r = Buffer2[ic++];
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = r;
            Buffer3[oc] = 0;
            strcat(Buffer3, " = BCD(r");
            oc += 8;
            Buffer3[oc++] = r;
            Buffer3[oc++] = ')';
            Buffer3[oc++] = ';';
        } elif
        (   !strncmp(&Buffer2[ic], "eora", 4)
         || !strncmp(&Buffer2[ic], "eorr", 4)
        )
        {   prepare(4);
            strcpy(op, "^=");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "eori", 4))
        {   prepare(4);
            strcpy(op, "^=");
            immediate(TRUE, 'E');
        } elif (!strncmp(&Buffer2[ic], "eorz", 4))
        {   prepare(4);
            strcpy(op, "^=");
            zero('E');
        } elif (!strncmp(&Buffer2[ic], "halt", 4))
        {   prepare(4);
            strcat(Buffer3, "for (;;);");
            oc += 9;
        } elif
        (   !strncmp(&Buffer2[ic], "iora", 4)
         || !strncmp(&Buffer2[ic], "iorr", 4)
        )
        {   prepare(4);
            strcpy(op, "|=");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "iori", 4))
        {   prepare(4);
            strcpy(op, "|=");
            immediate(TRUE, 'I');
        } elif (!strncmp(&Buffer2[ic], "iorz", 4))
        {   prepare(4);
            strcpy(op, "|=");
            zero('I');
        } elif
        (   !strncmp(&Buffer2[ic], "loda", 4)
         || !strncmp(&Buffer2[ic], "lodr", 4)
        )
        {   prepare(4);
            strcpy(op, "=");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "lodi", 4))
        {   prepare(4);
            strcpy(op, "=");
            immediate(FALSE, 'L');
        } elif (!strncmp(&Buffer2[ic], "lodz", 4))
        {   prepare(4);
            strcpy(op, "=");
            zero('L');
        } elif (!strncmp(&Buffer2[ic], "lpsl", 4))
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "PSL = r0;");
            oc += 9;
        } elif (!strncmp(&Buffer2[ic], "lpsu", 4))
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "PSU = (r0 & %01100111);");
            oc += 23;
        } elif (!strncmp(&Buffer2[ic], "nop", 3))
        {   prepare(3);
            Buffer3[oc++] = ';';
        } elif (!strncmp(&Buffer2[ic], "ppsl", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "PSL |= ");
            oc += 7;
            psl(FALSE);
            Buffer3[oc++] = ';';
        } elif (!strncmp(&Buffer2[ic], "ppsu", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "PSU |= ");
            oc += 7;
            psu(FALSE);
            Buffer3[oc] = 0;
            strcat(Buffer3, " & %01100111;");
            oc += 13;
        } elif (!strncmp(&Buffer2[ic], "redc", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            Buffer3[oc++] = 'r';
            Buffer3[oc++] =  r ;
            Buffer3[oc]   =  0 ;
            strcat(Buffer3, " = PORTC;");
            oc += 9;
        } elif (!strncmp(&Buffer2[ic], "redd", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            Buffer3[oc++] = 'r';
            Buffer3[oc++] =  r ;
            Buffer3[oc]   =  0 ;
            strcat(Buffer3, " = PORTD;");
            oc += 9;
        } elif (!strncmp(&Buffer2[ic], "rede", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = r;
            Buffer3[oc]   = 0;
            strcat(Buffer3, " = IOPORT(");
            oc += 10;
            for (i = 0; i <= 2; i++)
            {   Buffer3[oc++] = Buffer2[ic++];
            }
            Buffer3[oc]   = 0;
            strcat(Buffer3, ");");
            oc += 2;
        } elif (!strncmp(&Buffer2[ic], "retc", 4))
        {   prepare(4);
            skip();
            if (getcondition(TRUE))
            {   strcat(Buffer3, "if ");
                strcat(Buffer3, op);
                strcat(Buffer3, " ");
                oc += 4 + strlen(op);
            }
            strcat(Buffer3, "return;");
            oc += 7;
        } elif (!strncmp(&Buffer2[ic], "rete", 4))
        {   prepare(4);
            skip();
            if (getcondition(TRUE))                                   // lengths...
            {   strcat(Buffer3, "if ");                               // 3
                strcat(Buffer3, op);                                  // strlen(op)
                strcat(Buffer3, " then { PSU &= ~PSU_II; return; }"); // 33
                oc += 36 + strlen(op);
            } else
            {   strcat(Buffer3, "PSU &= ~PSU_II; return;");           // 23
                oc += 23;
            }
        } elif (!strncmp(&Buffer2[ic], "rrl", 3))
        {   prepare(3);
            skip();
            ic++;
            r = Buffer2[ic++];
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = r;
            Buffer3[oc] = 0;
            strcat(Buffer3, " <<= 1;");
            oc += 7;
        } elif (!strncmp(&Buffer2[ic], "rrr", 3))
        {   prepare(3);
            skip();
            ic++;
            r = Buffer2[ic++];
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = r;
            Buffer3[oc] = 0;
            strcat(Buffer3, " >>= 1;");
            oc += 7;
        } elif (!strncmp(&Buffer2[ic], "spsl", 4))
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "r0 = PSL;");
            oc += 9;
        } elif (!strncmp(&Buffer2[ic], "spsu", 4))
        {   prepare(4);
            Buffer3[oc] = 0;
            strcat(Buffer3, "r0 = PSU;");
            oc += 9;
        } elif
        (   !strncmp(&Buffer2[ic], "stra", 4)
         || !strncmp(&Buffer2[ic], "strr", 4)
        )
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            getea();
            Buffer3[oc++] = ' ';
            Buffer3[oc++] = '=';
            Buffer3[oc++] = ' ';
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = r;
            Buffer3[oc++] = ';';
            tellwhere();
        } elif (!strncmp(&Buffer2[ic], "strz", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = r;
            Buffer3[oc++] = ' ';
            Buffer3[oc++] = '=';
            Buffer3[oc++] = ' ';
            Buffer3[oc++] = 'r';
            Buffer3[oc++] = '0';
            Buffer3[oc++] = ';';
        } elif
        (   !strncmp(&Buffer2[ic], "suba", 4)
         || !strncmp(&Buffer2[ic], "subr", 4)
        )
        {   prepare(4);
            strcpy(op, "-=");
            absolute();
        } elif (!strncmp(&Buffer2[ic], "subi", 4))
        {   prepare(4);
            strcpy(op, "-=");
            immediate(FALSE, 'S');
        } elif (!strncmp(&Buffer2[ic], "subz", 4))
        {   prepare(4);
            strcpy(op, "-=");
            zero('S');
        } elif (!strncmp(&Buffer2[ic], "tmi",  3))
        {   prepare(3);
            skip();
            ic++;
            r = Buffer2[ic];
            ic++;
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "test bits ");
            oc += 10;
            binarize(FALSE);
            Buffer3[oc] = 0;
            strcat(Buffer3, " of r");
            oc += 5;
            Buffer3[oc++] = r;
            Buffer3[oc++] = ';';
        } elif (!strncmp(&Buffer2[ic], "tpsl", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "test bits ");
            oc += 10;
            psl(FALSE);
            Buffer3[oc] = 0;
            strcat(Buffer3, " of PSL;");
            oc += 8;
        } elif (!strncmp(&Buffer2[ic], "tpsu", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "test bits ");
            oc += 10;
            psu(FALSE);
            Buffer3[oc] = 0;
            strcat(Buffer3, " of PSU;");
            oc += 8;
        } elif (!strncmp(&Buffer2[ic], "wrtc", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            strcat(Buffer3, "PORTC = r");
            oc += 9;
            Buffer3[oc++] =  r ;
            Buffer3[oc++] = ';';
            Buffer3[oc]   =  0 ;
        } elif (!strncmp(&Buffer2[ic], "wrtd", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            strcat(Buffer3, "PORTD = r");
            oc += 9;
            Buffer3[oc++] =  r ;
            Buffer3[oc++] = ';';
            Buffer3[oc]   =  0 ;
        } elif (!strncmp(&Buffer2[ic], "wrte", 4))
        {   prepare(4);
            skip();
            ic++;
            r = Buffer2[ic++];
            skip();
            strcat(Buffer3, "IOPORT(");
            oc += 7;
            for (i = 0; i <= 2; i++)
            {   Buffer3[oc++] = Buffer2[ic++];
            }
            strcat(Buffer3, ") = r");
            oc += 5;
            Buffer3[oc++] =  r ;
            Buffer3[oc++] = ';';
            Buffer3[oc]   =  0 ;
        } elif (!strncmp(&Buffer2[ic], "zbrr", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "goto ");
            oc += 5;
            printlabel();
            if (penalty == 1)
            {   penalty = 2;
            }
            Buffer3[oc++] = ';';
            printrange();
        } elif (!strncmp(&Buffer2[ic], "zbsr", 4))
        {   prepare(4);
            skip();
            Buffer3[oc] = 0;
            strcat(Buffer3, "gosub ");
            oc += 6;
            printlabel();
            if (penalty == 1)
            {   penalty = 2;
            }
            Buffer3[oc++] = ';';
            printrange();
        } elif (!strncmp(&Buffer2[ic], "db", 2))
        {   bytes = '1'; // this only works with 9 or less bytes on a line
            while (Buffer2[ic] != LF)
            {   if (Buffer2[ic++] == ',')
                {   bytes++;
        }   }   }
        elif (!strncmp(&Buffer2[ic], "dw", 2))
        {   bytes = '2'; // this only works with 4 or less words on a line
            while (Buffer2[ic] != LF)
            {   if (Buffer2[ic++] == ',')
                {   bytes += 2;
        }   }   }

        ic = hc;
        if (level >= 6 && (bytes != '0' || cycles != '0'))
        {   yc = oc - ac;
            if (yc >= 71)
            {   if (ibm)
                {   Buffer3[oc++] = CR;
                }
                Buffer3[oc++] = LF;
                yc = 0;
            }
            if (penalty == 1)
            {   for (i = yc + 1; i < 69; i++)
                {   Buffer3[oc++] = ' ';
                }
                Buffer3[oc++] = ';';
                Buffer3[oc++] = cycles;
                Buffer3[oc++] = '+';
                Buffer3[oc++] = '2';
            } else
            {   // assert(penalty == 0 || penalty == 2);
                for (i = yc + 1; i < 71; i++)
                {   Buffer3[oc++] = ' ';
                }
                Buffer3[oc++] = ';';
                if (penalty == 2)
                {   cycles += 2;
                }
                Buffer3[oc++] = cycles;
            }
            Buffer3[oc++] = ',';
            Buffer3[oc++] = bytes;

            if (level >= 7)
            {   Buffer3[oc++] = ' ';
                Buffer3[oc++] = '$';
                if (machine >= ARCADIA_G && machine <= ARCADIA_I)
                {   tempaddress = (address / 4096) * 2;
                } else
                {   tempaddress = (address / 4096);
                }
                if (tempaddress >= 10)
                {   Buffer3[oc++] = 'A' +  tempaddress             - 10;
                } else
                {   Buffer3[oc++] = '0' +  tempaddress;
                }
                if ((address % 4096) / 256 >= 10)
                {   Buffer3[oc++] = 'A' + ((address % 4096) / 256) - 10;
                } else
                {   Buffer3[oc++] = '0' + ((address % 4096) / 256);
                }
                if ((address % 256) / 16 >= 10)
                {   Buffer3[oc++] = 'A' + ((address %  256) /  16) - 10;
                } else
                {   Buffer3[oc++] = '0' + ((address %  256) /  16);
                }
                if (address % 16 >= 10)
                {   Buffer3[oc++] = 'A' + ( address %   16)        - 10;
                } else
                {   Buffer3[oc++] = '0' + ( address %   16);
                }
                if (bytes >= '2')
                {   Buffer3[oc++] = '.';
                    Buffer3[oc++] = '.';
                    Buffer3[oc++] = '$';
                    address += bytes - '0' - 1;
                    if (machine >= ARCADIA_G && machine <= ARCADIA_I)
                    {   tempaddress = (address / 4096) * 2;
                    } else
                    {   tempaddress = (address / 4096);
                    }
                    if (tempaddress >= 10)
                    {   Buffer3[oc++] = 'A' +  tempaddress             - 10;
                    } else
                    {   Buffer3[oc++] = '0' +  tempaddress;
                    }
                    if ((address % 4096) / 256 >= 10)
                    {   Buffer3[oc++] = 'A' + ((address % 4096) / 256) - 10;
                    } else
                    {   Buffer3[oc++] = '0' + ((address % 4096) / 256);
                    }
                    if ((address % 256) / 16 >= 10)
                    {   Buffer3[oc++] = 'A' + ((address %  256) /  16) - 10;
                    } else
                    {   Buffer3[oc++] = '0' + ((address %  256) /  16);
                    }
                    if (address % 16 >= 10)
                    {   Buffer3[oc++] = 'A' + ( address %   16)        - 10;
                    } else
                    {   Buffer3[oc++] = '0' + ( address %   16);
                    }
                    address++;
                } else
                {   if (level >= 8)
                    {   Buffer3[oc] = 0;
                        strcat(Buffer3, ":        ");
                        oc += 9;
                    }
                    address += bytes - '0';
            }   }

            if (level >= 8 && bytes > '0')
            {   if (bytes >= '2')
                {   Buffer3[oc++] = ':';
                    Buffer3[oc++] = ' ';
                }
                for (i = '0'; i < bytes; i++)
                {   if (memory[iar] / 16 >= 10)
                    {   Buffer3[oc++] = 'A' + (memory[iar] / 16) - 10;
                    } else
                    {   Buffer3[oc++] = '0' + (memory[iar] / 16);
                    }
                    if (memory[iar] % 16 >= 10)
                    {   Buffer3[oc++] = 'A' + (memory[iar] % 16) - 10;
                    } else
                    {   Buffer3[oc++] = '0' + (memory[iar] % 16);
                    }
                    if (i < bytes - 1)
                    {   Buffer3[oc++] = ' ';
                    }
                    iar++;
                }
                Buffer3[oc] = 0;
        }   }
        if (ibm)
        {   Buffer3[oc++] = CR;
        }
        Buffer3[oc++] = LF;
    }

FINISH:
    Buffer3[oc] = 0;

    free(Buffer2);
    Buffer2 = NULL;

    printf("%s", Buffer3); // only works with printf(), *not* Printf()

    free(Buffer3);
    Buffer3 = NULL;

    exit(EXIT_SUCCESS); // end of the program. go back to DOS
}

MODULE void immediate(FLAG bin, TEXT special)
{   ULONG i;

    skip();
    ic++;
    r = Buffer2[ic++];
    skip();
    Buffer3[oc++] = 'r';
    Buffer3[oc++] = r;

    if (special == 'D' && Buffer2[ic + 1] == '0' && Buffer2[ic + 2] == '1')
    {   Buffer3[oc++] = '+';
        Buffer3[oc++] = '+';
    } elif
    (   (special == 'D' && Buffer2[ic + 1] == 'F' && Buffer2[ic + 2] == 'F')
     || (special == 'S' && Buffer2[ic + 1] == '0' && Buffer2[ic + 2] == '1')
    )
    {   Buffer3[oc++] = '-';
        Buffer3[oc++] = '-';
    } else
    {   Buffer3[oc++] = ' ';
        Buffer3[oc] = 0;
        strcat(Buffer3, op);
        oc = strlen(Buffer3);
        Buffer3[oc++] = ' ';
        if (bin)
        {   binarize(FALSE);
        } else
        {   for (i = 0; i <= 2; i++)
            {   Buffer3[oc++] = Buffer2[ic++];
    }   }   }

    Buffer3[oc++] = ';';
}
MODULE void skip(void)
{   while (Buffer2[ic] == ' ' || Buffer2[ic] == ',' || Buffer2[ic] == TAB)
    {   ic++;
}   }
MODULE void absolute(void)
{   // assert(Buffer3[oc] == 0);

    skip();
    ic++;
    r = Buffer2[ic++];
    skip();
    oc = strlen(Buffer3);
    Buffer3[oc++] = 'r';
    Buffer3[oc++] = r;
    Buffer3[oc++] = ' ';
    Buffer3[oc] = 0;
    strcat(Buffer3, op);
    oc = strlen(Buffer3);
    Buffer3[oc++] = ' ';
    getea();
    Buffer3[oc++] = ';';
    tellwhere();
}
MODULE FLAG getcondition(FLAG istrue)
{   Buffer3[oc] = 0;
    skip();
    if (!strncmp(&Buffer2[ic], "un", 2))
    {   ic += 2;
        skip();
        return(FALSE);
    } elif (!strncmp(&Buffer2[ic], "eq", 2))
    {   if (istrue)
        {   strcpy(op, "==");
        } else
        {   strcpy(op, "!=");
        }
        ic += 2;
        skip();
    return(TRUE);
    } elif (!strncmp(&Buffer2[ic], "gt", 2))
    {   if (istrue)
    {   strcpy(op, ">");
        } else
        {   strcpy(op, "<=");
        }
        ic += 2;
        skip();
        return(TRUE);
    } elif (!strncmp(&Buffer2[ic], "lt", 2))
    {   if (istrue)
        {   strcpy(op, "<");
        } else
        {   strcpy(op, ">=");
        }
        ic += 2;
        skip();
        return(TRUE);
    } else
    {   ; // there is a problem
    return(FALSE);
}   }
MODULE void zero(TEXT special)
{   skip();
    ic++;
    r = Buffer2[ic++];
    skip();
    Buffer3[oc++] = 'r';
    Buffer3[oc++] = '0';
    Buffer3[oc++] = ' ';

    if ((special == 'E' || special == 'S') && r == '0')
    {   Buffer3[oc++] = '=';
        Buffer3[oc++] = ' ';
        Buffer3[oc++] = '0';
    } elif (special == 'D' && r == '0')
    {   Buffer3[oc++] = '*';
        Buffer3[oc++] = '=';
        Buffer3[oc++] = ' ';
        Buffer3[oc++] = '2';
    } else
    {   Buffer3[oc] = 0;
        strcat(Buffer3, op);
        oc = strlen(Buffer3);
        Buffer3[oc++] = ' ';
        Buffer3[oc++] = 'r';
        Buffer3[oc++] = r;
    }
    Buffer3[oc++] = ';';
}

/* penalty of 0 = no indirection
              1 = possible indirection (eg. bcta,gt)
              2 = definite indirection (eg. bcta,un) */

MODULE void getea(void)
{   FLAG  done, indirect;
    ULONG i;

/* ic is assumed to be pointing to the start of the operand field.
   oc is assumed to be pointing past the expression, eg. "&=". */

    if (Buffer2[ic] == '*')
    {   Buffer3[oc++] = '*';
        Buffer3[oc++] = '(';
        indirect = TRUE;
        ic++;
        penalty = 2;
    } else
    {   indirect = FALSE;
    }

    where[0] = 0;
    if (level >= 3 && machine != GENERIC && Buffer2[ic + 5] == LF)
    {   done = replace(TRUE);
    } else
    {   done = FALSE;
    }

    if (!done)
    {   Buffer3[oc++] = '*';
        Buffer3[oc++] = '(';
        Buffer3[oc++] = '$';
        ic++;
        if (level >= 4 && Buffer2[ic + 4] == LF)
        {   for (i = 0; i <= 3; i++)
            {   where[i] = Buffer2[ic + i];
        }   }
        for (i = 0; i <= 3; i++)
        {   Buffer3[oc++] = Buffer2[ic++];
    }   }
    if (indirect)
    {   Buffer3[oc++] = ')';
    }
    if (Buffer2[ic] == ',')
    {   Buffer3[oc++] = ' ';
        Buffer3[oc++] = '+';
        Buffer3[oc++] = ' ';
        if (Buffer2[ic + 3] == '+')
        {   Buffer3[oc++] = '+';
            Buffer3[oc++] = '+';
        } elif (Buffer2[ic + 3] == '-')
        {   Buffer3[oc++] = '-';
            Buffer3[oc++] = '-';
        }
        ic++;
        Buffer3[oc++] = Buffer2[ic++];
        Buffer3[oc++] = Buffer2[ic++];
    }
    if (!done)
    {   Buffer3[oc++] = ')';
}   }
MODULE void binarize(FLAG invert)
{   UBYTE c0, c1, i, value;

    value = grabvalue();

    if (invert)
    {   c0 = '1';
        c1 = '0';
    } else
    {   c0 = '0';
        c1 = '1';
    }

    // write out binary value
    Buffer3[oc++] = '%';
    for (i = 128; i >= 1; i /= 2)
    {   if (value >= i)
        {   Buffer3[oc++] = c1;
            value -= i;
        } else Buffer3[oc++] = c0;
    }
}
MODULE void rq(STRPTR message)
{   printf("%s\n", message);
    exit(EXIT_FAILURE);
}
MODULE void printlabel(void)
{   ULONG i;
    FLAG  found;

    // assert(Buffer3[oc] == 0);

    if (Buffer2[ic] == '*')
    {   strcat(Buffer3, "*(");
        ic++;
        penalty = 1;
    }
    oc = strlen(Buffer3);

    rangeaddress = 0;
    for (i = 1; i <= 4; i++)
    {   if (*(Buffer2 + ic + i) >= '0' && *(Buffer2 + ic + i) <= '9')
        {   rangeaddress +=  (*(Buffer2 + ic + i) - '0')       * (1 << (16 - (i * 4)));
        } else
        {   // assert(*(Buffer2 + ic + 1) >= 'A' && *(Buffer2 + ic + 1) <= 'F');
            rangeaddress += ((*(Buffer2 + ic + i) - 'A') + 10) * (1 << (16 - (i * 4)));
    }   }

    found = FALSE;
    if (level >= 3)
    {   if (machine == ELEKTOR_E || machine == ELEKTOR_F)
        {   for (i = 0; i < E_REPLACEMENTS; i++)
            {   if (!strncmp(e_replacement[i].old, Buffer2 + ic + 1, 4))
                {   strcat(Buffer3, e_replacement[i].new);
                    ic += 5;
                    oc += strlen(e_replacement[i].new);
                    x  += strlen(e_replacement[i].new);
                    found = TRUE;
                    break;
        }   }   }
        elif (machine >= PIPBUG_J && machine <= PIPBUG_P)
        {   for (i = 0; i < P_REPLACEMENTS; i++)
            {   if (!strncmp(p_replacement[i].old, Buffer2 + ic + 1, 4))
                {   strcat(Buffer3, p_replacement[i].new);
                    ic += 5;
                    oc += strlen(p_replacement[i].new);
                    x  += strlen(p_replacement[i].new);
                    found = TRUE;
                    break;
            }   }
            if (machine == PIPBUG_P)
            {   for (i = 0; i < P_P_REPLACEMENTS; i++)
                {   if (!strncmp(p_p_replacement[i].old, Buffer2 + ic + 1, 4))
                    {   strcat(Buffer3, p_p_replacement[i].new);
                        ic += 5;
                        oc += strlen(p_p_replacement[i].new);
                        x  += strlen(p_p_replacement[i].new);
                        found = TRUE;
                        break;
        }   }   }   }
        elif (machine == INSTRUCTOR_N || machine == INSTRUCTOR_O)
        {   for (i = 0; i < S_REPLACEMENTS; i++)
            {   if (!strncmp(s_replacement[i].old, Buffer2 + ic + 1, 4))
                {   strcat(Buffer3, s_replacement[i].new);
                    ic += 5;
                    oc += strlen(s_replacement[i].new);
                    x  += strlen(s_replacement[i].new);
                    found = TRUE;
                    break;
        }   }   }
        elif (machine == CD2650_U)
        {   for (i = 0; i < C_REPLACEMENTS; i++)
            {   if (!strncmp(c_replacement[i].old, Buffer2 + ic + 1, 4))
                {   strcat(Buffer3, c_replacement[i].new);
                    ic += 5;
                    oc += strlen(c_replacement[i].new);
                    x  += strlen(c_replacement[i].new);
                    found = TRUE;
                    break;
    }   }   }   }

    if (!found)
    {   for (i = 0; i <= 4; i++)
        {   Buffer3[oc++] = Buffer2[ic++];
    }   }

    if (Buffer2[ic - 6] == '*')
    {   Buffer3[oc++] = ')';
    }
    Buffer3[oc] = 0;
}
MODULE void dolf(void)
{   oc = strlen(Buffer2);
    Buffer2[oc++] = LF;
    Buffer2[oc] = 0;
}
MODULE void prepare(ULONG value)
{   ULONG i;

    if (x <= 28)
    {   for (i = x + 1; i < 30; i++)
        {   Buffer3[oc++] = ' ';
    }   }
    elif (x >= 30)
    {   if (ibm)
        {   Buffer3[oc++] = CR;
        }
        Buffer3[oc++] = LF;
        for (i = 1; i < 30; i++)
        {   Buffer3[oc++] = ' ';
        }
        // should x = 0; be here?
    }

    Buffer3[oc++] = ';';
    Buffer3[oc] = 0; // important!
    ic += value;
}

MODULE void tellwhere(void)
{   int   i;
    ULONG value[4] = {0, 0, 0, 0}; // to avoid spurious SAS/C compiler warnings

    if (level >= 4 && machine != GENERIC && where[0])
    {    for (i = 0; i <= 3; i++)
         {   if (where[i] >= '0' && where[i] <= '9')
             {   value[i] = where[i] - '0';
             } else
             {   value[i] = where[i] - 'A' + 10;
         }   }
         rangeaddress = (value[0] * 4096)
                  + (value[1] *  256)
                  + (value[2] *   16)
                  +  value[3];

         printrange();
}   }

MODULE void printrange(void)
{   int i;

    if (machine >= ARCADIA_G && machine <= ARCADIA_I)
    {   for (i = A_MEMMAPLINES - 1; i >= 0; i--)
        {   if (rangeaddress >= a_memmap[i].address)
            {   Buffer3[oc++] = ' ';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = ' ';
                Buffer3[oc]   = 0;
                strcat(Buffer3, a_memmap[i].description);
                oc += strlen(a_memmap[i].description);
                return;
    }   }   }
    elif (machine >= PIPBUG_J && machine <= PIPBUG_P)
    {   for (i = P_RANGELINES - 1; i >= 0; i--)
        {   if (rangeaddress >= p_ranges[i].address)
            {   Buffer3[oc++] = ' ';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = ' ';
                Buffer3[oc]   = 0;
                strcat(Buffer3, p_ranges[i].description);
                oc += strlen(p_ranges[i].description);
                return;
    }   }   }
    elif (machine == INSTRUCTOR_N || machine == INSTRUCTOR_O)
    {   for (i = S_RANGELINES - 1; i >= 0; i--)
        {   if (rangeaddress >= s_ranges[i].address)
            {   Buffer3[oc++] = ' ';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = ' ';
                Buffer3[oc]   = 0;
                strcat(Buffer3, s_ranges[i].description);
                oc += strlen(s_ranges[i].description);
                return;
    }   }   }
    elif (machine == CD2650_U)
    {   for (i = C_RANGELINES - 1; i >= 0; i--)
        {   if (rangeaddress >= c_ranges[i].address)
            {   Buffer3[oc++] = ' ';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = '/';
                Buffer3[oc++] = ' ';
                Buffer3[oc]   = 0;
                strcat(Buffer3, c_ranges[i].description);
                oc += strlen(c_ranges[i].description);
                return;
    }   }   }
    else
    {   if (rangeaddress <= 0x1E7F || rangeaddress >= 0x2000)
        {   if (machine >= INTERTON_A && machine <= INTERTON_D)
            {   for (i = I_RANGELINES - 1; i >= 0; i--)
                {   if (rangeaddress >= i_ranges[machine - INTERTON_A][i].address)
                    {   Buffer3[oc++] = ' ';
                        Buffer3[oc++] = '/';
                        Buffer3[oc++] = '/';
                        Buffer3[oc++] = ' ';
                        Buffer3[oc]   = 0;
                        strcat(Buffer3, i_ranges[machine - INTERTON_A][i].description);
                        oc += strlen(i_ranges[machine - INTERTON_A][i].description);
                        return;
            }   }   }
            else
            {   // assert(machine == ELEKTOR_E || machine == ELEKTOR_F);
                for (i = E_MEMMAPLINES - 1; i >= 0; i--)
                {   if (rangeaddress >= e_memmap[machine - ELEKTOR_E][i].address)
                    {   Buffer3[oc++] = ' ';
                        Buffer3[oc++] = '/';
                        Buffer3[oc++] = '/';
                        Buffer3[oc++] = ' ';
                        Buffer3[oc]   = 0;
                        strcat(Buffer3, e_memmap[machine - ELEKTOR_E][i].description);
                        oc += strlen(e_memmap[machine - ELEKTOR_E][i].description);
                        return;
        }   }   }   }
        else
        {   // assert(rangeaddress >= 0x1E80 && rangeaddress <= 0x1FFF);
            for (i = PVI_RANGELINES - 1; i >= 0; i--)
            {   if (rangeaddress >= pvi_ranges[i].address)
                {   Buffer3[oc++] = ' ';
                    Buffer3[oc++] = '/';
                    Buffer3[oc++] = '/';
                    Buffer3[oc++] = ' ';
                    Buffer3[oc]   = 0;
                    strcat(Buffer3, pvi_ranges[i].description);
                    oc += strlen(pvi_ranges[i].description);
                    return;
}   }   }   }   }

MODULE UBYTE grabvalue(void)
{   UBYTE value;

    ic++; // pass '$'
    if (Buffer2[ic] >= '0' && Buffer2[ic] <= '9')
    {   value = Buffer2[ic] - '0';
    } elif (Buffer2[ic] >= 'A' && Buffer2[ic] <= 'F')
    {   value = Buffer2[ic] - 'A' + 10;
    } else value = 0;
    value *= 16;
    ic++;
    if (Buffer2[ic] >= '0' && Buffer2[ic] <= '9')
    {   value += Buffer2[ic] - '0';
    } elif (toupper(Buffer2[ic]) >= 'A' && toupper(Buffer2[ic]) <= 'F')
    {   value += Buffer2[ic] - 'A' + 10;
    } else value = 0;

    return(value);
}

MODULE void psu(FLAG invert)
{   UBYTE value;

    value = grabvalue();

    if (invert)
    {   if (value & PSU_S  ) Buffer3[oc++] = 's'; else Buffer3[oc++] = 'S';
        if (value & PSU_F  ) Buffer3[oc++] = 'f'; else Buffer3[oc++] = 'F';
        if (value & PSU_II ) Buffer3[oc++] = 'i'; else Buffer3[oc++] = 'I';
        if (value & 0x10   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
        if (value & 0x08   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
        if (value & 0x04   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
        if (value & 0x02   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
        if (value & 0x01   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
    } else
    {   if (value & PSU_S  ) Buffer3[oc++] = 'S'; else Buffer3[oc++] = '.';
        if (value & PSU_F  ) Buffer3[oc++] = 'F'; else Buffer3[oc++] = '.';
        if (value & PSU_II ) Buffer3[oc++] = 'I'; else Buffer3[oc++] = '.';
        if (value & 0x10   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
        if (value & 0x08   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
        if (value & 0x04   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
        if (value & 0x02   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
        if (value & 0x01   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
}   }

MODULE void psl(FLAG invert)
{   UBYTE value;

    value = grabvalue();

    if (invert)
    {   if (value & 0x80   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
        if (value & 0x40   ) Buffer3[oc++] = '.'; else Buffer3[oc++] = '!';
        if (value & PSL_IDC) Buffer3[oc++] = 'd'; else Buffer3[oc++] = 'D';
        if (value & PSL_RS ) Buffer3[oc++] = 'r'; else Buffer3[oc++] = 'R';
        if (value & PSL_WC ) Buffer3[oc++] = 'w'; else Buffer3[oc++] = 'W';
        if (value & PSL_OVF) Buffer3[oc++] = 'o'; else Buffer3[oc++] = 'O';
        if (value & PSL_COM) Buffer3[oc++] = 'm'; else Buffer3[oc++] = 'M';
        if (value & PSL_C  ) Buffer3[oc++] = 'c'; else Buffer3[oc++] = 'C';
    } else
    {   if (value & 0x80   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
        if (value & 0x40   ) Buffer3[oc++] = '!'; else Buffer3[oc++] = '.';
        if (value & PSL_IDC) Buffer3[oc++] = 'D'; else Buffer3[oc++] = '.';
        if (value & PSL_RS ) Buffer3[oc++] = 'R'; else Buffer3[oc++] = '.';
        if (value & PSL_WC ) Buffer3[oc++] = 'W'; else Buffer3[oc++] = '.';
        if (value & PSL_OVF) Buffer3[oc++] = 'O'; else Buffer3[oc++] = '.';
        if (value & PSL_COM) Buffer3[oc++] = 'M'; else Buffer3[oc++] = '.';
        if (value & PSL_C  ) Buffer3[oc++] = 'C'; else Buffer3[oc++] = '.';
}   }

MODULE void printusage(STRPTR name)
{   printf(USAGE, name);
    printf
    (   "MACHINE must be one of the following:\n"                 \
        " INTERTON_A    (2K ROM + 0K RAM)\n"                      \
        " INTERTON_B    (4K ROM + 0K RAM)\n"                      \
        " INTERTON_C    (4K ROM + 1K RAM)\n"                      \
        " INTERTON_D    (6K ROM + 1K RAM)\n"                      \
        " ELEKTOR_E     (basic Elektor TV Games Computer)\n"      \
        " ELEKTOR_F     (expanded Elektor TV Games Computer\n"    \
        " ARCADIA_G     (Emerson Arcadia 2001)\n"                 \
        " ARCADIA_H     (Tele-Fever)\n"                           \
        " ARCADIA_I     (Palladium VGC)\n"                        \
        " PIPBUG_J      (Electronics Australia 77up2)\n"          \
        " PIPBUG_K      (Signetics Adaptable Board Computer)\n"   \
        " PIPBUG_L      (1K Electronics Australia 78up5)\n"       \
        " PIPBUG_M      (8K Electronics Australia 78up5)\n"       \
        " PIPBUG_P      (11K Electronics Australia 78up5+EPROM)\n"\
        " INSTRUCTOR_N  (basic Signetics Instructor 50)\n"        \
        " INSTRUCTOR_O  (expanded Signetics Instructor 50)\n"     \
        " CD2650_U      (Central Data 2650)\n"                    \
        " GENERIC       (generic 2650-based machine)\n"
    );
}

MODULE int getsize(STRPTR passedfilename)
{   int localsize;

#ifdef AMIGA
    BPTR                  BHandle /* = NULL */ ;
    struct FileInfoBlock* FIBPtr  /* = NULL */ ;

    if (!(BHandle = (BPTR) Lock(passedfilename, ACCESS_READ)))
    {   sprintf
        (   errorstring,
            "Lock(\"%s\") failed!",
            passedfilename
        );
        rq(errorstring);
    }
    if (!(FIBPtr = AllocDosObject(DOS_FIB, NULL)))
    {   UnLock(BHandle);
        BHandle = NULL;
        sprintf
        (   errorstring,
            "AllocDosObject(\"%s\") failed!",
            passedfilename
        );
        rq(errorstring);
    }
    if (!(Examine(BHandle, FIBPtr)))
    {   FreeDosObject(DOS_FIB, FIBPtr);
        FIBPtr = NULL;
        UnLock(BHandle);
        BHandle = NULL;
        sprintf
        (   errorstring,
            "Examine(\"%s\") failed!",
            passedfilename
        );
        rq(errorstring);
    }
    UnLock(BHandle);
    // BHandle = NULL;
    localsize = FIBPtr->fib_Size;
    if (FIBPtr->fib_DirEntryType != -3)
    {   FreeDosObject(DOS_FIB, FIBPtr);
        FIBPtr = NULL;
        rq("Not a file!");
    }
    FreeDosObject(DOS_FIB, FIBPtr);
    // FIBPtr = NULL;
#endif
#ifdef WIN32
    HANDLE hFile /* = NULL */ ;

    hFile = CreateFile(passedfilename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
    {   localsize = 0;
    } else
    {   localsize = GetFileSize(hFile, NULL);
        CloseHandle(hFile);
        // hFile = NULL;
        if (localsize == (ULONG) -1)
        {   localsize = 0;
    }   }
#endif

    return localsize;
}

MODULE FLAG replace(FLAG whether)
{   int i;

    if (machine >= ARCADIA_G && machine <= ARCADIA_I)
    {   for (i = 0; i < A_REPLACEMENTS; i++)
        {   if (!strncmp(a_replacement[i].old, Buffer2 + ic + 1, 4))
            {   Buffer3[oc] = 0;
                strcat(Buffer3, a_replacement[i].new);
                if (whether)
                {   if (level >= 4)
                    {   where[0] = Buffer2[ic + 1];
                        where[1] = Buffer2[ic + 2];
                        where[2] = Buffer2[ic + 3];
                        where[3] = Buffer2[ic + 4];
                }   }
                else
                {   x += strlen(a_replacement[i].new);
                }
                ic += 5;
                oc += strlen(a_replacement[i].new);
                return TRUE;
    }   }   }
    elif (machine >= PIPBUG_J && machine <= PIPBUG_P)
    {   for (i = 0; i < P_REPLACEMENTS; i++)
        {   if (!strncmp(p_replacement[i].old, Buffer2 + ic + 1, 4))
            {   Buffer3[oc] = 0;
                strcat(Buffer3, p_replacement[i].new);
                if (whether)
                {   if (level >= 4)
                    {   where[0] = Buffer2[ic + 1];
                        where[1] = Buffer2[ic + 2];
                        where[2] = Buffer2[ic + 3];
                        where[3] = Buffer2[ic + 4];
                }   }
                else
                {   x += strlen(p_replacement[i].new);
                }
                ic += 5;
                oc += strlen(p_replacement[i].new);
                return TRUE;
        }   }
        if (machine == PIPBUG_P)
        {   for (i = 0; i < P_P_REPLACEMENTS; i++)
            {   if (!strncmp(p_p_replacement[i].old, Buffer2 + ic + 1, 4))
                {   Buffer3[oc] = 0;
                    strcat(Buffer3, p_p_replacement[i].new);
                    if (whether)
                    {   if (level >= 4)
                        {   where[0] = Buffer2[ic + 1];
                            where[1] = Buffer2[ic + 2];
                            where[2] = Buffer2[ic + 3];
                            where[3] = Buffer2[ic + 4];
                    }   }
                    else
                    {   x += strlen(p_p_replacement[i].new);
                    }
                    ic += 5;
                    oc += strlen(p_p_replacement[i].new);
                    return TRUE;
    }   }   }   }
    elif (machine == INSTRUCTOR_N || machine == INSTRUCTOR_O)
    {   for (i = 0; i < S_REPLACEMENTS; i++)
        {   if (!strncmp(s_replacement[i].old, Buffer2 + ic + 1, 4))
            {   Buffer3[oc] = 0;
                strcat(Buffer3, s_replacement[i].new);
                if (whether)
                {   if (level >= 4)
                    {   where[0] = Buffer2[ic + 1];
                        where[1] = Buffer2[ic + 2];
                        where[2] = Buffer2[ic + 3];
                        where[3] = Buffer2[ic + 4];
                }   }
                else
                {   x += strlen(s_replacement[i].new);
                }
                ic += 5;
                oc += strlen(s_replacement[i].new);
                return TRUE;
    }   }   }
    elif (machine == CD2650_U)
    {   for (i = 0; i < C_REPLACEMENTS; i++)
        {   if (!strncmp(c_replacement[i].old, Buffer2 + ic + 1, 4))
            {   Buffer3[oc] = 0;
                strcat(Buffer3, c_replacement[i].new);
                if (whether)
                {   if (level >= 4)
                    {   where[0] = Buffer2[ic + 1];
                        where[1] = Buffer2[ic + 2];
                        where[2] = Buffer2[ic + 3];
                        where[3] = Buffer2[ic + 4];
                }   }
                else
                {   x += strlen(c_replacement[i].new);
                }
                ic += 5;
                oc += strlen(c_replacement[i].new);
                return TRUE;
    }   }   }
    else
    {   if (machine == ELEKTOR_E || machine == ELEKTOR_F)
        {   for (i = 0; i < E_REPLACEMENTS; i++)
            {   if (!strncmp(e_replacement[i].old, Buffer2 + ic + 1, 4))
                {   Buffer3[oc] = 0;
                    strcat(Buffer3, e_replacement[i].new);
                    if (whether)
                    {   if (level >= 4)
                        {   where[0] = Buffer2[ic + 1];
                            where[1] = Buffer2[ic + 2];
                            where[2] = Buffer2[ic + 3];
                            where[3] = Buffer2[ic + 4];
                    }   }
                    else
                    {   x += strlen(e_replacement[i].new);
                    }
                    ic += 5;
                    oc += strlen(e_replacement[i].new);
                    return TRUE;
            }   }

            if (machine == ELEKTOR_F)
            {   for (i = 0; i < E_F_REPLACEMENTS; i++)
                {   if (!strncmp(e_f_replacement[i].old, Buffer2 + ic + 1, 4))
                    {   Buffer3[oc] = 0;
                        strcat(Buffer3, e_f_replacement[i].new);
                        if (whether)
                        {   if (level >= 4)
                            {   where[0] = Buffer2[ic + 1];
                                where[1] = Buffer2[ic + 2];
                                where[2] = Buffer2[ic + 3];
                                where[3] = Buffer2[ic + 4];
                        }   }
                        else
                        {   x += strlen(e_replacement[i].new);
                        }
                        ic += 5;
                        oc += strlen(e_f_replacement[i].new);
                        return TRUE;
        }   }   }   }

        for (i = 0; i < UVI_REPLACEMENTS; i++)
        {   if (!strncmp(uvi_replacement[i].old, Buffer2 + ic + 1, 4))
            {   Buffer3[oc] = 0;
                strcat(Buffer3, uvi_replacement[i].new);
                if (whether)
                {   if (level >= 4)
                    {   where[0] = Buffer2[ic + 1];
                        where[1] = Buffer2[ic + 2];
                        where[2] = Buffer2[ic + 3];
                        where[3] = Buffer2[ic + 4];
                }   }
                else
                {   x += strlen(uvi_replacement[i].new);
                }
                ic += 5;
                oc += strlen(uvi_replacement[i].new);
                return TRUE;
    }   }   }

    return FALSE;
}

