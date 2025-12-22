#include "libart.h"
#include <stdint.h>
#include <stdio.h>
#include <graphics/blitattr.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>

#define WIDTH 64
#define HEIGHT 64
#define BYTES_PER_PIXEL 3
#define ROWSTRIDE (WIDTH*BYTES_PER_PIXEL)

static ArtSVP *make_path(void) {
	ArtVpath *vec = NULL;
	ArtSVP *svp = NULL;

	vec = art_new(ArtVpath, 10);
	if (vec == NULL) {
		fprintf(stderr, "art_new failed\n");
		return NULL;
	}
	vec[0].code = ART_MOVETO;
	vec[0].x = 8;
	vec[0].y = 8;
	vec[1].code = ART_LINETO;
	vec[1].x = 8;
	vec[1].y = 56;
	vec[2].code = ART_LINETO;
	vec[2].x = 56;
	vec[2].y = 56;
	vec[3].code = ART_LINETO;
	vec[3].x = 56;
	vec[3].y = 8;
	vec[4].code = ART_END;

	svp = art_svp_from_vpath(vec);
	if (svp == NULL) {
		fprintf(stderr, "art_svp_from_vpath failed\n");
		return NULL;
	}

	return svp;
}

static uint8_t *render_path (const ArtSVP *path) {
	art_u8 *buffer = NULL;
	art_u32 color = 0xff0000ff;

	buffer = art_new(art_u8, WIDTH*HEIGHT*BYTES_PER_PIXEL);
	if (buffer == NULL) {
		fprintf(stderr, "art_new failed\n");
		return NULL;
	}
	art_rgb_run_alpha(buffer, 0xff, 0xff, 0xff, 0xff, WIDTH*HEIGHT);
	art_rgb_svp_alpha(path, 0, 0, WIDTH, HEIGHT, color, buffer, ROWSTRIDE, NULL);

	return (uint8_t *)buffer;
}

int main (void) {
	ArtSVP *path;
	uint8_t *buffer;
	struct Window *window;
	BOOL done = FALSE;
	struct IntuiMessage *msg;

	path = make_path();
	if (path == NULL) {
		fprintf(stderr, "make_path failed\n");
		return 0;
	}

	buffer = render_path(path);
	if (buffer == NULL) {
		fprintf(stderr, "render_path failed\n");
		return 0;
	}

	window = IIntuition->OpenWindowTags(NULL,
		WA_InnerWidth,  WIDTH,
		WA_InnerHeight, HEIGHT,
		WA_Flags,       WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET
		                |WFLG_SMART_REFRESH|WFLG_NOCAREREFRESH,
		WA_IDCMP,		IDCMP_CLOSEWINDOW,
		TAG_END);
	if (window == NULL) {
		fprintf(stderr, "failed to open window\n");
		return 0;
	}

	printf("path: 0x%08x\n", (uint32_t)path);
	printf("buffer: 0x%08x\n", (uint32_t)buffer);
	printf("window: 0x%08x\n", (uint32_t)window);
	printf("specs: %dx%dx%d\n", WIDTH, HEIGHT, BYTES_PER_PIXEL*8);

	IGraphics->BltBitMapTags(
		BLITA_SrcType,        BLITT_RGB24,
		BLITA_SrcBytesPerRow, ROWSTRIDE,
		BLITA_Source,         buffer,
		BLITA_DestType,       BLITT_RASTPORT,
		BLITA_Dest,           window->RPort,
		BLITA_Width,          WIDTH,
		BLITA_Height,         HEIGHT,
		BLITA_DestX,          window->BorderLeft,
		BLITA_DestY,          window->BorderTop,
		TAG_END);

	while (!done) {
		IExec->WaitPort(window->UserPort);
		while ((msg = (struct IntuiMessage *)IExec->GetMsg(window->UserPort)) != NULL) {
			switch (msg->Class) {
			case IDCMP_CLOSEWINDOW:
				done = TRUE;
				break;
			}
			IExec->ReplyMsg((struct Message *)msg);
		}
	}

	IIntuition->CloseWindow(window);

	return 0;
}

