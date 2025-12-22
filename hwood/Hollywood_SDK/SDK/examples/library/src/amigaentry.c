/*
** Test Hollywood plugin
** Copyright (C) 2015 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
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

#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <exec/exec.h>
#include <exec/types.h>
#include <proto/exec.h>

#include "version.h"

#include <hollywood/plugin.h>

#if defined(HW_MORPHOS) || defined(HW_AMIGAOS3)
struct ExecBase *SysBase = NULL;
#endif

#if defined(HW_AMIGAOS3) && !defined(HW_FPU)
struct Library *MathIeeeSingBasBase = NULL;
struct Library *MathIeeeDoubBasBase = NULL;
struct Library *MathIeeeDoubTransBase = NULL;
#elif defined(HW_AMIGAOS3) && defined(HW_FPU)
extern ULONG _fpu_init(VOID);
#endif

#ifdef HW_MORPHOS
// need to define this or LoadSeg() will fail on this plugin
// NB: libnix also defines __abox__ but if we don't use any
// libnix object it won't get defined so better declare it here!
int __abox__ = 1;
#endif

#ifdef HW_AMIGAOS4
void _start(void)
{
}
#endif

/*
** look-up table for GetProcAddress(); this table has to contain all the function
** names of the plugin capabilities you set in InitPlugin(); otherwise, Hollywood
** will fail to open your plugin
*/
static const struct
{
	STRPTR name;
	void *func;
} funcs[] =
{
	{"InitPlugin", (void *) InitPlugin},
	{"ClosePlugin", (void *) ClosePlugin},
	{"GetBaseTable", (void *) GetBaseTable},
	{"GetCommands", (void *) GetCommands},
	{"GetConstants", (void *) GetConstants},
	{"InitLibrary", (void *) InitLibrary},
	{"FreeLibrary", (void *) FreeLibrary},	
	{NULL, NULL}
};

/*
** since Amiga libraries don't support named symbol export so we need to use some
** glue code that allows us to get a function pointer from a symbol name
*/
HW_EXPORT void *GetProcAddress(STRPTR name)
{
	int k;

	for(k = 0; funcs[k].name; k++) {
		if(!strcmp(name, funcs[k].name)) return funcs[k].func;
	}

	return NULL;
}

/*
** magic cookie so that Hollywood can identify this executable as a Hollywood
** plugin after LoadSeg()
*/
const hwAmigaEntry entry = {
	{HWPLUG_COOKIE1, HWPLUG_COOKIE2},
	PLUGIN_ARCH,
	GetProcAddress,
};

/*
** open libraries required by our plugin
*/
int initamigastuff(void)
{
#if !defined(HW_WARPOS) && !defined(HW_AROS)
	SysBase = *((struct ExecBase **) 4);
#endif

#ifdef HW_AMIGAOS4
	IExec = (struct ExecIFace *) ((struct ExecBase *) SysBase)->MainInterface;
#endif

#ifdef HW_AMIGAOS3

#ifdef HW_FPU
	// exit cleanly in case there is no FPU
	if(!(SysBase->AttnFlags & AFF_68881) && !(SysBase->AttnFlags & AFF_FPU40)) return 0;
	
	// initialize FPU	
	Supervisor(_fpu_init);		
#else		
	// obviously only need these in case we're on 680x0 and don't have an FPU
	MathIeeeSingBasBase = OpenLibrary("mathieeesingbas.library", 0);
	MathIeeeDoubBasBase = OpenLibrary("mathieeedoubbas.library", 0);
	MathIeeeDoubTransBase = OpenLibrary("mathieeedoubtrans.library", 0);

	if(!(MathIeeeSingBasBase && MathIeeeDoubBasBase && MathIeeeDoubTransBase)) {
		if(MathIeeeDoubTransBase) CloseLibrary(MathIeeeDoubTransBase);
		if(MathIeeeSingBasBase) CloseLibrary(MathIeeeSingBasBase);
		if(MathIeeeDoubBasBase) CloseLibrary(MathIeeeDoubBasBase);
		return 0;
	}
#endif
#endif

	return 1;
}

/*
** close all libraries opened in initamigastuff()
*/
void freeamigastuff(void)
{
#if defined(HW_AMIGAOS3) && !defined(HW_FPU)
	if(MathIeeeSingBasBase) CloseLibrary(MathIeeeSingBasBase);
	if(MathIeeeDoubBasBase) CloseLibrary(MathIeeeDoubBasBase);
	if(MathIeeeDoubTransBase) CloseLibrary(MathIeeeDoubTransBase);
#endif
}

