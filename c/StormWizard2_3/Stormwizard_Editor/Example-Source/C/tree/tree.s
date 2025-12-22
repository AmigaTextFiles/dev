
; Storm C Compiler
; h0:w-pr/StormWIZARD/Example-Source/C/tree/tree.c


	XREF	_NewList
	XREF	_strcpy
	XREF	_std__in
	XREF	_std__out
	XREF	_std__err
	XREF	_DOSBase
	XREF	_SysBase
	XREF	_IntuitionBase

	SECTION ":0",CODE


;void FreeMyTreeList(struct MinList *list)
	XDEF	_FreeMyTreeList
_FreeMyTreeList
	movem.l	a2/a3/a6,-(a7)
	move.l	$10(a7),a3
L39
;	while (list->mlh_Head->mln_Succ)
	bra.b	L41
L40
;	
;		struct MyTreeNode *t=(struct MyTreeNode *)list->mlh_Head;
	move.l	a3,a0
	move.l	(a0),a2
;		FreeMyTreeList(&t->list);
	pea	$48(a2)
	jsr	_FreeMyTreeList
	addq.w	#4,a7
;		Remove((struct Node *)t);
	move.l	_SysBase,a6
	move.l	a2,a1
	jsr	-$FC(a6)
;		FreeVec(t);
	move.l	_SysBase,a6
	move.l	a2,a1
	jsr	-$2B2(a6)
L41
	move.l	a3,a1
	move.l	(a1),a0
	tst.l	(a0)
	bne.b	L40
L42
	movem.l	(a7)+,a2/a3/a6
	rts

