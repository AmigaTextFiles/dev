OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'devices/keymap',
       'exec/ports',
       'graphics/clip',
       'graphics/gfx',
       'graphics/rastport',
       'graphics/text',
       'intuition/screens',
       'intuition/sghooks',
       'utility/tagitem'

OBJECT menu
  nextmenu:PTR TO menu
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:WORD
  menuname:PTR TO CHAR
  firstitem:PTR TO menuitem
  jazzx:INT
  jazzy:INT
  beatx:INT
  beaty:INT
ENDOBJECT     /* SIZEOF=30 */

CONST MENUENABLED=1,
      MIDRAWN=$100

OBJECT menuitem
  nextitem:PTR TO menuitem
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:WORD
  mutualexclude:LONG
  itemfill:LONG
  selectfill:LONG
  command:CHAR
  subitem:PTR TO menuitem
  nextselect:WORD
ENDOBJECT     /* SIZEOF=34 */

CONST CHECKIT=1,
      ITEMTEXT=2,
      COMMSEQ=4,
      MENUTOGGLE=8,
      ITEMENABLED=16,
      HIGHFLAGS=$C0,
      HIGHIMAGE=0,
      HIGHCOMP=$40,
      HIGHBOX=$80,
      HIGHNONE=$C0,
      CHECKED=$100,
      ISDRAWN=$1000,
      HIGHITEM=$2000,
      MENUTOGGLED=$4000

OBJECT requester
  olderrequest:PTR TO requester
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  relleft:INT
  reltop:INT
  reqgadget:PTR TO gadget
  reqborder:PTR TO border
  reqtext:PTR TO intuitext
  flags:WORD
  backfill:CHAR
  reqlayer:PTR TO layer
  reqpad1[32]:ARRAY
  imagebmap:PTR TO bitmap
  rwindow:PTR TO window
  reqimage:PTR TO image
  reqpad2[32]:ARRAY
ENDOBJECT     /* SIZEOF=112 */

CONST POINTREL=1,
      PREDRAWN=2,
      NOISYREQ=4,
      SIMPLEREQ=16,
      USEREQIMAGE=$20,
      NOREQBACKFILL=$40,
      REQOFFWINDOW=$1000,
      REQACTIVE=$2000,
      SYSREQUEST=$4000,
      DEFERREFRESH=$8000

CONST GD_LEFTEDGE=4

OBJECT gadget
  nextgadget:PTR TO gadget
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:WORD
  activation:WORD
  gadgettype:WORD
  gadgetrender:LONG
  selectrender:LONG
  gadgettext:PTR TO intuitext
  mutualexclude:LONG
  specialinfo:LONG
  gadgetid:WORD
  userdata:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT extgadget
  nextgadget:PTR TO extgadget
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  flags:WORD
  activation:WORD
  gadgettype:WORD
  gadgetrender:LONG
  selectrender:LONG
  gadgettext:PTR TO intuitext
  mutualexclude:LONG
  specialinfo:LONG
  gadgetid:WORD
  userdata:LONG
  moreflags:LONG
  boundsleftedge:INT
  boundstopedge:INT
  boundswidth:INT
  boundsheight:INT
ENDOBJECT     /* SIZEOF=56 */

