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
/*************************   Analyseur Syntaxique   ***********************/

#ifdef msdos
        #include "include\\cleobis.h"
        #include "include\\libs.h"
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
#endif

extern void TraitErreur (char type, int num, int lig, int col);
extern Erreur Erreurs[];
extern Erreur Avertis[];
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
extern int curfct, debut;
extern FIELDSTRUCT Field[];
extern FCTLIB *extfct, *curextfct, *curlibfct;

void Code( int mnemo, int ope)
{
        PROG *new;

        if ( mnemo == ORG)            /*adress=  ADRESSE COURANTE */
                *(Adress+ope) = pcpc;
        else
        if ( mnemo == LOADORG)            /*adress=  ADRESSE DE DEBUT PRG */
                *(Adress+ope) = pcpc?pcpc:1;   /* Si l'adr de debut=0 alors la forcer à 1, sinon on boucle */
        else
        {
         if (!(new=(PROG *)calloc(sizeof(PROG),1)))
                TraitErreur (FATALERROR, MEMCOMPIL, curlg, curcol);

        if (prg == NULL)
            {
                curprg = new;
                prg = new;
            }
        else
            {
                curprg->next =new;
                curprg = new;
            }
        new->operande = ope;
        new->code = mnemo;
        new->next = NULL;
        pcpc++;          /** Incremente le compteur ordinal **/
        head.codesize++;
        }
}

void Expr(void)
{
        int id;
        int type1, type2;       /* Pour l'analyse semantique et confrontation de types */


        Simple_Exp();
        type1 = lasttokentype;        /* sauve le premier type */
    if ( curtokentype == booleen_mt)
        {
            Lexical();
            id = lasttokenid;         /* Prend l'ancien Id */
            Simple_Exp();
            type2 = lasttokentype;   /* sauve le second type */
        }
    else
        TraitErreur(TEXTERROR, NOBOOL, curlg, curcol);

/* Compatibilité des types */
        switch (id)        /** Attention cmp de chaine non implementees **/
        {
            case egal_b:
   /*           printf("type1=%d type2=%d\tstr=%d\tconst=%d\n",type1, type2,string_t, conststr_mt); */
if ((type1 == type2 && (type2 == string_t || type2 == conststr_mt)) ||
    type1==string_t && type2==conststr_mt)
                Code(EQU_STR,0);
             else
                 Code(EQU,0);    break;
                case pluspetit_b:
                        Code(LT,0);     break;
                case plusgrand_b:
                        Code(GT,0);     break;
                case pluspetitegal_b:
                        Code(LE,0);     break;
                case plusgrandegal_b:
                        Code(GE,0);     break;
                case different_b:
                        Code(NE,0);     break;
                case et_b:
                        Code(AND,0);    break;
                case ou_b:
                        Code(OR,0);     break;
                case ouex_b:
                        Code(XOR,0);    break;
                case non_b:
                        Code(NOT,0);    break;
                case in_b:
                        Code(IN,0);     break;
                default:
                     printf("*** Erreur ID booleen EXPR \n");
                                                                                                                End(); exit(); break;
                }
}

void Facteur(void)
{
        int id; /**Pile **/

       if ( *curtoken == '(' && curtokentype == separ_mt)
           {
            Lexical();
            Simple_Exp();           /*** Appel recursif ***/
            if ( *curtoken == ')' )
            Lexical();
            else
            TraitErreur(TEXTERROR, NOPF, curlg, curcol);
           }
        else
  {
        if (curtokentype == constchr_mt || curtokentype == constreal_mt ||
                curtokentype == constint_mt ||  curtokentype == conststr_mt )
          InsConst();
        else
        if (curtokentype == ident_mt)
                {
              facttype=TestVar( TRUE); /* Met adr in stack, et valeur */
                }
        else
        if (curtokentype = math_mt)
        {
            id = curtokenid;
            Lexical();
            if ( *curtoken == '(' )
             {
                Lexical();
                Simple_Exp();           /*** Appel recursif ***/
                if ( *curtoken == ')' )
                    Lexical();
                else
                    TraitErreur(TEXTERROR, NOPF, curlg, curcol);
             }
            else
               TraitErreur( TEXTERROR, NOPO, curlg, curcol);

            switch (id)
             {
                case abs_m:     Code (ABS,0); break;
                case atan_m:    Code (ATAN, 0); break;
                case acos_m:    Code (ACOS, 0); break;
                case asin_m:    Code (ASIN, 0); break;
                case cosh_m:    Code (COSH, 0); break;
                case sinh_m:    Code (SINH, 0); break;
                case tanh_m:    Code (TANH, 0); break;
                case cos_m:     Code (COS, 0); break;
                case sin_m:     Code (SIN, 0); break;
                case tan_m:     Code (TAN, 0); break;
                case exp_m:     Code (EXP, 0); break;
                case frac_m:    Code (FRAC, 0); break;
                case int_m:     Code (INT, 0); break;
                case ln_m:      Code (LN, 0); break;
                case sqr_m:     Code (SQR, 0); break;
                case sqrt_m:    Code (SQRT, 0); break;

                case odd_m:    Code (ODD, 0); break;
                case even_m:   Code (EVEN, 0); break;
                case pred_m:   Code (PRED, 0); break;
                case succ_m:   Code (SUCC, 0); break;
                case inv_m:    Code (INV, 0); break;
                case rnd_m:    Code (RND, 0); break;

/*                case sizeof_m:    Code (SIZEOF, 0); break;
                case lenght_m:    Code (LENGHT, 0); break;
                case round_m:    Code (ROUND, 0); break;
                case log_m:    Code (LOG, 0); break;
                case pwroften_m:    Code (PWROFTEN, 0); break;

  */
             }
        }
        else
        if (curtokentype == extern_mt)
        {
            id = curtokenid;
            AnalyseExtern();
        }
        else            /** Si ce n'est pas une fct Math, extern **/
          {
            if (*curtoken == '(' )
                {
                 Lexical();
                 Simple_Exp();   /** Appel recursif **/
                 if ( *curtoken == ')')
                    Lexical();
                 else
                    TraitErreur(TEXTERROR, NOPF, curlg, curcol);
                }
            else
                TraitErreur( TEXTERROR, NOPO, curlg, curcol);
          }
  }
}

