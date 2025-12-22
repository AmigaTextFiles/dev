/* str.h -- header for str.c.

   Copyright (C) 1996 Free Software Foundation, Inc.
   Written by Thomas Morgan <tmorgan@pobox.com>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

   Written by Thomas Morgan <tmorgan@pobox.com>.  */

#include <stdio.h>
#include <stdlib.h>

/* Always add at least this many bytes when extending the buffer.  */
#define CHUNK 64

/* Return values for `str_add_line*'.  */
enum add_line_return
  {
    ADD_LINE_OK,
    ADD_LINE_ERR,
    ADD_LINE_EOF
  };

struct str
  {
    char *str;			/* The array of characters.  */
    int len;			/* The number of characters.  */
    size_t mem;			/* The amount of memory allocated.  */
  };
typedef struct str str_t;

char *str_to_nstr (str_t * str);
int str_add_line (str_t *, FILE *);
int str_add_line_from_desc (str_t *, int);
str_t *int_to_str (int);
str_t *nstr_to_str (char *);
str_t *str_make (str_t *);
void str_add_char (str_t *, char);
void str_add_str (str_t *, str_t *);
