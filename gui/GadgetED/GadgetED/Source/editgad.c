/*----------------------------------------------------------------------*
   editgad.c Version 2.3 - © Copyright 1990 by Jaba Development

   Author : Jan van den Baard
   Purpose: The editing of gadgets flags e.c.t.
 *----------------------------------------------------------------------*/

static UBYTE UNDOBUFFER[20];

static struct TextAttr TOPAZ60 =
 { (STRPTR)"topaz.font",TOPAZ_SIXTY,FS_NORMAL,FPF_ROMFONT };

static SHORT MainPairs6[] =
 { 0,0,249,0,249,32,0,32,0,0 };
static SHORT MainPairs5[] =
 { 0,0,148,0,148,101,0,101,0,0 };
static SHORT MainPairs4[] =
 { 0,0,122,0,122,84,0,84,0,0 };
static SHORT MainPairs3[] =
 { 0,0,123,0,123,84,0,84,0,0 };
static SHORT MainPairs2[] =
 { 0,0,114,0,114,118,0,118,0,0 };
static SHORT MainPairs1[] =
 { 0,0,106,0,106,118,0,118,0,0 };

static struct Border MainBorder6 =
 { 233,97,1,0,JAM1,5,MainPairs6,NULL };
static struct Border MainBorder5 =
 { 486,11,1,0,JAM1,5,MainPairs5,&MainBorder6 };
static struct Border MainBorder4 =
 { 360,11,1,0,JAM1,5,MainPairs4,&MainBorder5 };
static struct Border MainBorder3 =
 { 233,11,1,0,JAM1,5,MainPairs3,&MainBorder4 };
static struct Border MainBorder2 =
 { 115,11,1,0,JAM1,5,MainPairs2,&MainBorder3 };
static struct Border MainBorder1 =
 { 5,11,1,0,JAM1,5,MainPairs1,&MainBorder2 };

static struct IntuiText MainText6 =
 { 2,0,JAM1,291,100,NULL,(UBYTE *)"SOURCE LABEL NAME",NULL };
static struct IntuiText MainText5 =
 { 2,0,JAM1,515,13,NULL,(UBYTE *)"GADGET TYPE",&MainText6 };
static struct IntuiText MainText4 =
 { 2,0,JAM1,366,13,NULL,(UBYTE *)"STRING SPECIAL",&MainText5 };
static struct IntuiText MainText3 =
 { 2,0,JAM1,249,13,NULL,(UBYTE *)"PROP SPECIAL",&MainText4 };
static struct IntuiText MainText2 =
 { 2,0,JAM1,132,13,NULL,(UBYTE *)"ACTIVATION",&MainText3 };
static struct IntuiText MainText1 =
 { 2,0,JAM1,36,13,NULL,(UBYTE *)"FLAGS",&MainText2 };

static struct Gadget BRD =
 { NULL,0,0,1,1,GADGHNONE,NULL,BOOLGADGET,
   (APTR)&MainBorder1,NULL,&MainText1,NULL,NULL,NULL,NULL };

static SHORT CNPairs[] =
 { 0,0,72,0,72,13,0,13,0,0 };
static struct Border CNBorder =
 { -1,-1,1,0,JAM1,5,CNPairs,NULL };

static struct IntuiText CNText =
 { 1,0,JAM1,5,2,&TOPAZ60,(UBYTE *)"CANCEL",NULL };
static struct Gadget CN =
 { &BRD,563,116,71,12,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&CNBorder,NULL,&CNText,NULL,NULL,35,NULL };

static struct IntuiText OKText =
 { 1,0,JAM1,26,2,&TOPAZ60,(UBYTE *)"OK",NULL };
static struct Gadget OK =
 { &CN,487,116,71,12,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&CNBorder,NULL,&OKText,NULL,NULL,34,NULL };

static UBYTE SLBuff[MAXLABEL];
static SHORT SLPairs[] =
 { 0,0,239,0,239,11,0,11,0,0 };
static struct Border SLBorder =
 { -1,-2,1,0,JAM1,5,SLPairs,NULL };
static struct StringInfo SLInfo =
 { SLBuff,UNDOBUFFER,0,MAXLABEL,0,0,0,0,0,0,0,0,NULL };
static struct Gadget SL =
 { &OK,239,112,237,8,NULL,RELVERIFY+STRINGCENTER,STRGADGET,
   (APTR)&SLBorder,NULL,NULL,NULL,(APTR)&SLInfo,33,NULL };

