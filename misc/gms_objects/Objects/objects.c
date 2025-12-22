/* Module:    Objects
** Author:    Paul Manias
** Copyright: DreamWorld Productions (c) 1996-1998.  All rights reserved.
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
**
** TO DO
** -----
** + PullObjects()
**     Grabs all objects matching a wildcard in their string, eg:
**
**     "BOB*"  to get objects like "BOB-Spinner"
**     "*BOB"  to get objects like "Spinner-BOB"
**     "BOB*1" to get objects like "BOB-Spinner1" and "BOB-Spot1"
*/

#include <proto/dpkernel.h>
#include <files/segments.h>
#include <files/objects.h>
#include <system/all.h>
#include <misc/config.h>

#include <pragmas/config_pragmas.h>
#include <pragmas/strings_pragmas.h>
#include <pragmas/objects_pragmas.h>

#include "defs.h"

/**********************************************************************************/

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "October 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1996-1998.  All rights reserved.";
BYTE ModName[]      = "Objects";

struct Function JumpTableV1[] = {
  { LIBPullObject,     "PullObject(a0l,a1l)"     },
  { LIBPullObjectList, "PullObjectList(a0l,a1l)" },
  { NULL, NULL }
};

/***********************************************************************************
** ObjectFile Definition
*/

#define OBJECTFILE_FIELDS 2

struct Field ObjectFileFields[OBJECTFILE_FIELDS] = {
  { "Source", 12, FID_Source, FDF_SOURCE, 0, 0, NULL, NULL },
  { "Config", 16, NULL,       FDF_OBJECT, ID_CONFIG, 0, NULL, NULL },
};

/***********************************************************************************
** Command: Init()
**
** Called when our module is being opened for the first time.
*/

LIBFUNC LONG CMDInit(mreg(__a0) LONG argModule,
                     mreg(__a1) LONG argDPKBase,
                     mreg(__a2) LONG argGVBase,
                     mreg(__d0) LONG argDPKVersion,
                     mreg(__d1) LONG argDPKRevision)
{
   DPKBase = (APTR)argDPKBase;
   GVBase  = (struct GVBase *)argGVBase;
   Public  = ((struct Module *)argModule)->Public;
   OBJBase = ((struct Module *)argModule)->ModBase;
   StrModule    = NULL;
   ConfigModule = NULL;
   OFObject     = NULL;

   if ((argDPKVersion < DPKVersion) OR ((argDPKVersion IS DPKVersion) AND (argDPKRevision < DPKRevision))) {
      DPrintF("!Objects:","This module requires V%d.%d of the dpkernel.library.",DPKVersion,DPKRevision);
      return(ERR_FAILED);
   }

   if (ConfigModule = Get(ID_MODULE|GET_NOTRACK)) {
      ConfigModule->Number = MOD_CONFIG;
      if (Init(ConfigModule, NULL)) {
         CNFBase = ConfigModule->ModBase;

         if (StrModule = Get(ID_MODULE|GET_NOTRACK)) {
            StrModule->Number = MOD_STRINGS;
            if (Init(StrModule, NULL)) {
               if (STRBase = StrModule->ModBase) {

                  if (OFObject = AddSysObjectTags(ID_OBJECTFILE,
                        ID_OBJECTFILE, "ObjectFile",
                        TAGS, NULL,
                        SOA_FileExtension, "obj;object;cnf;txt",
                        SOA_FileDesc,      "Object File",
                        SOA_Free,          OBJ_Free,
                        SOA_Get,           OBJ_Get,
                        SOA_Init,          OBJ_Init,
                        SOA_Load,          OBJ_Load,
                        SOA_FieldArray,    ObjectFileFields,
                        SOA_FieldTotal,    OBJECTFILE_FIELDS,
                        SOA_FieldSize,     sizeof(struct Field),
                        SOA_ClassVersion,  VER_OBJECTFILE,
                        SOA_ObjectSize,    sizeof(struct ObjectFile),
                        TAGEND)) {

                     return(ERR_OK);
                  }
               }
            }
         }
      }
   }

   FreeModule();
   return(ErrCode(ERR_FAILED));
}

/***********************************************************************************
** Free module allocations.
*/

void FreeModule(void) {
   if (OFObject)     { RemSysObject(OFObject); OFObject = NULL; }
   if (ConfigModule) { Free(ConfigModule); ConfigModule = NULL; }
}

/***********************************************************************************
** Command: Expunge()
** Short:   Called when the kernel makes an expunge request.
*/

LIBFUNC LONG CMDExpunge(void)
{
   if (Public) {
      if (Public->OpenCount IS NULL) {
         DPrintF("Objects:","Commencing self-expunge...");
         FreeModule();
         return(ERR_OK);
      }
   }
   else DPrintF("!Objects:","I have no Public reference, cannot allow an expunge.");

   return(ERR_FAILED);
}

/***********************************************************************************
** Command: Open()
** Short:   Called whenever our module is being opened.
*/

LIBFUNC LONG CMDOpen(mreg(__a0) struct Module *Module)
{
   Module->FunctionList = JumpTableV1;
   Public->OpenCount++;
   return(ERR_OK);
}

/***********************************************************************************
** Command: Close()
** Short:   Called when someone is closing our module.
*/

LIBFUNC void CMDClose(void)
{
   Public->OpenCount--;
}

#include "OBJ_ObjectFile.c"

