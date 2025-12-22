/*   Polar.c
 *   Implementierungsmodul
 */

#ifndef POLAR_H
#include "Polar.h"
#endif

// Rechnet Polarkoordinaten in kartesische koordinaten um
void PolarKart(double r, double phi,double &x, double &y)
{
  x = r*sin(phi);
  y = r*cos(phi);
}
