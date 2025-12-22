;/* execute me to make with SAS 6.x
sc NOSTKCHK CSRC makeaguideindex.c OPT IGNORE=73
slink lib:c.o makeaguideindex.o //Goodies/extrdargs/extrdargs.o TO /c/makeaguideindex SMALLDATA SMALLCODE NOICONS LIB lib:amiga.lib lib:sc.lib /lib/xrefsupport.lib
quit
*/

/*
** $PROJECT: XRef-Tools
**
** $VER: makeaguideindex.c 1.3 (13.09.94) 
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
** 13.09.94 : 001.003 :  workbench support added
** 03.09.94 : 001.002 :  ctrl-c support added
** 17.07.94 : 001.001 : initial
*/

/* ------------------------------- include -------------------------------- */

#include "Def.h"

#include "/lib/xrefsupport.h"

#include "makeaguideindex_rev.h"

/* ------------------------------- defines -------------------------------- */

/*FS*/ /*"Defines"*/
#define BUFFER_SIZE     1024

#define TMP_FILE        "T:index.tmp"
#define TMP_FILE2       "T:guide.tmp"

#define LINE_UPDATE     50

#define EOS             '\0'
/*FE*/

/* ------------------------- structure definition ------------------------- */

/*FS*/ /*"Structures"*/
struct GlobalData
{
   APTR gd_Pool;
   BPTR gd_ReadFH;

   struct List gd_Entries;
   ULONG gd_MaxLength;
   ULONG gd_Number;
   BOOL gd_Abort;
   BOOL gd_Workbench;

   ULONG *gd_Para;
   STRPTR gd_ActualFile;
   STRPTR gd_MainFile;
   ULONG gd_FileSize;
   ULONG gd_Line;

   STRPTR gd_Object;
   UBYTE gd_Buffer[BUFFER_SIZE];
   UBYTE gd_TempBuffer[BUFFER_SIZE];

   struct ScanWindow gd_SWin;
   struct ScanStat gd_SStat;
   struct TimeCalc gd_TimeCalc;
};

struct Index
{
   struct Node Node;
   STRPTR Link;
};
/*FE*/

/* ------------------------------ prototypes ------------------------------ */

/*FS*/ /*"Prototypes"*/

RegCall LONG scan_file(REGA0 struct Hook *hook,REGA2 struct GlobalData *gd,REGA1 struct spMsg *msg);

void write_index(struct GlobalData *gd,STRPTR file);

void alloc_index(struct GlobalData *gd,STRPTR name,STRPTR link);
BOOL check_abort(struct GlobalData *gd);

void draw_state(struct GlobalData *gd);
/*FE*/

/* -------------------------- static data items --------------------------- */

/*FS*/ /*"Dataitems"*/
static const STRPTR version = VERSTAG;
static const STRPTR prgname = "MakeAGuideIndex";

static STRPTR displaytexts[] = {
   "IndexFile",
   "Dirs",
   "Files",
   "Dir",
   "File",
   "Entries",
   "Mode",
   NULL};

enum {
   NUM_INDEXFILE,
   NUM_DIRS,
   NUM_FILES,
   NUM_DIR,
   NUM_FILE,
   NUM_ENTRIES,
   NUM_MODE,
   };
/*FE*/

/* ------------------------- template definition -------------------------- */

/*FS*/ /*"Template"*/
#define template    "FILES/M/A,INDEXFILE/K,INCLINKS/S,FILEPART/S,NOLETTERS/S" \
                    "VERBOSE/S"

enum {
   ARG_FILES,
   ARG_INDEXFILE,
   ARG_INCLINKS,
   ARG_FILEPART,
   ARG_NOLETTERS,
   ARG_VERBOSE,
   ARG_MAX};
/*FE*/

/* ------------------------------- AutoDoc -------------------------------- */

