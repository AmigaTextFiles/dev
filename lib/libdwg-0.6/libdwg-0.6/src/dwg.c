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
 *     \file       dwg.c
 *     \brief      Base DWG functions
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Anderson Pierre Cardoso
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/stat.h>
//#include <mcheck.h>
#include "config.h"

#include "bits.h"
#include "decode.h"
#include "object.h"
#include "logging.h"

/** DWG version codes */
char version_codes[9][7] = {
  "------",
  "AC1012",
  "AC1014",
  "AC1015",
  "AC1018",
  "AC1021",
  "AC1024",
  "AC1027",
  "------"
};

/* Forward functions
 */
FILE * dwg_load_file (char *filename, Bit_Chain * dat);
void dwg_handle_close (void);

/** Reads a dwg file and decodes its data, filling the dwg_data structure
 * with the information available for classes, variables and objects.
 * Returns a fail status (0 == OK; -1 == FAIL).
 */
int
dwg_read_file (char *filename, Dwg_Struct * dwg_data)
{
  Bit_Chain bit_chain;

  if (dwg_load_file (filename, &bit_chain))
    return (-1);

  /* Decode the dwg structure
   */
  if (dwg_decode_data (&bit_chain, dwg_data))
    {
      LOG_ERROR ("Failed to decode DWG data.\n");
      free (bit_chain.chain);
      bit_chain.chain = NULL;
      return (-1);
    }
  free (bit_chain.chain);

  /* Step II of objects parsing: handle index
   */
  dwg_handle_init (dwg_data);

  return (0);
}

/** Gets the preview bitmap image of a dwg file. The raw bitmap data is
 * put in a bit-chain, whose dat.byte locator is set to the start of this
 * data. Returns a fail status (0 == OK; -1 == FAIL).
 */
int
dwg_read_file_preview (char *filename, Bit_Chain * dat)
{
  int i;
  FILE * fp;
  char tmp[1024];
  int8_t num_pictures;
  int8_t *picture;
  int8_t code;
  int32_t address;
  int32_t size;
  int32_t header_size;
  Bit_Chain picdat;
  
  /* Open file */
  fp = dwg_load_file (filename, NULL);
  if (!fp)
  {
    LOG_ERROR ("Unable to open the file.\n");
    return (-1);
  }

  /* Image seeker */
  fseek (fp, 0x0D, SEEK_SET);
  fread (&address, sizeof (int32_t), 1, fp);
  snprintf (tmp, 1024, "Image seeker: 0x%X (+16)\n", address);
  LOG_TRACE (tmp);

  /* Load image data */
  fseek (fp, address + 16, SEEK_SET);
  fread (&dat->size, sizeof (int8_t), 4, fp);
  dat->chain = (char *) calloc (dat->size, sizeof (int8_t));
  fread (dat->chain, sizeof (int8_t), dat->size, fp);
  dat->byte = dat->bit = 0;
  snprintf (tmp, 1024, "Overall image size: %li\n", (signed) dat->size);
  LOG_TRACE (tmp);

  /* Decode */
  num_pictures = bit_read_RC (dat);
  snprintf (tmp, 1024, "Num. codes: %i \n", num_pictures);
  LOG_TRACE (tmp);
  code = 1;
  size = 0;
  header_size = 0;
  for (i = 0; i < num_pictures; i++)
    {
      code = bit_read_RC (dat);
      snprintf (tmp, 1024, "\t[%i] Code: %i \n", i, code);
      LOG_TRACE (tmp);

      address = bit_read_RL (dat);
      snprintf (tmp, 1024, "\t\tAdress: 0x%X \n", address);
      LOG_TRACE (tmp);

      size = bit_read_RL (dat);
      if (code == 1)
      {
	  snprintf (tmp, 1024, "\t\tHeader size: %li\n", size);
          if (size > 0)
            header_size = size;
      }
      else if (code == 2)
	  snprintf (tmp, 1024, "\t\tBMP size: %li\n", size);
      else if (code == 3)
	  snprintf (tmp, 1024, "\t\tWMF size: %li\n", size);
      else
	  snprintf (tmp, 1024, "\t\tRaw Size: %li\n", size);
      LOG_TRACE (tmp);
    }
  snprintf (tmp, 1024, "Current adress: 0x%X ==> 0x%X\n", dat->byte, dat->size);
  LOG_TRACE (tmp);

  if (code == 2)
    return 0;
  else
  {
    LOG_ERROR ("No preview BMP image found.\n");
    return -1;
  }
}

