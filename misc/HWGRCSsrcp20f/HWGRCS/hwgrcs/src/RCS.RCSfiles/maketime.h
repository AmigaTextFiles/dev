head	1.1;
access;
symbols
	V2_5:1.1
	V2_4:1.1
	V2_3:1.1
	V2_2:1.1
	V2_1:1.1
	RCS57BASE:1.1;
locks; strict;
comment	@ * @;


1.1
date	96.03.02.16.37.23;	author heinz;	state Exp;
branches;
next	;


desc
@RCS57 base
@


1.1
log
@Initial revision
@
text
@/* Yield time_t from struct partime yielded by partime.  */

/* Copyright 1993, 1994, 1995 Paul Eggert
   Distributed under license by the Free Software Foundation, Inc.

This file is part of RCS.

RCS is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

RCS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with RCS; see the file COPYING.
If not, write to the Free Software Foundation,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

Report problems and direct all questions to:

    rcs-bugs@@cs.purdue.edu

*/

#if defined(__STDC__) || has_prototypes
#	define __MAKETIME_P(x) x
#else
#	define __MAKETIME_P(x) ()
#endif

struct tm *time2tm __MAKETIME_P((time_t,int));
time_t difftm __MAKETIME_P((struct tm const *, struct tm const *));
time_t str2time __MAKETIME_P((char const *, time_t, long));
time_t tm2time __MAKETIME_P((struct tm *, int));
void adjzone __MAKETIME_P((struct tm *, long));
@
