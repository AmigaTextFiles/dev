(*---------------------------------------------------------------------------
  :Program.    MGRequest.mod
  :Contents.   Oberfläche für ModGen
  :Author.     Frank Lömker
  :Copyright.  FreeWare
  :Language.   Modula-2
  :Translator. Turbo Modula-2 V1.40
  :Imports.    NoFragLib,GadToolsBox[Jan van den Baard],ReqTools[Nico François]
  :Imports.    MGTools, MGGui, ReqToolsSupport [Frank]
  :History.    1.0 [Frank] 17-Apr-95
  :History.        ModGen basiert direkt auf OG V37.11 von Thomas Igracki
  :History.        und GenOberon V1.0 von Kai Bolay und Jan van den Baard.
  :Bugs.       keine bekannt
---------------------------------------------------------------------------*)

IMPLEMENTATION MODULE MGRequest;

FROM SYSTEM IMPORT LONGSET,ADR,CAST,ADDRESS,STRING,MAKEID;
FROM M2Lib IMPORT wbStarted,_ErrorReq;
FROM Workbench IMPORT DiskObjectPtr,NO_ICON_POSITION,WBMsg;
FROM Icon IMPORT GetDiskObject,FreeDiskObject,PutDiskObject;
FROM ReqTools IMPORT rtEZRequestTags;
FROM MGTools IMPORT MConfig;
IMPORT y:=SYSTEM, g:=MGgui, mt:=MGTools, e:=Exec, d:=Dos, I:=Intuition,
       gt:=GadTools, u:=Utility, w:=Workbench, C:=Classes,
       rt:=ReqTools, gtx:=GadToolsBox,
       st:=String;

TYPE str7=ARRAY [0..6] OF CHAR;
     str40=ARRAY [0..40] OF CHAR;
     str60=ARRAY [0..60] OF CHAR;
     Pstr60=POINTER TO str60;
     TScrNode=RECORD
                succ,pred:ADDRESS; pad:INTEGER;
                name:ADDRESS; str:str7;
              END;
     TConHead=RECORD
                form,size,pref:LONGINT;
                vers,versSize:LONGINT;
                version:CARDINAL;
                genm,genmSize:LONGINT;
              END;
VAR ScrNode:TScrNode;
    ConHead:TConHead;
    filereq:rt.FileRequesterPtr;
    patGui,patMod:ARRAY [0..60] OF CHAR;
    lock:LONGINT;

PROCEDURE Request (text,data:ADDRESS);
VAR ptr:ADDRESS;
BEGIN
  IF mt.args.nogui=d.DOSFALSE THEN
    ptr:=ADR(data);
    rtEZRequestTags (text,ADR("_OK"),NIL,ptr,
                     rt.Window,g.MGWnd,rt.ezReqTitle,ADR("ModGen V1.0"),
                     rt.LockWindowTag,TRUE,rt.Underscore,"_",
                     rt.ezFlags,LONGSET{rt.ezReqCenterText},u.TAG_DONE);
  ELSE
    d.VPrintf (text,ADR(data));
    d.VPrintf (ADR("\n"),NIL);
  END;
END Request;

PROCEDURE Overwrite (name: (*@N*)ARRAY OF CHAR): BOOLEAN;
VAR ptr,ptr2:ADDRESS;
BEGIN
  ptr:=ADR(name); ptr2:=ADR(ptr);
  IF mt.args.nogui=d.DOSFALSE THEN
    RETURN rtEZRequestTags (ADR('"%s" already exists!\nOverwrite?'),ADR("_Yes|_No"),NIL,ptr2,
                      rt.Window,g.MGWnd,rt.ezReqTitle,ADR("ModGen Request"),
                      rt.LockWindowTag,TRUE,rt.Underscore,"_",
                      rt.ezFlags,LONGSET{rt.ezReqCenterText},u.TAG_DONE)#0;
  ELSE
    RETURN rtEZRequestTags (ADR('"%s" already exists!\nOverwrite?'),ADR("_Yes|_No"),NIL,ptr2,
                      rt.ezReqTitle,ADR("ModGen Request"),
                      rt.Underscore,"_",
                      rt.ezFlags,LONGSET{rt.ezReqCenterText},u.TAG_DONE)#0;
  END;
