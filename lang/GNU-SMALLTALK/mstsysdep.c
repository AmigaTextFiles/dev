/***********************************************************************
 *
 *	System specific implementation module.
 *
 *	This module contains implementations of various operating system
 *	specific routines.  This module should encapsulate most of these OS
 *	specific calls so that the rest of the code is portable.
 *
 ***********************************************************************/

/***********************************************************************
 *
 * Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
 * Written by Steve Byrne.
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 1, or (at your option) any later 
 * version.
 * 
 * GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
 *
 ***********************************************************************/


/*
 *    Change Log
 * ============================================================================
 * Author      Date       Change 
 * sbb	     28 Nov 91	  Added getCurDirName() for allowing compiler to record
 *			  the full file name that is used.
 *
 * sbb	      5 Jan 91	  Added getMilliTime().
 *
 * sbyrne    17 May 90	  Added enableInterrupts and disableInterrupts.  System
 *			  V.3 code signal support from Doug McCallum (thanks,
 *			  Doug!).
 *
 * sbyrne    16 May 90	  Created.
 *
 */

#include "mst.h"
#include "mstsysdep.h"
#include <signal.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/param.h>
#if defined(USG)
#include <sys/times.h>
#endif

#ifdef SYSV_3_SIGNALS
static unsigned long __cursigmask; /* keep track of signal mask status */
#endif

/*
 *	IntState disableInterrupts()
 *
 * Description
 *
 *	Saves and returns the current state of the software interrupt system.
 *	Disables all interrupts.
 *
 * Outputs
 *
 *	The old state of the interrupt system (presumably for saving for a
 *	later call to enableInterrupts).
 */
IntState disableInterrupts()
{
#ifdef BSD_SIGNALS
  return (sigsetmask(-1));
#endif
#ifdef SYSV_3_SIGNALS
  unsigned long oldmask = __cursigmask;
  register int i;

  __cursigmask = -1;
  for (i=1; i <= 32; i++) {
    sighold(i);		/* want it blocked - ok if it already is */
  }
  return oldmask;
#endif
}


/*
 *	void enableInterrupts(mask)
 *
 * Description
 *
 *	Restores the state of the interrupt system to that which it had when
 *	"mask" was created. 
 *
 * Inputs
 *
 *	mask  : An interrupt state...should have been returned at some point
 *		from a call to disableInterrupts.
 *
 */
void enableInterrupts(mask)
IntState mask;
{
#ifdef BSD_SIGNALS
  sigsetmask(mask);
#endif
#ifdef SYSV_3_SIGNALS
  unsigned long oldmask = __cursigmask;
  register int i;

  __cursigmask = mask;
  for (i=1; mask != 0; i++, mask >>= 1) { 
    if (oldmask & (0x1 << (i-1))) {
      sigrelse(i);	/* want it unblocked and it is blocked */
    }
  }
#endif
}

/*
 *	unsigned long getMilliTime()
 *
 * Description
 *
 *	Returns the local time in milliseconds
 *
 */
unsigned long getMilliTime()
{
#if !defined(USG)
  struct timeval t;

  gettimeofday(&t, nil);
  return (t.tv_sec * 1000 + t.tv_usec / 1000);
#else
  time_t t;
  struct tms dummy;

  t = times(&dummy);
  return (t * 1000 / gethz());
#endif
}


/*
 *	unsigned long getTime()
 *
 * Description
 *
 *	Returns the time in seconds since midnight Jan 1, 1970 (standard UNIX
 *	type time).  There should be a better (more generic) way to get this
 *	information, but there doesn't seem to be.  Once things are POSIX
 *	compliant, life will be much better :-)
 *
 * Outputs
 *
 *	As described above.
 */
unsigned long getTime()
{
#if !defined(USG)
  struct timeval t;

  gettimeofday(&t, nil);
  return (t.tv_sec);
#else
  time_t	t;

  time(&t);
  return ((unsigned long) t);
#endif
}

