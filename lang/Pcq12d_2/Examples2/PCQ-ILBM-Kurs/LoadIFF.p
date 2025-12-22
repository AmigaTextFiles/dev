PROGRAM LoadIFF;

{
  Demoprogramm für den IFF-PCQ-Kurs im AmigaGadget

  Funktion : kann vom CLI aus mit "IFFKurs Filename" aufgerufen werden
             und zeigt dann das File "Filename" an, sofern es sich dabei
             um ein IFF-ILBM-Bild handelt
             es werden nur die allernotwendigsten Chunks unterstützt,
             Overscan-Support oder ähnliches fehlt ebenso

  © 1995 by Andreas Neumann basierend auf einer Veröffentlichung von
            Fritjof Siebert und den Informationen auf den
            CATS-IFF-Entwickler-Disks
}

{$I "Include:Exec/Exec.i" }
{$I "Include:Hardware/IntBits.I" }
{$I "Include:libraries/Dosextens.I" }
{$I "Include:Graphics/Graphics.I" }
{$I "Include:Graphics/View.i" }
{$I "Include:Graphics/Blitter.i" }
{$I "Include:Graphics/GfxBase.i" }
{$I "Include:graphics/Pens.i" }
{$I "Include:Graphics/Rastport.i" }
{$I "Include:Intuition/intuition.i" }
{$I "Include:Intuition/Intuitionbase.i" }
{$I "Include:Utils/StringLib.i" }
{$I "Include:Utils/Parameters.I" }


TYPE
    IFFTitles = (BMHD_f,CMAP_f,CAMG_f,BODY_f);

    BMHD = RECORD
            width,
            height      : SHORT;
            depth       : BYTE;
            left,
            top         : SHORT;
            masking     : BYTE;
            transCol    : SHORT;
            xAspect,
            yAspect     : BYTE;
            scrnWidth,
            scrnHeight  : SHORT;
           END;

    CMAP = RECORD
            colorcnt    : SHORT;
            red,
            green,
            blue        : ARRAY [0..255] OF BYTE;
           END;

    CAMG = RECORD
            viewType    : INTEGER;
           END;

    IFFInfoType = RECORD
                   IFFBMHD  : BMHD;
                   IFFCMAP  : CMAP;
                   IFFCAMG  : CAMG;
                   IFFTitle : IFFTitles;
                  END;

    IFFInfoTypePtr = ^IFFInfoType;

    IFFErrors = (iffNoErr,iffOutOfMem,iffOpenScreenfailed,
                 iffOpenWindowFailed,iffOpenFailed,iffWrongIff,
                 iffReadWriteFailed);


CONST

    gfxname : String = ("graphics.library");

    { IFFError-Strings }

    IFFErrorStrings : ARRAY [iffNoErr..iffReadWriteFailed] OF String =
                        ("No Error","Out of Memory","OpenScreen failed",
                         "OpenWindow failed","Open Failed","Wrong Iff",
                         "ReadWrite failed");


VAR
    IFFError    :   IFFErrors;
    IFFInfo     :   IFFInfoType;
    IFFName     :   String;
    IFFScreen   :   ScreenPtr;
    IFFWindow   :   WindowPtr;
    IFFMes      :   IntuiMessagePtr;

{$A     XREF    _p%IntuitionBase    }


FUNCTION Hoch (basis : INTEGER; exp : INTEGER) : INTEGER;

VAR h1 : INTEGER;
    h2 : INTEGER;

BEGIN
 h1:=1;
 IF exp>0 THEN
  FOR h2:=1 TO exp DO
   h1:=h1*basis;
 Hoch:=h1;
END;


FUNCTION GetIBase : IntuitionBasePtr;

BEGIN
{$A
        move.l  _p%IntuitionBase,d0
}
END;


FUNCTION IsAGA (gb : GfxBasePtr) : BOOLEAN;

BEGIN
 IF (gb^.ChipRevBits0 AND %100)=%100 THEN
  IsAGA:=TRUE
 ELSE
  IsAGA:=FALSE;
END;


PROCEDURE MySetRGB (vp : ViewPortPtr ; nr , r , g , b : INTEGER ;
                    gb : GfxBasePtr);

BEGIN
 IF IsAGA (gb) THEN
  SetRGB32 (vp,nr,r shl 24,g shl 24,b shl 24)
 ELSE
 SetRGB4 (vp,nr,(r shr 4),(g shr 4),(b shr 4));
END;

PROCEDURE BufSkip (VAR bufptr : Address ; bytes : INTEGER);

BEGIN
 bufptr:=Address(Integer(bufptr)+bytes);