void Terme(void)
{
        int id; /** Pile **/

        Facteur();
        while (curtokenid == fois_o || curtokenid == divise_o
               || curtokenid ==  mod_o || curtokenid == et_b
               || curtokenid ==  ouex_b || curtokenid == div_o)
        {
                id = curtokenid;
                Lexical();
                Facteur();
                switch(id)
                    {
                        case fois_o     :  Code (MULS, 0);break;
                        case divise_o   :  Code (DIVS,0); break;
                        case et_b      :  Code (AND,0); break;
                        case mod_o      :  Code (MOD,0); break;
                        case div_o      :  Code (DIV,0); break;
                        case ouex_b      :  Code (XOR,0); break;
                    }
        }
}

void Simple_Exp(void)   /*** Compilation des expressions mathematiques ***/
{
        int id; /**Pile**/

        if (curtokenid == plus_o || curtokenid == moins_o)
        {
                id = curtokenid;        /** sauve la valeur **/
                Lexical();
                Terme();

                if (id == moins_o)
                        Code (NEG, 0);
        }
        else
                Terme();
        while (curtokenid == plus_o || curtokenid == moins_o
                || curtokenid == ou_b)
        {
                id= curtokenid;
                Lexical();
                Terme();
                if ( id == plus_o)
                        Code (ADD, 0);
                else
                if ( id == ou_b)
                        Code (OR, 0);
                else
                        Code (SUB, 0);
        }
}

void Instruction(void)
{
    switch (curtokenid)
        {
        case begin_f:
            Bloc();   break;   /** Appel recursif **/
        case while_f:
            while_fct();   break;
        case repeat_f:
            repeat_fct();  break;
        case if_f:
            if_fct();      break;
        case read_fio:
            Lexical();
            read_fct();    break;
        case write_fio:
            Lexical();
            write_fct();   break;
        case readln_fio:
            readln_fct();  break;
        case writeln_fio:
            writeln_fct(); break;
        case inclib_fio:
            inclib_fct(TRUE); break;
        case extern_mt:
            AnalyseExtern(); break;
        case ident_mt:
            Assign();      break;
        default:
            if ( curtokenid != end_f && curtokenid !=until_f)
                {
                printf("Instruction %d (%s) non reconnue.\n", curtokenid, curtoken);
                End(); exit();
               }
            break;
       }
}
void Bloc(void)              /* BLOC d'instructions */
{
    if (curtokenid == begin_f)
        {
            Lexical();
            Instruction();     /** Gestion des ordres Pascal **/

            while( *curtoken == ';')
                {
                    Lexical();
                    Instruction();
                }
            if (curtokenid != end_f )          /* End */
                TraitErreur( TEXTERROR, NOEND, curlg, curcol);
            else
                Lexical();
        }
    else
        TraitErreur(TEXTERROR, NOBEGIN, curlg, curcol);
}

void BlocFct(void)              /* BLOC d'une Fonction */
{
        if (curtokenid == procedure_f)
                Procedure();
        if (curtokenid == function_f)
                Fonction();

        if (curtokenid == var_f)
                Gere_Variable();
if (curfct==0) Code(LOADORG, debut);         /* Marque le debut du prg */
        if (curtokenid == begin_f)
                {
                        Lexical();
                        Instruction();     /** Gestion des ordres Pascal **/

                        while( *curtoken == ';')
                        {
                                Lexical();
                                Instruction();
                        }
                        if (curtokenid != end_f )               /* End */
                                TraitErreur( TEXTERROR, NOEND, curlg, curcol);
                        else
                                Lexical();
                }
        else
                TraitErreur(TEXTERROR, NOBEGIN, curlg, curcol);
}

void Compiler(void)
{
    Lexical();
    while (curtokenid == inclib_fio)
        inclib_fct(FALSE);
    if (curtokenid != program_f)
        TraitErreur(TEXTERROR, NOPRG,curlg, curcol);
    Lexical();
    if ( curtokentype != ident_mt )
        TraitErreur(TEXTERROR, NOIDENT,curlg, curcol);
    Lexical();
    if ( *curtoken != ';')
        TraitErreur(TEXTERROR, NOVIRG,curlg, curcol);
    Lexical();
    while (curtokenid == inclib_fio)
        inclib_fct(FALSE);
    Code (BRA, debut);          /* Anticipe un saut au Bloc Principal */
    BlocFct();
    if ( *curtoken != '.')
        TraitErreur(TEXTERROR, NOPOINT, curlg, curcol);
    Code (RTS,0);
    Lexical();
    if (dismode) Dis();
    WriteCode();
}