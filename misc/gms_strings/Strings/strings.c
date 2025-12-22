/*
** Module:    Strings.
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  All rights reserved.
** Version:   1.0
**
** --------------------------------------------------------------------------
** 
** TERMS AND CONDITIONS
** 
** This source code is made available on the condition that it is only used
** to further enhance the Games Master System.  IT IS NOT DISTRIBUTED FOR THE
** USE IN OTHER PRODUCTS.  Developers may edit and re-release this source
** code only in the form of its GMS module.  Use of this code outside of the
** module is not permitted under any circumstances.
** 
** This source code stays the copyright of DreamWorld Productions regardless
** of what changes or additions are made to it by 3rd parties.  However joint
** copyright is granted if the 3rd party wishes to retain some ownership of
** said modifications.
** 
** In exchange for our distribution of this source code, we also ask you to
** distribute the source when releasing a modified version of this module.
** This is not compulsory if any additions are sensitive to 3rd party
** copyrights, or if it would damage any commercial product(s).
** 
** --------------------------------------------------------------------------
**
** BUGS AND MISSING FEATURES
** -------------------------
** If you correct a bug or fill in a missing feature, the source should be
** e-mailed to pmanias@ihug.co.nz for inclusion in the next update of this
** module.
**
** CHANGES
** -------
** -1998-
** 20 Jul Started the module.
** 09 Aug Fixed StrCompare() length handling.
*/

#include <proto/dpkernel.h>
#include <pragmas/strings_pragmas.h>
#include <system/all.h>
#include <dpkernel/prefs.h>
#include "defs.h"

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "July 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1998.  All rights reserved.";
BYTE ModName[]      = "Strings";

struct Function JumpTableV1[] = {
  { LIBStrClone,      "StrClone(a0l)"         },
  { LIBStrCompare,    "StrCompare(a0l,a1l,d0l,d1w)" },
  { LIBStrLength,     "StrLength(a0l)"        },
  { LIBStrMerge,      "StrMerge(a0l,a1l,a2l)" },
  { LIBStrCopy,       "StrCopy(a0l,a1l,d0l)"  },
  { LIBStrSearch,     "StrSearch(a0l,a1l)"    },
  { LIBStrUpper,      "StrUpper(a0l)"         },
  { LIBStrLower,      "StrLower(a0l)"         },
  { LIBStrToInt,      "StrToInt(a0l)"         },
  { LIBIntToStr,      "IntToStr(d0l,a0l)"     },
  { LIBStrCapitalize, "StrCapitalize(a0l)"    },
  { NULL, NULL }
};

/************************************************************************************
** Command: Init()
** Short:   Called by the system when our module has been loaded for the first time.
*/

LIBFUNC LONG CMDInit(mreg(__a0) LONG argModule, mreg(__a1) LONG argDPKBase,
                     mreg(__a2) LONG argGVBase,  mreg(__d0) LONG argDPKVersion,
                     mreg(__d1) LONG argDPKRevision)
{
  DPKBase = (APTR)argDPKBase;
  GVBase  = (struct GVBase *)argGVBase;
  Public  = ((struct Module *)argModule)->Public;
  STRBase = ((struct Module *)argModule)->ModBase;

  if ((argDPKVersion < DPKVersion) OR
     ((argDPKVersion IS DPKVersion) AND (argDPKRevision < DPKRevision))) {
     DPrintF("!Strings:","This module requires version %d.%d of the dpkernel.library.",DPKVersion,DPKRevision);
     return(ERR_FAILED);
  }

  return(ERR_OK);
}

/************************************************************************************
** Command: Open()
** Short:   Called when our module is being opened (from an Init(Module)).
*/

LIBFUNC LONG CMDOpen(mreg(__a0) struct Module *Module)
{
  if ((Module) AND (Public)) {
     Module->FunctionList = JumpTableV1;
     Public->OpenCount++;
     return(ERR_OK);
  }
  DPrintF("!Strings:","System corrupt.");
  return(ERR_FAILED);
}

