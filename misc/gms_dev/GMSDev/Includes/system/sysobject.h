#ifndef SYSTEM_SYSOBJECT_H
#define SYSTEM_SYSOBJECT_H TRUE

/*
**  $VER: sysobject.h
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** The SysObject structure.
*/

#define VER_SYSOBJECT  2
#define TAGS_SYSOBJECT ((ID_SPCTAGS<<16)|ID_SYSOBJECT)

struct SysObject {
  struct Head Head;
  struct SysObject *Prev;  /* Previous object in list */
  struct SysObject *Next;  /* Next object in list */
  WORD   ObjectID;         /* ID of this object, eg ID_PICTURE if master, or ID_HIDDEN if child */
  WORD   ClassID;          /* Class reference ID, use ID_HIDDEN if no class */
  BYTE   *Name;            /* Standard name of the object, eg "Picture", "Universe"... */
  LIBPTR LONG  (*CopyToUnv)(mreg(__a0) struct Universe *, mreg(__a1) struct Head *);
  LIBPTR LONG  (*CopyFromUnv)(mreg(__a0) struct Universe *, mreg(__a1) struct Head *);
  LIBPTR WORD  (*CheckFile)(mreg(__a0) struct File *, mreg(__a1) APTR Buffer);
  LIBPTR struct Head * (*Load)(mreg(__a0) struct File *);
  LIBPTR LONG  (*Show)(mreg(__a0) APTR Object);
  LIBPTR struct Head * (*Get)(mreg(__a0) APTR);
  LIBPTR void  (*Free)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Init)(mreg(__a0) APTR Object, mreg(__a1) APTR Container);
  LIBPTR LONG  (*Read)(mreg(__a0) APTR Object, mreg(__a1) APTR Buffer, mreg(__d0) LONG Length);
  LIBPTR LONG  (*Write)(mreg(__a0) APTR Object, mreg(__a1) APTR Buffer, mreg(__d0) LONG Length);
  LIBPTR LONG  (*Rename)(mreg(__a0) APTR Object, mreg(__a1) BYTE *Name);
  LIBPTR void  (*Hide)(mreg(__a0) APTR Object);
  LIBPTR void  (*yy03)(void);
  LIBPTR LONG  (*SaveToFile)(mreg(__a0) APTR Object, mreg(__a1) struct File *DestFile);
  LIBPTR LONG  (*Query)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Activate)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Deactivate)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Draw)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Clear)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Reset)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*Flush)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*TagTrigger)(mreg(__a0) LONG *TagPos, mreg(__a1) struct Head *);
  struct SysObject *Master;
  struct Field *FieldArray;
  LIBPTR void  (*Unlock)(mreg(__a0) APTR Object);
  LIBPTR LONG  (*DetachParent)(mreg(__a0) APTR Child, mreg(__a1) APTR Parent);
  LIBPTR LONG  (*DetachChild)(mreg(__a0) APTR Child, mreg(__a1) APTR Parent);
  LIBPTR LONG  (*Unhook)(mreg(__a0) APTR Object, mreg(__a1) APTR Chain);
  LIBPTR void  (*MoveToBack)(mreg(__a0) APTR Object);
  LIBPTR void  (*MoveToFront)(mreg(__a0) APTR Object);
  BYTE   *FileExtension;
  BYTE   *FileDesc;
  LIBPTR LONG  (*Copy)(mreg(__a0) APTR Source, mreg(__a1) APTR Dest);
  LIBPTR ECODE (*Lock)(mreg(__a0) APTR Object, mreg(__d0) WORD LockCount);
  LIBPTR LONG  (*Seek)(mreg(__a0) APTR Object, mreg(__d0) LONG Offset, mreg(__d1) WORD Position);
  LIBPTR ECODE (*AttemptExclusive)(mreg(__a0) APTR Object);
  LONG   FieldSize;
  LIBPTR void  (*FreeExclusive)(mreg(__a0) APTR Object);
  WORD   FieldTotal;
  WORD   ClassVersion;
  LONG   ObjectSize;
};

