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
 *     \file       dwg_object.spe.c
 *     \brief      DWG objects specification
 *     \author     written by Felipe Castro
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifdef IS_PRINT
#  undef IS_ENCODER
#  ifndef IS_DECODER
#    define IS_DECODER
#  endif
#endif

#define TODO_ENCODER fprintf(stderr, "TODO: Encoder\n");
#define TODO_DECODER fprintf(stderr, "TODO: Decoder\n");

DWG_ENTITY(UNUSED);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(1)*/
DWG_ENTITY(TEXT);

  VERSIONS(R_13,R_14)
    {
      FIELD_BD(elevation);
      FIELD_2RD(insertion_pt);
      FIELD_2RD(alignment_pt);
      FIELD_3BD(extrusion);
      FIELD_BD(thickness);
      FIELD_BD(oblique_ang);
      FIELD_BD(rotation_ang);
      FIELD_BD(height);
      FIELD_BD(width_factor);
      FIELD_TV(text_value);
      FIELD_BS(generation);
      FIELD_BS(horiz_alignment);
      FIELD_BS(vert_alignment);
    }

  SINCE(R_2000)
    {
      /* We assume that the user (the client application)
      is responsible for taking care of properly updating the dataflags field 
      which indicates which fields in the data structures are valid and which are
      undefined */

      FIELD(dataflags, RC);

      if (!(FIELD_VALUE(dataflags) & 0x01))
        {
          FIELD_RD(elevation);
        }

      FIELD_2RD(insertion_pt);

      if (!(FIELD_VALUE(dataflags) & 0x02))
        {
          FIELD_2DD(alignment_pt, 10, 20);
        }

      FIELD_BE(extrusion);
      FIELD_BT(thickness);

      if (!(FIELD_VALUE(dataflags) & 0x04))
        {
          FIELD_RD(oblique_ang);
        }

      if (!(FIELD_VALUE(dataflags) & 0x08))
        {
          FIELD_RD(rotation_ang);
        }

      FIELD_RD(height);

      if (!(FIELD_VALUE(dataflags) & 0x10))
        {
          FIELD_RD(width_factor);
        }

      FIELD_TV(text_value);

      if (!(FIELD_VALUE(dataflags) & 0x20))
        {
          FIELD_BS(generation);
        }

      if (!(FIELD_VALUE(dataflags) & 0x40)) 
        {
          FIELD_BS(horiz_alignment);
        }

      if (!(FIELD_VALUE(dataflags) & 0x80))
        {
          FIELD_BS(vert_alignment);
        }
    }

  COMMON_ENTITY_HANDLE_DATA;

  FIELD_HANDLE(style, 5);
DWG_ENTITY_END

/*(2)*/
DWG_ENTITY(ATTRIB);

  VERSIONS(R_13,R_14)
    {
      FIELD_BD(elevation);
      FIELD_2RD(insertion_pt);
      FIELD_2RD(alignment_pt);
      FIELD_3BD(extrusion);
      FIELD_BD(thickness);
      FIELD_BD(oblique_ang);
      FIELD_BD(rotation_ang);
      FIELD_BD(height);
      FIELD_BD(width_factor);
      FIELD_TV(text_value);
      FIELD_BS(generation);
      FIELD_BS(horiz_alignment);
      FIELD_BS(vert_alignment);
    }

  SINCE(R_2000)
    {
      /* We assume that the user (the client application)
      is responsible for taking care of properly updating the dataflags field 
      which indicates which fields in the data structures are valid and which are
      undefined */

      FIELD(dataflags, RC);
      if (!(FIELD_VALUE(dataflags) & 0x01))
        {
          FIELD_RD(elevation);
        }
      FIELD_2RD(insertion_pt);
      if (!(FIELD_VALUE(dataflags) & 0x02))
        {
          FIELD_2DD(alignment_pt, 10, 20);
        }
      FIELD_BE(extrusion);
      FIELD_BT(thickness);
      if (!(FIELD_VALUE(dataflags) & 0x04))
        {
          FIELD_RD(oblique_ang);
        }
      if (!(FIELD_VALUE(dataflags) & 0x08))
        {
          FIELD_RD(rotation_ang);
        }
      FIELD_RD(height);
      if (!(FIELD_VALUE(dataflags) & 0x10))
        {
          FIELD_RD(width_factor);
        }
      FIELD_TV(text_value);
      if (!(FIELD_VALUE(dataflags) & 0x20))
        {
          FIELD_BS(generation);
        }
      if (!(FIELD_VALUE(dataflags) & 0x40))
        {
          FIELD_BS(horiz_alignment);
        }
      if (!(FIELD_VALUE(dataflags) & 0x80))
        {
          FIELD_BS(vert_alignment);
        }
    }

  FIELD_TV(tag);
  FIELD_BS(field_length);
  FIELD(flags, RC);

  SINCE(R_2007)
    {
      FIELD(lock_position_flag, B);
    }

  COMMON_ENTITY_HANDLE_DATA;

  FIELD_HANDLE(style, 5);

DWG_ENTITY_END

/*(3)*/
DWG_ENTITY(ATTDEF);

  VERSIONS(R_13,R_14)
    {
      FIELD_BD(elevation);
      FIELD_2RD(insertion_pt);
      FIELD_2RD(alignment_pt);
      FIELD_3BD(extrusion);
      FIELD_BD(thickness);
      FIELD_BD(oblique_ang);
      FIELD_BD(rotation_ang);
      FIELD_BD(height);
      FIELD_BD(width_factor);
      FIELD_TV(default_value);
      FIELD_BS(generation);
      FIELD_BS(horiz_alignment);
      FIELD_BS(vert_alignment);
    }

  SINCE(R_2000)
    {
      /* We assume that the user (the client application)
      is responsible for taking care of properly updating the dataflags field 
      which indicates which fields in the data structures are valid and which are
      undefined */

      FIELD(dataflags, RC);
      if (!(FIELD_VALUE(dataflags) & 0x01))
        {
          FIELD_RD(elevation);
        }
      FIELD_2RD(insertion_pt);
      if (!(FIELD_VALUE(dataflags) & 0x02))
        {
          FIELD_2DD(alignment_pt, 10, 20);
        }
      FIELD_BE(extrusion);
      FIELD_BT(thickness);
      if (!(FIELD_VALUE(dataflags) & 0x04))
        {
          FIELD_RD(oblique_ang);
        }
      if (!(FIELD_VALUE(dataflags) & 0x08))
        {
          FIELD_RD(rotation_ang);
        }
      FIELD_RD(height);
      if (!(FIELD_VALUE(dataflags) & 0x10))
        {
          FIELD_RD(width_factor);
        }
      FIELD_TV(default_value);
      if (!(FIELD_VALUE(dataflags) & 0x20))
        {
          FIELD_BS(generation);
        }
      if (!(FIELD_VALUE(dataflags) & 0x40))
        {
          FIELD_BS(horiz_alignment);
        }
      if (!(FIELD_VALUE(dataflags) & 0x80))
        {
          FIELD_BS(vert_alignment);
        }
    }

  FIELD_TV(tag);
  FIELD_BS(field_length);
  FIELD(flags, RC);

  SINCE(R_2007)
    {
      FIELD(lock_position_flag, B);
    }

  FIELD_TV(prompt);

  COMMON_ENTITY_HANDLE_DATA;

  FIELD_HANDLE(style, 5);

DWG_ENTITY_END

/*(4)*/
DWG_ENTITY(BLOCK);

  FIELD_TV(name);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(5)*/
DWG_ENTITY(ENDBLK);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(6)*/
DWG_ENTITY(SEQEND);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(7)*/
DWG_ENTITY(INSERT);

  FIELD_3BD(ins_pt);

  VERSIONS(R_13,R_14)
    {
      FIELD_3BD(scale);
    }

  SINCE(R_2000)
    {
#     ifdef IS_DECODER
        {
          FIELD(scale_flag, BB);
          if (FIELD_VALUE(scale_flag) == 3)
            {
              FIELD_VALUE(scale.x) = 1.0;
              FIELD_VALUE(scale.y) = 1.0;
              FIELD_VALUE(scale.z) = 1.0;
            }
          else if (FIELD_VALUE(scale_flag) == 1)
            {
              FIELD_VALUE(scale.x) = 1.0;
              FIELD_DD(scale.y, 1.0);
              FIELD_DD(scale.z, 1.0);
            }
          else if (FIELD_VALUE(scale_flag) == 2)
            {
              FIELD_RD(scale.x); 
              FIELD_VALUE(scale.y) = FIELD_VALUE(scale.x);
              FIELD_VALUE(scale.z) = FIELD_VALUE(scale.x);
            }
          else //if (FIELD_VALUE(scale_flag) == 0)
            {
              FIELD_RD(scale.x);
              FIELD_DD(scale.y, FIELD_VALUE(scale.x));
              FIELD_DD(scale.z, FIELD_VALUE(scale.x));
            }
        }
#     endif

#     ifdef IS_ENCODER
        {
          if (FIELD_VALUE(scale.x)==1.0 && FIELD_VALUE(scale.y)==1.0 && FIELD_VALUE(scale.z)==1.0)
            {
              FIELD_VALUE(scale_flag) = 3;
              FIELD(scale_flag, BB);
            }
          else if (FIELD_VALUE(scale.x)==FIELD_VALUE(scale.y) && FIELD_VALUE(scale.x)==FIELD_VALUE(scale.z))
            {
              FIELD_VALUE(scale_flag) = 2;
              FIELD(scale_flag, BB);
              FIELD_RD(scale.x);
            }
          else if (FIELD_VALUE(scale.x)==1.0)
            {
              FIELD_VALUE(scale_flag) = 1;
              FIELD(scale_flag, BB);
              FIELD_RD(scale.x);
              FIELD_DD(scale.y, 1.0);
              FIELD_DD(scale.z, 1.0);
            }
          else
            {
              FIELD_VALUE(scale_flag) = 0;
              FIELD(scale_flag, BB);
              FIELD_RD(scale.x);
              FIELD_DD(scale.y, FIELD_VALUE(scale.x));
              FIELD_DD(scale.z, FIELD_VALUE(scale.x));
            }
       }
#    endif
    }

  FIELD_BD(rotation_ang);
  FIELD_3DPOINT(extrusion);
  FIELD(has_attribs, B);

  SINCE(R_2004)
    {
      if (FIELD_VALUE(has_attribs))
        {
          FIELD(owned_obj_count, BL);
        }
    }

  COMMON_ENTITY_HANDLE_DATA;

  FIELD_HANDLE(block_header, 5);

  //There is a typo in the spec. it says "R13-R200:".
  //I guess it means "R13-R2000:" (just like in MINSERT)
  VERSIONS(R_13,R_2000)
    {
      if(FIELD_VALUE(has_attribs))
        {
          FIELD_HANDLE(first_attrib, 4);
          FIELD_HANDLE(last_attrib, 4);
        }
    }

  //Spec typo? Spec says "2004:" but I think it should be "2004+:"
  // just like field owned_obj_count (AND just like in MINSERT)
  SINCE(R_2004)
    {
      if (FIELD_VALUE(has_attribs))
        {
          HANDLE_VECTOR(attrib_handles, owned_obj_count, 4);
        }
    }

  if (FIELD_VALUE(has_attribs))
    {
      FIELD_HANDLE(seqend, 3);
    }

DWG_ENTITY_END

