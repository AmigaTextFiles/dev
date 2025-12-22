*-----------------------------------------------*
*	@EnableStartDefrag			*
*-----------------------------------------------*

EnableStartDefrag:
	move.l	intui(a4),a6
	move.l	BT_Start_Defragment-t(a5),a0
	SETI	MUIA_Disabled,FALSE
	move.l	BT_Pause_Defragment-t(a5),a0
	SETI	MUIA_Disabled,TRUE
	move.l	BT_Abort_Defragment-t(a5),a0
	SETI	MUIA_Disabled,TRUE
	move.l	DefragWindowChild_A-t(a5),a0
	SETI	MUIA_Group_ActivePage,MUIV_Group_ActivePage_First
	move.l	WI_Defrag(a4),a0
	SET2	#MUIA_Window_ActiveObject,BT_Start_Defragment-t(a5)
	rts

*-----------------------------------------------*
*	@DisableStartDefrag			*
*-----------------------------------------------*

DisableStartDefrag:
	move.l	intui(a4),a6
	move.l	BT_Start_Defragment-t(a5),a0
	SETI	MUIA_Disabled,TRUE
	move.l	BT_Pause_Defragment-t(a5),a0
	SETI	MUIA_Disabled,FALSE
	move.l	BT_Abort_Defragment-t(a5),a0
	SETI	MUIA_Disabled,FALSE
	lea	t_DefStartTime-t(a5),a3
	move.l	TX_Defrag_Time-t(a5),a0
	SET2	#MUIA_Text_Contents,A3
	move.l	WI_Defrag(a4),a0
	SET2	#MUIA_Window_ActiveObject,BT_Pause_Defragment-t(a5)
	rts
