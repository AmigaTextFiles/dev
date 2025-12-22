/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/* #define debug */
        /********  Analyseur Syntaxique  Fonctions & Procedures ******/

#ifdef msdos
        #include "include\\cleobis.h"
#else
        #include "include/cleobis.h"
#endif

extern BOOL dismode;
extern int pcpc;
extern int curlg;
extern int curcol;
extern char curtoken[];
extern CONST *symb;
extern CONST *cursymb;
extern VAR *var;
extern VAR *curvar;
extern int NbVar;
extern MY_TYPESID curtokentype;
extern MY_TYPESID lasttokentype;
extern MY_TYPESID facttype;
extern MY_CONST curconst;
extern Entete head;
extern int curtokenid;
extern int lasttokenid;
extern PROG *prg;
extern int *Adress;
extern PROG *curprg;
extern int Nbfct;
extern int curfct;
extern FIELDSTRUCT Field[];

void Fonction(void)
{
    Lexical();
    if (curtokentype != ident_mt)
        TraitErreur( TEXTERROR, NOIDENT, curlg, curcol);

}

void Procedure(void)
{
    int nbvars=0, n=0;

    Lexical();
    if (curtokentype != ident_mt)
        TraitErreur( TEXTERROR, NOIDENT, curlg, curcol);
    Lexical();

    Nbfct++; curfct =Nbfct;

    if (*curtoken != '(' && *curtoken != ';')
        TraitErreur( TEXTERROR, BADPROC, curlg, curcol);
    else if ( *curtoken == ';')                     /* pas de parametres */
        {
            Lexical();
            BlocFct();
        }
    else              /* Il y a des parametres */
    {
            Lexical();
      while (curtokentype == ident_mt)
       {
        n=0;
        while (curtokentype == ident_mt)
        {
            InsVar(); n++; nbvars++;
            if ( *curtoken == ',')
                {
                    Lexical();
                    if (curtokentype != ident_mt)
                        TraitErreur( TEXTERROR, NOIDENT, curlg, curcol);
                }
         }
         if ( *curtoken != ':')
                TraitErreur( TEXTERROR, NOPP, curlg, curcol);
         Lexical();
         if (curtokentype != reservedtype_mt)
            TraitErreur( TEXTERROR, NOTYPE, curlg, curcol);
         AssignType(n, curtokenid);    /* rajoute les variables a la liste */
         Lexical();
         if ( *curtoken != ';' && *curtoken != ')')
            TraitErreur( TEXTERROR, NOPF, curlg, curcol);
         if ( *curtoken == ';') Lexical();
       }
       if ( *curtoken != ')')
           TraitErreur( TEXTERROR, NOPF, curlg, curcol);
       Lexical();
       BlocFct();
      }
 Lexical();

 curfct--;               /** On change de fonction */
}
