/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/************************* Traitements des Variables **********************/
#include <string.h>

#ifdef msdos
        #include "include\\cleobis.h"
#else
        #include "include/cleobis.h"
#endif

extern void TraitErreur (char type, int num, int lig, int col);
extern Erreur Erreurs[];
extern Erreur Avertis[];
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
extern MY_CONST curconst;
extern Entete head;
extern int curtokenid;
extern int lasttokenid;
extern int Nbfct;
extern int curfct;
extern FIELDSTRUCT Field[];

/******** Fonction qui insere une constante quelconque dans la liste ***/

void InsConst(void)              /*   MY_CONST + MY_TYPESID = SYMBOL    */
{
         CONST *new;

         if (!( new =(CONST *)calloc( sizeof(CONST), 1)))
              TraitErreur(FATALERROR, MEMSYM, curlg, curcol);

    if (symb == NULL)
        {
         symb = new;
         cursymb = new;
        }
    else
        {
        cursymb->next = new;
        cursymb = new;
        }

         new->type = curtokentype;
    switch(curtokentype)
     {
        case constchr_mt:
             new->variable.Char = curconst.Char ;    /* affecte la valeur */
             new->num = head.Char;                   /* Son numero */
             Code(PVAL_CHR, head.Char);             /* val du Nieme Char in Stack */
             head.Char++;                            /* Un Char de plus */
             break;

        case constint_mt:
             new->variable.integer = curconst.integer ;
             new->num = head.integer;
             Code(PVAL_INT, head.integer);          /* val du Nieme Int in Stack */
             head.integer++;
             break;

        case conststr_mt:
             strcpy( new->variable.string, curconst.string) ;
             new->num = head.string;
             Code(PVAL_STR, head.string);           /* Adr du Nieme String in Stack */
             head.string++;
             break;

        case constreal_mt:
             new->variable.real = curconst.real ;
             new->num = head.real;
             Code(PVAL_REAL, head.real);            /* val du Nieme Real in Stack */
             head.real++;
             break;
       default:
            printf("Erreur dans la détection de la constante\n");
            End(); exit(); break;
     }
    new->next = NULL;
    Lexical();
}

void ListConst(void)
{
         CONST *cur=symb;

    while (cur !=NULL)
    {
        switch(cur->type)
        {
        case constchr_mt:
            printf("char N°%d:<%c>\n",cur->num, cur->variable.Char);
             break;
        case constint_mt:
            printf("integer N°%d:<%d>\n",cur->num, cur->variable.integer);
             break;
        case conststr_mt:
            printf("string N°%d:<%s>\n",cur->num, cur->variable.string);
             break;
        case constreal_mt:
            printf("real N°%d:<%f>\n",cur->num, cur->variable.real);
             break;
        default:
            printf("Defaut d'acquisition de la constante\n");
              End(); exit(); break;
             break;
        }
        cur = cur->next;
    }
}

void Assign(void)
{
        int type=-1;           /* type de la variable a assigner */

        if (curtokenid != ident_mt)
                TraitErreur( TEXTERROR, NOIDENT, curlg, curcol);
        else
        {
           type = TestVar(FALSE);       /* Test et load adr in stack */

               if (curtokenid != affecte_b)
                        TraitErreur (TEXTERROR, NOAFFECTE, curlg, curcol);
                else
                {
                        Lexical();
                        Simple_Exp();

/* ici on a le resultat, reste à l'assigner a la variable d'un certain type */

                        switch( type)
                            {
                             case integer_t:
                                Code(STM_INT, 0); /* charge la valeur de la pile
                                              à la variable dont l'adr est a pile-1 */
                               break;
                             case longint_t:
                                Code(STM_LINT, 0);   break;
                             case real_t:
                                 Code(STM_REAL, 0);  break;
                             case longreal_t:
                                 Code(STM_LREAL, 0);  break;
                             case string_t:
                                 Code(STM_STR, 0);   break;
                             case char_t:
                                 Code(STM_CHR, 0);   break;
                             case boolean_t:
                                 Code(STM_BOOL, 0);  break;
                             case array_t:
                                 Code(STM_ARRAY, 0);     break;
                             case point2d_t:
                                 Code(STM_P2D, 0);     break;
                             case point3d_t:
                                 Code(STM_P3D, 0);     break;
                             case rgb_t:
                                 Code(STM_RGB, 0);     break;
                             default:
                              printf ("*** internal: Variable de type inconnu ASSIGN \n");
                               End(); exit(); break;
                }

                }
        }
}

