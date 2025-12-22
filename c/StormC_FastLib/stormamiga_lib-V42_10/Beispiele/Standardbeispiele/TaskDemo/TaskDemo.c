/*******************************************
**                                        **
**               TaskDemo                 **
**                                        **
**              für StormC                **
**                                        **
**   Kopierrecht 1996/97 bei COMPIUTECK   **
**                                        **
**     geschrieben von Uwe Schienbein     **
**                                        **
*************** © 15/02/97 ****************/


#include <pragma/intuition_lib.h>
#include <pragma/graphics_lib.h>
#include <pragma/dos_lib.h>
#include <pragma/exec_lib.h>
#include <clib/alib_protos.h>
#include <stdlib.h>
#include <stdio.h>

struct Task *TList[8];
struct Screen *Myscreen;
struct Window *Mywindow;
struct RastPort *RPort;

BYTE Karte[12*20]={
-1,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,
-6,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-6,
-6,-0,-0,-0,-0,-0,-0,-1,-5,-5,-5,-5,-4,-0,-0,-0,-0,-1,-5,-3,
-6,-0,-1,-5,-4,-0,-0,-6,-0,-0,-0,-0,-6,-0,-0,-0,-0,-6,-0,-0,
-6,-0,-6,-0,-6,-0,-0,-6,-0,-0,-0,-0,-6,-0,-0,-0,-1,+1,-5,-4,
-2,-5,+2,-5,-3,-0,-0,-6,-0,-0,-0,-1,+3,-5,-5,-5,+4,-3,-0,-6,
-1,-5,-3,-0,-0,-0,-0,-6,-0,-1,-5,+5,+6,-5,-5,-4,-6,-0,-0,-6,
-6,-0,-0,-1,-5,-5,-4,-6,-0,-6,-0,-6,-2,-5,-5,+7,-3,-0,-0,-6,
-6,-0,-0,-6,-0,-0,-6,-6,-0,-6,-0,-6,-0,-0,-0,-6,-0,-0,-0,-6,
-6,-0,-0,-6,-0,-1,-3,-6,-0,-6,-0,-6,-0,-0,-0,-6,-0,-0,-0,-6,
-6,-0,-0,-6,-0,-2,-5,-3,-0,-2,-5,-3,-0,-0,-0,-6,-0,-0,-0,-6,
-2,-5,-5,-3,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-0,-2,-5,-5,-5,-3};

void init(void)
{
  if(!(Myscreen = OpenScreenTags(NULL,
		  SA_Depth,  4,
		  SA_Width,  320,
		  SA_Height, 256,
		  SA_Title,  "TaskDemo © 1996/97 by Uwe Schienbein",
		  TAG_DONE)))
  exit(20);

  SetRGB4(&Myscreen->ViewPort,2,4,4,4);
  RPort=&Myscreen->RastPort;

  if(!(Mywindow = OpenWindowTags(NULL,
		  WA_CustomScreen, Myscreen,
		  WA_Backdrop,
		  WA_RMBTrap,
		  WA_Borderless,
		  WA_Activate,
		  WA_IDCMP,
		  +IDCMP_VANILLAKEY,
		  TAG_DONE)))
  exit(20);
}

#define StrUR(x,y) RectFill(RPort, x+1, y+(14+1), x+2, y+(14+15));\
		   RectFill(RPort, x+1, y+(14+1), x+15, y+(14+2));

#define StrOR(x,y) RectFill(RPort, x+1, y+14, x+2, y+(14+14));\
		   RectFill(RPort, x+1, y+(14+13), x+15, y+(14+14));

#define StrOL(x,y) RectFill(RPort, x, y+(14+13), x+14, y+(14+14));\
		   RectFill(RPort, x+13, y+14, x+14, y+(14+14));

#define StrUL(x,y) RectFill(RPort, x, y+(14+1), x+14, y+(14+2));\
		   RectFill(RPort, x+13, y+(14+1), x+14, y+(14+15));

#define StrLR(x,y) RectFill(RPort, x, y+(14+1), x+15, y+(14+2));\
		   RectFill(RPort, x, y+(14+13), x+15, y+(14+14));

#define StrOU(x,y) RectFill(RPort, x+1, y+14, x+2, y+(14+15));\
		   RectFill(RPort, x+13, y+14, x+14, y+(14+15));

