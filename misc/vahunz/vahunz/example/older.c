/*
 * older.c - functions to let a person grow older
 */

#include <stdio.h>

/* This will include the prototypes, so they will be validated.
 * The program would also compile without this include, but it
 * is good style to have it here. */
#include "older.h"

void grow_older(char *name, int *age)
{
    printf("%s grows older.\n", name);

    *age = *age + 1;
}