CONST GFLG_GADGHIGHBITS=3,
      GFLG_GADGHCOMP=0,
      GFLG_GADGHBOX=1,
      GFLG_GADGHIMAGE=2,
      GFLG_GADGHNONE=3,
      GFLG_GADGIMAGE=4,
      GFLG_RELBOTTOM=8,
      GFLG_RELRIGHT=16,
      GFLG_RELWIDTH=$20,
      GFLG_RELHEIGHT=$40,
      GFLG_RELSPECIAL=$4000,
      GFLG_SELECTED=$80,
      GFLG_DISABLED=$100,
      GFLG_LABELMASK=$3000,
      GFLG_LABELITEXT=0,
      GFLG_LABELSTRING=$1000,
      GFLG_LABELIMAGE=$2000,
      GFLG_TABCYCLE=$200,
      GFLG_STRINGEXTEND=$400,
      GFLG_IMAGEDISABLE=$800,
      GFLG_EXTENDED=$8000,
      GACT_RELVERIFY=1,
      GACT_IMMEDIATE=2,
      GACT_ENDGADGET=4,
      GACT_FOLLOWMOUSE=8,
      GACT_RIGHTBORDER=16,
      GACT_LEFTBORDER=$20,
      GACT_TOPBORDER=$40,
      GACT_BOTTOMBORDER=$80,
      GACT_BORDERSNIFF=$8000,
      GACT_TOGGLESELECT=$100,
      GACT_BOOLEXTEND=$2000,
      GACT_STRINGLEFT=0,
      GACT_STRINGCENTER=$200,
      GACT_STRINGRIGHT=$400,
      GACT_LONGINT=$800,
      GACT_ALTKEYMAP=$1000,
      GACT_STRINGEXTEND=$2000,
      GACT_ACTIVEGADGET=$4000,
      GTYP_GADGETTYPE=$FC00,
      GTYP_SYSGADGET=$8000,
      GTYP_SCRGADGET=$4000,
      GTYP_GZZGADGET=$2000,
      GTYP_REQGADGET=$1000,
      GTYP_SIZING=16,
      GTYP_WDRAGGING=$20,
      GTYP_SDRAGGING=$30,
      GTYP_WUPFRONT=$40,
      GTYP_SUPFRONT=$50,
      GTYP_WDOWNBACK=$60,
      GTYP_SDOWNBACK=$70,
      GTYP_CLOSE=$80,
      GTYP_BOOLGADGET=1,
      GTYP_GADGET0002=2,
      GTYP_PROPGADGET=3,
      GTYP_STRGADGET=4,
      GTYP_CUSTOMGADGET=5,
      GTYP_GTYPEMASK=7,
      GTYP_SYSTYPEMASK=$F0,
      GTYP_WDEPTH=$40,
      GTYP_SDEPTH=$50,
      GTYP_WZOOM=$60,
      GTYP_SUNUSED=$70,
      GMORE_BOUNDS=1,
      GMORE_GADGETHELP=2,
      GMORE_SCROLLRASTER=4

OBJECT boolinfo
  flags:WORD
  mask:PTR TO INT  -> Target is unsigned
  reserved:LONG
ENDOBJECT     /* SIZEOF=10 */

CONST BOOLMASK=1

OBJECT propinfo
  flags:WORD
  horizpot:WORD
  vertpot:WORD
  horizbody:WORD
  vertbody:WORD
  cwidth:WORD
  cheight:WORD
  hpotres:WORD
  vpotres:WORD
  leftborder:WORD
  topborder:WORD
ENDOBJECT     /* SIZEOF=22 */

CONST AUTOKNOB=1,
      FREEHORIZ=2,
      FREEVERT=4,
      PROPBORDERLESS=8,
      KNOBHIT=$100,
      PROPNEWLOOK=16,
      KNOBHMIN=6,
      KNOBVMIN=4,
      MAXBODY=$FFFF,
      MAXPOT=$FFFF

OBJECT stringinfo
  buffer:PTR TO CHAR
  undobuffer:PTR TO CHAR
  bufferpos:INT
  maxchars:INT
  disppos:INT
  undopos:INT
  numchars:INT
  dispcount:INT
  cleft:INT
  ctop:INT
  extension:PTR TO stringextend
  longint:LONG
  altkeymap:PTR TO keymap
ENDOBJECT     /* SIZEOF=36 */

OBJECT intuitext
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  leftedge:INT
  topedge:INT
  itextfont:PTR TO textattr
  itext:PTR TO CHAR
  nexttext:PTR TO intuitext
ENDOBJECT     /* SIZEOF=20 */

