/* FoxGUI - The fast, flexible, free Amiga GUI system
	Copyright (C) 2001 Simon Fox (Foxysoft)

This library is free software; you can redistribute it and/ormodify it under the terms of the GNU Lesser General PublicLicense as published by the Free Software Foundation; eitherversion 2.1 of the License, or (at your option) any later version.This library is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNULesser General Public License for more details.You should have received a copy of the GNU Lesser General PublicLicense along with this library; if not, write to the Free SoftwareFoundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
Foxysoft: www.foxysoft.co.uk      Email:simon@foxysoft.co.uk                */


/******************************************************************************
 * Shared library code.  Cannot call functions which use exit() such as:
 * printf(), fprintf()
 *
 * Otherwise:
 * The linker returns "__XCEXIT undefined" and the program will fail.
 * This is because you must not exit() a library!
 *
 * Also:
 * proto/exec.h must be included instead of clib/exec_protos.h and
 * __USE_SYSBASE must be defined.
 *
 * Otherwise:
 * The linker returns "Absolute reference to symbol _SysBase" and the
 * library crashes.  Presumably the same is true for the other protos.
 ******************************************************************************/

#define __USE_SYSBASE

#include <proto/mathieeedoubbas.h>
#include <string.h>
#include <clib/alib_protos.h>
#include <proto/exec.h>

#include "/foxinclude/foxgui.h"

#ifdef NOT_SHARED_LIBRARY
void spc(FILE *outfp, int spaces)
   {
   char tmp[80];
   strcpy(tmp, "                                                                      ");
   tmp[spaces] = '\0';
   fprintf(outfp, "%s",tmp);
   }
#endif

char *RightAlignString(char *str, int lenstr, BOOL commas)
	{
	/* Right align a string of length lenstr (including null terminator).  If commas is TRUE then
		stick in commas every 3 characters as we align it (for numbers). */
	if (str && lenstr)
		{
		str[lenstr - 1] = 0;
		if (strlen(str) < lenstr - 1)
			{
			char *retval;
			// strlen returns an unsigned int so cast it to an int so that if it is 0 length then answer will be -1
			int source = ((int) strlen(str)) - 1, dest = lenstr - 2, placed = 0;

			while (source >= 0)
				{
				if (placed == 3 && commas)
					{
					str[dest--] = ',';
					placed = 0;
					}
				str[dest--] = str[source--];
				placed++;
				}
			retval = &str[dest + 1];
			while (dest >= 0)
				str[dest--] = ' ';
			return retval;
			}
		return str;
		}
	return NULL;
	}

static int SetRandomSeed(void)
   {
   int Rubbish = 0, error = FALSE;
	struct timerequest *TimerIO;
	struct MsgPort *TimerMP;
   if (TimerMP = (struct MsgPort *) CreatePort(0, 0))
      {
      if (TimerIO = (struct timerequest *) CreateExtIO(TimerMP, sizeof(struct timerequest)))
         {
         if (!OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *) TimerIO, 0L))
            {
            TimerIO->tr_node.io_Command = TR_GETSYSTIME;
            DoIO((struct IORequest *) TimerIO);
            Rubbish = (int) TimerIO->tr_time.tv_micro;
            CloseDevice((struct IORequest *) TimerIO);
            }
			else
            error = TRUE;
         DeleteExtIO((struct IORequest *) TimerIO);
         }
      else
         error = TRUE;
      DeletePort(TimerMP);
      }
   else
      error = TRUE;
//	if (error)
//		SetLastErr("Random() failed to open timer to set seed - default used.")
   if (Rubbish == 0)
      Rubbish = 1;
   if (Rubbish < 0)
      Rubbish = -Rubbish;
   while (Rubbish > 1024)
      Rubbish /= 2;
   return Rubbish;
   }

int RandomSeed = -1;

void FOXLIB SetSeed(REGD0 int Seed)
	{
	if (Seed == -1)
		RandomSeed = SetRandomSeed();
	else
		{
		RandomSeed = Seed;
		if (RandomSeed < 0)
			RandomSeed = -RandomSeed;
		if (RandomSeed > 1024)
			RandomSeed = (RandomSeed % 1024) + 1;
		}
	}

int FOXLIB Random(REGD0 int limit)
{
   if (RandomSeed == -1)
  	   RandomSeed = SetRandomSeed();   /* Can be any number between 1 and 1024 */
	RandomSeed = ((29 * RandomSeed) + 7) % 1024;
	return (int) (limit * (RandomSeed / 1024.0)) + 1;
}
