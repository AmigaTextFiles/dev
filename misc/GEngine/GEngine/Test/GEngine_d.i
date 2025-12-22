{--- 1er intento de include GEngine ---}

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/IntuitionBase.i"}

{$I "Include:Graphics/RastPort.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/Text.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/GfxBase.i"}
{$I "Include:Graphics/View.i"}
{$I "Include:Graphics/Areas.i"}
{$I "Include:Graphics/Blitter.i"}

{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Libraries/ExecBase.i"}
{$I "Include:Libraries/GEngine.i"}
{$I "Include:Libraries/GE_AVL.i"}
{$I "Include:Libraries/GE_MemPools.i"}

{--Utils--}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/GE_Hooks.i"}

Const
 Pi2 = 6.2831853; {#-921707709}

Type

{-- IDList --}

 IDRemember = Record
	ID_Next : ^IDRemember;
	ID_Start: Short;
	ID_Size : Short;
 end;

 IDRememberPtr = ^IDRemember;

{-- NEW GEGUI struct (definitive?) --}
{-- Returned in GEObject.O_Data    --}
{-- GEOBject.O_Special==Nil by now --}

 GEGUI = Record
	G_Name : String;
	G_Flags: Integer;
	G_Status: Short;
	G_Selected: Integer;
	G_LValue: Integer;
	G_PInfo : PenInfoPtr; {Default PenInfo for WB Windows}
	G_WBScreen: ScreenPtr; {WB Screen}
	G_IDList : IDRememberPtr; {List of Allocated IDs}
 end;

 GEGUIPtr = ^GEGUI;

 GEProp = Record
	P_Label : Address;
	P_Frame : Address;
	P_Image,
	P_HImage : Address;
	P_IHook : Address;
	P_Rast,
	P_HRast : RastPortPtr;
	P_KnobH,
	P_KnobW : Short;
	P_Min,
	P_Max   : Short;
	P_ToolTip: String;
	P_Flags  : Boolean;
  end;

  Triplet = Array[1..3] of Integer;

  GEVars = Record
	IntBas	: IntuitionBasePtr;
	ExeBas	: ExecBasePtr;
	WFont	: TextAttrPtr;	{Font for Windows titles, etc}
	SFont	: TextAttrPtr;	{Font to use inside Sliders}
	ShiCol, 		{Color Brillo}
	HShCol,			{Color Semi-Brillo}
	TxtCol,			{Color del texto}
	BckCol,			{Color de fondo}
	DrkCol,			{Color de sombra}
	HDkCol,			{Color de semi-sombra}
	HGhCol,			{Color de resaltado}
	SltCol	: Triplet;	{y Color de seleccion por defecto}
  end;
  GEVarsPtr = ^GEVars;


{Project Structure, returned to you by NewProject}
  GEProject = Record
	PScreen	: ScreenPtr;	{This Project Screen, Nil if in WB Screen}
	PWindow : WindowPtr;	{This Project linked list of windows}
	PName	: String;	{This Project Name}
	PFlags	: Short;	{Flags}
	ShiPen,
	HShPen,
	TxtPen,
	BckPen,
	DrkPen,
	HDkPen,
	HghPen,
	SltPen	: Short;
	PPlay	: GadgetPtr;	{Current gadget selected}
	LValue	: Integer;	{Last value of the selected gadget}
  end;

  GEProjectPtr = ^GEProject;
{-----------------------}
Const
{Flags for project}

P_CSCR = $0001; {The project uses its own screen}
P_CCOL = $0002; {The project has its own palette}

Type
{NewProject}

 NewProject = Record
	Flags	: Short;
	SWidth,
	SHeight,
	SDepth,
	SMode	: Short; {if P_CSCR in flags then this are the custom screen attr}
	Ccolors : Address; { if P_CSCR & NP_CCOL the this is the custom colortable}
	CCount	: Short; {Number of colors in colortable. Set unused colors to $FFFF}
	Name	: String; {Project Name, max 80 chars}
 end;

 NewProjectPtr = ^NewProject;
{--------}

 GEMess = Record
	GType:	Short;
	GID  :	Byte;
	Pad1 :	Byte;
	GAct :	Short;
	GVal :	Integer;
 end;
 GEMessPtr = ^GEMess;


Const
{GAct values}

 GA_CHANGE = $0001;
 GA_INACT  = $0002;
 GA_ACTIVE = $0003;
 GA_PLAY   = $0004;

Type

  Items = Record
    Name    : String;
    Next    : ^Items;
  end;
  ItemsPtr = ^Items;

  MyProp = Record
    LeftEdge,
    TopEdge,
    Width,
    Height    : Short;
    VInit,
    HInit    : Short; {Valores iniciales}
    VMin,
    HMin    : Short; {Valores minimos}
    VMax,
    HMax    : Short; {Valores maximos}
    Flags    : Short;
    Reserved: Short;
    Font    : TextAttrPtr;
    CData    : Address;
    PropID : Byte;
    Pad : Byte;
    ToolTip : String;
  end;
  MyPropPtr = ^MyProp;

{Estructura comun a todos los gadgets}
  GotchaDat = Record
    GType    : Short;    {Tipo de Gadget}
    Flags    : Short;
    Action   : Address;    {Tags}
    ToolTip  : String;
  end;
  GotchaDatPtr = ^GotchaDat;

  GPropExt = Record
    GData : GotchaDat;
    NRast,
    HRast : RastPortPtr; {Rasters Temporales para el Knob}
    KnoW,
    KnoH  : Short; {Dimensiones del Knob}
    MinX,
    MinY,
    MaxX,
    MaxY  : Short; {Limites de valores}
    GFont : TextFontPtr; {Fuente de texto interno}
    CData : Address; {Puntero a array de strings}
  end;
  GPropExtPtr = ^GPropExt;

Const

{Constantes para GotchaDat.GType}

 GT_SCR = $0001; {Scroller}
 GT_SLD = $0002; {Slider}
 GT_STR = $0003; {String}
 GT_BUT = $0004; {Button}
 GT_POP = $0005; {Pop-Up Menu}
 GT_MEX = $0006; {Mutual Exclude}
 GT_LFT = $0100; {Flecha izquierda}
 GT_RGT = $0200; {Flecha derecha}
 GT_UP  = $0300; {Flecha arriba}
 GT_DWN = $0400; {Flecha abajo, estos ultimos usados con GT_SCR o GT_BUT}
 GT_FIL = $0500; {Archivo}
 GT_DRW = $0600; {Directorio, usar con GT_BUT}
{--------------------}
{Constantes internas para GadgetID}
 ID_SLD = $1000;
 ID_STR = $2000;
 ID_BUT = $3000;
 ID_POP = $4000;
 ID_MEX = $5000;
 ID_MOR = $6000;
 ID_LES = $7000;

{Constantes para MyProp.Flags}

 PLPC    = $1000; {LeftEdge es un porcentaje del ancho de la ventana}
 PTPC    = $2000; {lo mismo para TopEdge}
 PWPC    = $4000; {y Width}
 PHPC    = $8000; {y Height}
 PTXT    = $0200; {El Knob contiene texto}

{Nota: Use FREEHORIZ o FREEVERT en MyProp.Flags
 para indicar la orientacion del gadget}

{Constantes para Place en GEOpenWindow}

 PL_TL	= $0001; {Top Left of screen}
 PL_TR	= $0002; {Top Right}
 PL_BL	= $0003; {Bottom Left}
 PL_BR	= $0004; {Bottom Right}
 PL_CC	= $0005; {Centered}

{-------------------}

Pen1 : Triplet = ($E0000000,$E0000000,$E0000000);
Pen2 : Triplet = ($C0000000,$C0000000,$C0000000);
Pen3 : Triplet = (0,0,0);
Pen4 : Triplet = ($AA000000,$AA000000,$AA000000);
Pen5 : Triplet = ($50000000,$50000000,$50000000);
Pen6 : Triplet = ($70000000,$70000000,$70000000);
Pen7 : Triplet = ($D0000000,$B0000000,0);
Pen8 : Triplet = ($FFFFFFFF,$40000000,$40000000);


{-------------------}

{Constantes para Vertex}

 iv_MOV = $0001; {Move to v_x,v_y}
 iv_DRW = $0002; {Draw to v_x,v_y}
 iv_AST = $0003; {Start AreaFill at v_x,v_y}
 iv_ACL = $0004; {End AreaFill at v_x,v_y}
 iv_MIN = $0005; {v_x & v_y are minimun sizes}
 iv_DRK = $0100; {Pen is now DarkPen}
 iv_SHI = $0200; { "   "  "  ShinePen}
 iv_TXT = $0300; { "   "  "  TextPen}
 iv_ODK = $1000; {Outline pen is now DarkPen}
 iv_OSH = $2000; {   "     "  "   "  ShinePen}
 iv_OTX = $3000; {   "     "  "   "  TextPen}
 iv_OCL = $4000; {No outline pen}
 iv_END = $00FF; {Last node}

{Constantes para VImage}

 VI_HEAD = $FFFF; {First node of the list, vi_width & vi_height are total
		   width & height of the list}
 VI_RELP = $0001; {This node position is relative to the previous node position}
 VI_FIXP = $0002; {This node position is fixed -> NOT SCALED}
 VI_RELS = $0004; {This node size is relative to previous node size}
 VI_FIXS = $0008; {This node size is fixed -> NOT SCALED, VI_RELS has precedence}
 VI_CNTP = $0010; {This node centered on: Whole VImage if no VI_RELP
		   else on previous node}

{Other bits are reserved}

Type

 Vertex = Record
		v_x,
		v_y : Short;
		v_flags: Short;
	  end;

 VImage = Record
		vi_flags,
		vi_left,
		vi_top,
		vi_width,
		vi_height,
		vi_rotation : Short;
		vi_image : Address;
		vi_next : ^VImage;
	  end;

 VImagePtr = ^VImage;

{-------------------}

Var
Defaults : GEVars;

Const

 Arrow : Array [0..7] of Vertex =
	 ((2,2,iv_MIN),(0,0,iv_AST+iv_SHI),(1,1,iv_DRW),
	  (2,0,iv_DRW),(1,2,iv_DRW),(0,0,iv_DRW),
	  (0,0,iv_ACL),(0,0,iv_END));

 XENB1 : Array [0..6] of Vertex =
	 ((2,2,iv_MIN),(0,0,iv_MOV+iv_TXT),(2,0,iv_DRW),(2,2,iv_DRW),
	  (0,2,iv_DRW),(0,0,iv_DRW),(0,0,iv_END));

 XENB2 : Array [0..6] of Vertex =
	 ((2,2,iv_MIN),(0,0,iv_MOV+iv_SHI),(2,0,iv_DRW),(2,2,iv_DRW+iv_DRK),
	  (0,2,iv_DRW),(0,0,iv_DRW+iv_SHI),(0,0,iv_END));

 PROP1 : Array [0..9] of Vertex =
	 ((4,4,iv_MIN),(0,2,iv_MOV+iv_DRK),(2,0,iv_DRW),(1,0,iv_DRW),(0,1,iv_DRW),
	  (3,1,iv_MOV+iv_SHI),(1,3,iv_DRW),(2,3,iv_DRW),(3,2,iv_DRW),(0,0,iv_END));

 XBTN1 : VImage = (VI_RELS+VI_RELP+VI_FIXP,1,1,-2,-2,0,@XENB2,Nil);
 XBTN2 : VImage = (0,0,0,8,8,0,@XENB1,@XBTN1);
 XENBUTTON : VImage = (VI_HEAD,0,0,8,8,0,Nil,@XBTN2);
 PBTN0 : VImage = (0,0,0,8,8,0,@XENB2,Nil);
 PBTN1 : VImage = (VI_FIXS+VI_CNTP,0,0,4,4,0,@PROP1,@PBTN0);
 PROPBUTTON : VImage = (VI_HEAD,0,0,8,8,0,Nil,@PBTN1);

 NPBTN0 : VImage = (0,0,0,8,8,0,@XENB1,Nil);
 NPBTN1 : VImage = (VI_FIXS+VI_CNTP,0,0,4,4,0,@PROP1,@NPBTN0);
 NPROPBUTTON : VImage = (VI_HEAD,0,0,8,8,0,Nil,@NPBTN1);

{-- Crea Pen Info --}

{Function GetPenInfo(S: ScreenPtr): PenInfoPtr;

Var Vp: ViewPortPtr;
 PenI: PenInfoPtr;
 PenBuf,PPBuf: ^Array[0..0] of Short;
 i,r,g,b : Short;

Begin
 if S<>Nil then begin
  Vp:= Adr(S^.SViewPort);
  PenI:= AllocMem(SizeOf(PenInfo),MEMF_CLEAR+MEMF_PUBLIC);
  if PenI<>Nil then begin
   PenBuf:= AllocMem(16,MEMF_CLEAR+MEMF_PUBLIC);
   if PenBuf<>Nil then begin
    PenI^.PI_Version:= 1;
    PenI^.PI_NumPens:= 8;
    PPBuf:= Adr(GEngineBase^.eb_ShiCol);
    for i:= 0 to 7 do begin
      if i<>3 then begin
	r:= (PPBuf^[i] shr 8)and 15; g:= (PPBuf^[i] shr 4)and 15; b:= PPBuf^[i] and 15;
	PenBuf^[i]:= GetBestPen(Vp,r,g,b);
      end else
	PenBuf^[i]:= 0;
    end;
    PenI^.PI_PenArray:= PenBuf;
    PenI^.PI_NumCols:= VP^.ColorMap^.Count;
    PPBuf:= Nil; PPBuf:= AllocMem(PenI^.PI_NumCols*2,MEMF_PUBLIC+MEMF_CLEAR);
    if PPBuf<>Nil then begin
     for i:= 0 to PenI^.PI_NumCols-1 do
	PPBuf^[i]:= GetRGB4(VP^.ColorMap,i);
     PenI^.PI_Palette:= PPBuf;
     GetPenInfo:= PenI;
    end;
    FreeMem(PenBuf,16);
   end;
   FreeMem(PenI,SizeOf(PenInfo));
  end;
 end;
 GetPenInfo:= Nil;
end;}

{-- Libera Pen Info --}

{Procedure FreePenInfo(PI: PenInfoPtr);

Begin
 if PI<>Nil then begin
  if PI^.PI_PenArray<>Nil then
   FreeMem(PI^.PI_PenArray,16);
  if PI^.PI_Palette<> Nil then
   FreeMem(PI^.PI_Palette,PI^.PI_NumCols*2);
  FreeMem(PI,SizeOf(PenInfo));
 end;
end;}

{-- Polar --}
{
Function CModulo(X,Y:Real):Real;

Begin
 CModulo:= SQRT((X*X)+(Y*Y));
end;}

{Function CAlpha2(X,Y:Real):Real;

Var
 T: Real;

Begin
 if X<>0 then
  if Y=0 then
   if X>0 then
    T:= -PI2/4
   else
    T:= PI2/4
  else Begin
    T:= Abs(Y)/Abs(X);
    T:= ArcTan(T);
  end
 else if Y<0 then
  T:= 0
 else
  T:= PI2/2;
 if (X>0)and(Y<0) then
  T:= PI2-T
 else if (X>0)and(Y>0) then
  T:= (PI2/2)+T
 else if (X<0)and(Y>0) then
  T:= (PI2/2)-T;
 CAlpha2:= T;
end;}
{-- Dibuja imagen vectorial --}

Procedure DrawVertex(RP:RastPortPtr;X,Y,W,H,Rot:Short;VData:Address);

Const

Type
 tar = ^Array[0..0] of short;

Var
 MyAInfo : AreaInfo;
 MyTmpRas : TmpRas;
 MyPI : tar;
 Fill,Done: Boolean;
 ABuffer,Buffer : Address;
 ap,bp,op,dm : byte;
 Index, Mx,My,I :Short;
 Sx,Sy: Real;
 Data : ^Array[0..0] of Vertex;
 Rc,Rxy,Ryx : Short; {Rotation}
 AX,AY: Short; {Actual X & Y}
 PX,PY: Short; {Previous X & Y}
 t1,t2,T: Real; {temp}
 Rangle, PRad, P: Real;

Begin
 if (RP<>Nil) and (RP^.RP_User<>Nil) then begin
  MyPI:= tar(PenInfoPtr(RP^.RP_User)^.PI_PenArray);
  ap := RP^.FGPen; bp:= RP^.BGPen; op:= RP^.AOlPen; dm:= RP^.DrawMode;
  SetDrMd(RP,JAM2);
  Index:= 0; Done:=False; Fill:= False;
  Mx:= 2; My:=2;
  Data:= VData;
  Rangle:= ((Rot+90)*Pi2)/360; {Rot en radianes}
  while (Index <= 65535) and not Done do begin
   {find min sizes}
   if (Data^[Index].v_Flags and iv_MIN)=iv_MIN then begin
	Mx:= Data^[Index].v_x;
	My:= Data^[Index].v_y;
	Done:= true;
   end;
   if Data^[Index].v_Flags = iv_END then
	Done:= true;
   inc(Index);
  end;
  Index:= 0; Done:= False;
  Sx:= W/Mx; Sy:= H/My;
  Move(RP,X,Y);
  SetAPen(RP,TXTPEN); {RP^.AOlPen:=2; RP^.Flags:= RP^.Flags or 8;}

  Rc:= 1; Rxy:= 0;
  Ryx:= 0;
  Case ((Rot+45)div 90) of
	1: Begin
		Rc:= 0; Rxy:= 1;
		Ryx:= -1;
	   end;
	2: Begin
		Rc:= -1; Rxy:= 0;
		Ryx:= 0;
	   end;
	3: Begin
		Rc:= 0; Rxy:= -1;
		Ryx:= 1;
	   end;
  end;

  PX:=0; PY:=0;

  While (Index <= 65535) and not Done do begin
   {Iterate trought vertex}
   AX:= Data^[Index].v_x;
   AY:= Data^[Index].v_y;
   if (Rot Mod 90)<>0 then begin
    t1:= AX-(Mx/2); t2:= AY-(My/2);
    P:= CModulo(t1,t2); {SQRT((t1*t1)+(t2*t2));} {Modulo}
    PRad:= CAlpha(t1,t2)+Rangle;
    AX:= ((P*cos(PRad))*Sx); AY:= -((P*sin(PRad))*Sy);
    AX:= AX+X+((Mx/2)*Sx); AY:= AY+Y+((My/2)*Sy);
   end else begin
    AX:= ((Rc*Data^[Index].v_x)+((Ord(Rc<0)div 255)*Mx))*Sx;
    AX:= AX+(((Rxy*Data^[Index].v_y)+((Ord(Rxy<0)div 255)*My))*Sy)+X;
    AY:= ((Rc*Data^[Index].v_y)+((Ord(Rc<0)div 255)*My))*Sy;
    AY:= AY+(((Ryx*Data^[Index].v_x)+((Ord(Ryx<0)div 255)*Mx))*Sx)+Y;
   end;
   {Writeln(AX,' ',AY,' ',t1,' ',t2); Readln(P);}
   Case (Data^[Index].v_Flags and $0F00) of
	iv_DRK : SetAPen(RP,MyPI^[DRKPEN]);
	iv_SHI : SetAPen(RP,MyPI^[SHIPEN]);
	iv_TXT : SetAPen(RP,MyPI^[TXTPEN]);
   end;
   Case (Data^[Index].v_Flags and $00FF) of
	iv_AST : if Fill=False then begin
		  Buffer:= AllocRaster(BitmapPtr(RP^.BitMap)^.bytesPerRow*8,BitMapPtr(RP^.BitMap)^.Rows);
		  if Buffer<> Nil then begin
		   InitTmpRas(@MyTmpRas,Buffer,BitmapPtr(RP^.BitMap)^.bytesPerRow*BitMapPtr(RP^.BitMap)^.Rows);
		   i:= Index+1;
		   {Calculate number of vertex of area}
                   While (i<= 65535) and not Done do begin
		    if ((Data^[i].v_Flags and $00ff)= iv_ACL)or((Data^[i].v_Flags and $00ff)= iv_END) then
			Done:= true;
		    inc(i);
		   end;
		   i:= i-Index;
		   Done:= False;
		   ABuffer:= AllocMem(i*5,MEMF_CLEAR+MEMF_PUBLIC);
		   if ABuffer<>Nil then begin
			RP^.TmpRas:= @MyTmpRas;
			InitArea(@MyAInfo,ABuffer,i);
			RP^.AreaInfo:= @MyAInfo;
			if AreaMove(RP,AX,AY)=0 then;
			Fill:= true;
		   end else
			FreeRaster(Buffer,BitmapPtr(RP^.BitMap)^.bytesPerRow*8,BitMapPtr(RP^.BitMap)^.Rows);
		  end;
		  PX:= AX; PY:= AY;
		 end;
        iv_MOV : Begin
		  if not Fill then
		   Move(RP,AX,AY)
		  else
		  if AreaMove(RP,AX,AY)=0 then;
		  PX:= AX; PY:= AY;
		 end;
	iv_DRW : Begin
		  if not Fill then
		   Draw(RP,AX,AY)
		  else
		  if AreaDraw(RP,AX,AY)=0 then;
		  PX:= AX; PY:= AY;
		 end;
	iv_ACL : if Fill= True then begin
		  if AreaEnd(RP)=0 then;
		  RP^.AreaInfo:=Nil;
		  RP^.TmpRas:= Nil;
		  FreeRaster(Buffer,BitmapPtr(RP^.BitMap)^.bytesPerRow*8,BitMapPtr(RP^.BitMap)^.Rows);
		  FreeMem(ABuffer,i*5);
		  Fill:= False;
		  PX:= AX; PY:= AY;
		 end;
	iv_END : Begin
		  if Fill= True then begin
		   if AreaEnd(RP)=0 then;
		   RP^.TmpRas:= Nil;
		   RP^.AreaInfo:=Nil;
		   FreeRaster(Buffer,BitmapPtr(RP^.BitMap)^.bytesPerRow*8,BitMapPtr(RP^.BitMap)^.Rows);
		   FreeMem(ABuffer,i*5);
		   Fill:= False;
		  end;
		  Done:= True;
		 end;
   end;
   inc(Index);
  end;
  SetAPen(RP,ap); SetBPen(RP,bp); RP^.AOlPen:= ap; SetDrMd(RP,dm);
 end;
end;

{--Draw a list of Vector Images--}

Procedure DrawVImage(RP:RastPortPtr; VI:VImagePtr; L,T,W,H,R:Short);

Var
 AX,AY,PX,PY,
 AW,AH,PW,PH: Short;
 SX,SY: Real;
 TMP: VImagePtr;
 FIN: Boolean;

Begin
 if (RP<>Nil) and (VI<>Nil)then begin
  TMP:= VI;
  AX:=0; AY:=0; PX:=0; PY:=0;
  Fin:= false;
  While (TMP<>Nil) and not Fin do begin
   if (TMP^.vi_flags and $FFFF) = VI_HEAD then begin
        SX:= W/TMP^.vi_Width; SY:= H/TMP^.vi_Height;
	fin:= true;
   end else
	TMP:= TMP^.vi_next;
  end;
  fin:= false;
  TMP:= VI;
  While TMP<>Nil do begin
   if (TMP^.vi_flags and $FFFF)<>VI_HEAD then begin
    AX:= TMP^.vi_left; AY:= TMP^.vi_top;
    if (TMP^.vi_flags and VI_RELP)<>0 then begin
     AX:= AX+PX; AY:= AY+PY;
    end;
    if (TMP^.vi_flags and VI_FIXP)=0 then begin
     AX:= AX*SX; AY:= AY*SY;
    end;
    if (TMP^.vi_flags and VI_CNTP)<>0 then
     if (TMP^.vi_flags and VI_RELP)<>0 then begin
	AX:= PX+((PW-1)/2);
	AY:= PY+((PH-1)/2);
     end else begin
	AX:= (W+1)/2;
	AY:= (H+1)/2;
     end;
    AX:= AX+L; AY:= AY+T;
    if (TMP^.vi_flags and VI_RELS)<>0 then begin
	AW:= AW+TMP^.vi_Width;
	AH:= AH+TMP^.vi_Height;
    end else begin
	AW:= TMP^.vi_Width;
	AH:= TMP^.vi_Height;
	if (TMP^.vi_flags and VI_FIXS)= 0 then begin
	 AW:= AW*SX;
	 AH:= AH*SY;
	end;
    end;
    if (TMP^.vi_flags and VI_CNTP)<>0 then begin
	AX:= AX-(AW/2);
	AY:= AY-(AH/2);
    end;
    DrawVertex(RP,AX,AY,AW,AH,R,TMP^.vi_image);
    PX:= AX; PY:= AY;
    PW:= AW; PH:= AH;
   end;
   TMP:= TMP^.vi_next;
  end;
 end;
end;

{--RGB a HSL--}

{Procedure RGBtoHSL(rgb:short; VAR rhue,rsat,rlum:Integer);

Var
 min,max,hue,sat,lum,diff,rpart,gpart,bpart,rwork,gwork,bwork : Integer;

Begin
 rwork:= ((rgb shr 8)AND 15)* $111;
 gwork:= ((rgb shr 4)AND 15)* $111;
 bwork:= (rgb AND 15)* $111;
 if rwork < gwork then
    min:= rwork
 else
    min:= gwork;
 if bwork < min then
    min:= bwork;
 if rwork > gwork then
    max:= rwork
 else
    max:= gwork;
 if bwork > max then
    max:= bwork;
 lum:= max; lum:= lum shl 4; diff:= max-min;
 if max <> 0 then begin
    sat:=(diff shl 16)/max;
    if (sat > $ffff) then
     sat:= $ffff;
 end else
    sat:= 0;
 if sat=0 then
    hue:= 0
 else begin
    rpart:= (((max-rwork)shl 16)/diff)shr 4;
    gpart:= (((max-gwork)shl 16)/diff)shr 4;
    bpart:= (((max-bwork)shl 16)/diff)shr 4;
    if rwork=max then
        hue:= bpart-gpart
    else if gwork=max then
        hue:= $2000+rpart-bpart
    else if bwork=max then
        hue:= $4000+gpart-rpart;
    if hue<0 then hue:= hue+$6000;
    hue:= (hue*2667)/1000;
 end;
 rhue:= hue; rsat:= sat; rlum:= lum;
end;
}

{Busca si hay un color igual}

{Function Look4Color(Vp:ViewPortPtr; r,g,b:Byte):Integer;

Var
 CM : ColorMapPtr;
 i,Max  : Integer;
 rgb: Short;

Begin
 if Vp<>Nil then begin
   rgb:= (r shl 8)or(g shl 4)or B;
   CM:= Vp^.ColorMap;
   Max:= Bit(Vp^.RasInfo^.BitMap^.Depth);;
   i:= 0;
   While (i<Max) and (rgb<>GetRGB4(CM,i)) do
	inc(i);
   if i>=Max then
	Look4Color:= -1
   else
	Look4Color:= i;
 end;
end;}

{Busca una entrada libre en la tabla de colores}
{Function GetFreePen(Vp:ViewPortPtr):Integer;

Var
 CT: ^Array[0..0] of Short;
 i,Max : Integer;

Begin
 if Vp<>Nil then begin
   Max:= Bit(Vp^.RasInfo^.BitMap^.Depth);;
   i:= 0;
   CT:= Vp^.ColorMap^.ColorTable;
   While (i<=Max) and (CT^[i]<>$FFFF) do
	inc(i);
   if i>Max then
	GetFreePen:= -1
   else
	GetFreePen:= i;
 end;
end;}

{--Obtener mejor pluma--}

{Function GetClosest(BVp:ViewPortPtr; r,g,b:Short):Short;
Var
Ph,Ps,Pl,Max,PRGB,WRGB,ARGB,BRGB,i,Best,Actual,Bp,
Wh,Ws,Wl,Wr,Wg,Wb,PY,WY    :Integer;
WCm : ColorMapPtr;

Begin
 Best:= $FFFF; Bp:= 0; BRGB:= $FFFF;
 WCm:= BVp^.ColorMap;
 Max:= Bit(BVp^.RasInfo^.BitMap^.Depth);
 PRGB:= (r shl 8)or(g shl 4)or B;
 PY := Round((0.3*r)+(0.59*g)+(0.11*b));
 RGBtoHSL(PRGB,Ph,Ps,Pl);
 For i:= 0 to Max-1 do begin
  WRGB:= GetRGB4(WCm,i);
  Wr:= (WRGB Shr 8)and 15;Wg:= (WRGB Shr 4)and 15;Wb:= WRGB and 15;
  if (PRGB=0) or (PRGB=$FFF) then begin
    WY:= Round((0.3*Wr)+(0.59*Wg)+(0.11*Wb));
    Actual:= Abs(WY-PY);
    if Actual<Best then begin
        Best:= Actual;
        BP := i;
    end;
  end else begin
    RGBtoHSL(WRGB,Wh,Ws,Wl);
    Actual:= ((Abs(Wh-Ph)div 2)+(Abs(Ws-Ps)div 4)+(Abs(Wl-Pl)div 8))div 3;
    ARGB:= Abs(r-Wr)+Abs(g-Wg)+Abs(b-Wb);
    if (Actual < Best) and (ARGB<BRGB) then begin
        Best:= Actual;
        Bp:= i;
        BRGB:= ARGB;
    end;
  end;
 end;
 GetClosest := Bp;
end;}

{Obtener mejor pluma}
{Function GetBestPen (Vp:ViewPortPtr; r,g,b:Byte):Short;

Var
 i: Short;
 rgb:Short;

Begin
 rgb:= (r shl 8)or(g shl 4)or B;
 i:= Look4Color(Vp,rgb);
 if i=-1 then begin
  i:= GetFreePen(Vp);
  if i<>-1 then begin
	SetRGB4(Vp,i,r,g,b);
	GetBestPen:= i;
  end else
	GetBestPen:= GetClosestPen(Vp,r,g,b);
 end else
	GetBestPen:= i;
end;}

{Opens a Menu Window}

Function OpenMenuWindow(x,y : Short; List : ItemsPtr; Scr : ScreenPtr) : Address;

const
    MDat1 : array [1..5,1..2] of Short= ((0,0),(0,100),(100,100),(100,0),(1,0));

    MBor1 : Border = (0,0,1,2,JAM2,5,@MDat1,Nil);

    MenuWindow : NewWindow = (0,0,101,101,1,2,
        MOUSEBUTTONS_f + ACTIVEWINDOW_f +
        INACTIVEWINDOW_f + GADGETUP_f + GADGETDOWN_f,
        BORDERLESS + SIMPLE_REFRESH + ACTIVATE ,
        Nil, { Could add all gadgets automatically here }
        Nil, Nil, Nil, Nil, 138, 100, -1, -1, CUSTOMSCREEN_f);

var
    MWin : WindowPtr;
    first,Aux : ItemsPtr;
    j,k,Max,Ys : Short;
    Mgad,Agad,fgad : GadgetPtr;
    MText : IntuitextPtr;
    Black,White: Short;

begin
 Ys := Scr^.Font^.ta_YSize;
 j := 0;
 k := 0;
 Max := 0;
 first := List;
 new(Mgad);
 fgad := Mgad;
 Black:= GetBestPen(@Scr^.SViewPort,0,0,0);
 White:= GetBestPen(@Scr^.SViewPort,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF);
 MBor1.FrontPen:=Black; MBor1.BackPen:=White;
 repeat
    with Mgad^ do begin
        LeftEdge := 3;
        TopEdge := ((Ys+3)*j)+2;
        Aux := List^.Next;
        k := TextLength(@Scr^.SRastPort,List^.Name,StrLen(List^.Name));
        if k > Max then Max := k;
        Height := Ys;
        Flags := GADGHCOMP;
        Activation := RELVERIFY+GADGIMMEDIATE;
        GadgetType := BOOLGADGET;
        GadgetRender := Nil;
        SelectRender := Nil;
        New(MText);
        with MText^ do begin
            FrontPen := Black;
            BackPen := White;
            DrawMode := JAM2;
            LeftEdge := 0;
            TopEdge := 0;
            ITextFont := Nil;
            IText := List^.Name;
            NextText := Nil;
        end;
        GadgetText := MText;
        MutualExclude := 0;
        SpecialInfo := Nil;
        GadgetID := j;
        UserData := Nil;
        List := Aux;
        inc(j);
    end;
    if List <> Nil then begin
        New(Agad);
        Mgad^.NextGadget := Agad;
        Mgad := Agad;
    end;
 until List = Nil;
 List := first;
 Mgad^.NextGadget := Nil;
 Mgad := fgad;
 repeat
    Mgad^.Width := Max;
    Agad := Mgad^.NextGadget;
    Mgad := Agad;
 until Mgad = Nil;
 Mgad := fgad;
 Max := Max+4;
 j := j*(Ys+3);
 if (j+y) >= Scr^.Height then
    y := Scr^.Height-j;
 MenuWindow.Screen := Scr;
 MenuWindow.LeftEdge := x;
 MenuWindow.TopEdge := y;
 MenuWindow.Height := j+1;
 MenuWindow.Width := Max+1;
 MDat1[2,2] := j;
 MDat1[3,2] := j;
 MDat1[3,1] := Max;
 MDat1[4,1] := Max;
 MenuWindow.FirstGadget := Mgad;
 MWin := OpenWindow(@MenuWindow);
 if MWin <> Nil then begin
    SetRast(MWin^.RPort,White);
    DrawBorder(MWin^.RPort,@MBor1,0,0);
    RefreshGList(Mgad,MWin,Nil,j div Ys);
    OpenMenuWindow := MWin;
 end else
    OpenMenuWindow := Nil;
end;


{Closes a MenuWindow}

Procedure CloseMenuWindow (MW : WindowPtr);

var
  WG,AG : GadgetPtr;
  Mt : IntuitextPtr;

begin
 WG := MW^.FirstGadget;
 MW^.FirstGadget := Nil;
 While WG <> Nil do begin
    AG := WG^.NextGadget;
    Mt := WG^.GadgetText;
    WG^.GadgetText := Nil;
    Dispose(Mt);
    Dispose(WG);
    WG := AG;
 end;
 CloseWindow(MW);
end;


{Returns option pushed from menuwindow}

Function GetMenuSelection(MW : WindowPtr) : Short;

var
    WMMess    : IntuiMessagePtr;
    MQuit    : Boolean;
    Aux    : Short;

Begin
 MQuit := false;
 repeat
    WMMess := IntuiMessagePtr(WaitPort(MW^.UserPort));
    WMMess := IntuiMessagePtr(GetMsg(MW^.UserPort));
    case WMMess^.Class of
        INACTIVEWINDOW_f : begin
                    MQuit := true;
                    Aux := -1;
                   end;
        GADGETUP_f     : begin
                    MQuit := true;
                    Aux := GadgetPtr(WMMess^.IAddress)^.GadgetID;
                   end;
    end;
 until MQuit;
 GetMenuSelection := Aux;
end;


{Dibujar caja 3d}
{Procedure DrawBevel(Rp: RastPortPtr;x,y,w,h,wh,bl: Short;Recesed: Boolean);

Const
 LBor: Border= (0,0,0,0,JAM1,3,Nil,Nil);
 DBor: Border= (0,0,0,0,JAM1,3,Nil,@LBor);
var
 LB,DB: Array [1..3,1..2] of short;

Begin
 if Recesed then begin
    LBor.FrontPen:= bl;
    DBor.FrontPen:= wh;
 end else begin
    LBor.FrontPen:= wh;
    DBor.FrontPen:= bl;
 end;
 LBor.XY:= @LB; DBor.XY:= @DB;
 LBor.TopEdge:= y; DBor.TopEdge:= y;
 LBor.LeftEdge:= x; DBor.LeftEdge:= x;
 LB[1,1]:= 0; LB[1,2]:= h-1;
 LB[2,1]:= 0; LB[2,2]:= 0;
 LB[3,1]:= w-1; LB[3,2]:= 0;
 DB[1,1]:= 1; DB[1,2]:= h-1;
 DB[2,1]:= w-1; DB[2,2]:= h-1;
 DB[3,1]:= w-1; DB[3,2]:= 1;
 DrawBorder(Rp,@DBor,0,0);
end;}

{--Inicia RP para Gadget--}

{function GetGadRPort(W,H,D:Short):RastPortPtr;

Var
 RP    : RastPortPtr;
 BM    : BitmapPtr;
 Chunk    : Address;
 i    : Short;

Begin
 Chunk:= AllocMem(RASSIZE(W,H)*D,MEMF_CLEAR+MEMF_PUBLIC+MEMF_CHIP);
 if Chunk<>Nil then begin
  BM:= AllocMem(sizeof(BitMap),MEMF_CLEAR+MEMF_PUBLIC);
  if BM<>Nil then begin
   InitBitMap(BM,D,W,H);
   for i:=0 to D-1 do
    BM^.Planes[i]:= Address(Integer(Chunk)+(RASSIZE(W,H)*i));
   RP:= AllocMem(sizeof(RastPort),MEMF_CLEAR+MEMF_PUBLIC);
   if RP<>NIL then begin
    InitRastPort(RP);
    RP^.Bitmap:= BM;
    SetRast(RP,0);
    GetGadRPort:= RP;
   end;
   FreeMem(BM,Sizeof(BitMap));
  end;
  FreeMem(Chunk,RASSIZE(W,H)*D);
 end;
 GetGadRPort:= Nil;
end;}

{Libera RP de Gadget}
{Procedure FreeGadRP(RP:RastPortPtr);

Var BM:BitMapPtr;

Begin
 if RP<> Nil then begin
  BM:= RP^.BitMap;
  if BM<>Nil then begin
   FreeMem(BM^.Planes[0],RASSIZE(BM^.BytesPerRow*8,BM^.Rows)*BM^.Depth);
   FreeMem(BM,SizeOf(BitMap));
  end;
  FreeMem(RP,Sizeof(RastPort));
 end;
end;}

{Numeros de Planos Requeridos}

Function ReqBits(X: Short):Short;

Var i: Short;

Begin
 {ReqBits:= Round((ln(X)/ln(2))+0.5);}
 i:= 0;
 Repeat
  X:= X shr 1;
  inc(i);
 Until X=0;
 ReqBits:= i;
end;

{Calcula el maximo largo de un intervalo numerico al ser convertida a cadena}
Function NumTextLength(RP:RastPortPtr; Min,Max:Integer):Integer;

var
 Temp	: String;
 i,l1,l2: Integer;

Begin
 Temp := AllocString(20);
 i:= IntToStr(Temp,Min);
 l1:= TextLength(RP,Temp,i);
 i:= IntToStr(Temp,Max);
 l2:= TextLength(RP,Temp,i);
 FreeString(Temp);
 if l1>l2 then
  NumTextLength:= l1
 else
  NumTextLength:= l2;
end;


{Inicializa Prop Gadget}
Function InitGProp(PP:GEProjectPtr; Win:WindowPtr; Prop: MyPropPtr): GadgetPtr;

var
 wi,he,
 wg,hg,Tw,
 x,y,i    : Short;
 Pi    : PropInfoPtr;
 GRp    : Array[1..2] of RastPortPtr;
 MIm    : Array[1..2] of ImagePtr;
 Vp    : ViewPortPtr;
 GProp    : GadgetPtr;
 Udat    : GPropExtPtr;
 PFont,
 AFont    : TextFontPtr;
 GSt    : String;
 Bl,Ne,D1,D2,D3,DP: Short;

Begin
 if (PP<>Nil)and(Win<>Nil)and(Prop<>Nil) then begin
  Vp:= ViewPortAddress(Win);
  Bl:= PP^.ShiPen; Ne:= PP^.DrkPen;
  D1:= ReqBits(BL); D2:= ReqBits(Ne); D3:= ReqBits(PP^.TxtPen);
  {Writeln(BL,' ',ne,' ',PP^.TxtPen,' ',d1,' ',d2,' ',d3);
  readln(i);}
  if D1>D2 then
	DP:= D1
  else
	DP:= D2;
  if D3>DP then
        DP:= D3;
  GProp:= AllocMem(SizeOf(Gadget),MEMF_CLEAR+MEMF_PUBLIC);
  if GProp<>Nil then begin
   if (Prop^.Flags and PTXT)<>0 then begin
    if Prop^.Font<>Nil then
        PFont:= OpenFont(Prop^.Font)
    else
        PFont:= OpenFont(ScreenPtr(Win^.WScreen)^.Font);
    AFont:= RastPortPtr(Win^.RPort)^.Font;
    SetFont(Win^.RPort,PFont);
    Tw:= 10*Round((NumTextLength(Win^.RPort,Prop^.HMin,Prop^.HMax)/10)+0.5);
    SetFont(Win^.RPort,AFont);
    Writeln(PFont^.tf_Baseline,'-',PFont^.tf_YSize);
   {Writeln('font done'); readln(i);}
   end else
    PFont:= Nil;
   if (Prop^.Flags and PWPC)<>0 then
    wg:= (Win^.Width*Prop^.Width)div 100
   else
    wg:= Prop^.Width;
   if wg < 10 then
    wg:= 10;
   if (PFont<>Nil) and (wg<Tw+8) then
    wg:= Tw+8;
   if (Prop^.Flags and PHPC)<>0 then
    hg:= (Win^.Height*Prop^.Height)div 100
   else
    hg:= Prop^.Height;
   if hg<8 then
    hg:= 8;
   if PFont<>Nil then
    if hg<(PFont^.tf_YSize+8) then
    hg:= PFont^.tf_YSize+8;
   if (Prop^.Flags and PLPC)<>0 then
    x:= (Win^.Width*Prop^.LeftEdge)div 100
   else
    x:= Prop^.LeftEdge;
   if (Prop^.Flags and PTPC)<>0 then
    y:= (Win^.Height*Prop^.TopEdge)div 100
   else
    y:= Prop^.TopEdge;
   Pi:= AllocMem(SizeOf(PropInfo),MEMF_CLEAR+MEMF_PUBLIC);
   if Pi<>Nil then begin
    With Pi^ do begin
     Flags:= (Prop^.Flags and $0FFF);
     if (Prop^.HInit-Prop^.HMin) <>0 then
	HorizPot:= 65536 div (Prop^.HInit-Prop^.HMin)
     else
	HorizPot:= 0;
     if (Prop^.VInit-Prop^.VMin) <>0 then
	VertPot:= 65536 div (Prop^.VInit-Prop^.VMin)
     else
	VertPot:= 0;
     i:= Abs(Prop^.HMax-Prop^.HMin);
     if i<>0 then
	HorizBody:= 65536 div i
     else
	HorizBody:= $FFFF;
     i:= Abs(Prop^.VMax-Prop^.VMin);
     if i<>0 then
	VertBody:= 65536 div i
     else
	VertBody:= $FFFF;
    end;
    i:= Prop^.Hmax-Prop^.HMin;
    if i=0 then
     i:= 1;
     wi:= (wg-4)div i;
    if wi<(Tw+4) then
	wi:= Tw+4;
    i:= Prop^.VMax-Prop^.VMin;
    if i=0 then
     i:= 1;
    he:= (hg-4)div i;
    GRp[1]:= AllocGRPort(wi,he,DP);
    if GRp[1]<>Nil then begin
     GRp[1]^.RP_User:= GetPenInfo(ScreenPtr(Win^.WScreen));
     if GRp[1]^.RP_User<>Nil then begin
      GRp[2]:= AllocGRPort(wi,he,DP);
      if GRp[2]<>Nil then begin
       GRp[2]^.RP_User:= GetPenInfo(ScreenPtr(Win^.WScreen));
       if GRp[2]^.RP_User<>Nil then begin
	if PFont<>Nil then Begin
	 GSt:= AllocString(10);
	 if IntToStr(GSt,Prop^.HInit)=0 then;
	 for i:= 1 to 2 do begin
	  SetDrMd(GRp[i],JAM1);
	  SetFont(GRp[i],PFont);
	  Tw:= TextLength(GRp[i],GSt,StrLen(GSt));
	  SetAPen(GRp[i],PP^.TxtPen);
	  Move(GRp[i],(wi/2)-(Tw/2)-1,(he/2)+(PFont^.tf_YSize/2)-2);
	  GText(GRp[i],GSt,StrLen(GSt));
	 end;
	 FreeString(GSt);
	 {writeln('text writen');readln(i);}
	end;
	MIm[1]:= AllocMem(SizeOf(Image),MEMF_CLEAR+MEMF_PUBLIC);
	if MIm[1]<>Nil then begin
	 if PFont= Nil then
		DrawVImage(GRp[1],@PROPBUTTON,0,0,wi-1,he-1,0)
	 else
		DrawVertex(GRp[1],0,0,wi-1,he-1,0,@XENB2);
	 With MIm[1]^ do begin
	  LeftEdge:= 0;
	  TopEdge:= 0;
	  Width:= wi;
	  Height:= he;
	  Depth:= DP;
	  ImageData:= BitMapPtr(GRp[1]^.BitMap)^.Planes[0];
	  PlanePick:= Bit(DP)-1;
	  PlaneOnOff:= 0;
	  NextImage:= Nil;
	 end;
	 MIm[2]:= AllocMem(SizeOf(Image),MEMF_CLEAR+MEMF_PUBLIC);
	 if MIm[2]<>Nil then begin
	  if PFont= Nil then
		DrawVImage(GRp[2],@NPROPBUTTON,0,0,wi-1,he-1,0)
	  else
		DrawVertex(GRp[2],0,0,wi-1,he-1,0,@XENB1);
	  With MIm[2]^ do begin
	   LeftEdge:= 0;
	   TopEdge:= 0;
	   Width:= wi;
	   Height:= he;
	   Depth:= DP;
	   ImageData:= BitMapPtr(GRp[2]^.BitMap)^.Planes[0];
	   PlanePick:= Bit(DP)-1;
	   PlaneOnOff:= 0;
	   NextImage:= Nil;
	  end;
	  UDat:= AllocMem(SizeOF(GPropExt),MEMF_CLEAR+MEMF_PUBLIC);
	  if UDat<>Nil then begin
	   With UDat^ do begin
	    GData.GType    := GT_SLD;
	    GData.Flags    := 0;
	    GData.Action   := Nil;
	    GFont:= PFont;
	    GData.ToolTip  := Prop^.ToolTip;
	    KnoW := wi;
	    KnoH := he;
	    MaxX := Prop^.HMax;
	    MaxY := Prop^.VMax;
	    MinX := Prop^.HMin;
	    MinY := Prop^.VMin;
	    CData:= Nil;
	    NRast:= GRp[1];
	    HRast:= GRp[2];
	   end;
	   With GProp^ do begin
	    LeftEdge:= x;
	    TopEdge := y;
	    Width    := wg;
	    Height:= hg;
	    Flags    := GADGHIMAGE+GADGIMAGE;
	    Activation:= RELVERIFY+GADGIMMEDIATE+FOLLOWMOUSE;
	    GadgetType:= PROPGADGET;
	    GadgetRender:= MIm[1];
	    SelectRender:= MIm[2];
	    GadgetText:= Nil;
	    MutualExclude:= 0;
	    SpecialInfo:= Pi;
	    GadgetID:= ID_SLD or Prop^.PropID;
	    UserData:= UDat;
	   end;
	   if AddGadget(Win,GProp,-1)=0 then;
	   RefreshGadgets(Gprop,Win,Nil);
	   InitGProp:= GProp;
	  end;
	  FreeMem(MIm[2],SizeOf(Image));
	 end;
	 FreeMem(MIm[1],SizeOf(Image));
	end;
	FreePenInfo(GRp[2]^.RP_User);
      end;
      FreeGRPort(GRp[2]);
     end;
     FreePenInfo(GRp[1]^.RP_User);
    end;
    FreeGRPort(GRp[1]);
   end;
   FreeMem(Pi,SizeOf(PropInfo));
  end;
  if PFont<>Nil then
   CloseFont(PFont);
  FreeMem(GProp,SizeOf(Gadget));
  end;
 end;
 InitGProp:= Nil;
end;

{Libera Knob}
Procedure FreeGProp(PP:GEProjectPtr;Win:WindowPtr; PGad:GadgetPtr);

Begin
 if (PP<>Nil)and(Win<>Nil)and(PGad<>Nil) then begin
  if PGad^.UserData<>Nil then
   if (GotchaDatPtr(PGad^.UserData)^.GType and GT_SLD)<>0 then begin
    if RemoveGadget(Win,PGad)=0 then;
    FreeMem(PGad^.GadgetRender,SizeOf(Image));
    FreeMem(PGad^.SelectRender,SizeOf(Image));
    FreePenInfo(GPropExtPtr(PGad^.UserData)^.NRast^.RP_User);
    FreePenInfo(GPropExtPtr(PGad^.UserData)^.HRast^.RP_User);
    FreeGRPort(GPropExtPtr(PGad^.UserData)^.NRast);
    FreeGRPort(GPropExtPtr(PGad^.UserData)^.HRast);
    if GPropExtPtr(PGad^.UserData)^.GFont<>Nil then
        CloseFont(GPropExtPtr(PGad^.UserData)^.GFont);
    FreeMem(PGad^.UserData,SizeOF(GPropExt));
   end;
  if PGad^.SpecialInfo<>Nil then
    FreeMem(PGad^.SpecialInfo,SizeOf(PropInfo));
  FreeMem(PGad,SizeOf(Gadget));
 end;
end;


Function StartGEngine:Boolean;

Begin
 With Defaults do begin
  IntBas:= IntuitionBasePtr(OpenLibrary("intuition.library",34));
  if IntBas<> Nil then Begin
   ExeBas:= ExecBasePtr(OpenLibrary("exec.library",0));
   if ExeBas<>Nil then begin
	GfxBase:= OpenLibrary("graphics.library",0);
	if GfxBase<>Nil then begin
	 GEngineBase:= GEBasePtr(OpenLibrary("gengine.library",0));
	 if GEngineBase<>Nil then begin
		ShiCol:= Pen1;
		HShCol:= Pen2;
		TxtCol:= Pen3;
		BckCol:= Pen4;
		DrkCol:= Pen5;
		HDkCol:= Pen6;
		HGhCol:= Pen7;
		SltCol:= Pen8;
		StartGEngine:= true;
	 end;
         CloseLibrary(GfxBase);
	end;
	CloseLibrary(LibraryPtr(ExeBas));
   end;
  end;
  CloseLibrary(LibraryPtr(IntBas));
 end;
 StartGEngine:= false;
end;

Procedure StopGEngine;

Begin
 With Defaults do begin
  if IntBas<>Nil then
	CloseLibrary(LibraryPtr(IntBas));
  if ExeBas<>Nil then
	CloseLibrary(LibraryPtr(ExeBas));
 end;
 if GfxBase<>Nil then
	CloseLibrary(GfxBase);
 if GEngineBase<>Nil then
	CloseLibrary(LibraryPtr(GEngineBase));
end;


Function GEOpenWindow(PP:GEProjectPtr; WTitle:String; W,H,Place:Short; WFlags:Integer):WindowPtr;

Var
 NW: NewWindowPtr;
 This,Prev,New: WindowPtr;

Begin
 if PP<>Nil then begin
  NW:= AllocMem(SizeOf(NewWindow),MEMF_CLEAR+MEMF_PUBLIC);
  if NW<>Nil then begin
   With NW^ do begin
	Width:= W;
	Height:= H;
	Case Place of
		PL_TL: Begin
			TopEdge:= 0;
			LeftEdge:= 0;
		       end;
		PL_TR: Begin
			TopEdge:= 0;
			LeftEdge:= PP^.PScreen^.Width-Width;
		       end;
		PL_BL: Begin
			TopEdge:= PP^.PScreen^.Height-Height;
			LeftEdge:= 0;
		       end;
		PL_BR: Begin
			TopEdge:= PP^.PScreen^.Height-Height;
			LeftEdge:= PP^.PScreen^.Width-Width;
		       end;
		PL_CC: Begin
			TopEdge:= (PP^.PScreen^.Height div 2)-(Height div 2);
			LeftEdge:= (PP^.PScreen^.Width div 2)-(Width div 2);
		       end;
	end;
	DetailPen:= PP^.BckPen;
	BlockPen:= PP^.TxtPen;
	Flags:= WFlags;
	FirstGadget:= Nil;
	CheckMark:= Nil;
	Title:= AllocString(81);
	StrCpy(Title,WTitle);
	MinWidth:= 0; MinHeight:= 0;
	MaxWidth:= PP^.PScreen^.Width; MaxHeight:= PP^.PScreen^.Height;
	BitMap:= nil;
	IDCMPFlags:= GADGETUP_f+GADGETDOWN_f+MOUSEMOVE_f+MOUSEBUTTONS_f+INTUITICKS_f+
			CLOSEWINDOW_f+RAWKEY_f+MENUPICK_f+NEWSIZE_f+ACTIVEWINDOW_f+
			INACTIVEWINDOW_f;
	if PP^.PFlags=0 then begin
		Screen:= Nil;
		WType:= WBENCHSCREEN_f;
 	end else begin
		Screen:= PP^.PScreen;
		WType:= CUSTOMSCREEN_f;
	end;
   end;
   New:= OpenWindow(NW);
   if New<>Nil then begin
	New^.UserData:= nil;
	if PP^.PWindow<>Nil then begin
	 Prev:= PP^.PWindow;
	 While Prev^.UserData<>Nil do begin
		This:= Prev^.UserData;
		Prev:= This;
	 end;
	 Prev^.UserData:= New; {Agrego a la lista de ventanas del projecto}
	end else
		PP^.PWindow:= New;
	FreeMem(NW,SizeOf(NewWindow));
	GEOpenWindow:= New;
   end;
   FreeString(NW^.Title);
   FreeMem(NW,SizeOF(NewWindow));
  end;
 end;
 GEOpenWindow:= Nil;
end;

{Cierra Ventana}
Procedure GECloseWindow(PP:GEProjectPtr;W:WindowPtr);

Var
T,L : WindowPtr;

Begin
 if (PP<>Nil) and (W<>Nil) then begin
  L:= PP^.PWindow;
  if L<>W then begin
   T:= L^.UserData;
   While T<>W do begin
	T:= L^.UserData;
	L:= T;
   end;
   T^.UserData:= W^.UserData {Quit from window list}
  end else
   PP^.PWindow:= W^.UserData;
  FreeString(W^.Title);
  CloseWindow(W);
 end;
end;


Function CreateProject(NP: NewProjectPtr): GEProjectPtr;

Var
 GEP : GEProjectPtr;
 i   : Integer;
 NS  : NewScreenPtr;
 Vp  : ViewPortPtr;
 CAux: Triplet;
 TW  : WindowPtr;

Const
 Dummy: NewWindow = (0,0,20,20,0,0,0,BORDERLESS,Nil,Nil,Nil,Nil,Nil,
			-1,-1,-1,-1,WBENCHSCREEN_f);

Begin
 if NP<>Nil then begin
  GEP:= AllocMem(SizeOF(GEProject),MEMF_PUBLIC+MEMF_CLEAR);
  if GEP<>Nil then begin
   GEP^.PFlags:= NP^.Flags;
   GEP^.PWindow:= Nil;
   GEP^.PName:= AllocString(81);
   StrCpy(GEP^.PName,NP^.Name);
   if (NP^.Flags and P_CSCR)<>0 then begin
    NS:= AllocMem(SizeOf(NewScreen),MEMF_PUBLIC+MEMF_CLEAR);
    if NS<>Nil then begin
     With NS^ do begin
	LeftEdge:= 0;
	TopEdge	:= 0;
	Width	:= NP^.SWidth;
	Height	:= NP^.SHeight;
	Depth	:= NP^.SDepth;
	DetailPen:= 1;
	BlockPen:= 0;
	ViewModes:=  NP^.SMode;
	DefaultTitle:= GEP^.PName;
	SType	:= CUSTOMSCREEN_f;
	Font	:= Defaults.WFont;
	Gadgets	:= Nil;
	CustomBitMap:= Nil;
     end;
     GEP^.PScreen:= OpenScreen(NS);
     if GEP^.PScreen<>Nil then begin
      Vp:= @GEP^.PScreen^.SViewPort;
      if (NP^.Flags and P_CCOL)<>0 then begin
	LoadRGB4(Vp,NP^.Ccolors,NP^.CCount);
	With GEP^ do begin
	 CAux:= Defaults.ShiCol;
	 ShiPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.HShCol;
	 HShPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.TxtCol;
	 TxtPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.DrkCol;
	 DrkPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.HDkCol;
	 HDkPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.HGhCol;
	 HGhPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.SltCol;
	 SltPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	 CAux:= Defaults.BckCol;
	 if GetFreePen(Vp)=0 then
		SetRGB4(Vp,0,CAux[1],CAux[2],CAux[3]);
	 BckPen:= 0;
	end;
      end else begin
	CAux:= Defaults.ShiCol;
	SetRGB4(Vp,2,CAux[1],CAux[2],CAux[3]);
	GEP^.ShiPen:=2;
	CAux:= Defaults.HShCol;
	SetRGB4(Vp,5,CAux[1],CAux[2],CAux[3]);
	GEP^.HShPen:=5;
	CAux:= Defaults.TxtCol;
	SetRGB4(Vp,1,CAux[1],CAux[2],CAux[3]);
	gep^.TxtPen:=1;
	CAux:= Defaults.BckCol;
	SetRGB4(Vp,0,CAux[1],CAux[2],CAux[3]);
	gep^.BckPen:=0;
	CAux:= Defaults.DrkCol;
	SetRGB4(Vp,4,CAux[1],CAux[2],CAux[3]);
	gep^.DrkPen:=4;
	CAux:= Defaults.HDkCol;
	SetRGB4(Vp,6,CAux[1],CAux[2],CAux[3]);
	gep^.HDkPen:=6;
	CAux:= Defaults.HGhCol;
	SetRGB4(Vp,7,CAux[1],CAux[2],CAux[3]);
	gep^.HGhPen:=7;
	CAux:= Defaults.SltCol;
	SetRGB4(Vp,3,CAux[1],CAux[2],CAux[3]);
	gep^.SltPen:=3;
      end;
      FreeMem(NS,SizeOf(NewScreen));
      CreateProject:= gep;
     end;
     FreeMem(NS,SizeOf(NewScreen));
    end;
    CreateProject:= Nil;
   end else begin
	TW:= OpenWindow(@Dummy);
	if TW<>Nil then begin
	 Vp:= ViewPortAddress(TW);
	 gep^.PScreen:= TW^.WScreen;
	 CloseWindow(TW);
	 With gep^ do begin
	  CAux:= Defaults.ShiCol;
	  ShiPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  CAux:= Defaults.HShCol;
	  HShPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  CAux:= Defaults.TxtCol;
	  TxtPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  CAux:= Defaults.DrkCol;
	  DrkPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  CAux:= Defaults.HDkCol;
	  HDkPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  CAux:= Defaults.HghCol;
	  HghPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  CAux:= Defaults.SltCol;
	  SltPen:= GetBestPen(Vp,CAux[1],CAux[2],CAux[3]);
	  BckPen:= 0;
	 end;
	 CreateProject:= gep;
	end;
   end;
   FreeString(gep^.PName);
   FreeMem(gep,SizeOf(GEProject));
  end;
 end;
 CreateProject:= Nil;
end;

{Elimina projecto}

Procedure KillProject(PP:GEProjectPtr);

Begin
 if PP<>Nil then begin
  if PP^.PFlags<>0 then begin
   while PP^.PWindow<>Nil do
	GECloseWindow(PP,PP^.PWindow);
   CloseScreen(PP^.PScreen);
  end;
  FreeString(PP^.PName);
  FreeMem(PP,SizeOf(GEProject));
 end;
end;

{Catch intuimessages}

Function Gotcha(PP:GEProjectPtr; W:WindowPtr; IM: IntuiMessagePtr):GEMessPtr;

Var
 GEM: GEMessPtr;
 PI : PropInfoPtr;
 St : StringInfoPtr;
 AStr: String;
 PX : GPropExtPtr;
 i,x: Integer;
 Play : GadgetPtr;

Begin
 if (PP<>Nil)and(W<>Nil)and(IM<>Nil) then begin
  GEM:= AllocMem(SizeOf(GEMess),MEMF_CLEAR+MEMF_PUBLIC);
  if GEM<>Nil then begin
   with IM^ do begin
    case class of
	GADGETDOWN_f: case (GadgetPtr(IAddress)^.GadgetID)and $F000 of
		ID_SLD : Begin
			Play:= GadgetPtr(IAddress);
			PX:= GPropExtPtr(Play^.UserData);
			GEM^.GType:= GT_SLD;
			GEM^.GID:= Play^.GadgetID and $0FFF;
			GEM^.GAct:= GA_ACTIVE;
			PI:= PropInfoPtr(Play^.SpecialInfo);
			if (PI^.Flags and FREEHORIZ)<>0 then
			 GEM^.GVal:= PX^.MinX+((PI^.HorizPot and $FFFF)div PI^.HorizBody)
			else
			 GEM^.GVal:= PX^.MinY+(PI^.VertPot and $FFFF)div PI^.VertBody;
			PP^.LValue:= GEM^.GVal;
			PP^.PPlay:= Play;
			Gotcha:= GEM;
		end;
	end;
	GADGETUP_f: case (GadgetPtr(IAddress)^.GadgetID)and $F000 of
		ID_SLD : Begin
			Play:= PP^.PPlay;
			PX:= GPropExtPtr(Play^.UserData);
			GEM^.GType:= GT_SLD;
			GEM^.GID:= Play^.GadgetID and $0FFF;
			GEM^.GAct:= GA_INACT;
			PI:= PropInfoPtr(Play^.SpecialInfo);
			if (PI^.Flags and FREEHORIZ)<>0 then
			 GEM^.GVal:= PX^.MinX+(PI^.HorizPot and $FFFF)div PI^.HorizBody
			else
			 GEM^.GVal:= PX^.MinY+(PI^.VertPot and $FFFF)div PI^.VertBody;
			if PX^.GFont<>Nil then begin
			 AStr:= AllocString(10);
			 i:= GEM^.GVal;
			 if IntToStr(AStr,i)=0 then;
			 x:= TextLength(PX^.NRast,AStr,StrLen(AStr));
			 SetAPen(PX^.NRast,0);
			 RectFill(PX^.NRast,1,1,PX^.KnoW-2,PX^.KnoH-2);
			 SetAPen(PX^.NRast,PP^.TxtPen);
			 Move(PX^.NRast,(PX^.KnoW/2)-(x/2),(PX^.KnoH/2)+(PX^.GFont^.tf_YSize/2)-2);
			 GText(PX^.NRast,AStr,StrLen(AStr));
			 SetAPen(PX^.HRast,0);
			 RectFill(PX^.HRast,1,1,PX^.KnoW-2,PX^.KnoH-2);
			 SetAPen(PX^.HRast,PP^.TxtPen);
			 Move(PX^.HRast,(PX^.KnoW/2)-(x/2),(PX^.KnoH/2)+(PX^.GFont^.tf_YSize/2)-2);
			 GText(PX^.HRast,AStr,StrLen(AStr));
			 RefreshGList(Play,W,Nil,1);
			 FreeString(AStr);
			end;
			Play:= Nil;
			Gotcha:= GEM;
		end;
	end;
	MOUSEMOVE_f: if PP^.PPlay<>Nil then
		Case (PP^.PPlay^.GadgetID)and $F000 of
		 ID_SLD : Begin
			Play:= PP^.PPlay;
			PX:= GPropExtPtr(Play^.UserData);
			GEM^.GType:= GT_SLD;
			GEM^.GID:= Play^.GadgetID and $0FFF;
			GEM^.GAct:= GA_PLAY;
			PI:= PropInfoPtr(Play^.SpecialInfo);
			if (PI^.Flags and FREEHORIZ)<>0 then
			 GEM^.GVal:= PX^.MinX+(PI^.HorizPot and $FFFF)div PI^.HorizBody
			else
			 GEM^.GVal:= PX^.MinY+(PI^.VertPot and $FFFF)div PI^.VertBody;
			if (PP^.LValue<>GEM^.GVal)and(PX^.GFont<>Nil) then begin
			 AStr:= AllocString(10);
			 i:= GEM^.GVal;
			 if IntToStr(AStr,i)=0 then;
			 x:= TextLength(PX^.HRast,AStr,StrLen(AStr));
			 SetAPen(PX^.HRast,0);
			 RectFill(PX^.HRast,1,1,PX^.KnoW-2,PX^.KnoH-2);
			 SetAPen(PX^.HRast,PP^.TxtPen);
			 Move(PX^.HRast,(PX^.KnoW/2)-(x/2),(PX^.KnoH/2)+(PX^.GFont^.tf_YSize/2)-2);
			 GText(PX^.HRast,AStr,StrLen(AStr));
			 SetAPen(PX^.NRast,0);
			 RectFill(PX^.NRast,1,1,PX^.KnoW-2,PX^.KnoH-2);
			 SetAPen(PX^.NRast,PP^.TxtPen);
			 Move(PX^.NRast,(PX^.KnoW/2)-(x/2),(PX^.KnoH/2)+(PX^.GFont^.tf_YSize/2)-2);
			 GText(PX^.NRast,AStr,StrLen(AStr));
			 RefreshGList(Play,W,Nil,1);
			 FreeString(AStr);
			end;
			PP^.LValue:= GEM^.GVal;
			Gotcha:= GEM;
		 end;
		end;
    end;
   end;
   FreeMem(GEM,SizeOf(GEMess));
  end;
 end;
 Gotcha:= Nil;
end;


Procedure GEReply(GM: GEMessPtr);

Begin
 if GM<>Nil then
  FreeMem(GM,SizeOF(GEMess));
end;


{--StuffObject--}

{Function StuffObject(Action:Integer; SGUI,SObject,TagList:Address):Address;

Var
 Object, NewObject: Address;
 TList : ^Array [0..0] of Integer;
 SX,SY,SJ,SI : Short;
 X,Y,J,I : Integer;

Begin
 TList:= TagList;
 if (TList<>Nil) and (TList^[0]<CT_Start) then begin
  Case Action of}
   {Add Object}
{   GEM_Add : Case TList^[0] of
}    {Window}
 {   GE_WinObj : if (SGUI<>Nil) and (SObject<>Nil) then begin
	NewObject:= AllocMem(SizeOf(NewWindow),MEMF_CLEAR+MEMF_PUBLIC);
	if NewObject<>Nil then begin
	 With NewWindow(NewObject^) do begin
}	  {Constant fields}
{	  FirstGadget:= Nil;
	  CheckMark:= Nil;
	  MinWidth:= 0; MinHeight:= 0;
	  BitMap:= Nil;
}	  {Configurable fields}
{	  Width := GEGetTagData(Wi_Width,100,TList);
	  Height:= GEGetTagData(Wi_Height,100,TList);
	  if GETagInArray(Wi_Position,TList) then
	   Case GEGetTagData(Wi_Position,Pos_Center,TList) of
	    Pos_TL: Begin
	     TopEdge:= 0;
	     LeftEdge:= 0;
	    end;
	   end;
	 end;
	end;
    end;
 }   {Slider}
 {   GE_SldGad : y:=y;
   end;
  end;
 end;
 StuffObject:= Nil;
end;}