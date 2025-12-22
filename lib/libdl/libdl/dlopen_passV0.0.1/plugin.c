/*
   program: plugin.c
   dependences: dlopen.c

   description: This prgram gets call by dlopen.

*/

#include <stdio.h>

int one(int i)
{
  printf("in function one.\n");
  return ++i;
}

int two(int i)
{
  printf("in function two.\n");
  return ++i;
}

int three(int i)
{
  printf("in function three.\n");
  return ++i;
}


