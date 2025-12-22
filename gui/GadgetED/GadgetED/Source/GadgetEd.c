/*----------------------------------------------------------------------*
  GadgetED.c version 2.3 - © Copyright 1990-91 Jaba Development

  Autor   : Jan van den Baard
  Purpose : main control program.
 *----------------------------------------------------------------------*/

USHORT pointer[] =
 { 0x0000,0x0000,0xffff,0xffff,0xc007,0xffff,0xaffb,0xffff,
   0xa439,0xffff,0xd77d,0xffff,0xf6fd,0xffff,0xf43d,0xffff,
   0xf7fd,0xffff,0xf70d,0xffff,0xf7dd,0xffff,0xd7bd,0xffff,
   0xa709,0xffff,0xaffb,0xffff,0xc003,0xffff,0xffff,0xffff,
   0x0000,0x0000,0x0000,0x0000
 };
USHORT Colors[] =
 { 0x0000,0x0ecb,0x0f00,0x0ff0,0x00f0,0x00c0,0x0090,0x0060,
   0x000f,0x000c,0x0009,0x0ff0,0x0cc0,0x0990,0x0f0f,0x0c0c,
   0x0909,0x0a00,0x0000,0x0f00,0x0444,0x0555,0x0666,0x0777,
   0x0888,0x0999,0x0aaa,0x0bbb,0x0ccc,0x0ddd,0x0fff,0x0f00
 };
USHORT info_data[] =
 { 0xee00,0xc600,0xaa00,0xee00,0xee00,0xee00,0xee00,0xaa00,
   0xc600,0xee00,0xfff0,0xef70,0xdfb0,0x8010,0xdfb0,0xef70,
   0xfff0,0xee00,0xc600,0xaa00,0xee00,0xee00,0xee00,0xee00,
   0xee00,0xee00,0xee00,0xfff0,0xeff0,0xdff0,0x8010,0xdff0,
   0xeff0,0xfff0,0xfff0,0xbdf0,0xdbf0,0xe610,0xeff0,0xde10,
   0xbff0,0xfff0,0xfff8,0xbdf8,0xdbf8,0xe708,0xe7f8,0xdb08,
   0xbdf8,0xfff8
 };

struct Image HEIGHT_image =
 { 247,0,7,10,1,NULL,0x01,0x00,NULL
 };
struct Image WIDTH_image  =
 { 197,1,12,7,1,NULL,0x01,0x00,&HEIGHT_image
 };
struct Image TOP_image    =
 { 150,0,7,10,1,NULL,0x01,0x00,&WIDTH_image
 };
struct Image LEFT_image   =
 { 100,1,12,7,1,NULL,0x01,0x00,&TOP_image
 };
struct Image YC_image     =
 { 50,1,12,8,1,NULL,0x01,0x00,&LEFT_image
 };
struct Image XC_image     =
 { 0,1,13,8,1,NULL,0x01,0x00,&YC_image
 };

#define DATA_SIZE_TOTAL 100
#define HEIGHT_OFFSET   0
#define WIDTH_OFFSET    10
#define TOP_OFFSET      17
#define LEFT_OFFSET     27
#define YC_OFFSET       34
#define XC_OFFSET       42

UBYTE wdt[80]       = "Work Window";
UBYTE wlb[MAXLABEL] = "new_window";

struct TextAttr std =
 { (STRPTR)"topaz.font",8,FS_NORMAL,FPF_ROMFONT
 };

struct NewScreen ns_main =
 { 0,0,640,STDSCREENHEIGHT,2,0,1,HIRES,CUSTOMSCREEN,&std,TITLE,NULL,NULL
 };
struct NewWindow nw_main =
 { 50,25,175,50,0,1,NEWSIZE|GADGETUP|GADGETDOWN|INACTIVEWINDOW|ACTIVEWINDOW|MENUPICK|RAWKEY|MOUSEBUTTONS|CLOSEWINDOW,
   WINDOWSIZING|WINDOWDRAG|WINDOWCLOSE|WINDOWDEPTH|NOCAREREFRESH|SMART_REFRESH|ACTIVATE,NULL,NULL,(UBYTE *)&wdt,NULL,NULL,150,50,
   0,256,CUSTOMSCREEN
 };

char name[512];

struct GadgetList     Gadgets;
struct Requester      dw;
struct FileRequester *IODir;
struct MemoryChain    Memory;
struct MemoryChain    Misc;
struct ge_prefs       prefs  = { TRUE,TRUE,TRUE };
struct Window        *sysreq;
struct Window        *MainWindow = NULL;
struct Screen        *MainScreen = NULL;
struct RastPort      *MainRP;
struct Gadget        *Gadget;
struct Gadget        TextGadget = { NULL,0,0,1,1,GADGHNONE,NULL,BOOLGADGET,
                                    NULL,NULL,NULL,NULL,NULL,NULL,NULL };

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct ToolBase      *ToolBase;

