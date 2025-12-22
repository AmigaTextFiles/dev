/*----------------------------------------------------------------------*
   gensrc.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author : Jan van den Baard
   Purpose: What it's all about, the writing of C or Assembler source
 *----------------------------------------------------------------------*/

extern struct GadgetList     Gadgets;
extern struct Window        *MainWindow;
extern struct Screen        *MainScreen;
extern struct ge_prefs       prefs;
extern struct Gadget         TextGadget;
extern struct FileRequester *IODir;
extern BOOL                  REQUESTER, WBSCREEN;
extern UBYTE                 name[256], wdt[80], wlb[MAXLABEL];
extern ULONG                 WindowFlags, IDCMPFlags;
extern USHORT                BackFill, GadgetCount, WDBackFill;

BOOL   GenASM, HaveGad, MultyB;

struct GadgetList Borders;

/*
 * split up the normal and 'BORDERONLY' gadgets in seperate lists
 */
static VOID split()
{
    register struct MyGadget *tmp;
    register BCount = 0;

    NewList((void *)&Borders);

    if(!Gadgets.Head->Succ) return;

    while(1)
    {   tmp = Gadgets.Head;
        while(1)
        {   if(TestBits((ULONG)tmp->SpecialFlags,BORDERONLY)) break;
            if(!Gadgets.Head->Succ) return;
            if((tmp = tmp->Succ) == (struct MyGadget *)&Gadgets.Tail) return;
        }
        Remove((void *)tmp);
        AddHead((void *)&Borders,(void *)tmp);
    }
}

/*
 * join the normal and 'BORDERONLY' gadgets again
 */
static VOID join()
{
    register struct MyGadget *tmp;

    while((tmp = (struct MyGadget *)RemHead((void *)&Borders)))
         AddTail((void *)&Gadgets,(void *)tmp);
}

/*
 * write the IDCMPFlags
 */
static VOID WriteIFlags(file)
    BPTR file;
{
    if(NOT IDCMPFlags)
    {   if(GenASM)
            WriteFormat(file,"0");
        else
            WriteFormat(file,"NULL");
        return;
    }
    if(TestBits(IDCMPFlags,SIZEVERIFY))
       WriteFormat(file,"SIZEVERIFY+");
    if(TestBits(IDCMPFlags,NEWSIZE))
       WriteFormat(file,"NEWSIZE+");
    if(TestBits(IDCMPFlags,REFRESHWINDOW))
       WriteFormat(file,"REFRESHWINDOW+");
    if(TestBits(IDCMPFlags,ACTIVEWINDOW))
       WriteFormat(file,"ACTIVEWINDOW+");
    if(TestBits(IDCMPFlags,INACTIVEWINDOW))
       WriteFormat(file,"INACTIVEWINDOW+");
    if(TestBits(IDCMPFlags,GADGETDOWN))
       WriteFormat(file,"GADGETDOWN+");
    if(TestBits(IDCMPFlags,GADGETUP))
       WriteFormat(file,"GADGETUP+");
    if(TestBits(IDCMPFlags,CLOSEWINDOW))
       WriteFormat(file,"CLOSEWINDOW+");
    if(TestBits(IDCMPFlags,REQSET))
       WriteFormat(file,"REQSET+");
    if(TestBits(IDCMPFlags,REQCLEAR))
       WriteFormat(file,"REQCLEAR+");
    if(TestBits(IDCMPFlags,REQVERIFY))
       WriteFormat(file,"REQVERIFY+");
    if(TestBits(IDCMPFlags,MENUPICK))
       WriteFormat(file,"MENUPICK+");
    if(TestBits(IDCMPFlags,MENUVERIFY))
       WriteFormat(file,"MENUVERIFY+");
    if(TestBits(IDCMPFlags,MOUSEBUTTONS))
       WriteFormat(file,"MOUSEBUTTONS+");
    if(TestBits(IDCMPFlags,MOUSEMOVE))
       WriteFormat(file,"MOUSEMOVE+");
    if(TestBits(IDCMPFlags,DELTAMOVE))
       WriteFormat(file,"DELTAMOVE+");
    if(TestBits(IDCMPFlags,INTUITICKS))
       WriteFormat(file,"INTUITICKS+");
    if(TestBits(IDCMPFlags,NEWPREFS))
       WriteFormat(file,"NEWPREFS+");
    if(TestBits(IDCMPFlags,DISKINSERTED))
       WriteFormat(file,"DISKINSERTED+");
    if(TestBits(IDCMPFlags,DISKREMOVED))
       WriteFormat(file,"DISKREMOVED+");
    if(TestBits(IDCMPFlags,RAWKEY))
       WriteFormat(file,"RAWKEY+");
    if(TestBits(IDCMPFlags,VANILLAKEY))
       WriteFormat(file,"VANILLAKEY+");
    if(TestBits(IDCMPFlags,WBENCHMESSAGE))
       WriteFormat(file,"WBENCHMESSAGE+");
    if(TestBits(IDCMPFlags,LONELYMESSAGE))
       WriteFormat(file,"LONELYMESSAGE+");
    Seek(file,-1,OFFSET_CURRENT);
}

/*
 * write the window flags
 */
static VOID WriteWFlags(file)
    BPTR file;
{
    if(NOT WindowFlags)
    {   if(GenASM)
            WriteFormat(file,"0");
        else
            WriteFormat(file,"NULL");
        return;
    }
    if(TestBits(WindowFlags,WINDOWSIZING))
      WriteFormat(file,"WINDOWSIZING+");
    if(TestBits(WindowFlags,WINDOWDRAG))
      WriteFormat(file,"WINDOWDRAG+");
    if(TestBits(WindowFlags,WINDOWDEPTH))
      WriteFormat(file,"WINDOWDEPTH+");
    if(TestBits(WindowFlags,WINDOWCLOSE))
      WriteFormat(file,"WINDOWCLOSE+");
    if(TestBits(WindowFlags,SIZEBRIGHT))
      WriteFormat(file,"SIZEBRIGHT+");
    if(TestBits(WindowFlags,SIZEBBOTTOM))
      WriteFormat(file,"SIZEBBOTTOM+");
    if(TestBits(WindowFlags,NOCAREREFRESH))
      WriteFormat(file,"NOCAREREFRESH+");
    if(TestBits(WindowFlags,SIMPLE_REFRESH))
      WriteFormat(file,"SIMPLE_REFRESH+");
    if(TestBits(WindowFlags,SMART_REFRESH))
      WriteFormat(file,"SMART_REFRESH+");
    if(TestBits(WindowFlags,SUPER_BITMAP))
      WriteFormat(file,"SUPER_BITMAP+");
    if(TestBits(WindowFlags,BACKDROP))
      WriteFormat(file,"BACKDROP+");
    if(TestBits(WindowFlags,GIMMEZEROZERO))
      WriteFormat(file,"GIMMEZEROZERO+");
    if(TestBits(WindowFlags,BORDERLESS))
      WriteFormat(file,"BORDERLESS+");
    if(TestBits(WindowFlags,ACTIVATE))
      WriteFormat(file,"ACTIVATE+");
    if(TestBits(WindowFlags,REPORTMOUSE))
      WriteFormat(file,"REPORTMOUSE+");
    if(TestBits(WindowFlags,RMBTRAP))
      WriteFormat(file,"RMBTRAP+");
    Seek(file,-1,OFFSET_CURRENT);
}

/*
 * write the gadget flags
 */
static VOID WriteFlags(file,gad)
    BPTR            file;
    struct MyGadget *gad;
{
    struct Gadget *gadget;
    ULONG   flags;

    gadget = &gad->Gadget;
    flags   = (ULONG)gadget->Flags;

