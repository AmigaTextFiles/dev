*********************************************************
*                                                       *
*          KBXCPP  Vector Module  705C8                 *
*                                                       *
*********************************************************

monitor		RTS

*********************************************************
*                 Vector Table                          *
*********************************************************

		ORG $1FF4		;!- vector address table

		#spi_int		; SPI interupt
		#ser_int		; SCI interupt
		#tmr_int		; Timer interupt
		#irq_int		; External interupt
		#swi_int		; Software interupt
		#reset			; reset 

		END

