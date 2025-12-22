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

#ifndef _DWG_OBJECT_H_
#define _DWG_OBJECT_H_

#include "dwg.h"

void dwg_objects_reset (void);

void dwg_object_add_from_chain (Dwg_Struct *dwg, Bit_Chain *dat, uint32_t address);

int dwg_object_free (Dwg_Object * obj);


#define OBJECT_CASE_SET(action) \
      case DWG_TYPE_TEXT:\
        success = action##TEXT(dat, obj);\
        break;\
      case DWG_TYPE_ATTRIB:\
        success = action##ATTRIB(dat, obj);\
        break;\
      case DWG_TYPE_ATTDEF:\
        success = action##ATTDEF(dat, obj);\
        break;\
      case DWG_TYPE_BLOCK:\
        success = action##BLOCK(dat, obj);\
        break;\
      case DWG_TYPE_ENDBLK:\
        success = action##ENDBLK(dat, obj);\
        break;\
      case DWG_TYPE_SEQEND:\
        success = action##SEQEND(dat, obj);\
        break;\
      case DWG_TYPE_INSERT:\
        success = action##INSERT(dat, obj);\
        break;\
      case DWG_TYPE_MINSERT:\
        success = action##MINSERT(dat, obj);\
        break;\
      case DWG_TYPE_VERTEX_2D:\
        success = action##VERTEX_2D(dat, obj);\
        break;\
      case DWG_TYPE_VERTEX_3D:\
        success = action##VERTEX_3D(dat, obj);\
        break;\
      case DWG_TYPE_VERTEX_MESH:\
        success = action##VERTEX_MESH(dat, obj);\
        break;\
      case DWG_TYPE_VERTEX_PFACE:\
        success = action##VERTEX_PFACE(dat, obj);\
        break;\
      case DWG_TYPE_VERTEX_PFACE_FACE:\
        success = action##VERTEX_PFACE_FACE(dat, obj);\
        break;\
      case DWG_TYPE_POLYLINE_2D:\
        success = action##POLYLINE_2D(dat, obj);\
        break;\
      case DWG_TYPE_POLYLINE_3D:\
        success = action##POLYLINE_3D(dat, obj);\
        break;\
      case DWG_TYPE_ARC:\
        success = action##ARC(dat, obj);\
        break;\
      case DWG_TYPE_CIRCLE:\
        success = action##CIRCLE(dat, obj);\
        break;\
      case DWG_TYPE_LINE:\
        success = action##LINE(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_ORDINATE:\
        success = action##DIMENSION_ORDINATE(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_LINEAR:\
        success = action##DIMENSION_LINEAR(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_ALIGNED:\
        success = action##DIMENSION_ALIGNED(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_ANG3PT:\
        success = action##DIMENSION_ANG3PT(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_ANG2LN:\
        success = action##DIMENSION_ANG2LN(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_RADIUS:\
        success = action##DIMENSION_RADIUS(dat, obj);\
        break;\
      case DWG_TYPE_DIMENSION_DIAMETER:\
        success = action##DIMENSION_DIAMETER(dat, obj);\
        break;\
      case DWG_TYPE_POINT:\
        success = action##POINT(dat, obj);\
        break;\
      case DWG_TYPE__3DFACE:\
        success = action##_3DFACE(dat, obj);\
        break;\
      case DWG_TYPE_POLYLINE_PFACE:\
        success = action##POLYLINE_PFACE(dat, obj);\
        break;\
      case DWG_TYPE_POLYLINE_MESH:\
        success = action##POLYLINE_MESH(dat, obj);\
        break;\
      case DWG_TYPE_SOLID:\
        success = action##SOLID(dat, obj);\
        break;\
      case DWG_TYPE_TRACE:\
        success = action##TRACE(dat, obj);\
        break;\
      case DWG_TYPE_SHAPE:\
        success = action##SHAPE(dat, obj);\
        break;\
      case DWG_TYPE_VIEWPORT:\
        success = action##VIEWPORT(dat, obj);\
        break;\
      case DWG_TYPE_ELLIPSE:\
        success = action##ELLIPSE(dat, obj);\
        break;\
      case DWG_TYPE_SPLINE:\
        success = action##SPLINE(dat, obj);\
        break;\
      case DWG_TYPE_REGION:\
        success = action##REGION(dat, obj);\
        break;\
      case DWG_TYPE_3DSOLID:\
        success = action##_3DSOLID(dat, obj);\
        break;\
      case DWG_TYPE_BODY:\
        success = action##BODY(dat, obj);\
        break;\
      case DWG_TYPE_RAY:\
        success = action##RAY(dat, obj);\
        break;\
      case DWG_TYPE_XLINE:\
        success = action##XLINE(dat, obj);\
        break;\
      case DWG_TYPE_DICTIONARY:\
        success = action##DICTIONARY(dat, obj);\
        break;\
      case DWG_TYPE_MTEXT:\
        success = action##MTEXT(dat, obj);\
        break;\
      case DWG_TYPE_LEADER:\
        success = action##LEADER(dat, obj);\
        break;\
      case DWG_TYPE_TOLERANCE:\
        success = action##TOLERANCE(dat, obj);\
        break;\
      case DWG_TYPE_MLINE:\
        success = action##MLINE(dat, obj);\
        break;\
      case DWG_TYPE_BLOCK_CONTROL:\
        success = action##BLOCK_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_BLOCK_HEADER:\
        success = action##BLOCK_HEADER(dat, obj);\
        break;\
      case DWG_TYPE_LAYER_CONTROL:\
        success = action##LAYER_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_LAYER:\
        success = action##LAYER(dat, obj);\
        break;\
      case DWG_TYPE_SHAPEFILE_CONTROL:\
        success = action##SHAPEFILE_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_SHAPEFILE:\
        success = action##SHAPEFILE(dat, obj);\
        break;\
      case DWG_TYPE_LTYPE_CONTROL:\
        success = action##LTYPE_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_LTYPE:\
        success = action##LTYPE(dat, obj);\
        break;\
      case DWG_TYPE_VIEW_CONTROL:\
        success = action##VIEW_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_VIEW:\
        success = action##VIEW(dat, obj);\
        break;\
      case DWG_TYPE_UCS_CONTROL:\
        success = action##UCS_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_UCS:\
        success = action##UCS(dat, obj);\
        break;\
      case DWG_TYPE_VPORT_CONTROL:\
        success = action##VPORT_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_VPORT:\
        success = action##VPORT(dat, obj);\
        break;\
      case DWG_TYPE_APPID_CONTROL:\
        success = action##APPID_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_APPID:\
        success = action##APPID(dat, obj);\
        break;\
      case DWG_TYPE_DIMSTYLE_CONTROL:\
        success = action##DIMSTYLE_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_DIMSTYLE:\
        success = action##DIMSTYLE(dat, obj);\
        break;\
      case DWG_TYPE_VP_ENT_HDR_CONTROL:\
        success = action##VP_ENT_HDR_CONTROL(dat, obj);\
        break;\
      case DWG_TYPE_VP_ENT_HDR:\
        success = action##VP_ENT_HDR(dat, obj);\
        break;\
      case DWG_TYPE_GROUP:\
        success = action##GROUP(dat, obj);\
        break;\
      case DWG_TYPE_MLINESTYLE:\
        success = action##MLINESTYLE(dat, obj);\
        break;\
      case DWG_TYPE_LWPLINE:\
        success = action##LWPLINE(dat, obj);\
        break;\
      case DWG_TYPE_HATCH:\
        success = action##HATCH(dat, obj);\
        break;\
      case DWG_TYPE_XRECORD:\
        success = action##XRECORD(dat, obj);\
        break;\
      case DWG_TYPE_PLACEHOLDER:\
        success = action##PLACEHOLDER(dat, obj);\
        break;\
      case DWG_TYPE_LAYOUT:\
        success = action##LAYOUT(dat, obj);\
        break;

