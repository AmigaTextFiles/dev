;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC makexref.c OPT IGNORE=73
slink lib:c.o makexref.o //Goodies/extrdargs/extrdargs.o TO /c/makexref SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: makexref.c 1.20 (19.11.94)
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
** 19.11.94 : 001.020 :  new AUTHOR,NAME options, generates now VERSTAG
** 03.11.94 : 001.019 :  default icon name now env:sys/def_xref
** 25.09.94 : 001.018 :  line var in scan_header() now correct
** 24.09.94 : 001.017 :  if only a file is given, this wasn't opened. This is fixed
** 10.09.94 : 001.016 :  now uses a status window, if started from workbench
** 07.09.94 : 001.015 :  workbench support added (FinalReadArgs())
** 03.09.94 : 001.014 :  now uses ENTRYA_NodeName
** 29.08.94 : 001.013 :  unix manpages support added
** 28.07.94 : 001.012 :  only shift-space in scan_amigaguide was searched, this is now fixed
** 20.07.94 : 001.011 :  PATH option added
** 09.07.94 : 001.010 :  added support for typedefs etc, some bug fixes
** 19.06.94 : 001.009 :  changed to new library entry functions
** 05.06.94 : 001.008 :  strip '.doc' for an autodoc file and append ".guide" for an doc
** 22.05.94 : 001.007 :  ctrl-c support added
** 22.05.94 : 001.006 :  modularized and globaldata added
** 10.05.94 : 001.005 :  length byte after the type byte added
** 07.05.94 : 001.004 :  path for a file argument corrected
** 27.04.94 : 001.003 :  filepath corrected
** 26.04.94 : 001.002 :  verbose arg added and version change to 1
** 15.01.94 : 000.001 :  initial
**
*/

#include "Def.h"

#include <libraries/xref.h>
#include <clib/xref_protos.h>
#include <pragmas/xref_pragmas.h>

#include "/lib/xrefsupport.h"

#include "makexref_rev.h"

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/MakeXRef **************************************************

$VER: MakeXRef.doc

NAME
    MakeXRef - generate a xreffile for amigaguide from c-header, amigaguide,
               autodoc, unix man pages and normal doc files

TEMPLATE
    FROM/A/M,TO/A,CATEGORY/K,PATH/K,VERSION/N/K,REVISION/N/K,VERBOSE

FORMAT
    MakeXRef [FROM] file|dir [file2|dir2] [TO] file [CATEGORY category] 
             [PATH gpath] [VERSION versionnr] [REVISION revisionnr] [VERBOSE]

