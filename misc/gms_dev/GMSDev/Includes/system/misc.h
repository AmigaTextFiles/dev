#ifndef SYSTEM_MISC_H
#define SYSTEM_MISC_H TRUE

/*
**  $VER: misc.h V2.1
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#ifndef FILES_FILES_H
#include <files/files.h>
#endif

/****************************************************************************
** Object Referencing structure.
*/

#define VER_REFERENCE  2
#define TAGS_REFERENCE ((ID_SPCTAGS<<16)|ID_REFERENCE)

struct Reference {
  struct Head Head;            /* [00] Standard header */
  struct Reference *Next;      /* [12] Next reference */
  struct Reference *Prev;      /* [16] Previous reference */
  WORD   ClassID;              /* [20] ID of the class */
  WORD   prvPad;               /* [22] */
  BYTE   *ClassName;           /* [24] Name of the class */
  BYTE   *ModName;             /* [28] Name of the module containing the object */
  struct Config   *prvConfig;  /* [32] Private */
  WORD   ModNumber;            /* [36] Module ID number */
  BYTE   *Extension;           /* [38] File extension string */
  struct Module   *Module;     /* [42] Set once the Module has been Init()ialised */
  struct DPKTask  *Task;       /* [46] The Task that Activate()ed the reference */
  struct FileName *ConfigFile; /* [50] Parameter source */
  BYTE   *FileHead;            /* [54] String to match the file header */
};

#define REFA_ClassID    (TWORD|20)
#define REFA_ClassName  (TAPTR|24)
#define REFA_ModName    (TAPTR|28)
#define REFA_ModNumber  (TWORD|36)
#define REFA_Extension  (TAPTR|38)
#define REFA_ConfigFile (TAPTR|50)
#define REFA_FileHead   (TAPTR|54)

/****************************************************************************
** Universal Structure, used in the CopyStructure() routine.
*/

#define VER_UNIVERSE  1
#define TAGS_UNIVERSE ((ID_SPCTAGS<<16)|ID_UNIVERSE)

struct Universe {
  struct Head Head;
  LONG   *Palette;
  WORD   Planes;
  WORD   Width;
  WORD   Height;
  WORD   InsideWidth;
  WORD   InsideByteWidth;
  WORD   InsideHeight;
  struct DPKTask *Task;
  LONG   Frequency;
  LONG   AmtColours;
  WORD   ScrMode;
  WORD   BmpType;
  APTR   Source;
  struct JoyData *JoyData;
  struct Raster  *Raster;
  WORD   XOffset;
  WORD   YOffset;
  WORD   InsideYOffset;
  WORD   InsideXOffset;
  WORD   Channel;
  WORD   Priority;
  LONG   Length;
  WORD   Octave;
  WORD   Volume;
  LONG   BmpFlags;
  BYTE   *Name;
  WORD   Gutter;
  WORD   Colour;
  WORD   Point;
};

#endif /* SYSTEM_MISC_H */