END Overwrite;

(* Open a file carefully. *)
PROCEDURE OpenSafe (name: (*@N*)ARRAY OF CHAR): d.FileHandlePtr;
VAR handle: d.FileHandlePtr;
BEGIN
  handle := d.Open (ADR(name), d.MODE_OLDFILE);
  IF handle # NIL THEN
    d.Close (handle);
    IF NOT Overwrite (name) THEN RETURN CAST(d.FileHandlePtr,4); END;
  END;
  RETURN d.Open (ADR(name), d.MODE_NEWFILE);
END OpenSafe;

PROCEDURE startSave (start:BOOLEAN);
CONST titel="Saving Modula Source...";
BEGIN
  IF mt.args.nogui=d.DOSFALSE THEN
    IF start THEN
      I.SetWindowTitles (g.MGWnd,ADR(titel),ADDRESS(-1));
      lock:=rt.rtLockWindow (g.MGWnd);
    ELSE
      I.SetWindowTitles (g.MGWnd,ADR("ModGen V1.0"),ADDRESS(-1));
      rt.rtUnlockWindow (g.MGWnd,lock);
    END;
  ELSE
    IF start THEN
      d.VPrintf (ADR(titel),NIL);
      d.VPrintf (ADR("\n"),NIL);
    END;
  END;
END startSave;

PROCEDURE Enable (id:INTEGER);
BEGIN
  gt.GT_SetGadgetAttrs (g.MGGadgets[id],g.MGWnd,NIL,
                        C.GA_Disabled,FALSE,u.TAG_DONE);
END Enable;

PROCEDURE Disable (id:INTEGER);
BEGIN
  gt.GT_SetGadgetAttrs (g.MGGadgets[id],g.MGWnd,NIL,
                        C.GA_Disabled,TRUE,u.TAG_DONE);
END Disable;

PROCEDURE Showtext (id:INTEGER;text:ADDRESS);
BEGIN
  gt.GT_SetGadgetAttrs (g.MGGadgets[id],g.MGWnd,NIL,
                        gt.GTST_String,text,u.TAG_DONE);
END Showtext;

PROCEDURE FileReq (VAR name:ARRAY OF CHAR;id:INTEGER;save:BOOLEAN):BOOLEAN;
CONST titGui="Open GUI";
      titMod="Save Modula Source As";
      titScr="Save Screen Source As";
VAR ptr,tit,help:Pstr60;
    file,dir:mt.str256;
BEGIN
  IF id=g.GDSource THEN
    ptr:=ADR(patGui); tit:=ADR(titGui);
  ELSE
    ptr:=ADR(patMod);
    IF id=g.GDDest THEN tit:=ADR(titMod);
                   ELSE tit:=ADR(titScr); END;
  END;
  IF save THEN INCL (filereq^.flags,rt.fReqSave);
          ELSE EXCL (filereq^.flags,rt.fReqSave); END;
  st.strcpy (dir,name);
  st.strcpy (file,d.FilePart(ADR(dir)));
  help:=ADDRESS(d.PathPart(ADR(dir))); help^[0]:=0C;
  rt.rtChangeReqAttr (filereq,rt.fiDir,ADR(dir),
                              rt.fiMatchPat,ptr,u.TAG_DONE);
  IF rt.rtFileRequest (filereq, ADR(file),STRING(tit),
               rt.Window,g.MGWnd,rt.LockWindowTag,TRUE,
               rt.ReqPos,rt.ReqPosPointer,u.TAG_DONE) THEN
    st.strcpy (name,filereq^.dir);
    IF d.AddPart (ADR(name),ADR(file),HIGH(name)+1) THEN END;
    st.strcpy (ptr^,filereq^.matchPat);
    ptr:=ADR(name);
    Showtext (id,ptr);
    RETURN TRUE;
  END;
  RETURN FALSE;
