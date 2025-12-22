**
**       Assembler Source Code For The MUI Demo Program
**       ----------------------------------------------
**
**              written 1993 by Henri Veisterä
**
**         (modified from the C code by Stefan Stuntz)
**
** Even if it doesn't look so, all of the code below is pure Assembler,
** just a little bit enhanced with some MUI specific macros.
**

		opt	o+,c+,l+

		XREF	_DoMethod

		bra	_main

		include	"exec/types.i"
		include	"exec/libraries.i"
		include	"exec/memory.i"
		include	"exec/exec_lib.i"

		include	"dos/dos_lib.i"
		include	"dos/dosextens.i

		include	"intuition/intuition_lib.i"

		include	"libraries/gadtools.i"

		include	"libraries/mui_lib.i"
		include	"libraries/mui.i"
		include	"libraries/mui_asm.i"


**
** Some Macros to make my life easier and the actual source
** code more readable.
**

Listi MACRO ; ftxt
   ListviewObject
      MUIT MUIA_Weight,50,MUIA_Listview_Input,FALSE,MUIA_Listview_List
      FloattextObject
	 MUIT MUIA_Frame,MUIV_FrameReadList,MUIA_Floattext_Text,\1,MUIA_Floattext_TabSize,4,MUIA_Floattext_Justify,TRUE,Endi
      Endi
   ENDM

DemoWindow MACRO ; name,id,info
   WindowObject
      MUIT MUIA_Window_Title,\1,MUIA_Window_ID,\2,WindowContents
      VGroup
	 Childi Listi,\3
   ENDM

ImageLine MACRO ; name,nr
   HGroup
      Childi TextObject
	 MUIT MUIA_Text_PreParse,PreParse2,MUIA_Text_Contents,\1,MUIA_FixWidthTxt,rbut1,Endi
      Childi VGroup
	 Childi VSpace,0
	 Child3 ImageObject,MUIT,MUIA_Image_Spec,\2,Endi
	 Childi VSpace,0
	 Endi
      Endi
   ENDM

ScaledImage MACRO ; nr,s,x,y
   ImageObject
      MUIT MUIA_Image_Spec,\1,MUIA_FixWidth,\3,MUIA_FixHeight,\4
      MUIT MUIA_Image_FreeHoriz,TRUE,MUIA_Image_FreeVert,TRUE
      MUIT MUIA_Image_State,\2
      Endi
   ENDM

HProp MACRO
   PropObject
      PropFrame
      MUIT MUIA_Prop_Horiz,TRUE,MUIA_FixHeight,8,MUIA_Prop_Entries,111,MUIA_Prop_Visible,10
      Endi
   ENDM

VProp MACRO
   PropObject
      PropFrame
      MUIT MUIA_Prop_Horiz,FALSE,MUIA_FixWidth,8,MUIA_Prop_Entries,111,MUIA_Prop_Visible,10
      Endi
   ENDM

*** See if we were run from Workbench, if so, get msg and reply to it

_main		move.l	$4,_ExecBase

		sub.l	a1,a1
		CALLEXEC FindTask
		move.l	d0,a4

		tst.l	pr_CLI(a4)
		beq.s	fromWorkbench

*** we were called from the CLI

		bra.s	end_startup

*** we were called from the Workbench

fromWorkbench	lea	pr_MsgPort(a4),a0
		CALLEXEC WaitPort
		lea	pr_MsgPort(a4),a0
		CALLEXEC GetMsg
		move.l	d0,returnMsg

*** call our program

end_startup	bsr.s	main

*** returns to here with exit code in d0

		move.l	d0,-(sp)

		tst.l	returnMsg
		beq.s	exitToDOS

		CALLEXEC Forbid
		move.l	returnMsg(pc),a1
		CALLEXEC ReplyMsg

exitToDOS	move.l	(sp)+,d0
		rts

*** Open all libraries

main		lea	dosname(pc),a1
		move.l	#36,d0
		CALLEXEC OpenLibrary
		move.l	d0,_DOSBase
		beq	end

		lea	muimname(pc),a1
		move.l	#MUIMASTER_VMIN,d0
		CALLEXEC OpenLibrary
		move.l	d0,_MUIMasterBase
		beq	closedos

		lea	intname(pc),a1
		move.l	#37,d0
		CALLEXEC OpenLibrary
		move.l	d0,_IntuitionBase
		beq	closemui

*** Allocate space for tagitems.  Your program gets the maximum
*** tagspace usage in bytes in the variable TAG_SPACE.
*** Allocated space must be passed in the address register MR.

MR		EQUR	a4

		move.l	tagspace(pc),d0
		move.l	#MEMF_ANY,d1
		CALLEXEC AllocMem
		move.l	d0,tag_mem
		beq	closeint
		move.l	d0,MR


