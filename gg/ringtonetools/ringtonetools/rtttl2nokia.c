#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*

rtttl2nokia - Copyright 2001 Michael Kohn (naken@naken.cc)
This falls under the Kohnian license.  Please read
it at http://nakentone.naken.cc/

*/

#define VERSION "0.91"
#define VOLUME 7
#define SMS_SIZE 58     /* 140-22-(SMS_SIZE*2) = 0 or a little more
                           hopefully :) */
short int ring_stack[2048];
int stackptr;
int bitptr;
int pushback=-1;
FILE *fp;

int gettoken(char *token)
{
int tokentype;
int ptr,ch;

  tokentype=0;
  ptr=0;
  token[0]=0;

  while (1)
  {
    if (ptr>15) break;

    if (pushback!=-1)
    { ch=pushback; pushback=-1; }
      else
    { ch=getc(fp); }

    if ((ch==' ' || ch=='\t') || (ch=='\n' || ch=='\r')) continue;

    if (ch==EOF && ptr==0) return -1;
      else
    if (ch==EOF) { pushback=ch; break; }

    if ((ch>='A' && ch<='Z') || (ch>='a' && ch<='z'))
    {
      if (tokentype==1) { token[ptr++]=ch; }
        else
      if (ptr==0) { token[ptr++]=ch; tokentype=1; }
        else
      { pushback=ch; break; }
    }
      else
    if (ch>='0' && ch<='9')
    {
      if (tokentype==2) { token[ptr++]=ch; }
        else
      if (ptr==0) { token[ptr++]=ch; tokentype=2; }
        else
      { pushback=ch; break; }
    }
      else
    {
      if (ptr==0)
      {
        tokentype=3;
        token[ptr++]=ch;
        break;
      }
        else
      {
        pushback=ch;
        break;
      }
    }

  }

  token[ptr]=0;
  return tokentype;
}

int get_tempo(int tempo)
{
int t;
short int tempo_code[32]={ 25,28,31,35,40,45,50,56,63,70,80,90,100,
                         112,125,140,160,180,200,225,250,285,320,
                         355,400,450,500,565,635,715,800,900 };

  if (tempo>900) tempo=900;

  for (t=0; t<30; t++)
  {
    if (tempo_code[t]==tempo) return t;
    if (tempo_code[t]<tempo && tempo_code[t+1]>tempo)
    {
      if (tempo-tempo_code[t]<tempo_code[t+1]-tempo)
      { return t; }
        else
      { return t+1; }
    }
  }

  return t;
}

void push(int data, int size)
{
int d,t;

  d=data;
#ifdef DEBUG
printf("%d: ",stackptr);
#endif

  for (t=size-1; t>=0; t--)
  {
    d=(data>>t)&1;

#ifdef DEBUG
printf("%d",d);
#endif

    ring_stack[stackptr]&=255-(1<<bitptr);
    ring_stack[stackptr]+=(d<<bitptr);

    bitptr--;

    if (bitptr==-1)
    {
      bitptr=7;
      stackptr++;
      ring_stack[stackptr]=0;
    }
  }

#ifdef DEBUG
printf("\n");
#endif
}

void push_addr(int data, int size, int stackptr, int bitptr)
{
int d,t;

  d=data;

  for (t=size-1; t>=0; t--)
  {
    d=(data>>t)&1;
    ring_stack[stackptr]&=255-(1<<bitptr);
    ring_stack[stackptr]+=(d<<bitptr);

    bitptr--;

    if (bitptr==-1)
    {
      bitptr=7;
      stackptr++;
    }
  }
}

void print_hex(int t)
{
int lsn,msn;

  msn=t>>4;
  lsn=t&15;

  if (msn<10) { printf("%d",msn); }
    else
  { printf("%c",(msn-10+'A')); }

  if (lsn<10) { printf("%d",lsn); }
    else
  { printf("%c",(lsn-10+'A')); }
}

void print_codes()
{
int t;
int count,part,total_parts;

  count=1000;
  part=1;
  total_parts=(stackptr/SMS_SIZE)+1;

  printf("Send these messages as SMS's to your phone:\n");


  for (t=0; t<stackptr; t++)
  {
    if (count>=SMS_SIZE)
    {
      /* GIMME HEADers */

      printf("\n//SCKL15811581010%d0%d ",total_parts,part);

/*
      print_hex(0x0b);

      print_hex(0x00);
      print_hex(0x03);
      print_hex(0x01);
      print_hex(total_parts);
      print_hex(part);

      print_hex(0x05);
      print_hex(0x04);
      print_hex(0x15);
      print_hex(0x81);
      print_hex(0x15);
      print_hex(0x81);
*/
      count=0;
      part++;
    }

    print_hex(ring_stack[t]); 
    count++;
  }

  printf("\n");
}

