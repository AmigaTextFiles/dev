MODULE  CyberAVIVideo;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  b:=BestModeID,
        cu:=CyberAVIUtils,
        cgfx:=CyberGraphics,
        d:=Dos,
        e:=Exec,
        g:=CyberAVIGlobals,
        gfx:=Graphics,
        i:=Intuition,
        iff:=IFFParse,
        io:=AsyncIOSupport,
        i2m:=Intel2Mot,
        lv:=LibraryVer,
        mu:=MathUtils,
        o:=CyberAVIOpts,
        ol:=OberonLib,
        s:=CyberAVISync,
        sl:=StringLib,
        u:=Utility,
        y:=SYSTEM,
        ys:=YUVStuff;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   idmsvc=y.VAL(LONGINT,"msvc");
        idMSVC=y.VAL(LONGINT,"MSVC");
        idCRAM=y.VAL(LONGINT,"CRAM");
        idrgb =y.VAL(LONGINT,"\x00\x00\x00\x00");
        idRGB =y.VAL(LONGINT,"RGB ");
        idrle8=y.VAL(LONGINT,"\x01\x00\x00\x00");
        idRLE8=y.VAL(LONGINT,"RLE8");
        idrle4=y.VAL(LONGINT,"\x02\x00\x00\x00");
        idRLE4=y.VAL(LONGINT,"RLE4");
        idnone=y.VAL(LONGINT,"\x00\x00\xFF\xFF");
        idNONE=y.VAL(LONGINT,"NONE");
        idpack=y.VAL(LONGINT,"\x01\x00\xFF\xFF");
        idPACK=y.VAL(LONGINT,"PACK");
        idtran=y.VAL(LONGINT,"\x02\x00\xFF\xFF");
        idTRAN=y.VAL(LONGINT,"TRAN");
        idccc =y.VAL(LONGINT,"\x03\x00\xFF\xFF");
        idCCC =y.VAL(LONGINT,"CCC ");
        idjpeg=y.VAL(LONGINT,"\x04\x00\xFF\xFF");
        idJPEG=y.VAL(LONGINT,"JPEG");
        idmJPG=y.VAL(LONGINT,"mJPG");
        idMJPG=y.VAL(LONGINT,"MJPG");
        idIJPG=y.VAL(LONGINT,"IJPG");
        idRT21=y.VAL(LONGINT,"RT21");
        idrt21=y.VAL(LONGINT,"rt21");
        idIV31=y.VAL(LONGINT,"IV31");
        idiv31=y.VAL(LONGINT,"iv31");
        idIV32=y.VAL(LONGINT,"IV32");
        idiv32=y.VAL(LONGINT,"iv32");
        idIV41=y.VAL(LONGINT,"IV41");
        idiv41=y.VAL(LONGINT,"iv41");
        idCVID=y.VAL(LONGINT,"CVID");
        idcvid=y.VAL(LONGINT,"cvid");
        idRPZA=y.VAL(LONGINT,"RPZA");
        idrpza=y.VAL(LONGINT,"rpza");
        idAZPR=y.VAL(LONGINT,"AZPR");
        idazpr=y.VAL(LONGINT,"azpr");
        idULTI=y.VAL(LONGINT,"ULTI");
        idulti=y.VAL(LONGINT,"ulti");
        idYUV2=y.VAL(LONGINT,"YUV2");
        idyuv2=y.VAL(LONGINT,"yuv2");
        id2VUY=y.VAL(LONGINT,"2VUY");
        id2vuy=y.VAL(LONGINT,"2vuy");
        idYUV9=y.VAL(LONGINT,"YUV9");
        idYVU9=y.VAL(LONGINT,"YVU9");
        id9VUY=y.VAL(LONGINT,"9VUY");
        id9UVY=y.VAL(LONGINT,"9UVY");
        idVYUY=y.VAL(LONGINT,"VYUY");
        idYV12=y.VAL(LONGINT,"YV12");
        idyv12=y.VAL(LONGINT,"yv12");
        idXMPG=y.VAL(LONGINT,"XMPG");
        idxmpg=y.VAL(LONGINT,"xmpg");
        idCYUV=y.VAL(LONGINT,"CYUV");
        idcyuv=y.VAL(LONGINT,"cyuv");
        idVDOW=y.VAL(LONGINT,"VDOW");

        codecSupported * =1;
        codecUnknown * =0;
        codecUnsupported * =-1;

        tmpRasSize=4096;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    CodecHeader=STRUCT
            compression: LONGINT;
            width: LONGINT;
            height: LONGINT;
            depth: LONGINT;
            description: e.STRING;
        END;

        DecoderProc=PROCEDURE(from{8}: e.APTR;
                              to{9}: e.APTR;
                              width{0}: LONGINT;
                              height{1}: LONGINT;
                              encSize{2}: LONGINT;
                              spec{10}: e.APTR);

        FastC2PProc=PROCEDURE(chunky{8}: e.APTR;
                              bitmap{9}: gfx.BitMapPtr;
                              realWidth{1}: LONGINT);

        DisplayProc=PROCEDURE();

        ColorReg=STRUCT
            red: LONGINT;
            green: LONGINT;
            blue: LONGINT;
        END;
        ColorRegArrayPtr=UNTRACED POINTER TO ColorRegArray;
        ColorRegArray=ARRAY 256 OF ColorReg;

        ColorMapPtr=UNTRACED POINTER TO ColorMap;
        ColorMap=STRUCT
            count: INTEGER;
            first: INTEGER;
            colors: ColorRegArray;
            last: LONGINT;
        END;
        ColorMapArrayPtr=UNTRACED POINTER TO ColorMapArray;
        ColorMapArray=ARRAY SIZE(ColorMap) DIV SIZE(LONGINT) OF LONGINT;

        CMapArrPtr=UNTRACED POINTER TO CMapArr;
        CMapArr=ARRAY 256 OF STRUCT
            alpha: CHAR;
            red: CHAR;
            green: CHAR;
            blue: CHAR;
        END;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------------- "VAR" --------------------------------- *)
VAR     screen: i.ScreenPtr;
        window: i.WindowPtr;
        mouse: i.ObjectPtr;
        mouseBitMap: gfx.BitMapPtr;
        colorReduction: BOOLEAN;
        ham8: BOOLEAN;
        animWidth: INTEGER;
        animHeight: INTEGER;
        animDepth: INTEGER;
        dispModulo: INTEGER;
        calcWidth: LONGINT;
        calcHeight: LONGINT;
        colorMap: ColorMapPtr;
        secondColorMap: ColorMapPtr;
        videoBufferSize: LONGINT;
        videoData: e.LSTRPTR;
        videoDataDec: e.LSTRPTR;
        ham8Buffer: e.LSTRPTR;
        decoderProc: DecoderProc;
        rawDecoderProc: DecoderProc;
        displayProc: DisplayProc;
        fastc2pProc: FastC2PProc;
        decoderSpec: e.APTR;
        idcmpSig - : LONGINT;
        leftOff: INTEGER;
        topOff: INTEGER;
        rp: gfx.RastPortPtr;
        tmpBM: gfx.BitMapPtr;
        tmpRas: gfx.TmpRasPtr;
        tmpRasMem: UNTRACED POINTER TO ARRAY tmpRasSize OF CHAR;
        grayScale: BOOLEAN;
        pubScreen: BOOLEAN;
        colorType: LONGINT;
        frameSize: LONGINT;
        cmap: CMapArrPtr;
        secondCmap: CMapArrPtr;
        doubleScanned - : BOOLEAN;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE HandleIDCMP()" ----------------------- *)
PROCEDURE HandleIDCMP * (): LONGINT;

VAR     msg: i.IntuiMessagePtr;
        ret: LONGINT;

BEGIN
  ret:=g.noError;
  msg:=e.GetMsg(window.userPort);
  IF msg#NIL THEN
    IF i.vanillaKey IN msg.class THEN
      CASE msg.code OF
      | 3: ret:=d.break; (* CTRL-C *)
      | 4: ret:=g.skipAnim; (* CTRL-D *)
      | 27: ret:=g.skipAnim; (* ESC *)
      | ORD("P"), ORD("p"): ret:=g.pauseAnim;
      ELSE
      END;
    ELSIF i.rawKey IN msg.class THEN
      CASE msg.code OF
      | 69: ret:=g.skipAnim     (* ESC *)
      | 80: s.SetFrameDelay(0);      (* F1, maximal *)
      | 81: s.SetFrameDelay(16666);  (* F2, 60 fps*)
      | 82: s.SetFrameDelay(33333);  (* F3, 30 fps *)
      | 83: s.SetFrameDelay(41666);  (* F4, 24 fps*)
      | 84: s.SetFrameDelay(66666);  (* F5, 15 fps *)
      | 85: s.SetFrameDelay(83333);  (* F6, 12 fps *)
      | 86: s.SetFrameDelay(100000); (* F7, 10 fps *)
      | 87: s.SetFrameDelay(200000); (* F8, 5 fps *)
      | 88: s.SetFrameDelay(999999); (* F9, 1 fps*)
      | 89: s.SetFrameDelay(-1);     (* F10, normal*)
      ELSE
      END;
    ELSE
      ret:=g.skipAnim;
    END;
    e.ReplyMsg(msg);
  END;
  RETURN ret;
END HandleIDCMP;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------- "PROCEDURE ReadExternalPalette()" ------------------- *)
PROCEDURE ReadExternalPalette();

CONST   idILBM=y.VAL(LONGINT,"ILBM");
        idCMAP=y.VAL(LONGINT,"CMAP");