/** 
 * Frees the internal strings allocated for each item inside all objects present
 * in a dwg structure. The dwg structure itself is left intact, the user is 
 * supposed to free it (dynamically allocated) or not (statically declared).
 * Side effects: dwg.num_classes and dwg.num_objects are set to 0.
 */
void
dwg_free (Dwg_Struct * dwg)
{
  uint32_t i;

  if (dwg == NULL)
    return;

  /* Objects (order matters here)
   */
  for (i = 0; i < dwg->num_objects; i++)
    {
      if (&dwg->object[i])
        dwg_object_free (&dwg->object[i]);
    }
  if (dwg->object)
    free (dwg->object);
  dwg->object = NULL;
  dwg->num_objects = 0;
  dwg_objects_reset ();

  /* Internal object handle map
   */
  dwg_handle_close ();

  /* Variables
   */
  dwg_variables_free (dwg);

  /* Classes
   */
  for (i = 0; i < dwg->num_classes; i++)
    {
      if (dwg->dwg_class[i].appname)
        free (dwg->dwg_class[i].appname);
      if (dwg->dwg_class[i].cppname)
        free (dwg->dwg_class[i].cppname);
      if (dwg->dwg_class[i].dxfname)
        free (dwg->dwg_class[i].dxfname);
    }
  if (dwg->dwg_class)
    free (dwg->dwg_class);
  dwg->dwg_class = NULL;
  dwg->num_classes = 0;
}

/** 
 * Returns the AutoCAD version code from the enum Dwg_Version_Type.
 */
char *
dwg_version_code_from_id (Dwg_Version_Type id)
{
  return (version_codes[id]);
}

/** 
 * Returns the AutoCAD version code of the dwg data (e.g. AC1015, AC1018, etc).
 */
char *
dwg_version_code (Dwg_Struct * dwg)
{
  if (dwg->header.version > R_BEFORE && dwg->header.version < R_AFTER)
    return (version_codes[dwg->header.version]);
  else
    return ("UNKNOW");
}

/******************
 * Handle functions
 */
typedef struct _handle_map
{
  uint32_t hd;
  uint32_t ix;
} Handle_Map;

static uint32_t hmap_size = 0;
static Handle_Map *hmap = NULL;
static Dwg_Struct *hmap_dwg = NULL;

void
dwg_handle_close ()
{
  if (hmap_size > 0)
    free (hmap);
  hmap_size = 0;
}

/** 
 * Initializes the handle database ordering of dwg data, for searching it.
 */
