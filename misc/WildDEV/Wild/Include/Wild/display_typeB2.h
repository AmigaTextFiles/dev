#ifndef	WILD_DISPLAY_TYPEB2_H
#define	WILD_DISPLAY_TYPEB2_H

struct FrameBuffer
{
 struct Screen 		*fb_Screen;
 UBYTE			*fb_Chunky;
 UWORD			fb_ChunkyWidth;
 UWORD			fb_ChunkyHeight;
 UWORD			fb_ViewLeft;
 UWORD			fb_ViewTop;
 UWORD			fb_ViewWidth;
 UWORD			fb_ViewHeight;
 ULONG			fb_Flags; 
};

#define FBF_WildScreen	0x00010000

#endif
