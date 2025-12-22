/* $Id: main.c,v 1.12 1997/11/09 23:52:45 lars Exp $ */

/*---------------------------------------------------------------------------
** Main module of MkDepend.
**
** Copyright © 1995-1997  Lars Düning  -  All rights reserved.
** Permission granted for non-commercial use.
**---------------------------------------------------------------------------
** The module implements the argument parsing and the control flow.
**
** Usage:
**   mkdepend {-i|INCLUDE <includepath>[::<symbol>]}
**            {-x|EXCEPT  <filepattern>}
**            {-h|HIDE    <filepattern>}
**            {-s|SUFFIX  <src_ext>{,<src_ext>}[+][:<obj_ext>] | [+]:<obj_ext>}
**            {-p|OBJPAT  <src_ext>{,<src_ext>}[+]:<obj_pattern>}
**            [-f|MAKE    <makefile>]
**            [-y|STYLE   M|MP|S|SP]
**            [-d|DEP     <depfile>]
**            [-l|FLAT]
**            [-k|KEEP]
**            [-v|VERBOSE]
**            {<filepattern>}
**
** The <objpattern> recognizes as meta-symbols:
**   %s: the full sourcename (w/o suffix)
**   %[-][<][<number>]p: the path part of the sourcename
**     <number>: skip first <number> directories of the path, defaults to 0.
**     <       : directories are counted from the end.
**     -       : use, don't skip the counted directories.
**   %n: the base of the sourcename (w/o suffix)
**   %%: the character %
**   %x: the character 'x' for every other character.
**
**---------------------------------------------------------------------------
** C: DICE 3.20
**---------------------------------------------------------------------------
** [lars] Lars Düning; <duening@ibr.cs.tu-bs.de>
**---------------------------------------------------------------------------
** 11-Sep-95 [lars]
** 12-Oct-95 [lars] %p expanded to %[-][<][<number>]p
** 04-Feb-96 [lars]
**   Added separate DEP output, both FLAT and tree formatted.
**   Exported argument parsing to args.c
** 25-Feb-96 [lars]
**   Added output of list of users(includers) of files.
**   If a file can't be found, it's users so far are listed in the error
**   message.
**---------------------------------------------------------------------------
** $Log: main.c,v $
** Revision 1.12  1997/11/09  23:52:45  lars
** RELEASE 1.4
**
** Revision 1.11  1997/11/09  23:42:46  lars
** New options CLEAN/S and PROPER/S to clean up the Makefile.
** The mode is stored in args::eMode and evaluated in main.c.
** reader_copymake(2) are extended to optionally exclude the tagline
** from the data.
**
** Revision 1.10  1997/11/09  20:22:00  lars
** New option -y=STYLE/K to select different output styles.
**
** Revision 1.9  1997/11/09  18:49:20  lars
** New option -K=KEEP/S to keep the backup of the Makefile.
**
** Revision 1.8  1997/11/09  18:37:13  lars
** Debugged the handling of write-protected Makefiles and backups.
**
** Revision 1.7  1997/11/09  17:21:52  lars
** New option -H=HIDE/K to hide included files from being listed in the Makefile.
** Names are stored in args::aIHide[], the corresponding nodes are marked with
** NODE_HIDE.
**
** Revision 1.6  1997/11/08  19:11:04  lars
** MkDepend now also looks for 'GNUMakefile' if no explicite filename
** is given.
**
** Revision 1.5  1997/11/08  19:02:01  lars
** Added the patches and bugfixes submitted by Flavio Stanchini.
** Updated my address.
**
** Revision 1.4  1996/03/02  20:46:56  lars
** *** empty log message ***
**
** Revision 1.3  1996/02/25  20:39:41  lars
** Put under RCS.
**
**---------------------------------------------------------------------------
*/

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include <dos/dos.h>
#include <exec/types.h>
#include <exec/libraries.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#if defined(__SASC)
#include <proto/exec.h>
#include <proto/dos.h>
#endif

#include "args.h"
#include "main.h"
#include "reader.h"
#include "nodes.h"

#if defined (_DCC)
extern struct Library *SysBase;
#endif

/*-------------------------------------------------------------------------*/

/* Predicates operating on args::eMode */

#define MODE_NORMAL  (eMode == eModeNormal)
#define MODE_CLEAN   (eMode == eModeClean || eMode == eModeProper)
#define MODE_PROPER  (eMode == eModeProper)

/*-------------------------------------------------------------------------*/

/* Release version number, should match the version number in the Makefiles */

#define VERSION "1.4"

/* Stack structure for the tree output routines */
typedef struct stacknode
 {
   struct stacknode * pNext;  /* Next stacknode */
   struct stacknode * pPrev;  /* Previous stacknode */
   NodeRef * pRef;            /* Next node to work on */
 }
StackNode;
/* Misc Variables */

char * aVersion = "$VER: MkDepend " VERSION " (" __DATE__ ")";

static struct stat aMakeStat;    /* Stat buffer for the Makefile */
static int         bMakeExists;  /* TRUE: Old Makefile exists */

