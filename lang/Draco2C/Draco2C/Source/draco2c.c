#include "lint.h"

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <stdlib.h>

#define AUTO            auto    /* automatic variables */
#define AGLOBAL         ;       /* global (project-scope) */
#define MODULE    static   /* external static (file-scope) */
#define PERSIST      static   /* internal static (function-scope) */
typedef signed char  ABOOL;   /* 8-bit signed quantity (replaces BOOL) */
typedef signed char  FLAG; /* 8-bit signed quantity (replaces BOOL) */
typedef signed char  SBYTE;   /* 8-bit signed quantity (replaces Amiga BYTE) */
typedef signed short SWORD;   /* 16-bit signed quantity (replaces Amiga WORD) */
typedef signed long  SLONG;   /* 32-bit signed quantity (same as LONG) */
#define elif      else if

// #define DEBUG

#define TAB              9 /* horizontal tab */
#define LF              10 /* linefeed */

MODULE void rq(STRPTR message);
MODULE void phase1(void);
MODULE void phase2(void);
MODULE void phase3(void);
MODULE FLAG get1(STRPTR string);
MODULE FLAG get2(STRPTR string, FLAG coded);
MODULE FLAG get3(STRPTR string);
MODULE void append1(STRPTR string);
MODULE void append2(STRPTR string);
MODULE void append3(STRPTR string);
MODULE void parsequoted2(void);
MODULE void parsequoted3(void);
MODULE void parseunquoted2(void);
MODULE void parseunquoted3(void);
MODULE void nowhitespace2(void);
MODULE void nowhitespace3(void);
MODULE FLAG iswhitespace(TEXT candidate);
MODULE FLAG parsearglist(void);
MODULE void swallow(STRPTR string); // this is strictly for the use of phase2() only

IMPORT struct ExecBase*      SysBase; // optional under StormC

// Module and global variables are initialized to zero by default.
MODULE FLAG  amigan,
             by,
             code,
             done,
             fresh,
             memvartype,
             up;
MODULE TEXT  quoted,
             *Buffer1,
             *Buffer2,
             *Buffer3,
             *Buffer4;
MODULE TEXT  tempstring1[8196],
             tempstring2[8196],
             tempstring3[8196],
             tempstring4[8196];
MODULE ULONG icursor,
             ocursor,
             t1cursor,
             t2cursor,
             t3cursor,
             t4cursor;
MODULE SLONG bnesting,
             cnesting,
             pnesting;