#define SOA_Prev             (TAPTR|12)
#define SOA_Next             (TAPTR|16)
#define SOA_CopyToUnv        (TAPTR|28)
#define SOA_CopyFromUnv      (TAPTR|32)
#define SOA_CheckFile        (TAPTR|36)
#define SOA_Load             (TAPTR|40)
#define SOA_Show             (TAPTR|44)
#define SOA_Get              (TAPTR|48)
#define SOA_Free             (TAPTR|52)
#define SOA_Init             (TAPTR|56)
#define SOA_Read             (TAPTR|60)
#define SOA_Write            (TAPTR|64)
#define SOA_Rename           (TAPTR|68)
#define SOA_Hide             (TAPTR|72)
#define SOA_yy03             (TAPTR|76)
#define SOA_SaveToFile       (TAPTR|80)
#define SOA_Query            (TAPTR|84)
#define SOA_Activate         (TAPTR|88)
#define SOA_Deactivate       (TAPTR|92)
#define SOA_Draw             (TAPTR|96)
#define SOA_Clear            (TAPTR|100)
#define SOA_Reset            (TAPTR|104)
#define SOA_Flush            (TAPTR|108)
#define SOA_TagTrigger       (TAPTR|112)
#define SOA_Master           (TAPTR|116)
#define SOA_FieldArray       (TAPTR|120)
#define SOA_Unlock           (TAPTR|124)
#define SOA_DetachParent     (TAPTR|128)
#define SOA_DetachChild      (TAPTR|132)
#define SOA_Unhook           (TAPTR|136)
#define SOA_MoveToBack       (TAPTR|140)
#define SOA_MoveToFront      (TAPTR|144)
#define SOA_FileExtension    (TAPTR|148)
#define SOA_FileDesc         (TAPTR|152)
#define SOA_Copy             (TAPTR|156)
#define SOA_Lock             (TAPTR|160)
#define SOA_Seek             (TAPTR|164)
#define SOA_AttemptExclusive (TAPTR|168)
#define SOA_FieldSize        (TLONG|172)
#define SOA_FreeExclusive    (TAPTR|176)
#define SOA_FieldTotal       (TWORD|180)
#define SOA_ClassVersion     (TWORD|182)
#define SOA_ObjectSize       (TLONG|184)

/**************************************************************************
** Structure for field orientation.
*/

struct Field {
  BYTE *Name;      /* [00] The english name for the field, e.g. "Width" */
  WORD Offset;     /* [04] The field's position in the object structure */
  WORD FieldID;    /* [06] Provides a fast way of finding fields, eg FID_WIDTH */
  LONG Flags;      /* [08] Special flags that describe the field */
  LONG MinRange;   /* [12] Minimum value for this field (for debugging) */
  LONG MaxRange;   /* [16] Maximum value for this field (for debugging) */
  LIBPTR void (*GetField)(mreg(__a0) APTR Object);
  LIBPTR void (*SetField)(mreg(__a0) APTR Object, mreg(__d0) LONG Value);
};

struct FieldDef {
  BYTE *Name;
  LONG Value;
};

#define FDF_BYTE      0x10000000  /* Field is byte sized */
#define FDF_WORD      0x20000000  /* Field is word sized */
#define FDF_LONG      0x40000000  /* Field is long sized */
#define FDF_QUAD      0x80000000  /* Field is 2xlong sized */

#define FD_OBJECT     0x00000001
#define FD_CHILD      0x00000002
#define FD_STRING     0x00000004
#define FD_POINTER    0x00000008
#define FD_BYTEARRAY  0x00000010
#define FD_WORDARRAY  0x00000020
#define FD_LONGARRAY  0x00000040
#define FD_UNSIGNED   0x00000080
#define FD_RANGE      0x00000100
#define FD_FLAGS      0x00000200
#define FD_HEX        0x00000400
#define FD_SOURCE     0x00000800
#define FD_LOOKUP     0x00001000

#define FDF_OBJECT    0x40000009  /* Field refers to another object */
#define FDF_CHILD     0x4000000A  /* Field refers to a child object */
#define FDF_STRING    0x4000000C  /* Field points to a string */
#define FDF_POINTER   0x40000008  /* Field is an address pointer */
#define FDF_BYTEARRAY 0x40000018  /* Points to an array of bytes */
#define FDF_WORDARRAY 0x40000028  /* Points to an array of words */
#define FDF_LONGARRAY 0x40000048  /* Points to an array of longs */
#define FDF_UNSIGNED  0x00000080  /* Field is unsigned (no negatives) */
#define FDF_RANGE     0x00000100  /* Enforce range limitations */
#define FDF_FLAGS     0x00000200  /* Field contains flags */
#define FDF_HEX       0x00000400  /* Field is in hexadecimal */
#define FDF_SOURCE    0x40000808  /* FileName, MemPtr etc */
#define FDF_LOOKUP    0x00001000  /* Lookup names for values in this field */

