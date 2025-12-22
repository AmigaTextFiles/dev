/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

/*
   ---------------------------------------------------------
   This module stores and retrieves compiled bytecode. It
   communicates with the binary output module of the compiler
   and with the interpreter module of the virtual machine.
   ---------------------------------------------------------
*/

#include "Clown_HEADERS.h"

clown_int_t cursor;
clown_int_t program_size = 1000;
clown_float_t *compiled_program = NULL;

void SetUpBytecodeStorage(void)
{
    compiled_program = (clown_float_t *)malloc(program_size*sizeof(clown_float_t));
    cursor=0;
}

void freeProgram(void)
{
    free(compiled_program);
}

void writeToProgramFile(clown_float_t input)
{
    if(cursor==program_size)
    {
        /* dynamic program storage size -- uses less memory */
        program_size += 100;
        compiled_program = (clown_float_t *)realloc(compiled_program, program_size * sizeof(clown_float_t));
        assert(compiled_program != NULL);
    }
    compiled_program[cursor++]=input;
}

clown_int_t programFile_readInt(void)
{
    return (clown_int_t)compiled_program[cursor++];
}

clown_float_t programFile_readFloat(void)
{
    return (clown_float_t)compiled_program[cursor++];
}

void setCursor(clown_int_t theCursor)
{
    cursor=theCursor;
}

clown_int_t getCursor(void)
{
    return cursor;
}