**
** Every MUI application needs an application object
** which will hold general information and serve as
** a kind of anchor for user input, ARexx functions,
** commodities interface, etc.
**
** An application may have any number of SubWindows
** which can all be created in the same call or added
** later, according to your needs.
**
** Note that creating a window does not mean to
** open it, this will be done later by setting
** the windows open attribute.
**

		ApplicationObject
		   MUIT MUIA_Application_Title,titl1
		   MUIT MUIA_Application_Version,vers1
		   MUIT MUIA_Application_Copyright,copy1
		   MUIT MUIA_Application_Author,auth1
		   MUIT MUIA_Application_Description,desc1
		   MUIT MUIA_Application_Base,base1
		   MUIT MUIA_Application_Menu,MyMenus

		   SubWindowi
		      DemoWindow stri1,"STRG",IN_String
			 Childi ListviewObject
			    MUIT MUIA_Listview_Input,TRUE,MUIA_Listview_List
			    ListObject
			       InputListFrame
			       Endi
			    Endi
			    is LV_Brian
			 Child2 StringObject,StringFrame,Endi
			 is ST_Brian
			 Endi
		      Endi
		      is WI_String

		   SubWindowi
		      DemoWindow cycl1,"CYCL",IN_Cycle
			 Childi HGroup
			    Childi Radio,comp1,CYA_Computer
			    is MT_Computer
			    Childi VGroup
			       Childi Radio,prin1,CYA_Printer
			       is MT_Printer
			       Childi VSpace,0
			       Childi Radio,disp1,CYA_Display
			       is MT_Display
			       Endi
			    Childi VGroup
			       Childi ColGroup,2
				  GroupFrameT cycl2
				  Childi Label1,comp2
				  Childi KeyCycle,CYA_Computer,"c"
				  is CY_Computer
				  Childi Label1,prin2
				  Childi KeyCycle,CYA_Printer,"p"
				  is CY_Printer
				  Childi Label1,disp2
				  Childi KeyCycle,CYA_Display,"d"
				  is CY_Display
				  Endi
			       Childi ListviewObject
				  MUIT MUIA_Listview_Input,TRUE
				  MUIT MUIA_Listview_List
				  ListObject
				     InputListFrame
				     Endi
			          Endi
			          is LV_Computer
			       Endi
			    Endi
			 Endi
		      Endi
		      is WI_Cycle

		   SubWindowi
		      DemoWindow list1,"LIST",IN_Listviews
			 Childi HGroup
			    GroupFrameT dire1
			    Childi ListviewObject
			       MUIT MUIA_Listview_Input,TRUE
			       MUIT MUIA_Listview_MultiSelect,TRUE
			       MUIT MUIA_Listview_List
			       DirlistObject
				  InputListFrame
				  MUIT MUIA_Dirlist_Directory,ram1,Endi
			       Endi
			       is LV_Directory
			    Childi ListviewObject
			       MUIT MUIA_Weight,20
			       MUIT MUIA_Listview_Input,TRUE
			       MUIT MUIA_Listview_List
			       VolumelistObject
				  InputListFrame
				  MUIT MUIA_Dirlist_Directory,ram1,Endi
			       Endi
			       is LV_Volumes
			    Endi
			 Endi
		      Endi
		      is WI_Listviews

		   SubWindowi
		      DemoWindow noti1,"BRCA",IN_Notify
			 Childi HGroup
			    GroupFrameT conn1
			    Child2 GaugeObject,GaugeFrame
			       MUIT MUIA_Gauge_Horiz,FALSE,MUIA_FixWidth,16,Endi
			       is GA_Gauge1
			    Childi VProp
			    is PR_PropL
			    Childi VProp
			    is PR_PropR
			    Childi VGroup
			       Childi VSpace,0
			       Childi HProp
			       is PR_PropA
			       Childi HGroup
				  Childi HProp
				  is PR_PropH
				  Childi HProp
				  is PR_PropV
				  Endi
			       Childi VSpace,0
			       Childi VGroup
				  GroupSpacing 1
				  Child2 GaugeObject,GaugeFrame
				     MUIT MUIA_Gauge_Horiz,TRUE,Endi
				     is GA_Gauge2
				  Child3 ScaleObject,MUIT,MUIA_Scale_Horiz,TRUE,Endi
				  Endi
			       Childi VSpace,0
			       Endi
			    Childi VProp
			    is PR_PropT
			    Childi VProp
			    is PR_PropB
			    Child2 GaugeObject,GaugeFrame
			       MUIT MUIA_Gauge_Horiz,FALSE,MUIA_FixWidth,16,Endi
			       is GA_Gauge3
			    Endi
			 Endi
		      Endi
		      is WI_Notify

		   SubWindowi
		      DemoWindow back1,"BACK",IN_Backfill
			 Childi VGroup
			    GroupFrameT stan1
			    Childi HGroup
			       Child2 RectangleObject,TextFrame
			          MUIT MUIA_Background,MUII_BACKGROUND,Endi
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_FILL,Endi
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_SHADOW,Endi
			       Endi
			    Childi HGroup
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_SHADOWBACK,Endi
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_SHADOWFILL,Endi
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_SHADOWSHINE,Endi
			       Endi
			    Childi HGroup
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_FILLBACK,Endi
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_SHINEBACK,Endi
		               Child2 RectangleObject,TextFrame
		                  MUIT MUIA_Background,MUII_FILLSHINE,Endi
			       Endi
			    Endi
			 Endi
		      Endi
		      is WI_Backfill

		   SubWindowi
		      DemoWindow grou1,"GRPS",IN_Groups
			 Child3 HGroup,GroupFrameT,grou2
			    Child3 HGroup,GroupFrameT,hori1
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Endi
			    Child3 VGroup,GroupFrameT,vert1
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Endi
			    Childi ColGroup,3
			       GroupFrameT arra1
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Child2 RectangleObject,TextFrame,Endi
			       Endi
			    Endi
			 Child3 HGroup,GroupFrameT,diff1
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,kg25,MUIA_Weight,25,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,kg50,MUIA_Weight,50,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,kg75,MUIA_Weight,75,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,kg100,MUIA_Weight,100,Endi
			    Endi
			 Child3 HGroup,GroupFrameT,fixe1
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,fixe2,MUIA_Text_SetMax,TRUE,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,free1,MUIA_Text_SetMax,FALSE,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,fixe2,MUIA_Text_SetMax,TRUE,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,free1,MUIA_Text_SetMax,FALSE,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,fixe2,MUIA_Text_SetMax,TRUE,Endi
			    Endi
			 Endi
		      Endi
		      is WI_Groups

		   SubWindowi
		      DemoWindow fram1,"FRMS",IN_Frames
		         Childi ColGroup,2
			    Child2 TextObject,ButtonFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,butt1,Endi
			    Child2 TextObject,ImageButtonFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,imag1,Endi
			    Child2 TextObject,TextFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,text1,Endi
			    Child2 TextObject,StringFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,stri2,Endi
			    Child2 TextObject,ReadListFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,read1,Endi
			    Child2 TextObject,InputListFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,inpu1,Endi
			    Child2 TextObject,PropFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,prop1,Endi
			    Child2 TextObject,GroupFrame
			       MUIT MUIA_Background,MUII_TextBack,MUIA_Text_Contents,grou3,Endi
			    Endi
			 Endi
		      Endi
		      is WI_Frames

		   SubWindowi
		      DemoWindow imag2,"IMGS",IN_Images
		         Childi HGroup
			    Child3 VGroup,GroupFrameT,stan2
			       Childi ImageLine,arro1,MUII_ArrowUp
			       Childi ImageLine,arro2,MUII_ArrowDown
			       Childi ImageLine,arro3,MUII_ArrowLeft
			       Childi ImageLine,arro4,MUII_ArrowRight
			       Childi ImageLine,radi1,MUII_RadioButton
			       Childi ImageLine,file1,MUII_PopFile
			       Childi ImageLine,hard1,MUII_HardDisk
			       Childi ImageLine,disk1,MUII_Disk
			       Childi ImageLine,chip1,MUII_Chip
			       Childi ImageLine,draw1,MUII_Drawer
			       Endi
			    Child3 VGroup,GroupFrameT,scal1
			       Childi VSpace,0
			       Childi HGroup
				  Childi ScaledImage,MUII_RadioButton,1,17,9
				  Childi ScaledImage,MUII_RadioButton,1,20,12
				  Childi ScaledImage,MUII_RadioButton,1,23,15
				  Childi ScaledImage,MUII_RadioButton,1,26,18
				  Childi ScaledImage,MUII_RadioButton,1,29,21
				  Endi
			       Childi VSpace,0
			       Childi HGroup
				  Childi ScaledImage,MUII_CheckMark,1,13,7
				  Childi ScaledImage,MUII_CheckMark,1,16,10
				  Childi ScaledImage,MUII_CheckMark,1,19,13
				  Childi ScaledImage,MUII_CheckMark,1,22,16
				  Childi ScaledImage,MUII_CheckMark,1,25,19
				  Childi ScaledImage,MUII_CheckMark,1,28,22
				  Endi
			       Childi VSpace,0
			       Childi HGroup
				  Childi ScaledImage,MUII_PopFile,0,12,10
				  Childi ScaledImage,MUII_PopFile,0,15,13
				  Childi ScaledImage,MUII_PopFile,0,18,16
				  Childi ScaledImage,MUII_PopFile,0,21,19
				  Childi ScaledImage,MUII_PopFile,0,24,22
				  Childi ScaledImage,MUII_PopFile,0,27,25
				  Endi
			       Childi VSpace,0
			       Endi
			    Endi
			 Endi
		      Endi
		      is WI_Images

		   SubWindowi
		      WindowObject
		      MUIT MUIA_Window_Title,titl1
		      MUIT MUIA_Window_ID,"MAIN",WindowContents
		      VGroup
			 Child2 TextObject,GroupFrame
			    MUIT MUIA_Background,MUII_SHADOWFILL
			    MUIT MUIA_Text_Contents,tcon1,Endi

			 Childi Listi,IN_Master

			 Childi VGroup
			    GroupFrameT avad1
			    Childi HGroup
			       MUIT MUIA_Group_SameWidth,TRUE
			       Childi KeyButton,grou4,"g"
			       is BT_Groups
			       Childi KeyButton,fram2,"f"
			       is BT_Frames
			       Childi KeyButton,back2,"b"
			       is BT_Backfill
			       Endi
			    Childi HGroup
			       MUIT MUIA_Group_SameWidth,TRUE
			       Childi KeyButton,noti2,"n"
			       is BT_Notify
			       Childi KeyButton,list2,"l"
			       is BT_Listviews
			       Childi KeyButton,cycl3,"c"
			       is BT_Cycle
			       Endi
			    Childi HGroup
			       MUIT MUIA_Group_SameWidth,TRUE
			       Childi KeyButton,imag3,"i"
			       is BT_Images
			       Childi KeyButton,stri3,"s"
			       is BT_String
			       Childi KeyButton,quit1,"q"
			       is BT_Quit
			       Endi
			    Endi
			 Endi
		      Endi
		      is WI_Master

		   Endi
		   is AP_Demo


