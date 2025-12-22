/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _TYPESYSTEM_H
#define _TYPESYSTEM_H

/* Variable types */
#define AUTO_INT        1       /* can convert to auto float */
#define AUTO_FLOAT      2       /* can convert to auto int */
#define AUTO_NULL	3	/* default */

/* Function prototypes */
extern void typeSystem_init();
extern void typeSystem_quit();
extern char typeSystem_getAddressType(int address);
extern int typeSystem_convertAddressType(int address, int new_type);

#endif

