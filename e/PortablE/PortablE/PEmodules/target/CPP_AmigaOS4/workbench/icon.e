/* $Id: icon.h,v 1.18 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/graphics/view', 'target/intuition/imageclass', 'target/utility/tagitem', 'target/datatypes/pictureclass', 'target/dos/dos'
MODULE 'target/exec/libraries', 'target/dos/anchorpath'
{#include <workbench/icon.h>}
NATIVE {WORKBENCH_ICON_H} CONST

NATIVE {ICONNAME} CONST
#define ICONNAME iconname
STATIC iconname = 'icon.library'

/****************************************************************************/

NATIVE {ICONA_Dummy}                         CONST ICONA_DUMMY                         = (TAG_USER+$9000)

/****************************************************************************/

/* Error reporting (LONG *) */
NATIVE {ICONA_ErrorCode}                     CONST ICONA_ERRORCODE                     = (ICONA_DUMMY+1)

/* Points to the tag item that caused the error (struct TagItem **). */
NATIVE {ICONA_ErrorTagItem}                  CONST ICONA_ERRORTAGITEM                  = (ICONA_DUMMY+75)

/****************************************************************************/

/* Global options for IconControlA() */

/* Screen to use for remapping Workbench icons to (struct Screen *) */
NATIVE {ICONCTRLA_SetGlobalScreen}           CONST ICONCTRLA_SETGLOBALSCREEN           = (ICONA_DUMMY+2)
NATIVE {ICONCTRLA_GetGlobalScreen}           CONST ICONCTRLA_GETGLOBALSCREEN           = (ICONA_DUMMY+3)

/* Icon color remapping precision; defaults to PRECISION_ICON (LONG) */
NATIVE {ICONCTRLA_SetGlobalPrecision}        CONST ICONCTRLA_SETGLOBALPRECISION        = (ICONA_DUMMY+4)
NATIVE {ICONCTRLA_GetGlobalPrecision}        CONST ICONCTRLA_GETGLOBALPRECISION        = (ICONA_DUMMY+5)

/* Icon frame size dimensions (struct Rectangle *) */
NATIVE {ICONCTRLA_SetGlobalEmbossRect}       CONST ICONCTRLA_SETGLOBALEMBOSSRECT       = (ICONA_DUMMY+6)
NATIVE {ICONCTRLA_GetGlobalEmbossRect}       CONST ICONCTRLA_GETGLOBALEMBOSSRECT       = (ICONA_DUMMY+7)

/* Render image without frame (BOOL) */
NATIVE {ICONCTRLA_SetGlobalFrameless}        CONST ICONCTRLA_SETGLOBALFRAMELESS        = (ICONA_DUMMY+8)
NATIVE {ICONCTRLA_GetGlobalFrameless}        CONST ICONCTRLA_GETGLOBALFRAMELESS        = (ICONA_DUMMY+9)

/* Enable NewIcons support (BOOL) */
NATIVE {ICONCTRLA_SetGlobalNewIconsSupport}  CONST ICONCTRLA_SETGLOBALNEWICONSSUPPORT  = (ICONA_DUMMY+10)
NATIVE {ICONCTRLA_GetGlobalNewIconsSupport}  CONST ICONCTRLA_GETGLOBALNEWICONSSUPPORT  = (ICONA_DUMMY+11)

/* Enable color icon support (BOOL) */
NATIVE {ICONCTRLA_SetGlobalColorIconSupport} CONST ICONCTRLA_SETGLOBALCOLORICONSUPPORT = (ICONA_DUMMY+77)
NATIVE {ICONCTRLA_GetGlobalColorIconSupport} CONST ICONCTRLA_GETGLOBALCOLORICONSUPPORT = (ICONA_DUMMY+78)

/* Set/Get the hook to be called when identifying a file (struct Hook *) */
NATIVE {ICONCTRLA_SetGlobalIdentifyHook}     CONST ICONCTRLA_SETGLOBALIDENTIFYHOOK     = (ICONA_DUMMY+12)
NATIVE {ICONCTRLA_GetGlobalIdentifyHook}     CONST ICONCTRLA_GETGLOBALIDENTIFYHOOK     = (ICONA_DUMMY+13)

/* Set/get the maximum length of a file/drawer name supported
 * by icon.library (LONG).
 */
