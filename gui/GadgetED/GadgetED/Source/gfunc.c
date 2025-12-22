/*----------------------------------------------------------------------*
  gfunc.c Version 2.3 -  © Copyright 1990-91 Jaba Development

  Author : Jan van den Baard
  Purpose: functions called by user via menu and keyboard
 *----------------------------------------------------------------------*/

extern struct Window        *MainWindow;
extern struct Screen        *MainScreen;
extern struct RastPort      *MainRP;
extern struct GadgetList     Gadgets;
extern struct ge_prefs       prefs;
extern struct Gadget         TextGadget;
extern struct NewWindow      nw_main;
extern struct FileRequester *IODir;
extern struct MemoryChain    Memory;
extern BOOL                  Saved, REQUESTER, WBSCREEN;
extern USHORT                FrontPen, Code, GadgetCount, id, BackFill;
extern USHORT                Colors[32],DEPTH, WDBackFill;
extern UBYTE                 name[256], wdt[80], wlb[MAXLABEL];
extern SHORT                 MainX,MainY,text_num;
extern ULONG                 IDCMPFlags, WindowFlags, Class;

struct Gadget *wait_for_gadget();

/*
 * remove all 'BORDERONLY' gadgets from the edit window
 * so they won't interferre with your editing
 */
VOID rem_bo()
{
    register struct MyGadget *g;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;

    for(g = Gadgets.Head; g->Succ; g = g->Succ)
    {   if(TestBits((ULONG)g->SpecialFlags,BORDERONLY))
            RemoveGList(MainWindow,&g->Gadget,1);
    }
}

/*
 * put back all 'BORDERONLY' gadgets in the edit window
 * so they may be selected to be moved, re-sized, deleted,
 * copied and edited
 */
VOID add_bo()
{
    register struct MyGadget *g;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;

    for(g = Gadgets.Head; g->Succ; g = g->Succ)
    {   if(TestBits((ULONG)g->SpecialFlags,BORDERONLY))
            AddGList(MainWindow,&g->Gadget,-1L,1,NULL);
    }
}

/*
 * remove all normal gadgets from the edit window
 * so they won't interferre with text palcing and gadget resizing.
 */
VOID rem_no()
{
    register struct MyGadget *g;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;

    for(g = Gadgets.Head; g->Succ; g = g->Succ)
    {   if(NOT TestBits((ULONG)g->SpecialFlags,BORDERONLY))
            RemoveGList(MainWindow,&g->Gadget,1);
    }
}

/*
 * put back all normal gadgets in the edit window
 * so they may be selected to be moved, re-sized, deleted,
 * copied and edited
 */
VOID add_no()
{
    register struct MyGadget *g;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;

    for(g = Gadgets.Head; g->Succ; g = g->Succ)
    {   if(NOT TestBits((ULONG)g->SpecialFlags,BORDERONLY))
            AddGList(MainWindow,&g->Gadget,-1L,1,NULL);
    }
}

/*
 * refresh the complete display
 */
VOID refresh()
{
    USHORT br,bt,bb,bl;

    br = MainWindow->BorderRight;
    bt = MainWindow->BorderTop;
    bb = MainWindow->BorderBottom;
    bl = MainWindow->BorderLeft;

    SetDrMd(MainRP,JAM1);

    if(REQUESTER)
    {   add_bo();
        SetAPen(MainRP,BackFill);
        RectFill(MainRP,0,0,MainWindow->GZZWidth,MainWindow->GZZHeight);
        RefreshWindowFrame(MainWindow);
        rem_bo();
    }
    else
    {   RefreshWindowFrame(MainWindow);
        SetAPen(MainRP,WDBackFill);
        RectFill(MainRP,bl-2,bt-1,MainWindow->Width-bl+1,MainWindow->Height-2);
        add_bo();
        RefreshGList(MainWindow->FirstGadget,MainWindow,NULL,-1L);
        rem_bo();
    }
    if(TextGadget.GadgetText) PrintIText(MainRP,TextGadget.GadgetText,0,0);
}

/*
 * get the pointer to the MyGadget structure in which gadget 'g'
 * is defined
 */
struct MyGadget *get_mg(g)
    struct Gadget *g;
{
    register struct MyGadget *ret;

    for(ret = Gadgets.Head; ret ->Succ; ret = ret->Succ)
        if(g == &ret->Gadget) return(ret);
}

