/**********************************
 **   l_z1.c : LINKER PER        **
 ** C_Z80 ASSEMBLER Ver.:1.00    **
 ** MODULO PER LINKAGGIO EFFETTIV**
 **********************************
 ** by BIANCASOFT                **
 **         (c) 1992 GENNAIO     **
 **********************************/

#include "l_z80.h"

/********************************************
 ** FUNZIONE : LINKER                      **
 ** Esegue il linkaggio dei vari moduli.   **
 **** INGRESSI :                           **
 ** no = n# d'ordine del modulo da trattare**
 ** fd = puntatore al file d'uscita dove   **
 **      inserire i codici compilati.      **
 **** USCITE :                             **
 ** 00 = linkaggio ok.                     **
 ** 01 = incontrato un errore durante il   **
 **      linkaggio.                        **
 ***** NOTE :                              **
 ** I moduli e il file d'uscita devono     **
 ** essere gia' tutti aperti.              **
 ********************************************/

linker(no,fd)
int no;
int fd;
{
unsigned char nm_mod[90],name[100];
int a,al,ao,ln,i,ris,disp;
unsigned short int ck,ll,org,val,pos,com,com1;

disp=00;
org=00;
ris=00;
ck=00;

if (l_ac!=0) {free(ar_c); ar_c=0;}

i=f_l[no];

lseek(i,0L,0);       /* mi posiziono all'inizio del modulo */
l_ac=lseek(i,0L,2);  /* mi posiziono alla fine del modulo ottenendo cosi la sua lunghezza totale */
lseek(i,0L,0);       /* mi rimetto all'inizio */

ar_c=(unsigned char *)malloc(l_ac+10);
if (ar_c==0)   {
   printf("non disponibile posto in memoria per i codici!(%d)\n",l_ac);
   return(1);
               }
lseek(fd,0L,2);   /* mi posiziono alla fine del file d'uscita */

est_lb(ar_f,no,nm_mod,&org); /* estraggo nome modulo e sua origine effettiva */

/* loop per caricare codici macchina del modulo */
ll=1;
ln=00;
while (ll!=0)
{
   a=read(i,ar_c+ln,4);
   if (a<=0) break;
   ll=dpoke(ar_c[ln+2],ar_c[ln+3]);
   ln=ln+a;
   if (ll!=0)  {
      a=read(i,ar_c+ln,ll);
      if (a<=0) break;
      ln=ln+a;
               }
   a=read(i,ar_c+ln,2);
   if (a<=0) break;
   ln=ln+2;
}

if (a<=0) {
   printf("Errore in lettura nel modulo:%s\n",nm_mod);
   return(01);
           }

ln=ln-6;    /* elimino i codici di chiusura del modulo */

/* estrazione e linkaggio variabili esterne */

read(i,ar_c+ln,2);
ll=dpoke(ar_c[ln],ar_c[ln+1]);
if (ll!=0) lseek(i,ll,1); /* salto le variabili pubbliche se presenti */

a=read(i,ar_c+ln,2);
if (a<=0) {
   printf("Errore in lettura nel modulo:%s\n",nm_mod);
   return(01);
          }
ll=dpoke(ar_c[ln],ar_c[ln+1]);

if (ll==0) goto scrivi; /* se variabili esterne non esistenti passo a fase
                           successiva */
a=read(i,ar_c+ln,ll);

if (a<=0) {
   printf("Errore in lettura nel modulo:%s\n",nm_mod);
   return(01);
          }

ar_c[ln+ll]=0x01; /* tappo per tabella */
ar_c[ln+ll+1]=0x01;
ar_c[ln+ll+2]=0x01;

disp=ln;

a=0;

while(ar_c[disp]!=0x01 AND disp<l_ac)
{
   val=0000;
   while(ar_c[disp]!=0x00 AND a<90)
   {
      name[a++]=ar_c[disp++];
   }
   name[a]=0x00;

   i=trov_str(name,ar_p,2);
   if (i==-1) {
      printf("VAR:%s, non trovata!\n",name);
      ris++;
              }
   else val=dpoke(ar_p[i],ar_p[i+1]);

   ll=dpoke(ar_c[disp+1],ar_c[disp+2]);
   disp=disp+3;
   for(i=0;i<ll;i++)
   {
      pos=dpoke(ar_c[disp],ar_c[disp+1]);
      a=-6; al=00;
      while(a<ln)
      {
         a=a+al+6;
         ao=dpoke(ar_c[a],ar_c[a+1]);
         al=dpoke(ar_c[a+2],ar_c[a+3]);
         if (pos>=ao AND pos<=ao+al) break;
      }
      pos=pos-ao+a+4;
/* se valore scritto <>00 allora lo aggiungo a valoree trovato */
      val=val+dpoke(ar_c[pos+1],ar_c[pos]);
      ar_c[pos]=lbyte(val); ar_c[pos+1]=hbyte(val);
      disp=disp+2;
   }
}

scrivi:

#ifdef DEBUG
sprintf(name,"c_%s",nm_mod);
i=creat(name,1);
write(i,ar_c,ln);
close(i);
#endif

/* RISISTEMAZIONE DELL'ATTUALE BLOCCO DI CODICI */

printf("\n MODULO :%s\n",nm_mod);

disp=0;
while(disp<ln)
{
   n_mod++;
   com1=mod[n_mod++];com=mod[n_mod++];
   printf(" START:%05d,$%04x  LEN:%05d,$%04x\n",com,com,com1,com1);
   ar_c[disp]=hbyte(com);
   ar_c[disp+1]=lbyte(com);
   al=com1+4;
   for(a=disp;a<al;a++)
   {
      ck=ck+ar_c[a];
   }
   i=write(fd,ar_c+disp,al);
   i=write(fd,&ck,2);
   disp=disp+al+2;
   ck=0;
}

return(ris);
}