    if(NOT flags)
    {   WriteFormat(file,"GADGHCOMP");
        return;
    }
    if((TestBits(flags,GADGHIMAGE)) AND (TestBits(flags,GADGHBOX)))
      WriteFormat(file,"GADGHNONE+");
    else if(TestBits(flags,GADGHIMAGE))
      WriteFormat(file,"GADGHIMAGE+");
    else if(TestBits(flags,GADGHBOX))
      WriteFormat(file,"GADGHBOX+");
    else WriteFormat(file,"GADGHCOMP+");
    if(TestBits(flags,GRELBOTTOM))
      WriteFormat(file,"GRELBOTTOM+");
    if(TestBits(flags,GRELRIGHT))
      WriteFormat(file,"GRELRIGHT+");
    if(TestBits(flags,GRELWIDTH))
      WriteFormat(file,"GRELWIDTH+");
    if(TestBits(flags,GRELHEIGHT))
      WriteFormat(file,"GRELHEIGHT+");
    if(TestBits(flags,GADGIMAGE))
      WriteFormat(file,"GADGIMAGE+");
    if(TestBits(flags,SELECTED))
      WriteFormat(file,"SELECTED+");
    if(TestBits((ULONG)gad->SpecialFlags,GADGETOFF))
      WriteFormat(file,"GADGDISABLED+");
    Seek(file,-1,OFFSET_CURRENT);
}

/*
 * write the activation gadget flags
 */
static VOID WriteActivation(file,gad)
    BPTR            file;
    struct MyGadget *gad;
{
    struct Gadget   *gadget;
    ULONG  act;

    gadget = &gad->Gadget;
    act    = (ULONG)gadget->Activation;

    if(TestBits(act,TOGGLESELECT))
      WriteFormat(file,"TOGGLESELECT+");
    if(NOT TestBits(gad->SpecialFlags,NOSIGNAL))
    {   if(TestBits(act,RELVERIFY))
          WriteFormat(file,"RELVERIFY+");
        if(TestBits(act,GADGIMMEDIATE))
          WriteFormat(file,"GADGIMMEDIATE+");
    }
    if(TestBits(act,RIGHTBORDER))
      WriteFormat(file,"RIGHTBORDER+");
    if(TestBits(act,LEFTBORDER))
      WriteFormat(file,"LEFTBORDER+");
    if(TestBits(act,TOPBORDER))
      WriteFormat(file,"TOPBORDER+");
    if(TestBits(act,BOTTOMBORDER))
      WriteFormat(file,"BOTTOMBORDER+");
    if(TestBits(act,STRINGCENTER))
      WriteFormat(file,"STRINGCENTER+");
    if(TestBits(act,STRINGRIGHT))
      WriteFormat(file,"STRINGRIGHT+");
    if(TestBits(act,LONGINT))
      WriteFormat(file,"LONGINT+");
    if(TestBits(act,ALTKEYMAP))
      WriteFormat(file,"ALTKEYMAP+");
    if(TestBits(act,BOOLEXTEND))
      WriteFormat(file,"BOOLEXTEND+");
    if(TestBits(act,ENDGADGET))
      WriteFormat(file,"ENDGADGET+");
    if(TestBits(act,FOLLOWMOUSE))
      WriteFormat(file,"FOLLOWMOUSE+");
    Seek(file,-1,OFFSET_CURRENT);
}

/*
 * write the gadget type
 */
static VOID WriteType(file,gad)
    BPTR            file;
    struct MyGadget *gad;
{
    struct Gadget   *gadget;
    ULONG   type;

    gadget = &gad->Gadget;
    type   = (ULONG)gadget->GadgetType;

    if(TestBits(type,PROPGADGET))
      WriteFormat(file,"PROPGADGET+");
    else if(TestBits(type,STRGADGET))
      WriteFormat(file,"STRGADGET+");
    else if(TestBits(type,BOOLGADGET))
      WriteFormat(file,"BOOLGADGET+");
    if(TestBits((ULONG)gad->SpecialFlags,GZZGADGET))
      WriteFormat(file,"GZZGADGET+");
    if(REQUESTER)
      WriteFormat(file,"REQGADGET+");
    Seek(file,-1,OFFSET_CURRENT);
}

/*
 * write the draw modes
 */
static VOID WriteDrMd(file,drmd,mode)
    BPTR file;
    ULONG drmd;
    BOOL  mode; /* TRUE = Asm, FALSE = C */
{
    if(TestBits(drmd,JAM2))
    {   if(mode) WriteFormat(file,"RP_JAM2+");
        else     WriteFormat(file,"JAM2+");
    }
    else if(TestBits(drmd,JAM1))
    {   if(mode) WriteFormat(file,"RP_JAM1+");
        else     WriteFormat(file,"JAM1+");
    }
    if(TestBits(drmd,COMPLEMENT))
    if(mode) WriteFormat(file,"RP_COMPLEMENT+");
    else     WriteFormat(file,"COMPLEMENT+");
    if(TestBits(drmd,INVERSVID))
    if(mode) WriteFormat(file,"RP_INVERSVID+");
    else     WriteFormat(file,"INVERSVID+");
    Seek(file,-1,OFFSET_CURRENT);
}

/*
 * write the propinfo flags
 */
static VOID WritePFlags(file,info)
    BPTR            file;
    struct PropInfo *info;
{
    ULONG flags;

    flags = (ULONG)info->Flags;

    if(TestBits(flags,AUTOKNOB))
     WriteFormat(file,"AUTOKNOB+");
    if(TestBits(flags,FREEHORIZ))
     WriteFormat(file,"FREEHORIZ+");
    if(TestBits(flags,FREEVERT))
     WriteFormat(file,"FREEVERT+");
    if(TestBits(flags,PROPBORDERLESS))
     WriteFormat(file,"PROPBORDERLESS+");
    Seek(file,-1,OFFSET_CURRENT);
}

#define RAWINC  prefs.no_flags

/*
 * write the assembler border structure
 */
static VOID WriteAsmBorder(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct Border *border;
    SHORT         *XY;
    COUNT    i,x=0;

    border = (struct Border *)gadget->Gadget.GadgetRender;
    XY     = border->XY;

    while(1)
    {
        WriteFormat(file,"%s_pairs%ld:\n    DC.W    ",&gadget->GadgetLabel,x);
        for(i=0;i<(border->Count << 1);i++) WriteFormat(file,"%ld,",XY[i]);
        Seek(file,-1,OFFSET_CURRENT);
        WriteFormat(file,"\n\n");
        WriteFormat(file,"%s_bord%ld:\n",&gadget->GadgetLabel,x);
        WriteFormat(file,"    DC.W    %ld,%ld\n",border->LeftEdge,border->TopEdge);
        WriteFormat(file,"    DC.B    %ld,%ld\n",border->FrontPen,border->BackPen);
        WriteFormat(file,"    DC.B    ");
        if(RAWINC)
            WriteFormat(file,"$%02lx",border->DrawMode);
        else
            WriteDrMd(file,(ULONG)border->DrawMode,TRUE);
        WriteFormat(file,"\n    DC.B    %ld\n",border->Count);
        WriteFormat(file,"    DC.L    %s_pairs%ld\n",&gadget->GadgetLabel,x++);
        if(border = border->NextBorder)
        {   WriteFormat(file,"    DC.L    %s_bord%ld\n\n",&gadget->GadgetLabel,x);
            XY = border->XY;
        }
        else
        {   WriteFormat(file,"    DC.L    0\n\n");
            break;
        }
    }
}

/*
 * write the assembler image
 */
