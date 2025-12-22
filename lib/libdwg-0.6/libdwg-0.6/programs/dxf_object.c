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
 *     \file       dwg_object.c
 *     \brief      Write object data into DXF format, text mode, 
 *                   included from dwg-dxf.c
 *     \author     written by Felipe E. F. de Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <math.h>

#include "dwg.h"
#include "dwg-dxf.h"

int
dxf_retzero ()
{
  return (0);
}

void
dxf_TEXT (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_TEXT *_obj = &obj->as.entity.as.TEXT;

  REC (TEXT);
  dxf_entity_common (obj);

  VAL (100, "AcDbText");
  if (_obj->thickness != 0.0)
    {
      VAL_1D (39, _obj->thickness);
    }
  VAL_2D (10, 20, _obj->insertion_pt);
  VAL_1D (30, _obj->elevation);
  VAL_1D (40, _obj->height);
  VAL (1, _obj->text_value);
  if (!(_obj->dataflags & 0x08))
    {
      VAL_1D (50, _obj->rotation_ang * 180/M_PI);
    }
  if (!(_obj->dataflags & 0x10))
    {
      VAL_1D (41, _obj->width_factor);
    }
  if (!(_obj->dataflags & 0x04))
    {
      VAL_1D (51, _obj->oblique_ang * 180/M_PI);
    }
  idx = dwg_handle_get_index (_obj->style.value);
  if (idx < dwg->num_objects)
    {
      if (strcmp (dwg->object[idx].as.nongraph.as.SHAPEFILE.entry_name, "Standard") != 0)
        {
          VAL (7, dwg->object[idx].as.nongraph.as.SHAPEFILE.entry_name);
        }
    }
  if (!(_obj->dataflags & 0x20))
    {
      VAL (71, _obj->generation);
    }
  if (!(_obj->dataflags & 0x40))
    {
      VAL (72, _obj->horiz_alignment);
      VAL_1D (11, _obj->alignment_pt.x);
      VAL_1D (21, _obj->insertion_pt.y);
      VAL_1D (31, _obj->elevation);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  VAL (100, "AcDbText");
  if (!(_obj->dataflags & 0x80))
    {
      VAL (73, _obj->vert_alignment);
    }
}

void
dxf_ATTRIB (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_ATTRIB *_obj = &obj->as.entity.as.ATTRIB;

  REC (ATTRIB);
  dxf_entity_common (obj);

  VAL (100, "AcDbText");
  if (_obj->thickness != 0.0)
    {
      VAL_1D (39, _obj->thickness);
    }
  VAL_2D (10, 20, _obj->insertion_pt);
  VAL_1D (30, _obj->elevation);
  VAL_1D (40, _obj->height);
  VAL (1, _obj->text_value);
  if (!(_obj->dataflags & 0x08))
    {
      VAL_1D (50, _obj->rotation_ang * 180/M_PI);
    }
  if (!(_obj->dataflags & 0x10))
    {
      VAL_1D (41, _obj->width_factor);
    }
  if (!(_obj->dataflags & 0x04))
    {
      VAL_1D (51, _obj->oblique_ang * 180/M_PI);
    }
  idx = dwg_handle_get_index (_obj->style.value);
  if (idx < dwg->num_objects)
    {
      VAL (7, dwg->object[idx].as.nongraph.as.SHAPEFILE.entry_name);
    }
  if (!(_obj->dataflags & 0x20))
    {
      VAL (71, _obj->generation);
    }
  if (!(_obj->dataflags & 0x40))
    {
      VAL (72, _obj->horiz_alignment);
      VAL_1D (11, _obj->alignment_pt.x);
      VAL_1D (21, _obj->insertion_pt.y);
      VAL_1D (31, _obj->elevation);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }

  VAL (100, "AcDbAttribute");
  VAL (2, _obj->tag);
  VAL (70, _obj->flags);
  if (_obj->field_length != 0.0)
    {
      VAL (73, _obj->field_length);
    }
}

void
dxf_ATTDEF (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_ATTDEF *_obj = &obj->as.entity.as.ATTDEF;

  REC (ATTDEF);
  dxf_entity_common (obj);

  VAL (100, "AcDbText");
  if (_obj->thickness != 0.0)
    {
      VAL_1D (39, _obj->thickness);
    }
  VAL_2D (10, 20, _obj->insertion_pt);
  VAL_1D (30, _obj->elevation);
  VAL_1D (40, _obj->height);
  VAL (1, _obj->default_value);
  if (!(_obj->dataflags & 0x08))
    {
      VAL_1D (50, _obj->rotation_ang * 180/M_PI);
    }
  if (!(_obj->dataflags & 0x10))
    {
      VAL_1D (41, _obj->width_factor);
    }
  if (!(_obj->dataflags & 0x04))
    {
      VAL_1D (51, _obj->oblique_ang * 180/M_PI);
    }
  idx = dwg_handle_get_index (_obj->style.value);
  if (idx < dwg->num_objects)
    {
      VAL (7, dwg->object[idx].as.nongraph.as.SHAPEFILE.entry_name);
    }
  if (!(_obj->dataflags & 0x20))
    {
      VAL (71, _obj->generation);
    }
  if (!(_obj->dataflags & 0x40))
    {
      VAL (72, _obj->horiz_alignment);
      VAL_1D (11, _obj->alignment_pt.x);
      VAL_1D (21, _obj->insertion_pt.y);
      VAL_1D (31, _obj->elevation);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }

  VAL (100, "AcDbAttributeDefinition");
  VAL (3, _obj->prompt);
  VAL (2, _obj->tag);
  VAL (70, _obj->flags);
  if (_obj->field_length != 0.0)
    {
      VAL (73, _obj->field_length);
    }
  if (!(_obj->dataflags & 0x80))
    {
      VAL (74, _obj->vert_alignment);
    }
}

void
dxf_SEQEND (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_SEQEND *_obj = &obj->as.entity.as.SEQEND;

  REC (SEQEND);
  dxf_entity_common (obj);
}

void
dxf_INSERT (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_INSERT *_obj = &obj->as.entity.as.INSERT;

  REC (INSERT);
  dxf_entity_common (obj);
  VAL (100, "AcDbBlockReference");

  if (_obj->has_attribs)
    {
      VAL (66, _obj->has_attribs);
    }

  idx = dwg_handle_get_index (_obj->block_header.value);
  if (idx < dwg->num_objects)
    {
      VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
    }
  else
    {
      VAL (2, "");
    }

  VAL_3D (10, 20, 30, _obj->ins_pt);
  if (_obj->scale.x != 1.0)
   {
     VAL_1D (41, _obj->scale.x);
   }
  if (_obj->scale.y != 1.0)
   {
     VAL_1D (42, _obj->scale.y);
   }
  if (_obj->scale.z != 1.0)
   {
     VAL_1D (42, _obj->scale.z);
   }

  if (_obj->rotation_ang != 0)
   {
     VAL_1D (50, _obj->rotation_ang);
   }

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_MINSERT (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_MINSERT *_obj = &obj->as.entity.as.MINSERT;

  REC (INSERT);
  dxf_entity_common (obj);
  VAL (100, "AcDbBlockReference");

  if (_obj->has_attribs)
    {
      VAL (66, _obj->has_attribs);
    }

  idx = dwg_handle_get_index (_obj->block_header.value);
  if (idx < dwg->num_objects)
    {
      VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
    }
  else
    {
      VAL (2, "");
    }

  VAL_3D (10, 20, 30, _obj->ins_pt);
  if (_obj->scale.x != 1.0)
   {
     VAL_1D (41, _obj->scale.x);
   }
  if (_obj->scale.y != 1.0)
   {
     VAL_1D (42, _obj->scale.y);
   }
  if (_obj->scale.z != 1.0)
   {
     VAL_1D (42, _obj->scale.z);
   }

  if (_obj->rotation_ang != 0)
   {
     VAL_1D (50, _obj->rotation_ang);
   }

  if (_obj->numcols > 1)
   {
     VAL (70, _obj->numcols);
   }
  if (_obj->numrows > 1)
   {
     VAL (71, _obj->numrows);
   }
 if (_obj->col_spacing != 0)
   {
     VAL_1D (44, _obj->col_spacing);
   }
 if (_obj->row_spacing != 0)
   {
     VAL_1D (45, _obj->row_spacing);
   }

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_VERTEX_2D (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_VERTEX_2D *_obj = &obj->as.entity.as.VERTEX_2D;

  REC (VERTEX);
  dxf_entity_common (obj);
  VAL (100, "AcDbVertex");
  VAL (100, "AcDb2dVertex");

  VAL_3D (10, 20, 30, _obj->point);
  VAL_1D (40, _obj->start_width);
  VAL_1D (41, _obj->end_width);
  VAL_1D (42, _obj->bulge);
  VAL (70, _obj->flags);
  VAL_1D (50, _obj->tangent_dir);
}

void
dxf_VERTEX_3D (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_VERTEX_3D *_obj = &obj->as.entity.as.VERTEX_3D;

  REC (VERTEX);
  dxf_entity_common (obj);
  VAL (100, "AcDbVertex");
  VAL (100, "AcDb3dPolylineVertex");

  VAL_3D (10, 20, 30, _obj->point);
  VAL (70, _obj->flags);
}

void
dxf_VERTEX_MESH (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_VERTEX_MESH *_obj = &obj->as.entity.as.VERTEX_MESH;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (VERTEX_MESH);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "VERTEX_MESH");
  VAL (70, _obj->flags);
  VAL_3D (10, 20, 30, _obj->point);
}

void
dxf_VERTEX_PFACE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_VERTEX_PFACE *_obj = &obj->as.entity.as.VERTEX_PFACE;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (VERTEX_PFACE);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "VERTEX_PFACE");
  VAL (70, _obj->flags);
  VAL_3D (10, 20, 30, _obj->point);
}

