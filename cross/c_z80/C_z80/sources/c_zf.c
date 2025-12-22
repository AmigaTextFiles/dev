/*************************************************
 *******       C_Z80 Ver.:1.01         ***********
 *************************************************
 **    Compilatore per Z80 by BIANCA SOFT       **
 **     (C) Maggio 1990,Giugno 1992             **
 *************************************************/
/*************************************************
 *** FUNZIONI PER TRATTAMENTO DEGLI OPERANDI   ***
 *************************************************/

#include "c_z80.h"
#include <ctype.h>

extern int agg_vle();
extern int agg_vlr();

/********************************
 ** CALCOLO ARGOMENTO OPERANDO **
 ********************************
 ** IN str OPERANDO ,RENDE     **
 ** VALORE CALCOLATO           **
 ** O LUNGHEZZA SE STRINGA("s")**
 ** SE -1 TROVATO ERRORE       **
 ** SE -2 LABEL NON TROVATA    **
 **************************************
 ** ACCETTA I SEGUENTI OPERATORI :   **
 ** *,/,-,+;                         **
 ** numeri interi(MAX 65535)         **
 ** in base hex($) bin(%) dec()      **
 ** e label definite in tabella lab[]**
 **************************************
 ** FORMATO TABELLA lab[]:           **
 ** stringa,NULL,valore a 2 byte     **
 **************************************/
#define NULL 0L
#define MAX_VL 65535
#define MAX_VL1 255
#define HEX 0x24
#define BIN 0x25
#define STR 0x22

val_arg(str)
char *str;
{
int ln,a,v1,v2,i,v;
char cr,op;

ln=strlen(str);
i=0; v1=0; v2=0;
if (str[0]==STR) {ln=ln-2; return(ln);}
while (i<ln)
{
   cr=str[i]; a=0;
   if (cr==0x2A OR cr==0x2F OR cr==0x2B OR cr==0x2D) {op=cr; a=1; cr=str[++i];}
   for (a;a<2;a++)
   {
      if (i>=ln) {v2=0; op=0x2B; break; }
      if (cr==HEX) {i++; v=vl_hex(&i,str); goto nolab; }
      if (cr==BIN) {i++; v=vl_bin(&i,str); goto nolab; }
      if (cr>=0x30 AND cr<=0x39) {v=vl_dec(&i,str); goto nolab; }
      v=vl_lab(&i,str);
nolab:
      if (a==0) v1=v;
      if (a==1) {v2=v; break; }
      op=str[i++]; cr=str[i];
   }
   if (v1<0) { op=0; break; }
   if (v2<0) {v1=v2; op=0; break; }
   if (op==0x2A) {v1=v1*v2; continue; }
   if (op==0x2F) {v1=v1/v2; continue; }
   if (op==0x2B) {v1=v1+v2; continue; }
   if (op==0x2D) {v1=v1-v2; continue; }
   v1=-1; op=0; break;
}
if (op!=0)
   {
   if (v1<0 AND v1>-129) v1=MAX_VL1+v1+1;
   if (v1<-128) v1=MAX_VL+v1+1;
   if (v1>MAX_VL) v1=MAX_VL;
   }

return(v1);
}

/**************************
 ** CONVERSIONE DA HEX   **
 **************************/
vl_hex(p,lin)
int *p;
char *lin;
{
char cifr[4];
U_S_I v,c,i;
int a;

i=*p;
a=0;
while(isxdigit(lin[i])!=0)
{
   if (a<4) {
      if (lin[i]<0x40) cifr[a++]=lin[i]-0x30;
      else cifr[a++]=toupper(lin[i])-0x37;
            }
   i++;
}
*p=i;
c=1; v=0;
for(a--;a>=0;a--)
{
   v=v+cifr[a]*c;
   c=c<<4;
}
return((int)v);
}

/**************************
 ** CONVERSIONE DA BIN   **
 **************************/
vl_bin(p,lin)
int *p;
char *lin;
{
char cifr[16];
U_S_I i,v,c;
int a;

i=*p;
a=0;
while(lin[i]==0x30 OR lin[i]==0x31)
{
   if (a<16) cifr[a++]=lin[i]-0x30;
   i++;
}
*p=i;
c=1; v=0;
for(a--;a>=0;a--)
{
   v=v+cifr[a]*c;
   c=c<<1;
}
return((int)v);

}

/**************************
 ** CONVERSIONE DA DEC   **
 **************************/
