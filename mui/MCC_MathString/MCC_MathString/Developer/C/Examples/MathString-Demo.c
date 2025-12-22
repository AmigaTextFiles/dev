#include "demo.h"
#include "MathString_mcc.h"
#include "math.h"

struct Library *MUIMasterBase;


struct constdef my_const[] = {
	'a',	1.0,
	'b',	2.0,
	'pi',	3.1415926,
	NULL,	0.0
};

/* disable SAS/C Ctrl-C handling */

int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}


SAVEDS ASM ULONG absf(	REG(a0) struct Hook *h,
			REG(a1) double *arg,
			REG(a2) Object *obj)
{
	*arg = (*arg>=0)?*arg:-(*arg);	/* absolute value */
	return 0;
}

SAVEDS ASM ULONG sqrf(	REG(a0) struct Hook *h,
			REG(a1) double *arg,
			REG(a2) Object *obj)
{
	if (*arg<0.0)
		return 260;	/* custom error code */
	*arg = sqrt(*arg);	/* square root */
	return 0;
}

struct fundef myfun[] = {
	MAKE_ID( 0 ,'a','b','s'),	{{0,0},absf,0,0},
	MAKE_ID('s','q','r','t'),	{{0,0},sqrf,0,0},
	NULL	};




BOOL InitLibs(VOID)
{
	MUIMasterBase=OpenLibrary("muimaster.library",9);
	return ((BOOL)(MUIMasterBase));
}

VOID ExitLibs(VOID)
{
	if (MUIMasterBase)	CloseLibrary(MUIMasterBase);
}

int main(int argc, char *argv[])
{
	ULONG sigs=0;
	Object *app, *win;
	Object *bte, *btg, *mso,*to;
	ULONG r,ver,rev;
	double val=3.14;
	double *valp;

	if (InitLibs()) {

			app= ApplicationObject,
				MUIA_Application_Title,			"TestMathString",
				MUIA_Application_Version,		"$VER: TestMathString 1.1 (15.4.96)",
				MUIA_Application_Copyright,	"©1996 V. Gervasi",
				MUIA_Application_Author,		"Vincenzo Gervasi",
				MUIA_Application_Description,	"MathString Test Program",
				MUIA_Application_Base,			"TestMathS",
				SubWindow,							win=WindowObject,
					MUIA_Window_Title,			"Test for MathString "VERSION"."REVISION,
					MUIA_Window_ID,				MAKE_ID('W','I','N','0'),
					WindowContents,	VGroup,
						Child, HGroup,
							Child, 						TextObject,
								MUIA_Text_Contents,	"Enter an expression:",
								End,
							Child,					bte=KeyButton("Eval",'e'),
							Child,					btg=KeyButton("Get",'g'),
							End,
						Child,						mso=MathStringObject,
							StringFrame,
							MUIA_MathString_Units, 			MUIV_MathString_Units_Typo,
							MUIA_MathString_DefaultUnit,	0,
							MUIA_MathString_ValueMode,		MUIV_MathString_ValueMode_dIEEEptr,
							MUIA_MathString_ValueUnit,		MUIV_MathString_ValueUnit_Absolute,
							MUIA_MathString_Value,			&val,
							MUIA_MathString_ValueFormat,	"%.5g %s",
							MUIA_MathString_Constants,		&my_const,
//							MUIA_MathString_Behaviour,		MSB_ONEVAL_SUBST,
							End,
						Child,						to=TextObject,
							End,
						End,
					End,
				End;

			if (app) {
				DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
				DoMethod(bte,MUIM_Notify,MUIA_Pressed,FALSE,mso,1,MUIM_MathString_Eval);
				DoMethod(btg,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,1);
				DoMethod(mso,MUIM_Notify,MUIA_MathString_Value,MUIV_EveryTime,app,2,MUIM_Application_ReturnID,1);
				DoMethod(mso,MUIM_Notify,MUIA_MathString_LastError,MUIV_EveryTime,to,4,MUIM_SetAsString,MUIA_Text_Contents,"Error: %ld",MUIV_TriggerValue);

				set(mso,MUIA_MathString_Functions,myfun);

				get(mso,MUIA_MathString_Behaviour,&r);
				set(mso,MUIA_MathString_Behaviour,r | MSB_ONGETVALUE_EVAL);

				set(win,MUIA_Window_Open,TRUE);

				get(mso,MUIA_Version,&ver);
				get(mso,MUIA_Revision,&rev);
				
				printf("MathString Object reports version %ld.%ld\n",ver,rev);

				while ((r=DoMethod(app,MUIM_Application_NewInput, &sigs)) != MUIV_Application_ReturnID_Quit) {
					if (sigs) {
						sigs = Wait(sigs | SIGBREAKF_CTRL_C);
						if (sigs & SIGBREAKF_CTRL_C) break;
					}
					if (r==1) {
						get(mso,MUIA_MathString_Value,&valp);
						printf("Value: %.20g\n",*valp);
					}
				}

				MUI_DisposeObject(app);

			}
		ExitLibs();
	}
}