END;


FUNCTION ReadILBM (name : String; VAR myscreen : ScreenPtr ;
                   VAR mywindow : WindowPtr) : BOOLEAN;

VAR Compression,
    MaskPlane,
    contload        :   BOOLEAN;
    LineLength,
    LineWidth,
    i,
    j,
    k,
    len,
    PictureLength   :   INTEGER;
    PictureBuffer,
    WorkBuffer,
    HeaderBuffer    :   Address;
    TextBuffer      :   String;
    LONGBuffer      :   ^ARRAY [0..63] OF INTEGER;
    SHORTBuffer     :   ^ARRAY [0..127] OF SHORT;
    BYTEBuffer      :   ^ARRAY [0..255] OF BYTE;
    InH             :   FileHandle;
    IFFBitMap       :   BitMapPtr;


PROCEDURE OpenScrn;

VAR nuscreen    :   NewScreen;
    nuwindow    :   NewWindow;
    i           :   INTEGER;

BEGIN
 WITH NuScreen DO
 BEGIN
  width:=IFFInfo.IFFBMHD.scrnWidth;
  IF width<IFFInfo.IFFBMHD.width THEN
   width:=IFFInfo.IFFBMHD.width;
  height:=IFFInfo.IFFBMHD.scrnHeight;
  IF height<IFFInfo.IFFBMHD.height THEN
   height:=IFFInfo.IFFBMHD.height;

  leftEdge:=IFFInfo.IFFBMHD.left;
  topEdge:=IFFInfo.IFFBMHD.top;

  depth:=IFFInfo.IFFBMHD.depth;
  viewModes:=0;
  IF width>=640 THEN ViewModes:=ViewModes OR HIRES;
  IF height>=400 THEN ViewModes:=ViewModes OR LACE;

  WITH IFFInfo.IFFCAMG DO
   ViewModes:=ViewModes OR ViewType;

  IF ((depth=6) OR (depth=8)) AND (ViewModes=0) THEN
  IF (IFFInfo.IFFCMAP.colorcnt=Hoch(2,depth-2)) THEN
   ViewModes:=HAM;

  IF ((ViewModes AND HAM)=HAM) AND
     (IFFInfo.IFFCMAP.colorcnt>Hoch(2,depth-2)) THEN
   IFFInfo.IFFCMAP.colorcnt:=Hoch(2,depth-2);

  detailPen:=0;
  blockPen:=0;
  stype:=CUSTOMSCREEN_f+SCREENQUIET_f+SCREENBEHIND_f;
  font:=NIL;
  defaultTitle:=NIL;
  gadgets:=NIL;
  customBitMap:=NIL;
 END;
 myscreen:=OpenScreen (Adr(nuscreen));
 IF myscreen=NIL THEN
  IFFError:=iffOpenScreenfailed
 ELSE
 BEGIN

  WITH IFFInfo.IFFCMAP DO
  BEGIN
   FOR i:=0 TO (colorCnt-1) DO
    MySetRGB (Adr(myscreen^.SViewPort),i,red[i],green[i],blue[i],GfxBase);
  END;

  WITH nuwindow DO
  BEGIN
   leftEdge:=0;
   topEdge:=0;
   width:=IFFInfo.IFFBMHD.width;
   height:=IFFInfo.IFFBMHD.height;
   detailPen:=1;
   blockPen:=0;
   idcmpFlags:=MOUSEBUTTONS_f;
   flags:=BORDERLESS+NOCAREREFRESH+RMBTRAP+ACTIVATE;
   firstGadget:=NIL;
   checkMark:=NIL;
   title:=NIL;
   screen:=myscreen;
   bitMap:=NIL;
   wtype:=CUSTOMSCREEN_F;
  END;
  mywindow:=OpenWindow (Adr(nuwindow));
  IF mywindow=NIL THEN
  BEGIN
   CloseScreen (myscreen);
   myscreen:=NIL;
   IFFError:=iffOpenWindowFailed;
  END;
 END;
END;


PROCEDURE ReadQuick (mto : ADDRESS; Count : SHORT ; fake : BOOLEAN);

BEGIN
 IF fake=FALSE THEN
  CopyMem (WorkBuffer,mto,Count);
 BufSkip (WorkBuffer,Count);
END;


PROCEDURE ReadSlow (ato : ADDRESS; Count : SHORT);

VAR kk,
    scrRow,
    bCnt    :   INTEGER;
    inCode  :   BYTE;
    ToPtr   :   ^ARRAY [0..9999] OF BYTE;
    DPtr    :   ^ARRAY [0..254] OF BYTE;
    RQBuf   :   BYTE;
    j       :   SHORT;

