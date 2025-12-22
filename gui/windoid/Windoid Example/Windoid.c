/*
	a fast and dirty hack - macintosh "copland" feeling for the amiga :-)
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	TODO:
	-----
	
	- remove absolute values (Border 18 pixel etc.)
	- speed up rendering and remove unnecessary things (use polygones and patterns
	  for drawing lines)
	- the size gadget should not be rendered into the topborder
	- put everything in external classes (SYS:Classes/Copland/... :-)

	
	LOW-PRIORITY-TODO:
	------------------

	- simulate mac menus ( == write something like MagicMenu)
	- clone the checkbox, string, combobox etc. "gadgets"...
	- write a "flyer-window" (the *real* windoids on mac)

	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	And always remember : this is only a GAG, dont take this too serious
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


	dbalster@uni-paderborn.de
*/

//#define DEBUG ON

// this is my "include_all.h"

#include <db/defs.h>

/******************************************************/
/*** CUT HERE AND PUT INTO A LINK LIB ****************/
/******************************************************/

// the BOOPSI classes used in this example; application global.. (not system)

Class *cl_macdraggad;
Class *cl_macbordergad;
Class *cl_macborderimg;
Class *cl_maczoomimg;
Class *cl_maccloseimg;
Class *cl_macdragimg;
Class *cl_macsizeimg;

// the BOOPSI image packet

struct WindowUserData
{
	Object	*Size,	*SizeImg;
	Object	*Dragbar,	*DragImg;
	Object	*Close,	*CloseImg;
	Object	*Zoom,	*ZoomImg;
	Object	*Border,	*BorderImg;

	struct Screen *scr;
	struct DrawInfo *dri;
	struct TextFont *tf;
	struct TextFont *tf2;

	STRPTR title;

	// color pen allocations

	BYTE gray00,gray13,gray23,gray29;
	BYTE gray42,gray46,gray55,gray59;
	BYTE gray63,p1,p2,p3;
};

// color macro (change it slightly and get soft-touched colors, like on mac)

#define GRAY(xx) (xx<<26)|0xFFFFFF,(xx<<26)|0xFFFFFF,(xx<<26)|0xFFFFFF

// a private tag; 30.12.1971.... what is it ?

#define WUD_POINTER 0x80301271

struct Image_Data
{
	struct WindowUserData *WUD;
};

/*
	SAVEDS		-> local data a4 register (interrupt/hooks need this)
	ASM			-> tell the compiler to create the register calls;
	REG(x) var	-> put the next variable into register x
*/
SAVEDS ASM ULONG DispatchMacDragGad (REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpRender *msg)
{
	switch (msg->MethodID)
	{
		case GM_LAYOUT			:	/* we only overload LAYOUT and RENDER */
		case GM_RENDER			: 
			if (msg->gpr_GInfo->gi_Window)
			{
				ULONG width	= (ULONG) msg->gpr_GInfo->gi_Window->Width;
				ULONG height	= (ULONG) msg->gpr_GInfo->gi_Window->Height;

				/* layout ourself (GA_RelWidth!) */

				SetAttrs(obj,
					GA_Width		, width-2,
					GA_Height		, 17,
					TAG_DONE);
					
				/* and inherit the values to our image object */
				
				SetAttrs(((struct Gadget*)obj)->GadgetRender,
					IA_Width		, width-2,
					IA_Height		, 17,
					IA_Left		, 0,
					IA_Top		, 0,
					TAG_DONE);
			}
	}
	
	/* pass *EVERY* method to our superclass ! */
	
	return DoSuperMethodA(cl,obj,msg);
}

/*
	the bordergadget is not a real gadget; this will change in
	the next version (all HITTESTS are ignored so far...)
*/

SAVEDS ASM ULONG DispatchMacBorderGad (REG(a0) Class *cl, REG(a2) Object *obj, REG(a1) struct gpRender *msg)
{
	switch (msg->MethodID)
	{
		case GM_LAYOUT			: 
		case GM_RENDER			: 
			if (msg->gpr_GInfo->gi_Window)
			{
				ULONG height	= (ULONG) msg->gpr_GInfo->gi_Window->Height;
				ULONG width	= (ULONG) msg->gpr_GInfo->gi_Window->Width;
	
				SetAttrs(obj,
					GA_Width		, width,
					GA_Height		, height,
					TAG_DONE);
				SetAttrs(((struct Gadget*)obj)->GadgetRender,
					IA_Width		, width,
					IA_Height		, height,
					TAG_DONE);
			}
	}
	return DoSuperMethodA(cl,obj,msg);
}