/*(8)*/
DWG_ENTITY(MINSERT);

  FIELD_3BD(ins_pt);

  VERSIONS(R_13,R_14)
    {
      FIELD_3BD(scale);
    }

  SINCE(R_2000)
    {
#     ifdef IS_DECODER
        {
          FIELD(scale_flag, BB);
          if (FIELD_VALUE(scale_flag) == 3){
            FIELD_VALUE(scale.x) = FIELD_VALUE(scale.y) = FIELD_VALUE(scale.y) = 1.0;
          }
          else if (FIELD_VALUE(scale_flag) == 1)
            {
              FIELD_VALUE(scale.x) = 1.0;
              FIELD_DD(scale.y, 1.0);
              FIELD_DD(scale.z, 1.0);
            }
          else if (FIELD_VALUE(scale_flag) == 2)
            {
              FIELD_RD(scale.x);
              FIELD_VALUE(scale.y) = FIELD_VALUE(scale.x);
              FIELD_VALUE(scale.z) = FIELD_VALUE(scale.x);
            }
          else //if (FIELD_VALUE(scale_flag) == 0)
            {
              FIELD_RD(scale.x);
              FIELD_DD(scale.y, FIELD_VALUE(scale.x));
              FIELD_DD(scale.z, FIELD_VALUE(scale.x));
            }
        }
#     endif

#     ifdef IS_ENCODER
        {
          if (FIELD_VALUE(scale.x) == FIELD_VALUE(scale.y) == FIELD_VALUE(scale.z) == 1.0)
            {
              FIELD_VALUE(scale_flag) = 3;
              FIELD_BB(scale_flag);
            }
          else if (FIELD_VALUE(scale.x) == 1.0)
             {
              FIELD_VALUE(scale_flag) = 1;
              FIELD_BB(scale_flag);
              FIELD_DD(scale.y, 1.0);
              FIELD_DD(scale.z, 1.0);
             }
           else if (FIELD_VALUE(scale.x) == FIELD_VALUE(scale.y) == FIELD_VALUE(scale.z))
             {
              FIELD_VALUE(scale_flag) = 2;
              FIELD_BB(scale_flag);
              FIELD_RD(scale.x);
             }
           else
             {
              FIELD_VALUE(scale_flag) = 0;
              FIELD_BB(scale_flag);
              FIELD_RD(scale.x);
              FIELD_DD(scale.y, FIELD_VALUE(scale.x));
              FIELD_DD(scale.z, FIELD_VALUE(scale.x));
             }
        }
#     endif
    }

  FIELD_BD(rotation_ang);
  FIELD_3BD(extrusion);
  FIELD(has_attribs, B);

  SINCE(R_2004)
    {
      if (FIELD_VALUE(has_attribs))
        {
          FIELD(owned_obj_count, BL);
        }
    }

  FIELD_BS(numcols);
  FIELD_BS(numrows);
  FIELD_BD(col_spacing);
  FIELD_BD(row_spacing);

  COMMON_ENTITY_HANDLE_DATA;

  FIELD_HANDLE(block_header, 5);

  VERSIONS(R_13,R_2000)
    if (FIELD_VALUE(has_attribs))
      {
        FIELD_HANDLE(first_attrib, 4);
        FIELD_HANDLE(last_attrib, 4);
      }

  SINCE(R_2004)
    {
      HANDLE_VECTOR(attrib_handles, owned_obj_count, 4);
    }

  if (FIELD_VALUE(has_attribs))
    {
      FIELD_HANDLE(seqend, 3);
    }

DWG_ENTITY_END

//(9) Unknown

/*(10)*/
DWG_ENTITY(VERTEX_2D);

  FIELD_RC(flags);
  FIELD_3BD(point);

/* Decoder and Encoder routines could be the same but then we wouldn't compress
data when saving. So we explicitely implemented the encoder routine with the
compression technique described in the spec. --Juca */

# ifdef IS_DECODER
    {
      FIELD_BD(start_width);
 
      if (FIELD_VALUE(start_width) < 0)
        {
          FIELD_VALUE(start_width) = -FIELD_VALUE(start_width);
          FIELD_VALUE(end_width) = FIELD_VALUE(start_width);
        }
      else
        {
          FIELD_BD(end_width);
        }
    }
# endif

# ifdef IS_ENCODER
    {
      if (FIELD_VALUE(start_width) && FIELD_VALUE(start_width)==FIELD_VALUE(end_width))
        {
          //TODO: This is ugly! We should have a better way of doing such things
          FIELD_VALUE(start_width) = -FIELD_VALUE(start_width);
          FIELD_BD(start_width);
          FIELD_VALUE(start_width) = -FIELD_VALUE(start_width);
        }
      else
        {
          FIELD_BD(start_width);
          FIELD_BD(end_width);
        }
    }
# endif

  FIELD_BD(bulge);
  FIELD_BD(tangent_dir);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(11)*/
DWG_ENTITY(VERTEX_3D);

  FIELD_RC(flags);
  FIELD_3BD(point);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(12)*/
DWG_ENTITY(VERTEX_MESH);

  FIELD_RC(flags);
  FIELD_3BD(point);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(13)*/
DWG_ENTITY(VERTEX_PFACE);

  FIELD_RC(flags);
  FIELD_3BD(point);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(14)*/
DWG_ENTITY(VERTEX_PFACE_FACE);

  FIELD_BS(vertind[0]);
  FIELD_BS(vertind[1]);
  FIELD_BS(vertind[2]);
  FIELD_BS(vertind[3]);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(15)*/
DWG_ENTITY(POLYLINE_2D);

  FIELD_BS(flags);
  FIELD_BS(curve_type);
  FIELD_BD(start_width);
  FIELD_BD(end_width);
  FIELD_BT(thickness);
  FIELD_BD(elevation);
  FIELD_BE(extrusion);

  SINCE(R_2004)
    {
      FIELD_BL(owned_obj_count);
    }

  COMMON_ENTITY_HANDLE_DATA;

  VERSIONS(R_13,R_2000)
    {
      FIELD_HANDLE(first_vertex, 4);
      FIELD_HANDLE(last_vertex, 4);
    }

  SINCE(R_2004)
    {
      HANDLE_VECTOR(vertex, owned_obj_count, 4);
    }

  FIELD_HANDLE(seqend, 3);

DWG_ENTITY_END

/*(16)*/
DWG_ENTITY(POLYLINE_3D);

  FIELD(flags_1, RC);
  FIELD(flags_2, RC);

  SINCE(R_2004)
    {
      FIELD(owned_obj_count, BL);
    }

  COMMON_ENTITY_HANDLE_DATA;

  VERSIONS(R_13,R_2000)
    {
      FIELD_HANDLE(first_vertex, 4);
      FIELD_HANDLE(last_vertex, 4);
    }

  SINCE(R_2004)
    {
      HANDLE_VECTOR(vertex, owned_obj_count, 4);  //code 3
    }

  FIELD_HANDLE(seqend, 3);

DWG_ENTITY_END

/*(17)*/
DWG_ENTITY(ARC);

  FIELD_3BD(center);
  FIELD_BD(radius);
  FIELD_BT(thickness);
  FIELD_BE(extrusion);
  FIELD_BD(start_angle);
  FIELD_BD(end_angle);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(18)*/
DWG_ENTITY(CIRCLE);

  FIELD_3BD(center);
  FIELD_BD(radius);
  FIELD_BT(thickness);
  FIELD_BE(extrusion);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(19)*/
DWG_ENTITY(LINE);

  VERSIONS(R_13,R_14)
    {
      FIELD_3BD(start);
      FIELD_3BD(end);
    }

  SINCE(R_2000)
    {
#     ifdef IS_DECODER
        {
          FIELD(Zs_are_zero, B);
          FIELD_RD(start.x);
          FIELD_DD(end.x, FIELD_VALUE(start.x));
          FIELD_RD(start.y);
          FIELD_DD(end.y, FIELD_VALUE(start.y));

          if (FIELD_VALUE(Zs_are_zero))
            {
              FIELD_VALUE(start.z) = 0.0;
              FIELD_VALUE(end.z) = 0.0;
            }
          else
            {
              FIELD_RD(start.z);
              FIELD_DD(end.z, FIELD_VALUE(start.z));
            }
        }
#     endif

#     ifdef IS_ENCODER
        {
          FIELD_VALUE(Zs_are_zero) = (FIELD_VALUE(start.z) == 0.0 && FIELD_VALUE(end.z) == 0.0);
          FIELD_B(Zs_are_zero);
          FIELD_RD(start.x);
          FIELD_DD(end.x, FIELD_VALUE(start.x));
          FIELD_RD(start.y);
          FIELD_DD(end.y, FIELD_VALUE(start.y));
          if (!FIELD_VALUE(Zs_are_zero))
            {
              FIELD_RD(start.z);
              FIELD_DD(end.z, FIELD_VALUE(start.z));
            }
        }
#     endif
    }

  FIELD_BT(thickness);
  FIELD_BE(extrusion);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/**
 * Macro for common DIMENSION declaration
 */
/*FIELD_BD(elevation.ecs_11); \ */
#define DIMENSION_COMMON_DECODE \
    FIELD_3BD(extrusion); \
    FIELD_2RD(text_midpt); \
    FIELD_BD(elevation.ecs_12); \
    FIELD_RC(flags_1); \
    FIELD_TV(user_text); \
    FIELD_BD(text_rot); \
    FIELD_BD(horiz_dir); \
    FIELD_3BD(ins_scale); \
    FIELD_BD(ins_rotation); \
    SINCE(R_2000) \
      { \
        FIELD_BS(attachment_point); \
        FIELD_BS(lspace_style); \
        FIELD_BD(lspace_factor); \
        FIELD_BD(act_measurement); \
      } \
    SINCE(R_2007) \
      { \
        FIELD_B(unknown); \
        FIELD_B(flip_arrow1); \
        FIELD_B(flip_arrow2); \
      }


/*(20)*/
DWG_ENTITY(DIMENSION_ORDINATE);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_3BD(_10_pt);
  FIELD_3BD(_13_pt);
  FIELD_3BD(_14_pt);
  FIELD_RC(flags_2);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(21)*/
DWG_ENTITY(DIMENSION_LINEAR);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_3BD(_13_pt);
  FIELD_3BD(_14_pt);
  FIELD_3BD(_10_pt);
  FIELD_BD(ext_line_rot);
  FIELD_BD(dim_rot);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(22)*/
DWG_ENTITY(DIMENSION_ALIGNED);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_3BD(_13_pt);
  FIELD_3BD(_14_pt);
  FIELD_3BD(_10_pt);
  FIELD_BD(ext_line_rot);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(23)*/
DWG_ENTITY(DIMENSION_ANG3PT);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_3BD(_10_pt);
  FIELD_3BD(_13_pt);
  FIELD_3BD(_14_pt);
  FIELD_3BD(_15_pt);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(24)*/
DWG_ENTITY(DIMENSION_ANG2LN);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_2RD(_16_pt);
  FIELD_3BD(_13_pt);
  FIELD_3BD(_14_pt);
  FIELD_3BD(_15_pt);
  FIELD_3BD(_10_pt);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(25)*/
DWG_ENTITY(DIMENSION_RADIUS);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_3BD(_10_pt);
  FIELD_3BD(_15_pt);
  FIELD_BD(leader_len);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(26)*/
DWG_ENTITY(DIMENSION_DIAMETER);

  DIMENSION_COMMON_DECODE;
  FIELD_2RD(_12_pt);
  FIELD_3BD(_15_pt);
  FIELD_3BD(_10_pt);
  FIELD_BD(leader_len);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);
  FIELD_HANDLE(block, 5);

DWG_ENTITY_END

/*(27)*/
DWG_ENTITY(POINT);

  FIELD_BD(x);
  FIELD_BD(y);
  FIELD_BD(z);
  FIELD_BT(thickness);
  FIELD_BE(extrusion);
  FIELD_BD(x_ang);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(28)*/
