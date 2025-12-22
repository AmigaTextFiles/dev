/*----------------------------------------------------------------------*
   text.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author : Jan van den Baard
   Purpose: Text requester for adding and modifying gadget texts
 *----------------------------------------------------------------------*/

static UBYTE UNDOBUFFER[80];
static SHORT MainPairs2[] =
 { 0,0,291,0
 };
static struct Border MainBorder2 =
 { 2,12,0,0,JAM1,2,MainPairs2,NULL
 };
static SHORT MainPairs1[] =
 { 0,0,291,0,291,106,0,106,0,0
 };
static struct Border MainBorder1 =
 { 2,1,0,0,JAM1,5,MainPairs1,&MainBorder2
 };

static struct IntuiText GT =
 { 0,0,JAM1,88,3,NULL,(UBYTE *)"Edit GadgetText",NULL
 };
static struct IntuiText WT =
 { 0,0,JAM1,88,3,NULL,(UBYTE *)"Edit WindowText",NULL
 };
static struct IntuiText RT =
 { 0,0,JAM1,76,3,NULL,(UBYTE *)"Edit RequesterText",NULL
 };
static struct IntuiText MainText1 =
 { 0,0,JAM1,114,35,NULL,(UBYTE *)"DrawModes",&GT
 };

static SHORT OCPairs[] =
 { 0,0,133,0,133,26,0,26,0,0
 };
static struct Border OCBorder =
 { -1,-1,0,0,JAM1,5,OCPairs,NULL
 };

static struct IntuiText CANCELText =
 { 0,0,JAM1,42,9,NULL,(UBYTE *)"CANCEL",NULL
 };
static struct Gadget CANCEL =
 { NULL,152,77,132,25,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&OCBorder,NULL,&CANCELText,NULL,NULL,6,NULL
 };

static struct IntuiText OKText =
 { 0,0,JAM1,58,9,NULL,(UBYTE *)"OK",NULL
 };
static struct Gadget OK =
 { &CANCEL,13,77,132,25,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&OCBorder,NULL,&OKText,NULL,NULL,5,NULL
 };

static SHORT DRMDPairs[] =
 { 0,0,133,0,133,12,0,12,0,0
 };
static struct Border DRMDBorder =
 { -1,-1,0,0,JAM1,5,DRMDPairs,NULL
 };

static struct IntuiText IVText =
 { 0,0,JAM1,30,2,NULL,(UBYTE *)"INVERSVID",NULL
 };
static struct Gadget IV =
 { &OK,152,60,132,11,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&DRMDBorder,NULL,&IVText,NULL,NULL,4,NULL
 };

static struct IntuiText J2Text =
 { 0,0,JAM1,49,2,NULL,(UBYTE *)"JAM2",NULL
 };
static struct Gadget J2 =
 { &IV,13,60,132,11,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&DRMDBorder,NULL,&J2Text,1,NULL,3,NULL
 };

static struct IntuiText CMText =
 { 0,0,JAM1,27,2,NULL,(UBYTE *)"COMPLEMENT",NULL
 };
static struct Gadget CM =
 { &J2,152,45,132,11,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&DRMDBorder,NULL,&CMText,NULL,NULL,2,NULL
 };

static struct IntuiText J1Text =
 { 0,0,JAM1,50,2,NULL,(UBYTE *)"JAM1",NULL
 };
static struct Gadget J1 =
 { &CM,13,45,132,11,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&DRMDBorder,NULL,&J1Text,4,NULL,1,NULL
 };

static UBYTE ITBuff[80];
static struct StringInfo ITInfo =
 { ITBuff,UNDOBUFFER,0,80,0,0,0,0,0,0,0,0,NULL
 };
static SHORT ITPairs[] =
 { 0,0,273,0,273,9,0,9,0,0
 };
static struct Border ITBorder =
 { -1,-1,2,0,JAM1,5,ITPairs,NULL
 };
static struct IntuiText ITText =
 { 0,0,JAM1,0,-10,NULL,(UBYTE *)"Enter or edit text :",NULL
 };