VAR     handle: iff.IFFHandlePtr;
        fh: d.FileHandlePtr;
        chunk: iff.ContextNodePtr;
        buffer: ARRAY 768 OF CHAR;
        error: LONGINT;
        cnt: LONGINT;
        numColors: LONGINT;

BEGIN
  IF iff.base=NIL THEN RETURN; END;
  handle:=iff.AllocIFF();
  IF handle#NIL THEN
    fh:=d.Open(o.cmap,d.oldFile);
    IF fh#NIL THEN
      handle.stream:=y.VAL(LONGINT,fh);
      iff.InitIFFasDOS(handle);
      IF iff.OpenIFF(handle,iff.read)=0 THEN
        IF iff.StopChunk(handle,idILBM,idCMAP)=0 THEN
          IF iff.ParseIFF(handle,iff.parseScan)=0 THEN
            chunk:=iff.CurrentChunk(handle);
            numColors:=chunk.size DIV 3;
            error:=iff.ReadChunkBytes(handle,buffer,mu.min(chunk.size,SIZE(buffer)));
            FOR cnt:=0 TO numColors-1 DO
              colorMap.colors[cnt].red:=i2m.ByteTo32(buffer[cnt*3+0]);
              colorMap.colors[cnt].green:=i2m.ByteTo32(buffer[cnt*3+1]);
              colorMap.colors[cnt].blue:=i2m.ByteTo32(buffer[cnt*3+2]);
              (* cmap[cnt] nicht setzen, sonst gibts massiv Fehlfarben *)
            END;
            FOR cnt:=numColors TO 255 DO
              colorMap.colors[cnt].red:=0;
              colorMap.colors[cnt].green:=0;
              colorMap.colors[cnt].blue:=0;
            END;
            colorMap.count:=i.LongToUInt(numColors);
            colorMap.first:=0;
            colorMap.last:=numColors-1;
          END;
        END;
        iff.CloseIFF(handle);
      END;
      d.OldClose(fh);
    END;
    iff.FreeIFF(handle);
  END;
END ReadExternalPalette;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE Init332ColorMap()" --------------------- *)
PROCEDURE Init332ColorMap();

VAR     cnt: LONGINT;

BEGIN
  IF colorMap=NIL THEN NEW(colorMap); END;
  FOR cnt:=0 TO 255 DO
    IF grayScale THEN
      colorMap.colors[cnt].red:=i2m.ByteTo32(CHR(cnt));
      colorMap.colors[cnt].green:=i2m.ByteTo32(CHR(cnt));
      colorMap.colors[cnt].blue:=i2m.ByteTo32(CHR(cnt));
      cmap[cnt].red:=CHR(cnt);
      cmap[cnt].green:=CHR(cnt);
      cmap[cnt].blue:=CHR(cnt);
    ELSE
      colorMap.colors[cnt].red:=y.LSH(y.VAL(LONGINT,y.LSH(y.VAL(LONGSET,cnt)*LONGSET{5..7},-5))*9362,16);
      colorMap.colors[cnt].green:=y.LSH(y.VAL(LONGINT,y.LSH(y.VAL(LONGSET,cnt)*LONGSET{2..4},-2))*9362,16);
      colorMap.colors[cnt].blue:=y.LSH(y.VAL(LONGINT,y.VAL(LONGSET,cnt)*LONGSET{0..1})*21845,16);
      cmap[cnt].red:=CHR(y.LSH(y.VAL(LONGINT,y.LSH(y.VAL(LONGSET,cnt)*LONGSET{5..7},-5))*9362,-8));
      cmap[cnt].green:=CHR(y.LSH(y.VAL(LONGINT,y.LSH(y.VAL(LONGSET,cnt)*LONGSET{2..4},-2))*9362,-8));
      cmap[cnt].blue:=CHR(y.LSH(y.VAL(LONGINT,y.VAL(LONGSET,cnt)*LONGSET{0..1})*21845,-8));
    END;
  END;
  colorMap.count:=256;
  colorMap.first:=0;
  colorMap.last:=255;
  IF o.cmap#"" THEN ReadExternalPalette(); END;
END Init332ColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE InitHAM8ColorMap()" --------------------- *)
PROCEDURE InitHAM8ColorMap();

VAR     cnt: INTEGER;
        rr: INTEGER;
        gg: INTEGER;
        bb: INTEGER;

BEGIN
  IF colorMap=NIL THEN NEW(colorMap); END;
  rr:=0;
  gg:=0;
  bb:=0;
  FOR cnt:=0 TO 63 DO
    colorMap.colors[cnt].red:=y.LSH(rr,30)+y.LSH(rr,24);
    colorMap.colors[cnt].green:=y.LSH(gg,30)+y.LSH(gg,24);
    colorMap.colors[cnt].blue:=y.LSH(bb,30)+y.LSH(bb,24);
    INC(bb);
    IF bb>3 THEN
      bb:=0;
      INC(gg);
      IF gg>3 THEN
        gg:=0;
        INC(rr);
      END;
    END;
  END;
  colorMap.count:=64;
  colorMap.first:=0;
  colorMap.last:=63;
END InitHAM8ColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE InitTmpBitMap()" ---------------------- *)
PROCEDURE InitTmpBitMap(): LONGINT;
BEGIN
  tmpBM:=gfx.AllocBitMap(animWidth,animHeight,mu.max(animDepth,4),LONGSET{gfx.bmbInterleaved},NIL);
  IF tmpBM=NIL THEN RETURN d.noFreeStore; END;
  IF ~(gfx.bmbInterleaved IN y.VAL(LONGSET,gfx.GetBitMapAttr(tmpBM,gfx.bmaFlags))) THEN RETURN d.noFreeStore; END;
  IF tmpRas=NIL THEN (* tmpRas nur einmal allokieren *)
    NEW(tmpRas);
    INCL(ol.MemReqs,e.chip);
    NEW(tmpRasMem);
    EXCL(ol.MemReqs,e.chip);
    gfx.InitTmpRas(tmpRas^,tmpRasMem,tmpRasSize);
  END;
  rp.tmpRas:=y.ADR(tmpRas);
  RETURN g.noError;
END InitTmpBitMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE CloseDisplay()" ----------------------- *)
PROCEDURE CloseDisplay * ();
BEGIN
  IF tmpRas#NIL THEN gfx.WaitBlit(); rp.tmpRas:=NIL; END;
  IF window#NIL THEN i.CloseWindow(window); window:=NIL; END;
  IF screen#NIL THEN
    IF pubScreen THEN
      i.UnlockPubScreen(NIL,screen);
    ELSE
      i.OldCloseScreen(screen);
    END;
    screen:=NIL;
  END;
  IF mouse#NIL THEN i.DisposeObject(mouse); mouse:=NIL; END;
  IF mouseBitMap#NIL THEN gfx.FreeBitMap(mouseBitMap); mouseBitMap:=NIL; END;
  IF tmpBM#NIL THEN gfx.FreeBitMap(tmpBM); tmpBM:=NIL; END;
END CloseDisplay;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE OpenDisplay()" ----------------------- *)
PROCEDURE OpenDisplay * (virtual: BOOLEAN;
                         fileTitle: e.STRPTR): LONGINT;

VAR     windowTags: u.Tags20;
        screenDepth: LONGINT;
        errVal: LONGINT;
        cgx3: e.LibraryPtr;

CONST   winLeft=0;
        winTop=1;
        winWidth=2;
        winHeight=3;
        winScreen=4;