FUNCTION
    generate xref-file for use with xref.library.This tool scans any autodoc,
    amigaguide ,C-Header, unix man page and normal doc file. The following 
    entry types are recognized :
        in C-Header files :
        - normal define's
        - macro define's
        - structures
        - typedef's
        in autodoc,amigaguide, unix man page and normal doc files :
        - function's
        - command's (device command's for example)
        - generic (all other entries, which doesn't fit in the types above)

    If started from workbench, it opens a status window, which displays the
    current state of the program. Also it calculates the time to be used until
    the program finishes. Take just a look at !

INPUTS
    FROM    - File(s) or director(y|ies) to scan

    TO      - File to hold all xref-entries

    CATEGORY- category to use implicit for this xreffile (this is saved in
              the xreffile). Note this is the specification of the category,
              so you can't use any pattern !

    PATH    - global path, which is prepend to each filename for a entry, so
              you can build absolute filepath for a entry, this path is stored
              only once in a xreffile.

    VERSION - version of the created xreffile

    REVISION- revision of the created xreffile

    NOICON  - don't create a icon for the generated xreffile

    VERBOSE - switch, that indicate you want to see the found entries

SEE ALSO
    ParseXRef, AGuideXRefV37, AGuideXRefV39, LoadXRef, ExpungeXRef,
    libraries/amigaguide.h, libraries/xref.h

COPYRIGHT
    (C) by Stefan Ruppert 1994

HISTORY
    MakeXRef 1.20 (19.11.94) :
        - new AUTHOR,NAME options
        - generates now AmigaDOS 2.0 version string

    MakeXRef 1.19 (3.11.94) :
        - intern Icon definition corrected

    MakeXRef 1.18 (25.9.94) :
        - in header files line number was not correct in some cases

    MakeXRef 1.17 (24.9.94) :
        - if only a file was passed , it wasn't opened . This is fixed !

    MakeXRef 1.16 (10.9.94) :
        - status window added , if started from Workbench

    MakeXRef 1.15 (7.9.94) :
        - workbench support added
        - now patterns can be used for the FROM argument

    MakeXRef 1.14 (3.9.94) :
        - some changes to reflect new tags
        - scan_man() function now strips backspaces

    MakeXRef 1.13 (29.8.94) :
        - added support of unix manual pages

    MakeXRef 1.12 (28.7.94) :
        - in amigaguide scan , there was a bug, which interpreted a space in a
          a node name as a normal character. This is fixed !
        - path now check for last character (':','/')

    MakeXRef 1.11 (20.7.94) :
        - PATH option added.

    MakeXRef 1.10 (9.7.94) :
        - added support for typedefs, macros, commands and generic
        - now handles datatypes,gadgets and handlers as generic
        - some bug fixes

    MakeXRef 1.9 (19.6.94) :
        - now uses the xref.library function to create a xreffile
          the library handles now all entry and file names.It sorts
          all names and create an index for each entry.

    MakeXRef 1.8 (5.6.94) :
        - now strips ".doc" from an autodoc file in the xref file

    MakeXRef 1.7 (22.5.94) :
        - now supports C-header files

    MakeXRef 1.6 (10.5.94) :
        - xref file format changed

    MakeXRef 1.5 (7.5.94) :
        - first beta release

*****************************************************************************/
/*FE*/

/* ------------------------------ Prototypes ------------------------------ */

/*FS*/ /*"Prototypes"*/

RegCall LONG scan_file(REGA0 struct Hook *hook,REGA2 struct GlobalData *gd,REGA1 struct spMsg *msg);

void scan_header(struct GlobalData *gd);
void scan_autodoc(struct GlobalData *gd);
void scan_amigaguide(struct GlobalData *gd);
void scan_man(struct GlobalData *gd);

BOOL check_abort(struct GlobalData *gd);

void draw_info(struct GlobalData *gd,STRPTR entry,ULONG entrytype);
void draw_state(struct GlobalData *gd);

/*FE*/

/* ----------------------------- definitions ------------------------------ */

/*FS*/ /*"Defines"*/
#define BUFFER_LEN   1024
#define PATH_LEN     512

#define EOS          '\0'

#define LINE_UPDATE    50

/*FE*/

/* ------------------------------ Structures ------------------------------ */

/*FS*/ /*"Structure definition"*/
struct GlobalData
{
   ULONG *gd_Para;

   BPTR gd_ReadFH;
   APTR gd_XRefFile;

   BOOL gd_Workbench;                  /* TRUE -> started from workbench */
   BOOL gd_Abort;

   ULONG gd_FileType;                  /* actual filetype of the current file */
   ULONG gd_FileSize;                  /* actual filesize of the current file */
   ULONG gd_Line;

   struct ScanWindow gd_SWin;
   struct ScanStat gd_SStat;
   struct TimeCalc gd_TimeCalc;

   ULONG gd_Entries;

   STRPTR gd_FileName;
   UBYTE gd_TempPath[PATH_LEN];

   UBYTE gd_LineBuffer[BUFFER_LEN];
   UBYTE gd_TempBuffer[BUFFER_LEN];

   struct Library *gd_XRefBase;
};

#define XRefBase     gd->gd_XRefBase
/*FE*/

/* ------------------------------ Icon data ------------------------------- */

/*FS*/ /*"Icon Data"*/
/****** Image def_xref.info : w = 64, h = 22 ********/
UWORD def_xref_infoIData[176] = {
/*------ plane # 0: --------*/
        0x0000, 0x0000, 0x0000, 0x0400, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x0030, 0x0060, 0x0000, 0x0C00, 
        0x0018, 0x00C0, 0x0000, 0x0C00, 
        0x000C, 0x0180, 0x0000, 0x0C00, 
        0x0006, 0x0300, 0x0010, 0x0C00, 
        0x0003, 0x0600, 0x0018, 0x0C00, 
        0x0001, 0x8C00, 0x001C, 0x0C00, 
        0x0000, 0xD800, 0x001E, 0x0C00, 
        0x0000, 0x7007, 0xFFFF, 0x0C00, 
        0x0000, 0x7007, 0xFFFF, 0x0C00, 
        0x0000, 0xD800, 0x001E, 0x0C00, 
        0x0001, 0x8C00, 0x001C, 0x0C00, 
        0x0003, 0x0600, 0x0018, 0x0C00, 
        0x0006, 0x0300, 0x0010, 0x0C00, 
        0x000C, 0x0180, 0x0000, 0x0C00, 
        0x0018, 0x00C0, 0x0000, 0x0C00, 
        0x0030, 0x0060, 0x0000, 0x0C00, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x0000, 0x0000, 0x0000, 0x0C00, 
        0x7FFF, 0xFFFF, 0xFFFF, 0xFC00, 
/*------ plane # 1: --------*/
        0xFFFF, 0xFFFF, 0xFFFF, 0xF800, 
        0xEAAA, 0xAAAA, 0xAAAA, 0xA000, 
        0xEAFA, 0xAAFA, 0xAAAA, 0xA000, 
        0xEAC2, 0xAB8A, 0xAAAA, 0xA000, 
        0xEAE2, 0xAB0A, 0xAAAA, 0xA000, 
        0xEAB0, 0xAE0A, 0xAAAA, 0xA000, 
        0xEAB8, 0xAC2A, 0xAAA2, 0xA000, 
        0xEAAC, 0x382A, 0xAAA2, 0xA000, 
        0xEAAE, 0x30AA, 0xAAA0, 0xA000, 
        0xEAAB, 0x00AF, 0xFFE0, 0xA000, 
        0xEAAB, 0x82A8, 0x0000, 0x2000, 
        0xEAAB, 0x82A8, 0x0000, 0x2000, 
        0xEAAB, 0x02A8, 0x0000, 0x2000, 
        0xEAAE, 0x10AA, 0xAAA0, 0xA000, 
        0xEAAC, 0x38AA, 0xAAA0, 0xA000, 
        0xEAB8, 0x2C2A, 0xAAA2, 0xA000, 
        0xEAB0, 0xAE2A, 0xAAAA, 0xA000, 
        0xEAE0, 0xAB0A, 0xAAAA, 0xA000, 
        0xEAC2, 0xAB8A, 0xAAAA, 0xA000, 
        0xEAE2, 0xAAEA, 0xAAAA, 0xA000, 
        0xEAAA, 0xAAAA, 0xAAAA, 0xA000, 
        0x8000, 0x0000, 0x0000, 0x0000, 
};

struct Image def_xref_infoImg =
{
        0, 0,                    /* LeftEdge, TopEdge */
        54, 22, 2,               /* Width, Height, Depth */
        &def_xref_infoIData[0],  /* ImageData */
        0x03, 0x00,              /* PlanePick, PlaneOnOff */
        0L                       /* NextImage */
};

STRPTR def_xref_tooltypes[] = {
   "(XREFPRI=<priority>)",
   "(LOCK)",
   "(INDEX)",
   NULL};

struct SaveDefIcon def_xref = {
   "Env:Sys/def_xref",
   "LoadXRef",
   &def_xref_tooltypes[0],
   &def_xref_infoImg};


/*FE*/

/* ------------------------------- Template ------------------------------- */

/*FS*/ /*"Template definition"*/
#define template "FROM/A/M,TO/A,CATEGORY/K,PATH/K,VERSION/N/K,REVISION/N/K," \
                 "AUTHOR/K,NAME/K,NOICON/S,VERBOSE/S"

enum {
   ARG_FROM,
   ARG_TO,
   ARG_CATEGORY,
   ARG_PATH,
   ARG_VERSION,
   ARG_REVISION,
   ARG_AUTHOR,
   ARG_NAME,
   ARG_NOICON,
   ARG_VERBOSE,
   ARG_MAX};

char *prgname    = "MakeXRef";

const char *version    = VERSTAG;
const char *mainstring = "main";

char *displaytexts[] = {
   "XReffile",
   "Entries",
   "Files",
   "Dirs",
   "Dir",
   "File",
   "Filetype",
   "Entry",
   NULL};

enum {
   NUM_XREFFILE,
   NUM_ENTRIES,
   NUM_FILES,
   NUM_DIRS,
   NUM_DIR,
   NUM_FILE,
   NUM_FILETYPE,
   NUM_ENTRY,
   NUM_MAX};

const STRPTR etype[] = {
   "generic",
   "function",
   "command",
   "include",
   "macro",
   "struct",
   "field",
   "typedef",
   "define",
   NULL};

/*FE*/

/* --------------------------- main entry point --------------------------- */

/*FS*/ /*"int main(int ac,char *av[]) "*/
int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};

   struct GlobalData *gd;

   ULONG para[ARG_MAX];

   STRPTR obj  = prgname;
   LONG retval = RETURN_OK;
   LONG err;

   WORD i;

   for( i = 0 ; i < ARG_MAX ; i++ )
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = ARG_FROM;

   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      para[ARG_VERSION]  = (para[ARG_VERSION])  ? *((ULONG *) para[ARG_VERSION])  : 1;
      para[ARG_REVISION] = (para[ARG_REVISION]) ? *((ULONG *) para[ARG_REVISION]) : 1;

      if(gd = AllocVec(sizeof(struct GlobalData),MEMF_ANY | MEMF_CLEAR))
      {
         struct DateTime dt;
         STRPTR verstag = NULL;
         UBYTE dbuf[20];
         UBYTE vtbuf[100];

         DateStamp(&dt.dat_Stamp);

         dt.dat_Format = FORMAT_CDN;
         dt.dat_Flags  = 0;
         dt.dat_StrDate= dbuf;
         dt.dat_StrTime= NULL;
         dt.dat_StrDay = NULL;

         if(DateToStr(&dt))
         {
            STRPTR ptr = dbuf;

            if(*ptr == '0')
               while(*ptr = *(ptr + 1))
                  ptr++;

            ptr = dbuf;
            while(*ptr != '-')
               ptr++;

            *ptr++ = '.';
            if(*ptr == '0')
               while(*ptr = *(ptr + 1))
                  ptr++;

            ptr = dbuf;
            while(*ptr != '-')
               ptr++;
            *ptr = '.';

            sprintf(vtbuf,"%lc$VER: %s %ld.%ld (%s)",'\0',
                          FilePart((STRPTR) para[ARG_TO]),
                          para[ARG_VERSION],
                          para[ARG_REVISION],
                          dbuf);
            verstag = vtbuf;
         }

         gd->gd_Workbench = (ac == 0);

         if(para[ARG_PATH])
         {
            ULONG len;
            strcpy(gd->gd_TempPath,(STRPTR) para[ARG_PATH]);
            len = strlen(gd->gd_TempPath)-1;
            if(gd->gd_TempPath[len] != ':' && gd->gd_TempPath[len] != '/')
               strcat(gd->gd_TempPath,"/");
            para[ARG_PATH] = (ULONG) gd->gd_TempPath;
         }

         obj = "xref.library";
         if((XRefBase = OpenLibrary(obj,1)))
         {
            obj = (STRPTR) para[ARG_TO];
            if(gd->gd_XRefFile = CreateXRefFile(obj,XREFA_Category ,para[ARG_CATEGORY],
                                                    XREFA_VersTag  ,verstag,
                                                    XREFA_Author   ,para[ARG_AUTHOR],
                                                    XREFA_Name     ,para[ARG_NAME],
                                                    XREFA_Path     ,para[ARG_PATH],
                                                    TAG_DONE))
            {
               struct Hook scanfile_hook = {NULL};

               gd->gd_Para = para;
               scanfile_hook.h_Entry = (HOOKFUNC) scan_file;

               if(ac == 0)
               {
                  open_scanwindow(&gd->gd_SWin,displaytexts,prgname,400);
                  draw_scanwindowstatus(&gd->gd_SWin,"reading filelist ...");
               }

               getscanstat((STRPTR *) para[ARG_FROM],&gd->gd_SStat);

               if(ac == 0)
               {
                  draw_scanwindowtext(&gd->gd_SWin,NUM_XREFFILE,(STRPTR) para[ARG_TO]);
                  draw_scanwindowstatus(&gd->gd_SWin,"scanning ...");
               }
               
               /* init time service structure */
               time_init(&gd->gd_TimeCalc,LINE_UPDATE);

               err = scan_patterns((STRPTR *) para[ARG_FROM],&scanfile_hook,gd);

               CloseXRefFile(gd->gd_XRefFile);

               gd->gd_Abort |= (err == ERROR_BREAK);

               time_calc(&gd->gd_TimeCalc,1,1);

               if(gd->gd_Abort)
               {
                  DeleteFile((STRPTR) para[ARG_TO]);
                  err = ERROR_BREAK;
                  obj = prgname;
                  Printf ("\r%s removed ! %-60s\n",(STRPTR) para[ARG_TO],"");
               } else
               {
                  Printf ("\rFiles scanned : %ld, Entries found : %ld , Time used : %02ld:%02ld%-20s\n",
                          gd->gd_SStat.ss_Files,gd->gd_Entries,
                          gd->gd_TimeCalc.tc_Secs[TIME_USED] / 60,
                          gd->gd_TimeCalc.tc_Secs[TIME_USED] % 60,
                          "");

                  DB(("IoErr() = %ld\n",IoErr()));

                  if(!para[ARG_NOICON])
                  {
                     STRPTR xrefdir;
                     BPTR dir = NULL;
                     BPTR old;

                     if((FilePart((STRPTR) para[ARG_TO]) == ((STRPTR) para[ARG_TO])) &&
                        (GetXRefBaseAttrs(XREFBA_XRefDir,&xrefdir,TAG_DONE) == 1))
                     {
                        if((dir = Lock(xrefdir,SHARED_LOCK)))
                           old = CurrentDir(dir);
                     }

                     saveicon((STRPTR) para[ARG_TO],&def_xref);

                     if(dir)
                     {
                        CurrentDir(old);
                        UnLock(dir);
                     }
                  }

                  DB(("IoErr() = %ld\n",IoErr()));
               }

               /* close all workbench stuff */
               close_scanwindow(&gd->gd_SWin,gd->gd_Abort);
            }

            CloseLibrary(XRefBase);
         }
         FreeVec(gd);
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

      retval = RETURN_ERROR;
   }

   return(retval);
}
/*FE*/