/*
 *	void signalAfter(deltaMilli, func)
 *
 * Description
 *
 *	Set up func as a signal handler to be called after deltaMilli
 *	milliseconds.
 *
 * Inputs
 *
 *	deltaMilli: 
 *		Time in milliseconds before the function is invoked.  Rounded
 *		up to nearest second for machines without higher precision
 *		timers.
 *	func  : Signal handling function invoked when interval expires
 *
 * Outputs
 *
 *	None.
 */
void signalAfter(deltaMilli, func)
int	deltaMilli;
signalType (*func)();
{
/* Please feel free to make this more accurate for your operating system
 * and send me the changes.
 */

#ifdef ITIMER_REAL
  struct itimerval value;

    value.it_interval.tv_sec = value.it_interval.tv_usec = 0;
  if (deltaMilli <= 0) {
    /* If we have a negative delta time, we should signal the interrupt NOW.
     * We could do this by just invoking FUNC by hand, but FUNC may expect to
     * be called in the contect of an interrupt handler, and it would be
     * tricky to fake that.  We therefore just make the interrupt handler
     * be called as soon as possible.
     */
    value.it_value.tv_sec = 0;
    value.it_value.tv_usec = 1;	/* smallest possible  */
  } else {
    value.it_value.tv_sec = deltaMilli/1000;
    value.it_value.tv_usec = (deltaMilli%1000) * 1000;
  }

  signal(SIGALRM, func);
  setitimer(ITIMER_REAL, &value, (struct itimerval *)0);
#else 
  int		timeSecs;

  if (deltaMilli < 0) {
    timeSecs = 1;
  } else {
    timeSecs = (deltaMilli + 999)/ 1000; /* round up to nearest second */
  }
  signal(SIGALRM, func);

  alarm(timeSecs);
#endif  
}


/*
 *	char *getCurDirName()
 *
 * Description
 *
 *	Returns the path name for the current directory, without trailing
 *	delimiter (?).
 *
 * Outputs
 *
 *	Pointer to allocated string for current path name.  Caller has
 *	responsibility for freeing the returned value when through.
 */
char *getCurDirName()
{
  char		name[MAXPATHLEN];
  extern char	*strdup();

  getwd(name);
  return (strdup(name));
}


/*
 *	char *getFullFileName(fileName)
 *
 * Description
 *
 *	Returns the full path name for a given file.
 *
 * Inputs
 *
 *	fileName: 
 *		Pointer to file name, can be relative or absolute
 *
 * Outputs
 *
 *	Full path name string.  Caller has the responsibility for freeing the
 *	returned string.
 */
char *getFullFileName(fileName)
char	*fileName;
{
  char		*fullFileName;
  static char	*fullPath = NULL;
  extern char	*strdup();

  if (fileName[0] == '/') {	/* absolute, so don't need to change */
    return (strdup(fileName));
  }

  if (fullPath == NULL) {
    /* Only need to do this once, then cache the result */
    fullPath = getCurDirName();
  }

  /*
   * ### canonicalize filename and full path here in the future (remove any
   * extraneous .. or . directories, etc.)
   */

  fullFileName = (char *)malloc(strlen(fullPath) + strlen(fileName)
				+ 1 /* slash */
				+ 1 /* trailing nul */);
  sprintf(fullFileName, "%s/%s", fullPath, fileName);
  return (fullFileName);
}


#ifdef WANT_DPRINTF

#include <varargs.h>

dprintf(va_alist)
va_dcl
{
  va_list	args;
  char		*fmt;
  static	FILE	*debFile = NULL;

  if (debFile == NULL) {
    debFile = fopen("mst.deb", "w");
  }
  
  va_start(args);
  fmt = va_arg(args, char *);
  (void) vfprintf(debFile, fmt, args);
  fflush(debFile);
  va_end(args);
}

#endif
