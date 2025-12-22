(*#-- BEGIN AutoRevision header, please do NOT edit!
*
*   Program         :   readiff.mod
*   Copyright       :   1992 ©, By DigiSoft
*   Author          :   Marcel Timmermans
*   Address         :   A. Dekenstr 22, 6836 RM, Arnhem, HOLLAND
*   Creation Date   :   13-09-1992
*   Current version :   1.0
*   Translator      :   M2Amiga V4.1d
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*
*-- END AutoRevision header --*)

IMPLEMENTATION MODULE readiff;

(* options list *)
(*$ LargeVars:=FALSE
    StackChk:=FALSE
    OverflowChk:=FALSE
    RangeChk:=FALSE
    ReturnChk:=FALSE
    NilChk:=FALSE
    LongAlign:=FALSE
    Volatile:=FALSE
    StackParms:=FALSE
 *)

(*
  This is a simple iff reader written in modula-2. The program is public domain
  so you can modify it or use it or wathever you want to do with it.
  If you use it in your program, please let me now.

  The routines 'MakeGraph' and 'DPaintGraph' are written in modula-2 and not
  in assembler !, Why ?
  Just so show easy how to unpack data to your screen.
  If you want to speedup the unpacking just convert (adjust) it to assembler.

  The assemble source that the compiler m2c is making is very fast.
  But offcourse it can quicker !!

  If your are making changes, for a better support, error checking
  or its faster. Please send me a copy !

  Good luck !
   Marcel Timmermans, 1992 (c) DigiSoft
*)

FROM SYSTEM IMPORT ADR,ADDRESS,SHIFT;

(* import list *)
IMPORT id:IntuitionD,
       il:IntuitionL,
       gd:GraphicsD,
       gl:GraphicsL,
       dl:DosL,
       dd:DosD,
       s:String,
       R,
       A:Arts,
       H:Heap;

(*-- TYPES --*)

TYPE
    UByte = [0..255];    (* byte set          *)
    Byte  = [-128..127]; (* unsigned byte set *)

    pub= POINTER TO Byte;

    (* Bitmap header information *)
    bmhdtype =  RECORD
                  width,height,xpos,ypos : INTEGER;
                  depth, mask, comp : UByte;
                  transCol: INTEGER;
                  xAspect,yAspect: UByte;
                  scrnWidth,scrnHeight: INTEGER;
                END;

(*-- VARS --*)

VAR
    HEADER: RECORD
      name  :ARRAY[0..3] OF CHAR;
      length:LONGINT;
      name1 :ARRAY[0..3] OF CHAR;
    END;

  ColorTable : ARRAY[0..255] OF CARDINAL;

  newScreen: id.NewScreen; (* My screen structure *)
  myscreen : id.ScreenPtr; (* My screen pointer   *)

  file: dd.FileHandlePtr;      (* File handler            *)
  r,g,b: CARDINAL;
  colorCnt:INTEGER;            (* Number of Colors used   *)
  bpr:Byte;                    (* BytesPerRow             *)

  BODY:pub;                    (* BODY => Pointer to Byte *)
  CMAP:POINTER TO UByte;       (* ColorMAP Pointer        *)
  BMHD:POINTER TO bmhdtype;    (* Bitmap Header Pointer   *)



(*-------------------------------------------------------------------------*)
(*-------------------------------------------------------------------------*)

PROCEDURE CleanUp;
BEGIN
 IF file#NIL THEN dl.Close(file ) END;
END CleanUp;


(* normal mode *)
PROCEDURE MakeGraph(body:pub;planes:ARRAY OF ADDRESS);
VAR i{R.D2},j{R.D3},k{R.D4},offset{R.D5}: LONGINT;
    dest{R.A3}:pub;
BEGIN
  i:=0;offset:=0;
  REPEAT
    j:=0;
    REPEAT
      dest:=pub(planes[j]+offset);
      k:=0;
      REPEAT
       dest^:=body^;
       INC(dest);INC(body);INC(k);
      UNTIL k=bpr;
      INC(j);
    UNTIL j=LONGINT(myscreen^.bitMap.depth);
    INC(i);INC(offset,bpr);
  UNTIL i=LONGINT(myscreen^.bitMap.rows);
END MakeGraph;

(* compressed mode *)
PROCEDURE DPaintGraph(body{R.A2}:pub;planes:ARRAY OF ADDRESS);
VAR i{R.D2}: LONGINT;
    sofar{R.D4}:Byte;
    byte{R.D5},depth,j{R.D3}:Byte;
    dest{R.A3}:pub;
    offset:INTEGER;
    rows:LONGINT;

BEGIN
  i:=0;offset:=0;
  depth:=Byte(myscreen^.bitMap.depth);
  rows:=LONGINT(myscreen^.bitMap.rows);
  REPEAT (* line counter 'i' *)
    j:=0;
    REPEAT (* plane counter 'j' *)
      sofar:=bpr;
      dest:=pub(planes[j]+offset);
      WHILE sofar > 0 DO
       byte:=body^; INC(body);
       IF byte=128 THEN
       ELSIF byte > 0 THEN
        INC(byte);
        DEC(sofar,byte);
        REPEAT
         dest^:=body^;
         INC(dest);INC(body);DEC(byte);
        UNTIL byte<=0;
       ELSE
        byte:=-byte + 1;
        DEC(sofar,byte);
        REPEAT
         dest^:=body^;INC(dest);
         DEC(byte);
        UNTIL byte<=0;
        INC(body);
       END;
      END;
      INC(j);
    UNTIL j=depth;
    INC(i);INC(offset,bpr);
  UNTIL i=rows;
