/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#undef	inline
#define	inline
#undef	PROFILE

#define	LIBQTOOLS_CORE
#include <math.h>
#include "../include/init.h"
#undef	INLINE_BIGENDIAN
#include "../include/libqsys.h"
#include "../include/libqtools.h"
#include "../include/libqdisplay.h"
/* collect all default inline-functions that are not inlined */
#include "../include/mathlib.h"
#include "../libqtools/crc.h"
#include "../libqdisplay/cache.h"
