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
 *     \file       dwg-dump.c
 *     \brief      Dump data from a DWG file
 *     \author     written by Felipe E. F. de Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define SHOW_CLA
#define SHOW_VAR
#define SHOW_OBJ

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "dwg.h"
#include "config.h"
#include "logging.h"

/* Auto-generated variables dumping function: */
//#include "dump_variables.c"

/* Auto-generated object dumping functions: */
//#include "dump_objects.c"

/* Auto-generated entity handle dumping function: */
//#include "dump_entity_handle.c"

void
dump_objects (Dwg_Struct * dwg)
{
  unsigned int i, j;
  Dwg_Object *obj;
  Bit_Chain dat;

  dat.chain = (unsigned char *) malloc (1024);
  dat.size = 1024;
  dat.version = dwg->header.version;

  for (i = 0; i < dwg->num_objects; i++)
    {
      obj = &dwg->object[i];
      printf ("[%u] ", i);
      dat.byte = 0;
      dat.bit = 0;
      switch (obj->type)
	{
	case DWG_TYPE_TEXT:
	  dump_TEXT (&dat, obj);
	  break;
	case DWG_TYPE_ATTRIB:
	  dump_ATTRIB (&dat, obj);
	  break;
	case DWG_TYPE_ATTDEF:
	  dump_ATTDEF (&dat, obj);
	  break;
	case DWG_TYPE_BLOCK:
	  dump_BLOCK (&dat, obj);
	  break;
	case DWG_TYPE_ENDBLK:
	  dump_ENDBLK (&dat, obj);
	  break;
	case DWG_TYPE_SEQEND:
	  dump_SEQEND (&dat, obj);
	  break;
	case DWG_TYPE_INSERT:
	  dump_INSERT (&dat, obj);
	  break;
	case DWG_TYPE_MINSERT:
	  dump_MINSERT (&dat, obj);
	  break;
	case DWG_TYPE_VERTEX_2D:
	  dump_VERTEX_2D (&dat, obj);
	  break;
	case DWG_TYPE_VERTEX_3D:
	  dump_VERTEX_3D (&dat, obj);
	  break;
	case DWG_TYPE_VERTEX_MESH:
	  dump_VERTEX_MESH (&dat, obj);
	  break;
	case DWG_TYPE_VERTEX_PFACE:
	  dump_VERTEX_PFACE (&dat, obj);
	  break;
	case DWG_TYPE_VERTEX_PFACE_FACE:
	  dump_VERTEX_PFACE_FACE (&dat, obj);
	  break;
	case DWG_TYPE_POLYLINE_2D:
	  dump_POLYLINE_2D (&dat, obj);
	  break;
	case DWG_TYPE_POLYLINE_3D:
	  dump_POLYLINE_3D (&dat, obj);
	  break;
	case DWG_TYPE_ARC:
	  dump_ARC (&dat, obj);
	  break;
	case DWG_TYPE_CIRCLE:
	  dump_CIRCLE (&dat, obj);
	  break;
	case DWG_TYPE_LINE:
	  dump_LINE (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_ORDINATE:
	  dump_DIMENSION_ORDINATE (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_LINEAR:
	  dump_DIMENSION_LINEAR (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_ALIGNED:
	  dump_DIMENSION_ALIGNED (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_ANG3PT:
	  dump_DIMENSION_ANG3PT (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_ANG2LN:
	  dump_DIMENSION_ANG2LN (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_RADIUS:
	  dump_DIMENSION_RADIUS (&dat, obj);
	  break;
	case DWG_TYPE_DIMENSION_DIAMETER:
	  dump_DIMENSION_DIAMETER (&dat, obj);
	  break;
	case DWG_TYPE_POINT:
	  dump_POINT (&dat, obj);
	  break;
	case DWG_TYPE__3DFACE:
	  dump__3DFACE (&dat, obj);
	  break;
	case DWG_TYPE_POLYLINE_PFACE:
	  dump_POLYLINE_PFACE (&dat, obj);
	  break;
	case DWG_TYPE_POLYLINE_MESH:
	  dump_POLYLINE_MESH (&dat, obj);
	  break;
	case DWG_TYPE_SOLID:
	  dump_SOLID (&dat, obj);
	  break;
	case DWG_TYPE_TRACE:
	  dump_TRACE (&dat, obj);
	  break;
	case DWG_TYPE_SHAPE:
	  dump_SHAPE (&dat, obj);
	  break;
	case DWG_TYPE_VIEWPORT:
	  dump_VIEWPORT (&dat, obj);
	  break;
	case DWG_TYPE_ELLIPSE:
	  dump_ELLIPSE (&dat, obj);
	  break;
	case DWG_TYPE_SPLINE:
	  dump_SPLINE (&dat, obj);
	  break;
	case DWG_TYPE_REGION:
	  dump_REGION (&dat, obj);
	  break;
	case DWG_TYPE_3DSOLID:
	  dump__3DSOLID (&dat, obj);
	  break;
	case DWG_TYPE_BODY:
	  dump_BODY (&dat, obj);
	  break;
	case DWG_TYPE_RAY:
	  dump_RAY (&dat, obj);
	  break;
	case DWG_TYPE_XLINE:
	  dump_XLINE (&dat, obj);
	  break;
	case DWG_TYPE_DICTIONARY:
	  dump_DICTIONARY (&dat, obj);
	  break;
	case DWG_TYPE_MTEXT:
	  dump_MTEXT (&dat, obj);
	  break;
	case DWG_TYPE_LEADER:
	  dump_LEADER (&dat, obj);
	  break;
	case DWG_TYPE_TOLERANCE:
	  dump_TOLERANCE (&dat, obj);
	  break;
	case DWG_TYPE_MLINE:
	  dump_MLINE (&dat, obj);
	  break;
	case DWG_TYPE_BLOCK_CONTROL:
	  dump_BLOCK_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_BLOCK_HEADER:
	  dump_BLOCK_HEADER (&dat, obj);
	  break;
	case DWG_TYPE_LAYER_CONTROL:
	  dump_LAYER_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_LAYER:
	  dump_LAYER (&dat, obj);
	  break;
	case DWG_TYPE_SHAPEFILE_CONTROL:
	  dump_SHAPEFILE_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_SHAPEFILE:
	  dump_SHAPEFILE (&dat, obj);
	  break;
	case DWG_TYPE_LTYPE_CONTROL:
	  dump_LTYPE_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_LTYPE:
	  dump_LTYPE (&dat, obj);
	  break;
	case DWG_TYPE_VIEW_CONTROL:
	  dump_VIEW_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_VIEW:
	  dump_VIEW (&dat, obj);
	  break;
	case DWG_TYPE_UCS_CONTROL:
	  dump_UCS_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_UCS:
	  dump_UCS (&dat, obj);
	  break;
	case DWG_TYPE_VPORT_CONTROL:
	  dump_VPORT_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_VPORT:
	  dump_VPORT (&dat, obj);
	  break;
	case DWG_TYPE_APPID_CONTROL:
	  dump_APPID_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_APPID:
	  dump_APPID (&dat, obj);
	  break;
	case DWG_TYPE_DIMSTYLE_CONTROL:
	  dump_DIMSTYLE_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_DIMSTYLE:
	  dump_DIMSTYLE (&dat, obj);
	  break;
	case DWG_TYPE_VP_ENT_HDR_CONTROL:
	  dump_VP_ENT_HDR_CONTROL (&dat, obj);
	  break;
	case DWG_TYPE_VP_ENT_HDR:
	  dump_VP_ENT_HDR (&dat, obj);
	  break;
	case DWG_TYPE_GROUP:
	  dump_GROUP (&dat, obj);
	  break;
	case DWG_TYPE_MLINESTYLE:
	  dump_MLINESTYLE (&dat, obj);
	  break;
	case DWG_TYPE_LWPLINE:
	  dump_LWPLINE (&dat, obj);
	  break;
	case DWG_TYPE_HATCH:
	  dump_HATCH (&dat, obj);
	  break;
	case DWG_TYPE_XRECORD:
	  dump_XRECORD (&dat, obj);
	  break;
	case DWG_TYPE_PLACEHOLDER:
	  dump_PLACEHOLDER (&dat, obj);
	  break;
	case DWG_TYPE_LAYOUT:
	  dump_LAYOUT (&dat, obj);
	  break;
	default:
	  j = obj->type - 500;
	  if (j >= dwg->num_classes)
	    printf ("Unknown type, not dumping: %u\n", obj->type);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "DICTIONARYVAR"))
	    dump_DICTIONARYVAR (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "ACDBDICTIONARYWDFLT"))
	    dump_DICTIONARYWDLFT (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "HATCH"))
	    dump_HATCH (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "IDBUFFER"))
	    dump_IDBUFFER (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "IMAGE"))
	    dump_IMAGE (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "IMAGEDEF"))
	    dump_IMAGEDEF (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "IMAGEDEF_REACTOR"))
	    dump_IMAGEDEFREACTOR (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "LAYER_INDEX"))
	    dump_LAYER_INDEX (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "LAYOUT"))
	    dump_LAYOUT (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "LWPLINE"))
	    dump_LWPLINE (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "OLE2FRAME"))
	    dump_OLE2FRAME (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "ACDBPLACEHOLDER"))
	    dump_PLACEHOLDER (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "RASTERVARIABLES"))
	    dump_RASTERVARIABLES (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "SORTENTSTABLE"))
	    dump_SORTENTSTABLE (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "SPATIAL_FILTER"))
	    dump_SPATIAL_FILTER (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "SPATIAL_INDEX"))
	    dump_SPATIAL_INDEX (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "XRECORD"))
	    dump_XRECORD (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "WIPEOUT"))
	    dump_IMAGE (&dat, obj);
	  else if (!strcmp ((const char *) dwg->dwg_class[j].dxfname, "WIPEOUTVARIABLES"))
	    dump_WIPEOUTVARIABLES (&dat, obj);
	  else
	    printf ("Unknown variable type, not dumping: %u\n", obj->type);
	}
    }
  free (dat.chain);
}