DWG_ENTITY(_3DFACE);

  VERSIONS(R_13,R_14)
    {
      FIELD_3BD(corner1);
      FIELD_3BD(corner2);
      FIELD_3BD(corner3);
      FIELD_3BD(corner4);
      FIELD_BS(invis_flags);
    }

  SINCE(R_2000)
    {
      FIELD_B(has_no_flags);

#     ifdef IS_DECODER
        {
          FIELD_B(z_is_zero);
          FIELD_RD(corner1.x);
          FIELD_RD(corner1.y);
          if(FIELD_VALUE(z_is_zero))
            {
              FIELD_VALUE(corner1.z) = 0;
            }
          else
            {
              FIELD_RD(corner1.z);
            }
        }
#     endif

#     ifdef IS_ENCODER
        {
          FIELD_VALUE(z_is_zero) = (FIELD_VALUE(corner1.z) == 0);
          FIELD_B(z_is_zero);
          FIELD_RD(corner1.x);
          FIELD_RD(corner1.y);
          if(!FIELD_VALUE(z_is_zero))
            {
              FIELD_RD(corner1.z);
            }
        }
#     endif

      FIELD_DD(corner2.x, FIELD_VALUE(corner1.x));
      FIELD_DD(corner2.y, FIELD_VALUE(corner1.y));
      FIELD_DD(corner2.z, FIELD_VALUE(corner1.z));
      FIELD_DD(corner3.x, FIELD_VALUE(corner2.x));
      FIELD_DD(corner3.y, FIELD_VALUE(corner2.y));
      FIELD_DD(corner3.z, FIELD_VALUE(corner2.z));
      FIELD_DD(corner4.x, FIELD_VALUE(corner3.x));
      FIELD_DD(corner4.y, FIELD_VALUE(corner3.y));
      FIELD_DD(corner4.z, FIELD_VALUE(corner3.z));
    }

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(29)*/
DWG_ENTITY(POLYLINE_PFACE);

  FIELD_BS(numverts);
  FIELD_BS(numfaces);

  SINCE(R_2004)
    {
      FIELD_BL(owned_obj_count);
    }

  COMMON_ENTITY_HANDLE_DATA;

  VERSIONS(R_13, R_2000)
    {
      FIELD_HANDLE(first_vertex, 4);
      FIELD_HANDLE(last_vertex, 4);
    }
  SINCE(R_2004)
    {
      HANDLE_VECTOR(vertex, owned_obj_count, 4);
    }
  FIELD_HANDLE(seqend, 3);

DWG_ENTITY_END

/*(30)*/
DWG_ENTITY(POLYLINE_MESH);

  FIELD_BS(flags);
  FIELD_BS(curve_type);
  FIELD_BS(m_vert_count);
  FIELD_BS(n_vert_count);
  FIELD_BS(m_density);
  FIELD_BS(n_density);

  SINCE(R_2004)
    {
      FIELD_BL(owned_obj_count);
    }

  COMMON_ENTITY_HANDLE_DATA;

  VERSIONS(R_13, R_2000)
    {
      FIELD_HANDLE(first_vertex, 4);
      FIELD_HANDLE(last_vertex, 4);
    }
  SINCE(R_2004)
    {
      HANDLE_VECTOR(vertex, owned_obj_count, 4);
    }
  FIELD_HANDLE(seqend, 3);

DWG_ENTITY_END

/*(31)*/
DWG_ENTITY(SOLID);

  FIELD_BT(thickness);
  FIELD_BD(elevation);
  FIELD_2RD(corner1);
  FIELD_2RD(corner2);
  FIELD_2RD(corner3);
  FIELD_2RD(corner4);
  FIELD_BE(extrusion);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(32)*/
DWG_ENTITY(TRACE);

  FIELD_BT(thickness);
  FIELD_BD(elevation);
  FIELD_2RD(corner1);
  FIELD_2RD(corner2);
  FIELD_2RD(corner3);
  FIELD_2RD(corner4);
  FIELD_BE(extrusion);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(33)*/
DWG_ENTITY(SHAPE);

  FIELD_3BD(ins_pt);
  FIELD_BD(scale);
  FIELD_BD(rotation);
  FIELD_BD(width_factor);
  FIELD_BD(oblique);
  FIELD_BD(thickness);
  FIELD_BS(shape_no);
  FIELD_3BD(extrusion);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(shapefile, 5);

DWG_ENTITY_END

/*(34)*/
DWG_ENTITY(VIEWPORT);

  FIELD_3BD(center);
  FIELD_BD(width);
  FIELD_BD(height);

  SINCE(R_2000)
    {
      FIELD_3BD(view_target);
      FIELD_3BD(view_direction);
      FIELD_BD(view_twist_angle);
      FIELD_BD(view_height);
      FIELD_BD(lens_length);
      FIELD_BD(front_clip_z);
      FIELD_BD(back_clip_z);
      FIELD_BD(snap_angle);
      FIELD_2RD(view_center);
      FIELD_2RD(snap_base);
      FIELD_2RD(snap_spacing);
      FIELD_2RD(grid_spacing);
      FIELD_BS(circle_zoom);
    }

  SINCE(R_2007)
    {
      FIELD_BS(grid_major);
    }

  SINCE(R_2000)
    {
      FIELD_BL(frozen_layer_count);
      FIELD_BL(status_flags);
      FIELD_TV(style_sheet);
      FIELD_RC(render_mode);
      FIELD_B(ucs_at_origin);
      FIELD_B(ucs_per_viewport);
      FIELD_3BD(ucs_origin);
      FIELD_3BD(ucs_x_axis);
      FIELD_3BD(ucs_y_axis);
      FIELD_BD(ucs_elevation);
      FIELD_BS(ucs_ortho_view_type);
    }

  SINCE(R_2004)
    {
      FIELD_BS(shadeplot_mode);
    }

  SINCE(R_2007)
    {
      FIELD_B(use_def_lights);
      FIELD_RC(def_lighting_type);
      FIELD_BD(brightness);
      FIELD_BD(contrast);
      FIELD_CMC(ambient_light_color);
    }

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(35)*/
DWG_ENTITY(ELLIPSE);

  FIELD_3BD(center);
  FIELD_3BD(sm_axis);
  FIELD_3BD(extrusion);
  FIELD_BD(axis_ratio);
  FIELD_BD(start_angle);
  FIELD_BD(end_angle);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(36)*/
DWG_ENTITY(SPLINE);

  FIELD_BL(scenario);
  FIELD_BL(degree);
  if (FIELD_VALUE(scenario) & 2)
    {
      FIELD_BD(fit_tol);
      FIELD_3BD(beg_tan_vec);
      FIELD_3BD(end_tan_vec);
      FIELD_BL(num_fit_pts);
    }
  if (FIELD_VALUE(scenario) & 1)
    {
      FIELD_B(rational);
      FIELD_B(closed_b);
      FIELD_B(periodic);
      FIELD_BD(knot_tol);
      FIELD_BD(ctrl_tol);
      FIELD_BL(num_knots);
      FIELD_BL(num_ctrl_pts);
      FIELD_B(weighted);
    }

  REPEAT (num_knots, knots, BITCODE_BD)
    {
      FIELD_BD(knots[rcount]);
    }
  VECTOR_FREE (knots);

  REPEAT (num_ctrl_pts, ctrl_pts, Dwg_Entity_SPLINE_control_point)
    {
      FIELD_3BD(ctrl_pts[rcount]);
      if (!FIELD_VALUE(weighted))
        {
          //TODO check what "D" means on spec.
          //assuming typo - should be BD
          //assuming w=0 when not present.
          FIELD_VALUE(ctrl_pts[rcount].w) = 0;
        }
      else
        {
          FIELD_BD(ctrl_pts[rcount].w);
        }
    }
  VECTOR_FREE (ctrl_pts);

  REPEAT (num_fit_pts, fit_pts, Dwg_Entity_SPLINE_point)
    {
      FIELD_3BD(fit_pts[rcount]);
    }
  VECTOR_FREE (fit_pts);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

//TODO: 37, 38 and 39 are ACIS entities

#define PARSE_WIRE_STRUCT(name)                       \
  FIELD_RC(name.type);                                \
  FIELD_BL(name.selection_marker);                    \
  FIELD_BS(name.color);                               \
  FIELD_BL(name.acis_index);                          \
  FIELD_BL(name.num_points);                             \
  FIELD_3DPOINT_VECTOR(name.points, name.num_points); \
  FIELD_B(name.transform_present);                      \
  if (FIELD_VALUE(name.transform_present))              \
    {                                                 \
      FIELD_3BD(name.axis_x);                         \
      FIELD_3BD(name.axis_y);                         \
      FIELD_3BD(name.axis_z);                         \
      FIELD_3BD(name.translation);                    \
      FIELD_BD(name.scale);                           \
      FIELD_B(name.has_rotation);                     \
      FIELD_B(name.has_reflection);                    \
      FIELD_B(name.has_shear);                        \
    }

#ifndef IS_PRINT
#ifdef IS_DECODER

#define DECODE_3DSOLID decode_3dsolid(dat, obj, _obj);

int
decode_3dsolid (Bit_Chain* dat, Dwg_Object* obj, Dwg_Entity_3DSOLID* _obj)
{
  Dwg_Struct* dwg = obj->parent;
  unsigned int vcount, rcount, rcount2;
  unsigned int i=0;
  unsigned int j=0;
  int index;
  int total_size=0;
  unsigned int num_blocks=0;
  char tmp[1024];

  FIELD_B(acis_empty);
  
  if (!FIELD_VALUE(acis_empty))
    {
      FIELD_B (unknown);
      FIELD_BS (version);
      if (FIELD_VALUE(version)==1)
        {
          do
            {
              FIELD_VALUE(sat_data) = (BITCODE_RC**) realloc(FIELD_VALUE(sat_data), i * sizeof(BITCODE_RC*));
              FIELD_VALUE(block_size) = (BITCODE_BL*) realloc(FIELD_VALUE(block_size), i * sizeof(BITCODE_BL));
              FIELD_BL (block_size[i]);
              FIELD_VECTOR (sat_data[i], RC, block_size[i]);
              total_size += FIELD_VALUE(block_size[i]);
            } while(FIELD_VALUE(block_size[i++]));

          //de-obfuscate SAT data
          FIELD_VALUE(raw_sat_data) = (unsigned char*) malloc (total_size * sizeof(unsigned char*));
          num_blocks=i-1;
          index=0;
          for (i=0;i<num_blocks;i++)
            {
              for (j=0;j<FIELD_VALUE(block_size[i]);j++)
                {
                  if (FIELD_VALUE(sat_data[i][j]<=32))
                    {
                      FIELD_VALUE(raw_sat_data)[index++] = FIELD_VALUE(sat_data[i][j]);
                    }
                  else
                    {
                      FIELD_VALUE(raw_sat_data)[index++] = 159-FIELD_VALUE(sat_data[i][j]);
                    }
                }
            }
          snprintf (tmp, 1024, "Raw SAT data:\n%s\n", FIELD_VALUE(raw_sat_data));
          LOG_TRACE (tmp);
        }
      else //if (FIELD_VALUE(version)==2)
        {
          //TODO
          LOG_ERROR ("TODO: Implement parsing of SAT file (version==2) in entities 37,38 and 39.\n");
        }

      FIELD_B (wireframe_data_present);
      if (FIELD_VALUE(wireframe_data_present))
        {
          FIELD_B (point_present);
          if (FIELD_VALUE(point_present))
            {
              FIELD_3BD (point);
            }
          else
            {
              FIELD_VALUE(point.x) = 0;
              FIELD_VALUE(point.y) = 0;
              FIELD_VALUE(point.z) = 0;
            }
          FIELD_BL (num_isolines);
          FIELD_B (isoline_present);
          if (FIELD_VALUE(isoline_present))
            {
              FIELD_BL (num_wires);
              REPEAT(num_wires, wires, Dwg_Entity_3DSOLID_wire)
                {
                  PARSE_WIRE_STRUCT(wires[rcount])
                }
              VECTOR_FREE (wires);
              FIELD_BL(num_silhouettes);
              REPEAT(num_silhouettes, silhouettes, Dwg_Entity_3DSOLID_silhouette)
                {
                  FIELD_BL(silhouettes[rcount].vp_id);
                  FIELD_3BD(silhouettes[rcount].vp_target);
                  FIELD_3BD(silhouettes[rcount].vp_dir_from_target);
                  FIELD_3BD(silhouettes[rcount].vp_up_dir);
                  FIELD_B(silhouettes[rcount].vp_perspective);
                  FIELD_BL(silhouettes[rcount].num_wires);
                  REPEAT2(silhouettes[rcount].num_wires, silhouettes[rcount].wires, Dwg_Entity_3DSOLID_wire)
                    {
                      PARSE_WIRE_STRUCT(silhouettes[rcount].wires[rcount2])
                    }
                }
              VECTOR_FREE (silhouettes);
            }
        }

      FIELD_B(ACIS_empty_bit);
      if (!FIELD_VALUE(ACIS_empty_bit))
        {
          LOG_ERROR ("TODO: Implement parsing of ACIS data in the end of 3dsolid object parsing (ACIS_empty_bit==0).\n");
        }

      SINCE(R_2007)
        {
          FIELD_BL(unknown_2007);
        }

      COMMON_ENTITY_HANDLE_DATA;

      SINCE(R_2007)
        {
          FIELD_HANDLE(history_id, ANYCODE);
        }
    }
}
#else
#  define DECODE_3DSOLID {}
#endif //#if IS_DECODER
#else
#  define DECODE_3DSOLID {}
#endif //#if IS_PRINT