void
dxf_VERTEX_PFACE_FACE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_VERTEX_PFACE_FACE *_obj = &obj->as.entity.as.VERTEX_PFACE_FACE;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (VERTEX_PFACE_FACE);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "VERTEX_PFACE_FACE");
  VAL (70, _obj->vertind[0]);
  VAL (70, _obj->vertind[1]);
  VAL (70, _obj->vertind[2]);
  VAL (70, _obj->vertind[3]);
}

void
dxf_POLYLINE_2D (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_POLYLINE_2D *_obj = &obj->as.entity.as.POLYLINE_2D;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (POLYLINE_2D);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "POLYLINE_2D");
  VAL (70, _obj->flags);
  VAL (70, _obj->curve_type);
  VAL_1D (10, _obj->start_width);
  VAL_1D (10, _obj->end_width);
  VAL_1D (39, _obj->thickness);
  VAL_1D (10, _obj->elevation);
  VAL_3D (210, 220, 230, _obj->extrusion);
      VAL (5, _obj->first_vertex.value);
      VAL (5, _obj->last_vertex.value);
  VAL (5, _obj->seqend.value);
}

void
dxf_POLYLINE_3D (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_POLYLINE_3D *_obj = &obj->as.entity.as.POLYLINE_3D;

  REC (POLYLINE);
  dxf_entity_common (obj);
  VAL (100, "AcDb3dPolyline");

  VAL_1D (10, 0);
  VAL_1D (20, 0);
  VAL_1D (30, 0);
  VAL (70, 8); /* 3D polyline */
  /*
  VAL (5, _obj->first_vertex.value);
  VAL (5, _obj->last_vertex.value);
  VAL (5, _obj->seqend.value);
  */
}

void
dxf_ARC (Dwg_Object * obj)
{
  Dwg_Entity_ARC *_obj = &obj->as.entity.as.ARC;

  REC (ARC);
  dxf_entity_common (obj);
  VAL (100, "AcDbCircle");

  if (_obj->thickness != 0.0)
  {
    VAL_1D (39, _obj->thickness);
  }

  VAL_3D (10, 20, 30, _obj->center);
  VAL_1D (40, _obj->radius);

  VAL (100, "AcDbArc");

  VAL_1D (50, _obj->start_angle * 180/M_PI);
  VAL_1D (51, _obj->end_angle * 180/M_PI);

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_CIRCLE (Dwg_Object * obj)
{
  Dwg_Entity_CIRCLE *_obj = &obj->as.entity.as.CIRCLE;

  REC (CIRCLE);
  dxf_entity_common (obj);
  VAL (100, "AcDbCircle");

  if (_obj->thickness != 0.0)
  {
    VAL_1D (39, _obj->thickness);
  }
  VAL_3D (10, 20, 30, _obj->center);
  VAL_1D (40, _obj->radius);
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_LINE (Dwg_Object * obj)
{
  Dwg_Entity_LINE *_obj = &obj->as.entity.as.LINE;

  REC (LINE);
  dxf_entity_common (obj);
  VAL (100, "AcDbLine");

  if (_obj->thickness != 0.0)
  {
    VAL_1D (39, _obj->thickness);
  }

  VAL_3D (10, 20, 30, _obj->start);
  VAL_3D (11, 21, 31, _obj->end);

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_DIMENSION_ORDINATE (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_ORDINATE *_obj = &obj->as.entity.as.DIMENSION_ORDINATE;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 > 6 && _obj->flags_1 < 32)
    {
      VAL (70, 6);
    }
  else
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDbOrdinateDimension");
  VAL_3D (13, 23, 33, _obj->_13_pt);
  VAL_3D (14, 24, 34, _obj->_14_pt);

  /* What is this?
  VAL (70, _obj->flags_2);
  */
}

void
dxf_DIMENSION_LINEAR (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_LINEAR *_obj = &obj->as.entity.as.DIMENSION_LINEAR;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 <= 6 || _obj->flags_1 >= 32)
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDbAlignedDimension");
  if (_obj->_12_pt.x != 0.0 || _obj->_12_pt.y != 0.0 || _obj->elevation.ecs_12 != 0.0)
    {
      VAL_2D (12, 22, _obj->_12_pt);
      VAL_1D (32, _obj->elevation.ecs_12);
    }
  VAL_3D (13, 23, 33, _obj->_13_pt);
  VAL_3D (14, 24, 34, _obj->_14_pt);
  if (_obj->dim_rot != 0.0)
    {
      VAL_1D (50, _obj->dim_rot);
    }
  if (_obj->ext_line_rot != 0.0)
    {
      VAL_1D (52, _obj->ext_line_rot);
    }
  VAL (100, "AcDbRotatedDimension");

  /* Where did this come from?
  VAL_3D (10, 20, 30, _obj->ins_scale);
  VAL_1D (10, _obj->ins_rotation);
   */
}

void
dxf_DIMENSION_ALIGNED (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_ALIGNED *_obj = &obj->as.entity.as.DIMENSION_ALIGNED;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 > 6 && _obj->flags_1 < 32)
    {
      VAL (70, 1);
    }
  else
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDbAlignedDimension");
  if (_obj->_12_pt.x != 0.0 || _obj->_12_pt.y != 0.0 || _obj->elevation.ecs_12 != 0.0)
    {
      VAL_2D (12, 22, _obj->_12_pt);
      VAL_1D (32, _obj->elevation.ecs_12);
    }
  VAL_3D (13, 23, 33, _obj->_13_pt);
  VAL_3D (14, 24, 34, _obj->_14_pt);
}

void
dxf_DIMENSION_ANG3PT (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_ANG3PT *_obj = &obj->as.entity.as.DIMENSION_ANG3PT;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 > 6 && _obj->flags_1 < 32)
    {
      VAL (70, 5);
    }
  else
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDb3PointAngularDimension");

  if (_obj->_12_pt.x != 0.0 || _obj->_12_pt.y != 0.0 || _obj->elevation.ecs_12 != 0.0)
    {
      VAL_2D (12, 22, _obj->_12_pt);
      VAL_1D (32, _obj->elevation.ecs_12);
    }
  VAL_3D (13, 23, 33, _obj->_13_pt);
  VAL_3D (14, 24, 34, _obj->_14_pt);
  VAL_3D (15, 25, 35, _obj->_15_pt);
}

void
dxf_DIMENSION_ANG2LN (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_ANG2LN *_obj = &obj->as.entity.as.DIMENSION_ANG2LN;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 > 6 && _obj->flags_1 < 32)
    {
      VAL (70, 2);
    }
  else
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDb2LineAngularDimension");

  if (_obj->_12_pt.x != 0.0 || _obj->_12_pt.y != 0.0 || _obj->elevation.ecs_12 != 0.0)
    {
      VAL_2D (12, 22, _obj->_12_pt);
      VAL_1D (32, _obj->elevation.ecs_12);
    }
  VAL_3D (13, 23, 33, _obj->_13_pt);
  VAL_3D (14, 24, 34, _obj->_14_pt);
  VAL_3D (15, 25, 35, _obj->_15_pt);
  VAL_2D (16, 26, _obj->_16_pt);
  VAL_1D (36, _obj->elevation.ecs_12);
}

void
dxf_DIMENSION_RADIUS (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_RADIUS *_obj = &obj->as.entity.as.DIMENSION_RADIUS;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 > 6 && _obj->flags_1 < 32)
    {
      VAL (70, 4);
    }
  else
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDbRadialDimension");
  VAL_3D (15, 25, 35, _obj->_15_pt);
  VAL_1D (40, _obj->leader_len);
}

void
dxf_DIMENSION_DIAMETER (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_DIMENSION_DIAMETER *_obj = &obj->as.entity.as.DIMENSION_DIAMETER;

  REC (DIMENSION);
  dxf_entity_common (obj);
  VAL (100, "AcDbDimension");

  idx = dwg_handle_get_index (_obj->block.value);
  if (idx >= dwg->num_objects)
  {
    VAL (2, "*");
  }
  else
  {
    VAL (2, dwg->object[idx].as.nongraph.as.BLOCK_HEADER.entry_name);
  }
  VAL_3D (10, 20, 30, _obj->_10_pt);
  VAL_2D (11, 21, _obj->text_midpt);
  VAL_1D (31, _obj->elevation.ecs_12);
  if (_obj->flags_1 > 6 && _obj->flags_1 < 32)
    {
      VAL (70, 3);
    }
  else
    {
      VAL (70, _obj->flags_1);
    }
  VAL (71, _obj->attachment_point);
  if (_obj->lspace_style != 1)
    {
      VAL (72, _obj->lspace_style);
    }
  if (_obj->lspace_factor != 1.0)
    {
      VAL_1D (41, _obj->lspace_factor);
    }
  VAL_1D (42, _obj->act_measurement);
  if (_obj->user_text)
    if (_obj->user_text[0] != '\0')
      {
        VAL (1, _obj->user_text);
      }
  if (_obj->text_rot != 0.0)
    {
      VAL_1D (53, _obj->text_rot);
    }
  if (_obj->horiz_dir != 0.0)
    {
      VAL_1D (51, _obj->horiz_dir);
    }
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx >= dwg->num_objects)
    {
      VAL (3, "Standard");
    }
  else
    {
      VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }

  VAL (100, "AcDbDiametricDimension");
  VAL_3D (15, 25, 35, _obj->_15_pt);
  VAL_1D (40, _obj->leader_len);
}