/*
	now the image classes.
	
	only NEW and DRAW are overloaded, and all imagery is drawn using
	Move(), Draw() and Rectfill().
	In the next version I'll try to use more efficient and faster rendering
	(polygone structs?) or fixed size images (but they are not scalable).
	
	The new method is just setting the WUD (WindowUserData) for the image.
	Another method would be to put the WUD pointer into the IA_Data attribute.
	(we don't need the ImageData pointer)
*/

SAVEDS ASM ULONG DispatchMacBorderImg (REG(a0) Class *cl, REG(a2) struct Image *img, REG(a1) struct impDraw* msg)
{
	switch (msg->MethodID)
	{
		case IM_DRAW:
		{
			struct RastPort *RP	= msg->imp_RPort;
			struct Image_Data *data = INST_DATA(cl,img);
			UWORD left,top,width,height,X,Y,i;

			X		= msg->imp_Offset.X;
			Y		= msg->imp_Offset.Y;
			left		= img->LeftEdge + X;
			top		= img->TopEdge + Y;
			width	= img->Width;
			height	= img->Height;

			SetAPen(RP,data->WUD->gray00);

			Move (RP,left,top);
			Draw (RP,left+width-1,top);
			Draw (RP,left+width-1,top+height-1);
			Draw (RP,left,top+height-1);
			Draw (RP,left,top);

			Move (RP,left+width-2,top);
			Draw (RP,left+width-2,top+height-2);
			Draw (RP,left,top+height-2);

			Move (RP,left+1,top+18);
			Draw (RP,left+width-2,top+18);

			return (1);
		}
		break;

		case OM_NEW:
		{
			if (img = DoSuperMethodA(cl,img,msg))
			{
				struct Image_Data *data = INST_DATA(cl,img);
			
				data->WUD = GetTagData(WUD_POINTER,0,((struct opSet*)msg)->ops_AttrList);
			
				return (ULONG)(img);
			}
			CoerceMethod(cl,img,OM_DISPOSE);
			return NULL;
		}
		break;
	}
	DoSuperMethodA(cl,img,msg);
}

SAVEDS ASM ULONG DispatchMacDragImg (REG(a0) Class *cl, REG(a2) struct Image *img, REG(a1) struct impDraw* msg)
{
	switch (msg->MethodID)
	{
		case IM_DRAW:
		{
			struct RastPort *RP = msg->imp_RPort;
			struct Image_Data *data = INST_DATA(cl,img);
			UWORD left,top,width,height,X,Y,i,p1,p2;

			X		= msg->imp_Offset.X;
			Y		= msg->imp_Offset.Y;
			left		= img->LeftEdge + X;
			top		= img->TopEdge + Y;
			width	= img->Width - 1;
			height	= img->Height;

			switch (msg->imp_State)
			{
				case IDS_INACTIVENORMAL:
					SetAPen(RP,data->WUD->gray59); // 63 !!
					RectFill(RP,left,top,left+width-1,top+height-1);
					p1 = data->WUD->gray29; // 34 !!
					p2 = data->WUD->gray59; // 63 !!

					// the next drawing is only to fix a bug ??

					SetAPen(RP,data->WUD->gray00);
					Move (RP,left+width,top);
					Draw (RP,left+width,top+height-1);
					break;
				case IDS_NORMAL:
					SetAPen(RP,data->WUD->gray55);
					Move (RP,left,top+height-2);
					Draw (RP,left,top);
					Draw (RP,left+width-2,top);

					SetAPen(RP,data->WUD->gray46);
					Move (RP,left+width-1,top);				
					Draw (RP,left+width-1,top+height-1);
					Draw (RP,left,top+height-1);

					SetAPen(RP,data->WUD->gray59);
					RectFill(RP,left+1,top+1,left+width-2,top+height-2);

					SetAPen(RP,data->WUD->gray29);
					for (i=top+3;i<=top+13;i+=2)
					{
						Move (RP,left+1,i);
					Draw (RP,left+width-2,i);
					}
					p1 = data->WUD->gray00;
					p2 = data->WUD->gray59;

					// the next drawing is only to fix a bug ??

					SetAPen(RP,data->WUD->gray00);
					Move (RP,left+width,top);
					Draw (RP,left+width,top+height-1);
					break;
			}

	/*
		draw the centered title:
		
		- check how many chars are fitting into the title area (==chars)
		- draw 'chars'-number of chars into the title
	*/

			{
				struct TextExtent te;
				char *text = data->WUD->title;
				int len = strlen(text);
				int chars, pixel;
				
				SetABPenDrMd(RP,p1,p2,JAM2);
				SetFont (RP,data->WUD->tf);
				SetSoftStyle(RP,FS_NORMAL,FS_NORMAL);

				// absolute! *change*!....
				// 42 == 10+11 ... 11+10   (close and zoom gadget)

				chars = TextFit(RP,text,len,&te,0,1,width-42,1000);
				pixel = TextLength(RP,text,chars);

				Move (RP,left+((width>>1)-(pixel>>1)),top+4+RP->TxBaseline-1);
				Text (RP,text,chars);
			}

			return (1);
		}
	
		case OM_NEW:
		{
			if (img = DoSuperMethodA(cl,img,msg))
			{
				struct Image_Data *data = INST_DATA(cl,img);
			
				data->WUD = GetTagData(WUD_POINTER,0,((struct opSet*)msg)->ops_AttrList);
			
				return (ULONG)(img);
			}
			CoerceMethod(cl,img,OM_DISPOSE);
			return NULL;
		}

	}

	DoSuperMethodA(cl,img,msg);
}

