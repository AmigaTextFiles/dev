/*
    fd2pragma.c

    This is a small little hack which converts fd-files to either
    pragmas readable by a C-Compiler of LVO files readable by an
    assembler. Use it as you want, but WITHOUT ANY WARRANTY!

    V1.2:   Added pragmas for the Dice compiler. Available via switch "Dice".
	    Added switches "Aztec", "SAS" and "Maxon": Maxon and Aztec just
	    turn on the default (except that Maxon expects pragma files to be
	    called "xxx_pragmas.h" instead of "xxx_lib.h"), SAS is equal to
	    Dice, except that SAS supports the pragma tagcall.

    V2.0:   Added support for tag functions. See the docs for details.
    V2.1:   Minor bugfix; added support of PRAGMAS_DECLARING_LIBBASE
    V2.2:   Added the possibility to create a libraries function table.
            (See LibHeader.c)

    Computer: Amiga 1200			Compiler: Aztec-C V5.0a
							  Dice 3.01

    Author:	Jochen Wiedmann
		Am Eisteich 9
	  72555 Metzingen (Germany)
		Tel. 07123 / 14881
		Internet: wiedmann@zdv.uni-tuebingen.de
*/





/*
    Include files
*/
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/interrupts.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>

#ifdef AZTEC_C
#include <pragmas/exec_lib.h>
#include <pragmas/dos_lib.h>
#endif

#if defined(_DCC)  ||  defined(__SASC)  ||  defined(__MAXON)
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#endif

#ifdef __GNUC__
#include <inline/exec.h>
#include <inline/dos.h>
#endif

extern struct Library *SysBase;
extern struct Library *DOSBase;





/*
    Constants
*/
#define MAXNAMELEN 128

const UBYTE VERSION[] = "$VER: fd2pragma 2.2 (04.07.94)   by  Jochen Wiedmann";
const UBYTE TEMPLATE[] =
    "FDFILE/A,AZTEC/K,AS/K,SAS/K,DICE/K,MAXON/K,TAGDIR/K,FUNCTABLE/K,HELP/S";

const STRPTR RegNames[16] =
{ (STRPTR) "d0", (STRPTR) "d1", (STRPTR) "d2", (STRPTR) "d3",
  (STRPTR) "d4", (STRPTR) "d5", (STRPTR) "d6", (STRPTR) "d7",
  (STRPTR) "a0", (STRPTR) "a1", (STRPTR) "a2", (STRPTR) "a3",
  (STRPTR) "a4", (STRPTR) "a5", (STRPTR) "a6", (STRPTR) "a7"
};

const UBYTE HexDigits[17] = "0123456789ABCDEF";



/*
    This structure is used to represent the pragmas that are read.
*/
struct AmiPragma
{ struct MinNode Node;
  LONG Bias;
  LONG Public;
  STRPTR FuncName;
  STRPTR TagName;
  ULONG NumArgs;
  struct
  { STRPTR ArgName;
    ULONG ArgReg;
  } Args[14];	/*  a6 and a7 must not be used for function arguments	*/
};





/*
    Global variables
*/
struct MinList AmiPragmaList;
STRPTR BaseName;
STRPTR ShortBaseName;





/*
    This function works similar to strdup, but doesn't duplicate the
    whole string.

    Inputs: Str - the string to be duplicated
	    Len - the number of bytes to be duplicated

    Result: Pointer to the copy of the string or NULL.
*/
STRPTR strndup(const STRPTR Str, ULONG Len)

{ STRPTR result;

  if ((result = malloc(Len+1)))
  { memcpy(result, Str, Len);
    result[Len] = '\0';
  }
  return(result);
}





/*
    This function prints help information.
*/
void Usage(void)

{ fprintf(stderr, "\nUsage: fd2pragma %s\n\n", TEMPLATE);

  fprintf(stderr, "This program reads the given FDFILE and converts it ");
  fprintf(stderr, "into pragmas for\n");
  fprintf(stderr, "a C-Compiler (SAS, Dice, Aztec or Maxon) or LVO files ");
  fprintf(stderr, "for an\n");
  fprintf(stderr, "Assembler (Aztec-As).\n\n");
  fprintf(stderr, "FUNCTABLE is the name of a file where to store a ");
  fprintf(stderr, "function table\n");
  fprintf(stderr, "called LibFuncTable which describes the LVO table. (See ");
  fprintf(stderr, "LibHeader.c)\n\n");
  fprintf(stderr, "TAGDIR is the name of a directory where to store stub ");
  fprintf(stderr, "routines for\n");
  fprintf(stderr, "pragma functions, if any are found. \"\" is the current ");
  fprintf(stderr, "directory.\n\n\n");
  fprintf(stderr, "%s\n\n", VERSION+6);
  fprintf(stderr,
	  "This is public domain, use it as you want, but WITHOUT ANY WARRANTY!\n");
  fprintf(stderr,
	  "Bugs and suggestions to wiedmann@mailserv.zdv.uni-tuebingen.de.\n\n");

  exit (1);
}