/* ------------------------------ scan_file ------------------------------- */

/*FS*/ /*"LONG scan_file(struct Hook *hook,struct GlobalData *gd,struct spMsg *msg)"*/
RegCall LONG scan_file(REGA0 struct Hook *hook,REGA2 struct GlobalData *gd,REGA1 struct spMsg *msg)
{
   STRPTR path  = msg->Path;
   STRPTR gpath = msg->RealPath;
   ULONG filetype;

   DB(("msg  : %ld\n",msg->Msg));
   DB(("path : %s\n",msg->Path));

   switch(msg->Msg)
   {
   case SPM_DIR:

      gd->gd_SStat.ss_ActDirectories++;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"(%3ld/%3ld)",gd->gd_SStat.ss_ActDirectories,gd->gd_SStat.ss_Directories);
         draw_scanwindowtext(&gd->gd_SWin,NUM_DIRS,gd->gd_TempBuffer);

         draw_scanwindowtext(&gd->gd_SWin,NUM_DIR,gpath);
      } else if(gd->gd_Para[ARG_VERBOSE])
         Printf ("\rScanning dir (%3ld/%3ld) : %-40s\n",
                  gd->gd_SStat.ss_ActDirectories,
                  gd->gd_SStat.ss_Directories,
                  msg->RealPath);

      break;
   case SPM_FILE:
      gd->gd_SStat.ss_ActFiles++;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"(%3ld/%3ld)",gd->gd_SStat.ss_ActFiles,gd->gd_SStat.ss_Files);

         draw_scanwindowtext(&gd->gd_SWin,NUM_FILES    ,gd->gd_TempBuffer);
         draw_scanwindowtext(&gd->gd_SWin,NUM_FILE     ,FilePart(path));
      } else if(gd->gd_Para[ARG_VERBOSE])
         Printf ("\rScanning file (%3ld/%3ld) : %s",
                 gd->gd_SStat.ss_ActFiles,
                 gd->gd_SStat.ss_Files,
                 path);

      DB(("scanfile : %s\n",path));

      if((filetype = getfiletype(msg->FHandle,msg->RealPath)) != FTYPE_UNKNOWN)
      {
         gd->gd_ReadFH = msg->FHandle;

         if(gd->gd_Workbench)
            draw_scanwindowtext(&gd->gd_SWin,NUM_FILETYPE ,ftype[filetype]);
         else if(gd->gd_Para[ARG_VERBOSE])
            Printf (" (%s)%-30s\n",ftype[filetype],"");

         gd->gd_FileName = path;
         gd->gd_FileType = filetype;
         
         gd->gd_FileSize = msg->Fib->fib_Size;

         /* manipulate the filepart of the msg->Path (this is save for scan_patterns()) */
         convertsuffix(filetype,path);

         DB(("after convertsuffix : %s %s !\n",path,ftype[filetype]));

         if(gd->gd_Workbench)
            draw_gauge(&gd->gd_SWin.sw_Actual,0,0);

         switch(filetype)
         {
         case FTYPE_HEADER:
            scan_header(gd);
            break;
         case FTYPE_AUTODOC:
         case FTYPE_DOC:
            scan_autodoc(gd);
            break;
         case FTYPE_AMIGAGUIDE:
            scan_amigaguide(gd);
            break;
         case FTYPE_MAN:
            scan_man(gd);
            break;
         }

         DB(("before scan_file Close(readfh)\n"));
      
         gd->gd_ReadFH = NULL;
      } else
      {  
         if(gd->gd_Workbench)
            draw_scanwindowtext(&gd->gd_SWin,NUM_FILETYPE ,"unknown");
         else if(gd->gd_Para[ARG_VERBOSE])
            Printf ("(unknown)%-30s\n","");
      }
      DB(("scan_file : end !\n"));

      gd->gd_SStat.ss_ActTotalFileSize += msg->Fib->fib_Size;

      if(!gd->gd_Abort)
         draw_state(gd);

      break;
   }

   if(check_abort(gd))
      return(ERROR_BREAK);

   return(0);
}
/*FE*/

