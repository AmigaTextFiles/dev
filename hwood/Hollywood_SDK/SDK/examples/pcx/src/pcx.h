/*
** PCX Hollywood plugin
** Copyright (C) 2015 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
** Copyright (C) 2001-2005 by TEK neoscientists and the respective authors:
**
**	- Timm S. Müller
**	- Daniel Adler
**	- Frank Pagels
**	- Daniel Trompetter
**	- Tobias Schwinger
**	- Franciska Schulze
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#define MakeRGB(r,g,b) (ULONG) (((r)<<16 | ((g) <<8 | (b))))

#define hw_FClose hwcl->DOSBase->hw_FClose
#define hw_FGetC hwcl->DOSBase->hw_FGetC
#define hw_FSeek hwcl->DOSBase->hw_FSeek
#define hw_FRead hwcl->DOSBase->hw_FRead

// on AmigaOS we cannot use those functions from the C runtime that require the
// constructor/destructor code of the C runtime --> we need to use own implementations
// or the ones provided by Hollywood in CRTBase
#ifndef HW_AMIGA
#define my_malloc malloc
#define my_calloc calloc
#define my_free free
#else
#define my_malloc hwcl->CRTBase->malloc
#define my_calloc hwcl->CRTBase->calloc
#define my_free hwcl->CRTBase->free
#endif

#ifdef HW_AMIGA
int initamigastuff(void);
void freeamigastuff(void);
#endif
