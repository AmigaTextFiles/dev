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
#include <stdio.h>
#include <ctype.h>

#include <intuition/intuition.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>
#include "/FoxInclude/foxgui.h"

static int error;

// Copied from GuiSys.h
extern void GuiSetLastErrAndLine(char *error, char *file, int line);

#define SetLastErr(a,n)           GuiSetLastErrAndLine(a,__FILE__,__LINE__);error=n

static void ErrorConsole(struct Console *con)
{
   if (error < 1) CloseDevice((struct IORequest*) con->ConOut);
   if (error < 2) DeleteExtIO((struct IORequest*) con->ConIn);
   if (error < 3) DeletePort(con->RePort);
   if (error < 4) DeleteExtIO((struct IORequest*) con->ConOut);
   if (error < 5) DeletePort(con->WrPort);
}

void FOXLIB CloseConsole(register __a0 struct Console *con)
{
	error = 0;
   ErrorConsole(con);
}

int FOXLIB OpenConsole(register __a0 struct Console *con, register __a1 struct Window *win, register __a2 char *name)
{
	char str[20];
	error = 0;
	sprintf(str, "%sOutCon", name);
	if ((con->WrPort = /*(struct MsgPort *)*/ CreatePort(str, 0)) != 0)
	{
		if ((con->ConOut = (struct IOStdReq*) CreateExtIO(con->WrPort, sizeof(struct IOStdReq))) != 0)
		{
			sprintf(str, "%sInCon", name);
			if ((con->RePort = /*(struct MsgPort *)*/ CreatePort(str, 0)) != 0)
			{
				if ((con->ConIn = (struct IOStdReq*) CreateExtIO(con->RePort, sizeof(struct IOStdReq))) != 0)
				{
					con->ConOut->io_Data = (APTR) win;
					con->ConOut->io_Length = sizeof(struct Window);
					if (OpenDevice("console.device", 0, /*(struct IORequest*)*/ con->ConOut, 0) == 0)
					{
						con->ConIn->io_Device = con->ConOut->io_Device;
						con->ConIn->io_Unit = con->ConOut->io_Unit;
					}
					else
						SetLastErr("Failed to open console device in OpenConsole.", 1);
				}
				else
					SetLastErr("Failed to create input IOStdReq in OpenConsole.", 2);
			}
			else
				SetLastErr("Failed to create input port in OpenConsole.", 3);
		}
		else
			SetLastErr("Failed to create output IOStdReq in OpenConsole.", 4);
	}
	else
		SetLastErr("Failed to create output port in OpenConsole.", 5);
	if (error > 0)
	{
		ErrorConsole(con);
		return FALSE;
	}
	return TRUE;
}

void FOXLIB ConPutChar(register __a0 struct Console *con, register __d0 char ch)
{
	char ch1 = ch;

   con->ConOut->io_Command = CMD_WRITE;
   con->ConOut->io_Data = (APTR) &ch1;
   con->ConOut->io_Length = 1;
   DoIO((struct IORequest*) con->ConOut);
   if (ch == VAL_CR) ConPutChar(con, VAL_LF);
}

void FOXLIB QueueRead(register __a0 struct Console *con, register __a1 UBYTE *whereto)
{
   con->ConIn->io_Command = CMD_READ;
   con->ConIn->io_Data = (APTR) whereto;
   con->ConIn->io_Length = 1;
   SendIO((struct IORequest*) con->ConIn);
}

LONG FOXLIB ConMayGetChar(register __a0 struct Console *con, register __a1 UBYTE *whereto)
{
   register UBYTE temp;

   struct Console newcon;
   if (!(newcon.ConIn = (struct IOStdReq *) GetMsg(con->RePort)))
      return -1;
   temp = *whereto;
   QueueRead(&newcon, whereto);
   return temp;
}

