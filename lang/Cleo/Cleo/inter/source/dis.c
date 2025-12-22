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
#include <stdio.h>

extern PRG *prg;
extern Entete head;

void Dis(void)
{
    int p=0;

          while ( /*prg[p].code != RTS && */p< head.codesize)
                  {
                  switch (prg[p].code)
                  {
        case PADR_CHR: printf("%d PADR_CHR %d\n", p, prg[p].operande);
                break;
        case PADR_INT: printf("%d PADR_INT %d\n", p, prg[p].operande);
                break;
        case PADR_LINT: printf("%d PADR_LINT %d\n", p, prg[p].operande);
                break;
        case PADR_REAL: printf("%d PADR_REAL %d\n", p, prg[p].operande);
                break;
        case PADR_LREAL: printf("%d PADR_LREAL %d\n", p, prg[p].operande);
                break;
        case PADR_STR: printf("%d PADR_STR %d\n", p, prg[p].operande);
                break;
        case PADR_BOOL: printf("%d PADR_BOOL %d\n", p, prg[p].operande);
                break;
        case PADR_ARRAY: printf("%d PADR_ARRAY %d\n", p, prg[p].operande);
                break;
        case PADR_P2D: printf("%d PADR_P2D %d\n", p, prg[p].operande);
                break;
        case PADR_P3D: printf("%d PADR_P3D %d\n", p, prg[p].operande);
                break;
        case PADR_RGB: printf("%d PADR_RGB %d\n", p, prg[p].operande);
                break;

        case PVAL_CHR: printf("%d PVAL_CHR %d\n", p, prg[p].operande);
                break;
        case PVAL_INT: printf("%d PVAL_INT %d\n", p, prg[p].operande);
                break;
        case PVAL_REAL: printf("%d PVAL_REAL %d\n", p, prg[p].operande);
                break;
        case PVAL_STR: printf("%d PVAL_STR %d\n", p, prg[p].operande);
                break;

        case PMEM_CHR: printf("%d PMEM_CHR\n", p);
                break;
        case PMEM_INT: printf("%d PMEM_INT\n", p);
                break;
        case PMEM_LINT: printf("%d PMEM_LINT\n", p);
                break;
        case PMEM_REAL: printf("%d PMEM_REAL\n", p);
                break;
        case PMEM_LREAL: printf("%d PMEM_LREAL\n", p);
                break;
        case PMEM_STR: printf("%d PMEM_STR\n", p);
                break;
        case PMEM_BOOL: printf("%d PMEM_BOOL\n", p);
                break;
        case PMEM_ARRAY: printf("%d PMEM_ARRAY\n", p);
                break;
        case PMEM_P2D: printf("%d PMEM_P2D\n",p);
                break;
        case PMEM_P3D: printf("%d PMEM_P3D\n",p);
                break;
        case PMEM_RGB: printf("%d PMEM_RGB\n",p);
                break;

        case PMEM_P2D_ALL: printf("%d PMEM_P2D_ALL\n",p);
                break;
        case PMEM_P3D_ALL: printf("%d PMEM_P3D_ALL\n",p);
                break;
        case PMEM_RGB_ALL: printf("%d PMEM_RGB_ALL\n",p);
                break;


        case STM_CHR: printf("%d STM_CHR\n", p);
                break;
        case STM_INT: printf("%d STM_INT\n", p);
                break;
        case STM_LINT: printf("%d STM_INT\n", p);
                break;
        case STM_REAL: printf("%d STM_REAL\n", p);
                break;
        case STM_LREAL: printf("%d STM_LREAL\n", p);
                break;
        case STM_STR: printf("%d STM_STR\n", p);
                break;
        case STM_BOOL: printf("%d STM_BOOL\n", p);
                break;
        case STM_ARRAY: printf("%d STM_ARRAY\n", p);
                break;
        case STM_P2D: printf("%d STM_P2D\n",p);
                break;
        case STM_P3D: printf("%d STM_P3D\n",p);
                break;
        case STM_RGB: printf("%d STM_RGB\n",p);
                break;

        case DIVS: printf("%d DIVS\n", p);
                break;
        case MULS: printf("%d MULS\n", p);
                break;
        case ADD: printf("%d ADD\n", p);
                break;
        case SUB: printf("%d SUB\n", p);
                break;
        case NEG: printf("%d NEG\n", p);
                break;
        case EQU: printf("%d EQU\n", p);
                break;
        case LT: printf("%d LT\n", p);
                break;
        case GT: printf("%d GT\n", p);
                break;
        case LE: printf("%d LE\n", p);
                break;
        case GE: printf("%d GE\n", p);
                break;
        case NE: printf("%d NE\n", p);
                break;
        case AND: printf("%d AND\n", p);
                break;
        case MOD: printf("%d MOD\n", p);
                break;
        case OR: printf("%d OR\n", p);
                break;
        case XOR: printf("%d XOR\n", p);
                break;
        case NOT: printf("%d NOT\n", p);
                break;
        case IN: printf("%d IN\n", p);
                break;
        case EQU_STR: printf("%d EQU_STR\n", p);
                break;
        case LT_STR: printf("%d LT_STR\n", p);
                break;
        case GT_STR: printf("%d GT_STR\n", p);
                break;
        case LE_STR: printf("%d LE_STR\n", p);
                break;
        case GE_STR: printf("%d GE_STR\n", p);
                break;

        case BNE: printf("%d BNE %d\n", p, prg[p].operande);
                break;
        case BRA: printf("%d BRA %d\n", p, prg[p].operande);
                break;

        case PRSTR: printf("%d PRSTR\n", p);
                break;
        case PRVSTR: printf("%d PRVSTR\n",p);
                break;
        case PRCHR: printf("%d PRCHR\n", p);
                break;
        case PRINT: printf("%d PRINT\n", p);
                break;
        case PRINTCHR: printf("%d PRINTCHR\n", p);
                break;
        case CHR13: printf("%d CHR13\n", p);
                break;
        case READ: printf("%d READ\n", p);
                break;

        case ABS: printf("%d ABS\n", p);
                break;
        case ATAN: printf("%d ATAN\n", p);
                break;
        case ACOS: printf("%d ACOS\n", p);
                break;
        case ASIN: printf("%d ASIN\n", p);
                break;
        case COSH: printf("%d COSH\n", p);
                break;
        case SINH: printf("%d SINH\n", p);
                break;
        case COS: printf("%d COS\n", p);
                break;
        case SIN: printf("%d SIN\n", p);
                break;
        case EXP: printf("%d EXP\n", p);
                break;
        case FRAC: printf("%d FRAC\n", p);
                break;
        case INT: printf("%d INT\n", p);
                break;
        case LN: printf("%d LN\n", p);
                break;
        case SQR: printf("%d SQR\n", p);
                break;
        case SQRT: printf("%d SQRT\n", p);
                break;
        case RTS: printf("%d RTS\n", p);
                break;
        case PUSHVAL: printf("%d PUSHVAL %d\n", p, prg[p].operande);
                break;
        case LIBRARY: printf("%d LIBRARY %d\n", p, prg[p].operande);
                break;
        }
        p++;
        }
}
