/*****************************************************************************/
/*  LibDWG - free implementation of the DWG file format                      */
/*                                                                           */
/*  Copyright (C) 2009 Free Software Foundation, Inc.                        */
/*  Copyright (C) 2010 Thien-Thi Nguyen                                      */
/*  Copyright (C) 2013 Felipe Castro                                         */
/*                                                                           */
/*  This library is free software, licensed under the terms of the GNU       */
/*  General Public License as published by the Free Software Foundation,     */
/*  either version 3 of the License, or (at your option) any later version.  */
/*  You should have received a copy of the GNU General Public License        */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.    */
/*****************************************************************************/

/*
 * dwg-preview.c: get the bmp and wmf thumbnails of a dwg file
 * written by Felipe Castro
 * modified by Felipe Corrêa da Silva Sances
 * modified by Thien-Thi Nguyen
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include <dwg.h>

int
write_bmp (char *filename)
{
  char *outfile;
  int i, j;
  int fail;
  long size;
  long bmadr;
  size_t retval;
  FILE *fh;
  Bit_Chain dat;

  /* Read dwg data */
  fail = dwg_read_file_preview (filename, &dat);
  if (fail)
    {
      puts ("Failed to get a preview image.");
      return fail;
    }

  /* Show header bytes
   */
  puts ("Header data (80 bytes)");
  puts ("-----------");
  for (i = 0; i < 8; i++)
    {
      printf ("[%02d] ", i * 10);
      for (j = 0; j < 10; j++)
	{
	  printf ("%02X ", dat.chain[dat.byte + i * 10 + j]);
	}
      puts ("");
    }
  puts ("-----------");

  /* By-pass header data (just nulls?)
   */
  dat.byte += 80;
  bmadr = dat.byte;

  printf ("Bitmap data (%lu bytes), ASCII art.\n", dat.size - dat.byte);
  puts ("-----------");
  /* Kind of ASCII art...
   */
  for (i = 0; dat.byte < dat.size; dat.byte++, i++)
    {
      if (1 * 32 > dat.chain[dat.byte])
	printf (" ");
      else if (2 * 32 > dat.chain[dat.byte])
	printf (".");
      else if (3 * 32 > dat.chain[dat.byte])
	printf (":");
      else if (4 * 32 > dat.chain[dat.byte])
	printf ("+");
      else if (5 * 32 > dat.chain[dat.byte])
	printf ("o");
      else if (6 * 32 > dat.chain[dat.byte])
	printf ("O");
      else if (7 * 32 > dat.chain[dat.byte])
	printf ("0");
      else
	printf ("#");

      if (i % 120 == 0)
	puts ("");
    }
  puts ("\n-----------");

  dat.byte = bmadr;

  /* Make output filename and open for writing
   */
  size = strlen (filename);
  if (size < 5)
    size = 5;
  outfile = (char *) malloc (size);
  if (size == 5)
    strcpy (outfile, "a.bmp");
  else
    {
      strcpy (outfile, filename);
      strcpy (outfile + size - 4, ".bmp");
    }
  fh = fopen (outfile, "w");
  if (!fh)
    {
      printf ("Unable to write to file '%s'\n", outfile);
      free (outfile);
      return -1;
    }

  /* Write DIB bitmap data to file !!! OLD CODE !!!
     struct _BITMAP_HEADER
     {
     char magic[2];
     long file_size;
     long reserved;
     long offset;
     } bmp_h;
   */
  /* Write bmp file header
     bmp_h.magic[0] = 'B';
     bmp_h.magic[1] = 'M';
     bmp_h.file_size = 14 + size; // file header + DIB data
     bmp_h.reserved = 0;
     bmp_h.offset = 14 + 40 + 4 * 256; // file header + DIB header + color table
     retval = fwrite(&bmp_h.magic[0], 2, sizeof(char), fh);
     retval = fwrite(&bmp_h.file_size, 3, sizeof(long), fh);

     // Write data (DIB header + bitmap)
     retval = fwrite(data, 1, size, fh);
   */

  /* Write it, without changes.
   */
  retval = fwrite (dat.chain + dat.byte, dat.size - dat.byte, 1, fh);
  fclose (fh);

  if (retval > 0)
    printf ("Success! See the file '%s'\n", outfile);
  else
    printf ("Fail! Written 0 bytes on '%s'.\n", outfile);

  free (outfile);
  return 0;
}

int
main (int argc, char *argv[])
{
  char * fn;

  /* Test for one argument */
  if (argc < 2)
    {
      puts ("Need 1 filename argument");
      return -1;
    }

  /* Test for .dwg */
  fn = strrchr (argv[1], '.');
  if (fn == NULL)
    {
      printf ("The input file extension should be .dwg\n");
      return -1;
    }
  if (tolower (fn[1]) != 'd' || tolower (fn[2]) != 'w' || tolower (fn[3]) != 'g')
    {
      printf ("The input file extension should be like .dwg\n");
      return -1;
    }

  write_bmp (argv[1]);
  return 0;
}
