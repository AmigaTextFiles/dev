PySqrt	MACRO	; \1=a^2 \2=a \3 skr \4 skr
	moveq	#1,\2		;thank goes to  
	ror.l	#2,\2		;Graham for this 
        moveq   #32,\3		;fast and short sqrter 
.l2n 
        move.l  \2,\4 
        rol.l   \3,\4 
        add.w   \2,\2 
        cmp.l   \4,\1 
        bcs.b   .no 
        addq.w  #1,\2 
        sub.l   \4,\1 
.no 
        subq.w  #2,\3 
        bgt.b   .l2n 
        andi.l	#$0000ffff,\2
	ENDM 

a:	move.l	#1000,d3
	PySqrt	d3,d4,d5,d6
	rts
	