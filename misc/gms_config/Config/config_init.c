/************************************************************************************
** Action: Free()
** Object: Config
*/

LIBFUNC void CON_Free(mreg(__a0) struct Config *Config)
{
  if (Config->prvBuffer)  { FreeMemBlock(Config->prvBuffer);  }
  if (Config->prvEntries) { FreeMemBlock(Config->prvEntries); }
  Public->OpenCount--;
}

/************************************************************************************
** Action: Get()
** Object: Config
*/

LIBFUNC struct Config * CON_Get(mreg(__a0) struct Stats *Stats)
{
  struct Config *Config;

  if (Config = AllocMemBlock(sizeof(struct Config), MEM_RESOURCED|Stats->MemFlags)) {
     Config->Head.ID      = ID_CONFIG;
     Config->Head.Version = VER_CONFIG;
     Public->OpenCount++;
     return(Config);
  }
  else {
     ErrCode(ERR_FAILED);
     return(NULL);
  }
}

/************************************************************************************
** Action: Init()
** Object: Config
*/

LIBFUNC LONG CON_Init(mreg(__a0) struct Config *Config)
{
   OBJFile *File;
   struct ConEntry *Entry;
   WORD Array, Item, quote;
   BYTE *Data, *Buffer, *Temp, *EData, *ATemp, *AData;
   LONG i, line, items, FileSize, MaxLines, error;

   ATemp = NULL;
   AData = NULL;
   error = ERR_FAILED;

   if (File = Get(ID_FILE|GET_NOTRACK)) {
      File->Source = Config->Source;
      File->Flags  = FL_READ|FL_EXCLUSIVE;

      if (Init(File, NULL)) {
         if ((FileSize = GetFSize(File)) > 0) {
            if (AData = AllocPrivate(FileSize+2,MEM_UNTRACKED)) {
               Read(File, AData, FileSize);
               EData = AData + FileSize;
            }
            else goto exit;
         }
         else goto exit;
      }
      else goto exit;
   }
   else goto exit;

   DPrintF("3Config:","Data: $%x, EData: $%x, Size: %ld",AData,EData,FileSize);

   /* Process the file and get rid of PC carriage returns
   ** (by replacing them with standard line feeds).
   */

   MaxLines = 1;
   for (i=0; i < FileSize; i++) {
      if (AData[i] IS 10) {
         MaxLines++;
      }
      else if (AData[i] IS 13) {
         AData[i] = 10;
      }
   }

   /* Count the number of items to read */

   Data  = AData;
   items = NULL;
   while (Data < EData) {

      if (((*Data >= 'a') AND (*Data <= 'z')) OR
          ((*Data >= 'A') AND (*Data <= 'Z')) OR
          ((*Data >= '0') AND (*Data <= '9'))) {
         items++;
      }
      else if (*Data IS '=') {
         items++;
         while (*Data != '[') {
            while (*Data != 10) {
               Data++;
               if (Data >= EData) goto gotitems;
            }
            Data++;
            if (Data >= EData) goto gotitems;
         }
      }

      while (*Data != 10) {
         Data++;
         if (Data >= EData) goto gotitems;
      }
      Data++;
   }

gotitems:
   DPrintF("Config:","I detected %ld items and arrays in the file.",items);

   Config->AmtEntries = NULL;

   /**** Allocate the Buffers ***/

   if ((ATemp = AllocPrivate(200,MEM_UNTRACKED)) IS NULL) {
      ErrCode(ERR_MEMORY);
      goto exit;
   } 

   /* Buffer is allocated as:
   **
   **   Lines * (Longest Section Name + Longest Item Name + Longest Data)
   */

   if ((Config->prvBuffer = AllocMemBlock((40+40+80)*MaxLines, Config->Head.Stats->MemFlags)) IS NULL) {
      ErrCode(ERR_MEMORY);
      goto exit;
   }

   if ((Config->prvEntries = AllocMemBlock(sizeof(struct ConEntry) * items, Config->Head.Stats->MemFlags)) IS NULL) {
      ErrCode(ERR_MEMORY);
      goto exit;
   }

   DPrintF("3Config:","Temp: $%x, Buffer: $%x, Entries: $%x",ATemp,Config->prvBuffer,Config->Entries);

   /*** Process now ***/

   Config->Entries = Config->prvEntries;
   Data   = AData;
   Buffer = Config->prvBuffer;
   Entry  = Config->Entries;
   line   = 1;

   /*** Find the first section ***/

   while (*Data != '[') {
      if (*Data IS 10) line++;
      Data++;
      if (Data >= EData) {
         DPrintF("!Config:","There are no Sections defined in this file!");
         goto exit;
      }
   }

   DPrintF("3Config:","First section found at line %ld.",line);

   /*** FILE PROCESSOR ***/

   while (Data < EData) {
      Array = FALSE;
      Item  = FALSE;
      while (*Data != '[') {

         /*** Item check (Must start with a letter or number) ***/

         if (((*Data >= 'a') AND (*Data <= 'z')) OR
             ((*Data >= 'A') AND (*Data <= 'Z')) OR
             ((*Data >= '0') AND (*Data <= '9'))) {

            if (Array IS FALSE) {
               Item = TRUE;

               /*** Skip the section header that's in temp buffer ***/

               Temp = ATemp;
               while (*Temp != NULL) Temp++;
               Temp++;

               /*** Insert name of the Item just after the Section ***/

               while ((*Data != '=') AND (*Data != ' ') AND (*Data != 10)) {
                  *Temp++ = *Data++;
                  if (Data >= EData) goto okay;
               }
               *Temp = NULL;

               while (*Data IS ' ') { /* Skip past trailing spaces */
                  Data++;
                  if (Data >= EData) goto okay;
               }

               /* Did an equal sign follow the Item name?  If not,
               ** then there is an error at this line.
               */

               if (*Data IS '=') {
                  Data++;
                  if (Data >= EData) goto okay;

                  while (*Data IS ' ') { /* Skip any leading spaces */
                     Data++;
                     if (Data >= EData) goto okay;
                  }

                  if (*Data > 10) {

                     /*** Insert Section name ***/

                     Temp = ATemp;
                     Entry->Section = Buffer;
                     while (*Temp != NULL) {
                        *Buffer++ = *Temp++;
                     }
                     *Buffer++ = NULL;

                     /*** Insert Item name ***/

                     Temp++;
                     Entry->Item = Buffer;
                     while (*Temp != NULL) {
                        *Buffer++ = *Temp++;
                     }
                     *Buffer++ = NULL;

                     /* Insert the Item data.  This section also looks out
                     ** for strings that have been defined using quotes (").
                     ** These are forcibly removed.
                     */

                     if (*Data IS '"') { Data++; quote = TRUE; } else quote = FALSE;
                     Entry->Data = Buffer;
                     while ((Data < EData) AND (*Data != 10)) {
                        *Buffer++ = *Data++;
                     }
                     if (quote IS TRUE) {
                        if (Buffer[-1] IS '"') Buffer[-1] = NULL; else *Buffer++ = NULL;
                     }
                     else *Buffer++ = NULL;

                     DPrintF("4Config:","Successfully read %s:%s.",Entry->Section,Entry->Item);
                     Entry++; items--;
                     Config->AmtEntries++;
                     if (items IS NULL) goto okay;
                  }
                  else DPrintF("!Config:","Bad Item at line %ld.",line);
               }
               else DPrintF("!Config:","Bad Item at line %ld.",line);
            }
            else DPrintF("!Config:","Item found in array section at line %ld.",line);

            if (Data >= EData) goto okay;

            while (*Data != 10) {
               Data++;
               if (Data >= EData) goto okay;
            }
            line++;
         }

         /*** Section holds array data ***/

         else if (*Data IS '=') {
            if (Item IS FALSE) {
               Data++;
               if (Data >= EData) {
                  DPrintF("!Config:","Bad array definition at line %ld.",line);
                  goto okay;
               }

               /*** INSERT INITIAL SECTION/ITEM INFORMATION ***/

               if (Array IS FALSE) {
                  Temp = ATemp;
                  Entry->Section = Buffer;
                  while (*Temp != NULL) {
                     *Buffer++ = *Temp++;
                  }
                  *Buffer++ = NULL;

                  Entry->Item = NULL;   /* Item Name of NULL */
                  Entry->Data = Buffer;
                  Array = TRUE;
               }

               /*** INSERT DATA ***/

               if (*Data > 10) {
                  while ((Data < EData) AND (*Data != 10)) {
                     *Buffer++ = *Data++;
                  }
               }
               else DPrintF("!Config:","Bad array definition at line %ld.",line);
            }
            else DPrintF("!Config:","Array found in Item section at line %ld.",line);

            if (Data >= EData) goto okay;

            while (*Data != 10) {
               Data++;
               if (Data >= EData) goto okay;
            }
            line++;
         }
         else if (*Data IS 10) line++;

         Data++;
         if (Data >= EData) break;
      }

      /* If the last section, was an array, we
      ** must complete it here.
      */

      if (Array IS TRUE) {
         Array = FALSE;
         DPrintF("4Config:","Successfully read array %s.",Entry->Section);
         *Buffer++ = NULL;
         Config->AmtEntries++;
         Entry++;
         items--;
         if (items IS NULL) goto okay;
      }

      /*** NEW SECTION ***/

      if (Data < EData) {
         Temp = ATemp;
         Data++;
         if (Data >= EData) goto okay;
         while ((*Data != ']') AND (*Data != 10)) {
            *Temp++ = *Data++;
            if (Data >= EData) {
               DPrintF("!Config:","Bad section definition at line %ld.",line);
               goto okay;
            }
         }
         *Temp = NULL;

         DPrintF("4Config:","Found section \"%s\".",ATemp);

         while (*Data != 10) {
            Data++;
            if (Data >= EData) goto okay;
         }

         line++;
         Data++;
      }
   }

okay:
   error = ERR_OK;
   if (Array IS TRUE) {
      DPrintF("4Config:","Successfully read array %s.",Entry->Section);
      *Buffer = NULL;
      Config->AmtEntries++;
   }

   DPrintF("Config:","End of file reached, %ld lines read.",line);

exit:
   if (File)  Free(File);
   if (ATemp) FreeMemBlock(ATemp);
   if (AData) FreeMemBlock(AData);
   return(error);
}

/************************************************************************************
** Action: Load()
** Object: Config
*/

LIBFUNC struct Config * CON_Load(mreg(__a0) struct File *Source)
{
  return(InitTags(NULL,
    TAGS_CONFIG, NULL,
    CFA_Source,  Source,
    TAGEND));
}