**
** See if the application was created. The fail function
** deletes every created object and closes everything.
**
** Note that we do not need any
** error control for the sub objects since every error
** will automatically be forwarded to the parent object
** and cause this one to fail too.
**

		tst.l	AP_Demo
		beq	fail


**
** Here comes the broadcast magic. Notifying means:
** When an attribute of an object changes, then please change
** another attribute of another object (accordingly) or send
** a method to another object.
**

**
** Lets bind the sub windows to the corresponding button
** of the master window.
**

	DoMethod BT_Frames,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Frames,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_Images,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Images,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_Notify,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Notify,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_Listviews,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Listviews,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_Groups,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Groups,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_Backfill,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Backfill,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_Cycle,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_Cycle,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE
	DoMethod BT_String,#MUIM_Notify,#MUIA_Pressed,#FALSE,WI_String,#3,#MUIM_Set,#MUIA_Window_Open,#TRUE

	DoMethod BT_Quit,#MUIM_Notify,#MUIA_Pressed,#FALSE,AP_Demo,#2,#MUIM_Application_ReturnID,#MUIV_Application_ReturnID_Quit


**
** Automagically remove a window when the user hits the close gadget.
**

	DoMethod WI_Images,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Images,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_Frames,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Frames,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_Notify,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Notify,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_Listviews,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Listviews,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_Groups,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Groups,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_Backfill,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Backfill,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_Cycle,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_Cycle,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE
	DoMethod WI_String,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,WI_String,#3,#MUIM_Set,#MUIA_Window_Open,#FALSE