NATIVE {ICONCTRLA_SetGlobalMaxNameLength}    CONST ICONCTRLA_SETGLOBALMAXNAMELENGTH    = (ICONA_DUMMY+67)
NATIVE {ICONCTRLA_GetGlobalMaxNameLength}    CONST ICONCTRLA_GETGLOBALMAXNAMELENGTH    = (ICONA_DUMMY+68)

/* Enable marking of left-out icons (BOOL) (V51) */
NATIVE {ICONCTRLA_SetGlobalLeftOutMarking}   CONST ICONCTRLA_SETGLOBALLEFTOUTMARKING   = (ICONA_DUMMY+96)
NATIVE {ICONCTRLA_GetGlobalLeftOutMarking}   CONST ICONCTRLA_GETGLOBALLEFTOUTMARKING   = (ICONA_DUMMY+97)

/****************************************************************************/

/* Per icon local options for IconControlA() */

/* Get the icon rendering masks (PLANEPTR) */
NATIVE {ICONCTRLA_GetImageMask1}             CONST ICONCTRLA_GETIMAGEMASK1             = (ICONA_DUMMY+14)
NATIVE {ICONCTRLA_GetImageMask2}             CONST ICONCTRLA_GETIMAGEMASK2             = (ICONA_DUMMY+15)

/* Transparent image color; set to -1 if opaque */
NATIVE {ICONCTRLA_SetTransparentColor1}      CONST ICONCTRLA_SETTRANSPARENTCOLOR1      = (ICONA_DUMMY+16)
NATIVE {ICONCTRLA_GetTransparentColor1}      CONST ICONCTRLA_GETTRANSPARENTCOLOR1      = (ICONA_DUMMY+17)
NATIVE {ICONCTRLA_SetTransparentColor2}      CONST ICONCTRLA_SETTRANSPARENTCOLOR2      = (ICONA_DUMMY+18)
NATIVE {ICONCTRLA_GetTransparentColor2}      CONST ICONCTRLA_GETTRANSPARENTCOLOR2      = (ICONA_DUMMY+19)

/* Image color palette (struct ColorRegister *) */
NATIVE {ICONCTRLA_SetPalette1}               CONST ICONCTRLA_SETPALETTE1               = (ICONA_DUMMY+20)
NATIVE {ICONCTRLA_GetPalette1}               CONST ICONCTRLA_GETPALETTE1               = (ICONA_DUMMY+21)
NATIVE {ICONCTRLA_SetPalette2}               CONST ICONCTRLA_SETPALETTE2               = (ICONA_DUMMY+22)
NATIVE {ICONCTRLA_GetPalette2}               CONST ICONCTRLA_GETPALETTE2               = (ICONA_DUMMY+23)

/* Size of image color palette (LONG) */
NATIVE {ICONCTRLA_SetPaletteSize1}           CONST ICONCTRLA_SETPALETTESIZE1           = (ICONA_DUMMY+24)
NATIVE {ICONCTRLA_GetPaletteSize1}           CONST ICONCTRLA_GETPALETTESIZE1           = (ICONA_DUMMY+25)
NATIVE {ICONCTRLA_SetPaletteSize2}           CONST ICONCTRLA_SETPALETTESIZE2           = (ICONA_DUMMY+26)
NATIVE {ICONCTRLA_GetPaletteSize2}           CONST ICONCTRLA_GETPALETTESIZE2           = (ICONA_DUMMY+27)

/* Image data; one by per pixel (UBYTE *) */
NATIVE {ICONCTRLA_SetImageData1}             CONST ICONCTRLA_SETIMAGEDATA1             = (ICONA_DUMMY+28)
NATIVE {ICONCTRLA_GetImageData1}             CONST ICONCTRLA_GETIMAGEDATA1             = (ICONA_DUMMY+29)
NATIVE {ICONCTRLA_SetImageData2}             CONST ICONCTRLA_SETIMAGEDATA2             = (ICONA_DUMMY+30)
NATIVE {ICONCTRLA_GetImageData2}             CONST ICONCTRLA_GETIMAGEDATA2             = (ICONA_DUMMY+31)

/* Render image without frame (BOOL) */
NATIVE {ICONCTRLA_SetFrameless}              CONST ICONCTRLA_SETFRAMELESS              = (ICONA_DUMMY+32)
NATIVE {ICONCTRLA_GetFrameless}              CONST ICONCTRLA_GETFRAMELESS              = (ICONA_DUMMY+33)

