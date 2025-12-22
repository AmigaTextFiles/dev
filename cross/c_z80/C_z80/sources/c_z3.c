/*************************************************
 *******       C_Z80 Ver.:2.01         ***********
 *************************************************
 **    Compilatore per Z80 by BIANCA SOFT       **
 **       (C) Maggio 1990,Maggio 1991           **
 **           Dicembe 1991,Giugno 1992          **
 *************************************************/

#include "c_z80.h"
#include <fcntl.h>

#define NULL 0L
/**************************************************
 *** COMPILAZIONE FASE 2:                       ***
 *** COMPILAZIONE EFFETTIVA                     ***
 **************************************************/
#define S_CM 0x3B

extern int val_arg();
extern int si_arg();
extern int no_arg();
extern int ins_lb();

int cp_ist(file)
char *file;
{
register int i,f;
int i1,fl_s,vl,ln,lnt,lung,f_er;
U_S_I cksum,nel;
short int s_ind;
char nome_s[100];
unsigned char buf1[200];
unsigned char buf[200];

s_ind=-1;
n_lin=0; c_error=0; vl=0; lnt=0; cksum=0; lung=0;

sprintf(nome_s,"%s.MOD",file);

fl_s=creat(nome_s,1);              /* creo file oggetto */
if (fl_s==-1) {   ms_err(4,nome_s) ; return(0x01);}

write(fl_s,(char *)buf,4);  /* preparo il posto per la testata */

istr[0]=NULL; indirizzo=0;
n_error=0;
while(strcmp(istr,"END")!=0)
{
   leni=0;
   c_error=0;
   n_lin++;
   pref=0;
   fe=0;
   f_er=0;

#ifdef DEBUG
printf("LINEA:%d\n",n_lin);
#endif

/* riempio con spazi l'area di stampa */
   memset(buf1,0x20,165);  buf1[166]=NULL;
/* leggo i campi dal file temporaneo */
   rd_cmp();

   if (strlen(istr)==0) goto nxt;
                /* se linea senza istruzione salta alla prossima */

   for (i=0;i<n_op;i++)
   {
      t_op[i]=com_op(op[i],&vl);

#ifdef DEBUG
printf("OP%02d=%d ,%d,%x\n",i,t_op[i],vl,vl);
#endif

      if (vl==-1) {c_error=4; break;}
      if (vl==-2) {c_error=2; break;}
      v_op[i]=(unsigned short int)vl;

   }

   if (c_error!=0) {p_err(c_error); f_er=1; n_error++; goto nxt;}
#ifdef DEBUG
printf("OP OK\n");
#endif
   f=cmp_pseudo(buf);
   if (f==0) goto nxt;
   if (f!=-1) {p_err(f); f_er=1; n_error++; goto nxt;}

   if (n_op==0) leni=no_arg(buf);
   if (n_op==1 OR n_op==2) leni=si_arg(buf);
   if (leni==0) f_er=1;

nxt:
/* eseguo la stampa formattata della linea compilata */
ln=sprintf(buf1,"%4d  %04x   ",n_lin,indirizzo);
buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;

if (strcmp(istr,"EQU")==0) {
   ln=ln+sprintf(buf1+ln,"%02x %02x ",hbyte(v_op[0]),lbyte(v_op[0]));
   buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;
                           }

if (strcmp(istr,"DBS")!=0) {
   for (i=0;i<leni;i++)
   {
      if (i>3) break;
      ln=ln+sprintf(buf1+ln,"%02x ",buf[i]);
      buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;
   }
                           }

ln=27+sprintf(buf1+27,"%s",label);
buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;

ln=39+sprintf(buf1+39,"%s",istr);
buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;

if (ln>39) ln=47;
for (i=0;i<n_op;i++)
{
   ln=ln+sprintf(buf1+ln,"%s",op[i]);
   buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;
   if (i!=n_op-1) ln=ln+sprintf(buf1+ln,",");
   buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;
}
buf1[ln]=32; buf1[ln+1]=32; buf1[ln+2]=32; buf1[ln+3]=32;

if (ln!=39) ln=75;
ln=ln+sprintf(buf1+ln,"%s\n",com);

/* scrivo linea formattata sul file di list (.lst) */
/* e su std_out se rilevato un errore */
if (list!=0) write(fl_lst,buf1,ln);
if (f_er!=0) {
   buf1[ln]=NULL;
   printf("%s",buf1);
             }
if (leni>4 AND strcmp(istr,"DBS")!=0) {
   ln=sprintf(buf1,"      %04x   ",indirizzo+4); f=0;
   for (i=4;i<leni;i++)
      {
         ln=ln+sprintf(buf1+ln,"%02x ",buf[i]);
         if (f++==3) {
            if (list!=0) write(fl_lst,buf1,ln);
            f=0; ln=sprintf(buf1,"\n      %04x   ",indirizzo+i+1);
                     }
      }
      ln=ln+sprintf(buf1+ln,"\n");
      if (f_er!=0) {
         buf1[ln]=NULL;
         printf("%s",buf1);
                   }
      if (list!=0) write(fl_lst,buf1,ln);
                                      }

/* scrivo linea compilata su file oggetto */
if (strcmp(istr,"DBS")!=0) {
   write(fl_s,(char *)buf,(unsigned int)leni);
   for (i=0;i<leni;i++)
      {
         cksum=cksum+buf[i];
      }
                           }
else {buf[0]=0x00;
      for (i=0;i<leni;i++)
      {
         write(fl_s,(char *)buf,1);
      }
     }

   if (strcmp(istr,"ORG")==0) {
      if (s_ind!=-1) {
         f=ins_test(fl_s,s_ind,lnt,cksum);
         if (f==-1) ms_err(0x07,buf);
                    }
      s_ind=indirizzo; lung=lung+lnt; lnt=0; cksum=0;
                              }
   lnt=lnt+leni;
   indirizzo=indirizzo+leni;
}

/* inserisco cod. di fine file e testata*/
if (s_ind==-1) s_ind=0;
if (ins_test(fl_s,s_ind,lnt,cksum)==-1) ms_err(0x07,buf); /* inserisco testata */
lung=lung+lnt; /* lunghezza totale file compilato */

lseek(fl_s,-4L,1); /* torno indietro di 4 byte */
for (i=0;i<6;i++)
{
   buf1[i]=0x00;
}
write(fl_s,(char *)buf1,6);

/* stampo contenuto tabella label per debug */

i=0;
f=0;
ln=sprintf(buf1,"\n\n         *****    TABELLA LABEL    *****\n");
write(fl_lst,buf1,ln);
memset(buf1,0x20,160);
ln=0;
while (lab[i]!=0x01)
{
   i1=i+strlen(lab+i)+1; vl=((lab[i1])<<8)+lab[i1+1];

   if (lab[i]==0xFF) {
          ln=sprintf(buf1,"%s",lab+i+1); buf1[ln]=32;
          ln=10+sprintf(buf1+10,"= ESTERNA       ");
                     }
   else { ln=sprintf(buf1,"%s",lab+i); buf1[ln]=32;
          ln=10+sprintf(buf1+10,"=%5d,$%4x    ",vl,vl);
        }

   buf1[ln]=32;

   write(fl_lst,buf1,ln); ln=0; memset(buf1,0x20,30);

   i=i1+2;f++;
   if (f==5) {f=0; write(fl_lst,"\x0A",1); memset(buf1,0x20,160);}
}
write(fl_lst,"\x0A\x0A",2);

/***** PER DEBUG *****/
#ifdef DEBUG
i=open("F_ESTERN",O_WRONLY|O_CREAT);
if (i!=-1)  {
   write(i,labe,l_labe);
   close(i);
            }
#endif

/****** inserimento variabili pubbliche *****/
/** FORMATO :
 ** lunghezza  - nome var 0x00 val - ...
 ** 0            2
 ** |            |
 ** |            elemento inserito nello stesso formato usato in memoria
 ** n# di byte del blocco delle variabili pubbliche,se 00 nessuna.
 ************************************/

i=00;

while (labp[i]!=0x01 AND l_labp>i)
{
   i=i+strlen(labp+i)+3;
}
nel=i;
       /* inserisco la lunghezza del blocco variabili */
write(fl_s,(char *)&nel,2);
   /* inserisco il blocco variabili */
if (nel!=0) write(fl_s,(char *)labp,(unsigned int)nel);

/****** inserimento variabili esterne *****/
/** FORMATO :
 ** lunghezza  - nome 1# var 0x00 - n# elementi(2bytes) -1#elemento(2bytes)-2# ...
 ** 0            2
 ** |            |
 ** |            elemento inserito nello stesso formato usato in memoria
 ** n# di byte del blocco delle variabili esterne,se 00 nessuna.
 ************************************/

ins_be(fl_s,labe,s_labe);

close(fl_s);
return(lung);
}

