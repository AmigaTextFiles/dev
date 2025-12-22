/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/********            Fonctions de traitement de chaines         ********/

/* #define debug  */
#define verbose
#include <ctype.h>
#ifdef msdos
        #include "include\\cleobis.h"
        #include "include\\libs.h"
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
#endif

extern char curtoken[];
extern CONST *symb;
extern CONST *cursymb;
extern VAR *var;
extern VAR *curvar;
extern int NbVar;
extern MY_TYPESID curtokentype;
extern MY_TYPESID lasttokentype;
extern MY_CONST curconst;
extern Entete head;
extern void TraitErreur (char type, int num, int lig, int col);
extern int curlg;
extern int curcol;
extern long AdressSize;
extern long TextSize;
extern long SymbolSize;
extern long lg;
extern int curtokenid;
extern int lasttokenid;
extern BOOLEEN Bool[];
extern MOT Reserved[];
extern OPE Mathope[];
extern MOT Type[];
extern MOT Fonctions[];
extern MOT Math[];
extern FCTLIB *extfct, *curextfct, *curlibfct;

#ifdef unix

int Stricmp(str1,str2)
char *str1,*str2;
{
    int index = 0;

    while ( str1[index] && str2[index] &&
            tolower(str1[index]) == tolower(str2[index]) )
        ++index;

    return( (tolower(str1[index]) < tolower(str2[index])) ? -1 :
          ( (tolower(str1[index]) > tolower(str2[index])) ?  1 : 0) );
}
#endif

/*** Fonction qui cherche le prochain chr
        Renvoie le pointeur sur le chr suivant */

char *SearchChr(char *txt,char chr)
{
        char *tmp=txt, fin=0;
        while(lg<TextSize && !fin)
                {
                        if (*tmp==chr) fin=1;
                        else
                        {
                                if (*tmp=='\r' || *tmp=='\n')
                                {
                                curlg++;
#ifdef verbose
                    printf("# %d\r",curlg-1);
#endif
                                }
                                tmp++; lg++;
                        }
                }
        if (fin) return(tmp+1);
        else
        {
                printf("Erreur: Fin de fichier Texte Prématurée\n");
                return((char*)NULL);
        }
}

char *ExtractLine(char *txt)
{
        return(SearchChr(txt,';'));
}

/*** Fonction qui cherche la fin d'un commentaire
                 Renvoie le pointeur sur le chr suivant */
char *EndComment(char *txt)
{
        char *tmp=txt, fin=0;

        while( !fin && lg<TextSize)
                {
                        if (*tmp=='*' && *(tmp+1)=='/') fin=1;
                        else
                        {
                                if (*tmp=='\r' || *tmp=='\n')
                                { curlg++;
#ifdef verbose
                    printf("# %d\r",curlg-1);
#endif
                                }
                                tmp++; lg++;
                        }
                 }
        if (fin) return(tmp+2);
        else
        {
                TraitErreur(RECERROR, BADEND,0,0);
                return((char*)NULL);
        }
}

char *Nombres(char *txt)
{
    int len=0, reel=0;
    char *tmp=(char *)txt;
    float res=0;
    BOOL fin=FALSE;

    if (*txt =='-') { txt++; len++; lg++; }
        while (!fin && (isnum(*txt) || (*txt=='-' && (*(txt-1)=='e' || *(txt-1)=='E')) ||
                              (*txt=='+' && (*(txt-1)=='e' || *(txt-1)=='E')) ||
                 *txt=='.' ||
                (*txt=='e' && (*(txt+1)=='-') ) ||
                (*txt=='e' && (isnum(*(txt+1))|| *(txt+1)=='+') ) ||
                (*txt=='E' && (*(txt+1)=='+') ) ||
                (*txt=='E' && (isnum(*(txt+1))|| *(txt+1)=='-') )))
            {
                if (*txt=='.' && *(txt+1)=='.') fin++;
                else
                {
                    if( *txt=='.' && *(txt+1) != '.') reel++;
                    txt++; len++; lg++;
                }
            }
        if (reel >1)
            {
                TraitErreur(FATALERROR, BADCONST,0,0);
            }
        else
        if(reel==1)
            res= Ascii2Reel(tmp,len);
        else
            res = Ascii2Entier(tmp,len);

        if ( (res-( (int)res)) == 0)
            {
             curtokentype = constint_mt;     /** c'est une Const Integer **/
             curconst.integer = (long) res;
#ifdef debug
             printf("CONSTANTE=%d\tENTIER\n", curconst.integer);
#endif
            }
        else
            {
             curtokentype = constreal_mt;       /** c'est une Const Real **/
             curconst.real = (double)res;
#ifdef debug
            printf("CONSTANTE=%f\tFLOTTANT\n", curconst.real);
#endif
            }
return(txt);
}

char *Avance(char *txt)
{
    while (isspace(*txt))
        {
        if (*txt =='\r' || *txt =='\n')
            { curlg++; curcol=0;
#ifdef verbose
                    printf("# %d\r",curlg-1);
#endif

            }
        txt++; lg++;
        }
    return(txt);
}

