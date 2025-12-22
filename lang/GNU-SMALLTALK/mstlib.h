/***********************************************************************
 *
 *	Public interface for main module.
 *
 ***********************************************************************/

/***********************************************************************
 *
 * Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
 * Written by Steve Byrne.
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 1, or (at your option) any later 
 * version.
 * 
 * GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
 *
 ***********************************************************************/

/*
 *    Change Log
 * ============================================================================
 * Author      Date       Change 
 * sbb	      1 Jan 92	  Renamed from mstmain.h
 *
 * sbb	     14 Sep 91	  Added edit version support.
 *
 * sbb	      2 Oct 90	  findImageFile was changed to return Boolean.
 *
 * sbyrne     4 Mar 89	  Created.
 *
 */

#ifndef __MSTLIB__
#define __MSTLIB__

#ifndef __MST__
#include "mst.h"
#endif

/* string which represents the current version of Smalltalk */
extern char		versionString[50];

extern Boolean		smalltalkInitialized;

extern Boolean		findImageFile();

#endif /* __MSTLIB__ */