**
** Closing the master window forces a complete shutdown of the application.
**

	DoMethod WI_Master,#MUIM_Notify,#MUIA_Window_CloseRequest,#TRUE,AP_Demo,#2,#MUIM_Application_ReturnID,#MUIV_Application_ReturnID_Quit


**
** This connects the prop gadgets in the broadcast demo window.
**

	DoMethod PR_PropA,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,PR_PropH,#3,#MUIM_Set,#MUIA_Prop_First,#MUIV_TriggerValue
	DoMethod PR_PropA,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,PR_PropV,#3,#MUIM_Set,#MUIA_Prop_First,#MUIV_TriggerValue
	DoMethod PR_PropH,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,PR_PropL,#3,#MUIM_Set,#MUIA_Prop_First,#MUIV_TriggerValue
	DoMethod PR_PropH,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,PR_PropR,#3,#MUIM_Set,#MUIA_Prop_First,#MUIV_TriggerValue
	DoMethod PR_PropV,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,PR_PropT,#3,#MUIM_Set,#MUIA_Prop_First,#MUIV_TriggerValue
	DoMethod PR_PropV,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,PR_PropB,#3,#MUIM_Set,#MUIA_Prop_First,#MUIV_TriggerValue

	DoMethod PR_PropA,#MUIM_Notify,#MUIA_Prop_First,#MUIV_EveryTime,GA_Gauge2,#3,#MUIM_Set,#MUIA_Gauge_Current,#MUIV_TriggerValue
	DoMethod GA_Gauge2,#MUIM_Notify,#MUIA_Gauge_Current,#MUIV_EveryTime,GA_Gauge1,#3,#MUIM_Set,#MUIA_Gauge_Current,#MUIV_TriggerValue
	DoMethod GA_Gauge2,#MUIM_Notify,#MUIA_Gauge_Current,#MUIV_EveryTime,GA_Gauge3,#3,#MUIM_Set,#MUIA_Gauge_Current,#MUIV_TriggerValue