(* /// ---------------------- "PROCEDURE InitPubScreen()" ---------------------- *)
  PROCEDURE InitPubScreen(): LONGINT;

  VAR   width: LONGINT;
        height: LONGINT;
        factor: REAL;

  CONST winTitle=6;
        winMaxW=7;
        winMaxH=8;
        winMinW=9;
        winMinH=10;
        winSizeGad=15;

  BEGIN
    windowTags:=u.Tags20(i.waLeft,0,
                         i.waTop,0,
                         i.waInnerWidth,0,
                         i.waInnerHeight,0,
                         i.waPubScreen,NIL,
                         i.waActivate,e.true,
                         i.waTitle,NIL,
                         i.waMaxWidth,-1,
                         i.waMaxHeight,-1,
                         i.waMinWidth,-1,
                         i.waMinHeight,-1,
                         i.waDragBar,e.true,
                         i.waDepthGadget,e.true,
                         i.waCloseGadget,e.true,
                         i.waAutoAdjust,e.true,
                         i.waSizeGadget,e.true,
                         i.waSizeBBottom,e.true,
                         i.waRMBTrap,e.true,
                         i.waIDCMP,LONGSET{i.closeWindow,i.vanillaKey,i.rawKey},
                         u.done,0);
    screen:=i.LockPubScreen(o.pubScreen);
    IF screen=NIL THEN
      d.PrintF("Can't find screen \"%s\", using own screen\n",y.ADR(o.pubScreen));
      RETURN g.unknownError;
    END;
    width:=gfx.GetBitMapAttr(screen.rastPort.bitMap,gfx.bmaWidth);
    height:=gfx.GetBitMapAttr(screen.rastPort.bitMap,gfx.bmaHeight);
    screenDepth:=gfx.GetBitMapAttr(screen.rastPort.bitMap,gfx.bmaDepth);
    IF (width<calcWidth) OR (height<calcHeight) THEN
      d.PrintF("Screen is too small, using own screen\n");
      RETURN g.unknownError;
    END;
    IF screenDepth<15 THEN
      d.PrintF("Screen \"%s\" is no TrueColor screen, using own screen\n",y.ADR(o.pubScreen));
      RETURN g.unknownError;
    END;
    IF ~cgfx.IsCyberModeID(gfx.GetVPModeID(y.ADR(screen.viewPort))) THEN
      d.PrintF("Screen \"%s\" is not a CyberGraphX native screen, using own screen\n",y.ADR(o.pubScreen));
      RETURN g.unknownError;
    END;

    IF o.magnify<0 THEN
      factor:=1/(-o.magnify);
    ELSE
      factor:=o.magnify;
    END;
    IF (animDepth<=8) & grayScale THEN (* 8bit Graustufen => Truecolor *)
      windowTags[winSizeGad].data:=e.false;
      factor:=1.0;
    END;
    doubleScanned:=FALSE;
    width:=mu.floor(animWidth*factor);
    height:=mu.floor(animHeight*factor);
    windowTags[winLeft].data:=(screen.width-width) DIV 2;
    windowTags[winTop].data:=(screen.height-height) DIV 2;
    windowTags[winWidth].data:=width;
    windowTags[winHeight].data:=height;
    windowTags[winTitle].data:=fileTitle;
    windowTags[winMaxW].data:=animWidth*4;
    windowTags[winMaxH].data:=animHeight*4;
    windowTags[winMinW].data:=animWidth DIV 4;
    windowTags[winMinH].data:=animHeight DIV 4;
    i.ScreenToFront(screen);
    RETURN g.noError;
  END InitPubScreen;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE InitOwnScreen()" ---------------------- *)
  PROCEDURE InitOwnScreen(): LONGINT;

  VAR   screenTags: u.Tags12;
        dispIDbyDim: LONGINT;
        dispID: LONGINT;
        dimInfo: gfx.DimensionInfo;
        dispInfo: gfx.DisplayInfo;
        nameInfo: gfx.NameInfo;
        error: LONGINT;

  CONST scrID=0;
        scrWidth=1;
        scrHeight=2;
        scrDepth=3;
        scrColors=4;
        scrErrorCode=5;
        scrInterleaved=6;
        winPointer=5;

  BEGIN
    windowTags:=u.Tags20(i.waLeft,0,
                         i.waTop,0,
                         i.waWidth,0,
                         i.waHeight,0,
                         i.waCustomScreen,NIL,
                         i.waPointer,NIL,
                         i.waActivate,e.true,
                         i.waAutoAdjust,e.true,
                         i.waBorderless,e.true,
                         i.waRMBTrap,e.true,
                         i.waIDCMP,LONGSET{i.mouseButtons,i.vanillaKey,i.rawKey},
                         u.done,0,
                         0,0,
                         0,0,
                         0,0,
                         0,0,
                         0,0,
                         0,0,
                         0,0,
                         0,0);
    screenTags:=u.Tags12(i.saDisplayID,0,
                         i.saWidth,0,
                         i.saHeight,0,
                         i.saDepth,0,
                         i.saColors32,NIL,
                         i.saErrorCode,NIL,
                         i.saInterleaved,e.false,
                         i.saTitle,y.ADR("CyberAVI"),
                         i.saBehind,e.false,
                         i.saQuiet,e.true,
                         i.saPens,y.ADR("\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\x00\x00"
                                        "\xFF\xFF"),
                         u.done,0);

    IF (animDepth>8) & (colorReduction OR ham8) THEN
      animDepth:=8;
      IF ham8 THEN
        InitHAM8ColorMap();
      ELSE
        Init332ColorMap();
      END;
    END;

    IF (animDepth>8) & o.force24 THEN animDepth:=24; END;

    IF o.screenModeID#0 THEN
      dispIDbyDim:=o.screenModeID;
    ELSE
      dispIDbyDim:=b.BestMode(animWidth,animHeight,animDepth,colorReduction,ham8);
    END;
    dispID:=dispIDbyDim;
(* /// "$IF RUNDEBUG" *)
    IF o.debug THEN
       y.SETREG(0,gfx.GetDisplayInfoData(NIL,nameInfo,SIZE(nameInfo),gfx.dtagName,dispID));
       d.PrintF("selected screenmode: %s ($%08lx)\n",y.ADR(nameInfo.name),dispID);
    END;
(* \\\ $END *)

    IF o.askScrMode OR (dispID=gfx.invalidID) THEN
(* /// "$IF RUNDEBUG" *)
      IF o.debug & (dispID=gfx.invalidID) THEN d.PrintF("invalid display id, prompting for screenmode\n"); END;
(* \\\ "$END" *)
      dispID:=b.SelectModeIDByReq(animWidth,animHeight,animDepth,dispIDbyDim,colorReduction,ham8);
    END;

    IF dispID=gfx.invalidID THEN
      IF dispIDbyDim=gfx.invalidID THEN
(* /// "$IF RUNDEBUG" *)
        IF o.debug THEN d.PrintF("invalid display id, selecting simple id\n"); END;
(* \\\ "$END" *)
        dispID:=b.SelectModeIDSimple(animWidth,animHeight,ham8);
      ELSE
        dispID:=dispIDbyDim;
      END;
    END;

    screenTags[scrID].data:=dispID;
    IF colorReduction OR ham8 THEN
      y.SETREG(0,gfx.GetDisplayInfoData(NIL,dimInfo,SIZE(dimInfo),gfx.dtagDims,dispID));
      screenDepth:=dimInfo.maxDepth;
      screenTags[scrWidth].data:=dimInfo.nominal.maxX-dimInfo.nominal.minX+1;
      screenTags[scrHeight].data:=dimInfo.nominal.maxY-dimInfo.nominal.minY+1;
      screenTags[scrDepth].data:=mu.max(animDepth,4); (* unter AGA besser minimale Plane-Anzahl nehmen... *)
      screenTags[scrInterleaved].data:=e.true;
    ELSE
      screenDepth:=cgfx.GetCyberIDAttr(cgfx.idAttrDepth,dispID);
      screenTags[scrWidth].data:=cgfx.GetCyberIDAttr(cgfx.idAttrWidth,dispID);
      screenTags[scrHeight].data:=cgfx.GetCyberIDAttr(cgfx.idAttrHeight,dispID);
      screenTags[scrDepth].data:=screenDepth; (* ... aber unter CyberGfx besser 8bpp *)
    END;
    screenTags[scrColors].data:=colorMap;
    screenTags[scrErrorCode].data:=y.ADR(error);
    screen:=i.OpenScreenTagListA(NIL,screenTags);
    IF screen=NIL THEN
      d.PrintF("Can't open screen: ");
      CASE error OF
      | i.osErrNoMem: d.PrintF("not enough memory\n");
      | i.osErrNoChipMem: d.PrintF("not enough chip memory\n");
      | i.osErrUnknownMode: d.PrintF("unknown display id $%08lx\n",dispID);
      | i.oserrTooDeep: d.PrintF("depth %ld is too high\n",screenDepth);
      | i.oserrNotAvailable: d.PrintF("mode $%08lx is not available\n",dispID);
      ELSE
        d.PrintF("unknown error\n");
      END;
      RETURN g.unknownError;
    END;
    y.SETREG(0,gfx.GetDisplayInfoData(NIL,dispInfo,SIZE(dispInfo),gfx.dtagDisp,dispID));
    doubleScanned:=(gfx.isScandbl IN dispInfo.propertyFlags);
    mouseBitMap:=gfx.AllocBitMap(16,1,2,LONGSET{gfx.bmbClear,gfx.bmbDisplayable},NIL); (* Pointer mit 16x1 Pixel und 2 Planes *)
    IF mouseBitMap#NIL THEN
      mouse:=i.NewObject(NIL,i.pointerClass,i.pointeraBitMap,mouseBitMap,
                                            u.done);
    ELSE
      mouse:=NIL;
    END;
    windowTags[winWidth].data:=screen.width;
    windowTags[winHeight].data:=screen.height;
    windowTags[winScreen].data:=screen;
    windowTags[winPointer].data:=mouse;
    RETURN g.noError;
  END InitOwnScreen;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  doubleScanned:=TRUE;
  IF virtual THEN RETURN g.noError; END;
  errVal:=g.noError;
  pubScreen:=(o.pubScreen#"");
  cgx3:=e.OpenLibrary("cgxsystem.library",41);
  IF pubScreen & (animDepth<=8) THEN
    IF ~lv.CheckVersion(cgx3,41,9) THEN
      pubScreen:=FALSE;
      d.PrintF("Playback on public truecolor screens requires either truecolor animations (with\n"
               "CyberGraphX V2), or CyberGraphX V3 (at least rev 41.9)!\n"
               "Using own screen instead.\n");
    END;
  END;
  IF cgx3#NIL THEN e.CloseLibrary(cgx3); END;
  IF pubScreen THEN
    IF InitPubScreen()#g.noError THEN
      CloseDisplay();
      pubScreen:=FALSE;
      errVal:=InitOwnScreen();
    END;
  ELSE
    errVal:=InitOwnScreen();
  END;

  IF errVal=g.noError THEN
    windowTags[winScreen].data:=screen;
    window:=i.OpenWindowTagListA(NIL,windowTags);
    IF window=NIL THEN
      d.PrintF("Can't open window\n");
      RETURN g.unknownError;
    END;
    rp:=window.rPort;
    idcmpSig:=window.userPort.sigBit;
    IF pubScreen THEN
      leftOff:=window.borderLeft;
      topOff:=window.borderTop;
    ELSE
      leftOff:=i.LongToUInt((window.width-animWidth) DIV 2);
      topOff:=i.LongToUInt((window.height-animHeight) DIV 2);
      IF screenDepth<15 THEN
        gfx.SetRast(y.ADR(screen.rastPort),0);
        gfx.SetRast(rp,0);
      ELSE
        y.SETREG(0,cgfx.FillPixelArray(y.ADR(screen.rastPort),0,0,screen.width,screen.height,0));
        y.SETREG(0,cgfx.FillPixelArray(rp,0,0,window.width,window.height,0));
      END;
    END;

    IF screenDepth<15 THEN
      IF colorReduction THEN
        errVal:=InitTmpBitMap(); (* die AGA-Routine braucht eine extra BitMap *)
      END;
    END;
  END;
  RETURN errVal;
END OpenDisplay;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeDummy()" ----------------------- *)
PROCEDURE DecodeDummy {"_DecodeDummy"} (from{8}: e.APTR;
                                        to{9}: e.APTR;
                                        width{0}: LONGINT;
                                        height{1}: LONGINT;
                                        encSize{2}: LONGINT;
                                        spec{10}: e.APTR);

PROCEDURE SetupDummy(VAR codec: CodecHeader);
BEGIN
  decoderProc:=DecodeDummy;
  decoderSpec:=NIL;
END SetupDummy;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE CVIDData" ---------------------------- *)
TYPE    Color2x2Ptr=UNTRACED POINTER TO Color2x2;
        Color2x2=STRUCT
            r0,g0,b0: CHAR;
            r1,g1,b1: CHAR;
            r2,g2,b2: CHAR;
            r3,g3,b3: CHAR;
            clr00, clr01, clr02, clr03: LONGINT;
            clr10, clr11, clr12, clr13: LONGINT;
            clr20, clr21, clr22, clr23: LONGINT;
            clr30, clr31, clr32, clr33: LONGINT;
        END;
        Color2x2ArrayPtr=UNTRACED POINTER TO Color2x2Array;
        Color2x2Array=ARRAY 256 OF Color2x2;

CONST   cvidMaxStrips=16;

TYPE    CVIDDataPtr=UNTRACED POINTER TO CVIDData;
        CVIDData=STRUCT
            gray: BOOLEAN;
            dither: BOOLEAN;
            cvidMaps0: ARRAY cvidMaxStrips OF Color2x2ArrayPtr;
            cvidMaps1: ARRAY cvidMaxStrips OF Color2x2ArrayPtr;
            vMap0: ARRAY cvidMaxStrips OF LONGINT;
            vMap1: ARRAY cvidMaxStrips OF LONGINT;
            yuv: ys.YUVTablePtr;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     cvidData: CVIDDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeCVID()" ------------------------ *)
PROCEDURE DecodeCVID {"_DecodeCVID"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectCVIDFuncs {"_SelectCVIDFuncs"} (spec{8}: CVIDDataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupCVID(codec: CodecHeader);

VAR     cnt: LONGINT;

BEGIN
  IF cvidData=NIL THEN
    NEW(cvidData);
    FOR cnt:=0 TO cvidMaxStrips-1 DO
      NEW(cvidData.cvidMaps0[cnt]);
      NEW(cvidData.cvidMaps1[cnt]);
    END;
  END;
  cvidData.gray:=grayScale;
  cvidData.yuv:=ys.GenYUVTables();
  cvidData.limit:=ys.InitLimitTables();
  cvidData.cmap:=cmap;
  SelectCVIDFuncs(cvidData,(colorReduction & ~ham8) OR grayScale,o.dither);
  decoderProc:=DecodeCVID;
  decoderSpec:=cvidData;
END SetupCVID;
(* \\\ ------------------------------------------------------------------------- *)

(* /// IV32
(* /// ---------------------------- "TYPE IV32Data" ---------------------------- *)
TYPE    IV32DataPtr=UNTRACED POINTER TO IV32Data;
        IV32Data=STRUCT
            gray: BOOLEAN;
            dither: BOOLEAN;
            yuv: ys.YUVTablePtr;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
            x: UNTRACED POINTER TO ARRAY 10 OF LONGINT;
        END;

VAR     iv32Data: IV32DataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeIV32()" ------------------------ *)
PROCEDURE DecodeIV32 {"_DecodeIV32"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE DecodeIV322 {"_DecodeIV32_2"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectIV32Funcs {"_SelectIV32Funcs"} (spec{8}: IV32DataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

TYPE    arr256=UNTRACED POINTER TO ARRAY 256 OF LONGINT;

VAR     ivmem["L000126"]: e.LSTRPTR;
        ivmemsize["L000127"]: LONGINT;
        ivw["L000128"]: INTEGER;
        ivh["L000129"]: INTEGER;
        ivm1["_indeo_bufs"]: e.APTR;
        ivm2["L000124"]: e.APTR;
        ivm3["L000125"]: e.APTR;
        ivm4["L00012A"]: e.APTR;
        ivm5["L00012B"]: e.APTR;
        ivm6["L00012C"]: e.APTR;
        ibufinit["_indeo_buf_init"]: LONGINT;
        iv12f["L00012F"]: e.APTR;
        iv130["L000130"]: e.APTR;
        iv131["L000131"]: e.APTR;
        iv132["L000132"]: e.APTR;
        iv133["L000133"]: e.APTR;

        yt["_YContrib"]: arr256;
        ub["_UContribToB"]:arr256;
        ug["_UContribToG"]:arr256;
        vr["_VContribToG"]:arr256;
        vg["_VContribToR"]:arr256;
        indeoTabs["_indeo_tabs"]: LONGINT;

(* /// ----------------------- "PROCEDURE IndeoGenYUV()" ----------------------- *)
PROCEDURE IndeoGenYUV();

VAR     i: LONGINT;
        val: LONGINT;
        x1,x2,x3,x4,x5: LONGINT;

BEGIN
  NEW(yt); NEW(ub); NEW(ug); NEW(vr); NEW(vg);
  val:=04563H;
  FOR i:=127 TO 0 BY -1 DO
    yt[i]:=val;
    DEC(val,149);
  END;
  x3:=-13056;
  x5:=6656;
  x4:=6400;
  x2:=-16640;
  x1:=-16384;
  FOR i:=0 TO 127 DO
    ub[i]:=(x1 DIV 2)+(x2 DIV 2);
    ug[i]:=x4 DIV 2;
    vg[i]:=x5;
    vr[i]:=x3;
    INC(x3,204);
    DEC(x5,104);
    DEC(x4,100);
    INC(x2,260);
    INC(x1,256);
  END;
  FOR i:=0 TO 127 DO
    yt[i+128]:=yt[i];
    ub[i+128]:=ub[i];
    ug[i+128]:=ug[i];
    vg[i+128]:=vg[i];
    vr[i+128]:=vr[i];
  END;
  indeoTabs:=000000080H;
  iv12f:=yt;
  iv130:=ub;
  iv131:=vr;
  iv132:=ug;
  iv133:=vg;
END IndeoGenYUV;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE IndeoInitYUVBufs()" --------------------- *)
PROCEDURE IndeoInitYUVBufs(width: LONGINT;
                           height: LONGINT);
VAR     w16: LONGINT;
        h16: LONGINT;
        w164: LONGINT;
        cnt: LONGINT;
        ptr: e.LSTRPTR;

BEGIN
  w16:=i2m.Round(width,16);
  h16:=i2m.Round(height,16);
  ivmemsize:=2*w16*h16+4*w16;
  ol.New(ivmem,ivmemsize);
  w164:=w16 DIV 4;
  ivw:=i.LongToUInt(w16);
  ivh:=i.LongToUInt(h16);
  ivm1:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+w16);
  ivm4:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize DIV 2);

  ivm2:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize-w164*4);
  ivm3:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize-w164*2);

  ivm5:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize-w164*3);
  ivm6:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize-w164*1);
  ptr:=ivmem;
  FOR cnt:=0 TO w16-1 DO ptr[cnt]:=40X; END;
  ptr:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize DIV 2-w16);
  FOR cnt:=0 TO w16-1 DO ptr[cnt]:=40X; END;
  ptr:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,ivmem)+ivmemsize-w16*2);
  FOR cnt:=0 TO w16*2-1 DO ptr[cnt]:=40X; END;
  ibufinit:=1;
  (* d.PrintF("%ld x %ld, %08lx, %ld\n",ivw,ivh,ivmem,ivmemsize); *)
END IndeoInitYUVBufs;
(* \\\ ------------------------------------------------------------------------- *)

(* ///
PROCEDURE myentry{"myentry"}(w{0}: LONGINT; h{1}: LONGINT);
PROCEDURE myfree{"myfree"}(x{8}: e.APTR);
\\\ *)

PROCEDURE SetupIV32(codec: CodecHeader);
BEGIN
  IF iv32Data=NIL THEN NEW(iv32Data); END;
  iv32Data.gray:=grayScale;
  iv32Data.yuv:=ys.GenYUVTables();
  iv32Data.limit:=ys.InitLimitTables();
  iv32Data.cmap:=cmap;
  NEW(iv32Data.x);
(* ///
  d.PrintF("mem: %08lx\n"
           "size: %ld\n"
           "width: %ld\n"
           "height: %ld\n"
           "bufs: %08lx\n"
           "124: %08lx\n"
           "125: %08lx\n"
           "12a: %08lx\n"
           "12b: %08lx\n"
           "12c: %08lx\n"
           "init: %ld\n\n"
           ,ivmem,ivmemsize,ivw,ivh,ivm1,ivm2,ivm3,ivm4,ivm5,ivm6,ibufinit);
\\\ *)
  IndeoGenYUV();
  IndeoInitYUVBufs(codec.width,codec.height);
(* ///
  myentry(codec.width,codec.height);
  d.PrintF("mem: %08lx\n"
           "size: %ld\n"
           "width: %ld\n"
           "height: %ld\n"
           "bufs: %08lx\n"
           "124: %08lx\n"
           "125: %08lx\n"
           "12a: %08lx\n"
           "12b: %08lx\n"
           "12c: %08lx\n"
           "init: %ld\n\n"
           ,ivmem,ivmemsize,ivw,ivh,ivm1,ivm2,ivm3,ivm4,ivm5,ivm6,ibufinit);
\\\ *)
(* ///
  fh:=d.Open("sd0:memdump2",d.newFile);
  y.SETREG(0,d.Write(fh,ivmem^,ivmemsize));
  d.OldClose(fh);
\\\ *)
(* ///
  IF ivmem#NIL THEN myfree(ivmem); END;
\\\ *)
  SelectIV32Funcs(iv32Data,(colorReduction & ~ham8) OR grayScale,o.dither);
  decoderProc:=DecodeIV322;
  decoderSpec:=iv32Data;
END SetupIV32;
(* \\\ ------------------------------------------------------------------------- *)
\\\ *)

(* /// ---------------------------- "TYPE JPEGData" ---------------------------- *)
TYPE    JPEGDataPtr=UNTRACED POINTER TO JPEGData;
        JPEGData=STRUCT
            gray: BOOLEAN;
            dither: BOOLEAN;
            yuvTab: ys.YUVTablePtr;
            yuvBuf: ys.YUVBufferPtr;
            limit: ys.RangeLimitPtr;
            quantTab: ARRAY 4 OF e.APTR;
            cmap: CMapArrPtr;
        END;

VAR     jpegData: JPEGDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeJPEG()" ------------------------ *)
PROCEDURE DecodeJPEG {"_DecodeJPEG"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectJPEGFuncs {"_SelectJPEGFuncs"} (spec{8}: JPEGDataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupJPEG(VAR codec: CodecHeader);

VAR     cnt: LONGINT;

BEGIN
  IF jpegData=NIL THEN
    NEW(jpegData);
    FOR cnt:=0 TO 3 DO ol.New(jpegData.quantTab[cnt],64*SIZE(LONGINT)); END;
  END;
  jpegData.gray:=grayScale;
  jpegData.yuvTab:=ys.GenYUVTables();
  jpegData.yuvBuf:=ys.AllocMCUBuffers(codec.width,codec.height);
  jpegData.limit:=ys.InitLimitTables();
  jpegData.cmap:=cmap;
  SelectJPEGFuncs(jpegData,(colorReduction & ~ham8) OR grayScale,o.dither);
  decoderProc:=DecodeJPEG;
  decoderSpec:=jpegData;
END SetupJPEG;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE MSVCData" ---------------------------- *)
TYPE    MSVCDataPtr=UNTRACED POINTER TO MSVCData;
        MSVCData=STRUCT
            gray: BOOLEAN;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     msvcData: MSVCDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeMSVC8()" ----------------------- *)
PROCEDURE DecodeMSVC8 {"_DecodeMSVC8"} (from{8}: e.APTR;
                                        to{9}: e.APTR;
                                        width{0}: LONGINT;
                                        height{1}: LONGINT;
                                        encSize{2}: LONGINT;
                                        spec{10}: e.APTR);

PROCEDURE SetupMSVC8(codec: CodecHeader);
BEGIN
  decoderProc:=DecodeMSVC8;
  decoderSpec:=NIL;
END SetupMSVC8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeMSVC16()" ----------------------- *)
PROCEDURE DecodeMSVC16toRGB {"_DecodeMSVC16toRGB"} (from{8}: e.APTR;
                                                    to{9}: e.APTR;
                                                    width{0}: LONGINT;
                                                    height{1}: LONGINT;
                                                    encSize{2}: LONGINT;
                                                    spec{10}: e.APTR);

PROCEDURE DecodeMSVC16to332 {"_DecodeMSVC16to332"} (from{8}: e.APTR;
                                                     to{9}: e.APTR;
                                                     width{0}: LONGINT;
                                                     height{1}: LONGINT;
                                                     encSize{2}: LONGINT;
                                                     spec{10}: e.APTR);

PROCEDURE DecodeMSVC16to332Dith {"_DecodeMSVC16to332Dith"} (from{8}: e.APTR;
                                                            to{9}: e.APTR;
                                                            width{0}: LONGINT;
                                                            height{1}: LONGINT;
                                                            encSize{2}: LONGINT;
                                                            spec{10}: e.APTR);

PROCEDURE SetupMSVC16(codec: CodecHeader);
BEGIN
  IF msvcData=NIL THEN NEW(msvcData); END;
  msvcData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    decoderProc:=DecodeMSVC16to332;
  ELSE
    IF o.dither THEN
      msvcData.limit:=ys.InitLimitTables();
      msvcData.cmap:=cmap;
      decoderProc:=DecodeMSVC16to332Dith;
    ELSE
      decoderProc:=DecodeMSVC16toRGB;
    END;
  END;
  decoderSpec:=msvcData;
END SetupMSVC16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE RGBData" ----------------------------- *)
TYPE    RGBDataPtr=UNTRACED POINTER TO RGBData;
        RGBData=STRUCT
            gray: BOOLEAN;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     rgbData: RGBDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRGB4()" ------------------------ *)
PROCEDURE DecodeRGB4 {"_DecodeRGB4"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SetupRGB4(codec: CodecHeader);
BEGIN
  decoderProc:=DecodeRGB4;
  decoderSpec:=NIL;
END SetupRGB4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRGB8()" ------------------------ *)
PROCEDURE DecodeRGB8 {"_DecodeRGB8"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SetupRGB8(codec: CodecHeader);
BEGIN
  decoderProc:=DecodeRGB8;
  decoderSpec:=NIL;
END SetupRGB8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRGB16()" ----------------------- *)
PROCEDURE DecodeRGB16toRGB {"_DecodeRGB16toRGB"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRGB16to332 {"_DecodeRGB16to332"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRGB16to332Dith {"_DecodeRGB16to332Dith"} (from{8}: e.APTR;
                                                          to{9}: e.APTR;
                                                          width{0}: LONGINT;
                                                          height{1}: LONGINT;
                                                          encSize{2}: LONGINT;
                                                          spec{10}: e.APTR);

PROCEDURE SetupRGB16(codec: CodecHeader);
BEGIN
  IF rgbData=NIL THEN NEW(rgbData); END;
  rgbData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    decoderProc:=DecodeRGB16to332;
  ELSE
    IF o.dither THEN
      rgbData.limit:=ys.InitLimitTables();
      rgbData.cmap:=cmap;
      decoderProc:=DecodeRGB16to332Dith;
    ELSE
      decoderProc:=DecodeRGB16toRGB;
    END;
  END;
  decoderSpec:=rgbData;
END SetupRGB16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRGB24()" ----------------------- *)
PROCEDURE DecodeRGB24toRGB {"_DecodeRGB24toRGB"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRGB24to332 {"_DecodeRGB24to332"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRGB24to332Dith {"_DecodeRGB24to332Dith"} (from{8}: e.APTR;
                                                          to{9}: e.APTR;
                                                          width{0}: LONGINT;
                                                          height{1}: LONGINT;
                                                          encSize{2}: LONGINT;
                                                          spec{10}: e.APTR);

PROCEDURE SetupRGB24(codec: CodecHeader);
BEGIN
  IF rgbData=NIL THEN NEW(rgbData); END;
  rgbData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    decoderProc:=DecodeRGB24to332;
  ELSE
    IF o.dither THEN
      rgbData.limit:=ys.InitLimitTables();
      rgbData.cmap:=cmap;
      decoderProc:=DecodeRGB24to332Dith;
    ELSE
      decoderProc:=DecodeRGB24toRGB;
    END;
  END;
  decoderSpec:=rgbData;
END SetupRGB24;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRGB32()" ----------------------- *)
PROCEDURE DecodeRGB32toRGB {"_DecodeRGB32toRGB"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRGB32to332 {"_DecodeRGB32to332"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRGB32to332Dith {"_DecodeRGB32to332Dith"} (from{8}: e.APTR;
                                                          to{9}: e.APTR;
                                                          width{0}: LONGINT;
                                                          height{1}: LONGINT;
                                                          encSize{2}: LONGINT;
                                                          spec{10}: e.APTR);

PROCEDURE SetupRGB32(codec: CodecHeader);
BEGIN
  IF rgbData=NIL THEN NEW(rgbData); END;
  rgbData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    decoderProc:=DecodeRGB32to332;
  ELSE
    IF o.dither THEN
      rgbData.limit:=ys.InitLimitTables();
      rgbData.cmap:=cmap;
      decoderProc:=DecodeRGB32to332Dith;
    ELSE
      decoderProc:=DecodeRGB32toRGB;
    END;
  END;
  decoderSpec:=rgbData;
END SetupRGB32;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRLE8()" ------------------------ *)
PROCEDURE DecodeRLE8 {"_DecodeRLE8"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SetupRLE8(codec: CodecHeader);
BEGIN
  decoderProc:=DecodeRLE8;
  decoderSpec:=NIL;
END SetupRLE8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE ULTIData" ---------------------------- *)
TYPE    LONGPTR=UNTRACED POINTER TO ARRAY MAX(INTEGER) OF LONGINT;

        LTCTabPtr=UNTRACED POINTER TO ARRAY 16384 OF CHAR;

        ULTIDataPtr=UNTRACED POINTER TO ULTIData;
        ULTIData=STRUCT
            gray: BOOLEAN;
            ltcTab: LTCTabPtr;
            cr: ARRAY 16 OF LONGINT;
            cb: ARRAY 16 OF LONGINT;
            crcb: ARRAY 256 OF LONGINT;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     ultiData: ULTIDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeULTI()" ------------------------ *)
PROCEDURE DecodeULTItoRGB {"_DecodeULTItoRGB"} (from{8}: e.APTR;
                                                to{9}: e.APTR;
                                                width{0}: LONGINT;
                                                height{1}: LONGINT;
                                                encSize{2}: LONGINT;
                                                spec{10}: e.APTR);

PROCEDURE DecodeULTIto332 {"_DecodeULTIto332"} (from{8}: e.APTR;
                                                to{9}: e.APTR;
                                                width{0}: LONGINT;
                                                height{1}: LONGINT;
                                                encSize{2}: LONGINT;
                                                spec{10}: e.APTR);

PROCEDURE DecodeULTIto332Dith {"_DecodeULTIto332Dith"} (from{8}: e.APTR;
                                                        to{9}: e.APTR;
                                                        width{0}: LONGINT;
                                                        height{1}: LONGINT;
                                                        encSize{2}: LONGINT;
                                                        spec{10}: e.APTR);

PROCEDURE GenUltiLTC();

TYPE    arr=ARRAY 20 OF LONGINT;

  PROCEDURE check(val: LONGINT; a: arr): BOOLEAN;
  VAR   x: INTEGER;
  BEGIN
    x:=0;
    WHILE a[x]#255 DO
      IF a[x]=val THEN RETURN TRUE; END;
      INC(x);
    END;
    RETURN FALSE;
  END check;

CONST   lin=arr( 2, 3, 5, 6, 7, 8,11,14,17,20,255,255,255,255,255,255,255,255,255,255);
        lo=arr(  4, 5, 6, 7, 8,11,14,17,20,23, 26, 29, 32, 36,255,255,255,255,255,255);
        hi=arr(  6, 8,11,14,17,20,23,26,29,32, 35, 40, 46,255,255,255,255,255,255,255);

VAR     ys: LONGINT;
        ye: LONGINT;
        ydelta: LONGINT;
        x: LONGINT;
        yinc: LONGINT;
        y1,y2: LONGINT;
        yd: e.FLOAT;
        tab: LTCTabPtr;

BEGIN
  x:=0;
  tab:=ultiData.ltcTab;
  FOR ys:=0 TO 63 DO
    FOR ye:=ys TO 63 DO
      ydelta:=ye-ys;
      IF check(ydelta,lin) THEN
        yinc:=(ydelta+1) DIV 3;
        tab[x]:=CHR(ys); tab[x+1]:=CHR(ys+yinc); tab[x+2]:=CHR(ye-yinc); tab[x+3]:=CHR(ye); INC(x,4);
      END;
      IF check(ydelta,lo) THEN
        yd:=ydelta;
        y1:=ye-ENTIER(((2*yd-5.0)/10.0));
        y2:=ye-ENTIER(((  yd-5.0)/10.0));
        tab[x]:=CHR(ys); tab[x+1]:=CHR(y1); tab[x+2]:=CHR(y2); tab[x+3]:=CHR(ye); INC(x,4);
        y2:=ys+ENTIER(((2*yd+5.0)/10.0));
        tab[x]:=CHR(ys); tab[x+1]:=CHR(y2); tab[x+2]:=CHR(y1); tab[x+3]:=CHR(ye); INC(x,4);
        y1:=ys+ENTIER(((  yd+5.0)/10.0));
        tab[x]:=CHR(ys); tab[x+1]:=CHR(y1); tab[x+2]:=CHR(y2); tab[x+3]:=CHR(ye); INC(x,4);
      END;
      IF check(ydelta,hi) THEN
        tab[x]:=CHR(ys); tab[x+1]:=CHR(ye); tab[x+2]:=CHR(ye); tab[x+3]:=CHR(ye); INC(x,4);
        tab[x]:=CHR(ys); tab[x+1]:=CHR(ys); tab[x+2]:=CHR(ye); tab[x+3]:=CHR(ye); INC(x,4);
        tab[x]:=CHR(ys); tab[x+1]:=CHR(ys); tab[x+2]:=CHR(ys); tab[x+3]:=CHR(ye); INC(x,4);
      END;
    END;
  END;
END GenUltiLTC;

PROCEDURE GenUltiYUV();

VAR     rt: e.FLOAT;
        bt: e.FLOAT;
        cnt: INTEGER;
        r: e.FLOAT;
        b: e.FLOAT;
        tmp: INTEGER;
        str: e.STRING;

BEGIN
  rt:=16384.0*1.40200;
  bt:=16384.0*1.77200;
  FOR cnt:=0 TO 15 DO
    r:=63.0*((cnt-5.0)/40.0);
    b:=63.0*((cnt-6.0)/34.0);
    ultiData.cr[cnt]:=ENTIER(rt*r);
    ultiData.cb[cnt]:=ENTIER(bt*b);
  END;
  rt:=16384.0*(-0.71414);
  bt:=16384.0*(-0.34414);
  FOR cnt:=0 TO 255 DO
    tmp:=cnt MOD 16;
    r:=63.0*((tmp-5.0)/40.0);
    tmp:=(cnt DIV 16) MOD 16;
    b:=63.0*((tmp-6.0)/34.0);
    ultiData.crcb[cnt]:=ENTIER(bt*b+rt*r);
  END;
END GenUltiYUV;

PROCEDURE SetupULTI(codec: CodecHeader);
BEGIN
  IF ultiData=NIL THEN
    NEW(ultiData);
    NEW(ultiData.ltcTab);
    GenUltiLTC();
    GenUltiYUV();
  END;
  ultiData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    decoderProc:=DecodeULTIto332;
  ELSE
    IF o.dither THEN
      ultiData.limit:=ys.InitLimitTables();
      ultiData.cmap:=cmap;
      decoderProc:=DecodeULTIto332Dith;
    ELSE
      decoderProc:=DecodeULTItoRGB;
    END;
  END;
  decoderSpec:=ultiData;
END SetupULTI;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE YUV2Data" ---------------------------- *)
TYPE    YUV2DataPtr=UNTRACED POINTER TO YUV2Data;
        YUV2Data=STRUCT
            gray: BOOLEAN;
            yuvTab: ys.YUVTablePtr;
            yuvBuf: ys.YUVBufferPtr;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     yuv2Data: YUV2DataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeYUV2()" ------------------------ *)
PROCEDURE DecodeYUV2A {"_DecodeYUV2A"} (from{8}: e.APTR;
                                        to{9}: e.APTR;
                                        width{0}: LONGINT;
                                        height{1}: LONGINT;
                                        encSize{2}: LONGINT;
                                        spec{10}: e.APTR);

PROCEDURE DecodeYUV2B {"_DecodeYUV2B"} (from{8}: e.APTR;
                                        to{9}: e.APTR;
                                        width{0}: LONGINT;
                                        height{1}: LONGINT;
                                        encSize{2}: LONGINT;
                                        spec{10}: e.APTR);

PROCEDURE SelectYUV2Funcs {"_SelectYUV2Funcs"} (spec{8}: YUV2DataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupYUV2(codec: CodecHeader);
BEGIN
  IF yuv2Data=NIL THEN NEW(yuv2Data); END;
  yuv2Data.gray:=grayScale;
  yuv2Data.yuvTab:=ys.GenYUVTables();
  yuv2Data.yuvBuf:=ys.AllocMCUBuffers(codec.width,codec.height);
  yuv2Data.limit:=ys.InitLimitTables();
  yuv2Data.cmap:=cmap;
  SelectYUV2Funcs(yuv2Data,(colorReduction & ~ham8) OR grayScale,o.dither);
  IF codec.compression=idYUV2 THEN
    decoderProc:=DecodeYUV2A;
  ELSE
    decoderProc:=DecodeYUV2B;
  END;
  decoderSpec:=yuv2Data;
END SetupYUV2;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE YUV9Data" ---------------------------- *)
TYPE    YUV9DataPtr=UNTRACED POINTER TO YUV9Data;
        YUV9Data=STRUCT
            gray: BOOLEAN;
            yuvTab: ys.YUVTablePtr;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     yuv9Data: YUV9DataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeYUV9()" ------------------------ *)
PROCEDURE DecodeYUV9 {"_DecodeYUV9"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectYUV9Funcs {"_SelectYUV9Funcs"} (spec{8}: YUV9DataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupYUV9(codec: CodecHeader);
BEGIN
  IF yuv9Data=NIL THEN NEW(yuv9Data); END;
  yuv9Data.gray:=grayScale;
  yuv9Data.yuvTab:=ys.GenYUVTables();
  yuv9Data.limit:=ys.InitLimitTables();
  yuv9Data.cmap:=cmap;
  SelectYUV9Funcs(yuv9Data,(colorReduction & ~ham8) OR grayScale,o.dither);
  decoderProc:=DecodeYUV9;
  decoderSpec:=yuv9Data;
END SetupYUV9;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE YV12Data" ---------------------------- *)
TYPE    YV12DataPtr=UNTRACED POINTER TO YV12Data;
        YV12Data=STRUCT
            gray: BOOLEAN;
            yuvTab: ys.YUVTablePtr;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     yv12Data: YV12DataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeYV12()" ------------------------ *)
PROCEDURE DecodeYV12 {"_DecodeYV12"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectYV12Funcs {"_SelectYV12Funcs"} (spec{8}: YV12DataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupYV12(codec: CodecHeader);
BEGIN
  IF yv12Data=NIL THEN NEW(yv12Data); END;
  yv12Data.gray:=grayScale;
  yv12Data.yuvTab:=ys.GenYUVTables();
  yv12Data.limit:=ys.InitLimitTables();
  yv12Data.cmap:=cmap;
  SelectYV12Funcs(yv12Data,(colorReduction & ~ham8) OR grayScale,o.dither);
  decoderProc:=DecodeYV12;
  decoderSpec:=yv12Data;
END SetupYV12;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CodecQuery()" ------------------------ *)
PROCEDURE CodecQuery * (VAR codec: CodecHeader): LONGINT;

VAR     ret: LONGINT;

BEGIN
  ret:=codecSupported;
  IF codec.depth>32 THEN
    DEC(codec.depth,32);
    grayScale:=TRUE;
    Init332ColorMap();
  END;

  CASE codec.compression OF
  | idcvid,
    idCVID:
      codec.compression:=idCVID;
      codec.description:="Radius Cinepak";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF (codec.depth=8) OR (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupCVID(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idjpeg,
    idJPEG,
    idmJPG,
    idMJPG:
      IF (codec.compression=idMJPG) OR (codec.compression=idmJPG) THEN
        codec.compression:=idMJPG;
        codec.description:="Motion JPEG";
      ELSE
        codec.compression:=idJPEG;
        codec.description:="JFIF JPEG";
      END;
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,2);
      IF (codec.depth=8) OR (codec.depth=24) THEN
        SetupJPEG(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idmsvc,
    idMSVC,
    idCRAM:
      codec.compression:=idMSVC;
      codec.description:="Microsoft Video 1";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF codec.depth=8 THEN
        SetupMSVC8(codec);
        rawDecoderProc:=decoderProc;
      ELSIF codec.depth=16 THEN
        SetupMSVC16(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idrgb,
    idRGB:
      codec.compression:=idRGB;
      codec.description:="Microsoft RGB";
      IF codec.depth=4 THEN
        SetupRGB4(codec);
        rawDecoderProc:=decoderProc;
      ELSIF codec.depth=8 THEN
        SetupRGB8(codec);
        rawDecoderProc:=decoderProc;
      ELSIF codec.depth=16 THEN
        SetupRGB16(codec);
        rawDecoderProc:=decoderProc;
      ELSIF codec.depth=24 THEN
        SetupRGB24(codec);
        rawDecoderProc:=decoderProc;
      ELSIF codec.depth=32 THEN
        SetupRGB32(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idrle8,
    idRLE8:
      codec.compression:=idRLE8;
      codec.description:="Microsoft RLE8";
      IF codec.depth=8 THEN
        SetupRGB8(codec);
        rawDecoderProc:=decoderProc;
        SetupRLE8(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idulti,
    idULTI:
      codec.compression:=idULTI;
      codec.description:="IBM Ultimotion";
      codec.width:=i2m.Round(codec.width,8);
      codec.height:=i2m.Round(codec.height,8);
      IF codec.depth=16 THEN
        SetupULTI(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idyuv2,
    idYUV2,
    id2vuy,
    id2VUY,
    idVYUY:
      IF codec.compression=idVYUY THEN
        codec.compression:=idVYUY;
        codec.description:="Component Video (YUV2) Type B"; (* vielleicht auch "ATI Packed YUV" *)
      ELSE
        codec.compression:=idYUV2;
        codec.description:="Component Video (YUV2) Type A";
      END;
      codec.width:=i2m.Round(codec.width,2);
      codec.height:=i2m.Round(codec.height,2);
      IF (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupYUV2(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idYUV9,
    idYVU9,
    id9VUY,
    id9UVY:
      codec.compression:=idYUV9;
      codec.description:="Intel Raw (YUV9)";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF (codec.depth=9) OR (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupYUV9(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idyv12,
    idYV12:
      codec.compression:=idYV12;
      codec.description:="YUV12 Planar MPEG";
      IF (codec.depth=12) OR (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupYV12(codec);
        rawDecoderProc:=decoderProc;
      ELSE
        ret:=codecUnsupported;
      END;
  | idxmpg,
    idXMPG:
      codec.compression:=idXMPG;
      codec.description:="Editable MPEG";
      ret:=codecUnsupported;
  | idIJPG:
      codec.description:="Intergraph JPEG";
      ret:=codecUnsupported;
  | idrle4,
    idRLE4:
      codec.compression:=idRLE4;
      codec.description:="Microsoft RLE4";
      ret:=codecUnsupported;
  | idrt21,
    idRT21:
      codec.compression:=idRT21;
      codec.description:="Intel Indeo R2.1";
      ret:=codecUnsupported;
  | idiv31,
    idIV31:
      codec.compression:=idIV31;
      codec.description:="Intel Indeo R3.1";
      ret:=codecUnsupported;
  | idiv32,
    idIV32:
      codec.compression:=idIV32;
      codec.description:="Intel Indeo R3.2";
(*
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      SetupIV32(codec);
      ret:=codecSupported;
*)
      ret:=codecUnsupported;
  | idiv41,
    idIV41:
      codec.compression:=idIV41;
      codec.description:="Intel Indeo R4.1";
      ret:=codecUnsupported;
  | idcyuv,
    idCYUV:
      codec.compression:=idCYUV;
      codec.description:="Creative Technology (CYUV)";
      ret:=codecUnsupported;
  | idVDOW:
      codec.description:="VDONet Video";
      ret:=codecUnsupported;
  ELSE
    ret:=codecUnknown;
  END;
  RETURN ret;
END CodecQuery;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE FastC2P()" ------------------------- *)
PROCEDURE FastC2P4 {"_FastC2P4"} (chunky{8}: e.APTR;
                                  bitmap{9}: gfx.BitMapPtr;
                                  realWidth{1}: LONGINT);

PROCEDURE FastC2P8 {"_FastC2P8"} (chunky{8}: e.APTR;
                                  bitmap{9}: gfx.BitMapPtr;
                                  realWidth{1}: LONGINT);
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE RGBtoHAM8()" ------------------------ *)
PROCEDURE RGBtoHAM8 {"_RGBtoHAM8"} (rgb{8}: e.APTR;
                                    ham8{9}: e.APTR;
                                    width{0}: LONGINT;
                                    height{1}: LONGINT);
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DisplayFrame()" ----------------------- *)
PROCEDURE DisplayFrameDummy();
BEGIN
END DisplayFrameDummy;

PROCEDURE DisplayFrameAGA();
BEGIN
  gfx.WaitBlit();
  IF ham8 THEN
    RGBtoHAM8(videoDataDec,ham8Buffer,calcWidth,calcHeight);
    fastc2pProc(ham8Buffer,tmpBM,calcWidth);
  ELSE
    fastc2pProc(videoDataDec,tmpBM,calcWidth);
  END;
  gfx.BltBitMapRastPort(tmpBM,0,0,rp,leftOff,topOff,animWidth,animHeight,y.VAL(y.BYTE,0C0H));
END DisplayFrameAGA;

PROCEDURE DisplayFrameCyberGfx();

VAR     width: INTEGER;
        height: INTEGER;

BEGIN
  IF pubScreen THEN
    IF animDepth>8 THEN
      width:=window.width-(window.borderLeft+window.borderRight);
      height:=window.height-(window.borderTop+window.borderBottom);
      IF (width#animWidth) OR (height#animHeight) THEN
        y.SETREG(0,cgfx.ScalePixelArray(videoDataDec,animWidth,animHeight,dispModulo,rp,leftOff,topOff,width,height,colorType));
      ELSE
        y.SETREG(0,cgfx.WritePixelArray(videoDataDec,0,0,dispModulo,rp,leftOff,topOff,animWidth,animHeight,colorType));
      END;
    ELSE
      y.SETREG(0,cgfx.WriteLUTPixelArray(videoDataDec,0,0,dispModulo,rp,cmap,leftOff,topOff,animWidth,animHeight,cgfx.fmtXRGB8));
    END;
  ELSE
    y.SETREG(0,cgfx.WritePixelArray(videoDataDec,0,0,dispModulo,rp,leftOff,topOff,animWidth,animHeight,colorType));
  END;
END DisplayFrameCyberGfx;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeFrame()" ----------------------- *)
PROCEDURE DecodeFrame * (size: LONGINT;
                         raw: BOOLEAN);
BEGIN
  io.Read(videoData,size);
  IF raw & (size>=frameSize) THEN (* Workaround für kaputte MAB-AVIs, MAB speichert bei RLE oft 00db statt 00dc *)
    (* rawDecoderProc(videoData,videoDataDec,calcWidth,calcHeight,size,decoderSpec); *)
  ELSE
    decoderProc(videoData,videoDataDec,calcWidth,calcHeight,size,decoderSpec);
  END;
(*
  IF iv32Data#NIL THEN
    d.PrintF("%08lx\n",videoData);
    d.PrintF("%08lx\t%08lx\n",ivm1,ivm4);
    d.PrintF("%08lx\t%08lx\t%08lx%3ld\t\t%08lx\t%08lx\t%08lx\n",iv32Data.x[0],iv32Data.x[1],iv32Data.x[2],iv32Data.x[3],iv32Data.x[4],iv32Data.x[5],iv32Data.x[6]);
  END;
*)
  displayProc();
END DecodeFrame;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE ReadColorMap()" ----------------------- *)
PROCEDURE ReadColorMap * (colorCnt: LONGINT;
                          palChange: BOOLEAN);

TYPE    color=ARRAY 4 OF CHAR;

VAR     cnt: LONGINT;
        cReg: color;
        grayColor: LONGINT;

BEGIN
  grayScale:=o.grayScale;
  IF colorCnt=0 THEN (* =0 bedeutet TrueColor *)
    DISPOSE(colorMap);
    DISPOSE(secondColorMap);
  ELSE
    IF colorMap=NIL THEN NEW(colorMap); END;
    colorMap.count:=256; (* müßte colorCnt sein, kann aber Probleme geben *)
    colorMap.first:=0;
    colorMap.last:=255; (* müßte colorCnt-1 sein, kann aber Probleme geben *)
    FOR cnt:=0 TO colorCnt-1 DO
      cReg:=y.VAL(color,io.GetLSBLong());
      IF grayScale THEN
        grayColor:=i2m.ByteTo32(CHR(y.LSH(ORD(cReg[1])*11+ORD(cReg[2])*16+ORD(cReg[3])*5,-5)));
        colorMap.colors[cnt].red:=grayColor;
        colorMap.colors[cnt].green:=grayColor;
        colorMap.colors[cnt].blue:=grayColor;
        cmap[cnt].red:=CHR(grayColor);
        cmap[cnt].green:=CHR(grayColor);
        cmap[cnt].blue:=CHR(grayColor);
      ELSE
        colorMap.colors[cnt].red:=i2m.ByteTo32(cReg[1]);
        colorMap.colors[cnt].green:=i2m.ByteTo32(cReg[2]);
        colorMap.colors[cnt].blue:=i2m.ByteTo32(cReg[3]);
        cmap[cnt].red:=cReg[1];
        cmap[cnt].green:=cReg[2];
        cmap[cnt].blue:=cReg[3];
      END;
    END;
    IF palChange THEN
      IF secondColorMap=NIL THEN
        NEW(secondColorMap);
        NEW(secondCmap);
      END;
      e.CopyMemQuickAPTR(colorMap,secondColorMap,SIZE(colorMap^));
      e.CopyMemQuickAPTR(cmap,secondCmap,SIZE(cmap^));
    ELSE
      DISPOSE(secondColorMap);
      DISPOSE(secondCmap);
    END;
  END;
END ReadColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------- "PROCEDURE ChangeColorMap()" ---------------------- *)
PROCEDURE ChangeColorMap * (size: LONGINT);

TYPE    ColorPair=STRUCT
            first: CHAR;
            num: CHAR;
        END;
        ColorArr=ARRAY 4 OF CHAR;

VAR     palInfo: ColorPair;
        color: ColorArr;
        first: INTEGER;
        last: INTEGER;
        cnt: INTEGER;
        tcmap: ColorMapArrayPtr;
        grayColor: LONGINT;

BEGIN
  palInfo:=y.VAL(ColorPair,io.GetMSBShort());
  io.Skip(2);
  DEC(size,4);
  first:=ORD(palInfo.first);
  last:=first+ORD(palInfo.num)-1;
  IF last<0 THEN last:=255 END;
  FOR cnt:=first TO last DO
    color:=y.VAL(ColorArr,io.GetMSBLong());
    IF grayScale THEN
      grayColor:=i2m.ByteTo32(CHR(y.LSH(ORD(color[0])*11+ORD(color[1])*16+ORD(color[2])*5,-5)));
      colorMap.colors[cnt].red:=grayColor;
      colorMap.colors[cnt].green:=grayColor;
      colorMap.colors[cnt].blue:=grayColor;
      cmap[cnt].red:=CHR(grayColor);
      cmap[cnt].green:=CHR(grayColor);
      cmap[cnt].blue:=CHR(grayColor);
    ELSE
      colorMap.colors[cnt].red:=i2m.ByteTo32(color[0]);
      colorMap.colors[cnt].green:=i2m.ByteTo32(color[1]);
      colorMap.colors[cnt].blue:=i2m.ByteTo32(color[2]);
      cmap[cnt].red:=color[0];
      cmap[cnt].green:=color[1];
      cmap[cnt].blue:=color[2];
    END;
    DEC(size,4);
  END;
  IF ~pubScreen THEN
    tcmap:=y.VAL(ColorMapArrayPtr,colorMap);
    gfx.LoadRGB32(y.ADR(screen.viewPort),tcmap^);
  END;
  IF size>0 THEN io.Skip(size); END;
END ChangeColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------- "PROCEDURE Restore1stColorMap()" -------------------- *)
PROCEDURE Restore1stColorMap * ();

VAR     tcmap: ColorMapArrayPtr;

BEGIN
  IF secondColorMap#NIL THEN
    e.CopyMemQuickAPTR(secondColorMap,colorMap,SIZE(secondColorMap^));
    e.CopyMemQuickAPTR(secondCmap,cmap,SIZE(secondCmap^));
    tcmap:=y.VAL(ColorMapArrayPtr,secondColorMap);
    gfx.LoadRGB32(y.ADR(screen.viewPort),tcmap^);
  END;
END Restore1stColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE AllocBuffers()" ----------------------- *)
PROCEDURE AllocBuffers * (): BOOLEAN;

VAR     codec: CodecHeader;
        size: LONGINT;
        ret: BOOLEAN;

BEGIN
  colorReduction:=g.agaOnly OR (g.gfxBoth & o.aga) OR (g.cgfxOnly & o.aga);
  ham8:=o.ham8;
  ret:=TRUE;
  animWidth:=i.LongToUInt(g.animInfo.vids.strf.width);
  animHeight:=i.LongToUInt(g.animInfo.vids.strf.height);
  animDepth:=i.LongToUInt(g.animInfo.vids.strf.bitCnt);
  codec.compression:=g.animInfo.vids.strf.compression;
  codec.width:=g.animInfo.vids.strf.width;
  codec.height:=g.animInfo.vids.strf.height;
  codec.depth:=g.animInfo.vids.strf.bitCnt;
  CASE CodecQuery(codec) OF
  | codecUnsupported:
      d.PrintF("  Unsupported video encoding: %s [",y.ADR(codec.description)); cu.PrintFCC(codec.compression); d.PrintF("], depth %ld\n",animDepth);
      ret:=FALSE;
      IF (codec.compression=idRT21) OR (codec.compression=idIV31) OR (codec.compression=idIV32) OR (codec.compression=idIV41) THEN d.PrintF("Please consult the manual/FAQ for information about Intel Indeo\n"); END;
  | codecUnknown:
      d.PrintF("  Unknown video encoding: "); cu.PrintFCC(codec.compression); d.PrintF(", depth %ld\n",animDepth);
      ret:=FALSE;
  ELSE
    calcWidth:=codec.width;
    calcHeight:=codec.height;
    animDepth:=i.LongToUInt(codec.depth); (* Tiefe kann sich geändert haben! *)
    IF ~o.quiet THEN
      d.PrintF("  Video: %s, %ld bit, %ld×%ld, %ld fps\n",y.ADR(codec.description),
                                                          animDepth,
                                                          animWidth,
                                                          animHeight,
                                                          s.GetFPS());
    END;
    DISPOSE(videoData);
    DISPOSE(ham8Buffer);
    DISPOSE(videoDataDec);
    frameSize:=i2m.Round(calcWidth*calcHeight,2); (* ungerade Größen ergeben Mungwall-Hits *)
    dispModulo:=i.LongToUInt(calcWidth);
    videoBufferSize:=i2m.Round(g.animInfo.vids.strh.suggestedBufferSize,2); (* ungerade Größen ergeben Mungwall-Hits *)
    IF (videoBufferSize>frameSize) & (videoBufferSize>frameSize*3) OR (videoBufferSize<g.animInfo.avih.suggestedBufferSize) THEN videoBufferSize:=0; END;
    IF animDepth<=8 THEN
      ham8:=FALSE;
      IF videoBufferSize=0 THEN videoBufferSize:=frameSize*2; END; (* 2fache Größe, manche Videos sind leicht schrottig *)
      colorType:=cgfx.rectFmtLUT8;
    ELSE
      IF ham8 THEN ol.New(ham8Buffer,frameSize); END;
      IF grayScale THEN
        colorType:=cgfx.rectFmtGREY8;
      ELSE
        colorType:=cgfx.rectFmtRGB;
        dispModulo:=dispModulo*3;
        frameSize:=frameSize*3;
      END;
      IF videoBufferSize=0 THEN videoBufferSize:=frameSize*2; END; (* 2fache Größe, manche Videos sind leicht schrottig *)
    END;
    ol.New(videoData,videoBufferSize);
    ol.New(videoDataDec,frameSize);
    IF ~o.noVideo THEN
      IF colorReduction THEN
        displayProc:=DisplayFrameAGA;
        IF animDepth=4 THEN
          fastc2pProc:=FastC2P4;
        ELSE
          fastc2pProc:=FastC2P8;
        END;
      ELSE
        displayProc:=DisplayFrameCyberGfx;
      END;
    ELSE
      displayProc:=DisplayFrameDummy;
      colorReduction:=FALSE;
    END;
  END;
  RETURN ret;
END AllocBuffers;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  NEW(cmap);
CLOSE
  CloseDisplay();
END CyberAVIVideo.