void InsVar(void)
{
        VAR *new, *idx=var;
        BOOL fin=FALSE;

         if (!( new =(VAR *)calloc( sizeof(VAR), 1)))
            TraitErreur(FATALERROR, MEMSYM, curlg, curcol);
        NbVar++;
         if (var == NULL)
            {
                var = new;
                curvar = new;
                new->prev = NULL;
            }
         else
            {
                while( idx !=NULL && !fin)
                    {

                        if ( !strcmp(idx->str, curtoken) && curfct==idx->fct) fin=TRUE;
                        else
                             idx = idx->next;
                    }
                if (fin)
                      TraitErreur(TEXTERROR, DOUBLESYMB, curlg,curcol);
                else
                    {
                        curvar->next = new;
                        new->prev = curvar;
                        curvar = new;
                    }
            }
        strcpy(new->str, curtoken);         /* Copie le Nom */
        new->next = NULL;
        Lexical();
}

/*** Fct qui assigne un type aux n dernieres variables de la liste */
/*** Leur affecte un numero suivant leur type ***/

void AssignType(int n, int type, int borne1, int borne2, int typet)
{
    VAR *idx= curvar;

    while (n--)
        {
         idx->type = type;
         idx -> fct =curfct ;        /* Numero de la fct auquel elle E */
         switch(type)
            {
                case integer_t:
                   idx->num= head.Vinteger++;    break;
                case longint_t:
                   idx->num= head.Vlongint++;    break;
                case real_t:
                   idx->num= head.Vreal++;       break;
                case longreal_t:
                   idx->num= head.Vlongreal++;   break;
                case string_t:
                   idx->num= head.Vstring++;     break;
                case char_t:
                   idx->num= head.Vchar++;       break;
                case boolean_t:
                   idx->num= head.Vboolean++;    break;
                case array_t:
                   idx->num= head.Varray++;
                   idx->tab.borne1 = borne1;  /* copie les donnees du Tab */
                   idx->tab.borne2 = borne2;
                   idx->tab.type   = typet;   /* Type du tableau */
                   break;
                case point2d_t:
                   idx->num= head.Vpoint2d++;    break;
                case point3d_t:
                   idx->num= head.Vpoint3d++;    break;
                case rgb_t:
                   idx->num= head.Vrgb++;    break;
            }
        idx=idx->prev;
        }
}

void ListVar(void)
{
         VAR *list=var;
         printf("\n");
         while(list != NULL)
         {
                printf("\tFonction <%d> Variable No%d = <%s>\ttype: ",list->fct, list->num, list->str);
                switch(list->type)
                {
                case integer_t:
                            printf("Integer\n"); break;
                case longint_t:
                            printf("LongInt\n"); break;
                case real_t:
                            printf("Real\n"); break;
                case longreal_t:
                            printf("LongReal\n"); break;
                case string_t:
                            printf("String\n"); break;
                case char_t:
                            printf("Char\n"); break;
                case boolean_t:
                            printf("Boolean\n"); break;
                case array_t:
                            printf("Array\n"); break;
                case point2d_t:
                            printf("Point2d\n"); break;
                case point3d_t:
                            printf("Point3d\n"); break;
                case rgb_t:
                            printf("rgb\n"); break;
                default:
                            printf ("*** Variable de type inconnu\n");   break;
                                                                                                                                        End(); exit(); break;
                }
           list = list->next;
         }
}