**
** And here we connect cycle gadgets, radio buttons and the list in the
** cycle & radio window.
**

	DoMethod CY_Computer,#MUIM_Notify,#MUIA_Cycle_Active,#MUIV_EveryTime,MT_Computer,#3,#MUIM_Set,#MUIA_Radio_Active,#MUIV_TriggerValue
	DoMethod CY_Printer,#MUIM_Notify,#MUIA_Cycle_Active,#MUIV_EveryTime,MT_Printer,#3,#MUIM_Set,#MUIA_Radio_Active,#MUIV_TriggerValue
	DoMethod CY_Display,#MUIM_Notify,#MUIA_Cycle_Active,#MUIV_EveryTime,MT_Display,#3,#MUIM_Set,#MUIA_Radio_Active,#MUIV_TriggerValue
	DoMethod MT_Computer,#MUIM_Notify,#MUIA_Radio_Active,#MUIV_EveryTime,CY_Computer,#3,#MUIM_Set,#MUIA_Cycle_Active,#MUIV_TriggerValue
	DoMethod MT_Printer,#MUIM_Notify,#MUIA_Radio_Active,#MUIV_EveryTime,CY_Printer,#3,#MUIM_Set,#MUIA_Cycle_Active,#MUIV_TriggerValue
	DoMethod MT_Display,#MUIM_Notify,#MUIA_Radio_Active,#MUIV_EveryTime,CY_Display,#3,#MUIM_Set,#MUIA_Cycle_Active,#MUIV_TriggerValue
	DoMethod MT_Computer,#MUIM_Notify,#MUIA_Radio_Active,#MUIV_EveryTime,LV_Computer,#3,#MUIM_Set,#MUIA_List_Active,#MUIV_TriggerValue
	DoMethod LV_Computer,#MUIM_Notify,#MUIA_List_Active ,#MUIV_EveryTime,MT_Computer,#3,#MUIM_Set,#MUIA_Radio_Active,#MUIV_TriggerValue


**
** This one makes us receive input ids from several list views.
**

	DoMethod LV_Volumes,#MUIM_Notify,#MUIA_Listview_DoubleClick,#TRUE,AP_Demo,#2,#MUIM_Application_ReturnID,#ID_NEWVOL
	DoMethod LV_Brian,#MUIM_Notify,#MUIA_List_Active,#MUIV_EveryTime,AP_Demo,#2,#MUIM_Application_ReturnID,#ID_NEWBRI


**
** Now lets set the TAB cycle chain for some of our windows.
**

	DoMethod WI_Master,#MUIM_Window_SetCycleChain,BT_Groups,BT_Frames,BT_Backfill,BT_Notify,BT_Listviews,BT_Cycle,BT_Images,BT_String,NULL
	DoMethod WI_Listviews,#MUIM_Window_SetCycleChain,LV_Directory,LV_Volumes,NULL
	DoMethod WI_Cycle,#MUIM_Window_SetCycleChain,MT_Computer,MT_Printer,MT_Display,CY_Computer,CY_Printer,CY_Display,LV_Computer,NULL
	DoMethod WI_String,#MUIM_Window_SetCycleChain,ST_Brian,NULL


**
** Set some start values for certain objects.
**

	DoMethod LV_Computer,#MUIM_List_Insert,#CYA_Computer,#-1,#MUIV_List_Insert_Bottom
	DoMethod LV_Brian,#MUIM_List_Insert,#LVT_Brian,#-1,#MUIV_List_Insert_Bottom
	seti LV_Computer,#MUIA_List_Active,#0
	seti LV_Brian,#MUIA_List_Active,#0
	seti ST_Brian,#MUIA_String_AttachedList,LV_Brian


**
** Everything's ready, lets launch the application. We will
** open the master window now.
**

	seti WI_Master,#MUIA_Window_Open,#TRUE


**
** This is the main loop. As you can see, it does just nothing.
** Everything is handled by MUI, no work for the programmer.
**
** The only thing we do here is to react on a double click
** in the volume list (which causes an ID_NEWVOL) by setting
** a new directory name for the directory list. If you want
** to see a real file requester with MUI, wait for the
** next release of MFR :-)
**

main_loop	DoMethod AP_Demo,#MUIM_Application_Input,#signal

		cmp.l	#MUIV_Application_ReturnID_Quit,d0
		bne	switch1
		move.w	#FALSE,running
		bra	quit_now

switch1		cmp.l	#ID_NEWVOL,d0
		bne	switch2
		DoMethod LV_Volumes,#MUIM_List_GetEntry,#MUIV_List_GetEntry_Active,#buf
		seti LV_Directory,#MUIA_Dirlist_Directory,buf
		bra	switch4

switch2		cmp.l	#ID_NEWBRI,d0
		bne	switch3
		geti LV_Brian,#MUIA_List_Active,#buf
		move.l	#LVT_Brian,a0
		move.l	buf(pc),d0
		asl.l	#2,d0
		move.l	(a0,d0.l),d0
		seti ST_Brian,#MUIA_String_Contents,d0
		bra	switch4

switch3		cmp.l	#ID_ABOUT,d0
		bne	switch4
		MUI_Request AP_Demo,WI_Master,0,NULL,gads1,muid1
		
switch4		move.l	signal(pc),d0
		beq	main_loop
		CALLEXEC Wait
		bra	main_loop

quit_now	move.l	#0,error
		bra.s	freemem

fail		CALLMUI MUI_Error
		move.w	d0,muierror

		move.l   #erro1,d1
		move.l   #muierror,d2
		CALLDOS VPrintf

freemem		tst.l	tag_mem
		beq.s	freeobj
		move.l	tagspace(pc),d0
		move.l	tag_mem(pc),a1
		CALLEXEC FreeMem

