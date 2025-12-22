{ Screens.i }


{$I   "Include:exec/Types.i"}
{$I   "Include:graphics/gfx.i"}
{$I   "Include:Graphics/Clip.i"}
{$I   "Include:Graphics/View.i"}
{$I   "Include:Graphics/RastPort.i"}
{$I   "Include:Graphics/Text.i"}
{$I   "Include:Graphics/Layers.i"}
{$I   "Include:Utility/TagItem.i"}

{
 * NOTE:  intuition/iobsolete.h is included at the END of this file!
 }

{ ======================================================================== }
{ === DrawInfo ========================================================= }
{ ======================================================================== }

{ This is a packet of information for graphics rendering.  It originates
 * with a Screen, and is gotten using GetScreenDrawInfo( screen );
 }

{ If you find dri_Version >= DRI_VERSION, you know this structure
 * has at least the fields defined in this version of the include file
 }
CONST
 RI_VERSION  =    (1);     { obsolete, will be removed            }
 DRI_VERSION =    (1);

Type
 dri_Resolution_Struct = Record
  x,y : Short;
 END;

 DrawInfo = Record
    dri_Version : Short;    { will be  DRI_VERSION                 }
    dri_NumPens : Short;    { guaranteed to be >= numDrIPens       }
    dri_Pens    : Address;  { pointer to pen array                 }

    dri_Font    : TextFontPtr;      { screen default font          }
    dri_Depth   : Short;            { (initial) depth of screen bitmap     }

    dri_Resolution : dri_Resolution_Struct;              { from DisplayInfo database for initial display mode }

    dri_Flags : Integer;              { defined below                }
{ New for V39: dri_CheckMark, dri_AmigaKey. }
    dri_CheckMark : Address; { ImagePtr }         { pointer to scaled checkmark image
                                                  * Will be NULL if DRI_VERSION < 2
                                                  }
    dri_AmigaKey  : Address; { ImagePtr }    { pointer to scaled Amiga-key image
                                             * Will be NULL if DRI_VERSION < 2
                                             }

    dri_Reserved : Array[0..4] of Integer;        { avoid recompilation ;^)      }
 END;
 DrawInfoPtr = ^DrawInfo;

CONST
 DRIF_NEWLOOK =   $00000001;      { specified SA_Pens, full treatment }

{ rendering pen number indexes into DrawInfo.dri_Pens[]        }
 DETAILPEN    =    ($0000);       { compatible Intuition rendering pens  }
 BLOCKPEN     =    ($0001);       { compatible Intuition rendering pens  }
 TEXTPEN      =    ($0002);       { text on background                   }
 SHINEPEN     =    ($0003);       { bright edge on 3D objects            }
 SHADOWPEN    =    ($0004);       { dark edge on 3D objects              }
 FILLPEN      =    ($0005);       { active-window/selected-gadget fill   }
 FILLTEXTPEN  =    ($0006);       { text over FILLPEN                    }
 BACKGROUNDPEN =   ($0007);       { always color 0                       }
 HIGHLIGHTTEXTPEN = ($0008);       { special color text, on background    }
{ New for V39, only present if DRI_VERSION >= 2: }
 BARDETAILPEN   =  ($0009);       { text/detail in screen-bar/menus }
 BARBLOCKPEN    =  ($000A);       { screen-bar/menus fill }
 BARTRIMPEN     =  ($000B);       { trim under screen-bar }

 NUMDRIPENS   =    ($0009);

{ New for V39:  It is sometimes useful to specify that a pen value
 * is to be the complement of color zero to three.  The "magic" numbers
 * serve that purpose:
 }
 PEN_C3        =  $FEFC;          { Complement of color 3 }
 PEN_C2        =  $FEFD;          { Complement of color 2 }
 PEN_C1        =  $FEFE;          { Complement of color 1 }
 PEN_C0        =  $FEFF;          { Complement of color 0 }

{ ======================================================================== }
{ === Screen ============================================================= }
{ ======================================================================== }

