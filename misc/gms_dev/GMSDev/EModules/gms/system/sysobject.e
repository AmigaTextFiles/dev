/*
**  $VER: sysobject.e
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/****************************************************************************
** The SysObject structure.  Private.
*/

CONST VER_SYSOBJECT  = 2,
      TAGS_SYSOBJECT = $FFFB0000 OR ID_SYSOBJECT

OBJECT sysobject
  head[1]     :ARRAY OF head
  prev        :PTR TO sysobject /* Previous object in list */
  next        :PTR TO sysobject /* Next object in list */
  objectid    :INT              /* Unique ID of the object, eg ID_PICTURE */
  classid     :INT              /* Class reference ID */
  name        :PTR TO CHAR      /* Full name of the object */
ENDOBJECT

CONST SOA_Prev     = 12 OR TAPTR,
      SOA_Next     = 16 OR TAPTR,
      SOA_ObjectID = 20 OR TWORD,
      SOA_ClassID  = 22 OR TWORD,
      SOA_Name     = 24 OR TAPTR

/**************************************************************************
** Structure for field orientation.
*/

OBJECT field
  name     :PTR TO CHAR /* The english name for the field, e.g. "Width" */
  offset   :INT         /* The field's position in the object structure */
  fieldid  :INT         /* Provides a fast way of finding fields, eg FID_WIDTH */
  flags    :LONG        /* Special flags that describe the field */
  minrange :LONG        /* Minimum value for this field (for debugging) */
  maxrange :LONG        /* Maximum value for this field (for debugging) */
ENDOBJECT

#define FDF_BYTE      $10000000  /* Field is byte sized */
#define FDF_WORD      $20000000  /* Field is word sized */
#define FDF_LONG      $40000000  /* Field is long sized */
#define FDF_QUAD      $80000000  /* Field is 2xlong sized */

#define FD_OBJECT     $00000001
#define FD_CHILD      $00000002
#define FD_STRING     $00000004
#define FD_POINTER    $00000008
#define FD_BYTEARRAY  $00000010
#define FD_WORDARRAY  $00000020
#define FD_LONGARRAY  $00000040
#define FD_SOURCE     $00000800
#define FD_LOOKUP     $00001000

#define FDF_OBJECT    $40000009  /* Field refers to another object */
#define FDF_CHILD     $4000000A  /* Field refers to a child object */
#define FDF_STRING    $4000000C  /* Field points to a string */
#define FDF_POINTER   $40000008  /* Field is an address pointer */
#define FDF_BYTEARRAY $40000018  /* Points to an array of bytes */
#define FDF_WORDARRAY $40000028  /* Points to an array of words */
#define FDF_LONGARRAY $40000048  /* Points to an array of longs */
#define FDF_UNSIGNED  $00000080  /* Field is unsigned (no negatives) */
#define FDF_RANGE     $00000100  /* Enforce range limitations */
#define FDF_FLAGS     $00000200  /* Field contains flags */
#define FDF_HEX       $00000400  /* Field is in hexadecimal */
#define FDF_SOURCE    $40000808
#define FDF_LOOKUP    $00001000

/**************************************************************************
** Field identifiers provide a quick way of finding certain names.
*/

#define FID_Flags      1
#define FID_Source     2
#define FID_ScrHeight  3
#define FID_ScrWidth   4
#define FID_ScrMode    5
#define FID_Width      6
#define FID_Height     7
#define FID_Size       8
#define FID_Data       9
#define FID_Array      10
#define FID_MaxSize    11
#define FID_Parent     12
#define FID_Child      13
#define FID_Restore    14
#define FID_MemType    15
#define FID_Planes     16
#define FID_AmtColours 17
#define FID_Palette    18
#define FID_LineMod    19
#define FID_PlaneMod   20
#define FID_ByteWidth  21
#define FID_Type       22
#define FID_Buffers    23
#define FID_Owner      24
#define FID_Entries    25
#define FID_GfxCoords  26
#define FID_Frame      27
#define FID_ClipLX     28
#define FID_ClipRX     29
#define FID_ClipTY     30
#define FID_ClipBY     31
#define FID_FPlane     32
#define FID_PropWidth  33
#define FID_PropHeight 34
#define FID_Attrib     35
#define FID_PlaneSize  36
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

