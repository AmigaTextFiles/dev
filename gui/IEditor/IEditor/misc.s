
		SECTION chipdata,DATA,CHIP

		XDEF    _puntatore
_puntatore      dc.w    $0000,$0000             ; word di controllo
		dc.w    $0200,$0000
		dc.w    $0000,$0000
		dc.w    $0200,$0000
		dc.w    $0000,$0000
		dc.w    $0200,$0200
		dc.w    $0000,$0000
		dc.w    $A8A8,$0A80
		dc.w    $0000,$0000
		dc.w    $0200,$0200
		dc.w    $0000,$0000
		dc.w    $0200,$0000
		dc.w    $0000,$0000
		dc.w    $0200,$0000
		dc.w    $0000,$0000             ; teminatori


		END
