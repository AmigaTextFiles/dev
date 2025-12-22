/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/* The runtime type system, which
   is used at run-time by the VM to
   determine the types of the clown
   variables. Variables start out
   with type AUTO_NULL and are generally
   first typecasted when a literal is
   assigned to them.  */

char* variable_type = NULL;

void typeSystem_init()
{
    variable_type = malloc(MEMORY_QTY);
    memset(variable_type, AUTO_NULL, MEMORY_QTY);
    assert(variable_type != NULL);
}

void typeSystem_quit()
{
    free(variable_type);
}

char typeSystem_getAddressType(int address)
{
    /* An access function rather than a global */
    return variable_type[address];
}

int typeSystem_convertAddressType(int address, int new_type)
{
    /* "float mode" ignores casts to int */
    if(clown_state.float_mode)
        if(new_type==AUTO_INT)
            new_type=AUTO_FLOAT;

    variable_type[address] = new_type;
    return 0;
}




