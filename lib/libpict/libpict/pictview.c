#include "pict.h"
#include <sys/param.h>
#include <intuition/intuition.h>
#include <intuition/icclass.h>
#include <reaction/reaction_macros.h>
#include <classes/window.h>
#include <gadgets/scroller.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/graphics.h>
#include <proto/Picasso96API.h>
#include <proto/intuition.h>
#include <proto/window.h>

#define G(o) ((struct Gadget *)(o))

enum {
	GID_UNUSED = 0,
	GID_HPROP,
	GID_VPROP
};

uint32 idcmp_hook_func (struct Hook *hook, Object *window, struct IntuiMessage *msg);

struct idcmp_hook_data {
	struct BitMap *bm;
	int32 width, height;
	Object *hprop;
	Object *vprop;
	int32 top, left;
	int32 view_width;
	int32 view_height;
};

static const struct TagItem scroller_map[] = {
	{ SCROLLER_Top,		ICSPECIAL_CODE	},
	{ TAG_END,			0				},
};

int main (int argc, char **argv) {
	PICT *pict = NULL;
	FILE *fp = NULL;
	int32 width, height;
	struct BitMap *bm = NULL;
	struct MsgPort *port = NULL;
	Object *window = NULL;
	struct Window *win;
	uint32 sigmask;
	uint32 res;
	uint16 code;
	int quit = FALSE;
	struct Hook idcmp_hook = {0};
	struct idcmp_hook_data idcmp_hook_data = {0};

	if (argc != 2) {
		printf("Usage: pictview <pict file>\n");
		return 20;
	}

	fp = fopen(argv[1], "rb");
	if (!fp) {
		printf("%s: could not be opened\n", argv[1]);
		goto out;
	}
	
	pict = pict_create();
	if (!pict) {
		goto out;
	}

	pict_read_start(pict, fp);
	
	width = pict_get_width(pict);
	height = pict_get_height(pict);
	pict_read_set_unpack(pict, PICT_PACKING_RGB);
	
	bm = p96AllocBitMap(width, height, 24, BMF_USERPRIVATE, NULL, RGBFB_R8G8B8);
	if (!bm) {
		pict_read_end(pict);
		printf("Not enough memory for bitmap\n");
		goto out;
	} else {
		uint8 *px;
		int32 y, bpr;
		
		px = (uint8 *)p96GetBitMapAttr(bm, P96BMA_MEMORY);
		bpr = p96GetBitMapAttr(bm, P96BMA_BYTESPERROW);
		for (y = 0; y < height; y++) {
			pict_read_row(pict, px);
			px += bpr;
		}
		pict_read_end(pict);
	}
	
	port = CreateMsgPort();
	if (!port) {
		goto out;
	}
	
	idcmp_hook.h_Entry = idcmp_hook_func;
	idcmp_hook.h_Data = &idcmp_hook_data;
	idcmp_hook_data.bm = bm;
	idcmp_hook_data.width = width;
	idcmp_hook_data.height = height;
	window = WindowObject,
		WA_Title,				FilePart(argv[1]),
		WA_InnerWidth,			width,
		WA_InnerHeight,			height,
		WA_MinWidth,			120,
		WA_MinHeight,			120,
		WA_MaxWidth,			-1,
		WA_MaxHeight,			-1,
		WA_Flags,				WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|
								WFLG_SIZEGADGET|WFLG_SIZEBRIGHT|WFLG_SIZEBBOTTOM|
								WFLG_ACTIVATE,
		WA_IDCMP,				IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW|
								IDCMP_IDCMPUPDATE,
		WA_AutoAdjust,			TRUE,
		WINDOW_Position,		WPOS_CENTERSCREEN,
		WINDOW_AppPort,			port,
		WINDOW_IconifyGadget,	TRUE,
		WINDOW_HorizProp,		TRUE,
		WINDOW_VertProp,		TRUE,
		WINDOW_IDCMPHook,		&idcmp_hook,
		WINDOW_IDCMPHookBits,	IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW|IDCMP_IDCMPUPDATE,
	End;
	if (!window) {
		goto out;
	}
	GetAttrs(window,
		WINDOW_HorizObject,	(ULONG *)&idcmp_hook_data.hprop,
		WINDOW_VertObject,	(ULONG *)&idcmp_hook_data.vprop,
		TAG_END);
	win = RA_OpenWindow(window);
	if (!win) {
		goto out;
	}

	WindowLimits(win, 120, 120, -1, -1);
	idcmp_hook_data.view_width = MIN(width, win->GZZWidth);
	idcmp_hook_data.view_height = MIN(height, win->GZZHeight);
	SetGadgetAttrs(G(idcmp_hook_data.hprop), win, NULL,
		GA_ID,				GID_HPROP,
		SCROLLER_Total,		width,
		SCROLLER_Visible,	idcmp_hook_data.view_width,
		SCROLLER_Top,		0,
		ICA_TARGET,			ICTARGET_IDCMP,
		ICA_MAP,			scroller_map,
		TAG_END);
	SetGadgetAttrs(G(idcmp_hook_data.vprop), win, NULL,
		GA_ID,				GID_VPROP,
		SCROLLER_Total,		height,
		SCROLLER_Visible,	idcmp_hook_data.view_height,
		SCROLLER_Top,		0,
		ICA_TARGET,			ICTARGET_IDCMP,
		ICA_MAP,			scroller_map,
		TAG_END);
	BltBitMapRastPort(bm, 0, 0, win->RPort,
		win->BorderLeft, win->BorderTop,
		win->GZZWidth, win->GZZHeight,
		0xc0);

	while (!quit) {
		GetAttr(WINDOW_SigMask, window, &sigmask);
		Wait(sigmask);
		while ((res = RA_HandleInput(window, &code)) != WMHI_LASTMSG) {
			switch (res & WMHI_CLASSMASK) {
				
				case WMHI_CLOSEWINDOW:
					quit = TRUE;
					break;
				
				case WMHI_ICONIFY:
					RA_Iconify(window);
					win = NULL;
					break;
					
				case WMHI_UNICONIFY:
					win = RA_OpenWindow(window);
					break;

			}
		}
	}

out:
	DisposeObject(window);
	DeleteMsgPort(port);
	p96FreeBitMap(bm);
	if (pict) pict_destroy(&pict);
	if (fp) fclose(fp);

	return 0;
}

