/*
** $PROJECT: XRef-Tools
**
** $VER: aguidexref.c 1.1 (07.08.94)
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
** 07.08.94 : 001.001 :  initial
*/

/* ---------------------------- version string ---------------------------- */

/*FS*/ /*"Constants"*/

char *version = VERSTAG;
char *xreftypes[] = {
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

/* -------------------------- support functions --------------------------- */

/*FS*//*"STRPTR tmpname(struct GlobalData *gd)"*/
STRPTR tmpname(struct GlobalData *gd)
{
   sprintf(gd->gd_FileBuffer,"T:ag_%lx%ld.guide",FindTask(NULL),++gd->gd_TempCount);
   return(gd->gd_FileBuffer);
}
/*FE*/
/*FS*/ /*"void getstdargs(struct GlobalData *gd,ULONG *para) "*/
void getstdargs(struct GlobalData *gd,ULONG *para)
{
   UWORD linelength = 78;
   UWORD columns    = 2;
   ULONG limit      = ~0;

   /* try to get the defaults from the library */
   GetXRefBaseAttrs(XREFBA_DefaultLimit,&limit,
                    XREFBA_LineLength  ,&linelength,
                    XREFBA_Columns     ,&columns,
                    TAG_DONE);

   /* set given values */
   gd->gd_Matching = XREFMATCH_PATTERN_CASE;

   if(para[ARG_NOPATTERN])
      if(para[ARG_NOCASE])
         gd->gd_Matching = XREFMATCH_COMPARE_NOCASE;
      else
         gd->gd_Matching = XREFMATCH_COMPARE_CASE;
   else
      if(para[ARG_NOCASE])
         gd->gd_Matching = XREFMATCH_PATTERN_NOCASE;

   gd->gd_Num        = -1;
   gd->gd_LineLength = (para[ARG_LINELENGTH]) ? (*((ULONG *) para[ARG_LINELENGTH])) : linelength;
   gd->gd_Columns    = (para[ARG_COLUMNS]   ) ? (*((ULONG *) para[ARG_COLUMNS])   ) : columns;
   gd->gd_Chars      = gd->gd_LineLength / gd->gd_Columns;

   gd->gd_LastEntry.e_Type = -1;

   gd->gd_Limit      = (para[ARG_LIMIT]) ? (*((LONG *) para[ARG_LIMIT])) : limit;
   gd->gd_XRefFile   = (STRPTR) para[ARG_FILE];

   if(para[ARG_CATEGORY])
      strcpy(gd->gd_Category,(STRPTR) para[ARG_CATEGORY]);

   if(para[ARG_STRING])
      strcpy(gd->gd_String  ,(STRPTR) para[ARG_STRING]);
   else
      strcpy(gd->gd_String  ,"");

   gd->gd_Para     = para;
}
/*FE*/

/* --------------------------- parse hook entry --------------------------- */

/*FS*/ /*"RegCall GetA4 ULONG aguidehook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg) "*/
RegCall GetA4 ULONG aguidehook(REGA0 struct Hook *hook,REGA2 struct XRefFileNode *xref,REGA1 struct xrmXRef *msg)
{
   struct GlobalData *gd = (struct GlobalData *) hook->h_Data;

   if(msg->Msg == XRM_XREF)
   {
      struct TagItem *tstate = msg->xref_Attrs;
      struct TagItem *tag;

      ULONG tidata;

      struct Entry *entry;

      if((entry = LibAllocPooled(gd->gd_Pool,sizeof(struct Entry))))
      {
         entry->e_Line = 0;

         while((tag = NextTagItem(&tstate)))
         {
            tidata = tag->ti_Data;
         
            switch(tag->ti_Tag)
            {
            case ENTRYA_Type:
               entry->e_Type = tidata;
               break;
            case ENTRYA_File:
               entry->e_File = (STRPTR) tidata;
               entry->e_Node.ln_Name = (STRPTR) tidata;
               break;
            case ENTRYA_Name:
               entry->e_Name = (STRPTR) tidata;
               break;
            case ENTRYA_Line:
               entry->e_Line = tidata;
               break;
            case ENTRYA_NodeName:
               entry->e_NodeName = (STRPTR) tidata;
               break;
            case XREFA_Path:
               entry->e_Path = (STRPTR) tidata;
               break;
            }
         }

         if(entry->e_Name && entry->e_File && entry->e_Type < XREFT_MAXTYPES)
         {
            gd->gd_Num++;
            insertbyname(&gd->gd_EntryList,(struct Node *) entry);
         } else
            LibFreePooled(gd->gd_Pool,entry,sizeof(struct Entry));
      }
   } else
      FPrintf (gd->gd_FileHandle,"Not supported hook message : %ld\n",msg->Msg);

   return(0);
}
/*FE*/
/*FS*//*"BOOL parsexref(struct GlobalData *gd)"*/
BOOL parsexref(struct GlobalData *gd)
{
   STRPTR file = NULL;

   gd->gd_Object = prgname;

   /* if a cachedirectory is given , build the full path */
   if(gd->gd_Para[ARG_CACHEDIR])
   {
      /* check if there exists a file with contents of gd->gd_String */

      strcpy(gd->gd_FileBuffer,(STRPTR) gd->gd_Para[ARG_CACHEDIR]);
      if(AddPart(gd->gd_FileBuffer,(STRPTR) gd->gd_String,PATH_LEN))
      {
         BPTR lock;

         if(!(lock = Lock(gd->gd_FileBuffer,SHARED_LOCK)))
            file = gd->gd_FileBuffer;  /* set the filename to create the amigaguide */
         else
            UnLock(lock);
      }
   } else
     file = tmpname(gd);


   DB(("file : %s\n",file));
   
   if(file)
   {
      BPTR fh;

      if((fh = Open(file,MODE_NEWFILE)))
      {
         struct Hook hook = {NULL};
         UWORD column   = gd->gd_Columns;

         gd->gd_FileHandle = fh;

         if(SysBase->lib_Version < 40)
            column = 1;

         hook.h_Entry = (HOOKFUNC) aguidehook;
         hook.h_Data  = gd;

         FPrintf(fh,"@database %s\n\n"
                    "@node main \"%s\"\n"
                    "@toc xref.library_xreffile@main\n"
                    "@tab %ld\n",prgname,prgname,gd->gd_Chars);

         /* enable the xref.library dynamic node */
         AddXRefDynamicNode();

         gd->gd_Num = 0;

         DB(("string : %s\n",gd->gd_String));

         if(strlen(gd->gd_String) > 0)
            if((gd->gd_Pool = LibCreatePool(MEMF_CLEAR | MEMF_ANY,PUDDLE_SIZE,TRESH_SIZE)))
            {
               NewList(&gd->gd_EntryList);

               if(ParseXRefTags(gd->gd_String,
                                XREFA_Category  ,(gd->gd_Category[0]) ? gd->gd_Category : NULL,
                                XREFA_File      ,gd->gd_XRefFile,
                                XREFA_Matching  ,gd->gd_Matching,
                                XREFA_XRefHook  ,&hook,
                                XREFA_Limit     ,gd->gd_Limit,
                                TAG_DONE))
               {
                  struct Entry *entry;
                  STRPTR lastfile = NULL;
                  UWORD actcol = 0;

                  if(gd->gd_Num == 0)
                     DisplayBeep(gd->gd_Screen);
                  else if(gd->gd_Num == 1)
                     gd->gd_LastEntry = *((struct Entry *) gd->gd_EntryList.lh_Head);
                  else
                     for(entry = (struct Entry *) gd->gd_EntryList.lh_Head ;
                         entry->e_Node.ln_Succ ;
                         entry = (struct Entry *) entry->e_Node.ln_Succ)
                     {

                        /* write next file */
                        if(lastfile != entry->e_File)
                        {
                           lastfile = entry->e_File;
                           if(actcol)
                              FPutC(fh,'\n');

                           FPrintf(fh,"\nFile : @{fg highlight}%s@{fg text}\n\n",(STRPTR) lastfile);
                           actcol = 0;
                        }

                        /* write the entry with the link to the documentation */
                        FPrintf(fh,"@{\"%s\" link \"%s%s/%s\" %ld}\t",
                                   entry->e_Name,
                                   entry->e_Path,
                                   entry->e_File,
                                   entry->e_NodeName,
                                   entry->e_Line);

                        if((++actcol == column) || !entry->e_Node.ln_Succ)
                        {
                           actcol = 0;
                           FPutC(fh,'\n');
                        }
                     }

                  LibDeletePool(gd->gd_Pool);
               }
            }
         FPrintf(fh,"\n@endnode\n");
         Close(fh);

         /* delete cache file, if none or only one entry is found */
         if(gd->gd_Para[ARG_CACHEDIR] && gd->gd_Num < 2)
            DeleteFile(gd->gd_FileBuffer);
      }
   }

   return(TRUE);
}
/*FE*/

