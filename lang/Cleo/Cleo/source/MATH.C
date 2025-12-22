/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/*********************** Module Mathematique *************************/

#ifdef msdos
        #include "include\\cleobis.h"
#else
        #include "include/cleobis.h"
#endif

/*** Fonction puissance a^b */
float pw(int a, int b)
{
        double res=1;
        if(b>=0)
            while(b--)  res *=a;
        else
            {
                while (b++) res *=a;
                res = 1/res;
            }
return ((float) res);
}

