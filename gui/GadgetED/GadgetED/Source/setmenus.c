/*----------------------------------------------------------------------*
  setmenus.c Version 2.3 -  © Copyright 1990-91 Jaba Development

  Author : Jan van den Baard
  Purpose: set the menus according to the screen depth and edit type
           in the main window
 *----------------------------------------------------------------------*/

static struct IntuiText fpen_text[32];
static struct IntuiText bpen_text[32];
static struct MenuItem  fpen_item[32];
static struct MenuItem  bpen_item[32];

static struct IntuiText pen_text =
 { 0,0,JAM2,20,1,NULL,(UBYTE *)"      ",NULL
 };
static struct MenuItem pen_item =
 { NULL,4,0,68,10,HIGHBOX+CHECKIT+ITEMENABLED+ITEMTEXT,
   NULL,NULL,NULL,0,NULL,NULL
 };

UBYTE wbb[20];

static struct IntuiText SubText[] =
{ 0,1,JAM1,0,1,NULL,(UBYTE *)"C", NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Assembler",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Add a text    F6",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Modify a text",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Delete a text",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Move a text",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Load Gadget Image F7",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Load Select Image F8",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Delete Images", NULL
 };

static struct IntuiText ItemText[] =
{ 0,1,JAM1,0,1,NULL,(UBYTE *)"About",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"New", NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Load",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Save",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Generate Source",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Preferences",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)&wbb,NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Quit",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Move a gadget         F1",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Size a gadget         F2",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Copy a gadget         F3",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Delete a gadget       F4",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Edit a gadget         F5",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Gadget text",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"IFF Image render",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Load (IFF) ColorMap   F9",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Edit ColorMap        F10",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"Refresh all gadgets HELP",NULL,
  0,1,JAM1,0,1,NULL,(UBYTE *)"OS-2 Border colors      ",NULL
 };

static struct MenuItem SubItems[] =
{ &SubItems[1],150,0,108,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&SubText[0],NULL,'C',NULL,NULL,
  NULL,150,10,108,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&SubText[1],NULL,'A',NULL,NULL,
  &SubItems[3],110,0,132,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[2],NULL,NULL,NULL,NULL,
  &SubItems[4],110,10,132,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[3],NULL,NULL,NULL,NULL,
  &SubItems[5],110,20,132,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[4],NULL,NULL,NULL,NULL,
  NULL,110,30,132,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[5],NULL,NULL,NULL,NULL,
  &SubItems[7],80,0,164,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[6],NULL,NULL,NULL,NULL,
  &SubItems[8],80,10,164,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[7],NULL,NULL,NULL,NULL,
  NULL,80,20,164,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&SubText[8],NULL,NULL,NULL,NULL
 };

static struct MenuItem Items[] =
{ &Items[1],0,0,151,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&ItemText[0],NULL,'?',NULL,NULL,
  &Items[2],0,10,151,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&ItemText[1],NULL,'N',NULL,NULL,
  &Items[3],0,20,151,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&ItemText[2],NULL,'L',NULL,NULL,
  &Items[4],0,30,151,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&ItemText[3],NULL,'S',NULL,NULL,
  &Items[5],0,40,151,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[4],NULL,NULL,&SubItems[0],NULL,
  &Items[6],0,50,151,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&ItemText[5],NULL,'P',NULL,NULL,
  &Items[7],0,60,151,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[6],NULL,NULL,NULL,NULL,
  NULL,0,70,151,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
  0,(APTR)&ItemText[7],NULL,'Q',NULL,NULL,

  &Items[9],0,0,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[8],NULL,NULL,NULL,NULL,
  &Items[10],0,10,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[9],NULL,NULL,NULL,NULL,
  &Items[11],0,20,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[10],NULL,NULL,NULL,NULL,
  &Items[12],0,30,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[11],NULL,NULL,NULL,NULL,
  &Items[13],0,40,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[12],NULL,NULL,NULL,NULL,
  &Items[14],0,50,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[13],NULL,NULL,&SubItems[2],NULL,
  &Items[15],0,60,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[14],NULL,NULL,&SubItems[6],NULL,
  &Items[16],0,70,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[15],NULL,NULL,NULL,NULL,
  &Items[17],0,80,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[16],NULL,NULL,NULL,NULL,
  &Items[18],0,90,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[17],NULL,NULL,NULL,NULL,
  NULL,0,100,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
  0,(APTR)&ItemText[18],NULL,NULL,NULL,NULL,
 };

struct Menu Titles[] =
 { &Titles[1],0,0,60,10,MENUENABLED,(BYTE *)"Project",&Items[0],0,0,0,0,
   &Titles[2],60,0,60,10,MENUENABLED,(BYTE *)"Gadgets",&Items[8],0,0,0,0,
   &Titles[3],120,0,36,10,MENUENABLED,(BYTE *)"FPen",NULL,0,0,0,0,
   NULL,156,0,36,10,MENUENABLED,(BYTE *)"BPen",NULL,0,0,0,0
 };

static struct IntuiText TTT[] =
 { 0,1,JAM1,0,1,NULL,(UBYTE *)"Add a text",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Modify a text",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Delete a text",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Move a text",NULL
 };

static struct IntuiText WindowText[] =
 { 0,1,JAM1,0,1,NULL,(UBYTE *)"Window",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Edit Flags",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Edit IDCMP",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Set BackFill",NULL
 };

