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
 *     \file       dwg-dxf.c
 *     \brief      Convert a DWG file to a DXF one, text mode.
 *     \author     written by Felipe E. F. de Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include "config.h"

#include "dwg.h"
#include "logging.h"
#include "dwg-dxf.h"

/* Global vars
 */
FILE * fp;
char tmp[4096];
char * format_s;
int * checked_obj;

void
show_usage ()
{
  printf ("Usage: dwg-dxf FILE\n");
  printf ("       dwg-dxf OPTION\n");
  puts ("");
  printf ("FILE must be a DWG file, with a .dwg extension. Only versions\n"
	  "%s to %s are accepted for now. The output goes to a file\n"
	  "with same basename of FILE, but with its extension being dxf.\n",
	  "R13", "R2004");
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
      printf ("dwg-dxf %s\n", PACKAGE_VERSION);
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
  if (tolower (fn[1]) != 'd' ||
      tolower (fn[2]) != 'w' || tolower (fn[3]) != 'g')
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
  char *outfile;
  int fail;
  long size;
  uint32_t i, missing;
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

  /* Make output filename and open for writing
   */
  size = strlen (argv[1]);
  if (size < 5)
    size = 5;
  outfile = (char *) malloc (size);
  if (size == 5)
    strcpy (outfile, "a.dxf");
  else
    {
      strcpy (outfile, argv[1]);
      strcpy (outfile + size - 4, ".dxf");
    }
  fp = fopen (outfile, "w");
  if (!fp)
    {
      printf ("Unable to write to file '%s'\n", outfile);
      free (outfile);
      return -1;
    }

  /* Prepare object output control: 1 means written; 0 not written
   */
  checked_obj = (int *) calloc (dwg.num_objects, sizeof (int));

  /* Write out all sections
   */
  dxf_header_write (&dwg);
  dxf_classes_write (&dwg);
  dxf_tables_write (&dwg);
  dxf_blocks_write (&dwg);
  dxf_entities_write (&dwg);
  dxf_nongraphs_write (&dwg);

  /* Statistics
  missing = dwg.num_objects;
  for (i = 0; i < dwg.num_objects; i++)
    if (checked_obj[i])
      missing--;
  printf ("Objects written: %lu\n", dwg.num_objects - missing);
  printf ("And not written: %lu\n", missing);
   */

  free (checked_obj);

  return 0;
}

char *
codepage_string (int cpage)
{
  switch (cpage)
    {
    case 30:
      return "ANSI_1252";
    }
  printf ("[WARN] Not known codepage id: %i. Assuming ANSI_1252.\n", cpage);
  return "ANSI_1252";
}

/* HEADER section
 */