END FileReq;

PROCEDURE about;
CONST s1="ModGen V1.0, (c) 1995 by Frank Lömker\n\nTurbo Modula-2 SourceCodeGenerator for GadToolsBox\n(c) by Jan van den Baard\n\n";
      s2="Based on OG V37.11 (c) by Thomas Igracki\nand GenOberon V1.0 (c) by Kai Bolay &\nJan van den Baard\n\n";
      s3="Written using Turbo Modula-2 (c) by Amritpal Mann\n\nreqtools.library (c) by Nico François";
VAR str:ARRAY [1..116+98+88+3] OF CHAR;
BEGIN
  str:=s1;
  st.strcat (str,s2);
  st.strcat (str,s3);
  Request (ADR(str),NIL);
(*  Request (ADR("ModGen V1.0, (c) 1995 by Frank Lömker\n\n"
               "Turbo Modula-2 SourceCodeGenerator for GadToolsBox\n"
               "(c) by Jan van den Baard\n\n"
               "Based on OG V37.11 (c) by Thomas Igracki\n"
               "and GenOberon V1.0 (c) by Kai Bolay &\n"
               "Jan van den Baard\n\n"
               "Written using Turbo Modula-2 (c) by Amritpal Mann\n\n"
               "reqtools.library (c) by Nico François"),NIL); *)
END about;

PROCEDURE saveicon (name:(*@N*)ARRAY OF CHAR);
CONST IconName="modula:Icons/txt";
      IError='Unable to load Icon\n"modula:Icons/txt"';
VAR icon:DiskObjectPtr;
BEGIN
  IF mt.icon IN MConfig THEN
    icon:=GetDiskObject (ADR(name));  (* Icon schon da ? *)
    IF icon=NIL THEN
      icon:=GetDiskObject (ADR(IconName));
      IF icon#NIL THEN
        icon^.do_CurrentX:=NO_ICON_POSITION;
        icon^.do_CurrentY:=NO_ICON_POSITION;
        IF NOT PutDiskObject (ADR(name),icon) THEN
          Request (ADR('Unable to save Icon for\n"%s"'),ADR(name));
          FreeDiskObject (icon);
        END;
        FreeDiskObject (icon);
      ELSE
        Request (ADR(IError),NIL);
      END;
    ELSE
      FreeDiskObject (icon);
    END;  (* IF icon=NIL *)
  END;  (* IF icon *)
END saveicon;

PROCEDURE ZeigListe (source:(*@N*)mt.str256);
VAR error:LONGINT;
    ptr:ADDRESS;
BEGIN
  lock:=rt.rtLockWindow (g.MGWnd);
  IF geladen THEN
    e.RemHead (ADR(mt.Projects));
    gtx.GTX_FreeWindows (chain, mt.Projects); geladen:=FALSE
  END;
  IF source[0]#0C THEN
    error:=gtx.GTX_LoadGUI (chain,ADR(source),
                        gtx.rgGUI,ADR(mt.GuiData),
                        gtx.rgConfig,ADR(mt.MainConfig),
                        gtx.rgWindowList,ADR(mt.Projects),
                        gtx.rgValid,ADR(ValidBits), u.TAG_DONE);
    geladen:=TRUE;
    IF error=0 THEN
      ptr:=ADR(mt.Projects);
      e.AddHead (ADR(mt.Projects),ADR(ScrNode));
    ELSE
      ptr:=NIL;
      Request (ADR('Unable to load\n"%s"'),ADR(source));
    END;
  ELSE ptr:=NIL; END;
  gt.GT_SetGadgetAttrs (g.MGGadgets[g.GDWindows],g.MGWnd,NIL,
                        gt.GTLV_Labels,ptr,u.TAG_DONE);
  gt.GT_SetGadgetAttrs (g.MGGadgets[g.GDTfrom],g.MGWnd,NIL,
                        gt.GTTX_Text,NIL,u.TAG_DONE);
  gt.GT_SetGadgetAttrs (g.MGGadgets[g.GDTto],g.MGWnd,NIL,
                        gt.GTTX_Text,NIL,u.TAG_DONE);
  IF ptr=NIL THEN
    Disable (g.GDAll); Enable (g.GDFont); Enable (g.GDSys);
  ELSE
    Enable (g.GDAll);
    IF gtx.FontAdapt IN mt.MainConfig.configFlags0 THEN
      Disable (g.GDFont); Enable (g.GDSys);
    ELSE
      Enable (g.GDFont); Disable (g.GDSys);
    END;
  END;
  Disable (g.GDSelect);
  rt.rtUnlockWindow (g.MGWnd,lock);
