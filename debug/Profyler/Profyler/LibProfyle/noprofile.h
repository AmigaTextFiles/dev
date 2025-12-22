
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.0 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	No-profile Header							Last modified 23-Dec-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This program's source code has been set up to allow it to be profiled using
 the Profyler software performance profiler. To that end, it contains some
 macros that control profiling. To allow the distributed source to be com-
 piled when Profyler is not available without needing to change the code,
 this header is provided. It is included in place of Profyler's header file,
 and defines all of the profiler macros to do nothing.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This file is public domain software, and is free for use by anyone, with no
 strings attached.

 This file is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.

============================================================================
***************************************************************************/

#ifndef NOPROFILE_H
#define NOPROFILE_H

// Define these profiler control macros to do nothing.

#define PROFILE_PAUSE
#define PROFILE_OFF
#define PROFILE_RESUME
#define PROFILE_ON
#define DONT_PROFILE

#endif

