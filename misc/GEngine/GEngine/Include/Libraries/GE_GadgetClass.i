{ GE_GadgetClass.i }

{$I   "Include:Intuition/Intuition.i"}
{$I   "Include:Libraries/GEngine.i"}
{$I   "Include:Libraries/GE_TagItem.i"}
{$I   "Include:Libraries/GE_classes.i"}

Type
    GE_Gadget = Record
          ggadget : gadget;  {the standart gadget struct}
          gstate  : short;
          gxflags : short;   {like XFLG_LABELSTRING or XFLG_LABELIMAGE}
          glabel  : address; {Points to supplied Image struct if XFLG_LABELIMAGE,
                              null otherwise}
          gtarget : address;
          gmap    : address;
          gpinfo  : PenInfoPtr;
          gwindow : WindowPtr; {window the gadget is attached on}
    end;

    GE_GadgetPtr = ^GE_Gadget;


CONST
 XFLG_LABELSTRING = $1000;
 XFLG_LABELIMAGE  = $2000;

{ Gadget Class attributes      }
    GGA_Dummy           =  (TAG_USER +$30000);
    GGA_Left            =  (GGA_Dummy + $0001);
    GGA_RelRight        =  (GGA_Dummy + $0002);
    GGA_Top             =  (GGA_Dummy + $0003);
    GGA_RelBottom       =  (GGA_Dummy + $0004);
    GGA_Width           =  (GGA_Dummy + $0005);
    GGA_RelWidth        =  (GGA_Dummy + $0006);
    GGA_Height          =  (GGA_Dummy + $0007);
    GGA_RelHeight       =  (GGA_Dummy + $0008);
    GGA_Text            =  (GGA_Dummy + $0009); { ti_Data is (UBYTE *) }
    GGA_Image           =  (GGA_Dummy + $000A);
    GGA_Border          =  (GGA_Dummy + $000B);
    GGA_SelectRender    =  (GGA_Dummy + $000C);
    GGA_Highlight       =  (GGA_Dummy + $000D);
    GGA_Disabled        =  (GGA_Dummy + $000E);
    GGA_GZZGadget       =  (GGA_Dummy + $000F);
    GGA_ID              =  (GGA_Dummy + $0010);
    GGA_UserData        =  (GGA_Dummy + $0011);
    GGA_SpecialInfo     =  (GGA_Dummy + $0012);
    GGA_Selected        =  (GGA_Dummy + $0013);
    GGA_EndGadget       =  (GGA_Dummy + $0014);
    GGA_Immediate       =  (GGA_Dummy + $0015);
    GGA_RelVerify       =  (GGA_Dummy + $0016);
    GGA_FollowMouse     =  (GGA_Dummy + $0017);
    GGA_RightBorder     =  (GGA_Dummy + $0018);
    GGA_LeftBorder      =  (GGA_Dummy + $0019);
    GGA_TopBorder       =  (GGA_Dummy + $001A);
    GGA_BottomBorder    =  (GGA_Dummy + $001B);
    GGA_ToggleSelect    =  (GGA_Dummy + $001C);

    { internal use only, until further notice, please }
    GGA_SysGadget       =  (GGA_Dummy + $001D);
        { bool, sets GTYP_SYSGADGET field in type      }
    GGA_SysGType        =  (GGA_Dummy + $001E);
        { e.g., GTYP_WUPFRONT, ...     }

    GGA_Previous        =  (GGA_Dummy + $001F);
        { previous gadget (or (struct Gadget **)) in linked list
         * NOTE: This attribute CANNOT be used to link new gadgets
         * into the gadget list of an open window or requester.
         * You must use AddGList().
         }

    GGA_Next            =  (GGA_Dummy + $0020);
         { not implemented }

    GGA_PenInfo        =  (GGA_Dummy + $0021);
        { some fancy gadgets need to see a PenInfo
         * when created or for layout
         }

{ You should use at most ONE of GGA_Text, GGA_IntuiText, and GGA_LabelImage }
 GGA_IntuiText          =  (GGA_Dummy + $0022);
        { ti_Data is (struct IntuiText *) }

 GGA_LabelImage         =  (GGA_Dummy + $0023);
        { ti_Data is an image (object), used in place of
         * GadgetText
         }

 GGA_TabCycle           =  (GGA_Dummy + $0024);
        { New for V37:
         * Boolean indicates that this gadget is to participate in
         * cycling activation with Tab or Shift-Tab.
         }

 GGA_GadgetHelp         =  (GGA_Dummy + $0025);
        { New for V39:
         * Boolean indicates that this gadget sends gadget-help
         }

 GGA_Bounds             =  (GGA_Dummy + $0026);
        { New for V39:
         * ti_Data is a pointer to an IBox structure which is
         * to be copied into the extended gadget's bounds.
         }

 GGA_RelSpecial         =  (GGA_Dummy + $0027);
        { New for V39:
         * Boolean indicates that this gadget has the "special relativity"
         * property, which is useful for certain fancy relativity
         * operations through the GGM_LAYOUT method.
         }

