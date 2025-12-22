/*   Polar.h
 *   Definitionsmodul
 */

#ifndef POLAR_H
#define POLAR_H

// Stellt sicher, daﬂ math.h includiert wird
#ifndef _INCLUDE_MATH_H
#include <math.h>
#endif

/*  Falls Sie einen anderen Compiler als StormC
 *  bzw. andere Header-Dateien verwenden, kann es vorkommen,
 *  daﬂ die symbolische Konstante PI nicht definiert ist.
 */
#ifndef PI
#define PI 3.14159265358979323846
#endif

// Makro f¸r die Umwandlung von Grad in Bogenmaﬂ
#define DEG2RAD(a) (a*PI/180.0)

// Funktionsprototypen:

// Rechnet Polarkoordinaten in kartesische koordinaten um
void PolarKart(double r, double phi,double &x, double &y);

#endif
