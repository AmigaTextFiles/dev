#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <exec/types.h>
#include <devices/trackdisk.h>

void DoStuff(int, const char *);
struct MsgPort *CreatePort(char *, LONG);
void DeletePort(struct MsgPort *);
struct IOStdReq *CreateExtIO(struct MsgPort *, ULONG);
void DeleteExtIO(struct IOStdReq *);
long OpenDevice(char *, ULONG, struct IOStdReq *, ULONG);
void CloseDevice(struct IOStdReq *);

void main(int argc, char **argv)
{
 if (argc<2)
  {
   printf("Usage: %s [-]<0..%1d>\n",argv[0],NUMUNITS-1);
   exit(20);
  }

 while (--argc)
  {
   argv++;
   if (**argv=='-') DoStuff(0,*argv+1);
   else DoStuff(1,*argv);
  }

 exit(0);
}

void DoStuff(int doit, const char *arg)
{
 ULONG unit;
 struct MsgPort *iop;
 struct IOStdReq *ior;

 if (!isdigit(*arg))
  {
   printf("Bad argument '%c'!\n",*arg);
   return;
  }

 unit=atol(arg);

 if ((unit<0) || (unit>NUMUNITS-1))
  {
   printf("Bad drive number '%ld'!\n",unit);
   return;
  }

 if (iop=CreatePort("",0))
  {
   if (ior=CreateExtIO(iop,sizeof(struct IOStdReq)))
    {
     if (!OpenDevice(TD_NAME,unit,ior,0))
      {
       if (ior->io_Device->dd_Library.lib_Version>=36)
        {
         printf("NoClick unit %ld ",unit);

         if (doit)
          {
           ((struct TDU_PublicUnit *) (ior->io_Unit))->tdu_PubFlags|=TDPF_NOCLICK;
           printf("ON\n");
          }
         else
          {
           ((struct TDU_PublicUnit *) (ior->io_Unit))->tdu_PubFlags&=~TDPF_NOCLICK;
           printf("OFF\n");
          }
        }
       else
        printf("'" TD_NAME "' version 36 or better required!\n");

       CloseDevice(ior);
      }
     else
      printf("Can't open '" TD_NAME "' for unit %ld!\n",unit);

     DeleteExtIO(ior);
    }
   else
    printf("Can't create IORequest!\n");

   DeletePort(iop);
  }
 else
  printf("Can't create port!\n");
}

