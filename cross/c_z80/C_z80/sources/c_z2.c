/*************************************************
 *******       C_Z80 Ver.:2.00         ***********
 *************************************************
 **    Compilatore per Z80 by BIANCA SOFT       **
 **       (C) Maggio 1990,Maggio 1991           **
 **            Dicembre 1991                    **
 *************************************************/

#include "c_z80.h"

#define NULL 0L
/**************************************************
 *** COMPILAZIONE FASE 1:                       ***
 *** CALCOLO LABEL                              ***
 **************************************************/
#define S_CM 0x3B

extern int val_arg();

char cp_lab(file)
char *file;
{
int i1,i,vl,len,f;

i1=0; n_lin=0 ;c_error=0; vl=0;

istr[0]=NULL; indirizzo=0;
n_error=0;
while(strcmp(istr,"END")!=0)
{
   len=0;
   c_error=0;
   n_lin++;
   rd_cmp();
   fe=0;

#ifdef DEBUG
printf("LINEA n#%d\n",n_lin);
#endif

   if (strlen(istr)==0) goto nxt1;
                /* se linea senza istruzione salta alla prossima */

#ifdef DEBUG
printf("LABEL=[%s]\n",label);
#endif
   for (i=0;i<n_op;i++)
   {
      t_op[i]=pre_op(op[i]);
      if (t_op[i]==5 OR t_op[i]==15)  v_op[i]=val_arg(op[i]);
      else v_op[i]=0;

#ifdef DEBUG
printf("OP%02d=%d ,%d\n",i,t_op[i],v_op[i]);
#endif

   }

   f=pseudo_op();
   if (f==0) goto nxt;
   if (f!=-1) {p_err(f); n_error++; continue;};

   len=s_arg();
   if (len==0) len=n_arg();

nxt1:
   if (strlen(label)!=0) {
         f=cmp_lab(indirizzo);
         if (f!=0) {p_err(f); n_error++; }
#ifdef DEBUG
printf("lad=>%s< ind=%d,%x\n",label,indirizzo,indirizzo);
#endif
                         }
nxt:
#ifdef DEBUG
printf("ID=%d LUNGHEZZA=%d\n",indirizzo,len);
#endif

   indirizzo=indirizzo+len;
};

#ifdef DEBUG
/* stampo contenuto tabella label per debug */

i=0;

while (lab[i]!=01) 
{
   i1=i+strlen(lab+i)+1; f=((lab[i1])<<8)+lab[i1+1];
   printf("%s= \t\t%d,$%x\n",lab+i,f,f);
   i=i1+2;
};
#endif

return(0);
}

/**********************************
 ** TRATTAMENTO PSEUDO ISTRUZIONI**
 ** RITORNA:                     **
 ** 00=pseudo trovata            **
 ** -1=non pseudo                **
 ** >0=cod. errore incontrato    **
 **********************************/
pseudo_op(ind)
int *ind;
{
int i,ris,f,ln,f1;
char *p;

i=trov_str(istr,pseudo,0);
if (i==-1) return(-1);
ris=00; ln=00;

switch(i)               
{
   case(00): if (strlen(label)!=0) {         /* EQU */
               f=ins_lb(label,v_op[0],lab,l_lab);
               if (f==00) ris=3;
               if (f==-1) ris=6;
                                   }
      break;

   case(01): ln=n_op;                        /* FCB */
      break;

   case(02): ln=n_op<<1;                     /* FCW */
      break;

   case(03): for (f=0;f<n_op;f++)            /* FCC */
             {
               p=op[f];
               if (p[0]=='"') ln=v_op[f];
               else ln++;
             }
      break;

   case(04): ln=v_op[0];                     /* DBS */
      break;

   case(05): indirizzo=v_op[0];              /* ORG */
      break;

   case( 9): i=0;         /* elimino eventuale campo label */
             for (f=0;f<n_op;f++)            /* EXTERN */
             {
               fe=2;f1=ins_lb(op[f],0x0000,lab,l_lab);
               if (f1==-1) {i=0; ris=6; continue;}
               if (f1==00) {i=0; ris=3; continue;}
               fe=00;f1=ins_lb(op[f],0xFFFF,labe+2,s_labe);
               if (f1==-1) {i=0; ris=8;}
             }
      break;

   case(10):                                 /* PUBBLIC */
      break;


}

if (i!=0) {                                  /* compila se c'e' la label */
   if (strlen(label)!=0 AND ris==0) ris=cmp_lab(indirizzo);
          }

indirizzo=ln+indirizzo;
return(ris);
}