/*
    This function is used to skip over blanks.

    Inputs: OldPtr  - pointer to the beginning of a string.

    Result: Pointer to the first nonblank character of the string.
*/
STRPTR SkipBlanks(const STRPTR OldPtr)

{ STRPTR oldptr = OldPtr;

  while (*oldptr == ' '  ||  *oldptr == '\t')
  { ++oldptr;
  }
  return(oldptr);
}





/*
    This function is used to skip over variable names.

    Inputs: OldPtr  - pointer to the beginning of a string.

    Result: Pointer to the first character of the string, that is not one
	    of a-z, A-Z, 0-9 or the underscore.
*/
STRPTR SkipName(const STRPTR OldPtr)

{ STRPTR oldptr;
  UBYTE c;

  oldptr = OldPtr;
  while((c = *oldptr) == '_'  ||
	(c >= '0'  &&  c <= '9')  ||
	(c >= 'a'  &&  c <= 'z')  ||
	(c >= 'A'  &&  c <= 'Z'))
  { ++oldptr;
  }
  return(oldptr);
}





/*
    This function tells, that we ran out of memory.
*/
void MemError(void)

{ fprintf(stderr, "Fatal: Out of memory!\n");
}






/*
    This function is called to scan the FD file.

    Inputs: FDFile  - the name of the file to scan

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG ScanFDFile(const STRPTR FDFile)

{ FILE *fp;
  ULONG public = TRUE;
  ULONG bias = -1;
  ULONG linenum = 0;
  ULONG result = FALSE;
  UBYTE line[512];

  if (!(fp = fopen((char *) FDFile, "r")))
  { fprintf(stderr, "Fatal: Cannot open FD file %s.\n", FDFile);
    return(FALSE);
  }

  NewList((struct List *) &AmiPragmaList);

  while(fgets((char *) line, sizeof(line), fp)  !=  NULL)
  { ULONG len;

    ++linenum;

    for (len = 0;  len < sizeof(line);  ++len)
    { if (line[len] == '\n')
      { break;
      }
    }
    if (len == sizeof(line))
    { int c;

      fprintf(stderr, "Error: Line %ld too long.\n", linenum);
      while((c = getc(fp)) != EOF  &&  c != '\n')
      {
      }
      continue;
    }
    line[len] = '\0';   /*  Remove Line Feed    */

    if (line[0] == '*')
    { /*  Comment   */
      STRPTR ptr;

      ptr = SkipBlanks(line+1);
      if(strnicmp((char *) ptr, "tagcall", 7) == 0)  /*  Tag to create?  */
      { struct AmiPragma *prevpragma;

	ptr = SkipBlanks(ptr+7);

	prevpragma = (struct AmiPragma *) AmiPragmaList.mlh_TailPred;
	if (!prevpragma->Node.mln_Pred)
	{ fprintf(stderr,
		  "Line %ld, Error: Tag definition without preceding Pragma.\n",
		  linenum);
	  continue;
	}

	if (prevpragma->TagName)
	{ fprintf(stderr, "Line %ld, Warning: Tag function redeclared.\n",
		  linenum);
	  continue;
	}

	if (!prevpragma->NumArgs)
	{ fprintf(stderr,
		  "Line %ld, Error: Tag function must have arguments.\n",
		  linenum);
	}

	/*
	    Get the tag functions name.
	*/
	len = strlen((char *) prevpragma->FuncName)+strlen((char *) ptr)+1;

	if (!(prevpragma->TagName = strndup(prevpragma->FuncName, len)))
	{ MemError();
	  goto exit_ScanFDFile;
	}

	if (!*ptr)
	{ len = strlen((char *) prevpragma->TagName);
	  if (prevpragma->TagName[len-1] == 'A')
	  { prevpragma->TagName[len-1] = '\0';
	  }
	}
	else
	{ STRPTR nextptr;

	  if (*ptr == '=')
	  { ptr = SkipBlanks(ptr+1);
	    nextptr = SkipName(ptr);
	    if (!(len = nextptr-ptr))
	    { fprintf(stderr, "Line %ld, Error: Missing pragma name.\n",
		      linenum);
	      continue;
	    }
	    strncpy((char *) prevpragma->TagName, (char *) ptr, len);
	    prevpragma->TagName[len] = '\0';
	  }
	  else
	  { nextptr = SkipName(ptr);
	    if ((len = nextptr-ptr))
	    { STRPTR addptr;

	      addptr = prevpragma->TagName + strlen(prevpragma->TagName);
	      *ptr = toupper(*ptr);
	      strncat((char *) addptr, (char *) ptr, len);
	      addptr[len] = '\0';
	    }
	    else
	    { fprintf(stderr, "Line %ld, Error: Missing pragma name.\n",
		      linenum);
	      continue;
	    }
	  }

	  if (*SkipBlanks(nextptr))
	  { fprintf(stderr, "Line %ld, warning: Extra characters\n", linenum);
	  }
	}
      }
    }
    else if (strnicmp((char *) line, "##base", 6) == 0)
    { STRPTR ptr, nextptr;
      LONG len;

      if (BaseName)
      { fprintf(stderr, "Line %ld, Error: Basename declared twice.\n",
		linenum);
      }

      ptr = SkipBlanks(line+6);
      if (*ptr != '_')
      { fprintf(stderr, "Line %ld, Warning: Expected preceding _ in Basename.\n",
		linenum);
      }
      else
      { ++ptr;
      }
      nextptr = SkipName(ptr);
      if ((len = nextptr-ptr))
      { if (!(BaseName = strndup(ptr, len)))
	{ MemError();
	  goto exit_ScanFDFile;
	}

	ptr = FilePart(FDFile);
	len = strlen((char *) ptr)-7;
	if (len >= 0  &&  stricmp((char *) ptr+len, "_lib.fd") == 0)
	{ if (!(ShortBaseName = (STRPTR) strdup((char *) ptr)))
	  { MemError();
	    goto exit_ScanFDFile;
	  }
	  ShortBaseName[len] = '\0';
	}
	else
	{ if (!(ShortBaseName = (STRPTR) strdup((char *) BaseName)))
	  { MemError();
	    goto exit_ScanFDFile;
	  }
	  len = strlen((char *) ShortBaseName)-4;
	  if (len >= 0  &&  stricmp((char *) ShortBaseName+len, "base") == 0)
	  { ShortBaseName[len] = '\0';
	  }
	}

	if (*SkipBlanks(nextptr))
	{ fprintf(stderr, "Line %ld, warning: Extra characters\n", linenum);
	}
      }
      else
      { fprintf(stderr, "Line %ld, Error: Expected Basename.\n", linenum);
      }
    }
    else if (strnicmp((char *) line, "##bias", 6) == 0)
    { STRPTR ptr;
      LONG newbias;

      newbias = strtol((char *) line+6, (char **) &ptr, 0);
      if (ptr == line+6)
      { fprintf(stderr, "Line %ld, Error: Expected Bias value.\n", linenum);
      }
      else
      { if (newbias < 0)
	{ fprintf(stderr, "Line %ld, warning: Assuming positive value.\n",
		  linenum);
	  bias = -newbias;
	}
	else
	{ bias = newbias;
	}
      }
      if (*SkipBlanks(ptr))
      { fprintf(stderr, "Line %ld, warning: Extra characters\n", linenum);
      }
    }
    else if (strnicmp((char *) line, "##end", 5) == 0)
    { if (*SkipBlanks(line+5))
      { fprintf(stderr, "Line %ld, warning: Extra characters\n", linenum);
      }
      break;
    }
    else if (strnicmp((char *) line, "##public", 8) == 0)
    { if (*SkipBlanks(line+8))
      { fprintf(stderr, "Line %ld, warning: Extra characters\n", linenum);
      }
      public = TRUE;
    }
    else if (strnicmp((char *) line, "##private", 9) == 0)
    { if (*SkipBlanks(line+9))
      { fprintf(stderr, "Line %ld, warning: Extra characters\n", linenum);
      }
      public = FALSE;
    }
    else
    { STRPTR ptr, nextptr;
      struct AmiPragma *newpragma;
      ULONG len, numargs;

      ptr = SkipBlanks(line);
      nextptr = SkipName(ptr);
      if (!(len = nextptr-ptr))
      { fprintf(stderr, "Line %ld, Error: Missing function name\n", linenum);
	continue;
      }

      if (!(newpragma = calloc(sizeof(*newpragma), 1))  ||
	  !(newpragma->FuncName = strndup(ptr, len)))
      { MemError();
	goto exit_ScanFDFile;
      }

      if (*(ptr = SkipBlanks(nextptr)) != '(')
      { fprintf(stderr, "Line %ld, Error: Expected '('.\n", linenum);
	continue;
      }

      do
      { ptr = SkipBlanks(ptr+1);

	if (*ptr == ')' && newpragma->NumArgs == 0)
	{ break;
	}

	if (newpragma->NumArgs == 14)
	{ fprintf(stderr, "Line %ld, Error: Too much arguments.\n", linenum);
	}

	nextptr = SkipName(ptr);
	if (!(len = nextptr-ptr))
	{ fprintf(stderr, "Line %ld, Error: Expected argument name.\n",
		  linenum);
	  goto continue_loop;
	}

	if (!(ptr = strndup(ptr, len)))
	{ MemError();
	  goto exit_ScanFDFile;
	}
	newpragma->Args[newpragma->NumArgs++].ArgName = ptr;

	ptr = SkipBlanks(nextptr);
	if (*ptr != ','  &&  *ptr != '/'  &&  *ptr != ')')
	{ fprintf(stderr, "Line %ld, Error: Expected ')'.\n", linenum);
	  goto continue_loop;
	}
      }
      while (*ptr != ')');

      if (*(ptr = SkipBlanks(ptr+1)) != '(')
      { fprintf(stderr, "Line %ld, Error: Expected '('.\n", linenum);
	continue;
      }

      numargs = 0;
      do
      { ULONG i;

	ptr = SkipBlanks(ptr+1);

	if (*ptr == ')'  &&  numargs == 0)
	{ break;
	}

	if (numargs > newpragma->NumArgs)
	{ fprintf(stderr,
		  "Line %ld, Error: Number of arguments != number of registers.\n",
		  linenum);
	  goto continue_loop;
	}

	nextptr = SkipName(ptr);
	if (!(len = nextptr-ptr))
	{ fprintf(stderr, "Line %ld, Error: Expected register name.\n",
		  linenum);
	  goto continue_loop;
	}

	for (i = 0;  i < 16;  i++)
	{ if (strnicmp((char *) RegNames[i], (char *) ptr, len) == 0)
	  { break;
	  }
	}

	if (i > 16)
	{ fprintf(stderr, "Line %ld, Error: Expected register name.\n",
		  linenum);
	  goto continue_loop;
	}
	if (i > 14)
	{ fprintf(stderr,
		  "Line %ld, Error: %s not allowed as argument register.\n",
		  linenum, RegNames[i]);
	  goto continue_loop;
	}

	newpragma->Args[numargs].ArgReg = i;

	for (i = 0;  i < numargs;  i++)
	{ if (newpragma->Args[numargs].ArgReg == newpragma->Args[i].ArgReg)
	  { fprintf(stderr, "Line %ld, Error: Register %s used twice.\n",
		    linenum, RegNames[newpragma->Args[numargs].ArgReg]);
	    goto continue_loop;
	  }
	}
	++numargs;

	ptr = SkipBlanks(nextptr);
	if (*ptr != ','  &&  *ptr != '/'  &&  *ptr != ')')
	{ fprintf(stderr, "Line %ld, Error: Expected ')'.\n", linenum);
	  goto continue_loop;
	}
      }
      while (*ptr != ')');

      if (numargs < newpragma->NumArgs)
      { fprintf(stderr,
		"Line %ld, Error: Number of arguments != number of registers.\n",
		linenum);
	goto continue_loop;
      }

      if (bias == -1)
      { fprintf(stderr, "Line %ld, warning: Assuming bias of 30.\n",
		 linenum);
	bias = 30;
      }
      newpragma->Bias = bias;
      bias += 6;

      newpragma->Public = public;

      AddTail((struct List *) &AmiPragmaList, (struct Node *) newpragma);

      if (*SkipBlanks(ptr+1))
      { fprintf(stderr, "Line %ld, warning: Extra characters.\n", linenum);
      }
    }