void
dxf_POINT (Dwg_Object * obj)
{
  Dwg_Entity_POINT *_obj = &obj->as.entity.as.POINT;

  REC (POINT);
  dxf_entity_common (obj);
  VAL (100, "AcDbPoint");

  VAL_1D (10, _obj->x);
  VAL_1D (20, _obj->y);
  VAL_1D (30, _obj->z);

  if (_obj->thickness != 0.0)
  {
    VAL_1D (39, _obj->thickness);
  }

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }

  if (_obj->x_ang != 0.0)
  {
    VAL_1D (50, _obj->x_ang);
  }
}

void
dxf__3DFACE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity__3DFACE *_obj = &obj->as.entity.as._3DFACE;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (_3DFACE);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "_3DFACE");
      VAL (70, _obj->has_no_flags);
      {
	_obj->z_is_zero = (_obj->corner1.z == 0);
	VAL (70, _obj->z_is_zero);
	VAL_1D (10, _obj->corner1.x);
	VAL_1D (10, _obj->corner1.y);
	if (!_obj->z_is_zero)
	  {
	    VAL_1D (10, _obj->corner1.z);
	  }
      }
      VAL_1D (10, _obj->corner2.x);
      VAL_1D (10, _obj->corner2.y);
      VAL_1D (10, _obj->corner2.z);
      VAL_1D (10, _obj->corner3.x);
      VAL_1D (10, _obj->corner3.y);
      VAL_1D (10, _obj->corner3.z);
      VAL_1D (10, _obj->corner4.x);
      VAL_1D (10, _obj->corner4.y);
      VAL_1D (10, _obj->corner4.z);
}

void
dxf_POLYLINE_PFACE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_POLYLINE_PFACE *_obj = &obj->as.entity.as.POLYLINE_PFACE;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (POLYLINE_PFACE);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "POLYLINE_PFACE");
  VAL (70, _obj->numverts);
  VAL (70, _obj->numfaces);
      VAL (5, _obj->first_vertex.value);
      VAL (5, _obj->last_vertex.value);
  VAL (5, _obj->seqend.value);
}

void
dxf_POLYLINE_MESH (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_POLYLINE_MESH *_obj = &obj->as.entity.as.POLYLINE_MESH;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (POLYLINE_MESH);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "POLYLINE_MESH");
  VAL (70, _obj->flags);
  VAL (70, _obj->curve_type);
  VAL (70, _obj->m_vert_count);
  VAL (70, _obj->n_vert_count);
  VAL (70, _obj->m_density);
  VAL (70, _obj->n_density);
      VAL (5, _obj->first_vertex.value);
      VAL (5, _obj->last_vertex.value);
  VAL (5, _obj->seqend.value);
}

void
dxf_SOLID (Dwg_Object * obj)
{
  Dwg_Entity_SOLID *_obj = &obj->as.entity.as.SOLID;

  REC (SOLID);
  dxf_entity_common (obj);
  VAL (100, "AcDbTrace");

  VAL_2D (10, 20, _obj->corner1);
  VAL_1D (30, _obj->elevation);
  VAL_2D (11, 21, _obj->corner2);
  VAL_1D (31, _obj->elevation);
  VAL_2D (12, 22, _obj->corner3);
  VAL_1D (32, _obj->elevation);
  VAL_2D (13, 23, _obj->corner4);
  VAL_1D (33, _obj->elevation);

  if (_obj->thickness != 0.0)
  {
    VAL_1D (39, _obj->thickness);
  }

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_TRACE (Dwg_Object * obj)
{
  Dwg_Entity_TRACE *_obj = &obj->as.entity.as.TRACE;

  REC (TRACE);
  dxf_entity_common (obj);
  VAL (100, "AcDbTrace");

  VAL_2D (10, 20, _obj->corner1);
  VAL_1D (30, _obj->elevation);
  VAL_2D (11, 21, _obj->corner2);
  VAL_1D (31, _obj->elevation);
  VAL_2D (12, 22, _obj->corner3);
  VAL_1D (32, _obj->elevation);
  VAL_2D (13, 23, _obj->corner4);
  VAL_1D (33, _obj->elevation);

  if (_obj->thickness != 0.0)
  {
    VAL_1D (39, _obj->thickness);
  }

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
  {
    VAL_3D (210, 220, 230, _obj->extrusion);
  }
}

void
dxf_SHAPE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_SHAPE *_obj = &obj->as.entity.as.SHAPE;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (SHAPE);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "SHAPE");
  VAL_3D (10, 20, 30, _obj->ins_pt);
  VAL_1D (10, _obj->scale);
  VAL_1D (10, _obj->rotation);
  VAL_1D (10, _obj->width_factor);
  VAL_1D (10, _obj->oblique);
  VAL_1D (10, _obj->thickness);
  VAL (70, _obj->shape_no);
  VAL_3D (10, 20, 30, _obj->extrusion);
  VAL (5, _obj->shapefile.value);
}

void
dxf_VIEWPORT (Dwg_Object * obj)
{
  static int stack = 1;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_VIEWPORT *_obj = &obj->as.entity.as.VIEWPORT;

  REC (VIEWPORT);
  dxf_entity_common (obj);
  VAL (67, 1); // FIXME only works if there is only one viewport, in PaperSpace0.
  VAL (100, "AcDbViewport");

  VAL_3D (10, 20, 30, _obj->center);
  VAL_1D (40, _obj->width);
  VAL_1D (41, _obj->height);
  VAL (68, stack); // FIXME how to know if it is active or not, and the stack order?
  VAL (69, stack++); // and what about its ID?
  VAL_2D (12, 22, _obj->view_center);
  VAL_2D (13, 23, _obj->snap_base);
  VAL_2D (14, 24, _obj->snap_spacing);
  VAL_2D (15, 25, _obj->grid_spacing);
  VAL_3D (16, 26, 36, _obj->view_direction);
  VAL_3D (17, 27, 37, _obj->view_target);
  VAL_1D (42, _obj->lens_length);
  VAL_1D (43, _obj->front_clip_z);
  VAL_1D (44, _obj->back_clip_z);
  VAL_1D (45, _obj->view_height);
  VAL_1D (50, _obj->snap_angle);
  VAL_1D (51, _obj->view_twist_angle);
  VAL (72, _obj->circle_zoom);
  //VAL (70, _obj->frozen_layer_count); OPT where are the layer handles?
  VAL (90, _obj->status_flags);
  //VAL (340, OPT handle to clipping boundary object);
  VAL (1, _obj->style_sheet);
  VAL (281, _obj->render_mode);
  VAL (71, _obj->ucs_per_viewport);
  VAL (74, _obj->ucs_at_origin);
  VAL_3D (110, 120, 130, _obj->ucs_origin);
  VAL_3D (111, 121, 131, _obj->ucs_x_axis);
  VAL_3D (112, 122, 132, _obj->ucs_y_axis);
  //VAL (345, OPT handle to named UCS);
  //VAL (346, OPT handle to base UCS);
  VAL (79, _obj->ucs_ortho_view_type);
  VAL_1D (146, _obj->ucs_elevation);
}

void
dxf_ELLIPSE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_ELLIPSE *_obj = &obj->as.entity.as.ELLIPSE;

  REC (ELLIPSE);
  dxf_entity_common (obj);
  VAL (100, "AcDbEllipse");

  VAL_3D (10, 20, 30, _obj->center);
  VAL_3D (11, 21, 31, _obj->sm_axis);
  VAL_3D (210, 220, 230, _obj->extrusion);
  VAL_1D (40, _obj->axis_ratio);
  VAL_1D (41, _obj->start_angle);
  VAL_1D (42, _obj->end_angle);
}

void
dxf_SPLINE (Dwg_Object * obj)
{
  uint32_t rcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_SPLINE *_obj = &obj->as.entity.as.SPLINE;

  REC (SPLINE);
  dxf_entity_common (obj);
  VAL (100, "AcDbSpline");

  /* FIXME Normal vector: where is it? Assuming unitary in the for a x-y plane spline. */
  VAL_1D (210, 0);
  VAL_1D (220, 0);
  VAL_1D (230, 1.0);

  /* XXX Forcing Planar & Linear ? Check if scenario is used here...
  VAL (70, _obj->closed_b | _obj->periodic << 1 | _obj->rational << 2 | 1 << 3 | 1 << 5 | _obj->scenario << 9);
   */
  VAL (70, _obj->closed_b | _obj->periodic << 1 | _obj->rational << 2 | 1 << 3 | 1 << 5);

  VAL (71, _obj->degree);
  VAL (72, _obj->num_knots);
  VAL (73, _obj->num_ctrl_pts);

  if (_obj->num_fit_pts > 0)
    {
      VAL (74, _obj->num_fit_pts);
    }

  if (_obj->knot_tol == 0.0)
    {
      VAL_1D (42, 0.000000001);
    }
  else
    {
      VAL_1D (42, _obj->knot_tol);
    }

  if (_obj->ctrl_tol == 0.0)
    {
      VAL_1D (43, 0.0000000001);
    }
  else
    {
      VAL_1D (43, _obj->ctrl_tol);
    }

  if (_obj->fit_tol == 0.0)
    {
      VAL_1D (44, 0.0000000001);
    }
  else
    {
      VAL_1D (44, _obj->fit_tol);
    }

  if (_obj->beg_tan_vec.x != 0 || _obj->beg_tan_vec.y != 0 || _obj->beg_tan_vec.z != 0)
    {
      VAL_3D (12, 22, 32, _obj->beg_tan_vec);
    }
  if (_obj->end_tan_vec.x != 0 || _obj->end_tan_vec.y != 0 || _obj->end_tan_vec.z != 0)
    {
      VAL_3D (13, 23, 33, _obj->end_tan_vec);
    }

  for (rcount = 0; rcount < _obj->num_knots; rcount++)
    {
      VAL_1D (40, _obj->knots[rcount]);
      if (_obj->weighted)
	{
	  VAL_1D (41, _obj->ctrl_pts[rcount].w);
	}
    }
  for (rcount = 0; rcount < _obj->num_ctrl_pts; rcount++)
    {
      VAL_3D (10, 20, 30, _obj->ctrl_pts[rcount]);
    }
  for (rcount = 0; rcount < _obj->num_fit_pts; rcount++)
    {
      VAL_3D (11, 21, 31, _obj->fit_pts[rcount]);
    }
}

