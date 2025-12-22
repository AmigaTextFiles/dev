/*---------------------------------------------------------------------*
   spal.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author  : Jan van den Baard
   Purpose : Editing the screen colors ( can be used as a seperate
                                         module for your own progs )
 *---------------------------------------------------------------------*/

#define REDVAL          REDINFO.VertPot/0x1111
#define GREENVAL        GREENINFO.VertPot/0x1111
#define BLUEVAL         BLUEINFO.VertPot/0x1111

static struct TextAttr TOPAZ80 =
 { (STRPTR)"topaz.font",8,FS_NORMAL,0
 };

static struct Gadget CGads[32];
static struct Image CIMags[32];

static struct IntuiText REDTEXT =
 { 0,0,JAM1,5,-9,&TOPAZ80,(UBYTE *)"R",NULL
 };
static struct IntuiText GREENTEXT =
 { 0,0,JAM1,5,-9,&TOPAZ80,(UBYTE *)"G",NULL
 };
static struct IntuiText BLUETEXT =
 { 0,0,JAM1,5,-9,&TOPAZ80,(UBYTE *)"B",NULL
 };
static struct IntuiText OKTEXT =
 { 0,0,JAM1,38,3,&TOPAZ80,(UBYTE *)"OK",NULL
 };
static struct IntuiText RESETTEXT =
 { 0,0,JAM1,26,3,&TOPAZ80,(UBYTE *)"RESET",NULL
 };
static struct IntuiText CANCELTEXT =
 { 0,0,JAM1,22,3,&TOPAZ80,(UBYTE *)"CANCEL",NULL
 };

static struct PropInfo REDINFO =
 { AUTOKNOB|FREEVERT,0x0000,0x0000,0x0000,0x1000,0,0,0,0,0,0
 };
static struct PropInfo GREENINFO =
 { AUTOKNOB|FREEVERT,0x0000,0x0000,0x0000,0x1000,0,0,0,0,0,0
 };
static struct PropInfo BLUEINFO =
 { AUTOKNOB|FREEVERT,0x0000,0x0000,0x0000,0x1000,0,0,0,0,0,0
 };

static struct Image REDIMAGE;
static struct Image GREENIMAGE;
static struct Image BLUEIMAGE;

static SHORT ORCPAIRS[] =
 { -1,-1,92,-1,92,13,-1,13,-1,-1
 };
static struct Border ORCBORD =
 { 0,0,0,0,JAM1,5,(SHORT *)&ORCPAIRS,NULL
 };

static struct Gadget REDGAD =
 { &CGads[0],8,21,20,75,GADGHCOMP,RELVERIFY|FOLLOWMOUSE,PROPGADGET,
   (APTR)&REDIMAGE,NULL,&REDTEXT,NULL,(APTR)&REDINFO,0,NULL
 };
static struct Gadget GREENGAD =
 { &REDGAD,30,21,20,75,GADGHCOMP,RELVERIFY|FOLLOWMOUSE,PROPGADGET,
   (APTR)&GREENIMAGE,NULL,&GREENTEXT,NULL,(APTR)&GREENINFO,1,NULL
 };
static struct Gadget BLUEGAD =
 { &GREENGAD,52,21,20,75,GADGHCOMP,RELVERIFY|FOLLOWMOUSE,PROPGADGET,
   (APTR)&BLUEIMAGE,NULL,&BLUETEXT,NULL,(APTR)&BLUEINFO,2,NULL
 };
static struct Gadget OKGAD =
 { &BLUEGAD,76,13,92,13,GADGHCOMP,RELVERIFY,BOOLGADGET,
   (APTR)&ORCBORD,NULL,&OKTEXT,NULL,NULL,3,NULL
 };
static struct Gadget RESETGAD =
 { &OKGAD,76,30,92,13,GADGHCOMP,RELVERIFY,BOOLGADGET,
   (APTR)&ORCBORD,NULL,&RESETTEXT,NULL,NULL,4,NULL
 };
