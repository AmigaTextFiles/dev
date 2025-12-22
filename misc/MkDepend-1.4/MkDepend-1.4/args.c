/* $Id: args.c,v 1.6 1997/11/09 23:42:46 lars Exp $ */

/*---------------------------------------------------------------------------
** Arguments parsing and variables.
**
** Copyright © 1996-1997  Lars Düning  -  All rights reserved.
** Permission granted for non-commercial use.
**---------------------------------------------------------------------------
** Parsed arguments:
**
**   {-i|INCLUDE <includepath>[::<symbol>]}
**   {-x|EXCEPT  <filepattern>}
**   {-h|HIDE    <filepattern>}
**   {-s|SUFFIX  <src_ext>{,<src_ext>}[+][:<obj_ext>] | [+]:<obj_ext>}
**   {-p|OBJPAT  <src_ext>{,<src_ext>}[+]:<obj_pattern>
**   [-f|MAKE    <makefile>]
**   [-y|STYLE   M|MP|S|SP]
**   [-d|DEP     <depfile>]
**   [-l|FLAT]
**   [-k|KEEP]
**   [-v|VERBOSE]
**   [CLEAN|PROPER]
**   {<filepattern>}
**
**---------------------------------------------------------------------------
** C: DICE 3.20
**---------------------------------------------------------------------------
** [lars] Lars Düning; <duening@ibr.cs.tu-bs.de>
**---------------------------------------------------------------------------
** 04-Feb-96 [lars] Exported from main.c
**---------------------------------------------------------------------------
** $Log: args.c,v $
** Revision 1.6  1997/11/09  23:42:46  lars
** New options CLEAN/S and PROPER/S to clean up the Makefile.
** The mode is stored in args::eMode and evaluated in main.c.
** reader_copymake(2) are extended to optionally exclude the tagline
** from the data.
**
** Revision 1.5  1997/11/09  20:22:00  lars
** New option -y=STYLE/K to select different output styles.
**
** Revision 1.4  1997/11/09  18:49:20  lars
** New option -K=KEEP/S to keep the backup of the Makefile.
**
** Revision 1.3  1997/11/09  17:21:52  lars
** New option -H=HIDE/K to hide included files from being listed in the Makefile.
** Names are stored in args::aIHide[], the corresponding nodes are marked with
** NODE_HIDE.
**
** Revision 1.2  1997/11/08  19:02:01  lars
** Added the patches and bugfixes submitted by Flavio Stanchini.
** Updated my address.
**
** Revision 1.1  1996/03/02  20:46:56  lars
** Added '+' option to command parameters OBJPAT and SUFFIX, stored in
** *bGiveSrc and bDefGSrc.
**
** Revision 1.0  1996/02/25  20:37:47  lars
** Put under RCS.
**
**---------------------------------------------------------------------------
*/

#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exec/memory.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <clib/dos_protos.h>

#if defined(__SASC)
#include <proto/exec.h>
#include <proto/dos.h>
#endif

#include "args.h"
#include "main.h"

/*-------------------------------------------------------------------------*/

/* Program arguments */

short    bVerbose  = FALSE;          /* TRUE: Verbose action */
SArray   aFiles    = { 0, 0, NULL }; /* Source files */
SArray   aAvoid    = { 0, 0, NULL }; /* Source files to avoid */
SArray   aIHide    = { 0, 0, NULL }; /* Include files to hide */
SArray   aIncl     = { 0, 0, NULL }; /* Include paths */
SArray   aSymbol   = { 0, 0, NULL }; /* Include path symbols */
SArray   aSrcExt   = { 0, 0, NULL }; /* Source file extensions */
static int allocGiveSrc, sizeGiveSrc;  /* Allocated/used size of *bGiveSrc */
short  * bGiveSrc  = NULL;           /* For each entry in aSrcExt: TRUE if the source name
                                      * shall appear in the dependency list, too. */
