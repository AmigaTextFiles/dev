;/* execute me to make with SAS 6.x compile v37 part
sc NOSTKCHK CSRC aguidexrefv37.c OPT IGNORE=73
slink lib:c.o aguidexrefv37.o //Goodies/extrdargs/extrdargs.o TO /c/aguidexrefv37 SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: aguidexrefv37.c 0.14 (22.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 22.09.94 : 000.014 :  now uses ENTRYA_NodeName for the guide nodename
** 08.09.94 : 000.013 :  workbench support added
** 07.08.94 : 000.012 :  now v37,v39 versions separatly
** 29.07.94 : 000.011 :  major changes to v39 version
** 12.06.94 : 000.010 :  font support for v39 version
** 10.06.94 : 000.009 :  file highlight added
** 05.06.94 : 000.008 :  now different tmpfiles and v39 datatype skeleton added
** 28.05.94 : 000.007 :  now uses the tags function
** 18.05.94 : 000.006 :  file support added
** 18.05.94 : 000.005 :  cachedir option added
** 14.05.94 : 000.004 :  XRefAddDynamicHost added
** 09.05.94 : 000.003 :  support of diffrent main pages (categories)
** 06.05.94 : 000.002 :  column support added
** 02.05.94 : 000.001 :  initial
*/


#define OSV37     1

/* ------------------------------- includes ------------------------------- */

#include "aguidexref.h"

#include "aguidexrefv37_rev.h"

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/AGuideXRefV37 *********************************************

$VER: AGuideXRefV37.doc

NAME
    AGuideXRefV37 - searches the xref-lists for a given string/pattern and
                    shows a amigaguide text for the found entries

TEMPLATE
    STRING,CATEGORY,FILE/K,CACHEDIR/K,LINELENGTH/N/K,COLUMNS/N/K,LIMIT/N/K,
    NOPATTERN/S,NOCASE/S,PUBSCREEN/K,PORTNAME/K

FORMAT
    AGuideXRef [[STRING] string|pattern] [[CATEGORY] category] [FILE xreffile]
               [CACHEDIR dir] [LIMIT maxentries] [LINELENGTH numchars] 
               [COLUMNS numcolumns] [NOPATTERN] [NOCASE] [PUBSCREEN pubname]
               [PORTNAME arexxportname]

FUNCTION
    this command gives an CLI interface to the xref.library, which uses the
    AmigaGuide system to display some found xref entries and have a link to
    its real documentation.
    If you specify the CACHEDIR, this directory will be used to save the
    AmigaGuide files, if there are more the one entries for the given string
    or pattern. Any next call with this CACHEDIR and the given string/pattern,
    it will no longer call the xref.library function, but uses this file.
    If you do not specify a CATEGORY all xreffiles in the xref.library are
    parsed.From xref.library 1.8 the categorystring can be a pattern !

INPUTS
    STRING (STRING) - string|pattern to search for

    CATEGORY (STRING) - category to parse (no specified category matches
        all categories). Can be a pattern !

    FILE (STRING) - file to parse, this argument overrides the CATEGORY
        argument

    CACHEDIR (STRING) - if you want to save all generated AmigaGuide files
        to have a fast access to it, just specify here the directory, in which
        these files will saved

    LIMIT (NUMBER) - specifies the maximal number of entries to match
        (default : xref.library default (XREFBA_DefaultLimit))

    LINELENGTH (NUMBER) - specifies the number of chars for a line
        (default : xref.library default (XREFBA_LineLength))

    COLUMNS (NUMBER) - specifies the number of columns, which will be used
        if more than one entry matches
        (default : xref.library default (XREFBA_Columns))

    NOPATTERN (BOOLEAN) - interprets the given string as a normal string
        instead of a pattern

    NOCASE (BOOLEAN) - makes the search case-insensitive

    PUBSCREEN (STRING) - specifies the screen, on which the AmigaGuide window
        should be opened

EXAMPLES
    The following example searches all xreffiles of the AutoDoc category for
    xrefentries with the word "Window" inside and tries to open a window on the
    GoldEd Screen, if it has found some entry matches this pattern :

        AGuideXRefV37 #?Window#? #?AutoDoc#? PUBSCREEN=GOLDED.1

SEE ALSO
    LoadXRef,MakeXRef,ParseXRef,dos.library/ParsePattern()

COPYRIGHT
    by Stefan Ruppert (C) 1994

HISTORY
    AGuideXRefV37 1.10 (22.9.94) :
        - ENTRYA_NodeName wasn't used for the guide node. This is fixed !

    AGuideXRefV37 1.9 (8.9.94) :
        - workbench support added

    AGuideXRefV37 1.8 (3.9.94) :
        - some tagnames changed

    AGuideXRefV37 1.7 (10.8.94) :
        - now V37,V39 versions are two programs

    AGuideXRef 1.6 (29.7.94) :
        - major changes for V39 version
        - entries now sorted to files

    AGuideXRef 1.5 (10.6.94) :
        - File highlighted added

    AGuideXRef 1.4 (5.6.94) :
        - now unique tempfiles
        - V39 datatype skeleton
        - V39 datatype entry with the FORCEV39 switch

    AGuideXRef 1.3 (28.5.94) :
        - CACHEDIR and PORTNAME options added

    AGuideXRef 1.2 (20.5.94) :
        - LINELENGTH and COLUMNS options added

    AGuideXRef 1.1 (10.5.94) :
        - first beta release