/*FS*/ /*"AutoDoc"*/
/*GB*** XRef-Tools/MakeAGuideIndex *******************************************

$VER: MakeAGuideIndex.doc

NAME
    MakeAGuideIndex - generates an index file for some given AmigaGuide files

TEMPLATE
    FILES/M/A,INDEXFILE/K,INCLINKS/S,FILEPART/S,NOLETTERS/S

FORMAT
    MakeAGuideIndex [FILES] file [file2 [..]] [INDEXFILE idxfile] [INCLINKS]
                    [FILEPART] [NOLETTERS]

FUNCTION
    this command generates a index file or node for the given AmigaGuide
    files. If no INDEXFILE is specified the index is appended to the first
    AmigaGuide file.

INPUTS
    FILES (STRINGS) - AmigaGuide files to create index for. If no INDEXFILE
        is specified the generated index is append to the first file specified
        here

    INDEXFILE (STRING) - indexfile to create.

    INCLINKS (BOOLEAN) - if this switch is set, all links in the specified
        AmigaGuide files are included in the index.

    FILEPART (BOOLEAN) - if this switch is set, the index name is a part of
        the title of a node, which is calculated via FilePart() call. For
        example the title of a node is given as "XRef/My Title", a index
        is generated with the name "My Title".

    NOLETTERS (BOOLEAN) - if this switch is set, don't generate a initial
        letter line.

EXAMPLE
    MakeAGuideIndex myapp.guide INCLINKS FILEPART

    or

    MakeAGuideIndex myapp.guide INDEXFILE myapp.index INCLINKS FILEPART

SEE ALSO
    XRefConvert

COPYRIGHT
    (C) 1994 by Stefan Ruppert

HISTORY
    MakeAGuideIndex 1.3 (13.9.94) :
        - workbench support added

    MakeAGuideIndex 1.2 (3.9.94) :
        - ctrl-c support added

    MakeAGuideIndex 1.1 (17.7.94) :
        - created

*****************************************************************************/
/*FE*/

/* --------------------------- main entry point --------------------------- */

