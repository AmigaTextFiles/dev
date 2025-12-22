/*****************************************************************************/
/*  LibDWG - free implementation of the DWG file format                      */
/*                                                                           */
/*  Copyright (C) 2013 Free Software Foundation, Inc.                        */
/*                                                                           */
/*  This library is free software, licensed under the terms of the GNU       */
/*  General Public License as published by the Free Software Foundation,     */
/*  either version 3 of the License, or (at your option) any later version.  */
/*  You should have received a copy of the GNU General Public License        */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.    */
/*                                                                           */
/*****************************************************************************/

/**
 *     \file       decode.h
 *     \brief      Decoding function prototypes
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifndef DECODE_H
#define DECODE_H

#include "dwg.h"

/**
 *    \enum    DWG_SENTINEL
 *    \brief   references for byte stream sentinels
 */
typedef enum DWG_SENTINEL
{
  DWG_SENTINEL_HEADER_END,
  DWG_SENTINEL_PICTURE_BEGIN,
  DWG_SENTINEL_PICTURE_END,
  DWG_SENTINEL_VARIABLE_BEGIN,
  DWG_SENTINEL_VARIABLE_END,
  DWG_SENTINEL_CLASS_BEGIN,
  DWG_SENTINEL_CLASS_END,
  DWG_SENTINEL_SECOND_HEADER_BEGIN,
  DWG_SENTINEL_SECOND_HEADER_END
} Dwg_Sentinel;

/**
 *  \enum   DWG_SECTION_TYPE
 */
typedef enum DWG_SECTION_TYPE
{
  SECTION_VARIABLES = 0x01,
  SECTION_AUXHEADER = 0x02,
  SECTION_CLASSES = 0x03,
  SECTION_HANDLES = 0x04,
  SECTION_TEMPLATE = 0x05,
  SECTION_OBJFREESPACE = 0x06,
  SECTION_DBOBJECTS = 0x07,
  SECTION_REVHISTORY = 0x08,
  SECTION_SUMMARYINFO = 0x09,
  SECTION_PREVIEW = 0x0a,
  SECTION_APPINFO = 0x0b,
  SECTION_APPINFOHISTORY = 0x0c,
  SECTION_FILEDEPLIST = 0x0d,
  SECTION_SECURITY,      // 
  SECTION_VBAPROJECT,    // not seen
  SECTION_SIGNATURE      //
} Dwg_Section_Type;

/**
 *    \struct  _dwg_section
 *    \brief   Struct for DWG section
 */
typedef struct _dwg_section
{
  int32_t number;
  uint32_t address;
  uint32_t size;
  uint32_t parent;
  uint32_t left;
  uint32_t right;
  uint32_t x00;
} Dwg_Section;

typedef struct _dwg_section_info
{ 
  uint32_t size;
  uint32_t unknown1;	   
  uint32_t num_sections;  
  uint32_t max_decomp_size;  
  uint32_t unknown2;	   
  uint32_t compressed;
  uint32_t type;
  uint32_t encrypted;
  char name[64];
  Dwg_Section **sections;
} Dwg_Section_Info;

typedef struct _header_sections
{
  uint16_t num_sections;
  Dwg_Section *section;
  uint16_t num_descriptions;
  Dwg_Section_Info *section_info;
} Dwg_Header_Section;

int dwg_decode_data (Bit_Chain *bit_chain, Dwg_Struct * dwg_data);

int dwg_decode_object (Bit_Chain * dat, Dwg_Object * obj);

int dwg_decode_entity (Bit_Chain *dat, Dwg_Object_Entity * ent);

int dwg_decode_nongraph (Bit_Chain *dat, Dwg_Object_Nongraph * ngr);

void dwg_decode_common_entity_handle_data (Bit_Chain *dat, Dwg_Object *obj);

void decode_header_free (void);

unsigned char * decode_sentinel (Dwg_Sentinel sentinel);

/* XXX Functions defined in dwg_objects.spe.c (encoding is deprecated) */
int decode_3dsolid(Bit_Chain* dat, Dwg_Object* obj, Dwg_Entity_3DSOLID* _obj);
int encode_3dsolid(Bit_Chain* dat, Dwg_Object* obj, Dwg_Entity_3DSOLID* _obj);

#endif