BYTE    Xoff = -1, Yoff = 0;
BOOL    Saved = TRUE;
BOOL    REQUESTER = FALSE;
BOOL    WORKBENCH = FALSE;
BOOL    WBSCREEN  = FALSE;
ULONG   WindowFlags = WINDOWSIZING+WINDOWDRAG+WINDOWCLOSE+WINDOWDEPTH+NOCAREREFRESH+SMART_REFRESH+ACTIVATE;
ULONG   IDCMPFlags  = GADGETUP+GADGETDOWN+CLOSEWINDOW;
ULONG   Class;
USHORT  BackFill  = 1, WDBackFill = 0;
USHORT  Code, Qualifier, WBColors[4], LightSide = 2, DarkSide = 1;
USHORT *pd, *data_pointer;
USHORT  FrontPen = 1, BackPen = 0, GadgetCount = 0, id = 0, DEPTH;
SHORT   MainX, MainY;

extern struct MenuItem   SubItems[];
extern struct Menu       Titles[];
extern struct WBStartup *WBenchMsg;

/*
 * free and close all resources
 */
VOID close_up(msg)
 UBYTE *msg;
{
     struct Process *proc;

     FreeGList();
     if(IODir)         FreeFreq(IODir);
                       OpenWorkBench();
     proc = (struct Process *)FindTask(NULL);
     proc->pr_WindowPtr = (APTR)sysreq;
     if(MainWindow)  { ClearMenuStrip(MainWindow); CloseWindow(MainWindow); }
     if(MainScreen)    CloseScreen(MainScreen);
     if(msg)           puts(msg);
                       FreeMemoryChain(&Misc);
     if(ToolBase)      CloseLibrary(ToolBase);
     exit(0);
}

/*
 * allocate open and setup all resources
 */
VOID open_libs()
{
     int i;

     if(NOT(ToolBase = (struct ToolBase *)
      OpenLibrary("tool.library",TOOL_VERSION)))
        close_up("   - ERROR: Can't find the tool.library V8++!");

     GfxBase       = ToolBase->GfxBase;
     IntuitionBase = ToolBase->IntuitionBase;

     for(i=0;i<4;i++) WBColors[i] = (USHORT)GetRGB4(IntuitionBase->ActiveScreen->ViewPort.ColorMap,i);

     if(NOT(IODir = AllocFreq()))
         close_up("   - ERROR: Out of memory !");

     InitMemoryChain(&Misc,1024L);
     InitMemoryChain(&Memory,(5*1024));

     if(NOT(pd = (USHORT *)
      AllocItem(&Misc,(POINTERSIZE << 1),MEMF_CHIP+MEMF_CLEAR)))
         close_up("   - ERROR: Out of memory !");
     if(NOT(data_pointer = (USHORT *)
      AllocItem(&Misc,DATA_SIZE_TOTAL,MEMF_CHIP+MEMF_CLEAR)))
         close_up("   ERROR: Out of memory !");

     CopyMem((void *)&pointer,(void *)pd,(POINTERSIZE << 1));
     CopyMem((void *)&info_data,(void *)data_pointer,DATA_SIZE_TOTAL);

     HEIGHT_image.ImageData = (USHORT *)&data_pointer[HEIGHT_OFFSET];
     WIDTH_image.ImageData  = (USHORT *)&data_pointer[WIDTH_OFFSET];
     TOP_image.ImageData    = (USHORT *)&data_pointer[TOP_OFFSET];
     LEFT_image.ImageData   = (USHORT *)&data_pointer[LEFT_OFFSET];
     YC_image.ImageData     = (USHORT *)&data_pointer[YC_OFFSET];
     XC_image.ImageData     = (USHORT *)&data_pointer[XC_OFFSET];
}

/*
 * open up the main display
 */
VOID open_display()
{
     if(NOT MainScreen)
     {   if(NOT(MainScreen = OpenScreen(&ns_main)))
             close_up("   - ERROR: Can't open a work screen !");
     }
     nw_main.Screen    = MainScreen;
     nw_main.MaxHeight = MainScreen->Height;
     if(NOT(MainWindow = OpenWindow(&nw_main)))
         close_up("   - ERROR: Can't open a work window !");
     MainRP = MainWindow->RPort;
}

/*
 * disable the edit window by putting up a little requester
 */
VOID disable_window()
{
    InitRequester(&dw);
    dw.LeftEdge = 0;
    dw.TopEdge  = 0;
    dw.Width    = 1;
    dw.Height   = 1;
    dw.BackFill = 1;
    Request(&dw,MainWindow);
}

