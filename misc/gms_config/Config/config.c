/*
** Module:    Config.
** Authors:   Paul Manias & Peter Cahill.
** Copyright: DreamWorld Productions (c) 1998.  All rights reserved.
**
** --------------------------------------------------------------------------
** 
** TERMS AND CONDITIONS
** 
** This source code is made available on the condition that it is only used to
** further enhance the Games Master System.  IT IS NOT DISTRIBUTED FOR THE USE
** IN OTHER PRODUCTS.  Developers may edit and re-release this source code
** only in the form of its GMS module.  Use of this code outside of the module
** is not permitted under any circumstances.
** 
** This source code stays the copyright of DreamWorld Productions regardless
** of what changes or additions are made to it by 3rd parties.  A joint
** copyright can be granted if the 3rd party wishes to retain some ownership
** of said modifications.
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
**   + Implement SaveToFile() through use of the Config->Entry array.
**
** CHANGES
** -------
** -1998-
** 28 Jul Module started.
** 07 Aug All module functions successfully tested.
**
**        VERSION 2.1
** 30 Aug Fixed bug in leading/trailing spaces around the '=' sign of items.
**        Fixed buffer allocation bug.
** 11 Sep Items can now start with a number as the first character.
*/

#include <proto/dpkernel.h>
#include <desktop/all.h>
#include <system/all.h>
#include <misc/config.h>
#include <pragmas/strings_pragmas.h>
#include <pragmas/config_pragmas.h>
#include "defs.h"

/***********************************************************************************/

#define CONFIG_FIELDS 2

struct Field ConfigFields[CONFIG_FIELDS] = {
  { "Source", 12, FID_Source, FDF_SOURCE,    0, 0, NULL, NULL },
  { "Data",   16, FID_Data,   FDF_BYTEARRAY, 0, 0, NULL, NULL },
};

struct Function JumpTableV1[] = {
  { LIBReadConfig,    "ReadConfig(a0l,a1l,a2l)"    },
  { LIBReadConfigInt, "ReadConfigInt(a0l,a1l,a2l)" },
  { NULL, NULL }
};

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "September 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1998.  All rights reserved.";
BYTE ModName[]      = "Config";

/************************************************************************************
** Command:  Init()
**
** Called when our module is being opened for the first time.
*/

LIBFUNC LONG CMDInit(mreg(__a0) struct Module  *argModule,
                     mreg(__a1) struct DPKBase *argDPKBase,
                     mreg(__a2) struct GVBase  *argGVBase,
                     mreg(__d0) LONG argDPKVersion,
                     mreg(__d1) LONG argDPKRevision)
{
  DPKBase = argDPKBase;
  GVBase  = argGVBase;
  Public  = argModule->Public;
  CNFBase = argModule->ModBase;

  if ((argDPKVersion < DPKVersion) OR
     ((argDPKVersion IS DPKVersion) AND (argDPKRevision < DPKRevision))) {
     DPrintF("!Config:","This module requires V%d.%d of the dpkernel.library.",DPKVersion,DPKRevision);
  }
  else {
     if (FileMod = Get(ID_MODULE|GET_NOTRACK)) {
        FileMod->Number = MOD_FILES;
        if (Init(FileMod,NULL)) {
           FILBase = FileMod->ModBase;

           if (StrMod = Get(ID_MODULE|GET_NOTRACK)) {
              StrMod->Number = MOD_STRINGS;
              if (Init(StrMod,NULL)) {
                 STRBase = StrMod->ModBase;

                 if (ConfigObject = AddSysObjectTags(ID_CONFIG, ID_CONFIG, "Config",
                       TAGS, NULL,
                       SOA_FileExtension, "cnf;config",
                       SOA_FileDesc,      "Config File",
                       SOA_Free,          CON_Free,
                       SOA_Get,           CON_Get,
                       SOA_Init,          CON_Init,
                       SOA_Load,          CON_Load,
                       SOA_FieldArray,    ConfigFields,
                       SOA_FieldTotal,    CONFIG_FIELDS,
                       SOA_FieldSize,     sizeof(struct Field),
                       TAGEND)) {

                    return(ERR_OK);
                 }
              }
           }
        }
     }
  }

  FreeModule();
  return(ERR_FAILED);
}