void
dxf_header_write (Dwg_Struct * dwg)
{
  uint32_t idx;
  uint32_t inum;

  SEC (HEADER);

  VAR (ACADVER, 1, "AC1015");	/* Writting as R2000 DXF */
  VAR (ACADMAINTVER, 70, 20);
  VAR (DWGCODEPAGE, 3, codepage_string (dwg->header.codepage));

  VAR0_3D (INSBASE, 10, 20, 30);
  VAR0_3D (EXTMIN, 10, 20, 30);
  VAR0_3D (EXTMAX, 10, 20, 30);
  VAR0_2D (LIMMIN, 10, 20);
  VAR0_2D (LIMMAX, 10, 20);

  VAR0 (ORTHOMODE, 70);
  VAR0 (REGENMODE, 70);
  VAR0 (FILLMODE, 70);
  VAR0 (QTEXTMODE, 70);
  VAR0 (MIRRTEXT, 70);
  VAR0_1D (LTSCALE, 40);
  VAR0 (ATTMODE, 70);
  VAR0_1D (TEXTSIZE, 40);
  VAR0_1D (TRACEWID, 40);

  VAR_H2N (TEXTSTYLE, 7, SHAPEFILE.entry_name);
  VAR_H2N (CLAYER, 8, LAYER.entry_name);
  VAR_H2N (CELTYPE, 6, LTYPE.entry_name);

  VAR0_CMC (CECOLOR, 62);
  VAR0_1D (CELTSCALE, 40);

  VAR0 (DISPSILH, 70);

  VAR0_1D (DIMSCALE, 40);
  VAR0_1D (DIMASZ, 40);
  VAR0_1D (DIMEXO, 40);
  VAR0_1D (DIMDLI, 40);
  VAR0_1D (DIMRND, 40);
  VAR0_1D (DIMDLE, 40);
  VAR0_1D (DIMEXE, 40);
  VAR0_1D (DIMTP, 40);
  VAR0_1D (DIMTM, 40);
  VAR0_1D (DIMTXT, 40);
  VAR0_1D (DIMCEN, 40);
  VAR0_1D (DIMTSZ, 40);
  VAR0 (DIMTOL, 70);
  VAR0 (DIMLIM, 70);
  VAR0 (DIMTIH, 70);
  VAR0 (DIMTOH, 70);
  VAR0 (DIMSE1, 70);
  VAR0 (DIMSE2, 70);
  VAR0 (DIMTAD, 70);
  VAR0 (DIMZIN, 70);
  VAR_H2N (DIMBLK, 1, BLOCK_HEADER.entry_name);
  VAR0 (DIMASO, 70);
  VAR0 (DIMSHO, 70);
  VAR0 (DIMPOST, 1);
  VAR0 (DIMAPOST, 1);
  VAR0 (DIMALT, 70);
  VAR0 (DIMALTD, 70);
  VAR0_1D (DIMALTF, 40);
  VAR0_1D (DIMLFAC, 40);
  VAR0 (DIMTOFL, 70);
  VAR0_1D (DIMTVP, 40);
  VAR0 (DIMTIX, 70);
  VAR0 (DIMSOXD, 70);
  VAR0 (DIMSAH, 70);
  VAR_H2N (DIMBLK1, 1, BLOCK_HEADER.entry_name);
  VAR_H2N (DIMBLK2, 1, BLOCK_HEADER.entry_name);
  VAR_H2N (DIMSTYLE, 2, DIMSTYLE.entry_name);
  VAR0_CMC (DIMCLRD, 70);
  VAR0_CMC (DIMCLRE, 70);
  VAR0_CMC (DIMCLRT, 70);
  VAR0_1D (DIMTFAC, 40);
  VAR0_1D (DIMGAP, 40);
  VAR0 (DIMJUST, 70);
  VAR0 (DIMSD1, 70);
  VAR0 (DIMSD2, 70);
  VAR0 (DIMTOLJ, 70);
  VAR0 (DIMTZIN, 70);
  VAR0 (DIMALTZ, 70);
  VAR0 (DIMALTTZ, 70);
  VAR0 (DIMUPT, 70);
  VAR0 (DIMDEC, 70);
  VAR0 (DIMTDEC, 70);
  VAR0 (DIMALTU, 70);
  VAR0 (DIMALTTD, 70);
  VAR_H2N (DIMTXSTY, 7, SHAPEFILE.entry_name);
  VAR0 (DIMAUNIT, 70);
  VAR0 (DIMADEC, 70);
  VAR0_1D (DIMALTRND, 40);
  VAR0 (DIMAZIN, 70);
  VAR0 (DIMDSEP, 70);
  VAR0 (DIMATFIT, 70);
  VAR0 (DIMFRAC, 70);
  VAR_H2N (DIMLDRBLK, 1, BLOCK_HEADER.entry_name);
  VAR0 (DIMLUNIT, 70);
  VAR0I (DIMLWD, 70);
  VAR0I (DIMLWE, 70);
  VAR0 (DIMTMOVE, 70);

  VAR0 (LUNITS, 70);
  VAR0 (LUPREC, 70);
  VAR0_1D (SKETCHINC, 40);
  VAR0_1D (FILLETRAD, 40);
  VAR0 (AUNITS, 70);
  VAR0 (AUPREC, 70);
  VAR0 (MENU, 1);
  VAR0_1D (ELEVATION, 40);
  VAR0_1D (PELEVATION, 40);
  VAR0_1D (THICKNESS, 40);
  VAR0 (LIMCHECK, 70);
  VAR0_1D (CHAMFERA, 40);
  VAR0_1D (CHAMFERB, 40);
  VAR0_1D (CHAMFERC, 40);
  VAR0_1D (CHAMFERD, 40);
  VAR0 (SKPOLY, 70);

  inum = dwg->variable.TDCREATE_MILLISECONDS;
  VAR (TDCREATE, 40,
       dwg->variable.TDCREATE_JULIAN_DAY + (double) inum / 1.0e8);
  VAR (TDUCREATE, 40, dwg->variable.TDCREATE_JULIAN_DAY + (double) inum / 1.0e8);	//XXX repeating

  inum = dwg->variable.TDUPDATE_MILLISECONDS;
  VAR (TDUPDATE, 40,
       dwg->variable.TDUPDATE_JULIAN_DAY + (double) inum / 1.0e8);
  VAR (TDUUPDATE, 40, dwg->variable.TDUPDATE_JULIAN_DAY + (double) inum / 1.0e8);	//XXX repeating

  inum = dwg->variable.TDINDWG_MILLISECONDS;
  VAR (TDINDWG, 40, dwg->variable.TDINDWG_DAYS + (double) inum / 1.0e8);

  inum = dwg->variable.TDUSRTIMER_MILLISECONDS;
  VAR (TDUSRTIMER, 40,
       dwg->variable.TDUSRTIMER_DAYS + (double) inum / 1.0e8);

  VAR0 (USRTIMER, 70);
  VAR0_1D (ANGBASE, 50);
  VAR0 (ANGDIR, 70);
  VAR0 (PDMODE, 70);
  VAR0_1D (PDSIZE, 40);
  VAR0_1D (PLINEWID, 40);
  VAR0 (SPLFRAME, 70);
  VAR0 (SPLINETYPE, 70);
  VAR0 (SPLINESEGS, 70);

  VAR0_H (HANDSEED, 5);

  VAR0 (SURFTAB1, 70);
  VAR0 (SURFTAB2, 70);
  VAR0 (SURFTYPE, 70);
  VAR0 (SURFU, 70);
  VAR0 (SURFV, 70);

  VAR_H2N (UCSBASE, 2, UCS.entry_name);
  VAR_H2N (UCSNAME, 2, UCS.entry_name);
  VAR0_3D (UCSORG, 10, 20, 30);
  VAR0_3D (UCSXDIR, 10, 20, 30);
  VAR0_3D (UCSYDIR, 10, 20, 30);
  VAR_H2N (UCSORTHOREF, 2, UCS.entry_name);
  VAR0 (UCSORTHOVIEW, 70);
  VAR0_3D (UCSORGTOP, 10, 20, 30);
  VAR0_3D (UCSORGBOTTOM, 10, 20, 30);
  VAR0_3D (UCSORGLEFT, 10, 20, 30);
  VAR0_3D (UCSORGRIGHT, 10, 20, 30);
  VAR0_3D (UCSORGFRONT, 10, 20, 30);
  VAR0_3D (UCSORGBACK, 10, 20, 30);

  VAR_H2N (PUCSBASE, 2, UCS.entry_name);
  VAR_H2N (PUCSNAME, 2, UCS.entry_name);
  VAR0_3D (PUCSORG, 10, 20, 30);
  VAR0_3D (PUCSXDIR, 10, 20, 30);
  VAR0_3D (PUCSYDIR, 10, 20, 30);
  VAR_H2N (PUCSORTHOREF, 2, UCS.entry_name);
  VAR0 (PUCSORTHOVIEW, 70);
  VAR0_3D (PUCSORGTOP, 10, 20, 30);
  VAR0_3D (PUCSORGBOTTOM, 10, 20, 30);
  VAR0_3D (PUCSORGLEFT, 10, 20, 30);
  VAR0_3D (PUCSORGRIGHT, 10, 20, 30);
  VAR0_3D (PUCSORGFRONT, 10, 20, 30);
  VAR0_3D (PUCSORGBACK, 10, 20, 30);

  VAR0 (USERI1, 70);
  VAR0 (USERI2, 70);
  VAR0 (USERI3, 70);
  VAR0 (USERI4, 70);
  VAR0 (USERI5, 70);
  VAR0_1D (USERR1, 40);
  VAR0_1D (USERR2, 40);
  VAR0_1D (USERR3, 40);
  VAR0_1D (USERR4, 40);
  VAR0_1D (USERR5, 40);

  VAR0 (WORLDVIEW, 70);
  VAR0 (SHADEDGE, 70);
  VAR0 (SHADEDIF, 70);
  VAR0 (TILEMODE, 70);
  VAR0 (MAXACTVP, 70);

  VAR0_3D (PINSBASE, 10, 20, 30);
  VAR0 (PLIMCHECK, 70);
  VAR0_3D (PEXTMIN, 10, 20, 30);
  VAR0_3D (PEXTMAX, 10, 20, 30);
  VAR0_2D (PLIMMIN, 10, 20);
  VAR0_2D (PLIMMAX, 10, 20);

  VAR0 (UNITMODE, 70);
  VAR0 (VISRETAIN, 70);
  VAR0 (PLINEGEN, 70);
  VAR0 (PSLTSCALE, 70);
  VAR0 (TREEDEPTH, 70);
  VAR_H2N (CMLSTYLE, 2, MLINESTYLE.name);
  VAR0 (CMLJUST, 70);
  VAR0_1D (CMLSCALE, 40);
  VAR0 (PROXYGRAPHICS, 70);
  VAR (MEASUREMENT, 70, (dwg->variable.MEASUREMENT ? 1 : 0));

  VAR (CELWEIGHT, 370, dwg->variable.FLAGS & 0x001F);
  VAR (ENDCAPS, 280, (dwg->variable.FLAGS & 0x0060) >> 5);
  VAR (JOINSTYLE, 280, (dwg->variable.FLAGS & 0x0180) >> 7);
  VAR (LWDISPLAY, 290, !(dwg->variable.FLAGS & 0x0200));
  VAR0 (INSUNITS, 70);
  VAR0 (HYPERLINKBASE, 1);
  VAR0 (STYLESHEET, 1);		//XXX Not documented on DXF spec
  VAR (XEDIT, 290, !(dwg->variable.FLAGS & 0x0400));
  VAR0 (CEPSNTYPE, 380);
  if (dwg->variable.CEPSNTYPE == 3)
    {
      VAR_H2N (CPSNID, 390, LTYPE.entry_name);
    }
  VAR (PSTYLEMODE, 290, (dwg->variable.FLAGS & 0x2000) >> 13);
  VAR0 (FINGERPRINTGUID, 2);
  VAR0 (VERSIONGUID, 2);
  VAR (EXTNAMES, 290, (dwg->variable.FLAGS & 0x0800) >> 11);
  VAR0_1D (PSVPSCALE, 40);
  VAR (OLESTARTUP, 290, (dwg->variable.FLAGS & 0x4000) >> 14);	//XXX Not documented on DXF spec

  ENDSEC ();
}

