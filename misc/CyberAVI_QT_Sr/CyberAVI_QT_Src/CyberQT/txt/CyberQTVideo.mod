MODULE  CyberQTVideo;

(* $IFNOT DEBUG *)
  (* $StackChk- $OvflChk- $RangeChk- $CaseChk- $ReturnChk- $NilChk- $TypeChk- $OddChk- $ClearVars- *)
(* $END *)

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  b:=BestModeID,
        cgfx:=CyberGraphics,
        cu:=CyberQTUtils,
        d:=Dos,
        e:=Exec,
        es:=ExecSupport,
        fp:=FixedPoint,
        g:=CyberQTGlobals,
        gfx:=Graphics,
        i:=Intuition,
        iff:=IFFParse,
        io:=AsyncIOSupport2,
        i2m:=Intel2Mot,
        lv:=LibraryVer,
        m:=MathTrans,
        mu:=MathUtils,
        o:=CyberQTOpts,
        ol:=OberonLib,
        s:=CyberQTSync,
        sl:=StringLib,
        u:=Utility,
        y:=SYSTEM,
        ys:=YUVStuff;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "CONST" -------------------------------- *)
CONST   idmsvc=y.VAL(LONGINT,"msvc");
        idMSVC=y.VAL(LONGINT,"MSVC");
        idcram=y.VAL(LONGINT,"cram");
        idCRAM=y.VAL(LONGINT,"CRAM");
        idrle =y.VAL(LONGINT,"rle ");
        idsmc =y.VAL(LONGINT,"smc ");
        idraw =y.VAL(LONGINT,"raw ");
        idrpza=y.VAL(LONGINT,"rpza");
        idazpr=y.VAL(LONGINT,"azpr");
        idjpeg=y.VAL(LONGINT,"jpeg");
        idRT21=y.VAL(LONGINT,"RT21");
        idrt21=y.VAL(LONGINT,"rt21");
        idIV31=y.VAL(LONGINT,"IV31");
        idiv31=y.VAL(LONGINT,"iv31");
        idIV32=y.VAL(LONGINT,"IV32");
        idiv32=y.VAL(LONGINT,"iv32");
        idIV41=y.VAL(LONGINT,"IV41");
        idiv41=y.VAL(LONGINT,"iv41");
        idIV50=y.VAL(LONGINT,"IV50");
        idiv50=y.VAL(LONGINT,"iv50");
        idCVID=y.VAL(LONGINT,"CVID");
        idcvid=y.VAL(LONGINT,"cvid");
        idYUV2=y.VAL(LONGINT,"YUV2");
        idyuv2=y.VAL(LONGINT,"yuv2");
        id2VUY=y.VAL(LONGINT,"2VUY");
        id2vuy=y.VAL(LONGINT,"2vuy");
        idYUV9=y.VAL(LONGINT,"YUV9");
        idYVU9=y.VAL(LONGINT,"YVU9");
        id9VUY=y.VAL(LONGINT,"9VUY");
        id9UVY=y.VAL(LONGINT,"9UVY");
        idXMPG=y.VAL(LONGINT,"XMPG");
        idxmpg=y.VAL(LONGINT,"xmpg");
        idCYUV=y.VAL(LONGINT,"CYUV");
        idcyuv=y.VAL(LONGINT,"cyuv");
        idkpcd=y.VAL(LONGINT,"kpcd");
        idKPCD=y.VAL(LONGINT,"KPCD");
        idmjpa=y.VAL(LONGINT,"mjpa");
        idmjpb=y.VAL(LONGINT,"mjpb");

        codecSupported * =1;
        codecUnknown * =0;
        codecUnsupported * =-1;

        tmpRasSize=4096;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    DecoderProc=PROCEDURE(from{8}: e.APTR;
                              to{9}: e.APTR;
                              width{0}: LONGINT;
                              height{1}: LONGINT;
                              encSize{2}: LONGINT;
                              spec{10}: e.APTR);

        FastC2PProc=PROCEDURE(chunky{8}: e.APTR;
                              bitmap{9}: gfx.BitMapPtr;
                              realWidth{1}: LONGINT);

        DisplayProc=PROCEDURE();

        CodecHeader=STRUCT
            decoder: DecoderProc;
            special: e.APTR;
            compression: LONGINT;
            width: LONGINT;
            height: LONGINT;
            depth: LONGINT;
            description: e.STRING;
        END;

        CodecArray=UNTRACED POINTER TO ARRAY MAX(INTEGER) OF CodecHeader;

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
VAR     videoFile: io.ASFile;
        screen: i.ScreenPtr;
        window: i.WindowPtr;
        mouse: i.ObjectPtr;
        mouseBitMap: gfx.BitMapPtr;
        colorReduction: BOOLEAN;
        ham8: BOOLEAN;
        animWidth: INTEGER;
        animHeight: INTEGER;
        animDepth: LONGINT;
        dispModulo: INTEGER;
        calcWidth: LONGINT;
        calcHeight: LONGINT;
        colorMap: ColorMapPtr;
        videoBufferSize: LONGINT;
        videoData: e.LSTRPTR;
        videoDataDec: e.LSTRPTR;
        ham8Buffer: e.LSTRPTR;
        codecs: CodecArray;
        codecCnt: LONGINT;
        currentCodec: LONGINT;
        decoderProc: DecoderProc;
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
(*
      | ORD("P"),ORD("p"): ret:=g.pauseAnim;
*)
      ELSE
      END;
    ELSIF i.rawKey IN msg.class THEN
      CASE msg.code OF
      | 69: ret:=g.skipAnim     (* ESC *)
      | 80: s.SetSpeedFactor( 0.0);      (* F1, maximal *)
      | 81: s.SetSpeedFactor( 0.1);      (* F2, 1000%   *)
      | 82: s.SetSpeedFactor( 0.2);      (* F3,  500%   *)
      | 83: s.SetSpeedFactor( 0.333333); (* F4,  300%   *)
      | 84: s.SetSpeedFactor( 0.5);      (* F5,  200%   *)
      | 85: s.SetSpeedFactor( 1.0);      (* F6,  100%   *)
      | 86: s.SetSpeedFactor( 1.333333); (* F7,   75%   *)
      | 87: s.SetSpeedFactor( 2.0);      (* F8,   50%   *)
      | 88: s.SetSpeedFactor( 5.0);      (* F9,   20%   *)
      | 89: s.SetSpeedFactor(10.0);      (* F10,  10%   *)
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
              (* cmap[cnt] nicht setzen, sonst gibts massiv Falschfarben *)
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
        g: LONGINT;

