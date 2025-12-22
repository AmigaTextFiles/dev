/* $Id: random.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/random.h>}
NATIVE {UTILITY_RANDOM_H} CONST

NATIVE {RandomState} OBJECT randomstate
    {rs_High}	high	:VALUE
    {rs_Low}	low	:VALUE
ENDOBJECT
