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
        #include "include\\cleobis.h"
        #include "include\\libs.h"
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
#endif

extern BOOL dismode;
extern char *TxtFileName;
extern char *CodeFileName;
extern char *ErrorFileName;
extern char curtoken[];
extern FILE *ErrorF;
extern Erreur Erreurs[];
extern Erreur Avertis[];
extern FILE *CodeF;
extern FILE *TxtF;
extern char *Txt;
extern int *Adress;
extern CONST *symb;
extern VAR *var;
extern PROG *prg;
extern FCTLIB *extfct;
extern int ExecMode;
extern long AdressSize;
extern long TextSize;
extern long SymbolSize;

/******************** Fonctions de configuration *******************/

void ReadArg(int arc, char **arv)
{
  arc -= 1;  arv += 1;

if ((*arv)[0] == '-' && (*arv)[1] == 'v' || (*arv)[1] == 'V')
    {
    printf("\tAll Coding by DIALLO Barrou, special thanks to:\n\t\tFranck Diard, Christophe Lambert\n\t\tand my 'Bignome' Florent Dolidon their moral help!\n");
    End(); exit();
    }
        TxtFileName = (char*)calloc(strlen(*arv)+1,1);
        strcpy(TxtFileName,arv[0]);
  arc -= 1;  arv += 1;

  while (arc > 0 && (*arv)[0] == '-')
    {

      switch ((*arv)[1])
        {
        case 'O':
        case 'o':
            CodeFileName= (char*)strdup(*arv+2);
            break;
        case 'A':
        case 'a':   dismode=TRUE; break;
        default:
            printf(" Option inconnue '%c%c'\n",(*arv)[0],(*arv)[1]);
          break;
        }
      arc -= 1;
      arv += 1;
    }
if (!CodeFileName)
    {
    CodeFileName= (char*)strdup(DEFAULT_OUT);
    TraitErreur(WARNING, LESSARGS,0,0);
    }
if (arc != 0)
    {
      TraitErreur(RECERROR , BADARGS,0,0);
      printf("Usage: %s Source [-oDest]\n",NAME);
      exit(2);
    }
}

void Intro()
{
    printf("Cleobis Language\tVersion %d.%d\n\t(C)opyright July 1992 by DIALLO Barrou\n\n",VERSION, SUBVERSION);
}

void TraitErreur(char type, int num, int lig, int col)
{
    BOOL fat=FALSE;

    switch(type)
    {
    case WARNING:
        if (ErrorF==NULL)
            printf("** Avertissement %d, %s...\n", Avertis[num].num, Avertis[num].msg);
        else
            fprintf(ErrorF,"** Avertissement %d, %s...\n", Avertis[num].num, Avertis[num].msg);
        break;
    case FATALERROR:
        fat=TRUE;
    case RECERROR:
        if (ErrorF==NULL)
            printf("** Erreur %d, %s\n", Erreurs[num].num, Erreurs[num].msg);
        else
            fprintf(ErrorF,"** Erreur %d, %s\n", Erreurs[num].num, Erreurs[num].msg);
        if (fat)
            { End(); exit(num); }
        else break;
    case TEXTERROR:
        if (!ErrorF)
                                printf ("L:%d   C:%d ",lig,col);
        else
                                fprintf (ErrorF,"L:%d C:%d\t",lig,col);
                  printf("*** Erreur %d, <%s> %s\n", Erreurs[num].num, curtoken, Erreurs[num].msg);
                  switch(num)
        {
            case GUILLE:
                 printf("*** Erreur %d, %s\n", Erreurs[num].num, Erreurs[num].msg);
                break;
            case SYNTAX:
                break;
            case BADTYPE:
                break;
            default:
                break;
        }
        End(); exit(num);
        break;
     default:
        break;
    }
}

void FreeProg(void)
{
    PROG *list, *list1;

        list = prg; list1= list->next;
        while (list)
        {
                cfree(list);
                list=list1;
                list1=list1->next;
        }
}

void FreeConst(void)
{
    CONST *list, *list1;

        list = symb; list1= list->next;
        while (list)
        {
                cfree(list);
                list=list1;
                list1=list1->next;
        }
}