static int         returncode = RETURN_OK;   /* Global return code */

static StackNode * pStack = NULL;  /* Stackbase for tree output routines */

/*-----------------------------------------------------------------------*/
void
set_rc (int code, int bAbort)

/* Set the global returncode to <code> given that <code> is higher
 * than the current one.
 * If <bAbort>, exit immediately then.
 */

{
  if (code > returncode)
    returncode = code;
  if (bAbort)
    exit(returncode);
}

/*-------------------------------------------------------------------------*/
void
exit_doserr (int code)

/* Print a message according to IoErr(), then exit with <code>.
 */

{
  PrintFault(IoErr(), aPgmName);
  set_rc(code, 1);
}

/*-------------------------------------------------------------------------*/
void
exit_nomem (int code)

/* Print a "Out of Memory" message and exit with <code>.
 */

{
  printf("%s: Out of memory.\n", aPgmName);
  set_rc(code, 1);
}

/*-----------------------------------------------------------------------*/
#if defined(_DCC)
static int
chmod (char *file, long mode)

/* Set the access mode of a file.
 * For Amiga-OS, only the owner access can be set.
 */

{
  BPTR lock;
  struct FileInfoBlock *info;
  int rc;

  /* Unix mode 'rwx??????' => DOS mode 'rwxw' aka 'rwxd'.
  ** Well, this should be done using the FIB* constants from dos.h
  ** but they will hardly change and 'knowing' them keeps this a one-liner.
  ** Note that the Amiga-OS bits disallow the operation when set.
  */
  mode = ~((mode & 0700) >> 5 | (mode & 0200) >> 7) & 017;
  info = (struct FileInfoBlock *) malloc(sizeof (struct FileInfoBlock));
  if (info == NULL) return -1;
  rc = -1;
  if ((lock = Lock(file, SHARED_LOCK)) == NULL) goto chmod_exit;
  if (Examine(lock, info) == DOSFALSE) goto chmod_exit;
  UnLock(lock);
  if (SetProtection(file, (info->fib_Protection & (~017)) | mode) != DOSFALSE)
    rc = 0;
chmod_exit:
  free (info);
  return rc;
}
#endif

/*-----------------------------------------------------------------------*/
static void
CheckStacksize (LONG try_size)

/* Check the stacksize of this process against try_size.
 * If the actual stacksize is smaller, print a message and exit.
 */

{
  struct Task *pThis;

  pThis = (struct Task *)FindTask(NULL);

  /* Sanity checks, shouldn't happen anyway */
  assert(pThis && pThis->tc_Node.ln_Type == NT_PROCESS);

  if ((LONG)((char *)pThis->tc_SPUpper - (char *)pThis->tc_SPLower) < try_size)
  {
    printf("%s: Needs at least %ld KByte stack.\n", aPgmName, (try_size+512) >> 10);
    exit(RETURN_ERROR);
  }
}

/*-------------------------------------------------------------------------*/
static void
check_os2 (void)

/* Check if OS2 is available. If not, print a message and exit.
 */

{
  char *sNeedsOS2 = "Fatal: Needs OS 2.0 or better.\n";

  if (((struct Library *)SysBase)->lib_Version < 36)
  {
    Write(Output(), sNeedsOS2, strlen(sNeedsOS2));
    set_rc(RETURN_FAIL, 1);
  }
}

/*-------------------------------------------------------------------------*/
static int
readfiles (void)

/* Read and analyse all files.
 * If a file can't be read, print a message.
 * Return 0 if all went well, RETURN_WARN if one of the files could not be
 * found, RETURN_ERROR if one of the files could not be read properly.
 */

