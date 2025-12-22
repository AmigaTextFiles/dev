/* knocker version 0.4.0
 * Release date: 27 July 2001
 *
 * Project homepage: http://knocker.sourceforge.net
 *
 * Copyright 2001 Gabriele Giorgetti <g.gabriele@europe.com>
 *
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

enum {
        ATTRIB_RESET, ATTRIB_BRIGHT, ATTRIB_DIM, ATTRIB_UNDERLINE,
        ATTRIB_BLINK, ATTRIB_REVERSE, ATTRIB_HIDDEN
};

enum {
        COLOR_BLACK, COLOR_RED, COLOR_GREEN,
        COLOR_YELLOW, COLOR_BLUE, COLOR_MAGENTA,
        COLOR_CYAN, COLOR_WHITE
};

int KNOCKER_TERM_NO_COLORS;

void knocker_term_set_color (int fg, int bg, int attrib);
void knocker_term_set_default_color (void);
void knocker_term_reset_color (void);

void knocker_term_color_printf  (const char *buffer, int color, int attrib);
void knocker_term_color_fprintf ( FILE *fd, const char *buffer, int color, int attrib );

void knocker_term_color_intprintf (const int i, int color, int attrib );
void knocker_term_color_intfprintf (FILE *fd, const int i, int color, int attrib );