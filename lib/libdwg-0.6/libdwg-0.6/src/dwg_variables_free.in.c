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
 *     \file       dwg_variables_free.in.c
 *     \brief      Freeing dynamic data in variables (input C file)
 *     \author     written by Felipe Castro
 *     \author     modified by Felipe Corrêa da Silva Sances
 *     \author     modified by Rodrigo Rodrigues da Silva
 *     \author     modified by Till Heuschmann
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#define FIELD_VALUE(name) _var->name

#define FIELD(name,type) 

#include "dwg_macro.h"

#define FIELD_TV(name) \
	if (FIELD_VALUE(name)) \
          {\
            snprintf (tmp, 1024, "Freeing var." #name "\n");\
            LOG_MEMORY (tmp); \
            free (FIELD_VALUE(name)); \
            FIELD_VALUE(name) = NULL;\
          }
#define FIELD_T FIELD_TV /*TODO: implement version dependant string fields */

#define FIELD_BD(name) 
#define FIELD_RD(name) 
#define FIELD_BT(name) 

#define FIELD_HANDLE(name, handle_code) 

#define FIELD_CMC(token) \
	if (FIELD_VALUE(token).name) \
          {\
            snprintf (tmp, 1024, "Freeing var." #token ".name\n");\
            LOG_MEMORY (tmp); \
            free (FIELD_VALUE(token).name); \
            FIELD_VALUE(token).name = NULL;\
          }\
	if (FIELD_VALUE(token).book_name) \
          {\
            snprintf (tmp, 1024, "Freeing var." #token ".book_name\n");\
            LOG_MEMORY (tmp); \
            free (FIELD_VALUE(token).book_name);\
            FIELD_VALUE(token).book_name = NULL;\
          }

int
dwg_variables_free (Dwg_Struct *dwg)
{
  char tmp[1024];
  Dwg_Variables* _var = &dwg->variable;

# include "dwg_variables.spe.c"
}

