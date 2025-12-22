/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

          /********* Fonctions d'entrees-Sorties ************/

#ifdef msdos
        #include "include\\cleobis.h"
        #include "include\\libs.h"
        #include <io.h>
        #include <sys\\stat.h>
        #include <fcntl.h>
#else
        #include "include/cleobis.h"
        #include "include/libs.h"
#endif

#define verbose

extern CONST *symb;
extern VAR *var, *curvar;
extern int NbVar;
extern Entete head;
extern PROG *prg;

extern char *TxtFileName;
extern char *CodeFileName;
extern char *ErrorFileName;
extern FILE *ErrorF;
extern Erreur Erreurs[];
extern Erreur Avertis[];
extern FILE *CodeF;
extern FILE *TxtF;
extern char *Txt;
extern int *Adress;

extern int ExecMode;
extern long AdressSize;
extern long TextSize;
extern long SymbolSize;
extern FCTLIB *extfct, *curextfct, *curlibfct;

long Lenfile(FILE *fic)
{
    long ret, pos;

    pos= (long) ftell(fic);
    fseek(fic, 0, 2);
    ret= (long) ftell( fic);
    fseek(fic, 0, pos);
    return(ret);
}

BOOL ReadConfig( char *filename)
{
    FILE *conf;

    char fct[20], val[20];
    BOOL fin=FALSE;

    if (filename==(char*)NULL)
        {
         if (!(conf = fopen(CONFIGFILE,"rt")))
            {
            TraitErreur(WARNING, NOCONF,0,0);
            return (FALSE);
            }
        }
    else
        {
            if (!(conf = fopen(filename,"rt")))
                TraitErreur(FATALERROR, ERRCONF,0,0);
        }

    while (!fin)
      {
        fscanf (conf,"%s %s", fct, val);
        if (feof(conf)) fin=TRUE;

        if (!strcmp(fct, "SYMBOL"))
            SymbolSize = atoi(val);
        else
        if (!strcmp(fct, "MODE"))
            {
            if (!strcmp(val, "RUN"))
                ExecMode = RUNNING;
            else if (!strcmp(val,"TRACE"))
                ExecMode = TRACING;
            else
                TraitErreur(FATALERROR, MODECONF,0,0);
            }
        else
        if (!strcmp(fct, "ERRORS"))
            {
            ErrorFileName =(char *) strdup(val);
                                ErrorF = fopen(ErrorFileName,"wt");
            }
        else
        if (!strcmp(fct, "LABEL_MAXLEN"))
            SymbolSize = atoi(val);
        else
            {
            printf("\t'%s' ",fct);
            TraitErreur(FATALERROR, UNKWOWNCONF ,0,0);
            }
    }
        fclose(conf);
}

BOOL Ouvre()
{
        int hand=0;
#ifdef msdos
                 if (!(hand = open(TxtFileName,O_RDONLY | O_TEXT, S_IREAD)))
        {
                                TraitErreur(RECERROR,FICTXT,0,0);
                                return (FALSE);
                  }
                  TextSize = filelength(hand);
                  TxtF = fdopen (hand, "rt");
                  rewind(TxtF);
#else
        if (!(TxtF = fopen(TxtFileName,"rt")))
        {
                                TraitErreur(RECERROR,FICTXT,0,0);
            return (FALSE);
        }
                 TextSize=Lenfile(TxtF);
#endif
        if (!(CodeF = fopen(CodeFileName,"wb")))
        {
            TraitErreur(RECERROR,ERRCODE,0,0);
            return (FALSE);
                  }

         if (!(Txt = (char*)calloc((int)TextSize+1,1)))
                  TraitErreur(FATALERROR,MEMTXT,0,0);
         fread(Txt,(int)TextSize,1,TxtF);          /* Lecture du Source */
    if (TxtF != NULL)   fclose(TxtF);
    return (TRUE);
}

void WriteCode(void)
{
        CONST *cur=symb;       /* Pointeur sur les constantes */
        PROG *prog = prg;      /* Pointeur sur le prog. */
        VAR *curv= var;        /* Pointeur sur les variables */
        int tname;
        FCTLIB *curl;

       fwrite(&head, sizeof(head),1, CodeF);     /* Ecris l'entete */
       fprintf(CodeF, SECTDATA);
#ifdef verbose
    printf("Writing Code...");
#endif

        if (head.Char)
        {
        cur = symb;
        while (cur !=NULL)
         {
         if (cur->type== constchr_mt)
           fwrite( &cur->variable.Char,sizeof(char),1, CodeF);   /* Ecris Constantes Char */
         cur = cur->next;
         }
        }

        if (head.integer)
        {
        cur = symb;
        while (cur !=NULL)
         {
         if (cur->type== constint_mt)
            fwrite( &cur->variable.integer,sizeof(long),1, CodeF);   /* Ecris Constantes Integer */
         cur = cur->next;
         }
        }

        if (head.real)
        {
        cur = symb;
        while (cur !=NULL)
         {
         if (cur->type== constreal_mt)
            fwrite( &cur->variable.real,sizeof(double),1, CodeF);   /* Ecris Constantes Real */
         cur = cur->next;
         }
        }

        if (head.string)
        {
        cur = symb;
        while (cur !=NULL)
         {
         if (cur->type== conststr_mt)
            fwrite( &cur->variable.string, MAXSTRING ,1, CodeF);   /* Ecris Constantes String */
         cur = cur->next;
         }
        }

        if (head.Varray)     /* ecris les tableaux: borne1, borne2, type */
        {
        curv = var;
        while (curv !=NULL)
         {
         if (curv->type == array_t)
             fwrite( &curv->tab, sizeof(int)*3 ,1, CodeF);
         curv = curv->next;
         }
        }

        fprintf(CodeF, SECTLIB);

        if (head.nbrefctlib)
        {
            curl = extfct;
            while (curl)
            {
                fwrite(&curl->node, sizeof(int),1, CodeF);        /* node */
                fwrite(&curl->id, sizeof(int),1, CodeF);          /* id */
                fwrite(&curl->retype, sizeof(int),1, CodeF);      /* typeret */
                fwrite(&curl->nbarg,sizeof(int),1, CodeF);        /* Nbre d'args */
                fwrite(curl->type,sizeof(int)*curl->nbarg ,1, CodeF); /*tab de type */
                curl = curl->next;
            }
        }
        fprintf(CodeF, SECTCODE);

        while (prog != NULL)
        {
          if ( prog->code == BRA || prog->code == BNE)
              prog->operande = Adress[prog->operande];

          fwrite (&prog->code, sizeof(int),1, CodeF);
          fwrite (&prog->operande, sizeof(int),1, CodeF);
          prog = prog->next;
        }
}