int main(int argc, char** argv)
{   BPTR                  TheHandle /* = NULL */ ;
    LONG                  size;
    struct FileInfoBlock* FIBPtr    /* = NULL */ ;

    /* Start of program.

    version embedding into executcable */
    if (0) /* that is, never */
    {   Printf("$VER: Draco2C 1.0b (30.7.2005)");
    }

    if (SysBase->LibNode.lib_Version < 36)
    {   Write(Output(), "Draco2C: Need OS2.0+!\n", 22);
        exit(EXIT_FAILURE);
    }

    if (argc < 2 || argc > 3 || !strcmp(argv[1], "?"))
    {   Printf
        (   "Usage: %s <file> [-a|AMIGATYPES]\n",
            argv[0]
        );
        exit(EXIT_FAILURE);
    }
    if (argv[2])
    {   amigan = TRUE;
    }

    /* Firstly we read foo.d into Buffer1. Then we convert the trigraphs
    from Buffer1 to Buffer2. Then we do the main operation from Buffer2
    to Buffer3.

    Buffer1 and Buffer3 use the input and output files, respectively.
    Buffer2 exists only in memory, although it could easily be dumped to
    a file if anyone would be interested in it.

    ocursor is used as the cursor for both Buffer2 and Buffer3, at
    different points. icursor is used as the cursor for both Buffer1
    and Buffer2, at different points.

    We lock the input file, examine it, unlock it, check its type,
    get its size, allocate its memory, open its file, read its file,
    close its file. */

#ifdef DEBUG
    Printf("A!\n");
#endif

    if (!(TheHandle = (BPTR) Lock(argv[1], ACCESS_READ)))
    {   rq("Lock() failed!");
    }

#ifdef DEBUG
    Printf("B!\n");
#endif

    if (!(FIBPtr    = AllocDosObject(DOS_FIB, NULL)))
    {   UnLock(TheHandle);
        TheHandle = NULL;
        rq("AllocDosObject() failed!");
    }
    if (!(Examine(TheHandle, FIBPtr)))
    {   UnLock(TheHandle);
        TheHandle = NULL;
        rq("Examine() failed!");
    }

#ifdef DEBUG
    Printf("C!\n");
#endif

    UnLock(TheHandle);
    // TheHandle = NULL;

#ifdef DEBUG
    Printf("D!\n");
#endif

    size = FIBPtr->fib_Size;
    if (FIBPtr->fib_DirEntryType != -3)
    {   FreeDosObject(DOS_FIB, FIBPtr);
        FIBPtr = NULL;
        rq("Not a file!");
    }
    FreeDosObject(DOS_FIB, FIBPtr);
    // FIBPtr = NULL;

#ifdef DEBUG
    Printf("E!\n");
#endif

    if (!(Buffer1 = AllocVec(size + 1, MEMF_ANY | MEMF_PUBLIC)))
    {   rq("Out of memory!");
    }

#ifdef DEBUG
    Printf("Buffer1 is at %lx, size %ld!\n", Buffer1, size + 1);
    Printf("F!\n");
#endif

    if (!(TheHandle = Open(argv[1], MODE_OLDFILE)))
    {   rq("Open() failed!");
    }

#ifdef DEBUG
    Printf("G!\n");
#endif

    if (Read(TheHandle, Buffer1, size) == -1)
    {   Close(TheHandle);
        TheHandle = NULL;
        FreeVec(Buffer1);
        Buffer1 = NULL;
        rq("Read() failed!");
    }

#ifdef DEBUG
    Printf("H!\n");
#endif

    Close(TheHandle);
    // TheHandle = NULL;
    *(Buffer1 + size) = 0; // this is why we allocate size + 1

#ifdef DEBUG
    Printf("I!\n");
#endif

    /* Buffer1 is now allocated and filled.

    It is safe to be only the size of the input file, as trigraph
    translation never causes expansion, only contraction. */
    if (!(Buffer2 = AllocVec(size + 1, MEMF_ANY | MEMF_PUBLIC)))
    {   rq("Out of memory!");
    }

    icursor = ocursor = 0;
    code = fresh = quoted = FALSE;

#ifdef DEBUG
    Printf("Buffer2 is at %lx, size %ld!\n", Buffer2, size + 1);
    Printf("J!\n");
#endif

    while (icursor <= (ULONG) size)
    {   phase1();
    }

#ifdef DEBUG
    Printf("K!\n");
#endif

    /* Now we have Buffer1 and Buffer2 both allocated and filled.
    Next we want to do the main operation, to convert Buffer2 to Buffer3.
    */

    FreeVec(Buffer1);
    Buffer1 = NULL;

#ifdef DEBUG
    Printf("L!\n");
#endif

    size = (LONG) ocursor;
    if (!(Buffer3 = AllocVec(size * 2, MEMF_ANY | MEMF_PUBLIC)))
    {   FreeVec(Buffer2);
        Buffer2 = NULL;
        rq("Out of memory!");
    }

#ifdef DEBUG
    Printf("Buffer3 is at %lx, size %ld!\n", Buffer3, size * 2);
    Printf("M!\n");
#endif

    icursor  =
    ocursor  = 0;
    cnesting = 0;
    code = fresh = quoted = FALSE;
    if (amigan)
    {   append2("#include <exec/types.h>\n\n");
    }

#ifdef DEBUG
    Printf("N!\n");
#endif

    while (icursor <= (ULONG) size)
    {   phase2();
    }

#ifdef DEBUG
    Printf("O!\n");
#endif

    FreeVec(Buffer2);
    Buffer2 = NULL;

#ifdef DEBUG
    Printf("P!\n");
#endif

/* The first pass only ever shrinks the file, whereas the second and third
passes may expand it. */

    size = (LONG) ocursor;
    if (!(Buffer4 = AllocVec(size * 2, MEMF_ANY | MEMF_PUBLIC)))
    {   FreeVec(Buffer3);
        Buffer3 = NULL;
        rq("Out of memory!");
    }

#ifdef DEBUG
    Printf("Buffer4 is at %lx, size %ld!\n", Buffer4, size * 2);
    Printf("Q!\n");
#endif

    icursor = ocursor = 0;
    code = fresh = quoted = FALSE;

    while (icursor <= (ULONG) size)
    {   phase3();
    }

#ifdef DEBUG
    Printf("R!\n");
#endif

    FreeVec(Buffer3);
    Buffer3 = NULL;

#ifdef DEBUG
    Printf("S!\n");
#endif

    Printf("%s\n", Buffer4);

#ifdef DEBUG
    Printf("T!\n");
#endif

    FreeVec(Buffer4);
    Buffer4 = NULL;

#ifdef DEBUG
    Printf("U!\n");
#endif

    exit(EXIT_SUCCESS);
}