void Ecke(int x, int y)
{
  RectFill(RPort, x, y+14, x+2, y+(14+2));
}


void zeichneKarte(void)
{
  int x, y;
  for(x=0; x<20; x++)
  {
    for(y=0; y<12; y++)
    {
      int  a=x*16, b=y*16;
      SetAPen(RPort,0);
      RectFill(RPort,a, b+14, a+15, b+(14+15));
      SetAPen(RPort,2);
      switch(Karte[x+(y*20)])
      {
	case 0: break;
	case -1: StrUR(a, b); Ecke(a+13, b+13); break;
	case -2: StrOR(a, b); Ecke(a+13, b); break;
	case -3: StrOL(a, b); Ecke(a,   b); break;
	case -4: StrUL(a, b); Ecke(a,   b+13); break;
	case -5: StrLR(a, b); break;
	case -6: StrOU(a, b); break;
	default: Ecke(a, b); Ecke(a+13, b);
		 Ecke(a, b+13); Ecke(a+13, b+13); break;
      }
    }
  }
}

void task(void)
{
  int x=0, y=0;
  int xneu, yneu;
  int xR, yR;
  int TNum, c;
  char text[10];
  struct Task *mytask;

  mytask=FindTask(0);
  for(c=0; c<8; c++)
    if(mytask==TList[c])
      break;

  if(c>7)
    return;
  TNum=c;

  switch(TNum)
  {
    case 0: x= 2; y= 0; xR= 1; yR=0; break;
    case 1: x= 2; y=11; xR= 1; yR=0; break;
    case 2: x=18; y=11; xR=-1; yR=0; break;
    case 3: x=10; y= 6; xR= 1; yR=0; break;
    case 4: x= 2; y= 0; xR=-1; yR=0; break;
    case 5: x= 2; y=11; xR=-1; yR=0; break;
    case 6: x=18; y=11; xR= 1; yR=0; break;
    case 7: x=10; y= 6; xR=-1; yR=0; break;
  }
  sprintf(text,"Task%ld", TNum+1);
  SetAPen(RPort, 4+TNum);
  Move(RPort, ((TNum/2)*80)+20, 220+(TNum%2)*12);
  Text(RPort, text,5);

  for(;;)
  {
    if(SetSignal(0,0)&SIGBREAKF_CTRL_C)
      return;

    switch(Karte[x+(y*20)])
    {
      case -1: if(xR==-1){xR=0; yR=1;}
	       else{xR=1; yR=0;} break;
      case -2: if(xR==-1){xR=0; yR=-1;}
	       else{xR=1; yR=0;} break;
      case -3: if(xR== 1){xR=0; yR=-1;}
	       else{xR=-1; yR=0;} break;
      case -4: if(xR== 1){xR=0; yR=1;}
	       else{xR=-1; yR=0;} break;
      default: break;
    }
    xneu=x*16; yneu=y*16;
    for(c=0; c<16; c++)
    {
      SetAPen(RPort,4+TNum);
      RectFill(RPort, xneu+5, yneu+(14+5), xneu+10, yneu+(14+10));
      WaitTOF();
      SetAPen(RPort,0);
      RectFill(RPort, xneu+5, yneu+(14+5), xneu+10, yneu+(14+10));
      xneu=xneu+xR; yneu=yneu+yR;
    }
    x=x+xR; y=y+yR;
  }
}


void taskStarten(void)
{
  TList[0]=CreateTask("task1", 0, task, 9216);
  TList[1]=CreateTask("task2", 0, task, 9216);
  TList[2]=CreateTask("task3", 0, task, 9216);
  TList[3]=CreateTask("task4", 0, task, 9216);
  TList[4]=CreateTask("task5", 0, task, 9216);
  TList[5]=CreateTask("task6", 0, task, 9216);
  TList[6]=CreateTask("task7", 0, task, 9216);
  TList[7]=CreateTask("task8", 0, task, 9216);
}

void ende(void)
{
  int c;
  for(c=0; c<8; c++) if(TList[c]) { Signal(TList[c], SIGBREAKF_CTRL_C); }
  Delay(50);
  if(Mywindow) CloseWindow(Mywindow);
  if(Myscreen) CloseScreen(Myscreen);
}

void main(void)
{       
  atexit(ende);
  init();
  zeichneKarte();
  taskStarten();
  WaitPort(Mywindow->UserPort);
  exit(0);
}