*****************************************************************************/
/*FE*/

/* ------------------------------ Prototypes ------------------------------ */

/*FS*/ /*"Prototypes"*/

void openamigaguide(struct GlobalData *gd);

/*FE*/

/* ------------------------- template definition -------------------------- */

/*FS*/ /*"Template Definition"*/

#define template "STRING,CATEGORY,FILE/K,CACHEDIR/K,LINELENGTH/N/K," \
                 "COLUMNS/N/K,LIMIT/N/K,NOPATTERN/S,NOCASE/S," \
                 "PUBSCREEN/K,PORTNAME/K"

enum {
   ARG_STRING,     /* string to parse for */
   ARG_CATEGORY,   /* category to parse \  mutual   */
   ARG_FILE,       /* file to parse     / exclusive */
   ARG_CACHEDIR,   /* diretory to hold amigaguide files for a specified STRING */
   ARG_LINELENGTH, /* linelength for the amigaguide window */
   ARG_COLUMNS,    /* columns to use for the amigaguide window */
   ARG_LIMIT,      /* maximal number of entries */
   ARG_NOPATTERN,  /* just a string instead of a pattern-string */
   ARG_NOCASE,     /* ignore letter-case */
   ARG_PUBSCREEN,  /* pubscreen to open the amigaguide window */
   ARG_PORTNAME,   /* arexx portname to use */
   ARG_MAX};

char *prgname = "AGuideXRefV37";

/*FE*/

/* ---------------------- include generic functions ----------------------- */

#include "aguidexref.c"

/* ---------------------- open an amigaguide window ----------------------- */

/*FS*//*"void openamigaguide(struct GlobalData *gd)"*/
void openamigaguide(struct GlobalData *gd)
{
   struct Library *AmigaGuideBase;
   struct NewAmigaGuide nag = {NULL};

   /* default node */
   nag.nag_Node = "main";

   if(gd->gd_Num == 0)
      nag.nag_Node = gd->gd_MainBuffer;
   else if(gd->gd_Num == 1)
   {
      nag.nag_Node = gd->gd_LastEntry.e_NodeName;
      nag.nag_Line = gd->gd_LastEntry.e_Line;

      sprintf(gd->gd_FileBuffer,"%s%s",gd->gd_LastEntry.e_Path,
                                       gd->gd_LastEntry.e_File);
   }

   gd->gd_Object = "amigaguide.library";
   if(AmigaGuideBase = OpenLibrary(gd->gd_Object,34))
   {
      AMIGAGUIDECONTEXT handle;

      nag.nag_PubScreen  = (STRPTR) gd->gd_Para[ARG_PUBSCREEN];
      nag.nag_ClientPort = (STRPTR) gd->gd_Para[ARG_PORTNAME];

      nag.nag_Name      = gd->gd_FileBuffer;

      DB(("file : %s\n",nag.nag_Name));
      DB(("node : %s\n",nag.nag_Node));
      DB(("line : %ld\n",nag.nag_Line));

      if(handle = OpenAmigaGuide(&nag, NULL))
         CloseAmigaGuide(handle);

      CloseLibrary(AmigaGuideBase);
   }
}
/*FE*/

/* ---------------------------- main function ----------------------------- */

/*FS*/ /*"int main(int ac,char *av[]) "*/
int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};
   struct GlobalData *gd;

   ULONG para[ARG_MAX];
   STRPTR obj = prgname;
   LONG err;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FILE;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      if(gd = AllocMem(sizeof(struct GlobalData) , MEMF_CLEAR))
      {
         obj = "xref.library";

         if(XRefBase = OpenLibrary(obj,0))
         {
            getstdargs(gd,para);

            parsexref(gd);

            openamigaguide(gd);

            /* last object that caused an error */
            obj = gd->gd_Object;
            err = gd->gd_Error;

            CloseLibrary(XRefBase);

            /* delete all tempory files */
            while(gd->gd_TempCount > 0)
            {
               gd->gd_TempCount--;
               DeleteFile(tmpname(gd));
               gd->gd_TempCount--;
            }
         }
         FreeMem(gd,sizeof(struct GlobalData));
      }
   }
   ExtFreeArgs(&eargs);

   if(!err)
      err = IoErr();

   if(err)
   {
      if(ac == 0)
         showerror(prgname,obj,err);
      else
         PrintFault(err,obj);
      return(RETURN_ERROR);
   }

   return(RETURN_OK);
}
/*FE*/

