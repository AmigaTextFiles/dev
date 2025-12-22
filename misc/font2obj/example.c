#include <libraries/diskfont.h>
#include <intuition/intuition.h>
#include <dos/dos.h>

#include <proto/intuition.h>
#include <proto/graphics.h>

extern struct DiskFontHeader the_font_hunk;

#define the_font_header the_font_hunk

void test(struct TextFont *tf)
{
	struct Window *w;
	struct IntuiMessage *mess;
	int done = 0;
	ULONG mask, sigs;

	w = OpenWindowTags(NULL,
			WA_Width, 100,
			WA_Height, 50,
			WA_Title, "font test",
			WA_SmartRefresh, TRUE,
			WA_DepthGadget, TRUE,
			WA_CloseGadget, TRUE,
			WA_DragBar, TRUE,
			WA_RMBTrap, TRUE,
			WA_IDCMP, IDCMP_CLOSEWINDOW,
			TAG_DONE);

	if (w) {
		SetAPen(w->RPort, 1);
		SetDrMd(w->RPort, JAM1);
		SetFont(w->RPort, tf);
		Move(w->RPort, 25,25);
		Text(w->RPort, "Hello", 5);
		Move(w->RPort, 25,40);
		Text(w->RPort, "World", 5);

		mask = 1L<<w->UserPort->mp_SigBit | SIGBREAKF_CTRL_C;

		while (!done) {
			sigs = Wait(mask);
			if (sigs & SIGBREAKF_CTRL_C) break;
			while (mess= (struct IntuiMessage *) GetMsg(w->UserPort)) {
				switch (mess->Class) {
				case CLOSEWINDOW:
					done = 1;
					break;
				default:
					break;
				}
				ReplyMsg(mess);
			}
		}
		CloseWindow(w);
	}
}

main() {
	test(&the_font_header.dfh_TF);
}
