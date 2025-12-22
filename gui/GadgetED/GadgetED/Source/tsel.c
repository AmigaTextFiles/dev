/*----------------------------------------------------------------------*
   tsel.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author : Jan van den Baard
   Purpose: Selection requester for gadget & window/requester texts
 *----------------------------------------------------------------------*/

static SHORT MainPairs3[] =
 { 0,0,295,0
 };
static struct Border MainBorder3 =
 { 2,13,0,0,JAM1,2,MainPairs3,NULL
 };
static SHORT MainPairs2[] =
 { 0,0,257,0,257,101,0,101,0,0
 };
static struct Border MainBorder2 =
 { 8,17,0,0,JAM1,5,MainPairs2,&MainBorder3
 };
static SHORT MainPairs1[] =
 { 0,0,295,0,295,147,0,147,0,0
 };
static struct Border MainBorder1 =
 { 2,1,0,0,JAM1,5,MainPairs1,&MainBorder2
 };

static struct IntuiText GText =
 { 0,0,JAM1,78,4,NULL,(UBYTE *)"Select GadgetText",NULL
 };
static struct IntuiText WText =
 { 0,0,JAM1,78,4,NULL,(UBYTE *)"Select WindowText",NULL
 };
static struct IntuiText RText =
 { 0,0,JAM1,66,4,NULL,(UBYTE *)"Select RequesterText",NULL
 };

static SHORT CKPairs[] =
 { 0,0,121,0,121,20,0,20,0,0
 };
static struct Border CKBorder =
 { -1,-1,0,0,JAM1,5,CKPairs,NULL
 };
static struct IntuiText OKText =
 { 0,0,JAM1,50,6,NULL,(UBYTE *)"OK",NULL
 };
static struct Gadget OK =
 { NULL,9,124,120,19,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&CKBorder,NULL,&OKText,NULL,NULL,2,NULL
 };
static struct IntuiText CNCText =
 { 0,0,JAM1,38,6,NULL,(UBYTE *)"CANCEL",NULL
 };
static struct Gadget CNC =
 { &OK,170,124,120,19,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&CKBorder,NULL,&CNCText,NULL,NULL,1,NULL
 };
static struct PropInfo PROPInfo =
 { AUTOKNOB+FREEVERT,-1,0,6553,6553,0,0,0,0,0,0
 };
static struct Image PROPImage;
static struct Gadget PROP =
 { &CNC,269,16,26,104,NULL,RELVERIFY,PROPGADGET,
   (APTR)&PROPImage,NULL,NULL,NULL,(APTR)&PROPInfo,0,NULL
 };