static VOID WriteAsmImage(file,gadget,which)
    BPTR            file;
    struct MyGadget *gadget;
    UBYTE           which;
{
    struct Image    *image;
    register USHORT *data;
    register COUNT  i,ii;
    ULONG           data_size;

    if(which == RENDER) image = (struct Image *)gadget->Gadget.GadgetRender;
    else                image = (struct Image *)gadget->Gadget.SelectRender;
    data  = image->ImageData;

    if(which != STDPRP)
    {   if(which == SELECT)
          WriteFormat(file,"%s_hdata:\n",gadget->GadgetLabel);
        else
          WriteFormat(file,"%s_data:\n",gadget->GadgetLabel);
        data_size = (RASSIZE(image->Width,image->Height) * image->Depth);
        for(i=0;i<(data_size >> 1);i+=8)
        {   WriteFormat(file,"    DC.W    ");
            for(ii=0;ii<8;ii++)
            {   if(i+ii < (data_size >> 1)) WriteFormat(file,"$%04lx,",data[i+ii]);
            }
            Seek(file,-1,OFFSET_CURRENT);
            WriteFormat(file,"\n");
        }
        WriteFormat(file,"\n");
    }
    if(which == SELECT)
      WriteFormat(file,"%s_himage:\n",&gadget->GadgetLabel);
    else
      WriteFormat(file,"%s_image:\n",&gadget->GadgetLabel);
    WriteFormat(file,"    DC.W    %ld,%ld\n",image->LeftEdge,image->TopEdge);
    WriteFormat(file,"    DC.W    %ld,%ld\n",image->Width,image->Height);
    WriteFormat(file,"    DC.W    %ld\n",image->Depth);
    if(which != STDPRP)
    {   if(which == SELECT)
          WriteFormat(file,"    DC.L    %s_hdata\n",&gadget->GadgetLabel);
        else
          WriteFormat(file,"    DC.L    %s_data\n",&gadget->GadgetLabel);
    }
    else WriteFormat(file,"    DC.L    0\n");
    WriteFormat(file,"    DC.B    $%02lx\n",image->PlanePick);
    WriteFormat(file,"    DC.B    $%02lx\n",image->PlaneOnOff);
    WriteFormat(file,"    DC.L    0\n\n");
}

/*
 * write the assembler prop info structure
 */
static VOID WriteAsmPinfo(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct PropInfo *info;

    info = (struct PropInfo *)gadget->Gadget.SpecialInfo;
    WriteFormat(file,"%s_info:\n",&gadget->GadgetLabel);
    WriteFormat(file,"    DC.W    ");
    if(RAWINC)
        WriteFormat(file,"$%04lx",info->Flags);
    else
        WritePFlags(file,info);
    WriteFormat(file,"\n    DC.W    $%04lx\n",info->HorizPot);
    WriteFormat(file,"    DC.W    $%04lx\n",info->VertPot);
    WriteFormat(file,"    DC.W    $%04lx\n",info->HorizBody);
    WriteFormat(file,"    DC.W    $%04lx\n",info->VertBody);
    WriteFormat(file,"    DC.W    0,0,0,0,0,0\n\n");
}

/*
 * write the assembler string info structure
 */
static VOID WriteAsmSinfo(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct StringInfo *info;

    info = (struct StringInfo *)gadget->Gadget.SpecialInfo;
    WriteFormat(file,"%s_info:\n",&gadget->GadgetLabel);
    WriteFormat(file,"    DC.L    %s_buf\n",&gadget->GadgetLabel);
    if(info->UndoBuffer)
       WriteFormat(file,"    DC.L    %s_ubuf\n",&gadget->GadgetLabel);
    else
       WriteFormat(file,"    DC.L    0\n");
    WriteFormat(file,"    DC.W    0,%ld\n",info->MaxChars);
    WriteFormat(file,"    DC.W    0,0,0,0,0,0\n");
    WriteFormat(file,"    DC.L    0,0,0\n\n");
    WriteFormat(file,"%s_buf:\n",&gadget->GadgetLabel);
    if(strlen(info->Buffer))
    {
        WriteFormat(file,"    DC.B    '%s',0\n",info->Buffer);
        WriteFormat(file,"    DCB.B   %ld,0\n",info->MaxChars - strlen((char *)info->Buffer) -1);
    }
    else
        WriteFormat(file,"    DCB.B   %ld\n",info->MaxChars);
    WriteFormat(file,"    CNOP    0,2\n\n");
    if(info->UndoBuffer)
    {   WriteFormat(file,"%s_ubuf:\n    DCB.B    %ld,0\n",&gadget->GadgetLabel,info->MaxChars);
        WriteFormat(file,"    CNOP    0,2\n\n");
    }
}

/*
 * write the assembler gadget structure
 */
static VOID WriteAsmGadget(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct Gadget   *gad;
    struct MyGadget *next;

    gad = &gadget->Gadget;

    WriteFormat(file,"%s_ID   EQU     %ld\n\n",&gadget->GadgetLabel,gad->GadgetID);

    WriteFormat(file,"%s:\n",&gadget->GadgetLabel);
    if(gadget == Gadgets.Head)
    {   if((TextGadget.GadgetText) OR
           (Borders.TailPred != (struct MyGadget *)&Borders))
        {   if(NOT REQUESTER) WriteFormat(file,"    DC.L    Render\n");
            else WriteFormat(file,"    DC.L    0\n");
        }
        else WriteFormat(file,"    DC.L    0\n");
    }
    else
       WriteFormat(file,"    DC.L    %s\n",&(gadget->Pred->GadgetLabel));
    WriteFormat(file,"    DC.W    %ld,%ld\n",gad->LeftEdge,gad->TopEdge);
    WriteFormat(file,"    DC.W    %ld,%ld\n",gad->Width,gad->Height);
    WriteFormat(file,"    DC.W    ");
    if(RAWINC)
        WriteFormat(file,"$%04lx",gad->Flags);
    else
        WriteFlags(file,gadget);
    WriteFormat(file,"\n    DC.W    ");
    if(RAWINC)
        WriteFormat(file,"$%04lx",gad->Activation);
    else
        WriteActivation(file,gadget);
    WriteFormat(file,"\n    DC.W    ");
    if(RAWINC)
        WriteFormat(file,"$%04lx",gad->GadgetType);
    else
        WriteType(file,gadget);

    if((TestBits((ULONG)gad->Flags,GADGIMAGE)) ||
       (TestBits((ULONG)gad->GadgetType,PROPGADGET)))
      WriteFormat(file,"\n    DC.L    %s_image\n",&gadget->GadgetLabel);
    else if(NOT TestBits((ULONG)gadget->SpecialFlags,NOBORDER))
      WriteFormat(file,"\n    DC.L    %s_bord0\n",&gadget->GadgetLabel);
    else
      WriteFormat(file,"\n    DC.L    0\n");
    if((TestBits((ULONG)gad->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gad->Flags,GADGHBOX)))
      WriteFormat(file,"    DC.L    %s_himage\n",&gadget->GadgetLabel);
    else
      WriteFormat(file,"    DC.L    0\n");
    if(gad->GadgetText)
      WriteFormat(file,"    DC.L    %s_text0,0\n",&gadget->GadgetLabel);
    else
      WriteFormat(file,"    DC.L    0,0\n");
    if(gad->SpecialInfo)
      WriteFormat(file,"    DC.L    %s_info\n",&gadget->GadgetLabel);
    else
      WriteFormat(file,"    DC.L    0\n");
    WriteFormat(file,"    DC.W    %s_ID\n    DC.L    0\n\n",&gadget->GadgetLabel);
}

/*
 * write the assembler IntuitText structures
 */
static VOID WriteAsmTexts(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    register struct IntuiText *itext;
    COUNT    i=0;

    if((itext = gadget->Gadget.GadgetText))
    {   WriteFormat(file,"%s_text%ld:\n",&gadget->GadgetLabel,i);
        while(1)
        {   WriteFormat(file,"    DC.B    %ld,%ld\n",itext->FrontPen,itext->BackPen);
            WriteFormat(file,"    DC.B    ");
            if(RAWINC)
                WriteFormat(file,"$%02lx",itext->DrawMode);
            else
                WriteDrMd(file,itext->DrawMode,TRUE);
            WriteFormat(file,"\n    DC.W    %ld,%ld\n",itext->LeftEdge,itext->TopEdge);
            WriteFormat(file,"    DC.L    0\n");
            WriteFormat(file,"    DC.L    %s_itext%ld\n",&gadget->GadgetLabel,i);
            if(itext->NextText)
              WriteFormat(file,"    DC.L    %s_text%ld\n\n",&gadget->GadgetLabel,i+1);
            else
              WriteFormat(file,"    DC.L    0\n\n");
            WriteFormat(file,"%s_itext%ld:\n",&gadget->GadgetLabel,i++);
            WriteFormat(file,"    DC.B    '%s',0\n",itext->IText);
            WriteFormat(file,"    CNOP    0,2\n\n");
            if(!(itext = itext->NextText)) break;
            WriteFormat(file,"%s_text%ld\n",&gadget->GadgetLabel,i);
        }
    }
}

