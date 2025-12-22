/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _CLOWN_STATE_H
#define _CLOWN_STATE_H

struct clown_state_t
{
    char aflag;
    char hflag;
    int inter;
    char compiler_error;
    int symcount;
    int int_mode;
    int float_mode;
    int argc;
    char** argv;
} typedef clown_state_t;

clown_state_t clown_state;

#endif

