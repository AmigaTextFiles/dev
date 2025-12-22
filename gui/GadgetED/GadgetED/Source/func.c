/*----------------------------------------------------------------------*
   func.c Version 2.3 - © Copyright 1990-91 Jaba Development

   Author  : Jan van den Baard
   Purpose : Special subroutines used by the program
 *----------------------------------------------------------------------*/

extern struct GadgetList Gadgets;
extern struct Gadget     *Gadget, TextGadget;
extern struct Window     *MainWindow;
extern struct Screen     *MainScreen;
extern struct MemoryChain Memory;
extern ULONG             Class, WindowFlags;
extern USHORT            FrontPen, GadgetCount, id, BackFill;
extern USHORT            LightSide, DarkSide;
extern BOOL              Saved;
extern BOOL              REQUESTER;

SHORT  LB,TB;

/*
 * gadgets, borders and texts for the 'Error' requester
 */
static SHORT MainPairs1[] =
 { 2,1,307,1,307,37,2,37,2,1
 };
static struct Border MainBorder1 =
 { 0,0,0,0,JAM1,5,MainPairs1,NULL
 };
static SHORT MainPairs[] =
 { 2,0,307,0
 };
static struct Border MainBorder =
 { 0,12,0,0,JAM1,2,MainPairs,&MainBorder1
 };
static SHORT CPairs[] =
 { 0,0,111,0,111,10,0,10,0,0
 };
static struct Border CBorder =
 { -1,-1,0,0,JAM1,5,CPairs,NULL
 };
static struct IntuiText CText =
 { 0,0,JAM1,23,1,NULL,(UBYTE *)"CONTINUE",NULL
 };
static struct Gadget C =
 { NULL,101,25,110,9,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&CBorder,NULL,&CText,NULL,NULL,NULL,NULL
 };
static struct IntuiText TText =
 { 0,0,JAM1,63,3,NULL,(UBYTE *)"GadgetEd System Message",NULL
 };