/*
 * write the assembler new screen structure
 */
static VOID WriteAsmScreen(file)
    BPTR file;
{
    WriteFormat(file,"ns:\n");
    WriteFormat(file,"    DC.W    0,0,%ld,%ld\n",MainScreen->Width,MainScreen->Height);
    WriteFormat(file,"    DC.W    %ld\n",MainScreen->BitMap.Depth);
    WriteFormat(file,"    DC.B    -1,-1\n");
    if(MainScreen->BitMap.Depth == 5) WriteFormat(file,"    DC.W    0\n");
    else
    {   if(RAWINC)
            WriteFormat(file,"    DC.W    $8000\n");
        else
            WriteFormat(file,"    DC.W    V_HIRES\n");
    }
    if(RAWINC)
        WriteFormat(file,"    DC.W    $0001\n");
    else
        WriteFormat(file,"    DC.W    CUSTOMSCREEN\n");
    WriteFormat(file,"    DC.L    0,0,0,0\n\n");
}

/*
 * write the assembler window/requester structure
 */
static VOID WriteAsmRW(file)
    BPTR file;
{
    if(REQUESTER)
    {   WriteFormat(file,"requester:\n    DC.L    0\n");
        WriteFormat(file,"    DC.W    %ld,%ld,",(MainWindow->LeftEdge + MainWindow->BorderLeft),
                                                (MainWindow->TopEdge + MainWindow->BorderTop));
        WriteFormat(file,"%ld,%ld\n",MainWindow->GZZWidth,MainWindow->GZZHeight);
        if(GadgetCount)
            WriteFormat(file,"    DC.W    0,0\n    DC.L    %s,",&Gadgets.TailPred->GadgetLabel);
        else
            WriteFormat(file,"    DC.W    0,0\n    DC.L    0");
        if(Borders.TailPred != (struct MyGadget *)&Borders)
          WriteFormat(file,"Border0_bord0\n");
        else
          WriteFormat(file,"0\n");
        if(TextGadget.GadgetText) WriteFormat(file,"    DC.L    Render_text0\n");
        else WriteFormat(file,"    DC.L    0\n");
        WriteFormat(file,"    DC.W    0\n    DC.B    %ld\n",BackFill);
        WriteFormat(file,"    DC.L    0\n    DCB.B   32,0\n    DC.L    0,0\n    DCB.B    36,0\n\n");
    }
    else
    {   WriteFormat(file,"%s:\n",&wlb);
        WriteFormat(file,"    DC.W    %ld,%ld,%ld,%ld\n",MainWindow->LeftEdge,MainWindow->TopEdge,
                                                         MainWindow->Width,MainWindow->Height);
        WriteFormat(file,"    DC.B    %ld,%ld\n",MainWindow->DetailPen,MainWindow->BlockPen);
        WriteFormat(file,"    DC.L    ");
        if(RAWINC)
            WriteFormat(file,"$%08lx",IDCMPFlags);
        else
            WriteIFlags(file);
        WriteFormat(file,"\n    DC.L    ");
        if(RAWINC)
            WriteFormat(file,"$%08lx",WindowFlags);
        else
            WriteWFlags(file);
        WriteFormat(file,"\n");
        if(HaveGad)
            WriteFormat(file,"    DC.L    %s,0\n",Gadgets.TailPred->GadgetLabel);
        else if(Borders.TailPred != (struct MyGadget *)&Borders)
            WriteFormat(file,"    DC.L    Render,0\n");
        else
            WriteFormat(file,"    DC.L    0,0\n");
        if(strlen((char *)&wdt))
            WriteFormat(file,"    DC.L    %s_title\n",&wlb);
        else
            WriteFormat(file,"    DC.L    0\n");
        WriteFormat(file,"    DC.L    0,0\n");
        WriteFormat(file,"    DC.W    %ld,%ld,%ld,%ld,",MainWindow->MinWidth,
                                                        MainWindow->MinHeight,
                                                        MainWindow->MaxWidth,
                                                        MainWindow->MaxHeight);
        if(WBSCREEN)
        {   if(RAWINC)
                WriteFormat(file,"$0001\n\n");
            else
                WriteFormat(file,"WBENCHSCREEN\n\n");
        }
        else
        {   if(RAWINC)
                WriteFormat(file,"$000F\n\n");
            else
                WriteFormat(file,"CUSTOMSCREEN\n\n");
        }
        if(strlen((char *)&wdt))
            WriteFormat(file,"%s_title:\n    DC.B    '%s',0\n    CNOP    0,2\n\n",&wlb,&wdt);
    }
}

/*
 * write the assembler window/requester texts
 */
static VOID WriteAsmWDT(file)
    BPTR file;
{
    register struct IntuiText *t, *t1;
    register UCOUNT i = 0;

    if(NOT TextGadget.GadgetText) return;

    t = t1 = TextGadget.GadgetText;
    WriteFormat(file,"Render_text%ld:\n",i);
    while(1)
    {   WriteFormat(file,"    DC.B    %ld,%ld\n",t->FrontPen,t->BackPen);
        WriteFormat(file,"    DC.B    ");
        if(RAWINC)
            WriteFormat(file,"$%02lx",t->DrawMode);
        else
            WriteDrMd(file,t->DrawMode);
        WriteFormat(file,"\n    DC.W    %ld,%ld\n",t->LeftEdge,t->TopEdge);
        WriteFormat(file,"    DC.L    0\n");
        WriteFormat(file,"    DC.L    Render_itext%ld\n",i);
        if(t->NextText)
          WriteFormat(file,"    DC.L    Render_text%ld\n\n",i+1);
        else
          WriteFormat(file,"    DC.L    0\n\n");
        WriteFormat(file,"Render_itext%ld:\n",i++);
        WriteFormat(file,"    DC.B    '%s',0\n",t->IText);
        WriteFormat(file,"    CNOP    0,2\n\n");
        if(!(t = t->NextText)) break;
        WriteFormat(file,"Render_text%ld\n",i);
    }
}

/*
 * write assembler special render gadget
 */
static VOID WriteAsmCRG(file)
    BPTR file;
{
    if((TextGadget.GadgetText) OR
       (Borders.TailPred != (struct MyGadget *)&Borders))
    {   if(NOT REQUESTER)
        {   WriteFormat(file,"Render:\n");
           if(RAWINC)
            WriteFormat(file,"    DC.L    0\n    DC.W    0,0,1,1,$0003,0,$0001\n");
           else
            WriteFormat(file,"    DC.L    0\n    DC.W    0,0,1,1,GADGHNONE,0,BOOLGADGET\n");
           if(Borders.TailPred != (struct MyGadget *)&Borders)
             WriteFormat(file,"    DC.L    Border0_bord0,");
           else
             WriteFormat(file,"    DC.L    0,");
           if(TextGadget.GadgetText)
             WriteFormat(file,"0,Render_text0,");
           else
             WriteFormat(file,"0,0,");
             WriteFormat(file,"0,0\n    DC.W    0\n    DC.L    0\n\n");
       }
    }
}

/*
 * write the assembler border structures
 */