/*FS*/ /*"int main(int ac,char *av[]) "*/
int main(int ac,char *av[])
{
   struct ExtRDArgs eargs = {NULL};

   ULONG para[ARG_MAX];
   STRPTR obj = prgname;
   LONG err;

   LONG i;

   /* clear args buffer */
   for(i = 0 ; i < ARG_MAX ; i++)
      para[i] = 0;

   eargs.erda_Template      = template;
   eargs.erda_Parameter     = para;
   eargs.erda_FileParameter = 0;


   if((err = ExtReadArgs(ac,av,&eargs)) == 0)
   {
      struct GlobalData *gd;

      if(!(gd = AllocMem(sizeof(struct GlobalData), MEMF_ANY | MEMF_CLEAR)))
         err = ERROR_NO_FREE_STORE;
      else
      {
         NewList(&gd->gd_Entries);
         gd->gd_Para = para;

         if(!(gd->gd_Pool = LibCreatePool(MEMF_ANY | MEMF_CLEAR,BUFFER_SIZE,BUFFER_SIZE)))
            err = ERROR_NO_FREE_STORE;
         else
         {
            struct Hook scanfile_hook = {NULL};

            gd->gd_Para = para;
            scanfile_hook.h_Entry = (HOOKFUNC) scan_file;

            if(ac == 0)
            {
               gd->gd_Workbench = TRUE;
               open_scanwindow(&gd->gd_SWin,displaytexts,prgname,400);
               draw_scanwindowstatus(&gd->gd_SWin,"reading filelist ...");
            }

            getscanstat((STRPTR *) para[ARG_FILES],&gd->gd_SStat);

            /* double the filesize , because we scan each file twice */
            if(para[ARG_INCLINKS])
               gd->gd_SStat.ss_TotalFileSize *= 2;


            if(ac == 0)
            {
               draw_scanwindowstatus(&gd->gd_SWin,"scanning ...");
               if(para[ARG_INDEXFILE])
                  draw_scanwindowtext(&gd->gd_SWin,NUM_INDEXFILE,(STRPTR) para[ARG_INDEXFILE]);
               else
                  draw_scanwindowtext(&gd->gd_SWin,NUM_INDEXFILE,*((STRPTR *) para[ARG_FILES]));
            }

            /* init time service structure */
            time_init(&gd->gd_TimeCalc,LINE_UPDATE);

            err = scan_patterns((STRPTR *) para[ARG_FILES],&scanfile_hook,gd);

            gd->gd_Abort |= (err == ERROR_BREAK);

            time_calc(&gd->gd_TimeCalc,1,1);

            obj = gd->gd_Object;
            if(gd->gd_Abort)
            {
               err = ERROR_BREAK;
               obj = prgname;
            } else
               write_index(gd,(STRPTR) para[ARG_INDEXFILE]);

            LibDeletePool(gd->gd_Pool);

            close_scanwindow(&gd->gd_SWin,gd->gd_Abort);
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

/*FS*/ /*"LONG scan_file(struct Hook *hook,struct GlobalData *gd,struct spMsg *msg)"*/
RegCall LONG scan_file(REGA0 struct Hook *hook,REGA2 struct GlobalData *gd,REGA1 struct spMsg *msg)
{
   BPTR fh;

   switch(msg->Msg)
   {
   case SPM_DIR:

      gd->gd_SStat.ss_ActDirectories++;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"(%3ld/%3ld)",gd->gd_SStat.ss_ActDirectories,gd->gd_SStat.ss_Directories);
         draw_scanwindowtext(&gd->gd_SWin,NUM_DIRS,gd->gd_TempBuffer);

         draw_scanwindowtext(&gd->gd_SWin,NUM_DIR,msg->RealPath);
      } else if(gd->gd_Para[ARG_VERBOSE])
         Printf ("\rScanning dir (%3ld/%3ld) : %-40s\n",
                  gd->gd_SStat.ss_ActDirectories,
                  gd->gd_SStat.ss_Directories,
                  msg->RealPath);
      break;
   case SPM_FILE:
      gd->gd_SStat.ss_ActFiles++;

      if(gd->gd_SStat.ss_ActFiles == 1)
         gd->gd_MainFile = msg->Path;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"(%3ld/%3ld)",gd->gd_SStat.ss_ActFiles,gd->gd_SStat.ss_Files);

         draw_scanwindowtext(&gd->gd_SWin,NUM_FILES    ,gd->gd_TempBuffer);
         draw_scanwindowtext(&gd->gd_SWin,NUM_FILE     ,FilePart(msg->Path));
      } else if(gd->gd_Para[ARG_VERBOSE])
         Printf ("\rScanning file (%3ld/%3ld) : %s\n",
                 gd->gd_SStat.ss_ActFiles,
                 gd->gd_SStat.ss_Files,
                 msg->Path);

      gd->gd_Object = msg->RealPath;

      if((fh = msg->FHandle))
      {
         STRPTR ptr;
         STRPTR name;
         STRPTR link;

         gd->gd_ActualFile = msg->Path;
         gd->gd_FileSize   = msg->Fib->fib_Size;
         gd->gd_ReadFH     = fh;

         if(gd->gd_Workbench)
         {
            draw_gauge(&gd->gd_SWin.sw_Actual,0,0);
            draw_scanwindowtext(&gd->gd_SWin,NUM_MODE    ,"Scan @nodes");
         }

         while((ptr = FGets(fh,gd->gd_Buffer,BUFFER_SIZE)) && !check_abort(gd))
         {
            if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
               draw_state(gd);

            /* amigeguide node found ! */
            if(!Strnicmp(ptr,"@node",5))
            {
               STRPTR link  = ptr + 5;
               STRPTR title = ptr + 5;

               getamigaguidenode(&link,&title);

               /* cancel scan if index node is found */
               if(!Strnicmp(link,"index",5))
                  break;

               if(gd->gd_Para[ARG_FILEPART])
                  title = FilePart(title);

               if(gd->gd_Para[ARG_INDEXFILE])
               {
                  sprintf(gd->gd_TempBuffer,"%s/%s",gd->gd_ActualFile,link);
                  link = gd->gd_TempBuffer;
               }

               alloc_index(gd,title,link);

               continue;
            } else if(*ptr == '@')
            {
               continue;
            } else if(gd->gd_Para[ARG_INCLINKS])
            {
            }
         }

         /* scan inclinks after the @nodes to get the right link path
          * for the internal links 
          */
         if(gd->gd_Para[ARG_INCLINKS])
         {
            Seek(fh,0,OFFSET_BEGINNING);

            gd->gd_SStat.ss_ActTotalFileSize += msg->Fib->fib_Size;

            if(gd->gd_Workbench)
            {
               draw_gauge(&gd->gd_SWin.sw_Actual,0,0);
               draw_scanwindowtext(&gd->gd_SWin,NUM_MODE    ,"Scan links");
            }

            while((ptr = FGets(fh,gd->gd_Buffer,BUFFER_SIZE)) && !check_abort(gd))
            {
               if(!(++gd->gd_Line % gd->gd_TimeCalc.tc_Update))
                  draw_state(gd);

               while(*ptr != EOS)
               {
                  while(*ptr != '@' && *ptr != EOS)
                     ptr++;

                  if(*ptr == '@' && *(ptr+1) == '{')
                  {
                     ptr += 2;

                     while(*ptr == ' ' || *ptr == '\t')
                        ptr++;

                     if(*ptr == '"')
                     {
                        ptr++;
                        name = ptr;

                        while(*ptr != '"' && *ptr != EOS)
                           ptr++;

                        *ptr++ = EOS;

                        while(*ptr == ' ' || *ptr == '\t')
                           ptr++;

                        if(!Strnicmp(ptr,"link",4))
                        {
                           ptr += 4;

                           while(*ptr == ' ' || *ptr == '\t')
                              ptr++;

                           link = ptr;

                           while(*ptr != '}' && *ptr != EOS)
                              ptr++;

                           if(*ptr == '}')
                           {
                              *ptr++ = EOS;

                              alloc_index(gd,name,link);
                           }
                        }
                     }
                  } else
                     ptr++;
               }
            }
         }

      } else if(gd->gd_Para[ARG_INCLINKS])
         gd->gd_SStat.ss_ActTotalFileSize += msg->Fib->fib_Size;

      gd->gd_SStat.ss_ActTotalFileSize += msg->Fib->fib_Size;

      if(!gd->gd_Abort && gd->gd_Workbench)
      {
         draw_gauge(&gd->gd_SWin.sw_Actual,1,1);
         draw_gauge(&gd->gd_SWin.sw_Total ,gd->gd_SStat.ss_ActTotalFileSize,
                                           gd->gd_SStat.ss_TotalFileSize);
      }
      break;
   }

   if(gd->gd_Abort)
      return(ERROR_BREAK);

   return(0);
}
/*FE*/

