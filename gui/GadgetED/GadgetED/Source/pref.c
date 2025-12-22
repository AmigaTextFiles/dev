/*----------------------------------------------------------------------*
   pref.c Version 2.3 - © Copyright 1990-91 Jaba Development

   Author  : Jan van den Baard
   Purpose : the preferences requester
 *----------------------------------------------------------------------*/

static UBYTE UNDOBUFFER[80];

static SHORT MainPairs2[] =
 { 0,0,296,0,296,127,0,127,0,0
 };
static struct Border MainBorder2 =
 { 2,1,0,0,JAM1,5,MainPairs2,NULL
 };
static SHORT MainPairs1[] =
 { 0,0,296,0
 };
static struct Border MainBorder1 =
 { 2,12,0,0,JAM1,2,MainPairs1,&MainBorder2
 };

static SHORT SUPairs[] =
 { 0,0,87,0,87,13,0,13,0,0
 };
static struct Border SUBorder =
 { -1,-1,0,0,JAM1,5,SUPairs,NULL
 };

static struct IntuiText SUText =
 { 0,0,JAM1,3,2,NULL,(UBYTE *)"Save & Use",NULL
 };
static struct Gadget SU =
 { NULL,203,113,86,12,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&SUBorder,NULL,&SUText,NULL,NULL,9,NULL
 };

static struct IntuiText USText =
 { 0,0,JAM1,33,2,NULL,(UBYTE *)"Use",NULL
 };
static struct Gadget US =
 { &SU,107,113,86,12,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&SUBorder,NULL,&USText,NULL,NULL,8,NULL
 };

static struct IntuiText SAText =
 { 0,0,JAM1,27,2,NULL,(UBYTE *)"Save",NULL
 };
static struct Gadget SA =
 { &US,12,113,86,12,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&SUBorder,NULL,&SAText,NULL,NULL,7,NULL
 };

static SHORT RWPairs[] =
 { 0,0,136,0,136,10,0,10,0,0
 };
static struct Border RWBorder =
 { -1,-1,0,0,JAM1,5,RWPairs,NULL
 };

static struct IntuiText REText =
 { 0,0,JAM1,30,1,NULL,(UBYTE *)"REQUESTER",NULL
 };
static struct Gadget RE =
 { &SA,155,99,135,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&RWBorder,NULL,&REText,1L,NULL,3,NULL
 };

static struct IntuiText WDText =
 { 0,0,JAM1,43,1,NULL,(UBYTE *)"WINDOW",NULL
 };
static struct Gadget WD =
 { &RE,12,99,135,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&RWBorder,NULL,&WDText,2L,NULL,2,NULL
 };

static SHORT OPPairs[] =
 { 0,0,279,0,279,11,0,11,0,0
 };
static struct Border OPBorder =
 { -1,-1,0,0,JAM1,5,OPPairs,NULL
 };

static struct IntuiText NFText =
 { 0,0,JAM1,59,1,NULL,(UBYTE *)"RAW Assembler Source",NULL
 };
static struct Gadget NF =
 { &WD,12,85,278,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&OPBorder,NULL,&NFText,NULL,NULL,4,NULL
 };

static struct IntuiText STText =
 { 0,0,JAM1,71,1,NULL,(UBYTE *)"Static Structures",NULL
 };
static struct Gadget ST =
 { &NF,12,71,278,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&OPBorder,NULL,&STText,NULL,NULL,1,NULL
 };

static struct IntuiText TCText =
 { 0,0,JAM1,103,1,NULL,(UBYTE *)"Text Copy",NULL
 };
static struct Gadget TC =
 { &ST,12,57,278,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&OPBorder,NULL,&TCText,NULL,NULL,1,NULL
 };

static struct IntuiText ICText =
 { 0,0,JAM1,99,1,NULL,(UBYTE *)"Image Copy",NULL
 };
static struct Gadget IC =
 { &TC,12,43,278,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&OPBorder,NULL,&ICText,NULL,NULL,1,NULL
 };

