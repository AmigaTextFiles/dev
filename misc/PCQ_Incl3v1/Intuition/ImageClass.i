{ ImageClass.i }

{$I   "Include:Utility/TagItem.i"}

{
 * NOTE:  <intuition/iobsolete.h> is included at the END of this file!
 }

CONST
 CUSTOMIMAGEDEPTH     =   (-1);
{ if image.Depth is this, it's a new Image class object }

{ some convenient macros and casts }
FUNCTION GADGET_BOX(g : GadgetPtr) : Integer;
 External;

FUNCTION IM_BOX(im : ImagePtr) : Integer;
 External;

FUNCTION IM_FGPEN(im : ImagePtr) : Short;
BEGIN
 IM_FGPEN:=im^.PlanePick;
END;

FUNCTION IM_BGPEN(im : ImagePtr) : Short;
BEGIN
 IM_BGPEN:=im^.PlaneOnOff;
END;

{****************************************************}
CONST
 IA_Dummy             =   (TAG_USER + $20000);
 IA_Left              =   (IA_Dummy + $01);
 IA_Top               =   (IA_Dummy + $02);
 IA_Width             =   (IA_Dummy + $03);
 IA_Height            =   (IA_Dummy + $04);
 IA_FGPen             =   (IA_Dummy + $05);
                    { IA_FGPen also means "PlanePick"  }
 IA_BGPen             =   (IA_Dummy + $06);
                    { IA_BGPen also means "PlaneOnOff" }
 IA_Data              =   (IA_Dummy + $07);
                    { bitplanes, for classic image,
                     * other image classes may use it for other things
                     }
 IA_LineWidth         =   (IA_Dummy + $08);
 IA_Pens              =   (IA_Dummy + $0E);
                    { pointer to UWORD pens[],
                     * ala DrawInfo.Pens, MUST be
                     * terminated by ~0.  Some classes can
                     * choose to have this, or SYSIA_DrawInfo,
                     * or both.
                     }
 IA_Resolution        =   (IA_Dummy + $0F);
                    { packed uwords for x/y resolution into a longword
                     * ala DrawInfo.Resolution
                     }

{*** see class documentation to learn which    ****}
{*** classes recognize these                   ****}
 IA_APattern           =  (IA_Dummy + $10);
 IA_APatSize           =  (IA_Dummy + $11);
 IA_Mode               =  (IA_Dummy + $12);
 IA_Font               =  (IA_Dummy + $13);
 IA_Outline            =  (IA_Dummy + $14);
 IA_Recessed           =  (IA_Dummy + $15);
 IA_DoubleEmboss       =  (IA_Dummy + $16);
 IA_EdgesOnly          =  (IA_Dummy + $17);

{*** "sysiclass" attributes                    ****}
 SYSIA_Size            =  (IA_Dummy + $0B);
                    { 's below          }
 SYSIA_Depth           =  (IA_Dummy + $0C);
                    { this is unused by Intuition.  SYSIA_DrawInfo
                     * is used instead for V36
                     }
 SYSIA_Which           =  (IA_Dummy + $0D);
                    { see 's below      }
 SYSIA_DrawInfo        =  (IA_Dummy + $18);
                    { pass to sysiclass, please }

{****  obsolete: don't use these, use IA_Pens  ****}
 SYSIA_Pens            =  IA_Pens;
 IA_ShadowPen          =  (IA_Dummy + $09);
 IA_HighlightPen       =  (IA_Dummy + $0A);

{ New for V39: }
 SYSIA_ReferenceFont   =  (IA_Dummy + $19);
                    { Font to use as reference for scaling
                     * certain sysiclass images
                     }
 IA_SupportsDisable    =  (IA_Dummy + $1a);
                    { By default, Intuition ghosts gadgets itself,
                     * instead of relying on IDS_DISABLED or
                     * IDS_SELECTEDDISABLED.  An imageclass that
                     * supports these states should return this attribute
                     * as TRUE.  You cannot set or clear this attribute,
                     * however.
                     }

 IA_FrameType          =  (IA_Dummy + $1b);
                    { Starting with V39, FrameIClass recognizes
                     * several standard types of frame.  Use one
                     * of the FRAME_ specifiers below.  Defaults
                     * to FRAME_DEFAULT.
                     }

{* next attribute: (IA_Dummy + $1c)   *}

{***********************************************}

{ data values for SYSIA_Size   }
 SYSISIZE_MEDRES = (0);
 SYSISIZE_LOWRES = (1);
 SYSISIZE_HIRES  = (2);

{
 * SYSIA_Which tag data values:
 * Specifies which system gadget you want an image for.
 * Some numbers correspond to internal Intuition s
 }
 DEPTHIMAGE     = ($00);
 ZOOMIMAGE      = ($01);
 SIZEIMAGE      = ($02);
 CLOSEIMAGE     = ($03);
 SDEPTHIMAGE    = ($05); { screen depth gadget }
 LEFTIMAGE      = ($0A);
 UPIMAGE        = ($0B);
 RIGHTIMAGE     = ($0C);
 DOWNIMAGE      = ($0D);
 CHECKIMAGE     = ($0E);
 MXIMAGE        = ($0F); { mutual exclude "button" }
{* New for V39: *}
 MENUCHECK      = ($10); { Menu checkmark image }
 AMIGAKEY       = ($11); { Menu Amiga-key image }


{ image message id's   }
    IM_DRAW     = $202;  { draw yourself, with "state"          }
    IM_HITTEST  = $203;  { return TRUE IF click hits image      }
    IM_ERASE    = $204;  { erase yourself                       }
    IM_MOVE     = $205;  { draw new AND erase old, smoothly     }

    IM_DRAWFRAME= $206;  { draw with specified dimensions       }
    IM_FRAMEBOX = $207;  { get recommended frame around some box}
    IM_HITFRAME = $208;  { hittest with dimensions              }
    IM_ERASEFRAME= $209; { hittest with dimensions              }

{ image draw states or styles, for IM_DRAW }
    IDS_NORMAL          = (0);
    IDS_SELECTED        = (1);    { for selected gadgets     }
    IDS_DISABLED        = (2);    { for disabled gadgets     }
    IDS_BUSY            = (3);    { for future functionality }
    IDS_INDETERMINATE   = (4);    { for future functionality }
    IDS_INACTIVENORMAL  = (5);    { normal, in inactive window border }
    IDS_INACTIVESELECTED= (6);    { selected, in inactive border }
    IDS_INACTIVEDISABLED= (7);    { disabled, in inactive border }

{ oops, please forgive spelling error by jimm }
 IDS_INDETERMINANT = IDS_INDETERMINATE;

{ IM_FRAMEBOX  }
Type
  impFrameBox = Record
    MethodID   : Integer;
    imp_ContentsBox  : IBoxPtr;       { input: relative box of contents }
    imp_FrameBox     : IBoxPtr;          { output: rel. box of encl frame  }
    imp_DrInfo       : DrawInfoPtr;
    imp_FrameFlags   : Integer;
  END;
  impFrameBoxPtr = ^impFrameBox;

CONST
 FRAMEF_SPECIFY = (1);  { Make do with the dimensions of FrameBox
                                 * provided.
                                 }

{ IM_DRAW, IM_DRAWFRAME        }
Type
   imp_Offset_Struct = Record
    x,y : Short;
   END;

   imp_Dimensions_Struct = Record
    Width, Height : Short;
   END;

   impDraw = Record
    MethodID    : Integer;
    imp_RPort   : RastPortPtr;
    imp_Offset  : imp_Offset_Struct;
    imp_State   : Integer;
    imp_DrInfo  : DrawInfoPtr;

    { these parameters only valid for IM_DRAWFRAME }
    imp_Dimensions : imp_Dimensions_Struct;
   END;
   impDrawPtr = ^impDraw;

{ IM_ERASE, IM_ERASEFRAME      }
{ NOTE: This is a subset of impDraw    }
   impErase = Record
    MethodID       : Integer;
    imp_RPort      : RastPortPtr;
    imp_Offset     : imp_Offset_Struct;

    { these parameters only valid for IM_ERASEFRAME }
    imp_Dimensions : imp_Dimensions_Struct;
   END;
   impErasePtr = ^impErase;

{ IM_HITTEST, IM_HITFRAME      }
   imp_Point_Struct = Record
    x,y : Short;
   END;

   impHitTest = Record
    MethodID   : Integer;
    imp_Point  : imp_Point_Struct;

    { these parameters only valid for IM_HITFRAME }
    imp_Dimensions : imp_Dimensions_Struct;
   END;
   impHitTestPtr = ^impHitTest;

{$I   "Include:Intuition/iobsolete.i"}