static VOID WriteAsmB(file)
    BPTR file;
{
    register struct MyGadget *g;
    register struct Border   *b;
    register SHORT           *xy;
    register UCOUNT           bc = 0,xyc;

    if(Borders.TailPred == (struct MyGadget *)&Borders) return;

    g = Borders.Head;

    while(1)
    {
        b = (struct Border *)g->Gadget.GadgetRender;
        while(1)
        {   xy = b->XY;
            WriteFormat(file,"Border%ld_pairs%ld:\n    DC.W   ",bc,bc);
            for(xyc = 0;xyc < (b->Count << 1);xyc++) WriteFormat(file,"%ld,",xy[xyc]);
            Seek(file,-1,OFFSET_CURRENT);
            WriteFormat(file,"\n");
            bc++;
            if(!(b = b->NextBorder)) break;
        }
        if((g = g->Succ) == (struct MyGadget *)&Borders.Tail) break;
    }
    WriteFormat(file,"\n");

    bc = 0;
    g = Borders.Head;
    while(1)
    {   b = (struct Border *)g->Gadget.GadgetRender;
        while(1)
        {   WriteFormat(file,"Border%ld_bord%ld:\n",bc,bc);
            WriteFormat(file,"    DC.W    %ld,%ld\n",g->Gadget.LeftEdge,g->Gadget.TopEdge);
            if(RAWINC)
                WriteFormat(file,"    DC.B    %ld,0\n    DC.B    $00,%ld\n",b->FrontPen,b->Count);
            else
                WriteFormat(file,"    DC.B    %ld,0\n    DC.B    RP_JAM1,%ld\n",b->FrontPen,b->Count);
            WriteFormat(file,"    DC.L    Border%ld_pairs%ld,",bc,bc);
            bc++;
            if(!(b = b->NextBorder))
            {   if(g->Succ == (struct MyGadget *)&Borders.Tail)
                    WriteFormat(file,"0\n\n");
                else
                    WriteFormat(file,"Border%ld_bord%ld\n\n",bc,bc);
                break;
            }
            else
                WriteFormat(file,"Border%ld_bord%ld\n\n",bc,bc);
        }
        if((g = g->Succ) == (struct MyGadget *)&Borders.Tail)
            break;
    }
}

/*
 * write the assembler source code
 */
VOID WriteAsmGadgets()
{
    BPTR                      file;
    register struct MyGadget *gadget;
    struct ColorMap          *cm;
    COUNT                     i,ii;
    USHORT                   *tab,cc;
    ULONG                     rc,hg;
    char                     *str;

    GenASM = TRUE;
    HaveGad = is_gadget();

    strcpy((char *)IODir->fr_HeadLine,"Save Asm Source");
    IODir->fr_Screen  = MainScreen;
    IODir->fr_Caller  = MainWindow;
    IODir->fr_Flags  |= FR_NoInfo;
    rc = FileRequest(IODir);
    strcpy((char *)&name,(char *)IODir->fr_DirName);
    strcat((char *)&name,(char *)IODir->fr_FileName);

    if(rc == FREQ_CANCELED) return;
    else if(rc)
    {   Error("FileRequester won't open !");
        return;
    }
    cm = MainScreen->ViewPort.ColorMap;
    tab = (USHORT *)cm->ColorTable;
    if(!(file = Open((char *)&name,MODE_NEWFILE)))
    {  Error("Can't Open Write File !");
       return;
    }
    SetWindowTitles(MainWindow,(char *)-1L,(char *)"Saving Assembler Source.....");
    buisy();
    disable_window();
    un_gzz();
    cc = (1 << MainScreen->BitMap.Depth);
    WriteFormat(file,"*---------------------------------------------------\n");
    WriteFormat(file,"* Gadgets created with GadgetEd V2.3\n");
    WriteFormat(file,"* which is (c) Copyright 1990-91 by Jaba Development\n");
    WriteFormat(file,"* written by Jan van den Baard\n");
    WriteFormat(file,"*---------------------------------------------------\n\n");
    if(NOT WBSCREEN)
    {   WriteFormat(file,"Colors:\n");
        for(ii=0;ii<cc;ii+=8)
        {   WriteFormat(file,"    DC.W    ");
            for(i=0;i<8;i++)
              if((ii+i) < cc) WriteFormat(file,"$%04lx,",tab[ii+i]);
            Seek(file,-1,OFFSET_CURRENT);
            WriteFormat(file,"\n");
        }
        WriteFormat(file,"\n");
    }
    split();
    WriteAsmB(file);
    WriteAsmWDT(file);
    WriteAsmCRG(file);
    if(HaveGad)
    {   for(gadget = Gadgets.Head;gadget->Succ;gadget = gadget->Succ)
        {   if(TestBits((ULONG)gadget->Gadget.GadgetType,PROPGADGET))
            {   WriteAsmPinfo(file,gadget);
                if(NOT TestBits((ULONG)gadget->Gadget.Flags,GADGIMAGE))
                    WriteAsmImage(file,gadget,STDPRP);
            }
            if(TestBits((ULONG)gadget->Gadget.GadgetType,STRGADGET))
                WriteAsmSinfo(file,gadget);
            if((NOT TestBits((ULONG)gadget->Gadget.Flags,GADGIMAGE)) AND
               (NOT TestBits((ULONG)gadget->Gadget.GadgetType,PROPGADGET)) AND
               (NOT TestBits((ULONG)gadget->SpecialFlags,NOBORDER)))
                WriteAsmBorder(file,gadget);
            if(TestBits((ULONG)gadget->Gadget.Flags,GADGIMAGE))
                WriteAsmImage(file,gadget,RENDER);
            if((TestBits((ULONG)gadget->Gadget.Flags,GADGHIMAGE)) AND
               (NOT TestBits((ULONG)gadget->Gadget.Flags,GADGHBOX)))
                WriteAsmImage(file,gadget,SELECT);
            if(gadget->Gadget.GadgetText)
                WriteAsmTexts(file,gadget);
            WriteAsmGadget(file,gadget);
            if(str = IoErrToStr())
            {   enable_window();
                Close(file);
                Error(str);
                return;
            }
        }
    }
    gadget = Gadgets.TailPred;
    if(NOT WBSCREEN) WriteAsmScreen(file);
    WriteAsmRW(file);
    if(NOT WBSCREEN)  WriteFormat(file,"\nCOLORCOUNT   EQU   %ld",cc);
    if(NOT REQUESTER) { WriteFormat(file,"\nNEWWINDOW:   DC.L   %s",&wlb);
                        WriteFormat(file,"\nWDBACKFILL   EQU    %ld",WDBackFill); }
    else              WriteFormat(file,"\nREQUESTER:   DC.L   requester");
    if(NOT WBSCREEN)  WriteFormat(file,"\nNEWSCREEN:   DC.L   ns");
    if(HaveGad)
        WriteFormat(file,"\nFIRSTGADGET: DC.L   %s",&Gadgets.TailPred->GadgetLabel);
    if(TextGadget.GadgetText)
        WriteFormat(file,"\nFIRSTTEXT:   DC.L   Render_text0");
    if(Borders.TailPred != (struct MyGadget *)&Borders)
        WriteFormat(file,"\nFIRSTBORDER: DC.L   Border0_bord0");
    WriteFormat(file,"\n");
    if(str = IoErrToStr()) Error(str);
    Close(file);
    join();
    do_gzz();
    enable_window();
    ok();
    return;
}

#define STAT    prefs.static_structures

/*
 * write the C border structure
 */
