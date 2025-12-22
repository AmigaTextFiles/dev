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
 *     \file       logginc.c
 *     \brief      Logging functions
 *     \author     written by Felipe Castro
 *     \version    
 *     \copyright  GNU General Public License (version 3 or later)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "config.h"

#include "logging.h"

static int log_level = LOG_LEVEL_DEFAULT;

/** 
 * Ask for log level defined in the env var LIBDWG_LOGLEVEL,
 * And clears the error messages fifo (as a side effect).
 */
void
log_level_init ()
{
  char *probe;

  probe = getenv ("LIBDWG_TRACE");
  if (probe)
    log_level = atoi (probe);
  else
    log_level = LOG_LEVEL_DEFAULT;

  dwg_error_clear ();
}

/** Return the log level defined so far.
 */
int
log_level_get ()
{
  return (log_level);
}

/* Log functions ******************************************************
 */
#ifdef ENABLE_TRACE
void
LOG_WARN (char *string)
{
  dwg_error_push (string);
  if (log_level >= LOG_LEVEL_WARN)
    {
      LOG_HANDLER (LOG_OUTPUT, "libdwg: [WARN] ");
      LOG_HANDLER (LOG_OUTPUT, string);
    }
}

void
LOG_ERROR (char *string)
{
  dwg_error_push (string);
  if (log_level >= LOG_LEVEL_ERROR)
    {
      LOG_HANDLER (LOG_OUTPUT, "libdwg: [ERROR] ");
      LOG_HANDLER (LOG_OUTPUT, string);
    }
}

void
LOG_INFO (char *string)
{
  if (log_level >= LOG_LEVEL_INFO)
    {
      LOG_HANDLER (LOG_OUTPUT, "libdwg: ");
      LOG_HANDLER (LOG_OUTPUT, string);
    }
}

void
LOG_TRACE (char *string)
{
  if (log_level >= LOG_LEVEL_TRACE)
    LOG_HANDLER (LOG_OUTPUT, string);
}

void
LOG_COMPRESS (char *string)
{
  if (log_level >= LOG_LEVEL_COMPRESS)
    LOG_HANDLER (LOG_OUTPUT, string);
}

void
LOG_MEMORY (char *string)
{
  if (log_level >= LOG_LEVEL_MEMORY)
    {
      LOG_HANDLER (LOG_OUTPUT, "libdwg: [MEMORY] ");
      LOG_HANDLER (LOG_OUTPUT, string);
    }
}

void
LOG_PLOT (char *string)
{
  if (log_level >= LOG_LEVEL_PLOT)
    {
      LOG_HANDLER (LOG_OUTPUT, string);
    }
}

void
LOG_INSANE (char *string)
{
  if (log_level >= LOG_LEVEL_INSANE)
    LOG_HANDLER (LOG_OUTPUT, string);
}

#else /* No logging: */

void
LOG_WARN (char *string)
{
  dwg_error_push (string);
}

void
LOG_ERROR (char *string)
{
  dwg_error_push (string);
}

void
LOG_INFO (char *string)
{
}

void
LOG_TRACE (char *string)
{
}

void
LOG_COMPRESS (char *string)
{
}

void
LOG_MEMORY (char *string)
{
}

void
LOG_PLOT (char *string)
{
}

void
LOG_INSANE (char *string)
{
}

#endif /* ENABLE_TRACE */

/** Messages fifo for storing the errors circularly. ********************************************
 * It is implemented here so that it will not be accessible to the user, via dwg.h.
 */
Error_Fifo err;

/**
 * Clear the error fifo.
 */
void
dwg_error_clear ()
{
  err.first = 0;
  err.last = 0;
  err.msg[0][0] = '\0';
}

/**
 * Add an error message to a fifo.
 */
void
dwg_error_push (char *errmsg)
{
  if (err.msg[err.last][0] != '\0')
    {
      if (++err.last >= ERR_FIFO_LEVELS)
	err.last = 0;
      if (err.last == err.first)
	{
	  if (++err.first >= ERR_FIFO_LEVELS)
	    err.first = 0;
	}
      strcpy (err.msg[err.last], errmsg);
    }
  else
    {
      strcpy (err.msg[err.last], errmsg);
    }
}
