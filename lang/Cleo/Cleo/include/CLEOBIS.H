/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/


#define VERSION 1        /* Version actuelle de Cleobis    */
#define SUBVERSION 0
#define NAME "cleo"             /* Nom de la Version */
#ifdef msdos
        #define DEFAULT_OUT "cleobin\\cleobis.out"   /* Nom du file dest par defaut */
        #define CONFIGFILE "etc\\cleo_int.cfg"
#else
        #define DEFAULT_OUT "cleobin/cleo.out"   /* Nom du file dest par defaut */
        #define CONFIGFILE "etc/cleo_int.cfg"
#endif

#ifdef unix
    #define stricmp Stricmp
#endif

#define MAXSTRING 256           /* Taille maximum d'une chaine Cleobis */

#define SECTDATA "Data Section"
#define SECTCODE "Code Section"
#define SECTLIB "Lib Section"

/* Variables de compilation */

#define RUNNING 0
#define TRACING 1

/*  Redefinition de types */

#define UC unsigned char
#define UL unsigned long

typedef struct {
            char *msg;
            int num;
            } Erreur;

        /************** Type 'Programme Genere' ***************/
typedef struct prog {
                        int code;        /*** code l'instruction ***/
                        int operande;    /*** Operande ***/
                        struct prog *next;
                        } PROG;

        /************** Type Constante Courante ***************/

typedef union {
                char string[MAXSTRING]; /* Compatibilite sizeof > !!! */
                double real;
                long integer;
                char boolean;
                char Char;
                               /* Manque Array */
                } MY_CONST;

    typedef struct {
                int id;
                char *str;
        } FIELDSTRUCT;

     /************** Type des variables Courantes **************/

typedef struct Var {
                int type;               /** enum type de la var **/
                int num;                /** numero de la variable */
                int fct;                /** numero de la fct */
                struct
                 {
                    int borne1, borne2; /* Ensemble de Def */
                    int type;           /* Type du tableau */
                 } tab;                 /** data pour Var Tableau **/
                char str[MAXSTRING];
                struct Var *prev;
                struct Var *next;
                } VAR;

            /******* Types Standard Pascal ******/

typedef enum { separ_mt=0, ident_mt , constint_mt, conststr_mt, constreal_mt,
                constchr_mt, math_mt, reserved_mt, reservedtype_mt,
                fonction_mt, booleen_mt, mathope_mt, boolean_mt,
                extern_mt
             } MY_TYPESID;

typedef enum { program_f =100 , if_f, then_f, else_f, while_f, do_f,
               for_f, repeat_f, until_f, begin_f, end_f, var_f, pp_f,
               to_f, downto_f, of_f, function_f, procedure_f, goto_f,
               fin_f,

               read_fio, readln_fio, write_fio, writeln_fio, /*fwrite_fio, fread_fio, */
               inclib_fio,
               fin_fio,

               abs_m , atan_m, acos_m, asin_m, cosh_m, sinh_m,
               cos_m, sin_m, exp_m, frac_m, int_m, ln_m, sqr_m,
               sqrt_m,
               odd_m, even_m, pred_m, succ_m, inv_m, rnd_m, tan_m, tanh_m,
               fin_m,

               integer_t=200 , real_t, string_t, char_t, const_t,
               boolean_t, array_t, longint_t, longreal_t,
               point2d_t, point3d_t, rgb_t,           /* file_t, */
               fin_t
             } FCTID;

/************** Type Operateur MATH *********/

typedef enum { plus_o =300, moins_o, fois_o, divise_o, mod_o, div_o,
               fin_o
             } MATHOPE;

/************** Type Operateur BOOLEEN *********/

typedef enum { pluspetit_b =320, plusgrand_b,
               pluspetitegal_b, plusgrandegal_b,
               egal_b, different_b,

               et_b, ou_b, ouex_b, non_b, in_b,
               affecte_b,
               fin_b
             } BOOLOPE;

/************** Type Symbol *****************************/

typedef struct tableconst {
             FCTID type;                /* type de la constante   */
             MY_CONST  variable;        /* Valeur de la constante */
             int num;                   /* Numero de la constante */
             struct tableconst *next;    /* Prochaine Constante    */
             } CONST;

