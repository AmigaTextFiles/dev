/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

        /************* Module de conversion ******************/

#ifdef msdos
        #include "include\\cleobis.h"
#else
        #include "include/cleobis.h"
#endif

/* Fonction qui converti une Chaine d'entier en Long */

long Str2Int( char *str)
{
  long n = 0;
  char *c = str;
  while(*c >= '0' && *c <= '9')
    n = n*10 + *c++ - '0';
  return (n);
}

/*** Fonction de convertion d'une base quelconque en base 10 */

unsigned long Convert2Dec(char *txt,int base, int len)
{
        unsigned long i, digit, res=0;

        for (i=0;i< len; i++)
        {
                digit = txt[len-i-1]-'0';
                if (digit>9)
                {
                 if (txt[len-i-1]>='a' && txt[len-i-1] <='f')
                    digit -= ('a'-'9'-1);
                 else
                 if (txt[len-i-1]>='A' && txt[len-i-1] <='F')
                    digit -=('A'-'9'-1);
                }
                res += digit*pw(base,i);
        }
return(res);
}

/*** Fonction qui calcul la partie d'un nombre après le E */

float CalcE( char *txt, int lg)
{
        double mant=0;
        int n=0;
        char neg=0;
        txt++; lg--;

        if (*txt =='-')
                {   txt++; lg--; neg=1; }
        if (*txt =='+')
                {   txt++; lg--;    }

        while (lg)
                mant += (txt[n++]-'0')*pw(10,--lg);
        if (neg)
                mant= pw(10,-mant);
        else
                mant= pw(10,mant);
return((float) mant);
}

/*** Fonction qui convertit un nombre entier Ascii en Float */

float Ascii2Entier(char *txt, int len)
{
        double res=0, mant=1;
        char *tp, fin=0;
        int n=0, lg, sig=1;

        if (*txt=='-')  {sig=-1; txt++; }
        while (*txt=='0') { txt++;len--; }
        tp=txt; lg=len;
        while (lg && !fin)
        {
                if (*tp == 'E' || *tp == 'e')
                    fin=1;
                else
                {   lg--;  tp++;}
        }
        if (fin)
                {
                    mant = CalcE(tp,lg);
                    len=len-lg;
                }
                while(len)
                    res += ((txt[n++])-'0')*pw(10,--len);
return((float) res*mant*sig);
}

/*** Fonction qui convertit un nombre reel Ascii en Float */

float Ascii2Reel(char *txt, int len)
{
        int lg=0, lg2=0, sig=1;
        float mant=1,res=0,vir=0;
        char *tp, *tp2, fin=0;

        if (*txt=='-')  {sig=-1; txt++; }
        while (*txt=='0') { txt++;len--; }
        tp=tp2=txt;
        while (*tp++ !='.') lg++;
        while ( lg2<len && !fin)
                if (*tp2 =='e' || *tp2=='E') fin=1;
                else { lg2++; tp2++; }
        if (fin)
                {
                        mant = CalcE (tp2,len-lg2);
                        res=Ascii2Entier(txt,lg);
                        vir = Ascii2Entier(tp,lg2-2);
                        return((float)(res+vir/pw(10,lg2-2))*mant*sig);
                }
        else
        {
                res=Ascii2Entier(txt,lg);
                vir = Ascii2Entier(tp,len-lg-1);
                return((float) res+vir/pw(10,len-lg-1)*sig);
        }
}