/*
 * enable the edit window (remove the requester)
 */
VOID enable_window()
{
    EndRequest(&dw,MainWindow);
}

/*
 * show buisy pointer
 */
VOID buisy()
{
    SetPointer(MainWindow,(void *)pd,16,16,Xoff,Yoff);
}

/*
 * erase buisy pointer
 */
VOID ok()
{
    ClearPointer(MainWindow);
}

/*
 * change the depth of the edit screen
 */
VOID change_depth(depth)
    ULONG depth;
{
    if(MainWindow)
    {   ClearMenuStrip(MainWindow);
        CloseWindow(MainWindow);
    }
    if(MainScreen)
    {   if(depth != MainScreen->BitMap.Depth)
        {   CloseScreen(MainScreen);
            MainScreen = NULL;
        }
    }
    ns_main.Depth = depth;

    if(depth == 5)
    {   ns_main.ViewModes = NULL;
        ns_main.Width     = 320;
        if(NOT nw_main.MaxWidth) nw_main.MaxWidth  = 320;
    }
    else
    {   ns_main.ViewModes = HIRES;
        ns_main.Width     = 640;
        if(NOT nw_main.MaxWidth) nw_main.MaxWidth  = 640;
    }
    if(REQUESTER) nw_main.Flags |= (GIMMEZEROZERO+SIZEBRIGHT+SIZEBBOTTOM);
    open_display();
    if(REQUESTER)
    {   SetDrMd(MainRP,JAM1);
        SetAPen(MainRP,BackFill);
        RectFill(MainRP,0,0,MainWindow->GZZWidth,MainWindow->GZZHeight);
    }
    SetMenu(MainWindow);
}

/*
 * load the preferences file (if available)
 */
VOID load_prefs()
{
    BPTR file;

    if((file = Open("DEVS:GadgetEd.PREFS",MODE_OLDFILE)))
    {   if(Read(file,(char *)&prefs,sizeof(struct ge_prefs)) <= 0)
        {   Close(file);
            Error("Error reading preferences !");
            return;
        }
        Close(file);
    }
}

/*
 * if a gadget has GRELWITH or GRELHEIGHT set and it's
 * a BOOL or STRGADGET gadget with a border this routine
 * sizes the border to fit around the gadget again after
 * a resizing of the window.
 */
VOID grl()
{
    register struct Gadget *g, *g1;
    register SHORT *XY;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;

    g = &Gadgets.TailPred->Gadget;
    disable_window();
    while(1)
    {   g1 = g->NextGadget;
        un_grel(MainWindow,g);
        if((TestBits((ULONG)g->Flags,GRELWIDTH)) AND
           (NOT TestBits((ULONG)g->Flags,GADGIMAGE)))
        {   if(NOT TestBits((ULONG)g->GadgetType,PROPGADGET))
            {   XY = ((struct Border *)g->GadgetRender)->XY;
                if(g->Width < 9)
                {   XY[2] = XY[4] = 9;
                    g->Width = 9;
                }
                else
                { XY[2] = XY[4] = g->Width;
                }
            }
        }
        if((TestBits((ULONG)g->Flags,GRELHEIGHT)) AND
           (NOT TestBits((ULONG)g->Flags,GADGIMAGE)))
        {   if(NOT TestBits((ULONG)g->GadgetType,PROPGADGET))
            {   XY = ((struct Border *)g->GadgetRender)->XY;
                if(g->Height < 9)
                {   XY[5] = XY[7] = 9;
                    g->Height = 9;
                }
                else
                { XY[5] = XY[7] = g->Height;
                }
            }
        }
        grel(MainWindow,g);
        if(NOT g1) break;
        g = g1;
    }
    enable_window();
}

/*
 * set screen title. This does not use SetWindowTitles() because if
 * the edit window overlaps the screen title the message must still
 * be displayed.
 */
VOID sst(title)
    char *title;
{
    struct RastPort *rp;

    rp = &MainScreen->RastPort;
    SetAPen(rp,1);
    RectFill(rp,0,0,MainScreen->Width,9); /* clear the title bar */
    if(title)
    {   SetAPen(rp,0);
        SetBPen(rp,1);
        SetDrMd(rp,JAM2);
        Move(rp,4,7);
        Text(rp,title,strlen(title));
    }
}

/*
 * setup the info display
 */
VOID set_info()
{
    struct RastPort *rp;

    rp = &MainScreen->RastPort;
    sst(NULL);
    DrawImage(rp,&XC_image,0,0);
}

/*
 * update the info line
 */