void FreeVars(void)
{
    VAR *list, *list1;

        list = var; list1= list->next;
        while (list)
        {
                cfree(list);
                list=list1;
                list1=list1->next;
        }
}

void FreeExternFct(void)
{
    FCTLIB *list = extfct, *list1;

    list1= list->next;
    while (list)
        {
           if (list->type) cfree(list->type);
           cfree(list);
           list=list1;
           list1=list1->next;
        }
}

void End(void)
{
    if (ErrorF!=NULL) fclose(ErrorF);
         if (CodeF!=NULL)    fclose(TxtF);
         if (ErrorF != NULL) fclose(ErrorF);
         if (Txt!=NULL)      cfree(Txt);
         if (Adress!=NULL)   cfree(Adress);
         if (symb != NULL)   FreeConst();
         if (var != NULL)    FreeVars();
         if (prg != NULL)    FreeProg();
         if (extfct != NULL) FreeExternFct();
}

BOOL Alloue(void )
{
    if (!(Adress = (int *)calloc(AdressSize,sizeof(int))))
      {
          TraitErreur(RECERROR,MEMCOMPIL,0,0);
          return(FALSE);
      }
    return(TRUE);
}

BOOL Begin()
{
         if (!Alloue()) {End(); return(FALSE); }
         if (!Ouvre()) { End(); return(FALSE); }

    return(TRUE);
}

