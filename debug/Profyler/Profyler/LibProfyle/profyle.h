
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.0 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	LibProfyle Header							Last modified 29-Nov-21	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 This is the header for LibProfyle. Include this when compiling any code
 that is to be profiled.

 Actually, for many uses this file is not needed; the compiler will automat-
 ically pull in the necessary library functions when using the -finstrument-
 functions option. The exception is the various macros; using them requires
 this file to be included.

 If the symbol PROFILING is externally defined (typically on the compiler
 command line) then the macros in this file are activated and will provide
 profiling functionality. If PROFILING is not defined then the macros are
 defined to do nothing, so they may be left in place when profiling is not
 being performed.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This library is free software; you can redistribute it and/or modify it
 under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 2.1 of the License, or (at
 your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FIT-
 NESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
 for more details.

 You should have received a copy of the GNU Lesser General Public License
 along with this library; if not, write to the Free Software Foundation,
 Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

============================================================================
***************************************************************************/

#ifndef LIBPROFYLE_H
#define LIBPROFYLE_H

#ifdef __cplusplus
extern "C" {
#endif

// -------------------------------------------------------------------------
// === Includes ===


// -------------------------------------------------------------------------
// === Prototypes ===

#ifdef PROFILING

// These implement the pause and resume profiling functionality.
void ProfylePause(void);
void ProfyleResume(void);

// These are normally included automatically by the linker, and so don't need
// to be externally visible. However, doing so might allow them to be invoked
// manually in cases where there is no startup code.
void ProfyleConstructor(void);
void ProfyleDestructor(void);

#endif

// -------------------------------------------------------------------------
// === Macros ===

// Macros to disable profiling for sections of code that take a long or in-
// definite amount of time; typically calls to Wait() or user-interaction
// items such as requesters.
#ifdef PROFILING
	#define PROFILE_PAUSE	ProfylePause()
	#define PROFILE_RESUME	ProfyleResume()
#else
	#define PROFILE_PAUSE
	#define PROFILE_RESUME
#endif

// These alternate macros are provided for compatibility with the SAS/C
// SPROF profiler, for source code that is used with both GCC and SAS/C.
#define PROFILE_OFF	PROFILE_PAUSE
#define PROFILE_ON	PROFILE_RESUME

// Add this to a function definition to prevent the prolog and epilog from
// being added to it; as a result that function will not be profiled. A com-
// piler bug causes spurious errors when this is used in a C++ program under
// older versions of GCC, such as the one included with the OS4 SDK.
#ifdef PROFILING
	#define DONT_PROFILE __attribute__((no_instrument_function))
#else
	#define DONT_PROFILE
#endif

// -------------------------------------------------------------------------
// === Defines ===


// -------------------------------------------------------------------------
// === Globals ===


#ifdef __cplusplus
}
#endif

#endif