/***********************************************************************************
** Command:  Expunge()
** Synopsis: LONG Expunge(void);
** Short:    Called on expunge - if no program has us opened then we can give
**           permission to have us shut down.
*/

LIBFUNC LONG CMDExpunge(void)
{
  if (Public) {
     if (Public->OpenCount IS NULL) {
        /*FreeModule();*/
        return(ERR_OK); /* Okay to expunge */
     }
  }
  else DPrintF("!Strings:","I have no Public base reference.");

  return(ERR_FAILED); /* Do not expunge */
}

/***********************************************************************************
** Command:  Close()
** Synopsis: void Close(*Module [a0]);
** Short:    Called whenever someone is closing a link to our module.
*/

LIBFUNC void CMDClose(mreg(__a0) struct Module *Module)
{
  if (Public) {
     Public->OpenCount--;
  }
}

/**********************************************************************************/

BYTE UCase(BYTE Case)
{
  if ((Case >= 'a') AND (Case <= 'z')) Case -= 0x20;
  return(Case);
}

/***********************************************************************************
** Function: BYTE * IntToStr(LONG Integer [d0], BYTE *String [a0])
**
** DESCRIPTION
** Converts an integer to a string.  The String argument is optional, if
** you leave it as NULL then this function will allocate the string for you
** with AllocMemBlock() at defaults of MEM_DATA|MEM_PRIVATE.
**
** If the Integer is negative, this function will place a '-' sign at the front.
*/

LIBFUNC BYTE * LIBIntToStr(mreg(__d0) LONG Integer, mreg(__a0) BYTE *String)
{
  BYTE *StartStr;
  LONG count;
  WORD build;

  if (String IS NULL) {
     if ((String = AllocMemBlock(12+1,MEM_PRIVATE)) IS NULL) {
        return(NULL);
     }
  }

  StartStr = String;

  if (Integer < 0) {
     *String++ = '-';
     Integer   = -Integer;
  }

  if (Integer) {
     count = 1000000000;
     while (Integer < count) {
       count = count/10;
     }

     while (Integer > 0) {
        build = 0;
        while (Integer >= count) {
           Integer -= count;
           build++;
        }
        *String++ = (BYTE)(build + '0');
        count = count/10;
     }
  }
  else *String++ = '0';

  *String = NULL;
  return(StartStr);
}

/***********************************************************************************
** Function: void StrCapitalize(BYTE *String [a0])
** Short:    Capitalizes a string.
**
** "are u HAPpy R0B?"  = "Are U Happy R0b?"
*/

LIBFUNC void LIBStrCapitalize(mreg(__a0) BYTE *String)
{
  WORD Space = TRUE;

  while (*String) {
     if (Space) {
        if ((*String >= 'a') AND (*String <= 'z')) {
           *String -= 0x20;
        }
        else if (*String != ' ') {
           Space = FALSE;
        }
     }
     else {
        if ((*String >= 'A') AND (*String <= 'Z')) {
           *String += 0x20;
        }
        else if (*String IS ' ') {
           Space = TRUE;
        }
     }
     String++;
  }
}

/***********************************************************************************
** Function: BYTE * StrClone(BYTE *String [a0], LONG MemFlags [d0])
** Short:    Returns a memblock that is an exact duplicate of the String.
*/

LIBFUNC BYTE * LIBStrClone(mreg(__a0) BYTE *String, mreg(__d0) LONG MemFlags)
{
   LONG Length;
   BYTE *NewStr;

   if (String) {
      if (Length = StrLength(String)) {
         if (NewStr = AllocMemBlock(Length+1, MemFlags)) {
            StrCopy(String, NewStr, Length);
            return(NewStr);
         }
      }
   }

   return(NULL);
}

