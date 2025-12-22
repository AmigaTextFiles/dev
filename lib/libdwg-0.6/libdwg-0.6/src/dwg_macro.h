/*****************************************************************************/
/*  LibDWG - free implementation of the DWG file format                      */
/*                                                                           */
/*  Copyright (C) 2013 Free Software Foundation, Inc.                        */
/*                                                                           */
/*  This library is free software, licensed under the terms of the GNU       */
/*  General Public License as published by the Free Software Foundation,     */
/*  either version 3 of the License, or (at your option) any later version.  */
/*  You should have received a copy of the GNU General Public License        */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.    */
/*                                                                           */
/*****************************************************************************/

/**
 *     \file       dwg_macros.h
 *     \brief      Common macros used to generate ".c" from ".in.c" and ".spe.c"
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#ifndef _DWG_MACROS_H_
#define _DWG_MACROS_H_

#define PRE(v) if (dwg->header.version < v)
#define UNTIL(v) if (dwg->header.version <= v)
#define LATER_VERSIONS else
#define VERSION(v) if (dwg->header.version == v)
#define VERSIONS(v1,v2) if (dwg->header.version >= v1 && dwg->header.version <= v2)
#define OTHER_VERSIONS else
#define SINCE(v) if (dwg->header.version >= v)
#define PRIOR_VERSIONS else

#define ANYCODE -1

#define FIELD_B(name) FIELD(name, B);
#define FIELD_BB(name) FIELD(name, BB);
#define FIELD_BS(name) FIELD(name, BS);
#define FIELD_BL(name) FIELD(name, BL);
#define FIELD_RC(name) FIELD(name, RC);
#define FIELD_RS(name) FIELD(name, RS);
#define FIELD_RL(name) FIELD(name, RL);

#define FIELD_2RD(name) FIELD_RD(name.x); FIELD_RD(name.y);
#define FIELD_2BD(name) FIELD_BD(name.x); FIELD_BD(name.y);
#define FIELD_3RD(name) FIELD_RD(name.x); FIELD_RD(name.y); FIELD_RD(name.z);
#define FIELD_3BD(name) FIELD_BD(name.x); FIELD_BD(name.y); FIELD_BD(name.z);

#endif