{
  int           rc;       /* Return value */
  struct stat   aStat;    /* buffer for stat() */
  Node        * pNode;    /* Node of the file under examination */
  int           srcRead;  /* Number of source files read */
  int           index;    /* index in the aIncl array */
  char          aName[FILENAME_MAX+1];
  int           i;
  const char  * pName;    /* Includefile name returned by reader */

  rc = 0;
  srcRead = 0;
  aName[FILENAME_MAX] = '\0';

  while (pNode = nodes_todo())
  {
    /* Search the correct directory to read from */
    index = -1;
    pNode->iInclude = 0;
    strcpy(aName, pNode->pName);
    i = stat(aName, &aStat);
    if (i && !(pNode->flags & NODE_SOURCE))
    {
      for (index = 0; i && index < aIncl.size; index++)
      {
        strcpy(aName, aIncl.strs[index]);
        strcat(aName, pNode->pName);
        assert(aName[FILENAME_MAX] == '\0');
        i = stat(aName, &aStat);
      }
      if (!i)
        pNode->iInclude = index;
    }
    if (i || !reader_open(aName))
    {
      int slen; /* Linelen so far */
      int len;
      int bFlag;  /* TRUE if at least one name has been printed in this line */
      NodeRef * pRef;
      Node    * pRNode;

      if (!i)
        perror("mkdepend");
      if (rc < RETURN_ERROR)
        rc = RETURN_WARN;
      printf("%s: Warning: Can't read '%s'.\n", aPgmName, aName);
      if (pNode->flags & NODE_SOURCE)
        pNode->flags |= NODE_AVOID; /* don't list it in the Makefile */
      pRef = pNode->pUsers;
      if (pRef)
      {
        printf("%s:   Included at least by:", aPgmName);
        slen = strlen(aPgmName)+25;
        bFlag = FALSE;

        for ( ; pRef ; pRef = pRef->pNext)
        {
          pRNode = pRef->pNode;
          len = strlen(pRNode->pName);
          if (slen + len + 2 > 75)
          {
            if (bFlag)
              putchar(',');
            putchar('\n');
            slen = 0;
            bFlag = FALSE;
          }
          if (!slen)
          {
            printf("%s:    ", aPgmName);
            slen = strlen(aPgmName)+5;
          }
          if (bFlag)
          {
            putchar(',');
            slen++;
          }
          printf(" %s", pRNode->pName);
          slen += len+1;
          bFlag = TRUE;
        }
        if (slen)
          putchar('\n');
      }
      continue;
    }
    if (bVerbose)
    {
      printf(" reading %-65s\r", aName); fflush(stdout);
    }
    while (pName = reader_get())
    {
      if (nodes_depend(pNode, pName))
      {
        if (bVerbose)
          printf("%+-78s\r", "");
        reader_close();
        exit_nomem(RETURN_FAIL);
      }
    }
    if (bVerbose)
      printf("%+-78s\r", "");
    if (!reader_eof() || reader_close())
    {
      perror("mkdepend");
      printf("%s: Error reading '%s'\n", aPgmName, aName);
      rc = RETURN_ERROR;
    }
    else if (pNode->flags & NODE_SOURCE)
    {
      srcRead++;
    }
  } /* while (nodes_todo()) */
  if (!srcRead)
  {
    printf("%s: No source file read.\n", aPgmName);
    rc = RETURN_ERROR;
  }
  if (bVerbose)
    fflush(stdout);
  return rc;
}

/*-------------------------------------------------------------------------*/
static void
make_objname ( char *pBuf, const char *pName, int slen
             , const char * pObjExt, const char *pObjPat
             )

/* Construct the name of the dependency target.
 *
 *   pBuf   : Buffer to construct the name in.
 *   pName  : Name of the sourcefile.
 *   slen   : Length of the sourcefile suffix.
 *   pObjExt: Object extensions for this sourcefile, may be NULL.
 *   pObjPat: Object pattern for this sourcefile, may be NULL.
 *
 * If pObjPat is not NULL, the pattern is used to construct the name.
 * If pObjPat is NULL, the pObjExt string is appended to the sourcefile
 * name (minus its source suffix) to construct the name. If pObjExt is
 * NULL, the default object extension is used.
 */

{
  int nlen, plen;
  const char * pBasename, * pSrc, * pMark;
  char *pDst, ch;
  short flags;
  long  number;

#define GOT_MINUS   (1<<0)
#define GOT_ANGLE   (1<<1)
#define GOT_NUMBER  (1<<2)
#define NOT_DONE    (1<<3)
#define NO_PATTERN  (1<<4)

  nlen = strlen(pName)-slen;
  if (!pObjPat)
  {
    strcpy(pBuf, pName);
    if (pObjExt)
      strcpy(pBuf+nlen, pObjExt);
    else
      strcpy(pBuf+nlen, sObjExt);
    return;
  }
  pBasename = FilePart((STRPTR)pName);
  plen = pBasename-pName;
  pSrc = pObjPat;
  pDst = pBuf;
  while ('\0' != (ch = *pSrc++))
  {
    if (ch != '%')
    {
      *pDst++ = ch;
      continue;
    }

    pMark = pSrc;
    flags = 0;
    do
    {
      ch = *pSrc++;
      switch(ch)
      {
      case '-':
        if (flags & (GOT_MINUS|GOT_ANGLE|GOT_NUMBER))
          flags = NO_PATTERN;
        else
          flags |= GOT_MINUS|NOT_DONE;
        break;

      case '<':
        if (flags & (GOT_ANGLE|GOT_NUMBER))
          flags = NO_PATTERN;
        else
          flags |= GOT_ANGLE|NOT_DONE;
        break;

      case '0': case '1': case '2': case '3': case '4':
      case '5': case '6': case '7': case '8': case '9':
        if (flags & GOT_NUMBER)
          flags = NO_PATTERN;
        else
        {
          char * pTail;

          number = strtol(pSrc-1, &pTail, 10);
          pSrc = pTail;
          flags |= GOT_NUMBER|NOT_DONE;
        }
        break;

      case 's':
        strncpy(pDst, pName, nlen);
        pDst += nlen;
        flags = 0;
        break;

      case 'p':
        if (pName != pBasename
        && (!(flags & GOT_MINUS) || (flags & GOT_NUMBER))
        )
        {
          const char * cp;
          size_t cplen;

          cp = pName;
          cplen = plen;
          if (flags & GOT_NUMBER)
          {
            if (flags & GOT_ANGLE)
            {
              cp = pName+plen;
              number++;
              while (number)
              {
                --cp;
                if (*cp == '/' || *cp == ':')
                {
                  number--;
                  if (!number)
                    cp++;
                }
                if (cp == pName)
                  break;
              }
            }
            else
            {
              cp = pName;
              while (number && cp != pBasename)
              {
                if (*cp == '/' || *cp == ':')
                {
                  number--;
                }
                cp++;
              }
            }
            /* cp now points to the character after the
             * determined path part.
             */

            if (flags & GOT_MINUS)
            {
              cplen = cp - pName;
              cp = pName;
            }
            else
              cplen = plen - (cp-pName);
          }
          if (cplen)
          {
            strncpy(pDst, cp, cplen);
            pDst += cplen;
          }
        }
        flags = 0;
        break;

      case 'n':
        strncpy(pDst, pBasename, nlen-plen);
        pDst += nlen-plen;
        flags = 0;
        break;

      case '%':
        *pDst++ = '%';
        flags = 0;
        break;

      default:
        flags = NO_PATTERN;
        break;
      }
    }
    while (flags & NOT_DONE);
    if (flags & NO_PATTERN)
      pSrc = pMark; /* to be read again as normal text */
  }
  *pDst = '\0';

#undef GOT_MINUS
#undef GOT_ANGLE
#undef GOT_NUMBER
#undef NOT_DONE
#undef NO_PATTERN
}