continue_loop:
  ;
  }

  if (!BaseName)
  { fprintf(stderr, "Error: Missing Basename.\n");
  }
  else
  { result = TRUE;
  }

exit_ScanFDFile:
  fclose(fp);
  return(result);
}





/*
    This function is similar to puts, but converts the string to lowercase.

    Inputs: Str - the string to write
	    Fp	- the file where to write to

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG fputslower(const STRPTR Str, FILE *Fp)

{ STRPTR str = Str;

  while(*str)
  { char c = tolower((int) *str);

    str++;
    if (putc(c, Fp) == EOF)
    { return(FALSE);
    }
  }
  return(TRUE);
}





/*
    This function is similar to puts, but converts the string to uppercase.

    Inputs: Str - the string to write
	    Fp	- the file where to write to

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG fputsupper(const STRPTR Str, FILE *Fp)

{ STRPTR str = Str;

  while(*str)
  { char c = toupper((int) *str);

    str++;
    if (putc(c, Fp) == EOF)
    { return(FALSE);
    }
  }
  return(TRUE);
}





/*
    This function writes the header of a pragma file.

    Inputs: Fp	    - the file to write to.
	    Type    - Either "pragmas" or "lib", depending on the
		      typical pragma name. (Aztec uses something
		      like "pragmas/exec_pragmas.h" while SAS, Dice
		      and MAXON prefer "pragmas/exec_lib.h".)

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG WriteHeader(FILE *Fp, const STRPTR Type)

{
  if (fputs("#ifndef PRAGMAS_", Fp) < 0             ||
      !fputsupper(ShortBaseName, Fp)                ||
      (putc('_', Fp) == EOF)                        ||
      !fputsupper(Type, Fp)                         ||
      fputs("_H\n#define PRAGMAS_", Fp) < 0         ||
      !fputsupper(ShortBaseName, Fp)                ||
      (putc('_', Fp) == EOF)                        ||
      !fputsupper(Type, Fp)                         ||
      fputs("_H\n\n#ifndef CLIB_", Fp) < 0          ||
      !fputsupper(ShortBaseName, Fp)                ||
      fputs("_PROTOS_H\n#include <clib/", Fp) < 0   ||
      !fputslower(ShortBaseName, Fp)                ||
      fputs("_protos.h>\n#endif\n\n", Fp) < 0)

  { return(FALSE);
  }

  return(TRUE);
}





/*
    This function writes the footer of a pragma file.

    Inputs: Fp	    - the file to write to.
	    Type    - Either "pragmas" or "lib", depending on the
		      typical pragma name. (Aztec uses something
		      like "pragmas/exec_pragmas.h" while SAS, Dice
		      and MAXON prefer "pragmas/exec_lib.h".)

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG WriteFooter(FILE *Fp, const STRPTR Type)

{
  if (fputs("\n#endif\t/*  PRAGMAS_", Fp) < 0   ||
      !fputsupper(ShortBaseName, Fp)            ||
      (putc('_', Fp) == EOF)                    ||
      !fputsupper(Type, Fp)                     ||
      fputs("_H  */\n", Fp) < 0)
  { return(FALSE);
  }

  return(TRUE);
}