freeobj		tst.l	AP_Demo
		beq.s	closeint
		move.l	AP_Demo(pc),a0
		CALLMUI MUI_DisposeObject

closeint	tst.l	_IntuitionBase
		beq.s	closemui
		move.l	_IntuitionBase(pc),a1
		CALLEXEC CloseLibrary

closemui	tst.l	_MUIMasterBase
		beq.s	closedos
		move.l	_MUIMasterBase(pc),a1
		CALLEXEC CloseLibrary

closedos	tst.l	_DOSBase
		beq.s	end
		move.l	_DOSBase(pc),a1
		CALLEXEC CloseLibrary

end		move.l	error(pc),d0
		rts


*** Library bases

_ExecBase	dc.l	0
_DOSBase	dc.l	0
_IntuitionBase	dc.l	0
_MUIMasterBase	dc.l	0

*** Library names

dosname		dc.b	"dos.library",0
muimname	MUIMASTER_NAME
intname		INTNAME

*** Misc. vars

returnMsg	dc.l	0
error		dc.l	20
signal		dc.l	0
muierror	dc.w	0
running		dc.w	0
buf		dc.l	0
tag_mem		dc.l	0

*** The place to store TAG_SPACE _must_ be after all MUI creation macros.
*** Note: This depends on the order of compilation.  As the MUI macros
*** are compiled, the TAG_SPACE variable is increased.  When we reach
*** this position it has some meaningfull value.

tagspace	dc.l	TAG_SPACE

** Misc strings

rbut1		dc.b	"RadioButton:",0
base1		dc.b	"MUIDEMO",0
desc1		dc.b	"Demonstrate the features of MUI.",0
auth1		dc.b	"Stefan Stuntz",0
copy1		dc.b	"Copyright ©1993, Stefan Stuntz",0
vers1		dc.b	"$VER: MUI-Demo 4.4 (08.08.93)",0
titl1		dc.b	"MUI-Demo",0
stri1		dc.b	"String",0
cycl1		dc.b	"Cycle Gadgets & RadioButtons",0
comp1		dc.b	"Computer:",0
prin1		dc.b	"Printer:",0
disp1		dc.b	"Display:",0
cycl2		dc.b	"Cycle Gadgets",0
comp2		dc.b	"Computer:",0
prin2		dc.b	"Printer:",0
disp2		dc.b	"Display:",0
list1		dc.b	"Listviews",0
dire1		dc.b	"Dir & Volume List",0
ram1		dc.b	"ram:",0
noti1		dc.b	"Notifying",0
conn1		dc.b	"Connections",0
back1		dc.b	"Backfill",0
stan1		dc.b	"Standard Backgrounds",0
grou1		dc.b	"Groups",0
grou2		dc.b	"Group Types",0
hori1		dc.b	"Horizontal",0
vert1		dc.b	"Vertical",0
arra1		dc.b	"Array",0
diff1		dc.b	"Different Weights",0
kg25		dc.b	27,"c25 kg",0
kg50		dc.b	27,"c50 kg",0
kg75		dc.b	27,"c75 kg",0
kg100		dc.b	27,"c100 kg",0
fixe1		dc.b	"Fixed & Variable Sizes",0
fixe2		dc.b	"fixed",0
free1		dc.b	27,"cfree",0
fram1		dc.b	"Frames",0
butt1		dc.b	27,"cButton",0
imag1		dc.b	27,"cImageButton",0
text1		dc.b	27,"cText",0
stri2		dc.b	27,"cString",0
read1		dc.b	27,"cReadList",0
inpu1		dc.b	27,"cInputList",0
prop1		dc.b	27,"cProp Gadget",0
grou3		dc.b	27,"cGroup",0
imag2		dc.b	"Images",0
stan2		dc.b	"Standard Images",0
arro1		dc.b	"ArrowUp:",0
arro2		dc.b	"ArrowDown:",0
arro3		dc.b	"ArrowLeft:",0
arro4		dc.b	"ArrowRight:",0
radi1		dc.b	"RadioButton:",0
file1		dc.b	"File:",0
hard1		dc.b	"HardDisk:",0
disk1		dc.b	"Disk:",0
chip1		dc.b	"Chip:",0
draw1		dc.b	"Drawer:",0
scal1		dc.b	"Scale Engine",0
tcon1		dc.b	27,"c",27,"8MUI - ",27,"bM",27,"nagic",27,"bU",27,"nser",27,"bI",27,"nnterface",10,"written 1993 by Stefan Stuntz",0
avad1		dc.b	"Available Demos",0
grou4		dc.b	"Groups",0
fram2		dc.b	"Frames",0
back2		dc.b	"Backfill",0
noti2		dc.b	"Notify",0
list2		dc.b	"Listviews",0
cycl3		dc.b	"Cycle",0
imag3		dc.b	"Images",0
stri3		dc.b	"Strings",0
quit1		dc.b	"Quit",0

erro1		dc.b	"Failed to create application. MUI Error: %d",10,0
gads1		dc.b	"OK",0
muid1		dc.b	"MUI-Demo",10,"© 1993 by Stefan Stuntz",0


