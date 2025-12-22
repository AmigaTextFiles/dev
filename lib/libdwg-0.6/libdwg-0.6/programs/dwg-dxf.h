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
 *     \file       object.h
 *     \brief      Object function prototypes
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifndef _DWG_DXF_H_
#define _DWG_DXF_H_

#include "dwg.h"

#define GFORMAT "%-16.16G"

/* 'section' start.
 */
#define SEC(section) fprintf(fp, "  0\nSECTION\n  2\n" #section "\n")

/* end of section.
 */
#define ENDSEC() fprintf(fp, "  0\nENDSEC\n")

/* 'record' start.
 */
#define REC(record) fprintf(fp, "  0\n" #record "\n")

/* Print a group code and its value.
 */
#define VAL(gcode, value) \
  {\
    format_s = dxf_format_s (gcode);\
    snprintf (tmp, 4096, "%3i\n%s\n", gcode, format_s);\
    fprintf(fp, tmp, value);\
  }

/* The same, but for floats.
 */
#define VAL_1D(gcode, value) \
  {\
    if (value == ((double) (int32_t) value))\
      fprintf (fp, "%3i\n%-16.1F\n", gcode, value);\
    else\
      fprintf (fp, "%3i\n" GFORMAT "\n", gcode, value);\
  }

/* The same, for 2 floats.
 */
#define VAL_2D(gcodex, gcodey, value) \
  if (value.x == ((double) (int32_t) value.x))\
    fprintf (fp, "%3i\n%-16.1F\n", gcodex, value.x);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", gcodex, value.x);\
  if (value.y == ((double) (int32_t) value.y))\
    fprintf (fp, "%3i\n%-16.1F\n", gcodey, value.y);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", gcodey, value.y);

/* The same, for 3 floats.
 */
#define VAL_3D(gcodex, gcodey, gcodez, value) \
  if (value.x == ((double) (int32_t) value.x))\
    fprintf (fp, "%3i\n%-16.1F\n", gcodex, value.x);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", gcodex, value.x);\
  if (value.y == ((double) (int32_t) value.y))\
    fprintf (fp, "%3i\n%-16.1F\n", gcodey, value.y);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", gcodey, value.y);\
  if (value.z == ((double) (int32_t) value.z))\
    fprintf (fp, "%3i\n%-16.1F\n", gcodez, value.z);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", gcodez, value.z);

/* 'table' start.
 */