/****************************************
 ** inserisco blocco variabili esterne **
 ****************************************/
ins_be(fd,area,ofset)
int fd;
unsigned char *area;
unsigned int ofset;
{
unsigned short int len,end;
unsigned int ne,vl,i,f,f1;
unsigned char *p1,*d1,val[1100],*p;

len=00;
i=00;
end=(U_S_I)dpoke(area[0],area[1]);
end=end<<2;

p1=area+2;
f=((ofset>>1)<<1);  /* per essere allineati con le word */
p=area+f;

#ifdef DEBUG
printf("area=%d start=%d ofset=%d\n",area,p,ofset);
#endif

write(fd,(char *)&len,2);         /* riservo spazio su file per lunghezza */

while(p1[i]!=0x01 AND i<(ofset-2))
{
   f=strlen(p1+i)+1; f1=f+i;
   vl=dpoke(p1[f1],p1[f1+1]);

#ifdef DEBUG
printf("f1=%d f=%d vl=%d\n",f1,f,vl);
#endif

   if (vl!=0xFFFF) {
      ne=02;
      strcpy(val,p1+i); val[f-1]=0x00;
      d1=val+f;
      while(vl!=0xFFFF AND vl<end)
      {

#ifdef DEBUG
printf("ne=%d vl=%d val=%d d1=%d\n",ne,vl,val,d1);
#endif
         vl=vl<<1;
         d1[ne]=p[vl+2];
         d1[ne+1]=p[vl+3];
         vl=dpoke(p[vl],p[vl+1]);
         ne=ne+2;
         if (ne>1090) { printf("troppe occorrenze\n");break;}
      }
      f=f+ne;
      ne=(ne>>1)-1;
      d1[0]=hbyte(ne);
      d1[1]=lbyte(ne);
      write(fd,(char *)val,f);
      len=len+(U_S_I)f;
                   }
   i=f1+2;
}

if (len!=0) {
   lseek(fd,-(int)len-2,1);        /* torno su lunghezza */
   write(fd,(char *)&len,2);      /* inserisco lunghezza */
   lseek(fd,0L,2);                /* torno alla fine del file */
            }

return(00);
}