static struct NewWindow err_req =
 { 5,15,310,39,0,1,GADGETUP,NOCAREREFRESH+SMART_REFRESH+ACTIVATE+RMBTRAP,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

/*
 * gadgets, borders and texts for the 'Ask' Requester
 */
static SHORT MPairs2[] =
 { 0,0,295,0,295,53,0,53,0,0
 };
static struct Border MBorder2 =
 { 2,1,0,0,JAM1,5,MPairs2,NULL
 };
static SHORT MPairs1[] =
 { 0,0,295,0
 };
static struct Border MBorder1 =
 { 2,12,0,0,JAM1,2,MPairs1,&MBorder2
 };
static SHORT YNPairs[] =
 { 0,0,126,0,126,12,0,12,0,0
 };
static struct Border YNBorder =
 { -1,-1,0,0,JAM1,5,YNPairs,NULL
 };
static struct IntuiText YText =
 { 0,0,JAM1,48,2,NULL,(UBYTE *)"YES",NULL
 };
static struct Gadget Y =
 { NULL,11,38,125,11,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&YNBorder,NULL,&YText,NULL,NULL,0,NULL
 };
static struct IntuiText NText =
 { 0,0,JAM1,55,2,NULL,(UBYTE *)"NO",NULL
 };
static struct Gadget N =
 { &Y,162,38,125,11,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&YNBorder,NULL,&NText,NULL,NULL,1,NULL
 };
static struct IntuiText TTText =
 { 0,0,JAM1,100,3,NULL,(UBYTE *)"Pleasy Verify",NULL
 };
static struct NewWindow ask_req =
 { 10,15,300,56,0,1,GADGETUP,NOCAREREFRESH+SMART_REFRESH+ACTIVATE+RMBTRAP,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

/*
 * gadgets, borders and texts for the 'About' Requester
 */
static SHORT ABPairs2[] =
 { 0,0,295,0
 };
static struct Border ABBorder2 =
 { 2,12,0,0,JAM1,2,ABPairs2,NULL
 };
static SHORT ABPairs1[] =
 { 0,0,295,0,295,67,0,67,0,0
 };
static struct Border ABBorder1 =
 { 2,1,0,0,JAM1,5,ABPairs1,&ABBorder2
 };
static struct IntuiText ABText4 =
 { 0,0,JAM1,78,38,NULL,(UBYTE *)"Jan van den Baard",NULL
 };
static struct IntuiText ABText3 =
 { 0,0,JAM1,40,27,NULL,(UBYTE *)"written in Aztec C V5.0a by",&ABText4
 };
static struct IntuiText ABText2 =
 { 0,0,JAM1,9,17,NULL,(UBYTE *)"(c) Copyright 1991 Jaba Development",&ABText3
 };
static struct IntuiText ABText1 =
 { 0,0,JAM1,54,3,NULL,(UBYTE *)"- GadgetEd Version 2.3 -",&ABText2
 };
static SHORT CONTPairs[] =
 { 0,0,157,0,157,16,0,16,0,0
 };
static struct Border CONTBorder =
 { -1,-1,0,0,JAM1,5,CONTPairs,NULL
 };
static struct IntuiText CONTText =
 { 0,0,JAM1,48,4,NULL,(UBYTE *)"CONTINUE",NULL
 };
static struct Gadget CONT =
 { NULL,68,49,156,15,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&CONTBorder,NULL,&CONTText,NULL,NULL,NULL,NULL
 };
static struct NewWindow ab_req =
 { 10,15,300,70,0,1,GADGETUP,SMART_REFRESH+NOCAREREFRESH+ACTIVATE+RMBTRAP,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

/*
 * draw the graphics of the window
 */
VOID draw(window,gadget,border,itext)
    struct Window    *window;
    struct Gadget    *gadget;
    struct Border    *border;
    struct IntuiText *itext;
{
    struct RastPort *rp;
    register struct Gadget   *g, *g1;
    register USHORT x,y,x1,y1;

    rp = window->RPort;
    SetDrMd(rp,JAM1);
    SetAPen(rp,1);
    RectFill(rp,0,0,window->Width,window->Height);

    g = gadget;
    while(1)
    {   if(TestBits((ULONG)g->GadgetType,STRGADGET))
        {   x = g->LeftEdge; y = g->TopEdge;
            x1 = x + g->Width; y1 = y + g->Height;
            RectFill(rp,x,y,x1,y1);
        }
        g1 = g->NextGadget;
        if((TestBits((ULONG)g->GadgetType,BOOLGADGET)) AND
           (NOT TestBits((ULONG)g->GadgetType,GADGET0002)))
               ShadowGadget(window,g,NULL,0);
        if(NOT g1) break;
        g = g1;
    }
    PrintIText(rp,itext,0,0);
    DrawBorder(rp,border,0,0);
    AddGList(window,gadget,-1L,-1L,NULL);
    RefreshGList(gadget,window,NULL,-1L);
}

/*
 * put up the error window
 */
VOID Error(message)
    UBYTE         *message;
{
    struct Window *erw;

    err_req.Screen = MainScreen;
    if(NOT(erw = OpenWindow(&err_req))) return;
    draw(erw,&C,&MainBorder,&TText);
    ok();
    SetDrMd(erw->RPort,JAM1);
    SetAPen(erw->RPort,2);
    Move(erw->RPort,155-(strlen((char *)message) << 2),21);
    Text(erw->RPort,(char *)message,strlen((char *)message));
    disable_window();
    do
    {   Wait(1 << erw->UserPort->mp_SigBit);
        while(read_msg(erw));
    } while(Class != GADGETUP);
    CloseWindow(erw);
    enable_window();
}

/*
 * add a border to gadget 'g'
 */
BOOL add_border(gad)
    struct MyGadget *gad;
{
    register SHORT *XY;
    SHORT           x,y,w,h,xo=0,yo=0;
    struct Border  *border,*border1;
    struct Gadget  *g;

    g = &gad->Gadget;

    if(NOT TestBits((ULONG)gad->SpecialFlags,OS20BORDER))
    {
        x = g->LeftEdge - 1;
        y = g->TopEdge  - 1;
        w = g->Width;
        h = g->Height;

        if(NOT(border = (struct Border *)Alloc(&Memory,sizeof(struct Border))))
            return(FALSE);
        if(NOT(XY = (SHORT *)Alloc(&Memory,(ULONG)20)))
            return(FALSE);

        XY[0] = XY[1] = XY[3] = XY[6] = XY[8] = XY[9] = -1;
        XY[2] = XY[4] = w;
        XY[5] = XY[7] = h;

        border->FrontPen     = FrontPen;
        border->DrawMode     = JAM1;
        border->Count        = 5;
        border->XY           = XY;

        g->GadgetRender = (APTR)border;
        return(TRUE);
    }
    else
    {
        x = g->LeftEdge;
        y = g->TopEdge;
        w = g->Width-1;
        h = g->Height-1;

        if(TestBits((ULONG)g->GadgetType,STRGADGET))
        {   x--; y--; w+=2; h++; xo=-2; yo=-1; }

        if(NOT(border = (struct Border *)Alloc(&Memory,sizeof(struct Border))))
            return(FALSE);
        if(NOT(XY = (SHORT *)Alloc(&Memory,(ULONG)20)))
            return(FALSE);

        XY[0] = XY[2] = xo;
        XY[4] = XY[6] = xo+1;
        XY[1] = XY[7] = XY[9] = yo;
        XY[3] = h;
        XY[5] = h;
        XY[8] = w-1;

        border->FrontPen     = LightSide;
        border->DrawMode     = JAM1;
        border->Count        = 5;
        border->XY           = XY;

        g->GadgetRender = (APTR)border;

        if(NOT(border1 = (struct Border *)Alloc(&Memory,sizeof(struct Border))))
            return(FALSE);
        if(NOT(XY = (SHORT *)Alloc(&Memory,(ULONG)20)))
            return(FALSE);

        XY[1] = XY[3] = XY[9] = h;
        XY[2] = XY[4] = w-1;
        XY[6] = XY[8] = w;
        XY[0] = xo+1;
        XY[5] = yo+1;
        XY[7] = yo;

        border1->FrontPen     = DarkSide;
        border1->DrawMode     = JAM1;
        border1->Count        = 5;
        border1->XY           = XY;

        border->NextBorder    = border1;
        return(TRUE);
    }
}

/*
 * add a gadget to the edit window and to the list
 */
VOID add_gadget(w,x,y,x1,y1)
    struct Window *w;
    SHORT          x,y,x1,y1;
{
    SHORT tmp;
    struct MyGadget *gadget;

    Saved = FALSE;

    if(x > x1) { tmp = x; x = x1; x1 = tmp; }
    if(y > y1) { tmp = y; y = y1; y1 = tmp; }

    if(((x1 - x) < 9) OR ((y1 - y) < 9))
    {   draw_box(w,x,y,x1,y1);
        Error("Gadget to small !");
        return;
    }

    if(NOT(gadget = (struct MyGadget *)Alloc(&Memory,sizeof(struct MyGadget))))
    {   Error("Out of memory !");
        return;
    }

    AddHead((void *)&Gadgets,(void *)gadget);

    gadget->Gadget.GadgetType      = BOOLGADGET;
    gadget->Gadget.Flags           = GADGHCOMP;
    gadget->Gadget.Activation      = RELVERIFY;

    gadget->Gadget.LeftEdge        = x + 1;
    gadget->Gadget.TopEdge         = y + 1;
    gadget->Gadget.Width           = (x1 - x) - 1;
    gadget->Gadget.Height          = (y1 - y) - 1;

    gadget->Gadget.GadgetID        = GadgetCount++;

    if(NOT(add_border(gadget)))
    {   RemHead((void *)&Gadgets);
        FreeGadget(gadget);
        Error("Out of memory !");
        return;
    }

    AddGList(w,&gadget->Gadget,-1L,1,NULL);
    RefreshGList(&gadget->Gadget,w,NULL,1);
    Format((char *)&gadget->GadgetLabel,"Gadget%ld",id++);
}

/*
 * set the absolute dimensions of a 'GREL' gadget
 */
VOID un_grel(wi,g)
    struct Window *wi;
    struct Gadget *g;
{
    SHORT l,t,w,h,ww,wh;

    l = g->LeftEdge - 1;
    t = g->TopEdge  - 1;
    w = g->Width    - 1;
    h = g->Height   - 1;

    if(TestBits((ULONG)wi->Flags,GIMMEZEROZERO))
    {   ww = wi->GZZWidth;
        wh = wi->GZZHeight;
    }
    else
    {   ww = wi->Width;
        wh = wi->Height;
    }

    if(TestBits((ULONG)g->Flags,GRELBOTTOM))
        g->TopEdge  = t + wh;
    if(TestBits((ULONG)g->Flags,GRELRIGHT))
        g->LeftEdge = l + ww;
    if(TestBits((ULONG)g->Flags,GRELWIDTH))
        g->Width    = (w + ww) + 1;
    if(TestBits((ULONG)g->Flags,GRELHEIGHT))
        g->Height   = (h + wh) + 1;
}

/*
 * set the relative dimensions of a 'GREL' gadget
 */
VOID grel(wi,g)
    struct Window *wi;
    struct Gadget *g;
{
    SHORT l,t,w,h,ww,wh;

    l = g->LeftEdge + 1;
    t = g->TopEdge  + 1;
    w = g->Width    - 1;
    h = g->Height   - 1;

    if(TestBits((ULONG)wi->Flags,GIMMEZEROZERO))
    {   ww = wi->GZZWidth;
        wh = wi->GZZHeight;
    }
    else
    {   ww = wi->Width;
        wh = wi->Height;
    }

    if(TestBits((ULONG)g->Flags,GRELBOTTOM))
        g->TopEdge  = t - wh;
    if(TestBits((ULONG)g->Flags,GRELRIGHT))
        g->LeftEdge = l - ww;
    if(TestBits((ULONG)g->Flags,GRELWIDTH))
        g->Width    = (w - ww) + 1;
    if(TestBits((ULONG)g->Flags,GRELHEIGHT))
        g->Height   = (h - wh) + 1;
}

un_gzz()
{
    struct MyGadget  *gad;
    struct Gadget    *g;
    struct IntuiText *t;
    ULONG             act;
    SHORT             lb,tb;

    lb = MainWindow->BorderLeft;
    tb = MainWindow->BorderTop;

    if(REQUESTER) return;

    if(TestBits(WindowFlags,GIMMEZEROZERO))
    {
        for(gad = Gadgets.Head; gad->Succ; gad = gad->Succ)
        {
            g   = &gad->Gadget;
            act = (ULONG)g->Activation;

            un_grel(MainWindow,g);

            if(TestBits((ULONG)gad->SpecialFlags,GZZGADGET))
            {
                if(TestBits(act,LEFTBORDER))
                {
                    if((g->LeftEdge + g->Width) > lb)
                        lb = g->LeftEdge + g->Width;
                }
                else if(TestBits(act,TOPBORDER))
                {
                    if((g->TopEdge + g->Height) > tb)
                        tb = g->TopEdge + g->Height;
                }
            }
            grel(MainWindow,g);
        }
        LB = lb; TB = tb;
        for(gad = Gadgets.Head; gad->Succ; gad = gad->Succ)
        {
            g   = &gad->Gadget;

            un_grel(MainWindow,g);

            if(NOT TestBits((ULONG)gad->SpecialFlags,GZZGADGET))
            {
                g->LeftEdge -= lb;
                g->TopEdge  -= tb;
            }
            grel(MainWindow,g);
        }

        if((t = TextGadget.GadgetText))
        {
            while(1)
            {
                t->LeftEdge -= lb;
                t->TopEdge  -= tb;
                if(NOT(t = t->NextText)) break;
            }
        }
    }
}

do_gzz()
{
    struct MyGadget  *gad;
    struct Gadget    *g;
    struct IntuiText *t;

    if(REQUESTER) return;

    if(TestBits(WindowFlags,GIMMEZEROZERO))
    {
        for(gad = Gadgets.Head; gad->Succ; gad = gad->Succ)
        {
            g   = &gad->Gadget;

            un_grel(MainWindow,g);

            if(NOT TestBits((ULONG)gad->SpecialFlags,GZZGADGET))
            {
                g->LeftEdge += LB;
                g->TopEdge  += TB;
            }
            grel(MainWindow,g);
        }

        if((t = TextGadget.GadgetText))
        {
            while(1)
            {
                t->LeftEdge += LB;
                t->TopEdge  += TB;
                if(NOT(t = t->NextText)) break;
            }
        }
    }
}

/*
 * put up the ask window
 */
LONG Ask(text,text1)
    UBYTE         *text, *text1;
{
    USHORT y,id;
    BOOL   ret;
    struct Window *aw;
    struct RastPort *rp;

    if(text1) y = 21;
    else      y = 27;
    ask_req.Screen = MainScreen;
    if(NOT(aw = OpenWindow(&ask_req))) return;
    rp = aw->RPort;
    draw(aw,&N,&MBorder1,&TTText);
    SetDrMd(rp,JAM1);
    SetAPen(rp,2);
    Move(rp,150-((strlen((char *)text) << 3) >> 1),y);
    Text(rp,(char *)text,strlen((char *)text));
    if(text1)
    {   Move(rp,150-((strlen((char *)text1) << 3) >> 1),y+10);
        Text(rp,(char *)text1,strlen((char *)text1));
    }
    disable_window();
    do
    {   Wait(1 << aw->UserPort->mp_SigBit);
        while(read_msg(aw));
       id = Gadget->GadgetID;
    } while(Class != GADGETUP);
    CloseWindow(aw);
    if(id == 1) ret = FALSE;
    else ret = TRUE;
    enable_window();
    return(ret);
}

/*
 * put up the about window
 */
VOID About()
{
    struct Window *abw;
    ab_req.Screen = MainScreen;
    if(NOT(abw = OpenWindow(&ab_req))) return;
    draw(abw,&CONT,&ABBorder1,&ABText1);
    disable_window();
    do
    {   Wait(1 << abw->UserPort->mp_SigBit);
        while(read_msg(abw));
    } while(Class != GADGETUP);
    CloseWindow(abw);
    enable_window();
}
