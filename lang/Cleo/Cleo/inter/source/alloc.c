/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

#ifdef msdos
   #include "include\\inter.h"
#else
   #include "include/inter.h"
#endif

extern char *Char;
extern long *Int;
extern double *Real;
extern char **String;
extern Entete head;

extern char *Vchar;
extern unsigned char *Vboolean;
extern int  *Vinteger;
extern double *Vreal;
extern long *Vlongint;
extern double *Vlongreal;
extern char **Vstring;
extern TAB *Varray;
extern Point3d *Vpoint3d;
extern Point2d *Vpoint2d;
extern Rgb *Vrgb;

extern MY_CONST *stack;
extern int stsz;

void AlloueStack(void)
{
             if (!( stack = (MY_CONST *)calloc(stsz, sizeof(MY_CONST))))
                {
                  printf("Pas assez de memoire pour la Pile\n");
                  EndInter();
                }
}

void AlloueVars(void)
{

        if (head.Vchar)
        {
          if (!( Vchar = (char *)calloc(head.Vchar, sizeof(char))))
                {
                  printf("Pas assez de memoire pour les variables\n");
                  EndInter();
                }
        }

        if (head.Vboolean)
        {
              if (!( Vboolean = (unsigned char *)calloc(head.Vboolean, sizeof(unsigned char))))
                {
                 printf("Pas assez de memoire pour les variables\n");
                 EndInter();
                }
        }

        if (head.Vinteger)
        {
            if (!( Vinteger = (int *)calloc(head.Vinteger, sizeof(int))))
                {
                   printf("Pas assez de memoire pour les Variables\n");
                   EndInter();
                }
        }
        if (head.Vlongint)
        {
            if (!( Vlongint = (long *)calloc(head.Vlongint, sizeof(long))))
                {
                   printf("Pas assez de memoire pour les Variables\n");
                   EndInter();
                }
        }

        if (head.Vreal)  /* Stockage en plus des data sans types, donc seuil min =1000 */
        {
             if (!( Vreal = (double *)calloc(1000+head.Vreal, sizeof(double))))
                {
                  printf("Pas assez de memoire pour les Variables\n");
                  EndInter();
                }
        }
        if (head.Vlongreal)
        {
             if (!( Vreal = (double *)calloc(head.Vlongreal, sizeof(double))))
                {
                  printf("Pas assez de memoire pour les Variables\n");
                  EndInter();
                }
        }

        if (head.Vstring)
        {
            if (!( Vstring = (char **)calloc(head.Vstring, sizeof(char *))))
                {
                  printf("Pas assez de memoire pour les constantes Chaine\n");
                  EndInter();
                }
        }

        if (head.Varray)
        {
          if (!( Varray = (TAB *)calloc(head.Varray, sizeof(TAB))))
                {
                  printf("Pas assez de memoire pour les constantes Tableaux\n");
                  EndInter();
                }
        }
        if (head.Vpoint3d)
        {
          if (!( Vpoint3d = (Point3d *)calloc(head.Vpoint3d, sizeof(Point3d))))
                {
                  printf("Pas assez de memoire pour les variables Point3d\n");
                  EndInter();
                }
        }
        if (head.Vpoint2d)
        {
          if (!( Vpoint2d = (Point2d *)calloc(head.Vpoint2d, sizeof(Point2d))))
                {
                  printf("Pas assez de memoire pour les variables Point2d\n");
                  EndInter();
                }
        }
        if (head.Vrgb)
        {
          if (!( Vrgb = (Rgb *)calloc(head.Vrgb, sizeof(Rgb))))
                {
                  printf("Pas assez de memoire pour les variables Rgb\n");
                  EndInter();
                }
        }
}

void AlloueConst(void)
{
        if (head.Char)
        {
                if (!( Char = (char *)calloc(head.Char, sizeof(char))))
                {
                        printf("Pas assez de memoire pour les constantes\n");
                        EndInter();
                }
        }

        if (head.integer)
        {
                if (!( Int = (long *)calloc(head.integer, sizeof(long))))
                {
                        printf("Pas assez de memoire pour les constantes\n");
                        EndInter();
                }
        }

        if (head.real)
        {
                if (!( Real = (double *)calloc(head.real, sizeof(double))))
                {
                        printf("Pas assez de memoire pour les constantes\n");
                        EndInter();
                }
        }

        if (head.string)
        {
                if (!( String = (char **)calloc(head.string, sizeof(char *))))
                {
                        printf("Pas assez de memoire pour les constantes\n");
                        EndInter();
                }
        }
}