/*******************************
 ** INSERISCO TESTATA E CODA ***
 ** NEL FILE fl.             ***
 *** IL RISULTATO E':        ***
 ** 0-1-2-3-corpo-len+1-len+2***
 ** |   |         |          ***
 ** st  |         cksum      ***
 **     len       incluso    ***
 **               st+len     ***
 ***DOVE:                    ***
 ** st=indirizzo di partenza ***
 ** len=lunghezza blocco     ***
 ** cksum=cecksum solo corpo ***
 *******************************
 ** IMPORTANTE:              ***
 ** I PRIMI 4 BYTE DEL FILE  ***
 ** DEVONO ESSERE VUOTI PENA ***
 ** LORO SOVRASCRITTURA      ***
 ** RENDE 00 se OK ALTRIMENTI***
 ** RENDE -1                 ***
 *******************************/

ins_test(fl,st,len,cksum)
unsigned short int st,len,cksum;
int fl;
{
int ris;
unsigned char buf[4];

/* preparo testata */
buf[0]=hbyte(st); buf[1]=lbyte(st);
buf[2]=hbyte(len); buf[3]=lbyte(len);

cksum=cksum+buf[0]+buf[1]+buf[2]+buf[3]; /* aggiungo a cecksum len e st */

ris=lseek(fl,-len-4,1);         /* torno all'inizio */
if (ris==-1) return(-1);

ris=write(fl,(char *)buf,4);            /* inserisco testata */
if (ris==-1) return(-1);

ris=lseek(fl,0L,2);                     /* torno alla fine */
if (ris==-1) return(-1);

ris=write(fl,(char *)&cksum,2);         /* inserisco cecksum */
if (ris==-1) return(-1);

ris=write(fl,(char *)buf,4);            /* preparo spazio per prossima testata */
if (ris==-1) return(-1);

return(00);
}