END DPaintGraph;

(* I did support a view headers (most used) but you can update this file *)

PROCEDURE ReadILBM(name:ARRAY OF CHAR;VAR YourScreen:id.ScreenPtr):IFFErrors;
VAR chunk:ADDRESS;
    t:INTEGER;
BEGIN
  (* Be sure that pointers are nil *)
  BODY:=NIL;
  CMAP:=NIL;
  BMHD:=NIL;

  (* open the iff file *)
  file := dl.Open(ADR(name),dd.oldFile);
  IF file=NIL THEN RETURN iffOpenfailed; END;

  (* read the header file "FORM",size,"ILBM" *)
  IF (dl.Read(file, ADR(HEADER), SIZE(HEADER)) # SIZE(HEADER)) THEN
   RETURN iffHeaderfailed;
  END;

  (* Check for the ILBM Header file *)
  IF (s.Compare(HEADER.name,"FORM")#0) OR (s.Compare(HEADER.name1,"ILBM")#0) THEN
   RETURN iffWrongIFF;
  END;

  (* Get the needed chunks and allocate the needed memory for them *)
  WHILE (dl.Read( file, ADR(HEADER), 8) = 8) DO

   IF (s.Compare(HEADER.name,'BMHD')=0) OR
      (s.Compare(HEADER.name,'CMAP')=0) OR
      (s.Compare(HEADER.name,'BODY')=0)
   THEN
  (* Easy to use Heap.Allocate , but you make your own list or use Remember *)
    H.Allocate(chunk,HEADER.length);
    IF chunk=NIL THEN RETURN iffOutOfMem; END;

    IF (dl.Read(file, chunk, HEADER.length) # HEADER.length) THEN
     RETURN iffHeaderfailed;
    END;

    IF (s.Compare(HEADER.name,'BMHD')=0) THEN
          BMHD:=chunk;
    ELSIF (s.Compare(HEADER.name,'CMAP')=0) THEN
          CMAP:=chunk;
    ELSIF (s.Compare(HEADER.name,'BODY')=0) THEN
          BODY:=chunk;
    END;
   ELSE
    (* Don't get unneeded headers *)
    IF dl.Seek( file, HEADER.length, 0) > 0 THEN END;
   END;
  END;

 (* close the opened file *)
 IF file#NIL THEN dl.Close(file); file:=NIL END;

 (* you can leave this away but this is a second check if i get everything *)
 IF (BMHD=NIL) OR (BODY=NIL) THEN
  A.Assert(TRUE,ADR("No body, bmhd allocate"));
 END;

  (* setup my screen *)
  WITH newScreen DO
      width:=BMHD^.width;
      height:=BMHD^.height;
      depth:=BMHD^.depth;
      leftEdge := 0;
      topEdge := 0;
      viewModes := gd.ViewModeSet{};
      IF (width>320) THEN INCL(viewModes,gd.hires) END;
      IF height>256  THEN INCL(viewModes,gd.lace) END;
      IF depth>5     THEN INCL(viewModes,gd.ham) END;
      detailPen := 0; blockPen := 0;
      type := id.customScreen+id.ScreenFlagSet{id.screenQuiet,id.screenBehind};
      font := NIL;
      defaultTitle := NIL;
      gadgets := NIL;
      customBitMap := NIL;
    END;

    (* open the screen behind every otherscreen *)
    YourScreen := il.OpenScreen(newScreen);
    IF YourScreen=NIL THEN RETURN iffOpenScreenfailed; END;
    myscreen:=YourScreen;

    (* set the right colors which we use *)
    colorCnt:= SHIFT(1,BMHD^.depth);
    IF CMAP#NIL THEN
      FOR t:=0 TO colorCnt-1 DO
       r:=CARDINAL(CMAP^); INC(CMAP);
       g:=CARDINAL(CMAP^); INC(CMAP);
       b:=CARDINAL(CMAP^); INC(CMAP);          (* >> *)
       ColorTable[t] := (SHIFT(r,4) + g + SHIFT(b,-4));
      END;
      gl.LoadRGB4(ADR(YourScreen^.viewPort),ADR(ColorTable), colorCnt);
    END;

    (* How many bytes per row ? *)
    bpr:=Byte(YourScreen^.bitMap.bytesPerRow);

    (* copy picture data to screen bitmap
       First checkout if compressed or Not
     *)
    IF (BMHD^.comp=0) THEN
      MakeGraph(BODY,YourScreen^.bitMap.planes);
    ELSIF (BMHD^.comp=1) THEN (* compressed *)
      DPaintGraph(BODY,YourScreen^.bitMap.planes);
    END;

    (* screen to front mode , to see the picture *)
    il.ScreenToFront(YourScreen);

    (* just free the needed memory *)
    IF CMAP#NIL THEN H.Deallocate(CMAP); END;
    IF BODY#NIL THEN H.Deallocate(BODY); END;
    IF BMHD#NIL THEN H.Deallocate(BMHD); END;
    RETURN iffNoErr;
END ReadILBM;

(*-------------------------------------------------------------------------*)
(*-------------------------------------------------------------------------*)

BEGIN
 file := NIL;
CLOSE
 CleanUp;
END readiff.
