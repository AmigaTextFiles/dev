#ifndef _SGE_H
#define _SGE_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sge.h
 * @brief Main include file, the only one you should include directly. Defines a few macros and includes the other required files, see below for details.
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @mainpage sge2d SDL Game Engine
 *
 * @section intro_sec Introduction
 *
 * This is the API documentation of the SDL Game Engine sge2d.
 *
 * <a href="http://sge2d.agnosent.com" target="_blank">SDL Game Engine Homepage</a>
 *
 * sge2d is a platform independent 2d game programming framework
 * for c/c++ programmers with least possible dependencies for easy
 * porting and with focus on easy api calls and the requirement of
 * commercial programmers. It was started 2007 by the founder
 * of Agnostic Entertainment.
 *
 * It is a open source project under MIT license, so it is free
 * for commercial use, you don't have to publish your source, if
 * you use it. you may even alter the sge2d source for your needs
 * and don't have to publish it.
 *
 * @section demo_sec Demos
 *
 * There are a number of demos in the 'demo' folder. They are
 * well documented and the recommendet start for learning how
 * to develop your games with sge2d.
 *
 * @section build_sec Build
 *
 * To build the engine, change to the main directory and type:
 *
 * ./configure
 *
 * In most cases this should configure the build system. There
 * are platforms that require the platform specified as parameter
 * to ./configure. Type in
 *
 * ./configure --help
 *
 * to get a list of possible parameters, if you run into problems
 * with the build system.
 *
 * After configuring the build system, type in:
 *
 * make
 *
 * to start building the SDL game engine.
 *
 * There are two optional build steps:
 *
 * make demos
 * make test
 *
 * make demos builds the demos, they are well documented and the
 * suggested way to learn sge2d
 *
 * make test builds the developers test environment, this is
 * usually a good point to see whats going on with sge2d, but its
 * a developers playground, so it might be a mess and might even
 * not work at all, you have been warned.
 *
 * @section projects_sec Own projects
 *
 * The recomended way to develop own projects is to create a folder
 * within the sge2d base directory named
 *
 * projects/myproject
 *
 * and copy over a make file from one of the demos.
 *
 * These folders will be excluded from the sge2d cvs and can be set
 * up under your own version control.
 *
 * @section platform_sec Platform specific notes
 *
 * @section notes_amiga_sec Amiga OS derivates
 *
 * You usually have to start the configure script with:
 *
 * sh ./configure
 *
 * @section notes_windows_sec Windows
 *
 * You do require a MSYS/MinGW installation and run sge from
 * inside a MinGW shell.
 *
 * You also require SDL, SDL_image and SDL_mixer installed from
 * source which itself require several libraries. To prevent trouble
 * with compiling, configure all libraries with:
 *
 * ./configure --prefix=/mingw
 * 
 * @page license LICENSE
 *
 * Copyright (c) 2007 Heiko Irrgang
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_audio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#ifndef MORPHOS
	#include <unistd.h>
#endif
#include <fcntl.h>
#include <time.h>
#include <math.h>

/**
 * @defgroup Macros
 * @brief A collection of useful macros
 */

/**
 * @addtogroup Macros
 *
 * Macros for common tasks such as memory management
 * and cross platform C incompatibilities.
 *
 * @{
 */

/**
 * @brief Lock a surface
 *
 * @param surface surface to lock
 *
 * Lock a surface for drawing operations.
 *
 * You should always use this before
 * operating on pixel level on a surface. On most platforms your code will
 * work without locking surfaces, but there are platforms where you will
 * experience crashes.
 */
#define sgeLock(surface) do {\
		if (SDL_MUSTLOCK(surface)) SDL_LockSurface(surface);\
	} while (0)

/**
 * @brief Unlock a surface
 *
 * @param surface surface to unlock
 *
 * Unlock a surface, must be called after processing a locked surface.
 */
#define sgeUnlock(surface) do {\
		if (SDL_MUSTLOCK(surface)) SDL_UnlockSurface(surface);\
	} while (0)

/**
 * @brief Hard exit
 *
 * @param format printf format string
 * @param args arguments for the format string
 *
 * Exit out of the application without any cleanup.
 *
 * You should use this only if there is a unresolvable situation
 *
 */
#define sgeBailOut(format, args...) do {\
		fprintf(stderr,(format),args); \
		exit(-1); \
	} while (0)

/**
 * @brief Allocate ram, fill with 0
 *
 * @param target the pointer to the struct to alloc
 * @param type the struct type to alloc
 * @param amount the number of sructs to alloc
 * @return a pointer to the allocated and zero filled ram
 *
 * Allocates ram for a structure and fills it with zeros.
 *
 * MyStruct *obj;
 *
 * sgeMalloc(obj, MyStruct, 1);
 */
#define sgeMalloc(target,type,amount) do {\
		(target)=(type *)malloc((amount+1)*sizeof(type));\
		if ((target)==NULL) {\
			sgeBailOut("could not allocate %d bytes of ram\n", (int)((amount)*sizeof(type)));\
		}\
		memset(target,0,((amount)*sizeof(type)));\
	} while (0)

