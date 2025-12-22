/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

PRG *prg;

FILE *CodeF;             /* Fichier du P-Code */
char *Char= NULL;
long *Int=NULL;
double *Real=NULL;
char **String=NULL;
Entete head;

EXTLIB *lib=NULL;
char *Vchar = NULL;
unsigned char *Vboolean=NULL;
int *Vinteger = NULL;
long *Vlongint;
double *Vreal = NULL;
double *Vlongreal;
char **Vstring= NULL;
TAB *Varray=NULL;    /*Structure de donnee Array 'double' en interne */
Point3d *Vpoint3d;
Point2d *Vpoint2d;
Rgb *Vrgb;

MY_CONST *stack=NULL;
int stsz = 5000;    /* Taille pile */
int st=0;        /* pnt de pile */
int lastcode=0;
double regReal=0,regReal2=0,regReal3=0,regReal4=0;    /* registre pour les reels long*/
double Val[10];

Erreur ExecErrs[] = {
    "Depassement de pile, changer la taille",0,
    "Depassement de pile", 1,
    "Code Inconnu",2,
    (char *)NULL,0
    };
