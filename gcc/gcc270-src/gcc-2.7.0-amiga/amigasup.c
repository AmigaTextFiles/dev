/* Supplementary host support for AmigaDOS.  Used only when host is AmigaDOS.
   Copyright (C) 1994 Free Software Foundation, Inc.

This file is part of GNU CC.

GNU CC is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

GNU CC is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU CC; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

This code segment will interface between the startup code and the user's
main(), adjusting the stack if necessary. Two entry points are provided,
main(), and stkexit(). Programs should be compiled using
	gcc -Dmain=stkmain -Dexit=stkexit
and linked with this module.  Calling _exit is not provided for, but should
be trivial to implement.

The minimum acceptable stack size is obtained from the environment variable
GCC_STACK (change the #define ENVNAME to customize). If this variable is
not defined, the default is 50000 bytes (change the #define SIZE to
customize). If the current stack size is less than the minimum acceptable,
then a new stack is allocated, and appropriate actions are taken to ensure
that the original stack is restored before exit.

To link with my stderrfix hack, you will need to compile it using
   	gcc -Dmain=stkmain -c stderrfix.c
and compile everything else (apart from this file) using
   	gcc -Dmain=mymain -Dexit=stkexit
(I have not tested this, but there is no reason why it shouldn't work.)

AUTHOR:     Kriton Kyrimis (kyrimis@theseas.ntua.gr)
KNOWN BUGS: Calling stkexit(0x8000000) will cause the program to exit
            with the wrong exit code (0).
DISCLAIMER: Use this code at your own risk.
*/

/* Putting this in version.c seems to screw up configure, which attempts to
   extract the version number with a sed command that doesn't take this
   string into account.  Also, don't include the date of compilation
   in this string because the annoyance of not being able to do multistage
   build comparisons across days is more than the convenience gained
   (if any) by having the build date incoporated in the executables. -fnf */
char VERSION[]="$VER:gcc 2.6.4";

#undef main
#undef exit

#include <stdlib.h>
#include <setjmp.h>
#include <dos/dosextens.h>
#include <proto/exec.h>
#include <proto/dos.h>

#define SIZE 50000
#define ENVNAME "GCCSTACK"

#define MAGIC 0x80000000

void stkexit(int);

static jmp_buf jmp;
static int swapped = 0;

main(int argc, char **argv)
{
  /* Declare all variables as static, so that they are available no matter
     which stack is active */
  static struct Process *p;
  static struct CommandLineInterface *c;
  static int stacksize, prefsize, status;
  static struct StackSwapStruct stack;
  static char *envsize, *newstack;
  /* The next two variables point to information in the old stack. Declare
     them volatile, to avoid unexpected surprises introduced by the optimizer.
     (This is apparently unnecessary under 2.6.1, but you never know.) */
  static volatile int myargc;
  static volatile char **myargv;

  /* Determine original stack size */
  p = (struct Process *)FindTask(NULL);
  c = BADDR(p->pr_CLI);
  if (c) {
    stacksize = c->cli_DefaultStack * sizeof(LONG);
  }else{
    stacksize = p->pr_StackSize;
  }

  /* Determine preferred stack size */
  envsize = getenv(ENVNAME);
  if (envsize) {
    prefsize = atoi(envsize);
  }else{
    prefsize = SIZE;
  }

  myargc = argc;
  myargv = argv;

  if (prefsize > stacksize) {
    /* Round size to next long word */
    prefsize = ((prefsize + (sizeof(LONG) - 1)) / sizeof(LONG)) * sizeof(LONG);

    /* Allocate new stack */
    newstack = malloc(prefsize);
    if (!newstack) {
      Printf("Can't allocate new stack!\n");
      exit(RETURN_FAIL);
    }

    /* Build new stack structure */
    stack.stk_Lower = newstack;
    stack.stk_Upper = (ULONG)newstack + prefsize;
    /* Determine the address the stackpointer has to go:
     * Point to the last longword of the stackframe and subtract
     * the arguments of StackSwap() since the compiler might
     * try to adjust the stackpointer after calling it :-(.
     */
    stack.stk_Pointer = (APTR)(stack.stk_Upper-2*sizeof(long));

    /* Switch to new stack */
    StackSwap(&stack);
    swapped = 1;
    if (c) {
      c->cli_DefaultStack = prefsize / sizeof(LONG);
    }

    /* Save the current position, so that on exit we may return to the exact
       stack depth where we switched stacks, and switch them back again.
       Programs should invoke stkexit() rather than exit(), or return from
       stkmain(). Status contains the exit status given to stkexit().*/
    if ((status = setjmp(jmp)) != 0) {
      /* Switch back to old stack before exiting */
      StackSwap(&stack);
      if (c) {
	c->cli_DefaultStack = stacksize / sizeof(LONG);
      }
      free(newstack);
      if (status == MAGIC) {	/* If real exit status is 0, stkexit converts */
        status = 0;		/* it to MAGIC, to avoid confusing setjmp */
      }
      exit(status);
    }
    status = stkmain(myargc, myargv);
    stkexit(status);
  } else {
    return stkmain(myargc, myargv);
  }
}

void
stkexit(int status)
{
  if (!swapped) {
    exit (status);
  } else {
    if (status == 0) {	/* The world will end iff we pass 0 as the value */
      status = MAGIC;	/* for longjmp */
    }
    longjmp(jmp, status);
  }
}

