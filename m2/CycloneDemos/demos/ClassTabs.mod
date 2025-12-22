MODULE ClassTabs;

FROM SYSTEM IMPORT ADR,LONGSET,ASSEMBLE,ADDRESS,TAG;
IMPORT id:IntuitionD,il:IntuitionL,ExecL,ExecD,ml:ModulaLib,
       ud:UtilityD,DosD,InOut;


TYPE
 PenTyp   = ARRAY[0..3] OF INTEGER;
 LabelRec = RECORD
              adr:ADDRESS;
              pens:PenTyp;
              attr:ud.TagItemPtr;
            END;
 LabelTyp = ARRAY[0..3] OF LabelRec;


CONST 
  LTRUE=1;              (* Like 'C' *)
  LFALSE=0;             (* Like 'C' & Cyclone *)

(* Additional attributes defined by the tabs.gadget class *)
 tabsDummy = ud.tagUser+4000000H;

 tabsLabels = tabsDummy+1;
  (* (TabLabelP) Array of labels *)

 tabsCurrent = tabsDummy+2;
  (* (LONG) Current tab *)
 

 (* Easy filling of a constant record *)
 Labels = LabelTyp{LabelRec{ADR("Display"),PenTyp{-1,..},NIL},
                   LabelRec{ADR("Edit"),PenTyp{-1,..},NIL},
                   LabelRec{ADR("File"),PenTyp{-1,..},NIL},
                   LabelRec{NIL,PenTyp{0,..},NIL}};

VAR 
 scr:id.ScreenPtr;
 classBase:ExecD.LibraryPtr;
 win:id.WindowPtr;
 gad,g:id.GadgetPtr;
 msg:id.IntuiMessagePtr; 
 going:BOOLEAN;
 sig:LONGSET;
 pos:INTEGER;
 labels:LabelTyp;

BEGIN
 InOut.WriteString('Press CTRL-C to abort ...\n');
 scr:=il.intuitionBase^.firstScreen;
 classBase:=ExecL.OpenLibrary(ADR("gadgets/tabs.gadget"),37);
 IF classBase#NIL THEN
   (* make easly use of the lists [ ] *)
   win:=il.OpenWindowTagList(NIL,
                             [id.waTitle,       ADR("tabs.gadget Test"),
                              id.waInnerWidth,  320,
                              id.waInnerHeight, 8+6+34,
                              id.waIDCMP,       id.IDCMPFlagSet{id.closeWindow,id.gadgetUp,
                                                id.mouseMove,id.intuiTicks,id.vanillaKey,
                                                id.mouseButtons},
                              id.waDragBar,     LTRUE,
                              id.waDepthGadget, LTRUE,
                              id.waCloseGadget, LTRUE,
                              id.waSimpleRefresh,  LTRUE,
                              id.waNoCareRefresh, LTRUE,
                              id.waActivate,    LTRUE,
                              id.waSizeGadget,  LTRUE,
                              id.waMinWidth,    300,
                              id.waMinHeight,   scr^.barHeight+1+3+34,
                              id.waMaxWidth,    1024,
                              id.waMaxHeight,   1024,
                              id.waCustomScreen, scr,
                              ud.tagDone]); 

   gad:=il.NewObjectA(NIL,ADR("tabs.gadget"),
                                [id.gaTop,	win^.borderTop + 2,
				id.gaLeft,	win^.borderLeft + 4,
				id.gaHeight,	8 + 6,
				id.gaRelWidth,	-(win^.borderLeft + 8 + win^.borderRight),
				id.gaRelVerify,	LTRUE,
				id.gaImmediate,	LTRUE,
				tabsLabels,	ADR(Labels),
				tabsCurrent,	0,
                                ud.tagDone]); 
   (* Little bit bad written close stuff *)
   IF (gad#NIL) AND (win#NIL) THEN
        pos:=il.AddGList(win,gad,-1,-1,NIL);
        il.RefreshGList(gad,win,NIL,-1);
        going:=TRUE;
        WHILE going DO
         sig:=ExecL.Wait(LONGSET{win^.userPort^.sigBit,DosD.ctrlC});
         IF (DosD.ctrlC IN sig) THEN going:=FALSE; END;
         
        END;
        pos:=il.RemoveGList(win,gad,1);
        il.DisposeObject(gad);
   END;
   IF win#NIL THEN il.CloseWindow(win); END;
   ExecL.CloseLibrary(classBase);
 ELSE
  InOut.WriteString('Cannot open gadgets/tabs.gadget library!\n');
 END;
END ClassTabs.
