#ifndef	WILD_DISPLAY_TYPEB3_H
#define	WILD_DISPLAY_TYPEB3_H

struct FrameBuffer
{
 struct Window 		*fb_Window;
 UWORD			fb_ViewTop;
 UWORD			fb_ViewLeft;
 UWORD			fb_ViewWidth;
 UWORD			fb_ViewHeight;
};

#endif