int
dxf_3dsolid (Dwg_Object * obj, Dwg_Entity_3DSOLID * _obj)
{
}

void
dxf_REGION (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_REGION *_obj = &obj->as.entity.as.REGION;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (REGION);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "REGION");
  dxf_3dsolid (obj, _obj);;
}

void
dxf__3DSOLID (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity__3DSOLID *_obj = &obj->as.entity.as._3DSOLID;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  REC (_3DSOLID);
  VAL (999, "UNDONE");
  dxf_entity_common (obj);
  VAL (100, "AcDb" "_3DSOLID");
  dxf_3dsolid (obj, _obj);;
}

void
dxf_BODY (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_BODY *_obj = &obj->as.entity.as.BODY;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (BODY);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "BODY");
  dxf_3dsolid (obj, _obj);;
}

void
dxf_RAY (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_RAY *_obj = &obj->as.entity.as.RAY;

  REC (RAY);
  dxf_entity_common (obj);
  VAL (100, "AcDbRay");

  VAL_3D (10, 20, 30, _obj->point);
  VAL_3D (11, 21, 31, _obj->vector);
}

void
dxf_XLINE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_XLINE *_obj = &obj->as.entity.as.XLINE;

  REC (XLINE);
  dxf_entity_common (obj);
  VAL (100, "AcDbXline");

  VAL_3D (10, 20, 30, _obj->point);
  VAL_3D (11, 21, 31, _obj->vector);
}

void
dxf_DICTIONARY (Dwg_Object * obj)
{
  uint32_t vcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_DICTIONARY *_obj = &obj->as.nongraph.as.DICTIONARY;

  if (_obj->numitems > 10000)
    {
      printf ("Strange: dictionary with more than 10 thousand entries! Handle: %X\n", obj->handle.value);
      return;
    }

  REC (DICTIONARY);
  dxf_nongraph_common (obj);
  VAL (100, "AcDbDictionary");

  if (_obj->hard_owner)
    VAL (280, 1);

  VAL (281, _obj->cloning);

  for (vcount = 0; vcount < _obj->numitems; vcount++)
    {
      VAL (3, _obj->text[vcount]);
      VAL (350, _obj->itemhandles[vcount].value);
    }
}

void
dxf_DICTIONARYWDLFT (Dwg_Object * obj)
{
  uint32_t vcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_DICTIONARYWDLFT *_obj = &obj->as.nongraph.as.DICTIONARYWDLFT;

  if (_obj->numitems > 10000)
    {
      printf ("Strange: dictionary with more than 10 thousand entries! Handle: %X\n", obj->handle.value);
      return;
    }

  REC (ACDBDICTIONARYWDFLT);
  dxf_nongraph_common (obj);
  VAL (100, "AcDbDictionary");

  VAL (281, _obj->cloning);

  for (vcount = 0; vcount < _obj->numitems; vcount++)
    {
      VAL (3, _obj->text[vcount]);
      VAL (350, _obj->itemhandles[vcount].value);
    }

  VAL (100, "AcDbDictionaryWithDefault");
  VAL (340, _obj->defaultid.value);
}

void
dxf_MTEXT (Dwg_Object * obj)
{
  uint32_t idx;
  char tmptxt[251];
  char * txt;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_MTEXT *_obj = &obj->as.entity.as.MTEXT;

  REC (MTEXT);
  dxf_entity_common (obj);
  VAL (100, "AcDbMText");

  VAL_3D (10, 20, 30, _obj->insertion_pt);
  VAL_1D (40, _obj->text_height);
  VAL_1D (41, _obj->rect_width);
  VAL (71, _obj->attachment);
  VAL (72, _obj->drawing_dir);

  txt = _obj->text;
  while (strlen (txt) > 250)
    {
      strncpy (tmptxt, txt, 250);
      tmptxt[250] = '\0';
      VAL (3, tmptxt);
      txt += 250;
    }
  VAL (1, txt);

  idx = dwg_handle_get_index (_obj->style.value);
  if (idx < dwg->num_objects)
    {
      txt = dwg->object[idx].as.nongraph.as.SHAPEFILE.entry_name;
      if (strlen (txt) < 250 && strcmp (txt, "Standard") != 0)
        {
          VAL (7, txt);
        }
    }

  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
    {
      VAL_3D (210, 220, 230, _obj->extrusion);
    }
  if (_obj->x_axis_dir.x != 1.0 || _obj->x_axis_dir.y != 0.0 || _obj->x_axis_dir.z != 0.0)
    {
      VAL_3D (11, 21, 31, _obj->x_axis_dir);
    }
  VAL (73, _obj->linespace_style);
  VAL_1D (44, _obj->linespace_factor);

  VAL (1001, "ACAD");
  VAL (1000, "MTEXTBEGIN");
  VAL (1070, 73);
  VAL (1070, _obj->linespace_style);
  VAL (1070, 44);
  VAL_1D (1040, _obj->linespace_factor);
  VAL (1070, 74);
  VAL (1070, 0);
  VAL (1000, "MTEXTEND");
}

void
dxf_LEADER (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_LEADER *_obj = &obj->as.entity.as.LEADER;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (LEADER);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "LEADER");
  VAL (70, _obj->unknown_bit_1);
  VAL (70, _obj->annot_type);
  VAL (70, _obj->path_type);
  VAL (70, _obj->numpts);
  for (vcount = 0; vcount < _obj->numpts; vcount++)
    {
      VAL_3D (10, 20, 30, _obj->points[vcount]);
    };
  VAL_3D (10, 20, 30, _obj->end_pt_proj);
  VAL_3D (10, 20, 30, _obj->extrusion);
  VAL_3D (10, 20, 30, _obj->x_direction);
  VAL_3D (10, 20, 30, _obj->offset_to_block_ins_pt);
  if (R_2000 >= R_14)
    {
      VAL_3D (10, 20, 30, _obj->unknown_pt);
    }
  if (R_2000 >= R_13 && R_2000 <= R_14)
    {
      VAL_1D (10, _obj->dimgap);
    }
  VAL_1D (10, _obj->box_height);
  VAL_1D (10, _obj->box_width);
  VAL (70, _obj->hooklineonxdir);
  VAL (70, _obj->arrowhead_on);
  if (R_2000 >= R_13 && R_2000 <= R_14)
    {
      VAL (70, _obj->arrowhead_type);
      VAL_1D (10, _obj->dimasz);
      VAL (70, _obj->unknown_bit_2);
      VAL (70, _obj->unknown_bit_3);
      VAL (70, _obj->unknown_short_1);
      VAL (70, _obj->byblock_color);
      VAL (70, _obj->unknown_bit_4);
      VAL (70, _obj->unknown_bit_5);
    }
  if (R_2000 >= R_2000)
    {
      VAL (70, _obj->unknown_short_1);
      VAL (70, _obj->unknown_bit_4);
      VAL (70, _obj->unknown_bit_5);
    }
  if (R_2000 >= R_14)
    {
      VAL (5, _obj->associated_annotation.value);
    }
  VAL (5, _obj->dimstyle.value);
}

void
dxf_TOLERANCE (Dwg_Object * obj)
{
  uint32_t idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_TOLERANCE *_obj = &obj->as.entity.as.TOLERANCE;

  REC (TOLERANCE);
  dxf_entity_common (obj);

  VAL (100, "AcDbFcf");
  idx = dwg_handle_get_index (_obj->dimstyle.value);
  if (idx < dwg->num_objects)
    {
          VAL (3, dwg->object[idx].as.nongraph.as.DIMSTYLE.entry_name);
    }
  VAL_3D (10, 20, 30, _obj->ins_pt);
  if (_obj->extrusion.x != 0.0 || _obj->extrusion.y != 0.0 || _obj->extrusion.z != 1.0)
    {
      VAL_3D (210, 220, 230, _obj->extrusion);
    }
  if (_obj->x_direction.x != 1.0 || _obj->x_direction.y != 0.0 || _obj->x_direction.z != 0.0)
    {
      VAL_3D (11, 21, 31, _obj->x_direction);
    }
  VAL (1, _obj->text_string);
}