END ZeigListe;

PROCEDURE FindNode(nr:INTEGER):mt.Pstr256;
VAR pw: gtx.ProjectWindowPtr;
BEGIN
  pw := mt.Projects.head;
  WHILE nr>0 DO
    pw := pw^.succ; DEC (nr);
  END;
  RETURN ADR(pw^.name);
END FindNode;

PROCEDURE setConfig (Config:LONGSET);
TYPE TgdID=ARRAY [1..6] OF INTEGER;
VAR nr:INTEGER;
    flag:BOOLEAN;
    gdID:TgdID;
BEGIN
  gdID:=[g.GDFont,g.GDSys,g.GDRaster,g.GDMouse,g.GDPort,g.GDIcon];
  FOR nr:=1 TO 6 DO
    IF nr IN Config THEN flag:=TRUE
                    ELSE flag:=FALSE; END;
    gt.GT_SetGadgetAttrs (g.MGGadgets[gdID[nr]],g.MGWnd,NIL,
                          gt.GTCB_Checked,flag,u.TAG_DONE);
  END;
END setConfig;

PROCEDURE LoadConfig (VAR Config:LONGSET);
CONST name="ENV:GadToolsBox/GenMod.prefs";
VAR dat:d.FileHandlePtr;
    head:TConHead;
    conf:ARRAY [1..3] OF LONGSET;
BEGIN
  dat:=d.Open (ADR(name),d.MODE_OLDFILE);
  IF dat#NIL THEN
    IF (d.Read (dat,ADR(head),SIZE(ConHead))=SIZE(ConHead)) AND
       (st.memcmp (ADR(head),ADR(ConHead),SIZE(ConHead))=0) AND
       (d.Read (dat,ADR(conf),SIZE(conf))=SIZE(conf)) THEN
      Config:=conf[1];
    ELSE
      Request (ADR('Error while loading\n"%s"'),ADR(name));
    END;
    d.Close (dat);
  END;
END LoadConfig;

PROCEDURE SaveConfig (Config:LONGSET);
VAR dat:d.FileHandlePtr;
    conf:ARRAY [1..3] OF LONGSET;
    name:str40;
    nr:INTEGER;
BEGIN
  conf[1]:=Config; conf[2]:=LONGSET{}; conf[3]:=LONGSET{};
  name:="ENVARC:GadToolsBox/GenMod.prefs";
  FOR nr:=1 TO 2 DO
    dat:=d.Open (ADR(name),d.MODE_NEWFILE);
    IF dat#NIL THEN
      IF NOT( (d.Write (dat,ADR(ConHead),SIZE(ConHead))=SIZE(ConHead)) AND
              (d.Write (dat,ADR(conf),SIZE(conf))=SIZE(conf)) ) THEN
        Request (ADR('Unable to save\n"%s"'),ADR(name));
      END;
      d.Close (dat);
    ELSE
      Request (ADR('Unable to open\n"%s"'),ADR(name));
    END;
    name:="ENV:GadToolsBox/GenMod.prefs";
  END;  (* FOR *)