char *ConstChr(char *txt)
{
    char *tmp = (char*)curtoken;
    BOOL fin=FALSE;
    *tmp = 0;   ++txt;

    while (!fin && lg < TextSize)
         {

          if (*txt == '\'' && *(txt+1) == '\'')
            {
               *tmp = *txt++;
               lg++;
            }
          else
          {
          if (*txt == '\'' && *(txt+1) != '\'') fin=TRUE;
          else
          if (*txt=='\r' || *txt=='\n')
           {
            curlg++;
            #ifdef verbose
                    printf("# %d\r",curlg-1);
            #endif
           }
          }
          if (!fin)
            {
            *tmp++ = *txt++;
            lg++;
            }
         }
    if (!(lg < TextSize))
        TraitErreur(TEXTERROR, GUILLE, curlg, curcol);
    *tmp =0;

    if (strlen(curtoken) > 1)
        {
        curtokentype = conststr_mt;      /** c'est une const chaine **/
                    curtokenid = -1;
        if (strlen(curtoken) < MAXSTRING)
            strcpy( curconst.string, curtoken );
        else
            TraitErreur(TEXTERROR,STRING2LONG, curlg, curcol);
#ifdef debug
        printf("CONSTANTE=<%s>\tCONSTANTE CHAINE\n",curconst.string);
#endif
        }
    else
        {
        curtokentype = constchr_mt;       /** c'est une const chr **/
                    curtokenid = -1;
        curconst.Char = *curtoken;
#ifdef debug
        printf("CONSTANTE=<%c>\tCONSTANTE CHR\n",curconst.Char);
#endif
        }

    lg++;
    return(++txt);
}

        /**** VRAI si curtoken est une Fonction Externe ****/

BOOL TestExtern()
{
    BOOL trouve=FALSE;
    FCTLIB *cur=extfct;

    while (cur != NULL && !trouve)
    {
        if (!stricmp(curtoken, cur->nom))
            trouve=TRUE;
        else cur = cur->next;
    }
    if (cur != NULL)
        {
            curtokenid = extern_mt; /* Attention affectation du type
                                         dans l'id pour Instruction()*/
            curlibfct = (FCTLIB *)cur;
            return(TRUE);
        }
    else
        return(FALSE);
}

/********** Fct qui renvoie VRAI si curtoken est un Mot Reservé Pascal ****/

BOOL TestMot(MOT *buf)
{
    BOOL fin=FALSE, trouve=FALSE;
    int n=0;

    while (!fin && !trouve)
    {
        if (!stricmp(curtoken, buf[n].str))
            trouve=TRUE;
        else
        if (buf[n].str==(char*)NULL)
            fin=TRUE;
        else n++;
    }
    if (trouve==TRUE)
        {
            curtokenid = (int) buf[n].id;
            return(TRUE);
        }
    else
        return(FALSE);
}
/********** Fct qui renvoie VRAI si curtoken est un Booleen Pascal ****/

BOOL TestBool(void)
{
    BOOL fin=FALSE, trouve=FALSE;
    int n=0;

    while (!fin && !trouve)
    {
        if (!stricmp(curtoken, Bool[n].str))
            trouve=TRUE;
        else
        if (Bool[n].str==(char*)NULL)
            fin=TRUE;
        else n++;
    }
    if (trouve==TRUE)
        {
            curtokenid = (int) Bool[n].id;
            return(TRUE);
        }
    else
        return(FALSE);
}

char *Lettres(char *txt)
{
    char *tmp = (char*)curtoken;
    *tmp = 0;

    while (alnum(*txt) || *txt=='_')
         {
            *tmp++ = *txt++;
            lg++;
         }
    *tmp =0;

#ifdef debug
    printf("TOKEN=%s\t", curtoken);
#endif
    if(TestMot(Math) == TRUE)
            {
             curtokentype = math_mt;           /** c'est une fct math. **/
#ifdef debug
             printf("Fonction Math\n");
#endif
            }
    else
    if(TestMot(Fonctions) == TRUE)
            {
             curtokentype = fonction_mt;           /** c'est une fonction. **/
#ifdef debug
             printf("Fonction\n");
#endif
            }
    else
    if(TestBool() == TRUE)
            {
            curtokentype = booleen_mt;           /** c'est un Booleen. **/
#ifdef debug
            printf("Booleen\n");
#endif
            }
    else
    if (TestMot(Type) == TRUE)
        {
         curtokentype = reservedtype_mt;     /** c'est un Type Reserve*/
#ifdef debug
         printf("Type Reservé\n");
#endif
        }
    else
    if (TestMot(Reserved) == TRUE)
        {
         curtokentype = reserved_mt;           /** c'est un mot reserve **/
#ifdef debug
         printf("Mot Reservé\n");
#endif
        }
    else
    if (TestExtern() == TRUE)
        {
         curtokentype = extern_mt;           /** c'est 1 fct externe **/
#ifdef debug
         printf("Fonction externe\n");
#endif
        }
    else
        {
         curtokentype = ident_mt ;        /** c'est un Identificateur **/
         curtokenid = ident_mt ;
#ifdef debug
         printf("Identificateur\n");
#endif
        }
    return( txt);
}
