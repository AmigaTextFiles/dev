/*
	These routines are general purpose linked list routines... They will
	work on any object with prev at offset 4 and next at offset 0.
	If double_linked is set to TRUE, than prev is present, if not, only
	next is present. (Single linked list)
*/
DEF double_link=TRUE

PROC next(obj)
	DEF ret=0
	MOVEA.L	obj,A0
	MOVE.L	(A0),ret
ENDPROC ret

PROC prev(obj)
	DEF ret=0
	IF double_link=TRUE
		MOVEA.L	obj,A0
		MOVE.L	4(A0),ret
	ENDIF
ENDPROC ret
/*
	This procedure has the same effect as the E Forward() proc..
*/
PROC forward(target,num)
	DEF a=0
	IF num>-1
		WHILE (next(target)>0) AND (a<num)
			target:=next(target) ; a++
		ENDWHILE
		IF a<num
			RETURN 0
		ENDIF	
	ELSE
		RETURN 0
	ENDIF
ENDPROC target
/*
	This procedure links target to next.
*/
PROC link(target,next)
	DEF ret=0

	MOVEA.L	target,A0
	MOVEA.L	next,A1
	/*
		If double-linked, set next's prev field to target.
	*/
	IF double_link=TRUE
		MOVE.L	target,4(A1)
	ENDIF
	MOVE.L	next,(A0)
ENDPROC ret
/*
	This returns the length of a linked-list of OBJECTS
*/
PROC linklistlen(list)
	DEF cnt=1
	IF list>0
		WHILE (list:=next(list))>0
			cnt++
		ENDWHILE
	ELSE
		RETURN 0
	ENDIF
ENDPROC cnt
