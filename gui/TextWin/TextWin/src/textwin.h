#include <libraries/mui.h>
#include <proto/muimaster.h>
#include <clib/exec_protos.h>
#include <exec/memory.h>
#include <clib/alib_protos.h>

struct ObjApp
{
	APTR	App;
	APTR	WI_label_0;
	APTR	GR_ListView;
	APTR	GR_Buttons;
};


extern struct ObjApp * CreateApp(void);
extern void DisposeApp(struct ObjApp *);
