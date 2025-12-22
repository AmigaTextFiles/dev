/*
** This file contains the Lua specific functions. Once the library has
** been opened and the functions are registered they are accessible from
** the Lua client.
**
*/

#include <proto/dos.h>
#include <proto/exec.h>

#include "lauxlib.h"

#include <string.h>


/*---------------------------------------------------------------------------*/
int l_luaopen(lua_State*);
int l_processList(lua_State*);
int l_print(lua_State*);


/*---------------------------------------------------------------------------*/

/* The luaLib array may be read by more than one process at a time. */
const volatile struct luaL_reg amigaLuaLib[] = {
	{"luaopen_amiga", l_luaopen},
	{0, 0}
};	


static const struct luaL_reg luaLib[] = {
	{"processList", l_processList},
	{"print", l_print},
	{NULL, NULL}
};


int l_luaopen(lua_State* L)
{
	luaL_register(L, "amiga", luaLib);
	return 1;
}


/*---------------------------------------------------------------------------*/
int32 hookFunc(struct Hook* h, uint32* counter, struct Process* p)
{
	IDOS->Printf("%-40s %6lu %6lu %7lu\n",
		p->pr_Task.tc_Node.ln_Name,
		p->pr_ProcessID,
		p->pr_ParentID,
		p->pr_StackSize);

	(*counter)++;

	return 0;
}


int l_processList(lua_State* L)
{
	IDOS->Printf("%-40s %6s %6s %7s\n",
		"Name",
		"PID",
		"PPID",
		"Stack");

	struct Hook hook;
	memset(&hook, 0, sizeof(struct Hook));
	hook.h_Entry = (HOOKFUNC)&hookFunc;

	uint32 total = 0;

	IDOS->ProcessScan(&hook, &total, 0);

	lua_pushnumber(L, total);
	return 1;
}


int l_print(lua_State* L)
{
	const char* s = luaL_checkstring(L, 1);
	IDOS->Printf("%s\n", s);
	return 0;
}