/**********************************
 ** TRATTAMENTO ISTRUZIONI CON   **
 ** ARGOMENTI                    **
 ** SE ISTRUZIONE TROVATA RITORNA**
 ** LUNGHEZZA ALTRIMENTI 00      **
 **********************************/
s_arg()
{
int ln,i;
i=trov_str(istr,si_op,0);
if (i==-1) return(00);

ln=0;
if (n_op==1)
{            
   switch(i)
   {
      case(01):                              /* POP */
      case(02):ln=1; if (t_op[0]==3) ln=2;   /* PUSH */
         break;

      case(06):                              /* RLC */
      case(07):                              /* RRC */
      case( 8):                              /* RR  */
      case( 9):                              /* SRL */
      case(10):                              /* RL  */
      case(11):                              /* SLA */
      case(12):ln=2; if (t_op[0]==13) ln=3;  /* SRA */
         break;
      case(13):                              /* INC */
      case(14):ln=1; if (t_op[0]==13) ln=3;  /* DEC */
               if (t_op[0]==3) ln=3;
         break;
      case(20):                              /* JR  */
      case(21):                              /* DJNZ */
               if (fe==2) {p_err(0x0A); ln=0;
                           n_error++; break;
                          }
      case(25):ln=2;                         /* IM */
         break;
      case(22):ln=3; if (t_op[0]==13) ln=2;  /* JP */
               if (t_op[0]==1) ln=1;
         break;
      case(23):ln=3;                         /* CALL */
         break;
      case(24):ln=1;                         /* RET */
         break;
      case(27):                              /* XOR */
      case(28):                              /* SUB */
      case(29):                              /* AND */
      case(30):                              /* CP  */
      case(31):                              /* OR  */
               if (fe==2) {p_err(0x0A); ln=0;
                           n_error++; break;
                          }
               ln=1; if (t_op[0]==5) ln=2;
               if (t_op[0]==13) ln=3;
         break;
      case(32):ln=1;                         /* RST */
         break;
      default :p_err(0x04); n_error++; ln=0;
   };
};

if (n_op==2)
{
   switch(i)
   {
      case(00):if (t_op[0]==1 AND t_op[1]==1) {ln=1; break;}   /* LD */
               if (t_op[0]==4 OR  t_op[1]==4) {ln=2; break;}
               if (t_op[0]==3 OR  t_op[1]==3) {
                  ln=2;
                  if (t_op[0]==5 OR t_op[1]==5) ln=4;
                  if (t_op[0]==15 OR t_op[1]==15) ln=4;
                  break;                      }
               if (t_op[0]==13 OR t_op[1]==13) {
                  ln=3;
                  if (t_op[0]==5 OR t_op[1]==5) ln=4;
                  break;                       }
               if (t_op[0]==1 OR t_op[1]==1) {
                  ln=2;
                  if (t_op[0]==15 OR t_op[1]==15) ln=3;
                  if (t_op[0]==12 OR t_op[1]==12) ln=1;
                  break;                     }
               if (t_op[0]==2 AND t_op[1]==2) {ln=1; break;}
               if (t_op[0]==12 OR t_op[1]==12) {ln=1; break;}
               if (t_op[0]==2 OR t_op[1]==2) {
                  ln=3;
                  if (strcmp(op[0],"HL")==0) break;
                  if (strcmp(op[1],"HL")==0) break;
                  if (t_op[0]==15 OR t_op[1]==15) ln=4;
                                             }
         break;
      case(03):                                               /* BIT */
      case(04):                                               /* SET */
      case(05):ln=2; if (t_op[1]==13) ln=4;                   /* RES */
         break;
      case(15):ln=1; if (t_op[1]==13) ln=3;                   /* ADD */
               if (t_op[1]==5) ln=2;
               if (t_op[0]==3 OR t_op[1]==3) ln=2;
         break;
      case(16):                                               /* ADC */
      case(17):ln=1; if (t_op[1]==13) ln=3;                   /* SBC */
               if (t_op[1]==5 OR t_op[1]==2) ln=2;
         break;
      case(18):                                               /* OUT */
      case(19):                                               /* IN  */
      case(20):ln=2;                                          /* JR  */
               if (fe==2) {p_err(0x0A); ln=0;
                           n_error++; break;
                          }
         break;
      case(22):ln=3; if (t_op[1]==13) ln=2;                   /* JP  */
               if (t_op[1]==1) ln=1;
         break;
      case(23):ln=3;                                          /* CALL */
         break;
      case(26):ln=1; if (t_op[1]==3) ln=2;                    /* EX  */
         break;

      default :p_err(0x04); n_error++; ln=0;
   }
}

return(ln);
}

