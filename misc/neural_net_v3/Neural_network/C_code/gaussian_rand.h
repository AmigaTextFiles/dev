
#ifndef _GAUSSIAN_RAND_H_
#define _GAUSSIAN_RAND_H_

/* OBJECTIVE: To create a Gaussian Random Variable */

#ifdef __INLINE__
#include <math.h>
#include <stdlib.h>

inline double gaussian_rand (double variance)
{
  double ranA,ranB;

  ranA = rand() / (double) RAND_MAX;  /* two independent uniformly */
  ranB = rand() / (double) RAND_MAX;  /* distributed random var.   */
  return (sqrt(2.0 * variance * log (1/(1-ranA))) * cos (2.0 * PI * ranB));
}

#else

double gaussian_rand (double variance);

#endif

#endif