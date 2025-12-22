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

#ifndef	PARSE_H
#define	PARSE_H

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

#define	MAXTOKEN		128

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

extern char token[MAXTOKEN];						/* 128 */
extern bool unget, endofscript;						/* ? */
extern char *script_p;							/* 4 */
extern int scriptline;							/* 4 */

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

void StartTokenParsing(char *data);
extern bool GetToken(bool crossline);
void UngetToken(void);
bool TokenAvailable(void);

#endif
