/*
** Module:    Sound.
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
** + Support for Sound->Frequency.
**
** + WAVE Support - to be implemented as a child module (ie not in this
**   source code).
**
** CHANGES
** -------
** -1997-
** 27 Oct Replaced IFF body search with better one from Screens module.
**        Added support for CheckFile().
** 30 Oct Optimised the way audio channels are allocated from the OS.
**        Sound now supports Deactivate().
**        Edited too many parts to note!  Document the flags.
** 31 Oct Implemented SLEFT, SRIGHT, SFORCE.
**
** -1998-
** 29 Jan Added a Pair field for modulation.
** 14 Mar Removed the Sound->Header field.
** 18 Jul Moved precalculated arrays from asm to C.
**        Removed data=faronly from the SCOPTIONS file.
**        Added support for field orientation.
*/

#include <proto/dpkernel.h>
#include <system/all.h>
#include <dpkernel/prefs.h>
#include "defs.h"

/***********************************************************************************/

BYTE ModAuthor[]    = "Paul Manias";
BYTE ModDate[]      = "July 1998";
BYTE ModCopyright[] = "DreamWorld Productions (c) 1996-1998.  All rights reserved.";
BYTE ModName[]      = "Sound";

/***********************************************************************************/

struct Function JumpTableV1[] = {
  { LIBAllocSoundMem, "AllocSoundMem(d0l,d1l)" },
  { LIBStopAudio,     "StopAudio()"            },
  { LIBCheckSound,    "CheckSound(a0l)"        },
  { LIBFreeSoundMem,  "FreeSoundMem(d0l)"      },
  { LIBSetVolume,     "SetVolume(a0l,d0w)"     },
  { NULL, NULL }
};

/***********************************************************************************/

struct FieldDef AttribFlags[] = {
  { "BIT16",  0x00000001 }, { "MODVOL", 0x00000002 }, { "MODPER",   0x00000004 },
  { "REPEAT", 0x00000008 }, { "EMPTY",  0x00000010 }, { "LEFT",     0x00000020 },
  { "RIGHT",  0x00000040 }, { "FORCE",  0x00000080 }, { "STOPLAST", 0x00000100 },
  { NULL, NULL }
};

struct FieldDef SndOctave[] = {
  { "G0",   2  }, { "F0S",  4  }, { "F0",   6  }, { "E0",   8  },
  { "D0S", 10  }, { "D0",  12  }, { "C0S", 14  }, { "C0",  16  },
  { "B0",  18  }, { "A0S", 20  }, { "A0",  22  }, { "G1S", 24  },
  { "G1",  26  }, { "F1S", 28  }, { "F1",  30  }, { "E1",  32  },
  { "D1S", 34  }, { "D1",  36  }, { "C1S", 38  }, { "C1",  40  },
  { "B1",  42  }, { "A1S", 44  }, { "A1",  46  }, { "G2S", 48  },
  { "G2",  50  }, { "F2S", 52  }, { "F2",  54  }, { "E2",  56  },
  { "D2S", 58  }, { "D2",  60  }, { "C2S", 62  }, { "C2",  64  },
  { "B2",  66  }, { "A2S", 68  }, { "A2",  70  }, { "G3S", 72  },
  { "G3",  74  }, { "F3S", 76  }, { "F3",  78  }, { "E3",  80  },
  { "D3S", 82  }, { "D3",  84  }, { "C3S", 86  }, { "C3",  88  },
  { "B3",  90  }, { "A3S", 92  }, { "A3",  94  }, { "G4S", 96  },
  { "G4",  98  }, { "F4S", 100 }, { "F4",  102 }, { "E4",  104 },
  { "D4S", 106 }, { "D4",  108 }, { "C4S", 110 }, { "C4",  112 },
  { "B4",  114 }, { "A4S", 116 }, { "A4",  118 }, { "G5S", 120 },
  { "G5",  122 }, { "F5S", 124 }, { "F5",  126 }, { "E5",  128 },
  { "D5S", 130 }, { "D5",  132 }, { "C5S", 134 }, { "C5",  136 },
  { "B5",  138 }, { "A5S", 140 }, { "A5",  142 }, { "G6S", 144 },
  { "G6",  146 }, { "F6S", 148 }, { "F6",  150 }, { "E6",  152 },
  { "D6S", 154 }, { "D6",  156 }, { "C6S", 158 }, { "C6",  160 },
  { "B6",  162 }, { "A6S", 164 }, { "A6",  166 }, { "G7S", 168 },
  { "G7",  170 }, { "F7S", 172 }, { "F7",  174 }, { "E7",  176 },
  { "D7S", 178 }, { "D7",  180 }, { "C7S", 182 }, { "C7",  184 },
  { "B7",  186 }, { "A7S", 188 },
  { NULL, NULL }
};

#define SND_FIELDS 9

