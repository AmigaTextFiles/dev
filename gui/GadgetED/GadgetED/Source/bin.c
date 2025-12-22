/*----------------------------------------------------------------------*
   bin.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author : Jan van den Baard
   Purpose: The reading and writing of the gadgets in binary form.
   NOTE   : GadgetED 2.0 binary files MUST be patched first!
 *----------------------------------------------------------------------*/

/*
 * external global data
 */
extern struct Screen        *MainScreen;
extern struct Window        *MainWindow;
extern struct GadgetList     Gadgets;
extern struct NewWindow      nw_main;
extern struct Gadget         TextGadget;
extern struct ge_prefs       prefs;
extern struct FileRequester *IODir;
extern struct MemoryChain    Misc;
extern struct MemoryChain    Memory;
extern USHORT                GadgetCount, id, BackFill, WDBackFill;
extern USHORT                FrontPen, BackPen, Colors[], WBColors[];
extern USHORT                LightSide, DarkSide;
extern BOOL                  Saved, REQUESTER, WBSCREEN;
extern UBYTE                 name[512], wdt[80], wlb[MAXLABEL];
extern ULONG                 WindowFlags, IDCMPFlags;

/*
 * icon image data
 */
USHORT data[] =
 { 0x0000,0x0000,0x0000,0x03fe,0x47ff,0xf800,0x0f01,0xc1e0,
   0x1800,0x1e00,0xc1e0,0x0800,0x1c00,0x41e0,0x0800,0x3c00,
   0x01e0,0x8000,0x3c00,0x01e1,0x8000,0x3c00,0x01ff,0x8000,
   0x3c1f,0xe1e1,0x8000,0x3c07,0xc1e0,0x8000,0x3c03,0xc1e0,
   0x0800,0x1e03,0xc1e0,0x0800,0x0f07,0xc1e0,0x1800,0x03fe,
   0x67ff,0xf800,0x0000,0x0000,0x0000,0xffff,0xffff,0xfe00,
   0xffff,0xffff,0xfe00,0xffff,0xffff,0xfe00,0xffff,0xffff,
   0xfe00,0xffff,0xffff,0xfe00,0xffff,0xffff,0xfe00,0xffff,
   0xffff,0xfe00,0xffff,0xffff,0xfe00,0xffff,0xffff,0xfe00,
   0xffff,0xffff,0xfe00,0xffff,0xffff,0xfe00,0xffff,0xffff,
   0xfe00,0xffff,0xffff,0xfe00,0xffff,0xffff,0xfe00,0xffff,
   0xffff,0xfe00
 };

struct Image icon_image =
 { 0,0,39,15,2,NULL,0x03,0x00,NULL };
struct IconBase *IconBase;

/*
 * write a 'GE' icon
 */
BOOL write_icon(nme)
    UBYTE *nme;
{
    struct DiskObject  icon;
    struct Gadget      icon_Gadget;
    BOOL               ret;

    if((IconBase = OpenLibrary(ICONNAME,0L)))
    {   icon_image.ImageData     =   &data[0];

        icon_Gadget.NextGadget   =   NULL;
        icon_Gadget.LeftEdge     =   0;
        icon_Gadget.TopEdge      =   0;
        icon_Gadget.Width        =   39;
        icon_Gadget.Height       =   15;
        icon_Gadget.Flags        =   GADGIMAGE+GADGBACKFILL;
        icon_Gadget.Activation   =   RELVERIFY+GADGIMMEDIATE;
        icon_Gadget.GadgetType   =   BOOLGADGET;
        icon_Gadget.GadgetRender =   (APTR)&icon_image;
        icon_Gadget.SelectRender =   NULL;
        icon_Gadget.GadgetText   =   NULL;
        icon_Gadget.MutualExclude=   NULL;
        icon_Gadget.SpecialInfo  =   NULL;
        icon_Gadget.GadgetID     =   NULL;
        icon_Gadget.UserData     =   NULL;

        icon.do_Magic            =   WB_DISKMAGIC;
        icon.do_Version          =   WB_DISKVERSION;
        icon.do_Gadget           =   icon_Gadget;
        icon.do_Type             =   WBPROJECT;
        icon.do_DefaultTool      =   (char *)":GadgetEd";
        icon.do_ToolTypes        =   NULL;
        icon.do_CurrentX         =   NO_ICON_POSITION;
        icon.do_CurrentY         =   NO_ICON_POSITION;
        icon.do_DrawerData       =   NULL;
        icon.do_ToolWindow       =   NULL;
        icon.do_StackSize        =   NULL;
        ret = PutDiskObject((char *)nme,&icon);

        CloseLibrary(IconBase);
        if(NOT ret) return(FALSE);
        return(TRUE);
    }
    return(FALSE);
}

