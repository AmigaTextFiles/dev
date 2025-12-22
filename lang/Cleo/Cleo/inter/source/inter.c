/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

/**************************************************************************/
/*                 Interpreteur de Pseudo-Code Cleo                       */
/*                  (C)opyright 1992 by DIALLO Barrou                     */
/**************************************************************************/

#include <stdlib.h>
#ifdef msdos
   #include "include\\inter.h"
   #include "include\\glob.h"
#else
   #include "include/inter.h"
   #include "include/glob.h"
#endif

void FreeLib(void)
{
    int n;
    for (n=0; n<head.nbrefctlib; n++)
        if( lib[n].type) cfree(lib[n].type);
    cfree(lib);
}

void EndInter(void)
{
        int n;

        if (CodeF) fclose(CodeF);
        if (Char) cfree(Char);
        if (Int) cfree(Int);
        if (Real) cfree(Real);

        if (Vpoint3d) cfree(Vpoint3d);
        if (Vpoint2d) cfree(Vpoint2d);
        if (Vrgb) cfree(Vrgb);
        if (Vchar) cfree(Vchar);
        if (Vinteger) cfree(Vinteger);
        if (Vreal) cfree(Vreal);
        if (Vlongint) cfree(Vlongint);
        if (Vlongreal) cfree(Vlongreal);
        if (Vboolean) cfree(Vboolean);
        if (stack) cfree(stack);
        if (Vstring)
        {
         for (n=0; n< head.Vstring; n++)
           if (Vstring[n]) cfree(Vstring[n]);
              cfree(Vstring);
        }
        if (Varray)
        {
          for (n=0; n< head.Varray; n++)
          switch(Varray[n].tab.type)
          {
          case integer_t:
             if (Varray[n].buf.buf_int) cfree(Varray[n].buf.buf_int);
             break;
          case real_t:
             if (Varray[n].buf.buf_real) cfree(Varray[n].buf.buf_real);
             break;
          case char_t:
             if (Varray[n].buf.buf_char) cfree(Varray[n].buf.buf_char);
             break;
          case boolean_t:
             if (Varray[n].buf.buf_bool) cfree(Varray[n].buf.buf_bool);
             break;
          case point2d_t:
             if (Varray[n].buf.buf_p2d) cfree(Varray[n].buf.buf_p2d);
             break;
          case point3d_t:
             if (Varray[n].buf.buf_p3d) cfree(Varray[n].buf.buf_p3d);
             break;
          case rgb_t:
             if (Varray[n].buf.buf_rgb) cfree(Varray[n].buf.buf_rgb);
             break;
         }
        cfree(Varray);
        }
        if (String)
        {
          for (n=0; n< head.string; n++)
             if (String[n]) cfree(String[n]);
                cfree(String);
        }
        if (lib) FreeLib();

   exit(0);
}

void ReadHead(char *filename)
{
    if (filename==(char*)NULL)            /* Nom de fichier par defaut */
        {
        if (!(CodeF = fopen(DEFAULT_OUT,"rb")))
            {
            printf("Ne peut ouvrir le fichier code par defaut\n");
                                EndInter();
            }
        }
    else
        {
        if (!(CodeF = fopen(filename,"rb")))
            {
              printf("Ne peut ouvrir le fichier code\n");
              EndInter();
            }
        }
   fread(&head, sizeof(Entete),1, CodeF);     /* Lis l'entete */
   if (strcmp(head.magic,"Cleobis"))
        {
              printf("Fichier Code Invalide\n");
              EndInter();
        }

}

