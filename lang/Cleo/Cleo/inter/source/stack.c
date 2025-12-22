/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/*************** Fonctions de gestion de pile ****************************/

#ifdef msdos
   #include "include\\inter.h"
#else
   #include "include/inter.h"
#endif

extern int st;
extern MY_CONST *stack;
extern int stsz;

/****************** Long Real *******************/

void PushReal( double val)
{
    if ( st == stsz+1)
        Error(STACKOVER);
    stack[st++].val = val;
    stack[st-1].type = longreal_t;
}

double PopReal()
{
    if ( st==0)
        Error(STACKUNDER);
    --st;
    return ( stack[st].val );
}

/******************  Char *******************/

void PushChar( double val)
{
    if ( st == stsz+1)
        Error(STACKOVER);
    stack[st++].val = val;
    stack[st-1].type = char_t;
}

double PopChar()
{
    if ( st==0)
        Error(STACKUNDER);
    --st;
    return ( stack[ st].val );
}

/******************  Bool *******************/

void PushBool( double val)
{
    if ( st == stsz+1)
        Error(STACKOVER);
    stack[st++].val = val;
    stack[st-1].type = boolean_t;

/*    if (val) PushChar(1);
    else PushChar(0);                */
}

double PopBool()
{
    if ( st==0)
        Error(STACKUNDER);
    --st;
    return ( stack[ st].val );
}