void Dis(void)
{
        PROG *list=prg;
        int n=0;

                  while (list != NULL)
                  {
                  switch (list->code)
                  {
        case PADR_CHR: printf("%d PADR_CHR %d\n", n, list->operande);
                break;
        case PADR_INT: printf("%d PADR_INT %d\n", n, list->operande);
                break;
        case PADR_LINT: printf("%d PADR_LINT %d\n", n, list->operande);
                break;
        case PADR_REAL: printf("%d PADR_REAL %d\n", n, list->operande);
                break;
        case PADR_LREAL: printf("%d PADR_LREAL %d\n", n, list->operande);
                break;
        case PADR_STR: printf("%d PADR_STR %d\n", n, list->operande);
                break;
        case PADR_BOOL: printf("%d PADR_BOOL %d\n", n, list->operande);
                break;
        case PADR_ARRAY: printf("%d PADR_ARRAY %d\n", n, list->operande);
                break;
        case PADR_P2D: printf("%d PADR_P2D %d\n", n, list->operande);
                break;
        case PADR_P3D: printf("%d PADR_P3D %d\n", n, list->operande);
                break;
        case PADR_RGB: printf("%d PADR_RGB %d\n", n, list->operande);
                break;

        case PVAL_CHR: printf("%d PVAL_CHR %d\n", n, list->operande);
                break;
        case PVAL_INT: printf("%d PVAL_INT %d\n", n, list->operande);
                break;
        case PVAL_REAL: printf("%d PVAL_REAL %d\n",n, list->operande);
                break;
        case PVAL_STR: printf("%d PVAL_STR %d\n", n, list->operande);
                break;

        case PMEM_CHR: printf("%d PMEM_CHR\n", n);
                break;
        case PMEM_INT: printf("%d PMEM_INT\n", n);
                break;
        case PMEM_LINT: printf("%d PMEM_LINT\n", n);
                break;
        case PMEM_REAL: printf("%d PMEM_REAL\n",n);
                break;
        case PMEM_LREAL: printf("%d PMEM_LREAL\n",n);
                break;
        case PMEM_STR: printf("%d PMEM_STR\n", n);
                break;
        case PMEM_BOOL: printf("%d PMEM_BOOL\n", n);
                break;
        case PMEM_ARRAY: printf("%d PMEM_ARRAY\n",n);
                break;
        case PMEM_P2D: printf("%d PMEM_P2D\n",n);
                break;
        case PMEM_P3D: printf("%d PMEM_P3D\n",n);
                break;
        case PMEM_RGB: printf("%d PMEM_RGB\n",n);
                break;

        case PMEM_P2D_ALL: printf("%d PMEM_P2D_ALL\n",n);
                break;
        case PMEM_P3D_ALL: printf("%d PMEM_P3D_ALL\n",n);
                break;
        case PMEM_RGB_ALL: printf("%d PMEM_RGB_ALL\n",n);
                break;

        case STM_CHR: printf("%d STM_CHR\n", n);
                break;
        case STM_INT: printf("%d STM_INT\n", n);
                break;
        case STM_LINT: printf("%d STM_LINT\n", n);
                break;
        case STM_REAL: printf("%d STM_REAL\n",n);
                break;
        case STM_LREAL: printf("%d STM_LREAL\n",n);
                break;
        case STM_STR: printf("%d STM_STR\n", n);
                break;
        case STM_BOOL: printf("%d STM_BOOL\n", n);
                break;
        case STM_ARRAY: printf("%d STM_ARRAY\n",n);
                break;
        case STM_P2D: printf("%d STM_P2D\n",n);
                break;
        case STM_P3D: printf("%d STM_P3D\n",n);
                break;
        case STM_RGB: printf("%d STM_RGB\n",n);
                break;

        case DIVS: printf("%d DIVS\n",n);
                break;
        case MULS: printf("%d MULS\n",n);
                break;
        case ADD: printf("%d ADD\n",n);
                break;
        case SUB: printf("%d SUB\n",n);
                break;
        case NEG: printf("%d NEG\n",n);
                break;
        case MOD: printf("%d MOD\n",n);
                break;
        case EQU: printf("%d EQU\n",n);
                break;
        case LT: printf("%d LT\n",n);
                break;
        case GT: printf("%d GT\n",n);
                break;
        case LE: printf("%d LE\n",n);
                break;
        case GE: printf("%d GE\n",n);
                break;
        case NE: printf("%d NE\n",n);
                break;
        case AND: printf("%d AND\n",n);
                break;
        case OR: printf("%d OR\n",n);
                break;
        case XOR: printf("%d XOR\n",n);
                break;
        case NOT: printf("%d NOT\n",n);
                break;
        case IN: printf("%d IN\n",n);
                break;
        case EQU_STR: printf("%d EQU_STR\n",n);
                break;
        case LT_STR: printf("%d LT_STR\n",n);
                break;
        case GT_STR: printf("%d GT_STR\n",n);
                break;
        case LE_STR: printf("%d LE_STR\n",n);
                break;
        case GE_STR: printf("%d GE_STR\n",n);
                break;

        case BNE: printf("%d BNE %d\n",n, Adress[list->operande]);
                break;
        case BRA: printf("%d BRA %d\n",n, Adress[list->operande]);
                break;

        case PRSTR: printf("%d PRSTR\n",n);
                break;
        case PRVSTR: printf("%d PRVSTR\n",n);
                break;
        case PRCHR: printf("%d PRCHR\n",n);
                break;
        case PRINT: printf("%d PRINT\n",n);
                break;
        case PRINTCHR: printf("%d PRINTCHR\n",n);
                break;
        case CHR13: printf("%d CHR13\n",n);
                break;
        case READ: printf("%d READ\n",n);
                break;

        case ABS: printf("%d ABS\n",n);
                break;
        case ATAN: printf("%d ATAN\n",n);
                break;
        case ACOS: printf("%d ACOS\n",n);
                break;
        case ASIN: printf("%d ASIN\n",n);
                break;
        case COSH: printf("%d COSH\n",n);
                break;
        case SINH: printf("%d SINH\n",n);
                break;
        case COS: printf("%d COS\n",n);
                break;
        case SIN: printf("%d SIN\n",n);
                break;
        case EXP: printf("%d EXP\n",n);
                break;
        case FRAC: printf("%d FRAC\n",n);
                break;
        case INT: printf("%d INT\n",n);
                break;
        case LN: printf("%d LN\n",n);
                break;
        case SQR: printf("%d SQR\n",n);
                break;
        case SQRT: printf("%d SQRT\n",n);
                break;
        case RTS: printf("%d RTS\n", n);
                break;
        case PUSHVAL: printf("%d PUSHVAL %d\n", n, list->operande);
                break;
        case LIBRARY: printf("%d LIBRARY %d\n", n, list->operande);
                break;
        }
        list = list->next;
        n++;
        }
}