void ReadCode(void)
{
        char *section= (char *)calloc(MAXSTRING,1);
        int nbre=0, n, i;

          if (!(fread( section, strlen(SECTDATA), 1, CodeF)))   /* lis la section */
            {
             printf("Erreur de lecture dans le fichier Code\n");
             EndInter();
            }

        if ( strcmp(section, SECTDATA))
           {
            printf(" Section Data non presente\n");
            EndInter();
           }

        if (head.Char)
        {
          nbre= head.Char; n=0;
          while (nbre--)
           if (!(fread( &Char[n++], sizeof(char), 1, CodeF)))
            {
             printf("Erreur de lecture dans le fichier Code\n");
             EndInter();
            }
        }
        if (head.integer)
        {
          nbre= head.integer; n=0;
          while (nbre--)
            {
            if (!(fread( &Int[n++], sizeof(long), 1, CodeF)))
              {
                printf("Erreur de lecture dans le fichier Code\n");
                EndInter();
              }
            }
        }
        if (head.real)
        {
          nbre= head.real; n=0;
          while (nbre--)
            {
            if (!(fread( &Real[n++], sizeof(double), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            }
        }
        if (head.string)
        {
                nbre= 0; n=0;
                while (nbre < head.string)
                  {
                    String[nbre] = (char *)calloc( MAXSTRING, 1);
                    if (!(fread( String[nbre], MAXSTRING,1, CodeF)))
                     {
                       printf("Erreur de lecture dans le fichier Code\n");
                       EndInter();
                     }
                    nbre++ ;
                  }
        }

        if (head.Varray)
        {

           nbre= 0; n=0;
           while (nbre < head.Varray)
             {
               if (!(fread( &Varray[nbre].tab, sizeof(int)*3,1, CodeF)))
                {
                 printf("Erreur de lecture dans le fichier Code\n");
                 EndInter();
                }
               switch(Varray[nbre].tab.type)
               {
               case integer_t:
                if (!(Varray[nbre].buf.buf_int = (long *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(long))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               case real_t:
                if (!(Varray[nbre].buf.buf_real = (double *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(double))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               case char_t:
                if (!(Varray[nbre].buf.buf_char = (char *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(char))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               case boolean_t:
                if (!(Varray[nbre].buf.buf_bool = (char *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(unsigned char))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               case point2d_t:
                if (!(Varray[nbre].buf.buf_p2d = (Point2d *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(Point2d))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               case point3d_t:
                if (!(Varray[nbre].buf.buf_p3d = (Point3d *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(Point3d))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               case rgb_t:
                if (!(Varray[nbre].buf.buf_rgb = (Rgb *)calloc( Varray[nbre].tab.borne2-Varray[nbre].tab.borne1+1, sizeof(Rgb))))
                    {printf("Erreur d'alloc Varray\n"); EndInter(); }
                break;
               default: break;
               }
                nbre++ ;
             }
        }
        memset((char *)section,0,MAXSTRING);
        if (!(fread( section, strlen(SECTLIB), 1, CodeF)))   /* lis la section */
            {
             printf("Erreur de lecture dans le fichier Code\n");
             EndInter();
            }
        if ( strcmp(section, SECTLIB))
           {
            printf(" Section Library non presente\n");
            EndInter();
           }
        if(head.nbrefctlib)
        {
        if (!(lib = (EXTLIB *)calloc( sizeof(EXTLIB), head.nbrefctlib)))
            {
              printf("Ne peut allouer la memoire pour les libraries\n");
              EndInter();
            }

          nbre= head.nbrefctlib; n=0;
          while (nbre--)
            {
            if (!(fread( &lib->node, sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            if (!(fread( &lib->id, sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            if (!(fread( &lib->retype, sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            if (!(fread( &lib->nbarg, sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
           lib->type = (int *)calloc(sizeof(int), lib->nbarg);
            for (i=0; i<lib->nbarg; i++)
                if (!(fread( &lib->type[n], sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            }
        }
        memset((char *)section,0,MAXSTRING);
        if (!(fread( section, strlen(SECTCODE), 1, CodeF)))   /* lis la section */
            {
             printf("Erreur de lecture dans le fichier Code\n");
             EndInter();
            }
        if ( strcmp(section, SECTCODE))
           {
            printf(" Section Code non presente\n");
            EndInter();
           }

        if ( !(prg = (PRG *)calloc( sizeof(PRG), head.codesize)))
            {
              printf("Ne peut allouer la memoire pour le code\n");
              EndInter();
            }

          nbre= head.codesize; n=0;
          while (nbre--)
            {
            if (!(fread( &prg[n].code, sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            if (!(fread( &prg[n].operande, sizeof(int), 1, CodeF)))
                 {
                   printf("Erreur de lecture dans le fichier Code\n");
                   EndInter();
                 }
            n++;
            }
     cfree(section);
}

void StatHead(void)
{
printf("**** Statistiques ***\n");
printf("Taille Code:%ld \n---Constantes---\nInteger:%d \nReal:%d \nChar:%d \nString:%d\n",head.codesize, head.integer, head.real, head.Char, head.string);
printf("---Variables---\nInteger:%d \nReal:%d \nChar:%d \nString:%d \nBoolean:%d \nArray:%d\n", head.Vinteger, head.Vreal, head.Vchar, head.Vstring, head.Vboolean, head.Varray);
printf("---Fct externes:%d\n",head.nbrefctlib);
}

void main(int argc, char **argv)
{
/*    if (argc ==1)
        {
        printf("Cleo Language\tVersion %d.%d\n\t(C)opyright July 1992 by DIALLO Barrou\n\n",VERSION, SUBVERSION);
        exit(0);
        }    */
    ReadHead(argv[1]);
/*    StatHead();       */
    AlloueConst();
    AlloueVars();
    ReadCode();
    AlloueStack();
/*    Dis();     */
    Inter();
    EndInter();
}