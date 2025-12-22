#ifndef CLIB_TRITON_PROTOS_H
#define CLIB_TRITON_PROTOS_H

/*
**	$VER: triton_protos.h 6.5 (11.7.96)
**	Triton Release 2.0
**
**	triton.library prototypes
**	triton.lib definitions
*/


/********************************************************************************* Compiler specific stuff */

#ifdef _DCC

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_TRITON_H
#include <libraries/triton.h>
#endif

#define REG(x) __ ## x
#define ASM
#define STACK  __stkargs
#define REGS   __regargs

#else

#ifdef __GNUC__

#define REG(x)
#define ASM
#define STACK
#define REGS

#else /* __SASC__ */

#define REG(x) register __ ## x
#define ASM    __asm
#define STACK  __stdargs
#define REGS   __regargs

#endif /* __GNUC__ */

#endif /* _DCC */


/************************************************************************************ User-level functions */

ASM extern struct TR_Project * TR_OpenProject(REG(a1) struct TR_App *app, REG(a0) struct TagItem *);
ASM extern VOID                TR_CloseProject(REG(a0) struct TR_Project *);

ASM extern LONG                TR_FirstOccurance(REG(d0) UBYTE ch, REG(a0) STRPTR str);
ASM extern LONG                TR_NumOccurances(REG(d0) UBYTE ch, REG(a0) STRPTR str);
ASM extern STRPTR              TR_GetErrorString(REG(d0) UWORD num);
ASM extern UWORD               TR_GetLastError(REG(a1) struct TR_App *app);
ASM extern VOID                TR_CloseWindowSafely(REG(a0) struct Window *win);

ASM extern struct TR_Message * TR_GetMsg(REG(a1) struct TR_App *app);
ASM extern VOID                TR_ReplyMsg(REG(a1) struct TR_Message *message);
ASM extern ULONG               TR_Wait(REG(a1) struct TR_App *app, REG(d0) ULONG otherbits);

ASM extern ULONG               TR_SendMessage(REG(a0) struct TR_Project *project, REG(d0) ULONG objectid,
					      REG(d1) ULONG messageid, REG(a1) void *messagedata);
ASM extern VOID                TR_SetAttribute(REG(a0) struct TR_Project *, REG(d0) ULONG ID,
					       REG(d1) ULONG attribute, REG(d2) ULONG value);
ASM extern ULONG               TR_GetAttribute(REG(a0) struct TR_Project *, REG(d0) ULONG ID,
					       REG(d1) ULONG attribute);

ASM extern VOID                TR_LockProject(REG(a0) struct TR_Project *project);
ASM extern VOID                TR_UnlockProject(REG(a0) struct TR_Project *project);

ASM extern ULONG               TR_AutoRequest(REG(a1) struct TR_App *app,
					      REG(a0) struct TR_Project *lockproject,
					      REG(a2) struct TagItem *request_trwintags);
ASM extern ULONG               TR_EasyRequest(REG(a1) struct TR_App *app, REG(a2) STRPTR bodymft,
					      REG(a3) STRPTR gadfmt, REG(a0) struct TagItem *taglist);

ASM extern struct TR_App *     TR_CreateApp(REG(a1) struct TagItem *apptags);
ASM extern VOID                TR_DeleteApp(REG(a1) struct TR_App *app);

ASM extern struct Screen *     TR_LockScreen(REG(a0) struct TR_Project *project);
ASM extern VOID                TR_UnlockScreen(REG(a0) struct Screen *screen);

ASM extern struct Window *     TR_ObtainWindow(REG(a0) struct TR_Project *project);
ASM extern VOID                TR_ReleaseWindow(REG(a0) struct Window *window);


/*********************************************************************************** Class-level functions */

ASM extern BOOL                TR_AddClass(REG(a1) struct TR_App *app, REG(d0) ULONG tag,
					   REG(d1) ULONG superTag, REG(a2) TR_Method defaultMethod,
					   REG(d2) ULONG datasize, REG(a0) struct TagItem *tags);

ASM extern VOID                TR_DrawFrame(REG(a0) struct TR_Project *project,
					    REG(a1) struct RastPort *rp, REG(d1) UWORD left,
					    REG(d2) UWORD top, REG(d3) UWORD width, REG(d4) UWORD height,
					    REG(d0) UWORD type, REG(d5) BOOL inverted);
ASM extern ULONG               TR_FrameBorderHeight(REG(a0) struct TR_Project *project,
						    REG(d0) UWORD type);
ASM extern ULONG               TR_FrameBorderWidth(REG(a0) struct TR_Project *project,
						   REG(d0) UWORD type);

ASM extern ULONG               TR_TextWidth(REG(a0) struct TR_Project *project,
					    REG(a2) STRPTR text, REG(d0) ULONG flags);
ASM extern ULONG               TR_TextHeight(REG(a0) struct TR_Project *project,
					     REG(a2) STRPTR text, REG(d0) ULONG flags);
ASM extern VOID                TR_PrintText(REG(a0) struct TR_Project *project,
					    REG(a1) struct RastPort *rp, REG(a2) STRPTR text,
					    REG(d1) ULONG x, REG(d2) ULONG y,
                                            REG(d3) ULONG width, REG(d0) ULONG flags);

ASM extern ULONG               TR_GetPen(REG(a0) struct TR_Project *project,
					 REG(d0) ULONG pentype, REG(d1) ULONG pendata);
ASM extern ULONG               TR_DoMethod(REG(a0) struct TROD_Object *object,
					   REG(d0) ULONG messageid, REG(a1) APTR data);
ASM extern ULONG               TR_DoMethodClass(REG(a0) struct TROD_Object *object,
						REG(d0) ULONG messageid, REG(a1) APTR data,
						REG(a2) struct TR_Class *cl);

ASM extern VOID                TR_AreaFill(REG(a0) struct TR_Project *project, REG(a1) struct RastPort *rp,
					   REG(d0) ULONG left, REG(d1) ULONG top, REG(d2) ULONG right,
					   REG(d3) ULONG bottom, REG(d4) ULONG type, REG(a2) VOID *dummy);

ASM extern struct TR_Message * TR_CreateMsg(REG(a1) struct TR_App *app);


/***************************************************************************************** Support library */

#ifndef TR_NOSUPPORT

STACK extern BOOL                 TR_OpenTriton(ULONG version, ULONG taglist,...);
REGS  extern VOID                 TR_CloseTriton(VOID);
STACK extern struct TR_App     *  TR_CreateAppTags(ULONG taglist,...);
STACK extern struct TR_Project *  TR_OpenProjectTags(struct TR_App *app, ULONG taglist,...);
STACK extern ULONG                TR_EasyRequestTags(struct TR_App *app, STRPTR bodymft, STRPTR gadfmt,
						     ULONG taglist,...);
STACK extern ULONG                TR_AutoRequestTags(struct TR_App *app, struct TR_Project *lockproject,
						     ULONG taglist,...);
STACK extern BOOL                 TR_AddClassTags(struct TR_App *app, ULONG tag, ULONG superTag,
						  TR_Method defaultMethod, ULONG datasize,
						  ULONG taglist,...);
REGS  extern BOOL                 TRIM_trLogo_Init(VOID);
REGS  extern VOID                 TRIM_trLogo_Free(VOID);

#endif /* TR_NOSUPPORT */


/************************************************************************************************* The End */

#endif /* CLIB_TRITON_PROTOS_H */