#ifdef IS_ENCODER

#define ENCODE_3DSOLID encode_3dsolid(dat, obj, _obj);

int encode_3dsolid(Bit_Chain* dat, Dwg_Object* obj, Dwg_Entity_3DSOLID* _obj)
{
  char tmp[1024];

  //TODO Implement-me
}
#else
#define ENCODE_3DSOLID {}
#endif //#if IS_ENCODER


/*(37)*/
DWG_ENTITY(REGION);
# ifdef IS_DECODER
    DECODE_3DSOLID;
# endif
# ifdef IS_ENCODER
    ENCODE_3DSOLID;
# endif
DWG_ENTITY_END

/*(38)*/
DWG_ENTITY(_3DSOLID);
# ifdef IS_DECODER
      DECODE_3DSOLID;
# endif
# ifdef IS_ENCODER
      ENCODE_3DSOLID;
# endif
DWG_ENTITY_END

/*(39)*/
DWG_ENTITY(BODY);
# ifdef IS_DECODER
    DECODE_3DSOLID;
# endif
# ifdef IS_ENCODER
    ENCODE_3DSOLID;
# endif
DWG_ENTITY_END

/*(40)*/
DWG_ENTITY(RAY);

  FIELD_3BD(point);
  FIELD_3BD(vector);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(41)*/
DWG_ENTITY(XLINE);

  FIELD_3BD(point);
  FIELD_3BD(vector);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

/*(42)*/
DWG_NONGRAPH(DICTIONARY);

  FIELD(numitems, BL);

  VERSION(R_14)
    {
      FIELD(unknown_r14, RC);
    }

  SINCE(R_2000)
    {
      FIELD_BS(cloning);
      FIELD(hard_owner, RC);
    }

  if (FIELD_VALUE(numitems) > 10000)
    {
      fprintf(
          stderr,
          "Strange: dictionary with more than 10 thousand entries! Handle: %lu\n",
          obj->handle.value);
      return;
    }

  FIELD_TV_VECTOR(text, numitems);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(itemhandles, numitems, 2);

DWG_NONGRAPH_END

DWG_NONGRAPH(DICTIONARYWDLFT);
	  
  FIELD(numitems, BL);

  VERSION(R_14)
    {
      FIELD(unknown_r14, RC);
    }

  SINCE(R_2000)
    {
      FIELD_BS(cloning);
      FIELD(hard_owner, RC);
    }

  FIELD_TV_VECTOR(text, numitems);
  
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
  
  HANDLE_VECTOR(itemhandles, numitems, 2); 
  
  FIELD_HANDLE(defaultid, 5); // DXF:340 - default object id (one of the itemhandles)
    
DWG_NONGRAPH_END

//(43): Unknown

/*(44)*/
DWG_ENTITY(MTEXT);

  //spec-typo ? Spec says BD but we think it might be 3BD:
  FIELD_3BD(insertion_pt);
  FIELD_3BD(extrusion);
  FIELD_3BD(x_axis_dir);

  SINCE(R_2007)
    {
      FIELD_BD(rect_height);
    }

  FIELD_BD(rect_width);
  FIELD_BD(text_height);
  FIELD_BS(attachment);
  FIELD_BS(drawing_dir);
  FIELD_BD(extends_ht); //not documented
  FIELD_BD(extends_wid);
  FIELD_TV(text);

  SINCE(R_2000)
    {
      FIELD_BS(linespace_style);
      FIELD_BD(linespace_factor);
      FIELD(unknown_bit, B);
    }

  SINCE(R_2004)
    {
      FIELD(unknown_long, BL);
    }

  COMMON_ENTITY_HANDLE_DATA;

  FIELD_HANDLE(style, 5);

DWG_ENTITY_END

/*(45)*/
DWG_ENTITY(LEADER);

  FIELD(unknown_bit_1, B);
  FIELD_BS(annot_type);
  FIELD_BS(path_type);
  FIELD(numpts, BL);
  FIELD_3DPOINT_VECTOR(points, numpts);
  FIELD_3DPOINT(end_pt_proj);
  FIELD_3DPOINT(extrusion);
  FIELD_3DPOINT(x_direction);
  FIELD_3DPOINT(offset_to_block_ins_pt);

  SINCE(R_14)
    {
      FIELD_3DPOINT(unknown_pt);
    }

  VERSIONS(R_13,R_14)
    {
      FIELD_BD(dimgap);
    }

  FIELD_BD(box_height);
  FIELD_BD(box_width);
  FIELD(hooklineonxdir, B);
  FIELD(arrowhead_on, B);

  VERSIONS(R_13,R_14)
    {
      FIELD_BS(arrowhead_type);
      FIELD_BD(dimasz);
      FIELD(unknown_bit_2, B);
      FIELD(unknown_bit_3, B);
      FIELD_BS(unknown_short_1);
      FIELD_BS(byblock_color);
      FIELD(unknown_bit_4, B);
      FIELD(unknown_bit_5, B);
    }

  SINCE(R_2000)
    {
      FIELD_BS(unknown_short_1);
      FIELD(unknown_bit_4, B);
      FIELD(unknown_bit_5, B);
    }

  COMMON_ENTITY_HANDLE_DATA;

  //XXX reading these handles leaded to a segfault
  SINCE(R_14)
  {
    // Maybe present in R13 but inactive/not used.
    FIELD_HANDLE(associated_annotation, 5);
  }
  FIELD_HANDLE(dimstyle, 5);

DWG_ENTITY_END

/*(46)*/
DWG_ENTITY(TOLERANCE);

  VERSIONS(R_13, R_14)
    {
      FIELD_BS(unknown_short); //spec-typo? Spec says S instead of BS.
      FIELD_BD(height);
      FIELD_BD(dimgap);
    }

  FIELD_3DPOINT(ins_pt);
  FIELD_3DPOINT(x_direction);
  FIELD_3DPOINT(extrusion);
  FIELD_TV(text_string);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(dimstyle, 5);

DWG_ENTITY_END

/*(47)*/
DWG_ENTITY(MLINE);

  FIELD_BD(scale);
  FIELD(just, RC); //spec-typo? Spec says EC instead of RC...
  FIELD_3DPOINT(base_point);
  FIELD_3DPOINT(extrusion);
  FIELD_BS(open_closed);
  FIELD(num_lines, RC);
  FIELD_BS(num_verts);

  REPEAT(num_verts, verts, Dwg_Entity_MLINE_vert)
    {
      FIELD_3DPOINT(verts[rcount].vertex);
      FIELD_3DPOINT(verts[rcount].vertex_direction);
      FIELD_3DPOINT(verts[rcount].miter_direction);

      REPEAT2(num_lines, verts[rcount].lines, Dwg_Entity_MLINE_line)
        {
          FIELD_BS(verts[rcount].lines[rcount2].num_segparms);
          REPEAT3(verts[rcount].lines[rcount2].num_segparms, verts[rcount].lines[rcount2].segparms, BITCODE_BD)
            {
              FIELD_BD(verts[rcount].lines[rcount2].segparms[rcount3]);
            }
          VECTOR_FREE (verts[rcount].lines[rcount2].segparms);

          FIELD_BS(verts[rcount].lines[rcount2].num_areafillparms);
          REPEAT3(verts[rcount].lines[rcount2].num_areafillparms, verts[rcount].lines[rcount2].areafillparms, BITCODE_BD)
            {
              FIELD_BD(verts[rcount].lines[rcount2].areafillparms[rcount3]);
            }
          VECTOR_FREE (verts[rcount].lines[rcount2].areafillparms);
        }
      VECTOR_FREE (verts[rcount].lines);
    }
  VECTOR_FREE (verts);

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(mline_style, 5);

DWG_ENTITY_END