void
dxf_MLINE (Dwg_Object * obj)
{
  uint32_t rcount, rcount2, rcount3, idx;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_MLINE *_obj = &obj->as.entity.as.MLINE;

  REC (MLINE);
  dxf_entity_common (obj);

  VAL (100, "AcDbMline");
  idx =  dwg_handle_get_index (_obj->mline_style.value);
  if (idx < dwg->num_objects)
    {
      VAL (2, dwg->object[idx].as.nongraph.as.MLINESTYLE.name);
    }
  VAL (340, _obj->mline_style.value);
  VAL_1D (40, _obj->scale);
  VAL (70, _obj->just);
  VAL (71, _obj->open_closed);
  VAL (72, _obj->num_verts);
  VAL (73, _obj->num_lines);
  VAL_3D (10, 20, 30, _obj->base_point);
  VAL_3D (210, 220, 230, _obj->extrusion);

  for (rcount = 0; rcount < _obj->num_verts; rcount++)
    {
      VAL_3D (11, 21, 31, _obj->verts[rcount].vertex);
      VAL_3D (12, 22, 32, _obj->verts[rcount].vertex_direction);
      VAL_3D (13, 23, 33, _obj->verts[rcount].miter_direction);
      for (rcount2 = 0; rcount2 < _obj->num_lines; rcount2++)
	{
	  VAL (74, _obj->verts[rcount].lines[rcount2].num_segparms);
	  for (rcount3 = 0; rcount3 < _obj->verts[rcount].lines[rcount2].num_segparms; rcount3++)
	    {
	      VAL_1D (41, _obj->verts[rcount].lines[rcount2].segparms[rcount3]);
	    }
	  VAL (75, _obj->verts[rcount].lines[rcount2].num_areafillparms);
	  for (rcount3 = 0; rcount3 < _obj->verts[rcount].lines[rcount2].num_areafillparms; rcount3++)
	    {
	      VAL_1D (42, _obj->verts[rcount].lines[rcount2].areafillparms[rcount3]);
	    }
	}
    }
}

void
dxf_GROUP (Dwg_Object * obj)
{
  uint32_t idx, vcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_GROUP *_obj = &obj->as.nongraph.as.GROUP;

  REC (GROUP);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbGroup");
  VAL (300, _obj->str);
  VAL (70, _obj->unnamed);
  VAL (71, _obj->selectable);
  for (vcount = 0; vcount < _obj->num_handles; vcount++)
    {
      VAL (340, _obj->group_entries[vcount].value);
    }
}

void
dxf_MLINESTYLE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_MLINESTYLE *_obj = &obj->as.nongraph.as.MLINESTYLE;
  uint32_t vcount;

  REC (MLINESTYLE);
  dxf_nongraph_common (obj);
  VAL (100, "AcDbMlineStyle");

  VAL (2, _obj->name);
  VAL (70, _obj->flags);
  VAL (3, _obj->desc);
  VAL (62, _obj->fillcolor.index);
  VAL_1D (51, _obj->startang*180/M_PI);
  VAL_1D (52, _obj->endang*180/M_PI);
  VAL (71, _obj->linesinstyle);
  for (vcount = 0; vcount < _obj->linesinstyle; vcount++)
    {
      VAL_1D (49, _obj->lines[vcount].offset);
      VAL (62, _obj->lines[vcount].color.index);
      VAL (6, "BYLAYER"); // FIXME where to take a name from this index? _obj->lines[vcount].ltindex
    }
}

void
dxf_DICTIONARYVAR (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_DICTIONARYVAR *_obj = &obj->as.nongraph.as.DICTIONARYVAR;
  uint32_t vcount;

  REC (DICTIONARYVAR);
  dxf_nongraph_common (obj);
  VAL (100, "DictionaryVariables");

  VAL (280, _obj->intval);
  VAL (1, _obj->str);
}

void
dxf_HATCH (Dwg_Object * obj)
{
  uint32_t totbh = 0, rcount, rcount2, rcount3, vcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_HATCH *_obj = &obj->as.entity.as.HATCH;

  REC (HATCH);
  dxf_entity_common (obj);
  VAL (100, "AcDbHatch");

  VAL_1D (10, 0.0);
  VAL_1D (20, 0.0);
  VAL_1D (30, _obj->z_coord);
  VAL_3D (210, 220, 230, _obj->extrusion);
  VAL (2, _obj->name);
  VAL (70, _obj->solid_fill);
  VAL (71, _obj->associative);
  VAL (91, _obj->num_paths);

  for (rcount = 0; rcount < _obj->num_paths; rcount++)
    {
      VAL (92, _obj->paths[rcount].flag);
      if (!(_obj->paths[rcount].flag & 2))
	{
	  VAL (93, _obj->paths[rcount].num_path_segs);
	  for (rcount2 = 0; rcount2 < _obj->paths[rcount].num_path_segs; rcount2++)
	    {
	      VAL (72, _obj->paths[rcount].segs[rcount2].type_status);
	      switch (_obj->paths[rcount].segs[rcount2].type_status)
		{
		case 1:
		  VAL_2D (10, 20, _obj->paths[rcount].segs[rcount2].first_endpoint);
		  VAL_2D (11, 21, _obj->paths[rcount].segs[rcount2].second_endpoint);
		  break;
		case 2:
		  VAL_2D (10, 20, _obj->paths[rcount].segs[rcount2].center);
		  VAL_1D (40, _obj->paths[rcount].segs[rcount2].radius);
		  VAL_1D (50, _obj->paths[rcount].segs[rcount2].start_angle * 180/M_PI);
		  VAL_1D (51, _obj->paths[rcount].segs[rcount2].end_angle * 180/M_PI);
		  VAL (73, _obj->paths[rcount].segs[rcount2].is_ccw);
		  break;
		case 3:
		  VAL_2D (10, 20, _obj->paths[rcount].segs[rcount2].center);
		  VAL_2D (11, 21, _obj->paths[rcount].segs[rcount2].endpoint);
		  VAL_1D (40, _obj->paths[rcount].segs[rcount2].minor_major_ratio);
		  VAL_1D (50, _obj->paths[rcount].segs[rcount2].start_angle * 180/M_PI);
		  VAL_1D (51, _obj->paths[rcount].segs[rcount2].end_angle * 180/M_PI);
		  VAL (73, _obj->paths[rcount].segs[rcount2].is_ccw);
		  break;
		case 4:
		  VAL (94, _obj->paths[rcount].segs[rcount2].degree);
		  VAL (73, _obj->paths[rcount].segs[rcount2].is_rational);
		  VAL (74, _obj->paths[rcount].segs[rcount2].is_periodic);
		  VAL (95, _obj->paths[rcount].segs[rcount2].num_knots);
		  VAL (96, _obj->paths[rcount].segs[rcount2].num_control_points);
		  for (vcount = 0; vcount < _obj->paths[rcount].segs[rcount2].num_knots; vcount++)
		    {
		      VAL_1D (40, _obj->paths[rcount].segs[rcount2].knots[vcount]);
		    }
		  for (rcount3 = 0; rcount3 < _obj->paths[rcount].segs[rcount2].num_control_points; rcount3++)
		    {
		      VAL_2D (10, 20, _obj->paths[rcount].segs[rcount2].control_points[rcount3].point);
		      if (_obj->paths[rcount].segs[rcount2].is_rational)
			{
			  VAL_1D (42, _obj->paths[rcount]. segs[rcount2].control_points[rcount3].weigth);
			}
		    }
		  break;
		}
	    }
	}
      else
	{
	  VAL (72, _obj->paths[rcount].bulges_present);
	  VAL (73, _obj->paths[rcount].closed);
	  VAL (93, _obj->paths[rcount].num_path_segs);
	  for (rcount2 = 0; rcount2 < _obj->paths[rcount].num_path_segs; rcount2++)
	    {
	      VAL_2D (10, 20, _obj->paths[rcount].polyline_paths[rcount2].point);
	      if (_obj->paths[rcount].bulges_present)
		{
		  VAL_1D (42, 1);
		}
	    }
	}
      VAL (97, _obj->paths[rcount].num_boundary_handles);
      for (vcount = 0; vcount < _obj->paths[rcount].num_boundary_handles; vcount++)
        {
          VAL (330, _obj->boundary_handles[totbh].value);
	  totbh++;
        }
    }

  VAL (75, _obj->style);
  VAL (76, _obj->pattern_type);
  if (!_obj->solid_fill)
    {
      VAL_1D (52, _obj->angle * 180/M_PI);
      VAL_1D (41, _obj->scale_spacing);
      VAL (77, _obj->double_flag);
      VAL (78, _obj->num_deflines);
      for (rcount = 0; rcount < _obj->num_deflines; rcount++)
	{
	  VAL_1D (53, _obj->deflines[rcount].angle * 180/M_PI);
	  VAL_2D (43, 44, _obj->deflines[rcount].pt0);
	  VAL_2D (45, 46, _obj->deflines[rcount].offset);
	  VAL (79, _obj->deflines[rcount].num_dashes);
	  for (rcount2 = 0; rcount2 < _obj->deflines[rcount].num_dashes; rcount2++)
	    {
	      VAL_1D (49, _obj->deflines[rcount].dashes[rcount2]);
	    }
	}
    }
  if (_obj->has_derived)
    {
      VAL_1D (47, _obj->pixel_size);
    }
  VAL (98, _obj->num_seeds);
  for (vcount = 0; vcount < _obj->num_seeds; vcount++)
    {
      VAL_2D (10, 20, _obj->seeds[vcount]);
    }
}

