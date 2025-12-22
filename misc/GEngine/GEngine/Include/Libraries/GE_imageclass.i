{--- GE_ImageClass ---}

{-------------------------}
{- Started on 28-11-2001 -}
{-------------------------}

{$I   "Include:Libraries/GE_TagItem.i"}
{$I   "Include:Utils/GE_Hooks.i"}
{$I   "Include:Intuition/IntuitionBase.i"}
{$I   "Include:Intuition/Intuition.i"}
{$I   "Include:Graphics/RastPort.i"}
{$I   "Include:Libraries/GE_classes.i"}

CONST
 CUSTOMIMAGEDEPTH     =   (-1);
{ if image.Depth is this, it's a new Image class object }

{****************************************************}
CONST
 GIA_Dummy             =   (TAG_USER + $20000);
 GIA_Left              =   (GIA_Dummy + $01);
 GIA_Top               =   (GIA_Dummy + $02);
 GIA_Width             =   (GIA_Dummy + $03);
 GIA_Height            =   (GIA_Dummy + $04);
 GIA_FGPen             =   (GIA_Dummy + $05);
                    { GIA_FGPen also means "PlanePick"  }
 GIA_BGPen             =   (GIA_Dummy + $06);
                    { GIA_BGPen also means "PlaneOnOff" }
 GIA_Data              =   (GIA_Dummy + $07);
                    { bitplanes, for classic image,
                     * other image classes may use it for other things
                     }
 GIA_LineWidth         =   (GIA_Dummy + $08);
 GIA_Pens              =   (GIA_Dummy + $0E);
                    { pointer to UWORD pens[],
                     * ala PenInfo.Pens, MUST be
                     * terminated by ~0.  Some classes can
                     * choose to have this, or SYSGIA_DrawInfo,
                     * or both.
                     }
 GIA_Resolution        =   (GIA_Dummy + $0F);
                    { packed uwords for x/y resolution into a longword
                     * ala DrawInfo.Resolution
                     }

{*** see class documentation to learn which    ****}
{*** classes recognize these                   ****}
 GIA_APattern           =  (GIA_Dummy + $10);
 GIA_APatSize           =  (GIA_Dummy + $11);
 GIA_Mode               =  (GIA_Dummy + $12);
 GIA_Font               =  (GIA_Dummy + $13);
 GIA_Outline            =  (GIA_Dummy + $14);
 GIA_Recessed           =  (GIA_Dummy + $15);
 GIA_DoubleEmboss       =  (GIA_Dummy + $16);
 GIA_EdgesOnly          =  (GIA_Dummy + $17);

 GIA_ShadowPen          =  (GIA_Dummy + $09);
 GIA_HighlightPen       =  (GIA_Dummy + $0A);

{ New for V39: }
 SYSIA_ReferenceFont   =  (GIA_Dummy + $19);
                    { Font to use as reference for scaling
                     * certain sysiclass images
                     }
 GIA_SupportsDisable    =  (GIA_Dummy + $1a);
                    { By default, Intuition ghosts gadgets itself,
                     * instead of relying on IDS_DISABLED or
                     * IDS_SELECTEDDISABLED.  An imageclass that
                     * supports these states should return this attribute
                     * as TRUE.  You cannot set or clear this attribute,
                     * however.
                     }

 GIA_FrameType          =  (GIA_Dummy + $1b);
                    { Starting with V39, FrameIClass recognizes
                     * several standard types of frame.  Use one
                     * of the FRAME_ specifiers below.  Defaults
                     * to FRAME_DEFAULT.
                     }

{* next attribute: (GIA_Dummy + $1c)   *}

{***********************************************}

{ image message id's   }
    GIM_DRAW     = $202;  { draw yourself, with "state"          }
    GIM_HITTEST  = $203;  { return TRUE IF click hits image      }
    GIM_ERASE    = $204;  { erase yourself                       }
    GIM_MOVE     = $205;  { draw new AND erase old, smoothly     }

    GIM_DRAWFRAME= $206;  { draw with specified dimensions       }
    GIM_FRAMEBOX = $207;  { get recommended frame around some box}
    GIM_HITFRAME = $208;  { hittest with dimensions              }
    GIM_ERASEFRAME= $209; { hittest with dimensions              }

{ image draw states or styles, for IM_DRAW }
    GIDS_NORMAL          = (0);
    GIDS_SELECTED        = (1);    { for selected gadgets     }
    GIDS_DISABLED        = (2);    { for disabled gadgets     }
    GIDS_BUSY            = (3);    { for future functionality }
    GIDS_INDETERMINATE   = (4);    { for future functionality }
    GIDS_INACTIVENORMAL  = (5);    { normal, in inactive window border }
    GIDS_INACTIVESELECTED= (6);    { selected, in inactive border }
    GIDS_INACTIVEDISABLED= (7);    { disabled, in inactive border }

{ oops, please forgive spelling error by jimm }
 GIDS_INDETERMINANT = GIDS_INDETERMINATE;

{ GIM_FRAMEBOX  }
Type
  GE_impFrameBox = Record
    MethodID   : Integer;
    gimp_ContentsBox  : IBoxPtr;       { input: relative box of contents }
    gimp_FrameBox     : IBoxPtr;          { output: rel. box of encl frame  }
    gimp_PInfo        : PenInfoPtr;
    gimp_FrameFlags   : Integer;
  END;
  GE_impFrameBoxPtr = ^GE_impFrameBox;

CONST
 FRAMEF_SPECIFY = (1);  { Make do with the dimensions of FrameBox
                                 * provided.
                                 }

{ GIM_DRAW, GIM_DRAWFRAME        }
Type
   GE_imp_Offset_Struct = Record
    x,y : Short;
   END;

   GE_imp_Dimensions_Struct = Record
    Width, Height : Short;
   END;

   GE_impDraw = Record
    MethodID    : Integer;
    gimp_RPort   : RastPortPtr;
    gimp_Offset  : GE_imp_Offset_Struct;
    gimp_State   : Integer;
    gimp_DrInfo  : PenInfoPtr;

    { these parameters only valid for GIM_DRAWFRAME }
    gimp_Dimensions : GE_imp_Dimensions_Struct;
   END;
   GE_impDrawPtr = ^GE_impDraw;

{ IM_ERASE, IM_ERASEFRAME      }
{ NOTE: This is a subset of GE_impDraw    }
   GE_impErase = Record
    MethodID       : Integer;
    gimp_RPort      : RastPortPtr;
    gimp_Offset     : GE_imp_Offset_Struct;

    { these parameters only valid for GIM_ERASEFRAME }
    gimp_Dimensions : GE_imp_Dimensions_Struct;
   END;
   GE_impErasePtr = ^GE_impErase;

{ GIM_HITTEST, GIM_HITFRAME      }
   GE_imp_Point_Struct = Record
    x,y : Short;
   END;

   GE_impHitTest = Record
    MethodID   : Integer;
    gimp_Point  : GE_imp_Point_Struct;

    { these parameters only valid for IM_HITFRAME }
    gimp_Dimensions : GE_imp_Dimensions_Struct;
   END;
   GE_impHitTestPtr = ^GE_impHitTest;

Var
 IClass: GEClassPtr;

Function _GEImageHook(class:GEClassPtr; Object,Msg:Address):Integer;

Var
 MM: ^Array[0..0]of integer;
 TMem: _GObjectPtr;
 TIm: ImagePtr;
 TMs1,TMs2: TagItemPtr;
 i: Integer;
 td: GE_impDrawPtr;
 te: GE_impErasePtr;
 tg: gpGetPtr;
 ip: ^Integer;

Begin
 if (Object<>Nil)and(Msg<>Nil)then begin
  MM:= Msg;
  Case MM^[0] of
   GM_NEW : Begin {Create new object }
     TMem:= _GObjectPtr(DoSuperMethodA(class,Object,Msg));
     if TMem<>Nil then begin
      TIm:= ImagePtr(INST_DATA(class,TMem));
      With TIm^ do begin
       LeftEdge:= GE_GetTagData(GIA_Left,0,TagItemPtr(MM^[1]));
       TopEdge:= GE_GetTagData(GIA_Top,0,TagItemPtr(MM^[1]));
       Width:= GE_GetTagData(GIA_Width,16,TagItemPtr(MM^[1]));
       Height:= GE_GetTagData(GIA_Height,1,TagItemPtr(MM^[1]));
       Depth:= CUSTOMIMAGEDEPTH;
       ImageData:= Address(GE_GetTagData(GIA_Data,0,TagItemPtr(MM^[1])));
       PlanePick:= GE_GetTagData(GIA_FGPen,0,TagItemPtr(MM^[1]));
       PlaneOnOff:= GE_GetTagData(GIA_BGPen,0,TagItemPtr(MM^[1]));
       NextImage:= Nil;
      end;
     end;
     _GEImageHook:= Integer(TMem);
   end;
   GM_SET : Begin {Set attributtes}
     Tim:= ImagePtr(INST_DATA(class,object));
     TMs1:= gpSetPtr(MM)^.gps_AttrList;
     TMs2:= TMs1;
     TMs1:= GE_NextTagItem(TMs2);
     While TMs1<>Nil do begin
      i:= TMs1^.ti_Data;
      Case TMs1^.ti_Tag of
        GIA_Left: Tim^.LeftEdge:= i;
        GIA_Top: Tim^.TopEdge:= i;
        GIA_Width: Tim^.Width:= i;
        GIA_Height: Tim^.Height:= i;
        GIA_Data: Tim^.ImageData:= Address(i);
        GIA_FGPen: Tim^.PlanePick:= i;
        GIA_BGPen: Tim^.PlaneOnOff:= i;
      end;
      TMs1:= GE_NextTagItem(TMs2);
     end;
     _GEImageHook:= 1;
   end;
   GM_GET : Begin
     Tim:= ImagePtr(INST_DATA(class,object));
     tg:= gpGetPtr(Msg);
     ip:= tg^.gpg_Storage;
     i:= -1;
     Case tg^.gpg_AttrID of
       GIA_Left: ip^:= Tim^.LeftEdge;
       GIA_Top: ip^:= Tim^.TopEdge;
       GIA_Width: ip^:= Tim^.Width;
       GIA_Height: ip^:= Tim^.Height;
       GIA_Data: ip^:= Integer(Tim^.ImageData);
       GIA_FGPen: ip^:= Tim^.PlanePick;
       GIA_BGPen: ip^:= Tim^.PlaneOnOff;
       else
          i:= 0;
     end;
     _GEImageHook:= i;
   end;
   GIM_DRAW : Begin
     Tim:= ImagePtr(INST_DATA(class,object));
     td:= Msg;
     With td^ do begin
      if gimp_State = GIDS_NORMAL then begin
       DrawImage(gimp_RPort,Tim,gimp_offset.x,gimp_offset.y);
       {-test only-}
       {SetAPen(gimp_RPort,2);
       SetDrMd(gimp_RPort,JAM2);
       RectFill(gimp_RPort,Tim^.LeftEdge+gimp_offset.x,Tim^.TopEdge+gimp_offset.y,
        Tim^.LeftEdge+gimp_offset.x+Tim^.Width,Tim^.TopEdge+gimp_offset.y+Tim^.Height);}
      end;
     end;
     _GEImageHook:= 1;
   end;
   GIM_ERASE,GIM_ERASEFRAME : Begin
     Tim:= ImagePtr(INST_DATA(class,object));
     te:= Msg;
     With te^ do begin
      i:= gimp_RPort^.FgPen; {save APen}
      SetAPen(gimp_RPort,0);
      RectFill(gimp_RPort,gimp_offset.x+Tim^.LeftEdge,gimp_offset.y+Tim^.TopEdge,
               gimp_offset.x+Tim^.LeftEdge+Tim^.Width,gimp_offset.y+Tim^.TopEdge+Tim^.Height);
      SetAPen(gimp_RPort,i);
     end;
     _GEImageHook:= 0;
   end;
   GIM_DRAWFRAME : Begin
     td:= Msg;
     td^.MethodID:= GIM_DRAW;
     i:= DoMethodA(Object,Msg);
     td^.MethodID:= GIM_DRAWFRAME;
     _GEImageHook:= i;
   end;
   else _GEImageHook:= DoSuperMethodA(class,Object,Msg);
  end; {case}
 end;
 _GEImageHook:= 0;
end;