OBJECT border
  leftedge:INT
  topedge:INT
  frontpen:CHAR
  backpen:CHAR
  drawmode:CHAR
  count:CHAR  -> This is signed
  xy:PTR TO INT
  nextborder:PTR TO border
ENDOBJECT     /* SIZEOF=16 */

CONST IG_LEFTEDGE=0

OBJECT image
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  depth:INT
  imagedata:PTR TO INT  -> Target is unsigned
  planepick:CHAR
  planeonoff:CHAR
  nextimage:PTR TO image
ENDOBJECT     /* SIZEOF=20 */

OBJECT intuimessage
  execmessage:mn
  class:LONG
  code:WORD
  qualifier:WORD
  iaddress:LONG
  mousex:INT
  mousey:INT
  seconds:LONG
  micros:LONG
  idcmpwindow:PTR TO window
  speciallink:PTR TO intuimessage
ENDOBJECT     /* SIZEOF=52 */

OBJECT extintuimessage
  intuimessage:intuimessage
  tabletdata:PTR TO tabletdata
ENDOBJECT     /* SIZEOF=NONE !!! */

CONST IDCMP_SIZEVERIFY=1,
      IDCMP_NEWSIZE=2,
      IDCMP_REFRESHWINDOW=4,
      IDCMP_MOUSEBUTTONS=8,
      IDCMP_MOUSEMOVE=16,
      IDCMP_GADGETDOWN=$20,
      IDCMP_GADGETUP=$40,
      IDCMP_REQSET=$80,
      IDCMP_MENUPICK=$100,
      IDCMP_CLOSEWINDOW=$200,
      IDCMP_RAWKEY=$400,
      IDCMP_REQVERIFY=$800,
      IDCMP_REQCLEAR=$1000,
      IDCMP_MENUVERIFY=$2000,
      IDCMP_NEWPREFS=$4000,
      IDCMP_DISKINSERTED=$8000,
      IDCMP_DISKREMOVED=$10000,
      IDCMP_WBENCHMESSAGE=$20000,
      IDCMP_ACTIVEWINDOW=$40000,
      IDCMP_INACTIVEWINDOW=$80000,
      IDCMP_DELTAMOVE=$100000,
      IDCMP_VANILLAKEY=$200000,
      IDCMP_INTUITICKS=$400000,
      IDCMP_IDCMPUPDATE=$800000,
      IDCMP_MENUHELP=$1000000,
      IDCMP_CHANGEWINDOW=$2000000,
      IDCMP_GADGETHELP=$4000000,
      IDCMP_MOUSEHOVER=        $08000000, /* v50 */
      IDCMP_LONELYMESSAGE=$80000000,
      CWCODE_MOVESIZE=0,
      CWCODE_DEPTH=1,
      MENUHOT=1,
      MENUCANCEL=2,
      MENUWAITING=3,
      OKOK=1,
      OKABORT=4,
      OKCANCEL=2,
      WBENCHOPEN=1,
      WBENCHCLOSE=2,

      HOVERSTART =      $0001, /* v50 */
      HOVERSTOP =       $0002 /* v50 */

OBJECT ibox
  left:INT
  top:INT
  width:INT
  height:INT
ENDOBJECT     /* SIZEOF=8 */

