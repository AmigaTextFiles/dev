int luaopen_siamigalib(lua_State *L);
void siamiga_close_libraries(void);

#define LUA_EXTRALIBS { "siamiga", luaopen_siamigalib },