/*-------------------------------------------------------------------------*/
static int
output_node_tree (Node * pNode, int bUsers)

/* Output the collected dependencies (bUsers is FALSE) resp. the collected
 * users (bUsers is TRUE) in tree form into the Depfile.
 *
 * Return 0 on success, RETURN_WARN on a mild error, RETURN_ERROR on a
 * severe error.
 */

{
  StackNode * pTop;  /* Stackbase, next free Stacktop */
  int         rc;
  Node    * pRNode;  /* referenced node */
  NodeRef * pRef;    /* Next node to work on */
  int       level;   /* Depth in dependency tree */
  char      aObjname[FILENAME_MAX+1];
  int       i, len;

  assert(pNode);

  rc = RETURN_OK;
  do
  {
    pTop = pStack;

    aObjname[FILENAME_MAX] = '\0';

    /* Print name of the basenode */
    if (!bUsers)
    {
      if (reader_write(pNode->pName))
      {
        rc = RETURN_ERROR;
        break; /* outer while */
      }
      if (reader_write(" :\n"))
      {
        rc = RETURN_ERROR;
        break; /* outer while */
      }
    }

    /* Initialize the tree output */
    pTop->pRef = bUsers ? pNode->pUsers : pNode->pDeps;
    level = 1;
    pRef = pTop->pRef;

    /* Tree output loop
     */
    while (1)
    {
      /* On end of this level: pop stack */
      if (!pRef)
      {
        if (pTop == pStack)
          break;
        pRef = pTop->pRef;
        level--;
        pTop = pTop->pPrev;
        continue;
      }

      /* Output filename of referenced node */
      pRNode = pRef->pNode;
      aObjname[0] = ' ';
      aObjname[1] = '\0';
      if (!(pRNode->flags & NODE_SOURCE) && pRNode->iInclude)
      {
        if (aSymbol.strs[pRNode->iInclude-1])
          strcat(aObjname, aSymbol.strs[pRNode->iInclude-1]);
        else
          strcat(aObjname, aIncl.strs[pRNode->iInclude-1]);
        strcat(aObjname, pRNode->pName);
      }
      else
      {
        strcat(aObjname, pRNode->pName);
      }
      assert(aObjname[FILENAME_MAX] == '\0');
      len = strlen(aObjname);
      for (i = 0; i < level-1; i++)
        if (reader_writen("    ", 4))
        {
          rc = RETURN_ERROR;
          break; /* for */
        }
      if (!rc && i < level && reader_writen(bUsers ? " ->" : " <-", 3))
        rc = RETURN_ERROR;
      if (!rc && reader_writen(aObjname, len))
        rc = RETURN_ERROR;
      if (!rc && reader_writen("\n", 1))
        rc = RETURN_ERROR;
      if (rc)
        break; /* tree-while() */

      /* Push this level onto the stack */
      if (!pTop->pNext)
      {
        StackNode * pNew;
        pNew = malloc(sizeof(*pNew));
        if (!pNew)
        {
          if (bVerbose)
            printf("%+-78s\r", "");
          printf("%s: Out of memory.\n", aPgmName);
          rc = RETURN_ERROR;
          break; /* tree-while */
        }
        memset(pNew, 0, sizeof(*pNew));
        pTop->pNext = pNew;
        pNew->pPrev = pTop;
        pTop = pNew;
      }
      else
      {
        pTop = pTop->pNext;
      }
      pTop->pRef = pRef->pNext;

      /* Continue with next deeper level */
      level++;
      pRef = bUsers ? pRNode->pUsers : pRNode->pDeps;
    } /* end while(1) - tree output loop */

  } while(0);

  return rc;
}

/*-------------------------------------------------------------------------*/
static int
output_tree (void)

