#
#  Chunky 2 Planar routine (C) 2009 Fredrik Wikstrom
#
c2p_2:
	add		r11,r10,r5
	
	mr		r5,r6
c2p_2_001:
	subi	r7,r7,1
c2p_2_002:
	lwz		r26,4(r3)
	lwz		r27,8(r3)
	lwz		r28,12(r3)
	lwzu	r29,16(r3)
	
	subi	r5,r5,1
	
	rlwinm	r18,r26,23,16,16
	rlwinm	r19,r26,22,16,16
	
	rlwimi	r18,r26,30,17,17
	rlwimi	r19,r26,29,17,17
	
	rlwimi	r18,r26,5,18,18
	rlwimi	r19,r26,4,18,18
	
	rlwimi	r18,r26,12,19,19
	rlwimi	r19,r26,11,19,19
	
	rlwimi	r18,r27,19,20,20
	rlwimi	r19,r27,18,20,20
	
	rlwimi	r18,r27,26,21,21
	rlwimi	r19,r27,25,21,21
	
	rlwimi	r18,r27,1,22,22
	rlwimi	r19,r27,0,22,22
	
	rlwimi	r18,r27,8,23,23
	rlwimi	r19,r27,7,23,23
	
	rlwimi	r18,r28,15,24,24
	rlwimi	r19,r28,14,24,24
	
	rlwimi	r18,r28,22,25,25
	rlwimi	r19,r28,21,25,25
	
	rlwimi	r18,r28,29,26,26
	rlwimi	r19,r28,28,26,26
	
	rlwimi	r18,r28,4,27,27
	rlwimi	r19,r28,3,27,27
	
	rlwimi	r18,r29,11,28,28
	rlwimi	r19,r29,10,28,28
	
	rlwimi	r18,r29,18,29,29
	rlwimi	r19,r29,17,29,29
	
	rlwimi	r18,r29,25,30,30
	rlwimi	r19,r29,24,30,30
	
	rlwimi	r18,r29,0,31,31
	rlwimi	r19,r29,31,31,31
	
	cmpwi	cr0,r5,0
	
	sthu	r18,2(r10)
	sthu	r19,2(r11)
	
	bne+	c2p_2_002
	
	cmpwi	cr0,r7,0
	mr		r5,r6
	bne+	c2p_2_001
	
	lmw		r13,0(r1)
	addi	r1,r1,76
	blr