/**********************************
 ** TRATTAMENTO ISTRUZIONI SENZA **
 ** ARGOMENTI                    **
 **********************************/
n_arg()
{
int ln;
ln=trov_str(istr,no_op,10);
if (ln==-1) {ln=0; p_err(0x01); n_error++;}
else ln=no_op[ln];

#ifdef DEBUG
printf("no arg=%d\n",ln);
#endif

return(ln);
}

/*********************************
 ** AGGIUNGE UNA LABEL          **
 ** str=label vl=valore         **
 ** ar=area dove metterle       **
 ** l_ar=lunghezza max. disp.   **
 ** se non c'e' posto rende -1  **
 ** se gia' esistente rende 00  **
 ** se fe=2 mette in testa uno  **
 ** 0xFF perche' poi sia ricono-**
 ** sciuta come esterna         **
 *********************************/
ins_lb(str,vl,ar,l_ar)
char *str;
unsigned char *ar;
U_S_I vl;
int l_ar;
{
register int i,i1;

i=fe;
if (trov_str(str,ar,2)!=-1) return(00);
fe=i; /* evito la modifica di fe da parte della trov_str */
i=0;
while (ar[i]!=0x01)
{
   if (ar[i++]==NULL) i=i+2;
}
if (i+strlen(str)+4>=l_ar-5) return(-1);
i1=i;

if (fe==2) ar[i1++]=0xFF;  /* identificativo per var. esterne */
for (i=0;i<=strlen(str);i++)
{
   ar[i1+i]=str[i];
}
i1=i1+i; ar[i1]=hbyte(vl); ar[i1+1]=lbyte(vl);
ar[i1+2]=0x01; ar[i1+3]=0x01;

return(0x01);
}
/***********************************
 ** COMPILAZIONE LABEL            **
 ** in v mettere valore da asse-  **
 ** gnare alla label              **
 ** ritorna 00 se tutto  OK       **
 ** altrimenti restituisce il     **
 ** codice dell'errore incontrato **
 ***********************************/
cmp_lab(v)
unsigned short int v;
{
int cd_err,f;

cd_err=0;
if (label[0]!='_') {     /* test se label normale */
   fe=0;
   f=ins_lb(label,v,lab,l_lab);
   if (f==00) cd_err=0x03;
   if (f==-1) cd_err=0x06;
                   }
else  {              /* se label rilocabile la def. come */
                     /* pubblica e come esterna contemporaneamente */
   fe=2;
   f=ins_lb(label,0x0000,lab,l_lab);
   if (f==00) cd_err=0x03;
   if (f==-1) cd_err=0x06;
   fe=0;
   f=ins_lb(label,v,labp,l_labp);
   if (f==00) cd_err=0x03;
   if (f==-1) cd_err=0x09;
   f=ins_lb(label,0xFFFF,labe+2,s_labe);
   if (f==00) cd_err=0x03;
   if (f==-1) cd_err=0x08;
       }
return(cd_err);
}

/********************************
 *** PRECOMPILAZIONE OPERANDI ***
 ********************************/
pre_op(str)
char *str;   
{

static unsigned char r8[]=
{
'A',0,'B',0,'C',0,'D',0,'E',0,'H',0,'L',0,
0x01,0x01
};

static unsigned char r16[]=
{
'A','F',0,'B','C',0,'D','E',0,
'H','L',0,'S','P',0,
0x01,0x01
};

static unsigned char tst[]=
{
'Z',0,'N','Z',0,'C',0,'N','C',0,'P','O',0,
'P','E',0,'P',0,'M',0,
0x01,0x01
};

register int i;
int v,a,f;
char reg[3];

v=0; i=0;
if (strcmp(str,"(HL)")==0) return(1);
if (str[0]=='(') {
   v=10; a=strlen(str); a=a-2;
   for(i=0;i<a;i++)
   {
      str[i]=str[i+1];
   };
   str[a]=NULL;
                 };
reg[0]=str[0]; reg[1]=str[1]; reg[2]=NULL;
if (strcmp(reg,"IX")==0 OR strcmp(reg,"IY")==0) {v=v+3; return(v);};
if (strcmp(str,"I")==0 OR strcmp(str,"R")==0) {v=v+4; return(v);};

f=0;
if (trov_str(str,r8,0)!=-1) {v=v+1; f=1;};

if (f==0) {
   if (trov_str(str,r16,0)!=-1) {v=v+2; f=1;};
          };

if (f==0) {
   if (trov_str(str,tst,0)!=-1) f=1;
          };

if (f==0) v=v+5;

return(v);
}

