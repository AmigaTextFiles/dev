/**********************************
 **   l_z80.c : LINKER PER       **
 ** C_Z80 ASSEMBLER Ver.:1.01    **
 **********************************
 ** by BIANCASOFT                **
 **  (c) 1992 GENNAIO,GIUGNO     **
 **********************************/

#include <signal.h>
#include <stdio.h>

#define MAX_FILE 50

#define U_C unsigned char
#define U_S_I unsigned short int

#define AND &&
#define OR ||
#define NULL 0L

#define hbyte(vl) (vl>>8)
#define lbyte(vl) (vl & 0x000000FF)
#define bra(vl) (vl>indirizzo)?vl-indirizzo-2:254-indirizzo+vl
#define dpoke(vl,vl1) ((vl<<8)+vl1)

/** VARIABILI PUBBLICHE **/

U_S_I mod[600]       ;  /* tabella nuove origini di ogni blocco */
int n_mod            ;  /* puntatore su precedente tabella */
unsigned char *ar_p  ;  /* area per le variabili pubbliche */
unsigned int l_ap    ;  /* lunghezza area variabili pubbliche */
unsigned char *ar_c  ;  /* area per codici macchina */
unsigned int l_ac    ;  /* lunghezza area per codici macchina */
unsigned char *ar_f  ;  /* area per nomi file da linkare */
unsigned int l_af    ;  /* lunghezza area precedente */
unsigned int nf      ;  /* numero totale file richiesti */
       /* area per n#canali dei file aperti */
unsigned int f_l[MAX_FILE]   ;
int nerror           ;  /* numero errori rilevati */
unsigned short orig  ;  /* origine attuale codici */
FILE *f_par          ;  /* file con parametri di linkaggio */
int f_flag           ;  /* flag per indicare se usato (1) file precedente */


extern linker();

/*************************
 ** uscita d'emergenza  **
 *************************/
static stop()
{
   if (ar_f!=0) free(ar_f);      /* rilascio la memoria per i file */
   if (ar_c!=0) free(ar_c);      /* rilascio la memoria per i codici */
   if (ar_p!=0) free(ar_p);      /* rilascio la memoria per le variabili pubbliche */
   if (f_flag!=0) fclose(f_par); /* chiudo file parametri di linkaggio */
   printf("LINKER ABORTITO\n");
   exit(0);
   return(0); /* solo per evitare lo warning dal compilatore */
}

/**************************************************
 *** MAIN LOOP :                                ***
 **************************************************/