SAVEDS ASM ULONG DispatchMacSizeImg (REG(a0) Class *cl, REG(a2) struct Image *img, REG(a1) struct impDraw* msg)
{
	if (msg->MethodID == IM_DRAW)
	{
		struct RastPort *RP	= msg->imp_RPort;
		struct Image_Data *data = INST_DATA(cl,img);
		UWORD left,top,width,height,X,Y,i;

		X		= msg->imp_Offset.X;
		Y		= msg->imp_Offset.Y;
		left		= img->LeftEdge + X;
		top		= img->TopEdge + Y;
		width	= img->Width;
		height	= img->Height;

		switch (msg->imp_State)
		{
			case IDS_INACTIVENORMAL:
				SetAPen(RP,data->WUD->gray00);
				Move (RP,left,top+height-1);
				Draw (RP,left,top);
				Draw (RP,left+width-1,top);
				SetAPen(RP,data->WUD->gray59);
				RectFill (RP,left+1,top+1,left+width-1,top+height-1);
				break;
			case IDS_NORMAL:
			
			/* POLYGONES OR INLINE IMAGES SHOULD BE USED HERE !!! */
			
				SetAPen(RP,data->WUD->gray00);
				Move (RP,left,top+height-1);	Draw (RP,left,top);	Draw (RP,left+width-1,top);
				SetAPen(RP,data->WUD->gray55);
				RectFill (RP,left+1,top+1,left+width-1,top+height-1);
				SetAPen(RP,data->WUD->gray42);
				RectFill (RP,left+5,top+5,left+width-4,top+height-4);
				SetAPen(RP,data->WUD->gray13);
				Move (RP,left+3,top+8);	Draw (RP,left+3,top+3);	Draw (RP,left+8,top+3);
				Move (RP,left+5,top+8);	Draw (RP,left+8,top+8);	Draw (RP,left+8,top+5);
				Move (RP,left+4,top+9);	Draw (RP,left+4,top+width-3);
				Move (RP,left+9,top+4);	Draw (RP,left+width-3,top+4);
				Move (RP,left+6,top+height-3);	Draw (RP,left+width-3,top+height-3);	Draw (RP,left+width-3,top+6);
				SetAPen(RP,data->WUD->gray55);
				Move (RP,left+4,top+8);	Draw (RP,left+4,top+4);	Draw (RP,left+8,top+4);
				Move (RP,left+5,top+9);	Draw (RP,left+5,top+width-3);
				Move (RP,left+9,top+5);	Draw (RP,left+width-3,top+5);
				break;
		}

		return (1);
	}

	if (msg->MethodID==OM_NEW)
	{
		if (img = DoSuperMethodA(cl,img,msg))
		{
			struct Image_Data *data = INST_DATA(cl,img);
		
			data->WUD = GetTagData(WUD_POINTER,0,((struct opSet*)msg)->ops_AttrList);
		
			return (ULONG)(img);
		}
		CoerceMethod(cl,img,OM_DISPOSE);
		return NULL;
	}

	DoSuperMethodA(cl,img,msg);
}