MODULE void phase1(void)
{   /* trigraphs are converted regardless of context (ie. quotes,
    comments, etc.) */

    if (get1("(:"))
    {   append1("[");
    } elif (get1(":)"))
    {   append1("]");
    } elif (get1("($"))
    {   append1("{");
    } elif (get1("$)"))
    {   append1("}");
    } elif (get1("/="))
    {   append1("~=");
    } elif (get1("$-"))
    {   append1("~");
    } elif (get1("$/"))
    {   append1("|");
    } elif (get1("^"))
    {   append1("_");
    } elif (get1("\\#"))
    {   append1("#");
    } elif (get1("#"))
    {   append1("\\");
    } else
    {   Buffer2[ocursor++] = Buffer1[icursor++];
}   }

MODULE void phase3(void)
{   if (iswhitespace(*(Buffer3 + icursor)))
    {   *(Buffer4 + ocursor) = *(Buffer3 + icursor);
        icursor++;
        ocursor++;
    } elif (quoted)
    {   parsequoted3();
    } else
    {   parseunquoted3();
}   }

MODULE void parsequoted3(void)
{   if (*(Buffer3 + icursor) == '\"' && quoted == '\"')
    {   // assert(quoted);
        quoted = FALSE;
    } elif (*(Buffer3 + icursor) == '\'' && quoted == '\'')
    {   // assert(quoted);
        quoted = FALSE;
    }
    *(Buffer4 + ocursor) = *(Buffer3 + icursor);
    icursor++;
    ocursor++;
}

MODULE void parseunquoted3(void)
{   if (get3("bool"))
    {   if (amigan)
        {   append3("BOOL");
        } else
        {   append3("signed short");
    }   }
    elif (get3("byte"))
    {   if (amigan)
        {   append3("UBYTE");
        } else
        {   append3("unsigned char");
    }   }
    elif (get3("char"))
    {   if (amigan)
        {   append3("UBYTE");
        } else
        {   append3("unsigned byte");
    }   }
    elif (get3("false"))
    {   append3("FALSE");
    }
    elif (get3("int"))
    {   if (amigan)
        {   append3("WORD");
        } else
        {   append3("signed short");
    }   }
    elif (get3("long"))
    {   if (amigan)
        {   append3("ULONG");
        } else
        {   append3("unsigned long");
    }   }
    elif (get3("nil"))
    {   append3("NULL");
    } elif (get3("short"))
    {   if (amigan)
        {   append3("UBYTE");
        } else
        {   append3("unsigned char");
    }   }
    elif (get3("signed"))
    {   if (amigan)
        {   append3("LONG");
        } else
        {   append3("signed long");
        }
        nowhitespace3();
        while (!iswhitespace(*(Buffer3 + icursor)))
        {   icursor++;
    }   }
    elif (get3("true"))
    {   append3("TRUE");
    } elif (get3("uint"))
    {   if (amigan)
        {   append3("UWORD");
        } else
        {   append3("unsigned short");
    }   }
    elif (get3("unsigned"))
    {   if (amigan)
        {   append3("ULONG");
        } else
        {   append3("unsigned long");
        }
        nowhitespace3();
        while (!iswhitespace(Buffer3[icursor]))
        {   icursor++;
    }   }
    elif (get3("ulong"))
    {   if (amigan)
        {   append3("ULONG");
        } else
        {   append3("unsigned long");
    }   }
    elif (get3("ushort"))
    {   if (amigan)
        {   append3("UBYTE");
        } else
        {   append3("unsigned char");
    }   }
    elif (Buffer3[icursor] == '\"')
    {   append3("\"");
        icursor++;
        // assert(!quoted);
        quoted = '\"';
    } elif (Buffer3[icursor] == '\"')
    {   append3("\"");
        icursor++;
        // assert(!quoted);
        quoted = '\'';
    } elif (!strncmp(Buffer3 + icursor, "/*", 2))
    {   cnesting = 0;

        do
        {   if (!strncmp(Buffer3 + icursor, "*/", 2))
            {   append3("*/");
                icursor += 2;
                cnesting--;
            } elif (!strncmp(Buffer3 + icursor, "/*", 2))
            {   append3("/*");
                icursor += 2;
                cnesting++;
            } else
            {   Buffer4[ocursor++] = Buffer3[icursor++];
        }   }
        while (cnesting > 0);
    } elif (!strncmp(Buffer3 + icursor, "[*]", 3))
    {   icursor += 3;
        append3("[]");
    } elif (iswhitespace(*(Buffer3 + icursor)))
    {   *(Buffer4 + ocursor) = *(Buffer3 + icursor);
        icursor++;
        ocursor++;
    } else
    {   *(Buffer4 + ocursor) = *(Buffer3 + icursor);
        icursor++;
        ocursor++;
}   }

MODULE void phase2(void)
{   if (iswhitespace(*(Buffer2 + icursor)))
    {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
        icursor++;
        ocursor++;
    } elif (quoted)
    {   parsequoted2();
    } else
    {   parseunquoted2();
}   }