void
dump_classes (Dwg_Struct * dwg)
{
  unsigned int i;
  for (i = 0; i < dwg->num_classes; i++)
    {
      printf ("[%u] Class number %u:\n", i, dwg->dwg_class[i].number);
      printf ("  version: %u\n", dwg->dwg_class[i].version);
      printf ("  appname: %s\n", dwg->dwg_class[i].appname);
      printf ("  cppname: %s\n", dwg->dwg_class[i].cppname);
      printf ("  dxfname: %s\n", dwg->dwg_class[i].dxfname);
      printf ("  wasazombie: %u\n", dwg->dwg_class[i].wasazombie);
      printf ("  item_class_id: 0x%X\n", dwg->dwg_class[i].item_class_id);
    }
}

void
show_usage ()
{
  printf ("Usage: dwg-dump FILE [> outputfile.txt]\n");
  printf ("       dwg-dump OPTION\n");
  puts ("");
  printf ("FILE must be a DWG file, with a .dwg extension. Only versions\n"
	  "%s to %s are accepted for now. The output goes to stdout,\n"
	  "so it should be redirected to a file.\n", "R13", "R2004");
  puts ("");
  printf ("Options (one at time):\n");
  printf ("-h, --help      show simple usage information and exit.\n");
  printf ("-v, --version   show the program version and exit.\n");
  puts ("");
}