static struct IntuiText AUSText =
 { 0,0,JAM1,40,1,NULL,(UBYTE *)"Auto Gadget -> Image size",NULL
 };
static struct Gadget AUS =
 { &IC,12,29,278,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&OPBorder,NULL,&AUSText,1,NULL,0,NULL
 };

static struct IntuiText SZPText =
 { 0,0,JAM1,58,1,NULL,(UBYTE *)"Skip zero bit-planes",NULL
 };
static struct Gadget SZP =
 { &AUS,12,15,278,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&OPBorder,NULL,&SZPText,NULL,NULL,0,NULL
 };

static struct IntuiText MainText =
 { 0,0,JAM1,107,3,NULL,(UBYTE *)"Preferences",NULL
 };

static struct NewWindow pr_req =
 { 10,15,301,130,0,1,GADGETUP+GADGETDOWN,
   NOCAREREFRESH+SMART_REFRESH+ACTIVATE+RMBTRAP,
   NULL,NULL,NULL,NULL,NULL,0,0,0,0,CUSTOMSCREEN
 };

extern struct Window     *MainWindow;
extern struct Screen     *MainScreen;
extern BOOL               REQUESTER;
extern struct ge_prefs    prefs;
extern ULONG              Class;
extern USHORT             GadgetCount, BackFill, BackPen, FrontPen;
extern struct Gadget     *Gadget;
extern struct RastPort   *MainRP;
extern struct NewWindow   nw_main;
extern struct GadgetList  Gadgets;
extern UBYTE              wdt[80],wlb[MAXLABEL];
extern ULONG              WindowFlags;
extern struct Gadget      TextGadget;

static struct Window  *pw;
static struct ge_prefs pbuf;
static BOOL            req;

/*
 * write the preferences to "DEVS:GadgetEd.PREFS"
 */
static BOOL save_prefs()
{
    BPTR file;
    BOOL ret = TRUE;

    if(NOT(file = Open("DEVS:GadgetEd.PREFS",MODE_NEWFILE))) return(FALSE);

    if(Write(file,(char *)&prefs,sizeof(struct ge_prefs)) == -1) ret = FALSE;
    Close(file);

    return(ret);
}

/*
 * set the preferences
 */
static VOID set_prefs()
{
    USHORT i;

    if(SelectTest(&SZP))  prefs.skip_zero_planes = TRUE;
    else                  prefs.skip_zero_planes = FALSE;
    if(SelectTest(&AUS))  prefs.auto_size        = TRUE;
    else                  prefs.auto_size = FALSE;
    if(SelectTest(&IC))   prefs.image_copy = TRUE;
    else                  prefs.image_copy = FALSE;
    if(SelectTest(&RE)) { REQUESTER = TRUE; BackFill = BackPen; }
    else                  REQUESTER = FALSE;
    if(SelectTest(&ST))   prefs.static_structures = TRUE;
    else                  prefs.static_structures = FALSE;
    if(SelectTest(&TC))   prefs.text_copy = TRUE;
    else                  prefs.text_copy = FALSE;
    if(SelectTest(&NF))   prefs.no_flags = TRUE;
    else                  prefs.no_flags = FALSE;
    for(i=0;i<2;i++)      prefs.res[i] = FALSE;
    refresh();
}

#define REQ WINDOWDRAG+WINDOWSIZING+SIZEBRIGHT+SIZEBBOTTOM+GIMMEZEROZERO+BORDERLESS;

/*
 * re arrange the gadget list
 */
struct Gadget *re_arrange()
{
    register struct MyGadget *g;
    register struct Gadget *gd;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return(NULL);

    for(g = Gadgets.TailPred; g != (struct MyGadget *)&Gadgets; g = g->Pred)
    {   gd = &g->Gadget;
        if(g->Pred == (struct MyGadget *)&Gadgets) gd->NextGadget = NULL;
        else gd->NextGadget = &g->Pred->Gadget;
    }
    return(&Gadgets.TailPred->Gadget);
}