/*
 * write a gadget
 */
static BOOL WBG(file,g)
    BPTR               file;
    struct MyGadget   *g;
{
    struct Gadget     *gadget;
    struct IntuiText  *t;
    struct Border     *b;
    struct Image      *i;
    struct StringInfo *s;
    ULONG              data_size;
    char              *str;

    gadget = &g->Gadget;

    Write(file,(char *)gadget,sizeof(struct Gadget));
    Write(file,(char *)&g->SpecialFlags,2);
    Write(file,(char *)&g->GadgetLabel,MAXLABEL);

    if((t = gadget->GadgetText))
    {   while(1)
        {   Write(file,(char *)t,sizeof(struct IntuiText));
            Write(file,(char *)t->IText,80);
            if(NOT(t = t->NextText)) break;
        }
    }
    if((NOT TestBits((ULONG)gadget->GadgetType,PROPGADGET)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGIMAGE)))
    {   b = (struct Border *)gadget->GadgetRender;
        while(1)
        {   Write(file,(char *)b,sizeof(struct Border));
            Write(file,(char *)b->XY,(b->Count << 2));
            if(NOT(b = b->NextBorder)) break;
        }
    }
    else if(TestBits((ULONG)gadget->Flags,GADGIMAGE))
    {   i = (struct Image *)gadget->GadgetRender;
        data_size = (ULONG)(RASSIZE(i->Width,i->Height) * i->Depth);
        Write(file,(char *)i,sizeof(struct Image));
        Write(file,(char *)i->ImageData,data_size);
    }

    if((TestBits((ULONG)gadget->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGHBOX)))
    {   i = (struct Image *)gadget->SelectRender;
        data_size = (ULONG)(RASSIZE(i->Width,i->Height) * i->Depth);
        Write(file,(char *)i,sizeof(struct Image));
        Write(file,(char *)i->ImageData,data_size);
    }

    if(TestBits((ULONG)gadget->GadgetType,PROPGADGET))
    {   Write(file,(char *)gadget->SpecialInfo,sizeof(struct PropInfo));
    }
    if(TestBits((ULONG)gadget->GadgetType,STRGADGET))
    {   s = (struct StringInfo *)gadget->SpecialInfo;
        Write(file,(char *)s,sizeof(struct StringInfo));
        Write(file,(char *)s->Buffer,s->MaxChars);
    }
    if(str = IoErrToStr())
    {   enable_window();
        Error(str);
        return(FALSE); }
    return(TRUE);
}

/*
 * write the window/requester texts (if there are any)
 */
static BOOL WriteWRTexts(file)
    BPTR file;
{
    register struct IntuiText *t;
    char    *str;

    if((t = TextGadget.GadgetText))
    {   while(1)
        {   Write(file,(char *)t,sizeof(struct IntuiText));
            Write(file,(char *)t->IText,80);
            if(NOT(t = t->NextText)) break;
        }
    }
    if(str = IoErrToStr())
    {   enable_window();
        Error(str);
        return(FALSE);
    }
    return(TRUE);
}

/*
 * read a gadget
 */