void Gere_Variable(void)
{
    int n=0;
    int borne1=0, borne2=0, typet=0;

    Lexical();
    if (curtokentype != ident_mt)
        TraitErreur( TEXTERROR, NOIDENT, curlg, curcol);
    while (curtokentype == ident_mt)
    {
        n=0;
        while (curtokentype == ident_mt)
        {
            InsVar(); n++;
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
         if (curtokenid == array_t)              /*** Type Tableau ***/
            {
             Lexical();
             if (*curtoken != '[')       /*** Ne gere pas les Ensembles ***/
                TraitErreur( TEXTERROR, NOBRAKETO, curlg, curcol);
             Lexical();                 /* 1ere Borne */
             if (curtokentype == constchr_mt || curtokentype == constint_mt )
              {
                /* Que les constantes INT ou CHAR ex: [1..6] ou ['r'..'z'] */

                switch( curtokentype)
                    {
                    case constchr_mt:
                        borne1 = (int)curconst.Char ;    /* affecte la valeur */
                        break;
                    case constint_mt:
                        borne1 = (int) curconst.integer ;
                        break;
                    }
              }
             else
                TraitErreur( TEXTERROR, NOCONST, curlg, curcol);
             Lexical();
            if (curtokentype == reserved_mt && curtokenid == pp_f)
              {
                Lexical();    /* Lit la 2ieme Borne */
                if (curtokentype == constchr_mt || curtokentype == constint_mt )
                    {
                        switch( curtokentype)
                        {
                        case constchr_mt:
                            borne2 = (int)curconst.Char ;    /* affecte la valeur */
                            break;
                        case constint_mt:
                            borne2 = (int) curconst.integer ;
                            break;
                        }
                    }
                else
                    TraitErreur( TEXTERROR, NOCONST, curlg, curcol);
              }
            else
                TraitErreur( TEXTERROR, SEPPP, curlg, curcol);
            Lexical();
            if (*curtoken != ']')
                TraitErreur( TEXTERROR, NOBRAKETF, curlg, curcol);
            Lexical();
            if ( curtokenid != of_f)
                TraitErreur( TEXTERROR, NOOF, curlg, curcol);
            Lexical();
            if (curtokenid == char_t || curtokenid == real_t ||
             curtokenid == integer_t ||  curtokenid == string_t ||
             curtokenid ==boolean_t ||  curtokenid ==longint_t||
             curtokenid ==longreal_t ||  curtokenid ==point2d_t ||
             curtokenid ==point3d_t || curtokenid ==rgb_t)
                    typet = curtokenid ;           /*type du tableau */
            else
                TraitErreur( TEXTERROR, NOTYPE, curlg, curcol);
            curtokenid= array_t;
            }
         AssignType(n, curtokenid, borne1, borne2, typet);
         Lexical();
         if ( *curtoken != ';')
            TraitErreur( TEXTERROR, NOVIRG, curlg, curcol);
         Lexical();
    }
}

/* Fct qui met l'adresse d'une variable dans la pile */
/* Si load = TRUE alors elle charge apres sa valeur dans la pile */
/* Retourne le type de la var */

int TestVar(BOOL load)
{
         VAR *list=var;
         BOOL fin=FALSE, trouve=FALSE;
         int n=0, indice, typ;
         FIELDSTRUCT *champ= Field;
         char *adr;

      while(list != NULL && !fin)
       {
         if (!(strcmp(curtoken, list->str)) && (list->fct== curfct || list->fct==0)) fin=TRUE;
         else
         list = list->next;
       }
     if (fin)
      {
        switch(list->type)
             {
                case integer_t:
                          Code (PADR_INT, list->num);
                          if (load) Code(PMEM_INT, list->num);
                          break;
                case longint_t:
                          Code (PADR_LINT, list->num);
                          if (load) Code(PMEM_LINT, list->num);
                          break;
                case real_t:
                          Code (PADR_REAL, list->num);
                          if (load) Code(PMEM_REAL, list->num);
                          break;
                case longreal_t:
                          Code (PADR_LREAL, list->num);
                          if (load) Code(PMEM_LREAL, list->num);
                          break;
                case string_t:
                          Code (PADR_STR, list->num);
                          if (load) Code(PMEM_STR, list->num);
                          break;
                case char_t:
                          Code (PADR_CHR, list->num);
                          if (load) Code(PMEM_CHR, list->num);
                          break;
                case boolean_t:
                          Code (PADR_BOOL, list->num);
                          if (load) Code(PMEM_BOOL, list->num);
                          break;
                case array_t:
                         Code (PADR_ARRAY, list->num);

                        Lexical();
                        if ( *curtoken != '[')
                           TraitErreur( TEXTERROR, NOBRAKETO, curlg, curcol);
                        Lexical();
                        Simple_Exp();       /* lit l'index */
                        if ( *curtoken != ']')
                            TraitErreur( TEXTERROR, NOBRAKETF, curlg, curcol);
                            /* etat de la pile : Tab_adr - index -   */

                    typ = list->tab.type;
                    if (typ == point3d_t || typ == point2d_t || typ == rgb_t)
                      {
                        Lexical();
                        if ( *curtoken != '.')
                         {

                         }
                        Lexical();
                        n=0; fin=FALSE; trouve=FALSE;
                        while ( !fin && !trouve)
                         {
                            if (champ[n].id == typ)
                                trouve=TRUE;
                            else
                            if (champ[n].id == fin_t)
                                fin=TRUE;
                            else  n++;
                         }
                        if (fin)
                            {
                                printf("*** Internal error : type_id not found\n");
                                End(); exit();
                            }
                       if (!(adr = (char *)strchr(champ[n].str, (int)*curtoken) ))
                            TraitErreur( TEXTERROR, UNFIELD, curlg, curcol);
                       else
                        {
                            indice =(int)(adr - champ[n].str); /* calcul le No du champ */
                        /* indice correspond a l'indice du champ */
 /* indice <0 */           Code ( PUSHVAL, -indice-1); /* push neg (nbre indice)-1 pour le differencier  d'un index de tableau */
                        }
                      }
                       if (load) Code(PMEM_ARRAY, list->num);
                       break;

                case point3d_t:
                    Code (PADR_P3D, list->num);

                    Lexical();
                    if ( *curtoken != '.')
                     {
                       if (load) Code(PMEM_P3D_ALL, list->num);
                       return( list->type);
                     }

                    Lexical();
                    n=0; fin=FALSE; trouve=FALSE;
                    while ( !fin && !trouve)
                    {
                        if (champ[n].id == (int) point3d_t)
                            trouve=TRUE;
                        else
                        if (champ[n].id == fin_t)
                            fin=TRUE;
                        else  n++;
                    }
                    if (fin)
                        {
                         printf("*** Internal error : type_id not found\n");
                         End(); exit();
                        }
/*pas pour UNIX */      if (!(adr = (char *)strchr(champ[n].str, (int)*curtoken) ))
                        TraitErreur( TEXTERROR, UNFIELD, curlg, curcol);
                    else
                    {
                        indice =(int)(adr - champ[n].str); /* calcul le No du champ */
                        /* indice correspond a l'indice du champ */
                    Code ( PUSHVAL, indice);     /* met le nbre indice dans la pile */
                    if (load) Code(PMEM_P3D, list->num);
                    }
                    break;

                case point2d_t:
                         Code (PADR_P2D, list->num);

                        Lexical();
                        if ( *curtoken != '.')
                            {
                            if (load) Code(PMEM_P2D_ALL, list->num);
                            return( list->type);
                            }
                        Lexical();

                    n=0; fin=FALSE; trouve=FALSE;
                    while ( !fin && !trouve)
                    {
                        if (champ[n].id == (int) point2d_t)
                            trouve=TRUE;
                        else
                        if (champ[n].id == fin_t)
                            fin=TRUE;
                        else  n++;
                    }
                    if (fin)
                        {
                         printf("*** Internal error : type_id not found\n");
                         End(); exit();
                        }
                     if (!(adr = (char *)strchr(champ[n].str, (int)*curtoken) ))
                        TraitErreur( TEXTERROR, UNFIELD, curlg, curcol);
                    else
                    {
                        indice =(int)(adr - champ[n].str); /* calcul le No du champ */
                        /* indice correspond a l'indice du champ */
                    Code ( PUSHVAL, indice);     /* met le nbre indice dans la pile */
                    if (load) Code(PMEM_P2D, list->num);
                    }
                    break;

                case rgb_t:
                    Code (PADR_RGB, list->num);

                    Lexical();
                    if ( *curtoken != '.')
                     {
                       if (load) Code(PMEM_RGB_ALL, list->num);
                       return( list->type);
                     }

                    Lexical();
                    n=0; fin=FALSE; trouve=FALSE;
                    while ( !fin && !trouve)
                    {
                        if (champ[n].id == (int) rgb_t)
                            trouve=TRUE;
                        else
                        if (champ[n].id == fin_t)
                            fin=TRUE;
                        else  n++;
                    }
                    if (fin)
                        {
                         printf("*** Internal error : type_id not found\n");
                         End(); exit();
                        }
                      if (!(adr = (char *)strchr(champ[n].str, (int)*curtoken) ))
                        TraitErreur( TEXTERROR, UNFIELD, curlg, curcol);
                    else
                    {
                        indice =(int)(adr - champ[n].str); /* calcul le No du champ */
                        /* indice correspond a l'indice du champ */
                    Code ( PUSHVAL, indice);     /* met le nbre indice dans la pile */
                    if (load) Code(PMEM_RGB, list->num);
                    }
                    break;


                default:
                    printf ("*** Variable de type inconnu\n");
                    End(); exit(); break;
            }
          Lexical();
          return( list->type);
      }
      else
         TraitErreur(TEXTERROR, UNKNOWNVAR, curlg, curcol);
}