OBJECT window
  nextwindow:PTR TO window
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  mousey:INT
  mousex:INT
  minwidth:INT
  minheight:INT
  maxwidth:WORD
  maxheight:WORD
  flags:LONG
  menustrip:PTR TO menu
  title:PTR TO CHAR
  firstrequest:PTR TO requester
  dmrequest:PTR TO requester
  reqcount:INT
  wscreen:PTR TO screen
  rport:PTR TO rastport
  borderleft:CHAR  -> This is signed
  bordertop:CHAR  -> This is signed
  borderright:CHAR  -> This is signed
  borderbottom:CHAR  -> This is signed
  borderrport:PTR TO rastport
  firstgadget:PTR TO gadget
  parent:PTR TO window
  descendant:PTR TO window
  pointer:PTR TO INT  -> Target is unsigned
  ptrheight:CHAR  -> This is signed
  ptrwidth:CHAR  -> This is signed
  xoffset:CHAR  -> This is signed
  yoffset:CHAR  -> This is signed
  idcmpflags:LONG
  userport:PTR TO mp
  windowport:PTR TO mp
  messagekey:PTR TO intuimessage
  detailpen:CHAR
  blockpen:CHAR
  checkmark:PTR TO image
  screentitle:PTR TO CHAR
  gzzmousex:INT
  gzzmousey:INT
  gzzwidth:INT
  gzzheight:INT
  extdata:PTR TO CHAR
  userdata:PTR TO CHAR
  wlayer:PTR TO layer
  ifont:PTR TO textfont
  moreflags:LONG
ENDOBJECT     /* SIZEOF=136 */

CONST WFLG_SIZEGADGET=1,
      WFLG_DRAGBAR=2,
      WFLG_DEPTHGADGET=4,
      WFLG_CLOSEGADGET=8,
      WFLG_SIZEBRIGHT=16,
      WFLG_SIZEBBOTTOM=$20,
      WFLG_REFRESHBITS=$C0,
      WFLG_SMART_REFRESH=0,
      WFLG_SIMPLE_REFRESH=$40,
      WFLG_SUPER_BITMAP=$80,
      WFLG_OTHER_REFRESH=$C0,
      WFLG_BACKDROP=$100,
      WFLG_REPORTMOUSE=$200,
      WFLG_GIMMEZEROZERO=$400,
      WFLG_BORDERLESS=$800,
      WFLG_ACTIVATE=$1000,
      WFLG_RMBTRAP=$10000,
      WFLG_NOCAREREFRESH=$20000,
      WFLG_NW_EXTENDED=$40000,
      WFLG_NEWLOOKMENUS=$200000,
      WFLG_WINDOWACTIVE=$2000,
      WFLG_INREQUEST=$4000,
      WFLG_MENUSTATE=$8000,
      WFLG_WINDOWREFRESH=$1000000,
      WFLG_WBENCHWINDOW=$2000000,
      WFLG_WINDOWTICKED=$4000000,
      WFLG_VISITOR=$8000000,
      WFLG_ZOOMED=$10000000,
      WFLG_HASZOOM=$20000000,
      SUPER_UNUSED=$FCFC0000,
      DEFAULTMOUSEQUEUE=5

OBJECT nw
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  detailpen:CHAR
  blockpen:CHAR
  idcmpflags:LONG
  flags:LONG
  firstgadget:PTR TO gadget
  checkmark:PTR TO image
  title:PTR TO CHAR
  screen:PTR TO screen
  bitmap:PTR TO bitmap
  minwidth:INT
  minheight:INT
  maxwidth:WORD
  maxheight:WORD
  type:WORD
ENDOBJECT     /* SIZEOF=48 */

OBJECT extnewwindow
  leftedge:INT
  topedge:INT
  width:INT
  height:INT
  detailpen:CHAR
  blockpen:CHAR
  idcmpflags:LONG
  flags:LONG
  firstgadget:PTR TO gadget
  checkmark:PTR TO image
  title:PTR TO CHAR
  screen:PTR TO screen
  bitmap:PTR TO bitmap
  minwidth:INT
  minheight:INT
  maxwidth:WORD
  maxheight:WORD
  type:WORD
  extension:PTR TO tagitem
ENDOBJECT     /* SIZEOF=52 */

CONST WA_Dummy   =    (TAG_USER + 99)

