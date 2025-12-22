/*************************************************
 *******       C_Z80 Ver.:2.01         ***********
 *************************************************
 **    Compilatore per Z80 by BIANCA SOFT       **
 **       (C) Maggio 1990,Maggio 1991           **
 **           Dicembre 1991,Giugno 1992         **
 *************************************************/
/*************************************************
 *** IMPORTANTE :                              ***
 *** I FILE DA COMPILARE DEVONO ESSERE CHIUSI  ***
 *** DAL COMANDO -END- ALTRIMENTI TALE FILE NOM***
 *** VERRA'MAI CHIUSO                          ***
 *************************************************/

#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <fcntl.h>

#define P_CR printf("\n")
#define BUFF_SIZE 300

#define MAX_FILE 4-1  /* numero massimo di file apribili contemporaneamente */

#define U_C unsigned char
#define S_U_I unsigned short int
#define U_I unsigned int

#define VERO 1
#define FALSO 0
#define AND &&
#define OR ||

U_C  *o_tmp      ;     /* puntatore ad inizio area per file temporaneo */
U_I  l_tmp       ;     /* lunghezza totale area per file temporaneo */
U_I  p_tmp       ;     /* posizione attuale su area per file temporaneo */
U_C  bf_io[2000] ;     /* area per per lettura da file */
int  p_bf        ;     /* puntatore a posizione su area precedente */
int  d_bf        ;     /* dimensioni effettive del buffer precedente */
U_C  *lab        ;     /* puntatore ad area buffer per le label chiusa da 0x01 */
int  l_lab       ;     /* lunghezza area buffer per label */
U_C  *labe       ;     /* puntatore ad area buffer per le label esterne */
U_I  l_labe      ;     /* lunghezza area buffer per label esterne */
U_I  s_labe      ;     /* start area dati in buffer lab esterne */
U_C  *labp       ;     /* puntatore ad area buffer per le label pubbliche */
U_I  l_labp      ;     /* lunghezza area buffer per label pubbliche */
U_C  *labr       ;     /* puntatore ad area buffer per le label rilocabili */
U_I  l_labr      ;     /* lunghezza area buffer per label rilocabili */
U_I  s_labr      ;     /* start area dati in buffer lad rilocabili */
U_C  labele[25]  ;     /* stringa con nome label esterna da aggiornare */
U_C  label[15]   ;     /* stringa con campo label attuale */
U_C  istr[15]    ;     /* stringa con campo istruzione attuale */
U_C  com[85]     ;     /* stringa con campo commento attuale */
U_C  *op[12]     ;     /* puntatori a stringhe con campo operandi attuali */
U_C  area_op[600];     /* area per strighe operandi */
U_C   t_op[10]   ;     /* tipo operandi ,su linea attuale */
S_U_I v_op[10]   ;     /* valore operandi ,su linea attuale */

S_U_I indirizzo ;  /* contatore indirizzo istruzione attuale */
S_U_I n_lin     ;  /* n# linea attuale compilata */
S_U_I n_error   ;  /* n# errori rilevati */
U_C c_error     ;  /* codice errore linea attuale */
U_C n_op        ;  /* n# operandi nella linea attuale */
U_C pref        ;  /* valore eventuale prefisso (se=0 non presente) */
S_U_I disp      ;  /* valore eventuale displacement */
S_U_I leni      ;  /* lunghezza linea compilata attuale */
int fl_lst      ;  /* puntatore file .LST */
int deb         ;  /* variabile per ind.debug on(1) o off(0) */
int list        ;  /* indica se generare listato(1) o no(0) */
int fe          ;  /* indica se variabile da rilocare (1),esterna(2), o norm. (0) */
int fc          ;  /* indica se settare condensed fine(1) o no (0) */

/** TABELLE ISTRUZIONI **/
U_C pseudo[]=   /* pseudoistruzioni */
{
'E','Q','U',0,
'F','C','B',0,
'F','C','W',0,
'F','C','C',0,
'D','B','S',0,
'O','R','G',0,
'E','N','D',0,
'L','I','S','T',0,
'I','N','C','L','U','D','E',0,
'E','X','T','E','R','N',0,
'P','U','B','B','L','I','C',0,
0x01,0x01
};

