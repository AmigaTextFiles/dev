#ifndef CFGLYPHI_H
#define CFGLYPHI_H

#include <intuition/imageclass.h>

#define CFglyphiClassName "CFglyphiclass"

#define CFGI_Dummy      (TAG_USER + 0x3c000)

#define CFGI_DrawInfo   (CFGI_Dummy + 0x0001)
#define CFGI_Type       (CFGI_Dummy + 0x0002)

/* Supported glyph types */

#define GLYPH_PDARROW     0
#define GLYPH_TREEMORE   10
#define GLYPH_TREEDONE   11
#define GLYPH_TREEMSUB   12
#define GLYPH_TREEDSUB   13



#endif