CONST WA_LEFT=$80000064,
      WA_TOP=$80000065,
      WA_WIDTH=$80000066,
      WA_HEIGHT=$80000067,
      WA_DETAILPEN=$80000068,
      WA_BLOCKPEN=$80000069,
      WA_IDCMP=$8000006A,
      WA_FLAGS=$8000006B,
      WA_GADGETS=$8000006C,
      WA_CHECKMARK=$8000006D,
      WA_TITLE=$8000006E,
      WA_SCREENTITLE=$8000006F,
      WA_CUSTOMSCREEN=$80000070,
      WA_SUPERBITMAP=$80000071,
      WA_MINWIDTH=$80000072,
      WA_MINHEIGHT=$80000073,
      WA_MAXWIDTH=$80000074,
      WA_MAXHEIGHT=$80000075,
      WA_INNERWIDTH=$80000076,
      WA_INNERHEIGHT=$80000077,
      WA_PUBSCREENNAME=$80000078,
      WA_PUBSCREEN=$80000079,
      WA_PUBSCREENFALLBACK=$8000007A,
      WA_WINDOWNAME=$8000007B,
      WA_COLORS=$8000007C,
      WA_ZOOM=$8000007D,
      WA_MOUSEQUEUE=$8000007E,
      WA_BACKFILL=$8000007F,
      WA_RPTQUEUE=$80000080,
      WA_SIZEGADGET=$80000081,
      WA_DRAGBAR=$80000082,
      WA_DEPTHGADGET=$80000083,
      WA_CLOSEGADGET=$80000084,
      WA_BACKDROP=$80000085,
      WA_REPORTMOUSE=$80000086,
      WA_NOCAREREFRESH=$80000087,
      WA_BORDERLESS=$80000088,
      WA_ACTIVATE=$80000089,
      WA_RMBTRAP=$8000008A,
      WA_WBENCHWINDOW=$8000008B,
      WA_SIMPLEREFRESH=$8000008C,
      WA_SMARTREFRESH=$8000008D,
      WA_SIZEBRIGHT=$8000008E,
      WA_SIZEBBOTTOM=$8000008F,
      WA_AUTOADJUST=$80000090,
      WA_GIMMEZEROZERO=$80000091,
      WA_MENUHELP=$80000092,
      WA_NEWLOOKMENUS=$80000093,
      WA_AMIGAKEY=$80000094,
      WA_NOTIFYDEPTH=$80000095,
      WA_OBSOLETE=$80000096,
      WA_POINTER=$80000097,
      WA_BUSYPOINTER=$80000098,
      WA_POINTERDELAY=$80000099,
      WA_TABLETMESSAGES=$8000009A,
      WA_HELPGROUP=$8000009B,
      WA_HELPGROUPWINDOW=$8000009C,
      HC_GADGETHELP=1

/* new OpenWindowTags tags (added some padding there) */

/* V50 */


CONST WA_ExtraTitlebarGadgets /* I** */       = (WA_Dummy + 151)

/* ULONG flag field to indicate window titlebar gadgets
** your app wants to use. Those are built-in in sysiclass
** and use intuition skins system.
** You'll be notified with normal IDCMP_GADGETUP when one
** of those gadgets get pressed.
*/

CONST WA_ExtraGadgetsStartID /* I** */        = (WA_Dummy + 152)

/* All the extra gadgets have the Gadget ID's set to
** ETI_Dummy + gadget id value (defined below). Set this tag
** if you want to change ETI_Dummy value for your gadgets.
** (for example when those ID's are already in use)
*/

/* instead of using WA_ExtraTitlebarGadgets... */
CONST WA_ExtraGadget_Iconify /* IS* */        = (WA_Dummy + 153)
CONST WA_ExtraGadget_Lock    /* IS* */        = (WA_Dummy + 154)
CONST WA_ExtraGadget_MUI     /* IS* */        = (WA_Dummy + 155)
CONST WA_ExtraGadget_PopUp   /* IS* */        = (WA_Dummy + 156)
CONST WA_ExtraGadget_Snapshot /* IS* */       = (WA_Dummy + 157)
CONST WA_ExtraGadget_Jump    /* IS* */        = (WA_Dummy + 158)

