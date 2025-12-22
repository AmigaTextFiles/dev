#ifndef _INCLUDE_MATH_H
#define _INCLUDE_MATH_H

/*
**  $VER: math.h 1.1 (13.6.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

#ifndef PI
#define PI 3.141592653589
#endif

double sin(double);
double cos(double);
double tan(double);
double asin(double);
double acos(double);
double atan(double);
double atan2(double, double);
double sinh(double);
double cosh(double);
double tanh(double);
double exp(double);
double log(double);
double log10(double);
double pow(double,double);
double sqrt(double);
double ceil(double);
double floor(double);
double fabs(double);
double ldexp(double,int);
double frexp(double,int *);
double modf(double,double *);
double fmod(double,double);

#ifdef __cplusplus
}
#endif

#endif
