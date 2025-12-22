/*
  Written by Gilles MASSON, 1996

  This is just a test program that open the mcc and mcp class as libraries
  and test if the MCCQuery (and only public) function of them work.

  Think that the mcp (and mcc) name must have first letter uppercase
  to work with mui prefs !
*/

#include <stdio.h>
#include <stdlib.h>
#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dosextens.h>
#include <libraries/mui.h>
#include <proto/exec.h>

struct Library *SimpleBase = NULL;

#include "mcc_inline.h"

struct Library *SimpleBase1 = NULL;
struct Library *SimpleBase2 = NULL;


int main(void)
{
  long i;
  char str[200];

  SimpleBase1 = OpenLibrary("Simple.mcc",MUIMASTER_VMIN);
  SimpleBase2 = OpenLibrary("Simple.mcp",MUIMASTER_VMIN);

  printf("This exemple open Simple.mcc and Simple.mcp as classic shared libraries\n"
         "and return their Query() function (which is the only public function\n"
         "for mcc and mcp).\n");
  printf("Query(0) return the class adress for mcc.\n");
  printf("Query(1) return the class adress for mcp.\n");
  printf("Query(2) return an optional Bitmap/Bodychunk object (for mcp).\n");
  printf("Query(3) return 0 for mcp and 1 for mcc.\n");
  printf("Others value are not important !\n");
  printf("First letter of mcp must be uppercase to be seen by MUI prefs !\n");
  printf("I got that only by observations and tests, so it's not sur 100%.\n");

  if (SimpleBase1)
  {
    SimpleBase = SimpleBase1;
    printf("\n %s successfully opened.  SimpleBase=0x%lX \n",SimpleBase->lib_Node.ln_Name,SimpleBase);
    for (i=0;i<5;i++)
      printf("MCC_Query(%ld)=%lX \n",i,MCC_Query(i));
  }

  if (SimpleBase2)
  {
    SimpleBase = SimpleBase2;
    printf("\n %s successfully opened.  SimpleBase=0x%lX \n",SimpleBase->lib_Node.ln_Name,SimpleBase);
    for (i=0;i<5;i++)
      printf("MCC_Query(%ld)=%lX \n",i,MCC_Query(i));
  }

  printf("\nenter anything to quit...");
  scanf("%s",str);

  if (SimpleBase1) CloseLibrary((struct Library *)SimpleBase1);
  if (SimpleBase2) CloseLibrary((struct Library *)SimpleBase2);

  return 0;
}

