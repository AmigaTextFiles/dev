/*
 * $Id$
 *
 * :ts=4
 *
 * Wrapper routines for Amiga SSHv1 client interface to subversion 1.1.4
 * Copyright (c) 2009 by Olaf Barthel <obarthel@gmx.net>
 * All rights reserved
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 */

#include <proto/dos.h>

#include <signal.h>
#include <stdio.h>

/****************************************************************************/

#include "amiga_getpass.h"

/****************************************************************************/

/* Read a password from the console without showing what the user types. Returns
   a pointer to a static buffer which contains the password. Note that the
   password cannot be longer than 128 characters. */
char *
amiga_getpass(const char *prompt)
{
	void (*old_sig_handler)(int);
	char * result = NULL;
	BPTR input_stream;

	/* Let's hope that this really refers to the current input
	   stream... */
	input_stream = Input();

	old_sig_handler = signal(SIGINT,SIG_IGN);

	if(SetMode(input_stream,DOSTRUE))
	{
		static char pwd_buf[128];
		int len,c;

		fputs(prompt,stderr);
		fflush(stderr);

		len = 0;
		while(TRUE)
		{
			c = -1;

			while(TRUE)
			{
				if(CheckSignal(SIGBREAKF_CTRL_C))
				{
					SetMode(input_stream,DOSFALSE);
					signal(SIGINT,old_sig_handler);

					raise(SIGINT);

					signal(SIGINT,SIG_IGN);
					SetMode(input_stream,DOSTRUE);
				}

				if(WaitForChar(input_stream,TICKS_PER_SECOND / 2))
				{
					c = fgetc(stdin);
					if(c == '\003')
					{
						SetMode(input_stream,DOSFALSE);
						signal(SIGINT,old_sig_handler);

						raise(SIGINT);

						signal(SIGINT,SIG_IGN);
						SetMode(input_stream,DOSTRUE);
					}
					else
					{
						break;
					}
				}
			}

			if(c == '\r' || c == '\n')
				break;

			if(((c >= ' ' && c < 127) || (c >= 160)) && len < sizeof(pwd_buf)-1)
			{
				pwd_buf[len++] = c;
				pwd_buf[len] = '\0';
			}
		}

		SetMode(input_stream,DOSFALSE);

		fputs("\n",stderr);

		result = pwd_buf;
	}

	signal(SIGINT,old_sig_handler);

	return(result);
}