/* -------------------------- scan specific file -------------------------- */

/*FS*//*"void scan_header(struct GlobalData *gd)"*/
void scan_header(struct GlobalData *gd)
{
   STRPTR ptr;
   STRPTR name;
   ULONG add;
   ULONG type;
   ULONG line = 0;

   WriteXRefFileEntry(gd->gd_XRefFile,ENTRYA_Type     ,XREFT_INCLUDE,
                                      ENTRYA_Name     ,gd->gd_FileName,
                                      ENTRYA_File     ,gd->gd_FileName,
                                      ENTRYA_NodeName ,mainstring,
                                      TAG_DONE);

   draw_info(gd,gd->gd_FileName,XREFT_INCLUDE);

   while((ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      line++;

      while(*ptr == ' ' || *ptr == '\t')
         ptr++;

      if(!strncmp(ptr,"struct",6))
      {
         ptr += 6;

         name = ptr;

         while(*ptr == ' ' || *ptr == '\t')
            ptr++;

         if(name != ptr)
         {
            name = ptr;

            while(*ptr != '{' && *ptr != ' ' && *ptr != '\t' && *ptr != '\n')
               ptr++;

            *ptr++ = EOS;

            while(*ptr == ' ' || *ptr == '\t' && *ptr == '\n')
               ptr++;

            add = 0;

            if(*ptr == EOS)
            {
               while(ptr && (ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)))
               {
                  add++;

                  if(*ptr != '\n')
                     break;
               }

               if(!ptr)
                  break;
            }

            if(*ptr == '{')
            {

               if(WriteXRefFileEntry(gd->gd_XRefFile,ENTRYA_Type     ,XREFT_STRUCT,
                                                     ENTRYA_Name     ,name,
                                                     ENTRYA_File     ,gd->gd_FileName,
                                                     ENTRYA_Line     ,line,
                                                     ENTRYA_NodeName ,mainstring,
                                                     TAG_DONE))
               {
                  draw_info(gd,name,XREFT_STRUCT);
               }
            }         
            gd->gd_Line += add;
            line += add;
         }
      } else if(!strncmp(ptr,"#define",7))
      {
         ptr += 7;

         while(*ptr == ' ' || *ptr == '\t')
            ptr++;

         name = ptr;

         while(*ptr != ' ' && *ptr != '\t' && *ptr != '(' && *ptr != '\n')   
            ptr++;

         if(*ptr == '(')
            type = XREFT_MACRO;
         else
            type = XREFT_DEFINE;

         *ptr = EOS;

         if(WriteXRefFileEntry(gd->gd_XRefFile,ENTRYA_Type     ,type,
                                               ENTRYA_Name     ,name,
                                               ENTRYA_File     ,gd->gd_FileName,
                                               ENTRYA_Line     ,line,
                                               ENTRYA_NodeName ,mainstring,
                                               TAG_DONE))
         {
            draw_info(gd,name,type);
         }
      } else if(!strncmp(ptr,"typedef",7))
      {
         ptr += 7;

         while(*ptr != ';' && *ptr != EOS)
         {
            while(*ptr == ' ' || *ptr == '\t' || *ptr == '*')
               ptr++;

            if(*ptr != ';')
               name = ptr;

            while(*ptr != ';' && *ptr != EOS && *ptr != ' ' && *ptr != '\t')
               ptr++;
         }

         if(*ptr == ';')
         {
            *ptr = EOS;
            if(WriteXRefFileEntry(gd->gd_XRefFile,ENTRYA_Type     , XREFT_TYPEDEF,
                                                  ENTRYA_Name     , name,
                                                  ENTRYA_Line     , line,
                                                  ENTRYA_File     , gd->gd_FileName,
                                                  ENTRYA_NodeName , mainstring,
                                                  TAG_DONE))
            {
               draw_info(gd,name,XREFT_TYPEDEF);
            }
         }
      }
   }
}
/*FE*/
/*FS*//*"void scan_autodoc(struct GlobalData *gd)"*/
void scan_autodoc(struct GlobalData *gd)
{
   STRPTR ptr;
   STRPTR name;
   ULONG type;
   BOOL autodoc = TRUE;
   BOOL formfeed = FALSE;

   DB(("path : %s\n",gd->gd_FileName));

   while((ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      while(*ptr == ' ' || *ptr == '\t')
         ptr++;

      if(*ptr == '\f')
      {
         formfeed = TRUE;
         ptr++;
      }

      /* continue on an empty line */
      if(*ptr == '\n')
         continue;

      if(formfeed)
      {
         STRPTR ptr2 = ptr;

         while(*ptr2 != ' ' && *ptr2 != '\t' && *ptr2 != '\n' && *ptr2 != EOS)
            ptr2++;

         *ptr2 = EOS;

         if(strlen(ptr) > 40)
            ptr += (strlen(ptr) >> 1);

         strcpy(gd->gd_TempBuffer,FilePart(ptr));

         if(checkentrytype(gd->gd_TempBuffer) == XREFT_FUNCTION &&
            strcmp(&gd->gd_TempBuffer[strlen(gd->gd_TempBuffer) - 2],"()"))
            strcat(gd->gd_TempBuffer,"()");

         formfeed = FALSE;
      }

      if(!strncmp(ptr,"NAME",4))
      {
         ptr += 4;
         while(*ptr == ' ' || *ptr == '\t')
            ptr++;

         if(*ptr == '\n')
            while((ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)))
            {
               while(*ptr == ' ' || *ptr == '\t')
                  ptr++;

               /* break on an empty line */
               if(*ptr == '\n')
                  break;

               name = ptr;

               while(*ptr != ' ' && *ptr != '\t' && *ptr != '-' && *ptr != '\n')
                  ptr++;

               if(gd->gd_FileType == FTYPE_AUTODOC)
               {
                  STRPTR ptr2 = ptr;

                  autodoc = TRUE;

                  while(*ptr2 == ' ' || *ptr2 == '\t')
                     ptr2++;

                  if(*ptr2 != '-')
                     autodoc = FALSE;
               }

               *ptr = EOS;

               if(autodoc)
               {
                  name = FilePart(name);

                  if(gd->gd_FileType == FTYPE_AUTODOC)
                  {
                     type = checkentrytype(name);

                     if(type == XREFT_FUNCTION && strcmp(&name[strlen(name) - 2],"()"))
                        strcat(name,"()");
                  }

                  DB(("name     : %s\n",name));
                  DB(("nodename : %s\n",gd->gd_TempBuffer));

                  if(WriteXRefFileEntry(gd->gd_XRefFile,
                                        ENTRYA_Type      , type,
                                        ENTRYA_Name      , name,
                                        ENTRYA_File      , gd->gd_FileName,
                                        ENTRYA_NodeName  , gd->gd_TempBuffer,
                                        ENTRYA_CheckMode , ENTRYCHECK_FILE,
                                        TAG_DONE))
                  {
                     draw_info(gd,name,type);
                  }
               }
            }
      } else if(!strcmp(ptr,"TABLE OF CONTENTS\n"))
      {
         while(ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN))
         {

            draw_state(gd);

            while(*ptr == ' ' || *ptr == '\t')
               ptr++;

            if(*ptr == '\f')
               break;

            if(*ptr == '\n')
               continue;

            name = ptr;

            while(*ptr != EOS && *ptr != '\n')
               ptr++;

            *ptr = EOS;

            name = FilePart(name);

            type = checkentrytype(name);

            if(type == XREFT_FUNCTION && strcmp(&name[strlen(name) - 2],"()"))
               strcat(name,"()");

            if(WriteXRefFileEntry(gd->gd_XRefFile,
                                  ENTRYA_Type      ,type,
                                  ENTRYA_Name      ,name,
                                  ENTRYA_File      ,gd->gd_FileName,
                                  ENTRYA_NodeName  ,name,
                                  ENTRYA_CheckMode ,ENTRYCHECK_FILE,
                                  TAG_DONE))
            {
               draw_info(gd,name,type);
            }
         }
      }
   }
}
/*FE*/
/*FS*//*"void scan_amigaguide(struct GlobalData *gd)"*/
void scan_amigaguide(struct GlobalData *gd)
{
   STRPTR ptr;
   STRPTR name;
   ULONG type;

   while((ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      if(!Strnicmp(ptr,"@node",5))
      {
         ptr += 5;

         while(*ptr == ' ' || *ptr == '\t')
            ptr++;

         if(*ptr == '"')
            ptr++;

         name = ptr;

         while(*ptr != '"' && *ptr != ' ' && *ptr != '\t' && *ptr != '\n' && *ptr != ' ')
            ptr++;

         *ptr = EOS;

         type = checkentrytype(name);

         if(WriteXRefFileEntry(gd->gd_XRefFile,ENTRYA_Type     ,type,
                                               ENTRYA_File     ,gd->gd_FileName,
                                               ENTRYA_Name     ,name,
                                               ENTRYA_NodeName ,name,
                                               TAG_DONE))
         {
            draw_info(gd,name,type);
         }
      }
   }
}
/*FE*/
/*FS*/ /*"void scan_man(struct GlobalData *gd) "*/
void scan_man(struct GlobalData *gd)
{
   STRPTR ptr;
   STRPTR name;
   ULONG type;
   BOOL go = TRUE;
   BOOL eos;

   DB(("path : %s\n",gd->gd_FileName));

   while(go && (ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)) && !check_abort(gd))
   {
      if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
         draw_state(gd);

      while(*ptr == ' ' || *ptr == '\t')
         ptr++;

      if(!strcmp(ptr,"N\010NA\010AM\010ME\010E\n"))
      {
         while(*ptr != '-' && *ptr != EOS && (ptr = FGets(gd->gd_ReadFH,gd->gd_LineBuffer,BUFFER_LEN)))
         {
            while(*ptr != '-' && *ptr != EOS)
            {
               while(*ptr == ' ' || *ptr == '\t')
                  ptr++;

               name = gd->gd_TempBuffer;

               while(*ptr != ' ' && *ptr != '\t' && *ptr != '-' &&
                     *ptr != ',' && *ptr != '\n' && *ptr != EOS)
               {
                  if(ptr[1] == '\010')
                  {
                     ptr += 2;
                     *name++ = *ptr;
                  } else
                     *name++ = *ptr;
                  ptr++;
               }

               *name = EOS;
               name = gd->gd_TempBuffer;

               if(*ptr != '-')
               {
                  eos = FALSE;

                  if(*ptr == EOS)
                     eos = TRUE;
                  else
                     *ptr = EOS;

                  type = checkentrytype(name);

                  if(WriteXRefFileEntry(gd->gd_XRefFile,ENTRYA_Type     , type,
                                                        ENTRYA_Name     , name,
                                                        ENTRYA_File     , gd->gd_FileName,
                                                        ENTRYA_NodeName , mainstring,
                                                        TAG_DONE))
                  {
                     draw_info(gd,name,type);
                  }

                  if(!eos)
                     ptr++;
               }
            }
         }
         go = FALSE;
      }
   }
}
/*FE*/

