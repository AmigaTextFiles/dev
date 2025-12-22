(*---------------------------------------------------------------------------
  :Program.    ModGen
  :Contents.   Modula-2 SourceCode Generator für GadgetToolsBox 2.x
  :Author.     Frank Lömker
  :Copyright.  FreeWare
  :Language.   Modula-2
  :Translator. Turbo Modula-2 V1.40
  :Imports.    GadToolsBox, NoFragLib [Jan van den Baard]
  :Imports.    MGTools, MGRequest [Frank]
  :History.    1.0 [Frank] 17-Apr-95
  :History.        ModGen basiert direkt auf OG V37.11 von Thomas Igracki
  :History.        und GenOberon V1.0 von Kai Bolay und Jan van den Baard.
  :Bugs.       keine bekannt
---------------------------------------------------------------------------*)

MODULE ModGen;

FROM SYSTEM IMPORT ADR,ADDRESS,CAST,LONGSET,STRING;
FROM M2Lib IMPORT wbStarted;
IMPORT
   I:=Intuition, G:=Graphics,
   d:=Dos, u:=Utility, df:=DiskFont,
   gtx:=GadToolsBox, nf:=NoFragLib, st:=String,
   mt:=MGTools;
FROM MGTools IMPORT file,fdef,GuiData,MainConfig,FPrintF,FPrintF2,FPrintF3,
      FPrintF4,FPrintF5,FPutS,FPutS2;
FROM MGRequest IMPORT geladen,chain,ValidBits, Request,OpenReq,InitReq,
      OpenSafe,startSave,saveicon;

TYPE str43=ARRAY [0..43] OF CHAR;

CONST tmp = "NAME,TO=AS,SCREEN,OPENFONT/S,SYSFONT/S,RASTER/S,UNDERMOUSE/S,PORT/S,ICON/S,NOGUI/S,OPT/K";

VAR Path : ARRAY [0..511] OF CHAR;
    RD   : d.RDArgsPtr;
    VERSION:str43;

PROCEDURE FPfile (str:STRING);
BEGIN
  FPutS (file,str);
END FPfile;

(* --- Write the Modula cleanup routine. *)
PROCEDURE WriteCleanup (pw: gtx.ProjectWindowPtr);
BEGIN
  FPrintF (file, ADR("PROCEDURE Close%sWindow;\n"), ADR(pw^.name));
  FPrintF (fdef, ADR("PROCEDURE Close%sWindow;\n"), ADR(pw^.name));
  FPutS (file, "BEGIN\n");
  IF pw^.menus.head^.succ # NIL THEN
    FPrintF3 (file,ADR("  IF %sMenus # NIL THEN\n    IF %sWnd # NIL THEN\n      I.ClearMenuStrip (%sWnd);\n"),
              ADR(pw^.name), ADR(pw^.name), ADR(pw^.name));
    FPrintF2 (file,ADR("    END;\n    gt.FreeMenus (%sMenus);\n    %sMenus := NIL;\n  END;\n"),
              ADR(pw^.name), ADR(pw^.name));
  END;
  FPrintF  (file,ADR("  IF %sWnd # NIL THEN\n"),ADR(pw^.name));
  IF mt.port IN mt.MConfig THEN FPutS (file,"    ");
                           ELSE FPutS (file,"    I."); END;
  FPrintF2 (file,ADR("CloseWindow (%sWnd);\n    %sWnd := NIL;\n  END;\n"),
            ADR(pw^.name), ADR(pw^.name));
  IF pw^.gadgets.head^.succ # NIL THEN
    FPrintF3 (file,ADR("  IF %sGList # NIL THEN\n    gt.FreeGadgets (%sGList);\n    %sGList := NIL;\n  END;\n"),
              ADR(pw^.name), ADR(pw^.name), ADR(pw^.name));
  END;
  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
    IF mt.SysFont IN mt.MConfig THEN
      FPrintF3 (file,ADR("  IF %sFont # NIL THEN\n    g.CloseFont (%sFont);\n    %sFont := NIL;\n  END;\n"),
                ADR(pw^.name), ADR(pw^.name), ADR(pw^.name));
    END;
  END;
  IF mt.GetFileInWindow THEN
    FPrintF3 (file,ADR("  IF %sGetImage # NIL THEN\n    C.DisposeObject (%sGetImage);\n    %sGetImage := NIL;\n  END;\n"),
              ADR(pw^.name), ADR(pw^.name), ADR(pw^.name));
  END;
  FPrintF (file, ADR("END Close%sWindow;\n\n"), ADR(pw^.name));
END WriteCleanup;

(* --- Write the Screen cleanup routine. *)
PROCEDURE WriteScrCleanup();
BEGIN
  FPutS2 (ADR("PROCEDURE CloseDownScreen;\n"));
  FPutS (file, "BEGIN\n");
  FPutS (file,"  IF VisualInfo # NIL THEN\n    gt.FreeVisualInfo (VisualInfo);\n    VisualInfo := NIL;\n  END;\n");

  IF gtx.Custom IN GuiData.flags0 THEN
    FPutS (file,"  IF Scr # NIL THEN\n    I.CloseScreen (Scr);\n    Scr := NIL;\n  END;\n");
  ELSE
    FPutS (file,"  IF Scr # NIL THEN\n    I.UnlockPubScreen (NIL, Scr);\n    Scr := NIL;\n  END;\n");
  END;

  IF mt.CheckFont() THEN
    FPutS (file,"  IF Font # NIL THEN\n    g.CloseFont (Font);\n    Font := NIL;\n  END;\n");
  END;
  FPutS (file, "END CloseDownScreen;\n\n");
END WriteScrCleanup;

(* --- Write the rendering routine *)
PROCEDURE WriteRender (pw: gtx.ProjectWindowPtr);
VAR box: gtx.BevelBoxPtr;
    i, offx, offy, bleft, btop: INTEGER;
    t: I.IntuiTextPtr;
    alt:G.TextAttrPtr;
    fname: mt.str32;
    str:STRING;
    pos:LONGINT;
