/*----------------------------------------------------------------------*
   idreq.c Version 2.3 -  © Copyright 1990-91 Jaba Development

   Author  : Jan van den Baard
   Purpose : Set window IDCMP e.c.t
 *----------------------------------------------------------------------*/

static UBYTE UNDOBUFFER[80];

static SHORT MainPairs2[] =
 { 0,0,314,0 };
static struct Border MainBorder2 =
 { 2,12,0,0,JAM1,2,MainPairs2,NULL };
static SHORT MainPairs1[] =
 { 0,0,315,0,315,197,0,197,0,0 };
static struct Border MainBorder1 =
 { 2,1,0,0,JAM1,5,MainPairs1,&MainBorder2 };

static SHORT OCPairs[] =
 { 0,0,56,0,56,23,0,23,0,0 };
static struct Border OCBorder =
 { -1,-1,0,0,JAM1,5,OCPairs,NULL };

static struct IntuiText CNCText =
 { 0,0,JAM1,4,7,NULL,(UBYTE *)"CANCEL",NULL };
static struct Gadget CNC =
 { NULL,253,173,55,22,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&OCBorder,NULL,&CNCText,NULL,NULL,34,NULL };

static struct IntuiText OKText =
 { 0,0,JAM1,20,7,NULL,(UBYTE *)"OK",NULL };
static struct Gadget OK =
 { &CNC,253,147,55,22,NULL,RELVERIFY,BOOLGADGET,
   (APTR)&OCBorder,NULL,&OKText,NULL,NULL,33,NULL };

static SHORT VALPairs[] =
 { 0,0,57,0,57,9,0,9,0,0 };
static struct Border VALBorder =
 { -1,-1,2,0,JAM1,5,VALPairs,NULL };