vl_dec(p,lin)
int *p;
char *lin;
{
char cifr[5];
U_S_I i,v,c;
int a;

i=*p;
a=0;
while(isdigit(lin[i])!=0)
{
   if (a<5) cifr[a++]=lin[i]-0x30;
   i++;
}
*p=i;
c=1; v=0;
for(a--;a>=0;a--)
{
   v=v+cifr[a]*c;
   c=c*10;
}
return((int)v);

}

/**************************
 ** CONVERSIONE DA LABEL **
 **************************/
vl_lab(p,lin)
int *p;
char *lin;
{
char cifr[11];
register int a,c;
register U_S_I i;
int v;

i=*p;
v=0; c=0;
a=0;
while(isalnum(lin[i])!=0 OR lin[i]==0x5F)
{
   if (a<10) cifr[a++]=lin[i];
   i++;
}
*p=i;
cifr[a]=NULL;

c=trov_str(cifr,lab,2);
if (c==-1) return(-2);

v=(lab[c]<<8)+lab[c+1];

return (v);
}

/***********************************
 ** COMPILAZIONE ISTRUZIONI CON   **
 ** ARGOMENTI                     **
 ***********************************/
si_arg(buff)
char *buff;
{
int i,f;
register unsigned short int ln,vl0,vl1,cd;
char *p;

i=trov_str(istr,si_op,0);
if (i==-1) {p_err(0x01); n_error++; return(00);}
if (n_op>2) {p_err(0x04); n_error++; return(00);}

ln=0;
if (n_op==1)
/* compilazione istruzioni con un operando solo */
{
   f=0; cd=0; vl0=v_op[0];
 /* trasformo un eventuale stringa in un valore numerico ad 1 byte */
   if (t_op[0]==6) {t_op[0]=9; p=op[0]; vl0=p[1];}
   switch(i)
   {
      case(01):if (t_op[0]==2 AND strcmp(op[0],"SP")!=0 OR t_op[0]==3) {
                  ln=1; buff[0]=0xC1+vl0; break;            /* POP rr */
                                                                       }
               if (t_op[0]==4) {                            /* POP IX */
                  ln=2; buff[0]=pref; buff[1]=0xE1; break;
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(02):if (t_op[0]==2 AND strcmp(op[0],"SP")!=0 OR t_op[0]==3) {
                  ln=1; buff[0]=0xC5+vl0; break;            /* PUSH rr */
                                                                       }
               if (t_op[0]==4) {                            /* PUSH IX */
                  ln=2; buff[0]=pref; buff[1]=0xE5; break;
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(06):f=1; cd=00;                                  /* RLC */
      case(07):if (f==0) {f=1; cd=0x08;}                    /* RRC */
      case( 8):if (f==0) {f=1; cd=0x18;}                    /* RR  */
      case( 9):if (f==0) {f=1; cd=0x38;}                    /* SRL */
      case(10):if (f==0) {f=1; cd=0x10;}                    /* RL  */
      case(11):if (f==0) {f=1; cd=0x20;}                    /* SLA */
      case(12):if (f==0) cd=0x28;                           /* SRA */
               if (t_op[0]==0) {                            /* r */
                  ln=2; buff[0]=0xCB; buff[1]=cd+vl0; break;
                               }
               if (t_op[0]==54) {                           /* (IX+n) */
                  if (fe!=0) {p_err(0x0A); n_error++; ln=0; break;}
                  if (disp>255) {p_err(0x05); n_error++; ln=0; break;}
                  ln=4; buff[0]=pref; buff[1]=0xCB;
                  buff[2]=disp; buff[3]=cd+6; break;
                                }
               p_err(0x04); n_error++; ln=0;
         break;
      case(13):f=1; cd=0x04;                                /* INC */
      case(14):if (f==0) cd=0x05;                           /* DEC */
               if (t_op[0]==0) {                            /* r */
                  ln=1; buff[0]=cd+(vl0<<3); break;
                               }
               if (t_op[0]==54) {                           /* (IX+n) */
                  if (fe!=0) {p_err(0x0A); n_error++; ln=0; break;}
                  if (disp>255) {p_err(05); n_error++; ln=0; break;}
                  ln=3; buff[0]=pref; buff[1]=cd+(vl0<<3);
                  buff[2]=disp; break;
                                }
               if (t_op[0]==2) {                            /* rr */
                  ln=1; buff[0]=(cd==4)?0x03+vl0:0x0B+vl0; break;
                               }
               if (t_op[0]==4) {                            /* IX */
                  ln=2; buff[0]=pref;
                  buff[1]=(cd==4)?0x03+vl0:0x0B+vl0; break;
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(20):f=1; cd=0x18;                                /* JR n */
               if (fe!=0) {p_err(0x0A); n_error++; ln=0; break;}
      case(21):if (f==0) cd=0x10;                           /* DJNZ n */
               if (fe!=0) {p_err(0x0A); n_error++; ln=0; break;}
               if (t_op[0]!=9) {
                  p_err(04); n_error++; ln=0; break;
                               }
               ln=2; buff[0]=cd; cd=bra(vl0);
               if (vl0>indirizzo AND vl0-indirizzo-ln>127) {
                  p_err(07); n_error++; ln=0;
                                                           }
               if (vl0<indirizzo AND indirizzo-vl0+ln>128) {
                  p_err(07); n_error++; ln=0;
                                                           }
               buff[1]=cd;
         break;
      case(22):if (t_op[0]==9) {                            /* JP nn */
                  if (fe>=1) agg_vle(labele,indirizzo+1);
                  ln=3; buff[0]=0xC3; buff[1]=lbyte(vl0);
                  buff[2]=hbyte(vl0); break;
                               }
               if (t_op[0]==54) {                           /* JP (IX) */
                  ln=2; buff[0]=pref; buff[1]=0xE9; break;
                                }
               if (strcmp(op[0],"(HL)")==0) {               /* JP (HL) */
                  ln=1; buff[0]=0xE9; break;
                                            }
               p_err(0x04); n_error++; ln=0;
         break;
      case(23):if (t_op[0]==9) {                            /* CALL nn */
                  if (fe>=1) agg_vle(labele,indirizzo+1);
                  ln=3; buff[0]=0xCD; buff[1]=lbyte(vl0);
                  buff[2]=hbyte(vl0); break;
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(24):if (t_op[0]==7 OR t_op[0]==8) {              /* RET f */
                  ln=1; buff[0]=0xC0+vl0; break;
                                             }
               p_err(0x04); n_error++; ln=0;
         break;
      case(25):if (t_op[0]==9 AND vl0<3) {                  /* IM n */
                  ln=2; buff[0]=0xED; buff[1]=0x46;
                  buff[1]=(vl0!=2)?0x46+(vl0<<4):0x5E; break;
                                         }
               p_err(0x04); n_error++; ln=0;
         break;
      case(27):f=1; cd=0xA8;                                /* XOR */
      case(28):if (f==0) {f=1; cd=0x90;}                   /* SUB */
      case(29):if (f==0) {f=1; cd=0xA0;}                   /* AND */
      case(30):if (f==0) {f=1; cd=0xB8;}                   /* CP */
      case(31):if (f==0) cd=0xB0;
               if (t_op[0]==9) {                            /* n */
                  if (vl0>255) {p_err(05); n_error++; ln=0; break;}
                  ln=2; buff[0]=cd+0x46; buff[1]=vl0; break;
                               }
               if (t_op[0]==0) {                            /* r */
                  ln=1; buff[0]=cd+vl0; break;
                               }
               if (t_op[0]==54) {                           /* (IX+n) */
                  if (disp>255) {p_err(05); n_error++; ln=0; break;}
                  ln=3; buff[0]=pref; buff[1]=cd+vl0;
                  buff[2]=disp; break;
                                }
               p_err(0x04); n_error++; ln=0;
         break;
      case(32):if (t_op[0]==9) {                            /* RST n */
                  cd=vl0>>3; if (cd>7) {p_err(05); n_error++; ln=0; break;}
                  ln=1; buff[0]=0xC7+(cd<<3); break;
                               }
               p_err(0x04); n_error++; ln=0;
         break;

      default :p_err(0x01); n_error++; ln=0;
   }
}

if (n_op==2)
/* compilazione istruzioni con due operandi */
{
   f=0; cd=0; vl0=v_op[0]; vl1=v_op[1];
 /* trasformo un eventuale stringa in un valore numerico ad 1 byte */
   if (t_op[0]==6) {t_op[0]=9; p=op[0]; vl0=p[1];}
   if (t_op[1]==6) {t_op[1]=9; p=op[1]; vl1=p[1];}
   switch(i)
   {
      case(00):if (t_op[0]==0 AND t_op[1]==0) {             /* LD r,r */
                  ln=1; buff[0]=0x40+vl1+(vl0<<3); break;
                                              }
               if (t_op[0]==9 OR t_op[1]==9) {
                  if (t_op[0]==0) {                         /* LD r,n */
                     if (vl1>255) {p_err(0x05); n_error++; ln=0; break;}
                     ln=2; buff[0]=0x06+(vl0<<3); buff[1]=vl1;
                     break;
                                  }
                  if (t_op[0]==2) {                         /* LD rr,nn */
                     if (fe>=1) agg_vle(labele,indirizzo+1);
                     ln=3; buff[0]=0x01+vl0; buff[1]=lbyte(vl1);
                     buff[2]=hbyte(vl1); break;
                                  }
                  if (t_op[0]==4) {                         /* LD IX,nn */
                     if (fe>=1) agg_vle(labele,indirizzo+2);
                     ln=4; buff[0]=pref; buff[1]=0x21;
                     buff[2]=lbyte(vl1); buff[3]=hbyte(vl1); break;
                                  }
                  if (t_op[0]==54) {                        /* LD (IX+n),n */
                     if (disp>255) {p_err(0x05); n_error++; ln=0; break;}
                     if (vl1>255) {p_err(0x05); n_error++; ln=0; break;}
                     ln=4; buff[0]=pref; buff[1]=0x36;
                     buff[2]=disp; buff[3]=vl1; break;
                                   }
                                             }
               if (t_op[0]==59 OR t_op[1]==59) {
                  p=op[0]; if (p[0]=='A') {                 /* LD a,(nn) */
                     if (fe>=1) agg_vle(labele,indirizzo+1);
                     ln=3; buff[0]=0x3A; buff[1]=lbyte(vl1);
                     buff[2]=hbyte(vl1); break;
                                          }
                  p=op[1]; if (p[0]=='A') {                 /* LD (nn),a */
                     if (fe>=1) agg_vle(labele,indirizzo+1);
                     ln=3; buff[0]=0x32; buff[1]=lbyte(vl0);
                     buff[2]=hbyte(vl0); break;
                                          }
                  if (t_op[0]==2) {                         /* LD rr,(nn) */
                     if (v_op[0]==0x20) {                   /* LD HL,(nn) */
                        if (fe>=1) agg_vle(labele,indirizzo+1);
                        ln=3; buff[0]=0x2A; buff[1]=lbyte(vl1);
                        buff[2]=hbyte(vl1); break;
                                        }
                     ln=4; buff[0]=0xED; buff[1]=0x4B+vl0;
                     buff[2]=lbyte(vl1); buff[3]=hbyte(vl1); break;
                                  }
                  if (t_op[1]==2) {                         /* LD (nn),rr */
                     if (v_op[1]==0x20) {                   /* LD (nn),HL */
                        if (fe>=1) agg_vle(labele,indirizzo+1);
                        ln=3; buff[0]=0x22; buff[1]=lbyte(vl0);
                        buff[2]=hbyte(vl0); break;
                                        }
                     if (fe>=1) agg_vle(labele,indirizzo+2);
                     ln=4; buff[0]=0xED; buff[1]=0x43+vl1;
                     buff[2]=lbyte(vl0); buff[3]=hbyte(vl0); break;
                                  }
                  if (t_op[0]==4) {                         /* LD IX,(nn) */
                     if (fe>=1) agg_vle(labele,indirizzo+2);
                     ln=4; buff[0]=pref; buff[1]=0x2A;
                     buff[2]=lbyte(vl1); buff[3]=hbyte(vl1); break;
                                  }
                  if (t_op[1]==4) {                         /* LD (nn),IX */
                     if (fe>=1) agg_vle(labele,indirizzo+2);
                     ln=4; buff[0]=pref; buff[1]=0x22;
                     buff[2]=lbyte(vl0); buff[3]=hbyte(vl0); break;
                                  }
                                               }
               p=op[0]; if (p[0]=='A') {
                  if (t_op[1]==1) {                         /* LD A,RI */
                     ln=2; buff[0]=0xED; buff[1]=0x57+vl1; break;
                                  }
                  if (t_op[1]==52 AND strcmp(op[1],"(SP)")!=0) {
                     ln=1; buff[0]=0x0A+vl1; break;         /* LD A,(rr) */
                                                               }
                                       }
               p=op[1]; if (p[0]=='A') {
                  if (t_op[0]==1) {                         /* LD RI,A */
                     ln=2; buff[0]=0xED; buff[1]=0x47+vl0; break;
                                  }
                  if (t_op[0]==52 AND strcmp(op[0],"(SP)")!=0) {
                     ln=1; buff[0]=0x02+vl0; break;         /* LD (rr),A */
                                                               }
                                       }
               if (t_op[0]==0 OR t_op[1]==0) {
                  if (t_op[0]==54 AND strcmp(op[1],"(HL)")!=0) {
                     if (disp>255) {p_err(05); n_error++; break;}
                     ln=3; buff[0]=pref;                    /* LD (IX+n),r*/
                     buff[1]=0x70+vl1; buff[2]=disp; break;
                                                               }
                  if (t_op[1]==54 AND strcmp(op[0],"(HL)")!=0) {
                     if (disp>255) {p_err(05); n_error++; break;}
                     ln=3; buff[0]=pref;                    /* LD r,(IX+n)*/
                     buff[1]=0x46+(vl0<<3); buff[2]=disp; break;
                                                               }
                                             }
               if (strcmp(op[0],"SP")==0) {
                  if (strcmp(op[1],"HL")==0) {              /* LD SP,HL */
                     ln=1; buff[0]=0xF9; break;
                                         }
                  if (t_op[1]==4) {                         /* LD SP,IX */
                     ln=2; buff[0]=pref; buff[1]=0xF9; break;
                                  }
                                          }
               p_err(0x04); n_error++; ln=0;
         break;
      case(03):f=1; cd=0x40;                                /* BIT */
      case(04):if (f==0) {f=1; cd=0xC0;}                    /* SET */
      case(05):if (f==0) cd=0x80;                           /* RES */
               if (t_op[0]!=9) {p_err(0x04); n_error++; ln=0; break;}
               if (t_op[0]==9 AND vl0>7) {
                  p_err(0x05); n_error++; ln=0; break;
                                         }
               if (t_op[1]==0) {                            /* r */
                  ln=2; buff[0]=0xCB; buff[1]=cd+vl1+(vl0<<3); break;
                               }
               if (t_op[1]==54) {                           /* (IX+n) */
                  if (disp>255) {p_err(0x05); n_error++; ln=0; break;}
                  ln=4; buff[0]=pref; buff[1]=0xCB;
                  buff[2]=disp; buff[3]=cd+vl1+(vl0<<3); break;
                                }
               p_err(0x04); n_error++; ln=0;
         break;
      case(15):p=op[0];                                     /* ADD */
               if (p[0]=='A') {
                  if (t_op[1]==9) {                         /* A,n */
                     if (vl1>255) {p_err(05); n_error++; ln=0; break;}
                     ln=2; buff[0]=0xC6; buff[1]=vl1; break;
                                  }
                  if (t_op[1]==0) {                         /* A,r */
                     ln=1; buff[0]=0x80+vl1; break;
                                  }
                  if (t_op[1]==54) {                        /* A,(IX+n) */
                     if (disp>255) {p_err(05); n_error++; ln=0; break;}
                     ln=3; buff[0]=pref; buff[1]=0x80+vl1;
                     buff[2]=disp; break;
                                   }
                              }
               if (strcmp(p,"HL")==0 AND t_op[1]==2) {      /* HL,rr */
                  ln=1; buff[0]=0x09+vl1; break;
                                                     }
               if (t_op[0]==4) {
                  if (t_op[1]==2) {                         /* IX,rr */
                     ln=2; buff[0]=pref; buff[1]=0x09+vl1; break;
                                  }
                  if (strcmp(op[0],op[1])==0) {             /* IX,IX */
                     ln=2; buff[0]=pref; buff[1]=0x29; break;
                                              }
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(16):f=1; cd=0x88;                                /* ADC */
      case(17):p=op[0]; if (f==0) cd=0x98;                  /* SBC */
               if (p[0]=='A') {
                  if (t_op[1]==9) {                         /* A,n */
                     if (vl1>255) {p_err(05); n_error++; ln=0; break;}
                     ln=2; buff[0]=cd+0x46; buff[1]=vl1; break;
                                  }
                  if (t_op[1]==0) {                         /* A,r */
                     ln=1; buff[0]=cd+vl1; break;
                                  }
                  if (t_op[1]==54) {                        /* A,(IX+n) */
                     if (disp>255) {p_err(05); n_error++; ln=0; break;}
                     ln=3; buff[0]=pref; buff[1]=cd+vl1;
                     buff[2]=disp; break;
                                   }
                              }
               if (strcmp(p,"HL")==0 AND t_op[1]==2) {      /* HL,rr */
                  ln=2; buff[0]=0xED;
                  buff[1]=(cd==0x88) ?0x4A+vl1:0x42+vl1; break;
                                                     }
               p_err(0x04); n_error++; ln=0;
         break;
      case(18):if (t_op[0]==59) {
                  if (t_op[1]==0 AND vl1==7) {              /* OUT (n),A */
                     if (vl0>255) {p_err(05); n_error++; ln=0; break;}
                        ln=2; buff[0]=0xD3; buff[1]=vl0; break;
                                             }
                               }
               if (t_op[0]==50 AND vl0==1) {                  /* OUT (c),r */
                  if (t_op[1]==0) {
                     ln=2; buff[0]=0xED; buff[1]=0x41+(vl1<<3); break;
                                  }
                                          }
               p_err(0x04); n_error++; ln=0;
         break;
      case(19):if (t_op[1]==59) {
                  if (t_op[0]==0 AND vl0==7) {              /* IN A,(n) */
                     if (vl1>255) {p_err(05); n_error++; ln=0; break;}
                        ln=2; buff[0]=0xDB; buff[1]=vl1; break;
                                             }
                               }
               if (t_op[1]==50 AND vl1==1) {                  /* IN r,(c) */
                  if (t_op[0]==0) {
                     ln=2; buff[0]=0xED; buff[1]=0x40+(vl0<<3); break;
                                  }
                                          }
               p_err(0x04); n_error++; ln=0;
         break;
      case(20):if (t_op[1]!=9 OR t_op[0]!=7) {              /* JR f,n */
                  p_err(04); n_error++; ln=0; break;
                                             }
               ln=2; buff[0]=0x20+vl0; cd=bra(vl1);
               if (vl1>indirizzo AND vl1-indirizzo-ln>127) {
                  p_err(07); n_error++; ln=0;
                                                           }
               if (vl1<indirizzo AND indirizzo-vl1+ln>128) {
                  p_err(07); n_error++; ln=0;
                                                           }
               buff[1]=cd;
         break;
      case(22):if (t_op[1]==9) {                            /* JP f,nn */
                  if (t_op[0]==7 OR t_op[0]==8) {
                     if (fe>=1) agg_vle(labele,indirizzo+1);
                     ln=3; buff[0]=0xC2+vl0; buff[1]=lbyte(vl1);
                     buff[2]=hbyte(vl1); break;
                                                }
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(23):if (t_op[1]==9) {                             /* CALL f,nn */
                  if (t_op[0]==7 OR t_op[1]==8) {
                     if (fe>=1) agg_vle(labele,indirizzo+1);
                     ln=3; buff[0]=0xC4+vl0; buff[1]=lbyte(vl1);
                     buff[2]=hbyte(vl1); break;
                                                }
                               }
               p_err(0x04); n_error++; ln=0;
         break;
      case(26):if (strcmp(op[0],"(SP)")==0) {
                  if (strcmp(op[1],"HL")==0) {              /* EX (SP),HL */
                     ln=1; buff[0]=0xE3; break;
                                             }
                  if (t_op[1]==4) {                         /* EX (SP),IX */
                     ln=2; buff[0]=pref; buff[1]=0xE3; break;
                                  }
                                            }
               if (t_op[0]==3 AND t_op[1]==3) {             /* EX AF,AF' */
                  ln=1; buff[0]=0x08; break;
                                              }
               if (t_op[0]==2 AND t_op[1]==2) {             /* EX DE,HL */
                  if (vl0==0x10 AND vl1==0x20) {
                     ln=1; buff[0]=0xEB; break;
                                               }
                                              }
               p_err(0x04); n_error++; ln=0;
         break;

      default :p_err(0x01); n_error++; ln=0;
   }
}

return(ln);
}

/***********************************
 ** COMPILAZIONE ISTRUZIONI SENZA **
 ** ARGOMENTI                     **
 ***********************************/
no_arg(buff)
unsigned char *buff;
{
int ln,i,a;
ln=trov_str(istr,no_op,10);
if (ln==-1) {a=0; p_err(0x01); n_error++;}
else {
      a=no_op[ln]; ln++;
      for (i=0;i<a;i++)
      {
         buff[i]=no_op[ln+i];
      }
     }

return(a);
}
