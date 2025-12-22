/*****************************************
**                                      **
**              SpeedTest               **
**                                      **
**  Kopierrecht 1996/97 bei COMPIUTECK  **
**                                      **
**    Geschrieben von Matthias Henze    **
**                                      **
*************** © 19/03/97 **************/

#include <stdio.h>
#include <time.h>
#include <math.h>
#include <pragma/exec_lib.h>

clock_t timestart;
double z = 0;

void end (void)
{
  double y;
  clock_t timeend;
  timeend = clock ();
  y = ((timeend - timestart) / (double)50);
  printf ("Benötigte Zeit: %.5g  s\n", y);
  z = z + y;
}

int main (void)
{
  double *d, x;
  double a = 80.9394;
  double b = -80.9394;
  int *e, i, loop;

printf("\nGeben Sie bitte die Anzahl der Testdurchläufe an: ");
scanf("%ld",&loop);

Forbid ();

/*--fabs--*/
printf ("fabs (80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = fabs (a);
end();
printf ("Der absolute Betrag von 80.9394 sollte 80.9394 sein und ist: %g\n\n", x);

printf ("fabs (-80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = fabs (b);
end();
printf ("Der absolute Betrag von -80.9394 sollte 80.9394 sein und ist: %g\n\n", x);

/*--floor--*/
printf ("floor (80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = floor (a);
end();
printf ("Die nächstkleinere Ganzzahl von 80.9394 sollte 80 sein und ist: %g\n\n", x);

printf ("floor (-80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = floor (b);
end();
printf ("Die nächstkleinere Ganzzahl von -80.9394 sollte -81 sein und ist: %g\n\n", x);

/*--sqrt--*/
printf ("sqrt (9)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = sqrt (9);
end();
printf ("Die Quadratwurzel von 9 sollte 3 sein und ist: %g\n\n", x);

printf ("sqrt (-9)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = sqrt (-9);
end();
printf ("Die Quadratwurzel von -9 sollte NaN (Not a Number) sein und ist: %g\n\n", x);

/*--ceil--*/
printf ("ceil (80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = ceil (a);
end();
printf ("Die nächstgrößere Ganzzahl von 80.9394 sollte 81 sein und ist: %g\n\n", x);

printf ("ceil (-80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = ceil (b);
end();
printf ("Die nächstgrößere Ganzzahl von -80.9394 sollte -80 sein und ist: %g\n\n", x);

/*--frexp--*/
printf ("frexp (9)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = frexp (9,(void *) &e);
end();
printf ("Die Mantisse von 9 sollte 0.5625 sein und ist: %g\nDer Exponent von 9 sollte 4 sein und ist: %d\n\n", x, e);

printf ("frexp (88)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = frexp (88,(void *) &e);
end();
printf ("Die Mantisse von 88 sollte 0.6875 sein und ist: %g\nDer Exponent von 88 sollte 7 sein und ist: %d\n\n", x, e);

/*--modf--*/
printf ("modf (80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = modf (a,(void *) &d);
end();
printf ("Der Nachkommateil von 80.9394 sollte 0.9394 sein und ist: %g\nDer Vorkommateil von 80.9394 sollte 80 sein und ist: %g\n\n", x, d);

printf ("modf (-80.9394)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = modf (b,(void *) &d);
end();
printf ("Der Nachkommateil von -80.9394 sollte -0.9394 sein und ist: %g\nDer Vorkommateil von -80.9394 sollte -80 sein und ist: %g\n\n", x, d);

/*--fmod--*/
printf ("fmod (5.7, 1.5)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = fmod (5.7,1.5);
end();
printf ("Das Ergebnis dieser Funktion sollte 1.2 sein und ist: %g\n\n", x);

printf ("fmod (-5.7, 1.5)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = fmod (-5.7,1.5);
end();
printf ("Das Ergebnis dieser Funktion sollte -1.2 sein und ist: %g\n\n", x);

/*--ldexp--*/
printf ("ldexp (9, 3)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = ldexp (9,3);
end();
printf ("Das Produkt von 9 * (2³) sollte 72 sein und ist: %g\n\n", x);

printf ("ldexp (-9, 3)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = ldexp (-9,3);
end();
printf ("Das Produkt von -9 * (2³) sollte -72 sein und ist: %g\n\n", x);

/*--cos--*/
printf ("cos (0)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = cos (0);
end();
printf ("Der Cosinus von 0 sollte 1 sein und ist: %g\n\n", x);

printf ("cos (1)\n");
timestart = clock ();
  for (i = 0; i < loop; i++)
    x = cos (1);
end();
printf ("Der Cosinus von 1 sollte 0.540302 sein und ist: %g\n\n", x);

Permit ();

printf ("Gesamtzeit für %d Durchgänge: %g  s\n", loop, z);
return NULL;
}
