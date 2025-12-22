/*
  This is a rather simple library, supporting only one function call.
  It uses LibHeader.c.
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif




/*****************************************************************************
  Compiler specific stuff (Handling register arguments)
*****************************************************************************/
#if defined(_DCC)
#define REG(x) __ ## x
#define SAVEDS __geta4
#define ASM
#else
#if defined(__SASC)
#define REG(x) register __ ## x
#define SAVEDS __saveds
#define ASM __asm
#else
#error "Don't know how to handle register arguments for your compiler."
#endif
#endif





/*
  Some stuff for automatic generation of the FD file.

FDPrototype ##base _HelloWorldBase
FDPrototype * Very simple library
FDPrototype ##bias 30
FDPrototype ##public
*/





/*
  Our libraries one and only function. :-)

  Don't forget to add autodocs here if this is a real library!
*/
/*
  This comment defines the functions entry in the FD file.
  Note that doing it this way forces you to put the functions
  in the right order!

FDPrototype HelloWorld(StringNum)(d0)
*/
/*
  This comment defines the functions entry in the proto file.
Prototype STRPTR HelloWorld(LONG);
*/
SAVEDS ASM STRPTR HelloWorld(REG(d0) StringNum,
			     REG(a6) HelloWorldBase)
                             /*
			       Be sure that your library function expects
			       at least one argument. (The library base
			       pointer is a good choice, even if you don't 
			       need it.) Dice's linker will claim missing
			       symbols otherwise.
			     */

{ STATIC STRPTR strings [] = 
    {
      "Hello, world!\n",
      "Hello, local world!\n",
      "Hello, small world!\n",
      "Hello, easy world!\n"
    };

  /*
    Note that we would need to initialize this variable even if the first
    value would be 0! The startup code of LibHeader.c doesn't clear the
    BSS segment.
  */
  STATIC LONG LastNum = -1;

  if (StringNum < 0  ||  StringNum >= (sizeof(strings) / sizeof(STRPTR)))
    { StringNum = ++LastNum;
      if (StringNum == (sizeof(strings) / sizeof(STRPTR)))
	{ StringNum = 0;
	}
    }

  LastNum = StringNum;
  return(strings[StringNum]);
}