void
dxf_IDBUFFER (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_IDBUFFER *_obj = &obj->as.nongraph.as.IDBUFFER;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (IDBUFFER);
  dxf_nongraph_common (obj);
  VAL (100, "AcDb" "IDBUFFER");
  VAL (70, _obj->unknown);
  VAL (70, _obj->num_ids);
  VAL (330, obj->as.nongraph.parenthandle.value);
  for (vcount = 0; vcount < obj->num_reactors; vcount++)
    {
      VAL (5, obj->reactors[vcount].value);
    }
  VAL (5, obj->xdicobjhandle.value);
  for (vcount = 0; vcount < _obj->num_ids; vcount++)
    {
      VAL (5, _obj->obj_ids[vcount].value);
    }
}

void
dxf_IMAGE (Dwg_Object * obj)
{
  uint32_t rcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_IMAGE *_obj = &obj->as.entity.as.IMAGE;

  REC (IMAGE);
  dxf_entity_common (obj);

  VAL (100, "AcDbRasterImage");
  VAL (90, _obj->class_version);
  VAL_3D (10, 20, 30, _obj->pt0);
  VAL_3D (11, 21, 31, _obj->uvec);
  VAL_3D (12, 22, 32, _obj->vvec);
  VAL_1D (13, _obj->size.width);
  VAL_1D (23, _obj->size.height);
  VAL (340, _obj->imagedef.value);
  VAL (70, _obj->display_props);
  VAL (280, _obj->clipping);
  VAL (281, _obj->brightness);
  VAL (282, _obj->contrast);
  VAL (283, _obj->fade);
  VAL (360, _obj->imagedefreactor.value);
  VAL (71, _obj->clip_boundary_type);
  if (_obj->clip_boundary_type == 1)
    {
      VAL (91, 2);
      VAL_2D (14, 24, _obj->boundary_pt0);
      VAL_2D (14, 24, _obj->boundary_pt1);
    }
  else
    {
      VAL (91, _obj->num_clip_verts);
      for (rcount = 0; rcount < _obj->num_clip_verts; rcount++)
	{
	  VAL_2D (14, 24, _obj->clip_verts[rcount]);
	}
    }
}

void
dxf_IMAGEDEF (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_IMAGEDEF *_obj = &obj->as.nongraph.as.IMAGEDEF;

  REC (IMAGEDEF);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbRasterImageDef");
  VAL (90, _obj->class_version);
  VAL (1, _obj->file_path);
  VAL_2D (10, 20, _obj->image_size);
  VAL_2D (11, 21, _obj->pixel_size);
  VAL (280, _obj->is_loaded);
  VAL (281, _obj->resunits);
}

void
dxf_IMAGEDEFREACTOR (Dwg_Object * obj)
{
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Object_Nongraph *ngr = &obj->as.nongraph;
  Dwg_Nongraph_IMAGEDEFREACTOR *_obj = &obj->as.nongraph.as.IMAGEDEFREACTOR;

  REC (IMAGEDEF_REACTOR);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbRasterImageDefReactor");
  VAL (90, _obj->class_version);
  VAL (330, dwg_handle_absolute (&ngr->parenthandle, obj->handle.value));
}

void
dxf_LAYER_INDEX (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_LAYER_INDEX *_obj = &obj->as.nongraph.as.LAYER_INDEX;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (LAYER_INDEX);
  dxf_nongraph_common (obj);
  VAL (100, "AcDb" "LAYER_INDEX");
  VAL (70, _obj->timestamp1);
  VAL (70, _obj->timestamp2);
  VAL (70, _obj->num_entries);
  for (rcount = 0; rcount < _obj->num_entries; rcount++)
    {
      VAL (70, _obj->entries[rcount].index_long);
      VAL (1, _obj->entries[rcount].index_str);
    }
  VAL (330, obj->as.nongraph.parenthandle.value);
  for (vcount = 0; vcount < obj->num_reactors; vcount++)
    {
      VAL (5, obj->reactors[vcount].value);
    }
  VAL (5, obj->xdicobjhandle.value);
  for (vcount = 0; vcount < _obj->num_entries; vcount++)
    {
      VAL (5, _obj->entry_handles[vcount].value);
    }
}

void
dxf_LAYOUT (Dwg_Object * obj)
{
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_LAYOUT *_obj = &obj->as.nongraph.as.LAYOUT;

  REC (LAYOUT);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbPlotSettings");
  VAL (1, _obj->page_setup_name);
  VAL (2, _obj->printer_or_config);
  VAL (4, _obj->paper_size);
  VAL (6, _obj->plot_view_name);
  VAL_1D (40, _obj->left_margin);
  VAL_1D (41, _obj->bottom_margin);
  VAL_1D (42, _obj->right_margin);
  VAL_1D (43, _obj->top_margin);
  VAL_1D (44, _obj->paper_width);
  VAL_1D (45, _obj->paper_height);
  VAL_2D (46, 47, _obj->plot_origin);
  VAL_2D (48, 49, _obj->window_min);
  VAL_2D (140, 141, _obj->window_max);
  VAL_1D (142, _obj->real_world_units);
  VAL_1D (143, _obj->drawing_units);
  VAL (70, _obj->plot_layout_flags);
  VAL (72, _obj->paper_units);
  VAL (73, _obj->plot_rotation);
  VAL (74, _obj->plot_type);
  VAL (7, _obj->current_style_sheet);
  VAL (75, _obj->scale_type);
  VAL_1D (147, _obj->scale_factor);
  VAL_2D (148, 149, _obj->paper_image_origin);

  VAL (100, "AcDbLayout");
  VAL (1, _obj->layout_name);
  VAL (70, _obj->flags);
  VAL (71, _obj->tab_order);
  VAL_2D (10, 20, _obj->minimum_limits);
  VAL_2D (11, 21, _obj->maximum_limits);
  VAL_3D (12, 22, 32, _obj->ins_point);
  VAL_3D (14, 24, 34, _obj->extent_min);
  VAL_3D (15, 25, 35, _obj->extent_max);
  VAL_1D (146, _obj->elevation);
  VAL_3D (13, 23, 33, _obj->ucs_origin);
  VAL_3D (16, 26, 36, _obj->ucs_x_axis);
  VAL_3D (17, 27, 37, _obj->ucs_y_axis);
  VAL (76, _obj->orthoview_type);
  VAL (330, _obj->associated_paperspace_block_record_handle.value);
  VAL (331, _obj->last_active_viewport_handle.value);
  if (_obj->named_ucs_handle.value != 0)
    {
      VAL (345, _obj->named_ucs_handle.value);
    }
  if (_obj->base_ucs_handle.value != 0)
    {
      VAL (346, _obj->base_ucs_handle.value);
    }
}

void
dxf_LWPLINE (Dwg_Object * obj)
{
  uint32_t vcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_LWPLINE *_obj = &obj->as.entity.as.LWPLINE;

  REC (LWPOLYLINE);
  dxf_entity_common (obj);
  VAL (100, "AcDbPolyline");

  VAL (90, _obj->num_points);
  VAL (70, _obj->flags >> 9); // XXX Check this flag, are the 7MSB == 70 DXF group-code?
  VAL_1D (43, _obj->const_width);
  if (_obj->flags & 8)
    {
      VAL_1D (38, _obj->elevation);
    }
  if (_obj->flags & 2)
    {
      VAL_1D (39, _obj->thickness);
    }
  for (vcount = 0; vcount < _obj->num_points; vcount++)
    {
      VAL_2D (10, 20, _obj->points[vcount]);
    }
  for (vcount = 0; vcount < _obj->num_widths; vcount++)
    {
      VAL_1D (40, _obj->widths[vcount].start);
      VAL_1D (41, _obj->widths[vcount].end);
    }
  for (vcount = 0; vcount < _obj->num_bulges; vcount++)
    {
      VAL_1D (42, _obj->bulges[vcount]);
    }
  if (_obj->flags & 1)
    {
      VAL_3D (210, 220, 230, _obj->normal);
    }
}

void
dxf_OLE2FRAME (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_OLE2FRAME *_obj = &obj->as.entity.as.OLE2FRAME;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (OLE2FRAME);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "OLE2FRAME");
  VAL (70, _obj->flags);
  if (R_2000 >= R_2000)
    {
      VAL (70, _obj->mode);
    }
  VAL (70, _obj->data_length);
  for (vcount = 0; vcount < _obj->data_length; vcount++)
    {
      VAL (70, _obj->data[vcount]);
    };
  if (R_2000 >= R_2000)
    {
      VAL (70, _obj->unknown);
    }
  ;
}

void
dxf_PROXY (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_PROXY *_obj = &obj->as.nongraph.as.PROXY;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (PROXY);
  dxf_nongraph_common (obj);
  VAL (100, "AcDb" "PROXY");
  if (R_2000 >= R_2000)
    {
      VAL (70, _obj->class_id);
      VAL (70, _obj->object_drawing_format);
      VAL (70, _obj->original_data_format);
    }
}

void
dxf_RASTERVARIABLES (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_RASTERVARIABLES *_obj = &obj->as.nongraph.as.RASTERVARIABLES;

  REC (RASTERVARIABLES);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbRasterVariables");
  VAL (90, _obj->class_version);
  VAL (70, _obj->display_frame);
  VAL (71, _obj->display_quality);
  VAL (72, _obj->units);
}

void
dxf_SORTENTSTABLE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_SORTENTSTABLE *_obj = &obj->as.nongraph.as.SORTENTSTABLE;
  uint32_t vcount;

  REC (SORTENTSTABLE);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbSortentsTable");
  VAL (330, _obj->owner_handle.value);
  for (vcount = 0; vcount < _obj->num_entries; vcount++)
    {
      VAL (331, _obj->object_handles[vcount].value);
      VAL (5, _obj->sort_handles[vcount].value);
    }
}