/* Output the collected dependencies in tree form into the Depfile.
 * Return 0 on success, RETURN_WARN on a mild error, RETURN_ERROR on a
 * severe error.
 */

{
  int         rc;
  char      * pFile;    /* Name of file to create */
  Node      * pNode;

  pFile = sDepfile;
  assert(pFile);

  rc = RETURN_OK;
  do
  {
    if (!pStack)
    {
      /* Initialise stack */
      pStack = malloc(sizeof(*pStack));
      if (!pStack)
      {
        printf("%s: Out of memory\n", aPgmName);
        rc = RETURN_ERROR;
        break;
      }
      memset(pStack, 0, sizeof(*pStack));
    }

    /* Open files */
    if (reader_openrw(NULL, pFile))
    {
      perror("mkdepend");
      printf("%s: Can't write '%s'\n", aPgmName, pFile);
      rc = RETURN_ERROR;
      break;
    }

    if (bVerbose)
    {
      printf(" creating '%s'\r", pFile);
      fflush(stdout);
    }

    /* Walk and output the dependencies and users */
    nodes_initwalk();
    while (rc != RETURN_ERROR && (pNode = nodes_inorder()))
    {
      if ((pNode->flags & (NODE_SOURCE|NODE_AVOID)) == NODE_SOURCE)
      {
        rc = output_node_tree(pNode, FALSE);
        if (!rc)
          rc = output_node_tree(pNode, TRUE);
        if (!rc && reader_writen("\n", 1))
          rc = RETURN_ERROR;
      }
    }

    nodes_initwalk();
    while (rc != RETURN_ERROR && (pNode = nodes_inorder()))
    {
      if ((pNode->flags & (NODE_SOURCE|NODE_AVOID)) != NODE_SOURCE)
      {
        rc = output_node_tree(pNode, FALSE);
        if (!rc)
          rc = output_node_tree(pNode, TRUE);
        if (!rc && reader_writen("\n", 1))
          rc = RETURN_ERROR;
      }
    }

    if (rc == RETURN_ERROR)
    {
      int i = errno;
      if (bVerbose)
        printf("%+-78s\r", "");
      errno = i;
      perror("mkdepend");
      printf("%s: Error writing '%s'.\n", aPgmName, pFile);
      rc = RETURN_ERROR;
      break;
    }

    if (reader_writeflush())
    {
      int i = errno;
      if (bVerbose)
        printf("%+-78s\r", "");
      errno = i;
      perror("mkdepend");
      printf("%s: Error writing '%s'.\n", aPgmName, sDepfile);
      rc = RETURN_ERROR;
      break;
    }
    /* Finish up */
    if (bVerbose)
      printf("%+-78s\r", "");

    if (reader_close())
    {
      perror("mkdepend");
      printf("%s: Error writing '%s'.\n", aPgmName, pFile);
      rc = RETURN_ERROR;
      break;
    }

  } while(0);

  while (pStack)
  {
    StackNode * pTop;

    pTop = pStack;
    pStack = pStack->pNext;
    free(pTop);
  }

  /* Error cleanup */
  if (rc == RETURN_ERROR)
  {
    reader_close();
    remove(pFile);
  }

  if (bVerbose && rc != RETURN_ERROR)
    printf("%+-78s\r", "");

  return rc;
}

/*-------------------------------------------------------------------------*/
static int
output_list_flat ( NodeRef * pRef, int startlen
                 , const char * pIndent, int bAsMake)

/* Output the given list of dependencies/users, starting with pRef,
 * with bAsMake interpreted as below. startlen is the line length
 * printed at time of call, pIndent is the indentation string to use.
 *
 * Return 0 on success, RETURN_WARN on a mild error, RETURN_ERROR on a
 * severe error.
 */

{
  int       rc;
  Node    * pRNode;
  int       slen;           /* Linelen so far */
  int       len;
  int       ilen;           /* Length of pIndent */
  int       linelen;        /* Nominal linelength */
  char      aObjname[FILENAME_MAX+1];
  short     bForceFirst;    /* TRUE to force the first output after call */

  assert(pIndent);

  rc = RETURN_OK;
  aObjname[FILENAME_MAX] = '\0';

  slen = startlen;
  ilen = strlen(pIndent);
  linelen = (bAsMake && bOneDep) ? 1 : 75;

  for ( bForceFirst = bOneDep
      ; rc != RETURN_ERROR && pRef
      ; pRef = pRef->pNext, bForceFirst = FALSE
      )
  {
    pRNode = pRef->pNode;

    /* Don't list hidden dependees in Makefiles */
    if (bAsMake && (pRNode->flags & NODE_HIDE))
      continue;

    /* Construct the name of the dependee */
    aObjname[0] = ' ';
    aObjname[1] = '\0';
    if (pRNode->iInclude)
    {
      if (aSymbol.strs[pRNode->iInclude-1])
        strcat(aObjname, aSymbol.strs[pRNode->iInclude-1]);
      else
        strcat(aObjname, aIncl.strs[pRNode->iInclude-1]);
      strcat(aObjname, pRNode->pName);
    }
    else
    {
      strcat(aObjname, pRNode->pName);
    }
    assert(aObjname[FILENAME_MAX] == '\0');
    len = strlen(aObjname);

    /* Fit it into the line */
    if (slen > 0 && !bForceFirst)
    {
      if (slen+len > linelen)
      {
        if (reader_writen((bAsMake && !bEachLine) ? " \\\n" : "\n"
                         , (bAsMake && !bEachLine) ? 3 : 1)
           )
        {
          rc = RETURN_ERROR;
          break; /* inner for */
        }
        slen = 0;
      }
    }
    if (!slen)
    {
      if (reader_writen(pIndent, ilen))
      {
        rc = RETURN_ERROR;
        break; /* inner for */
      }
      slen = ilen;
    }
    if (reader_writen(aObjname, len))
    {
      rc = RETURN_ERROR;
      break; /* inner for */
    }
    slen += len;
  } /* for () */
  if (slen && reader_writen("\n", 1))
    rc = RETURN_ERROR;

  return rc;
}