struct Field SoundFields[SND_FIELDS] = {
  { "Priority",  14, FID_Priority,  FDF_WORD|FDF_RANGE, 0, 1000, NULL, NULL },
  { "Data",      16, FID_Data,      FDF_BYTEARRAY,      0, 0,    NULL, NULL },
  { "Length",    20, FID_Length,    FDF_LONG,           0, 0,    NULL, NULL },
  { "Octave",    24, FID_Octave,    FDF_WORD|FDF_LOOKUP, 0, 1000, NULL, NULL }, 
  { "Volume",    26, FID_Volume,    FDF_WORD|FDF_RANGE, 0, 100,  NULL, NULL },
  { "Attrib",    28, FID_Attrib,    FDF_LONG|FDF_FLAGS, (LONG)AttribFlags, 0, NULL, NULL },
  { "Source",    32, FID_Source,    FDF_SOURCE,         0, 0,        NULL, NULL },
  { "Frequency", 36, FID_Frequency, FDF_LONG,           0, 0,        NULL, NULL },
  { "Pair",      40, FID_Sound,     FDF_OBJECT,         ID_SOUND, 0, NULL, NULL },
};

/************************************************************************************
** Command:  Init()
**
** Called when our module is being opened for the first time.
*/

LIBFUNC LONG CMDInit(mreg(__a0) LONG argModule,
                     mreg(__a1) LONG argDPKBase,
                     mreg(__a2) LONG argGVBase,
                     mreg(__d0) LONG argDPKVersion,
                     mreg(__d1) LONG argDPKRevision)
{
  APTR *Exec = (APTR *)4;

  DPKBase = (APTR)argDPKBase;
  GVBase  = (struct GVBase *)argGVBase;
  Public  = ((struct Module *)argModule)->Public;
  SysBase = Exec[0];
  FileMod = NULL;

  if ((argDPKVersion < DPKVersion) OR
     ((argDPKVersion IS DPKVersion) AND (argDPKRevision < DPKRevision))) {
     DPrintF("!Sound:","This module requires V%d.%d of the dpkernel.library.",DPKVersion,DPKRevision);
  }
  else {
     if (FileMod = Get(ID_MODULE|GET_NOTRACK)) {
        FileMod->Number = MOD_FILES;
        if (Init(FileMod,NULL)) {
           FILBase = FileMod->ModBase;

           if (SndObject = AddSysObjectTags(ID_SOUND, ID_SOUND, "Sound",
                 TAGS, NULL,
                 SOA_FileExtension, "iff;8svx;snd",
                 SOA_FileDesc,      "IFF Sound Sample",
                 SOA_Activate,      SND_Activate,
                 SOA_CheckFile,     SND_CheckFile,
                 SOA_Deactivate,    SND_Deactivate,
                 SOA_CopyToUnv,     SND_CopyToUnv,
                 SOA_CopyFromUnv,   SND_CopyFromUnv,
                 SOA_Free,          SND_Free,
                 SOA_Get,           SND_Get,
                 SOA_Init,          SND_Init,
                 SOA_Load,          SND_Load,
                 SOA_FieldArray,    SoundFields,
                 SOA_FieldTotal,    SND_FIELDS,
                 SOA_FieldSize,     sizeof(struct Field),
                 SOA_ClassVersion,  VER_SOUND,
                 TAGEND)) {
                 
              return(ERR_OK);
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
  else DPrintF("!Sound:","I have no Public base reference.");

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
**
** Frees any allocations made in the opening of our module.
*/

void FreeModule(void) {
  if (SndObject) {
     RemSysObject(SndObject);
     SndObject = NULL;
  }

  if (FileMod) {
     Free(FileMod);
     FileMod = NULL;
  }
}

/************************************************************************************
** Internal: FindHeader
** Synopsis: Chunk = FindHeader(FORM);
*/

APTR FindHeader(LONG *form, LONG ID)
{
   BYTE *endiff = (BYTE *)form;
   BYTE *bytetmp;

   if ((form[0] IS CODE_FORM) AND (ID != NULL)) {
      endiff += form[1] + 8;     /* Find the end */
      form   += 3;               /* Skip FORM/Size/ILBM */

      while (form < (LONG *)endiff) {
         if (form[0] IS ID) {
            return(form+2);
         }

         bytetmp = (BYTE *)form + form[1] + 8;
         form    = (LONG *)bytetmp;

         /* Check for an uneven offset, if detected then
         ** add an extra 1 to make it all even.
         */

         if ((LONG)form & 0x00000001) {
            form = (LONG *)((LONG)form + 1);
         }
      }
      DPrintF("FindHeader:","Failed to find IFF chunk $%x.",ID);
   }
   else ErrCode(ERR_ARGS);

   return(NULL);
}

#include "SND_CopyStructure.c"
#include "SND_Init.c"
#include "SND_Misc.c"
#include "LIB_Memory.c"