SArray   aObjExt   = { 0, 0, NULL }; /* Associated object file extensions */
SArray   aObjPat   = { 0, 0, NULL }; /* Associated object file patterns */
char   * sObjExt   = NULL;           /* Default object file extension */
short    bDefGSrc  = FALSE;          /* For sObjExt: TRUE if the source name shall appear
                                      * in the depency list, too */
char   * sMake     = NULL;           /* Name of the Makefile */
char   * sDepfile  = NULL;           /* Name of the dependency file */
short    bFlat     = FALSE;          /* TRUE: Depfile in flat format */
short    bKeep     = FALSE;          /* TRUE: Keep Makefile backup */
short    bEachLine = FALSE;          /* TRUE: Prefix each line in Makefile with obj file */
short    bOneDep   = FALSE;          /* TRUE: Just one dependency per Makefile line */
OpMode   eMode     = eModeNormal;    /* Operation mode */

/* Misc Variables */

char * aPgmName = NULL;  /* Name of the program executable */

/*-------------------------------------------------------------------------*/
static int
givesrc_addflag (short bFlag)

/* Add <bFlag> to *bGiveSrc.
 * Return 0 on success, non-0 on error.
 */

{
  short * pFlags;
  assert(sizeGiveSrc <= allocGiveSrc);
  if (sizeGiveSrc+1 > allocGiveSrc)
  {
    pFlags = (short*)realloc(bGiveSrc, sizeof(short)*(allocGiveSrc+4));
    if (!pFlags)
      return 1;
    bGiveSrc = pFlags;
    allocGiveSrc += 4;
  }
  bGiveSrc[sizeGiveSrc] = bFlag;
  sizeGiveSrc++;
  return 0;
}

/*-------------------------------------------------------------------------*/
int
array_addfile (SArray *pArray, char * pName)

/* Add a copy of <*pName> to the string array <pArray>.
 * Return 0 on success, non-0 on error.
 * If pName is NULL, the array is simply extended by a NULL pointer.
 */

{
  char ** pStrs;
  assert(pArray->size <= pArray->alloc);
  if (pArray->size+1 > pArray->alloc)
  {
    pStrs = (char **)realloc(pArray->strs, sizeof(char *)*(pArray->alloc+4));
    if (!pStrs)
      return 1;
    pArray->strs = pStrs;
    pArray->alloc += 4;
  }
  else
    pStrs = pArray->strs;
  if (pName)
  {
    pStrs[pArray->size] = strdup(pName);
    if (!pStrs[pArray->size])
      return 1;
  }
  else
    pStrs[pArray->size] = NULL;
  pArray->size++;
  return 0;
}

/*-------------------------------------------------------------------------*/
int
array_addlist (SArray *pArray, int count, char ** pList)

/* Add the <count> string pointers from <pList> to string array <pArray>.
 * pList may be freed after return, the strings themselves are still
 * referenced (by pArray then).
 * Return 0 on success, non-0 else.
 */

{
  char ** pStrs;
  int     i;

  assert(pList);
  if (!count)
    return 0;
  assert(pArray->size <= pArray->alloc);
  if (pArray->size+count > pArray->alloc)
  {
    pStrs = (char **)realloc(pArray->strs, sizeof(char *)*(pArray->alloc+count));
    if (!pStrs)
      return 1;
    pArray->strs = pStrs;
    pArray->alloc += count;
  }
  else
    pStrs = pArray->strs;
  for (i = 0; i < count; i++)
    pStrs[pArray->size++] = pList[i];
  return 0;
}

/*-------------------------------------------------------------------------*/
int
add_expfile (SArray *pArray, char * pName)

/* Glob filename <*pName> and add the filenames to string array <pArray>.
 * Return 0 on success, non-0 else.
 *
 * The function uses DICE' supplied function expand_args() which does not
 * implement all possible wildcard patterns.
 * If we're not on DICE, this function uses DOS' Match() functions instead.
 */

