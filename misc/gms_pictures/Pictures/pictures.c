/*
** Module:    Pictures.
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
** If you want to add support for picture files like BMP, PCX, JPG
** or GIF then you need to create a child module such as "pictures_pcx.mod".
** This involves cloning this module and then making some modifications
** to the AddSysObject() part, plus creating a suitable reference file (see
** GMSDev:Source/References/pictures.ref for an example).  You can remove
** support for almost all the actions, but must write code for Init(),
** CheckFile() and Query().  If you want to save pictures in the file format,
** write code for SaveToFile() as well.
**
** This isn't too hard so long as you have *read the autodocs*.  For any
** quesions or help in doing this, send me an e-mail.
**
** CHANGES
** -------
** -1997-
** 13 Jul Removed the UnpackPic() function from public use.
** 29 Jul Removed GetPicInfo(), replaced with Query().
**        We are no longer remapping the kernel (100% object oriented).
** 03 Aug Moved module over to C.
**        Converted CopyToUnv(), CopyFromUnv().
** 17 Sep Moved Write(), Read(), Load() and CheckFile() over to C.
**        Moved SetPicViewMode(), SetPicColours(), SetPicPlanes(),
**         SetPicDimensions(), Query(), Init() over to C.
** 03 Oct Updated more parts to C code.
**        Created C version of IFF chunk searching routine.
**
** -1998-
** 08 Jan Removed Palette field, now inherited from Bitmap.
**        No longer interfering with palettes.
** 29 Jan Load(Picture) no longer stores the data in video memory.
** 03 May Totally re-wrote the picture unpacking, resizing and remapping.
** 31 May Added field orientation support.
** 21 Jun Added support for loading a picture in chunks, and body data is
**        now loaded in sets of 8kb rather than trying to read it all at once.
**        Module is now compiled with neardata option for SAS/C.
** 04 Jul Fixed bug in SkipLine(), it was not skipping all the bitplanes.
** 20 Aug Query() now queries the Picture->Bitmap instead of initialising it.
** 01 Sep Added faster pixel processing by using the Bitmap's internal pixel
**         functions (e.g. Bitmap->DrawPixel()).
** 03 Sep Picture->Init() will now initialise the child Bitmap instead of
**        only querying it.
*/

#include <proto/dpkernel.h>
#include <system/all.h>
#include <dpkernel/prefs.h>
#include "defs.h"

/**********************************************************************************/

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "October 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1996-1998.  All rights reserved.";
BYTE ModName[]      = "Pictures";

/***********************************************************************************
** Picture Definition
*/

struct FieldDef OptionFlags[] = {
  { "RESIZEX", 0x00000001 }, { "REMAP", 0x00000004 }, { "RESIZEY", 0x00000008 },
  { NULL, NULL }
};

struct FieldDef ScrFlags[] = {
  { "HIRES", 0x00000001 }, { "SHIRES", 0x00000002 }, { "LACED", 0x00000004 },
  { "LORES", 0x00000008 }, { "SLACED", 0x00000010 },
  { NULL, NULL }
};

#define PIC_FIELDS 6

struct Field PictureFields[PIC_FIELDS] = {
  { "Bitmap",    12, FID_Bitmap,    FDF_CHILD,          ID_BITMAP, 0,          NULL, NULL },
  { "Options",   16, FID_Flags,     FDF_LONG|FDF_FLAGS, (LONG)&OptionFlags, 0, NULL, NULL },
  { "Source",    20, FID_Source,    FDF_SOURCE,         0, 0,                  NULL, NULL },
  { "ScrMode",   24, FID_ScrMode,   FDF_WORD|FDF_FLAGS, (LONG)&ScrFlags, 0,    NULL, NULL }, 
  { "ScrHeight", 26, FID_ScrHeight, FDF_WORD|FDF_RANGE, 0, 2560,               NULL, NULL },
  { "ScrWidth",  28, FID_ScrWidth,  FDF_WORD|FDF_RANGE, 0, 2560,               NULL, NULL },
};

/***********************************************************************************
** Command: Init()
** Short:   Called when our module has been loaded for the first time.  Any
**          allocations made here will need to be freed in the FreeModule()
**          function.
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

  if ((argDPKVersion < DPKVersion) OR
     ((argDPKVersion IS DPKVersion) AND (argDPKRevision < DPKRevision))) {
     DPrintF("!Pictures:","This module requires V%d.%d of the dpkernel.library.",DPKVersion,DPKRevision);
     return(ERR_FAILED);
  }

  if (!(PicObject = AddSysObjectTags(ID_PICTURE, ID_PICTURE, "Picture",
        TAGS, NULL,
        SOA_FileExtension, "iff;ilbm;pic",
        SOA_FileDesc,      "IFF Picture",
        SOA_CheckFile,     PIC_CheckFile,
        SOA_CopyToUnv,     PIC_CopyToUnv,
        SOA_CopyFromUnv,   PIC_CopyFromUnv,
        SOA_Free,          PIC_Free,
        SOA_Get,           PIC_Get,
        SOA_Init,          PIC_Init,
        SOA_Load,          PIC_Load,
        SOA_Query,         PIC_Query,
        SOA_Read,          PIC_Read,
        SOA_SaveToFile,    PIC_SaveToFile,
        SOA_Seek,          PIC_Seek,
        SOA_Write,         PIC_Write,
        SOA_FieldArray,    PictureFields,
        SOA_FieldTotal,    PIC_FIELDS,
        SOA_FieldSize,     sizeof(struct Field),
        SOA_ObjectSize,    sizeof(struct Picture),
        SOA_ClassVersion,  VER_PICTURE
        TAGEND))) {
     FreeModule();
     return(ERR_FAILED);
  }

  return(ERR_OK);
}

/***********************************************************************************
** Command: Open()
** Short:   Called when our module is being opened (from an Init(Module)).
*/

LIBFUNC LONG CMDOpen(mreg(__a0) struct Module *Module)
{
  Module->FunctionList = NULL;
  Public->OpenCount++;
  return(ERR_OK);
}

/***********************************************************************************
** Command:  Expunge()
** Synopsis: LONG Expunge(void);
** Short:    Called on expunge - if no program has us opened then we can give
**           permission to have us shut down.
*/

LIBFUNC LONG CMDExpunge(void)
{
  if (Public) {
     if (Public->OpenCount IS NULL) {
        FreeModule();
        return(ERR_OK); /* Okay to expunge */
     }
  }
  else DPrintF("!Pictures:","I have no Public base reference.");

  return(ERR_FAILED); /* Do not expunge */
}

/***********************************************************************************
** Command:  Close()
** Synopsis: void Close(*Module [a0]);
** Short:    Called whenever someone is closing a link to our module.
*/

LIBFUNC void CMDClose(mreg(__a0) struct Module *Module)
{
  if (Public) Public->OpenCount--;
}

/***********************************************************************************
** Internal: FreeModule()
**
** Frees any allocations made in the opening of our module.
*/

void FreeModule(void)
{
  if (PicObject) RemSysObject(PicObject);
}

/***********************************************************************************
** Action: SaveToFile()
** Object: Picture
*/

LIBFUNC LONG PIC_SaveToFile(mreg(__a0) struct Picture *Picture, mreg(__a1) struct File *File)
{
  return(SaveToFile(Picture->Bitmap,(APTR)File,NULL));
}