static SHORT GTPairs[] =
 { 0,0,140,0,140,11,0,11,0,0 };
static struct Border GTBorder =
 { -1,-1,1,0,JAM1,5,GTPairs,NULL };

static struct IntuiText OSText =
 { 1,0,JAM1,31,1,NULL,(UBYTE *)"OS2BORDER",NULL };
static struct Gadget OS =
 { &SL,491,100,139,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&OSText,NULL,NULL,39,NULL };

static struct IntuiText NBText =
 { 1,0,JAM1,35,1,NULL,(UBYTE *)"NOBORDER",NULL };
static struct Gadget NB =
 { &OS,491,87,139,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&NBText,NULL,NULL,38,NULL };

static struct IntuiText GZText =
 { 1,0,JAM1,31,1,NULL,(UBYTE *)"GZZGADGET",NULL };
static struct Gadget GZ =
 { &NB,491,74,139,10,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&GZText,NULL,NULL,37,NULL };

static struct IntuiText BOText =
 { 1,0,JAM1,27,1,NULL,(UBYTE *)"BORDERONLY",NULL };
static struct Gadget BO =
 { &GZ,491,61,139,10,GADGDISABLED,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&BOText,NULL,NULL,36,NULL };

static struct IntuiText STText =
 { 1,0,JAM1,43,1,NULL,(UBYTE *)"STRING",NULL };
static struct Gadget ST =
 { &BO,491,48,139,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&STText,3L,NULL,32,NULL };

static struct IntuiText PRText =
 { 1,0,JAM1,22,1,NULL,(UBYTE *)"PROPORTIONAL",NULL };
static struct Gadget PR =
 { &ST,491,35,139,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&PRText,5L,NULL,31,NULL };

static struct IntuiText BLText =
 { 1,0,JAM1,52,1,NULL,(UBYTE *)"BOOL",NULL };
static struct Gadget BL =
 { &PR,491,22,139,10,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&GTBorder,NULL,&BLText,6L,NULL,30,NULL };

static SHORT BPairs[] =
 { 0,0,72,0,72,11,0,11,0,1 };
static struct Border BBorder =
 { -2,-2,1,0,JAM1,5,BPairs,NULL };

static UBYTE SZBuff[4] = "256";
static struct StringInfo SZInfo =
 { SZBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,256L,NULL };
static struct IntuiText SZText =
 { 2,0,JAM1,-46,1,NULL,(UBYTE *)"SIZE",NULL };
static struct Gadget SZ =
 { &BL,409,84,67,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&BBorder,NULL,&SZText,NULL,(APTR)&SZInfo,29,NULL };

static SHORT SINPairs[] =
 { 0,0,115,0,115,10,0,10,0,0 };
static struct Border SINBorder =
 { -1,-1,1,0,JAM1,5,SINPairs,NULL };

static struct IntuiText AMText =
 { 1,0,JAM1,21,1,NULL,(UBYTE *)"ALTKEYMAP",NULL };
static struct Gadget AM =
 { &SZ,365,70,114,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&AMText,NULL,NULL,28,NULL };

static struct IntuiText LIText =
 { 1,0,JAM1,29,1,NULL,(UBYTE *)"LONGINT",NULL };
static struct Gadget LI =
 { &AM,365,58,114,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&LIText,NULL,NULL,27,NULL };

static struct IntuiText SRText =
 { 1,0,JAM1,12,1,NULL,(UBYTE *)"STRINGRIGHT",NULL };
static struct Gadget SR =
 { &LI,365,46,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&SRText,1L,NULL,26,NULL };

static struct IntuiText SCText =
 { 1,0,JAM1,8,1,NULL,(UBYTE *)"STRINGCENTER",NULL };
static struct Gadget SC =
 { &SR,365,34,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&SCText,2L,NULL,25,NULL };

static struct IntuiText UBText =
 { 1,0,JAM1,16,1,NULL,(UBYTE *)"UNDOBUFFER",NULL };
static struct Gadget UB =
 { &SC,365,22,114,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&UBText,NULL,NULL,24,NULL };