/* Enable NewIcons support (BOOL) */
NATIVE {ICONCTRLA_SetNewIconsSupport}        CONST ICONCTRLA_SETNEWICONSSUPPORT        = (ICONA_DUMMY+34)
NATIVE {ICONCTRLA_GetNewIconsSupport}        CONST ICONCTRLA_GETNEWICONSSUPPORT        = (ICONA_DUMMY+35)

/* Icon aspect ratio (UBYTE *) */
NATIVE {ICONCTRLA_SetAspectRatio}            CONST ICONCTRLA_SETASPECTRATIO            = (ICONA_DUMMY+36)
NATIVE {ICONCTRLA_GetAspectRatio}            CONST ICONCTRLA_GETASPECTRATIO            = (ICONA_DUMMY+37)

/* Icon dimensions; valid only for palette mapped icon images (LONG) */
NATIVE {ICONCTRLA_SetWidth}                  CONST ICONCTRLA_SETWIDTH                  = (ICONA_DUMMY+38)
NATIVE {ICONCTRLA_GetWidth}                  CONST ICONCTRLA_GETWIDTH                  = (ICONA_DUMMY+39)
NATIVE {ICONCTRLA_SetHeight}                 CONST ICONCTRLA_SETHEIGHT                 = (ICONA_DUMMY+40)
NATIVE {ICONCTRLA_GetHeight}                 CONST ICONCTRLA_GETHEIGHT                 = (ICONA_DUMMY+41)

/* Check whether the icon is palette mapped (LONG *). */
NATIVE {ICONCTRLA_IsPaletteMapped}           CONST ICONCTRLA_ISPALETTEMAPPED           = (ICONA_DUMMY+42)

/* Get the screen the icon is attached to (struct Screen **). */
NATIVE {ICONCTRLA_GetScreen}                 CONST ICONCTRLA_GETSCREEN                 = (ICONA_DUMMY+43)

/* Check whether the icon has a real select image (LONG *). */
NATIVE {ICONCTRLA_HasRealImage2}             CONST ICONCTRLA_HASREALIMAGE2             = (ICONA_DUMMY+44)

/* Check whether the icon is of the NewIcon type (LONG *). */
NATIVE {ICONCTRLA_IsNewIcon}                 CONST ICONCTRLA_ISNEWICON                 = (ICONA_DUMMY+79)

/* Check whether this icon was allocated by icon.library
 * or if consists solely of a statically allocated
 * struct DiskObject. (LONG *).
 */
NATIVE {ICONCTRLA_IsNativeIcon}              CONST ICONCTRLA_ISNATIVEICON              = (ICONA_DUMMY+80)

/* Alias for ICONGETA_UseFriendBitMap (BOOL). V50 */
NATIVE {ICONCTRLA_UseFriendBitMap}           CONST

/* Get the bitmaps of the icon (struct BitMap *). Can be
 * NULL, only valid after an icon has been layouted. V50
 */
NATIVE {ICONCTRLA_GetBitMap1}                CONST ICONCTRLA_GETBITMAP1                = (ICONA_DUMMY+91)
NATIVE {ICONCTRLA_GetBitMap2}                CONST ICONCTRLA_GETBITMAP2                = (ICONA_DUMMY+92)

/****************************************************************************/

/* Icon aspect ratio is not known. */
NATIVE {ICON_ASPECT_RATIO_UNKNOWN} CONST ICON_ASPECT_RATIO_UNKNOWN = (0)

/* Pack the aspect ratio into a single byte. */
NATIVE {PACK_ICON_ASPECT_RATIO} CONST	->PACK_ICON_ASPECT_RATIO(num,den) (((num) << 4) | (den))

/* Unpack the aspect ratio stored in a single byte. */
NATIVE {UNPACK_ICON_ASPECT_RATIO} CONST	->UNPACK_ICON_ASPECT_RATIO(v,num,den) do { num = (((v) >> 4) & 15); den = ( (v) & 15); } while(0)

/****************************************************************************/

/* Tags for use with GetIconTagList() */