/*FS*/ /*"void write_index(struct GlobalData *gd,STRPTR file) "*/
void write_index(struct GlobalData *gd,STRPTR file)
{
   BPTR fh;

   if(!file)
      file = TMP_FILE;

   if((fh = Open(file,MODE_NEWFILE)))
   {
      struct Index *idx;
      STRPTR name = NULL;
      UBYTE fmtbuf[30];

      sprintf(fmtbuf,"  @{\" %%-%lds\" Link %%s}\n",gd->gd_MaxLength);

      if(gd->gd_Para[ARG_INDEXFILE])
         FPrintf(fh,"@database %s/Index\n"
                    "@node main \"Index for %s\"\n"
                    "@toc %s/main\n",
                    gd->gd_MainFile,gd->gd_MainFile,gd->gd_MainFile);

      for(idx = (struct Index *) gd->gd_Entries.lh_Head ;
          idx->Node.ln_Succ ;
          idx = (struct Index *) idx->Node.ln_Succ)
      {
         if(!gd->gd_Para[ARG_NOLETTERS])
            if(!name || ToUpper(*name) != ToUpper(*idx->Node.ln_Name))
            {
               FPrintf(fh,"\n@{b}  %lc@{ub}\n\n",ToUpper(idx->Node.ln_Name[0]));
               name = idx->Node.ln_Name;
            }

         FPrintf(fh,fmtbuf,idx->Node.ln_Name,idx->Link);
      }

      if(gd->gd_Para[ARG_INDEXFILE])
         FPrintf(fh,"@endnode\n");

      Close(fh);

      if(!gd->gd_Para[ARG_INDEXFILE])
      {
         BPTR tfh;
         STRPTR ptr;

         if((tfh = Open(TMP_FILE2,MODE_NEWFILE)))
         {
            if((fh = Open(gd->gd_MainFile,MODE_OLDFILE)))
            {
               while((ptr = FGets(fh,gd->gd_Buffer,BUFFER_SIZE)))
               {
                  if(!Strnicmp(ptr,"@node index",11))
                     break;
                  FPuts(tfh,ptr);
               }
               Close(fh);

               if((fh = Open(TMP_FILE,MODE_OLDFILE)))
               {
                  FPrintf(tfh,"@node Index \"Index\"\n");
                  while((ptr = FGets(fh,gd->gd_Buffer,BUFFER_SIZE)))
                     FPuts(tfh,ptr);
                  FPrintf(tfh,"@endnode\n");
                  Close(fh);
               }
            }
            Close(tfh);

            if((tfh = Open(TMP_FILE2,MODE_OLDFILE)))
            {
               if((fh = Open(gd->gd_MainFile,MODE_NEWFILE)))
               {
                  ULONG len;
                  while((len = Read(tfh,gd->gd_Buffer,BUFFER_SIZE)))
                     Write(fh,gd->gd_Buffer,len);

                  Close(fh);
               }
               Close(tfh);
               DeleteFile(TMP_FILE2);
            }
         }
         DeleteFile(TMP_FILE);
      }
   }
}
/*FE*/