static UBYTE VBBuff[4] = "0";
static struct StringInfo VBInfo =
 { VBBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText VBText =
 { 2,0,JAM1,-46,1,NULL,(UBYTE *)"VBODY",NULL };
static struct Gadget VB =
 { &UB,282,84,67,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&BBorder,NULL,&VBText,NULL,(APTR)&VBInfo,23,NULL };

static UBYTE HBBuff[4] = "0";
static struct StringInfo HBInfo =
 { HBBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText HBText =
 { 2,0,JAM1,-46,1,NULL,(UBYTE *)"HBODY",NULL };
static struct Gadget HB =
 { &VB,282,71,67,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&BBorder,NULL,&HBText,NULL,(APTR)&HBInfo,22,NULL };

static struct IntuiText PBText =
 { 1,0,JAM1,1,1,NULL,(UBYTE *)"PROPBORDERLESS",NULL };
static struct Gadget PB =
 { &HB,238,58,114,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&PBText,NULL,NULL,21,NULL };

static struct IntuiText FVText =
 { 1,0,JAM1,24,1,NULL,(UBYTE *)"FREEVERT",NULL };
static struct Gadget FV =
 { &PB,238,46,114,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&FVText,NULL,NULL,20,NULL };

static struct IntuiText FHText =
 { 1,0,JAM1,20,1,NULL,(UBYTE *)"FREEHORIZ",NULL };
static struct Gadget FH =
 { &FV,238,34,114,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&FHText,NULL,NULL,19,NULL };

static struct IntuiText AKText =
 { 1,0,JAM1,25,1,NULL,(UBYTE *)"AUTOKNOB",NULL };
static struct Gadget AK =
 { &FH,238,22,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&SINBorder,NULL,&AKText,NULL,NULL,18,NULL };

static SHORT ACTPairs[] =
 { 0,0,106,0,106,10,0,10,0,0 };
static struct Border ACTBorder =
 { -1,-1,1,0,JAM1,5,ACTPairs,NULL };

static struct IntuiText FMText =
 { 1,0,JAM1,8,1,NULL,(UBYTE *)"FOLLOWMOUSE",NULL };
static struct Gadget FM =
 { &AK,120,118,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&FMText,NULL,NULL,17,NULL };

static struct IntuiText EGText =
 { 1,0,JAM1,15,1,NULL,(UBYTE *)"ENDGADGET",NULL };
static struct Gadget EG =
 { &FM,120,106,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&EGText,NULL,NULL,16,NULL };

static struct IntuiText BBText =
 { 1,0,JAM1,4,1,NULL,(UBYTE *)"BOTTOMBORDER",NULL };
static struct Gadget BB =
 { &EG,120,94,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&BBText,NULL,NULL,15,NULL };

static struct IntuiText TBText =
 { 1,0,JAM1,16,1,NULL,(UBYTE *)"TOPBORDER",NULL };
static struct Gadget TB =
 { &BB,120,82,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&TBText,NULL,NULL,14,NULL };

static struct IntuiText LBText =
 { 1,0,JAM1,13,1,NULL,(UBYTE *)"LEFTBORDER",NULL };
static struct Gadget LB =
 { &TB,120,70,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&LBText,NULL,NULL,13,NULL };

static struct IntuiText RBText =
 { 1,0,JAM1,9,1,NULL,(UBYTE *)"RIGHTBORDER",NULL };
static struct Gadget RB =
 { &LB,120,58,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&RBText,NULL,NULL,12,NULL };

static struct IntuiText GIMText =
 { 1,0,JAM1,1,1,NULL,(UBYTE *)"GADGIMMEDIATE",NULL };
static struct Gadget GIM =
 { &RB,120,46,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&GIMText,NULL,NULL,11,NULL };

static struct IntuiText RVYText =
 { 1,0,JAM1,16,1,NULL,(UBYTE *)"RELVERIFY",NULL };
static struct Gadget RVY =
 { &GIM,120,34,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&RVYText,NULL,NULL,10,NULL };

static struct IntuiText TGSText =
 { 1,0,JAM1,4,1,NULL,(UBYTE *)"TOGGLESELECT",NULL };
static struct Gadget TGS =
 { &RVY,120,22,105,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&ACTBorder,NULL,&TGSText,NULL,NULL,9,NULL };

static SHORT FLGPairs[] =
 { 0,0,98,0,98,10,0,10,0,0 };
static struct Border FLGBorder =
 { -1,-1,1,0,JAM1,5,FLGPairs,NULL };

static struct IntuiText GDDText =
 { 1,0,JAM1,1,1,NULL,(UBYTE *)"GADGDISABLED",NULL };
static struct Gadget GDD =
 { &TGS,10,118,97,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GDDText,NULL,NULL,8,NULL };

static struct IntuiText SLCText =
 { 1,0,JAM1,17,1,NULL,(UBYTE *)"SELECTED",NULL };
static struct Gadget SLC =
 { &GDD,10,106,97,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&SLCText,NULL,NULL,7,NULL };

static struct IntuiText GRHText =
 { 1,0,JAM1,9,1,NULL,(UBYTE *)"GRELHEIGHT",NULL };
static struct Gadget GRH =
 { &SLC,10,94,97,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GRHText,NULL,NULL,6,NULL };

static struct IntuiText GRWText =
 { 1,0,JAM1,12,1,NULL,(UBYTE *)"GRELWIDTH",NULL };
static struct Gadget GRW =
 { &GRH,10,82,97,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GRWText,NULL,NULL,5,NULL };

static struct IntuiText GRRText =
 { 1,0,JAM1,12,1,NULL,(UBYTE *)"GRELRIGHT",NULL };
static struct Gadget GRR =
 { &GRW,10,70,97,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GRRText,NULL,NULL,4,NULL };

static struct IntuiText GRBText =
 { 1,0,JAM1,8,1,NULL,(UBYTE *)"GRELBOTTOM",NULL };
static struct Gadget GRB =
 { &GRR,10,58,97,9,NULL,TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GRBText,NULL,NULL,3,NULL };

static struct IntuiText GDHBText =
 { 1,0,JAM1,14,1,NULL,(UBYTE *)"GADGHBOX",NULL };
static struct Gadget GDHB =
 { &GRB,10,46,97,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GDHBText,3L,NULL,2,NULL };

static struct IntuiText GDHCText =
 { 1,0,JAM1,12,1,NULL,(UBYTE *)"GADGHCOMP",NULL };
static struct Gadget GDHC =
 { &GDHB,10,34,97,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GDHCText,5L,NULL,1,NULL };

static struct IntuiText GDHNText =
 { 1,0,JAM1,12,1,NULL,(UBYTE *)"GADGHNONE",NULL };
static struct Gadget GDHN =
 { &GDHC,10,22,97,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLGBorder,NULL,&GDHNText,6L,NULL,0,NULL };

static struct NewScreen ns =
 { 0,0,640,132,2,0,1,HIRES,CUSTOMSCREEN|SCREENBEHIND,NULL,NULL,NULL,NULL };

static struct NewWindow nw =
 { 0,0,640,132,0,1,GADGETUP|GADGETDOWN,SIMPLE_REFRESH+ACTIVATE+RMBTRAP+NOCAREREFRESH,
   NULL,NULL,(UBYTE *)"Edit Gadget",NULL,NULL,0,0,0,0,CUSTOMSCREEN };

static struct Window       *w;
static struct Screen       *s;
static struct RastPort     *rp;
static struct IntuiMessage *msg;
static USHORT id;

extern struct Window *MainWindow;
extern struct Screen *MainScreen;
extern struct IntuitionBase *IntuitionBase;
extern struct MemoryChain Memory;
extern USHORT LightSide, DarkSide;
extern ULONG  WindowFlags;
extern BOOL   REQUESTER;

static USHORT   my_colors[4] = { 0xCCC,0x962,0xFB9,0x843 };

/*
 * setup the main display
 */
static VOID backfill()
{
    register struct Gadget *g;
    register struct Border *b;
    register SHORT         *p, l, t, i;

    my_colors[0] = (USHORT)GetRGB4(MainScreen->ViewPort.ColorMap,0);

    LoadRGB4(&s->ViewPort,&my_colors[0],4);

    g = &GDHN;
    b = &MainBorder1;

    SetAPen(rp,3);
    while(1)
    {   p = b->XY;
        l = b->LeftEdge;
        t = b->TopEdge;
        RectFill(rp,l+p[0],t+p[1],l+p[4],t+p[5]);
        if(NOT(b = b->NextBorder)) break;
    }
    SetAPen(rp,2);
    while(1)
    {   l = g->LeftEdge;
        t = g->TopEdge;
        if(g != &BRD) RectFill(rp,l,t,l + g->Width,t + g->Height);
        if(NOT(g = g->NextGadget)) break;
    }
    SetAPen(rp,0);
    RectFill(rp,280,82,352,93);
    RectFill(rp,407,82,479,93);
    RectFill(rp,280,69,352,80);
    RectFill(rp,239,111,477,120);
}

/*
 * default the gadget flags of the control window
 */
static VOID clear_gadgets()
{
    register struct Gadget *g;

    g = &GDHN;

    while(1)
    { if((g != &HB)&&(g != &VB)&&(g != &SZ)&&
         (g != &SL)&&(g != &OK)&&(g != &CN)&&(g != &BRD)) g->Flags = NULL;
      if(NOT(g = g->NextGadget)) break;
    }
    SLBuff[0] = 0;
    strcpy((char *)HBBuff,"0");
    strcpy((char *)VBBuff,"0");
    strcpy((char *)SZBuff,"256");
}

/*
 * set the gadgets according to the information
 * found in the MyGadget structure 'g'
 */
static VOID set_gadgets(g)
    struct MyGadget *g;
{
    register ULONG flags, act, type;
    struct Gadget     *gadget;
    struct PropInfo   *pinfo;
    struct StringInfo *sinfo;

    gadget = &g->Gadget;
    flags  = (ULONG)gadget->Flags;
    act    = (ULONG)gadget->Activation;
    type   = (ULONG)gadget->GadgetType;

    if((TestBits(flags,GADGIMAGE)) OR
       (gadget->SpecialInfo) OR
       (gadget->GadgetText)) GadgetOff(w,&BO,NULL);

    if(NOT TestBits(WindowFlags,GIMMEZEROZERO))
        GadgetOff(w,&GZ,NULL);

    if((TestBits(flags,GADGIMAGE)) OR
       (TestBits(type,PROPGADGET))) { GadgetOff(w,&NB,NULL);
                                      GadgetOff(w,&OS,NULL); }

    if(REQUESTER)
    {   OffGList(w,&GRB,NULL,4);
        OffGList(w,&RB,NULL,4);
    }
    else GadgetOff(w,&EG,NULL);

    if(TestBits(flags,GADGIMAGE)) GadgetOff(w,&AK,NULL);

    if((TestBits(flags,GADGHIMAGE)) AND
       (NOT TestBits(flags,GADGHBOX)))  OffGList(w,&GDHN,NULL,3);
    else if((TestBits(flags,GADGHIMAGE)) AND
            (TestBits(flags,GADGHBOX))) SelectGadget(w,&GDHN,NULL);
    else if(TestBits(flags,GADGHBOX))   SelectGadget(w,&GDHB,NULL);
    else                                SelectGadget(w,&GDHC,NULL);

    if(TestBits(flags,GRELBOTTOM))      SelectGadget(w,&GRB,NULL);
    if(TestBits(flags,GRELRIGHT))       SelectGadget(w,&GRR,NULL);
    if(TestBits(flags,GRELWIDTH))       SelectGadget(w,&GRW,NULL);
    if(TestBits(flags,GRELHEIGHT))      SelectGadget(w,&GRH,NULL);
    if(TestBits(flags,SELECTED))        SelectGadget(w,&SLC,NULL);

    if(TestBits((ULONG)g->SpecialFlags,GADGETOFF))
                                        SelectGadget(w,&GDD,NULL);

    if(TestBits(act,TOGGLESELECT))      SelectGadget(w,&TGS,NULL);
    if(!TestBits((ULONG)g->SpecialFlags,NOSIGNAL))
    {   if(TestBits(act,RELVERIFY))         SelectGadget(w,&RVY,NULL);
        if(TestBits(act,GADGIMMEDIATE))     SelectGadget(w,&GIM,NULL);
    }
    if(TestBits(act,RIGHTBORDER))       SelectGadget(w,&RB,NULL);
    if(TestBits(act,LEFTBORDER))        SelectGadget(w,&LB,NULL);
    if(TestBits(act,TOPBORDER))         SelectGadget(w,&TB,NULL);
    if(TestBits(act,BOTTOMBORDER))      SelectGadget(w,&BB,NULL);
    if(TestBits(act,ENDGADGET))         SelectGadget(w,&EG,NULL);
    if(TestBits(act,FOLLOWMOUSE))       SelectGadget(w,&FM,NULL);

    if(TestBits(type,PROPGADGET))
    {   SelectGadget(w,&PR,NULL);
        pinfo = (struct PropInfo *)gadget->SpecialInfo;
        flags = (ULONG)pinfo->Flags;
        if(TestBits(flags,AUTOKNOB))       SelectGadget(w,&AK,NULL);
        if(TestBits(flags,FREEHORIZ))      SelectGadget(w,&FH,NULL);
        if(TestBits(flags,FREEVERT))       SelectGadget(w,&FV,NULL);
        if(TestBits(flags,PROPBORDERLESS)) SelectGadget(w,&PB,NULL);
        if(pinfo->HorizBody == MAXBODY)
        {   strcpy((char *)HBBuff,"0");
            HBInfo.LongInt = 0;
        }
        else
        {   Format((char *)HBBuff,"%ld",MAXBODY / pinfo->HorizBody);
            HBInfo.LongInt = MAXBODY / pinfo->HorizBody;
        }
        if(pinfo->VertBody == MAXBODY)
        {   strcpy((char *)VBBuff,"0");
            VBInfo.LongInt = 0;
        }
        else
        {   Format((char *)VBBuff,"%ld",MAXBODY / pinfo->VertBody);
            VBInfo.LongInt = MAXBODY / pinfo->VertBody;
        }
    }
    else if(TestBits(type,STRGADGET))
    {   SelectGadget(w,&ST,NULL);
        sinfo = (struct StringInfo *)gadget->SpecialInfo;
        if(sinfo->UndoBuffer)              SelectGadget(w,&UB,NULL);
        if(TestBits(act,STRINGCENTER))     SelectGadget(w,&SC,NULL);
        if(TestBits(act,STRINGRIGHT))      SelectGadget(w,&SR,NULL);
        if(TestBits(act,LONGINT))          SelectGadget(w,&LI,NULL);
        if(TestBits(act,ALTKEYMAP))        SelectGadget(w,&AM,NULL);
        Format((char *)SZBuff,"%ld",sinfo->MaxChars);
    }
    else SelectGadget(w,&BL,NULL);
    if(TestBits((ULONG)g->SpecialFlags,NOBORDER))
    {  SelectGadget(w,&NB,NULL);
       DeSelectGadget(w,&BO,NULL);
       GadgetOff(w,&BO,NULL);
    }
    else if(TestBits((ULONG)g->SpecialFlags,BORDERONLY))
    {  SelectGadget(w,&BO,NULL);
       DeSelectGadget(w,&NB,NULL);
       GadgetOff(w,&NB,NULL);
    }
    if(TestBits((ULONG)g->SpecialFlags,GZZGADGET))  SelectGadget(w,&GZ,NULL);

    if(TestBits((ULONG)g->SpecialFlags,OS20BORDER)) SelectGadget(w,&OS,NULL);

    strcpy((char *)SLBuff,(char *)g->GadgetLabel);
    RefreshGList(&HB,w,NULL,2);
    RefreshGList(&SZ,w,NULL,1);
    RefreshGList(&SL,w,NULL,1);
}

/*
 * change the gadget according to the control window
 */
static BOOL change_gadget(gad)
    struct MyGadget *gad;
{
    struct Border     *b;
    struct Image      *gi, *si;
    struct StringInfo *s;
    struct PropInfo   *p;
    struct Gadget     *g;
    USHORT bfpen, i;
    BOOL   image_render = FALSE, simage_render = FALSE;

    ULONG size;

    g = &gad->Gadget;

    if((TestBits(g->Flags,GADGIMAGE)))
    {   image_render = TRUE;
        gi = (struct Image *)g->GadgetRender;
    }
    else if(NOT(TestBits(g->GadgetType,PROPGADGET)))
    {   b = (struct Border *)g->GadgetRender;
        bfpen = b->FrontPen;
        FreeRender(g);
    }
    if((TestBits(g->Flags,GADGHIMAGE)) AND
       (NOT TestBits(g->Flags,GADGHBOX)))
    {   simage_render = TRUE;
        si = (struct Image *)g->SelectRender;
    }

    if(TestBits(g->GadgetType,PROPGADGET))
    {   if(image_render == FALSE)
            FreeItem(&Memory,g->GadgetRender,(long)sizeof(struct Image));
         FreeItem(&Memory,g->SpecialInfo,(long)sizeof(struct PropInfo));
    }
    else if(TestBits(g->GadgetType,STRGADGET))
    {   s = (struct StringInfo *)g->SpecialInfo;
        if(s->Buffer)     FreeItem(&Memory,s->Buffer,s->MaxChars);
        if(s->UndoBuffer) FreeItem(&Memory,s->UndoBuffer,s->MaxChars);
        FreeItem(&Memory,s,(long)sizeof(struct StringInfo));
    }

    g->Flags = g->Activation = g->GadgetType = gad->SpecialFlags = NULL;
    g->SpecialInfo = NULL;

    if(SelectTest(&GDHN))                 g->Flags = GADGHNONE;
    else if(SelectTest(&GDHB))            g->Flags = GADGHBOX;
    else if(SelectTest(&GDHC))            g->Flags = GADGHCOMP;
    else                                  g->Flags = GADGHIMAGE;

    if(image_render == TRUE)              g->Flags |= GADGIMAGE;

    if(SelectTest(&GRB))                  g->Flags |= GRELBOTTOM;
    if(SelectTest(&GRR))                  g->Flags |= GRELRIGHT;
    if(SelectTest(&GRW))                  g->Flags |= GRELWIDTH;
    if(SelectTest(&GRH))                  g->Flags |= GRELHEIGHT;
    if(SelectTest(&SLC))                  g->Flags |= SELECTED;

    if(SelectTest(&GDD))                  gad->SpecialFlags |= GADGETOFF;

    if(SelectTest(&TGS))                  g->Activation |= TOGGLESELECT;
    if(SelectTest(&RVY))                  g->Activation |= RELVERIFY;
    if(SelectTest(&GIM))                  g->Activation |= GADGIMMEDIATE;
    if(SelectTest(&RB))                   g->Activation |= RIGHTBORDER;
    if(SelectTest(&LB))                   g->Activation |= LEFTBORDER;
    if(SelectTest(&TB))                   g->Activation |= TOPBORDER;
    if(SelectTest(&BB))                   g->Activation |= BOTTOMBORDER;
    if(SelectTest(&EG))                   g->Activation |= ENDGADGET;
    if(SelectTest(&FM))                   g->Activation |= FOLLOWMOUSE;

    if(SelectTest(&PR))
    {   g->GadgetType    = PROPGADGET;
        if(NOT(p = (struct PropInfo *)Alloc(&Memory,(ULONG)sizeof(struct PropInfo))))
        {   Error("Out of memory !");
            return(FALSE);
        }
        if(NOT(TestBits(g->Flags,GADGIMAGE)))
        {   if(NOT(g->GadgetRender = Alloc(&Memory,(ULONG)sizeof(struct Image))))
            {   Error("Out of memory !");
                return(FALSE);
            }
        }
        if(SelectTest(&AK))    p->Flags |= AUTOKNOB;
        if(SelectTest(&FH))    p->Flags |= FREEHORIZ;
        if(SelectTest(&FV))    p->Flags |= FREEVERT;
        if(SelectTest(&PB))    p->Flags |= PROPBORDERLESS;
        if(HBInfo.LongInt <= NULL) p->HorizBody = MAXBODY;
        else p->HorizBody = MAXBODY / HBInfo.LongInt;
        if(VBInfo.LongInt <= NULL) p->VertBody  = MAXBODY;
        else p->VertBody  = MAXBODY / VBInfo.LongInt;
        g->SpecialInfo = (APTR)p;
    }
    else if(SelectTest(&ST))
    {   g->GadgetType    = STRGADGET;
        if(SelectTest(&SC))    g->Activation |= STRINGCENTER;
        if(SelectTest(&SR))    g->Activation |= STRINGRIGHT;
        if(SelectTest(&LI))    g->Activation |= LONGINT;
        if(SelectTest(&AM))    g->Activation |= ALTKEYMAP;
        if(NOT(s = (struct StringInfo *)Alloc(&Memory,(ULONG)sizeof(struct StringInfo))))
        {   Error("Out of memory !");
            return(FALSE);
        }
        size = SZInfo.LongInt;
        s->MaxChars = SZInfo.LongInt;
        if(NOT(s->Buffer = (UBYTE *)Alloc(&Memory,size)))
        {   Error("Out of memory !");
            return(FALSE);
        }
        if(SelectTest(&UB))
        {   if(NOT(s->UndoBuffer = (UBYTE *)Alloc(&Memory,size)))
            {   Error("Out of memory !");
                return(FALSE);
            };
        }
        g->SpecialInfo = (APTR)s;
    }
    else g->GadgetType                          = BOOLGADGET;
    if(SelectTest(&NB)) gad->SpecialFlags      |= NOBORDER;
    else if(SelectTest(&BO)) gad->SpecialFlags |= BORDERONLY;
    if(SelectTest(&GZ)) gad->SpecialFlags      |= GZZGADGET;
    if(SelectTest(&OS)) gad->SpecialFlags      |= OS20BORDER;

    if((!SelectTest(&GIM)) AND (!SelectTest(&RVY)))
    {   g->Activation     = RELVERIFY;
        gad->SpecialFlags = NOSIGNAL;
    }

    if(TestBits(g->Flags,GADGHIMAGE)) g->SelectRender = (APTR)si;
    if(TestBits(g->Flags,GADGIMAGE))  g->GadgetRender = (APTR)gi;
    else
    {   if(NOT(TestBits(g->GadgetType,PROPGADGET)))
        {    if(add_border(gad) == FALSE)
             {   Error("Out of memory !");
                 return(FALSE);
             }
             if(!SelectTest(&OS))
                 ((struct Border *)g->GadgetRender)->FrontPen = bfpen;
             else
             {
                 ((struct Border *)g->GadgetRender)->FrontPen = LightSide;
                 ((struct Border *)g->GadgetRender)->NextBorder->FrontPen = DarkSide;
            }
        }
    }
    for(i=0;i<strlen((char *)SLBuff);i++)
    {   if(SLBuff[i] == ' ') SLBuff[i] = '_';
    }
    strcpy((char *)&gad->GadgetLabel,(char *)SLBuff);
    return(TRUE);
}

/*
 * open the gadget editor control display
 */
BOOL edit_gadget(gadget)
    struct MyGadget *gadget;
{
    struct Gadget *g;

    buisy();
    ns.TopEdge = IntuitionBase->ActiveScreen->Height - 132;
    if(NOT(s = OpenScreen(&ns)))
    {   Error("Can't open display !");
        return(FALSE);
    }
    clear_gadgets();
    nw.Screen = s;
    if(NOT(w = OpenWindow(&nw)))
    {   Error("Can't open display !");
        CloseScreen(s);
        return(FALSE);
    }
    ScreenToFront(s);
    rp = w->RPort;
    backfill();
    AddGList(w,&GDHN,-1L,-1L,NULL);
    RefreshGList(&GDHN,w,NULL,-1L);
    set_gadgets(gadget);
    do
    {   Wait(1 << w->UserPort->mp_SigBit);
        while((msg = (struct IntuiMessage *)GetMsg(w->UserPort)))
        {   g  = (struct Gadget *)msg->IAddress;
            id = g->GadgetID;
            ReplyMsg((struct Message *)msg);
            switch(id)
            {  case 0:
               case 1:
               case 2:  MutualExclude(w,g,&GDHN,NULL);
                        SelectGadget(w,g,NULL);
                        break;
               case 31: if(NOT TestBits(gadget->Gadget.Flags,GADGIMAGE))
                            SelectGadget(w,&AK,NULL);
                        DeSelectGadget(w,&NB,NULL);
                        GadgetOff(w,&NB,NULL);
                        DeSelectGadget(w,&OS,NULL);
                        GadgetOff(w,&OS,NULL);
               case 32: DeSelectGadget(w,&BO,NULL); GadgetOff(w,&BO,NULL);
               case 30: MutualExclude(w,g,&BL,NULL);
                        SelectGadget(w,g,NULL);
                        break;
               case 18: SelectGadget(w,g,NULL);
                        break;
               case 25:
               case 26: MutualExclude(w,g,&SC,NULL);
                        break;
               case 36: DeSelectGadget(w,&NB,NULL);
                        GadgetOff(w,&NB,NULL);
                        break;
               case 38: DeSelectGadget(w,&BO,NULL);
                        GadgetOff(w,&BO,NULL);
                        break;
               default: break;
            }
        }
    } while(id != 34 && id != 35);
    CloseWindow(w);
    CloseScreen(s);
    ok();
    if(id == 34) return(change_gadget(gadget));
    return(TRUE);
}
