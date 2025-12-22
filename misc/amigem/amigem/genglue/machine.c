#include <stdio.h>
#include <ctype.h>
#include "genglue.h"
#include "machine.h"

char *regnames[]=
{ "d0","d1","d2","d3","d4","d5","d6","d7",
  "a0","a1","a2","a3","a4","a5","a6","sp" };

void printvar(char *name)
{
  if(baserel)
    printf("a4@(");
  printf("_%s%s",precedevec,name);
  if(baserel)
    printf(":W)");
}

int regnum(int c)
{
  if(!isxdigit(c))
    return -1;
  else
    return isdigit(c)?c-'0':islower(c)?c-'a'+0xa:c-'A'+0xa;
}

int pushregs(int mask)
{
  int i,c=0;
  for(i=0;i<16;i++)
    if(mask&(0x8000>>i))
      c++;
  if(c<3)
  {
    for(i=0;i<16;i++)
      if(mask&(0x8000>>i))
        printf("\tmovel %s,sp@-\n",regnames[i]);
  }else
    printf("\tmoveml #0x%04x,sp@-\n",mask);
  return c;
}

int popregs(int mask)
{
  int i,c=0;
  for(i=0;i<16;i++)
    if(mask&(0x8000>>i))
      c++;
  if(c<3)
  {
    for(i=16;i-->0;)
      if(mask&(0x8000>>i))
        printf("\tmovel sp@+,%s\n",regnames[i]);
  }else
  {
    int newmask=0;
    for(i=0;i<16;i++)
    {
      newmask<<=1;
      newmask|=(mask&1);
      mask>>=1;
    }
    printf("\tmoveml sp@+,#0x%04x\n",newmask);
  }
  return c;
}

void genlabel(void)
{
  printf("\t.even\n");
  printf("\t.globl _%s%s\n",precede,namebuf);
  printf("_%s%s:\n",precede,namebuf);
}

void regmask(int *mask)
{
  int i;
  for(i=0;i<regbufcnt;i++)
  {
    if(*mask&(0x8000>>regbuf[i]))
      ERROR("Duplicate argument register");
    *mask|=0x8000>>regbuf[i];
  }
}

int allocreg(int *mask)
{
  int i;
  int reg[15]={ 8,9,0,1,2,3,4,5,6,7,0xa,0xb,0xc,0xd,0xe };
  for(i=0;i<15;i++)
    if(!(*mask&(0x8000>>reg[i])))
    {
      *mask|=0x8000>>reg[i];
      return reg[i];
    }
  ERROR("No free register");
}

void normglue(void)
{
  int i,c;
  int sparg,mask;

  if(!basepar&&!libbasevar[0])
    ERROR("missing base variable");
  mask=0x8000>>libbasereg; /* Mask of arguments */
  regmask(&mask);
  sparg=0;
  if(mask&0x0001)
  { for(i=0;i<regbufcnt;i++)
      if(regbuf[i]==15)
        sparg=i+1;
    mask&=0xfffe; }
  mask|=(preserve<-1?0x3f38:0)+(preserve<0?0x0006:0)+
        (preserve<1?0x00c0:0)+(preserve<2?0xc000:0);
  if(sparg)
    regbuf[sparg-1]=allocreg(&mask);
  genlabel();
  mask&=0x3f3f;
  c=pushregs(mask);
  if(!basepar)
  {
    printf("\tmovel ");
    printvar(libbasevar);
    printf(",%s\n",regnames[libbasereg]);
  }else
    printf("\tmovel sp@(%ld:W),%s\n",(c+1)*sizeof(long),regnames[libbasereg]);
  for(i=0;i<regbufcnt;i++)
    printf("\tmovel sp@(%ld:W),%s\n",(c+i+1+basepar)*sizeof(long),regnames[regbuf[i]]);
  if(sparg)
    printf("\texg %s,sp\n",regnames[regbuf[sparg-1]]);
  printf("\tjsr %s@",regnames[libbasereg]);
  if(liboffset>0)
    printf("(-%d:W)",liboffset*6);
  printf("\n");
  if(sparg)
    printf("\tmovel %s,sp\n",regnames[regbuf[sparg-1]]);
  if(iflag)
    printf("\tsne d0\n\textw d0\n\textl d0\n");
  popregs(mask);
  printf("\trts\n");
}

void reverseglue(void)
{
  int i,c,mask;
  genlabel();
  mask=(preserve>0?0x00c0:0)+(preserve>1?0xc000:0)+(baserel?8:0);
  c=1+pushregs(mask);
  for(i=regbufcnt;i-->0;)
  {
    printf("\tmovel %s,sp@-\n",regnames[regbuf[i]]);
    c++;
    if(regbuf[i]==15)
    {
      if(c<4)
        printf("\taddql #%d,sp@\n",c*4-4);
      else
        printf("\taddl #%d:W,sp@\n",c*4-4);
    }
  }
  if(basepar)
    printf("\tmovel %s,sp@-\n",regnames[libbasereg]);
  if(baserel)
    printf("\tjbsr ___geta4\n");
  printf("\tjbsr _%s%s\n",precedevec,namebuf);
  c=regbufcnt+basepar;
  if(c>2)
    printf("\taddaw #%d,sp\n",c*4);
  else if(c)
    printf("\taddqw #%d,sp\n",c*4);
  popregs(mask);
  if(iflag)
    printf("\tmovel #0xdff000,a0\n\ttstl d0\n");
  printf("\trts\n");
}
