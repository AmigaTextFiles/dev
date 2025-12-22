/*----------------------------------------------------------------------*
   set_flags.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author  : Jan van den Baard
   Purpose : The window flags requester
 *----------------------------------------------------------------------*/

static SHORT MainPairs2[] =
 { 0,0,254,0
 };
static struct Border MainBorder2 =
 { 2,12,0,0,JAM1,2,MainPairs2,NULL
 };
static SHORT MainPairs1[] =
 { 0,0,254,0,254,139,0,139,0,0
 };
static struct Border MainBorder1 =
 { 2,1,0,0,JAM1,5,MainPairs1,&MainBorder2
 };

static SHORT OCPairs[] =
 { 0,0,115,0,115,16,0,16,0,0
 };
static struct Border OCBorder =
 { -1,-1,0,0,JAM1,5,OCPairs,NULL
 };

static struct IntuiText CNCText =
 { 0,0,JAM1,33,4,NULL,(UBYTE *)"CANCEL",NULL
 };
static struct Gadget CNC =
 { NULL,132,122,114,15,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&OCBorder,NULL,&CNCText,NULL,NULL,17,NULL
 };

static struct IntuiText OKText =
 { 0,0,JAM1,48,4,NULL,(UBYTE *)"OK",NULL
 };
static struct Gadget OK =
 { &CNC,12,122,114,15,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&OCBorder,NULL,&OKText,NULL,NULL,16,NULL
 };

static SHORT FPairs[] =
 { 0,0,115,0,115,10,0,10,0,0
 };
static struct Border FBorder =
 { -1,-1,0,0,JAM1,5,FPairs,NULL
 };

static struct IntuiText RMTText =
 { 0,0,JAM1,28,1,NULL,(UBYTE *)"RMBTRAP",NULL
 };
static struct Gadget RMT =
 { &OK,132,106,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&RMTText,NULL,NULL,15,NULL
 };

static struct IntuiText RPMText =
 { 0,0,JAM1,13,1,NULL,(UBYTE *)"REPORTMOUSE",NULL
 };
static struct Gadget RPM =
 { &RMT,132,93,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&RPMText,NULL,NULL,14,NULL
 };

static struct IntuiText ACTText =
 { 0,0,JAM1,24,1,NULL,(UBYTE *)"ACTIVATE",NULL
 };
static struct Gadget ACT =
 { &RPM,132,80,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&ACTText,NULL,NULL,13,NULL
 };

static struct IntuiText BDLText =
 { 0,0,JAM1,16,1,NULL,(UBYTE *)"BORDERLESS",NULL
 };
static struct Gadget BDL =
 { &ACT,132,67,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&BDLText,NULL,NULL,12,NULL
 };

static struct IntuiText GZZText =
 { 0,0,JAM1,5,1,NULL,(UBYTE *)"GIMMEZEROZERO",NULL
 };
static struct Gadget GZZ =
 { &BDL,132,54,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&GZZText,NULL,NULL,11,NULL
 };

static struct IntuiText BDRText =
 { 0,0,JAM1,25,1,NULL,(UBYTE *)"BACKDROP",NULL
 };
static struct Gadget BDR =
 { &GZZ,132,41,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&BDRText,NULL,NULL,10,NULL
 };

static struct IntuiText SBMText =
 { 0,0,JAM1,8,1,NULL,(UBYTE *)"SUPER_BITMAP",NULL
 };
static struct Gadget SBM =
 { &BDR,132,28,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&SBMText,3L,NULL,9,NULL
 };

static struct IntuiText SMFText =
 { 0,0,JAM1,4,1,NULL,(UBYTE *)"SMART_REFRESH",NULL
 };
static struct Gadget SMF =
 { &SBM,132,15,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&SMFText,5L,NULL,8,NULL
 };

static struct IntuiText SRFText =
 { 0,0,JAM1,0,1,NULL,(UBYTE *)"SIMPLE_REFRESH",NULL
 };
static struct Gadget SRF =
 { &SMF,12,106,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&SRFText,6L,NULL,7,NULL
 };

static struct IntuiText NCRText =
 { 0,0,JAM1,6,1,NULL,(UBYTE *)"NOCAREREFRESH",NULL
 };
static struct Gadget NCR =
 { &SRF,12,93,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&NCRText,NULL,NULL,6,NULL
 };

static struct IntuiText SBBText =
 { 0,0,JAM1,13,1,NULL,(UBYTE *)"SIZEBBOTTOM",NULL
 };
static struct Gadget SBB =
 { &NCR,12,80,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&SBBText,NULL,NULL,5,NULL
 };

static struct IntuiText SBRText =
 { 0,0,JAM1,17,1,NULL,(UBYTE *)"SIZEBRIGHT",NULL
 };
