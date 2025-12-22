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

extern PRG *prg;
extern MY_CONST *stack;
extern int stsz;
extern Erreur ExecErrs[];
extern int st;
extern int lastcode;
extern Entete head;
extern EXTLIB *lib;

extern char *Char;
extern long *Int;
extern double *Real;
extern char **String;

extern char *Vchar;
extern unsigned char *Vboolean;
extern int  *Vinteger;
extern double *Vreal;
extern long  *Vlongint;
extern double *Vlongreal;
extern char **Vstring;
extern TAB *Varray;
extern Point3d *Vpoint3d;
extern Point2d *Vpoint2d;
extern Rgb *Vrgb;

extern double regReal,regReal2, regReal3, regReal4;
extern double Val[];


int FindLibFct(int node, double id)
{
    register int n=0, trouve=0;

    while (n < head.nbrefctlib && !trouve)
        {
            if (lib[n].node == node && lib[n].id == id)
                trouve++;
            else
                n++;
        }
    if (trouve)
        return (n);
}

void Error(int num)
{
    printf("** Erreur %d, %s\n", ExecErrs[num].num, ExecErrs[num].msg);
    EndInter();
}

void InputVal(void )
{
    int val, val2;

    val= (int)PopReal();
    fflush(stdin);
    switch(lastcode)
        {
        case PADR_CHR:
           Vchar[val]=0;
           scanf("%c", &Vchar[val] );
           break;
        case PADR_INT:
/*           Vinteger[val]=0; */
           scanf("%d", &Vinteger[val] );
           break;
        case PADR_LINT:
           Vlongint[val]=0;
           scanf("%ld", &Vlongint[val] );
           break;
        case PADR_REAL:
           Vreal[ (int)val ]=0;
           scanf("%lG", &Vreal[val] );    /* lG */
           break;
        case PADR_LREAL:
           Vlongreal[val]=0;
           scanf("%lG", &Vlongreal[val] );
           break;
        case PADR_STR:
           scanf("%255s", Vstring[val] );
           break;
        case PADR_BOOL:
           Vboolean[val]=0;
           scanf("%c", &Vboolean[val] );
           break;
        case PVAL_INT:              /* last code = index du ADR_ARRAY */
            val2= (int)PopReal();
            switch( Varray[val2 ].tab.type)   /* selon le type */
            {
             case integer_t:
                scanf("%d",&Varray[val2 ].buf.buf_int[val]);
                break;
             case real_t:
                scanf("%lG",&Varray[val2 ].buf.buf_real[val]);
                break;
             case char_t:
             fflush(stdout); fflush(stdin);
                Varray[val2 ].buf.buf_char[val] = (char)getchar();
                break;
             case boolean_t:
                Varray[val2 ].buf.buf_bool[val] = (char)getchar();
                break;
            }
            break;
      }
}

void PrintVal(void )
{
    fflush(stdout);
    printf("%g", PopReal() ) ;
}

void PrintStr(void )
{
    fflush(stdout);
    printf("%s", String[ (int)PopReal()] ) ;

}
void PrintVStr(void )
{
    fflush(stdout);
    printf("%s", Vstring[ (int)PopReal()] ) ;

}

void PrintChr(void )
{
    fflush(stdout);
    printf("%c", (char)PopReal() ) ;

}