VOID do_info(x,y,x1,y1)
    register SHORT x,y,x1,y1;
{
    char  mx[5],my[5],l[5],t[5],w[5],h[5];
    SHORT xx,yy,tmp;
    struct RastPort *rp;

    rp = &MainScreen->RastPort;

    get_xy(&xx,&yy);

    if(x1 < x) { tmp = x; x = x1; x1 = tmp; }
    if(y1 < y) { tmp = y; y = y1; y1 = tmp; }

    SetAPen(rp,0);
    SetBPen(rp,1);
    SetDrMd(rp,JAM2);
    Move(rp,15,7);
    FormatText(rp,"%-4ld",xx);
    Move(rp,64,7);
    FormatText(rp,"%-4ld",yy);
    Move(rp,114,7);
    FormatText(rp,"%-4ld",x);
    Move(rp,159,7);
    FormatText(rp,"%-4ld",y);
    Move(rp,211,7);
    FormatText(rp,"%-3ld",x1-x);
    Move(rp,256,7);
    FormatText(rp,"%-3ld",y1-y);
}

/*
 * entry point
 */
VOID main(argc,argv)
    ULONG argc;
    char *argv[];
{
    SHORT x,y,x1,y1;
    BOOL running = TRUE;
    struct WBArg *wba;
    struct Process *proc;

    proc = (struct Process *)FindTask(NULL);
    sysreq = (struct Window *)proc->pr_WindowPtr;
    proc->pr_WindowPtr = (APTR)-1L;

    open_libs();
    NewList((void *)&Gadgets);

    if(NOT argc)
    {   if(WBenchMsg->sm_NumArgs > 1)
        {   wba = WBenchMsg->sm_ArgList;
            wba++;
            strcpy((char *)&name[0],(char *)wba->wa_Name);
            CurrentDir((struct FileLock *)wba->wa_Lock);
            ReadBinGadgets(TRUE);
        }
        else
        {   get_config();
            change_depth(DEPTH);
            if(NOT WBSCREEN) LoadRGB4(&MainScreen->ViewPort,(void *)&Colors,(1 << DEPTH));
            load_prefs();
        }
    }
    else if(argc == 1)
    {   get_config();
        change_depth(DEPTH);
        if(NOT WBSCREEN) LoadRGB4(&MainScreen->ViewPort,(void *)&Colors,(1 << DEPTH));
        load_prefs();
    }
    else if(argc > 2) close_up("   - USAGE: GadgetEd [name]");
    else
    {   strcpy((char *)&name[0],argv[1]);
        ReadBinGadgets(TRUE);
    }

    do
    {   SetWindowTitles(MainWindow,(char *)&wdt[0],(char *)TITLE);
        Wait(1 << MainWindow->UserPort->mp_SigBit);
        while(read_msg(MainWindow))
        {   switch(Class)
            {   case GADGETUP:
                case GADGETDOWN:     break;

                case ACTIVEWINDOW:   while(read_msg(MainWindow));
                                     break;

                case INACTIVEWINDOW: if(NOT IntuitionBase->ActiveWindow)
                                         ActivateWindow(MainWindow);
                                     break;

                case NEWSIZE:        grl();
                                     refresh();
                                     Saved = FALSE;
                                     break;

                case RAWKEY:         handle_keys(Code,Qualifier);
                                     while(read_msg(MainWindow));
                                     break;

                case MENUPICK:       handle_menus(Code);
                                     break;

                case MOUSEBUTTONS:   if(Code == SELECTDOWN)
                                     {   set_info();
                                         get_xy(&x,&y);
                                         MainX = x;
                                         MainY = y;
                                         SetAPen(MainRP,FrontPen);
                                         SetDrMd(MainRP,COMPLEMENT);
                                         draw_box(MainWindow,MainX,MainY,x,y);
                                         do_info(MainX,MainY,x,y);
                                         while(Code == SELECTDOWN)
                                         {   while(read_msg(MainWindow));
                                         }
                                         while(Code != SELECTDOWN)
                                         {   while(read_msg(MainWindow))
                                             {   if(Class == MENUPICK) set_info();
                                                 do_info(MainX,MainY,x,y);
                                             }
                                             get_xy(&x1,&y1);
                                             if((x1 != x) OR (y1 != y))
                                             {   draw_box(MainWindow,MainX,MainY,x,y);
                                                 get_xy(&x,&y);
                                                 draw_box(MainWindow,MainX,MainY,x,y);
                                                 do_info(MainX,MainY,x,y);
                                             }
                                         }
                                         add_gadget(MainWindow,MainX,MainY,x,y);
                                         refresh();
                                     }
                                     break;

                default:             break;
            }
        }
    } while(running == TRUE);
    close_up("  - BYE BYE");
}