U_C no_op[]=  /* istruzioni senza argomento */
{
'C','C','F',0,1,0x3F,
'C','P','D',0,2,0xED,0xA9,
'C','P','D','R',0,2,0xED,0xB9,
'C','P','I','R',0,2,0xED,0xB1,
'C','P','I',0,2,0xED,0xA1,
'C','P','L',0,1,0x2F,
'D','A','A',0,1,0x27,
'D','I',0,1,0xF3,
'E','I',0,1,0xFB,
'E','X','X',0,1,0xD9,
'H','A','L','T',0,1,0x76,
'I','N','D',0,2,0xED,0xAA,
'I','N','D','R',0,2,0xED,0xBA,
'I','N','I',0,2,0xED,0xA2,
'I','N','I','R',0,2,0xED,0xB2,
'L','D','D',0,2,0xED,0xA8,
'L','D','D','R',0,2,0xED,0xB8,
'L','D','I',0,2,0xED,0xA0,
'L','D','I','R',0,2,0xED,0xB0,
'N','E','G',0,2,0xED,0x44,
'N','O','P',0,1,0x00,
'O','T','D','R',0,2,0xED,0xBB,
'O','T','I','R',0,2,0xED,0xB3,
'O','U','T','D',0,2,0xED,0xAB,
'O','U','T','I',0,2,0xED,0xA3,
'R','E','T',0,1,0xC9,
'R','E','T','I',0,2,0xED,0x4D,
'R','E','T','N',0,2,0xED,0x45,
'R','L','A',0,1,0x17,
'R','L','C','A',0,1,0x07,
'R','L','D',0,2,0xED,0x6F,
'R','R','A',0,1,0x1F,
'R','R','C','A',0,1,0x0F,
'R','R','D',0,2,0xED,0x67,
'S','C','F',0,1,0x37,
0x01,0x01
};

U_C si_op[]=   /* istruzioni con argomento */
{
'L','D',0,
'P','O','P',0,
'P','U','S','H',0,
'B','I','T',0,
'S','E','T',0,
'R','E','S',0,
'R','L','C',0,
'R','R','C',0,
'R','R',0,
'S','R','L',0,
'R','L',0,
'S','L','A',0,
'S','R','A',0,
'I','N','C',0,
'D','E','C',0,
'A','D','D',0,
'A','D','C',0,
'S','B','C',0,
'O','U','T',0,
'I','N',0,
'J','R',0,
'D','J','N','Z',0,
'J','P',0,
'C','A','L','L',0,
'R','E','T',0,
'I','M',0,
'E','X',0,
'X','O','R',0,
'S','U','B',0,
'A','N','D',0,
'C','P',0,
'O','R',0,
'R','S','T',0,
0x01,0x01
};
/*************************
 ** uscita d'emergenza  **
 *************************/
void stop()
{
   if (o_tmp!=0) free(o_tmp);   /* rilascio la memoria riservata */
   if (lab!=0)  free(lab);      /* rilascio la memoria per le label */
   if (labe!=0) free(labe);     /* rilascio la memoria per le label esterne */
   if (labp!=0) free(labp);     /* rilascio la memoria per le label pubbliche */
/*   if (labr!=0) free(labr); */    /* rilascio la memoria per le label rilocabili */
   printf("COMPILAZIONE ABORTITA\n");
   exit(0);
}

/**************************************************
 *** MAIN LOOP :                                ***
 **************************************************/
extern ex_cmp();
extern cp_lab();
extern cp_ist();

