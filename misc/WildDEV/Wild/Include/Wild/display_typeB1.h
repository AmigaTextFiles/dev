#ifndef	WILD_DISPLAYTYPEB1_H
#define WILD_DISPLAYTYPEB1_H

struct FrameBuffer
{
 struct Screen 		*fb_Screen;
 struct RastPort 	*fb_RastPort;
 struct BitMap 		*fb_BitMap;
 UWORD			fb_ViewLeft;
 UWORD			fb_ViewTop;
 UWORD			fb_ViewWidth;
 UWORD			fb_ViewHeight;
 ULONG			fb_Flags;
};

#define FBF_WildScreen	0x00010000

#endif