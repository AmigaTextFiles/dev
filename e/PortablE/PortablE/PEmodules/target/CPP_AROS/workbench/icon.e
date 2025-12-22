OPT NATIVE, PREPROCESS
MODULE 'target/graphics/view', 'target/intuition/imageclass', 'target/utility/tagitem', 'target/datatypes/pictureclass', 'target/dos/dos'
MODULE 'target/exec/libraries'
{#include <workbench/icon.h>}
NATIVE {WORKBENCH_ICON_H} CONST

/*** Icon library name ******************************************************/
NATIVE {ICONNAME} CONST
#define ICONNAME iconname
STATIC iconname = 'icon.library'

/*** Start of icon.library tags *********************************************/
NATIVE {ICONA_BASE}                          CONST ICONA_BASE                          = (TAG_USER+$9000)

/*** Error reporting ********************************************************/
/* Errorcode (LONG *) */
NATIVE {ICONA_ErrorCode}                      CONST ICONA_ERRORCODE                      = (ICONA_BASE+1)

/* Points to the tag item that caused the error (struct TagItem **). */
NATIVE {ICONA_ErrorTagItem}                   CONST ICONA_ERRORTAGITEM                   = (ICONA_BASE+75)

/*** Global options for IconControlA() **************************************/
/* Screen to use for remapping icons to (struct Screen *) */
NATIVE {ICONCTRLA_SetGlobalScreen}            CONST ICONCTRLA_SETGLOBALSCREEN            = (ICONA_BASE+2)
NATIVE {ICONCTRLA_GetGlobalScreen}            CONST ICONCTRLA_GETGLOBALSCREEN            = (ICONA_BASE+3)

/* Icon color remapping precision, default is PRECISION_ICON (LONG) */
NATIVE {ICONCTRLA_SetGlobalPrecision}         CONST ICONCTRLA_SETGLOBALPRECISION         = (ICONA_BASE+4)
NATIVE {ICONCTRLA_GetGlobalPrecision}         CONST ICONCTRLA_GETGLOBALPRECISION         = (ICONA_BASE+5)

/* Icon frame size dimensions (struct Rectangle *) */
NATIVE {ICONCTRLA_SetGlobalEmbossRect}        CONST ICONCTRLA_SETGLOBALEMBOSSRECT        = (ICONA_BASE+6)
NATIVE {ICONCTRLA_GetGlobalEmbossRect}        CONST ICONCTRLA_GETGLOBALEMBOSSRECT        = (ICONA_BASE+7)

/* Render image without frame (BOOL) */
NATIVE {ICONCTRLA_SetGlobalFrameless}         CONST ICONCTRLA_SETGLOBALFRAMELESS         = (ICONA_BASE+8)
NATIVE {ICONCTRLA_GetGlobalFrameless}         CONST ICONCTRLA_GETGLOBALFRAMELESS         = (ICONA_BASE+9)

/* Enable NewIcons support (BOOL) */
NATIVE {ICONCTRLA_SetGlobalNewIconsSupport}   CONST ICONCTRLA_SETGLOBALNEWICONSSUPPORT   = (ICONA_BASE+10)
NATIVE {ICONCTRLA_GetGlobalNewIconsSupport}   CONST ICONCTRLA_GETGLOBALNEWICONSSUPPORT   = (ICONA_BASE+11)

/* Enable color icon support (BOOL) */
NATIVE {ICONCTRLA_SetGlobalColorIconSupport}  CONST ICONCTRLA_SETGLOBALCOLORICONSUPPORT  = (ICONA_BASE+77)
NATIVE {ICONCTRLA_GetGlobalColorIconSupport}  CONST ICONCTRLA_GETGLOBALCOLORICONSUPPORT  = (ICONA_BASE+78)

/* Set/Get the hook to be called when identifying a file (struct Hook *) */
NATIVE {ICONCTRLA_SetGlobalIdentifyHook}      CONST ICONCTRLA_SETGLOBALIDENTIFYHOOK      = (ICONA_BASE+12)
NATIVE {ICONCTRLA_GetGlobalIdentifyHook}      CONST ICONCTRLA_GETGLOBALIDENTIFYHOOK      = (ICONA_BASE+13)

/* Maximum length of a file/drawer name supported by icon.library (LONG) */
NATIVE {ICONCTRLA_SetGlobalMaxNameLength}     CONST ICONCTRLA_SETGLOBALMAXNAMELENGTH     = (ICONA_BASE+67)
NATIVE {ICONCTRLA_GetGlobalMaxNameLength}     CONST ICONCTRLA_GETGLOBALMAXNAMELENGTH     = (ICONA_BASE+68)

/*** Per icon local options for IconControlA() ******************************/
/* Get the icon rendering masks (PLANEPTR) */
NATIVE {ICONCTRLA_GetImageMask1}         CONST ICONCTRLA_GETIMAGEMASK1         = (ICONA_BASE+14)
NATIVE {ICONCTRLA_GetImageMask2}         CONST ICONCTRLA_GETIMAGEMASK2         = (ICONA_BASE+15)

/* Transparent image color, set to -1 if opaque */
NATIVE {ICONCTRLA_SetTransparentColor1}  CONST ICONCTRLA_SETTRANSPARENTCOLOR1  = (ICONA_BASE+16)
NATIVE {ICONCTRLA_GetTransparentColor1}  CONST ICONCTRLA_GETTRANSPARENTCOLOR1  = (ICONA_BASE+17)
NATIVE {ICONCTRLA_SetTransparentColor2}  CONST ICONCTRLA_SETTRANSPARENTCOLOR2  = (ICONA_BASE+18)
NATIVE {ICONCTRLA_GetTransparentColor2}  CONST ICONCTRLA_GETTRANSPARENTCOLOR2  = (ICONA_BASE+19)

/* Image color palette (struct ColorRegister *) */
NATIVE {ICONCTRLA_SetPalette1}           CONST ICONCTRLA_SETPALETTE1           = (ICONA_BASE+20)
NATIVE {ICONCTRLA_GetPalette1}           CONST ICONCTRLA_GETPALETTE1           = (ICONA_BASE+21)
NATIVE {ICONCTRLA_SetPalette2}           CONST ICONCTRLA_SETPALETTE2           = (ICONA_BASE+22)
NATIVE {ICONCTRLA_GetPalette2}           CONST ICONCTRLA_GETPALETTE2           = (ICONA_BASE+23)

/* Size of image color palette (LONG) */
NATIVE {ICONCTRLA_SetPaletteSize1}       CONST ICONCTRLA_SETPALETTESIZE1       = (ICONA_BASE+24)
NATIVE {ICONCTRLA_GetPaletteSize1}       CONST ICONCTRLA_GETPALETTESIZE1       = (ICONA_BASE+25)
NATIVE {ICONCTRLA_SetPaletteSize2}       CONST ICONCTRLA_SETPALETTESIZE2       = (ICONA_BASE+26)
NATIVE {ICONCTRLA_GetPaletteSize2}       CONST ICONCTRLA_GETPALETTESIZE2       = (ICONA_BASE+27)

/* Image data; one by per pixel (UBYTE *) */
NATIVE {ICONCTRLA_SetImageData1}         CONST ICONCTRLA_SETIMAGEDATA1         = (ICONA_BASE+28)
NATIVE {ICONCTRLA_GetImageData1}         CONST ICONCTRLA_GETIMAGEDATA1         = (ICONA_BASE+29)
NATIVE {ICONCTRLA_SetImageData2}         CONST ICONCTRLA_SETIMAGEDATA2         = (ICONA_BASE+30)
NATIVE {ICONCTRLA_GetImageData2}         CONST ICONCTRLA_GETIMAGEDATA2         = (ICONA_BASE+31)

/* Render image without frame (BOOL) */
NATIVE {ICONCTRLA_SetFrameless}          CONST ICONCTRLA_SETFRAMELESS          = (ICONA_BASE+32)
NATIVE {ICONCTRLA_GetFrameless}          CONST ICONCTRLA_GETFRAMELESS          = (ICONA_BASE+33)

/* Enable NewIcons support (BOOL) */
NATIVE {ICONCTRLA_SetNewIconsSupport}    CONST ICONCTRLA_SETNEWICONSSUPPORT    = (ICONA_BASE+34)
NATIVE {ICONCTRLA_GetNewIconsSupport}    CONST ICONCTRLA_GETNEWICONSSUPPORT    = (ICONA_BASE+35)

/* Icon aspect ratio (UBYTE *) */
NATIVE {ICONCTRLA_SetAspectRatio}        CONST ICONCTRLA_SETASPECTRATIO        = (ICONA_BASE+36)
NATIVE {ICONCTRLA_GetAspectRatio}        CONST ICONCTRLA_GETASPECTRATIO        = (ICONA_BASE+37)

/* Icon dimensions, valid only for palette mapped icon images (LONG) */
NATIVE {ICONCTRLA_SetWidth}              CONST ICONCTRLA_SETWIDTH              = (ICONA_BASE+38)
NATIVE {ICONCTRLA_GetWidth}              CONST ICONCTRLA_GETWIDTH              = (ICONA_BASE+39)
NATIVE {ICONCTRLA_SetHeight}             CONST ICONCTRLA_SETHEIGHT             = (ICONA_BASE+40)
NATIVE {ICONCTRLA_GetHeight}             CONST ICONCTRLA_GETHEIGHT             = (ICONA_BASE+41)

/* Check whether the icon is palette mapped (LONG *) */
NATIVE {ICONCTRLA_IsPaletteMapped}       CONST ICONCTRLA_ISPALETTEMAPPED       = (ICONA_BASE+42)

/* Get the screen the icon is attached to (struct Screen **) */
NATIVE {ICONCTRLA_GetScreen}             CONST ICONCTRLA_GETSCREEN             = (ICONA_BASE+43)

/* Check whether the icon has a real select image (LONG *) */
NATIVE {ICONCTRLA_HasRealImage2}         CONST ICONCTRLA_HASREALIMAGE2         = (ICONA_BASE+44)

/* Check whether the icon is of the NewIcon type (LONG *) */
NATIVE {ICONCTRLA_IsNewIcon}             CONST ICONCTRLA_ISNEWICON             = (ICONA_BASE+79)

/* Image data: In RECTFMT_ARGB32 format (ULONG **) */
NATIVE {ICONCTRLA_GetARGBImageData1} 	CONST ICONCTRLA_GETARGBIMAGEDATA1 	= (ICONA_BASE+301)
NATIVE {ICONCTRLA_GetARGBImageData2} 	CONST ICONCTRLA_GETARGBIMAGEDATA2 	= (ICONA_BASE+303)

/*
    Check if this icon was allocated by icon.library or if it consists
    solely of a statically allocated DiskObject. (LONG *)
*/
NATIVE {ICONCTRLA_IsNativeIcon}          CONST ICONCTRLA_ISNATIVEICON          = (ICONA_BASE+80)

/*** Icon aspect handling ***************************************************/
/* Icon aspect ratio is not known */
NATIVE {ICON_ASPECT_RATIO_UNKNOWN} CONST ICON_ASPECT_RATIO_UNKNOWN = (0)

/* Pack the aspect ratio into a single byte */
NATIVE {PACK_ICON_ASPECT_RATIO} CONST	->PACK_ICON_ASPECT_RATIO(num,den) (((num) << 4) | (den))

/* Unpack the aspect ratio stored in a single byte */
NATIVE {UNPACK_ICON_ASPECT_RATIO} CONST	->UNPACK_ICON_ASPECT_RATIO(v,num,den) do { num     = (((v) >> 4) & 15); den     = ( (v)       & 15); } while(0)

/*** Tags for use with GetIconTagList() *************************************/
/* Default icon type to retrieve (LONG) */
NATIVE {ICONGETA_GetDefaultType}         CONST ICONGETA_GETDEFAULTTYPE         = (ICONA_BASE+45)

/* Retrieve default icon for the given name (STRPTR) */
NATIVE {ICONGETA_GetDefaultName}         CONST ICONGETA_GETDEFAULTNAME         = (ICONA_BASE+46)

/* Return default icon if the requested icon file cannot be found (BOOL) */
NATIVE {ICONGETA_FailIfUnavailable}      CONST ICONGETA_FAILIFUNAVAILABLE      = (ICONA_BASE+47)

/* If possible, retrieve a palette mapped icon (BOOL) */
NATIVE {ICONGETA_GetPaletteMappedIcon}   CONST ICONGETA_GETPALETTEMAPPEDICON   = (ICONA_BASE+48)

/* Set if the icon returned is a default icon (LONG *) */
NATIVE {ICONGETA_IsDefaultIcon}          CONST ICONGETA_ISDEFAULTICON          = (ICONA_BASE+49)

/* Remap the icon to the default screen, if possible (BOOL) */
NATIVE {ICONGETA_RemapIcon}              CONST ICONGETA_REMAPICON              = (ICONA_BASE+50)

/* Generate icon image masks (BOOL) */
NATIVE {ICONGETA_GenerateImageMasks}     CONST ICONGETA_GENERATEIMAGEMASKS     = (ICONA_BASE+51)

/* Label text to be assigned to the icon (STRPTR) */
NATIVE {ICONGETA_Label}                  CONST ICONGETA_LABEL                  = (ICONA_BASE+52)

/* Screen to remap the icon to (struct Screen *) */
NATIVE {ICONGETA_Screen}                 CONST ICONGETA_SCREEN                 = (ICONA_BASE+69)

/*** Tags for use with PutIconTagList() *************************************/
/* Notify Workbench of the icon being written (BOOL) */
NATIVE {ICONPUTA_NotifyWorkbench}        CONST ICONPUTA_NOTIFYWORKBENCH        = (ICONA_BASE+53)

/* Store icon as the default for this type (LONG) */
NATIVE {ICONPUTA_PutDefaultType}         CONST ICONPUTA_PUTDEFAULTTYPE         = (ICONA_BASE+54)

/* Store icon as a default for the given name (STRPTR) */
NATIVE {ICONPUTA_PutDefaultName}         CONST ICONPUTA_PUTDEFAULTNAME         = (ICONA_BASE+55)

/* 
    Don't save the the original planar image with the file if writing a 
    palette mapped icon.  Replace it with a tiny replacement image.
*/
NATIVE {ICONPUTA_DropPlanarIconImage}    CONST ICONPUTA_DROPPLANARICONIMAGE    = (ICONA_BASE+56)

/* Don't write the chunky icon image data to disk */
NATIVE {ICONPUTA_DropChunkyIconImage}    CONST ICONPUTA_DROPCHUNKYICONIMAGE    = (ICONA_BASE+57)

/* Don't write the NewIcons tool types to disk */
NATIVE {ICONPUTA_DropNewIconToolTypes}   CONST ICONPUTA_DROPNEWICONTOOLTYPES   = (ICONA_BASE+58)

/* Try to compress the image data more efficiently. */
NATIVE {ICONPUTA_OptimizeImageSpace}     CONST ICONPUTA_OPTIMIZEIMAGESPACE     = (ICONA_BASE+59)

/* 
    Don't write the entire icon file back to disk, only change 
    do->do_CurrentX / do->do_CurrentY.
*/
NATIVE {ICONPUTA_OnlyUpdatePosition}     CONST ICONPUTA_ONLYUPDATEPOSITION     = (ICONA_BASE+72)

/* 
    Preserve the original planar image data when writing a pelette mapped 
    icon to disk (BOOL). 
*/
NATIVE {ICONPUTA_PreserveOldIconImages}  CONST ICONPUTA_PRESERVEOLDICONIMAGES  = (ICONA_BASE+84)

/*** For use with the file identification hook ******************************/
NATIVE {IconIdentifyMsg} OBJECT iconidentifymsg
        /* Libraries that are already opened. */
        {iim_SysBase}	sysbase	:PTR TO lib
        {iim_DOSBase}	dosbase	:PTR TO lib
        {iim_UtilityBase}	utilitybase	:PTR TO lib
        {iim_IconBase}	iconbase	:PTR TO lib

        /* File context information. */
        {iim_FileLock}	filelock	:BPTR   /* Lock on the object to return an icon for. */
        {iim_ParentLock}	parentlock	:BPTR /* Lock on the object's parent directory, if available. */
        {iim_FIB}	fib	:PTR TO fileinfoblock        /* Already initialized. */
        {iim_FileHandle}	filehandle	:BPTR /* Pointer to the file to examine,
                                                 * positioned right at the first byte.
                                                 * May be NULL.
                                                 */
        {iim_Tags}	tags	:NATIVE {const struct TagItem*} ARRAY OF tagitem       /* Tags passed to GetIconTagList(). */
ENDOBJECT

/*** Tags for use with DupDiskObjectA() *************************************/
/* Duplicate do_DrawerData */
NATIVE {ICONDUPA_DuplicateDrawerData}    CONST ICONDUPA_DUPLICATEDRAWERDATA    = (ICONA_BASE+60)

/* Duplicate the Image structures. */
NATIVE {ICONDUPA_DuplicateImages}        CONST ICONDUPA_DUPLICATEIMAGES        = (ICONA_BASE+61)

/* Duplicate the image data (Image->ImageData) itself. */
NATIVE {ICONDUPA_DuplicateImageData}     CONST ICONDUPA_DUPLICATEIMAGEDATA     = (ICONA_BASE+62)

/* Duplicate the default tool. */
NATIVE {ICONDUPA_DuplicateDefaultTool}   CONST ICONDUPA_DUPLICATEDEFAULTTOOL   = (ICONA_BASE+63)

/* Duplicate the tool types list. */
NATIVE {ICONDUPA_DuplicateToolTypes}     CONST ICONDUPA_DUPLICATETOOLTYPES     = (ICONA_BASE+64)

/* Duplicate the tool window. */
NATIVE {ICONDUPA_DuplicateToolWindow}    CONST ICONDUPA_DUPLICATETOOLWINDOW    = (ICONA_BASE+65)

/* 
    If the icon to be duplicated is in fact a palette mapped icon which has 
    never been set up to be displayed on the screen, turn the duplicate into 
    that palette mapped icon.
 */
NATIVE {ICONDUPA_ActivateImageData}      CONST ICONDUPA_ACTIVATEIMAGEDATA      = (ICONA_BASE+82)

/*** Tags for use with DrawIconStateA() and GetIconRectangleA() *************/
/* Drawing information to use (struct DrawInfo *) */
NATIVE {ICONDRAWA_DrawInfo}              CONST ICONDRAWA_DRAWINFO              = (ICONA_BASE+66)

/* Draw the icon without the surrounding frame (BOOL) */
NATIVE {ICONDRAWA_Frameless}             CONST ICONDRAWA_FRAMELESS             = (ICONA_BASE+70)

/* Erase the background before drawing a frameless icon (BOOL) */
NATIVE {ICONDRAWA_EraseBackground}       CONST ICONDRAWA_ERASEBACKGROUND       = (ICONA_BASE+71)

/* Draw the icon without the surrounding border and frame (BOOL) */
NATIVE {ICONDRAWA_Borderless}            CONST ICONDRAWA_BORDERLESS            = (ICONA_BASE+83)

/*** Reserved tags **********************************************************/
NATIVE {ICONA_Reserved1}                 CONST ICONA_RESERVED1                 = (ICONA_BASE+73)
NATIVE {ICONA_Reserved2}                 CONST ICONA_RESERVED2                 = (ICONA_BASE+74)
NATIVE {ICONA_Reserved3}                 CONST ICONA_RESERVED3                 = (ICONA_BASE+76)
NATIVE {ICONA_Reserved4}                 CONST ICONA_RESERVED4                 = (ICONA_BASE+81)
NATIVE {ICONA_Reserved5}                 CONST ICONA_RESERVED5                 = (ICONA_BASE+85)
NATIVE {ICONA_Reserved6}                 CONST ICONA_RESERVED6                 = (ICONA_BASE+86)
NATIVE {ICONA_Reserved7}                 CONST ICONA_RESERVED7                 = (ICONA_BASE+87)
NATIVE {ICONA_Reserved8}                 CONST ICONA_RESERVED8                 = (ICONA_BASE+88)

/*** Last tag ***************************************************************/
NATIVE {ICONA_LAST_TAG}                  CONST ICONA_LAST_TAG                  = (ICONA_BASE+88)