main (argc,argv)
int argc;
char *argv[];
{
char nome[30],nome_s[100];   /* nome file da compilare senza estensione */
register int i,a;

   if (argc<2) { printf("FORMATO:%s nomefile [-d,-l,-c,-t nnnn,-v nnnn -e nnnn -p nnnn]\n",argv[0]); return(0); } ;
   strcpy (nome,argv[1]);

   fc=1;    /* default :ON CONDENSED MODE */
   deb=0;list=1;l_tmp=0L;l_lab=3000;
   l_labp=1000;l_labe=2000;
   for (i=2;i<argc;i++)
   {
      if (strcmp(argv[i],"-d")==0) deb=1;                       /* debug on */
      if (strcmp(argv[i],"-l")==0) list=0;                      /* list off */
      if (strcmp(argv[i],"-c")==0) fc=0;                        /* CONDENSED FINE OFF */
      if (strcmp(argv[i],"-t")==0) l_tmp=(U_I)atoi(argv[++i]);  /* lunghezza area tmp */
      if (strcmp(argv[i],"-v")==0) l_lab=atoi(argv[++i]);       /* lunghezza area per label */
      if (strcmp(argv[i],"-e")==0) l_labe=atoi(argv[++i]);      /* lunghezza area label esterne */
      if (strcmp(argv[i],"-p")==0) l_labp=atoi(argv[++i]);      /* lunghezza area label pubbliche */
      if (strcmp(argv[i],"-r")==0) l_labr=atoi(argv[++i]);      /* lunghezza area label rilocabili */
   };

   o_tmp=0; /* valore iniziale indicante file temp. non aperto */
   lab=0;   /* valore iniziale indicante area per label non aperta */
   labe=0;  /* valore iniziale indicante area per label esterne non aperta */
   labp=0;  /* valore iniziale indicante area per label pubbliche non aperta */
/*   labr=0;  /* valore iniziale indicante area per label rilocabili non aperta */
   fe=0;    /* default :no label da rilocare */

   signal(SIGINT,*stop); /* attivo routin di uscita d'emergenza */

/* APRO FILE PER LISTATO */
   sprintf(nome_s,"%s.LST",nome);
   fl_lst=creat(nome_s,1);
   if (fl_lst==-1) {
      printf ("NON POSSO CREARE IL FILE:%s\n",nome_s); return(00);
                   };

/* INIZIALIZZAZIONE PUNTATORE A STRINGHE CAMPO OPERANDI */
   a=0;
   for(i=0;i<10;i++)
   {
      op[i]=area_op+a;
      a=a+54;
   };

/* INIZIALIZZAZIONE BUFFER LABEL */
   lab=(unsigned char *)malloc(l_lab); /* riservo area di memoria per variabili */
   if (lab==0L) { ms_err(5,nome_s); exit (01);};
   lab[0]=0x01;
   if (l_labe>300000) l_labe=300000;
   if (l_labe<1000) l_labe=1000;
   labe=(unsigned char *)calloc(l_labe,1); /* riservo area di memoria per variabili esterne */
   if (labe==0L) { ms_err(5,nome_s); exit (01);}
   labe[2]=0x01;
   labe[0]=00; labe[1]=00;
   s_labe=l_labe>>2;
   labp=(unsigned char *)malloc(l_labp); /* riservo area di memoria per variabili pubbliche */
   if (labp==0L) { ms_err(5,nome_s); exit (01);}
   labp[0]=0x01;

/* INIZIO PROGRAMMA */
   d_bf=0; p_bf=0;
   sprintf(nome_s,"%s.ASM",nome);
   if (fc!=0)                             /* test se condensed fine on */
      write(fl_lst,"\033c\033[4w",6);     /* reset+condensed fine on set*/

   p_tmp=0;
   c_error=ex_cmp(nome);
   if (deb!=0) {a=printf("mem temp.:%d bytes\n",l_tmp);};
   if (c_error!=0)  {close(fl_lst); return(0);};

   p_tmp=0;
   cp_lab(nome);
   printf("FIRST PASS\n");
   printf("ASSEMBLE ERROR:%d  %d:LINE ASSEMBLE\n",n_error,n_lin);

   p_tmp=0;
   i=n_error;
   a=cp_ist(nome);
   printf("SECOND PASS\n");
   printf("ASSEMBLE ERROR:%d  %d:LINE ASSEMBLE %d:BYTES TOT. \n",n_error,n_lin,a);
   if (n_error==0 AND i==0) ms_err(00,nome_s);
   else ms_err(0x0C,nome_s);
   P_CR;

   free (o_tmp);
   free (lab);
   free (labp);
   free (labe);
/* free (labr); */
   close (fl_lst);
   return (00);
}

/** emissione messaggi d'errore su stdout **/
/** il messaggio e'identificato da cod., restituisce lungezza **/
int ms_err (cod,nome)
char cod,*nome;
{
static unsigned char *err[]= 
/*tab. ms_erri :(n#errore,messaggio_chiuso_da_NULL),tappo 0xFF */
{
"ASSEMBLE OK\n",
"CROSS COMPILATORE PER ASSEMBLER Z80 Version:2.20\nCopyright (C) 1990,1991,1992,1995 by BIANCA SOFT\n\n FILE SORGENTE:%s\n",
"\n",
"Non posso aprire in lettura il file :%s\n",
"Non posso aprire in scrittura il file :%s\n",
"Non ho sufficente memoria disponibile\n",
"Istruzione sconosciuta\n",
"FILE ERROR!!\n",
"Troppi INCLUDE FILE \n",
"Non posso leggere l'INCLUDE FILE :%s\n",
"Non posso aprire il file temporaneo :%s\n",
"Area temporanea esaurita ,aumentarla con -t nnnn !\n"
};
char buf[200];
register int i;
int flag,len;

if (cod<=11) i=cod;
else return (0);

len=sprintf(buf,err[i],nome);
printf(buf);
write(fl_lst,buf,len);

return (len);
}

/*********************************
 *** ROUTIN DI RICERCA DI UNA  ***
 *** STRINGA str IN UN ARRAY ar***
 *** IL VALORE vl INDICA:      ***
 *** =0 :stringhe sep.solo dal ***
 ***     NULL.                 ***
 *** =1 :stringhe seguite da 1 ***
 ***     byte.                 ***
 *** =2 :stringhe seguite da 2 ***
 ***     byte.                 ***
 *** =10:byte seguente indica  ***
 ***     quanti byte prima del-***
 ***     successiva.           ***
 *** LA FUNZIONE RITORNA:      ***
 *** SE vl=0 IL n# D'ORDINE A  ***
 *** PARTIRE DA 0.             ***
 *** SE vl<>0 L'INDICE DEI     ***
 *** SUCCESSIVI BYTE.          ***
 *** SE RITORNA -1 STRINGA NON ***
 *** TROVATA.                  ***
 *** L'ARRAY VA CHIUSO CON 0x01***
 *** IN PIU' SETTA OPPURTUNA-  ***
 *** MENTE fe .                ***
 *********************************/

