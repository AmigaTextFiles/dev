/*************************************************
 *******       C_Z80 Ver.:2.01         ***********
 *************************************************
 **    Compilatore per Z80 by BIANCA SOFT       **
 **       (C) Maggio 1990,Maggio 1991           **
 **           Giugno 1992                       **
 *************************************************/

/*#include <stdio.h>  */
/*#include <fcntl.h>   file header per funzioni i/o unix soltanto */
#include <string.h>
#include "c_z80.h"

#define NULL 0L
/**************************************************
 *** ROUTIN DI ESTRAZIONE DEI CAMPI NEL FILE    ***
 **************************************************/
#define S_CM 0x3B

U_S_I pross();
U_S_I estrai();

ex_cmp(file)
char *file;
{
static unsigned char tst[]={
'N','Z',0,'Z',0,'N','C',0,
'C',0,'P','O',0,'P','E',0,
'P',0,'M',0,
0x01,0x01
                           };
int fl[MAX_FILE];
int n_fl;  /* indice corrente file aperto */
int i,esito;
unsigned char *l1,buff[BUFF_SIZE+1],nome_r[100];
register U_S_I c,f;
register short int i1;

i=0; n_fl=0 ;n_lin=0 ;c_error=0;

sprintf(nome_r,"%s",file);
fl[n_fl]=open(nome_r,0);
if (fl[n_fl]==-1) {
   sprintf(nome_r,"%s.ASM",file); fl[n_fl]=open(nome_r,0);
                  }

/* SCRIVO TESTATA SU STANDARD OUTPUT */
ms_err(01,nome_r); P_CR ;
write(fl_lst,"\x0A",1);

if (fl[n_fl]==-1) {  ms_err(3,nome_r); return(0x01);};

if (l_tmp==0L) {     /* test se dimensioni buffer gia' definite */
   l_tmp=(unsigned int)lseek(fl[n_fl],0L,2); /* mi metto alla fine del file */
   lseek(fl[n_fl],0L,0);   /* mi rimetto all'inizio */
   if (l_tmp==-1) { ms_err(3,nome_r); return(0x01);};
   l_tmp=l_tmp<<1;   /* raddoppio la lunghezza ottenuta */
   if (l_tmp<10000) l_tmp=10000; /* lunghezza minima area temporanea */

               };
o_tmp=(unsigned char *)malloc(l_tmp); /* riservo un area di memoria lungha il doppio del file */
if (o_tmp==NULL) {  ms_err(5,nome_r); return(0x01);};

esito=0;
do
{
   n_lin++;
   label[0]=NULL;
   istr[0]=NULL;
   com[0]=NULL;
   f=0;

   n_op=0;i1=0;
   if (deb!=0) printf("File n#%d punt:%d\n",n_fl,fl[n_fl]);

   if (read_l(fl[n_fl],buff,0x0A,00)==-1) {
      sprintf(istr,"END");
      goto scrivo1;    /* inserisco un END alla fine del file se non trovato prima */
                                           };

   if (buff[i1]==NULL) goto scrivo1;
   if (buff[i1]==S_CM OR buff[i1]=='*') goto commento;
   if (buff[i1]==0x20 OR buff[i1]==0x09) goto istruzione;
   i1=estrai(i1,buff,label,10,0x20,0x09);

#ifdef DEBUG
printf("LINEA:%d\n",n_lin);
printf("label=%s, %d\n",label,strlen(label));
#endif

istruzione:
   i1=pross(i1,buff);
   if (i1==-1) goto scrivo1;

   if (buff[i1]==S_CM OR buff[i1]=='*') goto commento;
   i1=estrai(i1,buff,istr,10,0x20,0x09);
   if (strcmp(istr,"RET")==0) f=1;

#ifdef DEBUG
printf("istr.=%s, %d\n",istr,strlen(istr));
#endif

operandi:
   i1=pross(i1,buff);
   if (i1==-1) goto scrivo1;
   if (f==0 AND trov_str(istr,no_op,10)!=-1) goto commento;
   if (buff[i1]==S_CM) goto commento;
   while (buff[i1]!=0x20 AND buff[i1]!=NULL)
   {
      if (n_op>=MAX_OP) break;
      l1=op[n_op];
      if (buff[i1]==',') i1++;
      if (buff[i1]=='"') {
         i1++; l1[0]='"'; i1=1+estrai(i1,buff,l1+1,48,'"','"');
         i=strlen(l1); l1[i]='"'; l1[i+1]=NULL; goto nxtop;
                         };
      c=0;
      while (buff[i1]!=',' AND buff[i1]!=' ' AND buff[i1]!=NULL)
      {
         l1[c++]=buff[i1++];
      };
      l1[c]=NULL;
nxtop:
      n_op++;
            /* istruzione=RET e operando non valido allora commento */
      if (f==1 AND n_op==1 AND trov_str(op[0],tst,0)==-1) {
         n_op=0; i1=i1-strlen(op[0]); break;
                                                         };
#ifdef DEBUG
   printf("oper[%d]=%s,\n",n_op-1,op[n_op-1]);
#endif
   };

   i1=pross(i1,buff);
   if (i1==-1) goto scrivo;


commento:

   estrai(i1,buff,com,80,NULL,NULL);
#ifdef DEBUG
printf("comm.=%s, %d\n",com,strlen(com));
#endif

scrivo:
/** Test se comando=INCLUDE ,nel caso apro il file specificato **/

if (strcmp(istr,"INCLUDE")==0) {
   if (n_fl+1>=MAX_FILE) {         /* test se troppi include nidificati */
      ms_err(0x08,""); return(-1);
                         };
   fl[n_fl+1]=open(op[0],0);
   if (fl[n_fl+1]==-1) {         /* test se file apribile in lettura */
      ms_err(0x09,op[0]); return(-1);
                       };
   n_fl++; n_lin--;
   read_l(fl[n_fl-1],0,0,1);     /* blocco file precedente */
   if (deb!=0) printf("Apro file n#%d \n",n_fl);
   continue;                     /* se tutto ok, passo a prima riga del nuovo file */
                               };

scrivo1:

/** test se aperti degli include file e se trovata fine file **/

if (strcmp(istr,"END")==0) {   /* test se fine file */
   if (n_fl>00)   {            /* test se aperti include file */
      if (deb!=0) printf("Chiudo file n#%d \n",n_fl);
      close(fl[n_fl--]);
      sprintf(istr,"");
      continue;                /* se si,non memorizzo la linea */
                  };
                           };

   esito=trasf(label);
   if (esito!=0) goto fine;

   esito=trasf(istr);
   if (esito!=0) goto fine;

   o_tmp[p_tmp++]=n_op;
   if (n_op>0)
   {
      for (c=0;c<n_op;c++)
      {
         esito=trasf(op[c]);
         if (esito!=0) break;
      };
   };
   esito=trasf(com);

fine:
   if (esito!=0) {
      ms_err(0x0B,"");
      break;
                 };

}while (strcmp(istr,"END")!=0); /* termina quando incontra l'istruzione END */

/* chiude tutti i file aperti */

for (i=n_fl;i>=0;i--) close(fl[i]);

/* close(fl[0]); */
return (esito);
}