static UBYTE MAYBuff[4];
static struct StringInfo MAYInfo =
 { MAYBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText MAYText =
 { 0,0,JAM1,12,-10,NULL,(UBYTE *)"MaxY",NULL };
static struct Gadget MAY =
 { &OK,253,131,56,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&VALBorder,NULL,&MAYText,NULL,(APTR)&MAYInfo,32,NULL };

static UBYTE MAXBuff[4];
static struct StringInfo MAXInfo =
 { MAXBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText MAXText =
 { 0,0,JAM1,12,-10,NULL,(UBYTE *)"MaxX",NULL };
static struct Gadget MAX =
 { &MAY,253,110,56,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&VALBorder,NULL,&MAXText,NULL,(APTR)&MAXInfo,31,NULL };

static UBYTE MIYBuff[4];
static struct StringInfo MIYInfo =
 { MIYBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText MIYText =
 { 0,0,JAM1,12,-10,NULL,(UBYTE *)"MinY",NULL };
static struct Gadget MIY =
 { &MAX,253,89,56,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&VALBorder,NULL,&MIYText,NULL,(APTR)&MIYInfo,30,NULL };

static UBYTE MIXBuff[4];
static struct StringInfo MIXInfo =
 { MIXBuff,UNDOBUFFER,0,4,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText MIXText =
 { 0,0,JAM1,12,-10,NULL,(UBYTE *)"MinX",NULL };
static struct Gadget MIX =
 { &MIY,253,68,56,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&VALBorder,NULL,&MIXText,NULL,(APTR)&MIXInfo,29,NULL };

static UBYTE BPBuff[3];
static struct StringInfo BPInfo =
 { BPBuff,UNDOBUFFER,0,3,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText BPText =
 { 0,0,JAM1,9,-10,NULL,(UBYTE *)"Block",NULL };
static struct Gadget BP =
 { &MIX,252,47,56,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&VALBorder,NULL,&BPText,NULL,(APTR)&BPInfo,28,NULL };

static UBYTE DPBuff[3];
static struct StringInfo DPInfo =
 { DPBuff,UNDOBUFFER,0,3,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText DPText =
 { 0,0,JAM1,5,-10,NULL,(UBYTE *)"Detail",NULL };
static struct Gadget DP =
 { &BP,252,26,56,8,NULL,RELVERIFY+STRINGCENTER+LONGINT,STRGADGET,
   (APTR)&VALBorder,NULL,&DPText,NULL,(APTR)&DPInfo,27,NULL };

static SHORT TLPairs[] =
 { 0,0,169,0,169,9,0,9,0,0 };
static struct Border TLBorder =
 { -1,-1,2,0,JAM1,5,TLPairs,NULL };

static UBYTE SLBuff[MAXLABEL] = "nw";
static struct StringInfo SLInfo =
 { SLBuff,UNDOBUFFER,0,MAXLABEL,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText SLText =
 { 0,0,JAM1,-67,0,NULL,(UBYTE *)"Label",NULL };
static struct Gadget SL =
 { &DP,75,187,168,8,NULL,RELVERIFY+STRINGCENTER,STRGADGET,
   (APTR)&TLBorder,NULL,&SLText,NULL,(APTR)&SLInfo,26,NULL };

static UBYTE TIBuff[80] = "Work Window";
static struct StringInfo TIInfo =
 { TIBuff,UNDOBUFFER,0,80,0,0,0,0,0,0,0,0,NULL };
static struct IntuiText TIText =
 { 0,0,JAM1,-67,0,NULL,(UBYTE *)"Title",NULL };
static struct Gadget TI =
 { &SL,75,173,168,8,NULL,RELVERIFY+STRINGCENTER,STRGADGET,
   (APTR)&TLBorder,NULL,&TIText,NULL,(APTR)&TIInfo,25,NULL };

static SHORT FLPairs[] =
 { 0,0,115,0,115,10,0,10,0,0 };
static struct Border FLBorder =
 { -1,-1,0,0,JAM1,5,FLPairs,NULL };

static struct IntuiText LMText =
 { 0,0,JAM1,5,1,NULL,(UBYTE *)"LONELYMESSAGE",NULL };
static struct Gadget LM =
 { &TI,129,160,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&LMText,NULL,NULL,23,NULL };

static struct IntuiText WMText =
 { 0,0,JAM1,5,1,NULL,(UBYTE *)"WBENCHMESSAGE",NULL };
static struct Gadget WM =
 { &LM,129,147,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&WMText,NULL,NULL,22,NULL };

static struct IntuiText VKText =
 { 0,0,JAM1,17,1,NULL,(UBYTE *)"VANILLAKEY",NULL };
static struct Gadget VK =
 { &WM,129,134,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&VKText,NULL,NULL,21,NULL };

static struct IntuiText RKText =
 { 0,0,JAM1,31,1,NULL,(UBYTE *)"RAWKEY",NULL };
static struct Gadget RK =
 { &VK,129,121,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&RKText,NULL,NULL,20,NULL };

static struct IntuiText DRText =
 { 0,0,JAM1,14,1,NULL,(UBYTE *)"DISKREMOVED",NULL };
static struct Gadget DR =
 { &RK,129,108,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&DRText,NULL,NULL,19,NULL };

static struct IntuiText DIText =
 { 0,0,JAM1,9,1,NULL,(UBYTE *)"DISKINSERTED",NULL };
static struct Gadget DI =
 { &DR,129,95,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&DIText,NULL,NULL,18,NULL };

static struct IntuiText NPText =
 { 0,0,JAM1,25,1,NULL,(UBYTE *)"NEWPREFS",NULL };
static struct Gadget NP =
 { &DI,129,82,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&NPText,NULL,NULL,17,NULL };

static struct IntuiText ITText =
 { 0,0,JAM1,15,1,NULL,(UBYTE *)"INTUITICKS",NULL };
static struct Gadget IT =
 { &NP,129,69,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&ITText,NULL,NULL,16,NULL };

static struct IntuiText DMText =
 { 0,0,JAM1,21,1,NULL,(UBYTE *)"DELTAMOVE",NULL };
static struct Gadget DM =
 { &IT,129,56,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&DMText,NULL,NULL,15,NULL };

static struct IntuiText MMText =
 { 0,0,JAM1,21,1,NULL,(UBYTE *)"MOUSEMOVE",NULL };
static struct Gadget MM =
 { &DM,129,43,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&MMText,NULL,NULL,14,NULL };

static struct IntuiText MBText =
 { 0,0,JAM1,9,1,NULL,(UBYTE *)"MOUSEBUTTONS",NULL };
static struct Gadget MB =
 { &MM,129,30,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&MBText,NULL,NULL,13,NULL };

static struct IntuiText MVText =
 { 0,0,JAM1,16,1,NULL,(UBYTE *)"MENUVERIFY",NULL };
static struct Gadget MV =
 { &MB,129,17,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&MVText,NULL,NULL,12,NULL };

static struct IntuiText MPText =
 { 0,0,JAM1,26,1,NULL,(UBYTE *)"MENUPICK",NULL };
static struct Gadget MP =
 { &MV,10,160,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&MPText,NULL,NULL,11,NULL };

static struct IntuiText RVText =
 { 0,0,JAM1,22,1,NULL,(UBYTE *)"REQVERIFY",NULL };
static struct Gadget RV =
 { &MP,9,147,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&RVText,NULL,NULL,10,NULL };

static struct IntuiText RCText =
 { 0,0,JAM1,27,1,NULL,(UBYTE *)"REQCLEAR",NULL };
static struct Gadget RC =
 { &RV,9,134,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&RCText,NULL,NULL,9,NULL };

static struct IntuiText RSText =
 { 0,0,JAM1,32,1,NULL,(UBYTE *)"REQSET",NULL };
static struct Gadget RS =
 { &RC,9,121,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&RSText,NULL,NULL,8,NULL };

static struct IntuiText CWText =
 { 0,0,JAM1,12,1,NULL,(UBYTE *)"CLOSEWINDOW",NULL };
static struct Gadget CW =
 { &RS,9,108,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&CWText,NULL,NULL,7,NULL };

static struct IntuiText GUText =
 { 0,0,JAM1,25,1,NULL,(UBYTE *)"GADGETUP",NULL };
static struct Gadget GU =
 { &CW,9,95,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&GUText,NULL,NULL,6,NULL };

static struct IntuiText GDText =
 { 0,0,JAM1,15,1,NULL,(UBYTE *)"GADGETDOWN",NULL };
static struct Gadget GD =
 { &GU,9,82,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&GDText,NULL,NULL,5,NULL };

static struct IntuiText IWText =
 { 0,0,JAM1,1,1,NULL,(UBYTE *)"INACTIVEWINDOW",NULL };
static struct Gadget IW =
 { &GD,9,69,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&IWText,NULL,NULL,4,NULL };

static struct IntuiText AWText =
 { 0,0,JAM1,9,1,NULL,(UBYTE *)"ACTIVEWINDOW",NULL };
static struct Gadget AW =
 { &IW,9,56,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&AWText,NULL,NULL,3,NULL };

static struct IntuiText RWText =
 { 0,0,JAM1,5,1,NULL,(UBYTE *)"REFRESHWINDOW",NULL };
static struct Gadget RW =
 { &AW,9,43,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&RWText,NULL,NULL,2,NULL };

static struct IntuiText NSText =
 { 0,0,JAM1,28,1,NULL,(UBYTE *)"NEWSIZE",NULL };
static struct Gadget NS =
 { &RW,9,30,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&NSText,NULL,NULL,1,NULL };

static struct IntuiText SVYText =
 { 0,0,JAM1,16,1,NULL,(UBYTE *)"SIZEVERIFY",NULL };
static struct Gadget SVY =
 { &NS,9,17,114,9,NULL,GADGIMMEDIATE+TOGGLESELECT,BOOLGADGET,
   (APTR)&FLBorder,NULL,&SVYText,NULL,NULL,0,NULL };

static struct IntuiText TText =
 { 0,0,JAM1,92,3,NULL,(UBYTE *)"Edit Window IDCMP",NULL };

static struct NewWindow id_req =
 { 0,0,320,200,0,1,GADGETDOWN+GADGETUP,
   ACTIVATE+RMBTRAP+NOCAREREFRESH,
   NULL,NULL,NULL,NULL,NULL,
   0,0,0,0,CUSTOMSCREEN };

extern struct Window *MainWindow;
extern struct Screen *MainScreen;
extern struct Gadget *Gadget;
extern ULONG          IDCMPFlags;
extern UBYTE          wdt[80];
extern UBYTE          wlb[MAXLABEL];
extern BOOL           Saved;

/*
 * reset all control gadgets
 */
VOID re_set()
{
 register struct Gadget *g;

 g = &SVY;
 while(1)
  {
   if(g == &TI) break;
   g->Flags = NULL;
   g = g->NextGadget;
  }

 strcpy((char *)&TIBuff,(char *)&wdt);
 strcpy((char *)&SLBuff,(char *)&wlb);

 Format((char *)&MAYBuff,"%ld",MainWindow->MaxHeight);
 MAYInfo.LongInt = MainWindow->MaxHeight;
 Format((char *)&MAXBuff,"%ld",MainWindow->MaxWidth);
 MAXInfo.LongInt = MainWindow->MaxWidth;

 Format((char *)&MIYBuff,"%ld",MainWindow->MinHeight);
 MIYInfo.LongInt = MainWindow->MinHeight;
 Format((char *)&MIXBuff,"%ld",MainWindow->MinWidth);
 MIXInfo.LongInt = MainWindow->MinWidth;

 Format((char *)&BPBuff,"%ld",MainWindow->BlockPen);
 BPInfo.LongInt = MainWindow->BlockPen;
 Format((char *)&DPBuff,"%ld",MainWindow->DetailPen);
 DPInfo.LongInt = MainWindow->DetailPen;
}

/*
 * open the IDCMP window
 */
VOID idcmp()
{
 struct Window *idw;
 UCOUNT i;

 id_req.Screen = MainScreen;
 re_set();
 if(NOT(idw = OpenWindow(&id_req))) return;
 disable_window();
 draw(idw,&SVY,&MainBorder1,&TText);

 if(TestBits(IDCMPFlags,SIZEVERIFY))      SelectGadget(idw,&SVY,NULL);
 if(TestBits(IDCMPFlags,NEWSIZE))         SelectGadget(idw,&NS ,NULL);
 if(TestBits(IDCMPFlags,REFRESHWINDOW))   SelectGadget(idw,&RW,NULL);
 if(TestBits(IDCMPFlags,ACTIVEWINDOW))    SelectGadget(idw,&AW,NULL);
 if(TestBits(IDCMPFlags,INACTIVEWINDOW))  SelectGadget(idw,&IW,NULL);
 if(TestBits(IDCMPFlags,GADGETDOWN))      SelectGadget(idw,&GD,NULL);
 if(TestBits(IDCMPFlags,GADGETUP))        SelectGadget(idw,&GU,NULL);
 if(TestBits(IDCMPFlags,CLOSEWINDOW))     SelectGadget(idw,&CW,NULL);
 if(TestBits(IDCMPFlags,REQSET))          SelectGadget(idw,&RS,NULL);
 if(TestBits(IDCMPFlags,REQCLEAR))        SelectGadget(idw,&RC,NULL);
 if(TestBits(IDCMPFlags,REQVERIFY))       SelectGadget(idw,&RV,NULL);
 if(TestBits(IDCMPFlags,MENUPICK))        SelectGadget(idw,&MP,NULL);
 if(TestBits(IDCMPFlags,MENUVERIFY))      SelectGadget(idw,&MV,NULL);
 if(TestBits(IDCMPFlags,MOUSEBUTTONS))    SelectGadget(idw,&MB,NULL);
 if(TestBits(IDCMPFlags,MOUSEMOVE))       SelectGadget(idw,&MM,NULL);
 if(TestBits(IDCMPFlags,DELTAMOVE))       SelectGadget(idw,&DM,NULL);
 if(TestBits(IDCMPFlags,INTUITICKS))      SelectGadget(idw,&IT,NULL);
 if(TestBits(IDCMPFlags,NEWPREFS))        SelectGadget(idw,&NP,NULL);
 if(TestBits(IDCMPFlags,DISKINSERTED))    SelectGadget(idw,&DI,NULL);
 if(TestBits(IDCMPFlags,DISKREMOVED))     SelectGadget(idw,&DR,NULL);
 if(TestBits(IDCMPFlags,RAWKEY))          SelectGadget(idw,&RK,NULL);
 if(TestBits(IDCMPFlags,VANILLAKEY))      SelectGadget(idw,&VK,NULL);
 if(TestBits(IDCMPFlags,WBENCHMESSAGE))   SelectGadget(idw,&WM,NULL);
 if(TestBits(IDCMPFlags,LONELYMESSAGE))   SelectGadget(idw,&LM,NULL);

 do
  {
   Wait(1 << idw->UserPort->mp_SigBit);
   while(read_msg(idw));
  } while(Gadget->GadgetID < 33);
 CloseWindow(idw);
 if(Gadget->GadgetID == 33)
  {
   IDCMPFlags = NULL;
   if(SelectTest(&SVY)) IDCMPFlags |= SIZEVERIFY;
   if(SelectTest(&NS))  IDCMPFlags |= NEWSIZE;
   if(SelectTest(&RW))  IDCMPFlags |= REFRESHWINDOW;
   if(SelectTest(&AW))  IDCMPFlags |= ACTIVEWINDOW;
   if(SelectTest(&IW))  IDCMPFlags |= INACTIVEWINDOW;
   if(SelectTest(&GD))  IDCMPFlags |= GADGETDOWN;
   if(SelectTest(&GU))  IDCMPFlags |= GADGETUP;
   if(SelectTest(&CW))  IDCMPFlags |= CLOSEWINDOW;
   if(SelectTest(&RS))  IDCMPFlags |= REQSET;
   if(SelectTest(&RC))  IDCMPFlags |= REQCLEAR;
   if(SelectTest(&RV))  IDCMPFlags |= REQVERIFY;
   if(SelectTest(&MP))  IDCMPFlags |= MENUPICK;
   if(SelectTest(&MV))  IDCMPFlags |= MENUVERIFY;
   if(SelectTest(&MB))  IDCMPFlags |= MOUSEBUTTONS;
   if(SelectTest(&MM))  IDCMPFlags |= MOUSEMOVE;
   if(SelectTest(&DM))  IDCMPFlags |= DELTAMOVE;
   if(SelectTest(&IT))  IDCMPFlags |= INTUITICKS;
   if(SelectTest(&NP))  IDCMPFlags |= NEWPREFS;
   if(SelectTest(&DI))  IDCMPFlags |= DISKINSERTED;
   if(SelectTest(&DR))  IDCMPFlags |= DISKREMOVED;
   if(SelectTest(&RK))  IDCMPFlags |= RAWKEY;
   if(SelectTest(&VK))  IDCMPFlags |= VANILLAKEY;
   if(SelectTest(&WM))  IDCMPFlags |= WBENCHMESSAGE;
   if(SelectTest(&LM))  IDCMPFlags |= LONELYMESSAGE;

   strcpy((char *)&wdt,(char *)&TIBuff);
   strcpy((char *)&wlb,(char *)&SLBuff);
   if(!strlen((char *)&wdt))
        MainWindow->Title = NULL;
   else
        MainWindow->Title = (UBYTE *)&wdt;
   for(i=0;i<strlen((char *)&wlb);i++) if(wlb[i] == 0x20) wlb[i] = '_';
   if(TestBits(MainWindow->Flags,WINDOWSIZING))
    {
     WindowLimits(MainWindow,MIXInfo.LongInt,
                             MIYInfo.LongInt,
                             MAXInfo.LongInt,
                             MAYInfo.LongInt);
    }

   MainWindow->DetailPen = DPInfo.LongInt;
   MainWindow->BlockPen  = BPInfo.LongInt;

   Saved = FALSE;
  }
 refresh();
 enable_window();
}