SAVEDS ASM ULONG DispatchMacZoomImg (REG(a0) Class *cl, REG(a2) struct Image *img, REG(a1) struct impDraw* msg)
{
	if (msg->MethodID == IM_DRAW)
	{
		struct RastPort *RP	= msg->imp_RPort;
		struct Image_Data *data = INST_DATA(cl,img);
		UWORD left,top,width,height,w2,h2,X,Y,i;

		X		= msg->imp_Offset.X;
		Y		= msg->imp_Offset.Y;
		left		= img->LeftEdge + X;
		top		= img->TopEdge + Y;
		width	= img->Width;
		height	= img->Height;

		switch (msg->imp_State)
		{
			case IDS_INACTIVENORMAL:
				break;
			case IDS_NORMAL:
				SetAPen(RP,data->WUD->gray59);
				Move (RP,left,top);	Draw (RP,left,top+width-3);
				Move (RP,left+width-1,top);	Draw (RP,left+width-1,top+width-3);
				SetAPen(RP,data->WUD->gray13);
				Move (RP,left+1,top+height-1);	Draw (RP,left+1,top);	Draw (RP,left+width-2,top);
				SetAPen(RP,data->WUD->gray55);
				Move (RP,left+2,top+1);Draw (RP,left+width-2,top+1);	Draw (RP,left+width-2,top+height-1);	Draw (RP,left+2,top+height-1);	Draw (RP,left+2,top+1);
				SetAPen(RP,data->WUD->gray42);
				RectFill (RP,left+3,top+2,left+width-4,top+height-3);
				w2 = (width-4) >> 1;
				h2 = (height-3) >> 1;
				SetAPen(RP,data->WUD->gray13);
				Move (RP,left+3,top+height-2);	Draw (RP,left+width-3,top+height-2);	Draw (RP,left+width-3,top+2);
				Move (RP,left+3,top+2+h2);	Draw (RP,left+3+w2,top+2+h2);	Draw (RP,left+3+w2,top+2);
				break;
			case IDS_SELECTED:
				SetAPen(RP,data->WUD->gray59);
				Move (RP,left,top);	Draw (RP,left,top+width-3);
				Move (RP,left+width-1,top);	Draw (RP,left+width-1,top+width-3);
				SetAPen(RP,data->WUD->gray29);
				RectFill (RP,left+2,top+1,left+width-3,top+height-2);
				SetAPen(RP,data->WUD->gray00);
				Move (RP,left+1,top);
				Draw (RP,left+width-2,top);
				Draw (RP,left+width-2,top+height-1);
				Draw (RP,left+1,top+height-1);
				Draw (RP,left+1,top);
				X = width>>1; Y = height>>1;
				Move (RP,left+2,top+Y);
				Draw (RP,left+width-2,top+Y);
				Move (RP,left+X,top+1);
				Draw (RP,left+X,top+height-2);
				Move (RP,left+3,top+2);
				Draw (RP,left+width-4,top+height-3);
				Move (RP,left+3,top+height-3);
				Draw (RP,left+width-4,top+2);
				SetAPen(RP,data->WUD->gray29);
				RectFill (RP,left+X-1,top+Y-1,left+X+1,top+Y+1);
		}

		return (1);
	}

	if (msg->MethodID==OM_NEW)
	{
		if (img = DoSuperMethodA(cl,img,msg))
		{
			struct Image_Data *data = INST_DATA(cl,img);
		
			data->WUD = GetTagData(WUD_POINTER,0,((struct opSet*)msg)->ops_AttrList);
		
			return (ULONG)(img);
		}
		CoerceMethod(cl,img,OM_DISPOSE);
		return NULL;
	}

	DoSuperMethodA(cl,img,msg);
}