/**
 * @brief Allocate ram, uninitialized
 *
 * @param target the pointer to the struct to alloc
 * @param type the struct type to alloc
 * @param amount the number of sructs to alloc
 * @return a pointer to the allocated ram
 *
 * Allocates ram for a structure
 *
 * MyStruct *obj;
 *
 * sgeMalloc(obj, MyStruct, 1);
 */
#define sgeMallocNoInit(target,type,amount) do {\
		(target)=(type *)malloc((amount+1)*sizeof(type));\
		if ((target)==NULL) {\
			sgeBailOut("could not allocate %d bytes of ram\n", (int)((amount)*sizeof(type)));\
		}\
	} while (0)

/**
 * @brief Resize allocated ram
 *
 * @param target the pointer to the struct to alloc
 * @param type the struct type to alloc
 * @param amount the number of sructs to alloc
 * @return a pointer to the increased ram
 */
#define sgeRealloc(target,type,amount) do {\
		(target)=realloc((target),sizeof(type)*(amount+1));\
		if (target==NULL) {\
			sgeBailOut("could not allocate %d bytes of ram\n", (int)((amount)*sizeof(type)));\
		}\
	} while (0)

/**
 * @brief Create one object (aka struct)
 *
 * @param target the pointer to the struct to alloc
 * @param type the struct type to alloc
 * @return a pointer with allocated and zero filled ram
 */
#define sgeNew(target,type) sgeMalloc(target,type,1);

/**
 * @brief Free the object
 *
 * @param target the pointer to the struct to free
 */
#define sgeFree(target) do {\
		free(target);\
		target=NULL;\
	} while(0)

/**
 * @brief Get a random integer
 *
 * @param from the base for the random
 * @param range the range the random will be around from +/-
 * @return a random integer
 */
#define sgeRandom(from, range) (from + (int) ((float)(range+1) * (rand() / (RAND_MAX + (float)from))))

/**
 * @brief Get a random float
 *
 * @param from the base for the random
 * @param range the range the random will be around from +/-
 * @return a random float
 */
#define sgeRandomFloat(from, range) (float) ((float)from + ((float)(range+1) * (rand() / (RAND_MAX + (float)from))))

/**
 * @brief swap byteorder on big endian, otherwise do nothing
 *
 * @param val a 16bit number
 * @return a 16bit number in a unique endianess
 *
 * Use this for example if you write 16 or 32 bit numbers into a binary
 * file to ensure it reads the same value on little and big endian
 */
#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#define sgeByteSwap16(val)    (val)
/**
 * @brief swap byteorder on big endian, otherwise do nothing
 *
 * @param val a 32bit number (depending on prefix)
 * @return a 32bit number in a unique endianess
 *
 * Use this for example if you write 16 or 32 bit numbers into a binary
 * file to ensure it reads the same value on little and big endian
 */
#define sgeByteSwap32(val)    (val)
#else
#define sgeByteSwap16(val)    SDL_Swap16(val)
#define sgeByteSwap32(val)    SDL_Swap32(val)
#endif

/**
 * @brief round a integer value, if there is no c lib function available
 *
 * @params val a float value
 * @return a int value rounded
 */
#ifdef NOROUND
#define sgeRound(val) (int)((val*100+50)/100)
#else
#define sgeRound(val) round(val)
#endif

/**
 * @brief define MAX if not already there
 * @param x a number
 * @param y the max limit of the number
 * @return x if it is in range of y, otherwise y
 */
#ifndef MAX
#define MAX(x, y) ((x) > (y) ? (x) : (y))
#endif

/**
 * @brief define MIN if not already there
 * @param x a number
 * @param y the min limit of the number
 * @return x if it is in range of y, otherwise y
 */
#ifndef MIN
#define MIN(x, y) ((x) < (y) ? (x) : (y))
#endif

/**
 * @brief keep a number in a certain range
 * @param value the number to keep in range
 * @param lower the lower end of the range
 * @param upper the upper end of the range
 * @return a number ensured to be in range of lower and upper borders
 */
#define MINMAX(value, lower, upper) MIN(MAX((value), (lower)), (upper))

// @}

#include <sgedefines.h>
#include <sgestring.h>
#include <sgeinit.h>
#include <sgegp2x.h>
#include <sgemisc.h>
#include <sgelist.h>
#include <sgearray.h>
#include <sgescreen.h>
#include <sgecontrol.h>
#include <sgegfx.h>
#include <sgeresource.h>
#include <sgeevent.h>
#include <sgesound.h>
#include <sgespriteimage.h>
#include <sgesprite.h>
#include <sgespritegroup.h>
#include <sgestage.h>
#include <sgegamestate.h>
#include <sgefont.h>
#include <sgepathfinder.h>
#include <sgeparticles.h>
#include <sgefadefx.h>

#include <../thirdparty/md5/md5.h>
#include <../thirdparty/sha1-c/sha1.h>

#ifdef __cplusplus
}
#endif

#endif