/* CLASSES section
 */
void
dxf_classes_write (Dwg_Struct * dwg)
{
  int16_t i;

#define CLASS_IS_ENTITY(dxfname) (\
	 strcmp (dxfname, "ARC_DIMENSION") == 0 ||\
	 strcmp (dxfname, "ARCALIGNEDTEXT") == 0 ||\
	 strcmp (dxfname, "HATCH") == 0 ||\
	 strcmp (dxfname, "IMAGE") == 0 ||\
	 strcmp (dxfname, "LARGE_RADIAL_DIMENSION") == 0 ||\
	 strcmp (dxfname, "LWPOLYLINE") == 0 ||\
	 strcmp (dxfname, "OLE2FRAME") == 0 ||\
	 strcmp (dxfname, "RTEXT") == 0 ||\
	 strcmp (dxfname, "WIPEOUT") == 0)

  SEC (CLASSES);

  for (i = 0; i < dwg->num_classes; i++)
    {
      REC (CLASS);
      VAL (1, dwg->dwg_class[i].dxfname);
      VAL (2, dwg->dwg_class[i].cppname);
      VAL (3, dwg->dwg_class[i].appname);
      VAL (90, dwg->dwg_class[i].version);
      VAL (280, dwg->dwg_class[i].wasazombie);
      VAL (281, CLASS_IS_ENTITY (dwg->dwg_class[i].dxfname));
    }

  ENDSEC ();
}

