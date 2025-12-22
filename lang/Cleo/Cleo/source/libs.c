/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

        /**          Module de gestions des fonction externes   **/

#ifdef msdos
        #include "include\\cleobis.h"
        #include "include\\libs.h"
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
#endif

extern void TraitErreur (char type, int num, int lig, int col);
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
extern int curadr;
extern long AdressSize;
extern int *Adress;
extern int pcpc;
extern FIELDSTRUCT Field[];
extern FCTLIB *extfct, *curextfct, *curlibfct;

void PrintExtFct(FCTLIB *fonc)
{
    int m;
    printf("\t\t\tnom:\t%s\n", fonc->nom);
    printf("\t\t\tid:\t%d\n", fonc->id);
    printf("\t\t\tnbarg:\t%d\n", fonc->nbarg);
    for (m=0; m< fonc->nbarg; printf("\t\t\t\targ type No%d = %d\n", m,fonc->type[m]), m++);
    printf("\t\t\tretype:\t%d\n", fonc->retype);
}

void AnalyseExtern(void)
{
    int nbpara= curlibfct->nbarg;
    int n=1;

/*    PrintExtFct(curlibfct); */

    Lexical();
    if ( *curtoken != '(' )
        TraitErreur (TEXTERROR, NOPO, curlg, curcol);
    do {
        Lexical();
        Simple_Exp();
       } while (n++ <= nbpara && *curtoken == ',');

    if (n-1 != nbpara)
        TraitErreur ( TEXTERROR, NBPARA, curlg, curcol);
    if ( *curtoken != ')' )
        TraitErreur ( TEXTERROR, NOPF, curlg, curcol);
    else
        Lexical();

    Code(PUSHVAL,curlibfct->id);
    Code(LIBRARY, curlibfct->node);
}

void InsExternFct(FCTLIB *ele)
{
    if (!extfct)
        {
            extfct = (FCTLIB *) ele;
            curextfct= extfct;
        }
    else
        {
            curextfct->next = (FCTLIB *) ele;
            curextfct = curextfct->next;
        }
    curextfct->next = NULL;
    head.nbrefctlib++;              /* 1 fct library en plus */
}

void ReadLib(fic)
    FILE *fic;
{
    LIBHEAD header;
    FCTLIB *fonc=NULL;
    int n,namesz;
    char nom[MAXSTRING];

    fread(&header, sizeof(LIBHEAD), 1, fic);
#ifdef verbose
    printf("\t\tLibrary %s avec %d declarations de fonctions\n", header.nom, header.nbfct);
    printf("\t\t\tLibrary Node: %d\n", header.node);
#endif
    for (n=0; n< header.nbfct; n++)
        {
        fonc = (FCTLIB *)calloc(sizeof(FCTLIB),1);
        fread(&namesz, sizeof(int),1, fic);      /* taille nom */
        fgets(nom, namesz+1, fic);
        fonc->nom = (char *)strdup(nom);           /* nom */
        fread(&fonc->id, sizeof(int),1, fic);      /* id */

        fread(&fonc->retype, sizeof(int),1, fic);  /* typeret */
        fread(&fonc->nbarg,sizeof(int),1, fic);    /* Nbre d'args */
        fonc->type =(int *)calloc(sizeof(int)*fonc->nbarg,1);
        fread(fonc->type,sizeof(int)*fonc->nbarg ,1, fic);   /*tab de type */
        fonc->node = header.node;
        InsExternFct(fonc);
#ifdef verbose
    PrintExtFct(fonc);
#endif
        }
}

void inclib_fct(text)
    BOOL text;
{
    char incnom[MAXSTRING];
    BOOL fin=FALSE;
    FILE *fic;

    Lexical();
    if (curtokenid != pluspetit_b)
        TraitErreur ( TEXTERROR, NOPPQ, curlg, curcol);
    Lexical();
    strcpy(incnom, curtoken);
    Lexical();
    while (!fin)
        {
            if (curtokenid != plusgrand_b)
                {
                strcat(incnom,curtoken);
                Lexical();
                }
            else fin =TRUE;
        }
    if(text)                 /* Si inclib dans le prg, alors no virg */
        *curtoken= ';' ;
    else
        Lexical();          /* Avant Program, Begin */

    if (!(fic=fopen(incnom,"rb")))
        TraitErreur ( TEXTERROR, CANTOPENLIB, curlg, curcol);

    ReadLib(fic);
    fclose(fic);
}
