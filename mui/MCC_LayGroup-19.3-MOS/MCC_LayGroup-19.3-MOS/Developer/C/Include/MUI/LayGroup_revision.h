/*******************************************************************************

 LayGroup.mcc - An automatic object arranger layout MUI Custom Class
 Copyright (C) 1997-1999 by Alessandro Zummo
 Copyright (C) 2008      by LayGroup.mcc Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 LayGroup class Support Site: http://sourceforge.net/projects/laygroup-mcc

 $Id:$

*******************************************************************************/

#define LIB_VERSION    19
#define LIB_REVISION   3

#define LIB_REV_STRING "19.3"
#define LIB_DATE       "25.03.2008"

#if defined(__PPC__)
  #if defined(__MORPHOS__)
    #define CPU " [MOS/PPC]"
  #else
    #define CPU " [OS4/PPC]"
  #endif
#elif defined(_M68060) || defined(__M68060) || defined(__mc68060)
  #define CPU " [060]"
#elif defined(_M68040) || defined(__M68040) || defined(__mc68040)
  #define CPU " [040]"
#elif defined(_M68030) || defined(__M68030) || defined(__mc68030)
  #define CPU " [030]"
#elif defined(_M68020) || defined(__M68020) || defined(__mc68020)
  #define CPU " [020]"
#else
  #define CPU ""
#endif

#define LIB_COPYRIGHT  "Copyright (c) 2008 LayGroup.mcc Open Source Team"