static struct Gadget CANCELGAD =
 { &RESETGAD,76,47,92,13,GADGHCOMP,RELVERIFY,BOOLGADGET,
   (APTR)&ORCBORD,NULL,&CANCELTEXT,NULL,NULL,5,NULL
 };

static struct Gadget CGAD =
 { NULL,0,0,0,0,GADGHNONE|GADGIMAGE,GADGIMMEDIATE,
   BOOLGADGET,NULL,NULL,NULL,NULL,NULL,0,NULL
 };
static struct Image CIMAG =
 { 0,0,0,0,1,NULL,0,0,NULL
 };

static struct NewWindow nw =
 { 0,0,177,122,0,1,MOUSEMOVE|GADGETUP|GADGETDOWN,
   WINDOWDRAG|SMART_REFRESH|ACTIVATE|RMBTRAP,
   NULL,NULL,(UBYTE *)"Set Colors",NULL,NULL,0,0,0,0,WBENCHSCREEN
 };

static struct Window       *CReqWind;
static struct Screen       *AScreen;
static struct IntuiMessage *CReqMsg;
static struct RastPort     *CRP;
static struct Gadget       *IdGad;
static ULONG                class, ID, AMC;
static USHORT              *ResetPal, ActCol = 0;
static UBYTE vals[16] =
 { '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
 };

extern struct IntuitionBase *IntuitionBase;

static VOID DrawRect(col,x1,y1,x2,y2)
   USHORT col,x1,y1,x2,y2;
{
   SetAPen(CRP,col);
   SetDrMd(CRP,JAM1);
   Move(CRP,x1,y1); Draw(CRP,x2,y1);
   Draw(CRP,x2,y2); Draw(CRP,x1,y2);
   Draw(CRP,x1,y1);
}

static VOID calc(wi,he,c,top)
   register SHORT wi,he,top;
   register USHORT c;
{
   CIMags[c]                  = CIMAG;
   CIMags[c].PlaneOnOff       = c;
   CIMags[c].Width            = wi;
   CIMags[c].Height           = he;

   CGads[c]                   = CGAD;
   CGads[c].Width             = wi;
   CGads[c].Height            = he;
   if(c < 16) CGads[c].LeftEdge          = 8 + (wi * c);
   else       CGads[c].LeftEdge          = 8 + (wi * (c - 16));
   CGads[c].TopEdge           = top;
   CGads[c].GadgetRender      = (APTR)&CIMags[c];
   CGads[c].GadgetID          = c + 6;
   CGads[c].NextGadget        = &CGads[c + 1];
}

static VOID EvaluateGads()
{
   register USHORT i;

   AMC = (1L << AScreen->BitMap.Depth);

   if(AMC == 2)       for(i=0;i<AMC;i++) calc(80,20,i,98);
   else if(AMC == 4)  for(i=0;i<AMC;i++) calc(40,20,i,98);
   else if(AMC == 8)  for(i=0;i<AMC;i++) calc(20,20,i,98);
   else if(AMC == 16) for(i=0;i<AMC;i++) calc(10,20,i,98);
   else            {  for(i=0;i<16;i++)  calc(10,10,i,98);
                      for(   ;i<32;i++)  calc(10,10,i,108); }
   CGads[i-1].NextGadget = NULL;
}

static VOID PrintCol()
{
   UBYTE rgb[3];

   SetAPen(CRP,0);
   SetBPen(CRP,1);
   SetDrMd(CRP,JAM2);
   rgb[0] = vals[REDVAL];
   rgb[1] = vals[GREENVAL];
   rgb[2] = vals[BLUEVAL];
   Move(CRP,111,81);
   Text(CRP,(char *)&rgb[0],3);
}

