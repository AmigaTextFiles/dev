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

#ifndef TRUE
    #define BOOL char
#define TRUE 1
    #define FALSE 0
#endif

extern BOOL ReadConfig( char *filename );   /* Lit fichier compil config */
extern void Intro(void);        /* Copyright */
extern void TraitErreur( char type, int num , int lig , int col);    /* Gestion de Erreurs */
extern long LenFile(FILE *fic);           /* retourne la longueur du FILE */
extern void ReadArg(int arc, char **arv);  /* lit les options de la ligne de cmde */
extern void End(void);      /*desalloue et ferme les file* */
extern BOOL Alloue(void);   /* Alloue place pour txt, code et symbols */
extern BOOL Begin(void);     /* Ouvre les files et appelle Alloue() */
extern void LineOut(char *txt);     /* extrait une ligne */
extern float pw(int a, int b);
extern void lexical (void);
extern char* Avance (char *txt);
extern char* Lettres (char *txt);
extern char* Nombres (char *txt);

extern BOOL TestMot(MOT *buf);
extern BOOL TestBool(void);
extern char *ConstChr(char *txt);

/* Fonctions de conversion */

extern float Ascii2Reel(char *txt, int len);
extern float Ascii2Entier(char *txt, int len);
extern float CalcE( char *txt, int lg);
extern long Str2Int( char *str);
extern unsigned long Convert2Dec(char *txt,int base, int len);
extern long Str2Int(char *str); /* Converti une suite de chr en Long */

extern void InsConst(void);
extern void ListConst(void);
extern void FreeConst(void);

extern void InsVar(void);
extern void ListVar(void);
extern void FreeVar(void);

extern void Bloc( void);
extern void BlocFct( void);
extern void Instruction( void);
extern void Terme(void);
extern void Facteur(void);
extern void Simple_Exp(void);
extern void Assign (void);
extern void Code(int mnemo, int ope);

extern void Gere_Variable(void);
extern int TestVar(BOOL load);
extern void read_fct(void);
extern void readln_fct (void);
extern void write_fct(void);
extern void writeln_fct(void);

extern void FreeProg(void);
extern void WriteCode(void);
extern void FreeExternFct(void);