main(argc,argv)
int argc;
char *argv[];
{
int i1,i,fl_s,ifl,a,a1,disp,b,b1,b2;
unsigned char buf[200],buf1[10],nome_s[100];
unsigned short int org,org1,st,ln;

/* INIZIALIZZAZIONI */

f_flag=0;

if (argc>2) {
   printf ("FORMATO:%s [file_parametri]\n",argv[0]);
   return(0);
            }
if (argc==2) {
   f_par=fopen(argv[1],"r");
   if (f_par==00) {
      printf ("Non posso aprire in lettura il file_parametri:%s\n",argv[1]);
      return(0);
                  }
   f_flag=1;         /* segnalo presenza file di parametri */
             }

printf("LINKER PER C_Z80 ASSEMBLER Ver:1.10\n");
printf("By BiancaSoft (c) 1992,1995\n\n\n");

ar_f=0; ar_p=0; ar_c=0;
nf=0; nerror=0;
orig=00; org1=0;

/* lunghezze di default aree */

l_af=2000;
l_ac=0;
l_ap=10000;

signal(SIGINT,*stop); /* attivo routin di uscita d'emergenza */

/* apro le aree */

ar_f=(unsigned char *)malloc(l_af);
if (ar_f==0) {
   printf(" Non posso aprire l'area per i nomi dei file!!\n");
   return(00);
             }
ar_f[0]=0x01;
ar_p=(unsigned char *)malloc(l_ap);
if (ar_p==0) {
   printf(" Non posso aprire l'area per variabili pubbliche!!\n");
   free(ar_f);
   return(00);
             }
ar_p[0]=0x01;

/* loop di inserimento file da linkare */

while(nf<MAX_FILE)
{
printf("Nome modulo:");

if (f_flag==0) scanf("%80s",buf);
   else { fscanf(f_par,"%80s",buf); printf("%s",buf); }

printf("\n");

if (strcmp(buf,"-")==0) break;

printf("Origine:");
if (f_flag==0) scanf("%5s",buf1);
   else { fscanf(f_par,"%5s",buf1); printf("%s",buf1); }
printf("\n");
i=0;
if (strcmp(buf1,"-")==0) i=0xFFFF;  /* origine di seguito */
if (strcmp(buf1,"+")==0) i=0xFFFE;  /* origine invariata */
/*
else if (buf1[0]=='$') stch_i(buf1+1,&i);
*/
if (i==0) i=atoi(buf1);

/*** per debug ***/
#ifdef DEBUG
printf("MODULO=%s ,",buf);
printf("ORIGINE=%d,$%x\n",i,i);
#endif
/*** fine debug ***/

i=ins_lb(buf,(unsigned short int)i,ar_f,l_af);
if (i==-1) printf("area per file esaurita!!\n");
if (i==00) printf("modulo gia' inserito!!\n");

nf++;
}

printf("Nome file d'uscita:");
if (f_flag==0) scanf("%80s",nome_s);
   else { fscanf(f_par,"%80s",nome_s); printf("%s",nome_s); }
printf("\n");

fclose(f_par);   /* chiudo il file con i parametri di linkaggio */

fl_s=creat(nome_s,1);
if (fl_s<=0) {
   printf("non posso aprire il file d'uscita:%s !\n",nome_s);
   goto fine;
             }

/*** per debug ***/
#ifdef DEBUG
i=creat("area_f",1);
write(i,ar_f,l_af);
close(i);
#endif
/*** fine debug ***/

/* ciclo estrazione e linkaggio immediato variabili pubbliche */

disp=0;
b=0;
a1=0;
b1=0;
for (ifl=0; ifl<nf; ifl++)
{
   if (est_lb(ar_f,ifl,buf,&org)==00) break;
   i=open(buf,0);
   if (i<=0) {
#ifdef DEBUG
printf ("ESITO OPEN=%d\n",i);
#endif
      printf ("Il modulo :%s non puo' essere letto !\n",buf);
      break;
            }
   f_l[ifl]=i;
   a=1;
   while(1)
   {
#ifdef DEBUG
printf ("N# CANALE=%d PER FILE:%s\n",i,buf);
#endif
      if (read(i,buf1,6)<=0) {
         printf ("Il modulo :%s non puo' essere letto !\n",buf);
         break;
                             }
      ln=dpoke(buf1[2],buf1[3]);     /* lunghezza blocco */
      st=dpoke(buf1[0],buf1[1]);    /* origine blocco */
#ifdef DEBUG
printf ("LN=%d,ST=%d,BLOCC N#:%d\n",ln,st,b/3);
#endif

      if (ln==0 AND st==00) break; /* test se finiti blocchi */
      b2=b;
/* preparo la tabella con l'inizio effettivo di ogni blocco di codici */
/*
   con questo formato :
   1# origine blocco,2# lunghezza blocco,3# origine effettiva blocco
*/
      mod[b++]=st; mod[b++]=ln;
      if (org<0xFFFE) {
         mod[b++]=org; org1=org+ln; goto next;
                      }
      if (org==0xFFFE) mod[b++]=st;
      if (org==0xFFFF) mod[b++]=org1;
      if (org1<mod[b-1]+ln) org1=mod[b-1]+ln;
next:
      if (ln!=0) lseek(i,ln,1);    /* mi sposto sull'inizio del prossimo blocco */
   }

   if (read(i,buf1,2)<=0) {

      printf ("Il modulo :%s non puo' essere letto correttamente!\n",buf);
      break;
                          }
   a=dpoke(buf1[0],buf1[1]);
   if (a==0) continue;     /* se non presenti var. pubbliche passo al prossimo */

   if (disp>=l_ap-3) {
      printf("Esaurita area per variabili pubbliche!\n");
      break;
                     }
   i=read(i,ar_p+disp,a);
   if (i<=0) {
      printf ("Errore in lettura del modulo:%s\n",buf);
      exit(0);
             }
   disp=disp+a;
   ar_p[disp]=0x01; ar_p[disp+1]=0x01;
/** linko le variabili pubbliche del modulo **/
   i1=01;
   while(1)
   {
      i1=est_lb(ar_p,a1++,buf,&org);
      if (i1==00) { a1--; break;}
#ifdef DEBUG
printf ("N#:%d VAR:%s VAL:%x N.VAL:",a1-1,buf,org);
#endif
      for(b1=b2; b1<b; b1=b1+3)
      {
         if (org<mod[b1]) continue;
         if (org>mod[b1]+mod[b1+1]) continue;
         org=org-mod[b1];
         org=org+mod[b1+2];
         ar_p[i1]=hbyte(org);
         ar_p[i1+1]=lbyte(org);
         break;
      }
#ifdef DEBUG
printf ("%x\n",dpoke(ar_p[i1],ar_p[i1+1]));
#endif
   }
}

if (ifl!=nf) goto fine;

/*** per debug ***/
#ifdef DEBUG
i=creat("area_p",1);
write(i,ar_p,l_ap);
close(i);
#endif
/*** fine debug ***/

/* LOOP DI ESECUZIONE LINKAGGIO EFFETTIVO */

printf("\n\n***** ELENCO INDIRIZZI MODULI LINKATI *****\n");

n_mod=0;    /* inizializzo puntatore su origini blocchi */

for (i=0;i<ifl;i++)
{
   a=linker(i,fl_s);
   nerror=nerror+a;

}

printf("\n**** FILE D'USCITA :%s ,%04d :LINKER ERROR ****\n\n",nome_s,nerror);

fine:

for (i=ifl; i!=0 ;i--)
{
   close(f_l[i]);
}

memset(ar_p,00,6);
write(fl_s,ar_p,6);

close(fl_s);

free(ar_p);
free(ar_f);
if (ar_c!=0) free(ar_c);

return(00);
}