/*
    This function writes one pragma for Aztec-C.

    Inputs: Ap	- a pointer to the pragma which should be written.
	    Fp	- the file to write to

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG WriteAztecPragma(struct AmiPragma *Ap, FILE *Fp)

{ int i;

  if (!Ap->Public)
  { return(TRUE);
  }

  if (fprintf(Fp, "#pragma amicall(%s,0x%lx,%s(",
	      BaseName, Ap->Bias, Ap->FuncName) < 0)
  { return(FALSE);
  }

  for (i = 0;  i < Ap->NumArgs;  ++i)
  { if (!fputslower(RegNames[Ap->Args[i].ArgReg], Fp))
    { return(FALSE);
    }
    if (i+1 < Ap->NumArgs  &&  putc(',', Fp) == EOF)
    { return(FALSE);
    }
  }

  if (fputs("))\n", Fp) < 0)
  { return(FALSE);
  }

  return(TRUE);
}





/*
    This function writes one pragma for SAS-C.

    Inputs: Ap	    - a pointer to the pragma which should be written.
	    Fp	    - the file to write to
	    TagCall - TRUE for a tagcall pragma, FALSE for a libcall pragma

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG WriteSASPragma(struct AmiPragma *Ap, FILE *Fp, ULONG TagCall)

{ int i;

  if (!Ap->Public)
  { return(TRUE);
  }

  if (fprintf(Fp, "#pragma %s %s %s %lx ",
	      TagCall ? "tagcall" : "libcall",
	      BaseName,
	      TagCall ? Ap->TagName : Ap->FuncName,
	      Ap->Bias) < 0)
  { return(FALSE);
  }

  for (i = Ap->NumArgs-1;  i >= 0;  --i)
  { if ((fputc((int) HexDigits[Ap->Args[i].ArgReg], Fp) == EOF))
    { return(FALSE);
    }
  }

  if (fprintf(Fp, "0%lc\n", HexDigits[Ap->NumArgs]) < 0)
  { return(FALSE);
  }

  return(TRUE);
}





/*
    This function creates a pragma file.

    Inputs: PragmaFile	- name of the file to be created.
	    PragmaExt	- TRUE, if the typical pragma filename is similar to
			  clib/exec_pragmas.h, FALSE for clib/exec_lib.h
	    SASPragmas	- TRUE for SAS-like pragmas, FALSE for Aztec
	    UseTags	- TRUE, if tagcall pragmas should be created.
	    Prototype	- TRUE, if a prototype for the library basepointer
			  should be created. (Dice seems to need this.)

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG CreatePragmaFile(const STRPTR PragmaFile, ULONG PragmaExt,
		       ULONG SASPragmas, ULONG UseTags, ULONG Prototype)

{ FILE *fp;
  struct AmiPragma *ap;
  ULONG result = FALSE;
  ULONG tagcall_seen = FALSE;

  if (!(fp = fopen((char *) PragmaFile, "w")))
  { fprintf(stderr, "Error: Cannot open %s for writing.\n", PragmaFile);
    return(FALSE);
  }

  if (!WriteHeader(fp, (STRPTR) (PragmaExt ? "pragmas" : "lib")))
  { goto exit_CreatePragmaFile;
  }

  if (Prototype)
  { if (fputs("#ifdef PRAGMAS_DECLARING_LIBBASE\n", fp) < 0         ||
	fprintf(fp, "extern struct Library *%s;\n", BaseName) < 0   ||
	fputs("#endif\n\n", fp) < 0)
    { goto exit_CreatePragmaFile;
    }
  }

  /*
      Write the pragmas.
  */
  for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
       ap->Node.mln_Succ;
       ap = (struct AmiPragma *) ap->Node.mln_Succ)
  { if ((SASPragmas  &&  !WriteSASPragma(ap, fp, FALSE))  ||
	(!SASPragmas  &&  !WriteAztecPragma(ap, fp)))
    { goto exit_CreatePragmaFile;
    }
    if (ap->TagName  &&  ap->Public)
    { tagcall_seen = TRUE;
    }
  }
  if (tagcall_seen  &&  UseTags)
  { if (fputs("\n#ifdef __SASC_60\n", fp) < 0)
    { goto exit_CreatePragmaFile;
    }

    for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
	 ap->Node.mln_Succ;
	 ap = (struct AmiPragma *) ap->Node.mln_Succ)
     { if (ap->TagName  &&  !WriteSASPragma(ap, fp, TRUE))
       { goto exit_CreatePragmaFile;
       }
     }

    if (fputs("#endif\t/*  __SASC_60  */\n", fp) < 0)
    { goto exit_CreatePragmaFile;
    }
   }

  /*
      Write the footer.
  */
  if (!WriteFooter(fp, (STRPTR) (PragmaExt ? "pragmas" : "lib")))
  { goto exit_CreatePragmaFile;
  }

  result = TRUE;