SAVEDS ASM ULONG DispatchMacCloseImg (REG(a0) Class *cl, REG(a2) struct Image *img, REG(a1) struct impDraw* msg)
{
	if (msg->MethodID == IM_DRAW)
	{
		struct RastPort *RP	= msg->imp_RPort;
		struct Image_Data *data = INST_DATA(cl,img);
		UWORD left,top,width,height,X,Y,i;

		X		= msg->imp_Offset.X;
		Y		= msg->imp_Offset.Y;
		left		= img->LeftEdge + X;
		top		= img->TopEdge + Y;
		width	= img->Width;
		height	= img->Height;

		switch (msg->imp_State)
		{
			case IDS_INACTIVENORMAL:
				break;
			case IDS_NORMAL:
				SetAPen(RP,data->WUD->gray59);
				Move (RP,left,top);	Draw (RP,left,top+width-3);
				Move (RP,left+width-1,top);	Draw (RP,left+width-1,top+width-3);
				SetAPen(RP,data->WUD->gray13);
				Move (RP,left+1,top+height-1);	Draw (RP,left+1,top);	Draw (RP,left+width-2,top);
				SetAPen(RP,data->WUD->gray55);
				Move (RP,left+2,top+1);	Draw (RP,left+width-2,top+1);	Draw (RP,left+width-2,top+height-1);	Draw (RP,left+2,top+height-1);	Draw (RP,left+2,top+1);
				SetAPen(RP,data->WUD->gray13);
				Move (RP,left+3,top+height-2);	Draw (RP,left+width-3,top+height-2);	Draw (RP,left+width-3,top+2);
				SetAPen(RP,data->WUD->gray42);
				RectFill (RP,left+3,top+2,left+width-4,top+height-3);
				break;
			case IDS_SELECTED:
				SetAPen(RP,data->WUD->gray59);
				Move (RP,left,top);	Draw (RP,left,top+width-3);
				Move (RP,left+width-1,top);	Draw (RP,left+width-1,top+width-3);
				SetAPen(RP,data->WUD->gray29);
				RectFill (RP,left+2,top+1,left+width-3,top+height-2);
				SetAPen(RP,data->WUD->gray00);
				Move (RP,left+1,top);
				Draw (RP,left+width-2,top);
				Draw (RP,left+width-2,top+height-1);
				Draw (RP,left+1,top+height-1);
				Draw (RP,left+1,top);
				/* draw the centered "star" */
				X = width>>1; Y = height>>1;
				Move (RP,left+2,top+Y);
				Draw (RP,left+width-2,top+Y);
				Move (RP,left+X,top+1);
				Draw (RP,left+X,top+height-2);
				Move (RP,left+3,top+2);
				Draw (RP,left+width-4,top+height-3);
				Move (RP,left+3,top+height-3);
				Draw (RP,left+width-4,top+2);
				SetAPen(RP,data->WUD->gray29);
				RectFill (RP,left+X-1,top+Y-1,left+X+1,top+Y+1);

				break;
		}

		return (1);
	}

	if (msg->MethodID==OM_NEW)
	{
		if (img = DoSuperMethodA(cl,img,msg))
		{
			struct Image_Data *data = INST_DATA(cl,img);
		
			data->WUD = GetTagData(WUD_POINTER,0,((struct opSet*)msg)->ops_AttrList);
		
			return (ULONG)(img);
		}
		CoerceMethod(cl,img,OM_DISPOSE);
		return NULL;
	}

	DoSuperMethodA(cl,img,msg);
}

/********************************************************/
/*** init/kill the custom classes ***********************/
/********************************************************/

void init (void)
{
	/* (layouted) gadgets ... */
	if (cl_macdraggad	= MakeClass (NULL,"buttongclass",0,0,0))					cl_macdraggad->cl_Dispatcher.h_Entry	= DispatchMacDragGad;
	if (cl_macbordergad	= MakeClass (NULL,"buttongclass",0,0,0))					cl_macbordergad->cl_Dispatcher.h_Entry	= DispatchMacBorderGad;

	/* images ... */
	if (cl_macdragimg	= MakeClass (NULL,"imageclass",0,sizeof(struct Image_Data),0))	cl_macdragimg->cl_Dispatcher.h_Entry	= DispatchMacDragImg;
	if (cl_macsizeimg	= MakeClass (NULL,"imageclass",0,sizeof(struct Image_Data),0))	cl_macsizeimg->cl_Dispatcher.h_Entry	= DispatchMacSizeImg;
	if (cl_maczoomimg	= MakeClass (NULL,"imageclass",0,sizeof(struct Image_Data),0))	cl_maczoomimg->cl_Dispatcher.h_Entry	= DispatchMacZoomImg;
	if (cl_maccloseimg	= MakeClass (NULL,"imageclass",0,sizeof(struct Image_Data),0))	cl_maccloseimg->cl_Dispatcher.h_Entry	= DispatchMacCloseImg;
	if (cl_macborderimg	= MakeClass (NULL,"imageclass",0,sizeof(struct Image_Data),0))	cl_macborderimg->cl_Dispatcher.h_Entry	= DispatchMacBorderImg;
}

void kill (void)
{
	/* (layouted) gadgets ... */
	FreeClass (cl_macdraggad);
	FreeClass (cl_macbordergad);

	/* images ... */
	FreeClass (cl_macdragimg);
	FreeClass (cl_macsizeimg);
	FreeClass (cl_maczoomimg);
	FreeClass (cl_maccloseimg);
	FreeClass (cl_macborderimg);
}

/******************************************************/

// an easy "faked-bitmap" backfill hook (for the "gray" background)