CONST WA_SkinInfo            /* I** */        = (WA_Dummy + 159)

/* Intuition skins system usualy enchances window size when
** SIZEIMAGE width/height forces non-std border sizes.
** If your app already knows about the border sizes (GetSkinInfo)
** please add this tag to your OpenWindow call. This will switch
** off window size adjustment.
** ti_Data should point to SkinInfo struct allocated by GetSkinInfo.
** IMPORTANT: passing WA_SkinInfo tag to OpenWindowTags means
** that your app IS Skin compilant. Expect windows with non
** standard titlebar height, etc when you pass it (also with NULL
** tag->ti_Data!)
*/

CONST WA_TransparentRegion    /* I** */       = (WA_Dummy + 160)

/* Installs the provided region as a transparent region in window's layer.
** Best solution for fixed size windows. Setting WA_TransparentRegion clears
** previously set WA_TransparentRegionHook!
**
** For more information please refer to intuition/TransparencyControl() autodoc.
*/

CONST WA_TransparentRegionHook /* I** */      = (WA_Dummy + 161)

/* Installs the provided transparent region hook. The hook is called whenever
** window's layer needs updating (usualy on resize). The hook is called with
** window pointer in A2 and struct TransparencyMessage * in A1 registers.
** Setting this tag clears previously set WA_TransparentRegion!
**
** For more information please refer to intuition/TransparencyControl() autodoc.
*/

CONST WA_UserPort              /* I*G */       = (WA_Dummy + 162)
/* Please note that ModifyIDCMP(win,NULL) WILL NOT FREE userport
** when you use WA_UserPort!!! It will also NOT create a new msg
** port later!!! Keep in mind that ModifyIDCMP(win,NULL) will
** clear win->UserPort, but NOT free it - you need to store it and
** free manually! CloseWindow() doesn't free the port as well.
** IMPORTANT: remember that you need to reply all messages before
** the msg port was detached from all your windows!
*/

/* V51 */

CONST WA_ToolbarWindow /* I** */              = (WA_Dummy + 163)
/* Toolbar windows are windows that cannot be activated. They react
** fine on IDCMP_MOUSEBUTTONS, IDCMP_MOUSEMOVE, IDCMP_INTUITICKS, but
** only on those. The one and only supported intuition gadget is a
** GTYP_WDRAGGING(2) gadget, rest will be ignored. Toolbar windows
** are _always_ borderless.
*/

CONST WA_PointerType /* ISG */                = (WA_Dummy + 164)
/* Use one of intuition's built-in pointers in your window. There's
** basicly everything an app should need there - please avoid using
** custom pointers when possible.
*/

CONST WA_FrontWindow  /* I** */               = (WA_Dummy + 165)
/* Window stays always on front of other windows.
*/

CONST WA_Parent       /* I*G */               = (WA_Dummy + 166)
/* struct Window *. Makes the new window a child window of the one
** passed in ti_Data. Useful for popup windows - you can set
** child window position relatively to parent top/leftedge, child
** windows are also depth arranged with their parent
** windows, but NOT dragged (you need to care about this yourself).
*/


CONST WA_Opacity /* ISG */                    = (WA_Dummy + 168)
/* ULONG. A 32bit opacity value. Use 0xFFFFFFFF for full visibility.
** NOTES: GZZ windows are not supported */

CONST WA_HasAlpha /* ISG */                   = (WA_Dummy + 169)
/* BOOL. Set to TRUE to make the window use the alpha data of it's
** buffer as window's opacity level
** NOTES: GZZ windows are not supported */