exit_CreatePragmaFile:
  if (!result)
  { fprintf(stderr, "Error while writing %s.\n", PragmaFile);
  }
  fclose(fp);
  return(result);
}





/*
    This function creates a LVO file.

    Inputs: LVOFile - the name of the file

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG CreateLVOFile(const STRPTR LVOFile)

{ FILE *fp;
  struct AmiPragma *ap;
  ULONG result;

  if (!(fp = fopen((char *) LVOFile, "w")))
  { fprintf(stderr, "Error: Cannot open %s for writing.\n", LVOFile);
    return(FALSE);
  }

  if (fputs("\t\tIFND ", fp) < 0            ||
      !fputsupper(ShortBaseName, fp)        ||
      fputs("_LIB_I\n", fp) < 0             ||
      !fputsupper(ShortBaseName, fp)        ||
      fputs("_LIB_I\tSET\t1\n\n", fp) > 0)
  { goto exit_CreateLVOFile;
  }

  for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
       ap->Node.mln_Succ;
       ap = (struct AmiPragma *) ap->Node.mln_Succ)
  { if (ap->Public  &&
	fprintf(fp, "\t\tXDEF\t_LVO%s\n", ap->FuncName) < 0)
    { goto exit_CreateLVOFile;
    }
  }

  if (fputs("\n\n", fp) < 0)
  { goto exit_CreateLVOFile;
  }

  for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
       ap->Node.mln_Succ;
       ap = (struct AmiPragma *) ap->Node.mln_Succ)
  { if (ap->Public  &&
	fprintf(fp, "_LVO%s\tEQU\t-%ld\n", ap->FuncName, ap->Bias) < 0)
    { goto exit_CreateLVOFile;
    }
  }

  if (fputs("\n\t\tEND", fp) < 0)
  { goto exit_CreateLVOFile;
  }

  result = TRUE;

exit_CreateLVOFile:
  if (!result)
  { fprintf(stderr, "Error while writing %s.\n", LVOFile);
  }
  fclose(fp);
  return(result);
}





/*
    This function creates an include file with the function table of
    a library. (See LibHeader.c)

    Inputs: FuncTable - the name of the file to create

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG CreateFuncTable(const STRPTR FuncTable)

{ FILE *fp;
  struct AmiPragma *ap;
  int offset, FoundLarger;
  struct AmiPragma InternalFuncs [3];

  InternalFuncs[2].Bias = 18;
  InternalFuncs[2].Public = FALSE;
  InternalFuncs[2].FuncName = "_LibExpunge";
  InternalFuncs[2].TagName = NULL;
  InternalFuncs[2].NumArgs = 0;
  AddHead((struct List *) &AmiPragmaList, (struct Node *) &InternalFuncs[2]);
  InternalFuncs[1].Bias = 12;
  InternalFuncs[1].Public = FALSE;
  InternalFuncs[1].FuncName = "_LibClose";
  InternalFuncs[1].TagName = NULL;
  InternalFuncs[1].NumArgs = 0;
  AddHead((struct List *) &AmiPragmaList, (struct Node *) &InternalFuncs[1]);
  InternalFuncs[0].Bias = 6;
  InternalFuncs[0].Public = FALSE;
  InternalFuncs[0].FuncName = "_LibOpen";
  InternalFuncs[0].TagName = NULL;
  InternalFuncs[0].NumArgs = 0;
  AddHead((struct List *) &AmiPragmaList, (struct Node *) &InternalFuncs[0]);

  if (!(fp = fopen((char *) FuncTable, "w")))
    { 
      fprintf(stderr, "Error: Cannot open %s for writing.\n", FuncTable);
      return(FALSE);
    }

  if (fprintf(fp, "\n/*\n    MACHINE GENERATED (Do not edit)\n*/\n\n") < 0)
    { return(FALSE);
    }

  offset = 24;
  do
    {
      offset += 6;
      FoundLarger = FALSE;
      for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
	   ap->Node.mln_Succ;
	   ap = (struct AmiPragma *) ap->Node.mln_Succ)
	{
	  if (ap->Bias >= offset)
	    {
	      FoundLarger = TRUE;
	      if (ap->Bias == offset  &&
		  fprintf(fp, "extern REGARGS VOID %s(struct Library *);\n",
			  ap->FuncName) < 0)
		{
		  return(FALSE);
		}
	      break;
	    }
	}
    }
  while (FoundLarger);

  if (fprintf(fp, "\nconst STATIC APTR LibFuncTable[] =\n  {\n") < 0)
    { return(FALSE);
    }

  offset = 0;
  do
    {
      offset += 6;
      FoundLarger = FALSE;
      for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
	   ap->Node.mln_Succ;
	   ap = (struct AmiPragma *) ap->Node.mln_Succ)
	{
	  if (ap->Bias >= offset)
	    {
	      FoundLarger = TRUE;
	      if (fprintf(fp, "    %s,\n",
			  ap->Bias == offset ? ap->FuncName : 
			                       (STRPTR) "_LibNull") < 0)
		{ return(FALSE);
		}
	      break;
	    }
	}
    }
  while (FoundLarger);

  if (fprintf(fp, "    (APTR)-1\n  };\n") < 0)
    { return(FALSE);
    }

  fclose(fp);
  return(TRUE);
}