int
parse_options (int argc, char *argv[])
{
  char *fn;
  if (1 == argc)
    {
      show_usage ();
      printf ("No input file specified.\n");
      return (-1);
    }
  if (argc > 2)
    {
      show_usage ();
      printf ("Only 1 argument at time is acceptable.\n");
      return (-1);
    }
  if (strcmp ("-h", argv[1]) == 0 || strcmp ("--help", argv[1]) == 0)
    {
      show_usage ();
      exit (0);
    }
  if (strcmp ("-v", argv[1]) == 0 || strcmp ("--version", argv[1]) == 0)
    {
      printf ("dwg-dump %s\n", PACKAGE_VERSION);
      exit (0);
    }
  if (argv[1][0] == '-')
    {
      show_usage ();
      printf ("Option not available: %s\n", argv[1]);
      return (-1);
    }
  fn = strrchr (argv[1], '.');
  if (fn == NULL)
    {
      show_usage ();
      printf ("The input file extension should be .dwg\n");
      return (-1);
    }
  if (tolower (fn[1]) != 'd' || tolower (fn[2]) != 'w' || tolower (fn[3]) != 'g')
    {
      show_usage ();
      printf ("The input file extension should be like .dwg\n");
      return (-1);
    }

  return (0);
}

int
main (int argc, char *argv[])
{
  int fail;
  Dwg_Struct dwg;
  fail = parse_options (argc, argv);
  if (fail)
    return (-1);
  dwg.num_classes = 0;
  dwg.num_objects = 0;
  fail = dwg_read_file (argv[1], &dwg);
  if (fail)
    {
      printf ("Failed, sorry.\n");
      return (-1);
    }

  puts ("-- DWG dumped data --");
  printf ("   version: %s\n", dwg_version_code (&dwg));
  puts ("");
#ifdef SHOW_VAR
  puts ("-- VARIABLES --");
  dump_variables (&dwg);
  puts ("");
#endif
#ifdef SHOW_CLA
  puts ("-- CLASSES --");
  printf ("   num_classes: %lu\n", dwg.num_classes);
  dump_classes (&dwg);
  puts ("");
#endif
#ifdef SHOW_OBJ
  puts ("-- OBJECTS --");
  printf ("   num_objects: %lu\n", dwg.num_objects);
  dump_objects (&dwg);
  puts ("");
#endif
  return 0;
}