/************************************************************************************
** Command:  Open()
**
** Called when our module is being opened for a second time...
*/

LIBFUNC LONG CMDOpen(mreg(__a0) struct Module *Module)
{
  if ((Module) AND (Public)) {
     Module->FunctionList = JumpTableV1;
     Public->OpenCount++;
     return(ERR_OK);
  }
  else return(ERR_FAILED);
}

/************************************************************************************
** Command:  Expunge()
** Synopsis: LONG Expunge(void);
**
** Called on expunge - if no program has us opened then we can give permission to
** have us shut us down.
**
*/

LIBFUNC LONG CMDExpunge(void)
{
  if (Public) {
     if (Public->OpenCount IS NULL) {
        FreeModule();
        return(ERR_OK); /* Okay to expunge */
     }
  }
  else DPrintF("!Config:","I have no Public base reference.");

  return(ERR_FAILED); /* Do not expunge */
}

/************************************************************************************
** Command:  Close()
** Synopsis: void Close(*Module [a0]);
*/

LIBFUNC void CMDClose(mreg(__a0) struct Module *Module)
{
  if (Public) Public->OpenCount--;
}

/************************************************************************************
** Internal: FreeModule()
** Short:    Frees any allocations made in the opening of our module.
*/

void FreeModule(void) {
  if (ConfigObject) { RemSysObject(ConfigObject); ConfigObject = NULL; }
  if (FileMod)      { Free(FileMod); FileMod = NULL; }
  if (StrMod)       { Free(StrMod);  StrMod  = NULL; }
}

/***********************************************************************************
** Function: ReadConfigInt()
** Synopsis: LONG ReadConfigInt(*Config [a0], BYTE *Section [a1], BYTE *Item [a2])
*/

LIBFUNC LONG LIBReadConfigInt(mreg(__a0) struct Config *Config,
                              mreg(__a1) BYTE *Section, mreg(__a2) BYTE *Item)
{
   LONG integer;
   BYTE *str;

   if ((Config IS NULL) OR (Section IS NULL) OR (Item IS NULL) OR (Config->Head.ID != ID_CONFIG)) {
      DPrintF("ReadInt()","Bad/NULL arguments.");
   }
   else {
      if (str = ReadConfig(Config,Section,Item)) {
         integer = StrToInt(str);
         return(integer);
      }
   }

   return(NULL);
}

/***********************************************************************************
** Function: ReadConfig()
** Synopsis: ReadConfig(*FileName, BYTE *Section, *Item)
** Short:    Returns a string pointing to the item data.
*/

LIBFUNC BYTE * LIBReadConfig(mreg(__a0) struct Config *Config, mreg(__a1) BYTE *Section,
                             mreg(__a2) BYTE *Item)
{
   LONG i;
   struct ConEntry *Entry;

   if (Item) {
      DPrintF("4ReadConfig()","Config: $%x, \"%s\", \"%s\"",Config,Section,Item);
   }
   else DPrintF("4ReadConfig()","Config: $%x, Array: \"%s\"",Config,Section);

   if ((Config IS NULL) OR (Section IS NULL) OR (Config->Head.ID != ID_CONFIG)) {
      DPrintF("!ReadConfig:","Bad arguments.");
      return(NULL);
   }

   if (Entry = Config->Entries) {
      for (i=Config->AmtEntries; i > 0; i--) {
         if (StrCompare(Section,Entry->Section,NULL,FALSE) IS TRUE) {
            if (Item) {
               if (StrCompare(Item,Entry->Item,NULL,FALSE) IS TRUE) {
                  return(Entry->Data);
               }
            }
            else return(Entry->Data);
         }
         Entry++;
      }

      if (Item)
         DPrintF("3ReadConfig:","Could not find item %s:%s.",Section,Item);
      else
         DPrintF("3ReadConfig:","Could not find array %s.",Section);
   }
   else DPrintF("!ReadConfig:","Corruption to Config->Entries (NULL).");

   return(NULL);
}

/**********************************************************************************/

#include "config_init.c"