MODULE void parseunquoted2(void)
{   AUTO    FLAG  sysinclude, equals;
    PERSIST FLAG  founddefault[64 + 1];
    // 64 levels of case nesting (element 0 is not used)

    /* "*" (asterisk) is no longer supported, as it is too troublesome to
       determine whether it is intended:

       a) as a multiplier;

       b) as "pointer to", eg. (in a variable declaration):

          *uint foo

          (equivalent to unsigned int* foo in C, ie. a pointer to an
          unsigned integer); or,

       c) as the postfix deferencing operator, eg.:

          foo* := bar

          (equivalent to *foo = bar in C, ie. memory at address pointed
          to by foo takes the value of bar.) */

    if (!strncmp(Buffer2 + icursor, "/*", 2))
    {   cnesting = 0;
        do
        {   if (!strncmp(Buffer2 + icursor, "*/", 2))
            {   append2("*/");
                icursor += 2;
                cnesting--;
            } elif (!strncmp(Buffer2 + icursor, "/*", 2))
            {   append2("/*");
                icursor += 2;
                cnesting++;
            } else
            {   Buffer3[ocursor++] = Buffer2[icursor++];
        }   }
        while (cnesting > 0);
    } elif (get2("and", TRUE))
    {   append2("&&");
    } elif (get2("case", TRUE))
    {   append2("switch (");
        fresh = TRUE;
        cnesting++;
        founddefault[cnesting] = FALSE;
        while
        (   (strncmp(Buffer2 + icursor, "incase" , 6))
         && (strncmp(Buffer2 + icursor, "default", 7))
        )
        {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
            icursor++;
            ocursor++;
        }
        append2(") { ");
    } elif
    (   get2("corp", TRUE)
     || get2("fi"  , TRUE)
     || get2("od"  , TRUE)
    )
    {   append2("}");
        swallow(";");
    } elif (get2("default", TRUE))
    {   founddefault[cnesting] = TRUE;
        if (fresh)
        {   fresh = FALSE;
            append2("default");
        } else
        {   append2("break; default");
    }   }
    elif (get2("do", TRUE))
    {   append2(") {");
        t1cursor = icursor;
        while (iswhitespace(*(Buffer2 + t1cursor)))
        {   t1cursor++;
        }
        if
        (   !strncmp(Buffer2 + t1cursor, "od", 2)
         && (   *(Buffer2 + t1cursor + 2) == ';'
             || iswhitespace(*(Buffer2 + t1cursor + 2))
        )   )
        {   append2(" ; ");
    }   }
    elif (get2("elif", TRUE))
    {   append2("} else if (");
    } elif (get2("else", TRUE))
    {   append2("} else {");
    } elif (get2("for", TRUE))
    {   // for a from b [by c] upto|downto d

        append2("for (");
        nowhitespace2();
        t1cursor = 0;
        while (!iswhitespace(*(Buffer2 + icursor)))
        {   tempstring1[t1cursor] = *(Buffer2 + icursor);
            t1cursor++;
            icursor++;
        }
        tempstring1[t1cursor] = 0; // the null terminator
        append2(tempstring1);
        append2(" =");
        while (strncmp(Buffer2 + icursor, "from", 4))
        {   icursor++;
        }
        icursor += 4;
        by = done = FALSE;
        up = TRUE;
        do
        {   if (!strncmp(Buffer2 + icursor, "by", 2) && !by)
            {   icursor += 2;
                by = TRUE;
                t2cursor = 0;
            } elif (!strncmp(Buffer2 + icursor, "downto", 6))
            {   icursor += 6;
                done = TRUE;
                append2("; ");
                append2(tempstring1);
                append2(" >=");
                up = FALSE;
            } elif (!strncmp(Buffer2 + icursor, "upto", 4))
            {   icursor += 4;
                done = TRUE;
                append2("; ");
                append2(tempstring1);
                append2(" <=");
            } else
            {   if (by)
                {   tempstring2[t2cursor] = *(Buffer2 + icursor);
                    icursor++;
                    t2cursor++;
                } else
                {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
                    icursor++;
                    ocursor++;
        }   }   }
        while (!done);
        tempstring2[t2cursor] = 0;
        // now find the end value
        while (strncmp(Buffer2 + icursor, "do", 2))
        {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
            icursor++;
            ocursor++;
        }
        append2("; ");
        append2(tempstring1);
        if (by)
        {   append2(" +=");
            append2(tempstring2);
        } elif (up)
        {   append2("++");
        } else
        {   append2("--");
        }
        append2(") ");
    } elif (get2("esac", TRUE))
    {   if (founddefault[cnesting])
        {   append2("}");
        } else
        {   append2("default: break; }");
        }
        cnesting--;
        swallow(";");
    } elif (get2("if", TRUE))
    {   append2("if (");
    } elif (get2("ignore", TRUE))
    {   nowhitespace2();
    } elif (get2("incase", TRUE))
    {   if (fresh)
        {   fresh = FALSE;
            append2("case");
        } else
        {   append2("break; case");
    }   }
    elif (get2("not", TRUE))
    {   append2("!");
        nowhitespace2();
    } elif (get2("or", TRUE))
    {   append2("||");
    } elif (get2("proc", FALSE))
    {   nowhitespace2();

        /* we can't write anything to the output stream until we
        know about the return code. */

        t1cursor = 0;
        while (*(Buffer2 + icursor) != '(')
        {   tempstring1[t1cursor] = *(Buffer2 + icursor);
            t1cursor++;
            icursor++;
        }
        tempstring1[t1cursor] = 0; // null terminator
        // we now have tempstring1, containing the procedure name

        t2cursor = 0;
        done = FALSE;
        pnesting = 0;
        while (!done)
        {   tempstring2[t2cursor] = Buffer2[icursor];
            if (Buffer2[icursor] == ')')
            {   pnesting--;
                if (pnesting == 0)
                {   done = TRUE;
            }   }
            elif (Buffer2[icursor] == '(')
            {   pnesting++;
            }
            icursor++;
            t2cursor++;
        }
        tempstring2[t2cursor] = 0; // null terminator
        // we now have tempstring2, containing the argument list (including parentheses)

        t3cursor = 0;
        while (iswhitespace(Buffer2[icursor])) // skip preceding whitespace
        {   icursor++;
        }
        while (*(Buffer2 + icursor) != ':')
        {   tempstring3[t3cursor] = *(Buffer2 + icursor);
            t3cursor++;
            icursor++;
        }
        tempstring3[t3cursor] = 0; // null terminator
        icursor++;
        // we now have tempstring3, containing the return code

        append2(tempstring3);
        append2(" ");
        append2(tempstring1);

        if (!strncmp(tempstring2, "()", 2))
        {   strcpy(tempstring2, "(void)");
        }

#ifdef DEBUG
        Printf("Procedure name: '%s'!\n", tempstring1);
        Printf("Argument list:  '%s'!\n", tempstring2);
        Printf("Return code:    '%s'!\n", tempstring3);
#endif

        // tempstring1 and tempstring3 are now reused.
        // tempstring2 (containing the argument list) is still needed.
        tempstring1[0] = 0;
        t1cursor =
        t2cursor = 0; // seems not to be a bug
        // assert(pnesting == 0); 
        memvartype = FALSE;
        do
        {   ;
        } while (parsearglist());
        // tempstring1 now contains the converted argument list.
        tempstring1[t1cursor] = 0;

        append2(tempstring1);
        append2(" {");
    } elif (get2("then", TRUE))
    {   append2(") {");
        t1cursor = icursor;
        while (iswhitespace(*(Buffer2 + t1cursor)))
        {   t1cursor++;
        }
        if
        (   !strncmp(Buffer2 + t1cursor, "fi", 2)
         && (   *(Buffer2 + t1cursor + 2) == ';'
             || iswhitespace(*(Buffer2 + t1cursor + 2))
        )   )
        {   append2(" ;");
    }   }
    elif (get2("type", FALSE))
    {   append2("typedef");
        while (*(Buffer2 + icursor) != '=')
        {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
            icursor++;
            ocursor++;
        }
        icursor++;
        nowhitespace2();
    } elif (get2("while", TRUE))
    {   append2("while (");
    } elif (!strncmp(Buffer2 + icursor, ":="   , 2))
    {   append2("=");
        icursor += 2;
        code = TRUE;
    } elif (!strncmp(Buffer2 + icursor, "~="   , 2))
    {   append2("!=");
        icursor += 2;
    } elif (!strncmp(Buffer2 + icursor, "*."   , 2))
    {   append2("->");
        icursor += 2;
    } elif (!strncmp(Buffer2 + icursor, "><"   , 2))
    {   append2("^");
        icursor += 2;
    } elif (*(Buffer2 + icursor) == '\"')
    {   append2("\"");
        icursor++;
        // assert(!quoted);
        quoted = '\"';
    } elif (*(Buffer2 + icursor) == '\'')
    {   append2("\'");
        icursor++;
        // assert(!quoted);
        quoted = '\'';
    } elif (*(Buffer2 + icursor) == '\\' && !code)
    {   icursor++;
        if (!strncmp(Buffer2 + icursor, "include:", 8))
        {   append2("#include <");
            icursor += 8;
            sysinclude = TRUE;
        } else
        {   append2("#include \"");
            sysinclude = FALSE;
        }
        done = FALSE;
        while (!done)
        {   if (!strncmp(Buffer2 + icursor, ".g", 2))
            {   icursor += 2;
                if (sysinclude)
                {   append2(".h>");
                } else
                {   append2(".h\"");
                }
                done = TRUE;
            } elif (*(Buffer2 + icursor) == LF)
            {   icursor++;
                if (sysinclude)
                {   append2(">\n");
                } else
                {   append2("\"\n");
                }
                done = TRUE;
            } else
            {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
                icursor++;
                ocursor++;
    }   }   }
    elif (!strncmp(Buffer2 + icursor, "<=", 2)) // these lines are needed
    {   append2("<=");                          // so that eg. <= does not
        icursor++;                              // become <==
    } elif (!strncmp(Buffer2 + icursor, ">=", 2))
    {   append2(">=");
        icursor++;
    } elif (*(Buffer2 + icursor) == '=')
    {   append2("==");
        icursor++;
    } elif (Buffer2[icursor] == '(')
    {   code = TRUE;
        append2("(");
        icursor++;
    } elif (Buffer2[icursor] == '[' && !code)
    {   tempstring3[0] = 0;
        bnesting = 0;
        t3cursor = 0;
        equals   =
        done     = FALSE;

        do
        {   if (*(Buffer2 + icursor) == ',')
            {   icursor++;
                nowhitespace2();
                tempstring3[t3cursor++] = ']';
                tempstring3[t3cursor++] = '[';
            } elif (Buffer2[icursor] == ']')
            {   tempstring3[t3cursor] = *(Buffer2 + icursor);
                icursor++;
                t3cursor++;
                bnesting--;
                if (bnesting == 0)
                {   if (Buffer2[icursor] == '[')
                    {   done = FALSE;
                    } else done = TRUE;
            }   }
            elif (*(Buffer2 + icursor) == '[')
            {   tempstring3[t3cursor] = *(Buffer2 + icursor);
                icursor++;
                t3cursor++;
                bnesting++;
            } else
            {   tempstring3[t3cursor++] = Buffer2[icursor++];
            } // should really look for comments too
        } while (!done);
        tempstring3[t3cursor] = 0;

#ifdef DEBUG
Printf("Subscript is '%s'!\n", tempstring3);
#endif

/* We might have, for example:
    [SIZE, SIZE] TYPE a, b;
    ^
When we hit the '[', we start recording, converting ', ' to '][' on the
way. We continue to record until the bnesting level reaches 0 (ie. we hit
the appropriate ']').
  So now tempstring3 contains the subscript(s):
    [SIZE][SIZE]
  Now we copy from the input buffer to the output buffer, with the caveat
that every time we hit a ',', we insert the subscript(s) just before it.
When we hit a ';', we do likewise but also exit. */

        nowhitespace2();
        done = FALSE;
        pnesting = 0;
        while (!done)
        {   if (Buffer2[icursor] == '=' && iswhitespace(Buffer2[icursor + 1]))
            {   ocursor--;
                while (iswhitespace(Buffer3[ocursor]))
                {   ocursor--;
                }
                equals = TRUE;
                ocursor++;
                append2(tempstring3);
                append2(" =");
                icursor++;
            } elif (!strncmp(Buffer2 + icursor, "/*", 2)) // needs to be before "*" handling
            {   cnesting = 0;
                do
                {   if (!strncmp(Buffer2 + icursor, "*/", 2))
                    {   append2("*/");
                        icursor += 2;
                        cnesting--;
                    } elif (!strncmp(Buffer2 + icursor, "/*", 2))
                    {   append2("/*");
                        icursor += 2;
                        cnesting++;
                    } else
                    {   Buffer3[ocursor++] = Buffer2[icursor++];
                }   }
                while (cnesting > 0);
            } elif (Buffer2[icursor] == ';')
            {   if (pnesting == 0 && !equals)
                {   append2(tempstring3);
                }
                append2(";");
                icursor++;
                done = TRUE;
            } elif (Buffer2[icursor] == ',')
            {   if (pnesting == 0 && !equals)
                {   append2(tempstring3);
                }
                append2(",");
                icursor++;
            } elif (Buffer2[icursor] == '(')
            {   pnesting++;
                append2("{");
                icursor++;
            } elif (Buffer2[icursor] == ')')
            {   pnesting--;
                append2("}");
                icursor++;
            } elif (Buffer2[icursor] == '*' && !iswhitespace(Buffer2[icursor + 1])) // 'pointer to' symbol
            {   icursor++;
                while (!iswhitespace(Buffer2[icursor]))
                {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
                    icursor++;
                    ocursor++;
                }
                append2("*");
            } else
            {   Buffer3[ocursor++] = Buffer2[icursor++];
    }   }   }
    elif (*(Buffer2 + icursor) == '[' && code)
    {   bnesting = 0;
        do
        {   if (*(Buffer2 + icursor) == ',')
            {   icursor++;
                nowhitespace2();
                append2("][");
            } elif (*(Buffer2 + icursor) == ']')
            {   icursor++;
                *(Buffer3 + ocursor) = ']';
                ocursor++;
                bnesting--;
            } elif (*(Buffer2 + icursor) == '[')
            {   icursor++;
                *(Buffer3 + ocursor) = '[';
                ocursor++;
                bnesting++;
            } else
            {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
                icursor++;
                ocursor++;
        }   }
        while (bnesting > 0);
    } else
    {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
        icursor++;
        ocursor++;
}   }