struct bfMsg
{
	struct Layer *Layer;
	struct Rectangle Bounds;
	LONG OffsetX;
	LONG OffsetY;
};

#define RECTSIZEX(r) ((r)->MaxX-(r)->MinX+1)
#define RECTSIZEY(r) ((r)->MaxY-(r)->MinY+1)

struct BitMap White = { 256, 256, 0,8, 0, { 0 } };

STATIC ULONG SAVEDS ASM MacLayerFunc (REG(a0) struct Hook *Hook,REG(a2) struct RastPort *RP,REG(a1) struct bfMsg *BFM)
{
	struct RastPort myRP = *RP;
	myRP.Layer = NULL;

	BltBitMap(&White,BFM->Bounds.MinX,BFM->Bounds.MinY,RP->BitMap,BFM->Bounds.MinX,BFM->Bounds.MinY,RECTSIZEX(&BFM->Bounds),RECTSIZEY(&BFM->Bounds),0xC0,0xFF,NULL);

	return 0;
}

/******************************************************/

// some typical mac fonts

struct TextAttr MacFont =
{
	"chicago.font",13,FPF_DISKFONT,FS_NORMAL
};
struct TextAttr MacFont2 =
{
	"monaco.font",9,FPF_DISKFONT,FS_NORMAL
};

struct Window *OpenWindoid( STRPTR pubname, ULONG tag1, ... )
{
	struct WindowUserData *WUD = AllocMem(sizeof(*WUD),MEMF_CLEAR|MEMF_PUBLIC);
	struct Window *win;
	struct TagItem *tag;
	static struct Hook MacLayerHook = {{NULL,NULL},(VOID*)MacLayerFunc,NULL,NULL};

	ifn (WUD) return NULL;

	WUD->tf = OpenDiskFont(&MacFont);
//	WUD->tf2 = OpenDiskFont(&MacFont2);

