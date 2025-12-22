/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/*#define debug*/
#define verbose
/*                              CLEOBIS Language
                        (C)opyright 1992 by DIALLO Barrou
*/

#ifdef msdos
        #include "include\\cleobis.h"
        #include "include\\libs.h"
        #include "include\\globals.h"
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
        #include "include/globals.h"
#endif

#include <string.h>
#include <ctype.h>

void Lexical(void)
{
    BOOL fin=FALSE, bon;

         lasttokentype = curtokentype;  /* Sauve l'ancien type */
         lasttokenid = curtokenid;                      /* Sauve l'ancien Id */

   do
    {
        bon =TRUE;
        if (isalpha(*curc) || *curc=='_')
            curc=(char *)Lettres(curc);
        else
        if (isnum(*curc))
            curc=(char *)Nombres(curc);
        else
        if (isspace(*curc))
            {
            curc=(char *)Avance(curc);
            bon =FALSE;
            }
        else
            switch(*curc)
            {
            case '\'':
                    curc =(char *)ConstChr(curc);
                    break;
            case '\"':  if (!quote) quote=TRUE;
                            else quote=FALSE;
                    curc++; lg++;
                    break;
            case '\r':
            case '\n':
                    curlg++; curcol=0; lg++;
                    bon =FALSE;
#ifdef verbose
                    printf("# %d\r",curlg-1);
#endif
                    break;

            case '-':
                    curtokenid =(int) moins_o;
                    curtokentype = mathope_mt;
                            *curtoken = (*curc);
#ifdef debug
                        printf("OPERATEUR MATH.\t-\n");
#endif
                    curc++; lg++;
                    break;
            case '+':
                    curtokenid =(int) plus_o;
                    curtokentype = mathope_mt;
                            *curtoken = (*curc);
#ifdef debug
                        printf("OPERATEUR MATH.\t+\n");
#endif
                    curc++; lg++;
                    break;
            case '*':
                    curtokenid =(int) fois_o;
                    curtokentype = mathope_mt;
                            *curtoken = (*curc);
#ifdef debug
                        printf("OPERATEUR MATH.\t*\n");
#endif
                    curc++; lg++;
                    break;
            case '/':
                    curtokenid =(int) divise_o;
#ifdef debug
                        printf("OPERATEUR MATH.\t/\n");
#endif
                    curtokentype = mathope_mt;
                            *curtoken = (*curc); *(curtoken+1)=0;
                    curc++; lg++;
                    break;
            case '%':
                    curtokenid =(int) mod_o;
#ifdef debug
                        printf("OPERATEUR MATH.\t/\n");
#endif
                    curtokentype = mathope_mt;
                            *curtoken = (*curc);
                    curc++; lg++;
                    break;
            case '<':
                    if ( *(curc+1) == '>')
                        {
                        curtokenid =(int) different_b;
#ifdef debug
                        printf("BOOLEEN\t<>\n");
#endif
                        curc++; lg++;
                        }
                    else
                    if ( *(curc+1) == '=')
                        {
                        curtokenid =(int) pluspetitegal_b;
#ifdef debug
                        printf("BOOLEEN\t<=\n");
#endif
                        curc++; lg++;
                        }
                    else
                        {
                        curtokenid =(int) pluspetit_b;
#ifdef debug
                       printf("BOOLEEN\t<\n");
#endif
                        }
                    curtokentype = booleen_mt;
                    curc++; lg++;
                    break;
            case '>':
                    if ( *(curc+1) == '=')
                        {
                        curtokenid =(int) plusgrandegal_b;
#ifdef debug
                        printf("BOOLEEN\t>=\n");
#endif
                        curc++; lg++;
                        }
                    else
                        {
                        curtokenid =(int) plusgrand_b;
#ifdef debug
                        printf("BOOLEEN\t>\n");
#endif
                        }
                    curtokentype = booleen_mt;
                    curc++; lg++;
                    break;

            case '=':
                    curtokenid =(int) egal_b;
                    curtokentype = booleen_mt;
                    curc++; lg++;
#ifdef debug
                        printf("BOOLEEN\t=\n");
#endif
                    break;
            case '.':
                    if ( *(curc+1) == '.')          /* '..' Mot Reserve! */
                        {
                         strcpy(curtoken, "..");
                         curtokentype = reserved_mt;
                         curtokenid = pp_f;
                         curc++; lg++;
#ifdef debug
                         printf("TOKEN= ..\tMot Reservé!!!\n");
#endif
                        }
                    else
                        {
                          *curtoken='.'; *(curtoken+1)=0;
                          curtokentype = separ_mt;
                    curtokenid = -1;
#ifdef debug
                        printf("SEPARATEUR \t%c\n", *curtoken);
#endif
                        }
                    curc++; lg++;
                    break;

            case ',': case '(': case ')': case ';': case '#':
                      case '[': case ']':
                    curtokentype = separ_mt;
                    *curtoken = (*curc); *(curtoken+1)=0;
#ifdef debug
                    printf("SEPARATEUR \t%c\n", *curtoken);
#endif
                    curc++; lg++;
                    curtokenid = -1;
                    break;
            case ':':
                    if (*(curc+1) == '=')
                        {
                         curtokenid =(int) affecte_b;
                         curtokentype = booleen_mt;
                         curc++; lg++;
#ifdef debug
                            printf("BOOLEEN\tAffecte\n");
#endif
                        }
                    else
                        {
                            curtokentype = separ_mt;
                            *curtoken = (*curc);
                    curtokenid = -1;
#ifdef debug
                            printf("SEPARATEUR \t%c\n", *curtoken);
#endif
                        }
                    curc++; lg++;
                    break;
            case '{':
                    while ( *curc != '}')
                     {
                      if (*curc=='\r' || *curc=='\n')
                        {
                          curlg++;
#ifdef verbose
                         printf("# %d\r",curlg-1);
#endif
                        }
                      curc++; lg++;
                     }
#ifdef debug
                            printf("COMMENTAIRE \t%c\n", *curc);
#endif
                    bon =FALSE;
                    curc++; lg++;
                    break;
            case 0:
                    fin=TRUE;
                    break;
            default:
                    printf("*********** ERREUR <%c> INCONNU\n", *curc);
                    curc++; lg++;
                    break;
            }
    } while (!bon);
    if (fin)
        {
#ifdef debug
        ListConst();
        ListVar();
        Dis();
#endif
/* End(); printf("Fin de la compilation\n"); exit(0); */}
}

void main(int argc, char **argv)
{
    Intro();
         if (argc>1)
       ReadArg(argc, argv);
    else exit();
    ReadConfig((char *)NULL);
    Begin();
curc =(char *)Txt;
    Compiler();
/*ListVar(); */
    printf("\n%d lignes compilees...\n",curlg);
    End();
}