static VOID WriteCBorder(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct Border *border;
    SHORT         *XY;
    COUNT          i,x=0;

    border = (struct Border *)gadget->Gadget.GadgetRender;
    XY     = border->XY;
    while(1)
    {
        if(STAT) WriteFormat(file,"static ");
        WriteFormat(file,"SHORT %s_pairs%ld[] = {\n  ",&gadget->GadgetLabel,x++);
        for(i=0;i<(border->Count << 1);i++) WriteFormat(file,"%ld,",XY[i]);
        Seek(file,-1,OFFSET_CURRENT);
        WriteFormat(file," };\n\n");
        if(NOT(border = border->NextBorder)) break;
        XY = border->XY;
    }
    border = (struct Border *)gadget->Gadget.GadgetRender;
    XY     = border->XY;
    x = 0;
    if(STAT) WriteFormat(file,"static ");
    if(border->NextBorder)
        WriteFormat(file,"struct Border %s_bord[] = {\n",&gadget->GadgetLabel);
    else
        WriteFormat(file,"struct Border %s_bord = {\n",&gadget->GadgetLabel);
    while(1)
    {
        WriteFormat(file,"  %ld,%ld,",border->LeftEdge,border->TopEdge);
        WriteFormat(file,"%ld,%ld,",border->FrontPen,border->BackPen);
        WriteDrMd(file,border->DrawMode,FALSE);
        WriteFormat(file,",%ld,",border->Count);
        WriteFormat(file,"(SHORT *)&%s_pairs%ld,",&gadget->GadgetLabel,x++);
        if(border = border->NextBorder)
            WriteFormat(file,"&%s_bord[%ld],\n",&gadget->GadgetLabel,x);
        else
        {   WriteFormat(file,"NULL };\n\n");
            break;
        }
    }
}

/*
 * write the C image structure
 */
static VOID WriteCImage(file,gadget,which)
    BPTR            file;
    struct MyGadget *gadget;
    UBYTE            which;
{
    struct Image *image;
    register USHORT       *data;
    register COUNT        i,ii;
    ULONG        data_size;

    if(which == RENDER) image = (struct Image *)gadget->Gadget.GadgetRender;
    else image = (struct Image *)gadget->Gadget.SelectRender;
    data  = image->ImageData;
    if(which != STDPRP)
    {   if(STAT) WriteFormat(file,"static ");
        if(which == SELECT)
          WriteFormat(file,"USHORT %s_hdata[] = {\n",gadget->GadgetLabel);
        else
          WriteFormat(file,"USHORT %s_data[] = {\n",gadget->GadgetLabel);
        data_size = (RASSIZE(image->Width,image->Height) * image->Depth);
        for(i=0;i<(data_size >> 1);i+=8)
        {   for(ii=0;ii<8;ii++)
            {   if(i+ii < (data_size >> 1)) WriteFormat(file,"  0x%04lx,",data[i+ii]);
            }
            WriteFormat(file,"\n");
        }
        Seek(file,-2,OFFSET_CURRENT);
        WriteFormat(file," }; \n\n");
    }
    if(STAT) WriteFormat(file,"static ");
    if(which == SELECT)
      WriteFormat(file,"struct Image %s_himage = {\n",&gadget->GadgetLabel);
    else
      WriteFormat(file,"struct Image %s_image = {\n",&gadget->GadgetLabel);
    WriteFormat(file,"  %ld,%ld,",image->LeftEdge,image->TopEdge);
    WriteFormat(file,"%ld,%ld,",image->Width,image->Height);
    WriteFormat(file,"%ld,",image->Depth);
    if(which != STDPRP)
    {   if(which == SELECT)
          WriteFormat(file,"(USHORT *)&%s_hdata,",&gadget->GadgetLabel);
        else
          WriteFormat(file,"(USHORT *)&%s_data,",&gadget->GadgetLabel);
    }
    else
       WriteFormat(file,"NULL,");
    WriteFormat(file,"0x%02lx,",image->PlanePick);
    WriteFormat(file,"0x%02lx,",image->PlaneOnOff);
    WriteFormat(file,"NULL };\n\n");
}

/*
 * write the C PropInfo structure
 */
static VOID WriteCPinfo(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct PropInfo *info;

    info = (struct PropInfo *)gadget->Gadget.SpecialInfo;
    if(STAT) WriteFormat(file,"static ");
    WriteFormat(file,"struct PropInfo %s_info = {\n  ",&gadget->GadgetLabel);
    WritePFlags(file,info);
    WriteFormat(file,",0x%04lx,",info->HorizPot);
    WriteFormat(file,"0x%04lx,",info->VertPot);
    WriteFormat(file,"0x%04lx,",info->HorizBody);
    WriteFormat(file,"0x%04lx,",info->VertBody);
    WriteFormat(file,"0,0,0,0,0,0 };\n\n");
}

/*
 * write the C StringInfo structure
 */
static VOID WriteCSinfo(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct StringInfo *info;

    info = (struct StringInfo *)gadget->Gadget.SpecialInfo;
    if(STAT) WriteFormat(file,"static ");
    if(strlen(info->Buffer))
        WriteFormat(file,"UBYTE %s_buf[%ld] = %lc%s%lc;\n\n",&gadget->GadgetLabel,
                                                             info->MaxChars,'"',
                                                             info->Buffer,'"');
    else
        WriteFormat(file,"UBYTE %s_buf[%ld];\n\n",&gadget->GadgetLabel,info->MaxChars);

    if(info->UndoBuffer)
    {   if(STAT) WriteFormat(file,"static ");
        WriteFormat(file,"UBYTE %s_ubuf[%ld];\n\n",&gadget->GadgetLabel,info->MaxChars);
    }
    if(STAT) WriteFormat(file,"static ");
    WriteFormat(file,"struct StringInfo %s_info = {\n",&gadget->GadgetLabel);
    WriteFormat(file,"  (UBYTE *)&%s_buf,",&gadget->GadgetLabel);
    if(info->UndoBuffer)
       WriteFormat(file,"(UBYTE *)&%s_ubuf,",&gadget->GadgetLabel);
    else
       WriteFormat(file,"NULL,");
    WriteFormat(file,"0,%ld,",info->MaxChars);
    WriteFormat(file,"0,0,0,0,0,0,");
    WriteFormat(file,"NULL,NULL,NULL };\n\n");
}

/*
 * write the C Gadget structure
 */
static VOID WriteCGadget(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    struct Gadget    *gad;
    struct MyGadget  *next;
    struct IntuiText *itext;

    gad = &gadget->Gadget;

    WriteFormat(file,"#define %s_ID    %ld\n\n",&gadget->GadgetLabel,gad->GadgetID);
    if(STAT) WriteFormat(file,"static ");
    WriteFormat(file,"struct Gadget %s = {\n  ",&gadget->GadgetLabel);
    if(gadget == Gadgets.Head)
    {   if(NOT REQUESTER)
        {   if((TextGadget.GadgetText) OR
               (Borders.TailPred != (struct MyGadget *)&Borders)) WriteFormat(file,"&Render,");
            else WriteFormat(file,"NULL,");
        }
        else WriteFormat(file,"NULL,");
    }
    else
       WriteFormat(file,"&%s,",&(gadget->Pred->GadgetLabel));
    WriteFormat(file,"%ld,%ld,",gad->LeftEdge,gad->TopEdge);
    WriteFormat(file,"%ld,%ld,\n  ",gad->Width,gad->Height);
    WriteFlags(file,gadget);
    WriteFormat(file,",\n  ");
    WriteActivation(file,gadget);
    WriteFormat(file,",\n  ");
    WriteType(file,gadget);
    if((TestBits((ULONG)gad->Flags,GADGIMAGE)) ||
       (TestBits((ULONG)gad->GadgetType,PROPGADGET)))
      WriteFormat(file,",\n  (APTR)&%s_image,",&gadget->GadgetLabel);
    else if(NOT TestBits((ULONG)gadget->SpecialFlags,NOBORDER))
    {   if(((struct Border *)gadget->Gadget.GadgetRender)->NextBorder)
            WriteFormat(file,",\n  (APTR)&%s_bord[0],",&gadget->GadgetLabel);
        else
            WriteFormat(file,",\n  (APTR)&%s_bord,",&gadget->GadgetLabel);
    }
    else
      WriteFormat(file,",\n  NULL,");
    if((TestBits((ULONG)gad->Flags,GADGHIMAGE)) AND
       (NOT TestBits((ULONG)gad->Flags,GADGHBOX)))
      WriteFormat(file,"(APTR)&%s_himage,\n  ",&gadget->GadgetLabel);
    else
      WriteFormat(file,"NULL,\n  ");
    if((itext = gad->GadgetText))
    {   if(itext->NextText)
          WriteFormat(file,"&%s_text[0],NULL,",&gadget->GadgetLabel);
        else
          WriteFormat(file,"&%s_text,NULL,",&gadget->GadgetLabel);
    }
    else WriteFormat(file,"NULL,NULL,");
    if(gad->SpecialInfo)
      WriteFormat(file,"(APTR)&%s_info,",&gadget->GadgetLabel);
    else
      WriteFormat(file,"NULL,");
    WriteFormat(file,"%s_ID,NULL };\n\n",&gadget->GadgetLabel);
}