/*-------------------------------------------------------------------------*/
static int
output_node_flat (Node * pNode, int bAsMake)

/* For a given node pNode Output the collected dependencies/users into a
 * file, either as Makefile (bAsMake is TRUE) or as Depfile (bAsMake is
 * FALSE).
 * The file must have been opened by the caller in the reader module.
 *
 * Return 0 on success, RETURN_WARN on a mild error, RETURN_ERROR on a
 * severe error.
 */

{
  int       rc;
  NodeRef * pList, * pRef;
  int       suffix;         /* Suffix index */
  int       slen;           /* Linelen so far */
  int       len;
  char      aObjname[FILENAME_MAX+3];
    /* '+3' to allow for the trailing 0 and additionally
     * for " :" appended temporarily.
     */

  assert(pNode);

  rc = RETURN_OK;
  aObjname[FILENAME_MAX] = '\0';

  /* First, output the dependencies list always */
  pList = nodes_deplist(pNode, FALSE);
  assert(pList);
  pRef = pList;

  /* Check for a given suffix.
   * Search backwards in case later definitions overwrote
   * earlier ones.
   */
  slen = strlen(pNode->pName);
  if (!bAsMake)
    suffix = -1;
  else
  for (suffix = aSrcExt.size-1; suffix >= 0; suffix--)
  {
    len = strlen(aSrcExt.strs[suffix]);
    if (!strcmp(pNode->pName+slen-len, aSrcExt.strs[suffix]))
      break;
  }

  do {
    /* Construct the name of the dependency target and write it */
    if (suffix >= 0)
    {
      char * pObjPat, * pObjExt;

      pObjExt = aObjExt.size ? aObjExt.strs[suffix] : NULL;
      pObjPat = aObjPat.size ? aObjPat.strs[suffix] : NULL;

      make_objname( aObjname, pNode->pName, len, pObjExt, pObjPat);
      assert(aObjname[FILENAME_MAX] == '\0');
      if (reader_write(aObjname))
      {
        rc = RETURN_ERROR;
        break; /* while */
      }
      slen = strlen(aObjname);

      if (!((pObjExt || pObjPat) ? bGiveSrc[suffix] : bDefGSrc))
        pRef = pRef->pNext;
    }
    else
    {
      if (reader_write(pNode->pName))
      {
        rc = RETURN_ERROR;
        break; /* outer while */
      }
      pRef = pRef->pNext;
    }

    if (bAsMake)
    {
      char * pCurrentEnd;

      if (reader_write(" :"))
      {
        rc = RETURN_ERROR;
        break; /* while */
      }
      slen += 2;
      if (bEachLine)
      {
        pCurrentEnd = aObjname + strlen(aObjname);
        strcat(aObjname, " :");
      }
      rc = output_list_flat(pRef, slen, bEachLine ? aObjname : "   ", TRUE);
      if (bEachLine)
        *pCurrentEnd = '\0';
    }
    else
    {
      if (reader_write(" :\n"))
      {
        rc = RETURN_ERROR;
        break; /* while */
      }
      if (pRef)
        rc = output_list_flat(pRef, 0, "   <-", FALSE);
    }
    nodes_freelist(pList);
    slen = 0;

    /* If demanded, output the list of users as well */
    if (RETURN_OK == rc && !bAsMake)
    {
      pList = nodes_deplist(pNode, TRUE);
      assert(pList);
      if (pList->pNext)
        rc = output_list_flat(pList->pNext, 0, "   ->", FALSE);
      nodes_freelist(pList);
    }

  } while(0);

  if (reader_writen("\n", 1))
    rc = RETURN_ERROR;

  return rc;
}

/*-------------------------------------------------------------------------*/
static int
output (int bAsMake)

/* Output the collected dependencies into the Makefile (bAsMake is TRUE)
 * resp. into the Depfile (bAsMake is FALSE).
 * Alternatively, depending on args::eMode, the Makefile is cleaned up.
 * Return 0 on success, RETURN_WARN on a mild error, RETURN_ERROR on a
 * severe error.
 *
 * Putting the cleaning code in here makes the function has the advantage
 * that the file futzing segments (and the magic Makefile lines!) are
 * collected in just on place. And it's not that a big deal, either.
 */