/*
    This function creates stub routines for the tag functions.

    Inputs: TagDir  - a pointer to the directory, where to store the created
		      sources.

    Result: TRUE, if successful, FALSE otherwise
*/
ULONG CreateTagFuncs(const STRPTR TagDir)

{ FILE *fp;
  struct AmiPragma *ap;

  for (ap = (struct AmiPragma *) AmiPragmaList.mlh_Head;
       ap->Node.mln_Succ;
       ap = (struct AmiPragma *) ap->Node.mln_Succ)
  { if (ap->TagName  &&  ap->Public)
    { STRPTR sourcename;
      ULONG size = strlen((char *) TagDir) +
		   strlen((char *) ap->TagName) + 128;
      ULONG i;
      ULONG result = FALSE;

      /*
	  Get name of sourcefile to create.
      */
      if (!(sourcename = strndup(TagDir, size)))
      { MemError();
	return(FALSE);
      }
      AddPart(sourcename, ap->TagName, size);
      strcat((char *) sourcename, ".c");

      /*
	  Open sourcefile.
      */
      if (!(fp = fopen((char *) sourcename, "w")))
      { fprintf(stderr, "Error: Cannot open %s for writing.\n", sourcename);
	return(FALSE);
      }

      if (fputs("typedef unsigned long ULONG;\n", fp) < 0               ||
	  fprintf(fp, "extern struct Library *%s;\n", BaseName) < 0     ||
	  fprintf(fp, "extern ULONG %s(", ap->FuncName) < 0)
      { goto exit_CreateTagFuncs;
      }
      for(i = 0;  i < ap->NumArgs;  i++)
      { if (fputs("ULONG", fp) < 0)
	{ goto exit_CreateTagFuncs;
	}
	if (i+1 < ap->NumArgs  &&  fputs(", ", fp) < 0)
	{ goto exit_CreateTagFuncs;
	}
      }
      if (fputs(");\n\n", fp) < 0                                           ||
	  fputs("#if defined(AZTEC_C)  ||  defined(__MAXON__)\n", fp) < 0   ||
	  !WriteAztecPragma(ap, fp)                                         ||
	  fputs("#endif\n\n", fp) < 0                                       ||
	  fputs("#if defined(_DCC)  ||  defined(__SASC)\n", fp) < 0         ||
	  !WriteSASPragma(ap, fp, FALSE)                                    ||
	  fputs("#endif\n\n\n", fp) < 0                                     ||
	  fprintf(fp, "ULONG %s(", ap->TagName) < 0)
      { goto exit_CreateTagFuncs;
      }
      for (i = 0;  i < ap->NumArgs;  i++)
      { if (fprintf(fp, "ULONG %s, ", ap->Args[i].ArgName) < 0)
	{ goto exit_CreateTagFuncs;
	}
      }
      if (fputs("...)\n\n", fp) < 0                         ||
	  fprintf(fp, "{ return(%s(", ap->FuncName) < 0)
      { goto exit_CreateTagFuncs;
      }
      for (i = 0;  i < ap->NumArgs-1;  i++)
      { if (fprintf(fp, "%s, ", ap->Args[i].ArgName) < 0)
	{ goto exit_CreateTagFuncs;
	}
      }
      if (fprintf(fp, "(ULONG) &%s));\n}\n", ap->Args[ap->NumArgs-1].ArgName) < 0)
      { goto exit_CreateTagFuncs;
      }

      result = TRUE;

exit_CreateTagFuncs:
      if (!result)
      { fprintf(stderr, "Error while writing %s.\n", sourcename);
      }
      fclose(fp);
      free(sourcename);
      if (!result)
      { return(FALSE);
      }
    }
  }

  return(TRUE);
}





