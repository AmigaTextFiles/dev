/*
 * Declarations needed to use noise() and friends...
 */

#ifndef _NOISE_H 
#define _NOISE_H 

#include <geometric.h>

extern bool     noise_ready;

extern void     noise_init();
extern double   noise();
extern double   turbulence();
extern Vector   Dnoise();


#endif /* _NOISE_H */