{
#if defined(_DCC)
  char  * argv[] = { NULL, pName, NULL };
  int     argc = 2;
#else
  struct AnchorPath *ap;
  LONG error;
#endif
  char ** xargv;
  int     xargc;
  int     rc;

#if defined(_DCC)
  if (expand_args(argc, argv, &xargc, &xargv))
  {
    printf("%s: Error expanding %s\n", aPgmName, pName);
    set_rc(RETURN_ERROR, 1);
  }
  assert(xargc > 1);
#else
  xargv = NULL;
  xargc = 1;

  if ((ap = AllocMem(sizeof(struct AnchorPath) + 256, MEMF_CLEAR | MEMF_PUBLIC)) != NULL)
  {
    ap->ap_BreakBits = SIGBREAKF_CTRL_C;
    ap->ap_Flags = APF_DOWILD;
    ap->ap_Strlen = 256;

    if ((error = MatchFirst(pName, ap)) == 0)
    {
      if (ap->ap_Info.fib_DirEntryType >= 0)
      {
        printf("%s: %s is a directory\n", aPgmName, pName);
        goto error;
      }

      do {
        /* Exited a directory, skip to MatchNext() */
        if (ap->ap_Flags & APF_DIDDIR)
        {
          ap->ap_Flags &= ~APF_DIDDIR;
          continue;
        }

        /* Is this a file? */
        if (ap->ap_Info.fib_DirEntryType < 0)
        {
          char **t = realloc(xargv, sizeof(char *) * (xargc + 2));
          if (t != NULL)
          {
            xargv = t;
            xargv[xargc++] = strdup(ap->ap_Buf);
          }
          else
          {
            printf("%s: realloc() failed\n", aPgmName);
            goto error;
          }
        }
      } while ((error = MatchNext(ap)) == 0);
  error:
      MatchEnd(ap);
    }

    if (error != ERROR_NO_MORE_ENTRIES)
      printf("%s: Error expanding %s\n", aPgmName, pName);

    FreeMem(ap, sizeof(struct AnchorPath));
  }
  else
  {
    PrintFault(IoErr(), aPgmName);
    set_rc(RETURN_ERROR, 1);
  }

  if (xargv != NULL)
  {
    xargv[0]     = NULL;
    xargv[xargc] = NULL;
  }
  else
    xargc = 0;
#endif

  rc = 0;
  if (xargc > 1)
  {
    rc = array_addlist(pArray, xargc-1, xargv+1);
    if (rc)
    {
      while (--xargc > 0)
        if (xargv[xargc])
          free(xargv[xargc]);
    }
    free(xargv);
  }

  return rc;
}

/*-------------------------------------------------------------------------*/
void
getargs (void)

/* Get the arguments from the commandline.
 * Unfortunately we have to emulate ReadArgs() as we have several /M values
 * in our template.
 */