**
** A little array definition:
**

LVT_Brian	dc.l	str1,str2,str3,str4,str5,str6,str7,str8,str9,str10
		dc.l	str11,str12,str13,str14,str15,str16,str17,str18,str19,str20
		dc.l	str21,str22,str23,str24,str25,str26,str27,str28,str29,str30
		dc.l	str31,str32,str33,str34,str35,str36,str37,str38,str39,str40
		dc.l	str41,str42,str43,str44,str45,str46,str47,NULL
str1		dc.b	"Cheer up, Brian. You know what they say.",0
str2		dc.b	"Some things in life are bad,",0
str3		dc.b	"They can really make you mad.",0
str4		dc.b	"Other things just make you swear and curse.",0
str5		dc.b	"When you're chewing on life's grissle,",0
str6		dc.b	"Don't grumble, give a whistle.",0
str7		dc.b	"And this'll help things turn out for the best,",0
str8		dc.b	"And...",0
str9		dc.b	0
str10		dc.b	"Always look on the bright side of life",0
str11		dc.b	"Always look on the light side of life",0
str12		dc.b	0
str13		dc.b	"If life seems jolly rotten,",0
str14		dc.b	"There's something you've forgotten,",0
str15		dc.b	"And that's to laugh, and smile, and dance, and sing.",0
str16		dc.b	"When you're feeling in the dumps,",0
str17		dc.b	"Don't be silly chumps,",0
str18		dc.b	"Just purse your lips and whistle, that's the thing.",0
str19		dc.b	"And...",0
str20		dc.b	0
str21		dc.b	"Always look on the bright side of life, come on!",0
str22		dc.b	"Always look on the right side of life",0
str23		dc.b	0
str24		dc.b	"For life is quite absurd,",0
str25		dc.b	"And death's the final word.",0
str26		dc.b	"You must always face the curtain with a bow.",0
str27		dc.b	"Forget about your sin,",0
str28		dc.b	"Give the audience a grin.",0
str29		dc.b	"Enjoy it, it's your last chance anyhow,",0
str30		dc.b	"So...",0
str31		dc.b	0
str32		dc.b	"Always look on the bright side of death",0
str33		dc.b	"Just before you draw your terminal breath.",0
str34		dc.b	0
str35		dc.b	"Life's a piece of shit,",0
str36		dc.b	"When you look at it.",0
str37		dc.b	"Life's a laugh, and death's a joke, it's true.",0
str38		dc.b	"You'll see it's all a show,",0
str39		dc.b	"Keep 'em laughing as you go,",0
str40		dc.b	"Just remember that the last laugh is on you.",0
str41		dc.b	"And...",0
str42		dc.b	0
str43		dc.b	"Always look on the bright side of life !",0
str44		dc.b	0
str45		dc.b	"..."
str46		dc.b	0
str47		dc.b	"[Thanx to sprooney@unix1.tcd.ie and to M. Python]",0
		even


**
** Convetional GadTools NewMenu structures. Since I was
** too lazy to construct my own object oriented menu
** system for now, this is the only part of MUI that needs
** "gadtools.library". Well, GadTools menus aren't that bad.
** Nevertheless, object oriented menus will come soon.
**

ID_ABOUT	EQU 1
ID_NEWVOL	EQU 2
ID_NEWBRI	EQU 3

MyMenus		dc.b	NM_TITLE,0	;--
		dc.l	projecttitle
		dc.l	0
		dc.w	0
		dc.l	0
		dc.l	0
		dc.b	NM_ITEM,0	;--
		dc.l	abouttext
		dc.l	aboutkey
		dc.w	0
		dc.l	0
		dc.l	ID_ABOUT
		dc.b	NM_ITEM,0	;--
		dc.l	NM_BARLABEL
		dc.l	0
		dc.w	0
		dc.l	0
		dc.l	0
		dc.b	NM_ITEM,0	;--
		dc.l	quittext
		dc.l	quitkey
		dc.w	0
		dc.l	0
		dc.l	MUIV_Application_ReturnID_Quit

		dc.l	NM_END		;--

projecttitle	dc.b	"Project",0
		even
abouttext	dc.b	"About...",0
		even
aboutkey	dc.b	"?",0
quittext	dc.b	"Quit",0
		even
quitkey		dc.b	"Q",0


**
** Here are all the little info texts
** that appear at the top of each demo window.
**

IN_Master	dc.b	9,"Welcome to the MUI demonstration program. This little toy will show you how easy it is to create graphical user interfaces with MUI and how powerful the results are."
		dc.b	10,9,"MUI is based on BOOPSI, Amiga's basic object oriented programming system. For details about programming, see the 'ReadMe' file and the documented source code of this demo. Only one thing so far: it's really easy!"
		dc.b	10,9,"Now go on, click around and watch this demo. Or use your keyboard (TAB, Return, Cursor-Keys) if you like that better. Hint: play around with the MUI preferences program and customize every pixel to fit your personal taste.",0
		even