MODULE void parsequoted2(void)
{   if (!strncmp(Buffer2 + icursor, "\'\'"   , 2))
    {   icursor += 2;
        append2("\\\""); // ie. '' becomes \"
    } elif (!strncmp(Buffer2 + icursor, "\\e"  , 2))
    {   icursor += 2;
        append2("\\0");
    } elif (*(Buffer2 + icursor) == '\"' && quoted == '\"')
    {   icursor++;
        append2("\"");
        // assert(quoted);
        quoted = FALSE;
    } elif (*(Buffer2 + icursor) == '\'' && quoted == '\'')
    {   icursor++;
        append2("\'");
        // assert(quoted);
        quoted = FALSE;
    } else
    {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
        icursor++;
        ocursor++;
}   }

MODULE void append1(STRPTR string)
{   *(Buffer2 + ocursor) = 0;
    strcat(Buffer2 + ocursor, string);
    ocursor += strlen(string);
}
MODULE void append2(STRPTR string)
{   *(Buffer3 + ocursor) = 0;
    strcat(Buffer3 + ocursor, string);
    ocursor += strlen(string);
}
MODULE void append3(STRPTR string)
{   *(Buffer4 + ocursor) = 0;
    strcat(Buffer4 + ocursor, string);
    ocursor += strlen(string);
}