static struct MenuItem WindowSubs[] =
 { &WindowSubs[1],110,0,142,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
   0,(APTR)&WindowText[1],NULL,'F',NULL,NULL,
   &WindowSubs[2],110,10,142,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
   0,(APTR)&WindowText[2],NULL,'I',NULL,NULL,
   &WindowSubs[3],110,20,142,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
   0,(APTR)&WindowText[3],NULL,'B',NULL,NULL,
   &WindowSubs[4],110,30,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[0],NULL,NULL,NULL,NULL,
   &WindowSubs[5],110,40,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[1],NULL,NULL,NULL,NULL,
   &WindowSubs[6],110,50,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[2],NULL,NULL,NULL,NULL,
   NULL,110,60,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[3],NULL,NULL,NULL,NULL
 };

static struct MenuItem WindowItem =
 { NULL,0,110,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&WindowText[0],NULL,NULL,&WindowSubs[0],NULL
 };

static struct IntuiText ReqText[] =
 { 0,1,JAM1,0,1,NULL,(UBYTE *)"Requester",NULL,
   0,1,JAM1,0,1,NULL,(UBYTE *)"Set BackFill",NULL
 };

static struct MenuItem ReqSubs[] =
 { &ReqSubs[1],110,0,142,10,ITEMENABLED+ITEMTEXT+COMMSEQ+HIGHCOMP,
   0,(APTR)&ReqText[1],NULL,'B',NULL,NULL,
   &ReqSubs[2],110,10,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[0],NULL,NULL,NULL,NULL,
   &ReqSubs[3],110,20,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[1],NULL,NULL,NULL,NULL,
   &ReqSubs[4],110,30,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[2],NULL,NULL,NULL,NULL,
   NULL,110,40,142,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&TTT[3],NULL,NULL,NULL,NULL
 };

static struct MenuItem ReqItem =
 { NULL,0,110,196,10,ITEMENABLED+ITEMTEXT+HIGHCOMP,
   0,(APTR)&ReqText[0],NULL,NULL,&ReqSubs[0],NULL
 };

extern BOOL REQUESTER, WORKBENCH, WBSCREEN;
extern USHORT FrontPen, BackPen;

/*
 * set the extra window or requester items
 */
VOID set_extra_items(w)
   struct Window *w;
{
   ClearMenuStrip(w);
   if(REQUESTER == TRUE) Items[18].NextItem = &ReqItem;
   else Items[18].NextItem = &WindowItem;
   SetMenuStrip(w,&Titles[0]);
}

/*
 * set up the menu strip for the edit window
 */
VOID SetMenu(window)
    struct Window *window;
{
    register COUNT i;
    SHORT am_col = (1 << window->WScreen->BitMap.Depth);
    LONG mutexf = NULL, mutexb = NULL;

    for(i=0;i<am_col;i++) mutexf += (1 << i);
    mutexb = mutexf;
    for(i=0;i<16;i++)
    {   fpen_text[i]                 =   pen_text;
        fpen_text[i+16]              =   pen_text;
        fpen_text[i].BackPen         =   i;
        fpen_text[i+16].BackPen      =   i+16;
        bpen_text[i]                 =   fpen_text[i];
        bpen_text[i+16]              =   fpen_text[i+16];

        fpen_item[i]                 =   pen_item;
        fpen_item[i+16]              =   pen_item;
        fpen_item[i].ItemFill        =   (APTR)&fpen_text[i];
        fpen_item[i+16].ItemFill     =   (APTR)&fpen_text[i+16];
        fpen_item[i].TopEdge         =   i*10;
        fpen_item[i+16].TopEdge      =   i*10;
        fpen_item[i+16].LeftEdge     =   70;
        fpen_item[i].MutualExclude   =   mutexf - (1 << i);
        fpen_item[i+16].MutualExclude =  mutexf - (1 << (i+16));
        fpen_item[i].NextItem        =   &fpen_item[i+1];
        fpen_item[i+16].NextItem     =   &fpen_item[i+17];
    }
    for(i=0;i<16;i++)
    {   bpen_item[i]                 =   pen_item;
        bpen_item[i+16]              =   pen_item;
        bpen_item[i].ItemFill        =   (APTR)&bpen_text[i];
        bpen_item[i+16].ItemFill     =   (APTR)&bpen_text[i+16];
        bpen_item[i].TopEdge         =   i*10;
        bpen_item[i+16].TopEdge      =   i*10;
        bpen_item[i+16].LeftEdge     =   70;
        bpen_item[i].MutualExclude   =   mutexb - (1 << i);
        bpen_item[i+16].MutualExclude =  mutexb - (1 << (i+16));
        bpen_item[i].NextItem        =   &bpen_item[i+1];
        bpen_item[i+16].NextItem     =   &bpen_item[i+17];
    }
    bpen_item[BackPen].Flags |= CHECKED;
    fpen_item[FrontPen].Flags |= CHECKED;
    bpen_item[am_col-1].NextItem = NULL;
    fpen_item[am_col-1].NextItem = NULL;

    Titles[2].FirstItem = &fpen_item[0];
    Titles[3].FirstItem = &bpen_item[0];

    if(WORKBENCH == TRUE) strcpy((char *)&wbb,"Open WorkBench");
    else                  strcpy((char *)&wbb,"Close WorkBench");

    if(WBSCREEN)  Items[15].Flags = Items[16].Flags = ITEMTEXT+HIGHCOMP;
    else          Items[15].Flags = Items[16].Flags = ITEMTEXT+HIGHCOMP+ITEMENABLED;

    SetMenuStrip(window,&Titles[0]);
    set_extra_items(window);
}
