/**
 * Copyright (C) 1999, 2000, 2001  Free Software Foundation, Inc.
 *
 * This file is part of GNU gengetopt 
 *
 * GNU gengetopt is free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation; either version 2, or (at your option) 
 * any later version. 
 *
 * GNU gengetopt is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details. 
 *
 * You should have received a copy of the GNU General Public License along 
 * with gengetopt; see the file COPYING. If not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 
 */

#ifndef _GENGETOPT_H
#define _GENGETOPT_H

int gengetopt_define_package (char * s) ;
int gengetopt_define_version (char * s) ;
int gengetopt_define_purpose (char * s) ;
int gengetopt_add_option (char * long_opt, char short_opt, char * desc, 
			  int type, int flagstat, int required,
                          char *default_value);

#endif /* _GENGETOPT_H */
