#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*

ems2nokia - Copyright 2001 Michael Kohn (naken@naken.cc)
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
FILE *in;

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
char song[1024];
int t,l,ptr,ch;
int b,scale,count,a0,b0;
int length,tone,octave,modifier;
int tone_modifier,ats;

  count=0;
  stackptr=0;
  bitptr=7;
  scale=-1;
  b=140;
  ats=1;

  if (argc<2)
  {
    printf("\nems2nokia "VERSION" - Convert Ericsson EMS files to Nokia.\n");
    printf("Copyright 2001 - Michael Kohn (naken@naken.cc)\n");
    printf("Please read license before using.\n");
    printf("Usage: ems2nokia [ options ] <input filename>\n");
    printf("                 -t <tempo (default: %d)>\n",b);
    printf("                 -a [force ems2nokia to ignore @'s in song]\n");
    exit(0);
  }

  for (t=1; t<argc; t++)
  {
    if (strcmp(argv[t],"-a")==0)
    { ats=0; }
      else
    if (strcmp(argv[t],"-t")==0)
    { 
      b=atoi(argv[++t]);
    }
      else
    { strncpy(filename,argv[t],1023); }
  }


  in=fopen(filename,"r");
  if (in==0)
  {
    printf("Could not open file for reading: %s\n",filename);
    exit(0);
  }

  push(2,8);   /* ring tone commands */
  push(74,8);
  push(29,7);

  ptr=0;
  while ((ch=getc(in))!=EOF)
  { song[ptr++]=ch; }

  song[ptr]=0;
  fclose(in);

  l=0;
  while (song[l]!=':' && l<15)
  {
    songname[l]=song[l++];
  }

  songname[l]=0;

  push(1,3);   /* song type */
  push(l,4);   /* length of song name */

  printf("\nems2nokia "VERSION" - Convert Ericsson EMS files to Nokia.\n");
  printf("Copyright 2001 - Michael Kohn (naken@naken.cc)\n");
  printf("Please read license before using.\n\n");

  printf("       Song Name: %s\n",songname);

  for (t=0; t<l; t++)
  { push(songname[t],8); }

  push(1,8);   /* 1 song pattern */
  push(0,3);   /* pattern header id */
  push(0,2);   /* A-part */
  push(0,4);  /* loop 0 times */

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

  l=0;
  while (song[l]!=':' && l<ptr) l++;
  l++;
  
  while (l<ptr)
  {
    if (song[l]==' ' || song[l]=='\t' || song[l]=='\r' || song[l]=='\n')
    { l++; continue; }

    if (song[l]=='@' && ats==0)
    { l++; continue; }

    if (song[l]=='+' && song[l+1]=='+') { octave=3; l=l+2; }
      else
    if (song[l]=='+') { octave=2; l++; }
      else
    { octave=1; }

    tone_modifier=0;

    if (song[l]=='#')
    {
      tone_modifier=tone_modifier+1;
      l++;
    }

    if (song[l]=='&' || song[l]=='@')
    {
      tone_modifier=tone_modifier-1;
      l++;
    }

    if (song[l]=='(' && song[l+1]=='b' && song[l+2]==')')
    {
      tone_modifier=tone_modifier-1;
      l=l+3;
    }

    if (tolower(song[l])=='a') tone=10; 
      else
    if (tolower(song[l])=='h' || tolower(song[l])=='b') tone=12;
      else
    if (tolower(song[l])=='c') tone=1;
      else
    if (tolower(song[l])=='d') tone=3;
      else
    if (tolower(song[l])=='e') tone=5;
      else
    if (tolower(song[l])=='f') tone=6;
      else
    if (tolower(song[l])=='g') tone=8;
      else
    if (tolower(song[l])=='p') tone=0;

    if (song[l]>='a' && song[l]<='z') length=3;
      else
    if (song[l]>='A' && song[l]<='Z') length=2;

    if (song[l]=='p')
    {
      if (song[l+1]=='p' && song[l+2]=='p' && song[l+3]=='p')
      { length=1; l=l+4; }
        else
      if (song[l+1]=='p')
      { length=2; l=l+2; }
        else
      { l++; }
    }
      else
    { l++; }

    if (song[l]=='.')
    {
      modifier=1;
      l++;
    }

    tone=tone+tone_modifier;

    if (scale!=octave)
    {
      scale=octave;
      push(2,3);
      push(octave,2);
      count++;
    }

    modifier=0;

    if (song[l]=='.')
    {
      modifier=1;
      l++;
    }

    push(1,3);
    push(tone,4);
    push(length,3);
    push(modifier,2);
    count++;
  }

  if (bitptr!=7) stackptr++;
  push(0,8);

  push_addr(count,8,a0,b0);

  print_codes();

  return (0);
}