BEGIN
  st.strcpy (fname,GuiData.fontName);
  str:=st.strchr(fname,'.'); str^[0]:=0C;

  bleft := pw^.leftBorder; btop := pw^.topBorder;
  offx := bleft; offy := btop;

  FPrintF (file, ADR("PROCEDURE %sRender;\n"), ADR(pw^.name));
  FPrintF (fdef, ADR("PROCEDURE %sRender;\n"), ADR(pw^.name));

  IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN FPutS (file, "VAR offx, offy: INTEGER;\n"); END;
  IF (pw^.boxes.head^.succ#NIL) OR (pw^.windowText#NIL) THEN
    IF (gtx.FontAdapt IN MainConfig.configFlags0) THEN
      FPutS (file,"VAR rp:g.RastPortPtr;\n");
    ELSE
      FPutS (file,"    rp:g.RastPortPtr;\n");
    END;
    IF (pw^.boxes.head^.succ#NIL) AND (mt.raster IN mt.MConfig) AND
       (gtx.FontAdapt IN MainConfig.configFlags0) THEN
      FPutS (file,"    sx,sy:INTEGER;\n");
    END;
  END;
  FPutS (file, "BEGIN\n");

  IF mt.raster IN mt.MConfig THEN
    FPrintF3 (file,ADR(" IF %sWnd^.Height-%sWnd^.BorderBottom-1-%sWnd^.BorderTop>0 THEN\n"),
                   ADR(pw^.name),ADR(pw^.name),ADR(pw^.name));
    FPrintF (file,ADR("  DrawRast (%sWnd);\n"),ADR(pw^.name));
  END;

  IF (pw^.boxes.head^.succ#NIL) OR (pw^.windowText#NIL) THEN
    FPrintF (file, ADR("  rp:=%sWnd^.RPort;\n"), ADR(pw^.name));
  END;

  IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
    IF ~(I.BACKDROP <= pw^.windowFlags) THEN
      FPrintF2 (file, ADR("  offx := %sWnd^.BorderLeft;\n  offy := %sWnd^.BorderTop;\n\n"), ADR(pw^.name), ADR(pw^.name));
    ELSE
      FPutS (file, "  offx := 0;\n  offy := Scr^.WBorTop + Scr^.RastPort.TxHeight + 1;\n\n");
    END;

    IF pw^.boxes.head^.succ # NIL THEN
      IF mt.raster IN mt.MConfig THEN
        FPutS (file, "  g.SetAPen (rp,0);\n");
        box := pw^.boxes.head;
        WHILE box^.succ # NIL DO
          FPrintF4 (file, ADR("  g.RectFill (rp, offx+(%ld), offy+(%ld), offx+(%ld), offy+(%ld));\n"),
                    box^.left - bleft, box^.top - btop, (box^.left - bleft)+box^.width-1, (box^.top - btop)+box^.height-1);
          box := box^.succ;
        END;
        FPutS (file, "  g.SetAPen (rp,1);\n");
      END;
      box := pw^.boxes.head;
      WHILE box^.succ # NIL DO
        FPrintF4 (file, ADR("  gt.DrawBevelBox (rp, offx+(%ld), offy+(%ld), %ld, %ld,\n"),
                  box^.left - bleft, box^.top - btop, box^.width, box^.height);
        IF gtx.recessed IN box^.flags THEN
          FPutS (file,"                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);\n");
        ELSE
          FPutS (file,"                   gt.GT_VisualInfo, VisualInfo, u.TAG_DONE);\n");
        END;

        IF gtx.dropBox IN box^.flags THEN
          FPrintF4 (file, ADR("  gt.DrawBevelBox (rp, offx+(%ld), offy+(%ld), %ld, %ld,\n"),
                    box^.left - bleft + 4, box^.top - btop + 2, box^.width- 8, box^.height - 4);
          FPutS (file,"                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);\n");
        END;
        box := box^.succ;
      END;  (* WHILE box^.succ # NIL *)
    END;  (* IF pw^.boxes.head^.succ # NIL *)

    IF pw^.windowText # NIL THEN
      t := pw^.windowText; i := 0;
      FPrintF (file, ADR("\n  %sIText := [\n"), ADR(pw^.name));
      WHILE t # NIL DO
        FPrintF2 (file, ADR("    [%ld, %ld, "), t^.FrontPen, t^.BackPen);
        mt.WriteDrMd (t^.DrawMode);
        FPrintF4 (file, ADR(", %ld, %ld, y.ADR (%s%ld),\n"), t^.LeftEdge - bleft, t^.TopEdge - btop, ADR(fname), GuiData.font.ta_YSize);

        IF t^.NextText # NIL THEN
          FPrintF3 (file, ADR('      "%s", y.ADR (%sIText[%ld])],\n'), t^.IText, ADR(pw^.name), i+1);
        ELSE
          FPrintF (file, ADR('      "%s", NIL] ];\n'), t^.IText);
        END;
        t := t^.NextText;
        INC(i);
      END; (* WHILE *)
      FPrintF (file, ADR("  I.PrintIText (rp, y.ADR(%sIText[0]), offx, offy);\n"), ADR(pw^.name));
    END;
  ELSE
    IF (pw^.windowText#NIL) OR (pw^.boxes.head^.succ#NIL) THEN
      FPrintF2 (file, ADR("  ComputeFont (%sWidth, %sHeight);\n\n"), ADR(pw^.name), ADR(pw^.name));
    END;
    IF pw^.boxes.head^.succ # NIL THEN
      IF mt.raster IN mt.MConfig THEN
        FPutS (file, "  g.SetAPen (rp,0);\n");
        box := pw^.boxes.head;
        WHILE box^.succ # NIL DO
          FPrintF2 (file,ADR("  sx:=OffX+ComputeX(%ld); sy:=OffY+ComputeY(%ld);\n"),
                    box^.left-offx, box^.top-offy);
          FPrintF2 (file,ADR("  g.RectFill (rp, sx, sy, sx+ComputeX(%ld)-2, sy+ComputeY(%ld)-2 );\n"),
                    box^.width, box^.height);
          box := box^.succ;
        END;
        FPutS (file, "  g.SetAPen (rp,1);\n");
      END;
      box := pw^.boxes.head;
      WHILE box^.succ # NIL DO
        FPrintF4 (file,ADR("  gt.DrawBevelBox (rp, OffX+ComputeX(%ld), OffY+ComputeY(%ld),\n                       ComputeX(%ld), ComputeY(%ld),\n"),
                  box^.left - offx, box^.top - offy, box^.width, box^.height);
        IF gtx.recessed IN box^.flags THEN
          FPutS (file,"                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);\n");
        ELSE
          FPutS (file,"                   gt.GT_VisualInfo, VisualInfo, u.TAG_DONE);\n");
        END;
        IF gtx.dropBox IN box^.flags THEN
          FPrintF4 (file,ADR("  gt.DrawBevelBox(rp, OffX+ComputeX(%ld), OffY+ComputeY(%ld),\n                  ComputeX(%ld), ComputeY(%ld),\n"),
                    box^.left - offx + 4, box^.top - offy + 2, box^.width - 8, box^.height - 4);
          FPutS (file,"                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);\n");
        END;
        box := box^.succ;
      END; (* WHILE *)
    END;
    IF pw^.windowText # NIL THEN
      t := pw^.windowText; i := 0;
      FPrintF (file, ADR("\n  %sIText := [\n"), ADR(pw^.name));
      WHILE t # NIL DO
        FPrintF2 (file, ADR("    [%ld, %ld, "), t^.FrontPen, t^.BackPen);
        mt.WriteDrMd (t^.DrawMode);
        FPrintF (file, ADR(",0 ,OffY + ComputeY (%ld) - Font^.ta_YSize DIV 2, Font,\n"),
                 t^.TopEdge + GuiData.font.ta_YSize DIV 2 - btop);
        IF t^.NextText # NIL THEN
          FPrintF3 (file, ADR('      "%s", y.ADR (%sIText[%ld])],\n'), t^.IText, ADR(pw^.name), i+1);
        ELSE
          FPrintF (file, ADR('      "%s", NIL] ];\n'), t^.IText);
        END;
        t := t^.NextText;
        INC(i);
      END; (* WHILE *)
      t := pw^.windowText; i := 0;
      WHILE t # NIL DO
        alt:=t^.ITextFont;
        IF (alt=NIL) OR (alt^.ta_YSize<1) THEN
          t^.ITextFont:=ADR(GuiData.font);
          pos:=I.IntuiTextLength(t);
          t^.ITextFont:=alt;
        ELSE
          pos:=I.IntuiTextLength(t);
        END;
        FPrintF5 (file, ADR("  %sIText[%ld].LeftEdge:= OffX + ComputeX (%ld) - (I.IntuiTextLength (y.ADR(%sIText[%ld])) DIV 2);\n"),
                   ADR(pw^.name), i, t^.LeftEdge + pos DIV 2 - bleft, ADR(pw^.name), i);
        t := t^.NextText; INC(i);
      END; (* WHILE *)
      FPrintF (file, ADR("  I.PrintIText (rp, y.ADR(%sIText[0]), 0, 0);\n"), ADR(pw^.name));
    END;
  END;

  IF mt.raster IN mt.MConfig THEN
    FPutS (file, ' END;\n\n');
    IF pw^.gadgets.head^.succ # NIL THEN
      FPrintF2 (file,ADR('  I.RefreshGList (%sGList, %sWnd, NIL, -1);\n'),ADR(pw^.name),ADR(pw^.name));
    END;
    FPrintF (file,ADR('  gt.GT_RefreshWindow (%sWnd, NIL);\n\n'),ADR(pw^.name));
  END;

  FPrintF (file, ADR("END %sRender;\n\n"), ADR(pw^.name) );
END WriteRender;

(* --- Write the Modula SetupScreen() routine. *)
PROCEDURE WriteSetupScr (scr:BOOLEAN);
VAR fname: mt.str32;
    xsize, ysize: INTEGER;
    rp: G.RastPort;
    tf: G.TextFontPtr;
    str:STRING;
BEGIN
  st.strcpy (fname,GuiData.fontName);
  str:=st.strchr(fname,'.'); str^[0]:=0C;

  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
    tf := G.OpenFont (ADR(GuiData.font));
    IF tf = NIL THEN tf := df.OpenDiskFont (ADR(GuiData.font)) END;

    IF tf # NIL THEN
      G.InitRastPort (rp);
      G.SetFont (ADR(rp), tf);
      xsize := G.TextLength (ADR(rp),ADR("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"), 62) DIV 62;
      G.CloseFont (tf);
    ELSE
      xsize := GuiData.font.ta_YSize;
    END;

    ysize := GuiData.font.ta_YSize;
    IF scr THEN
      FPutS (fdef,"PROCEDURE ComputeX (value: INTEGER): INTEGER;\nPROCEDURE ComputeY (value: INTEGER): INTEGER;\n");
      FPutS (fdef,"PROCEDURE ComputeFont (width, height: INTEGER);\n");
    END;
    FPfile ("PROCEDURE ComputeX (value: INTEGER): INTEGER;\nBEGIN\n");
    FPrintF2(file, ADR("  RETURN ((FontX * value) + %ld ) DIV %ld;\n"), xsize DIV 2, xsize);
    FPfile ("END ComputeX;\n\nPROCEDURE ComputeY (value: INTEGER): INTEGER;\nBEGIN\n");
    FPrintF2 (file, ADR("  RETURN ((FontY * value)  + %ld ) DIV %ld;\n"), ysize DIV 2, ysize);
    FPfile ("END ComputeY;\n\nPROCEDURE ComputeFont (width, height: INTEGER);\n");
    IF ~(mt.SysFont IN mt.MConfig) THEN
      FPfile ("VAR x:INTEGER;\nBEGIN\n  Font := y.ADR (Attr);\n  Font^.ta_Name := Scr^.RastPort.Font^.tf_Message.mn_Node.ln_Name;\n");
      FPfile ("  FontY := Scr^.RastPort.Font^.tf_YSize;\n  Font^.ta_YSize := FontY;\n  FontX := Scr^.RastPort.Font^.tf_XSize;\n");
      FPfile ('  IF g.FPB_PROPORTIONAL IN Scr^.RastPort.Font^.tf_Flags THEN\n    x:=(g.TextLength (y.ADR(Scr^.RastPort),y.ADR("ABCDHKOP"),8)+7) DIV 8;\n');
      FPfile ("    IF x>=FontX THEN FontX:=x;\n                ELSE FontX:=(FontX+x) DIV 2; END;\n  END;\n\n");
    ELSE
      FPfile ("BEGIN\n  Font := y.ADR (Attr);\n  e.Forbid;\n");
      FPfile ("  Font^.ta_Name := g.GfxBase^.DefaultFont^.tf_Message.mn_Node.ln_Name;\n  FontY := g.GfxBase^.DefaultFont^.tf_YSize;\n");
      FPfile ("  Font^.ta_YSize := FontY;\n  FontX := g.GfxBase^.DefaultFont^.tf_XSize;\n  e.Permit;\n\n" );
    END;
(******        IF ((pw.windowFlags ADR( WFLGBACKDROP) = WFLGBACKDROP THEN
      FPfile ("  OffX := 0;\n");
    ELSE *******)
      FPfile ("  OffX := Scr^.WBorLeft;\n");
(*****        END; *******)
    FPfile ("  OffY := Scr^.RastPort.TxHeight + Scr^.WBorTop + 1;\n\n  IF (width # 0) AND (height # 0) AND\n     (ComputeX (width) + OffX + Scr^.WBorRight > Scr^.Width) OR\n");
    FPfile ('     (ComputeY (height) + OffY + Scr^.WBorBottom > Scr^.Height) THEN\n');
    FPfile ("    Font := y.ADR (Topaz80);\n");
    FPfile ("    FontY := 8; FontX := 8;\n  END;\nEND ComputeFont;\n\n");
  END;

  FPutS2 (ADR("PROCEDURE SetupScreen ("));
  IF gtx.Public IN GuiData.flags0 THEN
    FPutS2 (ADR("pub: y.STRING"));
  END;
  FPutS2 (ADR("): INTEGER;\n"));
  FPutS (file,"BEGIN\n");

  IF mt.CheckFont() THEN
    FPrintF2 (file, ADR("  Font := df.OpenDiskFont (y.ADR(%s%ld));\n"), ADR(fname), GuiData.font.ta_YSize);
    FPutS (file, "  IF Font = NIL THEN RETURN 3 END;\n");
  END;

  IF gtx.Workbench IN GuiData.flags0 THEN FPutS (file, '  Scr := I.LockPubScreen ("Workbench");\n');
  ELSIF gtx.Public IN GuiData.flags0 THEN FPutS (file, "  Scr := I.LockPubScreen (pub);\n");
  ELSIF gtx.Custom IN GuiData.flags0 THEN
    FPutS (file, "  Scr := I.OpenScreenTags (NIL,\n");
    FPrintF (file, ADR("            I.SA_Left,          %ld,\n"), GuiData.left);
    FPrintF (file, ADR("            I.SA_Top,           %ld,\n"), GuiData.top);
    FPrintF (file, ADR("            I.SA_Width,         %ld,\n"), GuiData.width);
    FPrintF (file, ADR("            I.SA_Height,        %ld,\n"), GuiData.height);
    FPrintF (file, ADR("            I.SA_Depth,         %ld,\n"), GuiData.depth);

    IF GuiData.colors[0].ColorIndex # -1 THEN
      FPutS (file, "            I.SA_Colors,        y.ADR (ScreenColors[0]),\n");
    END;

    IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
      FPrintF2 (file, ADR("            I.SA_Font,          y.ADR (%s%ld),\n"), ADR(fname), GuiData.font.ta_YSize);
    END;
    FPutS (file,"            I.SA_Type,          I.CUSTOMSCREEN,\n            I.SA_DisplayID,     ");
    mt.WriteIDFlags (CAST(LONGSET,GuiData.displayID));

    IF gtx.AutoScroll IN GuiData.flags0 THEN
      FPutS (file,"            I.SA_AutoScroll,    TRUE,\n            I.SA_Overscan,      I.OSCAN_TEXT,\n");
    END;

    FPutS (file, "            I.SA_Pens,          y.ADR (DriPens[0]),\n");
    IF st.strlen (GuiData.screenTitle) > 0 THEN
      FPrintF (file, ADR('            I.SA_Title,         "%s",\n'), ADR(GuiData.screenTitle));
    END;
    FPutS (file, "            u.TAG_DONE);\n");
  END;

  FPutS (file, "  IF Scr = NIL THEN RETURN 1 END;\n\n");

  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
    FPutS (file, "  ComputeFont (0, 0);\n\n");
  END;

  FPutS (file,"  VisualInfo := gt.GetVisualInfoA (Scr, NIL);\n  IF VisualInfo = NIL THEN RETURN 2 END;\n\n");

  IF mt.GetFilePresent THEN
    FPutS (file, "  IF gf.GetFileClass = NIL THEN RETURN 4 END;\n\n");
  END;

  FPutS (file, "  RETURN 0;\nEND SetupScreen;\n\n");
END WriteSetupScr;

(* --- Write the Modula Source file. *)
PROCEDURE WriteSource (scr,win:BOOLEAN);
CONST modstart1="MODULE %s;\n\n(*\n *  Source generated with %s\n *  ModGen is based on OG V37.11 by Thomas Igracki\n";
      modstart2=" *  OG is based on GenOberon V1.0 by Kai Bolay & Jan van den Baard\n *\n *  GUI generated with GadToolsBox by Jan van den Baard\n";
      modstart3=" *  GUI designed by : %s\n *)\n\nIMPORT\n  I:=Intuition, ";
VAR pw,help: gtx.ProjectWindowPtr;
    fname, ModuleName,ScreenNam: mt.str32;
    fnm: mt.Pstr256;
    pnum: INTEGER;
    str:STRING;
BEGIN
  st.strcpy(fname,GuiData.fontName);
  str:=st.strchr(fname,'.'); str^[0]:=0C;

  IF scr OR win THEN
    st.strcpy (Path,mt.screen);
    fnm := ADDRESS(d.PathPart (ADR(Path)));
    IF fnm # NIL THEN
      IF fnm^[0] = '/' THEN fnm:=mt.Pstr256(ADDRESS(fnm)+1); END;
      str := st.strchr(fnm^, '.');
      IF str#NIL THEN str^[0]:=0C; END;
      IF win THEN st.strcpy(ScreenNam,fnm^);
             ELSE st.strcpy(ModuleName,fnm^); END;
    END;
  END;

  IF NOT scr THEN
    st.strcpy(Path,mt.dest);
    (* Get the module name and delete the ".mod" extennsion if present. *)
    fnm := ADDRESS(d.PathPart (ADR(Path)));
    IF fnm # NIL THEN
      IF fnm^[0] = '/' THEN fnm:=mt.Pstr256(ADDRESS(fnm)+1); END;
      str := st.strchr(fnm^, '.');
      IF str#NIL THEN str^[0] := 0C; END;
      st.strcpy(ModuleName,fnm^);
    END;
  END;
  st.strcat (Path,".mod");
  file := OpenSafe (Path);
  IF (file # NIL) AND (file # CAST(d.FileHandlePtr,4)) THEN
   saveicon (Path);
   str:=st.strrchr(Path,"."); str^[0]:=0C;
   st.strcat (Path,".def");
   fdef:=d.Open (ADR(Path), d.MODE_NEWFILE);
   IF fdef#NIL THEN
    saveicon (Path);
    startSave (TRUE);
    d.SetIoErr (0);
    mt.CheckGetFile();  (* GetFile and ListView *)
    IF scr THEN
      help:=mt.Projects.head^.succ; mt.Projects.head^.succ:=NIL;
    END;
    FPutS (file,"IMPLEMENTATION ");
    FPutS (fdef,"DEFINITION ");

    FPrintF2 (file,ADR(modstart1),ADR(ModuleName), ADR(VERSION[6]));
    FPutS    (file,modstart2);
    FPrintF  (file,ADR(modstart3), ADR(MainConfig.userName));
    FPrintF2 (fdef,ADR(modstart1),ADR(ModuleName), ADR(VERSION[6]));
    FPutS    (fdef,modstart2);
    FPrintF  (fdef,ADR(modstart3), ADR(MainConfig.userName));
    IF mt.CheckFont() OR (gtx.FontAdapt IN MainConfig.configFlags0) OR
       (NOT (gtx.FontAdapt IN MainConfig.configFlags0) AND scr) THEN
      FPutS (fdef,"g:=Graphics, ");
    END;
    IF scr AND (mt.port IN mt.MConfig) THEN FPutS (fdef,"u:=Utility, "); END;
    FPutS (file, "gt:=GadTools, u:=Utility, g:=Graphics, ");

    IF mt.ListViewPresent OR ((gtx.FontAdapt IN MainConfig.configFlags0) AND
       (mt.SysFont IN mt.MConfig)) OR ((scr OR NOT win) AND (mt.port IN mt.MConfig)) THEN
      FPutS (file, "e:=Exec, ");
      IF (scr OR NOT win) AND (mt.port IN mt.MConfig) THEN FPutS (file,"al:=AmigaLib, "); END;
    END;
    IF mt.CheckFont() OR (mt.SysFont IN mt.MConfig) THEN
      FPutS (file, "df:=DiskFont, ");
    END;
    IF gtx.Custom IN GuiData.flags0 THEN FPutS (file, "m:=ModeKeys, "); END;
    pnum:=0;
    pw := mt.Projects.head;
    WHILE (pw^.succ#NIL) AND (pnum=0) DO
      IF pw^.gadgets.head^.succ#NIL THEN pnum:=1; END;
      pw := pw^.succ;
    END;
    IF ((scr OR NOT win) AND (mt.port IN mt.MConfig)) OR (pnum=1) THEN
      FPutS (file, "C:=Classes, ");
    END;
    IF mt.GetFilePresent THEN FPutS (file, "gf:=GetFile, "); END;
    IF mt.raster IN mt.MConfig THEN FPutS (file, "gfx:=GfxMacros, "); END;
    IF scr OR NOT win THEN FPutS (file,"m2:=M2Lib, "); END;
    FPutS2 (ADR("y:=SYSTEM;\n"));
    IF win THEN
      FPrintF (file,ADR("FROM %s IMPORT Scr,VisualInfo,SetupScreen,CloseDownScreen"),ADR(ScreenNam));
      IF mt.CheckFont() THEN FPutS (file,",Font"); END;
      IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        FPutS (file,",Font,Attr,OffX,OffY,ComputeX,ComputeY,ComputeFont");
      ELSE
        FPrintF2 (file, ADR(",%s%ld"), ADR(fname),GuiData.font.ta_YSize);
      END;
      IF mt.raster IN mt.MConfig THEN
        FPutS (file,",DrawRast");
      END;
      IF mt.port IN mt.MConfig THEN
        FPutS (file,",CloseWindow,OpenWindowTags");
      END;
      FPutS (file,",GetMem;\n");
    END;
    IF NOT scr THEN
      FPutS (fdef,"\nCONST\n");
      FPutS (file,"\n");
      mt.WriteID();
    END;

    mt.WriteGlob (scr,win);
    IF NOT scr THEN
      mt.WriteLabels (FALSE);
      IF mt.ListViewPresent THEN mt.WriteList(); END;
    END;
    IF (NOT win) AND  ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
      mt.WriteTextAttr(scr,FALSE)
    END;
    IF NOT scr THEN
      mt.WriteIText();
      mt.WriteMenus (FALSE);
      mt.WriteGTypes (FALSE);
      mt.WriteGArray (FALSE);
      mt.WriteGTags (FALSE);
    END;

    IF NOT win THEN
      IF (gtx.Custom IN GuiData.flags0) THEN
        mt.WriteSTags(FALSE);
      END;

      FPutS (file,"\n");
      WriteSetupScr (scr);
      WriteScrCleanup();

      IF mt.raster IN mt.MConfig THEN
        IF scr THEN FPutS (fdef,"PROCEDURE DrawRast (win: I.WindowPtr);\n"); END;
        FPfile ("PROCEDURE DrawRast (win: I.WindowPtr);\n");
        FPfile ("TYPE PattType = ARRAY [0..1] OF CARDINAL;\n");
        FPfile ("VAR backPatt : PattType;\n");
        FPfile ("BEGIN\n");
        FPfile ("  backPatt := [0AAAAH,05555H];\n");
        FPfile ("  g.SetAPen (win^.RPort, 2);\n");
        FPfile ("  gfx.SetAfPt (win^.RPort, y.ADR(backPatt),1);\n");
        FPfile ("  IF I.GIMMEZEROZERO <= win^.Flags THEN\n");
        FPfile ("    g.RectFill(win^.RPort,0,0,win^.GZZWidth,win^.GZZHeight);\n");
        FPfile ("  ELSE\n");
        FPfile ("    g.RectFill(win^.RPort, win^.BorderLeft,win^.BorderTop,\n");
        FPfile ("               win^.Width-win^.BorderLeft-1, win^.Height-win^.BorderBottom-1);\n");
        FPfile ("  END;\n");
        FPfile ("  gfx.SetAfPt (win^.RPort, NIL,0);\n");
        FPfile ("END DrawRast;\n\n");
      END;
    ELSE FPutS (file,"\n"); END;

    IF (scr OR NOT win) AND (mt.port IN mt.MConfig) THEN
      IF scr THEN
        FPutS (fdef,
          "PROCEDURE CloseWindow (win:I.WindowPtr);\nPROCEDURE OpenWindowTags (nw:I.NewWindowPtr;tag1:LONGINT;..):I.WindowPtr;\n");
      END;
      FPfile ("VAR IdcmpPort:e.MsgPortPtr;\n\n");
      FPfile ("PROCEDURE CloseWindow (win:I.WindowPtr);\n");
      FPfile ("VAR msg,succ:I.IntuiMessagePtr;\n");
      FPfile ("BEGIN\n");
      FPfile ("  e.Forbid;\n");
      FPfile ("  msg:=y.CAST(I.IntuiMessagePtr,win^.UserPort^.mp_MsgList.lh_Head);\n");
      FPfile ("  WHILE msg^.ExecMessage.mn_Node.ln_Succ#NIL DO\n");
      FPfile ("    succ:=y.CAST(I.IntuiMessagePtr,msg^.ExecMessage.mn_Node.ln_Succ);\n");
      FPfile ("    IF msg^.IDCMPWindow=win THEN\n");
      FPfile ("      e.Remove (y.ADDRESS(msg));\n");
      FPfile ("      e.ReplyMsg (msg);\n");
      FPfile ("    END;\n");
      FPfile ("    msg:=succ;\n");
      FPfile ("  END;\n");
      FPfile ("  win^.UserPort:=NIL;\n");
      FPfile ("  I.ModifyIDCMP (win,{});\n");
      FPfile ("  e.Permit;\n");
      FPfile ("  I.CloseWindow (win);\n");
      FPfile ("END CloseWindow;\n\n");
      FPfile ("PROCEDURE OpenWindowTags (nw:I.NewWindowPtr;tag1:LONGINT;..):I.WindowPtr;\n");
      FPfile ("VAR idcmp:LONGCARD;\n");
      FPfile ("    win:I.WindowPtr;\n");
      FPfile ("    buf:ARRAY [0..1] OF LONGINT;\n");
      FPfile ("BEGIN\n");
      FPfile ("  buf:=[I.WA_IDCMP,u.TAG_DONE];\n");
      FPfile ("  idcmp:=u.GetTagData (I.WA_IDCMP,0,y.ADR(tag1));\n");
      FPfile ("  IF (idcmp#0) AND (IdcmpPort=NIL) THEN RETURN NIL;\n");
      FPfile ("  ELSE\n");
      FPfile ("    u.FilterTagItems(y.ADR(tag1),y.ADR(buf),u.TAGFILTER_NOT);\n");
      FPfile ("    win:=I.OpenWindowTagList (nw,y.ADR(tag1));\n");
      FPfile ("    IF (win#NIL) AND (idcmp#0) THEN\n");
      FPfile ("      win^.UserPort:=IdcmpPort;\n");
      FPfile ("      I.ModifyIDCMP (win,LONGSET(idcmp));\n");
      FPfile ("    END;\n");
      FPfile ("    RETURN win;\n");
      FPfile ("  END;\n");
      FPfile ("END OpenWindowTags;\n\n");
    END;

    pw := mt.Projects.head; pnum := 0;
    WHILE pw^.succ # NIL DO
      mt.CheckItOut (pw);  (* GETFILE, joined LISTVIEWS ? *)

      (* Both texts and boxes are supported with or without font-adapt. *)

      IF (pw^.windowText # NIL) OR (pw^.boxes.head^.succ # NIL) OR (mt.raster IN mt.MConfig) THEN
        WriteRender(pw);
      END;

      IF pw^.gadgets.head^.succ # NIL THEN
        mt.WriteGadHeader(pw);

        mt.WriteNodes (pw, pnum);

        IF mt.GetFileInWindow THEN
          FPrintF (file, ADR("  %sGetImage := C.NewObject (gf.GetFileClass,NIL,gt.GT_VisualInfo,VisualInfo,\n"), ADR(pw^.name));
          IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
            FPutS(file,"                                   C.IA_Width,ComputeX(20),C.IA_Height,ComputeY(14),");
          END;
          FPrintF (file, ADR("u.TAG_DONE);\n  IF %sGetImage = NIL THEN RETURN 7 END;\n\n"), ADR(pw^.name));
        END;

        FPrintF (file, ADR("  gad := gt.CreateContext (%sGList);\n"), ADR(pw^.name));
        FPutS (file, "  IF gad = NIL THEN RETURN 1 END;\n\n");

        mt.WriteGadgets(pw);

        FPrintF  (file, ADR("\n  RETURN 0;\nEND Create%sGadgets;\n\n"), ADR(pw^.name));
      END;

      mt.WriteHeader(pw);

      IF pw^.menus.head^.succ # NIL THEN
        FPrintF2 (file, ADR("  %sMenus := gt.CreateMenus (%sNewMenu^, gt.GTMN_FrontPen, 0, u.TAG_DONE);\n"), ADR(pw^.name), ADR(pw^.name));
        FPrintF (file, ADR("  IF %sMenus = NIL THEN RETURN 3 END;\n\n"), ADR(pw^.name));
        FPrintF (file, ADR("  IF NOT gt.LayoutMenus (%sMenus, VisualInfo, gt.GTMN_NewLookMenus, TRUE, "), ADR(pw^.name));
        IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
          FPrintF2 (file, ADR("gt.GTMN_TextAttr, y.ADR (%s%ld), u.TAG_DONE) THEN RETURN 4 END;\n\n"), ADR(fname), GuiData.font.ta_YSize);
        ELSE
          FPutS (file, "u.TAG_DONE) THEN RETURN 4 END;\n\n");
        END;
      END;

      IF ~(I.WINDOWSIZING <= pw^.windowFlags) THEN
        IF gtx.Zoom IN pw^.tagFlags THEN
          FPrintF4 (file, ADR("  %sZoom[0] := %sLeft;\n  %sZoom[1] := %sTop;\n"), ADR(pw^.name), ADR(pw^.name),  ADR(pw^.name), ADR(pw^.name));
        ELSIF gtx.DefaultZoom IN pw^.tagFlags THEN
          FPrintF2 (file, ADR("  %sZoom[0] := 0;\n  %sZoom[1] := 0;\n"), ADR(pw^.name), ADR(pw^.name));
        END;
        IF LONGSET{gtx.Zoom,gtx.DefaultZoom} * pw^.tagFlags # LONGSET{} THEN
          FPrintF3 (file, ADR('  %sZoom[2] := g.TextLength (y.ADR (Scr^.RastPort), y.ADR("%s"), %ld) + 80;\n'), ADR(pw^.name), ADR(pw^.windowTitle[0]), st.strlen (pw^.windowTitle));
          FPrintF (file, ADR("  %sZoom[3] := Scr^.WBorTop + Scr^.RastPort.TxHeight + 1;\n\n"), ADR(pw^.name));
        END;
      END;

      mt.WriteWindow(pw);

      IF pw^.menus.head^.succ # NIL THEN
        FPrintF2 (file, ADR("  IF NOT I.SetMenuStrip (%sWnd, %sMenus) THEN RETURN 6 END;\n"), ADR(pw^.name), ADR(pw^.name));
      END;

      (* Both texts and boxes are supported with or without font-adapt. *)

      IF (mt.raster IN mt.MConfig) AND (pw^.gadgets.head^.succ#NIL) THEN
        FPrintF2 (file,ADR("  ret:=I.AddGList (%sWnd,%sGList,-1,-1,NIL);\n"), ADR(pw^.name), ADR(pw^.name));
      END;
      IF (pw^.windowText # NIL) OR (pw^.boxes.head^.succ # NIL) OR (mt.raster IN mt.MConfig) THEN
        FPrintF (file, ADR("  %sRender;\n\n"), ADR(pw^.name));
      END;
      IF NOT (mt.raster IN mt.MConfig) THEN
        FPrintF (file, ADR("  gt.GT_RefreshWindow (%sWnd, NIL);\n\n"), ADR(pw^.name));
      END;
      FPrintF  (file, ADR("  RETURN 0;\nEND Open%sWindow;\n\n"), ADR(pw^.name));

      WriteCleanup(pw);
      pw := pw^.succ; INC(pnum);
    END; (* WHILE *)

    IF (scr OR NOT win) THEN
      IF scr THEN
        FPutS (fdef,"PROCEDURE GetMem (size:LONGINT):y.ADDRESS;\n");
      END;
      FPfile ("PROCEDURE GetMem (size:LONGINT):y.ADDRESS;\n");
      FPfile ("VAR ptr:y.ADDRESS;\n");
      FPfile ("BEGIN\n");
      FPfile ("  ptr:=m2.malloc (size);\n");
      FPfile ('  IF ptr=NIL THEN m2._ErrorReq ("Not enought Memory"," "); END;\n');
      FPfile ("  RETURN ptr;\n");
      FPfile ("END GetMem;\n\n");
    END;
    IF (scr OR NOT win) AND  ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
      mt.WriteTextAttr (scr,TRUE);
    ELSE
      FPfile ("BEGIN\n");
    END;
    IF NOT win AND (gtx.FontAdapt IN MainConfig.configFlags0) THEN
      FPfile ('  Topaz80:=[y.ADR ("topaz.font"),8];\n');
    END;
    IF NOT win AND (gtx.Custom IN GuiData.flags0) THEN
      mt.WriteSTags (TRUE);
    END;
    IF win OR NOT scr THEN
      mt.WriteLabels (TRUE);
      IF NOT scr THEN
        mt.WriteMenus (TRUE);
        mt.WriteGTypes (TRUE);
        mt.WriteGArray (TRUE);
        mt.WriteGTags (TRUE);
      END;
      mt.InitCoords;
    END;
    IF (scr OR NOT win) AND (mt.port IN mt.MConfig) THEN
      FPutS (file,'  IdcmpPort:=al.CreatePort (y.ADR(""),0);\n');
      FPfile ("CLOSE\n");
      FPfile ("  IF IdcmpPort#NIL THEN\n");
      FPfile ("    al.DeletePort (IdcmpPort); IdcmpPort:=NIL;\n");
      FPfile ("  END;\n");
    END;
    FPrintF (file, ADR("END %s.\n"), ADR(ModuleName));
    FPrintF (fdef, ADR("\nEND %s.\n"), ADR(ModuleName));

    IF scr THEN mt.Projects.head^.succ:=help; END;
    startSave (FALSE);

    IF d.IoErr() > 0 THEN Request (ADR("Error: write error"),NIL); END;
    d.Close (fdef); fdef := NIL;
   ELSE
    Request (ADR("Error: unable to open %s"),ADR(Path));
   END;
   d.Close (file); file := NIL;
  ELSIF file=NIL THEN
   Request (ADR("Error: unable to open %s"),ADR(Path));
  ELSE file:=NIL; END;
END WriteSource;

VAR ende:BOOLEAN;
    ptr,ptr2:ADDRESS;
    pw: gtx.ProjectWindowPtr;
    start,end:INTEGER;
    error:LONGINT;
BEGIN
  VERSION := '$VER: ModGen V1.0 (17.4.95) by Frank Lömker';
  geladen:=FALSE; mt.source:=""; mt.dest:=""; mt.screen:="";
  mt.MConfig:=LONGSET{}; mt.args.nogui:=d.DOSFALSE;
  chain:=nf.GetMemoryChain(4096);
  IF chain # NIL THEN
    IF NOT wbStarted THEN
      RD := d.ReadArgs (ADR(tmp),ADR(mt.args), NIL);
      IF RD # NIL THEN
        IF (mt.args.nogui=d.DOSTRUE) AND
           ((mt.args.name=NIL) OR (mt.args.baseName=NIL)) THEN
          d.VPrintf(ADR("NOGUI only possible if Source and Dest are given\n"),NIL);
          RETURN 10;
        END;
      ELSE
        IF d.PrintFault (d.IoErr(),ADR("Error")) THEN END; RETURN 10;
      END;
      d.Printf (ADR("%s.\n Based on Thomas Igracki's OG V37.11\n      and Kai Bolay's GenOberon V1.0.\n"),
                ADR(VERSION[6]) );
      IF mt.args.name#NIL THEN st.strcpy(mt.source,mt.args.name^); END;
      IF mt.args.baseName#NIL THEN st.strcpy(mt.dest,mt.args.baseName^); END;
      IF mt.args.screenPtr#NIL THEN st.strcpy(mt.screen,mt.args.screenPtr^); END;
      IF mt.args.nogui=d.DOSTRUE THEN
        IF mt.args.openfont=d.DOSTRUE THEN INCL (mt.MConfig,mt.GenOpenFont); END;
        IF mt.args.sysfont=d.DOSTRUE THEN INCL (mt.MConfig,mt.SysFont); END;
        IF mt.args.raster=d.DOSTRUE THEN INCL (mt.MConfig,mt.raster); END;
        IF mt.args.mouse=d.DOSTRUE THEN INCL (mt.MConfig,mt.mouse); END;
        IF mt.args.port=d.DOSTRUE THEN INCL (mt.MConfig,mt.port); END;
        IF mt.args.icon=d.DOSTRUE THEN INCL (mt.MConfig,mt.icon); END;
        IF mt.args.opts#NIL THEN
          FOR start:=0 TO st.strlen(mt.args.opts^)-1 DO
            CASE CAP(mt.args.opts^[start]) OF
              "O": INCL (mt.MConfig,mt.GenOpenFont);
             |"S": INCL (mt.MConfig,mt.SysFont);
             |"R": INCL (mt.MConfig,mt.raster);
             |"U": INCL (mt.MConfig,mt.mouse);
             |"P": INCL (mt.MConfig,mt.port);
             |"I": INCL (mt.MConfig,mt.icon);
            ELSE
            END;
          END;
        END;
      END;  (* IF nogui *)
    END;  (* IF NOT wbStarted *)
    IF mt.args.nogui=d.DOSTRUE THEN
      error:=gtx.GTX_LoadGUI (chain,mt.args.name,
                             gtx.rgGUI,ADR(GuiData),
                             gtx.rgConfig,ADR(MainConfig),
                             gtx.rgWindowList,ADR(mt.Projects),
                             gtx.rgValid,ADR(ValidBits), u.TAG_DONE);
      geladen:=TRUE;
      IF error=0 THEN
        WriteSource(FALSE,FALSE);
      ELSE
        CASE error OF
          | gtx.ErrorNoMem:      ptr:=ADR("Error: out of memory\n");
          | gtx.ErrorOpen:       ptr:=ADR("Error: unable to open the GUI file\n");
          | gtx.ErrorRead:       ptr:=ADR("Error: read error\n");
          | gtx.ErrorWrite:      ptr:=ADR("Error: write error\n");
          | gtx.ErrorParse:      ptr:=ADR("Error: iffparse.library error\n");
          | gtx.ErrorPacker:     ptr:=ADR("Error: unable to decrunch the file\n");
          | gtx.ErrorPPLib:      ptr:=ADR("Error: the file is crunched and the powerpacker.library is not available\n");
          | gtx.ErrorNotGUIFile: ptr:=ADR("Error: not a GUI file\n");
        ELSE
          ptr:=ADR("Unknown error\n");
        END;
        d.VPrintf (ptr,NIL);
      END;
    ELSE
      InitReq;
      REPEAT
        ende:=OpenReq(start,end);
        IF NOT ende THEN
          IF start=-1 THEN WriteSource(FALSE,FALSE);
          ELSE
            IF start=0 THEN
              WriteSource(TRUE,FALSE);
              INC (start);
            END;
            IF start<=end THEN
              end:=end-start;
              pw:=mt.Projects.head; ptr:=mt.Projects.head;
              WHILE start>1 DO
                pw:=pw^.succ; DEC (start);
              END;
              mt.Projects.head:=pw;
              WHILE end>=0 DO
                pw:=pw^.succ; DEC (end);
              END;
              ptr2:=pw^.succ; pw^.succ:=NIL;
              WriteSource(FALSE,TRUE);
              mt.Projects.head:=ptr; pw^.succ:=ptr2;
            END;
          END;
        END;
      UNTIL ende;
    END;  (* IF nogui *)
  ELSE
    Request (ADR("Error: Out of memory"),NIL);
  END;  (* IF chain # NIL *)
CLOSE
  IF geladen THEN
    gtx.GTX_FreeWindows (chain, mt.Projects); geladen:=FALSE;
  END;
  IF chain # NIL THEN nf.FreeMemoryChain (chain,TRUE); chain:=NIL; END;
  IF RD    # NIL THEN d.FreeArgs(RD); RD:=NIL; END;
  IF fdef  # NIL THEN d.Close (fdef); fdef := NIL; END;
  IF file  # NIL THEN d.Close (file); file := NIL; END;
END ModGen.
