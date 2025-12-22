#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#include <exec/exec.h>
#include <exec/types.h>
#include <proto/exec.h>

#include "common/version.h"

#include <hollywood/plugin.h>

#if defined(HW_MORPHOS) || defined(HW_AMIGAOS3)
struct ExecBase *SysBase = NULL;
#endif

#if defined(HW_AMIGAOS3) && !defined(HW_FPU)
struct Library *MathIeeeSingBasBase = NULL;
struct Library *MathIeeeDoubBasBase = NULL;
struct Library *MathIeeeDoubTransBase = NULL;
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

HW_EXPORT void *GetProcAddress(STRPTR name)
{
	int k;

	for(k = 0; funcs[k].name; k++) {
		if(!strcmp(name, funcs[k].name)) return funcs[k].func;
	}

	return NULL;
}

const hwAmigaEntry entry = {
	{HWPLUG_COOKIE1, HWPLUG_COOKIE2},
	PLUGIN_ARCH,
	GetProcAddress,
};

int initamigastuff(void)
{
#if defined(HW_MORPHOS) || defined(HW_AMIGAOS3)
	// on MorphOS we require SysBase for memcpy()
	SysBase = *((struct ExecBase **) 4);
#endif

#if defined(HW_AMIGAOS3) && !defined(HW_FPU)
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

	return 1;
}

void freeamigastuff(void)
{
#if defined(HW_AMIGAOS3) && !defined(HW_FPU)
	if(MathIeeeSingBasBase) CloseLibrary(MathIeeeSingBasBase);
	if(MathIeeeDoubBasBase) CloseLibrary(MathIeeeDoubBasBase);
	if(MathIeeeDoubTransBase) CloseLibrary(MathIeeeDoubTransBase);
#endif
}
