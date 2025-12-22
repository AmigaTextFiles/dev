
/* cwhelper.h - Helper routines for cwtext
Copyright (C) 2001 Randall S. Bohn

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  

*/

/* returns the index of char c in string s */
int strpos(const char *s, char c) {
 int x = 0;
 while (s[x] != 0) {
  if (s[x] == c) return x;
  x++;
 }
 return -1;
}
