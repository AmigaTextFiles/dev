		debug
		addsym
		exeobj
		objfile	testje

label:
		moveq		#4,d0
		moveq		#5,d1
		moveq		#8,d2
1$		add.l		d0,d1
		move.l	d1,(data2)
		add.l		(data2),(data1)
		dbra		d2,1$
		rts

data1:	dc.l	1000
data2:	dc.l	$12345678


	end