MODULE void swallow(STRPTR string)
{   ULONG length;

    length = strlen(string);

    while (iswhitespace(*(Buffer2 + icursor)))
    {   *(Buffer3 + ocursor) = *(Buffer2 + icursor);
        icursor++;
        ocursor++;
    }

    if (!strncmp(Buffer2 + icursor, string, length))
    {   icursor += length;
}   }

MODULE FLAG get1(STRPTR string)
{   ULONG length;

    length = strlen(string);

    if
    (   (!strncmp(Buffer1 + icursor, string, length))
    )
    {   icursor += length;

#ifdef DEBUG
        Printf("Found trigraph '%s'!\n", string);
#endif

        return(TRUE);
    } else
    {   return(FALSE);
}   }
MODULE FLAG get2(STRPTR string, FLAG coded)
{   ULONG length;

    length = strlen(string);

    if
    (   (!strncmp(Buffer2 + icursor, string, length))
     && (   *(Buffer2 + icursor + length) == ';'
         || *(Buffer2 + icursor + length) == ','
         || iswhitespace(*(Buffer2 + icursor + length))
    )   )
    {   icursor += length;
        code = coded;

#ifdef DEBUG
        Printf("Found keyword '%s'!\n", string);
#endif

        return(TRUE);
    } else
    {   return(FALSE);
}   }
MODULE FLAG get3(STRPTR string)
{   ULONG length;

    length = strlen(string);

    if
    (   (!strncmp(Buffer3 + icursor, string, length))
     && (   *(Buffer3 + icursor + length) == ';'
         || *(Buffer3 + icursor + length) == ','
         || *(Buffer3 + icursor + length) == '['
         || *(Buffer3 + icursor + length) == '*'
         || iswhitespace(*(Buffer3 + icursor + length))
    )   )
    {   icursor += length;
        t1cursor = icursor;
        while (iswhitespace(*(Buffer3 + t1cursor)))
        {   t1cursor++;
        }
        if (!strncmp(Buffer3 + t1cursor, "#define", 7))
        {   icursor = t1cursor;
            return(FALSE);
        }

#ifdef DEBUG
        Printf("Found variable type '%s'!\n", string);
#endif

        return(TRUE);
    } else
    {   return(FALSE);
}   }

