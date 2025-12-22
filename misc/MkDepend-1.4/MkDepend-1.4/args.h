/* $Id: args.h,v 1.5 1997/11/09 23:42:46 lars Exp $ */

#ifndef __ARGS_H__
#define __ARGS_H__ 1

/* Dynamic string array */

typedef struct sarray
{
  int     size;   /* Number of used strings */
  int     alloc;  /* Number of allocated string pointers */
  char ** strs;   /* Array of string pointers */
} SArray;

/* Program arguments */

extern short    bVerbose;   /* TRUE: Verbose action */
extern SArray   aFiles;     /* Source files */
extern SArray   aAvoid;     /* Source files to avoid */
extern SArray   aIHide;     /* Include files to hide */
extern SArray   aIncl;      /* Include paths */
extern SArray   aSymbol;    /* Include path symbols */
extern SArray   aSrcExt;    /* Source file extensions */
extern SArray   aObjExt;    /* Associated object file extensions */
extern SArray   aObjPat;    /* Associated object file patterns */
extern short  * bGiveSrc;   /* For each entry in aSrcExt: TRUE if the source name
                             * shall appear in the dependency list, too. */
extern char   * sObjExt;    /* Default object file extension */
extern short    bDefGSrc;   /* For sObjExt: TRUE if the source name shall appear
                             * in the depency list, too */
extern char   * sMake;      /* Name of the Makefile */
extern char   * sDepfile;   /* Name of the dependency file */
extern short    bFlat;      /* TRUE: Depfile in flat format */
extern short    bKeep;      /* TRUE: Keep Makefile backup */
extern short    bEachLine;  /* TRUE: Prefix each line in Makefile with obj file */
extern short    bOneDep;    /* TRUE: Just one dependency per Makefile line */

typedef enum { eModeNormal  /* Create dependencies */
             , eModeClean   /* Clean up the Makefile */
             , eModeProper  /* Make the Makefile really clean */
} OpMode;
extern OpMode   eMode;      /* Operation mode */

/* Misc Variables */

extern char * aPgmName;    /* Name of the program executable */

/* Prototypes */

extern void getargs (void);
extern int array_addlist (SArray *, int, char **);
extern int array_addfile (SArray *, char *);
extern int add_expfile (SArray *, char *);

#endif