static struct Gadget SBR =
 { &SBB,12,67,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&SBRText,NULL,NULL,4,NULL
 };

static struct IntuiText WDCText =
 { 0,0,JAM1,13,1,NULL,(UBYTE *)"WINDOWCLOSE",NULL
 };
static struct Gadget WDC =
 { &SBR,12,54,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&WDCText,NULL,NULL,3,NULL
 };

static struct IntuiText WDDText =
 { 0,0,JAM1,13,1,NULL,(UBYTE *)"WINDOWDEPTH",NULL
 };
static struct Gadget WDD =
 { &WDC,12,41,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&WDDText,NULL,NULL,2,NULL
 };

static struct IntuiText WDRText =
 { 0,0,JAM1,18,1,NULL,(UBYTE *)"WINDOWDRAG",NULL
 };
static struct Gadget WDR =
 { &WDD,12,28,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&WDRText,NULL,NULL,1,NULL
 };

static struct IntuiText WDSText =
 { 0,0,JAM1,10,1,NULL,(UBYTE *)"WINDOWSIZING",NULL
 };
static struct Gadget WDS =
 { &WDR,12,15,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FBorder,NULL,&WDSText,NULL,NULL,0,NULL
 };

static struct IntuiText EText =
 { 0,0,JAM1,55,3,NULL,(UBYTE *)"Edit Window Flags",NULL
 };