void
dxf_table_vport_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_VPORT_CONTROL *ngr;
  Dwg_Nongraph_VPORT *rec;

  idx = dwg_handle_get_index (dwg->variable.VPORT_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.VPORT_CONTROL;

  TAB (VPORT);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->vports[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->vports[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("VPORT Handle %X: not found!\n", ngr->vports[i].value);
	  continue;
	}
      rec = &dwg->object[idx].as.nongraph.as.VPORT;
      checked_obj[idx] = 1;
      REC (VPORT);
      VAL (5, ngr->vports[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbViewportTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4));
      VAL_2D (10, 20, rec->lower_left);
      VAL_2D (11, 21, rec->upper_right);
      VAL_2D (12, 22, rec->view_center);
      VAL_2D (13, 23, rec->snap_base);
      VAL_2D (14, 24, rec->snap_spacing);
      VAL_2D (15, 25, rec->grid_spacing);
      VAL_3D (16, 26, 36, rec->view_dir);
      VAL_3D (17, 27, 37, rec->view_target);
      VAL_1D (40, rec->view_height);
      VAL_1D (41, rec->aspect_ratio);
      VAL_1D (42, rec->lens_length);
      VAL_1D (43, rec->front_clip);
      VAL_1D (44, rec->back_clip);
      VAL_1D (50, rec->snap_rot);
      VAL_1D (51, rec->view_twist);
      VAL (71, rec->view_mode);
      VAL (72, rec->circle_zoom);
      VAL (73, rec->fast_zoom);
      VAL (74, rec->UCSICON_0 | (rec->UCSICON_1 << 1));
      VAL (75, rec->snap_on_off);
      VAL (76, rec->grid_on_off);
      VAL (77, rec->snap_style);
      VAL (78, rec->snap_isopair);
      VAL (281, rec->render_mode);
      VAL (65, rec->UCSFOLLOW);
      VAL_3D (110, 120, 130, rec->ucs_origin);
      VAL_3D (111, 121, 131, rec->ucs_x_axis);
      VAL_3D (112, 122, 132, rec->ucs_y_axis);
      VAL (79, rec->ucs_orthografic_type);
      VAL_1D (146, rec->ucs_elevation);
      VAL (345, rec->named_ucs_handle.value);
      VAL (346, rec->base_ucs_handle.value);
    }
  ENDTAB ();
}

void
dxf_table_ltype_write (Dwg_Struct * dwg)
{
  int16_t i, j;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_LTYPE_CONTROL *ngr;
  Dwg_Nongraph_LTYPE *rec;

  idx = dwg_handle_get_index (dwg->variable.LINETYPE_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.LTYPE_CONTROL;

  TAB (LTYPE);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->linetypes[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->linetypes[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("LTYPE Handle %X: not found!\n", ngr->linetypes[i].value);
	  continue;
	}
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.LTYPE;
      REC (LTYPE);
      VAL (5, ngr->linetypes[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbLinetypeTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4));
      VAL (3, rec->description);
      VAL (72, rec->alignment);
      VAL (73, rec->num_dashes);
      VAL_1D (40, rec->pattern_len);
      for (j = 0; j < rec->num_dashes; j++)
	{
	  VAL_1D (49, rec->dash[j].length);
	  VAL (74, rec->dash[j].complex_shapecode);
	  if (rec->dash[j].complex_shapecode > 0)
	    {
	      VAL (75, rec->dash[j].shape_flag);	// shape number.
	      VAL (340, rec->shapefiles[j].value);	// pointer to STYLE.
	    }
	  if (rec->dash[j].scale != 1.0)
	    {
	      VAL_1D (46, rec->dash[j].scale);
	    }
	  if (rec->dash[j].rotation != 0)
	    {
	      VAL_1D (50, rec->dash[j].rotation);
	    }
	  if (rec->dash[j].x_offset != 0)
	    {
	      VAL_1D (44, rec->dash[j].x_offset);
	    }
	  if (rec->dash[j].y_offset != 0)
	    {
	      VAL_1D (45, rec->dash[j].y_offset);
	    }
	  //VAL (9, rec->strings_area);	// FIXME: one string per dash-element!
	}
    }
  ENDTAB ();
}

void
dxf_table_layer_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  uint32_t idx2;
  uint32_t vcount;
  Dwg_Object *obj;
  Dwg_Nongraph_LAYER_CONTROL *ngr;
  Dwg_Nongraph_LAYER *rec;

  idx = dwg_handle_get_index (dwg->variable.LAYER_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.LAYER_CONTROL;

  TAB (LAYER);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->layers[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->layers[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("LAYER Handle %X: not found!\n", ngr->layers[i].value);
	  continue;
	}
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.LAYER;
      REC (LAYER);
      VAL (5, ngr->layers[i].value);
      if (dwg->object[idx].xdic_missing_flag == 0)
        {
          idx2 = dwg_handle_get_index (dwg->object[idx].xdicobjhandle.value);
          if (idx2 < dwg->num_objects)
            {
              VAL (102, "{ACAD_XDICTIONARY");
              VAL (360, dwg->object[idx].xdicobjhandle.value);
              VAL (102, "}");
            }
        }
      if (dwg->object[idx].num_reactors > 0)
        {
          VAL (102, "{ACAD_REACTORS");
          for (vcount = 0; vcount < dwg->object[idx].num_reactors; vcount++)
            {
              VAL (330, dwg->object[idx].reactors[vcount].value);
            }
          VAL (102, "}");
        }
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbLayerTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4));
      VAL (62, rec->color.index);
      idx = dwg_handle_get_index (rec->linetype.value);
      if (idx >= dwg->num_objects)
	{
	  VAL (6, dwg->object[idx].as.nongraph.as.LTYPE.entry_name);
	}
      else
	{
	  VAL (6, "Continuous");
	}
      VAL (370, rec->values);
      VAL (390, rec->plotstyle.value);
    }

  ENDTAB ();
}