{ PROPGCLASS attributes }

 GPA_Dummy      = (TAG_USER + $31000);
 GPA_Freedom    = (GPA_Dummy + $0001);
        { only one of FREEVERT or FREEHORIZ }
 GPA_Borderless = (GPA_Dummy + $0002);
 GPA_HorizPot   = (GPA_Dummy + $0003);
 GPA_HorizBody  = (GPA_Dummy + $0004);
 GPA_VertPot    = (GPA_Dummy + $0005);
 GPA_VertBody   = (GPA_Dummy + $0006);
 GPA_Total      = (GPA_Dummy + $0007);
 GPA_Visible    = (GPA_Dummy + $0008);
 GPA_Top        = (GPA_Dummy + $0009);
{ New for V37: }
 GPA_NewLook    = (GPA_Dummy + $000A);

{ STRGCLASS attributes }

 GSTRINGA_Dummy         =  (TAG_USER      +$32000);
 GSTRINGA_MaxChars      =  (GSTRINGA_Dummy + $0001);
 GSTRINGA_Buffer        =  (GSTRINGA_Dummy + $0002);
 GSTRINGA_UndoBuffer    =  (GSTRINGA_Dummy + $0003);
 GSTRINGA_WorkBuffer    =  (GSTRINGA_Dummy + $0004);
 GSTRINGA_BufferPos     =  (GSTRINGA_Dummy + $0005);
 GSTRINGA_DispPos       =  (GSTRINGA_Dummy + $0006);
 GSTRINGA_AltKeyMap     =  (GSTRINGA_Dummy + $0007);
 GSTRINGA_Font          =  (GSTRINGA_Dummy + $0008);
 GSTRINGA_Pens          =  (GSTRINGA_Dummy + $0009);
 GSTRINGA_ActivePens    =  (GSTRINGA_Dummy + $000A);
 GSTRINGA_EditHook      =  (GSTRINGA_Dummy + $000B);
 GSTRINGA_EditModes     =  (GSTRINGA_Dummy + $000C);

{ booleans }
 GSTRINGA_ReplaceMode    = (GSTRINGA_Dummy + $000D);
 GSTRINGA_FixedFieldMode = (GSTRINGA_Dummy + $000E);
 GSTRINGA_NoFilterMode   = (GSTRINGA_Dummy + $000F);

 GSTRINGA_Justification  = (GSTRINGA_Dummy + $0010);
        { GACT_STRINGCENTER, GACT_STRINGLEFT, GACT_STRINGRIGHT }
 GSTRINGA_LongVal        = (GSTRINGA_Dummy + $0011);
 GSTRINGA_TextVal        = (GSTRINGA_Dummy + $0012);

 GSTRINGA_ExitHelp       = (GSTRINGA_Dummy + $0013);
        { GSTRINGA_ExitHelp is new for V37, and ignored by V36.
         * Set this if you want the gadget to exit when Help is
         * pressed.  Look for a code of $5F, the rawkey code for Help
         }

 SG_DEFAULTMAXCHARS     = (128);

{ Gadget Layout related attributes     }

 GLAYOUTA_Dummy          = (TAG_USER  + $38000);
 GLAYOUTA_LayoutObj      = (GLAYOUTA_Dummy + $0001);
 GLAYOUTA_Spacing        = (GLAYOUTA_Dummy + $0002);
 GLAYOUTA_Orientation    = (GLAYOUTA_Dummy + $0003);

{ orientation values   }
 LORIENT_NONE   = 0;
 LORIENT_HORIZ  = 1;
 LORIENT_VERT   = 2;


