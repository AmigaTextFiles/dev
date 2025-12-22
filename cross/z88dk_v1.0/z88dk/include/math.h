#ifndef MATH_H
#define MATH_H



/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE

extern double acos(double);  /* arc cosine (z88 only) */
extern double asin(double);  /* arc cosine (z88 only) */

extern double atan(double);  /* arc tangent */
extern double atan2(double,double); /* atan2(a,b) = arc tangent of a/b */
extern double cos(double);   /* cosine */
extern double cosh(double);  /* hyperbolic cosine */
extern double exp(double);   /* exponential */
extern double log(double);   /* natural logarithm */
extern double log10(double); /* log base 10 */
extern double pow(double,double);   /* pow(x,y) = x**y */
extern double sin(double);   /* sine */
extern double sinh(double);  /* hyperbolic sine */
extern double sqrt(double);  /* square root */
extern double tan(double);   /* tangent */
extern double tanh(double);  /* hyperbolic tangent */

#pragma unproto HDRPRTYPE

#endif