/*
 * write the C IntuiText structures
 */
static VOID WriteCTexts(file,gadget)
    BPTR            file;
    struct MyGadget *gadget;
{
    register struct IntuiText *itext;
    COUNT    i=1;

    if((itext = gadget->Gadget.GadgetText))
    {   if(STAT) WriteFormat(file,"static ");
        if(itext->NextText)
          WriteFormat(file,"struct IntuiText %s_text[] = {\n",&gadget->GadgetLabel);
        else
          WriteFormat(file,"struct IntuiText %s_text = {\n",&gadget->GadgetLabel);
        while(1)
        {   WriteFormat(file,"  %ld,%ld,",itext->FrontPen,itext->BackPen);
            WriteDrMd(file,itext->DrawMode,FALSE);
            WriteFormat(file,",%ld,%ld,NULL,",itext->LeftEdge,itext->TopEdge);
            WriteFormat(file,"(UBYTE *)%lc%s%lc,",'"',itext->IText,'"');
            if(itext->NextText)
              WriteFormat(file,"&%s_text[%ld],\n  ",&gadget->GadgetLabel,i++);
            else
              WriteFormat(file,"NULL");
            if(!(itext = itext->NextText)) break;
       }
       WriteFormat(file," };\n\n");
    }
}

/*
 * write the C NewScreen structure
 */
static VOID WriteCScreen(file)
    BPTR file;
{
    if(STAT) WriteFormat(file,"static ");
    WriteFormat(file,"struct NewScreen ns = {\n");
    WriteFormat(file,"  0,0,%ld,%ld,",MainScreen->Width,MainScreen->Height);
    WriteFormat(file,"%ld,",MainScreen->BitMap.Depth);
    WriteFormat(file,"-1,-1,");
    if(MainScreen->BitMap.Depth == 5) WriteFormat(file,"NULL,");
    else WriteFormat(file,"HIRES,");
    WriteFormat(file,"CUSTOMSCREEN,NULL,NULL,NULL,NULL };\n\n");
}

/*
 * write the C window/requester structure
 */
static VOID WriteCRW(file)
    BPTR file;
{
    struct IntuiText *t;
    if(REQUESTER)
    {   if(STAT) WriteFormat(file,"static ");
        WriteFormat(file,"struct Requester requester = {\n  NULL,");
        WriteFormat(file,"%ld,%ld,",(MainWindow->LeftEdge + MainWindow->BorderLeft),
                                    (MainWindow->TopEdge + MainWindow->BorderTop));
        WriteFormat(file,"%ld,%ld,",MainWindow->GZZWidth,MainWindow->GZZHeight);
        if(HaveGad)
            WriteFormat(file,"0,0,&%s,",&Gadgets.TailPred->GadgetLabel);
        else
            WriteFormat(file,"0,0,NULL,");
        if(Borders.TailPred != (struct MyGadget *)&Borders)
        {   if(MultyB)
              WriteFormat(file,"&Border_bord[0],");
            else
              WriteFormat(file,"&Border_bord,");
        }
        else WriteFormat(file,"NULL,");
        if((t = TextGadget.GadgetText))
        {   if(t->NextText) WriteFormat(file,"&Render_text[0],");
            else WriteFormat(file,"&Render_text,");
        }
        else WriteFormat(file,"NULL,");
        WriteFormat(file,"NULL,%ld,",BackFill);
        WriteFormat(file,"NULL,NULL,NULL,NULL,NULL };\n\n");
    }
    else
    {   if(STAT) WriteFormat(file,"static ");
        WriteFormat(file,"struct NewWindow %s = {\n  ",&wlb);
        WriteFormat(file,"%ld,%ld,%ld,%ld,",MainWindow->LeftEdge,MainWindow->TopEdge,
                                            MainWindow->Width,MainWindow->Height);
        WriteFormat(file,"%ld,%ld,\n  ",MainWindow->DetailPen,MainWindow->BlockPen);
        WriteIFlags(file);
        WriteFormat(file,",\n  ");
        WriteWFlags(file);
        WriteFormat(file,",\n");
        if(HaveGad)
            WriteFormat(file,"  &%s,NULL,\n",Gadgets.TailPred->GadgetLabel);
        else if(Borders.TailPred != (struct MyGadget *)&Borders)
            WriteFormat(file,"  &Render,NULL,\n");
        else
            WriteFormat(file,"  NULL,NULL,\n");
        if(strlen((char *)&wdt))
            WriteFormat(file,"  (UBYTE *)%lc%s%lc,NULL,NULL,\n",'"',&wdt,'"');
        else
            WriteFormat(file,"  NULL,NULL,NULL,\n");
        WriteFormat(file,"  %ld,%ld,%ld,%ld,",MainWindow->MinWidth,
                                              MainWindow->MinHeight,
                                              MainWindow->MaxWidth,
                                              MainWindow->MaxHeight);
        if(WBSCREEN) WriteFormat(file,"WBENCHSCREEN };\n\n");
        else         WriteFormat(file,"CUSTOMSCREEN };\n\n");
    }
}

/*
 * write the C window/requester texts structures
 */
static VOID WriteCWDT(file)
    BPTR file;
{
    register struct IntuiText *t, *t1;
    register UCOUNT i = 1;

    if(NOT TextGadget.GadgetText) return;

    t = TextGadget.GadgetText;
    if(STAT) WriteFormat(file,"static ");
    if(t->NextText)
      WriteFormat(file,"struct IntuiText Render_text[] = {\n  ");
    else
      WriteFormat(file,"struct IntuiText Render_text = {\n  ");
    while(1)
    {   WriteFormat(file,"%ld,%ld,",t->FrontPen,t->BackPen);
        WriteDrMd(file,t->DrawMode,FALSE);
        WriteFormat(file,",%ld,%ld,NULL,",t->LeftEdge,t->TopEdge);
        WriteFormat(file,"(UBYTE *)%lc%s%lc,",'"',t->IText,'"');
        if(t->NextText)
          WriteFormat(file,"&Render_text[%ld],\n  ",i++);
        else
          WriteFormat(file,"NULL");
        if(!(t = t->NextText)) break;
    }
    WriteFormat(file," };\n\n");
}

/*
 * write the C special render gadget
 */
static VOID WriteCRG(file)
    BPTR file;
{
    struct IntuiText *t;

    if((TextGadget.GadgetText) OR
       (Borders.TailPred != (struct MyGadget *)&Borders))
    {   if(NOT REQUESTER)
        {   if(STAT) WriteFormat(file,"static ");
            WriteFormat(file,"struct Gadget Render = {\n  ");
            WriteFormat(file,"NULL,0,0,1,1,GADGHNONE,NULL,BOOLGADGET,\n");

            if(Borders.TailPred != (struct MyGadget *)&Borders)
            {   if(MultyB)
                  WriteFormat(file,"  (APTR)&Border_bord[0],NULL,");
                else
                  WriteFormat(file,"  (APTR)&Border_bord,NULL,");
            }
            else WriteFormat(file,"  NULL,NULL,");
            if((t = TextGadget.GadgetText))
            {   if(t->NextText) WriteFormat(file,"&Render_text[0],");
                else WriteFormat(file,"&Render_text,");
            }
            else WriteFormat(file,"NULL,");
            WriteFormat(file,"NULL,NULL,NULL,NULL };\n\n");
        }
    }
}

