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

/*
 * test.c: loading DWG files to memory and freeing them
 * written by Felipe Castro
 */

#include <stdio.h>
#include <string.h>

#include "dwg.h"

int
main (int argc, char *argv[])
{
  char *msg;
  int i;
  int error;
  Dwg_Struct dwg_struct;

  /* Allow memory tracing, use the env var "MALLOC_TRACE=yourfile.log" to enable it.
   */
  mtrace ();

  if (argc < 2)
    {
      puts ("Need at least one argument: a dwg filename.");
      return (-1);
    }

  for (i = 1; i < argc; i++)
    {
      error = dwg_read_file (argv[i], &dwg_struct);
      printf ("Read file %s...", argv[i]);
      if (error)
	break;
      dwg_free (&dwg_struct);
      printf (" freed it!\n");
    }

  if (error)
  {
    puts (" FAILED! LibDWG says:");
    for (i = 1; msg = dwg_error_pop (); i++)
    {
	    printf ("%i - %s", i, msg);
    }
  }
  else
    puts("SUCCESS!");

  return (error ? 1 : 0);
}
