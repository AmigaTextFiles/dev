/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

#include <stdio.h>
#include <math.h>
#ifdef msdos
   #include "include\\prot.h"
#else
   #include "include/prot.h"
#endif

#define VERSION 0        /* Version actuelle de Cleobis    */
#define SUBVERSION 1
#define NAME "cleo"             /* Nom de la Version */
#ifdef msdos
        #define DEFAULT_OUT "cleobin\\cleo.out"   /* Nom du file dest par defaut */
        #define CONFIGFILE "etc\\cleo_int.cfg"
#else
        #define DEFAULT_OUT "cleobin/cleo.out"   /* Nom du file dest par defaut */
        #define CONFIGFILE "etc/cleo_int.cfg"
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

/*********** declaration des types Pointxd ******/

typedef struct {    double x,y,z;    } Point3d;
typedef struct {    double x,y;      } Point2d;
typedef struct {    UC r,g,b;      } Rgb;

typedef struct fctlib{
    int node;       /* Noeud de la library à laquelle elle appartient */
    int id;         /* Id de cette fct */
    int retype;     /* Type de la valeur de retour */
    int nbarg;      /* Nbre d'arg */
    int *type;      /* Tableau sur les type des args */
    } EXTLIB;


typedef struct {
       int operande;
       int code;
        } PRG;

typedef struct
     {
        struct {
            int borne1, borne2;
            int type;
         } tab;
        union {
            long   *buf_int;
            double *buf_real;
            char   *buf_char;
            unsigned char   *buf_bool;
            Point2d *buf_p2d;
            Point3d *buf_p3d;
            Rgb     *buf_rgb;
            } buf;
     } TAB;

typedef enum { integer_t =200, real_t, string_t, char_t, const_t,
               boolean_t, array_t, longint_t, longreal_t,
               point2d_t, point3d_t, rgb_t,            /* file_t, */
               fin_t
             } VarTypes;
                                    /* _adr : adresse de variables
                                       _cadr: adresse de constantes */
typedef enum { integer_adr=50 , real_adr, string_adr, char_adr,
               boolean_adr, array_adr, longint_adr, longreal_adr,
               char_cadr, integer_cadr, real_cadr, string_cadr,
               point2d_adr, point3d_adr, rgb_adr,
               fin_adr
             } ADRTYPES;         /* Type de l'adr en pile */


typedef struct {
                int type;            /* enum VarTypes */
                double val;
                } MY_CONST;

/************** Code des Mnémoniques ******************/

typedef enum {
 RTS  =2000,
 PADR_CHR , /* Push Adr N; ajoute l'adr de la variable N sur la pile */
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
 PMEM_ARRAY,

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
 IN,

 EQU_STR  ,         /* =    */
 LT_STR  ,          /* <    */
 GT_STR  ,          /* >    */
 LE_STR  ,          /* <=   */
 GE_STR  ,          /* >=   */

 ORG,              /*  Adresse courante */
 BNE ,      /* N, va à l'adr N si Condition en Fin de pile = 0 =FAUX */
 BRA ,      /* N, Saut sans condition a l'adr N */

 PRSTR   ,    /* Affiche la chaine const dont l'adr est au sommet de la pile */
 PRVSTR   ,    /* Affiche la chaine var dont l'adr est au sommet de la pile */
 PRCHR,
 PRINT  ,     /*            l'Entier  ou le Real...*/
 PRINTCHR,
 CHR13  ,     /* Passe a la ligne */
 READ,

 ABS, ATAN, ACOS, ASIN, COSH, SINH, COS, SIN, EXP, FRAC, INT, LN, SQR, SQRT,

LOADORG,
PADR_P2D, PMEM_P2D, STM_P2D,
PADR_P3D, PMEM_P3D, STM_P3D,
PUSHVAL,     /* Met une valeur sur la pile */
PMEM_P2D_ALL, PMEM_P3D_ALL,         /* empile tous les champs */
ODD, EVEN, PRED, SUCC, INV, RND, TANH, TAN,
PADR_RGB, PMEM_RGB, STM_RGB, PMEM_RGB_ALL,
MOD, DIV,
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

        int Vpoint3d;            /* Nbre de Variables point3d */
        int Vpoint2d;            /* Nbre de Variables point2d */
        int Vrgb;                /* Nbre de Variables rgb */
        int Vsuite;              /* Nbre de Variables Suite */

   } Entete;

typedef struct {
            char *msg;
            int num;
            } Erreur;

typedef enum {
    STACKOVER, STACKUNDER,UNKNOW
} ERRNUM;


#ifndef unix
    #define cfree free
#endif