void
dwg_handle_init (Dwg_Struct * dwg)
{
  uint32_t i;
  int j, y;
  double factor;
  char space[101];
  space[100] = '\0';

  if (dwg == NULL)
    {
      hmap_dwg = NULL;
      return;
    }

  if (dwg->num_objects == 0)
    {
      hmap_dwg = NULL;
      return;
    }

  hmap_dwg = dwg;

  if (hmap_size == 0)
    {
      hmap_size = dwg->num_objects;
      hmap = (Handle_Map *) malloc (hmap_size * sizeof (Handle_Map));
    }
  else if (hmap_size < dwg->num_objects)
    {
      hmap_size = dwg->num_objects;
      hmap = (Handle_Map *) realloc (hmap, hmap_size * sizeof (Handle_Map));
    }

  LOG_PLOT ("\nCollected handles:\n");
  LOG_PLOT
    ("-------------------------------------------------------------------------------------------------------\n");
  factor = (double) dwg->variable.HANDSEED.value / 101.0;
  for (i = 0; i < dwg->num_objects; i++)
    {
      char tmp[1024];
      LOG_PLOT ("|");
      y = (double) dwg->object[i].handle.value / factor;
      if (y > 100)
	y = 100;
      memset (space, ' ', 100);
      space[(int) y] = '\0';
      LOG_PLOT (space);
      LOG_PLOT ("*");
      memset (space, ' ', 100);
      space[100 - (int) y] = '\0';
      LOG_PLOT (space);
      snprintf (tmp, 1024, "| %08X\n", dwg->object[i].handle.value);
      LOG_PLOT (tmp);
    }
  LOG_PLOT
    ("-------------------------------------------------------------------------------------------------------\n");

  /* Insertion sorting
   */
  hmap[0].hd = dwg->object[0].handle.value;
  hmap[0].ix = 0;
  for (i = 1; i < dwg->num_objects; i++)
    {
      uint32_t a, b, mid;
      uint32_t hdtmp, ixtmp;

      hdtmp = dwg->object[i].handle.value;
      ixtmp = i;
      a = 0;
      b = i - 1;
      while (b > a + 1)
	{
	  mid = (b - a) / 2 + a;
	  if (hdtmp < hmap[mid].hd)
	    b = mid;
	  else
	    a = mid;
	}
      if (hdtmp >= hmap[b].hd)
	b++;

      memmove (&hmap[b + 1], &hmap[b], (i - b) * sizeof (Handle_Map));
      hmap[b].hd = hdtmp;
      hmap[b].ix = ixtmp;
    }

  LOG_PLOT ("\nSorted handles:\n");
  LOG_PLOT
    ("-------------------------------------------------------------------------------------------------------\n");
  for (i = 0; i < dwg->num_objects; i++)
    {
      uint32_t idx;
      long delta;
      char tmp[1024];

      idx = hmap[i].ix;

      LOG_PLOT ("|");
      y = (double) dwg->object[idx].handle.value / factor;
      if (y > 100)
	y = 100;
      memset (space, ' ', 100);
      space[(int) y] = '\0';
      LOG_PLOT (space);
      LOG_PLOT ("*");
      memset (space, ' ', 100);
      space[100 - (int) y] = '\0';
      LOG_PLOT (space);
      snprintf (tmp, 1024, "| %08X", dwg->object[idx].handle.value);
      LOG_PLOT (tmp);
      delta = 0;
      if (i > 0)
	delta = dwg->object[idx].handle.value - dwg->object[hmap[i - 1].ix].handle.value;
      snprintf (tmp, 1024, " (+=)%li\n", delta);
      LOG_PLOT (tmp);
      if (delta == 0 && i > 0)
	{
          snprintf (tmp, 1024, "Objects with same handle: obj[%lu].handle == obj[%lu].handle\n",
	     idx, hmap[i - 1].ix);
	  LOG_WARN (tmp);
	}
      else if (delta < 0)
	{
	  LOG_ERROR ("Sorting of objects handles failed.\n");
	}
    }
  LOG_PLOT
    ("-------------------------------------------------------------------------------------------------------\n");
}

/** 
 * Finds the index of an object given it's id (handle)
 */
uint32_t
dwg_handle_get_index (uint32_t hdl)
{
  uint32_t a, b, mid;
  char tmp[1024];

  if (hdl == 0)
    return -1;

  if (hmap_dwg == NULL)
    {
      snprintf (tmp, 1024, "dwg_handle_get_index(0x%X): "
			   "please initialize the handle mapper (dwg_handle_init)\n"
	 		   "\tbefore using any other handle function.\n", hdl);
      LOG_WARN (tmp);
      return (-1);
    }

  /* Binary searching
   */
  a = 0;
  b = hmap_dwg->num_objects - 1;
  while (b > a + 1)
    {
      mid = (b - a) / 2 + a;
      if (hdl < hmap[mid].hd)
	b = mid;
      else if (hdl > hmap[mid].hd)
	a = mid;
      else
	return (hmap[mid].ix);
    }
  if (hdl == hmap[a].hd)
    return (hmap[a].ix);
  if (hdl == hmap[b].hd)
    return (hmap[b].ix);

  snprintf (tmp, 1024, "dwg_handle_get_index(0x%X): handle not found.\n", hdl);
  LOG_TRACE (tmp);
  return (-1);
}

/** 
 * Finds the absolute id of a handle from a referenced one.
 */
uint32_t
dwg_handle_absolute (Dwg_Handle *hd, uint32_t refhd)
{
  if (hd->code < 6)
    return (hd->value);
  else if (hd->code == 6 && hd->size != 0)
    return (hd->value);
  else if (hd->code == 6)
    return (refhd + 1);
  else if (hd->code == 8)
    return (refhd - 1);
  else if (hd->code == 10)
    return (refhd + hd->value);
  else if (hd->code == 12)
    return (refhd - hd->value);

  return 0;
}