BEGIN
 ToPtr:=ato;
 bCnt:=0;
 WHILE bCnt<Count DO
 BEGIN
  DPtr:=WorkBuffer;
  inCode:=DPtr^[0];
  BufSkip (WorkBuffer,1);
  IF inCode<128 THEN
  BEGIN
   CopyMem (WorkBuffer,Address(Integer(ato)+bCnt),inCode+1);
   BufSkip (WorkBuffer,inCode+1);
   Inc(bCnt,inCode+1);
  END
  ELSE
   IF inCode>128 THEN
   BEGIN
    DPtr:=WorkBuffer;
    RQBuf:=DPTr^[0];
    BufSkip(WorkBuffer,1);
    FOR j:=bCnt TO (bCnt+257-inCode-1) DO
     ToPtr^[j]:=RQBuf;
    Inc(bCnt,257-inCode);
   END;
 END;
END;


PROCEDURE CheckILBM;

BEGIN
 IF StrNEq (TextBuffer,"FORM",4)=FALSE THEN
  IFFError:=iffOpenFailed;

 IF (StrNEq (TextBuffer,"FORM",4)=TRUE) AND
    (StrNEq(Address(Integer(TextBuffer)+8),"ILBM",4)=FALSE) THEN
  IFFError:=iffWrongIFF;
END;