CONST WA_SizeNumerator /* ISG */              = (WA_Dummy + 171)
CONST WA_SizeDenominator /* ISG */            = (WA_Dummy + 172)
CONST WA_SizeExtraWidth /* ISG */             = (WA_Dummy + 173)
CONST WA_SizeExtraHeight /* ISG */            = (WA_Dummy + 174)
/* ULONG. The four attributes define how the window should act when
** the user resizes it. This allows to define an aspect ratio in
** which the window will be resized. ExtraWidth/Height attributes
** specify the total size of the area which the aspect ratio resize
** should not include (toolbars, window borders, etc).
** To disable aspect resizing, set the Numerator and Denominator to 1.
** Setting aspect resize doesn't resize the window or change it's
** size limits - you have to do it yourself. */

CONST WA_HitLevel /* ISG */                   = (WA_Dummy + 175)
/* ULONG. Defines the maximum opacity value to which the window
** will not be clickable. Unlike WA_Opacity, the value is in the
** 0-255 range. WA_HitLevel,0 will make the window clickable if
** it's opacity is != 0. Use 255 to make a fully visible window
** ignore mouse clicks, hovering, etc */

CONST WA_ShadowTop    /* ISG */               = (WA_Dummy + 176)
CONST WA_ShadowLeft   /* ISG */               = (WA_Dummy + 177)
CONST WA_ShadowRight  /* ISG */               = (WA_Dummy + 178)
CONST WA_ShadowBottom /* ISG */               = (WA_Dummy + 179)
/* BOOL. Some skins might support window shadows in certain display
** modes (depending on the hardware). In such case all windows with
** a window border will be given a shadow. You can query if the
** shadow is on with those attributes (to disable your own fake shadows,
** etc). Set any of the tags above to false to disable a certain
** part of the shadow. Set any of the tags above to true to force
** shadows in a borderless window */

CONST WA_VisibleOnMaximize /* ISG */          = (WA_Dummy + 180)
/* BOOL. When maximizing windows, intuition will take the windows
** with this tag on into the account and substract them from the
** area the maximized window will cover. Do note that intuition will
** not take windows that are not touching any screen border into the
** account. You should generally let user decide if he wants this
** functionality or not */

/* window methods */
CONST WM_Dummy = WA_Dummy

CONST WM_OpenMenu                             = (WM_Dummy + 1)
/* void. Makes intuition open a menu for the window the method was
** called on. Does nothing if there is no menu or the system
** is busy. Will fail silently if the menu did not open */

CONST WM_ObtainEvents                         = (WM_Dummy + 2)
/* BOOL. Obtains the events for the screen the window is at.
** This is an equivalent of installing your own, high priority
** inputhandler to capture input events. All IDCMPs will
** be sent to your window. Clicking outside of your window
** will not send events to other windows or cause their activation.
** Intuition menus will not be opened. The mouse pointer will use
** whatever your window has set, even if your window was not
** active when you obtained the pointer. Use this solely for the
** purpose of letting user pick a window, mark some area for
** snapshoting, etc. Will return FALSE if another window
** currently owns the events or your window already owns them.
** If the method returns true, you are the pointer owner and
** MUST match the call with WM_ReleaseEvents after you are done.
** For security reasons, if your application crashes or refuses
** to reply to IDCMP messages, the event ownership might be
** silently revoked. If a new window opens or gets activated
** while you have the ownership, it will be revoked and you
** will receive an IDCMP_INACTIVEWINDOW idcmp (even if your window
** is still active or was inactive before obtaining the pointer).
** The IDCMPS that your window will actually capture are:
** IDCMP_MOUSEMOVE, IDCMP_MOUSEBUTTON, IDCMP_RAWKEY,
** IDCMP_VANILLAKEY, IDCMP_INTUITICKS */

CONST WM_ReleaseEvents                        = (WM_Dummy + 3)
/* void. Releases the events obtained with WM_ObtainEvents. You MUST
** always call it after WM_ObtainEvents returned TRUE. It is safe
** to call it in case your events ownership was revoked by the
** system */




OBJECT remember
  nextremember:PTR TO remember
  remembersize:LONG
  memory:PTR TO CHAR
ENDOBJECT     /* SIZEOF=12 */

