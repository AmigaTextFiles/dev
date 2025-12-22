
{ *** vector.i  -  Include für PCQ1.2b ,  zur Nutzung der vector.library  *** }

{$I "include:intuition/screens.i"}
{$I "include:graphics/view.i"}
{$I "include:graphics/rastport.i"}


CONST VBOB  = -1;
      VLIN  =  0;
      END_1 = -1;
      END_2 = -2;
      LAB   = -3;
      DBF   = -4;

TYPE

  NewVScreen = Record
    LeftEdge, TopEdge,
    Width, Height, Depth :  Short;
    DetailPen, BlockPen  :  Byte;
    ViewModes            :  Short;
    Font                 :  ^TextAttr;
    DefaultTitle         :  String;
    vw_Flags             :  Short;
    vw_LeftEdge,
    vw_TopEdge, vw_Width,
    vw_Height, vw_Depth  :  Short;
  end;

  NewVScreenPtr          =  ^NewVScreen;


  Joy = Record
    Mov_Z,
    Border_Front,
    Border_Back         :       Short;
    Rot_X,
    Rot_Y,
    Rot_z               :       Short;
  end;

  JoyPtr        = ^Joy;


  vd_Object = Record
    Point_Data,
    Area_Data,
    Move_Table          :       Address;
    Flags,
    Pos_X,
    Pos_y,
    Pos_z               :       Short;
    Rot_X,
    Rot_y,
    Rot_z               :       Short;
  end;

  vd_ObjectPtr     = ^vd_Object;

TYPE


  ViewStruct = Record
    VScreen             :  ^Screen;
    VViewPort           :  ^ViewPort;
    VRastPort           :  ^RastPort;
  end;

  ViewStructPtr         = ^ViewStruct;

  World = Record
    Flags               : Short;        { 1 für Drahtgitter }
    ObjNum              : Short;        { Anzahl der Objekte }
    first               : vd_ObjectPtr;
  end;

  WorldPtr      = ^World;


  BOB = Record
    Width, Height       :  Short;
    GFX_Data,
    Msk_Data            :  String;
  end;

  BOBPtr        = ^BOB;


  BOBList = Record
    Number              :  Short;
    BOBs                :  BOB;         { ? }
  end;

  BOBListPtr    = ^BOBList;

  Rot3D = Record
    RotX,
    RotY,
    RotZ        : Integer;
  end;
  Rot3DPtr      = ^Rot3D;


VAR  VecBase: Address;


Function SetVBI(a1 : string) : Integer;
  External;

Function InitVBOBs(d0: Integer; a0: string; a1: BOBListPtr; a2: String) : Integer;
  External;

Function OpenVScreen(a1: NewVScreenPtr): ViewStructPtr;
  External;

Function CloseVScreen : Integer;
  External;

Function UseJoy(d0: Integer; a1: JoyPtr):Integer;
  External;

Function DoAnim(a1: WorldPtr):Integer;
  External;

Function RotateX(d0,d1,d2,d3,d4,d5,d6: Integer; a1: Rot3DPtr) : Rot3DPtr;
  External;

Function RotateY(d0,d1,d2,d3,d4,d5,d6: Integer; a1: Rot3DPtr) : Rot3DPtr;
  External;

Function RotateZ(d0,d1,d2,d3,d4,d5,d6: Integer; a1: Rot3DPtr) : Rot3DPtr;
  External;

Function FreeVBOBs : Integer;
  External;

Function AutoScaleOn(d0: Integer) : Integer;
  External;

Function AutoScaleOff : Integer;
  External;

Function FreeJoy : Integer;
  External;

Function SetColors(a0: ViewStructPtr; a1: Address):Integer;
  External;

