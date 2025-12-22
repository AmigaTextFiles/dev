OPT MODULE, POINTER
OPT PREPROCESS, INLINE	->for AmigaOS4

MODULE 'exec/lists'
MODULE 'exec'	->for AmigaOS4

#ifdef pe_TargetOS_AmigaOS4
PROC newList(lh:PTR TO lh) IS NewList_exec(lh!!PTR)
#else
PROC newList(lh:PTR TO lh)
	lh.tailpred := lh !!PTR!!PTR TO ln
	lh.tail := NIL
	lh.head := lh.tail
ENDPROC
#endif