{ Gadget Method ID's   }

 GGM_Dummy      =  (-1);    { not used for anything                }
 GGM_HITTEST    =  (0);     { return GMR_GADGETHIT IF you are clicked on
                                 * (whether or not you are disabled).
                                 }
 GGM_RENDER      = (1);     { draw yourself, in the appropriate state }
 GGM_GOACTIVE    = (2);     { you are now going to be fed input    }
 GGM_HANDLEINPUT = (3);     { handle that input                    }
 GGM_GOINACTIVE  = (4);     { whether or not by choice, you are done  }
 GGM_HELPTEST    = (5);     { Will you send gadget help if the mouse is
                                 * at the specified coordinates?  See below
                                 * for possible GMR_ values.
                                 }
 GGM_LAYOUT      = (6);     { re-evaluate your size based on the GadgetInfo
                                 * Domain.  Do NOT re-render yourself yet, you
                                 * will be called when it is time...
                                 }

{ Parameter "Messages" passed to gadget class methods  }

{ GGM_HITTEST   }
type
  ggpht_Mouse_Struct = Record
   x,y : Short;
  END;

  ggpHitTest = Record
    MethodID  : Integer;
    ggpht_GInfo : GadgetInfoPtr;
    ggpht_Mouse : ggpht_Mouse_Struct;
  END;
  ggpHitTestPtr =  ^ggpHitTest;

const
{ For GGM_HITTEST, return GMR_GADGETHIT if you were indeed hit,
 * otherwise return zero.
 *
 * For GGM_HELPTEST, return GMR_NOHELPHIT (zero) if you were not hit.
 * Typically, return GMR_HELPHIT if you were hit.
 * It is possible to pass a UWORD to the application via the Code field
 * of the IDCMP_GADGETHELP message.  Return GMR_HELPCODE or'd with
 * the UWORD-sized result you wish to return.
 *
 * GMR_HELPHIT yields a Code value of ((UWORD) ~0), which should
 * mean "nothing particular" to the application.
 }

 GMR_GADGETHIT  = ($00000004);    { GGM_HITTEST hit }

 GMR_NOHELPHIT  = ($00000000);    { GGM_HELPTEST didn't hit }
 GMR_HELPHIT    = ($FFFFFFFF);    { GGM_HELPTEST hit, return code = ~0 }
 GMR_HELPCODE   = ($00010000);    { GGM_HELPTEST hit, return low word as code }


{ GGM_RENDER    }
Type
   ggpRender = Record
    MethodID  : Integer;
    ggpr_GInfo : GadgetInfoPtr;      { gadget context               }
    ggpr_RPort : RastPortPtr;        { all ready for use            }
    ggpr_Redraw : Integer;           { might be a "highlight pass"  }
   END;
   ggpRenderPtr = ^ggpRender;

{ values of ggpr_Redraw }
CONST
 GREDRAW_UPDATE = (2);     { incremental update, e.g. prop slider }
 GREDRAW_REDRAW = (1);     { redraw gadget        }
 GREDRAW_TOGGLE = (0);     { toggle highlight, IF applicable      }

{ GGM_GOACTIVE, GGM_HANDLEINPUT  }
Type
  ggpi_Mouse_Struct = Record
   x,y : Short;
  END;

  ggpInput = Record
    MethodID : Integer;
    ggpi_GInfo : GadgetInfoPtr;
    ggpi_IEvent : InputEventPtr;
    ggpi_Termination : Address;
    ggpi_Mouse : ggpi_Mouse_Struct;
    {* (V39) Pointer to TabletData structure, if this event originated
     * from a tablet which sends IESUBCLASS_NEWTABLET events, or NULL if
     * not.
     *
     * DO NOT ATTEMPT TO READ THIS FIELD UNDER INTUITION PRIOR TO V39!
     * IT WILL BE INVALID!
     *
   ggpi_TabletData  : TabletDataPtr;}
  END;
  ggpInputPtr = ^ggpInput;

{ GGM_HANDLEINPUT and GGM_GOACTIVE  return code flags    }
{ return GGMR_MEACTIVE (0) alone if you want more input.
 * Otherwise, return ONE of GMR_NOREUSE and GGMR_REUSE, and optionally
 * GGMR_VERIFY.
 }
CONST
 GGMR_MEACTIVE  =  (0);
 GGMR_NOREUSE   =  (2);
 GGMR_REUSE     =  (4);
 GGMR_VERIFY    =  (8);        { you MUST set cgp_Termination }

{ New for V37:
 * You can end activation with one of GMR_NEXTACTIVE and GMR_PREVACTIVE,
 * which instructs Intuition to activate the next or previous gadget
 * that has GFLG_TABCYCLE set.
 }
 GGMR_NEXTACTIVE = (16);
 GGMR_PREVACTIVE = (32);

{ GGM_GOINACTIVE }
Type
   ggpGoInactive = Record
    MethodID    : Integer;
    ggpgi_GInfo  : GadgetInfoPtr;

    { V37 field only!  DO NOT attempt to read under V36! }
    ggpgi_Abort  : Integer;               { ggpgi_Abort=1 IF gadget was aborted
                                         * by Intuition and 0 if gadget went
                                         * inactive at its own request
                                         }
   END;
   ggpGoInactivePtr = ^ggpGoInactive;

{* New for V39: Intuition sends GGM_LAYOUT to any GREL_ gadget when
 * the gadget is added to the window (or when the window opens, if
 * the gadget was part of the NewWindow.FirstGadget or the WA_Gadgets
 * list), or when the window is resized.  Your gadget can set the
 * GGA_RelSpecial property to get GGM_LAYOUT events without Intuition
 * changing the interpretation of your gadget select box.  This
 * allows for completely arbitrary resizing/repositioning based on
 * window size.
 *}
{* GGM_LAYOUT *}
Type
 ggpLayout = Record
    MethodID            : Integer;
    ggpl_GInfo           : GadgetInfoPtr;
    ggpl_Initial         : Integer;      {* non-zero if this method was invoked
                                         * during AddGList() or OpenWindow()
                                         * time.  zero if this method was invoked
                                         * during window resizing.
                                         *}
 end;
 ggpLayoutPtr = ^ggpLayout;

Var
 GClass: GEClassPtr;

Function _GEGadgetHook(class:GEClassPtr; Object,Msg:Address):Integer;

Const
 BoolPacket1 : Array [1..10] of TagItem =
             ((GGA_EndGadget,ENDGADGET),
              (GGA_Immediate,GADGIMMEDIATE),
              (GGA_RelVerify,RELVERIFY),
              (GGA_FollowMouse,FOLLOWMOUSE),
              (GGA_RightBorder,RIGHTBORDER),
              (GGA_LeftBorder,LEFTBORDER),
              (GGA_TopBorder,TOPBORDER),
              (GGA_BottomBorder,BOTTOMBORDER),
              (GGA_ToggleSelect,TOGGLESELECT),(TAG_DONE,0)); {Activation flags}

 BoolPacket2 : Array [1..3] of TagItem =
             ((GGA_Disabled, GADGDISABLED), (GGA_Selected,SELECTED),(TAG_DONE,0));

 BoolPacket3 : Array [1..3] of TagItem =
             ((GGA_GZZGadget,GZZGADGET),(GGA_SysGadget,SYSGADGET),(TAG_DONE,0));

Var
 MM: ^Array[0..0]of integer;
 TMem: _GObjectPtr;
 Tgad: GE_GadgetPtr;
 TMs1,TMs2: TagItemPtr;
 tAct: ggpInputPtr;
 tin : ggpGoInactivePtr;
 i,j: Integer;

Begin
 if (Object<>Nil)and(Msg<>Nil)then begin
  MM:= Msg;
  Case MM^[0] of
   GM_NEW : Begin {Create new object }
     TMem:= _GObjectPtr(DoSuperMethodA(class,Object,Msg));
     if TMem<>Nil then begin
      {Writeln(GE_IsObject(TMem));}
      Tgad:= GE_GadgetPtr(INST_DATA(class,TMem));
      With Tgad^ do begin
       with ggadget do begin
        LeftEdge:= GE_GetTagData(GGA_Left,0,TagItemPtr(MM^[1]));
        TopEdge:= GE_GetTagData(GGA_Top,0,TagItemPtr(MM^[1]));
        Width:= GE_GetTagData(GGA_Width,16,TagItemPtr(MM^[1]));
        Height:= GE_GetTagData(GGA_Height,1,TagItemPtr(MM^[1]));
        Activation:= GE_PackBoolTags(0,TagItemPtr(MM^[1]),@BoolPacket1);
        Flags:= GE_GetTagData(GGA_HighLight,0,TagItemPtr(MM^[1]));
        Flags:= GE_PackBoolTags(Flags,TagItemPtr(MM^[1]),@BoolPacket2);
        GadgetType:= GE_PackBoolTags(0,TagItemPtr(MM^[1]),@BoolPacket3);
        GadgetRender:= Address(GE_GetTagData(GGA_Image,0,TagItemPtr(MM^[1])));
        SelectRender:= Address(GE_GetTagData(GGA_SelectRender,0,TagItemPtr(MM^[1])));
        GadgetID:= GE_GetTagData(GGA_ID,0,TagItemPtr(MM^[1]));
        SpecialInfo:= Address(GE_GetTagData(GGA_SpecialInfo,0,TagItemPtr(MM^[1])));
        UserData:= Address(GE_GetTagData(GGA_UserData,0,TagItemPtr(MM^[1])));
        {Writeln(Integer(GadgetRender));}
       end;
       TMs1:= GE_FindTagItem(GGA_IntuiText,TagItemPtr(MM^[1]));
       if TMs1<>Nil then
        ggadget.GadgetText:= IntuiTextPtr(TMs1^.ti_Data)
       else begin
        TMs1:= GE_FindTagItem(GGA_Text,TagItemPtr(MM^[1]));
        if TMs1<>Nil then
         with ggadget do begin
          GadgetText:= AllocMem(SizeOf(IntuiText),MEMF_CLEAR+MEMF_PUBLIC);
          if GadgetText<>Nil then begin
           With GadgetText^ do begin
            FrontPen:= 1;
            DrawMode:= JAM1;
            IText:= Address(TMs1^.ti_Data);
           end;
           gxflags:= XFLG_LABELSTRING;
          end;
         end
        else begin
         TMs1:= GE_FindTagItem(GGA_LabelImage,TagItemPtr(MM^[1]));
         if TMs1<>Nil then begin
          glabel:= Address(TMs1^.ti_Data);
          gxflags:= XFLG_LABELIMAGE;
         end;
        end;
       end;
       {---- New fields ----}
       gpinfo:= Address(GE_GetTagData(GGA_PenInfo,0,TagItemPtr(MM^[1])));
      end;
     end;
     _GEGadgetHook:= Integer(TMem);
   end;
   GM_SET : Begin {Set attributtes}
     {Writeln("setting");}
     Tgad:= GE_GadgetPtr(INST_DATA(class,object));
     j:= -1;
     TMs1:= gpSetPtr(MM)^.gps_AttrList;
     TMs2:= TMs1;
     Tgad^.ggadget.Activation:= GE_PackBoolTags(Tgad^.ggadget.Activation,TMs1,@BoolPacket1);
     Tgad^.ggadget.Flags:= GE_PackBoolTags(Tgad^.ggadget.Flags,TMs1,@BoolPacket2);
     Tgad^.ggadget.GadgetType:= GE_PackBoolTags(Tgad^.ggadget.GadgetType,TMs1,@BoolPacket3);
     TMs1:= GE_NextTagItem(TMs2);
     While TMs1<>Nil do begin
      i:= TMs1^.ti_Data;
      if (TMs1^.ti_Tag<>GGA_UserData)and (j=-1) and (Tgad^.gwindow<>Nil) then
        j:= RemoveGadget(Tgad^.gwindow,GadgetPtr(Tgad));
      Case TMs1^.ti_Tag of
        GGA_Left: Tgad^.ggadget.LeftEdge:= i;
        GGA_Top: Tgad^.ggadget.TopEdge:= i;
        GGA_Width: Tgad^.ggadget.Width:= i;
        GGA_Height: Tgad^.ggadget.Height:= i;
        GGA_HighLight: Tgad^.ggadget.Flags:= (Tgad^.ggadget.Flags and not GADGHIGHBITS) or i;
        GGA_Image: Tgad^.ggadget.GadgetRender:= Address(i);
        GGA_SelectRender: Tgad^.ggadget.SelectRender:= Address(i);
        GGA_ID: Tgad^.ggadget.GadgetID:= i;
        GGA_SpecialInfo: Tgad^.ggadget.SpecialInfo:= Address(i);
        GGA_UserData: Tgad^.ggadget.UserData:= Address(i);
        {---- New fields ----}
        GGA_PenInfo: Tgad^.gpinfo:= Address(i);
      end;
      TMs1:= GE_NextTagItem(TMs2);
     end;
     if j<>-1 then begin
      i:=AddGadget(TGad^.gwindow,GadgetPtr(TGad),j);

      {---CAMBIAR POR GE_RefreshGadgets---}

      RefreshGadgets(GadgetPtr(Tgad),Tgad^.gwindow,Nil);

      {----^^^^^^^^^----}
     end;
     _GEGadgetHook:= 1;
   end;
   GGM_HITTEST: _GEGadgetHook:= GMR_GADGETHIT; {Always Hit since gadget is a rectangle}
   GGM_GOACTIVE: Begin
     Tgad:= GE_GadgetPtr(INST_DATA(class,object));
     {TAct:= ggpInputPtr(MM);}
     if ((Tgad^.ggadget.GadgetType and STRGADGET)<>0)and(Tgad^.gwindow <>Nil) then
       _GEGadgetHook:= GMR_MEACTIVE
     else
       _GEGadgetHook:= GMR_NOREUSE;
   end;
   {GGM_GOINACTIVE probablemente actualizar estado}
   GGM_HANDLEINPUT: _GEGadgetHook:= GMR_MEACTIVE {El resto de los casos se ocupa Intuition}
   {GGM_RENDER:}
   end;
   else _GEGadgetHook:= DoSuperMethodA(class,Object,Msg);
  end;
 end;
 _GEGadgetHook:= 0;
end;