/*
 * check to see if there are already gadgets on the
 * edit window that are not 'BORDERONLY'
 */
BOOL is_gadget()
{
    register struct MyGadget *tmp;

    for(tmp = Gadgets.Head; tmp->Succ ; tmp = tmp->Succ)
    {   if(NOT TestBits((ULONG)tmp->SpecialFlags,BORDERONLY)) return(TRUE);
    }
    return(FALSE);
}

/*
 * make a copy of a gadget
 */
VOID copy_gadget()
{
    struct Gadget *gad;
    SHORT             x,y,w,h,xo,yo,ls,ds;
    ULONG             ps;
    struct MyGadget   *gadget, *mg;
    struct Border     *border,*border1;
    struct StringInfo *sinfo, *sinfo1;
    struct PropInfo   *pinfo;
    struct Image      *image, *image1;
    struct IntuiText  *to, *tn, *tnl;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    add_bo();
    sst("PICK GADGET TO COPY....");
    if(NOT(gad = wait_for_gadget(MainWindow)))
    {   rem_bo();
        return;
    }

    rem_bo();
    rem_no();
    Saved = FALSE;
    mg = get_mg(gad);

    if(NOT(gadget = (struct MyGadget *)Alloc(&Memory,(ULONG)sizeof(struct MyGadget))))
    {   Error("Out of Memory !");
        return;
    }

    un_grel(MainWindow,gad);
    CopyMem((void *)gad,(void *)&gadget->Gadget,sizeof(struct Gadget));

    gadget->Gadget.GadgetText   = NULL;
    gadget->Gadget.GadgetRender = NULL;
    gadget->Gadget.SelectRender = NULL;
    gadget->Gadget.SpecialInfo  = NULL;
    gadget->Gadget.GadgetID     = GadgetCount++;
    Format((char *)&gadget->GadgetLabel,"Gadget%ld",id++);
    gadget->Gadget.LeftEdge     = gad->LeftEdge + 5;
    gadget->Gadget.TopEdge      = gad->TopEdge  + 5;
    gadget->SpecialFlags        = mg->SpecialFlags;


    if(NOT TestBits((ULONG)gad->GadgetType,PROPGADGET))
    {   if((NOT TestBits((ULONG)gad->Flags,GADGIMAGE)) OR
           (NOT prefs.image_copy))
        {   border = (struct Border *)gad->GadgetRender;
            if(add_border(gadget) == FALSE)
                goto NoMem;
            border1 = (struct Border *)gadget->Gadget.GadgetRender;
            border1->FrontPen = border->FrontPen;
            if(TestBits((ULONG)gadget->SpecialFlags,OS20BORDER))
                border1->NextBorder->FrontPen = border->NextBorder->FrontPen;
        }
    }
    else
    {   if(NOT(pinfo = (struct PropInfo *)Alloc(&Memory,(ULONG)sizeof(struct PropInfo))))
            goto NoMem;
        CopyMem((void *)gad->SpecialInfo,(void *)pinfo,sizeof(struct PropInfo));
        if((NOT(TestBits((ULONG)gad->Flags,GADGIMAGE))) OR
           (prefs.image_copy == FALSE))
        {   if(NOT(gadget->Gadget.GadgetRender = Alloc(&Memory,(ULONG)sizeof(struct Image))))
                goto NoMem;
            pinfo->Flags |= AUTOKNOB;
        }
        gadget->Gadget.SpecialInfo = (APTR)pinfo;
    }

    if((TestBits((ULONG)gad->Flags,GADGIMAGE)) AND
       (prefs.image_copy == TRUE))
    {   image = (struct Image *)gad->GadgetRender;
        ps = (ULONG)(RASSIZE(image->Width,image->Height) * image->Depth);
        if(NOT(image1 = (struct Image *)Alloc(&Memory,(ULONG)sizeof(struct Image))))
            goto NoMem;
        CopyMem((void *)image,(void *)image1,sizeof(struct Image));
        if(NOT(image1->ImageData = (USHORT *)AllocMem(ps,MEMF_CHIP+MEMF_CLEAR)))
            goto NoMem;
        CopyMem((void *)image->ImageData,(void *)image1->ImageData,ps);
        gadget->Gadget.GadgetRender = (APTR)image1;
    }
    else if((TestBits((ULONG)gad->Flags,GADGIMAGE)) AND
            (prefs.image_copy == FALSE))
                  gadget->Gadget.Flags ^= GADGIMAGE;

    if((TestBits((ULONG)gad->Flags,GADGHIMAGE)) AND
       (prefs.image_copy == TRUE) AND
       (NOT TestBits((ULONG)gad->Flags,GADGHBOX)))
    {   image = (struct Image *)gad->SelectRender;
        ps = (ULONG)(RASSIZE(image->Width,image->Height) * image->Depth);
        if(NOT(image1 = (struct Image *)Alloc(&Memory,(ULONG)sizeof(struct Image))))
            goto NoMem;
        CopyMem((void *)image,(void *)image1,sizeof(struct Image));
        if(NOT(image1->ImageData = (USHORT *)AllocMem(ps,MEMF_CHIP+MEMF_CLEAR)))
            goto NoMem;
        CopyMem((void *)image->ImageData,(void *)image1->ImageData,ps);
        gadget->Gadget.SelectRender = (APTR)image1;
    }
    else if((TestBits((ULONG)gad->Flags,GADGHIMAGE)) AND
            (prefs.image_copy == FALSE))
    {   gadget->Gadget.SelectRender = NULL;
        gadget->Gadget.Flags ^= GADGHIMAGE;
    }

    if((gad->GadgetText) AND (prefs.text_copy == TRUE))
    {   to = gad->GadgetText;
        if(NOT(tn = (struct IntuiText *)Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
            goto NoMem;
        CopyMem((char *)to,(char *)tn,(ULONG)sizeof(struct IntuiText));
        if(NOT(tn->IText = (UBYTE *)Alloc(&Memory,80L)))
            goto NoMem;
        CopyMem((char *)to->IText,(char *)tn->IText,80L);
        gadget->Gadget.GadgetText = tn;
        if(to = to->NextText)
        {   while(1)
            {   if(NOT(tnl = (struct IntuiText *)Alloc(&Memory,(ULONG)sizeof(struct IntuiText))))
                    goto NoMem;
                CopyMem((char *)to,(char *)tnl,(ULONG)sizeof(struct IntuiText));
                if(NOT(tnl->IText = (UBYTE *)Alloc(&Memory,80L)))
                    goto NoMem;
                CopyMem((char *)to->IText,(char *)tnl->IText,80L);
                tn->NextText = tnl;
                tn = tnl;
                if(NOT(to = to->NextText)) break;
            }
        }
    }
    if((TestBits((ULONG)gad->GadgetType,STRGADGET)))
    {   sinfo1 = (struct StringInfo *)gad->SpecialInfo;
        if(NOT(sinfo = (struct StringInfo *)Alloc(&Memory,(ULONG)sizeof(struct StringInfo))))
            goto NoMem;
        CopyMem((void *)sinfo1,(void *)sinfo,sizeof(struct StringInfo));
        if(NOT(sinfo->Buffer = (UBYTE *)Alloc(&Memory,sinfo->MaxChars)))
            goto NoMem;
        CopyMem((void *)sinfo1->Buffer,(void *)sinfo->Buffer,sinfo->MaxChars);
        if(sinfo->UndoBuffer)
        {   if(NOT(sinfo1->UndoBuffer = (UBYTE *)Alloc(&Memory,sinfo->MaxChars)))
                goto NoMem;
        }
        gadget->Gadget.SpecialInfo = (APTR)sinfo;
    }
    set_info();
    x = gadget->Gadget.LeftEdge-1;
    y = gadget->Gadget.TopEdge-1;
    w = gadget->Gadget.Width+1;
    h = gadget->Gadget.Height+1;
    SetDrMd(MainRP,COMPLEMENT);
    SetAPen(MainRP,FrontPen);
    draw_box(MainWindow,x,y,x+w,y+h);
    do_info(x,y,x+w,y+w);
    xo = MainX-x;
    yo = MainY-y;
    while(Code != SELECTDOWN)
    {   while(read_msg(MainWindow))
        {   if(Class == MENUPICK) set_info();
            do_info(x,y,x+w,y+h);
        }
        get_xy(&MainX,&MainY);
        if((MainX != (x + xo)) OR (MainY != (y + yo)))
        {   draw_box(MainWindow,x,y,x+w,y+h);
            x = MainX - xo;
            y = MainY - yo;
            draw_box(MainWindow,x,y,x+w,y+h);
            do_info(x,y,x+w,y+w);
        }
    }
    gadget->Gadget.LeftEdge = x+1;
    gadget->Gadget.TopEdge  = y+1;
    AddHead((void *)&Gadgets,(void *)gadget);
    grel(MainWindow,&gadget->Gadget);
    grel(MainWindow,gad);
    add_no();
    refresh();
    return;
NoMem:
    FreeGadget(gadget);
    Error("Out of Memory !");
}

/*
 * delete a gadget
 */
VOID delete()
{
    struct Gadget   *gd;
    struct MyGadget *gadget;
    UCOUNT          i=0;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;

    add_bo();
    sst("PICK GADGET TO DELETE.....");
    if(NOT(gd = wait_for_gadget(MainWindow))) { rem_bo(); return; }

    Saved = FALSE;

    for(gadget = Gadgets.Head; gadget->Succ; gadget = gadget->Succ)
    {   if(gd == &gadget->Gadget)
        {   Remove((void *)gadget);
            un_grel(MainWindow,gd);
            RemoveGList(MainWindow,gd,1);
            FreeGadget(gadget);
            break;
        }
    }
    for(gadget = Gadgets.TailPred; gadget != (struct MyGadget *)&Gadgets.Head; gadget = gadget->Pred)
       gadget->Gadget.GadgetID = i++;
    rem_bo();
    refresh();
}

/*
 * load a IFF ILBM brush as gadget render
 */
VOID render()
{
    struct Gadget   *gadget;
    struct PropInfo *info;
    struct Border   *border;
    struct Image    *image, *image1, *ReadImage();
    ULONG            Pos, ps, rc;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    if(NOT is_gadget()) return;
    sst("PICK GADGET TO RENDER.....");
    if(NOT(gadget = wait_for_gadget(MainWindow))) return;

    if(TestBits((ULONG)gadget->Flags,GADGIMAGE))
    {   if(Ask("Gadget already has an Image !",
               "Do you wish to over-write it ?") == FALSE) return;
    }

    strcpy((char *)IODir->fr_HeadLine,"Load Gadget Render");
    IODir->fr_Screen  = MainScreen;
    IODir->fr_Caller  = MainWindow;
    IODir->fr_Flags  |= FR_NoInfo;
    rc = FileRequest(IODir);
    strcpy((char *)&name,(char *)IODir->fr_DirName);
    strcat((char *)&name,(char *)IODir->fr_FileName);

    if(rc == FREQ_CANCELED) return;
    else if(rc)
    {   Error("FileRequester Won't Open !");
        return;
    }
    Saved = FALSE;
    disable_window();
    if(NOT(image = ReadImage(name)))
    {   enable_window();
        return;
    }

    Pos = RemoveGList(MainWindow,gadget,1);
    un_grel(MainWindow,gadget);

    if(TestBits((ULONG)gadget->Flags,GADGIMAGE))
    {   image1 = (struct Image *)gadget->GadgetRender;
        ps     = (ULONG)(RASSIZE(image1->Width,image1->Height) * image1->Depth);
        FreeMem(image1->ImageData,ps);
        FreeItem(&Memory,image1,(long)sizeof(struct Image));
    }
    else if(TestBits((ULONG)gadget->GadgetType,PROPGADGET))
        FreeItem(&Memory,gadget->GadgetRender,(long)sizeof(struct Image));
    else
    {   border = (struct Border *)gadget->GadgetRender;
        FreeItem(&Memory,border->XY,20L);
        FreeItem(&Memory,border,(long)sizeof(struct Border));
    }
    if(NOT(TestBits((ULONG)gadget->GadgetType,PROPGADGET)))
    {   if(prefs.auto_size)
        {   gadget->Width  = image->Width;
            gadget->Height = image->Height;
        }
    }
    else
    {   info = (struct PropInfo *)gadget->SpecialInfo;
        info->Flags ^= AUTOKNOB;
    }
    gadget->Flags       |= GADGIMAGE;
    gadget->GadgetRender = (APTR)image;
    grel(MainWindow,gadget);
    AddGList(MainWindow,gadget,Pos,1,NULL);
    enable_window();
    refresh();
}

/*
 * read an IFF ILBM brush as select render
 */
VOID sel_render()
{
    struct Gadget   *gadget;
    struct PropInfo *info;
    struct Image    *image, *image1, *ReadImage();
    ULONG           Pos, ps, rc;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    if(NOT is_gadget()) return;
    sst("PICK GADGET TO SELECT RENDER.....");
    if(NOT(gadget = wait_for_gadget(MainWindow))) return;

    if((TestBits((ULONG)gadget->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGHBOX)))
    {   if(Ask("Gadget already has an Image !",
               "Do you wish to over-write it ?") == FALSE) return;
    }

    if(NOT(TestBits((ULONG)gadget->Flags,GADGIMAGE)))
    {   Error("Not an Image Gadget !");
        return;
    }

    strcpy((char *)IODir->fr_HeadLine,"Load Select Render");
    IODir->fr_Screen  = MainScreen;
    IODir->fr_Caller  = MainWindow;
    IODir->fr_Flags  |= FR_NoInfo;
    rc = FileRequest(IODir);
    strcpy((char *)&name,(char *)IODir->fr_DirName);
    strcat((char *)&name,(char *)IODir->fr_FileName);
    if(rc == FREQ_CANCELED) return;
    else if(rc)
    {   Error("FileRequester Won't Open");
        return;
    }

    Saved = FALSE;

    disable_window();
    if(NOT(image = ReadImage(name)))
    {   enable_window();
        return;
    }
    Pos = RemoveGList(MainWindow,gadget,1);
    un_grel(MainWindow,gadget);
    if((TestBits((ULONG)gadget->Flags,GADGHBOX)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGHIMAGE)))
           gadget->Flags ^= GADGHBOX;

    if((TestBits((ULONG)gadget->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gadget->Flags,GADGHBOX)))
    {   image1 = (struct Image *)gadget->SelectRender;
        ps     = (ULONG)(RASSIZE(image1->Width,image1->Height) * image1->Depth);
        FreeMem(image1->ImageData,ps);
        FreeItem(&Memory,image1,(long)sizeof(struct Image));
    }

    gadget->Flags       |= GADGHIMAGE;
    gadget->SelectRender = (APTR)image;
    grel(MainWindow,gadget);
    AddGList(MainWindow,gadget,Pos,1,NULL);
    enable_window();
    refresh();
}

/*
 * read and set the CMAP of an IFF ILBM picture
 */
VOID do_cmap()
{
    ULONG rc;

    strcpy((char *)IODir->fr_HeadLine,"Load IFF ColorMap");
    IODir->fr_Screen = MainScreen;
    IODir->fr_Caller = MainWindow;
    rc = FileRequest(IODir);
    strcpy((char *)&name,(char *)IODir->fr_DirName);
    strcat((char *)&name,(char *)IODir->fr_FileName);
    if(rc == FREQ_CANCELED) return;
    else if(rc)
    {   Error("FileRequester Won't Open !");
        return;
    }
    Saved = FALSE;
    disable_window();
    ReadCMAP(name);
    enable_window();
}

/*
 * resize a gadget
 */
VOID size_gadget()
{
    struct MyGadget *mg;
    struct Gadget *gadget;
    SHORT         x,y,w,h,xo,yo, *XY;
    ULONG         Pos;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    add_bo();
    sst("PICK GADGET TO RE-SIZE.....");
    if(NOT(gadget = wait_for_gadget(MainWindow))) { rem_bo(); return; }

    rem_bo();
    rem_no();

    Saved = FALSE;

    mg = get_mg(gadget);
    un_grel(MainWindow,gadget);
    x = gadget->LeftEdge-1;
    y = gadget->TopEdge-1;
    w = gadget->Width+1;
    h = gadget->Height+1;
    set_info();
    SetDrMd(MainRP,COMPLEMENT);
    SetAPen(MainRP,FrontPen);
    draw_box(MainWindow,x,y,x+w,y+h);
    do_info(x,y,x+w,y+h);
    xo = (x+w)-MainX;
    yo = (y+h)-MainY;

    while(Code != SELECTDOWN)
    {   while(read_msg(MainWindow))
        {   if(Class == MENUPICK) set_info();
            do_info(x,y,x+w,y+h);
        }
        get_xy(&MainX,&MainY);
        if((MainX != ((x + w) - xo)) OR (MainY != ((y + h) - yo)))
        {   draw_box(MainWindow,x,y,x+w,y+h);
            if(((MainX - x) + xo) >= 9)  w = (MainX - x) + xo;
            if(((MainY - y) + yo) >= 9)  h = (MainY - y) + yo;
            draw_box(MainWindow,x,y,x+w,y+h);
            do_info(x,y,x+w,y+h);
        }
    }
    add_bo();
    add_no();
    draw_box(MainWindow,x,y,x+w,y+h);
    gadget->Width  = w-1;
    gadget->Height = h-1;
    if((TestBits((ULONG)gadget->GadgetType,STRGADGET)) &&
       (TestBits((ULONG)mg->SpecialFlags,OS20BORDER)))
        { w++; h++; }
    if(NOT(TestBits((ULONG)gadget->GadgetType,PROPGADGET)))
    {   if(NOT TestBits((ULONG)mg->SpecialFlags,OS20BORDER))
        {   XY = (((struct Border *)gadget->GadgetRender)->XY);
            XY[2] = XY[4] = w-1;
            XY[5] = XY[7] = h-1;
        }
        else
        {   w-=2; h-=2;
            XY = (((struct Border *)gadget->GadgetRender)->XY);
            XY[3] = h;
            XY[5] = h-1;
            XY[8] = w-1;
            XY = ((((struct Border *)gadget->GadgetRender)->NextBorder)->XY);
            XY[1] = XY[3] = XY[9] = h;
            XY[2] = XY[4] = w-1;
            XY[6] = XY[8] = w;
        }
    }
    grel(MainWindow,gadget);
    rem_bo();
    refresh();
}

/*
 * move a gadget
 */
VOID move_gadget()
{
    struct MyGadget *mg;
    struct Gadget *gadget;
    SHORT x,y,w,h,xo,yo;
    ULONG Pos;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    add_bo();
    sst("PICK GADGET TO MOVE....");
    if(NOT(gadget = wait_for_gadget(MainWindow))) { rem_bo(); return; }

    Saved = FALSE;
    rem_bo();
    rem_no();
    mg = get_mg(gadget);
    set_info();
    un_grel(MainWindow,gadget);
    x = gadget->LeftEdge-1;
    y = gadget->TopEdge-1;
    w = gadget->Width+1;
    h = gadget->Height+1;
    SetDrMd(MainRP,COMPLEMENT);
    SetAPen(MainRP,FrontPen);
    draw_box(MainWindow,x,y,x+w,y+h);
    do_info(x,y,x+w,y+h);
    xo = MainX-x;
    yo = MainY-y;

    while(Code != SELECTDOWN)
    {   while(read_msg(MainWindow))
        {   if(Class == MENUPICK) set_info();
            do_info(x,y,x+w,y+h);
        }
        get_xy(&MainX,&MainY);
        if((MainX != (x + xo)) OR (MainY != (y + yo)))
        {   draw_box(MainWindow,x,y,x+w,y+h);
            x = MainX - xo;
            y = MainY - yo;
            draw_box(MainWindow,x,y,x+w,y+h);
            do_info(x,y,x+w,y+h);
        }
    }
    add_bo();
    add_no();
    draw_box(MainWindow,x,y,x+w,y+h);
    gadget->LeftEdge = x+1;
    gadget->TopEdge  = y+1;
    grel(MainWindow,gadget);
    rem_bo();
    refresh();
}

/*
 * edit a gadget
 */
VOID edit()
{
    struct MyGadget *mg;
    struct Gadget   *g;
    ULONG  Pos;
    BOOL   suc;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    add_bo();
    sst("PICK GADGET TO EDIT....");
    if(NOT(g = wait_for_gadget(MainWindow))) { rem_bo(); return; }

    Saved = FALSE;

    mg = get_mg(g);
    Pos = RemoveGList(MainWindow,g,1);
    un_grel(MainWindow,g);
    disable_window();
    suc = edit_gadget(mg);
    enable_window();
    grel(MainWindow,g);
    if(NOT suc)
    {   Remove((void *)mg);
        FreeGadget(mg);
    }
    else AddGList(MainWindow,g,Pos,1,NULL);
    rem_bo();
    refresh();
}

/*
 * erase all gadgets and set the window to default
 */
VOID new()
{
    if(Saved == FALSE)
    {   if(Ask("Current work isn't saved !",
               "Are you sure ?") == FALSE) return;
    }

    FreeGList();

    if(REQUESTER)
    {   nw_main.Flags     = WINDOWDRAG+WINDOWSIZING+SIZEBRIGHT+SIZEBBOTTOM+BORDERLESS+GIMMEZEROZERO;
        strcpy((char *)&wdt,"Requester");
        strcpy((char *)&wlb,"requester");
        BackFill = 1;
    }
    else
    {   nw_main.Flags    = WINDOWDRAG+WINDOWSIZING+WINDOWDEPTH+WINDOWCLOSE;
        strcpy((char *)&wdt,"Work Window");
        strcpy((char *)&wlb,"new_window");
    }
    nw_main.LeftEdge    = 50;
    nw_main.TopEdge     = 25;
    nw_main.Width       = 175;
    nw_main.Height      = 50;
    nw_main.BlockPen    = 1;
    nw_main.DetailPen   = 0;
    nw_main.FirstGadget = NULL;
    nw_main.Title       = (UBYTE *)&wdt;
    nw_main.MinWidth    = 150;
    nw_main.MinHeight   = 50;
    nw_main.MaxWidth    = MainScreen->Width;
    nw_main.MaxHeight   = MainScreen->Height;
    nw_main.Flags      |= NOCAREREFRESH+SMART_REFRESH+ACTIVATE;

    WindowFlags = WINDOWCLOSE+WINDOWDRAG+WINDOWDEPTH+WINDOWSIZING+NOCAREREFRESH+SMART_REFRESH+ACTIVATE;
    IDCMPFlags  = GADGETUP+GADGETDOWN+CLOSEWINDOW;
    CloseWindow(MainWindow);
    open_display();
    SetMenu(MainWindow);
    if(!WBSCREEN)
        LoadRGB4(&MainScreen->ViewPort,(void *)&Colors,(1 << DEPTH));
    refresh();
}

/*
 * delete the render images of a gadget
 */
VOID delete_images()
{
    struct Gadget   *g;
    struct Image    *i;
    struct PropInfo *p;
    ULONG            pos,ds;

    if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
    if(NOT is_gadget()) return;
    sst("PICK GADGET TO DELETE IMAGES....");
    if(NOT(g = wait_for_gadget(MainWindow))) return;

    if(NOT(TestBits((ULONG)g->Flags,GADGIMAGE)))
    {   Error("Gadget has no Images to delete !");
        return;
    }

    Saved = FALSE;

    pos = RemoveGList(MainWindow,g,1);
    un_grel(MainWindow,g);
    i = (struct Image *)g->GadgetRender;
    ds = (ULONG)(RASSIZE(i->Width,i->Height) * i->Depth);
    FreeMem(i->ImageData,ds);
    if(NOT TestBits(g->GadgetType,PROPGADGET))
       FreeItem(&Memory,i,(long)sizeof(struct Image));
    g->Flags ^= GADGIMAGE;
    if((TestBits((ULONG)g->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)g->Flags,GADGHBOX)))
    {   i = (struct Image *)g->SelectRender;
        ds = (ULONG)(RASSIZE(i->Width,i->Height) * i->Depth);
        FreeMem(i->ImageData,ds);
        FreeItem(&Memory,i,(long)sizeof(struct Image));
        g->Flags ^= GADGHIMAGE;
        g->SelectRender = NULL;
    }
    if(TestBits((ULONG)g->GadgetType,PROPGADGET))
    {   p = (struct PropInfo *)g->SpecialInfo;
        p->Flags |= AUTOKNOB;
    }
    else add_border(get_mg(g));
    grel(MainWindow,g);
    AddGList(MainWindow,g,pos,1,NULL);
    refresh();
}