/* ---------------------------- abort function ---------------------------- */

/*FS*/ /*"BOOL check_abort(struct GlobalData *gd)"*/
BOOL check_abort(struct GlobalData *gd)
{
   if(gd->gd_SWin.sw_Window)
   {
      struct IntuiMessage *msg;

      while((msg = (struct IntuiMessage *) GetMsg(gd->gd_SWin.sw_Window->UserPort)))
      {
         switch(msg->Class)
         {
         case IDCMP_CLOSEWINDOW:
            gd->gd_Abort = TRUE;
            break;
         case IDCMP_VANILLAKEY:
            /* check if ctrl-c or ecs was pressed ? */
            if(msg->Code == 3 || msg->Code == 27)
               gd->gd_Abort = TRUE;
            break;
         }
         ReplyMsg((struct Message *) msg);
      }

      if(gd->gd_Abort)
         draw_scanwindowstatus(&gd->gd_SWin,"aborted !");
   }

   gd->gd_Abort |= (SetSignal(0L,SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C);

   return(gd->gd_Abort);
}
/*FE*/

/* --------------------------- displays function --------------------------- */

/*FS*/ /*"void draw_info(struct GlobalData *gd,STRPTR entry,ULONG entrytype)"*/
void draw_info(struct GlobalData *gd,STRPTR entry,ULONG entrytype)
{
   gd->gd_Entries++;

   if(gd->gd_Workbench)
   {
      UBYTE buf[100];

      sprintf(buf,"%s (%s)",entry,etype[entrytype]);
      draw_scanwindowtext(&gd->gd_SWin,NUM_ENTRY,buf);
      sprintf(buf,"%ld",gd->gd_Entries);
      draw_scanwindowtext(&gd->gd_SWin,NUM_ENTRIES,buf);
   }
}
/*FE*/
/*FS*/ /*"void draw_state(struct GlobalData *gd)"*/
void draw_state(struct GlobalData *gd)
{
   if(gd->gd_Workbench || gd->gd_Para[ARG_VERBOSE])
   {
      ULONG current;
      ULONG acttotal;

      if(gd->gd_ReadFH)
      {
         current = Seek(gd->gd_ReadFH,0,OFFSET_CURRENT);
         acttotal = gd->gd_SStat.ss_ActTotalFileSize + current;
      } else
      {
         current = gd->gd_FileSize;
         acttotal = gd->gd_SStat.ss_ActTotalFileSize;
      }

      time_calc(&gd->gd_TimeCalc,acttotal,
                                 gd->gd_SStat.ss_TotalFileSize);

      if(gd->gd_Workbench)
      {
         draw_gauge(&gd->gd_SWin.sw_Actual,current,gd->gd_FileSize);
         draw_gauge(&gd->gd_SWin.sw_Total ,acttotal,
                                           gd->gd_SStat.ss_TotalFileSize);

         draw_scanwindowtime(&gd->gd_SWin,gd->gd_TimeCalc.tc_Secs);
      }
      {
         Printf ("\rScanning (%6ld/%6ld) , Time Exp. : %02ld:%02ld , Left : %02ld:%02ld",
                 current,gd->gd_FileSize,
                 gd->gd_TimeCalc.tc_Secs[TIME_EXPECTED] / 60,gd->gd_TimeCalc.tc_Secs[TIME_EXPECTED] % 60,
                 gd->gd_TimeCalc.tc_Secs[TIME_LEFT]     / 60,gd->gd_TimeCalc.tc_Secs[TIME_LEFT]     % 60);
      }
   }
}
/*FE*/