trov_str(str,ar,vl)
unsigned char *str,*ar;
int vl;
{
register int f1,i,c,inc;
int r,f;

i=0; c=0; r=-1;
f1=0;
if (vl<10) {inc=vl; f=0;}
else {inc=0; f=1;}

while (ar[c]!=0x01)
{
   if (ar[c]==0xFF) {f1=2; c++;}  /* test se variabile esterna */
   if (strcmp(str,(ar+c))==0) {f=2 ;break;}
   i++; c=c+strlen(ar+c)+1;
   if (f==1) c=c+ar[c]+1;
   else c=c+inc;
   f1=0;
}

if (f1==2) sprintf(labele,"%s",str); /* metto nome var.estern anche in labele */
if (f==2 AND vl==0) r=i;
if (f==2 AND vl!=0) r=c+strlen(ar+c)+1;
if (str[0]=='_') f1=1;        /* variabile da rilocare */

if (f1!=0) fe=f1;

return(r);
}

/************************************
 *** STAMPA IL MESSAGGIO D'ERRORE ***
 ************************************/
p_err(cd)
int cd;
{
static unsigned char *err_c[]=
{
"** 01:ISTRUZIONE ILLEGALE **",
"** 02:LABEL NON DEFINITA **",
"** 03:LABEL GIA' DEFINITA **",
"** 04:OPERANDO ILLEGALE **",
"** 05:NUMERO TROPPO GRANDE **",
"** 06:TROPPE LABEL **",
"** 07:SALTO TROPPO LUNGO **",
"** 08:TROPPE LABEL ESTERNE **",
"** 09:TROPPE LABEL PUBBLICHE **",
"** 10:USO LABEL ESTERNA O RILOC.ILLEGALE **"
};
register int i,ln;
char buf[100];

if (cd<=10) i=cd-1;
else return(0); 

ln=sprintf(buf,"LINEA:%4d \t%s\n",n_lin,err_c[i]);
printf("%s",buf);
write(fl_lst,buf,ln);

return(00);
}



/*********************************
 *** ESTRAE DALLA MEMORIA TEMP.***
 *** I CAMPI E LI METTE NEI    ***
 *** RISPETTIVI BUFFER         ***
 *********************************/

rd_cmp()
{
int ln;
unsigned char *o,a;
n_op=0;
label[0]=NULL;
istr[0]=NULL;
com[0]=NULL;

/* estrazione campo label*/
a=o_tmp[p_tmp++];
if (a>10) a=10;
if (p_tmp+a>=l_tmp) goto fine;
if (a>0x00) {
   memmove(label,o_tmp+p_tmp,a); label[a]=NULL;
   p_tmp=p_tmp+a;
             };

/* estrazione campo istruzione */
a=o_tmp[p_tmp++];
if (a>10) a=10;
if (p_tmp+a>=l_tmp) goto fine;
if (a>0x00) {
   memmove(istr,o_tmp+p_tmp,a); istr[a]=NULL;
   p_tmp=p_tmp+a;
                };

/* estrazione campi operandi */
n_op=o_tmp[p_tmp++];
if (n_op>9) n_op=9;
for (ln=0;ln<n_op;ln++)
{
   a=o_tmp[p_tmp++];
   if (a>50) a=50;
   if (p_tmp+a>=l_tmp) break;
   if (a>0x00) {
      o=op[ln];
      memmove(o,o_tmp+p_tmp,a); o[a]=NULL;
      p_tmp=p_tmp+a;
                };
};
if (p_tmp+a>=l_tmp) goto fine;

/* estrazione campo commenti */
a=o_tmp[p_tmp++];
if (a>80) a=80;
if (p_tmp+a>=l_tmp) goto fine;
if (a>0x00) {
   memmove(com,o_tmp+p_tmp,a); com[a]=NULL;
   p_tmp=p_tmp+a;
                };

fine:
if (p_tmp+a>=l_tmp) {scanf(istr,"END"); };
if (deb!=0) {
   printf ("label :%s\nistr :%s\n",label,istr);
   for (a=0;a<n_op;a++)
   {
      printf("op(%2d) :%s\n",a,op[a]);
   };
   printf("com :%s\n",com);
            };
return(0) ;
}