void
dxf_table_style_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_SHAPEFILE_CONTROL *ngr;
  Dwg_Nongraph_SHAPEFILE *rec;

  idx = dwg_handle_get_index (dwg->variable.STYLE_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.SHAPEFILE_CONTROL;

  TAB (STYLE);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->shapefiles[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->shapefiles[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("STYLE (shapefile) Handle %X: not found!\n", ngr->shapefiles[i].value);
	  continue;
        }
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.SHAPEFILE;
      REC (STYLE);
      VAL (5, ngr->shapefiles[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbTextStyleTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4) | (rec->vertical << 2) | rec->shape_file);
      VAL_1D (40, rec->fixed_height);
      VAL_1D (41, rec->width_factor);
      VAL_1D (50, rec->oblique_ang);
      VAL (71, rec->generation);
      VAL_1D (42, rec->last_height);
      VAL (3, rec->font_name);
      VAL (4, rec->bigfont_name);
    }
  ENDTAB ();
}

void
dxf_table_view_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_VIEW_CONTROL *ngr;
  Dwg_Nongraph_VIEW *rec;

  idx = dwg_handle_get_index (dwg->variable.VIEW_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.VIEW_CONTROL;

  TAB (VIEW);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->views[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->views[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("VIEW Handle %X: not found!\n", ngr->views[i].value);
	  continue;
        }
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.VIEW;
      REC (VIEW);
      VAL (5, ngr->views[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbViewTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4) | rec->pspace_flag);
      VAL_1D (40, rec->height);
      VAL_2D (10, 20, rec->center);
      VAL_1D (41, rec->width);
      VAL_3D (11, 21, 31, rec->direction);
      VAL_3D (12, 22, 32, rec->target);
      VAL_1D (42, rec->lens_legth);
      VAL_1D (43, rec->front_clip);
      VAL_1D (44, rec->back_clip);
      VAL_1D (50, rec->twist_angle);
      VAL (71, rec->view_mode);
      VAL (281, rec->render_mode);
      VAL (72, rec->associated_ucs);
      if (rec->associated_ucs)
	{
	  VAL_3D (110, 120, 130, rec->origin);
	  VAL_3D (111, 121, 131, rec->x_direction);
	  VAL_3D (112, 122, 132, rec->y_direction);
	  VAL (79, rec->orthographic_view_type);
	  VAL_1D (146, rec->elevation);
	  VAL (345, rec->named_ucs_handle);
	  VAL (346, rec->base_ucs_handle);
	}
    }
  ENDTAB ();
}

void
dxf_table_ucs_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_UCS_CONTROL *ngr;
  Dwg_Nongraph_UCS *rec;

  idx = dwg_handle_get_index (dwg->variable.UCS_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.UCS_CONTROL;

  TAB (UCS);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->ucs[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->ucs[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("UCS Handle %X: not found!\n", ngr->ucs[i].value);
	  continue;
        }
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.UCS;
      REC (UCS);
      VAL (5, ngr->ucs[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbUCSTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4));
      VAL_3D (10, 20, 30, rec->origin);
      VAL_3D (11, 21, 31, rec->x_direction);
      VAL_3D (12, 22, 32, rec->y_direction);
      VAL (79, rec->orthographic_view_type);
      VAL (346, rec->base_ucs_handle);
      /* Optional, and unknown...
         BITCODE_BS orthographic_type;
         BITCODE_H unknown;
       */
    }

  ENDTAB ();
}

void
dxf_table_appid_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_APPID_CONTROL *ngr;
  Dwg_Nongraph_APPID *rec;

  idx = dwg_handle_get_index (dwg->variable.APPID_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.APPID_CONTROL;

  TAB (APPID);
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->apps[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->apps[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("APPID Handle %X: not found!\n", ngr->apps[i].value);
	  continue;
        }
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.APPID;
      REC (APPID);
      VAL (5, ngr->apps[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbRegAppTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4));
    }

  ENDTAB ();
}