Type

    Screen = record
        NextScreen      : ^Screen;      { linked list of screens }
        FirstWindow     : Address;      { linked list Screen's Windows }

        LeftEdge,
        TopEdge         : Short;        { parameters of the screen }
        Width,
        Height          : Short;        { parameters of the screen }

        MouseY,
        MouseX          : Short;        { position relative to upper-left }

        Flags           : Short;        { see definitions below }

        Title           : String;       { null-terminated Title text }
        DefaultTitle    : String;       { for Windows without ScreenTitle }

    { Bar sizes for this Screen and all Window's in this Screen }
        BarHeight,
        BarVBorder,
        BarHBorder,
        MenuVBorder,
        MenuHBorder     : Byte;
        WBorTop,
        WBorLeft,
        WBorRight,
        WBorBottom      : Byte;

        Font            : TextAttrPtr;  { this screen's default font       }

    { the display data structures for this Screen (note the prefix S)}
        SViewPort       : ViewPort;     { describing the Screen's display }
        SRastPort       : RastPort;     { describing Screen rendering      }
        SBitMap         : BitMap;       { extra copy of RastPort BitMap   }
        LayerInfo       : Layer_Info;   { each screen gets a LayerInfo     }

    { You supply a linked-list of Gadgets for your Screen.
     *  This list DOES NOT include system Gadgets.  You get the standard
     *  system Screen Gadgets by default
     }

        FirstGadget     : Address;

        DetailPen,
        BlockPen        : Byte;         { for bar/border/gadget rendering }

    { the following variable(s) are maintained by Intuition to support the
     * DisplayBeep() color flashing technique
     }
        SaveColor0      : Short;

    { This layer is for the Screen and Menu bars }
        BarLayer        : LayerPtr;

        ExtData         : Address;
        UserData        : Address;
                        { general-purpose pointer to User data extension }
    {**** Data below this point are SYSTEM PRIVATE ****}

    end;
    ScreenPtr = ^Screen;

Const

{ The screen flags have the suffix "_f" added to avoid conflicts with
  routine names. }

{ --- FLAGS SET BY INTUITION --------------------------------------------- }
{ The SCREENTYPE bits are reserved for describing various Screen types
 * available under Intuition.
 }
    SCREENTYPE_f        = $000F;        { all the screens types available       }
{ --- the definitions for the Screen Type ------------------------------- }
    WBENCHSCREEN_f      = $0001;        { Ta Da!  The Workbench         }
    CUSTOMSCREEN_f      = $000F;        { for that special look         }

    SHOWTITLE_f         = $0010;        { this gets set by a call to ShowTitle() }

    BEEPING_f           = $0020;        { set when Screen is beeping            }

    CUSTOMBITMAP_f      = $0040;        { if you are supplying your own BitMap }

    SCREENBEHIND_f      = $0080;        { if you want your screen to open behind
                                         * already open screens
                                         }
    SCREENQUIET_f       = $0100;        { if you do not want Intuition to render
                                         * into your screen (gadgets, title)
    SCREENHIRES         = $0200;        { do no use lowres gadgets (private)       }

    NS_EXTENDED         = $1000;          { ExtNewScreen.Extension is valid      }
    { V36 applications can use OpenScreenTagList() instead of NS_EXTENDED  }

{ New for V39: }
    PENSHARED           = $0400;  { Screen opener set (SA_SharePens,TRUE) }


    AUTOSCROLL          = $4000;  { screen is to autoscoll               }

    STDSCREENHEIGHT     = -1;           { supply in NewScreen.Height            }
    STDSCREENWIDTH      = -1;           { supply in NewScreen.Width             }



{
 * Screen attribute tag ID's.  These are used in the ti_Tag field of
 * TagItem arrays passed to OpenScreenTagList() (or in the
 * ExtNewScreen.Extension field).
 }

{ Screen attribute tags.  Please use these versions, not those in
 * iobsolete.h.
 }
CONST
  SA_Dummy    =    (TAG_USER + 32);
{
 * these items specify items equivalent to fields in NewScreen
 }
 SA_Left     =    (SA_Dummy + $0001);
 SA_Top      =    (SA_Dummy + $0002);
 SA_Width    =    (SA_Dummy + $0003);
 SA_Height   =    (SA_Dummy + $0004);
                        { traditional screen positions and dimensions  }
 SA_Depth    =    (SA_Dummy + $0005);
                        { screen bitmap depth                          }
 SA_DetailPen=    (SA_Dummy + $0006);
                        { serves as default for windows, too           }
 SA_BlockPen =    (SA_Dummy + $0007);
 SA_Title    =    (SA_Dummy + $0008);
                        { default screen title                         }
 SA_Colors   =    (SA_Dummy + $0009);
                        { ti_Data is an array of struct ColorSpec,
                         * terminated by ColorIndex = -1.  Specifies
                         * initial screen palette colors.
                         }
 SA_ErrorCode=    (SA_Dummy + $000A);
                        { ti_Data points to LONG error code (values below)}
 SA_Font     =    (SA_Dummy + $000B);
                        { equiv. to NewScreen.Font                     }
 SA_SysFont  =    (SA_Dummy + $000C);
                        { Selects one of the preferences system fonts:
                         *      0 - old DefaultFont, fixed-width
                         *      1 - WB Screen preferred font
                         }
 SA_Type     =    (SA_Dummy + $000D);
                        { equiv. to NewScreen.Type                     }
 SA_BitMap   =    (SA_Dummy + $000E);
                        { ti_Data is pointer to custom BitMap.  This
                         * implies type of CUSTOMBITMAP
                         }
 SA_PubName  =    (SA_Dummy + $000F);
                        { presence of this tag means that the screen
                         * is to be a public screen.  Please specify
                         * BEFORE the two tags below
                         }
 SA_PubSig   =    (SA_Dummy + $0010);
 SA_PubTask  =    (SA_Dummy + $0011);
                        { Task ID and signal for being notified that
                         * the last window has closed on a public screen.
                         }
 SA_DisplayID=    (SA_Dummy + $0012);
                        { ti_Data is new extended display ID from
                         * <graphics/displayinfo.h>.
                         }
 SA_DClip    =    (SA_Dummy + $0013);
                        { ti_Data points to a rectangle which defines
                         * screen display clip region
                         }
 SA_Overscan =    (SA_Dummy + $0014);
                        { was S_STDDCLIP.  Set to one of the OSCAN_
                         * specifiers below to get a system standard
                         * overscan region for your display clip,
                         * screen dimensions (unless otherwise specified),
                         * and automatically centered position (partial
                         * support only so far).
                         * If you use this, you shouldn't specify
                         * SA_DClip.  SA_Overscan is for "standard"
                         * overscan dimensions, SA_DClip is for
                         * your custom numeric specifications.
                         }
 SA_Obsolete1=    (SA_Dummy + $0015);
                        { obsolete S_MONITORNAME                       }

{* booleans *}
 SA_ShowTitle  =  (SA_Dummy + $0016);
                        { boolean equivalent to flag SHOWTITLE         }
 SA_Behind     =  (SA_Dummy + $0017);
                        { boolean equivalent to flag SCREENBEHIND      }
 SA_Quiet      =  (SA_Dummy + $0018);
                        { boolean equivalent to flag SCREENQUIET       }
 SA_AutoScroll =  (SA_Dummy + $0019);
                        { boolean equivalent to flag AUTOSCROLL        }
 SA_Pens       =  (SA_Dummy + $001A);
                        { pointer to ~0 terminated UWORD array, as
                         * found in struct DrawInfo
                         }
 SA_FullPalette=  (SA_Dummy + $001B);
                        { boolean: initialize color table to entire
                         *  preferences palette (32 for V36), rather
                         * than compatible pens 0-3, 17-19, with
                         * remaining palette as returned by GetColorMap()
                         }

 SA_ColorMapEntries = (SA_Dummy + $001C);
                        { New for V39:
                         * Allows you to override the number of entries
                         * in the ColorMap for your screen.  Intuition
                         * normally allocates (1<<depth) or 32, whichever
                         * is more, but you may require even more if you
                         * use certain V39 graphics.library features
                         * (eg. palette-banking).
                         }

 SA_Parent      = (SA_Dummy + $001D);
                        { New for V39:
                         * ti_Data is a pointer to a "parent" screen to
                         * attach this one to.  Attached screens slide
                         * and depth-arrange together.
                         }

 SA_Draggable   = (SA_Dummy + $001E);
                        { New for V39:
                         * Boolean tag allowing non-draggable screens.
                         * Do not use without good reason!
                         * (Defaults to TRUE).
                         }

 SA_Exclusive   = (SA_Dummy + $001F);
                        { New for V39:
                         * Boolean tag allowing screens that won't share
                         * the display.  Use sparingly!  Starting with 3.01,
                         * attached screens may be SA_Exclusive.  Setting
                         * SA_Exclusive for each screen will produce an
                         * exclusive family.   (Defaults to FALSE).
                         }

 SA_SharePens   = (SA_Dummy + $0020);
                        { New for V39:
                         * For those pens in the screen's DrawInfo->dri_Pens,
                         * Intuition obtains them in shared mode (see
                         * graphics.library/ObtainPen()).  For compatibility,
                         * Intuition obtains the other pens of a public
                         * screen as PEN_EXCLUSIVE.  Screens that wish to
                         * manage the pens themselves should generally set
                         * this tag to TRUE.  This instructs Intuition to
                         * leave the other pens unallocated.
                         }

 SA_BackFill    = (SA_Dummy + $0021);
                        { New for V39:
                         * provides a "backfill hook" for your screen's
                         * Layer_Info.
                         * See layers.library/InstallLayerInfoHook()
                         }

 SA_Interleaved = (SA_Dummy + $0022);
                        { New for V39:
                         * Boolean tag requesting that the bitmap
                         * allocated for you be interleaved.
                         * (Defaults to FALSE).
                         }

 SA_Colors32    = (SA_Dummy + $0023);
                        { New for V39:
                         * Tag to set the screen's initial palette colors
                         * at 32 bits-per-gun.  ti_Data is a pointer
                         * to a table to be passed to the
                         * graphics.library/LoadRGB32() function.
                         * This format supports both runs of color
                         * registers and sparse registers.  See the
                         * autodoc for that function for full details.
                         * Any color set here has precedence over
                         * the same register set by SA_Colors.
                         }

 SA_VideoControl = (SA_Dummy + $0024);
                        { New for V39:
                         * ti_Data is a pointer to a taglist that Intuition
                         * will pass to graphics.library/VideoControl(),
                         * upon opening the screen.
                         }

 SA_FrontChild  = (SA_Dummy + $0025);
                        { New for V39:
                         * ti_Data is a pointer to an already open screen
                         * that is to be the child of the screen being
                         * opened.  The child screen will be moved to the
                         * front of its family.
                         }

 SA_BackChild   = (SA_Dummy + $0026);
                        { New for V39:
                         * ti_Data is a pointer to an already open screen
                         * that is to be the child of the screen being
                         * opened.  The child screen will be moved to the
                         * back of its family.
                         }

 SA_LikeWorkbench     =   (SA_Dummy + $0027);
                        { New for V39:
                         * Set ti_Data to 1 to request a screen which
                         * is just like the Workbench.  This gives
                         * you the same screen mode, depth, size,
                         * colors, etc., as the Workbench screen.
                         }

 SA_Reserved          =   (SA_Dummy + $0028);
                        { Reserved for private Intuition use }

 SA_MinimizeISG       =   (SA_Dummy + $0029);
                        { New for V40:
                         * For compatibility, Intuition always ensures
                         * that the inter-screen gap is at least three
                         * non-interlaced lines.  If your application
                         * would look best with the smallest possible
                         * inter-screen gap, set ti_Data to TRUE.
                         * If you use the new graphics VideoControl()
                         * VC_NoColorPaletteLoad tag for your screen's
                         * ViewPort, you should also set this tag.
                          }


{ this is an obsolete tag included only for compatibility with V35
 * interim release for the A2024 and Viking monitors
 }
 NSTAG_EXT_VPMODE = (TAG_USER + 1);


{ OpenScreen error codes, which are returned in the (optional) LONG
 * pointed to by ti_Data for the SA_ErrorCode tag item
 }
 OSERR_NOMONITOR   = (1);     { named monitor spec not available     }
 OSERR_NOCHIPS     = (2);     { you need newer custom chips          }
 OSERR_NOMEM       = (3);     { couldn't get normal memory           }
 OSERR_NOCHIPMEM   = (4);     { couldn't get chipmem                 }
 OSERR_PUBNOTUNIQUE= (5);     { public screen name already used      }
 OSERR_UNKNOWNMODE = (6);     { don't recognize mode asked for       }

{ ======================================================================== }
{ === NewScreen ========================================================== }
{ ======================================================================== }

Type

    NewScreen = record
        LeftEdge,
        TopEdge,
        Width,
        Height,
        Depth           : Short;        { screen dimensions }

        DetailPen,
        BlockPen        : Byte;         { for bar/border/gadget rendering }

        ViewModes       : Short;        { the Modes for the ViewPort (and View) }

        SType           : Short;        { the Screen type (see defines above) }

        Font            : TextAttrPtr;  { this Screen's default text attributes }

        DefaultTitle    : String;       { the default title for this Screen }

        Gadgets         : Address;      { your own Gadgets for this Screen }

    { if you are opening a CUSTOMSCREEN and already have a BitMap
     * that you want used for your Screen, you set the flags CUSTOMBITMAP in
     * the Type field and you set this variable to point to your BitMap
     * structure.  The structure will be copied into your Screen structure,
     * after which you may discard your own BitMap if you want
     }

        CustomBitMap    : BitMapPtr;
    end;
    NewScreenPtr = ^NewScreen;


type

 ExtNewScreen = Record
  LeftEdge, TopEdge, Width, Height, Depth : Short;
  DetailPen, BlockPen : Byte;
  ViewModes : Short;
  ens_Type : Short;     { Type in C-Includes }
  Font : TextAttrPtr;
  DefaultTitle : String;
  Gadgets : Address;
  CustomBitMap : BitMapPtr;
  Extension : TagItemPtr;
 END;
 ExtNewScreenPtr = ^ExtNewScreen;


CONST
{ === Overscan Types ===       }
 OSCAN_TEXT     = (1);     { entirely visible     }
 OSCAN_STANDARD = (2);     { just past edges      }
 OSCAN_MAX      = (3);     { as much as possible  }
 OSCAN_VIDEO    = (4);     { even more than is possible   }


{ === Public Shared Screen Node ===    }

{ This is the representative of a public shared screen.
 * This is an internal data structure, but some functions may
 * present a copy of it to the calling application.  In that case,
 * be aware that the screen pointer of the structure can NOT be
 * used safely, since there is no guarantee that the referenced
 * screen will remain open and a valid data structure.
 *
 * Never change one of these.
 }

Type
   PubScreenNode = Record
    psn_Node    : Node;       { ln_Name is screen name }
    psn_Screen  : ScreenPtr;
    psn_Flags   : Short;      { below                }
    psn_Size    : Short;      { includes name buffer }
    psn_VisitorCount  : Short; { how many visitor windows }
    psn_SigTask : TaskPtr;    { who to signal when visitors gone }
    psn_SigBit  : Byte;     { which signal }
   END;;
   PubScreenNodePtr = ^PubScreenNode;

CONST
 PSNF_PRIVATE  =  ($0001);

 MAXPUBSCREENNAME  =      (139);   { names no longer, please      }

{ pub screen modes     }
 SHANGHAI      =  $0001;  { put workbench windows on pub screen }
 POPPUBSCREEN  =  $0002;  { pop pub screen to front when visitor opens }

{ New for V39:  Intuition has new screen depth-arrangement and movement
 * functions called ScreenDepth() and ScreenPosition() respectively.
 * These functions permit the old behavior of ScreenToFront(),
 * ScreenToBack(), and MoveScreen().  ScreenDepth() also allows
 * independent depth control of attached screens.  ScreenPosition()
 * optionally allows positioning screens even though they were opened
 * (SA_Draggable,FALSE).
 }

{ For ScreenDepth(), specify one of SDEPTH_TOFRONT or SDEPTH_TOBACK,
 * and optionally also SDEPTH_INFAMILY.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * SDEPTH_INFAMILY.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.  (Note that this is a style-behavior
 * requirement;  there is no technical requirement that the
 * task calling this function need be the task which opened
 * the screen).
 }

 SDEPTH_TOFRONT        =  (0);     { Bring screen to front }
 SDEPTH_TOBACK         =  (1);     { Send screen to back }
 SDEPTH_INFAMILY       =  (2);     { Move an attached screen with
                                         * respect to other screens of
                                         * its family
                                         }

{ Here's an obsolete name equivalent to SDEPTH_INFAMILY: }
 SDEPTH_CHILDONLY      =  SDEPTH_INFAMILY;


{ For ScreenPosition(), specify one of SPOS_RELATIVE, SPOS_ABSOLUTE,
 * or SPOS_MAKEVISIBLE to describe the kind of screen positioning you
 * wish to perform:
 *
 * SPOS_RELATIVE: The x1 and y1 parameters to ScreenPosition() describe
 *      the offset in coordinates you wish to move the screen by.
 * SPOS_ABSOLUTE: The x1 and y1 parameters to ScreenPosition() describe
 *      the absolute coordinates you wish to move the screen to.
 * SPOS_MAKEVISIBLE: (x1,y1)-(x2,y2) describes a rectangle on the
 *      screen which you would like autoscrolled into view.
 *
 * You may additionally set SPOS_FORCEDRAG along with any of the
 * above.  Set this if you wish to reposition an (SA_Draggable,FALSE)
 * screen that you opened.
 *
 * NOTE: ONLY THE OWNER OF THE SCREEN should ever specify
 * SPOS_FORCEDRAG.  Commodities, "input helper" programs,
 * or any other program that did not open a screen should never
 * use that flag.
 }

 SPOS_RELATIVE         =  (0);     { Coordinates are relative }

 SPOS_ABSOLUTE         =  (1);     { Coordinates are expressed as
                                         * absolutes, not relatives.
                                         }

 SPOS_MAKEVISIBLE      =  (2);     { Coordinates describe a box on
                                         * the screen you wish to be
                                         * made visible by autoscrolling
                                         }

 SPOS_FORCEDRAG        =  (4);     { Move non-draggable screen }

{ New for V39: Intuition supports double-buffering in screens,
 * with friendly interaction with menus and certain gadgets.
 * For each buffer, you need to get one of these structures
 * from the AllocScreenBuffer() call.  Never allocate your
 * own ScreenBuffer structures!
 *
 * The sb_DBufInfo field is for your use.  See the graphics.library
 * AllocDBufInfo() autodoc for details.
 }
Type
 ScreenBuffer = Record
    sb_BitMap  : BitMapPtr;           { BitMap of this buffer }
    sb_DBufInfo : DBufInfoPtr;       { DBufInfo for this buffer }
 end;
 ScreenBufferPtr = ^ScreenBuffer;

const
{ These are the flags that may be passed to AllocScreenBuffer().
 }
 SB_SCREEN_BITMAP      =  1;
 SB_COPY_BITMAP        =  2;

{$I "Include:Intuition/Intuition.i"}