{
  int           rc, i;
  struct stat   aStat;    /* buffer for stat() */
  char        * pBackup;  /* Name of the Makefilebackup */
  char        * pFile;    /* Name of file to create */
  Node        * pNode;

  pBackup = NULL;
  pFile = bAsMake ? sMake : sDepfile;

  assert(pFile);

  /* Rename old Makefile if necessary */
  if (bAsMake && bMakeExists)
  {
    pBackup = (char *)malloc(strlen(sMake)+4+1);
    strcpy(pBackup, sMake);
    strcat(pBackup, ".bak");
    if (remove(pBackup))
    {
      /* The backup file might not exist, or it is write/delete-protected.
       * In the latter case unprotect it and try again.
       */
      i = stat(pBackup, &aStat);
      if (!i)
      {
        chmod(pBackup, S_IWRITE|aStat.st_mode);
        if (remove(pBackup))
        {
          perror("mkdepend");
          printf("%s: Can't delete old '%s'.\n", aPgmName, pBackup);
          chmod(pBackup, aStat.st_mode);
        }
      }
    }
    if (rename(sMake, pBackup))
    {
      perror("mkdepend");
      printf("%s: Can't rename '%s' to '%s'.\n", aPgmName, sMake, pBackup);
      free(pBackup);
      return RETURN_ERROR;
    }
  }

  rc = RETURN_OK;
  do
  {
    /* Open files */
    if (reader_openrw(pBackup, pFile))
    {
      perror("mkdepend");
      printf("%s: Can't write '%s'\n", aPgmName, pFile);
      rc = RETURN_ERROR;
      break;
    }

    if (bVerbose)
    {
      printf(" %s '%s'\r", (bMakeExists && bAsMake) ? "updating" : "creating", pFile);
      fflush(stdout);
    }

    /* Copy the Makefile up to the tagline */
    if (bAsMake
    &&  reader_copymake("# --- DO NOT MODIFY THIS LINE -- AUTO-DEPENDS FOLLOW ---\n"
                       , MODE_PROPER)
       )
    {
      int i = errno;
      if (bVerbose)
        printf("%+-78s\r", "");
      errno = i;
      perror("mkdepend");
      printf("%s: Error copying '%s' to '%s'.\n", aPgmName, pBackup, sMake);
      rc = RETURN_ERROR;
      break;
    }

    if (bAsMake && MODE_NORMAL)
    {
      /* Walk and output the dependencies and users.
       * First all the files specified as root.
       */
      nodes_initwalk();
      while (rc != RETURN_ERROR && (pNode = nodes_inorder()))
      {
        if ((pNode->flags & (NODE_SOURCE|NODE_AVOID)) == NODE_SOURCE)
          rc = output_node_flat(pNode, bAsMake);
      }  /* while (treewalk */

      /* Second (if wanted), all the files not specified as root. */
      if (RETURN_OK == rc && !bAsMake)
      {
        nodes_initwalk();
        while (rc != RETURN_ERROR && (pNode = nodes_inorder()))
        {
          if (!(pNode->flags & NODE_SOURCE))
            rc = output_node_flat(pNode, bAsMake);
        }  /* while (treewalk */
      }

      if (rc == RETURN_ERROR)
      {
        int i = errno;
        if (bVerbose)
          printf("%+-78s\r", "");
        errno = i;
        perror("mkdepend");
        printf("%s: Error writing '%s'.\n", aPgmName, pFile);
        rc = RETURN_ERROR;
        break;
      }
    }

    if (bAsMake
    &&  reader_copymake2("# --- DO NOT MODIFY THIS LINE -- AUTO-DEPENDS PRECEDE ---\n"
                        , MODE_PROPER)
       )
    {
      int i = errno;
      if (bVerbose)
        printf("%+-78s\r", "");
      errno = i;
      perror("mkdepend");
      printf("%s: Error copying '%s' to '%s'.\n", aPgmName, pBackup, sMake);
      rc = RETURN_ERROR;
      break;
    }
    else if (!bAsMake &&  reader_writeflush())
    {
      int i = errno;
      if (bVerbose)
        printf("%+-78s\r", "");
      errno = i;
      perror("mkdepend");
      printf("%s: Error writing '%s'.\n", aPgmName, sDepfile);
      rc = RETURN_ERROR;
      break;
    }
    /* Finish up */
    if (bVerbose)
      printf("%+-78s\r", "");

    if (reader_close())
    {
      perror("mkdepend");
      printf("%s: Error writing '%s'.\n", aPgmName, pFile);
      rc = RETURN_ERROR;
      break;
    }

    if (bAsMake && bMakeExists && chmod(sMake, aMakeStat.st_mode))
    {
      /* perror("mkdepend"); */
      printf("%s: Warning: Can't update mode of '%s'.\n", aPgmName, sMake);
      rc = RETURN_WARN;
    }

    if (bAsMake && !bKeep && pBackup
    && (chmod(pBackup, S_IWRITE|aMakeStat.st_mode) || remove(pBackup))
       )
    {
      perror("mkdepend");
      printf("%s: Warning: Can't remove backup '%s'.\n", aPgmName, pBackup);
      rc = RETURN_WARN;
      break;
    }

  } while(0);

  /* Error cleanup */
  if (rc == RETURN_ERROR)
  {
    reader_close();
    remove(pFile);
    if (pBackup && rename(pBackup, sMake))
    {
      perror("mkdepend");
      printf("%s: Can't restore '%s' from backup '%s'\n", aPgmName, sMake, pBackup);
    }
  }

  if (bVerbose && rc != RETURN_ERROR)
    printf("%+-78s\r", "");

  if (pBackup)
    free(pBackup);

  return rc;
}