/*
    This is main().
*/
void main (int argc, char *argv[])

{ struct RDArgs *rdargs;
  struct
  { STRPTR FDFILE;
    STRPTR AZTEC;
    STRPTR AS;
    STRPTR SAS;
    STRPTR DICE;
    STRPTR MAXON;
    STRPTR TAGDIR;
    STRPTR FUNCTABLE;
    ULONG HELP;
  } args = {NULL, NULL, NULL, NULL, NULL, NULL, FALSE};
  extern struct Library *SysBase;

  if (!argc)        /*  Prevent calling from Workbench.     */
  { exit(-1);
  }

  if (SysBase->lib_Version < 36)
  { fprintf(stderr, "Need at least Kickstart 2.0.\n");
    exit(20);
  }

  if (!(rdargs = ReadArgs((STRPTR) TEMPLATE, (LONG *) &args, NULL)))
  { Usage();
  }

  if(args.HELP)
  { Usage();
  }

  if (ScanFDFile(args.FDFILE))
  { if ((args.AZTEC  &&
	 !CreatePragmaFile(args.AZTEC, FALSE, FALSE, FALSE, TRUE))          ||
	(args.AS  &&
	 !CreateLVOFile(args.AS))                                           ||
	(args.SAS  &&
	 !CreatePragmaFile(args.SAS, TRUE, TRUE, TRUE, TRUE))               ||
	(args.MAXON  &&
	 !CreatePragmaFile(args.MAXON, TRUE, FALSE, FALSE, TRUE))           ||
	(args.DICE  &&
	 !CreatePragmaFile(args.DICE, TRUE, TRUE, TRUE, TRUE))              ||
	(args.TAGDIR  &&
	 !CreateTagFuncs(args.TAGDIR))                                      ||
	(args.FUNCTABLE  &&
	 !CreateFuncTable(args.FUNCTABLE)))
    { exit(5);
    }
  }
  exit(0);
}