OBJECT colorspec
  colorindex:INT
  red:WORD
  green:WORD
  blue:WORD
ENDOBJECT     /* SIZEOF=8 */

OBJECT easystruct
  structsize:LONG
  flags:LONG
  title:PTR TO CHAR
  textformat:PTR TO CHAR
  gadgetformat:PTR TO CHAR
ENDOBJECT     /* SIZEOF=20 */

#define MENUNUM(n) ((n) AND $1F)
#define ITEMNUM(n) (Shr((n),5) AND $3F)
#define SUBNUM(n)  (Shr((n),11) AND $1F)

#define SHIFTMENU(n) ((n) AND $1F)
#define SHIFTITEM(n) (Shl((n) AND $3F,5))
#define SHIFTSUB(n)  (Shl((n) AND $1F,11))

#define FULLMENUNUM(menu,item,sub) (SHIFTSUB(sub) OR SHIFTITEM(item) OR \
                                    SHIFTMENU(menu))

#define SRBNUM(n)  (8-Shr((n),4))
#define SWBNUM(n)  (8-((n) AND $F))
#define SSBNUM(n)  (1+Shr((n),4))
#define SPARNUM(n) (Shr((n),4))
#define SHAKNUM(n) ((n) AND $F)

CONST NOMENU=31,
      NOITEM=$3F,
      NOSUB=31,
      MENUNULL=$FFFF,
      CHECKWIDTH=19,
      COMMWIDTH=27,
      LOWCHECKWIDTH=13,
      LOWCOMMWIDTH=16,
      ALERT_TYPE=$80000000,
      RECOVERY_ALERT=0,
      DEADEND_ALERT=$80000000,
      AUTOFRONTPEN=0,
      AUTOBACKPEN=1,
      AUTODRAWMODE=1,
      AUTOLEFTEDGE=6,
      AUTOTOPEDGE=3,
      AUTOITEXTFONT=0,
      AUTONEXTTEXT=0,
      SELECTUP=$E8,
      SELECTDOWN=$68,
      MENUUP=$E9,
      MENUDOWN=$69,
      MIDDLEUP=$EA,
      MIDDLEDOWN=$6A,
      ALTLEFT=16,
      ALTRIGHT=$20,
      AMIGALEFT=$40,
      AMIGARIGHT=$80,
      AMIGAKEYS=$C0,
      CURSORUP=$4C,
      CURSORLEFT=$4F,
      CURSORRIGHT=$4E,
      CURSORDOWN=$4D,
      KEYCODE_Q=16,
      KEYCODE_Z=$31,
      KEYCODE_X=$32,
      KEYCODE_V=$34,
      KEYCODE_B=$35,
      KEYCODE_N=$36,
      KEYCODE_M=$37,
      KEYCODE_LESS=$38,
      KEYCODE_GREATER=$39,
      TABLETA_DUMMY=$8003A000,
      TABLETA_TABLETZ=$8003A001,  -> Data for this tag is unsigned INT
      TABLETA_RANGEZ=$8003A002,
      TABLETA_ANGLEX=$8003A003,
      TABLETA_ANGLEY=$8003A004,
      TABLETA_ANGLEZ=$8003A005,
      TABLETA_PRESSURE=$8003A006,
      TABLETA_BUTTONBITS=$8003A007,
      TABLETA_INPROXIMITY=$8003A008,
      TABLETA_RESOLUTIONX=$8003A009,
      TABLETA_RESOLUTIONY=$8003A00A

OBJECT tabletdata
  xfraction:WORD
  yfraction:WORD
  tabletx:LONG
  tablety:LONG
  rangex:LONG
  rangey:LONG
  taglist:PTR TO tagitem
ENDOBJECT     /* SIZEOF=24 */

OBJECT tablethookdata
  screen:PTR TO screen
  width:LONG
  height:LONG
  screenchanged:LONG
ENDOBJECT     /* SIZEOF=16 */