/*
 * add a text to a gadget or the window/requester
 */
VOID add_text(which)
    USHORT which;
{
    struct Gadget *g;
    struct IntuiText *t, *edit_text();
    ULONG pos;
    SHORT x,y;

    if(NOT which)
    {   if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
        if(NOT is_gadget()) return;
        sst("PICK GADGET TO ADD TEXT....");
        if(NOT(g = wait_for_gadget(MainWindow))) return;
    }
    else g = &TextGadget;

    if(NOT(t = edit_text(g,0,0,which))) return;

    rem_no();
    Saved = FALSE;

    un_grel(MainWindow,g);
    get_xy(&x,&y);
    SetDrMd(MainRP,COMPLEMENT);
    SetAPen(MainRP,FrontPen);
    Move(MainRP,x,y);
    Text(MainRP,(char *)t->IText,strlen((char *)t->IText));

    while(Code != SELECTDOWN)
    {   while(read_msg(MainWindow));
        get_xy(&MainX,&MainY);
        if((MainX != x) OR (MainY != y))
        {   Move(MainRP,x,y);
            Text(MainRP,(char *)t->IText,strlen((char *)t->IText));
            x = MainX;
            y = MainY;
            Move(MainRP,x,y);
            Text(MainRP,(char *)t->IText,strlen((char *)t->IText));
        }
    }
    Move(MainRP,x,y);
    Text(MainRP,(char *)t->IText,strlen((char *)t->IText));

    t->LeftEdge = x - g->LeftEdge;
    t->TopEdge  = y - g->TopEdge - 6;

    if(NOT which)
        grel(MainWindow,g);
    add_no();
    refresh();
}

