/***********************************************************************
 *
 *	Main Module
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
 * sbb	      1 Jan 92	  Created from old mstmain.c (now mstlib.c)
 *
 */

#include "mstlib.h"
#include "mstpub.h"

#ifdef atarist
long _stksize = -1L;		/* what does this do? */
#endif
main(argc, argv)
int	argc;
char 	**argv;
{
  smalltalkArgs(argc, argv);
  initSmalltalk();
  topLevelLoop();

  exit(0);
}

testMain(argc, argv)
int	argc;
char 	**argv;
{
  char	*str;
  OOP	o;

#ifdef out_temp /* Sat Feb  8 17:08:18 1992 */
/**/  o = msgEval("'foo on you' printNl!");
/**/  msgSendf(nil, "%s %o inspect", o);
#endif /* out_temp Sat Feb  8 17:08:18 1992 */
#ifdef temp /* Thu Jan  2 22:23:07 1992 */
/**/
/**/  smalltalkArgs(argc, argv);
/**/  initSmalltalk();
/**/
/**/  msgSendf(nil, "%s %s printNl", "This is a test");
/**/  msgSendf(&str, "%s %s , %s", "This is a test", " ok?");
/**/  msgSendf(nil, "%s %s printNl", str);
#endif /* temp Thu Jan  2 22:23:07 1992 */
  exit(0);
}

