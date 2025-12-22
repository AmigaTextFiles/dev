
#include <inline/exec.h>
#include <libraries/mui.h>
#include <exec/memory.h>


struct ObjWI_CyberGL
{
	APTR	WI_CyberGL;
	APTR	BT_CyberGLRefresh;
	APTR	BT_CyberGLReset;
	APTR	BT_CyberGLRender;
	APTR	GR_CyberGLOutput;
	APTR	GA_CyberGLRendering;
	APTR	BT_CyberGLBreak;
	APTR	IM_CyberGLXLeft;
	APTR	IM_CyberGLXRight;
	APTR	STR_CyberGLX;
	APTR	IM_CyberGLYLeft;
	APTR	IM_CyberGLYRight;
	APTR	STR_CyberGLY;
	APTR	IM_CyberGLZLeft;
	APTR	IM_CyberGLZRight;
	APTR	STR_CyberGLZ;
	APTR	IM_CyberGLHLeft;
	APTR	IM_CyberGLHRight;
	APTR	STR_CyberGLHeading;
	APTR	IM_CyberGLPLeft;
	APTR	IM_CyberGLPRight;
	APTR	STR_CyberGLPitch;
	APTR	CY_CyberGLMouseEvent;
	APTR	CY_CyberGLWhich;
	APTR	CY_CyberGLLevel;
	APTR	CY_CyberGLMode;
	APTR	CY_CyberGLBox;
	char *	CY_CyberGLMouseEventContent[5];
	char *	CY_CyberGLWhichContent[4];
	char *	CY_CyberGLLevelContent[4];
	char *	CY_CyberGLModeContent[7];
	char *	CY_CyberGLBoxContent[3];
};

extern struct ObjWI_CyberGL * CreateWI_CyberGL(void);
extern void DisposeWI_CyberGL(struct ObjWI_CyberGL *);