/*-------------------------------------------------------------------------*/
int main (int argc, char *argv[])

{
  int i;

  check_os2();

  /* Determine the program executables name */
  aPgmName = strdup(FilePart(argv[0]));
  if (!aPgmName)
    aPgmName = "mkdepend";

  CheckStacksize(10240);

  reader_init();

  /* Get arguments, set up defaults */
  getargs();
  if (returncode > RETURN_WARN)
    return returncode;

  if (MODE_NORMAL)
  {
    if (!aFiles.size)
    {
      if (add_expfile(&aFiles, "#?.c"))
        exit_nomem(RETURN_FAIL);
    }
    if (!sObjExt)
      sObjExt = ".o";

    if (!aSrcExt.size)
    {
      if (array_addfile(&aSrcExt, ".c") || array_addfile(&aObjExt, NULL))
        exit_nomem(RETURN_FAIL);
    }
  }

  if (bVerbose)
  {
    printf("MkDepend %s (%s) -- Make Dependency Generator\n", VERSION, __DATE__);
    puts("Copyright © 1995-1997 Lars Düning.");
    putchar('\n');
  }

  /* Look for the Makefile to modify */
  bMakeExists = 0;
  if (sMake)
  {
    bMakeExists = !stat(sMake, &aMakeStat);
  }
  else if (!sDepfile || !MODE_NORMAL)
  {
    sMake = "Makefile";
    bMakeExists = !stat(sMake, &aMakeStat);
    if (!bMakeExists)
    {
      sMake = "Makefile.mk";
      bMakeExists = !stat(sMake, &aMakeStat);
    }
    if (!bMakeExists)
    {
      sMake = "DMakefile";
      bMakeExists = !stat(sMake, &aMakeStat);
    }
    if (!bMakeExists)
    {
      sMake = "Makefile";
      bMakeExists = !stat(sMake, &aMakeStat);
    }
    if (!bMakeExists)
    {
      sMake = "GNUMakefile";
      bMakeExists = !stat(sMake, &aMakeStat);
    }
    if (!bMakeExists)
      sMake = "Makefile";
  }

  if (MODE_NORMAL) /* --- Do all the file reading and analyzing --- */
  {
    /* Add the source files to the tree */
    if (!aFiles.size)
    {
      printf("%s: No files given.\n", aPgmName);
      set_rc(RETURN_WARN, 1);
    }
    for (i = 0; i < aFiles.size; i++)
    {
      if (nodes_addsource(aFiles.strs[i], 0))
        exit_nomem(RETURN_FAIL);
    }

    /* Mark the exceptional files */
    for (i = 0; i < aAvoid.size; i++)
    {
      if (nodes_addsource(aAvoid.strs[i], 1))
        exit_nomem(RETURN_FAIL);
    }

    /* Add/mark the assumed files */
    for (i = 0; i < aIHide.size; i++)
    {
      if (nodes_addsource(aIHide.strs[i], -1))
        exit_nomem(RETURN_FAIL);
    }

    /* Read and analyse all those files */
    set_rc(readfiles(), 0);
  }
  else /* --- Prepare the cleaning of the makefile --- */
  {
    if (!bMakeExists)
    {
      printf("%s: No Makefile there to clean up.\n", aPgmName);
      return returncode;
    }
  }

  if (returncode < RETURN_ERROR && sMake)
    set_rc(output(TRUE), 0);

  if (returncode < RETURN_ERROR && sMake && bVerbose)
  {
    switch(eMode)
    {
    case eModeNormal:
      printf("%s '%s'.\n", bMakeExists ? "Updated" : "Created", sMake);
      break;
    case eModeClean:
      printf("Cleaned '%s'.\n", sMake);
      break;
    case eModeProper:
      printf("Cleaned '%s' really well.\n", sMake);
      break;
    default:
      printf("%s: Illegal operation mode %d\n", eMode);
      set_rc(RETURN_FAIL, 0);
      break;
    }
  }

  if (returncode < RETURN_ERROR && sDepfile && MODE_NORMAL)
    set_rc(bFlat ? output(FALSE) : output_tree(), 0);

  if (returncode < RETURN_ERROR && sDepfile && bVerbose)
    printf("Created '%s'.\n", sDepfile);

  return returncode;
}

/***************************************************************************/