/*
 * write the C border structures
 */
static VOID WriteCB(file)
    BPTR file;
{
    register struct MyGadget *g;
    register struct Border   *b;
    register SHORT           *xy;
    register UCOUNT           bc = 0,xyc;

    if(Borders.TailPred == (struct MyGadget *)&Borders) return;

    g = Borders.Head;

    while(1)
    {
        b = (struct Border *)g->Gadget.GadgetRender;
        while(1)
        {   if(STAT) WriteFormat(file,"static ");
            xy = b->XY;
            WriteFormat(file,"SHORT Border%ld_pairs[] = {\n  ",bc);
            for(xyc = 0;xyc < (b->Count << 1);xyc++) WriteFormat(file,"%ld,",xy[xyc]);
            Seek(file,-1,OFFSET_CURRENT);
            WriteFormat(file," };\n");
            bc++;
            if(!(b = b->NextBorder)) break;
        }
        if((g = g->Succ) == (struct MyGadget *)&Borders.Tail) break;
    }
    WriteFormat(file,"\n");

    bc = 0;
    g = Borders.Head;
    b = (struct Border *)g->Gadget.GadgetRender;
    if(STAT) WriteFormat(file,"static ");
    if((b->NextBorder) OR (g->Succ != (struct MyGadget *)&Borders.Tail))
    {   WriteFormat(file,"struct Border Border_bord[] = {\n");
        MultyB = TRUE;
    }
    else
    {   WriteFormat(file,"struct Border Border_bord = {\n");
        MultyB = FALSE;
    }
    while(1)
    {
        while(1)
        {
            WriteFormat(file,"  %ld,%ld,",g->Gadget.LeftEdge,g->Gadget.TopEdge);
            WriteFormat(file,"%ld,0,JAM1,%ld,",b->FrontPen,b->Count);
            WriteFormat(file,"(SHORT *)&Border%ld_pairs,",bc);
            bc++;
            if(!(b = b->NextBorder))
            {   if(g->Succ == (struct MyGadget *)&Borders.Tail)
                    WriteFormat(file,"NULL };\n\n");
                else
                    WriteFormat(file,"&Border_bord[%ld],\n",bc);
                break;
            }
            else
                WriteFormat(file,"&Border_bord[%ld],\n",bc);
        }
        if((g = g->Succ) == (struct MyGadget *)&Borders.Tail)
            break;
        b = (struct Border *)g->Gadget.GadgetRender;
    }
}

/*
 * write the C source code
 */
VOID WriteCGadgets()
{
    BPTR                      file;
    register struct MyGadget *gadget;
    struct ColorMap          *cm;
    COUNT                     i,ii;
    USHORT                   *tab,cc;
    ULONG                     rc;
    char                     *str;

    GenASM = FALSE;
    HaveGad = is_gadget();

    strcpy((char *)IODir->fr_HeadLine,"Save C Source");
    IODir->fr_Screen  = MainScreen;
    IODir->fr_Caller  = MainWindow;
    IODir->fr_Flags  |= FR_NoInfo;
    rc = FileRequest(IODir);
    strcpy((char *)&name,(char *)IODir->fr_DirName);
    strcat((char *)&name,(char *)IODir->fr_FileName);

    if(rc == FREQ_CANCELED) return;
    else if(rc)
    {   Error("FileRequester won't open !");
        return;
    }
    cm = MainScreen->ViewPort.ColorMap;
    tab = (USHORT *)cm->ColorTable;
    if(NOT(file = Open((char *)&name,MODE_NEWFILE)))
    {   Error("Can't open write file !");
        return;
    }
    SetWindowTitles(MainWindow,(char *)-1L,(char *)"Saving C Source.....");
    buisy();
    disable_window();
    un_gzz();
    cc = (1 << MainScreen->BitMap.Depth);
    WriteFormat(file,"/*---------------------------------------------------*\n");
    WriteFormat(file,"  Gadgets created with GadgetEd V2.3\n");
    WriteFormat(file,"  which is (c) Copyright 1990-91 by Jaba Development\n");
    WriteFormat(file,"  written by Jan van den Baard\n");
    WriteFormat(file," *---------------------------------------------------*/\n\n");
    if(NOT WBSCREEN)
    {   if(STAT) WriteFormat(file,"static ");
        WriteFormat(file,"USHORT Colors[] = {\n");
        for(ii=0;ii<cc;ii+=8)
        {   for(i=0;i<8;i++)
              if((ii+i) < cc) WriteFormat(file,"  0x%04lx,",tab[ii+i]);
            WriteFormat(file,"\n");
        }
        Seek(file,-2,OFFSET_CURRENT);
        WriteFormat(file," };\n\n");
    }
    split();
    WriteCB(file);
    WriteCWDT(file);
    WriteCRG(file);
    if(HaveGad)
    {   for(gadget = Gadgets.Head;gadget->Succ;gadget = gadget->Succ)
        {   if(TestBits((ULONG)gadget->Gadget.GadgetType,PROPGADGET))
            {   WriteCPinfo(file,gadget);
                if(NOT TestBits((ULONG)gadget->Gadget.Flags,GADGIMAGE))
                    WriteCImage(file,gadget,STDPRP);
            }
            if(TestBits((ULONG)gadget->Gadget.GadgetType,STRGADGET))
                WriteCSinfo(file,gadget);
            if((NOT TestBits((ULONG)gadget->Gadget.Flags,GADGIMAGE)) AND
               (NOT TestBits((ULONG)gadget->Gadget.GadgetType,PROPGADGET)) AND
               (NOT TestBits((ULONG)gadget->SpecialFlags,NOBORDER)))
                WriteCBorder(file,gadget);
            if(TestBits((ULONG)gadget->Gadget.Flags,GADGIMAGE))
                WriteCImage(file,gadget,RENDER);
            if((TestBits((ULONG)gadget->Gadget.Flags,GADGHIMAGE)) AND
               (NOT TestBits((ULONG)gadget->Gadget.Flags,GADGHBOX)))
                WriteCImage(file,gadget,SELECT);
            if(gadget->Gadget.GadgetText)
                WriteCTexts(file,gadget);
            WriteCGadget(file,gadget);
            if(str = IoErrToStr())
            {   Close(file);
                enable_window();
                Error(str);
                return;
            }
        }
    }
    gadget = Gadgets.TailPred;
    if(NOT WBSCREEN) WriteCScreen(file);
    WriteCRW(file);
    if(NOT WBSCREEN)  WriteFormat(file,"\n#define COLORCOUNT  %ld",cc);
    if(NOT REQUESTER) { WriteFormat(file,"\n#define NEWWINDOW   &%s",&wlb);
                        WriteFormat(file,"\n#define WDBACKFILL   %ld",WDBackFill); }
    else              WriteFormat(file,"\n#define REQUESTER   &requester");
    if(NOT WBSCREEN)  WriteFormat(file,"\n#define NEWSCREEN   &ns");
    if(HaveGad)
        WriteFormat(file,"\n#define FIRSTGADGET &%s",&Gadgets.TailPred->GadgetLabel);
    if(TextGadget.GadgetText)
    {   WriteFormat(file,"\n#define FIRSTTEXT   &");
        if(TextGadget.GadgetText->NextText)
          WriteFormat(file,"Render_text[0]");
        else
          WriteFormat(file,"Render_text");
    }
    if(Borders.TailPred != (struct MyGadget *)&Borders)
    {   WriteFormat(file,"\n#define FIRSTBORDER &");
        if(MultyB)
          WriteFormat(file,"Border_bord[0]");
        else
        WriteFormat(file,"Border_bord");
    }
    WriteFormat(file,"\n");
    if(str = IoErrToStr()) Error(str);
    Close(file);
    join();
    do_gzz();
    enable_window();
    ok();
    return;
}
