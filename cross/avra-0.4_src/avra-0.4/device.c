/***********************************************************************
 *  avra - Assembler for the Atmel AVR microcontroller series
 *  Copyright (C) 1998-1999 Jon Anders Haugum
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; see the file COPYING.  If not, write to
 *  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 *  Boston, MA 02111-1307, USA.
 *
 *
 *  Author of avra can be reached at:
 *     email: jonah@omegav.ntnu.no
 *     www: http://www.omegav.ntnu.no/~jonah/el/avra.html
 */

#include "misc.h"
#include "avra.h"
#include "device.h"

struct device device_list[] =
	{
	{       NULL, 4194304, 8388608, 65536, 0},
	{"AT90S1200",     512,       0,    64, DF_NO_MUL},
	{"AT90S2313",    1024,     128,   128, DF_NO_MUL},
	{"AT90S2323",    1024,     128,   128, DF_NO_MUL},
	{"AT90S2333",    1024,     128,   128, DF_NO_MUL},
	{"AT90S2343",    1024,     128,   128, DF_NO_MUL},
	{"AT90S4414",    2048,     256,   256, DF_NO_MUL},
	{"AT90S4433",    2048,     128,   128, DF_NO_MUL},
	{"AT90S4434",    2048,     256,   256, DF_NO_MUL},
	{"AT90S8515",    4096,     512,   512, DF_NO_MUL},
	{"AT90S8535",    4096,     512,   512, DF_NO_MUL},
	{"ATmega603",   32768,    4096,  2048, DF_NO_MUL},
	{"ATmega103",   65536,    4096,  4096, DF_NO_MUL},
	{NULL, 0, 0, 0, 0}
	};


struct device *get_device(char *name)
	{
	int i = 1;

	if(name == NULL)
		return(&device_list[0]);
	while(device_list[i].name)
		{
		if(!nocase_strcmp(name, device_list[i].name))
			return(&device_list[i]);
		i++;
		}
	return(NULL);
	}