BEGIN
 IFFInfo.IFFTitle:=IFFTitles(0);
 IFFError:=iffnoErr;
 myscreen:=NIL;
 mywindow:=NIL;
 PictureBuffer:=NIL;
 PictureLength:=0;
 contload:=FALSE;
 InH:=DOSOpen (name,MODE_OLDFILE);
 IF InH=NIL THEN
  IFFError:=iffOpenfailed
 ELSE
 BEGIN
  HeaderBuffer:=AllocMem (12,MEMF_CLEAR+MEMF_PUBLIC);
  IF HeaderBuffer<>NIL THEN
  BEGIN
   len:=DOSRead (InH,HeaderBuffer,12);
   IF len<>12 THEN IFFError:=iffReadWriteFailed;
   TEXTBuffer:=HeaderBuffer;
   LONGBuffer:=HeaderBuffer;
   CheckILBM;

   PictureLength:=LONGBuffer^[1]-4;
   FreeMem (HeaderBuffer,12);

   IF IFFError=iffNoErr THEN
   BEGIN

    PictureBuffer:=AllocMem(PictureLength,MEMF_CLEAR+MEMF_PUBLIC);

    IF PictureBuffer=NIL THEN
     IFFError:=iffOutofmem
    ELSE
    BEGIN
     len:=DOSRead (InH,PictureBuffer,PictureLength);
     IF InH<>NIL THEN BEGIN DOSClose (InH); InH:=NIL; END;
     IF len<>PictureLength THEN
      IFFError:=iffReadWritefailed
     ELSE
       contload:=TRUE;
     WorkBuffer:=PictureBuffer;
    END;
   END;
  END;
 END;
 IF contload THEN
 BEGIN
  WHILE (IFFError=iffNoErr) AND (contload) DO
  BEGIN
   TextBuffer:=WorkBuffer;
   BufSkip(WorkBuffer,4);
   IF StrNEq (TextBuffer,"BMHD",4) THEN
   BEGIN
    IFFInfo.IFFTitle:=IFFInfo.IFFTitle OR BMHD_f;
    LONGBuffer:=WorkBuffer;
    BufSkip(WorkBuffer,4);
    j:=LONGBuffer^[0];
    SHORTBuffer:=WorkBuffer;
    BYTEBuffer:=WorkBuffer;
    BufSkip(WorkBuffer,j);
    WITH IFFInfo.IFFBMHD DO
    BEGIN
     width:=SHORTBuffer^[0];
     height:=SHORTBuffer^[1];
     left:=SHORTBuffer^[2];
     top:=SHORTBuffer^[3];
     depth:=BYTEBuffer^[8];
     masking:=BYTEBuffer^[9];
     MaskPlane:=(masking=1);
     Compression:=(ByteBuffer^[10]=1);
     transCol:=SHORTBuffer^[6];
     xAspect:=BYTEBuffer^[14];
     yAspect:=BYTEBuffer^[15];
     scrnWidth:=SHORTBuffer^[8];
     scrnHeight:=SHORTBuffer^[9];
    END;
   END
   ELSE
   BEGIN
    IF StrNEq (TextBuffer,"CMAP",4) THEN
    BEGIN
     IFFInfo.IFFTitle:=IFFInfo.IFFTitle OR CMAP_f;
     LONGBuffer:=WorkBuffer;
     BufSkip(WorkBuffer,4);
     i:=LONGBuffer^[0];
     BYTEBuffer:=WorkBuffer;
     BufSkip(WorkBuffer,i);
     WITH IFFInfo.IFFCMAP DO
     BEGIN
      colorcnt:=i DIV 3;
      j:=0;
      FOR k:=0 TO colorcnt-1 DO
      BEGIN
       red[k]:=BYTEBuffer^[j];
       green[k]:=BYTEBuffer^[j+1];
       blue[k]:=BYTEBuffer^[j+2];
       Inc(j,3);
      END;
     END;
    END
    ELSE
    BEGIN
     IF StrNEq (TextBuffer,"CAMG",4) THEN
     BEGIN
      IFFInfo.IFFTitle:=IFFInfo.IFFTitle OR CAMG_f;
      LONGBuffer:=WorkBuffer;
      BufSkip(WorkBuffer,8);
      IFFInfo.IFFCAMG.viewType:=LONGBuffer^[1];
     END
     ELSE
     BEGIN
      IF StrNEq (TextBuffer,"BODY",4) THEN
      BEGIN
       IFFInfo.IFFTitle:=IFFInfo.IFFTitle OR BODY_f;

       OpenScrn;

       IF IFFError=iffNoErr THEN
       BEGIN

        BufSkip (WorkBuffer,4);

        IFFBitMap:=myscreen^.SRastPort.BitMap;
        LineLength:=RASSIZE(IFFInfo.IFFBMHD.width,1);
        LineWidth:=IFFBitMap^.BytesPerRow;

        IF Compression THEN
        BEGIN
         FOR i:=0 TO (IFFInfo.IFFBMHD.height-1) DO
         FOR j:=0 TO (IFFBitMap^.Depth-1) DO
          ReadSlow (Address(Integer(IFFBitMap^.Planes[j])+(LineWidth*i)),
                    LineLength);
        END
        ELSE
        BEGIN
         FOR i:=0 TO (IFFInfo.IFFBMHD.height-1) DO
         FOR j:=0 TO (IFFBitMap^.Depth-1) DO
          ReadQuick (Address(Integer(IFFBitMap^.Planes[j])+(LineWidth*i)),
                     LineLength,FALSE);
         IF MaskPlane THEN
          ReadQuick (NIL,LineLength,TRUE);
        END;

       END;
       contload:=FALSE;
      END
      ELSE
      BEGIN
       LONGBuffer:=WorkBuffer;
       BufSkip (WorkBuffer,4);
       i:=LONGBuffer^[0];
       BufSkip (WorkBuffer,i);
      END;
     END;
    END;
   END;
  END;
 END;
 IF InH<>NIL THEN
  DOSClose (InH);
 IF PictureBuffer<>NIL THEN FreeMem (PictureBuffer,PictureLength);
 IF IFFError<>iffNoErr THEN
 BEGIN
  IF mywindow<>NIL THEN CloseWindow (mywindow);
  IF myscreen<>NIL THEN CloseScreen (myscreen);
  mywindow:=NIL;
  myscreen:=NIL;
 END;
 ReadILBM:=(iffError=iffNoErr);
END;


BEGIN
 IFFName:=AllocString(255);
 IF IFFName<>NIL THEN
 BEGIN

  GetParam(1,IFFName);

  IF StrLen (IFFName)>0 THEN
  BEGIN
   GfxBase := OpenLibrary(gfxname, 0);
   WRITELN ("\nIFF-Kurs für AmigaGadget - ein Demo-IFF-Lader");
   WRITELN ("written 1995 by Andreas Neumann":65,"\n");
   IF ReadILBM (IFFName,IFFScreen,IFFWindow) THEN
   BEGIN
    ScreenToFront (IFFScreen);
    REPEAT
     IFFMes:=Address(WaitPort(IFFWindow^.UserPort));
     IFFMes:=Address(GetMsg(IFFWindow^.UserPort));
    UNTIL IFFMes<>NIL;
    ReplyMsg (Address(IFFMes));
    ScreenToBack (IFFScreen);
   END;

   IF IFFWindow<>NIL THEN CloseWindow (IFFWindow);
   IF IFFScreen<>NIL THEN CloseScreen (IFFScreen);
   CloseLibrary (GfxBase);
   IF IFFError<>iffNoErr THEN
    WRITELN ("\n",IFFErrorStrings[IFFError],"\n");
  END;
  FreeString (IFFName);
 END;
END.