#define TAB(table) \
  fprintf(fp, "  0\nTABLE\n  2\n" #table "\n");\
  VAL (5, obj->handle.value);\
  VAL (330, 0);\
  VAL (100, "AcDbSymbolTable");\
  VAL (70, ngr->num_entries);

/* end of table.
 */
#define ENDTAB() fprintf(fp, "  0\nENDTAB\n")

/* VARIABLES ***************************************************************** 
 * Print variable 'name', with group-code 'gcode', using 'value'.
 */
#define VAR(name, gcode, value) \
  fprintf (fp, "  9\n$" #name "\n%3i\n", gcode);\
  format_s = dxf_format_s (gcode);\
  snprintf (tmp, 4096, "%s\n", format_s);\
  fprintf (fp, tmp, value);

/* The same, but the value field is the same
 * than used for libdwg (canonical).
 */
#define VAR0(name, gcode) VAR(name, gcode, dwg->variable.name)

/* Some specific integer variables needs conversion to signed.
 */
#define VAR0I(name, gcode) \
  fprintf (fp, "  9\n$" #name "\n%3i\n%6i\n", gcode, (int16_t)dwg->variable.name);

/* Print variable 'name', with group-code 'gcode', the value field is the same
 * than used for libdwg (DWG spec), applied for the handle value.
 */
#define VAR0_H(name, gcode) \
  format_s = dxf_format_s (gcode);\
  snprintf (tmp, 4096, "  9\n$" #name "\n%3i\n%s\n", gcode, format_s);\
  fprintf (fp, tmp, dwg->variable.name.value);

/* Print variable 'name', with group-code 'gcode', referencing the name_entry
 * of a 'type' nongraph, through the handle of the variable.
 */
#define VAR_H2N(name, gcode, type) \
  idx = dwg_handle_get_index (dwg->variable.name.value);\
  if (idx > 0 && idx <  dwg->num_objects)\
  {\
    VAR (name, gcode, dwg->object[idx].as.nongraph.as.type);\
  }\
  else \
  {\
    VAR (name, gcode, "");\
  }

/* Print variable 'name', with group-code 'gcode', the value fields are the same
 * than used for libdwg (canonical), 3D point.
 */
#define VAR0_3D(name, codex, codey, codez) \
  fprintf (fp, "  9\n$" #name "\n");\
  if (dwg->variable.name.x == ((double) (int32_t) dwg->variable.name.x))\
    fprintf (fp, "%3i\n%-16.1F\n", codex, dwg->variable.name.x);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", codex, dwg->variable.name.x);\
  if (dwg->variable.name.y == ((double) (int32_t) dwg->variable.name.y))\
    fprintf (fp, "%3i\n%-16.1F\n", codey, dwg->variable.name.y);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", codey, dwg->variable.name.y);\
  if (dwg->variable.name.z == ((double) (int32_t) dwg->variable.name.z))\
    fprintf (fp, "%3i\n%-16.1F\n", codez, dwg->variable.name.z);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", codez, dwg->variable.name.z);\

/* Same, for 2D point.
 */
#define VAR0_2D(name, codex, codey) \
  fprintf (fp, "  9\n$" #name "\n");\
  if (dwg->variable.name.x == ((double) (int32_t) dwg->variable.name.x))\
    fprintf (fp, "%3i\n%-16.1F\n", codex, dwg->variable.name.x);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", codex, dwg->variable.name.x);\
  if (dwg->variable.name.y == ((double) (int32_t) dwg->variable.name.y))\
    fprintf (fp, "%3i\n%-16.1F\n", codey, dwg->variable.name.y);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", codey, dwg->variable.name.y);\

/* Same, for 1D point.
 */
#define VAR0_1D(name, gcode) \
  fprintf (fp, "  9\n$" #name "\n");\
  if (dwg->variable.name == ((double) (int32_t) dwg->variable.name))\
    fprintf (fp, "%3i\n%-16.1F\n", gcode, dwg->variable.name);\
  else\
    fprintf (fp, "%3i\n" GFORMAT "\n", gcode, dwg->variable.name);\

/* Print variable 'name', with group-code 'gcode', the value field is the same
 * than used for libdwg (DWG spec), applied for the CMC index.
 */
#define VAR0_CMC(name, gcode) \
  format_s = dxf_format_s (gcode);\
  snprintf (tmp, 4096, "  9\n$" #name "\n%3i\n%s\n", gcode, format_s);\
  fprintf (fp, tmp, dwg->variable.name.index);

/* BLOCKS ******************************************************************** 
 * Print block headers.
 */
#define REC_BLOCK(is_pspace) \
      REC (BLOCK);\
      VAL (5, obj->handle.value);\
      VAL (330, blk->block_control_handle.value);\
      VAL (100, "AcDbEntity");\
      if (is_pspace == 1)\
        {\
          VAL (67, 1);\
        }\
      VAL (8, "0"); /* XXX Where is the layer info? */\
      VAL (100, "AcDbBlockBegin");\
      idx2 = dwg_handle_get_index (blk->block_entity.value);\
      if (idx2 < dwg->num_objects)\
        {\
          VAL (2, dwg->object[idx2].as.entity.as.BLOCK.name);\
        }\
      else\
        {\
          VAL (2, blk->entry_name);\
        }\
      VAL (70, blk->anonymous |\
	      (blk->hasattrs << 1) |\
	      (blk->blkisxref << 2) |\
	      (blk->xrefoverlaid << 3) |\
	      (blk->xdep << 4));\
      VAL_3D (10, 20, 30, blk->base_pt);\
      VAL (3, blk->entry_name);\
      VAL (1, blk->xref_pname);\
      if (blk->block_description[0]) {VAL (4, blk->block_description);}

/* Print ENDBLK.
 */
#define REC_ENDBLK(is_pspace) \
      REC (ENDBLK);\
      idx = dwg_handle_get_index (blk->endblk_entity.value);\
      if (idx < dwg->num_objects) {VAL (5, dwg->object[idx].handle.value);}\
      else {VAL (5, dwg->variable.HANDSEED.value++);}\
      VAL (330, obj->handle.value);\
      VAL (100, "AcDbEntity");\
      if (is_pspace == 1)\
        {\
          VAL (67, 1);\
        }\
      VAL (8, "0"); /* XXX ? */\
      VAL (100, "AcDbBlockEnd");

/* Functions ***************************************************************** 
 */
void dxf_header_write (Dwg_Struct * dwgdwg);
void dxf_classes_write (Dwg_Struct * dwg);
void dxf_tables_write (Dwg_Struct * dwg);
void dxf_blocks_write (Dwg_Struct * dwg);
void dxf_entities_write (Dwg_Struct * dwg);
void dxf_nongraphs_write (Dwg_Struct * dwg);

char * dxf_format_s (int gcode);

/* Selection macros for object-types ******************************************
 */
#define OBJECT_CASE_SET(action) \
      case DWG_TYPE_TEXT:\
        action##TEXT(obj);\
        break;\
      case DWG_TYPE_ATTRIB:\
        action##ATTRIB(obj);\
        break;\
      case DWG_TYPE_ATTDEF:\
        action##ATTDEF(obj);\
        break;\
      case DWG_TYPE_SEQEND:\
        action##SEQEND(obj);\
        break;\
      case DWG_TYPE_INSERT:\
        action##INSERT(obj);\
        break;\
      case DWG_TYPE_MINSERT:\
        action##MINSERT(obj);\
        break;\
      case DWG_TYPE_VERTEX_2D:\
        action##VERTEX_2D(obj);\
        break;\
      case DWG_TYPE_VERTEX_3D:\
        action##VERTEX_3D(obj);\
        break;\
      case DWG_TYPE_VERTEX_MESH:\
        action##VERTEX_MESH(obj);\
        break;\
      case DWG_TYPE_VERTEX_PFACE:\
        action##VERTEX_PFACE(obj);\
        break;\
      case DWG_TYPE_VERTEX_PFACE_FACE:\
        action##VERTEX_PFACE_FACE(obj);\
        break;\
      case DWG_TYPE_POLYLINE_2D:\
        action##POLYLINE_2D(obj);\
        break;\
      case DWG_TYPE_POLYLINE_3D:\
        action##POLYLINE_3D(obj);\
        break;\
      case DWG_TYPE_ARC:\
        action##ARC(obj);\
        break;\
      case DWG_TYPE_CIRCLE:\
        action##CIRCLE(obj);\
        break;\
      case DWG_TYPE_LINE:\
        action##LINE(obj);\
        break;\
      case DWG_TYPE_DIMENSION_ORDINATE:\
        action##DIMENSION_ORDINATE(obj);\
        break;\
      case DWG_TYPE_DIMENSION_LINEAR:\
        action##DIMENSION_LINEAR(obj);\
        break;\
      case DWG_TYPE_DIMENSION_ALIGNED:\
        action##DIMENSION_ALIGNED(obj);\
        break;\
      case DWG_TYPE_DIMENSION_ANG3PT:\
        action##DIMENSION_ANG3PT(obj);\
        break;\
      case DWG_TYPE_DIMENSION_ANG2LN:\
        action##DIMENSION_ANG2LN(obj);\
        break;\
      case DWG_TYPE_DIMENSION_RADIUS:\
        action##DIMENSION_RADIUS(obj);\
        break;\
      case DWG_TYPE_DIMENSION_DIAMETER:\
        action##DIMENSION_DIAMETER(obj);\
        break;\
      case DWG_TYPE_POINT:\
        action##POINT(obj);\
        break;\
      case DWG_TYPE__3DFACE:\
        action##_3DFACE(obj);\
        break;\
      case DWG_TYPE_POLYLINE_PFACE:\
        action##POLYLINE_PFACE(obj);\
        break;\
      case DWG_TYPE_POLYLINE_MESH:\
        action##POLYLINE_MESH(obj);\
        break;\
      case DWG_TYPE_SOLID:\
        action##SOLID(obj);\
        break;\
      case DWG_TYPE_TRACE:\
        action##TRACE(obj);\
        break;\
      case DWG_TYPE_SHAPE:\
        action##SHAPE(obj);\
        break;\
      case DWG_TYPE_VIEWPORT:\
        action##VIEWPORT(obj);\
        break;\
      case DWG_TYPE_ELLIPSE:\
        action##ELLIPSE(obj);\
        break;\
      case DWG_TYPE_SPLINE:\
        action##SPLINE(obj);\
        break;\
      case DWG_TYPE_REGION:\
        action##REGION(obj);\
        break;\
      case DWG_TYPE_3DSOLID:\
        action##_3DSOLID(obj);\
        break;\
      case DWG_TYPE_BODY:\
        action##BODY(obj);\
        break;\
      case DWG_TYPE_RAY:\
        action##RAY(obj);\
        break;\
      case DWG_TYPE_XLINE:\
        action##XLINE(obj);\
        break;\
      case DWG_TYPE_DICTIONARY:\
        action##DICTIONARY(obj);\
        break;\
      case DWG_TYPE_MTEXT:\
        action##MTEXT(obj);\
        break;\
      case DWG_TYPE_LEADER:\
        action##LEADER(obj);\
        break;\
      case DWG_TYPE_TOLERANCE:\
        action##TOLERANCE(obj);\
        break;\
      case DWG_TYPE_MLINE:\
        action##MLINE(obj);\
        break;\
      case DWG_TYPE_GROUP:\
        action##GROUP(obj);\
        break;\
      case DWG_TYPE_MLINESTYLE:\
        action##MLINESTYLE(obj);\
        break;\
      case DWG_TYPE_LWPLINE:\
        action##LWPLINE(obj);\
        break;\
      case DWG_TYPE_HATCH:\
        action##HATCH(obj);\
        break;\
      case DWG_TYPE_XRECORD:\
        action##XRECORD(obj);\
        break;\
      case DWG_TYPE_PLACEHOLDER:\
        action##PLACEHOLDER(obj);\
        break;\
      case DWG_TYPE_LAYOUT:\
        action##LAYOUT(obj);\
        break;

#define OBJECT_VARTYPE_ELSEIF_SET(action) \
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "DICTIONARYVAR"))\
	  action##DICTIONARYVAR (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "ACDBDICTIONARYWDFLT"))\
	  action##DICTIONARYWDLFT (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "HATCH"))\
	  action##HATCH (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IDBUFFER"))\
	  action##IDBUFFER (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IMAGE"))\
	  action##IMAGE (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IMAGEDEF"))\
	action##IMAGEDEF (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IMAGEDEF_REACTOR"))\
	action##IMAGEDEFREACTOR (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "LAYER_INDEX"))\
	action##LAYER_INDEX (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "LAYOUT"))\
	action##LAYOUT (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "LWPLINE"))\
	action##LWPLINE (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "OLE2FRAME"))\
	action##OLE2FRAME (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "ACDBPLACEHOLDER"))\
	action##PLACEHOLDER (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "RASTERVARIABLES"))\
	action##RASTERVARIABLES (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "SORTENTSTABLE"))\
	action##SORTENTSTABLE (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "SPATIAL_FILTER"))\
	action##SPATIAL_FILTER (obj);\
      else if (!strcmp((const char *) dwg->dwg_class[i].dxfname, "SPATIAL_INDEX"))\
	action##SPATIAL_INDEX (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "XRECORD"))\
	action##XRECORD (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "WIPEOUT"))\
	action##WIPEOUT (obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "WIPEOUTVARIABLES"))\
	action##WIPEOUTVARIABLES (obj);

#endif
