#include <exec/resident.h>
#include <exec/memory.h>
#include <dos/doshunks.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <setjmp.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/time.h>
#include <exec/io.h>
#include <exec/semaphores.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#include <amigem/machine.h>

#include <amigem/fd_lib.h>

void *const basetabl[]=
{
  NULL,NULL,NULL,NULL,NULL, /* 0 */
  NULL,NULL,NULL,NULL,NULL,
  &CacheClearU,	/* 10 */
  &CacheClearE,
  &CachePreDMA,
  &CachePostDMA,
  NULL,NULL,NULL,NULL,NULL,NULL,
  &SDivMod32,	/* 20 */
  &SMult32,
  &SMult64,
  &UDivMod32,
  &UMult32,
  &UMult64,
  NULL,NULL,NULL,NULL,
  &malloc,	/* 30 */
  NULL,NULL,NULL,NULL,
  (void *)&exit,	/* 35 */
  &setjmp,
  &longjmp,
  NULL,NULL,
  &kill,	/* 40 */
  &getpid,
  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
  &sigprocmask,	/* 50 */
  &sigsuspend,
  &sigaction,
  NULL,NULL,NULL,NULL,NULL,NULL,NULL,
  &open,	/* 60 */
  &close,
  &read,
  &write,&puts,
  NULL,NULL,NULL,NULL,NULL,
  NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
  &setitimer,	/* 80 */
};

void readall(int file,void *buf,int size)
{
  char *b=buf;
  do
  {
    int l;
    if((l=read(file,b,size))<0)
    {
      fputs("error reading file\n",stderr);
      exit(20);
    }
    b+=l;
    size-=l;
  }while(size);
}

char *allocmem(size_t size)
{
  char *ret;
  if((ret=malloc(size))==NULL)
  {
    fputs("out of memory\n",stderr);
    exit(20);
  }
  return ret;
}

void *loadseg(char *filename)
{
  unsigned long	a,b,first,count=0,i;
  int read=0;

  int file;
  unsigned long numsegs=0;
  char **hunks;
  unsigned long *hunksizes;

  if((file=open(filename,O_RDONLY,0))<0)
    goto error;
  readall(file,&a,sizeof(unsigned long));
  if(a!=HUNK_HEADER)
    goto error;
  for(;;)
  {
    readall(file,&a,sizeof(unsigned long));
    if(!a)
      break;
    if(lseek(file,a*sizeof(unsigned long),SEEK_CUR)<0)
      goto error;
  }
  readall(file,&numsegs,sizeof(unsigned long));
  if(!numsegs)
    goto error;
  readall(file,&first,sizeof(unsigned long));
  readall(file,&a,sizeof(unsigned long));
  if(a-first!=numsegs-1)
    goto error;
  hunks=alloca(numsegs*sizeof(char *));
  hunksizes=alloca(numsegs*sizeof(unsigned long));
  for(i=0;i<numsegs;i++)
  {
    readall(file,&a,sizeof(unsigned long));
    if(a&(HUNKF_CHIP|HUNKF_FAST))
      goto error;
    a*=sizeof(unsigned long);
    hunks[i]=allocmem(a);
    hunksizes[i]=a;
  }

  do
  {
    readall(file,&a,sizeof(unsigned long));
    switch(a)
    {
      case HUNK_CODE:
      case HUNK_DATA:
      case HUNK_BSS:
        readall(file,&b,sizeof(unsigned long));
        b*=sizeof(unsigned long);
        if(b>hunksizes[count])
          goto error;
        if((a&~(HUNKF_CHIP|HUNKF_FAST))!=HUNK_BSS)
          readall(file,hunks[count],b);
        read=1;
        break;
      case HUNK_ABSRELOC32:
        if(!read)
          goto error;
        for(;;)
        {
          readall(file,&a,sizeof(unsigned long));
          if(!a)
            break;
          readall(file,&i,sizeof(unsigned long));
          i-=first;
          if(i>=numsegs)
            goto error;
          while(a--)
          {
            readall(file,&b,sizeof(unsigned long));
            if(b>=hunksizes[count]-sizeof(unsigned long))
              goto error;
            *(unsigned long *)&hunks[count][b]+=(unsigned long)hunks[i];
          }
        }        
        break;
      case HUNK_SYMBOL:
        for(;;)
        {
          readall(file,&a,sizeof(unsigned long));
          if(!a)
            break;
          if(lseek(file,((a&0xffffff)+1)*sizeof(unsigned long),SEEK_CUR)<0)
            goto error;
        }
        break;
      case HUNK_DEBUG:
        readall(file,&a,sizeof(unsigned long));
        if(lseek(file,a*sizeof(unsigned long),SEEK_CUR)<0)
          goto error;
        break;
      case HUNK_END:
        count++;
        read=0;
        break;
      default:
        goto error;
    }
  }while(count<numsegs);
  
  if(close(file))
  { file=0;
    goto error; }

  CacheClearU();

  return hunks[0];

error:
  
  fputs("Missing or malformatted load file: ",stderr);
  fputs(filename,stderr);
  fputs("\n",stderr);
  exit(20);
  return 0;
}

FC3(0,LONG,Init,A1,APTR dummy1,D0,BPTR dummy2,A0,APTR ft,A6)
;

void startromtag(void *seg)
{
  UWORD *w=(UWORD *)seg;

  for(;;)
  {
    struct Resident *r=(struct Resident *)w;
    if(r->rt_MatchWord==RTC_MATCHWORD&&r==r->rt_MatchTag)
      Init(r->rt_Init,NULL,0,(APTR)basetabl);
    w++;
  }
}

int main(int argc,char *argv[])
{
  void *rom;

  rom=loadseg("Devs/amigem");  /* load amigem image */

  startromtag(rom);

  return 0;
}
