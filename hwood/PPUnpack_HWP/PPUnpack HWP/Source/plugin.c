#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#include <hollywood/plugin.h>


#include "common/purefuncs.h"
#include "common/version.h"

#include "depack.h"

hwPluginAPI *hwcl = NULL;

static const char plugin_name[] = PLUGIN_NAME;
static const char plugin_modulename[] = PLUGIN_MODULENAME;
static const char plugin_author[] = PLUGIN_AUTHOR;
static const char plugin_description[] = PLUGIN_DESCRIPTION;
static const char plugin_copyright[] = PLUGIN_COPYRIGHT;
static const char plugin_url[] = PLUGIN_URL;
static const char plugin_date[] = PLUGIN_DATE;

const char verstr[] = "$VER: " PLUGIN_MODULENAME ".hwp " PLUGIN_VER_STR " (" PLUGIN_DATE ") [" PLUGIN_PLAT "]";

static const char *basetable = "pp";

#define ERR_FILEEXIST  1213
#define ERR_MEM 1000


#ifdef HW_AMIGA
int initamigastuff(void);
void freeamigastuff(void);
#endif

HW_EXPORT int InitPlugin(hwPluginBase *self, hwPluginAPI *cl, STRPTR path)
{
#ifdef HW_AMIGA
	if(!initamigastuff()) return FALSE;
#endif

	self->CapsMask = HWPLUG_CAPS_LIBRARY;
	self->Version = PLUGIN_VER;
	self->Revision = PLUGIN_REV;
	self->hwVersion = HWPLUG_APIVERSION_MIN;
	self->hwRevision = HWPLUG_APIREVISION_MIN;
	self->Name = (STRPTR) plugin_name;
	self->ModuleName = (STRPTR) plugin_modulename;	
	self->Author = (STRPTR) plugin_author;
	self->Description = (STRPTR) plugin_description;
	self->Copyright = (STRPTR) plugin_copyright;
	self->URL = (STRPTR) plugin_url;
	self->Date = (STRPTR) plugin_date;
	self->Settings = NULL;
	self->HelpFile = NULL;

	hwcl = cl;

	return TRUE;
}

HW_EXPORT void ClosePlugin(void)
{
#ifdef HW_AMIGA
	freeamigastuff();
#endif
}

static int hw_ReadText(lua_State *L)
{
    /*
        string$=ReadText(file$)
    */

    FILE *file;
    ULONG plen, unplen;
	UBYTE *packed, *unpacked;

    char *filename = hwcl->LuaBase->lua_tostring(L, 1);

    file = hwcl->CRTBase->fopen(filename,"rb");
	if (!file)
		{
        hwcl->SysBase->hw_SetErrorString(filename);
        return ERR_FILEEXIST;
		}

    hwcl->CRTBase->fseek(file, 0, SEEK_END);
	plen = hwcl->CRTBase->ftell(file);
    hwcl->CRTBase->fseek(file, 0, SEEK_SET);
    
    packed = (UBYTE *)hwcl->CRTBase->malloc(plen);
	if (!packed)
		{
		return ERR_MEM;
		}

	hwcl->CRTBase->fread(packed, 1, plen, file);

    hwcl->CRTBase->fclose(file);

    unplen = depackedlen(packed, plen);
	if (!unplen)
		{
		/*not a powerpacked file*/
        hwcl->LuaBase->lua_pushlstring(L, packed, plen);
	    hwcl->CRTBase->free(packed);
	    return 1;   // return number of return values
		}

	unpacked = (UBYTE *)hwcl->CRTBase->malloc(unplen);

	if (!unpacked)
		{
		return ERR_MEM;
		}

	ppdepack(packed, unpacked, plen, unplen);

    hwcl->CRTBase->free(packed);

    hwcl->LuaBase->lua_pushlstring(L, unpacked, unplen);
	hwcl->CRTBase->free(unpacked);
	return 1;   // return number of return values
}