MODULE void nowhitespace2(void)
{   while (iswhitespace(*(Buffer2 + icursor)))
    {   icursor++;
}   }
MODULE void nowhitespace3(void)
{   while (iswhitespace(*(Buffer3 + icursor)))
    {   icursor++;
}   }

MODULE FLAG iswhitespace(TEXT candidate)
{   if
    (   candidate == ' '
     || candidate == TAB
     || candidate == LF
    )
    {   return(TRUE);
    } else
    {   return(FALSE);
}   }

MODULE void rq(STRPTR message)
{   Printf("%s\n", message);
    exit(EXIT_FAILURE);
}

MODULE FLAG parsearglist(void)
{   FLAG  again = FALSE; // to avoid spurious compiler warnings
    ULONG asterisks = 0;

#ifdef DEBUG
Printf("Entering parsearglist()!\n");
#endif

    /*
    tempstring1 will contain the output string, eg.
    (TYPE x[*][*], TYPE y[*][*], TYPE z[*][*])

    tempstring2 contains the input string, eg.
    ([*, *] TYPE x; [*, *] TYPE y; [*, *] TYPE z)
    ^
    tempstring3 will contain the subscript string, eg.
    [*][*]

    tempstring4 will contain the variable type string, eg.
    uint
    */

    tempstring3[0] =
    tempstring4[0] = 0;
    t3cursor       =
    t4cursor       = 0;
    bnesting       = 0;
    done           = FALSE;

#ifdef DEBUG
Printf("Input  string is: '%s', cursor is %ld!\n", tempstring2, t2cursor);
Printf("Output string is: '%s', cursor is %ld!\n", tempstring1, t1cursor);
#endif

    while (iswhitespace(tempstring2[t2cursor]))
    {   tempstring1[t1cursor++] =
        tempstring2[t2cursor++];
    }

    while (!done)
    {   if (tempstring2[t2cursor] == '[')
        {   bnesting       = 0;
            t3cursor       = 0;
            tempstring3[0] = 0;
            do
            {   if (tempstring2[t2cursor] == ',')
                {   t2cursor++;
                    while (iswhitespace(tempstring2[t2cursor]))
                    {   t2cursor++;
                    }
                    tempstring3[t3cursor++] = ']';
                    tempstring3[t3cursor++] = '[';
                } elif (tempstring2[t2cursor] == ']')
                {   tempstring3[t3cursor] = ']';
                    t2cursor++;
                    t3cursor++;
                    bnesting--;
                    while (iswhitespace(tempstring2[t2cursor]))
                    {   t2cursor++;
                }   }
                elif (tempstring2[t2cursor] == '[')
                {   tempstring3[t3cursor] = '[';
                    t2cursor++;
                    t3cursor++;
                    bnesting++;
                } else
                {   tempstring3[t3cursor++] = tempstring2[t2cursor++];
            }   }
            while (bnesting > 0);
            tempstring3[t3cursor] = 0;
        } elif (tempstring2[t2cursor] == ';')
        {   tempstring1[t1cursor] = 0;
            strcat(&tempstring1[t1cursor], tempstring3);
            strcat(&tempstring1[t1cursor], ",");
            t1cursor = strlen(tempstring1);
            t2cursor++;
            done = again = memvartype = TRUE;
            asterisks = 0;
        } elif (tempstring2[t2cursor] == '*' && memvartype)
        {   asterisks++;
            t2cursor++;
        } elif (tempstring2[t2cursor] == ',')
        {   tempstring1[t1cursor] = 0;
            strcat(&tempstring1[t1cursor], tempstring3);
            t1cursor = strlen(tempstring1);
            strcat(&tempstring1[t1cursor], ", ");
            t1cursor = strlen(tempstring1);
            strcat(&tempstring1[t1cursor], tempstring4);
            t1cursor = strlen(tempstring1);
            t2cursor++;
        } elif (iswhitespace(tempstring2[t2cursor]))
        {   if (memvartype)
            {   memvartype = FALSE;
                while (asterisks > 0)
                {   tempstring4[t4cursor++] =
                    tempstring1[t1cursor++] = '*';
                    asterisks--;
                }
                tempstring4[t4cursor] = 0;
            }
            tempstring1[t1cursor++] =
            tempstring2[t2cursor++];
        } elif (tempstring2[t2cursor] == ')' && pnesting == 1)
        {   pnesting = 0;
            tempstring1[t1cursor] = 0;
            strcat(&tempstring1[t1cursor], tempstring3);
            strcat(&tempstring1[t1cursor], ")");
            t1cursor = strlen(tempstring1);
            t2cursor++;
            done = TRUE;
            again = FALSE;
        } elif (tempstring2[t2cursor] == '(')
        {   if (pnesting == 0)
            {   memvartype = TRUE;
                asterisks = 0;
                tempstring1[t1cursor++] =
                tempstring2[t2cursor++];
            } else
            {   if (memvartype)
                {   tempstring1[t1cursor++] =
                    tempstring4[t4cursor++] =
                    tempstring2[t2cursor++];
                } else
                {   tempstring1[t1cursor++] =
                    tempstring2[t2cursor++];
            }   }
            pnesting++;
        } else
        {   if (tempstring2[t2cursor] == ')')
            {   pnesting--;
            }

            if (memvartype)
            {   tempstring1[t1cursor++] =
                tempstring4[t4cursor++] =
                tempstring2[t2cursor++];
            } else
            {   tempstring1[t1cursor++] =
                tempstring2[t2cursor++];
    }   }   }

    return(again);
}