/* Default icon type to retrieve (LONG) */
NATIVE {ICONGETA_GetDefaultType}             CONST ICONGETA_GETDEFAULTTYPE             = (ICONA_DUMMY+45)

/* Retrieve default icon for the given name (STRPTR) */
NATIVE {ICONGETA_GetDefaultName}             CONST ICONGETA_GETDEFAULTNAME             = (ICONA_DUMMY+46)

/* Return a default icon if the requested icon
 * file cannot be found (BOOL).
 */
NATIVE {ICONGETA_FailIfUnavailable}          CONST ICONGETA_FAILIFUNAVAILABLE          = (ICONA_DUMMY+47)

/* If possible, retrieve a palette mapped icon (BOOL). */
NATIVE {ICONGETA_GetPaletteMappedIcon}       CONST ICONGETA_GETPALETTEMAPPEDICON       = (ICONA_DUMMY+48)

/* Set if the icon returned is a default icon (BOOL *). */
NATIVE {ICONGETA_IsDefaultIcon}              CONST ICONGETA_ISDEFAULTICON              = (ICONA_DUMMY+49)

/* Remap the icon to the default screen, if possible (BOOL). */
NATIVE {ICONGETA_RemapIcon}                  CONST ICONGETA_REMAPICON                  = (ICONA_DUMMY+50)

/* Generate icon image masks (BOOL). */
NATIVE {ICONGETA_GenerateImageMasks}         CONST ICONGETA_GENERATEIMAGEMASKS         = (ICONA_DUMMY+51)

/* Label text to be assigned to the icon (STRPTR). */
NATIVE {ICONGETA_Label}                      CONST ICONGETA_LABEL                      = (ICONA_DUMMY+52)

/* Screen to remap the icon to (struct Screen *). */
NATIVE {ICONGETA_Screen}                     CONST ICONGETA_SCREEN                     = (ICONA_DUMMY+69)

/* Allocate a bitmap for the icon images instead of
 * the traditional planar icon images (BOOL). (V50)
 */
NATIVE {ICONGETA_UseFriendBitMap}            CONST ICONGETA_USEFRIENDBITMAP            = (ICONA_DUMMY+90)

/****************************************************************************/

/* Tags for use with PutIconTagList() */

/* Notify Workbench of the icon being written (BOOL) */
NATIVE {ICONPUTA_NotifyWorkbench}            CONST ICONPUTA_NOTIFYWORKBENCH            = (ICONA_DUMMY+53)

/* Store icon as the default for this type (LONG) */
NATIVE {ICONPUTA_PutDefaultType}             CONST ICONPUTA_PUTDEFAULTTYPE             = (ICONA_DUMMY+54)

/* Store icon as a default for the given name (STRPTR) */
NATIVE {ICONPUTA_PutDefaultName}             CONST ICONPUTA_PUTDEFAULTNAME             = (ICONA_DUMMY+55)

/* When storing a palette mapped icon, don't save the
 * the original planar icon image with the file. Replace
 * it with a tiny replacement image.
 */
NATIVE {ICONPUTA_DropPlanarIconImage}        CONST ICONPUTA_DROPPLANARICONIMAGE        = (ICONA_DUMMY+56)

/* Don't write the chunky icon image data to disk. */
NATIVE {ICONPUTA_DropChunkyIconImage}        CONST ICONPUTA_DROPCHUNKYICONIMAGE        = (ICONA_DUMMY+57)

/* Don't write the NewIcons tool types to disk. */
NATIVE {ICONPUTA_DropNewIconToolTypes}       CONST ICONPUTA_DROPNEWICONTOOLTYPES       = (ICONA_DUMMY+58)

/* If this tag is enabled, the writer will examine the
 * icon image data to find out whether it can compress
 * it more efficiently. This may take extra time and
 * is not generally recommended.
 */
NATIVE {ICONPUTA_OptimizeImageSpace}         CONST ICONPUTA_OPTIMIZEIMAGESPACE         = (ICONA_DUMMY+59)

/* Don't write the entire icon file back to disk,
 * only change the do->do_CurrentX/do->do_CurrentY
 * members.
 */
NATIVE {ICONPUTA_OnlyUpdatePosition}         CONST ICONPUTA_ONLYUPDATEPOSITION         = (ICONA_DUMMY+72)