void Inter(void)
{
    register int pc =0, ope=0;
    char fin=0;
    int str1_type, str1_adr;
    int str2_type, str2_adr;
    char *str1, *str2;
    int infofct;

    while (prg[pc].code != RTS && !fin)
    {
        ope = prg[pc].operande;
        switch( prg[pc].code)
        {
        case PVAL_CHR:           /* Push Val N;  Met la Const N dans la pile */
            PushReal(*(Char+ope));
            stack[st-1].type = char_cadr; break;
        case PVAL_INT:
            PushReal(*(Int+ope));
            stack[st-1].type = integer_cadr; break;
        case PVAL_REAL:
            PushReal(*(Real+ope));
            stack[st-1].type = real_cadr; break;
        case PVAL_STR:
            PushReal(ope);
            stack[st-1].type = string_cadr; break;


        case PADR_CHR:              /* Push l'adr de la var N sur la pile */
            PushReal(ope);
            stack[st-1].type = char_adr; break;
        case PADR_INT:
            PushReal(ope);
            stack[st-1].type = integer_adr; break;
        case PADR_LINT:
            PushReal(ope);
            stack[st-1].type = longint_adr; break;
        case PADR_REAL:
            PushReal(ope);
            stack[st-1].type = real_adr; break;
        case PADR_LREAL:
            PushReal(ope);
            stack[st-1].type = longreal_adr; break;
        case PADR_STR:
            PushReal(ope);
            stack[st-1].type = string_adr; break;
        case PADR_BOOL:
            PushReal(ope);
            stack[st-1].type = boolean_adr; break;
        case PADR_ARRAY:
            PushReal(ope);
            stack[st-1].type = array_adr; break;
        case PADR_P2D:
            PushReal(ope);
            stack[st-1].type = point2d_adr; break;
        case PADR_P3D:
            PushReal(ope);
            stack[st-1].type = point3d_adr; break;
        case PADR_RGB:
            PushReal(ope);
            stack[st-1].type = rgb_adr; break;


        case PMEM_CHR:    /*charge la val de la var dont l'adr est in pile */
            PushReal( Vchar[(int)PopReal()]);
            stack[st-1].type = char_t; break;
        case PMEM_INT:
            PushReal(Vinteger[(int)PopReal()]);
            stack[st-1].type = integer_t; break;
        case PMEM_LINT:
            PushReal(Vlongint[(int)PopReal()]);
            stack[st-1].type = longint_t; break;
        case PMEM_REAL:
            PushReal(Vreal[(int)PopReal()]);
            stack[st-1].type = real_t; break;
        case PMEM_LREAL:
            PushReal(Vlongreal[(int)PopReal()]);
            stack[st-1].type = longreal_t; break;
        case PMEM_BOOL:
            PushReal(Vboolean[(int)PopReal()]);
            stack[st-1].type = boolean_t; break;

        case PMEM_ARRAY:
            regReal = PopReal();             /* index ?*/
            if ( regReal <0.0)     /* Non, tab de struct !!! */
            {
                regReal2 = regReal;       /* recopie indice du champ*/
                regReal  = PopReal();     /* index */
                regReal3  = PopReal();    /* No tab */
                switch( Varray[(int)regReal3 ].tab.type)   /* selon le type */
                {
                  case point3d_t:
                    switch( (int)-regReal2-1)      /* selon le champs de la struct */
                    {
                    case 0:
                        PushReal(Varray[(int)regReal3 ].buf.buf_p3d[(int)regReal].x); break;
                    case 1:
                        PushReal(Varray[(int)regReal3 ].buf.buf_p3d[(int)regReal].y); break;
                    case 2:
                        PushReal(Varray[(int)regReal3 ].buf.buf_p3d[(int)regReal].z); break;
                    }
                    break;
                  case point2d_t:
                    switch( (int)-regReal2-1)      /* selon le champs de la struct */
                    {
                    case 0:
                        PushReal(Varray[(int)regReal3 ].buf.buf_p2d[(int)regReal].x); break;
                    case 1:
                        PushReal(Varray[(int)regReal3 ].buf.buf_p2d[(int)regReal].y); break;
                    }
                    break;
                  case rgb_t:
                    switch( (int)-regReal2-1)      /* selon le champs de la struct */
                    {
                    case 0:
                        PushReal(Varray[(int)regReal3 ].buf.buf_rgb[(int)regReal].r); break;
                    case 1:
                        PushReal(Varray[(int)regReal3 ].buf.buf_rgb[(int)regReal].g); break;
                    case 2:
                        PushReal(Varray[(int)regReal3 ].buf.buf_rgb[(int)regReal].b); break;
                    }
                    break;

                }
            }
          else
          {
            regReal2 = PopReal();   /* Numero du Tab*/

            switch( Varray[(int)regReal2 ].tab.type)   /* selon le type */
            {
             case integer_t:
                PushReal(Varray[(int)regReal2 ].buf.buf_int[(int)regReal]);
                break;
             case real_t:
                PushReal(Varray[(int)regReal2 ].buf.buf_real[(int)regReal]);
                break;
             case char_t:
                PushReal(Varray[(int)regReal2 ].buf.buf_char[(int)regReal]);
                break;
             case boolean_t:
                PushReal(Varray[(int)regReal2 ].buf.buf_bool[(int)regReal]);
                break;
            }
      } /* else */
      stack[st-1].type = array_t;
      break;

       case PMEM_P3D_ALL:
                regReal = PopReal();      /* No de la structure */
                PushReal(Vpoint3d[ (int) regReal].x);
                PushReal(Vpoint3d[ (int) regReal].y);
                PushReal(Vpoint3d[ (int) regReal].z);
                break;

       case PMEM_P2D_ALL:
                regReal = PopReal();      /* No de la structure */
                PushReal(Vpoint3d[ (int) regReal].x);
                PushReal(Vpoint3d[ (int) regReal].y);
                break;
       case PMEM_RGB_ALL:
                regReal = PopReal();      /* No de la structure */
                PushReal(Vrgb[ (int)regReal].r);
                PushReal(Vrgb[ (int)regReal].g);
                PushReal(Vrgb[ (int)regReal].b);
                break;

       case PMEM_RGB:
            regReal2 = PopReal();     /* Numero du champs*/
            regReal = PopReal();      /* No de la structure */
            switch( (int)regReal2)  /* champs r, g ou b ? */
            {
              case 0:
                PushReal(Vrgb[ (int) regReal].r); break;
              case 1:
                PushReal(Vrgb[ (int) regReal].g); break;
              case 2:
                PushReal(Vrgb[ (int) regReal].b); break;
            }
         stack[st-1].type = rgb_t;
         break;

       case PMEM_P3D:
            regReal2 = PopReal();     /* Numero du champs*/
            regReal = PopReal();      /* No de la structure */
            switch( (int)regReal2)  /* champs x, y ou z ? */
            {
              case 0:
                PushReal(Vpoint3d[ (int) regReal].x); break;
            case 1:
                PushReal(Vpoint3d[ (int) regReal].y); break;
            case 2:
                PushReal(Vpoint3d[ (int) regReal].z); break;
            }
         stack[st-1].type = point3d_t;
         break;

       case PMEM_P2D:
            regReal2 = PopReal(); /* Numero du champs*/
            regReal = PopReal();   /* No de la structure */
            switch( (int)regReal2)  /* champs x ou y ? */
            {
            case 0:
                PushReal(Vpoint2d[ (int) regReal].x); break;
            case 1:
                PushReal(Vpoint2d[ (int) regReal].y); break;
            }
         stack[st-1].type = point2d_t;
         break;


/*        case PMEM_STR:
            PushReal(Vstring[(int)PopReal()]); break;     */

        case PRSTR:
            PrintStr(); break;
        case PRVSTR:
            PrintVStr(); break;
        case PRCHR:
            PrintChr(); break;
        case PRINT:
            PrintVal(); break;
        case PRINTCHR:
            PrintChr(); break;
        case CHR13:
            printf("\n"); break;
        case READ:
            InputVal(); break;

        case STM_CHR:      /*Val in variable dont l'adr est a pile-1*/
             regReal = PopReal();
             Vchar[ (int) PopReal()] = regReal;
             break;
        case STM_INT:
             regReal = PopReal();
             Vinteger[ (int) PopReal()] = regReal;
             break;
        case STM_LINT:
             regReal = PopReal();
             Vlongint[ (int) PopReal()] = regReal;
             break;
        case STM_REAL:
             regReal = PopReal();
             Vreal[ (int)PopReal()] = regReal;
             break;
        case STM_LREAL:
             regReal = PopReal();
             Vlongreal[ (int) PopReal()] = regReal;
             break;
        case STM_BOOL:
             regReal = PopReal();
             Vboolean[ (int) PopReal()] = regReal;
             break;
        case STM_STR:
             regReal = PopReal();   /* Adr du string */
             regReal2 = PopReal();  /* adr de la variable string */
             Vstring[ (int)regReal2 ] = (char *)calloc(MAXSTRING,1);
             if (lastcode== PVAL_STR)  /* c'est une constante */
                strcpy( Vstring[ (int)regReal2 ], String[(int)regReal]);
             else
                strcpy( Vstring[ (int)regReal2 ], Vstring[(int)regReal]);
             break;

        case STM_ARRAY:
             regReal = PopReal();    /* Valeur a mettre */
             regReal2 = PopReal();   /* index du tab ? */
             if ( regReal2 <0.0)
             {
                regReal3 = PopReal();   /* index du tab  */
                regReal4 = PopReal();   /* No du tab  */
                switch( Varray[(int)regReal4 ].tab.type)   /* selon le type */
                {
                case point3d_t:
                    switch ( (int)-regReal2-1)
                    {
                    case 0:
                        Varray[ (int) regReal4 ].buf.buf_p3d[ (int)regReal3 ].x = regReal; break;
                    case 1:
                        Varray[ (int) regReal4 ].buf.buf_p3d[ (int)regReal3 ].y = regReal; break;
                    case 2:
                        Varray[ (int) regReal4 ].buf.buf_p3d[ (int)regReal3 ].z = regReal; break;
                    }
                    break;
                case point2d_t:
                    switch ( (int)-regReal2-1)
                    {
                    case 0:
                        Varray[ (int) regReal4 ].buf.buf_p2d[ (int)regReal3 ].x = regReal;
                    break;
                    case 1:
                        Varray[ (int) regReal4 ].buf.buf_p2d[ (int)regReal3 ].y = regReal;
                    break;
                    }
                    break;
                case rgb_t:
                    switch ( (int)-regReal2-1)
                    {
                    case 0:
                        Varray[ (int) regReal4 ].buf.buf_rgb[ (int)regReal3 ].r = regReal; break;
                    case 1:
                        Varray[ (int) regReal4 ].buf.buf_rgb[ (int)regReal3 ].g = regReal; break;
                    case 2:
                        Varray[ (int) regReal4 ].buf.buf_rgb[ (int)regReal3 ].b = regReal; break;
                    }
                    break;

                 }
           break; /* quit STM case */
             }
             regReal3 = PopReal();   /* numero du tab */

            switch( Varray[(int)regReal3 ].tab.type)   /* selon le type */
            {
             case integer_t:
                Varray[ (int) regReal3 ].buf.buf_int[ (int)regReal2 ] = regReal;
                break;
             case real_t:
                Varray[ (int) regReal3 ].buf.buf_real[ (int)regReal2 ] = regReal;
                break;
             case char_t:
                Varray[ (int) regReal3 ].buf.buf_char[ (int)regReal2 ] = regReal;
                break;
             case boolean_t:
                Varray[ (int) regReal3 ].buf.buf_bool[ (int)regReal2 ] = regReal;
                break;
            }
             break;

        case STM_P3D:
            if (lastcode == PMEM_P3D_ALL)
            {
             *Val = PopReal();       /* z */
             *(Val+1) = PopReal();   /* y */
             *(Val+2) = PopReal();   /* x */
             regReal = PopReal();    /* numero de la structure */

             Vpoint3d[ (int)regReal ].x = Val[2];  /* x */
             Vpoint3d[ (int)regReal ].y = Val[1];  /* y */
             Vpoint3d[ (int)regReal ].z = Val[0];  /* z */
             break;
            }
             regReal = PopReal();    /* Valeur a mettre dans le champs*/
             regReal2 = PopReal();   /* index du champs */
             regReal3 = PopReal();   /* numero de la structure */

             switch((int)regReal2)
             {
             case 0 : Vpoint3d[ (int)regReal3 ].x = regReal; break;  /* x */
             case 1 : Vpoint3d[ (int)regReal3 ].y = regReal; break;  /* y */
             case 2 : Vpoint3d[ (int)regReal3 ].z = regReal; break;  /* z */
             }
             break;

        case STM_P2D:
            if (lastcode == PMEM_P2D_ALL)
            {
             Val[1] = PopReal();   /* y */
             Val[2] = PopReal();   /* x */
             regReal = PopReal();   /* numero de la structure */

             Vpoint3d[ (int)regReal ].x = Val[2];  /* x */
             Vpoint3d[ (int)regReal ].y = Val[1];  /* y */
             break;
            }
             regReal = PopReal();    /* Valeur a mettre dans le champs*/
             regReal2 = PopReal();   /* index du champs */
             regReal3 = PopReal();   /* numero de la structure */

             switch((int)regReal2)
             {
             case 0 : Vpoint2d[ (int)regReal3 ].x = regReal; break;  /* x */
             case 1 : Vpoint2d[ (int)regReal3 ].y = regReal; break;  /* y */
             }
             break;

        case STM_RGB:
            if (lastcode == PMEM_RGB_ALL)
            {
             *Val = PopReal();       /* r */
             *(Val+1) = PopReal();   /* g */
             *(Val+2) = PopReal();   /* b */
             regReal = PopReal();    /* numero de la structure */

             Vrgb[ (int)regReal ].r = Val[2];  /* r */
             Vrgb[ (int)regReal ].g = Val[1];  /* g */
             Vrgb[ (int)regReal ].b = Val[0];  /* b */
             break;
            }
             regReal = PopReal();    /* Valeur a mettre dans le champs*/
             regReal2 = PopReal();   /* index du champs */
             regReal3 = PopReal();   /* numero de la structure */

             switch((int)regReal2)
             {
             case 0 : Vrgb[ (int)regReal3 ].r = regReal; break;  /* r */
             case 1 : Vrgb[ (int)regReal3 ].g = regReal; break;  /* g */
             case 2 : Vrgb[ (int)regReal3 ].b = regReal; break;  /* b */
             }
             break;

        case DIVS :
             regReal = 1/PopReal();
             PushReal(regReal*PopReal()); break;
        case DIV :
             regReal = 1/PopReal();
             PushReal((int)(regReal*PopReal())); break;
        case MOD :
             regReal = PopReal();
             PushReal( ((int)regReal) % ((int)PopReal())); break;
        case MULS :
             PushReal(PopReal()*PopReal()); break;
        case ADD :
             PushReal(PopReal()+PopReal()); break;
        case SUB:
             regReal = -PopReal();
             PushReal(regReal+PopReal()); break;
        case NEG:
             PushReal(-PopReal()); break;

        case EQU:
            if (PopReal()==PopReal())
               PushReal(1);
            else
               PushReal(0);
            break;
        case LT:
            if (PopReal()>PopReal())
               PushReal(1);
            else
               PushReal(0);
            break;

        case GT:
            if (PopReal()<PopReal())
               PushReal(1);
            else
               PushReal(0);
            break;
        case LE:
            if (PopReal()>=PopReal())
               PushReal(1);
            else
               PushReal(0);
            break;
        case GE:
            if (PopReal()<=PopReal())
               PushReal(1);
            else
               PushReal(0);
            break;
        case NE:
            if (PopReal()!=PopReal())
               PushReal(1);
            else
               PushReal(0);
            break;

        case BRA:
            pc  = ope-1; break;
        case BNE:
            if (!PopReal())
                pc  = ope-1;
/*            else
                if ( prg[pc].code != RTS)
                    Error(UNKNOW);                    */
            break;
        case EQU_STR:
            str1_type = stack[st-1].type; str1_adr = PopReal();
            str2_type = stack[st-1].type; str2_adr = PopReal();

            if (str1_type == string_adr)
                str1= (char*) Vstring[str1_adr];
            else
                str1= (char*) String[str1_adr];

            if (str2_type == string_adr)
                str2= (char*) Vstring[str2_adr];
            else
                str2= (char*) String[str2_adr];

            if ( !(strcmp(str1,str2)))
               PushReal(1);
            else
               PushReal(0);
            break;

        case LT_STR:
        case GT_STR:
        case LE_STR:
        case GE_STR:
            break;
        case AND:
             PushReal((int)PopReal() & (int)PopReal()); break;
        case OR:
             PushReal((int)PopReal() | (int)PopReal()); break;
        case XOR:
             PushReal((int)PopReal() ^ (int)PopReal()); break;
        case NOT:
             PushReal(~((int)PopReal())); break;
        case IN:
            break;

        case SQR:       /* a*a */
                regReal = PopReal();
             PushReal(regReal*regReal); break;
        case SQRT:      /* Racine de a */
             PushReal(sqrt(PopReal())); break;
        case ABS:
             PushReal(fabs(PopReal())); break;

        case COS:
             PushReal(cos(PopReal())); break;
        case SIN:
             PushReal(sin(PopReal())); break;
        case TAN:
             PushReal(tan(PopReal())); break;
        case ACOS:
             PushReal(acos(PopReal())); break;
        case ASIN:
             PushReal(asin(PopReal())); break;
        case ATAN:
             PushReal(atan(PopReal())); break;
        case COSH:
             PushReal(cosh(PopReal())); break;
        case SINH:
             PushReal(sinh(PopReal())); break;
        case TANH:
             PushReal(tanh(PopReal())); break;
        case LN:
             PushReal(log(PopReal())); break;
        case EXP:
             PushReal(exp(PopReal())); break;
        case FRAC:
            regReal = PopReal();
            PushReal (regReal-(int)regReal);
            break;
        case INT:
             PushReal( (int)PopReal()); break;

        case ODD:
            regReal = PopReal();
            if (regReal/2.0 == (int)(regReal/2.0))
                PushReal(0.0);
            else PushReal(1.0);
            break;
        case EVEN:
            regReal = PopReal();
            if (regReal/2.0 == (int)(regReal/2.0))
                PushReal(1.0);
            else PushReal(0.0);
            break;
        case PRED:
             PushReal( PopReal()-1); break;
        case SUCC:
             PushReal( PopReal()+1); break;
        case INV:
             PushReal( 1.0/PopReal()); break;
        case RND:             /* not implemented cause UNIX, AMIGA... */
            break;
        case RTS:
            fin=1; break;
        case PUSHVAL:
             PushReal(ope); break;
        case LIBRARY:
            infofct=FindLibFct( ope, PopReal());     /* Trouve la fct de la lib qui correspond */
            break;
    }
    lastcode= prg[pc].code;
    pc++;
    }
  EndInter();
}