END SaveConfig;

VAR wahlID:INTEGER;
    Grenzen:ARRAY [0..1] OF INTEGER;

PROCEDURE butSelect (VAR GDid:INTEGER);
VAR fnm:mt.Pstr256;
    str:STRING;
BEGIN
  IF (Grenzen[0]>0) OR (Grenzen[1]>0) THEN
    IF (mt.dest[0]=0C) AND FileReq (mt.dest,g.GDDest,TRUE) THEN END;
    IF mt.dest[0]=0C THEN GDid:=-1; END;
  END;
  IF (GDid=g.GDSelect) AND (mt.screen[0]=0C) THEN
    st.strcpy(mt.screen,mt.source);
    fnm := ADDRESS(d.PathPart (ADR(mt.screen)));
    IF fnm # NIL THEN
      IF fnm^[0] = '/' THEN fnm:=mt.Pstr256(ADDRESS(fnm)+1); END;
      str:=st.strchr (fnm^,'.');
      IF str#NIL THEN str^[0]:=0C; END;
      st.strcat (mt.screen,"Scr");
    END;
    IF (NOT FileReq (mt.screen,g.GDScreen,TRUE)) OR (mt.screen[0]=0C) THEN
      GDid:=-1;
    END;
  END;
END butSelect;

PROCEDURE HandleMG(VAR GDid:INTEGER): BOOLEAN;
CONST shortcuts="CDEFTOURMPIBVAS";
TYPE TgdID=ARRAY [0..14] OF INTEGER;
VAR imsgPtr: I.IntuiMessagePtr;
    imsg: I.IntuiMessage;
    done: BOOLEAN;
    gad:I.GadgetPtr;
    nr:INTEGER;
    ptr:ADDRESS;
    gadID:TgdID;