static struct NewWindow sf_req =
 { 30,15,259,142,0,1,GADGETDOWN+GADGETUP,
   ACTIVATE+RMBTRAP+NOCAREREFRESH+SMART_REFRESH,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

extern struct Window     *MainWindow;
extern struct Screen     *MainScreen;
extern struct NewWindow   nw_main;
extern struct RastPort   *MainRP;
extern struct GadgetList  Gadgets;
extern struct Gadget     *Gadget;
extern ULONG              WindowFlags;
extern USHORT             GadgetCount;
extern BOOL               Saved;
extern UBYTE              wdt[80];

struct Gadget *re_arrange();

/*
 * clear all selected flags
 */
static VOID clear()
{
    register struct Gadget *g;

    g = &WDS;
    while(1)
    {   if(g == &OK) break;
        g->Flags = NULL;
        g = g->NextGadget;
    }
}

/*
 * open the flags window
 */
VOID set_flags()
{
    struct Window *sfw, *w;
    struct NewWindow nw;

    sf_req.Screen = MainScreen;
    clear();
    if(NOT(sfw = OpenWindow(&sf_req))) return;

    draw(sfw,&WDS,&MainBorder1,&EText);
    disable_window();

    if(TestBits(WindowFlags,WINDOWSIZING))   SelectGadget(sfw,&WDS,NULL);
    if(TestBits(WindowFlags,WINDOWDRAG))     SelectGadget(sfw,&WDR,NULL);
    if(TestBits(WindowFlags,WINDOWDEPTH))    SelectGadget(sfw,&WDD,NULL);
    if(TestBits(WindowFlags,WINDOWCLOSE))    SelectGadget(sfw,&WDC,NULL);
    if(TestBits(WindowFlags,SIZEBRIGHT))     SelectGadget(sfw,&SBR,NULL);
    if(TestBits(WindowFlags,SIZEBBOTTOM))    SelectGadget(sfw,&SBB,NULL);
    if(TestBits(WindowFlags,NOCAREREFRESH))  SelectGadget(sfw,&NCR,NULL);
    if(TestBits(WindowFlags,SIMPLE_REFRESH)) SelectGadget(sfw,&SRF,NULL);
    if(TestBits(WindowFlags,SMART_REFRESH))  SelectGadget(sfw,&SMF,NULL);
    if(TestBits(WindowFlags,SUPER_BITMAP))   SelectGadget(sfw,&SBM,NULL);
    if(TestBits(WindowFlags,BACKDROP))       SelectGadget(sfw,&BDR,NULL);
    if(TestBits(WindowFlags,GIMMEZEROZERO))  SelectGadget(sfw,&GZZ,NULL);
    if(TestBits(WindowFlags,BORDERLESS))     SelectGadget(sfw,&BDL,NULL);
    if(TestBits(WindowFlags,ACTIVATE))       SelectGadget(sfw,&ACT,NULL);
    if(TestBits(WindowFlags,REPORTMOUSE))    SelectGadget(sfw,&RPM,NULL);
    if(TestBits(WindowFlags,RMBTRAP))        SelectGadget(sfw,&RMT,NULL);

    do
    {   Wait(1 << sfw->UserPort->mp_SigBit);
        while(read_msg(sfw))
        {   switch(Gadget->GadgetID)
            {   case 7:
                case 8:
                case 9: MutualExclude(sfw,Gadget,&SRF,NULL);
                        SelectGadget(sfw,Gadget,NULL);
                        break;
            }
        }
    } while(Gadget->GadgetID < 16);
    CloseWindow(sfw);
    enable_window();
    if(Gadget->GadgetID == 16)
    {   WindowFlags = NULL;
        if(SelectTest(&WDS)) WindowFlags |= WINDOWSIZING;
        if(SelectTest(&WDR)) WindowFlags |= WINDOWDRAG;
        if(SelectTest(&WDD)) WindowFlags |= WINDOWDEPTH;
        if(SelectTest(&WDC)) WindowFlags |= WINDOWCLOSE;
        if(SelectTest(&SBR)) WindowFlags |= SIZEBRIGHT;
        if(SelectTest(&SBB)) WindowFlags |= SIZEBBOTTOM;
        if(SelectTest(&NCR)) WindowFlags |= NOCAREREFRESH;
        if(SelectTest(&SRF)) WindowFlags |= SIMPLE_REFRESH;
        if(SelectTest(&SMF)) WindowFlags |= SMART_REFRESH;
        if(SelectTest(&SBM)) WindowFlags |= SUPER_BITMAP;
        if(SelectTest(&BDR)) WindowFlags |= BACKDROP;
        if(SelectTest(&GZZ)) WindowFlags |= GIMMEZEROZERO;
        if(SelectTest(&BDL)) WindowFlags |= BORDERLESS;
        if(SelectTest(&ACT)) WindowFlags |= ACTIVATE;
        if(SelectTest(&RPM)) WindowFlags |= REPORTMOUSE;
        if(SelectTest(&RMT)) WindowFlags |= RMBTRAP;

        nw_main.LeftEdge  = MainWindow->LeftEdge;
        nw_main.TopEdge   = MainWindow->TopEdge;
        nw_main.Width     = MainWindow->Width;
        nw_main.Height    = MainWindow->Height;
        nw_main.DetailPen = MainWindow->DetailPen;
        nw_main.BlockPen  = MainWindow->BlockPen;
        if(strlen((char *)&wdt))
            nw_main.Title = (UBYTE *)&wdt;
        else
            nw_main.Title = NULL;
        nw_main.Flags     = NULL;
        nw_main.Screen    = MainScreen;
        nw_main.MinWidth  = MainWindow->MinWidth;
        nw_main.MinHeight = MainWindow->MinHeight;
        nw_main.MaxWidth  = MainWindow->MaxWidth;
        nw_main.MaxHeight = MainWindow->MaxHeight;

        if(TestBits(WindowFlags,WINDOWSIZING))
              nw_main.Flags |= WINDOWSIZING;
        else if(TestBits(nw_main.Flags,WINDOWSIZING))
              nw_main.Flags ^= WINDOWSIZING;

        if(TestBits(WindowFlags,WINDOWDRAG))
              nw_main.Flags |= WINDOWDRAG;
        else if(TestBits(nw_main.Flags,WINDOWDRAG))
              nw_main.Flags ^= WINDOWDRAG;

        if(TestBits(WindowFlags,WINDOWDEPTH))
              nw_main.Flags |= WINDOWDEPTH;
        else if(TestBits(nw_main.Flags,WINDOWDEPTH))
              nw_main.Flags ^= WINDOWDEPTH;

        if(TestBits(WindowFlags,WINDOWCLOSE))
              nw_main.Flags |= WINDOWCLOSE;
        else if(TestBits(nw_main.Flags,WINDOWCLOSE))
              nw_main.Flags ^= WINDOWCLOSE;

        if(TestBits(WindowFlags,SIZEBRIGHT))
              nw_main.Flags |= SIZEBRIGHT;
        else if(TestBits(nw_main.Flags,SIZEBRIGHT))
              nw_main.Flags ^= SIZEBRIGHT;

        if(TestBits(WindowFlags,SIZEBBOTTOM))
              nw_main.Flags |= SIZEBBOTTOM;
        else if(TestBits(nw_main.Flags,SIZEBBOTTOM))
              nw_main.Flags ^= SIZEBBOTTOM;

        nw_main.Flags |= NOCAREREFRESH+SMART_REFRESH+ACTIVATE;

        add_bo();
        nw_main.FirstGadget = re_arrange();

        if(NOT(w = OpenWindow(&nw_main)))
        {   Error("Can't change window !");
            return;
        }
        ClearMenuStrip(MainWindow);
        CloseWindow(MainWindow);
        MainWindow = w;
        MainRP     = MainWindow->RPort;
        SetMenu(MainWindow);
        rem_bo();
        refresh();
        Saved = FALSE;
    }
}