/***********************************
 ** COMPILAZIONE PSEUDO ISTRUZIONI**
 ** IN buf INDIRIZZO DOVE METTERE **
 ** OPCODE OTTENUTI               **
 ** RITORNA:                      **
 ** 00=pseudo trovata             **
 ** -1=non pseudo                 **
 ** >0=cod. errore incontrato     **
 ***********************************/
cmp_pseudo(buf)
char *buf;
{
int ris;
register int i,vl;

i=trov_str(istr,pseudo,0);
if (i==-1) return(-1);
ris=00; leni=00;

switch(i)
{
   case(00):                              /* EQU */
      break;
   case(01):leni=n_op;                    /* FCB */
            if (fe!=0) {ris=10;break;}
            for (i=0;i<leni;i++)
            {
               if (t_op[i]!=9) {leni=0; ris=4; break;}
               buf[i]=v_op[i];
            }
      break;
   case(02):leni=n_op<<1;                 /* FCW */
            if (fe!=0) {ris=10;break;}
            for (i=0;i<n_op;i++)
            {
               if (t_op[i]!=9) {leni=0; ris=4; break;}
               vl=v_op[i];
               buf[1+(i<<1)]=hbyte(vl); buf[i<<1]=lbyte(vl);
            }
      break;
   case(03):if (fe!=0) {ris=10;break;}
            for (i=0;i<n_op;i++)          /* FCC */
            {
               if (t_op[i]==9) {buf[leni++]=v_op[i]; continue;}
               if (t_op[i]==6) {
                  if (v_op[i]>0 AND v_op[i]<65535) {
                     memmove(buf+leni,op[i]+1,v_op[i]); leni=leni+v_op[i];
                     continue;                     }
                               }
               leni=0; ris=4; break;
            }
      break;
   case(04):if (fe!=0) {ris=10;break;}
            leni=v_op[0];                 /* DBS */
      break;
   case(05):if (fe!=0) {ris=10;break;}
            indirizzo=v_op[0];            /* ORG */
      break;
   case(07):if (fe!=0) {ris=10;break;}
            list=v_op[0];                 /* LIST n */
      break;
   case( 8):                              /* INCLUDE */
      break;
   case( 9):                              /* EXTERN */
      break;
   case(10):for (i=0;i<n_op;i++)          /* PUBLIC */
            {
               vl=trov_str(op[i],lab,2);
               if (vl==-1) {ris=6; continue;}
               if (vl==00) {ris=3; continue;}
               vl=ins_lb(op[i],dpoke(lab[vl],lab[vl+1]),labp,l_labp);
               if (vl==-1) ris=8;
            }
      break;

}

return(ris);
}


/********************************
 ***   COMPILAZIONE OPERANDI  ***
 *** RESTITUISCE :            ***
 *** TIPO OPERANDO,           ***
 *** E METTE NELLA VARIABILE  ***
 *** PUNTATA DA vl IL VALORE  ***
 *** DELL'OPERANDO            ***
 *** IN ESSO ANCHE EVENTUALE  ***
 *** ERRORE OPERANDO          ***
 ********************************/