/**************************************************************************
** Field identifiers provide a quick way of finding certain names.
*/

#define FID_Flags         1
#define FID_Source        2
#define FID_ScrHeight     3
#define FID_ScrWidth      4
#define FID_ScrMode       5
#define FID_Width         6
#define FID_Height        7
#define FID_Size          8
#define FID_Data          9
#define FID_Array         10
#define FID_MaxSize       11
#define FID_Parent        12
#define FID_Child         13
#define FID_Restore       14
#define FID_MemType       15
#define FID_Planes        16
#define FID_AmtColours    17
#define FID_Palette       18
#define FID_LineMod       19
#define FID_PlaneMod      20
#define FID_ByteWidth     21
#define FID_Type          22
#define FID_Buffers       23
#define FID_Owner         24
#define FID_Entries       25
#define FID_GfxCoords     26
#define FID_Frame         27
#define FID_ClipLX        28
#define FID_ClipRX        29
#define FID_ClipTY        30
#define FID_ClipBY        31
#define FID_FPlane        32
#define FID_PropWidth     33
#define FID_PropHeight    34
#define FID_Attrib        35
#define FID_PlaneSize     36
#define FID_SrcBitmap     37
#define FID_DestBitmap    38
#define FID_MaskBitmap    39
#define FID_MaskCoords    40
#define FID_AmtFrames     41
#define FID_XCoord        42
#define FID_YCoord        43
#define FID_Frequency     44
#define FID_Pair          45
#define FID_Volume        46
#define FID_Priority      47
#define FID_Length        48
#define FID_Octave        49
#define FID_Bitmap        50
#define FID_Sound         51
#define FID_Name          52
#define FID_Colour        53
#define FID_Point         54
#define FID_Gutter        55
#define FID_Char          56
#define FID_Port          57
#define FID_XChange       58
#define FID_YChange       59
#define FID_ZChange       60
#define FID_Buttons       61
#define FID_ButtonTimeOut 62
#define FID_MoveTimeOut   63
#define FID_NXLimit       64
#define FID_NYLimit       65
#define FID_PXLimit       66
#define FID_PYLimit       67
#define FID_Number        68
#define FID_Year          69
#define FID_Month         70
#define FID_Day           71
#define FID_Hour          72
#define FID_Minute        73
#define FID_Second        74
#define FID_Micro         75
#define FID_ModBase       76
#define FID_Segment       77
#define FID_Public        78
#define FID_MinVersion    79
#define FID_MinRevision   80
#define FID_Date          81
#define FID_Author        82
#define FID_Copyright     83
#define FID_Short         84
#define FID_Args          85
#define FID_GVBase        86
#define FID_Prev          87
#define FID_Next          88
#define FID_Task          89
#define FID_Address       90
#define FID_ClassID       91
#define FID_ClassName     92
#define FID_CPU           93
#define FID_ModName       94
#define FID_ModNumber     95
#define FID_Extension     96
#define FID_Module        97
#define FID_ConfigFile    98
#define FID_FileHead      99
#define FID_ChildDir      100
#define FID_ChildFile     101
#define FID_BytePos       102
#define FID_DataProcessor 103
#define FID_MemPtr1       104
#define FID_MemPtr2       105
#define FID_MemPtr3       106
#define FID_Command       107
#define FID_Link          108
#define FID_Raster        109
#define FID_BmpXOffset    110
#define FID_BmpYOffset    111
#define FID_Switch        112
#define FID_Screen        113
#define FID_XOffset       114
#define FID_YOffset       115
#define FID_DirectGfx     116
#define FID_EntryList     117
#define FID_DirectMasks   118
#define FID_EntrySize     119
#define FID_Music         120
#define FID_Title         121
#define FID_Track         122
#define FID_Artist        123
#define FID_Tempo         124
#define FID_Position      125
#define FID_Routine       126

#endif /* SYSTEM_SYSOBJECT_H */