static int hw_UnpackFile(lua_State *L)
{
    /*
      x=UnpackFile(packedfile$,destinationfile$)
    */

    FILE *file;
    ULONG plen, unplen;
	UBYTE *packed, *unpacked;
    char *filename = hwcl->LuaBase->lua_tostring(L, 1);
    char *dest = hwcl->LuaBase->lua_tostring(L, 2);

    file = hwcl->CRTBase->fopen(filename,"rb");
	if (!file)
		{
        hwcl->SysBase->hw_SetErrorString(filename);
        return ERR_FILEEXIST;
		}

    hwcl->CRTBase->fseek(file, 0, SEEK_END);
	plen = hwcl->CRTBase->ftell(file);
    hwcl->CRTBase->fseek(file, 0, SEEK_SET);

    packed = (UBYTE *)hwcl->CRTBase->malloc(plen);
	if (!packed)
		{
		return ERR_MEM;
		}

	hwcl->CRTBase->fread(packed, 1, plen, file);

    hwcl->CRTBase->fclose(file);

    unplen = depackedlen(packed, plen);
	if (!unplen)
		{
		/*not a powerpacked file*/
        hwcl->LuaBase->lua_pushnumber(L, 0);
	    hwcl->CRTBase->free(packed);
	    return 1;   // return number of return values
		}

	unpacked = (UBYTE *)hwcl->CRTBase->malloc(unplen);

	if (!unpacked)
		{
		return ERR_MEM;
		}

	ppdepack(packed, unpacked, plen, unplen);

    hwcl->CRTBase->free(packed);

	file = hwcl->CRTBase->fopen(dest, "wb");
	if (!file)
		{
        hwcl->SysBase->hw_SetErrorString(dest);
        return ERR_FILEEXIST;
		}

	hwcl->CRTBase->fwrite(unpacked, 1, unplen, file);
	hwcl->CRTBase->fclose(file);

	hwcl->CRTBase->free(unpacked);
	hwcl->LuaBase->lua_pushnumber(L, 1);
    return 1;   // return number of return values

}

static int hw_IsPacked(lua_State *L)
{
    /*
      x=IsPacked(file$)
    */


    FILE *file;
	UBYTE *packed;
    char *filename = hwcl->LuaBase->lua_tostring(L, 1);

    file = hwcl->CRTBase->fopen(filename,"rb");
	if (!file)
		{
        hwcl->SysBase->hw_SetErrorString(filename);
        return ERR_FILEEXIST;
		}
    hwcl->CRTBase->fseek(file, 0, SEEK_SET);
    packed = (UBYTE *)hwcl->CRTBase->malloc(8);
	if (!packed)
		{
		return ERR_MEM;
		}

	hwcl->CRTBase->fread(packed, 1, 8, file);
    hwcl->CRTBase->fclose(file);

    if (packed[0] != 'P' || packed[1] != 'P' ||
		packed[2] != '2' || packed[3] != '0')
			return 0; /* not a powerpacker file */

	hwcl->LuaBase->lua_pushnumber(L, 1);
    return 1;   // return number of return values
}


struct hwCmdStruct plug_commands[] = {
	{"ReadText", hw_ReadText},
    {"UnpackFile",hw_UnpackFile},
    {"IsPacked",hw_IsPacked},
	{NULL, NULL}
};

struct hwCstStruct plug_constants[] = {
	{NULL, NULL, 0}
};

HW_EXPORT STRPTR GetBaseTable(void)
{
	return (STRPTR) basetable;
}

HW_EXPORT struct hwCmdStruct *GetCommands(void)
{
	return (struct hwCmdStruct *) plug_commands;
}


HW_EXPORT struct hwCstStruct *GetConstants(void)
{
	return (struct hwCstStruct *) plug_constants;
}

HW_EXPORT int InitLibrary(lua_State *L)
{
	return 0;
}

HW_EXPORT void FreeLibrary(lua_State *L)
{
}
