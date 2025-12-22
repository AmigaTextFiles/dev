#ifndef FLOAT_H
#define FLOAT_H



/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE



extern double fmod();
extern double amax();
extern double fabs();
extern double amin();
extern double floor();
extern double ceil();
extern double rand(); /* Generic only */
extern int seed();    /* Seed random number */


#pragma unproto HDRPRTYPE

#endif

