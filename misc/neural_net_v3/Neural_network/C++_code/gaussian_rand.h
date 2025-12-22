
#ifndef _GAUSSIAN_RAND_H_
#define _GAUSSIAN_RAND_H_

/* OBJECTIVE: To create a Gaussian Random Variable */
#include <math.h>
#include <stdlib.h>

double const rand_max = RAND_MAX;

inline double gaussian_rand (double variance)
{
  double ranA,ranB;

  ranA = rand() / rand_max;  /* two independent uniformly */
  ranB = rand() / rand_max;  /* distributed random var.   */
  return (sqrt(2.0 * variance * log (1/(1-ranA))) * cos (2.0 * PI * ranB));
}

#endif