/************************
 ** FUNZIONI GENERICHE **
 ************************/

/*********************************
 ** ESTRAE LA LABEL N#(n) DAL   **
 ** AREA (ar) ,il risultato va  **
 ** in -nome- ed in -valore-    **
 ** rende :                     **
 ** 00 variabile non trovata    **
 ** !=00 indice su valore       **
 *********************************
 ** nota :l'area deve essere    **
 ** chiusa da 0x01              **
 ** valore minimo per n e'0     **
 *********************************/
est_lb(ar,n,nome,valore)
unsigned char *ar,*nome;
unsigned short int n,*valore;
{
unsigned short int i;
int a;

i=n; a=0;
while (ar[a]!=0x01 AND i!=0)
{
   if (ar[a++]==NULL) { a=a+2; i--;}
}
if (i!=0) return(00);
if (ar[a]==0x01) return(00);

a=a+sprintf(nome,"%0.30s",ar+a)+1;

valore[0]=dpoke(ar[a],ar[a+1]);

return(a);
}

/*********************************
 ** AGGIUNGE UNA LABEL          **
 ** str=label vl=valore         **
 ** ar=area dove metterle       **
 ** l_ar=lunghezza max. disp.   **
 ** se non c'e' posto rende -1  **
 ** se gia' esistente rende 00  **
 *********************************/
ins_lb(str,vl,ar,l_ar)
char *str;
unsigned char *ar;
U_S_I vl;
int l_ar;
{
register int i,i1;

if (trov_str(str,ar,2)!=-1) return(00);
i=0;
while (ar[i]!=0x01)
{
   if (ar[i++]==NULL) i=i+2;
}
if (i+strlen(str)+4>=l_ar-5) return(-1);
i1=i;

for (i=0;i<=strlen(str);i++)
{
   ar[i1+i]=str[i];
}
i1=i1+i; ar[i1]=hbyte(vl); ar[i1+1]=lbyte(vl);
ar[i1+2]=0x01; ar[i1+3]=0x01;

return(0x01);
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
   if (strcmp(str,(ar+c))==0) {f=2 ;break;}
   i++; c=c+strlen(ar+c)+1;
   if (f==1) c=c+ar[c]+1;
   else c=c+inc;
   f1=0;
}

if (f==2 AND vl==0) r=i;
if (f==2 AND vl!=0) r=c+strlen(ar+c)+1;

return(r);
}