static VOID SetCol(num)
   ULONG num;
{
   register int i;
   USHORT Col,x,y,x1,y1,xx,yy,xx1,yy1;
   UBYTE r,g,b;
   ULONG Pos;

   x  = CGads[num].LeftEdge;
   y  = CGads[num].TopEdge;
   x1 = x + CGads[num].Width-1;
   y1 = y + CGads[num].Height-1;

   xx  = CGads[ActCol].LeftEdge;
   yy  = CGads[ActCol].TopEdge;
   xx1 = xx + CGads[ActCol].Width-1;
   yy1 = yy + CGads[ActCol].Height-1;

   DrawRect(ActCol,xx,yy,xx1,yy1);
   DrawRect(0,x,y,x1,y1);

   DrawRect(0,75,63,168,95);
   SetAPen(CRP,num);
   RectFill(CRP,76,64,167,94);
   DrawRect(0,105,73,139,83);
   SetAPen(CRP,1);
   RectFill(CRP,106,74,138,82);

   ActCol = num;
   Col=GetRGB4(AScreen->ViewPort.ColorMap,num);
   Pos = RemoveGList(CReqWind,&BLUEGAD,3);
   r = (Col >> 8) & 0x0F;
   g = (Col >> 4) & 0x0F;
   b = (Col     ) & 0x0F;
   REDINFO.VertPot = r * 0x1111;
   GREENINFO.VertPot = g * 0x1111;
   BLUEINFO.VertPot = b * 0x1111;
   AddGList(CReqWind,&BLUEGAD,Pos,3,NULL);
   RefreshGList(&BLUEGAD,CReqWind,NULL,3);
   PrintCol();
}

static VOID MakeCol()
{
   SetRGB4(&AScreen->ViewPort,ActCol,REDVAL,GREENVAL,BLUEVAL);
   PrintCol();
}

static LONG GetIntuiMsg()
{
   if((CReqMsg = (struct IntuiMessage *)GetMsg(CReqWind->UserPort)))
   {   class = CReqMsg->Class;
       IdGad = (struct Gadget *)CReqMsg->IAddress;
       ID    = IdGad->GadgetID;
       ReplyMsg((struct Message *)CReqMsg);
       return(TRUE);
   }
   return(FALSE);
}

static VOID CleanUp()
{
   if(ResetPal) FreeMem(ResetPal,64L);
   while(GetIntuiMsg());
   if(CReqWind) CloseWindow(CReqWind);
}

static VOID Reset()
{
   LoadRGB4(&AScreen->ViewPort,ResetPal,AMC);
   SetCol(ActCol);
}

LONG SetPalette(x,y,s)
   USHORT x,y;
   struct Screen *s;
{
   if(s)
   {   AScreen = nw.Screen = s;
       nw.Type = CUSTOMSCREEN;
   }
   else AScreen = IntuitionBase->ActiveScreen;
   nw.LeftEdge = x;
   nw.TopEdge = y;
   EvaluateGads();
   if(!(CReqWind = OpenWindow(&nw))) return 1L;
   CRP = CReqWind->RPort;
   if(!(ResetPal = AllocMem(64L,MEMF_PUBLIC)))
   {   CleanUp();
       return 3L;
   }
   CopyMem((void *)AScreen->ViewPort.ColorMap->ColorTable,(void *)ResetPal,64L);
   SetAPen(CRP,1);
   RectFill(CRP,3,11,173,119);
   AddGList(CReqWind,&CANCELGAD,-1L,6+AMC,NULL);
   RefreshGList(&CANCELGAD,CReqWind,NULL,6+AMC);
   SetCol(0);
   FOREVER
   {   Wait(1<<CReqWind->UserPort->mp_SigBit);
       while(GetIntuiMsg())
       {   switch(class)
           {   case GADGETUP: switch(ID)
                              {   case 3:  CleanUp();
                                           return 0L;
                                           break;
                                  case 4:  Reset();
                                           break;
                                  case 5:  Reset();
                                           CleanUp();
                                           return 2L;
                                           break;
                                  default: break;
                              }
                              break;
             case GADGETDOWN: if(ID >= 6 && ID <= 6+AMC) SetCol(ID-6);
                              break;
             case MOUSEMOVE:  while(class == MOUSEMOVE)
                              {   while(GetIntuiMsg());
                                  MakeCol();
                              }
                              break;
             default:         break;
           }
       }
   }
}
