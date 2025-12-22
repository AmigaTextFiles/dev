/*
*************************************************************************
*                                                                       *
* TEST TEST TEST                                                        *
* Program zum Testen der verschiedenen Netuti-Routinen                  *
*                                                                       *
*                                                                       *
*                                                                       *
*                                                                       *
*                                                                       *
*                                                                       *
*                                                                       *
*************************************************************************
*                                                                       *
*   Version 1.0   12.03.93      Olaf Asholz                             *
*                                                                       *
*                                                                       *
*                                                                       *
*************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <exec/types.h>
#include "proto/exec.h"
#include "isam.h"
//#include "netlib.h"
#include "btisam_pragmas.h"

char __stdiowin[] = "con:0/0/400/500";
struct Library *IsamBase;

#define AREA_TEXT_LEN 40

typedef struct{
  long dele;
  int  AreaId;
  char Name[AREA_TEXT_LEN+1];
}t_area;

t_area area,*SAREA;
int IDAREA=-1;
//void __asm __saveds BuildAREAKey(register __a0 void*DatS,
//                                register __d1 unsigned KeyNr,
//                                register __a1 char * IKS ) ;

__saveds __asm void BuildAREAKey(register __a0 void *DatS,
                                 register __d1 unsigned KeyNr,
                                 register __a1 char *IKS);
//void far BuildAREAKey(void *DatS, unsigned KeyNr, char */*IsamKeyStr*/ IKS);
int DateiInitAREA(int ReadOnly, int OvWrite);

//+ Datenbankbeschreibungen
//void far BuildAREAKey(void *DatS, unsigned KeyNr, char *IKS );
__saveds __asm void BuildAREAKey(register __a0 void *DatS,
                                 register __d1 unsigned KeyNr,
                                 register __a1 char *IKS )
{
  t_area *P=(t_area*) DatS;
  switch (KeyNr) {
    case 1:
      sprintf(IKS,"%4.4d",P->AreaId);
      //strupr(IKS);
    break;
    case 2:
      *IKS=0;//sprintf(IKS,"%-20.20s",P->Name);
      //strupr(IKS);
    break;
  }
}

char *MakeAREAKey(IsamKeyStr IKS,unsigned key,int AreaId,char *Name)
{
  t_area S;
  strcpy(S.Name,Name);
  S.AreaId=AreaId;

  BuildAREAKey(&S,key,IKS);
  return(IKS);
}


int DateiInitAREA(int ReadOnly,int OvWrite)
{
  Datentyp Testdatei;

  memset(&Testdatei, 0, sizeof(Testdatei));
  strcpy(Testdatei.name,"AREA");
  Testdatei.BuildKey=BuildAREAKey;
  Testdatei.anzkey=2U;
  Testdatei.IFBPtr=NULL;
  Testdatei.flag=FALSE;
  Testdatei.Save=FALSE;
  Testdatei.OvWrite=OvWrite;
  Testdatei.SetDate=FALSE;
  Testdatei.FehlerFkt=NULL;
  Testdatei.ReadOnly=ReadOnly;
  Testdatei.IsamLastError=NULL;
  Testdatei.size=sizeof(*SAREA);

  SAREA=ISAMDateiMalloc(&Testdatei);

  //for(i=0;i<Testdatei.anzkey;i++){
  //  Testdatei.id[i].laenge=strlen(MakeAREAKey(IKS,i+1,0,""));
  //}
  Testdatei.id[0].laenge=4;
  Testdatei.id[1].laenge=20; Testdatei.id[1].einein=FALSE;
  return (ISAMAddDatei (&Testdatei));
}
//-

void main()
{
  int j,i=0;
  IsamKeyStr IKS;
  time_t t1,t2;
  IsamBase =OpenLibrary("BTIsam.library",0);
  if(IsamBase){
    ISAMInit(65000L);
    IDAREA=DateiInitAREA(FALSE,TRUE);

    printf("\nSchreibSatz\n");
    for(j=0;j<10;j++){
      for(i=0;i<10;i++){
        SAREA[1].AreaId=j*10+i;
        ISAMSchreibSatz(IDAREA);
        printf("%d-%ld ",SAREA[1].AreaId,ISAMGetError());
      }
      printf("\n");
    }
    printf("FirstSatz\n");
    if(TRUE==ISAMFirstSatz(IDAREA,1U))printf("%d",SAREA[1].AreaId);

    printf("\nNEXTSATZ\n");
    do{
      printf("%d ",SAREA[1].AreaId);
    }while(TRUE==ISAMNextSatz(IDAREA,1U,""));

    printf("\nPrevSatz\n");
    do{
      printf("%d ",SAREA[1].AreaId);
    }while(TRUE==ISAMPrevSatz(IDAREA,1U,""));
    

    printf("\nLastSatz\n");
    if(TRUE==ISAMLastSatz(IDAREA,1U))printf("%d ",SAREA[1].AreaId);

    printf("\nFindSatz 10 50 75 \n");
    ISAMClearSatz(IDAREA);
    ISAMFindSatz(IDAREA,1U,MakeAREAKey(IKS,1U,10,""));
    printf("%d ",SAREA[1].AreaId);
    ISAMFindSatz(IDAREA,1U,MakeAREAKey(IKS,1U,50,""));
    printf("%d ",SAREA[1].AreaId);
    ISAMFindSatz(IDAREA,1U,MakeAREAKey(IKS,1U,75,""));
    printf("%d \n",SAREA[1].AreaId);

    printf("\nGetPos 100tel 10 50 75\n");
    printf("%ld ",ISAMGetPos(IDAREA,1U,100U,MakeAREAKey(IKS,1U,10,"")));
    printf("%ld ",ISAMGetPos(IDAREA,1U,100U,MakeAREAKey(IKS,1U,50,"")));
    printf("%ld ",ISAMGetPos(IDAREA,1U,100U,MakeAREAKey(IKS,1U,75,"")));

    ISAMExit();
    CloseLibrary(IsamBase);
  }else printf("Kann BTIsam.library nicht öffnen \n");
  printf("\nEnde. \n");
}