com_op(str1,vl)
char *str1;
int *vl;
{
static unsigned char r8[]=
{
'B',0,'C',0,'D',0,'E',0,'H',0,
'L',0,'(','H','L',')',0,'A',0,
0x01,0x01
};
static unsigned char r16[]=
{
'B','C',0,'D','E',0,'H','L',0,'S','P',0,'A','F',0,
0x01,0x01
};
static unsigned char tst[]=
{
'N','Z',0,'Z',0,'N','C',0,'C',0,'P','O',0,
'P','E',0,'P',0,'M',0,
0x01,0x01
};
register int i,i1,v;
int ds,a,f;
char reg[3];
char str[100];

v=0; i=0; f=0; i1=0; a=strlen(str1);
if (strcmp(str1,"(HL)")==0) {*vl=6; return(0);}
if (str1[0]=='(') {                    /* operando indiretto */
   v=50; a=a-2; i1=1;
                  }

for(i=0;i<a;i++)
{
   str[i]=str1[i+i1];
}
str[a]=NULL;
#ifdef DEBUG
printf("[%s]\n",str);
#endif

if (str[0]=='"') {v=v+6; *vl=val_arg(str); return(v);}
                                              /* operando stringa */

reg[0]=str[0]; reg[1]=str[1]; reg[2]=NULL;    /* registri indice */
if (strcmp(reg,"IX")==0) {pref=0xDD; f=1;}
if (f==1 OR strcmp(reg,"IY")==0) {
   v=v+4; *vl=6; if (f!=1) pref=0xFD;
   if (v<10) *vl=0x20;
   else {
      if (strlen(str)>2) {
         ds=val_arg(str+2); disp=ds;
         if (ds<0) *vl=ds;
                         }
        }
   return(v);
                                 }
if (strcmp(str,"I")==0) f=1;                  /* registri interruzioni */
if (f==1 OR strcmp(str,"R")==0) {
   v=v+1; *vl=0; if (f!=1) *vl=8;
   return(v);
                                }
if (strcmp(istr,"JP")==0 OR strcmp(istr,"JR")==0) goto salti;
if (strcmp(istr,"CALL")==0 OR strcmp(istr,"RET")==0) goto salti;
*vl=trov_str(str,r8,0);
if (*vl!=-1) {v=v+0; f=1;}                   /* registri a 8bit */

if (f==0) {                                   /* registri a 16bit */
   *vl=trov_str(str,r16,0);
   if (*vl!=-1) {
      v=v+2; f=1; if (*vl==4) {*vl=3; v++;}
      *vl=(*vl)<<4;
                }
          }

salti:
if (f==0) {                                   /* test su flag */
   *vl=trov_str(str,tst,0);
   if (*vl!=-1) {
      if (*vl>3) v++;
      *vl=(*vl)<<3; f=1; v=v+7;
                }
          }

if (f==0) {v=v+9; *vl=val_arg(str);}         /* operando numerico */

return(v);
}
/**************************************
 ** AGGIUNGO UN NUOVO INDIRIZZO ALLA **
 ** LISTA PER LE VAR. ESTERNE        **
 ** EVENTUALI ERRORI SONO SERVITI    **
 ** QUI ,AGGIORNANDO DIRETTAMENTE    **
 ** n_error                          **
 **************************************/
/**********************************
 ** str= indirizzo stringa con   **
 **      nome label.             **
 ** vl = valore da inserire nella**
 **      tabella                 **
 **********************************
 ** ottenuti dai valori globali  **
 ** area=indirizzo d'inzio buffer**
 **      disponibile             **
 ** ln = lunghezza totale buffer **
 ** st = offset in words inizio  **
 **      effettivo tabella valori**
 **********************************/  
agg_vle(str,vl)
unsigned char *str;
unsigned short int vl;
{
unsigned short int c,p,p1,*i,*i1,st;
unsigned char *n1;

c=trov_str(str,labe+2,2);
if (c<=00) {printf("VARIABILE ESTERNA NON TROVATA"); return(00);}

n1=c+labe+2;  /* punto n1 a valore dopo nome variabile cercata */

st=s_labe>>1;

i1=(U_S_I *)labe;
i=i1+st;    /* punto i ad inizio area valori */

p=dpoke(n1[0],n1[1]);
p1=p;
while(p!=0xFFFF)
{
   p1=p;
   p=i[p];
}

p=i1[0];
if (p>=(l_labe>>1)-st-2) {p_err(0x08); n_error++; return(00);}

if (p1==0xFFFF) {      /* test se nuova serie di valori */
   n1[0]=hbyte(p);
   n1[1]=lbyte(p);
                }
else i[p1]=p;

i1[0]=i1[0]+2;    /* incremento di 2 poiche' ogni elemento della tabella */
                  /* e' composto da 2 short int,uno che punta al succes- */
                  /* sivo elemento ed uno com il vl voluto */

i[p]=0xFFFF;
i[p+1]=vl;

return (00);
}

/**************************************
 ** AGGIUNGO UN NUOVO INDIRIZZO ALLA **
 ** LISTA PER LE VAR. RILOCABILI     **
 ** EVENTUALI ERRORI SONO SERVITI    **
 ** QUI ,AGGIORNANDO DIRETTAMENTE    **
 ** n_error                          **
 **************************************/
agg_vlr(ind)
U_S_I ind;
{
return(00);
}