void
dxf_table_dimstyle_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_DIMSTYLE_CONTROL *ngr;
  Dwg_Nongraph_DIMSTYLE *rec;

  idx = dwg_handle_get_index (dwg->variable.DIMSTYLE_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.DIMSTYLE_CONTROL;

  TAB (DIMSTYLE);
  VAL (100, "AcDbDimStyleTable");
  VAL (71, ngr->unknown_byte);
  VAL (340, 0); //FIXME unknown handle here
  for (i = 0; i < ngr->num_entries; i++)
    {
      if (ngr->dimstyles[i].value == 0)
        continue;
      idx = dwg_handle_get_index (ngr->dimstyles[i].value);
      if (idx >= dwg->num_objects)
        {
          printf ("DIMSTYLE Handle %X: not found!\n", ngr->dimstyles[i].value);
	  continue;
        }
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.DIMSTYLE;
      REC (DIMSTYLE);
      VAL (105, ngr->dimstyles[i].value);	/* Only DIMSTYLE has group-code 105 instead of 5 here */
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbDimStyleTableRecord");
      VAL (2, rec->entry_name);
      VAL (70, (rec->xrefdep << 4));
      if (rec->DIMPOST[0])
	{
	  VAL (3, rec->DIMPOST);
	}
      if (rec->DIMAPOST[0])
	{
	  VAL (4, rec->DIMAPOST);
	}
      VAL_1D (40, rec->DIMSCALE);
      VAL_1D (41, rec->DIMASZ);
      VAL_1D (42, rec->DIMEXO);
      VAL_1D (43, rec->DIMDLI);
      VAL_1D (44, rec->DIMEXE);
      VAL_1D (45, rec->DIMRND);
      VAL_1D (46, rec->DIMDLE);
      VAL_1D (47, rec->DIMTP);
      VAL_1D (48, rec->DIMTM);
      VAL_1D (140, rec->DIMTXT);
      VAL_1D (141, rec->DIMCEN);
      VAL_1D (142, rec->DIMTSZ);
      VAL_1D (143, rec->DIMALTF);
      VAL_1D (144, rec->DIMLFAC);
      VAL_1D (145, rec->DIMTVP);
      VAL_1D (146, rec->DIMTFAC);
      VAL_1D (147, rec->DIMGAP);
      VAL_1D (148, rec->DIMALTRND);
      VAL (71, rec->DIMTOL);
      VAL (72, rec->DIMLIM);
      VAL (73, rec->DIMTIH);
      VAL (74, rec->DIMTOH);
      VAL (75, rec->DIMSE1);
      VAL (76, rec->DIMSE2);
      VAL (77, rec->DIMTAD);
      VAL (78, rec->DIMZIN);
      VAL (79, rec->DIMAZIN);
      VAL (170, rec->DIMALT);
      VAL (171, rec->DIMALTD);
      VAL (172, rec->DIMTOFL);
      VAL (173, rec->DIMSAH);
      VAL (174, rec->DIMTIX);
      VAL (175, rec->DIMSOXD);
      VAL (176, rec->DIMCLRD.index);
      VAL (177, rec->DIMCLRE.index);
      VAL (178, rec->DIMCLRT.index);
      VAL (179, rec->DIMADEC);
      VAL (271, rec->DIMDEC);
      VAL (272, rec->DIMTDEC);
      VAL (273, rec->DIMALTU);
      VAL (274, rec->DIMALTTD);
      VAL (275, rec->DIMAUNIT);
      VAL (276, rec->DIMFRAC);
      VAL (277, rec->DIMLUNIT);
      VAL (278, rec->DIMDSEP);
      VAL (279, rec->DIMTMOVE);
      VAL (280, rec->DIMJUST);
      VAL (281, rec->DIMSD1);
      VAL (282, rec->DIMSD2);
      VAL (283, rec->DIMTOLJ);
      VAL (284, rec->DIMTZIN);
      VAL (285, rec->DIMMALTZ);
      VAL (286, rec->DIMMALTTZ);
      VAL (288, rec->DIMUPT);
      VAL (340, rec->DIMTXSTY);
      VAL (341, rec->DIMLDRBLK);
      VAL (342, rec->DIMBLK);
      VAL (343, rec->DIMBLK1);
      VAL (344, rec->DIMBLK2);
      VAL (371, (int16_t) rec->DIMLWD);
      VAL (372, (int16_t) rec->DIMLWE);
    }
  ENDTAB ();
}

