

/* OBJECTIVE: To create a Gaussian Random Variable */
#include <math.h>
#include <stdlib.h>
#include "gaussian_rand.h"

double gaussian_rand (double variance)
{
  double ranA,ranB;

  ranA = rand() / (double) RAND_MAX;  /* two independent uniformly */
  ranB = rand() / (double) RAND_MAX;  /* distributed random var.   */
  return (sqrt(2.0 * variance * log (1/(1-ranA))) * cos (2.0 * PI * ranB));
}