{
  int  i;                 /* all purpose */

  #define BUFSIZE 1024
  char aBuffer[BUFSIZE];  /* Argument buffer */
  char aArgBuf[BUFSIZE];  /* Source buffer for separator less arguments */
  long item, arg;         /* Result from ReadItem(), FindArg() */
  struct CSource aArgSrc; /* For postponed arguments */

  enum {
    NoArg, QuesFound, OtherArg, QuesPending
  } eHelp;
  enum {
    Standard, ParseMake, ParseDep, ParseIncl, ParseExcept, ParseHide,
    ParseSuffix, ParseObjpat, ParseStyle
  } eMulti;

  /* General command template */
  char * sTemplate
    = "-F=MAKE/K,-D=DEP/K,-I=INCLUDE/K,-X=EXCEPT/K,-H=HIDE/K,-S=SUFFIX/K,"
      "-P=OBJPAT/K,-Y=STYLE/K,-L=FLAT/S,-K=KEEP/S,-V=VERBOSE/S,CLEAN/S,"
      "PROPER/S,FILES/M";
  #define TEMP_MAKE     0
  #define TEMP_DEP      1
  #define TEMP_INCLUDE  2
  #define TEMP_EXCEPT   3
  #define TEMP_HIDE     4
  #define TEMP_SUFFIX   5
  #define TEMP_PATTERN  6
  #define TEMP_STYLE    7
  #define TEMP_FLAT     8
  #define TEMP_KEEP     9
  #define TEMP_VERBOSE 10
  #define TEMP_CLEAN   11
  #define TEMP_PROPER  12
  #define TEMP_FILES   13

  /* Options which allow for no separator */
  char * sAbbrev
    = "-F/K,-D/K,-I/K,-X/K,-H/K,-S/K,-P/K,-Y/K";
  #define ABBREV_MAKE    0
  #define ABBREV_DEP     1
  #define ABBREV_INCLUDE 2
  #define ABBREV_EXCEPT  3
  #define ABBREV_HIDE    4
  #define ABBREV_SUFFIX  5
  #define ABBREV_PATTERN 6
  #define ABBREV_STYLE   7

  /* Translation table abbrev indices to template indices */
  int aA2T[] = { TEMP_MAKE, TEMP_DEP, TEMP_INCLUDE, TEMP_EXCEPT, TEMP_HIDE
               , TEMP_SUFFIX, TEMP_PATTERN, TEMP_STYLE };

  eHelp = NoArg;
  eMulti = Standard;
  aArgSrc.CS_Buffer = NULL;
  while(1)
  {
    if (eHelp == QuesPending)
    {
      aBuffer[0] = '?';
      aBuffer[1] = '\0';
      item = ITEM_UNQUOTED;
      eHelp = OtherArg;
    }
    else
    {
      aBuffer[0] = '\0';
      item = ReadItem(aBuffer, BUFSIZE, aArgSrc.CS_Buffer ? &aArgSrc : NULL);
    }

    if (ITEM_EQUAL == item)
      item = ITEM_UNQUOTED;
    if (ITEM_ERROR == item)
      exit_doserr(RETURN_ERROR);

    if (ITEM_NOTHING == item)
    {
      if (!aArgSrc.CS_Buffer && eHelp != QuesFound)
        break; /* outer while(1) */
      if (aArgSrc.CS_Buffer)
        aArgSrc.CS_Buffer = NULL;
      else
      {
        FGetC(Input()); /* re-read newline */
        Write(Output(), sTemplate, strlen(sTemplate));
        Write(Output(), ": ", 2);
        eHelp = NoArg;
        eMulti = Standard;
      }
      continue;
    }

    if (eHelp == NoArg && eMulti == Standard && !strcmp(aBuffer, "?"))
    {
      eHelp = QuesFound;
      continue;
    }

    /* At this point, we have an arg beside '?' so mark the '?'
     * for reinsertion
     */
    if (eHelp == QuesFound)
    {
      eHelp = QuesPending;
    }

    /* Check if the argument is a keyword */
    arg = -1;
    if (ITEM_UNQUOTED == item && !aArgSrc.CS_Buffer)
    {
      /* Shortcuts need no separator */
      if (aBuffer[0] == '-' && aBuffer[1] != '\0' && aBuffer[2] != '\0')
      {
        char aTmp[3];

        aTmp[0] = '-';
        aTmp[1] = aBuffer[1];
        aTmp[2] = '\0';
        arg = FindArg(sAbbrev, aTmp);
        if (arg != -1)
        {
          int len;
          arg = aA2T[arg];
          strcpy(aArgBuf, aBuffer+2);
          len = strlen(aArgBuf);
          aArgBuf[len] = '\n';   /* ReadItem() needs this as terminator */
          aArgBuf[len+1] = '\0';
          aBuffer[2] = '\0';
          aArgSrc.CS_Buffer = aArgBuf;
          aArgSrc.CS_Length = len+1;
          aArgSrc.CS_CurChr = 0;
        }
      }
      if (arg == -1)
        arg = FindArg(sTemplate, aBuffer);
    }
    /* arg == -1: aBuffer is an argument
     * arg != -1: bufindex == 0: aBuffer is keyword
     */

    /* Evaluate keyword if any */
    switch(arg)
    {
    case TEMP_MAKE:
      eMulti = ParseMake;
      break;
    case TEMP_DEP:
      eMulti = ParseDep;
      break;
    case TEMP_INCLUDE:
      eMulti = ParseIncl;
      break;
    case TEMP_EXCEPT:
      eMulti = ParseExcept;
      break;
    case TEMP_HIDE:
      eMulti = ParseHide;
      break;
    case TEMP_SUFFIX:
      eMulti = ParseSuffix;
      break;
    case TEMP_PATTERN:
      eMulti = ParseObjpat;
      break;
    case TEMP_STYLE:
      eMulti = ParseStyle;
      break;
    case TEMP_VERBOSE:
      bVerbose = 1;
      break;
    case TEMP_FLAT:
      bFlat = 1;
      break;
    case TEMP_KEEP:
      bKeep = 1;
      break;
    case TEMP_CLEAN:
      if (eMode < eModeClean)
        eMode = eModeClean;
      break;
    case TEMP_PROPER:
      eMode = eModeProper;
      break;
    default:
      assert(arg == -1);
      break;
    }

    if (arg != -1)
      continue; /* of while(1) */

    /* Assign argument value (if any) */
    switch (eMulti)
    {
    case Standard:
      if (ITEM_QUOTED == item)
        i = array_addfile(&aFiles, aBuffer);
      else
        i = add_expfile(&aFiles, aBuffer);
      if (i)
        exit_nomem(RETURN_FAIL);
      break;

    case ParseMake:
      if (sMake)
        free(sMake);
      sMake = strdup(aBuffer);
      if (!sMake)
        exit_nomem(RETURN_FAIL);
      break;

    case ParseDep:
      if (sDepfile)
        free(sDepfile);
      sDepfile = strdup(aBuffer);
      if (!sDepfile)
        exit_nomem(RETURN_FAIL);
      break;

    case ParseExcept:
      if (ITEM_QUOTED == item)
        i = array_addfile(&aAvoid, aBuffer);
      else
        i = add_expfile(&aAvoid, aBuffer);
      if (i)
        exit_nomem(RETURN_FAIL);
      break;

    case ParseHide:
      if (ITEM_QUOTED == item)
        i = array_addfile(&aIHide, aBuffer);
      else
        i = add_expfile(&aIHide, aBuffer);
      if (i)
        exit_nomem(RETURN_FAIL);
      break;

    case ParseIncl:
      {
        char * pSym, * pMark;

        /* Allow for <path>::<symbol> notation */
        pSym = NULL;
        pMark = aBuffer+strlen(aBuffer);
        if (pMark != aBuffer)
        {
          pMark--;
          while (!pSym && pMark >= aBuffer+1)
          {
            if (':' != *pMark)
            {
              pMark--;
              continue;
            }
            if (':' != *(pMark-1))
            {
              pMark -= 2;
              continue;
            }
            pSym = pMark+1;
            *(pMark-1) = '\0';
          }
        }
        if (pSym && !strlen(pSym))
          pSym = NULL;
        i = array_addfile(&aSymbol, pSym);
        if (i)
          exit_nomem(RETURN_FAIL);

        /* Make sure <path> ends in a ':' or '/' */
        pMark = aBuffer+strlen(aBuffer);
        if (pMark > aBuffer && ':' != *(pMark-1) && '/' != *(pMark-1))
        {
          *pMark = '/';
          *(pMark+1) = '\0';
        }
        i = array_addfile(&aIncl, aBuffer);
        if (i)
          exit_nomem(RETURN_FAIL);
      }
      break;

    case ParseSuffix:
    case ParseObjpat:
      {
        char * pMark, *pOsfix;
        short  bGotPlus;

        /* Allow for <src_suffix>[+]:<obj_suffix> notation */
        bGotPlus = FALSE;
        pOsfix = NULL;
        pMark = aBuffer+strlen(aBuffer);
        if (pMark != aBuffer)
        {
          pMark--;
          while (!pOsfix && pMark >= aBuffer)
          {
            if (':' != *pMark)
            {
              pMark--;
              continue;
            }
            pOsfix = pMark+1;
            if (pMark != aBuffer && *(pMark-1) == '+')
            {
              bGotPlus = TRUE;
              pMark--;
            }
            *pMark = '\0';
          }
        }
        if (pOsfix && !strlen(pOsfix))
          pOsfix = NULL;

        if (ParseObjpat == eMulti && !pOsfix)
        {
          printf("%s: Object pattern missing in argument.\n", aPgmName);
          set_rc(RETURN_WARN, 0);
          break;
        }

        /* [+]:<obj_suffix> alone defines default object suffix */
        if (pOsfix && !strlen(aBuffer))
        {
          if (sObjExt)
            free(sObjExt);
          sObjExt = strdup(pOsfix);
          if (!sObjExt)
            exit_nomem(RETURN_FAIL);
          bDefGSrc = bGotPlus;
        }
        else
        {
          char * pSfix;

          /* Allow for <sfix1>,<sfix2>,...,<sfixn> for source suffixes */
          for ( pSfix = aBuffer
              ; pMark = strchr(pSfix, ',')
              ; pSfix = pMark+1
              )
          {
            *pMark = '\0';
            if (strlen(pSfix))
            {
              if (   array_addfile(&aSrcExt, pSfix)
                  || givesrc_addflag(bGotPlus)
                  || (ParseSuffix == eMulti ? array_addfile(&aObjExt, pOsfix)
                                            : array_addfile(&aObjPat, pOsfix)
                     )
                 )
                exit_nomem(RETURN_FAIL);
            }
          }
          if (strlen(pSfix))
          {
            if (   array_addfile(&aSrcExt, pSfix)
                || givesrc_addflag(bGotPlus)
                || (ParseSuffix == eMulti ? array_addfile(&aObjExt, pOsfix)
                                          : array_addfile(&aObjPat, pOsfix)
                   )
               )
              exit_nomem(RETURN_FAIL);
          }
        }
      }
      break;

    case ParseStyle:
      if (!stricmp("m", aBuffer))
      {
        bEachLine = FALSE;
        bOneDep = FALSE;
      }
      else if (!stricmp("mp", aBuffer))
      {
        bEachLine = TRUE;
        bOneDep = FALSE;
      }
      else if (!stricmp("s", aBuffer))
      {
        bEachLine = FALSE;
        bOneDep = TRUE;
      }
      else if (!stricmp("sp", aBuffer))
      {
        bEachLine = TRUE;
        bOneDep = TRUE;
      }
      else
      {
        printf("%s: Unknown output style '%s'.\n", aPgmName, aBuffer);
        set_rc(RETURN_ERROR, 0);
        return;
      }
      break;

    default:
      assert(0);
    }

    eMulti = Standard;
  } /* while(1) */

  #undef BUFSIZE
  #undef TEMP_MAKE
  #undef TEMP_DEP
  #undef TEMP_INCLUDE
  #undef TEMP_EXCEPT
  #undef TEMP_HIDE
  #undef TEMP_SUFFIX
  #undef TEMP_PATTERN
  #undef TEMP_STYLE
  #undef TEMP_FLAT
  #undef TEMP_KEEP
  #undef TEMP_VERBOSE
  #undef TEMP_FILES
  #undef ABBREV_MAKE
  #undef ABBREV_DEP
  #undef ABBREV_INCLUDE
  #undef ABBREV_EXCEPT
  #undef ABBREV_HIDE
  #undef ABBREV_SUFFIX
  #undef ABBREV_PATTERN
  #undef ABBREV_STYLE
}

/***************************************************************************/