;void ReadDir(STRPTR dir,struct MinList *list,struct MyTreeNode *pare
	XDEF	_ReadDir
_ReadDir
L68	EQU	-$220
	link	a5,#L68
	movem.l	d2-d5/a2/a3/a6,-(a7)
L43
;	if ((mylock=Lock(dir,SHARED_LOCK)))
	move.l	_DOSBase,a6
	move.l	$8(a5),d1
	moveq	#-2,d2
	jsr	-$54(a6)
	move.l	d0,d5
	beq	L67
L44
;	
;		if (Examine(mylock,&fib))
	lea	-$104(a5),a0
	move.l	_DOSBase,a6
	move.l	d5,d1
	move.l	a0,d2
	jsr	-$66(a6)
	tst.l	d0
	beq	L66
L45
;		
;			while(ExNext(mylock,&fib))
	bra	L65
L46
;			
;				if ((NewNode=(struct MyTreeNode *)AllocVec(sizeof(MyTreeNode)
	move.l	_SysBase,a6
	moveq	#$78,d0
	move.l	#$10001,d1
	jsr	-$2AC(a6)
	move.l	d0,-$10C(a5)
	tst.l	-$10C(a5)
	beq	L65
L47
;				
;					long Ready=FALSE;
	moveq	#0,d4
;					struct MyTreeNode *PredNode=(struct MyTreeNode *)list->mlh
	move.l	$C(a5),a0
	move.l	(a0),a3
;					NewList((struct List *)&NewNode->list);
	move.l	-$10C(a5),a1
	pea	$48(a1)
	jsr	_NewList
	addq.w	#4,a7
;					strcpy(NewNode->Name,fib.fib_FileName);
	lea	-$104(a5),a0
	pea	$8(a0)
	move.l	-$10C(a5),a1
	pea	$54(a1)
	jsr	_strcpy
	addq.w	#$8,a7
;          	
;					WZ_InitNode(&NewNode->WNode.WizardNode,1,
	clr.l	-(a7)
	pea	$60.w
	move.l	#$801803E8,-(a7)
	move.l	_WizardBase,a6
	moveq	#1,d0
	move.l	-$10C(a5),a0
	move.l	a7,a1
	jsr	-$B4(a6)
	add.w	#$C,a7
;					if ((MyScreen=LockPubScreen(0L)))
	clr.l	-(a7)
	move.l	-$10C(a5),a1
	pea	$48(a1)
	move.l	#$80180453,-(a7)
	move.l	-$10C(a5),a1
	pea	$54(a1)
	move.l	#$80180454,-(a7)
	move.l	$10(a5),-(a7)
	move.l	#$80180452,-(a7)
	pea	3.w
	move.l	#$8018044C,-(a7)
	move.l	_WizardBase,a6
	moveq	#0,d0
	move.l	-$10C(a5),a0
	move.l	a7,a1
	jsr	-$BA(a6)
	add.w	#$24,a7
;																		count++;
	addq.l	#1,_count___ReadDir
;            	
;					if (fib.fib_DirEntryType>=0)
	tst.l	-$100(a5)
	bmi	L51
L48
;					
;						WZ_InitNodeEntry(&NewNode->WNode.WizardNode,0,
	clr.l	-(a7)
	move.l	-$10C(a5),a1
	pea	$48(a1)
	move.l	#$80180453,-(a7)
	move.l	_WizardBase,a6
	moveq	#0,d0
	move.l	-$10C(a5),a0
	move.l	a7,a1
	jsr	-$BA(a6)
	add.w	#$C,a7
;						NewNode->Type=0;
	move.l	-$10C(a5),a0
	clr.l	$74(a0)
;						strcpy (NewDir,dir);
	move.l	$8(a5),-(a7)
	pea	-$214(a5)
	jsr	_strcpy
	addq.w	#$8,a7
;						if (AddPart(NewDir,fib.fib_FileName,sizeof(NewDir)))
	lea	-$104(a5),a0
	lea	-$214(a5),a1
	lea	$8(a0),a0
	move.l	_DOSBase,a6
	move.l	a1,d1
	move.l	a0,d2
	move.l	#$100,d3
	jsr	-$372(a6)
	tst.w	d0
	beq	L62
L49
;							ReadDir(NewDir,&NewNode->list,NewNode);
	move.l	-$10C(a5),-(a7)
	move.l	-$10C(a5),a1
	pea	$48(a1)
	pea	-$214(a5)
	jsr	_ReadDir
	add.w	#$C,a7
L50
	bra.b	L62
L51
;					
;						NewNode->Type=1;
	move.l	-$10C(a5),a0
	move.l	#1,$74(a0)
L52
;					while (!Ready && PredNode->WNode.WizardNode.Node.mln_Succ)
	bra.b	L62
L53
;					
;						if (NewNode->Type>=PredNode->Type)
	move.l	-$10C(a5),a0
	move.l	$74(a0),d1
	move.l	a3,a0
	cmp.l	$74(a0),d1
	blt.b	L61
L54
;						
;							if (NewNode->Type==PredNode->Type)
	move.l	-$10C(a5),a0
	move.l	$74(a0),d1
	move.l	a3,a0
	cmp.l	$74(a0),d1
	bne.b	L59
L55
;							
;								if (Stricmp(NewNode->Name,PredNode->Name)<0)
	move.l	-$10C(a5),a2
	move.l	_UtilityBase,a6
	lea	$54(a2),a0
	lea	$54(a3),a1
	jsr	-$A2(a6)
	tst.l	d0
	bpl.b	L57
L56
;								
;									PredNode=(struct MyTreeNode *)PredNode->WNode.Wiza
	move.l	a3,a0
	move.l	4(a0),a3
;									Ready=TRUE;
	moveq	#1,d4
	bra.b	L62
L57
;									PredNode=(struct MyTreeNode *)PredNode->WNode.Wiza
	move.l	a3,a0
	move.l	(a0),a3
L58
	bra.b	L62
L59
;								PredNode=(struct MyTreeNode *)PredNode->WNode.Wizard
	move.l	a3,a0
	move.l	(a0),a3
L60
	bra.b	L62
L61
;						
;							PredNode=(struct MyTreeNode *)PredNode->WNode.WizardNo
	move.l	a3,a0
	move.l	4(a0),a3
;							Ready=TRUE;
	moveq	#1,d4
L62
	tst.l	d4
	bne.b	L64
L63
	move.l	a3,a1
	tst.l	(a1)
	bne.b	L53
L64
;					Insert((struct List *)list,(struct Node *)NewNode,(struct 
	move.l	_SysBase,a6
	move.l	$C(a5),a0
	move.l	-$10C(a5),a1
	move.l	a3,a2
	jsr	-$EA(a6)
L65
	lea	-$104(a5),a0
	move.l	_DOSBase,a6
	move.l	d5,d1
	move.l	a0,d2
	jsr	-$6C(a6)
	tst.l	d0
	bne	L46
L66
;		UnLock(mylock);
	move.l	_DOSBase,a6
	move.l	d5,d1
	jsr	-$5A(a6)
L67
	movem.l	(a7)+,d2-d5/a2/a3/a6
	unlk	a5
	rts

;void main( void)
	XDEF	_main
_main
L106	EQU	-$18
	link	a5,#L106
	movem.l	d2/a2/a3/a6,-(a7)
L74
;	NewList((struct List *)&MyList);
	move.l	#_MyList,-(a7)
	jsr	_NewList
	addq.w	#4,a7
;	NewList((struct List *)&DummyList);
	move.l	#_DummyList,-(a7)
	jsr	_NewList
	addq.w	#4,a7
;	if ((UtilityBase=OpenLibrary("utility.library",0L)))
	move.l	_SysBase,a6
	moveq	#0,d0
	lea	L69(pc),a1
	jsr	-$228(a6)
	move.l	d0,_UtilityBase
	tst.l	_UtilityBase
	beq	L105
L75
;	
;		if ((WizardBase=OpenLibrary("wizard.library",0L)))
	move.l	_SysBase,a6
	moveq	#0,d0
	lea	L70(pc),a1
	jsr	-$228(a6)
	move.l	d0,_WizardBase
	tst.l	_WizardBase
	beq	L104
L76
;		
;			if ((AslBase=OpenLibrary("asl.library",0L)))
	move.l	_SysBase,a6
	moveq	#0,d0
	lea	L71(pc),a1
	jsr	-$228(a6)
	move.l	d0,_AslBase
	tst.l	_AslBase
	beq	L103
L77
;			
;				if ((MySurface=WZ_OpenSurface("dh0:w-pr/stormwizard/example-
	clr.l	-(a7)
	move.l	_WizardBase,a6
	lea	L72(pc),a0
	sub.l	a1,a1
	move.l	a7,a2
	jsr	-$1E(a6)
	addq.w	#4,a7
	move.l	d0,_MySurface
	tst.l	_MySurface
	beq	L102
L78
;				
;					if ((MyScreen=LockPubScreen(0L)))
	move.l	_IntuitionBase,a6
	sub.l	a0,a0
	jsr	-$1FE(a6)
	move.l	d0,_MyScreen
	tst.l	_MyScreen
	beq	L101
L79
;					
;						if ((MyFReq=AllocAslRequestTags(ASL_FileRequest,ASLFR_Sc
	clr.l	-(a7)
	move.l	#L73,-(a7)
	move.l	#$80080001,-(a7)
	move.l	_MyScreen,-(a7)
	move.l	#$80080028,-(a7)
	move.l	_AslBase,a6
	moveq	#0,d0
	move.l	a7,a0
	jsr	-$30(a6)
	add.w	#$14,a7
	move.l	d0,_MyFReq
	tst.l	_MyFReq
	beq	L100
L80
;						
;																	}
	clr.l	-(a7)
	move.l	_MyScreen,d0
	move.l	_MySurface,a0
	move.l	_WizardBase,a6
	moveq	#0,d1
	move.l	a7,a1
	jsr	-$2A(a6)
	addq.w	#4,a7
	move.l	d0,_MyWinHandle
	tst.l	_MyWinHandle
	beq	L99
L81
;							
;								if ((MyNewWindow=WZ_CreateWindowObj(MyWinHandle,1,WW
	clr.l	-(a7)
	pea	$28.w
	move.l	#$8018012D,-(a7)
	move.l	#_MyGadgets,-(a7)
	move.l	#$8018012C,-(a7)
	move.l	_MyWinHandle,a0
	move.l	_WizardBase,a6
	moveq	#1,d0
	move.l	a7,a1
	jsr	-$30(a6)
	add.w	#$14,a7
	move.l	d0,_MyNewWindow
	tst.l	_MyNewWindow
	beq	L98
L82
;								
;									SetGadgetAttrs(MyGadgets[ArgumentID],0L,0L,WARGSA_
	clr.l	-(a7)
	move.l	#_ArgumentPuffer,-(a7)
	move.l	#$80180222,-(a7)
	move.l	#_MyGadgets,a1
	move.l	$20(a1),a0
	move.l	_IntuitionBase,a6
	sub.l	a1,a1
	sub.l	a2,a2
	move.l	a7,a3
	jsr	-$294(a6)
	add.w	#$C,a7
;									if ((MyWindow=WZ_OpenWindow(MyWinHandle,MyNewWindo
	clr.l	-(a7)
	pea	1.w
	move.l	#$80000090,-(a7)
	move.l	_MyWinHandle,a0
	move.l	_MyNewWindow,a1
	move.l	_WizardBase,a6
	move.l	a7,a2
	jsr	-$36(a6)
	add.w	#$C,a7
	move.l	d0,_MyWindow
	tst.l	_MyWindow
	beq	L98
L83
;									
;										unsigned long Flag=FALSE;
	moveq	#0,d2
;										
L84
;										
;											WaitPort(MyWindow->UserPort);
	move.l	_MyWindow,a0
	move.l	_SysBase,a6
	move.l	$56(a0),a0
	jsr	-$180(a6)
;											if ((msg=(struct IntuiMessage *)GetMsg(MyWindo
	move.l	_MyWindow,a0
	move.l	_SysBase,a6
	move.l	$56(a0),a0
	jsr	-$174(a6)
	move.l	d0,-$8(a5)
	tst.l	-$8(a5)
	beq	L96
L85
;											
;												switch (msg->Class)
	move.l	-$8(a5),a0
	move.l	$14(a0),d0
	cmp.l	#$200,d0
	beq.b	L86
	cmp.l	#$800000,d0
	beq.b	L87
	bra	L95
;												
;													
L86
;														
;															Flag=TRUE;
	moveq	#1,d2
;														
	bra	L95
L87
;														
;															switch (GetTagData(GA_ID,0,(struct Tag
	move.l	-$8(a5),a1
	move.l	_UtilityBase,a6
	move.l	#$80030010,d0
	moveq	#0,d1
	move.l	$1C(a1),a0
	jsr	-$24(a6)
	cmp.l	#2,d0
	beq.b	L88
	cmp.l	#$9,d0
	beq	L91
	bra	L95
;															
;																
L88
;																	
;																		if (t=(struct MyTreeNode *)WZ_Ge
	move.l	-$8(a5),a1
	move.l	_UtilityBase,a6
	move.l	#$8018026D,d0
	moveq	#0,d1
	move.l	$1C(a1),a0
	jsr	-$24(a6)
	move.l	_WizardBase,a6
	move.l	#_MyList,a0
	jsr	-$96(a6)
	move.l	d0,a0
	cmp.w	#0,a0
	beq	L95
L89
;																		
;																			strcpy(ArgumentPuffer,t->Name);
	pea	$54(a0)
	move.l	#_ArgumentPuffer,-(a7)
	jsr	_strcpy
	addq.w	#$8,a7
;																			SetGadgetAttrs(MyGadgets[Argum
	clr.l	-(a7)
	move.l	#_ArgumentPuffer,-(a7)
	move.l	#$80180222,-(a7)
	move.l	#_MyGadgets,a1
	move.l	$20(a1),a0
	move.l	_MyWindow,a1
	move.l	_IntuitionBase,a6
	sub.l	a2,a2
	move.l	a7,a3
	jsr	-$294(a6)
	add.w	#$C,a7
L90
;																	
	bra	L95
L91
;																	
;																		WZ_LockWindow(MyWinHandle);
	move.l	_MyWinHandle,a0
	move.l	_WizardBase,a6
	jsr	-$48(a6)
;																		if (AslRequestTags(MyFReq,ASLFR_
	clr.l	-(a7)
	pea	1.w
	move.l	#$8008002F,-(a7)
	move.l	_MyFReq,a0
	move.l	_AslBase,a6
	move.l	a7,a1
	jsr	-$3C(a6)
	add.w	#$C,a7
	tst.w	d0
	beq	L93
L92
;																		
;																			SetGadgetAttrs(MyGadgets[Hiera
	clr.l	-(a7)
	move.l	#_DummyList,-(a7)
	move.l	#$8018026C,-(a7)
	move.l	#_MyGadgets,a1
	move.l	$8(a1),a0
	move.l	_MyWindow,a1
	move.l	_IntuitionBase,a6
	sub.l	a2,a2
	move.l	a7,a3
	jsr	-$294(a6)
	add.w	#$C,a7
;																			FreeMyTreeList(&MyList);
	move.l	#_MyList,-(a7)
	jsr	_FreeMyTreeList
	addq.w	#4,a7
;																			ReadDir(MyFReq->fr_Drawer,&MyL
	clr.l	-(a7)
	move.l	#_MyList,-(a7)
	move.l	_MyFReq,a0
	move.l	$8(a0),-(a7)
	jsr	_ReadDir
	add.w	#$C,a7
;																			SetGadgetAttrs(MyGadgets[Hiera
	clr.l	-(a7)
	move.l	#_MyList,-(a7)
	move.l	#$8018026C,-(a7)
	move.l	#_MyGadgets,a1
	move.l	$8(a1),a0
	move.l	_MyWindow,a1
	move.l	_IntuitionBase,a6
	sub.l	a2,a2
	move.l	a7,a3
	jsr	-$294(a6)
	add.w	#$C,a7
L93
;																		WZ_UnlockWindow(MyWinHandle);
	move.l	_MyWinHandle,a0
	move.l	_WizardBase,a6
	jsr	-$4E(a6)
;																	
L94
;														
L95
;												ReplyMsg((struct Message *)msg);
	move.l	_SysBase,a6
	move.l	-$8(a5),a1
	jsr	-$17A(a6)
L96
	tst.l	d2
	beq	L84
L97
;										WZ_CloseWindow(MyWinHandle);
	move.l	_MyWinHandle,a0
	move.l	_WizardBase,a6
	jsr	-$3C(a6)
L98
;								WZ_FreeWindowHandle(MyWinHandle);
	move.l	_MyWinHandle,a0
	move.l	_WizardBase,a6
	jsr	-$42(a6)
L99
;							FreeAslRequest(MyFReq);
	move.l	_MyFReq,a0
	move.l	_AslBase,a6
	jsr	-$36(a6)
L100
;						UnlockPubScreen(0L,MyScreen);
	move.l	_MyScreen,a1
	move.l	_IntuitionBase,a6
	sub.l	a0,a0
	jsr	-$204(a6)
L101
;					WZ_CloseSurface(MySurface);
	move.l	_MySurface,a0
	move.l	_WizardBase,a6
	jsr	-$24(a6)
L102
;				CloseLibrary(AslBase);
	move.l	_AslBase,a1
	move.l	_SysBase,a6
	jsr	-$19E(a6)
L103
;			CloseLibrary(WizardBase);
	move.l	_WizardBase,a1
	move.l	_SysBase,a6
	jsr	-$19E(a6)
L104
;		CloseLibrary(UtilityBase);
	move.l	_UtilityBase,a1
	move.l	_SysBase,a6
	jsr	-$19E(a6)
L105
	movem.l	(a7)+,d2/a2/a3/a6
	unlk	a5
	moveq	#0,d0
	rts

L73
	dc.b	'Choose Path ...',0
L71
	dc.b	'asl.library',0
L72
	dc.b	'dh0:w-pr/stormwizard/example-source/c/tree/tree.wizard',0
L69
	dc.b	'utility.library',0
L70
	dc.b	'wizard.library',0

	SECTION ":1",DATA

	XDEF	_ArgumentPuffer
_ArgumentPuffer
	dc.b	0
	ds.b	255
_count___ReadDir
	dc.l	0

	SECTION ":2",BSS

	XDEF	_AslBase
_AslBase
	ds.l	1
	XDEF	_WizardBase
_WizardBase
	ds.l	1
	XDEF	_UtilityBase
_UtilityBase
	ds.l	1
	XDEF	_MySurface
_MySurface
	ds.l	1
	XDEF	_MyGadgets
_MyGadgets
	ds.b	40
	XDEF	_MyScreen
_MyScreen
	ds.l	1
	XDEF	_MyFReq
_MyFReq
	ds.l	1
	XDEF	_MyWindow
_MyWindow
	ds.l	1
	XDEF	_MyNewWindow
_MyNewWindow
	ds.l	1
	XDEF	_MyWinHandle
_MyWinHandle
	ds.l	1
	XDEF	_MyList
_MyList
	ds.b	12
	XDEF	_DummyList
_DummyList
	ds.b	12

	END