/*
 * change the window to requester or viceversa
 */
BOOL change_window()
{
    register struct Gadget    *g, *g1, *gl;
    register struct IntuiText *t;
    struct Window             *w;

    nw_main.LeftEdge       =   MainWindow->LeftEdge;
    nw_main.TopEdge        =   MainWindow->TopEdge;
    nw_main.Width          =   MainWindow->Width;
    nw_main.Height         =   MainWindow->Height;
    nw_main.Flags          =   NULL;
    nw_main.FirstGadget    =   NULL;
    nw_main.Screen         =   MainScreen;
    nw_main.MinWidth       =   MainWindow->MinWidth;
    nw_main.MinHeight      =   MainWindow->MinHeight;
    nw_main.MaxWidth       =   MainScreen->Width;
    nw_main.MaxHeight      =   MainScreen->Height;

    add_bo();

    g = gl = re_arrange();

    if(REQUESTER)
    {   nw_main.DetailPen    =   0;
        nw_main.BlockPen     =   1;
        BackFill             =   1;
        FrontPen             =   0;
        BackPen              =   1;
        nw_main.Flags        =   REQ;
        strcpy((char *)&wlb,"requester");
        strcpy((char *)&wdt,"Requester");
        nw_main.Title        =   (UBYTE *)"Work Requester";
        if((nw_main.LeftEdge + nw_main.Width + 17) < MainScreen->Width)
            nw_main.Width += 17;
        if((nw_main.TopEdge + nw_main.Height + 8) < MainScreen->Height)
            nw_main.Height += 8;
    }
    else
    {   nw_main.DetailPen    =   MainWindow->DetailPen;
        nw_main.BlockPen     =   MainWindow->BlockPen;
        strcpy((char *)&wdt,"Work Window");
        nw_main.Title        =   (UBYTE *)&wdt;
        strcpy((char *)&wlb,"new_window");
        FrontPen             =   1;
        BackPen              =   0;
        nw_main.Width       -=   17;
        nw_main.Height      -=   8;
        if(TestBits(WindowFlags,WINDOWCLOSE))  nw_main.Flags |= WINDOWCLOSE;
        if(TestBits(WindowFlags,WINDOWDRAG))   nw_main.Flags |= WINDOWDRAG;
        if(TestBits(WindowFlags,WINDOWDEPTH))  nw_main.Flags |= WINDOWDEPTH;
        if(TestBits(WindowFlags,WINDOWSIZING)) nw_main.Flags |= WINDOWSIZING;
        if(TestBits(WindowFlags,SIZEBRIGHT))   nw_main.Flags |= SIZEBRIGHT;
        if(TestBits(WindowFlags,SIZEBBOTTOM))  nw_main.Flags |= SIZEBBOTTOM;
    }
    nw_main.Flags |= NOCAREREFRESH+SMART_REFRESH+ACTIVATE;

    if(NOT(w = OpenWindow(&nw_main)))
    {   Error("Can't change window !");
        if(g) AddGList(MainWindow,g,-1L,GadgetCount,NULL);
        return;
    }

    if(REQUESTER)
    {  if(g)
       {   while(1)
           {   g1 = g->NextGadget;
               un_grel(MainWindow,g);
               if(TestBits((ULONG)g->Flags,GRELWIDTH))  g->Flags ^= GRELWIDTH;
               if(TestBits((ULONG)g->Flags,GRELHEIGHT)) g->Flags ^= GRELHEIGHT;
               if(TestBits((ULONG)g->Flags,GRELRIGHT))  g->Flags ^= GRELRIGHT;
               if(TestBits((ULONG)g->Flags,GRELBOTTOM)) g->Flags ^= GRELBOTTOM;

               if(TestBits((ULONG)g->Activation,RIGHTBORDER))
                    g->Activation ^= RIGHTBORDER;
               if(TestBits((ULONG)g->Activation,LEFTBORDER))
                    g->Activation ^= LEFTBORDER;
               if(TestBits((ULONG)g->Activation,TOPBORDER))
                    g->Activation ^= TOPBORDER;
               if(TestBits((ULONG)g->Activation,BOTTOMBORDER))
                    g->Activation ^= BOTTOMBORDER;

               g->TopEdge  -= MainWindow->BorderTop - 1;

               if(NOT g1) break;
               g = g1;
           }
       }
       if((t = TextGadget.GadgetText))
       {   while(1)
           {   t->TopEdge -= MainWindow->BorderTop - 1;
               if(NOT(t = t->NextText)) break;
           }
       }
    }
    else
    {   if(g)
        {   while(1)
            {   g1 = g->NextGadget;
                if(TestBits((ULONG)g->Activation,ENDGADGET))
                g->Activation ^= ENDGADGET;
                g->TopEdge  += MainWindow->BorderTop + 1;
                if(NOT g1) break;
                g = g1;
            }
        }
        if((t = TextGadget.GadgetText))
        {   while(1)
            {   t->TopEdge += MainWindow->BorderTop + 1;
                if(NOT(t = t->NextText)) break;
            }
        }
    }

    ClearMenuStrip(MainWindow);
    CloseWindow(MainWindow);
    MainWindow = w;
    MainRP     = MainWindow->RPort;
    SetMenu(MainWindow);
    if(gl) AddGList(MainWindow,gl,-1L,GadgetCount,NULL);
    rem_bo();
    refresh();
}