void
dxf_SPATIAL_FILTER (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_SPATIAL_FILTER *_obj = &obj->as.nongraph.as.SPATIAL_FILTER;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (SPATIAL_FILTER);
  dxf_nongraph_common (obj);
  VAL (100, "AcDb" "SPATIAL_FILTER");
  VAL (70, _obj->num_points);
  for (vcount = 0; vcount < _obj->num_points; vcount++)
    {
      VAL_2D (10, 20, _obj->points[vcount]);
    };
  VAL_3D (10, 20, 30, _obj->extrusion);
  VAL_3D (10, 20, 30, _obj->clip_bound_origin);
  VAL (70, _obj->display_boundary);
  VAL (70, _obj->front_clip_on);
  if (_obj->front_clip_on == 1)
    {
      VAL_1D (10, _obj->front_clip_dist);
    }
  VAL (70, _obj->back_clip_on);
  if (_obj->back_clip_on == 1)
    {
      VAL_1D (10, _obj->back_clip_dist);
    }
  for (vcount = 0; vcount < 12; vcount++)
    {
      VAL_1D (10, _obj->inverse_block_transform[vcount]);
    }
  for (vcount = 0; vcount < 12; vcount++)
    {
      VAL_1D (10, _obj->clip_bound_transform[vcount]);
    }
  VAL (330, obj->as.nongraph.parenthandle.value);
  for (vcount = 0; vcount < obj->num_reactors; vcount++)
    {
      VAL (5, obj->reactors[vcount].value);
    }
  VAL (5, obj->xdicobjhandle.value);
}

void
dxf_SPATIAL_INDEX (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_SPATIAL_INDEX *_obj = &obj->as.nongraph.as.SPATIAL_INDEX;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (SPATIAL_INDEX);
  dxf_nongraph_common (obj);
  VAL (100, "AcDb" "SPATIAL_INDEX");
  VAL (70, _obj->timestamp1);
  VAL (70, _obj->timestamp2);
  VAL (330, obj->as.nongraph.parenthandle.value);
  for (vcount = 0; vcount < obj->num_reactors; vcount++)
    {
      VAL (5, obj->reactors[vcount].value);
    }
  VAL (5, obj->xdicobjhandle.value);;
}