	if (WUD->tf)
	{
		if (WUD->scr = LockPubScreen (pubname))
		{
			if (WUD->dri = GetScreenDrawInfo(WUD->scr))
			{
				struct ColorMap *cm = WUD->scr->ViewPort.ColorMap;
				register int i;

			/*
				allocate some user colors.
				if a call fails, we don't care about it!
				ReleasePen(-1) is safe (but the window could look strange...)
			*/

				WUD->gray00 = ObtainBestPen (cm,GRAY(0) ,OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray13 = ObtainBestPen (cm,GRAY(13),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray23 = ObtainBestPen (cm,GRAY(23),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray29 = ObtainBestPen (cm,GRAY(29),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray42 = ObtainBestPen (cm,GRAY(42),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray46 = ObtainBestPen (cm,GRAY(46),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray55 = ObtainBestPen (cm,GRAY(55),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray59 = ObtainBestPen (cm,GRAY(59),OBP_Precision,PRECISION_EXACT,TAG_END);
				WUD->gray63 = ObtainBestPen (cm,GRAY(63),OBP_Precision,PRECISION_EXACT,TAG_END);

				// Create a "white-fixed-color" bitmap
				for (i=0;i<8;i++) White.Planes[i] = (PLANEPTR) ((((ULONG)WUD->gray55) & (1L<<i)) == (1L<<i)) ? (-1) : (0);

				WUD->BorderImg = NewObject(cl_macborderimg,0,
					WUD_POINTER	, WUD,
					GA_Top		, 0,
					GA_Left		, 0,
					TAG_DONE);
				ifn (WUD->BorderImg) goto OpenWindoid_failed;

				WUD->CloseImg = NewObject(cl_maccloseimg,0,
					IA_Width		, 13,
					IA_Height		, 11,
					WUD_POINTER	, WUD,
					TAG_DONE);
				ifn (WUD->CloseImg) goto OpenWindoid_failed;

				WUD->ZoomImg = NewObject(cl_maczoomimg,0,
					IA_Width		, 13,
					IA_Height		, 11,
					WUD_POINTER	, WUD,
					TAG_DONE);
				ifn (WUD->ZoomImg) goto OpenWindoid_failed;

				WUD->SizeImg = NewObject(cl_macsizeimg,0,
					IA_Width		, 15,
					IA_Height		, 15,
					WUD_POINTER	, WUD,
					TAG_DONE);
				ifn (WUD->BorderImg) goto OpenWindoid_failed;

				WUD->DragImg = NewObject(cl_macdragimg,0,
					IA_Height		, 17,
					IA_Width		, 0,
					WUD_POINTER	, WUD,
					TAG_DONE);
				ifn (WUD->DragImg) goto OpenWindoid_failed;

				WUD->Border = NewObject(cl_macbordergad,0,
					GA_RelWidth	, TRUE,
					GA_RelHeight	, TRUE,
					GA_Top		, 0,
					GA_Left		, 0,
					GA_Image		, WUD->BorderImg,
					TAG_DONE);
				ifn (WUD->Border) goto OpenWindoid_failed;

				WUD->Dragbar = NewObject(cl_macdraggad,NULL,
					GA_Top		, 1,
					GA_Left		, 1,
					GA_RelWidth	, TRUE,
					GA_Width		, 0,
					GA_Height		, 17,
					GA_SysGType	, GTYP_WDRAGGING,
					GA_TopBorder	, TRUE,
					GA_Image		, WUD->DragImg,
					TAG_DONE);
				ifn (WUD->Dragbar) goto OpenWindoid_failed;

				WUD->Close = NewObject(NULL,"buttongclass",
					GA_Top		, 4,
					GA_Left		, 8,
					GA_Width		, 13,
					GA_Height		, 11,
					GA_RelVerify	, TRUE,
					GA_EndGadget	, TRUE,
					GA_SysGType	, GTYP_CLOSE,
					GA_TopBorder	, TRUE,
					GA_Image		, WUD->CloseImg,
					TAG_DONE);
				ifn (WUD->Close) goto OpenWindoid_failed;

				WUD->Zoom = NewObject(NULL,"buttongclass",
					GA_Top		, 4,
					GA_RelRight	, -(11+10),
					GA_Width		, 13,
					GA_Height		, 11,
					GA_RelVerify	, TRUE,
					GA_SysGType	, GTYP_WZOOM,
					GA_TopBorder	, TRUE,
					GA_Image		, WUD->ZoomImg,
					TAG_DONE);
				ifn (WUD->Zoom) goto OpenWindoid_failed;

				WUD->Size = NewObject(NULL,"buttongclass",
					GA_RelBottom	, -16,
					GA_RelRight	, -16,
					GA_Width		, 15,
					GA_Height		, 15,
					GA_RelVerify	, TRUE,
					GA_SysGType	, GTYP_SIZING,
					GA_Image		, WUD->SizeImg,
					TAG_DONE);
				ifn (WUD->Size) goto OpenWindoid_failed;

				/* at this point I should insert a taglist scanner, (for...NextTagItem()
				   filtering all tags out that the user shouldn't use */

				if (tag = FindTagItem(WA_Title,&tag1))	// WA_Title 
				{
					WUD->title =tag->ti_Data;
					tag->ti_Data = NULL;
				}

				if (win = OpenWindowTags(NULL,
					WA_Borderless		, TRUE,
					WA_BackFill		, &MacLayerHook,
					WA_GimmeZeroZero	, FALSE,
					WA_NoCareRefresh	, TRUE,					/* fastest possible refreshig */
					WA_SimpleRefresh	, TRUE,
					WA_RMBTrap		, TRUE,					/* still no menus :-) */
					WA_ScreenTitle		, "  Project    Edit    File        (menus ;-) questions? dbalster@uni-paderborn.de",
					WA_MaxWidth		, 65535,
					WA_MaxHeight		, 65535,
					WA_MinWidth		, 64,					/* should be calculated */
					WA_MinHeight		, 20,
					TAG_MORE, &tag1))
				{
					win->UserData = WUD;

			// font not yet
			//		SetFont(win->RPort,WUD->tf2);
					SetBPen(win->RPort,WUD->gray55);
					SetAPen(win->RPort,WUD->gray00);	/* black */
					SetDrMd(win->RPort,JAM2);
				
				/*
					sequence is important!
				*/
				
					AddGadget(win,WUD->Close,(UWORD)-1);
					AddGadget(win,WUD->Zoom,(UWORD)-1);
					AddGadget(win,WUD->Size,(UWORD)-1);
					AddGadget(win,WUD->Dragbar,(UWORD)-1);
					AddGadget(win,WUD->Border,(UWORD)-1);

				// these border values should be dynamic... :-(

					win->BorderLeft	= 1;
					win->BorderTop		= 19;
					win->BorderRight	= 2;
					win->BorderBottom	= 2;

				/* calculate the new border frame (mandatory) */

					RefreshWindowFrame(win);

					UnlockPubScreen(0,WUD->scr);
					return win;	
				}
	OpenWindoid_failed:
				FreeScreenDrawInfo(WUD->scr,WUD->dri);
			}
			UnlockPubScreen(0,WUD->scr);
		}

		DisposeObject (WUD->Border);
		DisposeObject (WUD->BorderImg);
		DisposeObject (WUD->Size);
		DisposeObject (WUD->SizeImg);
		DisposeObject (WUD->Zoom);
		DisposeObject (WUD->ZoomImg);
		DisposeObject (WUD->Dragbar);
		DisposeObject (WUD->DragImg);
		DisposeObject (WUD->Close);
		DisposeObject (WUD->CloseImg);
	}
	FreeMem (WUD,sizeof(*WUD));

	return 0;
}

/*
	taken from the RKM examples
	(..else some *strange* MUNGWALL hits occurred..)
*/

static void CloseWindowSafely (struct Window *win)
{
	struct IntuiMessage *imsg;
	struct Node *succ;
	
	Forbid();
	imsg = (struct IntuiMessage*) win->UserPort->mp_MsgList.lh_Head;
	while (succ = imsg->ExecMessage.mn_Node.ln_Succ)
	{
		if (imsg->IDCMPWindow == win)
		{
			Remove ((struct Message*)imsg);
			ReplyMsg ((struct Message*)imsg);
		}
		imsg = (struct IntuiMessage *) succ;
	}
	win->UserPort = NULL;
	ModifyIDCMP(win,0);
	Permit();
	CloseWindow(win);
}

void CloseWindoid (struct Window *win)
{
	if (win)
	{
		if (win->UserData)
		{
			struct WindowUserData *WUD = win->UserData;

			CloseWindowSafely(win);

			DisposeObject (WUD->Border);
			DisposeObject (WUD->BorderImg);
			DisposeObject (WUD->Size);
			DisposeObject (WUD->SizeImg);
			DisposeObject (WUD->Zoom);
			DisposeObject (WUD->ZoomImg);
			DisposeObject (WUD->Dragbar);
			DisposeObject (WUD->DragImg);
			DisposeObject (WUD->Close);
			DisposeObject (WUD->CloseImg);

			if (WUD->dri) FreeScreenDrawInfo(WUD->scr,WUD->dri);

			if (WUD->scr)
			{
				struct ColorMap *cm = WUD->scr->ViewPort.ColorMap;

				ReleasePen(cm,WUD->gray00);
				ReleasePen(cm,WUD->gray13);
				ReleasePen(cm,WUD->gray23);
				ReleasePen(cm,WUD->gray29);
				ReleasePen(cm,WUD->gray42);
				ReleasePen(cm,WUD->gray46);
				ReleasePen(cm,WUD->gray55);
				ReleasePen(cm,WUD->gray59);
			}

			if (WUD->tf) CloseFont(WUD->tf);
		//	if (WUD->tf2) CloseFont(WUD->tf2);
	
			FreeMem (WUD,sizeof(*WUD));
		}
	}
}

/******************************************************************************/

/*

	A simple example code of using the "Windoid"

	1.) open a windoid window
	2.) open a datatypes picture and add it to the window
	3.) do a simple input loop
	4.) clean up after CLOSEWINDOW or CTRL_C

*/


int main (void)
{
	struct RDArgs *rda;
	struct Window *win;

	init();

	if (win = OpenWindoid(
					"Workbench",
					WA_Left		, 100,
					WA_Top		, 100,
					WA_Width		, 200,
					WA_Height		, 100,
					WA_Title		, "  Play with me!  ",
					WA_IDCMP		, IDCMP_CLOSEWINDOW,
					WA_Activate	, TRUE,
					TAG_DONE))
	{
		ULONG signals = 0;
		BOOL running = TRUE;

			while (running)
			{
				signals = Wait(SIGBREAKF_CTRL_C | (1L << win->UserPort->mp_SigBit));
				
				if (signals & (1L << win->UserPort->mp_SigBit))
				{
					struct IntuiMessage *imsg;
					ULONG iClass;
					UWORD iCode, iMouseX,iMouseY;
					
					while (imsg = (struct IntuiMessage*) GetMsg(win->UserPort))
					{
						iClass  = imsg->Class;
						iCode   = imsg->Code;
						iMouseX = imsg->MouseX;
						iMouseY = imsg->MouseY;
					
						ReplyMsg((struct Message*)imsg);
						
						switch (iClass)
						{
							case IDCMP_CLOSEWINDOW:
								running = FALSE;
								break;	

							defaults:
								break;
						}
					}
				}
			
				if (signals & SIGBREAKF_CTRL_C) running = FALSE;
			}
		CloseWindoid(win);
	}
	
	kill();
	
	return 0;
}