static UBYTE ConGetCh(struct Console *con, UBYTE *whereto)   /* ConGetChar */
{
   register UBYTE temp;

   WaitPort(con->RePort);
   con->ConIn = (struct IOStdReq *) GetMsg(con->RePort);
   temp = *whereto;
   QueueRead(con, whereto);
   return((UBYTE) temp);
}

char FOXLIB ConGetChar(register __a0 struct Console *con, register __a1 UBYTE *ibuf)    /* wgetc */
{
   UBYTE ch;

   ch = ConGetCh(con, ibuf);
   return ((char) ch);
}

void FOXLIB ConPrint(register __a0 struct Console *con, register __a1 char *String)  /* wprintf */
{
   con->ConOut->io_Command = CMD_WRITE;
   con->ConOut->io_Data = (APTR) String;
   con->ConOut->io_Length = -1;
   DoIO((struct IORequest*) con->ConOut);
}

void FOXLIB ConClear(register __a0 struct Console *con)        /* wclear */
{
   ConPutChar(con, 12);
}

void FOXLIB ConHome(register __a0 struct Console *con)         /* whome */
{
   ConPrint(con, "\033[H");
}

void FOXLIB ConBlankToEOL(register __a0 struct Console *con)   /* wblanktoeol */
{
   ConPrint(con, "\033[K");
}

void FOXLIB ConTab(register __a0 struct Console *con, register __d0 int x, register __d1 int y)    /* wtab */
{
   char str[10];
   sprintf(str, "\033[%d;%dH", y, x);
   ConPrint(con, str);
}

void FOXLIB ConPrintTab(register __a0 struct Console *con, register __d0 int x, register __d1 int y, register __a1 char *str)
{
   char nstr[200];
   sprintf(nstr, "\033[%d;%dH%s", y, x, str);
   ConPrint(con, nstr);
}

static int ConGetNum(struct Console *con, UBYTE *buf)   /* wGetNum */
{
   int num = 0, ptr = 0, neg = 1;
   char string[30], ch;

   while ((ch = ConGetChar(con, buf)) != VAL_CR)
   {
      if (ch == VAL_BS)
      {
         if (ptr > 0)
         {
            ConPutChar(con, ch);
            ConPutChar(con, ' ');
            ConPutChar(con, ch);
            ptr--;
         }
      }
      else
      {
         if (ptr < 29)
         {
            ConPutChar(con, ch);
            string[ptr++] = ch;
         }
      }
   }
   ConPutChar(con, VAL_CR);
   string[ptr] = '\0';
   ptr = 0;
   if (string[ptr] == '-')
   {
      neg = -1;
      ptr++;
   }
   while (isdigit(string[ptr]))
   {
      num *= 10;
      num += string[ptr++] - '0';
   }
   num *= neg;
   return num;
}

static void ConSelectEvent(struct Console *con, int EventType)
{
   char out[5];

   sprintf(out, "\033[%d{", EventType);
   if (EventType >= 0 && EventType <= 16)
      ConPrint(con, out);
}

// Turn auto-wrap OFF for the given console (default is ON)
void FOXLIB ConWrapOff(register __a0 struct Console *con)
{
	char WrapOff[5];

	sprintf(WrapOff, "%c?7l", 155);
	ConPrint(con, WrapOff);
}

// Turn auto-wrap ON for the given console (default is ON)
void FOXLIB ConWrapOn(register __a0 struct Console *con)
{
	char WrapOn[5];

	sprintf(WrapOn, "%c?7h", 155);
	ConPrint(con, WrapOn);
}

void FOXLIB ConHideCursor(register __a0 struct Console *con)
{
   ConPrint(con, "\033[0 p");
}

void FOXLIB ConShowCursor(register __a0 struct Console *con)
{
   ConPrint(con, "\033[ p");
}

void FOXLIB ConPrintHi(register __a0 struct Console *con, register __a1 char *text, register __d0 int col)
{
   char temp[200];

   sprintf(temp, "\033[3%-dm%s\033[0m", col, text);
   ConPrint(con, temp);
}