static BOOL RBG(file)
    BPTR file;
{
    struct MyGadget   *g;
    struct Gadget     *gadget;
    struct IntuiText  *t,*t1;
    struct Border     *b,*b1;
    struct Image      *i;
    struct StringInfo *s;
    ULONG  data_size;
    char    *str;


    if(NOT(g = (struct MyGadget *)Alloc(&Memory,(ULONG)sizeof(struct MyGadget))))
        goto NoMem;

    AddTail((void *)&Gadgets,(void *)g);

    gadget = (struct Gadget *)&g->Gadget;

    Read(file,(char *)gadget,sizeof(struct Gadget));
    Read(file,(char *)&g->SpecialFlags,2);
    Read(file,(char *)&g->GadgetLabel,MAXLABEL);

    if(gadget->GadgetText)
    {   if(NOT(t1 = (struct IntuiText *)
         Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
            goto NoMem;
        Read(file,(char *)t1,sizeof(struct IntuiText));

        if(NOT(t1->IText = (UBYTE *)Alloc(&Memory,80L)))
            goto NoMem;
        Read(file,(char *)t1->IText,80);
        gadget->GadgetText = t1;
        if(t1->NextText)
        {   while(1)
            {   if(NOT(t = (struct IntuiText *)
                 Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
                    goto NoMem;
                Read(file,(char *)t,sizeof(struct IntuiText));

                if(NOT(t->IText = (UBYTE *)Alloc(&Memory,80L)))
                    goto NoMem;
                Read(file,(char *)t->IText,80);
                t1->NextText = t;
                if(NOT t->NextText) break;
                t1 = t;
            }
        }
    }

    if((NOT TestBits((ULONG)gadget->GadgetType,PROPGADGET)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGIMAGE)))
    {
        if(NOT(b1 = (struct Border *)
         Alloc(&Memory,(ULONG)sizeof(struct Border))))
            goto NoMem;
        Read(file,(char *)b1,sizeof(struct Border));

        if(NOT(b1->XY = (SHORT *)Alloc(&Memory,(b1->Count << 2))))
            goto NoMem;
        Read(file,(char *)b1->XY,(b1->Count << 2));
        gadget->GadgetRender = (APTR)b1;
        if(b1->NextBorder)
        {   while(1)
            {   if(NOT(b = (struct Border *)
                 Alloc(&Memory,(ULONG)sizeof(struct Border))))
                    goto NoMem;
                Read(file,(char *)b,sizeof(struct Border));

                if(NOT(b->XY = (SHORT *)Alloc(&Memory,(b->Count << 2))))
                    goto NoMem;
                Read(file,(char *)b->XY,(b->Count << 2));
                b1->NextBorder = b;
                if(NOT b->NextBorder) break;
                b1 = b;
            }
        }
    }
    else if(TestBits((ULONG)gadget->Flags,GADGIMAGE))
    {   if(NOT(i = (struct Image *)
         Alloc(&Memory,(ULONG)sizeof(struct Image))))
            goto NoMem;
        Read(file,(char *)i,sizeof(struct Image));

        data_size = (ULONG)(RASSIZE(i->Width,i->Height) * i->Depth);
        if(NOT(i->ImageData = (USHORT *)
         AllocMem(data_size,MEMF_CHIP+MEMF_CLEAR)))
            goto NoMem;
        Read(file,(char *)i->ImageData,data_size);
        gadget->GadgetRender = (APTR)i;
    }

    if((TestBits((ULONG)gadget->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGHBOX)))
    {   if(NOT(i = (struct Image *)
         Alloc(&Memory,(ULONG)sizeof(struct Image))))
            goto NoMem;
        Read(file,(char *)i,sizeof(struct Image));

        data_size = (ULONG)(RASSIZE(i->Width,i->Height) * i->Depth);
        if(NOT(i->ImageData = (USHORT *)
         AllocMem(data_size,MEMF_CHIP+MEMF_CLEAR)))
            goto NoMem;
        Read(file,(char *)i->ImageData,data_size);
        gadget->SelectRender = (APTR)i;
    }

    if(TestBits((ULONG)gadget->GadgetType,PROPGADGET))
    {   if(NOT TestBits((ULONG)gadget->Flags,GADGIMAGE))
        {   if(NOT(gadget->GadgetRender =
             Alloc(&Memory,(ULONG)sizeof(struct Image))))
                goto NoMem;
        }
        if(NOT(gadget->SpecialInfo =
          Alloc(&Memory,(ULONG)sizeof(struct PropInfo))))
                goto NoMem;
        Read(file,(char *)gadget->SpecialInfo,sizeof(struct PropInfo));
    }
    if(TestBits((ULONG)gadget->GadgetType,STRGADGET))
    {   if(NOT(s = (struct StringInfo *)
         Alloc(&Memory,(ULONG)sizeof(struct StringInfo))))
            goto NoMem;
        Read(file,(char *)s,sizeof(struct StringInfo));
        if(NOT(s->Buffer = (UBYTE *)Alloc(&Memory,s->MaxChars)))
            goto NoMem;
        Read(file,(char *)s->Buffer,s->MaxChars);
        if(s->UndoBuffer)
        {   if(NOT(s->UndoBuffer = (UBYTE *)Alloc(&Memory,s->MaxChars)))
                goto NoMem;
        }
        gadget->SpecialInfo = (APTR)s;
    }
    if(str = IoErrToStr())
    {   enable_window();
        Error(str);
        return(FALSE);
    }
    return(TRUE);

NoMem:
    enable_window();
    Error("Out of Memory !");
    return(FALSE);
}

/*
 * read the window/requester text (if there are any)
 */
static BOOL ReadWRTexts(file,num)
    BPTR file;
    ULONG num;
{
    register struct IntuiText *t, *t1;
    register UCOUNT i;
    char    *str;

    if(NOT num) return(TRUE);

    if(NOT(t = (struct IntuiText *)
     Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
        goto NoMem;
    Read(file,(char *)t,sizeof(struct IntuiText));
    if(NOT(t->IText = (UBYTE *)Alloc(&Memory,80L)))
        goto NoMem;
    Read(file,(char *)t->IText,80);
    TextGadget.GadgetText = t;
    for(i=0;i<num-1;i++)
    {   if(NOT(t1 = (struct IntuiText *)
         Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
            goto NoMem;
        Read(file,(char *)t1,sizeof(struct IntuiText));
        if(NOT(t1->IText = (UBYTE *)Alloc(&Memory,80)))
            goto NoMem;
        Read(file,(char *)t1->IText,80);
        t->NextText = t1;
        t = t1;
    }
    if(str = IoErrToStr())
    {   enable_window();
        Error(str);
        return(FALSE);
    }
    return(TRUE);

NoMem:
    enable_window();
    Error("Out of Memory !");
    return(FALSE);
}

/*
 * get the number of window/requester texts
 */
static LONG get_num_texts()
{
    register struct IntuiText *t;
    LONG num = NULL;

    if((t = TextGadget.GadgetText))
    {   num = 1L;
        while(1)
        {   if(NOT(t = t->NextText)) break;
            num++;
        }
    }
    return(num);
}

/*
 * write a binary gadgets file
 */
VOID WriteBinGadgets()
{
    struct BinHeader         head;
    BPTR                     file;
    struct ViewPort          *vp;
    ULONG                    rc;
    struct NewWindow         nw;
    register struct MyGadget *g;
    register UCOUNT          i;
    char    *str;

    strcpy((char *)IODir->fr_HeadLine,(char *)"Save Binary");

    IODir->fr_Screen  = MainScreen;
    IODir->fr_Caller  = MainWindow;
    IODir->fr_Flags  != FR_NoInfo;
    rc = FileRequest(IODir);
    if(rc == FREQ_CANCELED) return;
    else if(rc)
    {   Error("FileRequester won't open !");
        return;
    }
    strcpy((char *)&name,(char *)IODir->fr_DirName);
    strcat((char *)&name,(char *)IODir->fr_FileName);

    disable_window();
    SetWindowTitles(MainWindow,(char *)-1L,(char *)"Saving Binary......");
    buisy();
    vp = &MainScreen->ViewPort;

    if(NOT(file = Open((char *)&name,MODE_NEWFILE)))
    {   enable_window();
        Error("Can't open Write File !");
        return;
    }
    /* write file header */
    head.FileType   = TYPE;
    head.Version    = GE_VERSION;
    head.Revision   = GE_REVISION;
    head.NumGads    = GadgetCount;
    head.ReqGads    = REQUESTER;
    head.WBScreen   = WBSCREEN;
    head.ScrDepth   = MainScreen->BitMap.Depth;
    for(i=0;i<32;i++) head.Colors[i] = (USHORT)GetRGB4(vp->ColorMap,(LONG)i);
    head.NumTexts   = get_num_texts();
    head.FPen       = FrontPen;
    head.BPen       = BackPen;
    head.BackFill   = BackFill;
    head.WDBackFill = WDBackFill;
    head.LightSide  = LightSide;
    head.DarkSide   = DarkSide;
    for(i=0;i<2;i++) head.Res[i] = 0;
    Write(file,(char *)&head,sizeof(struct BinHeader));

    /* write prefs */
    Write(file,(char *)&prefs,sizeof(struct ge_prefs));

    /* write window specifics */
    nw.LeftEdge    = MainWindow->LeftEdge;
    nw.TopEdge     = MainWindow->TopEdge;
    nw.Width       = MainWindow->Width;
    nw.Height      = MainWindow->Height;
    nw.DetailPen   = MainWindow->DetailPen;
    nw.BlockPen    = MainWindow->BlockPen;
    nw.Flags       = WindowFlags;
    nw.IDCMPFlags  = IDCMPFlags;
    nw.FirstGadget = NULL;
    nw.CheckMark   = NULL;
    nw.Title       = NULL;
    nw.Screen      = NULL;
    nw.BitMap      = NULL;
    nw.MinWidth    = MainWindow->MinWidth;
    nw.MinHeight   = MainWindow->MinHeight;
    nw.MaxWidth    = MainWindow->MaxWidth;
    nw.MaxHeight   = MainWindow->MaxHeight;
    nw.Type        = CUSTOMSCREEN;
    Write(file,(char *)&nw,sizeof(struct NewWindow));

    /* write title + label */
    Write(file,(char *)&wdt,80);
    Write(file,(char *)&wlb,MAXLABEL);

    /* write window/requester texts */
    if(WriteWRTexts(file) == FALSE)
    {   Close(file);
        return;
    }

    if(GadgetCount)
    {   for(g = Gadgets.Head; g != (struct MyGadget *)&Gadgets.Tail; g = g->Succ)
        {   if(WBG(file,g) == FALSE)
            {   Close(file);
                return;
            }
        }
    }
    Close(file);
    if(str = IoErrToStr())
    {   enable_window();
        Error(str);
        DeleteFile((char *)&name[0]);
        return;
    }
    Saved = TRUE;
    if(NOT(write_icon((char *)&name[0])))
        Error("Error writing the icon");
    enable_window();
    ok();
}

/*
 * read a binary gadgets file
 */
VOID ReadBinGadgets(fsu)
    BOOL fsu;
{
    struct BinHeader         head;
    BPTR                     file;
    struct ViewPort          *vp;
    ULONG                    rc;
    register struct MyGadget *g;
    register UCOUNT          i;
    char   *str;

    if(NOT fsu)
    {   if(Saved == FALSE)
        {   if(Ask("Current work isn't saved !",
                   "Load a file anyway ?") == FALSE) return;
        }
        strcpy((char *)IODir->fr_HeadLine,(char *)"Load Binary");
        IODir->fr_Screen  = MainScreen;
        IODir->fr_Caller  = MainWindow;
        IODir->fr_Flags  |= FR_NoInfo;
        rc = FileRequest(IODir);
        if(rc == FREQ_CANCELED) return;
        else if(rc)
        {   Error("FileRequester won't open !");
            return;
        }
        strcpy((char *)&name,(char *)IODir->fr_DirName);
        strcat((char *)&name,(char *)IODir->fr_FileName);
    }

    if(NOT(file = Open((char *)&name,MODE_OLDFILE)))
    {   if(fsu)
        {   WBSCREEN = TRUE;
            change_depth(2);
        }
        Error("Can't open Read File !");
        return;
    }

    Read(file,(char *)&head,sizeof(struct BinHeader));


    if(head.FileType == OLDTYPE)
    {   if(fsu)
        {   WBSCREEN = TRUE;
            change_depth(2);
        }
        Close(file);
        Error("File needs patching !"); return;
    }
    if(head.FileType != TYPE)
    {   if(fsu)
        {   WBSCREEN = TRUE;
            change_depth(2);
        }
        Close(file);
        Error("Unknown FileType !"); return;
    }

    FreeGList();
    GadgetCount = id = 0;

    REQUESTER  = head.ReqGads;
    WBSCREEN   = head.WBScreen;
    FrontPen   = head.FPen;
    BackPen    = head.BPen;
    BackFill   = head.BackFill;
    WDBackFill = head.WDBackFill;
    LightSide  = head.LightSide;
    DarkSide   = head.DarkSide;

    Read(file,(char *)&prefs,sizeof(struct ge_prefs));
    Read(file,(char *)&nw_main,sizeof(struct NewWindow));

    WindowFlags = nw_main.Flags;
    IDCMPFlags  = nw_main.IDCMPFlags;

    if(REQUESTER)
    {   nw_main.Flags     = WINDOWDRAG|WINDOWSIZING;
        nw_main.Flags    |= GIMMEZEROZERO|SIZEBRIGHT|SIZEBBOTTOM|BORDERLESS;
    }
    else
    {   nw_main.Flags     = 0;
        if(TestBits(WindowFlags,WINDOWCLOSE))   nw_main.Flags |= WINDOWCLOSE;
        if(TestBits(WindowFlags,WINDOWDEPTH))   nw_main.Flags |= WINDOWDEPTH;
        if(TestBits(WindowFlags,WINDOWDRAG))    nw_main.Flags |= WINDOWDRAG;
        if(TestBits(WindowFlags,WINDOWSIZING))  nw_main.Flags |= WINDOWSIZING;
        if(TestBits(WindowFlags,SIZEBRIGHT))    nw_main.Flags |= SIZEBRIGHT;
        if(TestBits(WindowFlags,SIZEBBOTTOM))   nw_main.Flags |= SIZEBBOTTOM;
    }
    nw_main.Flags      |=SMART_REFRESH|NOCAREREFRESH|ACTIVATE;
    nw_main.IDCMPFlags  =SIZEVERIFY|NEWSIZE|GADGETUP|GADGETDOWN|INACTIVEWINDOW;
    nw_main.IDCMPFlags |=ACTIVEWINDOW|MENUPICK|RAWKEY|MOUSEBUTTONS|CLOSEWINDOW;

    Read(file,(char *)&wdt,80);
    Read(file,(char *)&wlb,MAXLABEL);

    change_depth(head.ScrDepth);
    disable_window();
    SetWindowTitles(MainWindow,(char *)-1L,(char *)"Reading Binary......");
    buisy();
    vp = &MainScreen->ViewPort;
    if(NOT WBSCREEN)
        LoadRGB4(vp,(void *)&head.Colors,(1 << MainScreen->BitMap.Depth));
    else
        LoadRGB4(vp,(void *)&WBColors[0],4);
    if(ReadWRTexts(file,head.NumTexts) == FALSE)
    {   Close(file);
        FreeGList();
        return;
    }
    if(head.NumGads)
    {   for(i=0;i<head.NumGads;i++)
        {   if(RBG(file) == FALSE)
            {   Close(file);
                FreeGList();
                return;
            }
        }
        for(g = Gadgets.Head; g != (struct MyGadget *)&Gadgets.Tail; g = g->Succ)
        {   AddGList(MainWindow,&g->Gadget,NULL,1,NULL);
            GadgetCount++;
            id++;
        }
    }
    Close(file);
    rem_bo();
    refresh();
    Saved = TRUE;
    enable_window();
    ok();
    if(str = IoErrToStr()) Error(str);
}
