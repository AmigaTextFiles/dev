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
 *     \file       logging.h
 *     \brief      Logging macros
 *     \author     written by Rodrigo Rodrigues da Silva
 *     \author     modified by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

/* Reduce logging code through macros. In the future, this file can be used as
 *an interface to use more sophisticated logging libraries such as gnu nana
 */
#ifndef _LOGGING_H_
#define _LOGGING_H_

#include <stdio.h>

/* If more logging levels are necessary, put them in the right place and
 * update the numbering, keeping it a 0,1,...n sequence, where n corresponds
 * to LOGLEVEL_ALL. If LOGLEVEL is set to k, all messages with LOGLEVEL < k
 * will be displayed
 */
#define LOG_LEVEL_NONE    0	// no log
#define LOG_LEVEL_WARN    1	// only error messages
#define LOG_LEVEL_ERROR   2	// only error messages
#define LOG_LEVEL_INFO    3	// only general info and object codes/names
#define LOG_LEVEL_TRACE   4	// trace parsed data from bitchain
#define LOG_LEVEL_COMPRESS 5	// info about compressed sections
#define LOG_LEVEL_MEMORY  6	// info about memory footprints
#define LOG_LEVEL_PLOT    7	// hello-kitties
#define LOG_LEVEL_INSANE  8	// code for robots
#define LOG_LEVEL_ALL     9

#define LOG_LEVEL_DEFAULT LOG_LEVEL_ERROR

#define LOG_HANDLER fprintf
#define LOG_OUTPUT stderr

/** Ask for log level defined in the env var LIBDWG_LOGLEVEL
 */
void log_level_init (void);

/** Return the log level defined so far
 */
int log_level_get (void);

void LOG_WARN (char * string);
void LOG_ERROR (char * string);
void LOG_INFO (char * string);
void LOG_TRACE (char * string);
void LOG_COMPRESS (char * string);
void LOG_MEMORY (char * string);
void LOG_PLOT (char * string);
void LOG_INSANE (char * string);

#define ERR_FIFO_LEVELS 13
typedef struct _error_fifo
{
  int first;
  int last;
  char msg[ERR_FIFO_LEVELS][1024];
} Error_Fifo;
void dwg_error_clear (void);
void dwg_error_push (char * errmsg);

#endif /* _LOGGING_H_ */