void
dxf_TABLE (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_TABLE *_obj = &obj->as.entity.as.TABLE;
  uint32_t rcount = 0, rcount2 = 0, rcount3 = 0, vcount = 0;
  VAL (999, "UNDONE");
  REC (TABLE);
  dxf_entity_common (obj);
  VAL (100, "AcDb" "TABLE");
  VAL_3D (10, 20, 30, _obj->insertion_point);
      VAL (70, _obj->data_flags);
      switch (_obj->data_flags)
	{
	case 0:
	  _obj->scale.x = 1.0;
	  VAL_1D (10, _obj->scale.y);
	  VAL_1D (10, _obj->scale.z);
	  break;
	case 1:
	  _obj->scale.x = 1.0;
	  VAL_1D (10, _obj->scale.y);
	  VAL_1D (10, _obj->scale.z);
	  break;
	case 2:
	  VAL_1D (10, _obj->scale.x);
	  _obj->scale.y = _obj->scale.x;
	  _obj->scale.z = _obj->scale.x;
	  break;
	case 3:
	  _obj->scale.x = 1.0;
	  _obj->scale.y = 1.0;
	  _obj->scale.z = 1.0;
	  break;
	}
  VAL_1D (10, _obj->rotation);
  VAL_3D (10, 20, 30, _obj->extrusion);
  VAL (70, _obj->has_attribs);
  VAL (70, _obj->flag_for_table_value);
  VAL_3D (10, 20, 30, _obj->horiz_direction);
  VAL (70, _obj->num_cols);
  VAL (70, _obj->num_rows);
  for (vcount = 0; vcount < _obj->num_cols; vcount++)
    {
      VAL_1D (10, _obj->col_widths[vcount]);
    }
  for (vcount = 0; vcount < _obj->num_rows; vcount++)
    {
      VAL_1D (10, _obj->row_heights[vcount]);
    }
  for (rcount = 0; rcount < _obj->num_rows * _obj->num_cols; rcount++)
    {
      VAL (70, _obj->cells[rcount].type);
      VAL (70, _obj->cells[rcount].flags);
      VAL (70, _obj->cells[rcount].merged_value);
      VAL (70, _obj->cells[rcount].autofit_flag);
      VAL (70, _obj->cells[rcount].merged_width_flag);
      VAL (70, _obj->cells[rcount].merged_height_flag);
      VAL_1D (10, _obj->cells[rcount].rotation_value);
      if (_obj->cells[rcount].type == 1)
	{
	  VAL (1, _obj->cells[rcount].text_string);
	}
      if (_obj->cells[rcount].type == 2)
	{
	  VAL_1D (10, _obj->cells[rcount].block_scale);
	  VAL (70, _obj->cells[rcount].additional_data_flag);
	  if (_obj->cells[rcount].additional_data_flag == 1)
	    {
	      VAL (70, _obj->cells[rcount].attr_def_count);
	      VAL (70, _obj->cells[rcount].attr_def_index);
	      VAL (1, _obj->cells[rcount].attr_def_text);
	    }
	}
      if (_obj->cells[rcount].type == 1 || _obj->cells[rcount].type == 2)
	{
	  VAL (70, _obj->cells[rcount].additional_data_flag);
	  if (_obj->cells[rcount].additional_data_flag == 1)
	    {
	      VAL (70, _obj->cells[rcount].cell_flag_override);
	      VAL (70, _obj->cells[rcount].virtual_edge_flag);
	      if (_obj->cells[rcount].cell_flag_override & 0x01)
		{
		  VAL (70, _obj->cells[rcount].cell_alignment);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x02)
		{
		  VAL (70, _obj->cells[rcount].background_fill_none);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x04)
		{
		  VAL (62, _obj->cells[rcount].background_color.index);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x08)
		{
		  VAL (62, _obj->cells[rcount].content_color.index);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x20)
		{
		  VAL_1D (10, _obj->cells[rcount].text_height);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x00040)
		{
		  VAL (62, _obj->cells[rcount].top_grid_color.index);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x00400)
		{
		  VAL (70, _obj->cells[rcount].top_grid_linewt);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x04000)
		{
		  VAL (70, _obj->cells[rcount].top_visibility);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x00080)
		{
		  VAL (62, _obj->cells[rcount].right_grid_color.index);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x00800)
		{
		  VAL (70, _obj->cells[rcount].right_grid_linewt);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x08000)
		{
		  VAL (70, _obj->cells[rcount].right_visibility);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x00100)
		{
		  VAL (62, _obj->cells[rcount].bottom_grid_color.index);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x01000)
		{
		  VAL (70, _obj->cells[rcount].bottom_grid_linewt);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x10000)
		{
		  VAL (70, _obj->cells[rcount].bottom_visibility);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x00200)
		{
		  VAL (62, _obj->cells[rcount].left_grid_color.index);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x02000)
		{
		  VAL (70, _obj->cells[rcount].left_grid_linewt);
		}
	      if (_obj->cells[rcount].cell_flag_override & 0x20000)
		{
		  VAL (70, _obj->cells[rcount].left_visibility);
		}
	    }
	}
    }
  VAL (70, _obj->table_overrides_present);
  if (_obj->table_overrides_present == 1)
    {
      VAL (70, _obj->table_flag_override);
      if (_obj->table_flag_override & 0x0001)
	{
	  VAL (70, _obj->title_suppressed);
	}
      VAL (70, _obj->header_suppressed);
      if (_obj->table_flag_override & 0x0004)
	{
	  VAL (70, _obj->flow_direction);
	}
      if (_obj->table_flag_override & 0x0008)
	{
	  VAL_1D (10, _obj->horiz_cell_margin);
	}
      if (_obj->table_flag_override & 0x0010)
	{
	  VAL_1D (10, _obj->vert_cell_margin);
	}
      if (_obj->table_flag_override & 0x0020)
	{
	  VAL (62, _obj->title_row_color.index);
	}
      if (_obj->table_flag_override & 0x0040)
	{
	  VAL (62, _obj->header_row_color.index);
	}
      if (_obj->table_flag_override & 0x0080)
	{
	  VAL (62, _obj->data_row_color.index);
	}
      if (_obj->table_flag_override & 0x0100)
	{
	  VAL (70, _obj->title_row_fill_none);
	}
      if (_obj->table_flag_override & 0x0200)
	{
	  VAL (70, _obj->header_row_fill_none);
	}
      if (_obj->table_flag_override & 0x0400)
	{
	  VAL (70, _obj->data_row_fill_none);
	}
      if (_obj->table_flag_override & 0x0800)
	{
	  VAL (62, _obj->title_row_fill_color.index);
	}
      if (_obj->table_flag_override & 0x1000)
	{
	  VAL (62, _obj->header_row_fill_color.index);
	}
      if (_obj->table_flag_override & 0x2000)
	{
	  VAL (62, _obj->data_row_fill_color.index);
	}
      if (_obj->table_flag_override & 0x4000)
	{
	  VAL (70, _obj->title_row_align);
	}
      if (_obj->table_flag_override & 0x8000)
	{
	  VAL (70, _obj->header_row_align);
	}
      if (_obj->table_flag_override & 0x10000)
	{
	  VAL (70, _obj->data_row_align);
	}
      if (_obj->table_flag_override & 0x100000)
	{
	  VAL_1D (10, _obj->title_row_height);
	}
      if (_obj->table_flag_override & 0x200000)
	{
	  VAL_1D (10, _obj->header_row_height);
	}
      if (_obj->table_flag_override & 0x400000)
	{
	  VAL_1D (10, _obj->data_row_height);
	}
    }
  VAL (70, _obj->border_color_overrides_present);
  if (_obj->border_color_overrides_present == 1)
    {
      VAL (70, _obj->border_color_overrides_flag);
      if (_obj->border_color_overrides_flag & 0x0001)
	{
	  VAL (62, _obj->title_horiz_top_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0002)
	{
	  VAL (62, _obj->title_horiz_ins_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0004)
	{
	  VAL (62, _obj->title_horiz_bottom_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0008)
	{
	  VAL (62, _obj->title_vert_left_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0010)
	{
	  VAL (62, _obj->title_vert_ins_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0020)
	{
	  VAL (62, _obj->title_vert_right_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0040)
	{
	  VAL (62, _obj->header_horiz_top_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0080)
	{
	  VAL (62, _obj->header_horiz_ins_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0100)
	{
	  VAL (62, _obj->header_horiz_bottom_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0200)
	{
	  VAL (62, _obj->header_vert_left_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0400)
	{
	  VAL (62, _obj->header_vert_ins_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x0800)
	{
	  VAL (62, _obj->header_vert_right_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x1000)
	{
	  VAL (62, _obj->data_horiz_top_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x2000)
	{
	  VAL (62, _obj->data_horiz_ins_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x4000)
	{
	  VAL (62, _obj->data_horiz_bottom_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x8000)
	{
	  VAL (62, _obj->data_vert_left_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x10000)
	{
	  VAL (62, _obj->data_vert_ins_color.index);
	}
      if (_obj->border_color_overrides_flag & 0x20000)
	{
	  VAL (62, _obj->data_vert_right_color.index);
	}
    }
  VAL (70, _obj->border_lineweight_overrides_present);
  if (_obj->border_lineweight_overrides_present == 1)
    {
      VAL (70, _obj->border_lineweight_overrides_flag);
      if (_obj->border_lineweight_overrides_flag & 0x0001)
	{
	  VAL (70, _obj->title_horiz_top_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0002)
	{
	  VAL (70, _obj->title_horiz_ins_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0004)
	{
	  VAL (70, _obj->title_horiz_bottom_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0008)
	{
	  VAL (70, _obj->title_vert_left_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0010)
	{
	  VAL (70, _obj->title_vert_ins_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0020)
	{
	  VAL (70, _obj->title_vert_right_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0040)
	{
	  VAL (70, _obj->header_horiz_top_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0080)
	{
	  VAL (70, _obj->header_horiz_ins_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0100)
	{
	  VAL (70, _obj->header_horiz_bottom_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0200)
	{
	  VAL (70, _obj->header_vert_left_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0400)
	{
	  VAL (70, _obj->header_vert_ins_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x0800)
	{
	  VAL (70, _obj->header_vert_right_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x1000)
	{
	  VAL (70, _obj->data_horiz_top_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x2000)
	{
	  VAL (70, _obj->data_horiz_ins_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x4000)
	{
	  VAL (70, _obj->data_horiz_bottom_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x8000)
	{
	  VAL (70, _obj->data_vert_left_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x10000)
	{
	  VAL (70, _obj->data_vert_ins_lineweigh);
	}
      if (_obj->border_lineweight_overrides_flag & 0x20000)
	{
	  VAL (70, _obj->data_vert_right_lineweigh);
	}
    }
  VAL (70, _obj->border_visibility_overrides_present);
  if (_obj->border_visibility_overrides_present == 1)
    {
      VAL (70, _obj->border_visibility_overrides_flag);
      if (_obj->border_visibility_overrides_flag & 0x0001)
	{
	  VAL (70, _obj->title_horiz_top_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0002)
	{
	  VAL (70, _obj->title_horiz_ins_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0004)
	{
	  VAL (70, _obj->title_horiz_bottom_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0008)
	{
	  VAL (70, _obj->title_vert_left_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0010)
	{
	  VAL (70, _obj->title_vert_ins_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0020)
	{
	  VAL (70, _obj->title_vert_right_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0040)
	{
	  VAL (70, _obj->header_horiz_top_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0080)
	{
	  VAL (70, _obj->header_horiz_ins_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0100)
	{
	  VAL (70, _obj->header_horiz_bottom_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0200)
	{
	  VAL (70, _obj->header_vert_left_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0400)
	{
	  VAL (70, _obj->header_vert_ins_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x0800)
	{
	  VAL (70, _obj->header_vert_right_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x1000)
	{
	  VAL (70, _obj->data_horiz_top_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x2000)
	{
	  VAL (70, _obj->data_horiz_ins_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x4000)
	{
	  VAL (70, _obj->data_horiz_bottom_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x8000)
	{
	  VAL (70, _obj->data_vert_left_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x10000)
	{
	  VAL (70, _obj->data_vert_ins_visibility);
	}
      if (_obj->border_visibility_overrides_flag & 0x20000)
	{
	  VAL (70, _obj->data_vert_right_visibility);
	}
    }
  VAL (5, _obj->block_header.value);
      if (_obj->has_attribs)
	{
	  VAL (5, _obj->first_attrib.value);
	  VAL (5, _obj->last_attrib.value);
          VAL (5, _obj->seqend.value);
	}
  VAL (5, _obj->table_style_id.value);
  for (rcount = 0; rcount < _obj->num_rows * _obj->num_cols; rcount++)
    {
      VAL (5, _obj->cells[rcount].cell_handle.value);
      if (_obj->cells[rcount].type == 2 &&
	  _obj->cells[rcount].additional_data_flag == 1)
	{
	  for (vcount = 0; vcount < _obj->cells[rcount].attr_def_count;
	       vcount++)
	    {
	      VAL (5, _obj->cells[rcount].attr_def_id[vcount].value);
	    };
	}
      if (_obj->cells[rcount].additional_data_flag2 == 1 &&
	  _obj->cells[rcount].cell_flag_override & 0x08)
	{
	  VAL (5, _obj->cells[rcount].text_style_override.value);
	}
    }
  VAL (5, _obj->title_row_style_override.value);
  VAL (5, _obj->header_row_style_override.value);
  VAL (5, _obj->data_row_style_override.value);
}

void
dxf_XRECORD (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_XRECORD *_obj = &obj->as.nongraph.as.XRECORD;

  REC (XRECORD);
  dxf_nongraph_common (obj);
  VAL (100, "AcDbXrecord");

  VAL (280, _obj->cloning_flags);
}

void
dxf_PLACEHOLDER (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_PLACEHOLDER *_obj = &obj->as.nongraph.as.PLACEHOLDER;
  uint32_t vcount = 0;

  REC (ACDBPLACEHOLDER);
  dxf_nongraph_common (obj);
}

void
dxf_WIPEOUT (Dwg_Object * obj)
{
  uint32_t rcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Entity_IMAGE *_obj = &obj->as.entity.as.IMAGE;

  REC (WIPEOUT);
  dxf_entity_common (obj);

  VAL (100, "AcDbWipeout");
  VAL (90, _obj->class_version);
  VAL_3D (10, 20, 30, _obj->pt0);
  VAL_3D (11, 21, 31, _obj->uvec);
  VAL_3D (12, 22, 32, _obj->vvec);
  VAL_1D (13, _obj->size.width);
  VAL_1D (23, _obj->size.height);
  VAL (340, _obj->imagedef.value);
  VAL (70, _obj->display_props);
  VAL (280, _obj->clipping);
  VAL (281, _obj->brightness);
  VAL (282, _obj->contrast);
  VAL (283, _obj->fade);
  VAL (360, _obj->imagedefreactor.value);
  VAL (71, _obj->clip_boundary_type);
  if (_obj->clip_boundary_type == 1)
    {
      VAL (91, 2);
      VAL_2D (14, 24, _obj->boundary_pt0);
      VAL_2D (14, 24, _obj->boundary_pt1);
    }
  else
    {
      int not_closed =
         _obj->clip_verts[0].x != _obj->clip_verts[_obj->num_clip_verts-1].x ||
         _obj->clip_verts[0].y != _obj->clip_verts[_obj->num_clip_verts-1].y;
      if (not_closed)
        {
          VAL (91, _obj->num_clip_verts + 1);
        }
      else
        {
          VAL (91, _obj->num_clip_verts);
        }
      for (rcount = 0; rcount < _obj->num_clip_verts; rcount++)
	{
	  VAL_2D (14, 24, _obj->clip_verts[rcount]);
	}
      if (not_closed)
	{
	  VAL_1D (14, _obj->clip_verts[0].x);
	  VAL_1D (24, _obj->clip_verts[0].y);
	}
    }
}

void
dxf_WIPEOUTVARIABLES (Dwg_Object * obj)
{
  Dwg_Struct *dwg = obj->parent;
  Dwg_Nongraph_WIPEOUTVARIABLES *_obj = &obj->as.nongraph.as.WIPEOUTVARIABLES;

  REC (WIPEOUTVARIABLES);
  dxf_nongraph_common (obj);

  VAL (100, "AcDbWipeoutVariables");
  VAL (70, _obj->display_frame);
}
