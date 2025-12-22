PROC p_LockListView(gad,win) /*"p_LockListView(gad,win)"*/
/*===============================================================================
 = Para         : Address of gadget,Address of window.
 = Return       : NONE.
 = Description  : Just lock the LISTVIEW Gadet.
 ==============================================================================*/
    Gt_SetGadgetAttrsA(gad,win,NIL,[GTLV_LABELS,-1,TAG_DONE,0])
ENDPROC
PROC p_UnLockListView(gad,win,list) /*"p_UnLockListView(gad,win,list)"*/
/*===============================================================================
 = Para         : Address of gadget (gadget),address of window (winodw),address of list (lh)
 = Return       : NONE.
 = Description  : Unlock the LISTVIEW if the list is not empty.
 ==============================================================================*/
    IF p_EmptyList(list)<>-1
        Gt_SetGadgetAttrsA(gad,win,NIL,[GA_DISABLED,FALSE,GTLV_LABELS,list,TAG_DONE,0])
    ELSE
        Gt_SetGadgetAttrsA(gad,win,NIL,[GA_DISABLED,TRUE,GTLV_LABELS,-1,TAG_DONE,0])
    ENDIF
ENDPROC