/********************* Type MOT *******************/

typedef struct {
                char *str;            /*** Nom de la fonction ***/
                FCTID id;             /*** Id de la fct ***/
               } MOT;

/*********** declaration du type Infini **********/

typedef struct {
    void * ele;         /* element de la suite */
    long len;           /* Longueur de la suite */
    }   Suite;      /* Suite Infinie */


/*********** Structures Operateurs ***********/

typedef struct {
                char *str;      /* chr de l'operateur Math. */
                MATHOPE id;
                } OPE;

typedef struct {
                char *str;      /* chr de l'operateur Booleen */
                BOOLOPE id;
                } BOOLEEN;

typedef struct {
                char *str;
                int id;
                char *type;     /* Tableau de types */
               } FCTN;          /* Fonction à n arguments */


/************** Code des Mnémoniques ******************/

typedef enum {
 RTS=2000,
 PADR_CHR,  /* Push Adr N; ajoute l'adr de la variable N sur la pile */
 PADR_INT,
 PADR_LINT,
 PADR_REAL,
 PADR_LREAL,
 PADR_STR,
 PADR_BOOL,
 PADR_ARRAY,

 PVAL_CHR    ,   /* Push Val N; Met la val de la Const Chr N dans la pile   */
 PVAL_INT    ,   /* Push Val N; Met la val de la Const Int N dans la pile   */
 PVAL_REAL    ,  /* Push Val N; Met la val de la Const Real N dans la pile   */
 PVAL_STR    ,   /* Push Val N; Met l'ADRESSE de la Const String N dans la pile   */

 PMEM_CHR    ,   /* Push Memory; charge la valeur de la var
                                                  dont l'adr est au sommet de la pile  */
 PMEM_INT,
 PMEM_LINT,
 PMEM_REAL,
 PMEM_LREAL,
 PMEM_STR,
 PMEM_BOOL,
 PMEM_ARRAY,        /* 15 */

 STM_CHR,      /* Pop valeur dans la variable dont l'adr est
                                                a l'avant derniere pos de la pile */
 STM_INT,
 STM_LINT,
 STM_REAL,
 STM_LREAL,
 STM_STR,
 STM_BOOL,
 STM_ARRAY,

 DIVS  ,     /************ Operations sur les Valeurs du ********/
 MULS ,      /*            sommet de la pile                    */
 ADD  ,      /*              /, *, +, -, *-1                    */
 SUB  ,      /*                                                 */
 NEG  ,      /***************************************************/

 EQU  ,          /* =    */
 LT  ,           /* <    */
 GT  ,           /* >    */
 LE  ,           /* <=   */
 GE  ,           /* >=   */
 NE,             /* <>   */
 AND,
 OR,
 XOR,
 NOT,
 IN,                 /* 37*/

 EQU_STR  ,         /* =    */
 LT_STR  ,          /* <    */
 GT_STR  ,          /* >    */
 LE_STR  ,          /* <=   */
 GE_STR  ,          /* >=   */

 ORG,              /*  Adresse courante */
 BNE ,      /* N, va à l'adr N si Condition en Fin de pile = 0 =FAUX */
 BRA ,      /* N, Saut sans condition a l'adr N */

 PRSTR   ,    /* Affiche la const chaine dont l'adr est au sommet de la pile */
 PRVSTR   ,    /* Affiche la var chaine ... */
 PRCHR,
 PRINT  ,     /*            l'Entier  ou le Real...*/
 PRINTCHR,
 CHR13  ,     /* Passe a la ligne */
 READ,   /* 50 */

 ABS, ATAN, ACOS, ASIN, COSH, SINH, COS, SIN, EXP, FRAC, INT, LN, SQR, SQRT,
LOADORG,

PADR_P2D, PMEM_P2D, STM_P2D,
PADR_P3D, PMEM_P3D, STM_P3D,
PUSHVAL,                            /* Met une valeur sur la pile */
PMEM_P2D_ALL, PMEM_P3D_ALL,         /* empile tous les champs */

ODD, EVEN, PRED, SUCC, INV, RND, TANH, TAN,
PADR_RGB, PMEM_RGB, STM_RGB, PMEM_RGB_ALL,
MOD, DIV,    /* Modulo et division entiere */
LIBRARY
    } MNEMOS;