/*
 * move a gadget or window/requester text
 */
VOID move_text(which)
    USHORT which;
{
    struct Gadget    *g;
    struct IntuiText *t, *GetPtr();
    ULONG            pos;
    LONG             tnum;
    SHORT            x,y;

    if(NOT which)
    {   if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
        if(NOT is_gadget()) return;
        sst("PICK GADGET TO MOVE TEXT....");
        if(NOT(g = wait_for_gadget(MainWindow))) return;

    }
    else g = &TextGadget;

    if(NOT g->GadgetText)
    {   if(NOT which) Error("Gadget has no text(s) to move !");
        else if(which == 1) Error("Window has no text(s) to move !");
        else Error("Requester has no text(s) to move !");
        return;
    }
    if((tnum = text_select(g,1,which)) == -1L) return;

    Saved = FALSE;
    t = GetPtr(g,tnum);

    rem_no();
    un_grel(MainWindow,g);
    get_xy(&x,&y);
    SetDrMd(MainRP,COMPLEMENT);
    SetAPen(MainRP,FrontPen);
    Move(MainRP,x,y);
    Text(MainRP,(char *)t->IText,strlen((char *)t->IText));

    while(Code != SELECTDOWN)
    {   while(read_msg(MainWindow));
        get_xy(&MainX,&MainY);
        if((MainX != x) OR (MainY != y))
        {   Move(MainRP,x,y);
            Text(MainRP,(char *)t->IText,strlen((char *)t->IText));
            x = MainX;
            y = MainY;
            Move(MainRP,x,y);
            Text(MainRP,(char *)t->IText,strlen((char *)t->IText));
        }
    }
    Move(MainRP,x,y);
    Text(MainRP,(char *)t->IText,strlen((char *)t->IText));
    text_num = tnum;
    clear_text(g);
    t->LeftEdge = x - g->LeftEdge;
    t->TopEdge  = y - g->TopEdge - 6;
    if(NOT which)
        grel(MainWindow,g);
    add_no();
    refresh();
}