IN_Notify	dc.b	9,"MUI objects communicate with each other with the aid of a broadcasting system. This system is frequently used in every MUI application. Binding an up and a down arrow to a prop gadget e.g. makes up a scrollbar, "
		dc.b	"binding a scrollbar to a list makes up a listview. You can also bind windows to buttons, thus the window will be opened when the button is pressed."
		dc.b	10,9,"Remember: The main loop of this demo program simply consists of a Wait(). Once set up, MUI handles all user actions concerning the GUI automatically.",0
		even
IN_Frames	dc.b	9,"Every MUI object can have a surrounding frame. Several types are available, all adjustable with the preferences program.",0
		even
IN_Images	dc.b	9,"MUI offers a vector image class, that allows images to be zoomed to any dimension. Every MUI image is transformed to match the current screens colors before displaying."
		dc.b	10,9,"There are several standard images for often used GUI components (e.g. Arrows). These standard images can be defined via the preferences program.",0
		even
IN_Groups	dc.b	9,"Groups are very important for MUI. Their combinations determine how the GUI will look. A group may contain any number of child objects, which are positioned either horizontal or vertical."
		dc.b	10,9,"When a group is layouted, the available space is distributed between all of its children, depending on their minimum and maximum dimensions and on their weight."
		dc.b	10,9,"Of course, the children of a group may be other groups. There are no restrictions.",0
		even
IN_Backfill	dc.b	9,"Every object can have his own background, if it wants to. MUI offers several standard backgrounds (e.g. one of the DrawInfo pens or one of the rasters below)."
		dc.b	10,"The prefs program allows defining a large number of backgrounds... try it!",0
		even
IN_Listviews	dc.b	9,"MUI's list class is very flexible. A list can be made up of any number of columns containing formatted text or even images. Several subclasses of list class (e.g. a directory class and a volume class) are available. "
		dc.b	"All MUI lists hav the capability of multi selection, just by setting a single flag."
		dc.b	10,9,"The small info texts at the top of each demo window are made with floattext class. This one just needs a character string as input and formats the text according to its width.",0
		even
IN_Cycle	dc.b	9,"Cycle gadgets, radios buttons and simple lists can be used to let the user pick exactly one selection from a list of choices. In this example, all three possibilities are shown. Of course they are connected via broadcasting, "
		dc.b	"so every object will immediately be notified and updated when necessary.",0
		even
IN_String	dc.b	9,"Of course, MUI offers a standard string gadget class for text input. The gadget in this example is attached to the list, you can control the list cursor from within the gadget.",0
		even


**
** These are the entries for the cycle gadgets and radio buttons.
**

CYA_Computer	dc.l	st11,st12,st13,st14,st15,st16,st17,st18,st19,NULL
st11		dc.b	"Amiga 500",0
st12		dc.b	"Amiga 600",0
st13		dc.b	"Amiga 1000 :)",0
st14		dc.b	"Amiga 1200",0
st15		dc.b	"Amiga 2000",0
st16		dc.b	"Amiga 3000",0
st17		dc.b	"Amiga 4000",0
st18		dc.b	"Amiga 4000T",0
st19		dc.b	"Atari ST :(",0
		even

CYA_Printer	dc.l	st21,st22,st23,NULL
st21		dc.b	"HP Deskjet",0
st22		dc.b	"NEC P6",0
st23		dc.b	"Okimate 20",0
		even

CYA_Display	dc.l	st31,st32,st33,NULL
st31		dc.b	"A1081",0
st32		dc.b	"NEC 3D",0
st33		dc.b	"A2024",0
st44		dc.b	"Eizo T660i",0
		even


**
** For every object we want to refer later (e.g. for broadcasting purposes)
** we need a pointer.
**

AP_Demo		dc.l	0

WI_Master	dc.l	0
WI_Frames	dc.l	0
WI_Images	dc.l	0
WI_Notify	dc.l	0
WI_Listviews	dc.l	0
WI_Groups	dc.l	0
WI_Backfill	dc.l	0
WI_Cycle	dc.l	0
WI_String	dc.l	0

BT_Notify	dc.l	0
BT_Frames	dc.l	0
BT_Images	dc.l	0
BT_Groups	dc.l	0
BT_Backfill	dc.l	0
BT_Listviews	dc.l	0
BT_Cycle	dc.l	0
BT_String	dc.l	0
BT_Quit		dc.l	0

PR_PropA	dc.l	0
PR_PropH	dc.l	0
PR_PropV	dc.l	0
PR_PropL	dc.l	0
PR_PropR	dc.l	0
PR_PropT	dc.l	0
PR_PropB	dc.l	0

LV_Volumes	dc.l	0
LV_Directory	dc.l	0
LV_Computer	dc.l	0
LV_Brian	dc.l	0

CY_Computer	dc.l	0
CY_Printer	dc.l	0
CY_Display	dc.l	0

MT_Computer	dc.l	0
MT_Printer	dc.l	0
MT_Display	dc.l	0

ST_Brian	dc.l	0

GA_Gauge1	dc.l	0
GA_Gauge2	dc.l	0
GA_Gauge3	dc.l	0

BP_Wheel	dc.l	0

 end