/***********************************************************************************
** Function: LONG StrCompare(BYTE *String1 [a0], BYTE *String2 [a1], LONG Length [d0]
**             WORD CaseSensitive [d1])
**
** DESCRIPTION
** Compares two strings against each other.  Supports case in/sensitivity and
** length specifications.
**
** INPUT
** String1, String2
**   Pointers to the two strings that you want to compare.
** 
** Length
**   The maximum amount of characters that you want to compare.  If one
**   of the strings is shorter than the specified Length, StrCompare() will only
**   compare up to the length of the shortest string.  If you leave the Length at
**   NULL, the maximum possible string length will be compared.
**
** CaseSensitive
**   Set to TRUE if you want a case sensitive comparison (this is fastest) or
**   set to FALSE for case insensitive.
**
** RESULT
** Returns TRUE if the strings match, otherwise returns FALSE.
*/

LIBFUNC LONG LIBStrCompare(mreg(__a0) LONG argString1, mreg(__a1) LONG argString2,
                           mreg(__d0) LONG Length,  mreg(__d1) WORD CaseSensitive)
{
  BYTE *String1 = (BYTE *)argString1;
  BYTE *String2 = (BYTE *)argString2;

  if ((String1) AND (String2)) {
     if (Length <= 0) Length = 0x7fffffff;
     if (CaseSensitive IS TRUE) { /* Straight compare */
        while ((Length) AND (*String1) AND (*String2)) {
           if (*String1 != *String2) return(FALSE);
           String1++; String2++;
           Length--;
        }
        if (Length > 0) {
           if ((*String1 != NULL) OR (*String2 != NULL)) {
              return(FALSE);
           }
        }
        return(TRUE);
     }
     else  { /* Upgrade each alpha-character to uppercase */
        while ((Length) AND (*String1) AND (*String2)) {
           if (UCase(*String1) != UCase(*String2)) return(FALSE);
           String1++; String2++;
           Length--;
        }
        if (Length > 0) {
           if ((*String1 != NULL) OR (*String2 != NULL)) {
              return(FALSE);
           }
        }
        return(TRUE);
     }
  }
  return(FALSE);
}

/***********************************************************************************
** Function: void StrCopy(BYTE *Source [a0], BYTE *Dest [a1], LONG Length [d0])
**
** DESCRIPTION
** This function copies part of one string over to another.
**
** If the Length is specifed as NULL then this function will copy the entire source
** string over to the destination.  Note that if this function encounters the end
** of the Source string (ie NULL) while copying, then it will stop automatically
** to prevent copying of junk characters.
*/

LIBFUNC void LIBStrCopy(mreg(__a0) LONG argString, mreg(__a1) LONG argDest,
                        mreg(__d0) LONG Length)
{
  BYTE *String = (BYTE *)argString;
  BYTE *Dest   = (BYTE *)argDest;

  if ((String) AND (Dest)) {
     if (Length IS NULL) Length = 0x7fffffff; /* Largest number */

     while ((Length > 0) AND (*String)) {
        *Dest++ = *String++;
        Length--;
     }
     *Dest = 0;
  }
}

/***********************************************************************************
** Function: LONG StrLength(BYTE *String [a0])
**
** DESCRIPTION
** Calculates the length of a string, not including the null byte.
**
** REQUIRES
** String
**   The string that you want to examine. 
**
** RESULT
** Returns the length of the string.
*/

LIBFUNC LONG LIBStrLength(mreg(__a0) BYTE *String)
{
   LONG i;
   if (String) {
      for (i=0; String[i] != NULL; i++);
      return(i);
   }
   return(NULL);
}

/***********************************************************************************
** Function: void StrLower(BYTE *String [a0])
** Short:    Changes a string so that all alphabetic characters are in lower case.
*/

LIBFUNC void LIBStrLower(mreg(__a0) BYTE *String)
{
   LONG i;

   if (String) {
      for (i=0; String[i] != NULL; i++) {
         if ((String[i] >= 'A') AND (String[i] <= 'Z')) {
            String[i] += 0x20;
         }
      }
   }
}

/***********************************************************************************
** Function: BYTE * StrMerge(BYTE *String1 [a0], BYTE *String2 [a1], BYTE *Dest [a2])
** Short:    Merges two strings into a destination.
*/

