//----------------------------------------------------------
// class Y_program - primitive class for handling code block
//----------------------------------------------------------

#define CL_Y_PROGRAM_HPP

#define YPAGE_0
// compile standard codepage

#define YPAGE_2
// compile floatingpoint codepage


#ifndef STDIO_H
extern "C"{
#include <stdio.h>
}
#endif

#ifndef STDLIB_H
extern "C"{
#include <stdlib.h>
}
#endif

#ifndef TIME_H
extern "C"{
#include <time.h>
}
#endif

#ifndef MATH_H
extern "C"{
#include <math.h>
}
#endif

#ifndef PI
#define PI 3.1415926535897932384626432383279502
#endif

#ifndef STRING_H
extern "C"{
#include <string.h>
}
#endif



#ifndef MYTYPES_H
#include "mytypes.h"
#endif


typedef char *programcounter;
typedef long stackcounter;

class Y_program
{
private:

//+ statics

enum comco                // command codes
{unk=0, // unknown
 imp,   // impossible - cannot reach do_keyword. '(', for example
 yyy,   // Y vital ( 'Y','Q')
 ari,   // arithmetics
 bin,   // binary
 cmp,   // comparison
 mem,   // peek, poke, size
 sta,   // stack manipulators
 sio,   // standard I/O
 pag    // page specific
};

static const int commandtype[128];  // command types of all ascii characters


//-

//+ basic data

char *code;
programcounter pc;
long length;

programcounter *r_stack;
stackcounter r_sc;
ulword rsize;

ulword *d_stack;
stackcounter d_sc;
ulword dsize;

//-

ulword vars[26*16]; // a-z

int valid;

ulword pokesize;
ulword codepage;        // which codepage are we using?
float fcomparetolerance;

virtual int do_keyword(const char);

void err_uflow(void){fprintf(stderr,"Underflow!\n");valid=0;}
void err_oflow(void){fprintf(stderr,"Overflow!\n");valid=0;}

void init_variables(long, long);  // dstack size, rstack size
void prepare_source(void);

//+ "Eval Commands of same kind" routines:

// There is no function for Y vitals. You will never be able to change them!

int do_mem(const char);
int do_sta(const char);

int do_base_pag(const char);

int do_int_ari(const char);
int do_int_bin(const char);
int do_int_cmp(const char);
int do_int_sio(const char);

//---
int do_memN(const char);
int do_staN(const char);
int do_base_pagN(const char);
int do_int_ariN(const char);
int do_int_binN(const char);
int do_int_cmpN(const char);
int do_int_sioN(const char);


#ifdef YPAGE_2

int do_float_pag(const char);

int do_float_ari(const char);
int do_float_cmp(const char);
int do_float_sio(const char);

//---
int do_float_pagN(const char);
int do_float_ariN(const char);
int do_float_cmpN(const char);
int do_float_sioN(const char);

#endif

//-


// PUBLIC
public:

Y_program(const char *, long, long); // Arg: filename, datastack size, returnstack size
Y_program(long, long, const char *); // Arg: datastack size, returnstack size, program as string

// Yes, it's dirty, but...
// hey, come on, what is worse? Writing an own completely "naked"
// class filename solely for the purpose of being able to call
// overloaded Y_program constructors properly, or doing tricks with
// argument sequences?    (Probably the last alternative... :-) )



~Y_program();

int is_valid(void) const {return valid;}

int step(void);

void go(void){while(step());}

void setvar(char v, ulword n){vars[(v-'a')*16]=n;}
};

// This level of abstraction is enough for our purpose, I say.
                              