BEGIN
  gadID:=[g.GDSource,g.GDDest,g.GDScreen,g.GDTfrom,g.GDTto,g.GDFont,
          g.GDSys,g.GDRaster,g.GDMouse,g.GDPort,g.GDIcon,g.GDAbout,
          g.GDSave,g.GDAll,g.GDSelect];
  done := FALSE; GDid:=-1;
  LOOP
    imsgPtr:= gt.GT_GetIMsg (g.MGWnd^.UserPort);
    IF imsgPtr = NIL THEN EXIT END;
    imsg:=imsgPtr^;
    gt.GT_ReplyIMsg (imsgPtr);
    IF (I.CLOSEWINDOW<=imsg.Class) THEN
      done := TRUE;
    ELSIF I.REFRESHWINDOW<=imsg.Class THEN
      gt.GT_BeginRefresh (g.MGWnd);
      g.MGRender;
      gt.GT_EndRefresh (g.MGWnd, TRUE);
    ELSIF imsg.Class<=I.GADGETDOWN+I.GADGETUP THEN
      gad:=imsg.IAddress; GDid:=gad^.GadgetID;
      CASE GDid OF
        g.GDFont: IF mt.GenOpenFont IN MConfig THEN EXCL (MConfig,mt.GenOpenFont)
                                           ELSE INCL (MConfig,mt.GenOpenFont); END;
       |g.GDSys: IF mt.SysFont IN MConfig THEN EXCL (MConfig,mt.SysFont)
                                      ELSE INCL (MConfig,mt.SysFont); END;
       |g.GDRaster: IF mt.raster IN MConfig THEN EXCL (MConfig,mt.raster)
                                        ELSE INCL (MConfig,mt.raster); END;
       |g.GDMouse: IF mt.mouse IN MConfig THEN EXCL (MConfig,mt.mouse)
                                      ELSE INCL (MConfig,mt.mouse); END;
       |g.GDPort: IF mt.port IN MConfig THEN EXCL (MConfig,mt.port)
                                    ELSE INCL (MConfig,mt.port); END;
       |g.GDIcon: IF mt.icon IN MConfig THEN EXCL (MConfig,mt.icon)
                                    ELSE INCL (MConfig,mt.icon); END;
       |g.GDSource: st.strcpy (mt.source,gad^.SpecialInfo(I.StringInfoPtr)^.Buffer);
                    ZeigListe (mt.source);
                    Grenzen[0]:=-1; Grenzen[1]:=-1;
       |g.GDFsource: IF FileReq (mt.source,g.GDSource,FALSE) THEN
                       ZeigListe (mt.source);
                       Grenzen[0]:=-1; Grenzen[1]:=-1;
                     END;
       |g.GDFdest: IF FileReq (mt.dest,g.GDDest,FALSE) THEN END;
       |g.GDFscreen: IF FileReq (mt.screen,g.GDScreen,FALSE) THEN END;
       |g.GDWindows: Grenzen[ORD(wahlID=g.GDTto)]:=imsg.Code;
            gt.GT_SetGadgetAttrs (g.MGGadgets[wahlID],g.MGWnd,NIL,
                     gt.GTTX_Text,FindNode(imsg.Code),u.TAG_DONE);
            Enable (g.GDSelect);
       |g.GDFrom: IF imsg.Code=0 THEN wahlID:=g.GDTfrom
                                 ELSE wahlID:=g.GDTto; END;
       |g.GDAbout: about;
       |g.GDSave: SaveConfig (MConfig);
       |g.GDAll: IF (mt.dest[0]=0C) AND FileReq (mt.dest,g.GDDest,TRUE) THEN END;
                 IF mt.dest[0]=0C THEN GDid:=-1; END;
       |g.GDSelect: butSelect (GDid);
       |g.GDQuit: done:=TRUE;
      ELSE
      END;
    ELSIF I.VANILLAKEY<=imsg.Class THEN
      nr:=-1;
      ptr:=st.strchr(shortcuts,CAP(CHR(imsg.Code)));
      IF ptr#NIL THEN nr:=ptr-ADR(shortcuts); END;
      IF (nr>=0) AND (nr<=14) AND
         (I.GADGDISABLED<=g.MGGadgets[gadID[nr]]^.Flags) THEN nr:=-1; END;
      CASE nr OF
       |0..2: IF I.ActivateGadget (g.MGGadgets[gadID[nr]],g.MGWnd,NIL) THEN END;
       |3,4: gt.GT_SetGadgetAttrs (g.MGGadgets[g.GDFrom],g.MGWnd,NIL,
                                   gt.GTMX_Active,nr-3,u.TAG_DONE);
             wahlID:=gadID[nr];
       |5..10: DEC (nr,4);
               IF nr IN MConfig THEN EXCL (MConfig,nr)
                                ELSE INCL (MConfig,nr); END;
               setConfig (MConfig);
       |11: about;
       |12: SaveConfig (MConfig);
       |13: IF (mt.dest[0]=0C) AND FileReq (mt.dest,g.GDDest,TRUE) THEN END;
            IF mt.dest[0]#0C THEN GDid:=gadID[nr]; END;
       |14: GDid:=gadID[nr];
            butSelect (GDid);
      ELSE
      END;
    END;
  END; (* LOOP *)
  st.strcpy (mt.dest,g.MGGadgets[g.GDDest]^.SpecialInfo(I.StringInfoPtr)^.Buffer);
  st.strcpy (mt.screen,g.MGGadgets[g.GDScreen]^.SpecialInfo(I.StringInfoPtr)^.Buffer);
  RETURN done;
END HandleMG;

PROCEDURE OpenReq(VAR start,end:INTEGER):BOOLEAN;
VAR quit: BOOLEAN;
    id:INTEGER;
