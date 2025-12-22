/*****************************************************************************

 Images

 *****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem', 'intuition/screens'

-> RenderImage() tags
CONST IM_Width          = TAG_USER + 0    -> Width of image
CONST IM_Height         = TAG_USER + 1    -> Height of image
CONST IM_State          = TAG_USER + 2    -> 1 = selected, 0 = normal (default)
CONST IM_Rectangle      = TAG_USER + 3    -> Rectangle to center within
CONST IM_Mask           = TAG_USER + 4    -> 1 = mask image
CONST IM_Depth          = TAG_USER + 5    -> Depth of image
CONST IM_ClipBoundary   = TAG_USER + 6    -> Clip boundary size
CONST IM_Erase          = TAG_USER + 7    -> Erase background
CONST IM_NoDrawInvalid  = TAG_USER + 8    -> Don't draw if image is invalid
CONST IM_NoIconRemap    = TAG_USER + 9    -> Don't remap icons

-> Images remapping
OBJECT imageRemap
    screen:PTR TO screen
    penArray:PTR TO INT
    penCount:INT
    flags:LONG
ENDOBJECT

SET IRF_REMAP_COL0,         -> Remap colour 0
    IRF_PRECISION_EXACT,    -> Remap precision
    IRF_PRECISION_ICON,
    IRF_PRECISION_GUI

-> Open an image in memory (for remapping)
OBJECT openImageInfo
    imageData:PTR TO INT
    palette:PTR TO LONG
    width:INT
    height:INT
    depth:INT
ENDOBJECT
