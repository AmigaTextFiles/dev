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

#define	LIBQTOOLS_CORE
#include "../include/libqtools.h"
#include "../include/libqbuild.h"

char token[MAXTOKEN];						/* 128 */
bool unget, endofscript;					/* ? */
char *script_p;							/* 4 */
int scriptline;							/* 4 */

/*============================================================================ */

void StartTokenParsing(char *data)
{
  scriptline = 1;
  script_p = data;
  unget = FALSE;
  endofscript = FALSE;
}

bool GetToken(bool crossline)
{
  char *token_p;

  if (unget) {							/* is a token allready waiting? */
    unget = FALSE;
    return TRUE;
  }

  /* skip space */
skipspace:
  while (*script_p <= 32) {
    if (!*script_p) {
      if (!crossline)
	Error("Line %i is incomplete", scriptline);
      endofscript = TRUE;
      return FALSE;
    }
    if (*script_p++ == '\n') {
      if (!crossline)
	Error("Line %i is incomplete", scriptline);
      scriptline++;
    }
  }

  if (script_p[0] == '/' && script_p[1] == '/') {		/* comment field */
    if (!crossline)
      Error("Line %i is incomplete\n", scriptline);
    while (*script_p++ != '\n')
      if (!*script_p) {
	if (!crossline)
	  Error("Line %i is incomplete", scriptline);
	endofscript = TRUE;
	return FALSE;
      }
    goto skipspace;
  }

  /* copy token */
  token_p = token;

  if (*script_p == '"') {
    script_p++;
    while (*script_p != '"') {
      if (!*script_p)
	Error("EOF inside quoted token");
      *token_p++ = *script_p++;
      if (token_p > &token[MAXTOKEN - 1])
	Error("Token too large on line %i", scriptline);
    }
    script_p++;
  }
  else
    while (*script_p > 32) {
      *token_p++ = *script_p++;
      if (token_p > &token[MAXTOKEN - 1])
	Error("Token too large on line %i", scriptline);
    }

  *token_p = 0;

  return TRUE;
}

void UngetToken(void)
{
  unget = TRUE;
}

/*
 * ==============
 * TokenAvailable
 * Returns true if there is another token on the line
 * ==============
 */
bool TokenAvailable(void)
{
  char *search_p;

  search_p = script_p;

  if (!*search_p)
    return FALSE;

  while (*search_p <= 32) {
    if (*search_p == '\n')
      return FALSE;
    search_p++;
    if (!*search_p)
      return FALSE;
  }

  if ((search_p[0] == '/') && (search_p[1] == '/'))
    return FALSE;

  return TRUE;
}