int main (int argc, char *argv[])
{
char filename[1024];
char songname[16];
char token[16];
int t,r,l;
int d,o,b,scale,count,a0,b0;
int length,tone,octave,modifier;
int higher;

  d=4;
  o=6;
  b=63;

  count=0;
  stackptr=0;
  bitptr=7;
  scale=-1;
  higher=0;

  if (argc<2)
  {
    printf("\nrtttl2nokia "VERSION" - Convert RTTTL files to Nokia.\n");
    printf("Copyright 2001 - Michael Kohn (naken@naken.cc)\n");
    printf("Please read license before using.\n");
    printf("Usage: rtttl2nokia [options { -o }] <input filename>\n");
    printf("       -o : Make song 1 octave higher\n\n");
    exit(0);
  }

  for (t=1; t<argc; t++)
  {
    if (strcmp(argv[t],"-o")==0)
    { higher=1; }
      else
    { strncpy(filename,argv[t],1023); }
  }

  fp=fopen(filename,"r");
  if (fp==0)
  {
    printf("Could not open file for reading: %s\n",filename);
    exit(0);
  }

  push(2,8);   /* ring tone commands */
  push(74,8);
  push(29,7);

  if (gettoken(songname)==-1)
  {
    printf("Error: Illegal RTTTL format file\n");
    exit(0);
  }

  l=strlen(songname);

  push(1,3);   /* song type */
  push(l,4);   /* length of song name */

  printf("\nrtttl2nokia "VERSION" - Convert RTTTL files to Nokia.\n");
  printf("Copyright 2001 - Michael Kohn (naken@naken.cc)\n");
  printf("Please read license before using.\n\n");

  printf("       Song Name: %s\n",songname);

  for (t=0; t<l; t++)
  { push(songname[t],8); }

  push(1,8);   /* 1 song pattern */
  push(0,3);   /* pattern header id */
  push(0,2);   /* A-part */
  push(0,4);  /* loop 0 times */

  gettoken(token);

  r=0;
  while(1)
  {
    if (gettoken(token)==-1)
    {
      printf("Error: Illegal RTTTL format file\n");
      exit(0);
    }

    if (r==0)
    {
      if (strcmp(token,",")==0) continue;
        else
      if (strcmp(token,":")==0) break;
        else
      if (strcasecmp(token,"d")==0) r=1;
        else
      if (strcasecmp(token,"o")==0) r=2;
        else
      if (strcasecmp(token,"b")==0) r=3;
    }
      else
    if (strcmp(token,"=")==0)
    {
      gettoken(token);
      if (r==1) d=atoi(token);
        else
      if (r==2) o=atoi(token);
        else
      if (r==3) b=atoi(token);
      r=0;
    }
      else
    {
      printf("Error: Illegal RTTTL format file\n");
      exit(0);
    }
  }

  printf("Default Duration: %d\n",d);
  printf("   Default Scale: %d\n",o);
  printf("Beats Per Minute: %d\n",b);

  a0=stackptr;
  b0=bitptr;
  push(0,8);

  t=get_tempo(b);
  push(4,3);  /* set tempo */
  push(t,5);
  count++;

  push(3,3);       /* set style */
  push(0,2);       /* set to normal. can rtttl do others? */
  count++;

  push(5,3);       /* set volume */
  push(VOLUME,4);
  count++;

  while(1)
  {
    t=gettoken(token);
    if (t==-1) 
    { 
#ifdef DEBUG
printf("EOF\n");
#endif
      break; 
    } 

#ifdef DEBUG
    printf("%s\n",token);
#endif
    if (strcmp(token,";")==0) break; 

    length=d;

    if (t==2) 
    {
      length=atoi(token);
      t=gettoken(token);
    }

    if (length==1) length=0;
      else
    if (length==2) length=1;
      else
    if (length==4) length=2;
      else
    if (length==8) length=3;
      else
    if (length==16) length=4;
      else
    if (length==32) length=5;

    token[0]=tolower(token[0]);

    if (token[0]=='p') tone=0;
      else
    if (token[0]=='a') tone=10;
      else
    if (token[0]=='h' || token[t]=='b') tone=12;
      else
    if (token[0]=='c') tone=1;
      else
    if (token[0]=='d') tone=3;
      else
    if (token[0]=='e') tone=5;
      else
    if (token[0]=='f') tone=6;
      else
    if (token[0]=='g') tone=8;

    t=gettoken(token);

    if (token[0]=='#')
    {
      tone=tone+1;
      t=gettoken(token);
    }

    if (strcmp(token,".")==0)
    {
      modifier=1;
      t=gettoken(token); 
    }

    if (t==2)
    {
      octave=atoi(token);
      t=gettoken(token); 
    }
      else
    { octave=o; }

    if (scale!=octave)
    {
      scale=octave;
      push(2,3);
      push(octave-5+higher,2);
      count++;
    }

    modifier=0;

    if (strcmp(token,".")==0)
    {
      modifier=1;
      t=gettoken(token); 
    }

    push(1,3);
    push(tone,4);
    push(length,3);
    push(modifier,2);
    count++;

/*
    if (scale!=octave)
    {
      scale=octave;
      push(2,3);
      push(octave-5,2);
      count++;
    }
*/

    if (t==-1)
    { break; }
  }

  if (bitptr!=7) stackptr++;
  push(0,8);

  push_addr(count,8,a0,b0);

  print_codes();

  return (0);
}