/*****************************************
 ** SE FLAG=0                           **
 ** LEGGE DAL FILE fd FINCHE NON TROVA  **
 ** IL CARATTERE end                    **
 ** METTE IL RISULTATO IN linea         **
 ** SE SI HA ERRORE O EOF RITORNA -1    **
 ** SE FLAG=1                           **
 ** RESETTA BUFFER, E SI RIPOSIZIONA    **
 ** SULLA POSIZIONE EFFETTIVAMENTE LETTA**
 ** NEL FILE.                           **
 ** usa un buffer per fare la lettura   **
 *****************************************/

read_l(fd,linea,end,flag)
int fd,flag;
unsigned char *linea,end;
{
register int i,r;

i=0; r=0;

switch(flag) {
case(00):      /* lettura da file normale */
   while(VERO)
   {
      if (p_bf>=d_bf) {
         d_bf=read(fd,bf_io,1990); p_bf=0;
         if (d_bf<=0) {r=-1; break; };
                      };
      if (bf_io[p_bf++]==end) break;
      if (i>=BUFF_SIZE) continue;
      linea[i++]=bf_io[p_bf-1];
   };
   linea[i]=NULL;
   break;

case(01):      /* reset buffer e si ferma nel file sull' ultimo carattere letto */
   if (p_bf<d_bf) lseek(fd,p_bf-d_bf,1); /* si posiziona sull'ultimo carattere letto nel file */
   p_bf=0;d_bf=0;
   break;

             };

return(r);
}

/*****************************************
 ** CERCA IL PROSSIMO CARATTERE DIVERSO **
 ** DA SPAZIO O TAB NELLA STRINGA linea **
 ** A PARTIRE DAL CARATTERE a E NE      **
 ** RESITUISCE IL VALORE                **
 ** SE RESTITUISCE -1 ALLORA FINE TESTO **
 ** LA LINEA DEVE TERMINARE CON 0x00    **
 *****************************************/

U_S_I pross(a,linea)
U_S_I a;
unsigned char *linea;
{
register U_S_I cr,i;

cr=-1 ;i=a;
while (linea[i]!=NULL AND i<BUFF_SIZE)
{
   if (linea[i]!=0x20 AND linea[i]!=0x09) {cr=i;break;};
   i++;
};
return (cr);
}

/********************************************
 ** ESTRAE DA cr DI lin UNA STRINGA FINO   **
 ** AL PROSSIMO CAR. dl o dl1 O ALLA FINE  **
 ** DI lin E METTE IL RISULTATO IN buff    **
 ** linea DEVE TERMINARE PER 0x00          **
 ** len INDICA LA MAX LUNGHEZZA PER buff   ** 
 ** RESTITUISCE IL PUNTATORE A TALE        **
 ** CARATTERE                              **
 ********************************************/

U_S_I estrai(cr,lin,buff,len,dl,dl1)
U_S_I cr,len;
unsigned char *lin,*buff,dl,dl1;
{
register U_S_I i,i1;

i=cr;i1=0;
while (lin[i]!=NULL AND i<BUFF_SIZE)
{
   if (lin[i]==dl OR lin[i]==dl1) break;
   if (i1<len) buff[i1++]=lin[i];
   i++;
};
buff[i1]=NULL;
return (i);
}

/**********************************************
 ** SCRIVE NEL FILE MEMORIA TEMPORANEA       **
 ** LA STRINGA str IN TESTA METTE LA         **
 ** LUNGHEZZA RESTITUISCE -1 SE SI E'        **
 ** VERIFICATO UN ERRORE                     **
 **********************************************/
trasf(str)
register unsigned char *str;
{
register unsigned char i;

if (p_tmp>=l_tmp) return(-1);
i=(unsigned char)strlen(str);
if (p_tmp+5+i>=l_tmp) return(-1);

o_tmp[p_tmp++]=i;
if (deb!=0) {
   printf ("punt:%d lung:%d testo:%s\n",o_tmp+p_tmp-1,i,str);
            };
memmove(o_tmp+p_tmp,str,i);
p_tmp=p_tmp+i;

return (0);
}