LIBFUNC BYTE * LIBStrMerge(mreg(__a0) LONG argString1, mreg(__a1) LONG argString2,
                           mreg(__a2) LONG argDest)
{
  BYTE *String1 = (BYTE *)argString1;
  BYTE *String2 = (BYTE *)argString2;
  BYTE *Dest    = (BYTE *)argDest;
  BYTE *Begin;

  if (String1 AND String2) {
     if (Dest IS NULL) {
        Dest = AllocMemBlock(StrLength(String1)+StrLength(String2)+1,MEM_DATA|MEM_PRIVATE);
     }
     Begin = Dest;
     while (*String1) *Dest++ = *String1++;
     while (*String2) *Dest++ = *String2++;
     *Dest = 0;
     return(Begin);
  }
  return(NULL);
}

/***********************************************************************************
** Function: LONG StrSearch(BYTE *Search [a0], BYTE *String [a1])
**
** DESCRIPTION
** This function allows you to search for a particular keyword/phrase inside some
** other string.
**
** REQUIRES
** Search
**   A string that specifies the keyword/phrase you are searching for.
**
** String
**   The string that you want to search.
**
** RESULT
** Returns the byte location of the string (possible values start from position 0).  If
** the Search string could not be found, this function returns -1.
*/

LIBFUNC LONG LIBStrSearch(mreg(__a0) LONG argSearch, mreg(__a1) LONG argString)
{
   BYTE *Search = (BYTE *)argSearch;
   BYTE *String = (BYTE *)argString;
   LONG i, j;

   if (String) {
      for (i=0; String[i] != 0; i++) {
         if (Search[0] IS String[i]) {         /* Matching first letter found */
            for (j=1; Search[j] != 0; j++) {   /* Now check each sequential letter */
               if (String[i+j] != Search[j]) break;
            }
            if (Search[j] IS 0) return(i);
         }
      }
   }

   return(-1);
}

/************************************************************************************
** Function: void StrUpper(BYTE *String [a0])
** Short:    Changes a string so that all alphabet characters are in upper case.
*/

LIBFUNC void LIBStrUpper(mreg(__a0) BYTE *String)
{
   LONG i;

   if (String) {
      for (i=0; String[i] != NULL; i++) {
         if ((String[i] >= 'a') AND (String[i] <= 'z')) {
            String[i] -= 0x20;
         }
      }
   }
}

/***********************************************************************************
** Function: LONG StrToInt(BYTE *String [a0])
** Short:    Converts a string to an integer.
**
** DESCRIPTION
** Converts a string to its integer equivalent.  Supports negative numbers
** (if a '-' is at the front) and skips leading spaces and non-numeric characters
** that occur before any digits.
**
** If the function encounters a non-numeric character once it has started its digit
** processing, it immediately stops and returns the result calculated up to that
** point.
**
** EXAMPLES
** "183"      =  183
** "  2902a6" =  2902
** "hx239"    =  239
** "-45"      =  -45
** " jff-9"   =  -9
*/

LIBFUNC LONG LIBStrToInt(mreg(__a0) BYTE *str)
{
  LONG number, neg;

  if (str) {

     /* Ignore any leading characters */

     while ((*str < '0') OR (*str > '9')) {
        if (*str IS NULL) return(NULL);
        str++;
     }
     if (str[-1] IS '-') neg = TRUE; else neg = FALSE;

     /* Ignore leading zeros */

     while (*str IS '0') {
        str++;
     }

     /* Check if there are any numbers following the leading zeros */

     number = 0;
     if ((*str >= '1') AND (*str <= '9')) {
        while (*str) {
           if ((*str >= '0') AND (*str <= '9')) {
              number *= 10;
              if (neg IS TRUE) {
                 number -= (*str - '0');
              }
              else number += (*str - '0');
           }
           else return(number);
           str++;
        }

        return(number);
     }
     else return(0);
  }
  else return(NULL);
}

