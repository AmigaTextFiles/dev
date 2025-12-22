/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

FCTLIB *extfct=NULL, *curextfct=NULL, *curlibfct=NULL;  /* liste des fonctions externes */
       /* debut de liste   fin de liste    fct en cours d'analyse */
        /************* Globals de Cleobis ************************/

Entete head=  { "Cleobis", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0, 0, 0, 0L };
                        /* Declaration de l'entete courante    */
long *buf_entier;       /* Declaration du buffer des 'Entier'  */
double *buf_reel;       /* Declaration du buffer des 'Reel'    */
char *buf_chr;          /*                       des 'Chr'     */
char **buf_chaine;      /* Declaration du buffer des chaines */

BOOL dismode=FALSE;
int NbAdr  =0;                          /*** Nbre d'adresses  ***/
int NbSym =0;                           /*** Nbre de symbols ***/
int NbConst=0;                          /*** Nbre de constante ***/
int NbVar=0;                                                                     /*** Nbre de variable ***/

MY_TYPESID lasttokentype;       /* type de l'avant dernier token */
MY_TYPESID curtokentype;        /*** type du token courant ***/
MY_TYPESID facttype;            /* Type du token courant dans Facteur() */
MY_CONST curconst;              /** Valeur de la constante courante */
char curtoken[MAXSTRING];       /* Ligne courante de traitement */
int curtokenid;                 /** Id du token courant **/
int lasttokenid;                        /* Id de l'avant dernier token */

CONST *symb=NULL, *cursymb=NULL;    /** Liste de SYMBOLS **/
VAR *var=NULL, *curvar=NULL;                     /** Liste de VARIABLES **/

PROG *prg=NULL;         /*** Debut du prg code ***/
PROG *curprg=NULL;              /** cpt courant de prog **/

long AdressSize=5000;       /*** Taille Tableau d'adresses ***/
int *Adress=NULL;          /***          "  "    "     "  ***/
int curadr=0;                   /** Adr courante **/
int pcpc =0;                                    /** Compteur d'adresses **/
long TextSize=0;
int SymbolSize=MAXSTRING;   /* nombre de chr maxi dans un symbol */
int ExecMode = RUNNING;
char *ErrorFileName =   NULL;       char *TxtFileName = NULL;
char *CodeFileName = NULL;

FILE *ErrorF=NULL, *TxtF=NULL, *CodeF=NULL;   /* Descripteur Fichiers erreur, txt, code */
char *Txt=NULL;                               /* Adr du Buffer Source */

long lg=0;                      /* Compteur d'octet dans le source */
int curlg=1, curcol=0;          /* No ligne & col  courantes */
BOOL quote=FALSE;
int Nbfct=0;            /* Nbre de fct & proc */
int curfct=0;           /* Num de la fct courante */
char *curc;      /** Chr courant */
int debut=0;   /* Adress du debut du prg */
                    /***** Operateurs mathématiques *********/

OPE Mathope[] = {  "+", plus_o,  "-", moins_o,
                   "*", fois_o,  "/", divise_o, "%", mod_o,
                   (char*)NULL,fin_o
                };

BOOLEEN Bool[] = {  "and", et_b,   "or", ou_b, "xor", ouex_b,
                    "not", non_b,  "in", in_b, "mod", mod_o, "div", div_o,
                    "xxx := xxx", affecte_b,
                    (char*)NULL, fin_b
                 };

               /******* Procedures & Types Standard Pascal ******/

MOT Reserved[] = {   "program", program_f, "if", if_f, "then", then_f,
                     "else", else_f, "while", while_f, "do", do_f,
                     "for", for_f, "repeat", repeat_f, "until", until_f,
                     "begin", begin_f, "end", end_f, "var", var_f,
                     "to", to_f, "downto", downto_f, "of", of_f, "function",function_f,
                     "procedure", procedure_f, "goto", goto_f,
                     (char*)NULL, fin_f
                 };

MOT Type[] = {
                "real", real_t, "integer", integer_t, "string", string_t,
                "boolean", boolean_t, "char", char_t, "array", array_t,
                "longint", longint_t, "longreal", longreal_t,
                "point2d", point2d_t, "point3d", point3d_t, "rgb", rgb_t,
                (char*)NULL, fin_t
              };

FIELDSTRUCT Field[] = {
            point2d_t, "xy", point3d_t ,"xyz", rgb_t ,"rgb",
            fin_t, (char*)NULL
            };

MOT Fonctions[] = { "read", read_fio, "readln", readln_fio,
                    "write", write_fio, "writeln", writeln_fio,
                    "inclib",inclib_fio,
                    (char*)NULL, fin_fio
                  };

MOT Math[] =    { "abs", abs_m, "atan", atan_m, "acos", acos_m,
                  "asin", asin_m, "cosh", cosh_m, "sinh", sinh_m,
                  "cos", cos_m, "sin", sin_m, "exp", exp_m, "frac", frac_m,
                  "trunc", int_m, "ln", ln_m, "sqr", sqr_m, "sqrt", sqrt_m,
                  "odd", odd_m, "even", even_m, "pred", pred_m ,"succ", succ_m,
                  "inv", inv_m, "rnd", rnd_m,"tanh", tanh_m, "tan", tan_m,
                  (char*)NULL, fin_m
                };

Erreur Avertis[] = {
        "Compilation sans fichier de configuration",0,
        "Fichier Code par defaut",1,
        (char *)NULL, 0
        };

Erreur Erreurs[] = {
    "Fichier Config de Compilation introuvable.",0,
    "Mauvaise Syntaxe dans fichier Config",1,
    "Mauvaise Syntaxe",2,
    "Mauvais Type d'argument",3,
    "Variable de configuration inconnue",4,
    "Mode d'execution inconnu",5,
    "Mauvais Arguments",6,
    "Impossible d'ouvrir le fichier de Code",7,
    "Impossible d'ouvrir le fichier Source",8,
    "Pas assez de memoire pour le Code",9,
    "Pas assez de memoire pour le Fichier Source",10,
    "Pas assez de memoire pour la table des Symboles",11,
    "Guillements non fermees",12,
    "Constante Reelle incoherente",13,
    "Fin de fichier Texte Prematuree",14,
    "Pas assez de memoire pour la compilation",15,
    "Constante Chaine trop longue", 16,
    "Double symbole",17,
    "Point inexistant",18,
    "Point-virgule inexistant",19,
    "PROGRAM inexistant",20,
    "Identificateur inexistant",21,
    "Operateur d'affectation ':=' inexistant",22,
    "BEGIN inexistant", 23,
    "END inexistant", 24,
    "Parenthese ouvrante manquante", 25,
    "Parenthese fermante manquante", 26,
    "Separateur ':' manquant", 27,
    "Declaration de variable sans type ou type inconnu", 28,
    "Pas assez de place dans la table d'adresses",29,
    "Variable ou Fonction non declaree", 30,
    "DO inexistant", 31,
    "Operateur Booleen inexistant", 32,
    "THEN inexistant", 33,
    "UNTIL inexistant", 34,
    "PROCEDURE incomplète, parametres ou ';' inexistant", 35,
    "Crochet ouvrant manquant",36,
    "Crochet fermant manquant",37,
    "Constante manquante",38,
    "Separateur '..' attendu",39,
    "OF inexistant", 40,
    "Champs de structure non precise", 41,
    "Champs de structure inconnu",42,
    "Symbole '<' manquant",43,
    "Symbole '>' manquant",44,
    "Impossible d'ouverture la library",45,
    "Nombre de parametres incorrect", 46,
   (char *)NULL,0
    };