#define OBJECT_VARTYPE_ELSEIF_SET(action) \
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "DICTIONARYVAR"))\
	  success = action##DICTIONARYVAR (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "ACDBDICTIONARYWDFLT"))\
	  success = action##DICTIONARYWDLFT (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "HATCH"))\
	  success = action##HATCH (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IDBUFFER"))\
	  success = action##IDBUFFER (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IMAGE"))\
	  success = action##IMAGE (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IMAGEDEF"))\
	success = action##IMAGEDEF (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "IMAGEDEF_REACTOR"))\
	success = action##IMAGEDEFREACTOR (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "LAYER_INDEX"))\
	success = action##LAYER_INDEX (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "LAYOUT"))\
	success = action##LAYOUT (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "LWPLINE"))\
	success = action##LWPLINE (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "OLE2FRAME"))\
	success = action##OLE2FRAME (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "ACDBPLACEHOLDER"))\
	success = action##PLACEHOLDER (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "RASTERVARIABLES"))\
	success = action##RASTERVARIABLES (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "SORTENTSTABLE"))\
	success = action##SORTENTSTABLE (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "SPATIAL_FILTER"))\
	success = action##SPATIAL_FILTER (dat, obj);\
      else if (!strcmp((const char *) dwg->dwg_class[i].dxfname, "SPATIAL_INDEX"))\
	success = action##SPATIAL_INDEX (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "XRECORD"))\
	success = action##XRECORD (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "WIPEOUT"))\
        success = action##IMAGE (dat, obj);\
      else if (!strcmp ((const char *) dwg->dwg_class[i].dxfname, "WIPEOUTVARIABLE"))\
        success = action##WIPEOUTVARIABLES (dat, obj);

#endif
