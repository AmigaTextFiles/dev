#include "clisp.h"

extern object module__queens_ffi__object_tab[];

subr_ module__queens_ffi__subr_tab[1];
uintC module__queens_ffi__subr_tab_size = 0;
subr_initdata module__queens_ffi__subr_tab_initdata[1];

object module__queens_ffi__object_tab[1];
object_initdata module__queens_ffi__object_tab_initdata[1];
uintC module__queens_ffi__object_tab_size = 0;

extern uint32 (queens)();

void module__queens_ffi__init_function_1(module)
  var module_* module;
{ }

void module__queens_ffi__init_function_2(module)
  var module_* module;
{
  register_foreign_function(&queens,"queens",512);
}
