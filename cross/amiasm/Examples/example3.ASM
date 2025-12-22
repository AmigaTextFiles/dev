		; sectie file globale symbolen
   
teller          .def 85h

		.section test
		nop
		ld teller,a
		nop
		nop
                RET

		.section test2
		nop
		jrz skip
		nop
		ld a,teller
		nop
skip 	        RET
                
		.end