/********** Entete et fichier P-Code **************/

typedef struct {
        char magic[30];         /* Chr de reconnaissance */
        long codesize;          /* Taille du Code */
        int nbrefctlib;         /* Nbre de fct library */

        int string;             /* Nbre de constantes Chaines */
        int integer;            /* Nbre de constantes Entier */
        int real;               /* Nbre de constantes real */
        int Char;               /* Nbre de constantes Char */

        int Vstring;             /* Nbre de Variables Chaines */
        int Varray;              /* Nbre de Variables Array */
        int Vinteger;            /* Nbre de Variables Entier */
        int Vlongint;            /* Nbre de Variables Entier long*/
        int Vreal;               /* Nbre de Variables real */
        int Vlongreal;           /* Nbre de Variables longreal */
        int Vchar;               /* Nbre de Variables Char */
        int Vboolean;            /* Nbre de Variables booleen */
/*        int Vfile;    */           /* Nbre de Variables File */

        int Vpoint3d;            /* Nbre de Variables point3d */
        int Vpoint2d;            /* Nbre de Variables point2d */
        int Vrgb;                /* Nbre de Variables rgb */
        int Vsuite;              /* Nbre de Variables Suite */

                  } Entete;

/***************** Classe d'erreur *******************/

#define FATALERROR  0
#define TEXTERROR   1
#define WARNING     2
#define RECERROR    3

                 /********* WARNINGS ***********/

#define NOCONF      0       /* Warning pas de fichier config compil */
#define LESSARGS    1

    /***************** Numeros d'erreur *******************/

typedef enum {
 ERRCONF=0   ,   /* Err fichier de config */
 CONF        ,   /* Err de syntaxe dans le fichier config compil. */
 SYNTAX      ,   /* Err de syntaxe */
 BADTYPE     ,   /* Mauvais type d'argument */
 UNKWOWNCONF ,   /* Variable de config inconnue */
 MODECONF    ,   /* Mode d'exec inconnu */
 BADARGS     ,   /* Mauvais arguments */
 ERRCODE     ,   /* Fichier code inexistant */
 FICTXT      ,   /*          Txt         */
 MEMCODE     ,       /* Pas de place pour le code */
 MEMTXT      ,      /* idem txt */
 MEMSYM      ,      /* idem table des symbols */
 GUILLE      ,      /* Quote */
 BADCONST    ,      /* ex: 2.3343.1   */
 BADEND      ,      /* ex : commentaire non fermée avant la fin du Source */
 MEMCOMPIL   ,      /* Pas assez de memoire pour la compil */
 STRING2LONG ,      /* Const String >= MAXSTRING */
 DOUBLESYMB  ,      /* Variable déclarée 2 fois */
 NOPOINT     ,
 NOVIRG      ,
 NOPRG       ,
 NOIDENT     ,
 NOAFFECTE   ,
 NOBEGIN     ,
 NOEND       ,
 NOPO        ,
 NOPF        ,
 NOPP        ,
 NOTYPE      ,
 NOADRSPC    ,
 UNKNOWNVAR  ,
 NODO        ,
 NOBOOL      ,
 NOTHEN      ,
 NOUNTIL     ,
 BADPROC     ,
 NOBRAKETO   ,
 NOBRAKETF   ,
 NOCONST     ,
 SEPPP       ,
 NOOF        ,
 NOFIELD     ,
 UNFIELD,
 NOPPQ,
 NOPGQ,
 CANTOPENLIB,
 NBPARA
} ERRNUM;

#define Isspace(x)  ( ((x)==' ' || (x)=='\t')?1:0)
#define isnum(x)    ( (((x)>='0') && ((x) <='9'))?1:0 )
#define alnum(x)    ( (isnum(x) || (((x) >='a') && ((x)<='z')) || (((x) >='A') && ((x)<='Z')))? 1:0 )

#ifndef unix
    #define cfree free
#endif

#ifdef msdos
        #include "include\\internes.h"       /* Fct internes */
#else
        #include "include/internes.h"
#endif
