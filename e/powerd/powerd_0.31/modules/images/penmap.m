CONST PENMAP_Dummy=$85018000,
 PENMAP_SelectBGPen=(PENMAP_Dummy + 1),
 PENMAP_SelectData=(PENMAP_Dummy + 2),
 PENMAP_RenderBGPen=$80020006,
 PENMAP_RenderData=$80020007,
 PENMAP_Palette=(PENMAP_Dummy + 3),
 PENMAP_Screen=(PENMAP_Dummy + 4),
 PENMAP_ImageType=(PENMAP_Dummy + 5),
 PENMAP_Transparent=(PENMAP_Dummy + 6),
 PENMAP_Precision=(PENMAP_Dummy + 8),
 PENMAP_ColorMap=(PENMAP_Dummy + 9),
 PENMAP_MaskBlit=(PENMAP_Dummy + 10),
 IMAGE_CHUNKY=0, /* Supported Default */
 IMAGE_IMAGE=1, /* Currently unsupported. */
 IMAGE_DRAWLIST=2 /* Currently unsupported. */

define IMAGE_WIDTH(i) (i[0])
#define IMAGE_HEIGHT(i) (i[1])