/*(48)*/
DWG_NONGRAPH(BLOCK_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(block_headers, num_entries, 2);
  FIELD_HANDLE(model_space,3);
  FIELD_HANDLE(paper_space,3);

DWG_NONGRAPH_END

/*(49)*/
DWG_NONGRAPH(BLOCK_HEADER);

  FIELD_TV(entry_name);
  FIELD(_64_flag, B);
  FIELD_BS(xrefindex_plus1);
  FIELD(xdep, B);
  FIELD(anonymous, B);
  FIELD(hasattrs, B);
  FIELD(blkisxref, B);
  FIELD(xrefoverlaid, B);

  SINCE(R_2000)
    {
      FIELD(loaded_bit, B);
    }

  SINCE(R_2004)
    {
      FIELD(owned_object_count, BL);
    }

  FIELD_3DPOINT(base_pt);
  FIELD_TV(xref_pname);

  SINCE(R_2000)
    {

      /* Skip non-zero bytes and a terminating zero */
#ifndef OBJECT_FREE
      FIELD_VALUE(insert_count)=0;
      while (SKIP(RC))
        {
          FIELD_VALUE(insert_count)++;
        }
#endif

      FIELD_TV(block_description);

      FIELD(size_of_preview_data, BL);
      FIELD_VECTOR(binary_preview_data, RC, size_of_preview_data);
    }

  SINCE(R_2007)
    {
      FIELD_BS(insert_units);
      FIELD(explodable, B);
      FIELD(block_scaling, RC);
    }

  FIELD_HANDLE(block_control_handle, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(NULL_handle, 5);
  FIELD_HANDLE(block_entity, 3);

  VERSIONS(R_13,R_2000)
    {
      if (!FIELD_VALUE(blkisxref) && !FIELD_VALUE(xrefoverlaid))
        {
          FIELD_HANDLE(first_entity, 4);
          FIELD_HANDLE(last_entity, 4);
        }
    }

  SINCE(R_2004)
    {
      HANDLE_VECTOR(entities, owned_object_count, 4);
    }

  FIELD_HANDLE(endblk_entity, 3);

  SINCE(R_2000)
    {
      HANDLE_VECTOR(insert_handles, insert_count, ANYCODE)
      FIELD_HANDLE(layout_handle, ANYCODE);
    }

DWG_NONGRAPH_END

/*(50)*/
DWG_NONGRAPH(LAYER_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(layers, num_entries, 2);

DWG_NONGRAPH_END

/*(51)*/
DWG_NONGRAPH(LAYER);

  FIELD_TV(entry_name);
  FIELD(_64_flag, B);
  FIELD_BS(xrefindex_plus1);
  FIELD(xrefdep, B);
  VERSIONS(R_13, R_14)
    {
      FIELD(frozen, B);
      FIELD(on, B);
      FIELD(frozen_in_new, B);
      FIELD(locked, B);
    }

  SINCE(R_2000)
    {
      FIELD_BS(values);      
    }

  FIELD_CMC(color);

  FIELD_HANDLE(layer_control, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);

  SINCE(R_2000)
    {
      FIELD_HANDLE(plotstyle, 5);
    }

  SINCE(R_2007)
    {
      FIELD_HANDLE(material, ANYCODE);
    }

  FIELD_HANDLE(linetype, 5);

DWG_NONGRAPH_END

/*(52)*/
DWG_NONGRAPH(SHAPEFILE_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(shapefiles, num_entries, 2);

DWG_NONGRAPH_END

/*(53)*/
DWG_NONGRAPH(SHAPEFILE);

  FIELD_TV(entry_name);
  FIELD_B(_64_flag);
  FIELD_BS(xrefindex_plus1);
  FIELD_B(xrefdep);
  FIELD_B(vertical);
  FIELD_B(shape_file);
  FIELD_BD(fixed_height);
  FIELD_BD(width_factor);
  FIELD_BD(oblique_ang);
  FIELD_RC(generation);
  FIELD_BD(last_height);
  FIELD_TV(font_name);
  FIELD_TV(bigfont_name);
  FIELD_HANDLE(shapefile_control, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);

DWG_NONGRAPH_END

//(54): Unknown
//(55): Unknown

/*(56)*/
DWG_NONGRAPH(LTYPE_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(linetypes, num_entries, 2);
  FIELD_HANDLE(bylayer, 3);
  FIELD_HANDLE(byblock, 3);

DWG_NONGRAPH_END

/*(57)*/
DWG_NONGRAPH(LTYPE);
  char R2007plus_text_area_is_present = 0;

  FIELD_TV(entry_name);
  FIELD(_64_flag, B);
  FIELD_BS(xrefindex_plus1);
  FIELD(xrefdep, B);
  FIELD_TV(description);
  FIELD_BD(pattern_len);
  FIELD(alignment, RC);
  FIELD(num_dashes, RC);

  REPEAT(num_dashes, dash, LTYPE_dash)
    {
      FIELD_BD(dash[rcount].length);
      FIELD_BS(dash[rcount].complex_shapecode);
      FIELD_RD(dash[rcount].x_offset);
      FIELD_RD(dash[rcount].y_offset);
      FIELD_BD(dash[rcount].scale);
      FIELD_BD(dash[rcount].rotation);
      FIELD_BS(dash[rcount].shape_flag);
      if (FIELD_VALUE(dash[rcount].shape_flag) & 0x02)
        R2007plus_text_area_is_present = 1;
    }
  VECTOR_FREE (dash);

  UNTIL(R_2004)
    {
      FIELD_VECTOR_N(strings_area, RC, 256);
    }
  LATER_VERSIONS
    {
      if (R2007plus_text_area_is_present)
        {
          FIELD_VECTOR_N(strings_area, RC, 512);
        }
    }

  FIELD_HANDLE(linetype_control, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);
  HANDLE_VECTOR(shapefiles, num_dashes, 5);

DWG_NONGRAPH_END

//(58): Unknown
//(59): Unknown

/*(60)*/
DWG_NONGRAPH(VIEW_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(views, num_entries, 2);

DWG_NONGRAPH_END

/*(61)*/
DWG_NONGRAPH(VIEW);

  FIELD_TV(entry_name);
  FIELD(_64_flag, B);
  FIELD_BS(xrefindex_plus1);
  FIELD(xrefdep, B);
  FIELD_BD(height);
  FIELD_BD(width);
  FIELD_2RD(center);
  FIELD_3BD(target);
  FIELD_3BD(direction);
  FIELD_BD(twist_angle);
  FIELD_BD(lens_legth);
  FIELD_BD(front_clip);
  FIELD_BD(back_clip);
  
  // FIELD(view_mode, RC); ? 4bits ??? TODO: check this
  SKIP(B);
  SKIP(B);
  SKIP(B);
  SKIP(B);

  SINCE(R_2000)
    {
      FIELD(render_mode, RC);
    }

  FIELD(pspace_flag, B);

  SINCE(R_2000)
    {
      FIELD(associated_ucs, B);
      
      if (FIELD_VALUE(associated_ucs) & 1)
        {
          FIELD_3BD(origin);
          FIELD_3BD(x_direction);
          FIELD_3BD(y_direction);
          FIELD_BD(elevation);
          FIELD_BS(orthographic_view_type);
        }      
    }

  SINCE(R_2007)
    {
      FIELD(camera_plottable, B);
    }

  FIELD_HANDLE(view_control_handle, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);

  SINCE(R_2000)
    {
	  if (FIELD_VALUE(associated_ucs) & 1)
	    {
          FIELD_HANDLE(base_ucs_handle, ANYCODE);
          FIELD_HANDLE(named_ucs_handle, ANYCODE);
		}
    }

  SINCE(R_2007)
    {
      FIELD_HANDLE(live_section, ANYCODE);
    }

DWG_NONGRAPH_END

/*(62)*/
DWG_NONGRAPH(UCS_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(ucs, num_entries, 2);

DWG_NONGRAPH_END

/*(63)*/
DWG_NONGRAPH(UCS);

  FIELD_TV(entry_name);
  FIELD(_64_flag, B);
  FIELD_BS(xrefindex_plus1);
  FIELD(xrefdep, B);
  FIELD_3BD(origin);
  FIELD_3BD(x_direction);
  FIELD_3BD(y_direction);

  SINCE(R_2000)
    {
      FIELD_BD(elevation);
      FIELD_BS(orthographic_view_type);
      FIELD_BS(orthographic_type);
    }

  FIELD_HANDLE(ucs_control_handle, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);

  SINCE(R_2000)
    {
      FIELD_HANDLE(base_ucs_handle, ANYCODE);
      FIELD_HANDLE(unknown, ANYCODE); 
    }
DWG_NONGRAPH_END

/*(64)*/
DWG_NONGRAPH(VPORT_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(vports, num_entries, 2); 

DWG_NONGRAPH_END

/*(65)*/
DWG_NONGRAPH(VPORT);

  FIELD_TV(entry_name);
  FIELD_B(_64_flag);
  FIELD_BS(xrefindex_plus1);
  FIELD_B(xrefdep);
  FIELD_BD(view_height);
  FIELD_BD(aspect_ratio);
  FIELD_2RD(view_center);
  FIELD_3BD(view_target);
  FIELD_3BD(view_dir);
  FIELD_BD(view_twist);
  FIELD_BD(lens_length);
  FIELD_BD(front_clip);
  FIELD_BD(back_clip);
  FIELD_4BITS(view_mode);

  SINCE(R_2000)
    {
      FIELD_RC (render_mode);
    }

  SINCE(R_2007)
    {
      FIELD_B(use_default_lights);
      FIELD_RC(default_lightining_type);
      FIELD_BD(brightness);
      FIELD_BD(contrast);
      FIELD_CMC(ambient_color);
    }

  FIELD_2RD(lower_left);
  FIELD_2RD(upper_right);
  FIELD_B(UCSFOLLOW);
  FIELD_BS(circle_zoom);
  FIELD_B(fast_zoom);
  FIELD_B(UCSICON_0);
  FIELD_B(UCSICON_1);
  FIELD_B(grid_on_off);
  FIELD_2RD(grid_spacing);
  FIELD_B(snap_on_off);
  FIELD_B(snap_style);
  FIELD_BS(snap_isopair);
  FIELD_BD(snap_rot);
  FIELD_2RD(snap_base);
  FIELD_2RD(snap_spacing);

  SINCE(R_2000)
    {
      FIELD_B (unknown);
      FIELD_B (ucs_pre_viewport);
      FIELD_3BD (ucs_origin);
      FIELD_3BD (ucs_x_axis);
      FIELD_3BD (ucs_y_axis);
      FIELD_BD (ucs_elevation);
      FIELD_BS (ucs_orthografic_type);
    }

  SINCE(R_2007)
    {
      FIELD_BS (grid_flags);
      FIELD_BS (grid_major);
    }

  FIELD_HANDLE(vport_control, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);

  SINCE(R_2007)
    {
      FIELD_HANDLE(background_handle, ANYCODE);
      FIELD_HANDLE(visual_style_handle, ANYCODE);
      FIELD_HANDLE(sun_handle, ANYCODE);
    }

  SINCE(R_2000)
    {
      FIELD_HANDLE(named_ucs_handle, ANYCODE);
      FIELD_HANDLE(base_ucs_handle, ANYCODE);
    }

DWG_NONGRAPH_END

/*(66)*/
DWG_NONGRAPH(APPID_CONTROL);

  FIELD_BS(num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(apps, num_entries, 2);

DWG_NONGRAPH_END

/*(67)*/
DWG_NONGRAPH(APPID);

  FIELD_TV (entry_name);
  FIELD_B (_64_flag);
  FIELD_BS (xrefindex_plus1);
  FIELD_B (xrefdep);
  FIELD_RC (unknown);

  FIELD_HANDLE(app_control, 4);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);

DWG_NONGRAPH_END

/*(68)*/
DWG_NONGRAPH(DIMSTYLE_CONTROL);

  FIELD_BL (num_entries);

  /* This is not stated in the spec.
   * Appeared in a R2000 and in a R2004 files but not on a R14 so far.
   * TODO: this should be checked with more sample files from various DWG versions.
   */
  SINCE(R_2000)
    {
      FIELD_RC (unknown_byte);
    }

  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR (dimstyles, num_entries, 2);

DWG_NONGRAPH_END

/*(69)*/
DWG_NONGRAPH(DIMSTYLE);

  FIELD_TV (entry_name);
  FIELD_B (_64_flag);
  FIELD_BS (xrefindex_plus1);
  FIELD_B (xrefdep);

  VERSIONS(R_13, R_14)
    {
      FIELD_B (DIMTOL);
      FIELD_B (DIMLIM);
      FIELD_B (DIMTIH);
      FIELD_B (DIMTOH);
      FIELD_B (DIMSE1);
      FIELD_B (DIMSE2);
      FIELD_B (DIMALT);
      FIELD_B (DIMTOFL);
      FIELD_B (DIMSAH);
      FIELD_B (DIMTIX);
      FIELD_B (DIMSOXD);
      FIELD_RC (DIMALTD);
      FIELD_RC (DIMZIN);
      FIELD_B (DIMSD1);
      FIELD_B (DIMSD2);
      FIELD_RC (DIMTOLJ);
      FIELD_RC (DIMJUST);
      FIELD_RC (DIMFIT);
      FIELD_B (DIMUPT);
      FIELD_RC (DIMTZIN);
      FIELD_RC (DIMMALTZ);
      FIELD_RC (DIMMALTTZ);
      FIELD_RC (DIMTAD);
      FIELD_BS (DIMUNIT);
      FIELD_BS (DIMAUNIT);
      FIELD_BS (DIMDEC);
      FIELD_BS (DIMTDEC);
      FIELD_BS (DIMALTU);
      FIELD_BS (DIMALTTD);
      FIELD_BD (DIMSCALE);
      FIELD_BD (DIMASZ);
      FIELD_BD (DIMEXO);
      FIELD_BD (DIMDLI);
      FIELD_BD (DIMEXE);
      FIELD_BD (DIMRND);
      FIELD_BD (DIMDLE);
      FIELD_BD (DIMTP);
      FIELD_BD (DIMTM);
      FIELD_BD (DIMTXT);
      FIELD_BD (DIMCEN);
      FIELD_BD (DIMTSZ);
      FIELD_BD (DIMALTF);
      FIELD_BD (DIMLFAC);
      FIELD_BD (DIMTVP);
      FIELD_BD (DIMTFAC);
      FIELD_BD (DIMGAP);
      FIELD_T (DIMPOST_T);
      FIELD_T (DIMAPOST_T);
      FIELD_T (DIMBLK_T);
      FIELD_T (DIMBLK1_T);
      FIELD_T (DIMBLK2_T);
      FIELD_CMC (DIMCLRD);
      FIELD_CMC (DIMCLRE);
      FIELD_CMC (DIMCLRT);
    }

  SINCE(R_2000)
    {
      FIELD_TV (DIMPOST);
      FIELD_TV (DIMAPOST);
      FIELD_BD (DIMSCALE);
      FIELD_BD (DIMASZ);
      FIELD_BD (DIMEXO);
      FIELD_BD (DIMDLI);
      FIELD_BD (DIMEXE);
      FIELD_BD (DIMRND);
      FIELD_BD (DIMDLE);
      FIELD_BD (DIMTP);//
      FIELD_BD (DIMTM);//
    }

  SINCE(R_2007)
    {
      FIELD_BD (DIMFXL);
      FIELD_BD (DIMJOGANG);
      FIELD_BS (DIMTFILL);
      FIELD_CMC (DIMTFILLCLR);
    }

  SINCE(R_2000)
    {
      FIELD_B (DIMTOL);
      FIELD_B (DIMLIM);
      FIELD_B (DIMTIH);
      FIELD_B (DIMTOH);
      FIELD_B (DIMSE1);
      FIELD_B (DIMSE2);
      FIELD_BS (DIMTAD);
      FIELD_BS (DIMZIN);
      FIELD_BS (DIMAZIN);
    }

  SINCE(R_2007)
    {
      FIELD_BS (DIMARCSYM);
    }

  SINCE(R_2000)
    {
      FIELD_BD (DIMTXT);
      FIELD_BD (DIMCEN);
      FIELD_BD (DIMTSZ);
      FIELD_BD (DIMALTF);
      FIELD_BD (DIMLFAC);
      FIELD_BD (DIMTVP);
      FIELD_BD (DIMTFAC);
      FIELD_BD (DIMGAP);
      FIELD_BD (DIMALTRND);
      FIELD_B (DIMALT);
      FIELD_BS (DIMALTD);
      FIELD_B (DIMTOFL);
      FIELD_B (DIMSAH);
      FIELD_B (DIMTIX);
      FIELD_B (DIMSOXD);	  
      FIELD_CMC (DIMCLRD);
      FIELD_CMC (DIMCLRE);
      FIELD_CMC (DIMCLRT);
      FIELD_BS (DIMADEC);
      FIELD_BS (DIMDEC);
      FIELD_BS (DIMTDEC);
      FIELD_BS (DIMALTU);
      FIELD_BS (DIMALTTD);
      FIELD_BS (DIMAUNIT);
      FIELD_BS (DIMFRAC);
      FIELD_BS (DIMLUNIT);
      FIELD_BS (DIMDSEP);
      FIELD_BS (DIMTMOVE);
      FIELD_BS (DIMJUST);
      FIELD_B (DIMSD1);
      FIELD_B (DIMSD2);
      FIELD_BS (DIMTOLJ);
      FIELD_BS (DIMTZIN);
      FIELD_BS (DIMALTZ);
      FIELD_BS (DIMALTTZ);
      FIELD_B (DIMUPT);
      FIELD_BS (DIMFIT);
    }

  SINCE(R_2007)
    {
      FIELD_B (DIMFXLON);
    }

  SINCE(R_2000)
    {
      FIELD_BS (DIMLWD);
      FIELD_BS (DIMLWE);
    }

  FIELD_B (unknown);

  FIELD_HANDLE(dimstyle_control, 4);  
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null_handle, 5);  
  FIELD_HANDLE(shapefile, 5); /* Text style (DIMTXSTY) */

  SINCE(R_2000)
    {
      FIELD_HANDLE(leader_block,5); /* Leader arrow	(DIMLDRBLK)*/
      FIELD_HANDLE(dimblk,5); /* Arrow */
      FIELD_HANDLE(dimblk1,5); /* Arrow 1 */
      FIELD_HANDLE(dimblk2,5); /* Arrow 2 */
    }

  SINCE(R_2007)
    {
      FIELD_HANDLE(dimltype, ANYCODE);
      FIELD_HANDLE(dimltex1, ANYCODE);
      FIELD_HANDLE(dimltex2, ANYCODE);     
    }

DWG_NONGRAPH_END

/*(70)*/
DWG_NONGRAPH(VP_ENT_HDR_CONTROL);

  FIELD_BS (num_entries);
  FIELD_HANDLE(null_handle, 4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(viewport_entity_headers, num_entries, 2);

DWG_NONGRAPH_END

/*(71)*/
DWG_NONGRAPH(VP_ENT_HDR);

  FIELD_TV(entry_name);
  FIELD(_64_flag, B);
  FIELD_BS(xrefindex_plus1);
  FIELD(xrefdep, B);
  FIELD(one_flag, B);
  FIELD_HANDLE(vp_ent_ctrl, ANYCODE);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(null, 5);

DWG_NONGRAPH_END

/*(72)*/
DWG_NONGRAPH(GROUP);

  FIELD_TV (str);
  FIELD_BS (unnamed);
  FIELD_BS (selectable);
  FIELD_BL (num_handles);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(group_entries, num_handles, 5);

DWG_NONGRAPH_END;

/*(73)*/
DWG_NONGRAPH(MLINESTYLE);

  FIELD_TV(name);
  FIELD_TV(desc);
  FIELD_BS(flags);
  FIELD_CMC(fillcolor);
  FIELD_BD(startang);
  FIELD_BD(endang);
  FIELD(linesinstyle, RC);

  REPEAT(linesinstyle, lines, Dwg_Nongraph_MLINESTYLE_line)
    {
      FIELD_BD(lines[rcount].offset);
      FIELD_CMC(lines[rcount].color);
      FIELD_BS(lines[rcount].ltindex);
    }
  VECTOR_FREE (lines);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END


//pg.135
DWG_NONGRAPH(DICTIONARYVAR);

  FIELD_RC(intval);
  FIELD_TV(str);

  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END

//pg.136
DWG_ENTITY(HATCH);

  SINCE(R_2004)
    {
      FIELD_BL (is_gradient_fill);
      FIELD_BL (reserved);
      FIELD_BD (gradient_angle);
      FIELD_BD (gradient_shift);
      FIELD_BL (single_color_gradient);
      FIELD_BD (gradient_tint);
      FIELD_BL (num_colors);
      REPEAT(num_colors, colors, Dwg_Entity_HATCH_Color)
        {
          FIELD_BD(colors[rcount].unknown_double);
          FIELD_BS(colors[rcount].unknown_short);
          FIELD_BL(colors[rcount].rgb_color);
          FIELD_RC(colors[rcount].ignored_color_byte);
        }
      VECTOR_FREE (colors);
      FIELD_TV (gradient_name);
    }

  FIELD_BD (z_coord); /* x,y always 0.0 */
  FIELD_3BD (extrusion);
  FIELD_TV (name);
  FIELD_B (solid_fill);
  FIELD_B (associative);
  FIELD_BL (num_paths);
  FIELD_VALUE (tot_boundary_handles) = 0;
  FIELD_VALUE (has_derived) = 0;
  REPEAT(num_paths, paths, Dwg_Entity_HATCH_Path)
    {
      FIELD_BL(paths[rcount].flag);
      if (!(FIELD_VALUE(paths[rcount].flag) & 2))
        {
          FIELD_BL(paths[rcount].num_path_segs);
          REPEAT2(paths[rcount].num_path_segs, paths[rcount].segs, Dwg_Entity_HATCH_PathSeg)
            {
              FIELD_RC(paths[rcount].segs[rcount2].type_status);
              switch (FIELD_VALUE(paths[rcount].segs[rcount2].type_status))
                {
                    case 1: /* LINE */
                      FIELD_2RD(paths[rcount].segs[rcount2].first_endpoint);
                      FIELD_2RD(paths[rcount].segs[rcount2].second_endpoint);
                      break;
                    case 2: /* CIRCULAR ARC */
                      FIELD_2RD(paths[rcount].segs[rcount2].center);
                      FIELD_BD(paths[rcount].segs[rcount2].radius);
                      FIELD_BD(paths[rcount].segs[rcount2].start_angle);
                      FIELD_BD(paths[rcount].segs[rcount2].end_angle);
                      FIELD_B(paths[rcount].segs[rcount2].is_ccw);
                      break;
                    case 3: /* ELLIPTICAL ARC */
                      FIELD_2RD(paths[rcount].segs[rcount2].center);
                      FIELD_2RD(paths[rcount].segs[rcount2].endpoint);
                      FIELD_BD(paths[rcount].segs[rcount2].minor_major_ratio);
                      FIELD_BD(paths[rcount].segs[rcount2].start_angle);
                      FIELD_BD(paths[rcount].segs[rcount2].end_angle);
                      FIELD_B(paths[rcount].segs[rcount2].is_ccw);
                      break;
                    case 4: /* SPLINE */
                      FIELD_BL(paths[rcount].segs[rcount2].degree);
                      FIELD_B(paths[rcount].segs[rcount2].is_rational);
                      FIELD_B(paths[rcount].segs[rcount2].is_periodic);
                      FIELD_BL(paths[rcount].segs[rcount2].num_knots);
                      FIELD_BL(paths[rcount].segs[rcount2].num_control_points);
                      FIELD_VECTOR(paths[rcount].segs[rcount2].knots, BD, paths[rcount].segs[rcount2].num_knots)
                      REPEAT3(paths[rcount].segs[rcount2].num_control_points,
				      paths[rcount].segs[rcount2].control_points,
				      Dwg_Entity_HATCH_ControlPoint)
                        {
                          FIELD_2RD(paths[rcount].segs[rcount2].control_points[rcount3].point);
                          if (FIELD_VALUE(paths[rcount].segs[rcount2].is_rational))
                            {
                              FIELD_BD(paths[rcount].segs[rcount2].control_points[rcount3].weigth);
                            }
                        }                      
                      VECTOR_FREE (paths[rcount].segs[rcount2].control_points);
                      break;
                }
            }
          VECTOR_FREE (paths[rcount].segs);
        }
    else
        { /* POLYLINE PATH */
          FIELD_B(paths[rcount].bulges_present);
          FIELD_B(paths[rcount].closed);
          FIELD_BL(paths[rcount].num_path_segs);
          REPEAT2(paths[rcount].num_path_segs, paths[rcount].polyline_paths, Dwg_Entity_HATCH_PolylinePath)
            {
              FIELD_2RD (paths[rcount].polyline_paths[rcount2].point);
              if (FIELD_VALUE(paths[rcount].bulges_present))
                {
                  FIELD_BD (paths[rcount].polyline_paths[rcount2].bulge);
                }
            }
          VECTOR_FREE (paths[rcount].polyline_paths);
        }
      FIELD_BL(paths[rcount].num_boundary_handles);
      FIELD_VALUE (tot_boundary_handles) += FIELD_VALUE(paths[rcount].num_boundary_handles);
      FIELD_VALUE (has_derived) = FIELD_VALUE (has_derived) || (FIELD_VALUE (paths[rcount].flag) & 0x4);
    }
  VECTOR_FREE (paths);
  FIELD_BS(style);
  FIELD_BS(pattern_type);
  if (!FIELD_VALUE(solid_fill))
    {
      FIELD_BD (angle);
      FIELD_BD (scale_spacing);
      FIELD_B (double_flag);
      FIELD_BS (num_deflines);
      REPEAT (num_deflines, deflines, Dwg_Entity_HATCH_DefLine)
        {
          FIELD_BD (deflines[rcount].angle);
          FIELD_2BD (deflines[rcount].pt0);
          FIELD_2BD (deflines[rcount].offset);
          FIELD_BS (deflines[rcount].num_dashes);
          REPEAT2 (deflines[rcount].num_dashes, deflines[rcount].dashes, BITCODE_BD)
            {
              FIELD_BD (deflines[rcount].dashes[rcount2]);
            }
          VECTOR_FREE (deflines[rcount].dashes);
        }
      VECTOR_FREE (deflines);
    }
  if (FIELD_VALUE (has_derived))
    {
      FIELD_BD (pixel_size);
    }
  FIELD_BL (num_seeds);
  FIELD_2RD_VECTOR (seeds, num_seeds)

  COMMON_ENTITY_HANDLE_DATA;
  HANDLE_VECTOR (boundary_handles, tot_boundary_handles, 5);

DWG_ENTITY_END

//pg.139
DWG_NONGRAPH(IDBUFFER);

  FIELD_RC (unknown);
  FIELD_BL (num_ids);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(obj_ids, num_ids, 4);

DWG_NONGRAPH_END

//pg.140
DWG_ENTITY(IMAGE);

  FIELD(class_version, BL);
  FIELD_3DPOINT(pt0);
  FIELD_3DPOINT(uvec);
  FIELD_3DPOINT(vvec);
  FIELD_RD(size.width);
  FIELD_RD(size.height);
  FIELD_BS(display_props);
  FIELD(clipping, B);
  FIELD(brightness, RC);
  FIELD(contrast, RC);
  FIELD(fade, RC);

  FIELD_BS(clip_boundary_type);
  if (FIELD_VALUE(clip_boundary_type) == 1)
    {
      FIELD_2RD(boundary_pt0);
      FIELD_2RD(boundary_pt1);
    }
  else
    {
      FIELD(num_clip_verts, BL);
      REPEAT(num_clip_verts, clip_verts, Dwg_Entity_IMAGE_clip_vert) 
        {
          FIELD_2RD(clip_verts[rcount]);
        }
      VECTOR_FREE (clip_verts);
    }

  COMMON_ENTITY_HANDLE_DATA;
  FIELD_HANDLE(imagedef,5);
  FIELD_HANDLE(imagedefreactor,3);

DWG_ENTITY_END

//pg.142
DWG_NONGRAPH(IMAGEDEF);

  FIELD_BL (class_version);
  FIELD_2RD (image_size);
  FIELD_TV (file_path);
  FIELD_B (is_loaded);
  FIELD_RC (resunits);
  FIELD_2RD (pixel_size);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END

//PG.143
DWG_NONGRAPH(IMAGEDEFREACTOR);

  FIELD_BL(class_version);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END

//pg.144
DWG_NONGRAPH(LAYER_INDEX);

  FIELD_BL(timestamp1);
  FIELD_BL(timestamp2);
  FIELD_BL(num_entries);
  REPEAT(num_entries, entries, Dwg_LAYER_entry)
    {
      FIELD_BL(entries[rcount].index_long);
      FIELD_TV(entries[rcount].index_str);
    }
  VECTOR_FREE (entries);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
  HANDLE_VECTOR(entry_handles, num_entries, ANYCODE);

DWG_NONGRAPH_END

//pg.145
DWG_NONGRAPH(LAYOUT);

  FIELD_TV(page_setup_name);
  FIELD_TV(printer_or_config);
  FIELD_BS(plot_layout_flags);
  FIELD_BD(left_margin);
  FIELD_BD(bottom_margin);
  FIELD_BD(right_margin);
  FIELD_BD(top_margin);
  FIELD_BD(paper_width);
  FIELD_BD(paper_height);
  FIELD_TV(paper_size);
  FIELD_2BD(plot_origin);
  FIELD_BS(paper_units);
  FIELD_BS(plot_rotation);
  FIELD_BS(plot_type);
  FIELD_2BD(window_min);
  FIELD_2BD(window_max);

  VERSIONS(R_13,R_2000)
    {
      FIELD_TV(plot_view_name);
    }

  FIELD_BD(real_world_units);
  FIELD_BD(drawing_units);
  FIELD_TV(current_style_sheet);
  FIELD_BS(scale_type);
  FIELD_BD(scale_factor);
  FIELD_2BD(paper_image_origin);

  SINCE(R_2004)
    {
      FIELD_BS(shade_plot_mode);
      FIELD_BS(shade_plot_res_level);
      FIELD_BS(shade_plot_custom_dpi);
    }

  FIELD_TV(layout_name);
  FIELD_BS(tab_order);
  FIELD_BS(flags);
  FIELD_3DPOINT(ucs_origin);
  FIELD_2RD(minimum_limits);
  FIELD_2RD(maximum_limits);
  FIELD_3DPOINT(ins_point);
  FIELD_3DPOINT(ucs_x_axis);
  FIELD_3DPOINT(ucs_y_axis);
  FIELD_BD(elevation);
  FIELD_BS(orthoview_type);
  FIELD_3DPOINT(extent_min);
  FIELD_3DPOINT(extent_max);

  SINCE(R_2004)
    {
      FIELD_BL(viewport_count);
    }

  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

  SINCE(R_2004)
    {
      FIELD_HANDLE(plot_view_handle, ANYCODE);
    }

  SINCE(R_2007)
    {
      FIELD_HANDLE(visual_style_handle, ANYCODE);
    }

  FIELD_HANDLE(associated_paperspace_block_record_handle, ANYCODE);
  FIELD_HANDLE(last_active_viewport_handle, ANYCODE);
  FIELD_HANDLE(base_ucs_handle, ANYCODE);
  FIELD_HANDLE(named_ucs_handle, ANYCODE);

  SINCE(R_2004)
    {
      HANDLE_VECTOR(viewport_handles, viewport_count, ANYCODE);
    }

DWG_NONGRAPH_END

//pg.147
DWG_ENTITY(LWPLINE);

  FIELD_BS(flags);

  if (FIELD_VALUE(flags) & 4)
    {
      FIELD_BD(const_width);
    }    
  if (FIELD_VALUE(flags) & 8)
    {
      FIELD_BD(elevation);
    }
  if (FIELD_VALUE(flags) & 2)
    {
      FIELD_BD(thickness);
    }    
  if (FIELD_VALUE(flags) & 1)
    {
      FIELD_3BD(normal);
    }
    
  FIELD_BL(num_points);

  if (FIELD_VALUE(flags) & 16)
    {
      FIELD_BL(num_bulges);
    }
  if (FIELD_VALUE(flags) & 32)
    {
      FIELD_BL(num_widths);
    }

  VERSIONS(R_13,R_14)
    {
      FIELD_2RD_VECTOR(points, num_points);
    }

  SINCE(R_2000)
    {
      FIELD_2DD_VECTOR(points, num_points);
    }

  FIELD_VECTOR(bulges, BD, num_bulges);
  REPEAT(num_widths, widths, Dwg_Entity_LWPLINE_width)
    {
      FIELD_BD(widths[rcount].start);
      FIELD_BD(widths[rcount].end);
    }
  VECTOR_FREE (widths);

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END

//pg.149
DWG_ENTITY(OLE2FRAME);

  FIELD_BS(flags);

  SINCE(R_2000)
    {
      FIELD_BS(mode);
    }

  FIELD_BL(data_length);
  FIELD_VECTOR(data, RC, data_length);

  SINCE(R_2000)
    {
      FIELD_RC(unknown);
    }

  COMMON_ENTITY_HANDLE_DATA;

DWG_ENTITY_END


//pg.149
DWG_NONGRAPH(PROXY);

  SINCE(R_2000)
    {
      FIELD_BL(class_id);
      FIELD_BL(object_drawing_format);
      FIELD_B(original_data_format);
    }

  //TODO: figure out how to deal with the arbitrary size vector databits described on the spec

DWG_NONGRAPH_END


//pg.150
DWG_NONGRAPH(RASTERVARIABLES);

  FIELD_BL(class_version);
  FIELD_BS(display_frame);
  FIELD_BS(display_quality);
  FIELD_BS(units);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END

//pg.151
DWG_NONGRAPH(SORTENTSTABLE);

  FIELD_BL(num_entries);
  HANDLE_VECTOR(sort_handles, num_entries, 0);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
  FIELD_HANDLE(owner_handle, 4);
  HANDLE_VECTOR (object_handles, num_entries, 4);

DWG_NONGRAPH_END

//pg.152
DWG_NONGRAPH(SPATIAL_FILTER);

  FIELD_BS (num_points);
  FIELD_2RD_VECTOR (points, num_points);
  FIELD_3BD (extrusion);
  FIELD_3BD (clip_bound_origin);
  FIELD_BS (display_boundary);
  FIELD_BS (front_clip_on);
  if (FIELD_VALUE(front_clip_on)==1)
    {
      FIELD_BD (front_clip_dist);
    }

  FIELD_BS (back_clip_on);
  if (FIELD_VALUE(back_clip_on)==1)
    {
      FIELD_BD (back_clip_dist);
    }

  FIELD_VECTOR_N (inverse_block_transform, BD, 12);
  FIELD_VECTOR_N (clip_bound_transform, BD, 12);
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END

//pg.153
DWG_NONGRAPH(SPATIAL_INDEX);

  FIELD(timestamp1, BL);
  FIELD(timestamp2, BL);

#ifndef OBJECT_FREE
  while (dat->bit != 0)
    SKIP (B);
#endif
  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END

//pg.158
DWG_ENTITY(TABLE);
  //int total_attr_def_count = 0;

  FIELD_3BD (insertion_point);

  VERSIONS(R_13,R_14)
    {
      FIELD_3BD (scale);
    }

  SINCE(R_2000)
    {
      FIELD_BB (data_flags);
      switch (FIELD_VALUE(data_flags))
        {
          case 0:
            FIELD_VALUE(scale.x)=1.0;
            FIELD_DD(scale.y, FIELD_VALUE(scale.x));
            FIELD_DD(scale.z, FIELD_VALUE(scale.x));
            break;
          case 1:
            FIELD_VALUE(scale.x)=1.0;
            FIELD_DD(scale.y, 1.0);
            FIELD_DD(scale.z, 1.0);
            break;
          case 2:
            FIELD_RD(scale.x);
            FIELD_VALUE(scale.y) = FIELD_VALUE(scale.x);
            FIELD_VALUE(scale.z) = FIELD_VALUE(scale.x);
            break;
          case 3:
            FIELD_VALUE(scale.x)=1.0;
            FIELD_VALUE(scale.y)=1.0;
            FIELD_VALUE(scale.z)=1.0;
            break;
        }
    }

  FIELD_BD (rotation);
  FIELD_3BD (extrusion);
  FIELD_B (has_attribs);

  SINCE(R_2004)
    {
      FIELD_BL (owned_object_count);
    }

  FIELD_BS (flag_for_table_value);
  FIELD_3BD (horiz_direction);
  FIELD_BL (num_cols);
  FIELD_BL (num_rows);
  FIELD_VECTOR(col_widths, BD, num_cols);
  FIELD_VECTOR(row_heights, BD, num_rows);
  REPEAT_N(FIELD_VALUE(num_rows)*FIELD_VALUE(num_cols), cells, Dwg_Entity_TABLE_Cell)
    {
      FIELD_BS(cells[rcount].type);
      FIELD_RC(cells[rcount].flags);
      FIELD_B(cells[rcount].merged_value);
      FIELD_B(cells[rcount].autofit_flag);
      FIELD_BL(cells[rcount].merged_width_flag);
      FIELD_BL(cells[rcount].merged_height_flag);
      FIELD_BD(cells[rcount].rotation_value);

      if (FIELD_VALUE(cells[rcount].type)==1)
        { /* text cell */
          FIELD_TV(cells[rcount].text_string);
        }
      if (FIELD_VALUE(cells[rcount].type)==2)
        { /* block cell */
          FIELD_BD(cells[rcount].block_scale);
          FIELD_B(cells[rcount].additional_data_flag);
          if (FIELD_VALUE(cells[rcount].additional_data_flag) == 1)
            {
              FIELD_BS(cells[rcount].attr_def_count);
              FIELD_BS(cells[rcount].attr_def_index);
              FIELD_TV(cells[rcount].attr_def_text);
              //total_attr_def_count += FIELD_VALUE(cells[rcount].attr_def_count);
            }
        }
      if (FIELD_VALUE(cells[rcount].type)==1 || FIELD_VALUE(cells[rcount].type)==2)
        { /* common to both text and block cells */
          FIELD_B(cells[rcount].additional_data_flag);
          if (FIELD_VALUE(cells[rcount].additional_data_flag) == 1)
            {
              FIELD_BL(cells[rcount].cell_flag_override);
              FIELD_RC(cells[rcount].virtual_edge_flag);
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x01)
                {
                  FIELD_RS(cells[rcount].cell_alignment);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x02)
                {
                  FIELD_B(cells[rcount].background_fill_none);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x04)
                {
                  FIELD_CMC(cells[rcount].background_color);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x08)
                {
                  FIELD_CMC(cells[rcount].content_color);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x20)
                {
                  FIELD_BD(cells[rcount].text_height);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x00040)
                {
                  FIELD_CMC(cells[rcount].top_grid_color);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x00400)
                {
                  FIELD_BS(cells[rcount].top_grid_linewt);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x04000)
                {
                  FIELD_BS(cells[rcount].top_visibility);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x00080)
                {
                  FIELD_CMC(cells[rcount].right_grid_color);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x00800)
                {
                  FIELD_BS(cells[rcount].right_grid_linewt);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x08000)
                {
                  FIELD_BS(cells[rcount].right_visibility);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x00100)
                {
                  FIELD_CMC(cells[rcount].bottom_grid_color);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x01000)
                {
                  FIELD_BS(cells[rcount].bottom_grid_linewt);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x10000)
                {
                  FIELD_BS(cells[rcount].bottom_visibility);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x00200)
                {
                  FIELD_CMC(cells[rcount].left_grid_color);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x02000)
                {
                  FIELD_BS(cells[rcount].left_grid_linewt);
                }
              if (FIELD_VALUE(cells[rcount].cell_flag_override) & 0x20000)
                {
                  FIELD_BS(cells[rcount].left_visibility);
                }

              SINCE(R_2007)
                {
                  FIELD_BL(cells[rcount].unknown);
                  FIELD_BL(cells[rcount].flags_2007);
                  FIELD_BL(cells[rcount].data_type);
                  switch (FIELD_VALUE(cells[rcount].data_type))
                    {
                      case 0: /* kLong */
                        FIELD_BL(cells[rcount].data_long);
                        break;
                      case 1: /* kDouble */
                        FIELD_BD(cells[rcount].data_double);
                        break;
                      case 2: /* kString */
                        FIELD_TV(cells[rcount].data_string);
                        break;
                      case 4: /* kDate */
                        FIELD_BL(cells[rcount].data_size);
                        FIELD_VECTOR(cells[rcount].data_date, RC, cells[rcount].data_size);
                        break;
                      case 8: /* kPoint */
                        FIELD_BL(cells[rcount].data_size);
                        FIELD_2RD(cells[rcount].data_point);
                        break;
                      case 16: /* k3dPoint */
                        FIELD_BL(cells[rcount].data_size);
                        FIELD_3RD(cells[rcount].data_3dpoint);
                        break;
                      case 32: /* kObjectId */
                        //data is a HANDLE
                        //read from appropriate place in handles section
                        break;
                      case 64: /* kBuffer */
                        snprintf (tmp, 1024, "Unknwon data type in TABLE entity: \"kBuffer\".\n");
                        LOG_ERROR (tmp);
                        break;
                      case 128: /* kResBuf */
                        snprintf (tmp, 1024, "Unknwon data type in TABLE entity: \"kResBuf\".\n");
                        LOG_ERROR (tmp);
                        break;
                      case 256: /* kGeneral */
                        snprintf (tmp, 1024, "Unknwon data type in TABLE entity: \"kGeneral\".\n");
                        LOG_ERROR (tmp);
                        break;
                      default:
                        snprintf (tmp, 1024, "Invalid data type in TABLE entity\n");
                        LOG_ERROR (tmp);
                        break;
                    }
                  FIELD_BL(cells[rcount].unknown2);
                  FIELD_TV(cells[rcount].format_string);
                  FIELD_TV(cells[rcount].value_string);
                } /* end SINCE(2007)*/
            }
        }
    } /* End Cell Data (remaining data applies to entire table)*/

/* COMMON: */

  FIELD_B (table_overrides_present);
  if (FIELD_VALUE(table_overrides_present)==1)
    {
      FIELD_BL (table_flag_override);
      if (FIELD_VALUE(table_flag_override) & 0x0001)
        {
          FIELD_B (title_suppressed);
        }

      FIELD_B (header_suppressed);

      if (FIELD_VALUE(table_flag_override) & 0x0004)
        {
          FIELD_BS (flow_direction);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0008)
        {
          FIELD_BD (horiz_cell_margin);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0010)
        {
          FIELD_BD (vert_cell_margin);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0020)
        {
          FIELD_CMC (title_row_color);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0040)
        {
          FIELD_CMC (header_row_color);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0080)
        {
          FIELD_CMC (data_row_color);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0100)
        {
          FIELD_B (title_row_fill_none);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0200)
        {
          FIELD_B (header_row_fill_none);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0400)
        {
          FIELD_B (data_row_fill_none);
        }

      if (FIELD_VALUE(table_flag_override) & 0x0800)
        {
          FIELD_CMC (title_row_fill_color);
        }

      if (FIELD_VALUE(table_flag_override) & 0x1000)
        {
          FIELD_CMC (header_row_fill_color);
        }

      if (FIELD_VALUE(table_flag_override) & 0x2000)
        {
          FIELD_CMC (data_row_fill_color);
        }

      if (FIELD_VALUE(table_flag_override) & 0x4000)
        {
          FIELD_BS (title_row_align);
        }

      if (FIELD_VALUE(table_flag_override) & 0x8000)
        {
          FIELD_BS (header_row_align);
        }

      if (FIELD_VALUE(table_flag_override) & 0x10000)
        {
          FIELD_BS (data_row_align);
        }

      if (FIELD_VALUE(table_flag_override) & 0x100000)
        {
          FIELD_BD (title_row_height);
        }

      if (FIELD_VALUE(table_flag_override) & 0x200000)
        {
          FIELD_BD (header_row_height);
        }

      if (FIELD_VALUE(table_flag_override) & 0x400000)
        {
          FIELD_BD (data_row_height);
        }
    }

  FIELD_B (border_color_overrides_present);
  if (FIELD_VALUE(border_color_overrides_present)==1)
    {
      FIELD_BL (border_color_overrides_flag);
      if (FIELD_VALUE(border_color_overrides_flag) & 0x0001)
        {
          FIELD_CMC (title_horiz_top_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0002)
        {
          FIELD_CMC (title_horiz_ins_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0004)
        {
          FIELD_CMC (title_horiz_bottom_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0008)
        {
          FIELD_CMC (title_vert_left_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0010)
        {
          FIELD_CMC (title_vert_ins_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0020)
        {
          FIELD_CMC (title_vert_right_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0040)
        {
          FIELD_CMC (header_horiz_top_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0080)
        {
          FIELD_CMC (header_horiz_ins_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0100)
        {
          FIELD_CMC (header_horiz_bottom_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0200)
        {
          FIELD_CMC (header_vert_left_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0400)
        {
          FIELD_CMC (header_vert_ins_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x0800)
        {
          FIELD_CMC (header_vert_right_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x1000)
        {
          FIELD_CMC (data_horiz_top_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x2000)
        {
          FIELD_CMC (data_horiz_ins_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x4000)
        {
          FIELD_CMC (data_horiz_bottom_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x8000)
        {
          FIELD_CMC (data_vert_left_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x10000)
        {
          FIELD_CMC (data_vert_ins_color);
        }

      if (FIELD_VALUE(border_color_overrides_flag) & 0x20000)
        {
          FIELD_CMC (data_vert_right_color);
        }
    }

  FIELD_B (border_lineweight_overrides_present);
  if (FIELD_VALUE(border_lineweight_overrides_present)==1)
    {
      FIELD_BL (border_lineweight_overrides_flag);
      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0001)
        {
          FIELD_BS (title_horiz_top_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0002)
        {
          FIELD_BS (title_horiz_ins_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0004)
        {
          FIELD_BS (title_horiz_bottom_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0008)
        {
          FIELD_BS (title_vert_left_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0010)
        {
          FIELD_BS (title_vert_ins_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0020)
        {
          FIELD_BS (title_vert_right_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0040)
        {
          FIELD_BS (header_horiz_top_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0080)
        {
          FIELD_BS (header_horiz_ins_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0100)
        {
          FIELD_BS (header_horiz_bottom_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0200)
        {
          FIELD_BS (header_vert_left_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0400)
        {
          FIELD_BS (header_vert_ins_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x0800)
        {
          FIELD_BS (header_vert_right_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x1000)
        {
          FIELD_BS (data_horiz_top_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x2000)
        {
          FIELD_BS (data_horiz_ins_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x4000)
        {
          FIELD_BS (data_horiz_bottom_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x8000)
        {
          FIELD_BS (data_vert_left_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x10000)
        {
          FIELD_BS (data_vert_ins_lineweigh);
        }

      if (FIELD_VALUE(border_lineweight_overrides_flag) & 0x20000)
        {
          FIELD_BS (data_vert_right_lineweigh);
        }
    }

  FIELD_B (border_visibility_overrides_present);
  if (FIELD_VALUE(border_visibility_overrides_present)==1)
    {
      FIELD_BL (border_visibility_overrides_flag);
      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0001)
        {
          FIELD_BS (title_horiz_top_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0002)
        {
          FIELD_BS (title_horiz_ins_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0004)
        {
          FIELD_BS (title_horiz_bottom_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0008)
        {
          FIELD_BS (title_vert_left_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0010)
        {
          FIELD_BS (title_vert_ins_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0020)
        {
          FIELD_BS (title_vert_right_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0040)
        {
          FIELD_BS (header_horiz_top_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0080)
        {
          FIELD_BS (header_horiz_ins_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0100)
        {
          FIELD_BS (header_horiz_bottom_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0200)
        {
          FIELD_BS (header_vert_left_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0400)
        {
          FIELD_BS (header_vert_ins_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x0800)
        {
          FIELD_BS (header_vert_right_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x1000)
        {
          FIELD_BS (data_horiz_top_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x2000)
        {
          FIELD_BS (data_horiz_ins_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x4000)
        {
          FIELD_BS (data_horiz_bottom_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x8000)
        {
          FIELD_BS (data_vert_left_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x10000)
        {
          FIELD_BS (data_vert_ins_visibility);
        }

      if (FIELD_VALUE(border_visibility_overrides_flag) & 0x20000)
        {
          FIELD_BS (data_vert_right_visibility);
        }
    }

  FIELD_HANDLE(block_header, 5);

  VERSIONS(R_13, R_2000)
    {
      if (FIELD_VALUE(has_attribs))
        {
          FIELD_HANDLE(first_attrib, 4);
          FIELD_HANDLE(last_attrib, 4);
        }
    }

  SINCE(R_2004)
    {
      HANDLE_VECTOR(attribs, owned_object_count, 4)
    }

  if (FIELD_VALUE(has_attribs))
    {
      FIELD_HANDLE(seqend, 3);
    }

  FIELD_HANDLE(table_style_id, ANYCODE);

  REPEAT_N(FIELD_VALUE(num_rows)*FIELD_VALUE(num_cols), cells, Dwg_Entity_TABLE_Cell)
    {
      FIELD_HANDLE(cells[rcount].cell_handle, ANYCODE);

      if (FIELD_VALUE(cells[rcount].type) == 2 &&
          FIELD_VALUE(cells[rcount].additional_data_flag) == 1)
        {
          HANDLE_VECTOR(cells[rcount].attr_def_id, cells[rcount].attr_def_count, ANYCODE);
        }

      if (FIELD_VALUE(cells[rcount].additional_data_flag2) == 1 &&
          FIELD_VALUE(cells[rcount].cell_flag_override) & 0x08)
        {
          FIELD_HANDLE(cells[rcount].text_style_override, ANYCODE);
        }
    }
  VECTOR_FREE(cells);

  FIELD_HANDLE(title_row_style_override, ANYCODE);
  FIELD_HANDLE(header_row_style_override, ANYCODE);
  FIELD_HANDLE(data_row_style_override, ANYCODE);

DWG_ENTITY_END

//pg.164
DWG_NONGRAPH(XRECORD);

    {
	  FIELD_BL(numdatabytes);  	    
	  FIELD_XDATA(rbuf, numdatabytes);
	  
	  SINCE(R_2000)
		{
		  FIELD_BS(cloning_flags);
		}
	  
	  FIELD_HANDLE_NGR (parenthandle);
	  REACTORS(4);
	  XDICOBJHANDLE(3);
	  
	  //XXX how to known when I run out of data?
	  //BITCODE_H* objid_handles;
    }
    
DWG_NONGRAPH_END

DWG_NONGRAPH(PLACEHOLDER);

  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);
    
DWG_NONGRAPH_END


/* DWG_ENTITY(WIPEOUT); <==> DWG_ENTITY(IMAGE); */


/* TODO This is not tested absolutely, just a guess!
 */
DWG_NONGRAPH(WIPEOUTVARIABLES);

  FIELD_BS(display_frame);

  FIELD_HANDLE_NGR (parenthandle);
  REACTORS(4);
  XDICOBJHANDLE(3);

DWG_NONGRAPH_END