/* Before writing a palette mapped icon back to disk,
 * icon.library will make sure that the original
 * planar image data is stored in the file. If you
 * don't want that to happen, set this option to
 * FALSE. This will allow you to change the planar icon
 * image data written back to disk.
 */
NATIVE {ICONPUTA_PreserveOldIconImages}      CONST ICONPUTA_PRESERVEOLDICONIMAGES      = (ICONA_DUMMY+84)

/****************************************************************************/

/* For use with the file identification hook. */

NATIVE {IconIdentifyMsg} OBJECT iconidentifymsg
    /* Libraries that are already opened for your use. */
    {iim_SysBase}	sysbase	:PTR TO lib
    {iim_DOSBase}	dosbase	:PTR TO lib
    {iim_UtilityBase}	utilitybase	:PTR TO lib
    {iim_IconBase}	iconbase	:PTR TO lib

    /* File context information. */
    {iim_FileLock}	filelock	:BPTR   /* Lock on the object to return an
                                            * icon for. */
    {iim_ParentLock}	parentlock	:BPTR /* Lock on the object's parent
                                            * directory, if available. */
    {iim_FIB}	fib	:PTR TO fileinfoblock        /* Already initialized for you. */
    {iim_FileHandle}	filehandle	:BPTR /* If non-NULL, pointer to the file
                                            * to examine, positioned right at
                                            * the first byte, ready for you
                                            * to use.
                                            */
    {iim_Tags}	tags	:ARRAY OF tagitem       /* Tags passed to
                                            * GetIconTagList().
                                            */
->#ifdef __amigaos4__
    {iim_IExec}	iexec	:NATIVE {struct ExecIFace*} PTR
    {iim_IDOS}	idos	:NATIVE {struct DOSIFace*} PTR
    {iim_IUtility}	iutility	:NATIVE {struct UtilityIFace*} PTR
    {iim_IIcon}	iicon	:NATIVE {struct IconIFace*} PTR
->#endif
ENDOBJECT

/****************************************************************************/

/* Tags for use with DupDiskObjectA() */

/* Duplicate do_DrawerData */
NATIVE {ICONDUPA_DuplicateDrawerData}        CONST ICONDUPA_DUPLICATEDRAWERDATA        = (ICONA_DUMMY+60)

/* Duplicate the Image structures. */
NATIVE {ICONDUPA_DuplicateImages}            CONST ICONDUPA_DUPLICATEIMAGES            = (ICONA_DUMMY+61)

/* Duplicate the image data (Image->ImageData) itself. */
NATIVE {ICONDUPA_DuplicateImageData}         CONST ICONDUPA_DUPLICATEIMAGEDATA         = (ICONA_DUMMY+62)

/* Duplicate the default tool. */
NATIVE {ICONDUPA_DuplicateDefaultTool}       CONST ICONDUPA_DUPLICATEDEFAULTTOOL       = (ICONA_DUMMY+63)

/* Duplicate the tool types list. */
NATIVE {ICONDUPA_DuplicateToolTypes}         CONST ICONDUPA_DUPLICATETOOLTYPES         = (ICONA_DUMMY+64)

/* Duplicate the tool window. */
NATIVE {ICONDUPA_DuplicateToolWindow}        CONST ICONDUPA_DUPLICATETOOLWINDOW        = (ICONA_DUMMY+65)

/* If the icon to be duplicated is in fact a palette mapped
 * icon which has never been set up to be displayed on the
 * screen, turn the duplicate into that palette mapped icon.
 */
NATIVE {ICONDUPA_ActivateImageData}          CONST ICONDUPA_ACTIVATEIMAGEDATA          = (ICONA_DUMMY+82)

/* Alias for ICONGETA_UseFriendBitMap (BOOL). V50 */
NATIVE {ICONDUPA_UseFriendBitMap}            CONST

/****************************************************************************/

/* Tags for use with LayoutIconA() */

/* Alias for ICONGETA_UseFriendBitMap (BOOL). V50 */
NATIVE {ICONLAYA_UseFriendBitMap}            CONST

/****************************************************************************/

/* Tags for use with DrawIconStateA() and GetIconRectangleA(). */

/* Drawing information to use (struct DrawInfo *). */
NATIVE {ICONDRAWA_DrawInfo}                  CONST ICONDRAWA_DRAWINFO                  = (ICONA_DUMMY+66)