static struct NewWindow sel_req =
 { 10,15,300,150,0,1,GADGETUP|GADGETDOWN,
   NOCAREREFRESH+SMART_REFRESH+ACTIVATE+RMBTRAP,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

extern struct Window      *MainWindow;
extern struct Screen      *MainScreen;
extern struct Gadget      *Gadget;
extern struct RastPort    *MainRP;
extern struct MemoryChain  Memory;
extern ULONG               Class;
extern BOOL                REQUESTER;
extern USHORT              BackFill;

static struct Gadget Gad[10];
static struct Gadget G =
 { NULL,9,18,256,10,GADGHCOMP,TOGGLESELECT+GADGIMMEDIATE,
   BOOLGADGET,NULL,NULL,NULL,NULL,NULL,0,NULL
 };
static struct RastPort *rp;
static struct Window   *tswin;
SHORT           text_num, num_text,selected = 0;

/*
 * add the text gadgets to the window
 */
VOID do_gadgets()
{
    register UCOUNT i,top=18;
    LONG            mutex = NULL;
    for(i=0;i<10;i++) mutex += (1 << (i + 3));
    for(i=0;i<10;i++,top+=10)
    {   Gad[i]                   =   G;
        Gad[i].TopEdge           =   top;
        Gad[i].GadgetID          =   i+3;
        Gad[i].MutualExclude     =   mutex;
        Gad[i].NextGadget        =   &Gad[i+1];
    }
    Gad[i].NextGadget = NULL;
    AddGList(tswin,&Gad[0],-1L,10,NULL);
}

/*
 * set the proportional gadget according to the number of texts
 */
VOID set_prop(gadget)
    struct Gadget *gadget;
{
    register struct IntuiText *t;

    num_text      = 1;
    OK.NextGadget = NULL;
    t             = gadget->GadgetText;

    while((t = t->NextText)) num_text++;

    PROPInfo.VertPot = 0;

    if(num_text <= 10)      PROPInfo.VertBody = MAXBODY;
    else if(num_text == 11) PROPInfo.VertBody = 0x8000;
    else                    PROPInfo.VertBody = MAXBODY / (num_text - 10);
}

/*
 * get the pointer to the IntuitionText structure
 * of text number 'num' in gadget 'gadget'
 */
struct IntuiText *GetPtr(gadget,num)
    struct Gadget *gadget;
    SHORT         num;
{
    register COUNT i=0;
    register struct IntuiText *t;
    t = gadget->GadgetText;
    while(i != num)
    {   if(NOT(t = t->NextText)) break;
        i++;
    }
    return(t);
}

/*
 * print the text list
 */
VOID do_text(gadget)
    struct Gadget *gadget;
{
    register ULONG             Max = 10, Pos = 0,i,y=25;
    register struct IntuiText *t;

    Pos = PROPInfo.VertPot/PROPInfo.VertBody;
    if(num_text - Pos < 10) Max = num_text;
    DeSelectGadget(tswin,&Gad[selected],NULL);
    t = GetPtr(gadget,Pos);

    SetDrMd(rp,JAM1);
    SetAPen(rp,1);
    RectFill(rp,9,18,264,117);

    for(i=0;i<Max;i++,y+=10)
    {   if(t)
        {   SetAPen(rp,0);
            Move(rp,9,y);
            if(strlen((char *)t->IText) > 32) Text(rp,(char *)t->IText,32);
            else Text(rp,(char *)t->IText,strlen((char *)t->IText));
        }
        t = t->NextText;
    }
    if(i < 10)
    {    OffGList(tswin,&Gad[i],NULL,10-i);
         SetAPen(rp,1);
         RectFill(rp,9,y-8,264,117);
    }
    if(text_num < Pos)
    {   text_num = Pos;
        SelectGadget(tswin,&Gad[0],NULL);
        selected = 0;
    }
    else if(text_num > 9)
    {   text_num = Pos+9;
        SelectGadget(tswin,&Gad[9],NULL);
        selected = 9;
    }
    else
    {   SelectGadget(tswin,&Gad[text_num - Pos],NULL);
        selected = text_num - Pos;
    }
}

/*
 * calculate the text number according to the prop position
 */
VOID do_num(num)
    SHORT num;
{
    SHORT Pos;
    Pos = PROPInfo.VertPot/PROPInfo.VertBody;
    text_num = num + Pos;
    selected = num;
}

/*
 * delete the text
 */
VOID delete_text(gadget)
    struct Gadget *gadget;
{
    struct IntuiText *t,*succ,*pred;
    LONG Pos;

    succ = GetPtr(gadget,text_num+1);
    pred = GetPtr(gadget,text_num-1);
    t    = GetPtr(gadget,text_num);
    if(t)
    {   if(pred) pred->NextText = succ;
        else gadget->GadgetText = succ;
        FreeItem(&Memory,t->IText,80L);
        FreeItem(&Memory,t,(long)sizeof(struct IntuiText));
    }
}

/*
 * clear a text from the display
 */
VOID clear_text(g)
    struct Gadget *g;
{
    struct IntuiText *ttc,it;

    ttc = GetPtr(g,text_num);
    CopyMem((void *)ttc,(void *)&it,sizeof(struct IntuiText));
    it.FrontPen = it.BackPen = 0;
    if(REQUESTER) it.FrontPen = it.BackPen = BackFill;
    it.DrawMode = JAM2;
    it.NextText = NULL;
    un_grel(MainWindow,g);
    PrintIText(MainRP,&it,g->LeftEdge,g->TopEdge);
    grel(MainWindow,g);
}

/*
 * put up the text selector
 */
LONG text_select(gadget,mode,which)
    struct Gadget *gadget;
    LONG           mode;
    USHORT         which;
{
    BOOL   running = TRUE;
    struct IntuiText *MT;
    USHORT gid;

    set_prop(gadget);
    sel_req.Screen = MainScreen;
    if(NOT(tswin = OpenWindow(&sel_req))) return;
    disable_window();
    if(which == 0) MT = &GText;
    else if(which == 1) MT = &WText;
    else MT = &RText;
    draw(tswin,&PROP,&MainBorder1,MT);
    do_gadgets();
    rp = tswin->RPort;
    SelectGadget(tswin,&Gad[0],NULL);
    do_num(0);
    do_text(gadget);
    do
    {   Wait(1 << tswin->UserPort->mp_SigBit);
        while(read_msg(tswin))
        {   if((Class == GADGETUP) OR (Class == GADGETDOWN))
            {   gid = Gadget->GadgetID;
                if(gid > 2)
                {    do_num(gid-3);
                     MutualExclude(tswin,&Gad[gid-3],&PROP,NULL);
                     SelectGadget(tswin,&Gad[gid-3],NULL);
                }
                else if((gid == 0) AND (num_text > 10)) do_text(gadget);
                else if((gid == 1) OR (gid == 2)) running = FALSE;
            }
        }
    } while(running == TRUE);
    while(read_msg(tswin));
    CloseWindow(tswin);
    enable_window();
    if(gid == 2)
    {   if(mode == 1)      return(text_num);
        else if(mode == 2)
        {   clear_text(gadget);
            edit_text(gadget,mode,text_num,which);
            return(NULL);
        }
        else
        {   clear_text(gadget);
            delete_text(gadget);
            return(NULL);
        }
    }
    return(-1L);
}
