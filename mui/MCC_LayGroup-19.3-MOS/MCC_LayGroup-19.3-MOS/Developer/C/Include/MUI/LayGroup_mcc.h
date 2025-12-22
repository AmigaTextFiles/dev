/*******************************************************************************

 LayGroup.mcc - An automatic object arranger layout MUI Custom Class
 Copyright (C) 1997-1999 by Alessandro Zummo
 Copyright (C) 2008      by LayGroup.mcc Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 LayGroup class Support Site: http://sourceforge.net/projects/laygroup-mcc

 $Id:$

*******************************************************************************/

#ifndef LAYGROUP_MCC_H
#define LAYGROUP_MCC_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __GNUC__
  #ifdef __PPC__
    #pragma pack(2)
  #endif
#elif defined(__VBCC__)
  #pragma amiga-align
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

#define MUIC_LayGroup    "LayGroup.mcc"
#define LayGroupObject   MUI_NewObject((char *) MUIC_LayGroup

// Class identifiers 0xA5530000 - 0xA553FFFF
#define TAGBASE_LAYGROUP   (TAG_USER + (0x2553 << 16))

// Attributes
#define MUIA_LayGroup_ChildNumber         (TAGBASE_LAYGROUP + 0x0001) // [..G] ULONG
#define MUIA_LayGroup_MaxHeight           (TAGBASE_LAYGROUP + 0x0002) // [I..] WORD
#define MUIA_LayGroup_MaxWidth            (TAGBASE_LAYGROUP + 0x0003) // [I..] WORD
#define MUIA_LayGroup_HorizSpacing        (TAGBASE_LAYGROUP + 0x0004) // [ISG] WORD
#define MUIA_LayGroup_VertSpacing         (TAGBASE_LAYGROUP + 0x0005) // [ISG] WORD
#define MUIA_LayGroup_Spacing             (TAGBASE_LAYGROUP + 0x0006) // [IS.] WORD
#define MUIA_LayGroup_LeftOffset          (TAGBASE_LAYGROUP + 0x0007) // [ISG] WORD
#define MUIA_LayGroup_TopOffset           (TAGBASE_LAYGROUP + 0x0008) // [ISG] WORD
#define MUIA_LayGroup_AskLayout           (TAGBASE_LAYGROUP + 0x0009) // [I..] BOOL
#define MUIA_LayGroup_NumberOfColumns     (TAGBASE_LAYGROUP + 0x000A) // [..G] ULONG
#define MUIA_LayGroup_NumberOfRows        (TAGBASE_LAYGROUP + 0x000B) // [..G] ULONG
#define MUIA_LayGroup_InheritBackground   (TAGBASE_LAYGROUP + 0x000C) // [I..] BOOL

// Constants for attributes
#define MUIV_LayGroup_Spacing_Default       8
#define MUIV_LayGroup_Spacing_Minimum       0
#define MUIV_LayGroup_Spacing_Maximum      24

// Values for MUIA_LayGroup_LeftOffset
#define MUIV_LayGroup_LeftOffset_Default    0
#define MUIV_LayGroup_LeftOffset_Minimum    0
#define MUIV_LayGroup_LeftOffset_Maximum   32
#define MUIV_LayGroup_LeftOffset_Center    -1

// Values for MUIA_LayGroup_TopOffset
#define MUIV_LayGroup_TopOffset_Default     0
#define MUIV_LayGroup_TopOffset_Minimum     0
#define MUIV_LayGroup_TopOffset_Maximum    32
#define MUIV_LayGroup_TopOffset_Center     -1

// Methods
#define MUIM_LayGroup_AskLayout           (TAGBASE_LAYGROUP + 0x0101)

// Parameter structure for methods
struct MUIP_LayGroup_AskLayout { ULONG MethodID; struct MUI_LayGroup_Layout * lgl; };

// Values for MUIM_LayGroup_AskLayout
#define MUIV_LayGroup_MaxHeight_Auto -1
#define MUIV_LayGroup_MaxWidth_Auto  -1

// Structure for object in layout
struct MUI_LayGroup_Layout
{
   Object * lgl_Object;
   UWORD    lgl_Height;
   UWORD    lgl_Width;
};

#ifdef __GNUC__
  #ifdef __PPC__
    #pragma pack()
  #endif
#elif defined(__VBCC__)
  #pragma default-align
#endif

#ifdef __cplusplus
}
#endif

#endif /* LAYGROUP_MCC_H */

