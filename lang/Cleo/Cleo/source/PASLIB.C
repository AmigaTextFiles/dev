/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

        /*************** Librarie de fonctions Pascal *****************/

#ifdef msdos
        #include "include\\cleobis.h"
        #include "include\\libs.h"
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
#endif

extern void TraitErreur (char type, int num, int lig, int col);
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
extern int curadr;
extern long AdressSize;
extern int *Adress;
extern int pcpc;
extern FIELDSTRUCT Field[];

void NewAdress(void)
{
        if (curadr == AdressSize)
                TraitErreur(FATALERROR, NOADRSPC, curlg, curcol);
        else
                curadr++;
}

void while_fct(void)
{
        int adress, adress1;

        NewAdress();
        adress = curadr;
        Code (ORG, adress);   /* Stocke l'adr du debut du while */
        Lexical();
        Expr();
        NewAdress();
        adress1 = curadr;
        Code ( BNE, adress1);
        if ( curtokenid == do_f)
            {
            Lexical();
            Instruction();
            Code ( BRA, adress);
            Code (ORG, adress1); /* La fin du while (adress1)
                                  est egal au PC apres l'instruction */
            }
        else
            TraitErreur(TEXTERROR, NODO, curlg, curcol);
}

void for_fct(void)
{
    int adress;
        NewAdress();
        adress = curadr;
        Code (ORG, adress);
        Lexical();

}

void repeat_fct(void)
{
        int adress;

        NewAdress();
        adress = curadr;
        Code (ORG, adress);
        do {
            Lexical();
            Instruction();
        } while ( *curtoken == ';');

        if (curtokenid != until_f)
            TraitErreur (TEXTERROR, NOUNTIL, curlg, curcol);
        else
            {
                Lexical();
                Expr();
            }
        Code( BNE, adress);
}

void PokeAdr(int adress)
{
    Adress[adress] = pcpc;
}

void if_fct(void)
{
        int adress1, adress;

        Lexical();
        Expr();
        NewAdress();
        adress = curadr;
        Code ( BNE, adress);
        if (curtokenid != then_f)
                TraitErreur (TEXTERROR, NOTHEN, curlg, curcol);
        else
            {
                Lexical();
                Instruction();

                if ( *curtoken == ';') PokeAdr( adress);
                else
                {
                    if ( curtokenid == else_f)
                        {
                            NewAdress();
                            adress1 = curadr;
                            Code ( BRA, adress1);
                            Code (ORG, adress);
                            Lexical();
                            Instruction();
                            Code ( ORG, adress1);
                        }
                    else
                        printf("ELSE Manquant...\n");
               }
          }
}

void read_fct(void)
{
        if ( *curtoken != '(' )
                TraitErreur ( TEXTERROR, NOPO, curlg, curcol);
        else
        do {
                Lexical();
                if ( curtokentype != ident_mt)
                        TraitErreur (TEXTERROR, NOIDENT, curlg, curcol);
                else
                {
                   TestVar(FALSE);
                   Code (READ, 0);
                }
        } while ( *curtoken == ',');

        if ( *curtoken != ')' )
            TraitErreur (TEXTERROR, NOPF, curlg, curcol);
        else
            Lexical();
}

void readln_fct(void)
{
        Lexical();
        if ( *curtoken == '(' )
                read_fct();
        Code ( CHR13, 0);
}

void writeln_fct (void)
{
        Lexical();
        if ( *curtoken == '(' )
                write_fct();
        Code( CHR13, 0);
}

void write_fct(void)
{
        if ( *curtoken != '(' )
                TraitErreur (TEXTERROR, NOPO, curlg, curcol);
        else
          {
           do {
             Lexical();
             if ( curtokentype == constchr_mt || curtokentype == conststr_mt )
               {
                 InsConst();
                 if (lasttokentype == constchr_mt)
                  {
                    Code ( PRCHR, 0);   /* print la const chr sur la pile */
                  }
                 else
                  {
                   Code ( PRSTR,0);   /* print la String sur la pile */
                  }
              }
             else
               {
                Simple_Exp();
                /*** ATTENTION, on ne connait pas le type de la valeur !!!!! */
               if (facttype == string_t)
                   Code ( PRVSTR, 0);
               else
               if (facttype == char_t)
                   Code ( PRINTCHR, 0);
               else
                Code ( PRINT, 0);       /* affiche la valeur sur la pile */
               }
       } while ( *curtoken == ',' );

          if ( *curtoken != ')' )
                TraitErreur ( TEXTERROR, NOPF, curlg, curcol);
          else
            Lexical();
    }
}