void
dxf_table_block_record_write (Dwg_Struct * dwg)
{
  int16_t i;
  uint32_t idx;
  Dwg_Object *obj;
  Dwg_Nongraph_BLOCK_CONTROL *ngr;
  Dwg_Nongraph_BLOCK_HEADER *rec;

  idx = dwg_handle_get_index (dwg->variable.BLOCK_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    return;
  checked_obj[idx] = 1;

  obj = &dwg->object[idx];
  ngr = &obj->as.nongraph.as.BLOCK_CONTROL;

  TAB (BLOCK_RECORD);

  /* Model-space block */
  idx = dwg_handle_get_index (ngr->model_space.value);
  if (idx < dwg->num_objects)
    {
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.BLOCK_HEADER;
      REC (BLOCK_RECORD);
      VAL (5, ngr->model_space.value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbBlockTableRecord");
      VAL (2, rec->entry_name);
      VAL (340, rec->layout_handle);
    }

  /* Paper-space block */
  idx = dwg_handle_get_index (ngr->paper_space.value);
  if (idx < dwg->num_objects)
    {
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.BLOCK_HEADER;
      REC (BLOCK_RECORD);
      VAL (5, ngr->paper_space.value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbBlockTableRecord");
      VAL (2, rec->entry_name);
      VAL (340, rec->layout_handle);
    }

  for (i = 0; i < ngr->num_entries; i++)
    {
      idx = dwg_handle_get_index (ngr->block_headers[i].value);
      if (idx >= dwg->num_objects)
	continue;
      checked_obj[idx] = 1;
      rec = &dwg->object[idx].as.nongraph.as.BLOCK_HEADER;
      REC (BLOCK_RECORD);
      VAL (5, ngr->block_headers[i].value);
      VAL (330, obj->handle.value);
      VAL (100, "AcDbSymbolTableRecord");

      VAL (100, "AcDbBlockTableRecord");
      VAL (2, rec->entry_name);
      VAL (340, rec->layout_handle);
    }
  ENDTAB ();
}

/* TABLES section
 */
void
dxf_tables_write (Dwg_Struct * dwg)
{
  int32_t idx;
  Dwg_Object *obj;

  SEC (TABLES);

  dxf_table_vport_write (dwg);
  dxf_table_ltype_write (dwg);
  dxf_table_layer_write (dwg);
  dxf_table_style_write (dwg);
  dxf_table_view_write (dwg);
  dxf_table_ucs_write (dwg);
  dxf_table_appid_write (dwg);
  dxf_table_dimstyle_write (dwg);
  dxf_table_block_record_write (dwg);

  ENDSEC ();
}

void
dxf_nongraph_common (Dwg_Object * obj)
{
  uint32_t idx;
  uint32_t vcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Object_Nongraph *ngr = &obj->as.nongraph;

  VAL (5, obj->handle.value);
  if (obj->xdic_missing_flag == 0)
    {
      idx = dwg_handle_get_index (obj->xdicobjhandle.value);
      if (idx < dwg->num_objects)
        {
          VAL (102, "{ACAD_XDICTIONARY");
          VAL (360, obj->xdicobjhandle.value);
          VAL (102, "}");
        }
    }
  if (obj->num_reactors > 0)
    {
      VAL (102, "{ACAD_REACTORS");
      for (vcount = 0; vcount < obj->num_reactors; vcount++)
        {
          VAL (330, obj->reactors[vcount].value);
        }
      VAL (102, "}");
    }
  VAL (330, dwg_handle_absolute (&ngr->parenthandle, obj->handle.value));
}

void
dxf_entity_common (Dwg_Object * obj)
{
  uint32_t idx;
  uint32_t rcount;
  Dwg_Struct *dwg = obj->parent;
  Dwg_Object_Entity *ent = &obj->as.entity;

  VAL (5, obj->handle.value);
  if (obj->xdic_missing_flag == 0)
    {
      idx = dwg_handle_get_index (obj->xdicobjhandle.value);
      if (idx < dwg->num_objects)
        {
          VAL (102, "{ACAD_XDICTIONARY");
          VAL (360, obj->xdicobjhandle.value);
          VAL (102, "}");
        }
    }
  if (obj->num_reactors > 0)
    {
      VAL (102, "{ACAD_REACTORS");
      for (rcount = 0; rcount < obj->num_reactors; rcount++)
        {
	  VAL (330, obj->reactors[rcount].value);
        }
      VAL (102, "}");
    }
  if (ent->entity_mode == 0)
    {
      VAL (330, dwg_handle_absolute (&ent->subentity, obj->handle.value));
    }
  else
    {
      VAL (330, 0); //TODO find more options to obtain owner handles for modelspace and paperspace
    }
  VAL (100, "AcDbEntity");

  idx = dwg_handle_get_index (ent->layer.value);
  if (idx < dwg->num_objects)
    {
      VAL (8, dwg->object[idx].as.nongraph.as.LAYER.entry_name);
    }
  else
    {
      VAL (8, "0");
    }

  if (ent->linetype_flags == 1)
    {
      VAL (6, "ByBlock");
    }
  else if (ent->linetype_flags == 2)
    {
      VAL (6, "Continuous");
    }
  else if (ent->linetype_flags == 3)
    {
      idx = dwg_handle_get_index (ent->ltype.value);
      if (idx < dwg->num_objects)
	{
	  VAL (6, dwg->object[idx].as.nongraph.as.LTYPE.entry_name);
	}
    }

  if (ent->color.index != 256)
    {
      VAL (62, ent->color.index);
    }

  if (ent->linetype_scale != 1.0)
    {
      VAL (48, ent->linetype_scale);
    }

  if (ent->invisible)
    {
      VAL (60, 1);
    }
}

/* dxf_object functions: ordinary objects */
#include "dxf_object.c"

void
dxf_object_write (Dwg_Object * obj)
{
  int32_t i;
  Dwg_Struct *dwg;

  dwg = obj->parent;
  switch (obj->type)
    {
      OBJECT_CASE_SET (dxf_);
    default:
      i = obj->type - 500;
      if (i >= dwg->num_classes || i < 0)
	return;
      OBJECT_VARTYPE_ELSEIF_SET (dxf_);
    }
}

/* BLOCKS section
 */
void
dxf_blocks_write (Dwg_Struct * dwg)
{
  int32_t i;
  uint32_t idx;
  uint32_t idx2;
  uint32_t hdl;
  Dwg_Object *obj;
  Dwg_Nongraph_BLOCK_HEADER *blk;
  Dwg_Nongraph_BLOCK_CONTROL *ktl;

  SEC (BLOCKS);

  idx = dwg_handle_get_index (dwg->variable.BLOCK_CONTROL_OBJECT.value);
  if (idx >= dwg->num_objects)
    {
      puts ("WARN: no blocks found.");
      ENDSEC ();
      return;
    }
  ktl = &dwg->object[idx].as.nongraph.as.BLOCK_CONTROL;

  /* First block: empty Model_Space
   */
  blk = NULL;
  idx = dwg_handle_get_index (ktl->model_space.value);
  if (idx < dwg->num_objects)
    {
      obj = &dwg->object[idx];
      if (obj->type == DWG_TYPE_BLOCK_HEADER)
	if (strcmp ("*Model_Space",
	     obj->as.nongraph.as.BLOCK_HEADER.entry_name) == 0)
	  {
	    blk = &obj->as.nongraph.as.BLOCK_HEADER;
            checked_obj[idx] = 1;
            REC_BLOCK (0);
            REC_ENDBLK (0);
	  }
    }
  if (blk == NULL)
      puts ("WARN: no *Model_Space block found.");

  /* Second block: empty Paper_Space
   */
  blk = NULL;
  idx = dwg_handle_get_index (ktl->paper_space.value);
  if (idx < dwg->num_objects)
    {
      obj = &dwg->object[idx];
      if (obj->type == DWG_TYPE_BLOCK_HEADER)
	if (strcmp ("*Paper_Space",
	     obj->as.nongraph.as.BLOCK_HEADER.entry_name) == 0)
	  {
	    blk = &obj->as.nongraph.as.BLOCK_HEADER;
            checked_obj[idx] = 1;
            REC_BLOCK (1);
            REC_ENDBLK (1);
	  }
    }
  if (blk == NULL)
      puts ("WARN: no *Paper_Space block found.");

  /* Other blocks */
  for (i = 0; i < ktl->num_entries; i++)
    {
      idx = dwg_handle_get_index (ktl->block_headers[i].value);
      if (idx >= dwg->num_objects)
	continue;
      obj = &dwg->object[idx];
      blk = &obj->as.nongraph.as.BLOCK_HEADER;
      REC_BLOCK (0);
      if (blk->first_entity.value <= blk->last_entity.value)
	{
	  for (hdl = blk->first_entity.value; hdl <= blk->last_entity.value; hdl++)
	    {
	      Dwg_Object * subo;
	      idx = dwg_handle_get_index (hdl);
	      if (idx >= dwg->num_objects)
		continue;
	      subo = &dwg->object[idx];
	      if (subo->supertype != DWG_SUPERTYPE_ENTITY)
		continue;
	      if (obj->handle.value != dwg_handle_absolute (&subo->as.entity.subentity, subo->handle.value) )
		continue;
              checked_obj[idx] = 1;
	      dxf_object_write (subo);
	    }
	}
      REC_ENDBLK (0);
    }
  ENDSEC ();
}

/* ENTITIES section
 */
void
dxf_entities_write (Dwg_Struct * dwg)
{
  uint32_t idx;
  uint32_t subhd;
  Dwg_Object *obj;

  SEC (ENTITIES);
  for (idx = 0; idx < dwg->num_objects; idx++)
    {

      obj = &dwg->object[idx];
      if (obj->supertype != DWG_SUPERTYPE_ENTITY)
        continue;
      if (obj->type == DWG_TYPE_ENDBLK)
        continue;
      if (checked_obj[idx])
        continue;
      subhd = dwg_handle_absolute (&obj->as.entity.subentity, obj->handle.value);
      if (obj->as.entity.entity_mode == 0 && dwg_handle_get_index (subhd) >= dwg->num_objects)
        continue;
      checked_obj[idx] = 1;
      dxf_object_write (obj);
    }
  ENDSEC ();
}

/* OBJECTS section
 */
void
dxf_nongraphs_write (Dwg_Struct * dwg)
{
  uint32_t idx;
  Dwg_Object *obj;

  SEC (OBJECTS);
  /* Dictionaries first */
  for (idx = 0; idx < dwg->num_objects; idx++)
    {
      obj = &dwg->object[idx];
      if (obj->supertype != DWG_SUPERTYPE_NONGRAPH)
        continue;
      if (obj->type != DWG_TYPE_DICTIONARY)
        continue;
      if (checked_obj[idx])
        continue;
      checked_obj[idx] = 1;
      dxf_object_write (obj);
    }
  /* Others after */
  for (idx = 0; idx < dwg->num_objects; idx++)
    {
      obj = &dwg->object[idx];
      if (obj->supertype != DWG_SUPERTYPE_NONGRAPH)
        continue;
      if (checked_obj[idx])
        continue;
      checked_obj[idx] = 1;
      dxf_object_write (obj);
    }
  ENDSEC ();
}

char *
dxf_format_s (int gcode)
{
  if (0 <= gcode && gcode < 5)
    return "%s";
  if (gcode == 5)
    return "%X";
  if (5 < gcode && gcode < 10)
    return "%s";
  if (gcode < 60)
    return (GFORMAT);
  if (gcode < 80)
    return "%6i";
  if (89 < gcode && gcode < 100)
    return "%9li";
  if (gcode == 100)
    return "%s";
  if (gcode == 102)
    return "%s";
  if (gcode == 105)
    return "%X";
  if (105 < gcode && gcode < 148)
    return (GFORMAT);
  if (169 < gcode && gcode < 180)
    return "%6i";
  if (269 < gcode && gcode < 300)
    return "%6i";
  if (299 < gcode && gcode < 320)
    return "%s";
  if (319 < gcode && gcode < 370)
    return "%X";
  if (369 < gcode && gcode < 390)
    return "%6i";
  if (389 < gcode && gcode < 400)
    return "%X";
  if (399 < gcode && gcode < 410)
    return "%6i";
  if (409 < gcode && gcode < 420)
    return "%s";
  if (gcode == 999)
    return "%s";
  if (999 < gcode && gcode < 1010)
    return "%s";
  if (1009 < gcode && gcode < 1060)
    return (GFORMAT);
  if (1059 < gcode && gcode < 1071)
    return "%6i";
  if (gcode == 1071)
    return "%9li";

  return "(unknown gcode)";	//XXX if not known group-code, return something to cause an error.
}