/* Draw the icon without the surrounding frame (BOOL). */
NATIVE {ICONDRAWA_Frameless}                 CONST ICONDRAWA_FRAMELESS                 = (ICONA_DUMMY+70)

/* Erase the background before drawing a frameless icon (BOOL). */
NATIVE {ICONDRAWA_EraseBackground}           CONST ICONDRAWA_ERASEBACKGROUND           = (ICONA_DUMMY+71)

/* Draw the icon without the surrounding border and frame (BOOL). */
NATIVE {ICONDRAWA_Borderless}                CONST ICONDRAWA_BORDERLESS                = (ICONA_DUMMY+83)

/* The icon to be drawn refers to a linked object (BOOL). */
NATIVE {ICONDRAWA_IsLink}                    CONST ICONDRAWA_ISLINK                    = (ICONA_DUMMY+89)

/* Draw the icon label with shadow (BOOL). V50.
 */
NATIVE {ICONDRAWA_LabelShadow}               CONST ICONDRAWA_LABELSHADOW               = (ICONA_DUMMY+93)

/* Draw the icon label with outline (BOOL). V50.
 */
NATIVE {ICONDRAWA_LabelOutline}              CONST ICONDRAWA_LABELOUTLINE              = (ICONA_DUMMY+94)

/* Special properties of the icon to be drawn (ULONG). V51. */
NATIVE {ICONDRAWA_Properties}                CONST ICONDRAWA_PROPERTIES                = (ICONA_DUMMY+95)

/* Draw the actual icon image (BOOL). V51. */
NATIVE {ICONDRAWA_DrawIcon}                  CONST ICONDRAWA_DRAWICON                  = (ICONA_DUMMY+98)

/* Erase the background before drawing an icon label (BOOL). V51. */
NATIVE {ICONDRAWA_EraseLabelBackground}      CONST ICONDRAWA_ERASELABELBACKGROUND      = (ICONA_DUMMY+101)

/* Override the transparency value which is used for drawing the
 * icon image in range from 0 to 255 (opaque) (LONG). V51. */
NATIVE {ICONDRAWA_Transparency}              CONST ICONDRAWA_TRANSPARENCY              = (ICONA_DUMMY+102)

/****************************************************************************/

/* Property flags for ICONDRAWA_Properties */

NATIVE {ICON_DRAGGED}   CONST ICON_DRAGGED   = $00000001  /* Icon is being dragged       */
NATIVE {ICON_DROPPABLE} CONST ICON_DROPPABLE = $00000002  /* Icon is over a drop area    */
NATIVE {ICON_LEFTOUT}   CONST ICON_LEFTOUT   = $00000004  /* Icon has been "left out"    */
NATIVE {ICON_POINTED}   CONST ICON_POINTED   = $00000008  /* Icon is under mouse pointer */

/****************************************************************************/

/* Reserved tags; don't use! */
NATIVE {ICONA_Reserved1}                     CONST ICONA_RESERVED1                     = (ICONA_DUMMY+73)
NATIVE {ICONA_Reserved2}                     CONST ICONA_RESERVED2                     = (ICONA_DUMMY+74)
NATIVE {ICONA_Reserved3}                     CONST ICONA_RESERVED3                     = (ICONA_DUMMY+76)
NATIVE {ICONA_Reserved4}                     CONST ICONA_RESERVED4                     = (ICONA_DUMMY+81)
NATIVE {ICONA_Reserved5}                     CONST ICONA_RESERVED5                     = (ICONA_DUMMY+85)
NATIVE {ICONA_Reserved6}                     CONST ICONA_RESERVED6                     = (ICONA_DUMMY+86)
NATIVE {ICONA_Reserved7}                     CONST ICONA_RESERVED7                     = (ICONA_DUMMY+87)
NATIVE {ICONA_Reserved8}                     CONST ICONA_RESERVED8                     = (ICONA_DUMMY+88)
NATIVE {ICONA_Reserved9}                     CONST ICONA_RESERVED9                     = (ICONA_DUMMY+99)
NATIVE {ICONA_Reserved10}                    CONST ICONA_RESERVED10                    = (ICONA_DUMMY+100)

/****************************************************************************/

NATIVE {ICONA_LAST_TAG}                      CONST ICONA_LAST_TAG                      = (ICONA_DUMMY+101)