BEGIN
  IF colorMap=NIL THEN NEW(colorMap); END;
  FOR cnt:=0 TO 255 DO
    IF grayScale THEN
      g:=i2m.ByteTo32(CHR(cnt));
      colorMap.colors[cnt].red:=g;
      colorMap.colors[cnt].green:=g;
      colorMap.colors[cnt].blue:=g;
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

(* /// --------------------- "PROCEDURE InitDefColorMap()" --------------------- *)
PROCEDURE InitDefColorMap(depth: LONGINT);


CONST   qt4map="\xFF\xFB\xFF"
               "\xEF\xD9\xBB"
               "\xE8\xC9\xB1"
               "\x93\x65\x5E"
               "\xFC\xDE\xE8"
               "\x9D\x88\x91"
               "\xFF\xFF\xFF"
               "\xFF\xFF\xFF"
               "\xFF\xFF\xFF"
               "\x47\x48\x37"
               "\x7A\x5E\x55"
               "\xDF\xD0\xAB"
               "\xFF\xFB\xF9"
               "\xE8\xCA\xC5"
               "\x8A\x7C\x77";

        pat10="\xEE\xDD\xBB\xAA\x88\x77\x55\x44\x22\x11";

VAR     cnt: LONGINT;
        r: INTEGER;
        g: INTEGER;
        b: INTEGER;
        val: LONGINT;

BEGIN
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("init default colormap\n"); END;
(* \\\ $END *)
  IF colorMap=NIL THEN NEW(colorMap); END;
  IF depth=1 THEN
    colorMap.colors[0].red:=0;
    colorMap.colors[0].green:=0;
    colorMap.colors[0].blue:=0;
    colorMap.colors[1].red:=0FFFFFFFFH;
    colorMap.colors[1].green:=0FFFFFFFFH;
    colorMap.colors[1].blue:=0FFFFFFFFH;
    cmap[0].red:=000X;
    cmap[0].green:=000X;
    cmap[0].blue:=000X;
    cmap[1].red:=0FFX;
    cmap[1].green:=0FFX;
    cmap[1].blue:=0FFX;
    colorMap.count:=2;
    colorMap.first:=0;
    colorMap.last:=1;
  ELSIF depth=4 THEN
    FOR cnt:=0 TO 14 DO
      colorMap.colors[cnt].red:=i2m.ByteTo32(qt4map[cnt+0]);
      colorMap.colors[cnt].green:=i2m.ByteTo32(qt4map[cnt+1]);
      colorMap.colors[cnt].blue:=i2m.ByteTo32(qt4map[cnt+2]);
      cmap[cnt].red:=qt4map[cnt+0];
      cmap[cnt].green:=qt4map[cnt+1];
      cmap[cnt].blue:=qt4map[cnt+2];
    END;
    colorMap.colors[15].red:=0;
    colorMap.colors[15].green:=0;
    colorMap.colors[15].blue:=0;
    cmap[15].red:=000X;
    cmap[15].green:=000X;
    cmap[15].blue:=000X;
    colorMap.count:=16;
    colorMap.first:=0;
    colorMap.last:=15;
  ELSE
    r:=0FFH;
    g:=0FFH;
    b:=0FFH;
    FOR cnt:=0 TO 214 DO
      colorMap.colors[cnt].red:=i2m.ByteTo32(CHR(r));
      colorMap.colors[cnt].green:=i2m.ByteTo32(CHR(g));
      colorMap.colors[cnt].blue:=i2m.ByteTo32(CHR(b));
      cmap[cnt].red:=CHR(r);
      cmap[cnt].green:=CHR(g);
      cmap[cnt].blue:=CHR(b);
      DEC(b,033H);
      IF b<0 THEN
        b:=0FFH;
        DEC(g,033H);
        IF g<0 THEN
          g:=0FFH;
          DEC(r,033H);
        END;
      END;
    END;
    FOR cnt:=0 TO 9 DO
      val:=i2m.ByteTo32(pat10[cnt]);
      colorMap.colors[215+cnt].red:=val;
      colorMap.colors[215+cnt].green:=0;
      colorMap.colors[215+cnt].blue:=0;
      cmap[215+cnt].red:=CHR(val);
      cmap[215+cnt].green:=000X;
      cmap[215+cnt].blue:=000X;
      colorMap.colors[225+cnt].red:=0;
      colorMap.colors[225+cnt].green:=val;
      colorMap.colors[225+cnt].blue:=0;
      cmap[225+cnt].red:=000X;
      cmap[225+cnt].green:=CHR(val);
      cmap[225+cnt].blue:=000X;
      colorMap.colors[235+cnt].red:=0;
      colorMap.colors[235+cnt].green:=0;
      colorMap.colors[235+cnt].blue:=val;
      cmap[235+cnt].red:=000X;
      cmap[235+cnt].green:=000X;
      cmap[235+cnt].blue:=CHR(val);
      colorMap.colors[245+cnt].red:=val;
      colorMap.colors[245+cnt].green:=val;
      colorMap.colors[245+cnt].blue:=val;
      cmap[245+cnt].red:=CHR(val);
      cmap[245+cnt].green:=CHR(val);
      cmap[245+cnt].blue:=CHR(val);
    END;
    colorMap.colors[255].red:=0;
    colorMap.colors[255].green:=0;
    colorMap.colors[255].blue:=0;
    cmap[255].red:=000X;
    cmap[255].green:=000X;
    cmap[255].blue:=000X;
    colorMap.count:=256;
    colorMap.first:=0;
    colorMap.last:=255;
  END;
END InitDefColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE InitGrayColorMap()" --------------------- *)
PROCEDURE InitGrayColorMap(depth: LONGINT;
                           backward: BOOLEAN);

VAR     cnt: LONGINT;
        g: LONGINT;
        gray: CHAR;

BEGIN
(* /// "$IF RUNDEBUG" *)
  IF o.debug THEN d.PrintF("init gray colormap\n"); END;
(* \\\ $END *)
  IF colorMap=NIL THEN NEW(colorMap); END;
  IF depth=36 THEN
    FOR cnt:=0 TO 15 DO
      gray:=CHR((15-cnt)*17);
      g:=i2m.ByteTo32(gray);
      colorMap.colors[cnt].red:=g;
      colorMap.colors[cnt].green:=g;
      colorMap.colors[cnt].blue:=g;
      cmap[cnt].red:=gray;
      cmap[cnt].green:=gray;
      cmap[cnt].blue:=gray;
    END;
    colorMap.count:=16;
    colorMap.first:=0;
    colorMap.last:=15;
  ELSE
    FOR cnt:=0 TO 255 DO
      IF backward THEN
        gray:=CHR(255-cnt);
      ELSE
        gray:=CHR(cnt);
      END;
      g:=i2m.ByteTo32(gray);
      colorMap.colors[cnt].red:=g;
      colorMap.colors[cnt].green:=g;
      colorMap.colors[cnt].blue:=g;
      cmap[cnt].red:=gray;
      cmap[cnt].green:=gray;
      cmap[cnt].blue:=gray;
    END;
    colorMap.count:=256;
    colorMap.first:=0;
    colorMap.last:=255;
  END;
  grayScale:=TRUE;
END InitGrayColorMap;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE InitColorMap()" ----------------------- *)
PROCEDURE InitColorMap * (desc: g.VideoDescriptionPtr);

TYPE    Color=STRUCT
            p: INTEGER;
            r: INTEGER;
            g: INTEGER;
            b: INTEGER;
        END;
        ColorArray=UNTRACED POINTER TO ARRAY MAX(INTEGER) OF Color;

VAR     cnt: LONGINT;
        grayColor: LONGINT;
        gray: CHAR;
        colorCnt: LONGINT;
        start: LONGINT;
        end: LONGINT;
        data: ColorArray;

BEGIN
  IF (desc.depth<=8) OR (desc.depth>32) THEN
    IF colorMap=NIL THEN NEW(colorMap); END;
    IF (desc.depth<32) & ~grayScale THEN
      InitDefColorMap(desc.depth);
    ELSE
      InitGrayColorMap(desc.depth,(desc.head.dataFormat#idcvid) & (desc.head.dataFormat#idCVID) & (desc.head.dataFormat#idjpeg));
    END;
    IF ~(3 IN y.VAL(SET,desc.colorTableID)) & (desc.head.size>86) THEN
(* /// "$IF RUNDEBUG" *)
      IF o.debug THEN d.PrintF("init own colormap\n"); END;
(* \\\ $END *)
      start:=desc.start;
      end:=desc.end;
(* normalerweise müßten diese Werte gesetzt werden, aber bei zB 247 Farben gibts Murx. *Kein* Fehler von CGX, tritt auch bei AGA-only auf
      colorMap.count:=i.LongToUInt(end-start+1);
      colorMap.first:=i.LongToUInt(start);
      colorMap.last:=end;
*)
      data:=y.ADR(desc.colorTable);
      FOR cnt:=start TO end DO
        IF grayScale THEN
          data[cnt].r:=y.LSH(data[cnt].r,-8);
          data[cnt].g:=y.LSH(data[cnt].g,-8);
          data[cnt].b:=y.LSH(data[cnt].b,-8);
          gray:=CHR(y.LSH(data[cnt].r*11+data[cnt].g*16+data[cnt].g*5,-5));
          grayColor:=i2m.ByteTo32(gray);
          colorMap.colors[cnt].red:=grayColor;
          colorMap.colors[cnt].green:=grayColor;
          colorMap.colors[cnt].blue:=grayColor;
          cmap[cnt].red:=gray;
          cmap[cnt].green:=gray;
          cmap[cnt].blue:=gray;
        ELSE
          colorMap.colors[cnt].red:=i2m.ShortTo32(data[cnt].r);
          colorMap.colors[cnt].green:=i2m.ShortTo32(data[cnt].g);
          colorMap.colors[cnt].blue:=i2m.ShortTo32(data[cnt].b);
          cmap[cnt].red:=CHR(y.LSH(data[cnt].r,-8));
          cmap[cnt].green:=CHR(y.LSH(data[cnt].g,-8));
          cmap[cnt].blue:=CHR(y.LSH(data[cnt].b,-8));
        END;
      END;
    END;
  END;
END InitColorMap;
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

(* /// --------------------- "PROCEDURE DetermineDepth()" ---------------------- *)
PROCEDURE DetermineDepth();

VAR     track: g.TrackPtr;
        usage: LONGINT;

BEGIN
  track:=g.animInfo.videoTracks.head;
  usage:=0;
  WHILE track.node.succ#NIL DO
    IF track.sizeEntries>usage THEN
      animDepth:=y.VAL(g.VideoDescriptionPtr,track.descriptions[track.descriptionEntries-1]).depth;
      usage:=track.sizeEntries;
    ELSE
      IF y.VAL(g.VideoDescriptionPtr,track.descriptions[track.descriptionEntries-1]).depth>32 THEN grayScale:=TRUE; END;
    END;
    track:=track.node.succ;
  END;
  IF animDepth>32 THEN
    grayScale:=TRUE;
    DEC(animDepth,32);
  END;
END DetermineDepth;
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
      d.PrintF("Can't find screen \"%s\", using own screen.\n",y.ADR(o.pubScreen));
      RETURN g.unknownError;
    END;
    width:=gfx.GetBitMapAttr(screen.rastPort.bitMap,gfx.bmaWidth);
    height:=gfx.GetBitMapAttr(screen.rastPort.bitMap,gfx.bmaHeight);
    screenDepth:=gfx.GetBitMapAttr(screen.rastPort.bitMap,gfx.bmaDepth);
    IF (width<calcWidth) OR (height<calcHeight) THEN
      d.PrintF("Screen is too small, using own screen.\n");
      RETURN g.unknownError;
    END;
    IF screenDepth<15 THEN
      d.PrintF("Screen \"%s\" is not a truecolor screen, using own screen.\n",y.ADR(o.pubScreen));
      RETURN g.unknownError;
    END;
    IF ~cgfx.IsCyberModeID(gfx.GetVPModeID(y.ADR(screen.viewPort))) THEN
      d.PrintF("Screen \"%s\" is not a CyberGraphX native screen, using own screen.\n",y.ADR(o.pubScreen));
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
    doubleScanned:=FALSE;
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
                         i.waInnerWidth,0,
                         i.waInnerHeight,0,
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
                         i.saTitle,y.ADR("CyberQT"),
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
    IF animDepth<=8 THEN screenTags[scrColors].data:=colorMap; END;
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
      d.PrintF("Can't open window!\n");
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
  codec.decoder:=DecodeDummy;
  codec.special:=NIL;
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

PROCEDURE SetupCVID(VAR codec: CodecHeader);

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
  codec.decoder:=DecodeCVID;
  codec.special:=cvidData;
END SetupCVID;
(* \\\ ------------------------------------------------------------------------- *)

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
            test: LONGINT;
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
(* ///
PROCEDURE DecodeJPEG (from{8}: e.APTR;
                      to{9}: e.APTR;
                      width{0}: LONGINT;
                      height{1}: LONGINT;
                      encSize{2}: LONGINT;
                      spec{10}: e.APTR);

TYPE    arr=UNTRACED POINTER TO ARRAY MAX(INTEGER) OF LONGINT;

VAR     o: i.ObjectPtr;
        file: e.STRING;
        fh: d.FileHandlePtr;
        bm: gfx.BitMapPtr;
        mode: LONGINT;
        tcmap: arr;

BEGIN
  sl.sprintf(file,"T:CyberQT1.%08lx.temp",e.FindTask(NIL));
  fh:=d.Open(file,d.newFile);
  IF fh#NIL THEN
    y.SETREG(0,d.Write(fh,y.VAL(e.LSTRPTR,from)^,encSize));
    d.OldClose(fh);
    IF colorReduction THEN mode:=dt.modeV42; ELSE mode:=dt.modeV43; END;
    o:=dt.NewDTObject(file,dt.destMode,mode,
                           u.done);
    IF o#NIL THEN
      IF mode=dt.modeV42 THEN
        y.SETREG(0,dt.GetDTAttrs(o,dt.bitMap,y.ADR(bm),
                                   dt.cRegs,y.ADR(tcmap),
                                   u.done));
        gfx.LoadRGB32(y.ADR(screen.viewPort),tcmap^);
      ELSE
        y.SETREG(0,dt.GetDTAttrs(o,dt.bitMap,y.ADR(bm),u.done));
      END;
      gfx.BltBitMapRastPort(bm,0,0,rp,leftOff,topOff,animWidth,animHeight,y.VAL(y.BYTE,0C0H));
      dt.DisposeDTObject(o);
    END;
  END;
END DecodeJPEG;

PROCEDURE DecodeJPEGlib (from{8}: e.APTR;
                         to{9}: e.APTR;
                         width{0}: LONGINT;
                         height{1}: LONGINT;
                         encSize{2}: LONGINT;
                         spec{10}: e.APTR);
BEGIN
  jpegData.handle.fromBuffer:=videoData;
  jpegData.handle.toBuffer:=videoDataDec;
  jpegData.handle.encodedSize:=encSize;
  jpeg.DecodeJPEG(y.ADR(jpegData.handle));
END DecodeJPEGlib;
\\\ *)

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
  codec.decoder:=DecodeJPEG;
  codec.special:=jpegData;
END SetupJPEG;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE KPCDData" ---------------------------- *)
TYPE    KPCDDataPtr=UNTRACED POINTER TO KPCDData;
        KPCDData=STRUCT
            gray: BOOLEAN;
            yuvTab: ys.YUVTablePtr;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     kpcdData: KPCDDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeKPCD()" ------------------------ *)
PROCEDURE DecodeKPCD {"_DecodeKPCD"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectKPCDFuncs {"_SelectKPCDFuncs"} (spec{8}: KPCDDataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupKPCD(VAR codec: CodecHeader);
BEGIN
  IF kpcdData=NIL THEN NEW(kpcdData); END;
  kpcdData.gray:=grayScale;
  kpcdData.yuvTab:=ys.GenYUVTables();
  kpcdData.limit:=ys.InitLimitTables();
  kpcdData.cmap:=cmap;
  SelectKPCDFuncs(kpcdData,(colorReduction & ~ham8) OR grayScale,o.dither);
  codec.decoder:=DecodeKPCD;
  codec.special:=kpcdData;
END SetupKPCD;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE MJPAData" ---------------------------- *)
TYPE    MJPADataPtr=UNTRACED POINTER TO MJPAData;
        MJPAData=STRUCT
            gray: BOOLEAN;
            dither: BOOLEAN;
            yuvTab: ys.YUVTablePtr;
            yuvBuf: ys.YUVBufferPtr;
            limit: ys.RangeLimitPtr;
            quantTab: ARRAY 4 OF e.APTR;
            cmap: CMapArrPtr;
        END;

VAR     mjpaData: MJPADataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeMJPA()" ------------------------ *)
PROCEDURE DecodeMJPA {"_DecodeMJPA"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SelectMJPAFuncs {"_SelectMJPAFuncs"} (spec{8}: MJPADataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupMJPA(VAR codec: CodecHeader);

VAR     cnt: LONGINT;

BEGIN
  IF mjpaData=NIL THEN
    NEW(mjpaData);
    FOR cnt:=0 TO 3 DO ol.New(mjpaData.quantTab[cnt],64*SIZE(LONGINT)); END;
  END;
  mjpaData.gray:=grayScale;
  mjpaData.yuvTab:=ys.GenYUVTables();
  mjpaData.yuvBuf:=ys.AllocMCUBuffers(codec.width,codec.height);
  mjpaData.limit:=ys.InitLimitTables();
  mjpaData.cmap:=cmap;
  SelectMJPAFuncs(mjpaData,(colorReduction & ~ham8) OR grayScale,o.dither);
  codec.decoder:=DecodeMJPA;
  codec.special:=mjpaData;
END SetupMJPA;
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

PROCEDURE SetupMSVC8(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeMSVC8;
  codec.special:=NIL;
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

PROCEDURE SetupMSVC16(VAR codec: CodecHeader);
BEGIN
  IF msvcData=NIL THEN NEW(msvcData); END;
  msvcData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeMSVC16to332;
  ELSE
    IF o.dither THEN
      msvcData.limit:=ys.InitLimitTables();
      msvcData.cmap:=cmap;
      codec.decoder:=DecodeMSVC16to332Dith;
    ELSE
      codec.decoder:=DecodeMSVC16toRGB;
    END;
  END;
  codec.special:=msvcData;
END SetupMSVC16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------- "TYPE QTRLEData" ---------------------------- *)
TYPE    QTRLEDataPtr=UNTRACED POINTER TO QTRLEData;
        QTRLEData=STRUCT
            gray: BOOLEAN;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     qtrleData: QTRLEDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeQTRLE1()" ----------------------- *)
PROCEDURE DecodeQTRLE1 {"_DecodeQTRLE1"} (from{8}: e.APTR;
                                          to{9}: e.APTR;
                                          width{0}: LONGINT;
                                          height{1}: LONGINT;
                                          encSize{2}: LONGINT;
                                          spec{10}: e.APTR);

PROCEDURE SetupQTRLE1(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeQTRLE1;
  codec.special:=NIL;
END SetupQTRLE1;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeQTRLE4()" ----------------------- *)
PROCEDURE DecodeQTRLE4 {"_DecodeQTRLE4"} (from{8}: e.APTR;
                                          to{9}: e.APTR;
                                          width{0}: LONGINT;
                                          height{1}: LONGINT;
                                          encSize{2}: LONGINT;
                                          spec{10}: e.APTR);

PROCEDURE SetupQTRLE4(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeQTRLE4;
  codec.special:=NIL;
END SetupQTRLE4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeQTRLE8()" ----------------------- *)
PROCEDURE DecodeQTRLE8 {"_DecodeQTRLE8"} (from{8}: e.APTR;
                                          to{9}: e.APTR;
                                          width{0}: LONGINT;
                                          height{1}: LONGINT;
                                          encSize{2}: LONGINT;
                                          spec{10}: e.APTR);

PROCEDURE SetupQTRLE8(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeQTRLE8;
  codec.special:=NIL;
END SetupQTRLE8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeQTRLE16()" ---------------------- *)
PROCEDURE DecodeQTRLE16toRGB {"_DecodeQTRLE16toRGB"} (from{8}: e.APTR;
                                                      to{9}: e.APTR;
                                                      width{0}: LONGINT;
                                                      height{1}: LONGINT;
                                                      encSize{2}: LONGINT;
                                                      spec{10}: e.APTR);

PROCEDURE DecodeQTRLE16to332 {"_DecodeQTRLE16to332"} (from{8}: e.APTR;
                                                      to{9}: e.APTR;
                                                      width{0}: LONGINT;
                                                      height{1}: LONGINT;
                                                      encSize{2}: LONGINT;
                                                      spec{10}: e.APTR);

PROCEDURE DecodeQTRLE16to332Dith {"_DecodeQTRLE16to332Dith"} (from{8}: e.APTR;
                                                              to{9}: e.APTR;
                                                              width{0}: LONGINT;
                                                              height{1}: LONGINT;
                                                              encSize{2}: LONGINT;
                                                              spec{10}: e.APTR);

PROCEDURE SetupQTRLE16(VAR codec: CodecHeader);
BEGIN
  IF qtrleData=NIL THEN NEW(qtrleData); END;
  qtrleData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeQTRLE16to332;
  ELSE
    IF o.dither THEN
      qtrleData.limit:=ys.InitLimitTables();
      qtrleData.cmap:=cmap;
      codec.decoder:=DecodeQTRLE16to332Dith;
    ELSE
      codec.decoder:=DecodeQTRLE16toRGB;
    END;
  END;
  codec.special:=qtrleData;
END SetupQTRLE16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeQTRLE24()" ---------------------- *)
PROCEDURE DecodeQTRLE24toRGB {"_DecodeQTRLE24toRGB"} (from{8}: e.APTR;
                                                      to{9}: e.APTR;
                                                      width{0}: LONGINT;
                                                      height{1}: LONGINT;
                                                      encSize{2}: LONGINT;
                                                      spec{10}: e.APTR);

PROCEDURE DecodeQTRLE24to332 {"_DecodeQTRLE24to332"} (from{8}: e.APTR;
                                                      to{9}: e.APTR;
                                                      width{0}: LONGINT;
                                                      height{1}: LONGINT;
                                                      encSize{2}: LONGINT;
                                                      spec{10}: e.APTR);

PROCEDURE DecodeQTRLE24to332Dith {"_DecodeQTRLE24to332Dith"} (from{8}: e.APTR;
                                                              to{9}: e.APTR;
                                                              width{0}: LONGINT;
                                                              height{1}: LONGINT;
                                                              encSize{2}: LONGINT;
                                                              spec{10}: e.APTR);

PROCEDURE SetupQTRLE24(VAR codec: CodecHeader);
BEGIN
  IF qtrleData=NIL THEN NEW(qtrleData); END;
  qtrleData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeQTRLE24to332;
  ELSE
    IF o.dither THEN
      qtrleData.limit:=ys.InitLimitTables();
      qtrleData.cmap:=cmap;
      codec.decoder:=DecodeQTRLE24to332Dith;
    ELSE
      codec.decoder:=DecodeQTRLE24toRGB;
    END;
  END;
  codec.special:=qtrleData;
END SetupQTRLE24;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE DecodeQTRLE32()" ---------------------- *)
PROCEDURE DecodeQTRLE32toRGB {"_DecodeQTRLE32toRGB"} (from{8}: e.APTR;
                                                      to{9}: e.APTR;
                                                      width{0}: LONGINT;
                                                      height{1}: LONGINT;
                                                      encSize{2}: LONGINT;
                                                      spec{10}: e.APTR);

PROCEDURE DecodeQTRLE32to332 {"_DecodeQTRLE32to332"} (from{8}: e.APTR;
                                                      to{9}: e.APTR;
                                                      width{0}: LONGINT;
                                                      height{1}: LONGINT;
                                                      encSize{2}: LONGINT;
                                                      spec{10}: e.APTR);

PROCEDURE DecodeQTRLE32to332Dith {"_DecodeQTRLE32to332Dith"} (from{8}: e.APTR;
                                                              to{9}: e.APTR;
                                                              width{0}: LONGINT;
                                                              height{1}: LONGINT;
                                                              encSize{2}: LONGINT;
                                                              spec{10}: e.APTR);

PROCEDURE SetupQTRLE32(VAR codec: CodecHeader);
BEGIN
  IF qtrleData=NIL THEN NEW(qtrleData); END;
  qtrleData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeQTRLE32to332;
  ELSE
    IF o.dither THEN
      qtrleData.limit:=ys.InitLimitTables();
      qtrleData.cmap:=cmap;
      codec.decoder:=DecodeQTRLE32to332Dith;
    ELSE
      codec.decoder:=DecodeQTRLE32toRGB;
    END;
  END;
  codec.special:=qtrleData;
END SetupQTRLE32;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE RAWData" ----------------------------- *)
TYPE    RAWDataPtr=UNTRACED POINTER TO RAWData;
        RAWData=STRUCT
            gray: BOOLEAN;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     rawData: RAWDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRAW1()" ------------------------ *)
PROCEDURE DecodeRAW1 {"_DecodeRAW1"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SetupRAW1(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeRAW1;
  codec.special:=NIL;
END SetupRAW1;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRAW4()" ------------------------ *)
PROCEDURE DecodeRAW4 {"_DecodeRAW4"} (from{8}: e.APTR;
                                      to{9}: e.APTR;
                                      width{0}: LONGINT;
                                      height{1}: LONGINT;
                                      encSize{2}: LONGINT;
                                      spec{10}: e.APTR);

PROCEDURE SetupRAW4(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeRAW4;
  codec.special:=NIL;
END SetupRAW4;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRAW8()" ------------------------ *)
PROCEDURE DecodeRAW8 (from{8}: e.APTR;
                      to{9}: e.APTR;
                      width{0}: LONGINT;
                      height{1}: LONGINT;
                      encSize{2}: LONGINT;
                      spec{10}: e.APTR);
BEGIN
  e.CopyMemQuickAPTR(from,to,frameSize);
END DecodeRAW8;

PROCEDURE SetupRAW8(VAR codec: CodecHeader);
BEGIN
  codec.decoder:=DecodeRAW8;
  codec.special:=NIL;
END SetupRAW8;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRAW16()" ----------------------- *)
PROCEDURE DecodeRAW16toRGB {"_DecodeRAW16toRGB"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRAW16to332 {"_DecodeRAW16to332"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRAW16to332Dith {"_DecodeRAW16to332Dith"} (from{8}: e.APTR;
                                                          to{9}: e.APTR;
                                                          width{0}: LONGINT;
                                                          height{1}: LONGINT;
                                                          encSize{2}: LONGINT;
                                                          spec{10}: e.APTR);

PROCEDURE SetupRAW16(VAR codec: CodecHeader);
BEGIN
  IF rawData=NIL THEN NEW(rawData); END;
  rawData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeRAW16to332;
  ELSE
    IF o.dither THEN
      rawData.limit:=ys.InitLimitTables();
      rawData.cmap:=cmap;
      codec.decoder:=DecodeRAW16to332Dith;
    ELSE
      codec.decoder:=DecodeRAW16toRGB;
    END;
  END;
  codec.special:=rawData;
END SetupRAW16;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRAW24()" ----------------------- *)
PROCEDURE DecodeRAW24toRGB (from{8}: e.APTR;
                            to{9}: e.APTR;
                            width{0}: LONGINT;
                            height{1}: LONGINT;
                            encSize{2}: LONGINT;
                            spec{10}: e.APTR);
BEGIN
  e.CopyMemQuickAPTR(from,to,frameSize);
END DecodeRAW24toRGB;

PROCEDURE DecodeRAW24to332 {"_DecodeRAW24to332"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRAW24to332Dith {"_DecodeRAW24to332Dith"} (from{8}: e.APTR;
                                                          to{9}: e.APTR;
                                                          width{0}: LONGINT;
                                                          height{1}: LONGINT;
                                                          encSize{2}: LONGINT;
                                                          spec{10}: e.APTR);

PROCEDURE SetupRAW24(VAR codec: CodecHeader);
BEGIN
  IF rawData=NIL THEN NEW(rawData); END;
  rawData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeRAW24to332;
  ELSE
    IF o.dither THEN
      rawData.limit:=ys.InitLimitTables();
      rawData.cmap:=cmap;
      codec.decoder:=DecodeRAW24to332Dith;
    ELSE
      codec.decoder:=DecodeRAW24toRGB;
    END;
  END;
  codec.special:=rawData;
END SetupRAW24;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRAW32()" ----------------------- *)
PROCEDURE DecodeRAW32toRGB {"_DecodeRAW32toRGB"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRAW32to332 {"_DecodeRAW32to332"} (from{8}: e.APTR;
                                                  to{9}: e.APTR;
                                                  width{0}: LONGINT;
                                                  height{1}: LONGINT;
                                                  encSize{2}: LONGINT;
                                                  spec{10}: e.APTR);

PROCEDURE DecodeRAW32to332Dith {"_DecodeRAW32to332Dith"} (from{8}: e.APTR;
                                                          to{9}: e.APTR;
                                                          width{0}: LONGINT;
                                                          height{1}: LONGINT;
                                                          encSize{2}: LONGINT;
                                                          spec{10}: e.APTR);

PROCEDURE SetupRAW32(VAR codec: CodecHeader);
BEGIN
  IF rawData=NIL THEN NEW(rawData); END;
  rawData.gray:=grayScale;
  IF (colorReduction & ~ham8 & ~o.dither) OR grayScale THEN
    codec.decoder:=DecodeRAW32to332;
  ELSE
    IF o.dither THEN
      rawData.limit:=ys.InitLimitTables();
      rawData.cmap:=cmap;
      codec.decoder:=DecodeRAW32to332Dith;
    ELSE
      codec.decoder:=DecodeRAW32toRGB;
    END;
  END;
  codec.special:=rawData;
END SetupRAW32;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE RPZAData" ---------------------------- *)
TYPE    RPZADataPtr=UNTRACED POINTER TO RPZAData;
        RPZAData=STRUCT
            gray: BOOLEAN;
            limit: ys.RangeLimitPtr;
            cmap: CMapArrPtr;
        END;

VAR     rpzaData: RPZADataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeRPZA()" ------------------------ *)
PROCEDURE DecodeRPZAtoRGB {"_DecodeRPZAtoRGB"} (from{8}: e.APTR;
                                                to{9}: e.APTR;
                                                width{0}: LONGINT;
                                                height{1}: LONGINT;
                                                encSize{2}: LONGINT;
                                                spec{10}: e.APTR);

PROCEDURE DecodeRPZAto332 {"_DecodeRPZAto332"} (from{8}: e.APTR;
                                                to{9}: e.APTR;
                                                width{0}: LONGINT;
                                                height{1}: LONGINT;
                                                encSize{2}: LONGINT;
                                                spec{10}: e.APTR);

PROCEDURE DecodeRPZAto332Dith {"_DecodeRPZAto332Dith"} (from{8}: e.APTR;
                                                        to{9}: e.APTR;
                                                        width{0}: LONGINT;
                                                        height{1}: LONGINT;
                                                        encSize{2}: LONGINT;
                                                        spec{10}: e.APTR);

PROCEDURE SetupRPZA(VAR codec: CodecHeader);
BEGIN
  IF rpzaData=NIL THEN NEW(rpzaData); END;
  rpzaData.gray:=grayScale;
  IF (colorReduction & ~ham8) OR grayScale OR o.dither THEN
    IF o.dither THEN
      rpzaData.limit:=ys.InitLimitTables();
      rpzaData.cmap:=cmap;
      codec.decoder:=DecodeRPZAto332Dith;
    ELSE
      codec.decoder:=DecodeRPZAto332;
    END;
  ELSE
    codec.decoder:=DecodeRPZAtoRGB;
  END;
  codec.special:=rpzaData;
END SetupRPZA;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------------- "TYPE SMCData" ----------------------------- *)
CONST   smcMaxCnt=256;

TYPE    SMCDataPtr=UNTRACED POINTER TO SMCData;
        SMCData=STRUCT
            smc8: ARRAY 2*smcMaxCnt OF LONGINT;
            smcA: ARRAY 4*smcMaxCnt OF LONGINT;
            smcC: ARRAY 8*smcMaxCnt OF LONGINT;
        END;

VAR     smcData: SMCDataPtr;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------ "PROCEDURE DecodeSMC()" ------------------------ *)
PROCEDURE DecodeSMC {"_DecodeSMC"} (from{8}: e.APTR;
                                    to{9}: e.APTR;
                                    width{0}: LONGINT;
                                    height{1}: LONGINT;
                                    encSize{2}: LONGINT;
                                    spec{10}: e.APTR);

PROCEDURE SetupSMC(VAR codec: CodecHeader);
BEGIN
  IF smcData=NIL THEN NEW(smcData); END;
  codec.decoder:=DecodeSMC;
  codec.special:=smcData;
END SetupSMC;
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
PROCEDURE DecodeYUV2 {"_DecodeYUV2A"} (from{8}: e.APTR;
                                       to{9}: e.APTR;
                                       width{0}: LONGINT;
                                       height{1}: LONGINT;
                                       encSize{2}: LONGINT;
                                       spec{10}: e.APTR);

PROCEDURE SelectYUV2Funcs {"_SelectYUV2Funcs"} (spec{8}: YUV2DataPtr;
                                                reduce{0}: BOOLEAN;
                                                dither{1}: BOOLEAN);

PROCEDURE SetupYUV2(VAR codec: CodecHeader);
BEGIN
  IF yuv2Data=NIL THEN NEW(yuv2Data); END;
  yuv2Data.gray:=grayScale;
  yuv2Data.yuvTab:=ys.GenYUVTables();
  yuv2Data.yuvBuf:=ys.AllocMCUBuffers(codec.width,codec.height);
  yuv2Data.limit:=ys.InitLimitTables();
  yuv2Data.cmap:=cmap;
  SelectYUV2Funcs(yuv2Data,(colorReduction & ~ham8) OR grayScale,o.dither);
  codec.decoder:=DecodeYUV2;
  codec.special:=yuv2Data;
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

PROCEDURE SetupYUV9(VAR codec: CodecHeader);
BEGIN
  IF yuv9Data=NIL THEN NEW(yuv9Data); END;
  yuv9Data.gray:=grayScale;
  yuv9Data.yuvTab:=ys.GenYUVTables();
  yuv9Data.limit:=ys.InitLimitTables();
  yuv9Data.cmap:=cmap;
  SelectYUV9Funcs(yuv9Data,(colorReduction & ~ham8) OR grayScale,o.dither);
  codec.decoder:=DecodeYUV9;
  codec.special:=yuv9Data;
END SetupYUV9;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE CodecQuery()" ------------------------ *)
PROCEDURE CodecQuery * (VAR codec: CodecHeader): LONGINT;

VAR     ret: LONGINT;

BEGIN
  ret:=codecSupported;
  IF codec.depth>32 THEN DEC(codec.depth,32); END;
  CASE codec.compression OF
  | idcvid,
    idCVID:
      codec.compression:=idCVID;
      codec.description:="Radius Cinepak";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF (codec.depth=8) OR (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupCVID(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idjpeg:
      codec.description:="JFIF JPEG";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,2);
      IF (codec.depth=8) OR (codec.depth=24) THEN
        SetupJPEG(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idkpcd,
    idKPCD:
      codec.compression:=idKPCD;
      codec.description:="Kodak Photo CD";
      codec.width:=i2m.Round(codec.width,4);
      IF (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupKPCD(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idmjpa:
      codec.description:="Motion JPEG (type A)";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height DIV 2,2); (* es müssen alle Zeilen doppelt angezeigt werden, aber die Höhe wurde als doppelte Höhe gespeichert *)
      IF (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupMJPA(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idmsvc,
    idMSVC,
    idcram,
    idCRAM:
      codec.compression:=idMSVC;
      codec.description:="Microsoft Video 1";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF codec.depth=8 THEN
        SetupMSVC8(codec);
      ELSIF codec.depth=16 THEN
        SetupMSVC16(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idraw:
      codec.description:="Apple Uncompressed";
      IF codec.depth=1 THEN
        SetupRAW1(codec);
      ELSIF codec.depth=4 THEN
        SetupRAW4(codec);
      ELSIF codec.depth=8 THEN
        SetupRAW8(codec);
      ELSIF codec.depth=16 THEN
        SetupRAW16(codec);
      ELSIF codec.depth=24 THEN
        SetupRAW24(codec);
      ELSIF codec.depth=32 THEN
        SetupRAW32(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idrle:
      codec.description:="Apple Animation (RLE)";
      IF codec.depth=1 THEN
        codec.width:=i2m.Round(codec.width,16);
        SetupQTRLE1(codec);
      ELSIF codec.depth=4 THEN
        codec.width:=i2m.Round(codec.width,8);
        SetupQTRLE4(codec);
      ELSIF codec.depth=8 THEN
        codec.width:=i2m.Round(codec.width,4);
        SetupQTRLE8(codec);
      ELSIF codec.depth=16 THEN
        SetupQTRLE16(codec);
      ELSIF codec.depth=24 THEN
        SetupQTRLE24(codec);
      ELSIF codec.depth=32 THEN
        SetupQTRLE32(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idrpza,
    idazpr:
      codec.compression:=idrpza;
      codec.description:="Apple Video (RPZA)";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF codec.depth=16 THEN
        SetupRPZA(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idsmc:
      codec.description:="Apple Graphics (SMC)";
      codec.width:=i2m.Round(codec.width,4);
      codec.height:=i2m.Round(codec.height,4);
      IF codec.depth=8 THEN
        SetupSMC(codec);
      ELSE
        ret:=codecUnsupported;
      END;
  | idyuv2,
    idYUV2,
    id2vuy,
    id2VUY:
      codec.compression:=idYUV2;
      codec.description:="Component Video (YUV2)";
      codec.width:=i2m.Round(codec.width,2);
      codec.height:=i2m.Round(codec.height,2);
      IF (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupYUV2(codec);
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
      IF (codec.depth=16) OR (codec.depth=24) OR (codec.depth=32) THEN
        SetupYUV9(codec);
      ELSE
        ret:=codecUnsupported;
      END;
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
      ret:=codecUnsupported;
  | idiv41,
    idIV41:
      codec.compression:=idIV41;
      codec.description:="Intel Indeo R4.1";
      ret:=codecUnsupported;
  | idiv50,
    idIV50:
      codec.compression:=idIV50;
      codec.description:="Intel Indeo R5.0";
      ret:=codecUnsupported;
  | idcyuv,
    idCYUV:
      codec.compression:=idCYUV;
      codec.description:="Creative Technology (CYUV)";
      ret:=codecUnsupported;
  | idmjpb:
      codec.description:="Motion JPEG (type B)";
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

(* /// ---------------------- "PROCEDURE InitVideoFile()" ---------------------- *)
PROCEDURE InitVideoFile * (name: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)
BEGIN
  RETURN io.Open(videoFile,name,o.bufferSize,FALSE);
END InitVideoFile;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ----------------------- "PROCEDURE DecodeFrame()" ----------------------- *)
PROCEDURE DecodeFrame * (offset: LONGINT;
                         size: LONGINT;
                         codec: LONGINT);
VAR fh: d.FileHandlePtr;
BEGIN
  io.SeekTo(videoFile,offset);
  io.Read(videoFile,videoData,size);
  IF codec#currentCodec THEN
    decoderProc:=codecs[codec].decoder;
    decoderSpec:=codecs[codec].special;
(*
    calcWidth:=codecs[codec].width;
    calcHeight:=codecs[codec].height;
*)
    currentCodec:=codec;
  END;
  decoderProc(videoData,videoDataDec,calcWidth,calcHeight,size,decoderSpec);
  displayProc();
(*
  fh:=d.Open("sd0:x",d.newFile);
  y.SETREG(0,d.Write(fh,videoData^,size));
  d.OldClose(fh);
*)
END DecodeFrame;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ---------------------- "PROCEDURE AllocBuffers()" ----------------------- *)
PROCEDURE AllocBuffers * (): BOOLEAN;

VAR     track: g.TrackPtr;
        desc: g.VideoDescriptionPtr;
        codec: CodecHeader;
        cnt: LONGINT;
        cur: LONGINT;
        ret: BOOLEAN;
        size: LONGINT;
        minDepth: LONGINT;
        maxDepth: LONGINT;

BEGIN
  colorReduction:=g.agaOnly OR (g.gfxBoth & o.aga) OR (g.cgfxOnly & o.aga);
  ham8:=o.ham8;
  grayScale:=o.grayScale;
  ret:=TRUE;
  track:=g.animInfo.videoTracks.head;
  (* $RangeChk- *)
  animWidth:=SHORT(fp.FP32toINT(track.head.width));
  animHeight:=SHORT(fp.FP32toINT(track.head.height));
  calcWidth:=animWidth;
  calcHeight:=animHeight;
  (* $RangeChk= *)
  DetermineDepth();
  minDepth:=MAX(LONGINT);
  maxDepth:=MIN(LONGINT);
  DISPOSE(codecs);
  IF es.ListEmpty(g.animInfo.videoTracks) THEN RETURN FALSE; END;

  ol.New(codecs,cu.CalcDescEntries(g.animInfo.videoTracks)*SIZE(CodecHeader));
  cur:=0;
  WHILE track.node.succ#NIL DO
    FOR cnt:=0 TO track.descriptionEntries-1 DO
      desc:=y.VAL(g.VideoDescriptionPtr,track.descriptions[cnt]);
      InitColorMap(desc);
      codec.compression:=desc.head.dataFormat;
      codec.width:=desc.width;
      codec.height:=desc.height;
      codec.depth:=desc.depth;
      CASE CodecQuery(codec) OF
      | codecUnsupported:
          d.PrintF("  Unsupported video encoding: %s [",y.ADR(codec.description)); cu.PrintFCC(codec.compression); d.PrintF("], depth %ld\n",desc.depth);
          ret:=FALSE;
          IF (codec.compression=idRT21) OR (codec.compression=idIV31) OR (codec.compression=idIV32) OR (codec.compression=idIV41) OR (codec.compression=idIV50) THEN d.PrintF("Please consult the manual/FAQ for information about Intel Indeo\n"); END;
      | codecUnknown:
          d.PrintF("  Unknown video encoding: "); cu.PrintFCC(codec.compression); d.PrintF(", depth %ld\n",desc.depth);
          ret:=FALSE;
      ELSE
        minDepth:=mu.min(minDepth,codec.depth);
        maxDepth:=mu.max(maxDepth,codec.depth);
        calcWidth:=mu.max(calcWidth,codec.width);
        calcHeight:=mu.max(calcHeight,codec.height);
        IF ~o.quiet THEN
          d.PrintF("  Video: %s, %ld bit, %ld×%ld\n",y.ADR(codec.description),
                                                     codec.depth,
                                                     animWidth,
                                                     animHeight);
        END;
      END;
      codecs[cur]:=codec;
      INC(cur);
    END;
    track:=track.node.succ;
  END;

  IF ret THEN
    DISPOSE(videoData);
    DISPOSE(ham8Buffer);
    DISPOSE(videoDataDec);
    size:=i2m.Round(cu.CalcMaxSize(g.animInfo.videoTracks,TRUE),e.blockSize);
    frameSize:=i2m.Round(calcWidth*calcHeight,4); (* ungerade Größen ergeben Mungwall-Hits *)
    dispModulo:=i.LongToUInt(calcWidth);
    IF animDepth<=8 THEN
      ham8:=FALSE;
      colorType:=cgfx.rectFmtLUT8;
    ELSE
      IF ham8 THEN ol.New(ham8Buffer,mu.max(size,frameSize)); END;
      IF grayScale THEN
        colorType:=cgfx.rectFmtGREY8;
      ELSE
        colorType:=cgfx.rectFmtRGB;
        dispModulo:=dispModulo*3;
        frameSize:=frameSize*3;
      END;
    END;
    IF (minDepth<=8) & (maxDepth>8) THEN frameSize:=frameSize*3; END;
    ol.New(videoData,size);
    ol.New(videoDataDec,mu.max(size,frameSize));
(*
    ol.New(videoDataDec,mu.max(size,frameSize)*6);
    videoDataDec:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,videoDataDec)+frameSize);
*)
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
    currentCodec:=0;
    decoderProc:=codecs[0].decoder;
    decoderSpec:=codecs[0].special;
    calcWidth:=codecs[0].width;
    calcHeight:=codecs[0].height;
  END;
  RETURN ret;
END AllocBuffers;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  NEW(cmap);
CLOSE
  io.Close(videoFile);
  CloseDisplay();
END CyberQTVideo.