/*
 * open the preferences window
 */
VOID preferences()
{
    struct RastPort *rp;
    BOOL             running = TRUE, req;
    USHORT           g_id;

    pr_req.Screen = MainScreen;
    if(NOT(pw = OpenWindow(&pr_req))) return;
    disable_window();
    rp = pw->RPort;
    draw(pw,&SZP,&MainBorder1,&MainText);
    DeSelectGList(pw,&SZP,NULL,6);
    if(prefs.skip_zero_planes) SelectGadget(pw,&SZP,NULL);
    if(prefs.auto_size) SelectGadget(pw,&AUS,NULL);
    if(prefs.image_copy) SelectGadget(pw,&IC,NULL);
    if(prefs.static_structures) SelectGadget(pw,&ST,NULL);
    if(prefs.text_copy) SelectGadget(pw,&TC,NULL);
    if(prefs.no_flags) SelectGadget(pw,&NF,NULL);
    if(REQUESTER) SelectGadget(pw,&RE,NULL);
    else SelectGadget(pw,&WD,NULL);
    req = REQUESTER;
    do
    {   Wait(1 << pw->UserPort->mp_SigBit);
        while(read_msg(pw))
        {   g_id = Gadget->GadgetID;
            switch(g_id)
            {   case 2:
                case 3: MutualExclude(pw,Gadget,&WD,NULL);
                        SelectGadget(pw,Gadget,NULL);
                        break;
                case 7:
                case 8:
                case 9: running = FALSE;
                        break;
            }
        }
    } while(running == TRUE);
    CloseWindow(pw);
    enable_window();
    if(g_id == 7)
    {    req = REQUESTER;
         CopyMem((char *)&prefs,(char *)&pbuf,(long)sizeof(struct ge_prefs));
         set_prefs();
         if(NOT save_prefs())
         {   Error("Error writing preferences !");
             REQUESTER = req;
             CopyMem((char *)&pbuf,(char *)&prefs,(long)sizeof(struct ge_prefs));
             return;
         }
         REQUESTER = req;
         CopyMem((char *)&pbuf,(char *)&prefs,(long)sizeof(struct ge_prefs));
    }
    else if(g_id == 8)
    {   set_prefs();
        if(REQUESTER != req) change_window();
        set_extra_items(MainWindow);
    }
    else
    {   set_prefs();
        if(REQUESTER != req) change_window();
        set_extra_items(MainWindow);
        if(NOT save_prefs())
        {   Error("Error writing preferences !");
            return;
        }
    }
}
