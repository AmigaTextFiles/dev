;MUIExtend - Test

	include	utility/tagitem.i
	include	lvo/exec_lib.i
	include	lvo/muiextend_lib.i
	include	"mui.i"
	include	libraries/muiextend.i
	include	libraries/muiextend_macros.i

Main:
	movea.l	(4.w),a6
	lea		_MUIExtendName,a1
	moveq		#0,d0
	jsr		_LVOOpenLibrary(a6)			;Open MUIExtend.library
	move.l	d0,_MUIExtendBase
	beq.w		.openmuiextenderror
	movea.l	_MUIExtendBase(pc),a6
	lea.l		Application,a0
	moveq		#0,d0
	jsr		_LVOMUIE_MakeObjects(a6)
	tst.l		d0
	beq.w		.initmuierror
	lea.l		Method_1,a0
	moveq		#0,d0
	jsr		_LVOMUIE_MakeMethods(a6)
	lea.l		Application,a0
	jsr		_LVOMUIE_Main(a6)
	lea.l		Application,a0
	jsr		_LVOMUIE_DisposeObjects(a6)
.initmuierror:
	movea.l	(4.w),a6
	movea.l	_MUIExtendBase(pc),a1
	jsr		_LVOCloseLibrary(a6)
.openmuiextenderror:
	moveq		#10,d0
	rts

;***************************** Application *********************************
Application:	ApplicationObject	NULL,Main_WI
		TagItem	MUIA_Application_Author,.author,MUIA_Application_Base,.base,MUIA_Application_Title,.title,MUIA_Application_Version,.version,MUIA_Application_Copyright,.copyright,MUIA_Application_Description,.desc,TAG_END
.title:				dc.b	"MUIExtend_library",0
.author:				dc.b	"Robin Cloutman",0
.base:				dc.b	"MUIE",0
.version:			dc.b	"$VER: MUIExtend 1.1 (21.8.97)",0
.copyright:			dc.b	"©1997 Robin Cloutman",0
.desc:				dc.b	"Easier creation of MUI applications",0
	EVEN
;***************************** Main Window *********************************
Main_WI:	WindowObject	NULL,main_GR,MUIA_Window_Title,.winTitle,MUIA_Window_ScreenTitle,.screenTitle,MUIA_Window_ID,'MAIN',TAG_END
.winTitle:			dc.b	"MUIExtend - test",0
.screenTitle:		dc.b	"MUIExtend",0
	EVEN
	Method	Main_WI,MUIM_Notify,Imm,MUIA_Window_CloseRequest,Imm,TRUE,Imm,MUIV_Notify_Application,Imm,2,Imm,MUIM_Application_ReturnID,Imm,-1
main_GR:			GroupObject	NULL,mainpop,MUIA_Background,MUII_WindowBack,TAG_END
mainpop:				PopaslObject	NULL,maintxt,MUIA_ShortHelp,.help,TAG_END
.help:		dc.b	"Easy add help text",0
	EVEN
maintxt:					String	mainbut,.demostring,80
.demostring:		dc.b	"This is a demonstration string",0
	EVEN
mainbut:					PopButton	NULL,MUII_PopFile

;*************************** OpenWindow Method *****************************
	LastMethod	Main_WI,MUIM_Set,Imm,MUIA_Window_Open,Imm,TRUE

;********************************** Data ***********************************
_MUIExtendBase:	dc.l	0

_MUIExtendName:	dc.b	'muiextend.library',0

PreParse:			dc.b	27,"c",0

	include	"muiclasses.i"

	ENDC