/* -------------------------- support functions --------------------------- */

/*FS*/ /*"void alloc_index(struct GlobalData *gd,STRPTR name,STRPTR link) "*/
void alloc_index(struct GlobalData *gd,STRPTR name,STRPTR link)
{
   struct Index *idx;
   ULONG namelen = strlen(name);
   ULONG size = sizeof(struct Index) + namelen + strlen(link) + 2;

   for(idx = (struct Index *) gd->gd_Entries.lh_Head ;
       idx->Node.ln_Succ ;
       idx = (struct Index *) idx->Node.ln_Succ)
      if(!Stricmp(idx->Node.ln_Name,name))
         return;

   if((idx = LibAllocPooled(gd->gd_Pool,size)))
   {
      D(bug("intern xref : %s\n",name));

      idx->Node.ln_Name = (STRPTR) (idx + 1);
      strcpy(idx->Node.ln_Name,name);
      idx->Link         = idx->Node.ln_Name + namelen + 1;
      strcpy(idx->Link,link);

      insertbyiname(&gd->gd_Entries,(struct Node *) idx);

      if(gd->gd_MaxLength < namelen)
         gd->gd_MaxLength = namelen;

      gd->gd_Number++;

      if(gd->gd_Workbench)
      {
         sprintf(gd->gd_TempBuffer,"%ld",gd->gd_Number);
         draw_scanwindowtext(&gd->gd_SWin,NUM_ENTRIES,gd->gd_TempBuffer);
      }
   }
}
/*FE*/
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

/* ---------------------------- draw functions ---------------------------- */

/*FS*/ /*"void draw_state(struct GlobalData *gd)"*/
void draw_state(struct GlobalData *gd)
{
   if(gd->gd_Workbench || gd->gd_Para[ARG_VERBOSE])
   {
      ULONG current  = Seek(gd->gd_ReadFH,0,OFFSET_CURRENT);
      ULONG acttotal = gd->gd_SStat.ss_ActTotalFileSize + current;

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