static struct Gadget IT =
 { &J1,13,24,272,8,NULL,STRINGCENTER,STRGADGET,
   (APTR)&ITBorder,NULL,&ITText,NULL,(APTR)&ITInfo,0,NULL
 };

struct NewWindow text_req =
 { 12,15,296,109,0,1,GADGETUP+GADGETDOWN,
   NOCAREREFRESH+SMART_REFRESH+ACTIVATE+RMBTRAP,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

static struct RastPort *rp;

extern struct Window      *MainWindow;
extern struct Screen      *MainScreen;
extern struct Gadget      *Gadget;
extern struct MemoryChain  Memory;
extern USHORT              FrontPen, BackPen;

/*
 * put up the text editor
 */
struct IntuiText *edit_text(gadget,mode,num,which)
   struct Gadget *gadget;
   LONG          mode;
   SHORT         num;
   USHORT        which;
{
   struct Window    *w;
   struct IntuiText *t,*t1, *GetPtr();
   BOOL             running = TRUE, Add;
   USHORT           gp,i;

   if(mode)
   {   t = GetPtr(gadget,num);
       strcpy((char *)ITBuff,(char *)t->IText);
   }
   else ITBuff[0] = 0;
   text_req.Screen = MainScreen;
   if(NOT(w = OpenWindow(&text_req))) return;
   disable_window();
   rp = w->RPort;
   if(NOT which) MainText1.NextText       = &GT;
   if(which == 1) MainText1.NextText      = &WT;
   else if(which == 2) MainText1.NextText = &RT;
   draw(w,&IT,&MainBorder1,&MainText1);
   DeSelectGList(w,&J1,NULL,4);
   if(mode)
   {   if(TestBits((ULONG)t->DrawMode,JAM2)) SelectGadget(w,&J2,NULL);
       else SelectGadget(w,&J1,NULL);
       if(TestBits((ULONG)t->DrawMode,COMPLEMENT))
            SelectGadget(w,&CM,NULL);
       if(TestBits((ULONG)t->DrawMode,INVERSVID))
            SelectGadget(w,&IV,NULL);
   }
   else if(NOT mode) SelectGadget(w,&J1,NULL);
   do
   {    for(i=0;i<3;i++) ActivateGadget(&IT,w,NULL);
        Wait(1 << w->UserPort->mp_SigBit);
        while(read_msg(w))
        {   gp = Gadget->GadgetID;
            if(gp == 5)
            {   running = FALSE;
                Add = TRUE;
            }
            if(gp == 6)
            {   running = FALSE;
                Add = FALSE;
            }
            if(gp == 1 OR gp == 3)
            {   MutualExclude(w,Gadget,&J1,NULL);
                SelectGadget(w,Gadget,NULL);
            }
       }
   } while(running == TRUE);
   CloseWindow(w);
   if((Add == TRUE) AND (ITBuff[0] != 0) AND (NOT mode))
   {   if(NOT(t = (struct IntuiText *)
         Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
       {   Error("Out of memory !");
           enable_window();
           return(NULL);
       }
       if(NOT(t->IText = (UBYTE *)Alloc(&Memory,80L)))
       {   FreeItem(&Memory,t,(long)sizeof(struct IntuiText));
           Error("Out of memory !");
           enable_window();
           return(NULL);
       }
       if((t1 = gadget->GadgetText))
       {   while(1)
           {   if(NOT t1->NextText) break;
               t1 = t1->NextText;
           }
           t1->NextText = t;
       }
       else gadget->GadgetText = t;
   }
   if(Add == TRUE)
   {   strcpy((char *)t->IText,(char *)ITBuff);
       t->DrawMode = NULL;
       if(SelectTest(&J1)) t->DrawMode = JAM1;
       if(SelectTest(&J2)) t->DrawMode = JAM2;
       if(SelectTest(&IV)) t->DrawMode |= INVERSVID;
       if(SelectTest(&CM)) t->DrawMode |= COMPLEMENT;
       t->FrontPen = FrontPen;
       t->BackPen  = BackPen;
       enable_window();
       if(mode) return(NULL);
       return(t);
   }
   enable_window();
   return(NULL);
}