uint32 idcmp_hook_func (struct Hook *hook, Object *window, struct IntuiMessage *msg) {
	struct idcmp_hook_data *data = hook->h_Data;
	struct Window *win = NULL;
	int32 left;
	int32 top;
	GetAttr(WINDOW_Window, window, (ULONG *)&win);
	switch (msg->Class) {
	
		case IDCMP_IDCMPUPDATE:
			left = data->left;
			top = data->top;
			switch (GetTagData(GA_ID, GID_UNUSED, msg->IAddress)) {
				case GID_HPROP:
					left = msg->Code;
					break;
				case GID_VPROP:
					top = msg->Code;
					break;
				default:
					printf("unknown gadget id\n");
					break;
			}
			if (left != data->left || top != data->top) {
				data->left = left;
				data->top = top;
				if (win) {
					BltBitMapRastPort(data->bm, data->left, data->top, win->RPort,
						win->BorderLeft, win->BorderTop,
						data->view_width, data->view_height,
						0xc0);
				}
			}
			break;
	
		case IDCMP_NEWSIZE:
			data->view_width = MIN(data->width, win->GZZWidth);
			data->view_height = MIN(data->height, win->GZZHeight);
			left = MIN(data->left, data->width - data->view_width);
			top = MIN(data->top, data->height - data->view_height);
			SetGadgetAttrs(G(data->hprop), win, NULL,
				SCROLLER_Visible,	data->view_width,
				SCROLLER_Top,		left,
				TAG_END);
			SetGadgetAttrs(G(data->vprop), win, NULL,
				SCROLLER_Visible,	data->view_height,
				SCROLLER_Top,		top,
				TAG_END);
			if (left != data->left || top != data->top) {
				data->left = left;
				data->top = top;
				BltBitMapRastPort(data->bm, data->left, data->top, win->RPort,
					win->BorderLeft, win->BorderTop,
					data->view_width, data->view_height,
					0xc0);
			}
			break;
	
		case IDCMP_REFRESHWINDOW:
			if (win) {
				BeginRefresh(win);
				BltBitMapRastPort(data->bm, data->left, data->top, win->RPort,
					win->BorderLeft, win->BorderTop,
					data->view_width, data->view_height,
					0xc0);
				EndRefresh(win, TRUE);
			}
			break;

	}
	return 0;
}