extern Error_Fifo err;
/** 
 * Returns an error output by the library operations from a fifo, if any.
 * If none, returns a NULL.
 */
char *
dwg_error_pop ()
{
	static char msg[1024];

	if (err.first != err.last)
	{
		strcpy (msg, err.msg[err.first]);
		if (++err.first >= ERR_FIFO_LEVELS)
			err.first = 0;
		return (msg);
	}

	if (err.msg[err.first][0] == '\0')
	{
		return (NULL);
	}

	strcpy (msg, err.msg[err.first]);
	err.msg[err.first][0] = '\0';
	return (msg);
}


/* Private functions
 */

FILE *
dwg_load_file (char *filename, Bit_Chain * dat)
{
  FILE * fp;
  struct stat attrib;
  size_t size;
  char tmp[1024];

#ifdef ENABLE_TRACE
  log_level_init ();
#endif

  if (stat (filename, &attrib))
    {
      snprintf (tmp, 1024, "File not found: %s \n", filename);
      LOG_ERROR (tmp);
      if (dat)
        return ((FILE *) -1);
      else
        return (NULL);
    }
  if (!S_ISREG (attrib.st_mode))
    {
      snprintf (tmp, 1024, "Not a regular file: %s \n", filename);
      LOG_ERROR (tmp);
    }
  fp = fopen (filename, "rb");
  if (!fp)
    {
      snprintf (tmp, 1024, "Could not open file: %s\n", filename);
      LOG_ERROR (tmp);
      if (dat)
        return ((FILE *) -1);
      else
        return (NULL);
    }

  if (dat == NULL)
    return (fp);

  /* Load file to memory */
  dat->bit = 0;
  dat->byte = 0;
  dat->size = attrib.st_size;
  dat->chain = (uint8_t *) malloc (dat->size);
  if (!dat->chain)
    {
      snprintf (tmp, 1024, "Not enough memory.\n");
      LOG_ERROR (tmp);
      fclose (fp);
      return ((FILE *) -1);
    }
  size = 0;
  size = fread (dat->chain, sizeof (char), dat->size, fp);
  if (size != dat->size)
    {
      snprintf (tmp, 1024, "Could not read the entire file (%lu out of %lu): %s \n",
		 (uint32_t) size, dat->size, filename);
      LOG_ERROR (tmp);
      fclose (fp);
      free (dat->chain);
      return ((FILE *) -1);
    }
  fclose (fp);
  if (size == 0)
    {
      snprintf (tmp, 1024, "No data to read.\n");
      LOG_ERROR (tmp);
      return ((FILE *) -1);
    }

  return (NULL);
}

/* XXX Encoding support is deprecated. */
#ifdef _DEPRECATED_
int
dwg_write_file (char *filename, Dwg_Struct * dwg_data)
{
  FILE *dt;
  struct stat atrib;
  Bit_Chain bit_chain;
  bit_chain.version = (Dwg_Version_Type) dwg_data->header.version;

  /* Encode the DWG struct */
  bit_chain.size = 0;
  if (dwg_encode_chains (dwg_data, &bit_chain))
    {
      LOG_ERROR ("Failed to encode datastructure.\n") if (bit_chain.size > 0);
      free (bit_chain.chain);
      return -1;
    }

  /* try opening the output file in write mode */
  if (!stat (filename, &atrib))
    {
      LOG_ERROR ("The file already exists. We won't overwrite it.");
      return -1;
    }
  dt = fopen (filename, "w");
  if (!dt)
    {
      LOG_ERROR ("Failed to create the file: %s\n", filename);
      return -1;
    }

  /* Write the data into the file */
  if (fwrite (bit_chain.chain, sizeof (char), bit_chain.size, dt) !=
      bit_chain.size)
    {
      LOG_ERROR ("Failed to write data into the file: %s\n", filename);
      fclose (dt);
      free (bit_chain.chain);
      return -1;
    }
  fclose (dt);

  if (bit_chain.size > 0)
    free (bit_chain.chain);

  return 0;
}
#endif