BEGIN
  IF geladen THEN
    e.AddHead (ADR(mt.Projects),ADR(ScrNode));
  END;
  REPEAT
    quit:= (d.SIGBREAKB_CTRL_C IN e.Wait (LONGSET {g.MGWnd^.UserPort^.mp_SigBit,
                                                   d.SIGBREAKB_CTRL_C}));
    quit:= quit OR HandleMG(id);
  UNTIL quit OR (id=g.GDAll) OR (id=g.GDSelect);
  IF geladen THEN
    e.RemHead (ADR(mt.Projects));
  END;
  IF quit THEN
    g.CloseMGWindow;
    g .CloseDownScreen;
    IF filereq#NIL THEN rt.rtFreeRequest (filereq); filereq:=NIL; END;
  ELSE
    IF id=g.GDAll THEN
      start:=-1; end:=-1;
    ELSE
      IF Grenzen[0]<Grenzen[1] THEN start:=Grenzen[0]; end:=Grenzen[1];
                               ELSE start:=Grenzen[1]; end:=Grenzen[0]; END;
      IF start=-1 THEN start:=end; END;
    END;
  END;
  RETURN quit;
END OpenReq;

PROCEDURE Assert (cond:BOOLEAN; str:STRING);
BEGIN
  IF NOT cond THEN _ErrorReq (str," "); END;
END Assert;

PROCEDURE InitReq;
VAR anz:LONGINT;
BEGIN
  ScrNode.name:=ADR(ScrNode.str);
  wahlID:=g.GDTfrom; Grenzen[0]:=-1; Grenzen[1]:=-1;
  LoadConfig (MConfig);
  filereq := rt.rtAllocRequestA (rt.TypeFileReq, NIL);
  Assert ((filereq#NIL),"Error: Out of memory");
  Assert (g.SetupScreen(NIL) = 0, "Unable to set up Screen");
  Assert (g.OpenMGWindow(TRUE) = 0, "Unable to open Window");
  INCL (filereq^.flags,rt.fReqPatGad);
  patGui:="#?(.gui)"; patMod:="#?(.mod|.def)";
  setConfig (MConfig);
  Disable (g.GDAll); Disable (g.GDSelect);
  IF wbStarted AND (WBMsg#NIL) THEN
    d.CurrentDir (WBMsg^.sm_ArgList^[0].wa_Lock);
    anz:=WBMsg^.sm_NumArgs;
    IF anz>3 THEN
      d.NameFromLock (WBMsg^.sm_ArgList^[3].wa_Lock,
                      ADR(mt.screen),SIZE(mt.screen));
      d.AddPart (ADR(mt.screen),WBMsg^.sm_ArgList^[3].wa_Name,
                 SIZE(mt.screen));
    END;
    IF anz>2 THEN
      d.NameFromLock (WBMsg^.sm_ArgList^[2].wa_Lock,
                      ADR(mt.dest),SIZE(mt.dest));
      d.AddPart (ADR(mt.dest),WBMsg^.sm_ArgList^[2].wa_Name,
                 SIZE(mt.dest));
    END;
    IF anz>1 THEN
      d.NameFromLock (WBMsg^.sm_ArgList^[1].wa_Lock,
                      ADR(mt.source),SIZE(mt.source));
      d.AddPart (ADR(mt.source),WBMsg^.sm_ArgList^[1].wa_Name,
                 SIZE(mt.source));
    END;
  END;
  Showtext (g.GDScreen,ADR(mt.screen)); Showtext (g.GDDest,ADR(mt.dest));
  IF mt.source[0]#0C THEN
    Showtext (g.GDSource,ADR(mt.source)); ZeigListe (mt.source);
    IF geladen THEN
      e.RemHead (ADR(mt.Projects));
    END;
  END;
END InitReq;

BEGIN
  ScrNode:=[NIL,NIL,0,NIL,"Screen"];
  ConHead:=[MAKEID("FORM"),34,MAKEID("PREF"),MAKEID("VERS"),2,1,
            MAKEID("GENM"),12];
  filereq:=NIL;
CLOSE
  g.CloseMGWindow;
  g.CloseDownScreen;
  IF filereq#NIL THEN rt.rtFreeRequest (filereq); filereq:=NIL; END;
END MGRequest.
