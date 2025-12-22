#
#  Chunky 2 Planar routine (C) 2009 Fredrik Wikstrom
#
c2p_8:
	add		r4,r5,r5
	add		r11,r10,r5
	add		r12,r10,r4
	add		r13,r11,r4
	add		r14,r12,r4
	add		r15,r13,r4
	add		r16,r14,r4
	add		r17,r15,r4
	
	mr		r5,r6
c2p_8_001:
	subi	r7,r7,1
c2p_8_002:
	lwz		r26,4(r3)
	lwz		r27,8(r3)
	lwz		r28,12(r3)
	lwzu	r29,16(r3)
	
	subi	r5,r5,1
	
	rlwinm	r18,r26,23,16,16
	rlwinm	r19,r26,22,16,16
	rlwinm	r20,r26,21,16,16
	rlwinm	r21,r26,20,16,16
	rlwinm	r22,r26,19,16,16
	rlwinm	r23,r26,18,16,16
	rlwinm	r24,r26,17,16,16
	rlwinm	r25,r26,16,16,16
	
	rlwimi	r18,r26,30,17,17
	rlwimi	r19,r26,29,17,17
	rlwimi	r20,r26,28,17,17
	rlwimi	r21,r26,27,17,17
	rlwimi	r22,r26,26,17,17
	rlwimi	r23,r26,25,17,17
	rlwimi	r24,r26,24,17,17
	rlwimi	r25,r26,23,17,17
	
	rlwimi	r18,r26,5,18,18
	rlwimi	r19,r26,4,18,18
	rlwimi	r20,r26,3,18,18
	rlwimi	r21,r26,2,18,18
	rlwimi	r22,r26,1,18,18
	rlwimi	r23,r26,0,18,18
	rlwimi	r24,r26,31,18,18
	rlwimi	r25,r26,30,18,18
	
	rlwimi	r18,r26,12,19,19
	rlwimi	r19,r26,11,19,19
	rlwimi	r20,r26,10,19,19
	rlwimi	r21,r26,9,19,19
	rlwimi	r22,r26,8,19,19
	rlwimi	r23,r26,7,19,19
	rlwimi	r24,r26,6,19,19
	rlwimi	r25,r26,5,19,19
	
	rlwimi	r18,r27,19,20,20
	rlwimi	r19,r27,18,20,20
	rlwimi	r20,r27,17,20,20
	rlwimi	r21,r27,16,20,20
	rlwimi	r22,r27,15,20,20
	rlwimi	r23,r27,14,20,20
	rlwimi	r24,r27,13,20,20
	rlwimi	r25,r27,12,20,20
	
	rlwimi	r18,r27,26,21,21
	rlwimi	r19,r27,25,21,21
	rlwimi	r20,r27,24,21,21
	rlwimi	r21,r27,23,21,21
	rlwimi	r22,r27,22,21,21
	rlwimi	r23,r27,21,21,21
	rlwimi	r24,r27,20,21,21
	rlwimi	r25,r27,19,21,21
	
	rlwimi	r18,r27,1,22,22
	rlwimi	r19,r27,0,22,22
	rlwimi	r20,r27,31,22,22
	rlwimi	r21,r27,30,22,22
	rlwimi	r22,r27,29,22,22
	rlwimi	r23,r27,28,22,22
	rlwimi	r24,r27,27,22,22
	rlwimi	r25,r27,26,22,22
	
	rlwimi	r18,r27,8,23,23
	rlwimi	r19,r27,7,23,23
	rlwimi	r20,r27,6,23,23
	rlwimi	r21,r27,5,23,23
	rlwimi	r22,r27,4,23,23
	rlwimi	r23,r27,3,23,23
	rlwimi	r24,r27,2,23,23
	rlwimi	r25,r27,1,23,23
	
	rlwimi	r18,r28,15,24,24
	rlwimi	r19,r28,14,24,24
	rlwimi	r20,r28,13,24,24
	rlwimi	r21,r28,12,24,24
	rlwimi	r22,r28,11,24,24
	rlwimi	r23,r28,10,24,24
	rlwimi	r24,r28,9,24,24
	rlwimi	r25,r28,8,24,24
	
	rlwimi	r18,r28,22,25,25
	rlwimi	r19,r28,21,25,25
	rlwimi	r20,r28,20,25,25
	rlwimi	r21,r28,19,25,25
	rlwimi	r22,r28,18,25,25
	rlwimi	r23,r28,17,25,25
	rlwimi	r24,r28,16,25,25
	rlwimi	r25,r28,15,25,25
	
	rlwimi	r18,r28,29,26,26
	rlwimi	r19,r28,28,26,26
	rlwimi	r20,r28,27,26,26
	rlwimi	r21,r28,26,26,26
	rlwimi	r22,r28,25,26,26
	rlwimi	r23,r28,24,26,26
	rlwimi	r24,r28,23,26,26
	rlwimi	r25,r28,22,26,26
	
	rlwimi	r18,r28,4,27,27
	rlwimi	r19,r28,3,27,27
	rlwimi	r20,r28,2,27,27
	rlwimi	r21,r28,1,27,27
	rlwimi	r22,r28,0,27,27
	rlwimi	r23,r28,31,27,27
	rlwimi	r24,r28,30,27,27
	rlwimi	r25,r28,29,27,27
	
	rlwimi	r18,r29,11,28,28
	rlwimi	r19,r29,10,28,28
	rlwimi	r20,r29,9,28,28
	rlwimi	r21,r29,8,28,28
	rlwimi	r22,r29,7,28,28
	rlwimi	r23,r29,6,28,28
	rlwimi	r24,r29,5,28,28
	rlwimi	r25,r29,4,28,28
	
	rlwimi	r18,r29,18,29,29
	rlwimi	r19,r29,17,29,29
	rlwimi	r20,r29,16,29,29
	rlwimi	r21,r29,15,29,29
	rlwimi	r22,r29,14,29,29
	rlwimi	r23,r29,13,29,29
	rlwimi	r24,r29,12,29,29
	rlwimi	r25,r29,11,29,29
	
	rlwimi	r18,r29,25,30,30
	rlwimi	r19,r29,24,30,30
	rlwimi	r20,r29,23,30,30
	rlwimi	r21,r29,22,30,30
	rlwimi	r22,r29,21,30,30
	rlwimi	r23,r29,20,30,30
	rlwimi	r24,r29,19,30,30
	rlwimi	r25,r29,18,30,30
	
	rlwimi	r18,r29,0,31,31
	rlwimi	r19,r29,31,31,31
	rlwimi	r20,r29,30,31,31
	rlwimi	r21,r29,29,31,31
	rlwimi	r22,r29,28,31,31
	rlwimi	r23,r29,27,31,31
	rlwimi	r24,r29,26,31,31
	rlwimi	r25,r29,25,31,31
	
	cmpwi	cr0,r5,0
	
	sthu	r18,2(r10)
	sthu	r19,2(r11)
	sthu	r20,2(r12)
	sthu	r21,2(r13)
	sthu	r22,2(r14)
	sthu	r23,2(r15)
	sthu	r24,2(r16)
	sthu	r25,2(r17)
	
	bne+	c2p_8_002
	
	cmpwi	cr0,r7,0
	mr		r5,r6
	bne+	c2p_8_001
	
	lmw		r13,0(r1)
	addi	r1,r1,76
	blr
