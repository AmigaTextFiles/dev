/*
** Test Hollywood plugin
** Copyright (C) 2015-2016 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
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

#include <hollywood/plugin.h>

#include "testplugin.h"
#include "version.h"

// pointer to the Hollywood plugin API
static hwPluginAPI *hwcl = NULL;

// information about our plugin for InitPlugin()
// (NB: we store the version string after the plugin's name; this is not required by Hollywood;
// it is just a trick to prevent the linker from optimizing our version string away)
static const char plugin_name[] = PLUGIN_NAME "\0$VER: " PLUGIN_MODULENAME ".hwp " PLUGIN_VER_STR " (" PLUGIN_DATE ") [" PLUGIN_PLAT "]";
static const char plugin_modulename[] = PLUGIN_MODULENAME;
static const char plugin_author[] = PLUGIN_AUTHOR;
static const char plugin_description[] = PLUGIN_DESCRIPTION;
static const char plugin_copyright[] = PLUGIN_COPYRIGHT;
static const char plugin_url[] = PLUGIN_URL;
static const char plugin_date[] = PLUGIN_DATE;

// all functions will be added to this table
static const char *basetable = "testplugin";

// custom errors registered by this plugin
static int PERR_DIVBYZERO;

/*
** WARNING: InitPlugin() will be called by *any* Hollywood version >= 5.0. Thus, you must
** check the Hollywood version that called your InitPlugin() implementation before calling
** functions from the hwPluginAPI pointer or accessing certain structure members. Your
** InitPlugin() implementation must be compatible with *any* Hollywood version >= 5.0. If
** you call Hollywood 6.0 functions here without checking first that Hollywood 6.0 or higher
** has called your InitPlugin() implementation, *all* programs compiled with Hollywood
** versions < 6.0 *will* crash when they try to open your plugin! 
*/
HW_EXPORT int InitPlugin(hwPluginBase *self, hwPluginAPI *cl, STRPTR path)
{
	// open Amiga libraries needed by this plugin		
#ifdef HW_AMIGA
	if(!initamigastuff()) return FALSE;
#endif

	// identify as a library plugin to Hollywood
	self->CapsMask = HWPLUG_CAPS_LIBRARY;
	self->Version = PLUGIN_VER;
	self->Revision = PLUGIN_REV;

	// we want to be compatible with Hollywood 5.0
	// **WARNING**: when compiling with newer SDK versions you have to be very
	// careful which functions you call and which structure members you access
	// because not all of them are present in earlier versions. Thus, if you
	// target versions older than your SDK version you have to check the hollywood.h
	// header file very carefully to check whether the older version you want to
	// target has the respective feature or not
	self->hwVersion = 5;
	self->hwRevision = 0;
	
	// set plugin information; note that these string pointers need to stay
	// valid until Hollywood calls ClosePlugin()		
	self->Name = (STRPTR) plugin_name;
	self->ModuleName = (STRPTR) plugin_modulename;	
	self->Author = (STRPTR) plugin_author;
	self->Description = (STRPTR) plugin_description;
	self->Copyright = (STRPTR) plugin_copyright;
	self->URL = (STRPTR) plugin_url;
	self->Date = (STRPTR) plugin_date;
	self->Settings = NULL;
	self->HelpFile = NULL;

	// NB: "cl" can be NULL in case Hollywood or Designer just wants to obtain information
	// about our plugin
	if(cl) {
			
		hwcl = cl;
		
		// register a custom error for our plugin
		PERR_DIVBYZERO = hwcl->SysBase->hw_RegisterError("Division by zero!");
	}

	return TRUE;
}

/*
** WARNING: ClosePlugin() will be called by *any* Hollywood version >= 5.0.
** --> see the note above in InitPlugin() for information on how to implement this function
*/
HW_EXPORT void ClosePlugin(void)
{
#ifdef HW_AMIGA
	freeamigastuff();
#endif
}

/* add two numbers */
static SAVEDS int hw_Add(lua_State *L)
{
	lua_Number a = luaL_checknumber(L, 1);
	lua_Number b = luaL_checknumber(L, 2);
		
	lua_pushnumber(L, a + b);
	return 1;
}

/* subtract two numbers */
static SAVEDS int hw_Sub(lua_State *L)
{
	lua_Number a = luaL_checknumber(L, 1);
	lua_Number b = luaL_checknumber(L, 2);
		
	lua_pushnumber(L, a - b);
	return 1;
}

/* multiply two numbers */
static SAVEDS int hw_Mul(lua_State *L)
{
	lua_Number a = luaL_checknumber(L, 1);
	lua_Number b = luaL_checknumber(L, 2);
		
	lua_pushnumber(L, a * b);
	return 1;
}

/* divide two numbers */
static SAVEDS int hw_Div(lua_State *L)
{
	lua_Number a = luaL_checknumber(L, 1);
	lua_Number b = luaL_checknumber(L, 2);
	
	// sanity check	
	if(b == 0) return PERR_DIVBYZERO;
		
	lua_pushnumber(L, a / b);
	return 1;
}

/*
** on AmigaOS we cannot use those functions from the C runtime that require the
** constructor/destructor code of the C runtime --> we need to use own implementations
** or the ones provided by Hollywood in CRTBase
*/
#ifdef HW_AMIGA
static int my_printf(const char *format, ...)
{
	va_list args;
	int r;

	va_start(args, format);
	r = hwcl->CRTBase->vprintf(format, args);
	va_end(args);

	return r;
} 
#else
#define my_printf printf
#endif

/* print a string to stdout */
static SAVEDS int hw_PrintStr(lua_State *L)
{
	const char *s = luaL_checklstring(L, 1, NULL);
	
	my_printf("%s\n", s);
	return 0;
}

/* table containing all commands to be added by this plugin */
struct hwCmdStruct plug_commands[] = {
	{"Add", hw_Add},
	{"Sub", hw_Sub},
	{"Mul", hw_Mul},
	{"Div", hw_Div},
	{"PrintStr", hw_PrintStr},
	{NULL, NULL}
};

/* table containing all constants to be added by this plugin */
struct hwCstStruct plug_constants[] = {
	{"TESTCONSTANT", NULL, 1234},
	{"TESTSTRINGCONSTANT", "A string constant", 0},
	{NULL, NULL, 0}
};

/* return base table's name */
HW_EXPORT STRPTR GetBaseTable(void)
{
	return (STRPTR) basetable;
}

/* return command table */
HW_EXPORT struct hwCmdStruct *GetCommands(void)
{
	return (struct hwCmdStruct *) plug_commands;
}

/* return constant table */
HW_EXPORT struct hwCstStruct *GetConstants(void)
{
	return (struct hwCstStruct *) plug_constants;
}

/* you may do additional initialization here */
HW_EXPORT int InitLibrary(lua_State *L)
{
	return 0;
}

/* you may do additional clean-up here */
#if defined(HW_WIN32) && defined(HW_64BIT)
HW_EXPORT void _FreeLibrary(lua_State *L)
#else
HW_EXPORT void FreeLibrary(lua_State *L)
#endif
{
}