/*
 * modify a gadget or window/requester text
 */
VOID modify(which)
    USHORT which;
{
    struct Gadget *g;
    ULONG pos;

    if(NOT which)
    {   if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
        if(NOT is_gadget()) return;
        sst("PICK GADGET TO MODIFY TEXT....");
        if(NOT(g = wait_for_gadget(MainWindow))) return;
    }
    else g = &TextGadget;

    if(NOT g->GadgetText)
    {   if(NOT which) Error("Gadget has no text(s) to modify !");
        else if(which == 1) Error("Window has no text(s) to modify !");
        else Error("Requester has no text(s) to modify !");
        return;
    }
    Saved = FALSE;
    rem_no();
    text_select(g,2,which);
    add_no();
    refresh();
}

/*
 * delete a gadget or window/requester text
 */
VOID text_delete(which)
    USHORT which;
{
    struct Gadget *g;
    ULONG pos;

    if(NOT which)
    {   if(Gadgets.TailPred == (struct MyGadget *)&Gadgets) return;
        if(NOT is_gadget()) return;
        sst("PICK GADGET TO DELETE TEXT....");
        if(NOT(g = wait_for_gadget(MainWindow))) return;
    }
    else g = &TextGadget;
    if(NOT g->GadgetText)
    {   if(NOT which) Error("Gadget has no text(s) to delete !");
        else if(which == 1) Error("Window has no text(s) to delete !");
        else Error("Requester has no text(s) to delete !");
        return;
    }
    Saved = FALSE;
    rem_no();
    text_select(g,3,which);
    if(NOT which)
    add_no();
    refresh();
}
